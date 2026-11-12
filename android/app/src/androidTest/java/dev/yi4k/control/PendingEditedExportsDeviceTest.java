package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

/** Actual local MediaProvider filtering plus explicitly staged emulator-only process-death recovery. */
public final class PendingEditedExportsDeviceTest extends InstrumentationTestCase {
    public void testEditedRecoveryPreservesPublishedOriginalAndCurrentProcessRows() throws Exception {
        Yi4kApplication.awaitOriginalExportRecovery(() -> false);
        Yi4kApplication.awaitEditedExportRecovery(() -> false);
        ContentResolver resolver = getInstrumentation().getTargetContext().getContentResolver();
        String owner = getInstrumentation().getTargetContext().getPackageName();
        List<Uri> files = new ArrayList<>();
        try {
            Uri abandoned = seed(resolver,files,"Movies/YI4K/Edited/",true,"abandoned");
            Uri published = seed(resolver,files,"Movies/YI4K/Edited/",false,"published");
            Uri original = seed(resolver,files,"Movies/YI4K/",true,"original");
            Uri nested = seed(resolver,files,"Movies/YI4K/Edited/Other/",true,"nested");
            assertEquals(1,PendingOriginalExports.cleanupCollection(resolver,MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                    owner,"Movies/YI4K/Edited/"));
            assertEquals(-1,pending(resolver,abandoned)); assertEquals(0,pending(resolver,published));
            assertEquals(1,pending(resolver,original)); assertEquals(1,pending(resolver,nested));
            Uri current = seed(resolver,files,"Movies/YI4K/Edited/",true,"current");
            Yi4kApplication.awaitEditedExportRecovery(() -> false);
            assertEquals("Startup recovery must not repeat after creating a current-process export",1,pending(resolver,current));
        } finally { for (Uri file : files) if (pending(resolver,file)!=-1) resolver.delete(file,null,null); }
    }
    public void testPrepareInterruptedExport() throws Exception {
        if (!"prepare".equals(arguments().getString("yi4k_pending_death_stage"))) return;
        assertEquals("ranchu",android.os.Build.HARDWARE);
        Yi4kApplication.awaitOriginalExportRecovery(() -> false);
        Yi4kApplication.awaitEditedExportRecovery(() -> false);
        assertFalse("Clean an earlier staged fixture before another run",journal().exists());
        ContentResolver resolver = getInstrumentation().getTargetContext().getContentResolver();
        List<Uri> files = new ArrayList<>(); org.json.JSONObject fixture = new org.json.JSONObject();
        java.io.File source = new java.io.File(getInstrumentation().getTargetContext().getCacheDir(),"edited-process-death-source.mp4");
        java.util.concurrent.CountDownLatch ready = new java.util.concurrent.CountDownLatch(1), hold = new java.util.concurrent.CountDownLatch(1);
        java.util.concurrent.atomic.AtomicReference<Throwable> failure = new java.util.concurrent.atomic.AtomicReference<>();
        boolean staged = false;
        try {
            fixture.put("published",seed(resolver,files,"Movies/YI4K/Edited/",false,"published-death").toString());
            fixture.put("nested",seed(resolver,files,"Movies/YI4K/Edited/Other/",true,"nested-death").toString());
            try (java.io.FileOutputStream output = new java.io.FileOutputStream(source)) {
                byte[] block = new byte[65536]; for (int i=0;i<128;i++) output.write(block);
            }
            Thread publisher = new Thread(() -> {
                try {
                    LocalVideoFiles.publish(resolver,source,() -> {
                        try {
                            Uri partial = findPending(resolver);
                            if (partial != null) try (android.os.ParcelFileDescriptor fd = resolver.openFileDescriptor(partial,"r")) {
                                if (fd != null && fd.getStatSize() > 0) {
                                    fixture.put("partial",partial.toString()).put("partial_bytes",fd.getStatSize());
                                    ready.countDown(); hold.await();
                                }
                            }
                            return false;
                        } catch (Exception error) { throw new IllegalStateException(error); }
                    });
                    failure.set(new AssertionError("Publication completed before staged process death")); ready.countDown();
                } catch (Throwable error) { failure.set(error); ready.countDown(); }
            },"edited-publication-process-death"); publisher.setDaemon(true); publisher.start();
            assertTrue("Observe real LocalVideoFiles.publish bytes before process death",ready.await(15,java.util.concurrent.TimeUnit.SECONDS));
            if (failure.get()!=null) throw new AssertionError(failure.get());
            assertTrue(fixture.getLong("partial_bytes")>0 && fixture.getLong("partial_bytes")<source.length());
            fixture.put("expected_bytes",source.length()).put("prepare_pid",android.os.Process.myPid())
                    .put("prepare_process_start_elapsed_ms",android.os.Process.getStartElapsedRealtime()).put("prepare_complete",true);
            write(journal(),fixture); write(evidence("prepare.json"),fixture);
            Bundle status = new Bundle();status.putString("pending_process_death_ready",journal().getAbsolutePath());
            getInstrumentation().sendStatus(0,status); staged = true;
            // Do not let Instrumentation.finish terminate this process first.
            hold.await(); fail("The host must terminate the blocked publisher process");
            // The real publisher remains blocked with an open destination FD.
            // Only the host force-stop terminates it; normal cancellation is not used.
        } finally {
            if (!staged) {
                hold.countDown();
                for (Uri file : files) resolver.delete(file,null,null);
                Uri partial = findPending(resolver);if (partial!=null)resolver.delete(partial,null,null);
                source.delete();journal().delete();
            }
        }
    }
    public void testVerifyRecoveryAfterProcessDeath() throws Exception {
        if (!"verify".equals(arguments().getString("yi4k_pending_death_stage"))) return;
        assertEquals("ranchu",android.os.Build.HARDWARE);
        ContentResolver resolver = getInstrumentation().getTargetContext().getContentResolver();
        org.json.JSONObject fixture = read(journal());
        try {
            assertTrue(fixture.getBoolean("prepare_complete"));
            assertTrue(fixture.getInt("prepare_pid")!=android.os.Process.myPid()
                    || fixture.getLong("prepare_process_start_elapsed_ms")!=android.os.Process.getStartElapsedRealtime());
            Uri partial = Uri.parse(fixture.getString("partial"));
            long deadline = android.os.SystemClock.elapsedRealtime()+15000;
            while (pending(resolver,partial)!=-1 && android.os.SystemClock.elapsedRealtime()<deadline) Thread.sleep(50);
            assertEquals("Application startup must remove interrupted edited publication",-1,pending(resolver,partial));
            assertEquals(0,pending(resolver,Uri.parse(fixture.getString("published"))));
            assertEquals(1,pending(resolver,Uri.parse(fixture.getString("nested"))));
            fixture.put("verify_pid",android.os.Process.myPid()).put("verify_process_start_elapsed_ms",android.os.Process.getStartElapsedRealtime())
                    .put("startup_recovery_before_export",true).put("complete",true);
            write(evidence("verify.json"),fixture);
        } finally { cleanup(resolver,fixture); }
    }
    public void testCleanPriorStagedFixture() throws Exception {
        if (!"cleanup".equals(arguments().getString("yi4k_pending_death_stage"))) return;
        assertEquals("ranchu",android.os.Build.HARDWARE);
        if (journal().exists()) {
            org.json.JSONObject fixture = read(journal());write(evidence("prior-staged-fixture.json"),fixture);
            cleanup(getInstrumentation().getTargetContext().getContentResolver(),fixture);
        }
    }
    private void cleanup(ContentResolver resolver,org.json.JSONObject fixture) throws Exception {
        for (String key : new String[]{"partial","published","nested"}) if (fixture.has(key)) {
            Uri file = Uri.parse(fixture.getString(key));if (pending(resolver,file)!=-1)resolver.delete(file,null,null);
        }
        new java.io.File(getInstrumentation().getTargetContext().getCacheDir(),"edited-process-death-source.mp4").delete();
        journal().delete();
    }
    private Uri findPending(ContentResolver resolver) {
        Bundle query = new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=? AND "+MediaStore.MediaColumns.IS_PENDING+"=1");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{getInstrumentation().getTargetContext().getPackageName(),"Movies/YI4K/Edited/"});
        try (Cursor rows = resolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,new String[]{MediaStore.MediaColumns._ID},query,null)) {
            assertNotNull(rows);return rows.moveToFirst()?android.content.ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,rows.getLong(0)):null;
        }
    }
    private Bundle arguments() { return ((android.test.InstrumentationTestRunner)getInstrumentation()).getArguments(); }
    private java.io.File journal() { return new java.io.File(getInstrumentation().getTargetContext().getFilesDir(),"pending-edited-process-death.json"); }
    private java.io.File evidence(String name) { return new java.io.File(getInstrumentation().getTargetContext().getExternalFilesDir(null),"acceptance-screens/pending-edited-death/"+name); }
    private static org.json.JSONObject read(java.io.File file) throws Exception {
        try (java.io.InputStream input = new java.io.FileInputStream(file)) {
            java.io.ByteArrayOutputStream output = new java.io.ByteArrayOutputStream();byte[] block = new byte[4096];int n;
            while ((n=input.read(block))!=-1)output.write(block,0,n);return new org.json.JSONObject(output.toString("UTF-8"));
        }
    }
    private static void write(java.io.File file,org.json.JSONObject data) throws Exception {
        java.io.File parent = file.getParentFile();if (!parent.isDirectory()&&!parent.mkdirs())throw new java.io.IOException("Cannot create evidence directory");
        try (java.io.FileOutputStream output = new java.io.FileOutputStream(file)) {
            output.write(data.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));output.flush();output.getFD().sync();
        }
    }
    private Uri seed(ContentResolver resolver,List<Uri> files,String path,boolean pending,String label) throws Exception {
        ContentValues values = new ContentValues();
        values.put(MediaStore.MediaColumns.DISPLAY_NAME,"YI4K_EDIT_RECOVERY_"+label+"_"+System.nanoTime()+".mp4");
        values.put(MediaStore.MediaColumns.MIME_TYPE,"video/mp4");
        values.put(MediaStore.MediaColumns.RELATIVE_PATH,path);values.put(MediaStore.MediaColumns.IS_PENDING,1);
        Uri file = resolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,values); assertNotNull(file); files.add(file);
        try (OutputStream output = resolver.openOutputStream(file)) { assertNotNull(output);output.write(new byte[]{1,2,3,4}); }
        if (!pending) { values.clear();values.put(MediaStore.MediaColumns.IS_PENDING,0);assertEquals(1,resolver.update(file,values,null,null)); }
        return file;
    }
    private int pending(ContentResolver resolver,Uri file) {
        Bundle query = new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        try (Cursor rows = resolver.query(file,new String[]{MediaStore.MediaColumns.IS_PENDING},query,null)) {
            return rows != null && rows.moveToFirst() ? rows.getInt(0) : -1;
        }
    }
}
