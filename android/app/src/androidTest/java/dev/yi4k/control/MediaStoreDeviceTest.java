package dev.yi4k.control;

import android.content.ContentResolver;
import android.database.Cursor;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

/** Actual Android MediaProvider checks; all test-created rows are removed. */
public final class MediaStoreDeviceTest extends InstrumentationTestCase {
    private ContentResolver resolver;
    private File source;

    @Override protected void setUp() throws Exception {
        super.setUp();
        resolver=getInstrumentation().getTargetContext().getContentResolver();
        source=File.createTempFile("publish-fixture-",".mp4",getInstrumentation().getTargetContext().getCacheDir());
        try(InputStream input=getInstrumentation().getContext().getAssets().open("editor-av-fixture.mp4");
                FileOutputStream output=new FileOutputStream(source)) {
            byte[] bytes=new byte[8192];int n;while((n=input.read(bytes))!=-1)output.write(bytes,0,n);
        }
    }

    @Override protected void tearDown() throws Exception {
        if(source!=null)source.delete();
        super.tearDown();
    }

    public void testActualPublicationKeepsBytesAndPublishesDecodableVideo() throws Exception {
        Uri saved=null;
        try {
            saved=LocalVideoFiles.publish(resolver,source,()->false);
            try(Cursor row=resolver.query(saved,new String[]{MediaStore.MediaColumns.IS_PENDING,
                    MediaStore.MediaColumns.SIZE,MediaStore.MediaColumns.RELATIVE_PATH,
                    MediaStore.MediaColumns.MIME_TYPE},null,null,null)) {
                assertNotNull(row);assertTrue(row.moveToFirst());
                assertEquals(0,row.getInt(0));assertEquals(source.length(),row.getLong(1));
                assertEquals("Movies/YI4K/Edited/",row.getString(2));assertEquals("video/mp4",row.getString(3));
            }
            try(InputStream expected=new java.io.FileInputStream(source);InputStream actual=resolver.openInputStream(saved)) {
                assertEquals(digest(expected),digest(actual));
            }
            try(MediaMetadataRetriever decoder=new MediaMetadataRetriever()) {
                decoder.setDataSource(getInstrumentation().getTargetContext(),saved);
                assertEquals("yes",decoder.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO));
                android.graphics.Bitmap frame=decoder.getFrameAtTime(0);
                assertNotNull("Published content URI must decode",frame);frame.recycle();
            }
            assertTrue(source.exists());
        } finally { if(saved!=null)assertEquals(1,resolver.delete(saved,null,null)); }
    }

    public void testCancellationAfterRowCreationRemovesPendingResult() throws Exception {
        Set<Long> before=ownedRows();AtomicInteger checks=new AtomicInteger();
        try {
            // First check precedes insert; the next occurs after row/output creation.
            LocalVideoFiles.publish(resolver,source,()->checks.incrementAndGet()>1);
            fail("Cancelled publication succeeded");
        } catch(IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
        assertTrue("Cancellation must occur after the first check",checks.get()>1);
        assertEquals("No pending or visible result may remain",before,ownedRows());
        assertTrue(source.exists());
    }

    private Set<Long> ownedRows() {
        android.os.Bundle query=new android.os.Bundle();
        query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,
                MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,
                new String[]{getInstrumentation().getTargetContext().getPackageName(),"Movies/YI4K/Edited/"});
        Set<Long> ids=new HashSet<>();
        try(Cursor rows=resolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                new String[]{MediaStore.MediaColumns._ID},query,null)) {
            assertNotNull(rows);while(rows.moveToNext())ids.add(rows.getLong(0));
        }
        return ids;
    }

    private static String digest(InputStream input) throws Exception {
        MessageDigest hash=MessageDigest.getInstance("SHA-256");byte[] buffer=new byte[8192];int n;
        while((n=input.read(buffer))!=-1)hash.update(buffer,0,n);
        StringBuilder text=new StringBuilder();for(byte b:hash.digest())text.append(String.format("%02x",b&255));return text.toString();
    }
}
