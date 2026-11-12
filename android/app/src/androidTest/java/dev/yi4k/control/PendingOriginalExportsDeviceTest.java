package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.os.Process;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONObject;

/** Local HTTP + actual MediaStore only. No camera commands or Activity launches.
 *
 * Process-death acceptance requires two separate instrumentations:
 * 1. #testPrepareInterruptedExport, -e yi4k_pending_death_stage prepare
 * 2. HOST force-stop dev.yi4k.control, then start a fresh instrumentation
 * 3. #testVerifyRecoveryAfterProcessDeath, -e yi4k_pending_death_stage verify
 * Never force-stop a process while a real-camera test is running.
 */
public final class PendingOriginalExportsDeviceTest extends InstrumentationTestCase {
    private Context context;
    private ContentResolver resolver;

    @Override protected void setUp() throws Exception {
        super.setUp();
        context=getInstrumentation().getTargetContext(); resolver=context.getContentResolver();
        assertTrue("Manifest must initialize recovery before any Activity", context.getApplicationContext() instanceof Yi4kApplication);
    }

    public void testActualProviderFiltersAndDoesNotSweepCurrentProcessExports() throws Exception {
        Yi4kApplication.awaitOriginalExportRecovery(()->false);
        JSONObject fixture=new JSONObject();
        try {
            seedControls(fixture);
            Uri pendingVideo=create("Movies/YI4K/",true,true,unique("orphan-video")+".mp4");
            fixture.put("pending_video",pendingVideo.toString());
            Uri pendingPhoto=create("Pictures/YI4K/",false,true,unique("orphan-photo")+".jpg");
            fixture.put("pending_photo",pendingPhoto.toString());
            assertEquals(1,row(pendingVideo).getInt("pending"));
            assertEquals(1,row(pendingPhoto).getInt("pending"));
            PendingOriginalExports.cleanup(resolver,context.getPackageName());
            assertNull(row(pendingVideo)); assertNull(row(pendingPhoto));
            verifyControls(fixture);
            // Once startup succeeded, await must never run cleanup again: this
            // row represents an export being written in the current process.
            Uri current=create("Movies/YI4K/",true,true,unique("current-process")+".mp4");
            fixture.put("current_pending",current.toString());
            Yi4kApplication.awaitOriginalExportRecovery(()->false);
            assertEquals(1,row(current).getInt("pending"));
        } finally { deleteFixture(fixture); }
    }

    public void testPrepareInterruptedExport() throws Exception {
        if (!"prepare".equals(arguments().getString("yi4k_pending_death_stage"))) return;
        assertEquals("Staged process death is restricted to the dedicated emulator", "ranchu",Build.HARDWARE);
        Yi4kApplication.awaitOriginalExportRecovery(()->false);
        assertFalse("Verify/clean a prior staged run before preparing another",journal().exists());
        JSONObject fixture=new JSONObject();
        boolean staged=false;
        CountDownLatch received=new CountDownLatch(1), holdUntilProcessDeath=new CountDownLatch(1);
        AtomicReference<Throwable> failure=new AtomicReference<>();
        ServerSocket server=new ServerSocket(0,1,InetAddress.getByName("127.0.0.1"));
        String name=unique("interrupted-original")+".mp4";
        final int expected=8*1024*1024;
        Thread http=new Thread(()->{
            try(Socket socket=server.accept(); InputStream request=socket.getInputStream(); OutputStream body=socket.getOutputStream()) {
                int matched=0; byte[] end="\r\n\r\n".getBytes(StandardCharsets.US_ASCII);
                while(matched<end.length) { int b=request.read(); if(b<0)throw new java.io.IOException("Incomplete HTTP request"); matched=b==end[matched]?matched+1:0; }
                body.write(("HTTP/1.1 200 OK\r\nContent-Length: "+expected+"\r\nConnection: close\r\n\r\n").getBytes(StandardCharsets.US_ASCII));
                body.write(new byte[256*1024]); body.flush();
            } catch(Throwable error) { failure.compareAndSet(null,error); received.countDown(); }
        },"pending-death-local-http");
        http.setDaemon(true); http.start();
        Thread transfer=new Thread(()->{
            try {
                new MediaExporter().export(resolver,null,"127.0.0.1",server.getLocalPort(),
                        new MediaEntry(MediaEntry.DCIM_ROOT,name,expected+" bytes|fixture"),()->false,count->{
                            if(count>0) {
                                received.countDown();
                                try { holdUntilProcessDeath.await(); }
                                catch(InterruptedException error) { Thread.currentThread().interrupt(); }
                            }
                        });
                failure.compareAndSet(null,new AssertionError("Staged export unexpectedly completed"));
            } catch(Throwable error) { failure.compareAndSet(null,error); received.countDown(); }
        },"pending-death-real-export");
        transfer.setDaemon(true);
        try {
            seedControls(fixture);
            fixture.put("pending_photo",create("Pictures/YI4K/",false,true,unique("interrupted-photo")+".jpg").toString());
            transfer.start();
            assertTrue("Observe real bytes through MediaExporter before killing process",received.await(15,TimeUnit.SECONDS));
            if(failure.get()!=null)throw new AssertionError("Local export failed before staging",failure.get());
            Uri partial=findOwned(name,true); assertNotNull(partial);
            JSONObject partialRow=row(partial); assertNotNull(partialRow);
            assertEquals(1,partialRow.getInt("pending"));
            long bytes=partialRow.getLong("bytes");
            // A writer's SIZE column may not be refreshed until its FD closes.
            try(ParcelFileDescriptor fd=resolver.openFileDescriptor(partial,"r")) {
                assertNotNull(fd); bytes=fd.getStatSize();
            }
            assertTrue("Partial output must contain actual bytes",bytes>0 && bytes<expected);
            fixture.put("pending_video",partial.toString()); fixture.put("partial_bytes",bytes);
            fixture.put("prepare_pid",Process.myPid());
            fixture.put("prepare_process_start_elapsed_ms",Process.getStartElapsedRealtime());
            fixture.put("expected_bytes",expected); fixture.put("prepare_complete",true);
            write(journal(),fixture); write(evidence("prepare.json"),fixture);
            Bundle status=new Bundle();status.putString("pending_process_death_ready",journal().getAbsolutePath());
            getInstrumentation().sendStatus(0,status);
            staged=true;
            // Keep Instrumentation alive: returning would terminate the process
            // before the host could prove force-stop killed this active writer.
            holdUntilProcessDeath.await();
            fail("The host must terminate the blocked publisher process");
            // Intentionally leave the real exporter blocked AFTER writing.
            // The host terminates the process; no cancel(), close(), or finally
            // is used as a substitute for process-death recovery.
        } finally {
            server.close();
            if(!staged) {
                holdUntilProcessDeath.countDown(); transfer.interrupt(); transfer.join(3000);
                Uri partial=findOwned(name,true); if(partial!=null)resolver.delete(partial,null,null);
                deleteFixture(fixture); journal().delete();
            }
        }
    }

    public void testCleanPriorStagedFixture() throws Exception {
        if (!"cleanup".equals(arguments().getString("yi4k_pending_death_stage"))) return;
        assertEquals("Fixture cleanup is restricted to the dedicated emulator", "ranchu",Build.HARDWARE);
        JSONObject result=new JSONObject().put("journal_present",journal().exists());
        if(journal().exists()) {
            JSONObject prior=read(journal());
            // Preserve the previous interrupted run before touching its exact
            // recorded fixtures. This is preflight cleanup, not recovery proof.
            write(evidence("prior-staged-fixture.json"),prior);
            deleteFixture(prior);
            assertTrue("Remove the journal only after fixture cleanup succeeds",journal().delete());
        }
        assertFalse(journal().exists());
        result.put("complete",true);
        write(evidence("preflight-cleanup.json"),result);
    }

    public void testVerifyRecoveryAfterProcessDeath() throws Exception {
        if (!"verify".equals(arguments().getString("yi4k_pending_death_stage"))) return;
        assertEquals("Run only on the dedicated emulator", "ranchu",Build.HARDWARE);
        JSONObject fixture=read(journal());
        try {
            assertTrue(fixture.getBoolean("prepare_complete"));
            assertTrue("Verification must execute in a new process; an ordinary cancellation is insufficient",
                    fixture.getInt("prepare_pid")!=Process.myPid()
                    || fixture.getLong("prepare_process_start_elapsed_ms")!=Process.getStartElapsedRealtime());
            // Do not call cleanup or await here. Application.onCreate itself
            // must remove leftovers, before any exporter or Activity is used.
            long deadline=SystemClock.elapsedRealtime()+15000;
            Uri video=Uri.parse(fixture.getString("pending_video")), photo=Uri.parse(fixture.getString("pending_photo"));
            while((row(video)!=null || row(photo)!=null) && SystemClock.elapsedRealtime()<deadline) Thread.sleep(50);
            assertNull("Startup must recover the interrupted real-export row",row(video));
            assertNull("Startup must recover pending original photos",row(photo));
            verifyControls(fixture);
            fixture.put("verify_pid",Process.myPid()); fixture.put("verify_process_start_elapsed_ms",Process.getStartElapsedRealtime());
            fixture.put("startup_recovery_before_export",true); fixture.put("complete",true);
            write(evidence("verify.json"),fixture);
        } finally { deleteFixture(fixture); journal().delete(); }
    }

    private void seedControls(JSONObject fixture) throws Exception {
        // A deeper nested directory belongs to neither original nor edited cleanup.
        Yi4kApplication.awaitEditedExportRecovery(()->false);
        fixture.put("published_video",create("Movies/YI4K/",true,false,unique("published-video")+".mp4").toString());
        fixture.put("published_photo",create("Pictures/YI4K/",false,false,unique("published-photo")+".jpg").toString());
        fixture.put("nested_pending",create("Movies/YI4K/Edited/Other/",true,true,unique("nested")+".mp4").toString());
        fixture.put("other_pending",create("Movies/YI4K-Other/",true,true,unique("other-directory")+".mp4").toString());
        String name=unique("foreign-owner")+".mp4";
        // Record the name BEFORE insertion, so failure to read its ID cannot
        // leak the foreign-owned row outside the finally cleanup.
        fixture.put("foreign_name",name);
        Bundle foreign=foreignFixture("create",name);
        verifyForeign(foreign);
        fixture.put("foreign_pending",foreign.getString("uri"));
        fixture.put("foreign_owner",foreign.getString("owner"));
        fixture.put("foreign_uid",foreign.getInt("provider_uid"));
        fixture.put("foreign_bytes",foreign.getLong("bytes"));
        fixture.put("foreign_reported_media_size",foreign.getLong("reported_media_size"));
        fixture.put("foreign_sha256",foreign.getString("sha256"));
    }

    private void verifyControls(JSONObject fixture) throws Exception {
        for(String key:new String[]{"published_video","published_photo","nested_pending","other_pending"}) {
            JSONObject actual=row(Uri.parse(fixture.getString(key))); assertNotNull(key+" must survive",actual);
            assertEquals(key.startsWith("published")?0:1,actual.getInt("pending"));
            assertTrue(key+" must retain bytes",actual.getLong("bytes")>0);
        }
        Bundle foreign=foreignFixture("status",fixture.getString("foreign_name"));
        verifyForeign(foreign);
        assertEquals("Foreign-package row must survive",fixture.getString("foreign_pending"),foreign.getString("uri"));
        assertEquals(fixture.getString("foreign_owner"),foreign.getString("owner"));
        assertEquals(fixture.getInt("foreign_uid"),foreign.getInt("provider_uid"));
        assertEquals(fixture.getLong("foreign_bytes"),foreign.getLong("bytes"));
        assertEquals("Foreign fixture bytes must remain identical",fixture.getString("foreign_sha256"),foreign.getString("sha256"));
        fixture.put("foreign_reported_media_size_after",foreign.getLong("reported_media_size"));
    }

    private Uri create(String directory,boolean video,boolean pending,String name) throws Exception {
        ContentValues values=new ContentValues(); values.put(MediaStore.MediaColumns.DISPLAY_NAME,name);
        values.put(MediaStore.MediaColumns.MIME_TYPE,video?"video/mp4":"image/jpeg");
        values.put(MediaStore.MediaColumns.RELATIVE_PATH,directory); values.put(MediaStore.MediaColumns.IS_PENDING,1);
        Uri uri=resolver.insert(collection(video),values); assertNotNull(uri);
        try {
            try(OutputStream output=resolver.openOutputStream(uri)) { assertNotNull(output); output.write(new byte[1024]); }
            if(!pending) { values.clear();values.put(MediaStore.MediaColumns.IS_PENDING,0);assertEquals(1,resolver.update(uri,values,null,null)); }
            return uri;
        } catch(Exception|AssertionError error) { resolver.delete(uri,null,null); throw error; }
    }

    private JSONObject row(Uri uri) throws Exception {
        Bundle args=new Bundle(); args.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        String[] columns={MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE};
        Cursor result=Build.VERSION.SDK_INT>=30?resolver.query(uri,columns,args,null)
                :resolver.query(MediaStore.setIncludePending(uri),columns,null,null,null);
        try(Cursor rows=result) {
            assertNotNull(rows); if(!rows.moveToFirst())return null;
            JSONObject item=new JSONObject().put("pending",rows.getInt(0)).put("reported_media_size",rows.getLong(1));
            try(ParcelFileDescriptor file=resolver.openFileDescriptor(uri,"r")) {
                assertNotNull(file);item.put("bytes",file.getStatSize());
            } catch(java.io.FileNotFoundException removedDuringObservation) {
                // Startup recovery can remove the file after the row query.
                // Keep reporting the observed row until a later query sees it
                // disappear; absent bytes alone do not prove DB cleanup.
                item.put("bytes",-1).put("file_removed_during_observation",true);
            }
            return item;
        }
    }

    private Uri findOwned(String name,boolean video) {
        Bundle args=new Bundle(); args.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        args.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.DISPLAY_NAME+"=?");
        args.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{context.getPackageName(),name});
        Cursor result=Build.VERSION.SDK_INT>=30?resolver.query(collection(video),new String[]{MediaStore.MediaColumns._ID},args,null)
                :resolver.query(MediaStore.setIncludePending(collection(video)),new String[]{MediaStore.MediaColumns._ID},
                        args.getString(ContentResolver.QUERY_ARG_SQL_SELECTION),args.getStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS),null);
        try(Cursor rows=result) {
            assertNotNull(rows); return rows.moveToFirst()?ContentUris.withAppendedId(collection(video),rows.getLong(0)):null;
        }
    }

    private void deleteFixture(JSONObject fixture) throws Exception {
        Exception failure=null;
        for(String key:new String[]{"pending_video","pending_photo","published_video","published_photo","nested_pending","other_pending","current_pending"}) {
            if(!fixture.has(key))continue;
            try {
                Uri owned=Uri.parse(fixture.getString(key));
                // Once recovery removed a row and its owner, deleting that
                // item URI may raise SecurityException instead of returning 0.
                // Skip only when the database query proves it is already gone.
                if(row(owned)!=null)resolver.delete(owned,null,null);
            } catch(Exception error) { if(failure==null)failure=error;else failure.addSuppressed(error); }
        }
        if(fixture.has("foreign_name")) {
            try { foreignFixture("delete",fixture.getString("foreign_name")); }
            catch(Exception error) { if(failure==null)failure=error;else failure.addSuppressed(error); }
        }
        if(failure!=null)throw failure;
    }

    private Bundle foreignFixture(String method,String name) {
        Bundle result=resolver.call(Uri.parse("content://dev.yi4k.control.test.pendingfixture"),method,name,null);
        assertNotNull("Independent test APK provider must answer",result);
        return result;
    }

    private void verifyForeign(Bundle foreign) {
        assertTrue("Test APK's pending row must exist",foreign.getBoolean("exists"));
        assertEquals("Foreign row must have an explicit test-APK owner",getInstrumentation().getContext().getPackageName(),foreign.getString("owner"));
        assertFalse("Test APK must run under a different UID",Process.myUid()==foreign.getInt("provider_uid"));
        assertEquals("Movies/YI4K/",foreign.getString("directory"));
        assertEquals(1,foreign.getInt("pending"));
        assertEquals(1024,foreign.getLong("bytes"));
        assertEquals("Foreign fixture must contain the actual 1024-byte body",
                "5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef",foreign.getString("sha256"));
    }
    private Bundle arguments() { return ((InstrumentationTestRunner)getInstrumentation()).getArguments(); }
    private File journal() { return new File(context.getFilesDir(),"pending-original-process-death.json"); }
    private File evidence(String name) { return new File(context.getExternalFilesDir(null),"acceptance-screens/pending-export-death/"+name); }
    private static Uri collection(boolean video) { return video?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI; }
    private static String unique(String prefix) { return "yi4k-"+prefix+"-"+java.util.UUID.randomUUID(); }
    private static JSONObject read(File file) throws Exception {
        try(InputStream input=new FileInputStream(file)) { java.io.ByteArrayOutputStream output=new java.io.ByteArrayOutputStream();byte[] buffer=new byte[4096];int n;while((n=input.read(buffer))!=-1)output.write(buffer,0,n);return new JSONObject(output.toString("UTF-8")); }
    }
    private static void write(File file,JSONObject data) throws Exception {
        File parent=file.getParentFile();if(!parent.isDirectory()&&!parent.mkdirs())throw new java.io.IOException("Cannot create "+parent);
        try(FileOutputStream output=new FileOutputStream(file)) { output.write(data.toString(2).getBytes(StandardCharsets.UTF_8));output.flush();output.getFD().sync(); }
    }
}
