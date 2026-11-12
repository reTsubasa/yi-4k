package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaMetadataRetriever;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import java.io.InputStream;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import org.json.JSONArray;
import org.json.JSONObject;

/** Explicit real-source API + HTTP + MediaProvider test, no camera mutations. */
public final class CameraMediaDeviceTest extends InstrumentationTestCase {
    private Context context;
    private ContentResolver resolver;
    private Network network;
    private String host;
    private JSONArray manifest;
    private CameraClient camera;
    private JSONObject beforeSettings,beforeStatus;
    private final ArrayList<Uri> created=new ArrayList<>();

    @Override protected void setUp() throws Exception {
        super.setUp();
        Bundle args=((InstrumentationTestRunner)getInstrumentation()).getArguments();
        host=args.getString("yi4k_camera_host");assertNotNull("Run explicitly with camera host",host);
        manifest=new JSONArray(args.getString("yi4k_media_manifest","[]"));assertEquals(2,manifest.length());
        context=getInstrumentation().getTargetContext();resolver=context.getContentResolver();
        ConnectivityManager connectivity=(ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        network=connectivity.getActiveNetwork();assertNotNull("Actual Android Network required",network);
        camera=new CameraClient(event->{});
        try {
            camera.connect(network.getSocketFactory(),host,7878);
            beforeStatus=camera.call(1,CameraClient.args("type","app_status"));
            assertTrue("Camera must be idle/VF",CameraState.isReady(beforeStatus.getString("param")));
            beforeSettings=selectedSettings();
            assertTrue(beforeSettings.getString("sw_version").startsWith("Z16V13L_1.10.7_"));
        } catch(Exception | AssertionError error) {
            // JUnit 3 skips tearDown when setUp fails, so release the session here.
            camera.disconnect();throw error;
        }
        Bundle status=new Bundle();status.putString("android_network",String.valueOf(connectivity.getNetworkCapabilities(network)));
        getInstrumentation().sendStatus(0,status);
    }
    @Override protected void tearDown() throws Exception {
        try {
            for(Uri uri:created)resolver.delete(uri,null,null);
            if(camera!=null&&camera.isConnected()){
                assertEquals(beforeStatus.getString("param"),camera.call(1,CameraClient.args("type","app_status")).getString("param"));
                assertEquals(beforeSettings.toString(),selectedSettings().toString());
            }
        }finally{if(camera!=null)camera.disconnect();super.tearDown();}
    }

    public void testActualVideoAndPhotoOriginalExport() throws Exception {
        for(int i=0;i<manifest.length();i++){
            JSONObject expected=manifest.getJSONObject(i);MediaEntry entry=readListedEntry(expected);
            boolean video=entry.name.toLowerCase(java.util.Locale.ROOT).endsWith(".mp4");
            Set<Long> before=ownedRows(video);AtomicLong progress=new AtomicLong();
            String result=new MediaExporter().export(resolver,network,host,entry,()->false,progress::set);
            Set<Long> added=ownedRows(video);added.removeAll(before);
            for(long id:added)created.add(ContentUris.withAppendedId(collection(video),id));
            assertEquals("Export must publish exactly one row",1,added.size());
            Uri saved=ContentUris.withAppendedId(collection(video),added.iterator().next());
            assertEquals(entry.bytes,progress.get());
            assertTrue("Reported transfer hash must equal independently read camera hash",result.contains(expected.getString("sha256")));
            try(Cursor row=resolver.query(saved,new String[]{MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE,
                    MediaStore.MediaColumns.RELATIVE_PATH,MediaStore.MediaColumns.MIME_TYPE},null,null,null)){
                assertNotNull(row);assertTrue(row.moveToFirst());assertEquals(0,row.getInt(0));assertEquals(entry.bytes,row.getLong(1));
                assertEquals(video?"Movies/YI4K/":"Pictures/YI4K/",row.getString(2));
                assertEquals(video?"video/mp4":"image/jpeg",row.getString(3));
            }
            try(InputStream input=resolver.openInputStream(saved)){
                assertEquals("Published bytes must equal camera sha256sum",expected.getString("sha256"),digest(input));
            }
            int width,height;
            if(video){
                try(MediaMetadataRetriever reader=new MediaMetadataRetriever()){
                    reader.setDataSource(context,saved);assertEquals("yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO));
                    Bitmap frame=reader.getFrameAtTime(0);assertNotNull("Real camera original must decode on Android",frame);
                    width=frame.getWidth();height=frame.getHeight();frame.recycle();
                    assertEquals("yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
                }
            }else{
                try(InputStream input=resolver.openInputStream(saved)){
                    BitmapFactory.Options options=new BitmapFactory.Options();options.inSampleSize=4;
                    Bitmap image=BitmapFactory.decodeStream(input,null,options);assertNotNull("Real camera photo must decode",image);
                    width=options.outWidth;height=options.outHeight;image.recycle();
                }
            }
            assertTrue(width>0&&height>0);
            Bundle evidence=new Bundle();evidence.putString("original_export",entry.name);
            evidence.putLong("bytes",entry.bytes);evidence.putString("sha256",expected.getString("sha256"));
            evidence.putString("decoded_dimensions",width+"x"+height);getInstrumentation().sendStatus(0,evidence);
            readListedEntry(expected);
        }
    }

    public void testCancellationAfterActualCameraBytesRemovesPendingRow() throws Exception {
        JSONObject expected=null;
        for(int i=0;i<manifest.length();i++)if(manifest.getJSONObject(i).getString("name").toLowerCase(java.util.Locale.ROOT).endsWith(".mp4"))expected=manifest.getJSONObject(i);
        assertNotNull(expected);MediaEntry entry=readListedEntry(expected);
        Set<Long> before=ownedRows(true);AtomicBoolean cancel=new AtomicBoolean();AtomicLong received=new AtomicLong();
        try{
            new MediaExporter().export(resolver,network,host,entry,cancel::get,bytes->{received.set(bytes);if(bytes>0)cancel.set(true);});
            fail("Cancelled export unexpectedly succeeded");
        }catch(java.io.IOException error){assertTrue("Expected cancellation error: "+error,error.getMessage().contains("取消"));}
        finally{
            Set<Long> added=ownedRows(true);added.removeAll(before);
            for(long id:added)created.add(ContentUris.withAppendedId(collection(true),id));
        }
        assertTrue("Cancel must follow receipt of real camera bytes",received.get()>0);
        assertEquals("No pending/visible incomplete original may remain",before,ownedRows(true));
        readListedEntry(expected);
        Bundle evidence=new Bundle();evidence.putString("original_export_cancel","real bytes received; pending and visible rows restored");
        evidence.putLong("received_before_cancel",received.get());getInstrumentation().sendStatus(0,evidence);
    }
    private MediaEntry readListedEntry(JSONObject expected) throws Exception {
        String path=expected.getString("path"),folder=path.substring(0,path.lastIndexOf('/')+1),name=expected.getString("name");
        JSONObject response=camera.call(1282,CameraClient.args("param",folder));JSONArray listing=response.getJSONArray("listing");
        assertTrue("Complete media list required",response.optInt("total",listing.length())<=listing.length());
        for(int i=0;i<listing.length();i++)if(listing.getJSONObject(i).has(name)){
            MediaEntry entry=new MediaEntry(folder,name,listing.getJSONObject(i).getString(name));
            assertTrue(entry.isMedia());assertEquals(path,entry.path);assertEquals(expected.getLong("bytes"),entry.bytes);return entry;
        }
        throw new AssertionError("Existing camera original missing from list: "+path);
    }
    private JSONObject selectedSettings() throws Exception {
        JSONObject all=CameraClient.flattenSettings(camera.call(3)),selected=new JSONObject();
        for(String key:new String[]{"sw_version","hw_version","system_mode","sd_card_status","video_resolution","video_standard","iq_eis_enable","video_quality"})
            if(all.has(key))selected.put(key,all.get(key));
        return selected;
    }
    private static Uri collection(boolean video){return video?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI;}
    private Set<Long> ownedRows(boolean video){
        Bundle query=new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{context.getPackageName(),video?"Movies/YI4K/":"Pictures/YI4K/"});
        Set<Long> ids=new HashSet<>();try(Cursor rows=resolver.query(collection(video),new String[]{MediaStore.MediaColumns._ID},query,null)){
            assertNotNull(rows);while(rows.moveToNext())ids.add(rows.getLong(0));
        }return ids;
    }
    private static String digest(InputStream input) throws Exception{
        assertNotNull(input);MessageDigest hash=MessageDigest.getInstance("SHA-256");byte[] bytes=new byte[65536];int n;
        while((n=input.read(bytes))!=-1)hash.update(bytes,0,n);
        StringBuilder text=new StringBuilder();for(byte b:hash.digest())text.append(String.format(java.util.Locale.ROOT,"%02x",b&255));return text.toString();
    }
}
