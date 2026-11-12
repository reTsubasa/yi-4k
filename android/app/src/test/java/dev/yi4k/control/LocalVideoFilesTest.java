package dev.yi4k.control;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.provider.MediaStore;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.rules.TemporaryFolder;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.RuntimeEnvironment;
import org.robolectric.annotation.Config;
import org.robolectric.shadows.ShadowContentResolver;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
public class LocalVideoFilesTest {
    @Rule public TemporaryFolder temporary = new TemporaryFolder();
    @Test public void importCopiesActualBytesAndAlwaysClosesSource() throws Exception {
        byte[] bytes = new byte[140039]; for (int i=0;i<bytes.length;i++) bytes[i]=(byte)(i*7);
        boolean[] closed = {false};
        InputStream source = new ByteArrayInputStream(bytes) { @Override public void close() { closed[0]=true; } };
        File copy = LocalVideoFiles.importVideo(source, temporary.newFolder(), () -> false);
        assertTrue(closed[0]); assertArrayEquals(bytes, Files.readAllBytes(copy.toPath()));
    }
    @Test public void importCancellationAndReadFailureRemovePartialCopies() throws Exception {
        File directory = temporary.newFolder(); AtomicInteger checks = new AtomicInteger();
        try {
            LocalVideoFiles.importVideo(new ByteArrayInputStream(new byte[180000]), directory, () -> checks.incrementAndGet() > 2);
            fail("Cancellation accepted");
        } catch (IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
        assertEquals(0, directory.list().length);
        try {
            LocalVideoFiles.importVideo(new InputStream() { int n;
                @Override public int read() throws IOException { if (++n > 123) throw new IOException("source lost"); return 42; }
            }, directory, () -> false); fail("Broken source accepted");
        } catch (IOException expected) { assertEquals("source lost", expected.getMessage()); }
        assertEquals(0, directory.list().length);
    }
    @Test public void publicationCopiesBeforeClearingPendingAndKeepsSource() throws Exception {
        Context context = RuntimeEnvironment.getApplication(); Provider provider = register();
        File video = temporary.newFile(); byte[] bytes = new byte[131089];
        for (int i=0;i<bytes.length;i++) bytes[i]=(byte)(i*19); Files.write(video.toPath(),bytes);
        Uri saved = LocalVideoFiles.publish(context.getContentResolver(), video, () -> false);
        assertEquals(provider.uri,saved); assertEquals(1,provider.created.getAsInteger(MediaStore.MediaColumns.IS_PENDING).intValue());
        assertEquals("Movies/YI4K/Edited",provider.created.getAsString(MediaStore.MediaColumns.RELATIVE_PATH));
        assertEquals(0,provider.deleted); assertEquals(1,provider.published);
        assertArrayEquals(bytes, Files.readAllBytes(provider.output.toPath())); assertTrue(video.exists());
    }
    @Test public void cancelledOrRejectedPublicationDeletesPendingRow() throws Exception {
        Context context = RuntimeEnvironment.getApplication(); Provider provider = register();
        File video = temporary.newFile(); Files.write(video.toPath(),new byte[150000]);
        AtomicInteger checks = new AtomicInteger();
        try { LocalVideoFiles.publish(context.getContentResolver(),video,()->checks.incrementAndGet()>3); fail("Cancelled publication"); }
        catch (IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
        assertEquals(1,provider.deleted); assertEquals(0,provider.published);
        provider = register(); provider.failPublish=true;
        try { LocalVideoFiles.publish(context.getContentResolver(),video,()->false); fail("Rejected publication"); }
        catch (IOException expected) { assertTrue(expected.getMessage().contains("发布")); }
        assertEquals(1,provider.deleted); assertEquals(0,provider.published);
    }
    @Test public void editedPublicationWaitsForRecoveryAndDoesNotSweepAgain() throws Exception {
        Context context = RuntimeEnvironment.getApplication(); Provider provider = register();
        File video = temporary.newFile();Files.write(video.toPath(),new byte[]{1,2,3});
        java.util.concurrent.CountDownLatch entered = new java.util.concurrent.CountDownLatch(1);
        java.util.concurrent.CountDownLatch release = new java.util.concurrent.CountDownLatch(1);
        AtomicInteger sweeps = new AtomicInteger();
        PendingOriginalExports recovery = new PendingOriginalExports(() -> {
            sweeps.incrementAndGet();entered.countDown();assertTrue(release.await(5,java.util.concurrent.TimeUnit.SECONDS));return 1;
        });
        java.lang.reflect.Field barrier = Yi4kApplication.class.getDeclaredField("editedExports");barrier.setAccessible(true);barrier.set(null,recovery);
        java.util.concurrent.ExecutorService worker = java.util.concurrent.Executors.newSingleThreadExecutor();
        try {
            recovery.start();assertTrue(entered.await(5,java.util.concurrent.TimeUnit.SECONDS));
            java.util.concurrent.Future<Uri> publication = worker.submit(() -> LocalVideoFiles.publish(context.getContentResolver(),video,() -> false));
            assertNull(provider.created);assertFalse(publication.isDone());
            release.countDown();assertEquals(provider.uri,publication.get(5,java.util.concurrent.TimeUnit.SECONDS));
            Yi4kApplication.awaitEditedExportRecovery(() -> false);assertEquals(1,sweeps.get());
        } finally { release.countDown();worker.shutdownNow(); }
    }
    private Provider register() throws Exception {
        Provider provider = new Provider(); provider.output=temporary.newFile();
        ShadowContentResolver.registerProviderInternal("media",provider);
        java.lang.reflect.Field barrier = Yi4kApplication.class.getDeclaredField("editedExports");barrier.setAccessible(true);
        barrier.set(null,new PendingOriginalExports(() -> PendingOriginalExports.cleanupCollection(
                RuntimeEnvironment.getApplication().getContentResolver(),MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                RuntimeEnvironment.getApplication().getPackageName(),"Movies/YI4K/Edited/")));
        org.robolectric.Shadows.shadowOf(RuntimeEnvironment.getApplication().getContentResolver())
                .registerOutputStreamSupplier(provider.uri, () -> {
                    try { return new FileOutputStream(provider.output); }
                    catch (FileNotFoundException error) { throw new IllegalStateException(error); }
                });
        return provider;
    }
    public static class Provider extends ContentProvider {
        final Uri uri=Uri.parse("content://media/external/video/media/41");
        ContentValues created; File output; int deleted,published; boolean failPublish;
        @Override public boolean onCreate(){return true;}
        @Override public Uri insert(Uri uri,ContentValues values){created=new ContentValues(values);return this.uri;}
        @Override public int update(Uri uri,ContentValues values,String where,String[] args){
            assertTrue(output.length()>0);
            if(failPublish)return 0;
            assertEquals(0,values.getAsInteger(MediaStore.MediaColumns.IS_PENDING).intValue()); published++;return 1;
        }
        @Override public int delete(Uri uri,String where,String[] args){deleted++;output.delete();return 1;}
        @Override public ParcelFileDescriptor openFile(Uri uri,String mode) throws FileNotFoundException {
            return ParcelFileDescriptor.open(output,ParcelFileDescriptor.MODE_CREATE|ParcelFileDescriptor.MODE_TRUNCATE|ParcelFileDescriptor.MODE_READ_WRITE);
        }
        @Override public String getType(Uri uri){return "video/mp4";}
        @Override public Cursor query(Uri uri,String[] columns,String where,String[] args,String order){return new android.database.MatrixCursor(columns);}
    }
}
