package dev.yi4k.control;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.media.MediaExtractor;
import android.media.MediaFormat;
import android.media.MediaMetadataRetriever;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.Uri;
import android.os.Bundle;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.Button;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Explicit opt-in, real camera original -> DocumentsUI -> editor controls -> codecs -> MediaStore.
 * Run this class alone with yi4k_camera_host and the externally verified yi4k_media_manifest.
 * Camera operations are limited to session/status/settings/listing and downloading an existing file.
 */
public final class CameraOriginalEditorDeviceTest extends InstrumentationTestCase {
    private static final String ORIGINAL_PATH="Movies/YI4K/";
    private static final String EDITED_PATH="Movies/YI4K/Edited/";
    private Context context;
    private ContentResolver resolver;

    public void testCameraOriginalPickerTrimRetainsAudioAndSourceHash() throws Exception {
        Bundle arguments=((InstrumentationTestRunner)getInstrumentation()).getArguments();
        String host=arguments.getString("yi4k_camera_host");
        assertNotNull("Explicit opt-in requires yi4k_camera_host",host);
        JSONArray manifest=new JSONArray(arguments.getString("yi4k_media_manifest","[]"));
        JSONObject expected=null;
        for(int i=0;i<manifest.length();i++){
            JSONObject candidate=manifest.getJSONObject(i);
            if(candidate.optString("name").toLowerCase(Locale.ROOT).endsWith(".mp4")){
                assertNull("Manifest must contain only one video",expected);expected=candidate;
            }
        }
        assertNotNull("Manifest must contain an existing camera MP4 and its independent SHA-256",expected);
        assertTrue(expected.getString("sha256").matches("[0-9a-f]{64}"));
        context=getInstrumentation().getTargetContext();resolver=context.getContentResolver();
        Network network=((ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE)).getActiveNetwork();
        assertNotNull("Actual Android Network required",network);
        Set<Long> originalBefore=ownedRows(ORIGINAL_PATH),editedBefore=ownedRows(EDITED_PATH);
        CameraClient camera=new CameraClient(event->{});
        Activity activity=null;
        JSONObject beforeSettings=null;String beforeStatus=null;
        try {
            camera.connect(network.getSocketFactory(),host,7878);
            beforeStatus=camera.call(1,CameraClient.args("type","app_status")).getString("param");
            assertTrue("Read-only workflow requires an idle/VF camera",CameraState.isReady(beforeStatus));
            beforeSettings=selectedSettings(camera);
            assertTrue(beforeSettings.getString("sw_version").startsWith("Z16V13L_1.10.7_"));
            MediaEntry entry=listedEntry(camera,expected);
            AtomicLong received=new AtomicLong();
            String transfer=new MediaExporter().export(resolver,network,host,entry,()->false,received::set);
            assertEquals(entry.bytes,received.get());
            assertTrue("Actual transfer hash must match independent manifest",transfer.contains(expected.getString("sha256")));
            Set<Long> added=ownedRows(ORIGINAL_PATH);added.removeAll(originalBefore);
            assertEquals("Exactly one camera original must be published",1,added.size());
            Uri source=videoUri(added.iterator().next());
            assertPublished(source,entry.bytes);
            String sourceHash=digest(source);
            assertEquals(expected.getString("sha256"),sourceHash);
            // Give this run a unique phone-side display name so DocumentsUI cannot select an old copy.
            String pickerName="YI4K_CAMERA_EDITOR_"+System.currentTimeMillis()+".mp4";
            ContentValues rename=new ContentValues();rename.put(MediaStore.MediaColumns.DISPLAY_NAME,pickerName);
            assertEquals(1,resolver.update(source,rename,null,null));
            long durationMs;
            try(MediaMetadataRetriever reader=new MediaMetadataRetriever()){
                reader.setDataSource(context,source);
                durationMs=Long.parseLong(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
                assertEquals("Real camera fixture must include original audio","yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
            }
            assertTrue("Camera original must be long enough for a non-keyframe two-second cut",durationMs>=2700);
            int startProgress=(int)Math.round(500*10000.0/durationMs);
            int endProgress=(int)Math.round(2500*10000.0/durationMs);
            long startMs=VideoEditPlan.timeAt(startProgress,durationMs);
            long endMs=VideoEditPlan.timeAt(endProgress,durationMs);
            JSONObject sourceCut=assertNonSyncCut(source,startMs);
            activity=getInstrumentation().startActivitySync(new Intent(context,VideoEditorActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            clickEditor(activity,"从手机选择视频");
            chooseInDocumentsUi(pickerName,20000);
            waitEditorText(activity,"调整片段范围，然后点击右上角导出",30000);
            saveScreen("camera-original-imported.png");
            setAccessibleProgress("片段起点",startProgress);
            setAccessibleProgress("片段终点",endProgress);
            waitEditorText(activity,"起点 "+VideoEditorActivity.time(startMs)+"  ·  终点 "+VideoEditorActivity.time(endMs)
                    +"  ·  保留 "+VideoEditorActivity.time(endMs-startMs),5000);
            assertEditorText(activity,"保留原声"); // Deliberately leave mute OFF.
            clickEditor(activity,"原色");clickEditor(activity,"旋转 0°");
            assertEditorText(activity,"黑白");assertEditorText(activity,"旋转 90°");
            saveScreen("camera-original-adjusted.png");
            clickEditor(activity,"导出");
            waitEditorText(activity,"已保存到相册 Movies/YI4K/Edited",120000);
            saveScreen("camera-original-exported.png");
            Set<Long> edited=ownedRows(EDITED_PATH);edited.removeAll(editedBefore);
            assertEquals("Actual editor export must publish exactly one clip",1,edited.size());
            Uri output=videoUri(edited.iterator().next());
            assertPublished(output,-1);
            JSONObject validation=validateClip(output,endMs-startMs);
            assertEquals("Camera original bytes must survive picker/import/edit/export",sourceHash,digest(source));
            assertEquals("Independent camera-source manifest must still match",expected.getString("sha256"),digest(source));
            listedEntry(camera,expected);
            assertEquals(beforeStatus,camera.call(1,CameraClient.args("type","app_status")).getString("param"));
            assertEquals(beforeSettings.toString(),selectedSettings(camera).toString());
            JSONObject evidence=new JSONObject();
            evidence.put("scope","real camera original API/list/HTTP -> real DocumentsUI -> editor UI trim/grayscale/rotation -> real Transformer -> MediaStore/Android decode");
            evidence.put("camera_file",entry.path);evidence.put("camera_bytes",entry.bytes);
            evidence.put("source_sha256_before",sourceHash);evidence.put("source_sha256_after",digest(source));
            evidence.put("output_sha256",digest(output));evidence.put("source_duration_ms",durationMs);
            evidence.put("selected_start_ms",startMs);evidence.put("selected_end_ms",endMs);
            evidence.put("source_non_sync_cut",sourceCut);evidence.put("output",validation);
            evidence.put("camera_state_unchanged",true);evidence.put("camera_mutations",false);
            evidence.put("limitations","Android runtime under test only; not proof of physical phone Wi-Fi, all codecs, or perceptual A/V sync. Camera hash independently supplied by runner; camera file list checked again.");
            try(OutputStream file=new FileOutputStream(new File(evidenceDirectory(),"camera-original-editor.json"))){file.write(evidence.toString(2).getBytes(StandardCharsets.UTF_8));}
            Bundle status=new Bundle();status.putString("camera_original_editor",evidence.toString());getInstrumentation().sendStatus(0,status);
        } finally {
            try {
                if(activity!=null){Activity close=activity;getInstrumentation().runOnMainSync(close::finish);getInstrumentation().waitForIdleSync();}
            } finally {
                try {
                    // Delete only new app-owned rows in the two exact paths; preserve every pre-test row.
                    try {cleanupRows(EDITED_PATH,editedBefore);}
                    finally {cleanupRows(ORIGINAL_PATH,originalBefore);}
                } finally {
                    try {
                        if(camera.isConnected()&&beforeStatus!=null&&beforeSettings!=null){
                            assertEquals(beforeStatus,camera.call(1,CameraClient.args("type","app_status")).getString("param"));
                            assertEquals(beforeSettings.toString(),selectedSettings(camera).toString());
                        }
                    } finally {camera.disconnect();}
                }
            }
        }
    }

    private JSONObject validateClip(Uri output,long selectedMs) throws Exception {
        JSONObject result=new JSONObject();
        try(MediaMetadataRetriever reader=new MediaMetadataRetriever()){
            reader.setDataSource(context,output);
            long duration=Long.parseLong(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
            assertTrue("Non-keyframe clip must retain the selected duration: "+duration,Math.abs(duration-selectedMs)<=180);
            assertEquals("UI left original audio enabled","yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
            Bitmap frame=reader.getFrameAtTime(0,MediaMetadataRetriever.OPTION_CLOSEST);
            assertNotNull("Published real-camera edit must decode a video frame",frame);
            try {
                assertTrue("90-degree UI rotation must produce portrait presentation",frame.getHeight()>frame.getWidth());
                for(int y=1;y<10;y++)for(int x=1;x<10;x++){
                    int pixel=frame.getPixel(frame.getWidth()*x/10,frame.getHeight()*y/10);
                    int r=Color.red(pixel),g=Color.green(pixel),b=Color.blue(pixel);
                    assertTrue("UI grayscale must affect actual decoded pixels",Math.max(r,Math.max(g,b))-Math.min(r,Math.min(g,b))<=10);
                }
                result.put("decoded_width",frame.getWidth());result.put("decoded_height",frame.getHeight());
            } finally {frame.recycle();}
            result.put("duration_ms",duration);
        }
        MediaExtractor extractor=new MediaExtractor();
        try {
            extractor.setDataSource(context,output,null);
            int video=-1,audio=-1;
            for(int i=0;i<extractor.getTrackCount();i++){
                String mime=extractor.getTrackFormat(i).getString(MediaFormat.KEY_MIME);
                if(mime!=null&&mime.startsWith("video/")){assertEquals(-1,video);video=i;assertEquals("video/avc",mime);}
                if(mime!=null&&mime.startsWith("audio/")){assertEquals(-1,audio);audio=i;assertEquals("audio/mp4a-latm",mime);}
            }
            assertTrue("Exactly one actual H264 track required",video>=0);assertTrue("Original sound requires an AAC track",audio>=0);
            JSONObject videoSamples=sampleTimeline(extractor,video,false);
            JSONObject audioSamples=sampleTimeline(extractor,audio,true);
            assertTrue(videoSamples.getInt("count")>=40);assertTrue(audioSamples.getInt("count")>=50);
            long durationUs=selectedMs*1000;
            for(JSONObject track:new JSONObject[]{videoSamples,audioSamples}){
                assertTrue("Clipped timestamps should start near zero",track.getLong("first_pts_us")>=0&&track.getLong("first_pts_us")<=100000);
                assertTrue("Real samples must cover nearly the complete selected interval",Math.abs(track.getLong("max_pts_us")-durationUs)<=200000);
            }
            assertTrue("Retained audio/video start timestamps must align",Math.abs(videoSamples.getLong("first_pts_us")-audioSamples.getLong("first_pts_us"))<=100000);
            assertTrue("Retained audio/video end timestamps must align",Math.abs(videoSamples.getLong("max_pts_us")-audioSamples.getLong("max_pts_us"))<=150000);
            result.put("video_samples",videoSamples);result.put("audio_samples",audioSamples);
        } finally {extractor.release();}
        return result;
    }
    private JSONObject sampleTimeline(MediaExtractor extractor,int track,boolean monotonic) throws Exception {
        extractor.selectTrack(track);extractor.seekTo(0,MediaExtractor.SEEK_TO_PREVIOUS_SYNC);
        int count=0;long first=-1,previous=-1,max=-1,totalBytes=0;
        ByteBuffer bytes=ByteBuffer.allocate(4*1024*1024);
        try {
            while(extractor.getSampleTime()>=0){
                long pts=extractor.getSampleTime();if(first<0)first=pts;
                if(monotonic)assertTrue("AAC timestamps must increase strictly",pts>previous);
                previous=pts;max=Math.max(max,pts);
                bytes.clear();int size=extractor.readSampleData(bytes,0);assertTrue("Every sample must contain readable encoded data",size>0);
                totalBytes+=size;count++;if(!extractor.advance())break;
            }
        } finally {extractor.unselectTrack(track);}
        JSONObject result=new JSONObject();result.put("count",count);result.put("first_pts_us",first);result.put("max_pts_us",max);result.put("encoded_bytes",totalBytes);return result;
    }
    private JSONObject assertNonSyncCut(Uri source,long startMs) throws Exception {
        MediaExtractor extractor=new MediaExtractor();
        try {
            extractor.setDataSource(context,source,null);int track=-1;
            for(int i=0;i<extractor.getTrackCount();i++)if(extractor.getTrackFormat(i).getString(MediaFormat.KEY_MIME).startsWith("video/"))track=i;
            assertTrue(track>=0);extractor.selectTrack(track);
            long closest=Long.MAX_VALUE,previousSync=-1,nextSync=-1,target=startMs*1000;
            while(extractor.getSampleTime()>=0){
                long pts=extractor.getSampleTime();
                if((extractor.getSampleFlags()&MediaExtractor.SAMPLE_FLAG_SYNC)!=0){
                    closest=Math.min(closest,Math.abs(pts-target));
                    if(pts<=target)previousSync=Math.max(previousSync,pts);else if(nextSync<0)nextSync=pts;
                }
                if(!extractor.advance())break;
            }
            assertTrue("Cut must actually be away from a source keyframe, not merely labelled non-keyframe",closest>2000&&previousSync>=0);
            JSONObject result=new JSONObject();result.put("requested_start_us",target);result.put("nearest_sync_distance_us",closest);
            result.put("previous_sync_us",previousSync);result.put("next_sync_us",nextSync);return result;
        } finally {extractor.release();}
    }
    private MediaEntry listedEntry(CameraClient camera,JSONObject expected) throws Exception {
        String path=expected.getString("path"),name=expected.getString("name"),folder=path.substring(0,path.lastIndexOf('/')+1);
        JSONObject response=camera.call(1282,CameraClient.args("param",folder));JSONArray listing=response.getJSONArray("listing");
        assertTrue(response.optInt("total",listing.length())<=listing.length());
        for(int i=0;i<listing.length();i++)if(listing.getJSONObject(i).has(name)){
            MediaEntry entry=new MediaEntry(folder,name,listing.getJSONObject(i).getString(name));
            assertEquals(path,entry.path);assertEquals(expected.getLong("bytes"),entry.bytes);assertTrue(entry.isMedia());return entry;
        }
        throw new AssertionError("Existing camera original disappeared: "+path);
    }
    private static JSONObject selectedSettings(CameraClient camera) throws Exception {
        JSONObject all=CameraClient.flattenSettings(camera.call(3)),selected=new JSONObject();
        for(String key:new String[]{"sw_version","hw_version","system_mode","sd_card_status","video_resolution","video_standard","iq_eis_enable","video_quality"})
            if(all.has(key))selected.put(key,all.get(key));
        return selected;
    }
    private void assertPublished(Uri uri,long expectedBytes){
        try(Cursor row=resolver.query(uri,new String[]{MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE},null,null,null)){
            assertNotNull(row);assertTrue(row.moveToFirst());assertEquals(0,row.getInt(0));assertTrue(row.getLong(1)>0);
            if(expectedBytes>=0)assertEquals(expectedBytes,row.getLong(1));
        }
    }
    private Set<Long> ownedRows(String path){
        Bundle query=new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{context.getPackageName(),path});
        Set<Long> result=new HashSet<>();
        try(Cursor rows=resolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,new String[]{MediaStore.MediaColumns._ID},query,null)){
            assertNotNull(rows);while(rows.moveToNext())result.add(rows.getLong(0));
        }return result;
    }
    private void cleanupRows(String path,Set<Long> before){
        Set<Long> added=ownedRows(path);added.removeAll(before);
        for(long id:added)resolver.delete(videoUri(id),null,null);
        assertEquals("Only this test's MediaStore rows must be removed",before,ownedRows(path));
    }
    private static Uri videoUri(long id){return ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,id);}
    private String digest(Uri uri) throws Exception {
        MessageDigest hash=MessageDigest.getInstance("SHA-256");byte[] buffer=new byte[65536];
        try(InputStream input=resolver.openInputStream(uri)){assertNotNull(input);int n;while((n=input.read(buffer))!=-1)hash.update(buffer,0,n);}
        StringBuilder value=new StringBuilder();for(byte b:hash.digest())value.append(String.format(Locale.ROOT,"%02x",b&255));return value.toString();
    }
    private void clickEditor(Activity activity,String text){
        getInstrumentation().runOnMainSync(()->{View view=findText(activity.getWindow().getDecorView(),text);
            assertTrue("Missing enabled editor control: "+text,view instanceof Button&&view.isEnabled());assertTrue(view.performClick());});
        getInstrumentation().waitForIdleSync();
    }
    private void assertEditorText(Activity activity,String text){
        getInstrumentation().runOnMainSync(()->assertNotNull("Editor text absent: "+text,findText(activity.getWindow().getDecorView(),text)));
    }
    private void waitEditorText(Activity activity,String text,long timeout) throws Exception {
        long deadline=SystemClock.uptimeMillis()+timeout;
        do {
            AtomicBoolean found=new AtomicBoolean();getInstrumentation().runOnMainSync(()->found.set(findText(activity.getWindow().getDecorView(),text)!=null));
            if(found.get())return;Thread.sleep(200);
        }while(SystemClock.uptimeMillis()<deadline);
        saveScreen("camera-original-timeout.png");
        AtomicReference<String> visible=new AtomicReference<>();getInstrumentation().runOnMainSync(()->{StringBuilder value=new StringBuilder();collectTexts(activity.getWindow().getDecorView(),value);visible.set(value.toString());});
        fail("Editor state not reached: "+text+"; actual: "+visible.get());
    }
    private static View findText(View root,String text){
        if(root instanceof TextView&&text.contentEquals(((TextView)root).getText()))return root;
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){View match=findText(((ViewGroup)root).getChildAt(i),text);if(match!=null)return match;}return null;
    }
    private static void collectTexts(View root,StringBuilder value){
        if(root instanceof TextView)value.append(((TextView)root).getText()).append(" | ");
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++)collectTexts(((ViewGroup)root).getChildAt(i),value);
    }
    private void chooseInDocumentsUi(String name,long timeout) throws Exception {
        long deadline=SystemClock.uptimeMillis()+timeout;
        do {
            AccessibilityNodeInfo root=getInstrumentation().getUiAutomation().getRootInActiveWindow();
            if(root!=null&&String.valueOf(root.getPackageName()).endsWith("documentsui")){
                for(AccessibilityNodeInfo node:root.findAccessibilityNodeInfosByText(name)){
                    if(!name.equals(String.valueOf(node.getText())))continue;
                    saveScreen("camera-original-system-picker.png");
                    for(AccessibilityNodeInfo target=node;target!=null;target=target.getParent()){
                        if(target.isClickable()&&target.performAction(AccessibilityNodeInfo.ACTION_CLICK)){getInstrumentation().waitForIdleSync();return;}
                    }
                }
            }
            Thread.sleep(200);
        }while(SystemClock.uptimeMillis()<deadline);
        saveScreen("camera-original-picker-timeout.png");fail("Real DocumentsUI did not expose/select this run's exported camera original: "+name);
    }
    private void setAccessibleProgress(String description,float value){
        AccessibilityNodeInfo slider=findDescription(getInstrumentation().getUiAutomation().getRootInActiveWindow(),description);
        assertNotNull("Missing editor slider: "+description,slider);Bundle args=new Bundle();args.putFloat(AccessibilityNodeInfo.ACTION_ARGUMENT_PROGRESS_VALUE,value);
        assertTrue(slider.performAction(AccessibilityNodeInfo.AccessibilityAction.ACTION_SET_PROGRESS.getId(),args));getInstrumentation().waitForIdleSync();
    }
    private static AccessibilityNodeInfo findDescription(AccessibilityNodeInfo node,String description){
        if(node==null)return null;if(description.equals(String.valueOf(node.getContentDescription())))return node;
        for(int i=0;i<node.getChildCount();i++){AccessibilityNodeInfo match=findDescription(node.getChild(i),description);if(match!=null)return match;}return null;
    }
    private File evidenceDirectory(){File directory=new File(context.getExternalFilesDir(null),"acceptance-screens/camera-original-editor");assertTrue(directory.isDirectory()||directory.mkdirs());return directory;}
    private void saveScreen(String name) throws Exception {
        getInstrumentation().waitForIdleSync();getInstrumentation().getUiAutomation().waitForIdle(500,5000);
        Bitmap screen=getInstrumentation().getUiAutomation().takeScreenshot();assertNotNull(screen);
        try(OutputStream output=new FileOutputStream(new File(evidenceDirectory(),name))){assertTrue(screen.compress(Bitmap.CompressFormat.PNG,100,output));}
        finally{screen.recycle();}
    }
}
