package dev.yi4k.control;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.Uri;
import android.os.Bundle;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONArray;
import org.json.JSONObject;

/** Opt-in real MainActivity and camera source; no camera configuration or capture writes. */
public final class CameraMainWorkflowDeviceTest extends InstrumentationTestCase {
    private Activity activity;
    private ContentResolver resolver;

    public void testConnectSettingsBrowseBatchOriginalExportAndDisconnect() throws Exception {
        Bundle args=((InstrumentationTestRunner)getInstrumentation()).getArguments();
        String host=args.getString("yi4k_camera_host");assertNotNull("Explicit camera host required",host);
        JSONArray manifest=new JSONArray(args.getString("yi4k_media_manifest","[]"));assertEquals(2,manifest.length());
        long totalBytes=0;
        for(int i=0;i<manifest.length();i++)totalBytes=Math.addExact(totalBytes,manifest.getJSONObject(i).getLong("bytes"));
        long exportTimeoutMs=totalBytes>128L*1024*1024?180000:60000;
        JSONObject evidence=new JSONObject();JSONArray exports=new JSONArray();
        evidence.put("exports",exports);evidence.put("export_timeout_ms",exportTimeoutMs);
        Context context=getInstrumentation().getTargetContext();resolver=context.getContentResolver();
        Set<Long> videosBefore=ownedRows(true),photosBefore=ownedRows(false);
        try {
            awaitWifi(context);
            activity=getInstrumentation().startActivitySync(new Intent(context,MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            getInstrumentation().waitForIdleSync();
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host));
            waitText("连接成功",20000);saveScreen("camera-main-connected.png");
            runUi(()->{
                View root=activity.getWindow().getDecorView();
                View shutter=findDescription(root,"开始录像");assertNotNull(shutter);
                assertFullyVisible(shutter);
                for(String mode:new String[]{"录像","照片","延时","慢动作"})assertFullyVisible(findText(root,mode));
            });
            evidence.put("capture_controls_fully_visible",true);
            click("设置"); runUi(() -> MainActivityTestDriver.openSetting(activity, "sw_version"));
            waitText("固件版本",5000); waitText("相机正在运行的固件版本",5000);
            runUi(() -> MainActivityTestDriver.openSetting(activity, "video_resolution")); waitText("视频分辨率",5000);
            runUi(() -> MainActivityTestDriver.openSetting(activity, "iq_eis_enable")); waitText("电子防抖（EIS）",5000);
            saveScreen("camera-main-settings.png");
            click("相册");
            String path=manifest.getJSONObject(0).getString("path");String folder=path.substring(0,path.lastIndexOf('/')+1);
            assertEquals("This bounded workflow covers one camera media folder",folder,
                    manifest.getJSONObject(1).getString("path").substring(0,manifest.getJSONObject(1).getString("path").lastIndexOf('/')+1));
            String folderName=folder.substring(MediaEntry.DCIM_ROOT.length());
            waitText(folderName,10000);click(folderName);
            click("选择");
            for(int i=0;i<manifest.length();i++){
                String name=manifest.getJSONObject(i).getString("name");waitText(name,10000);
                runUi(()->{
                    View label=findText(activity.getWindow().getDecorView(),name);assertNotNull(label);
                    View box=findType((View)label.getParent(),CheckBox.class);assertNotNull(box);
                    box.requestRectangleOnScreen(new android.graphics.Rect(0,0,box.getWidth(),box.getHeight()),true);
                });getInstrumentation().waitForIdleSync();
                runUi(()->{
                    View label=findText(activity.getWindow().getDecorView(),name);assertNotNull(label);
                    View card=(View)label.getParent();View box=findType(card,CheckBox.class);
                    assertNotNull("Media card must expose selection",box);
                    assertFullyVisible(box);
                    box.performClick();assertTrue("CompoundButton must toggle the actual selection",((CheckBox)box).isChecked());
                });getInstrumentation().waitForIdleSync();
            }
            waitText("导出选中（2）",5000);saveScreen("camera-main-selected.png");
            long exportStarted=SystemClock.elapsedRealtime();
            click("导出选中（2）");waitText("已导出 2 个文件到相册",exportTimeoutMs);
            evidence.put("export_elapsed_ms",SystemClock.elapsedRealtime()-exportStarted);
            saveScreen("camera-main-exported.png");
            for(int i=0;i<manifest.length();i++){
                JSONObject expected=manifest.getJSONObject(i);boolean video=expected.getString("name").endsWith(".MP4");
                Set<Long> added=ownedRows(video);added.removeAll(video?videosBefore:photosBefore);
                assertEquals("MainActivity batch must publish exactly one file per type",1,added.size());
                Uri saved=ContentUris.withAppendedId(collection(video),added.iterator().next());
                JSONObject actual=new JSONObject();actual.put("name",expected.getString("name"));
                actual.put("bytes",expected.getLong("bytes"));actual.put("type",video?"video":"photo");
                try(Cursor row=resolver.query(saved,new String[]{MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE},null,null,null)){
                    assertNotNull(row);assertTrue(row.moveToFirst());assertEquals(0,row.getInt(0));assertEquals(expected.getLong("bytes"),row.getLong(1));
                }
                try(InputStream input=resolver.openInputStream(saved)){
                    String hash=digest(input);actual.put("sha256",hash);
                    assertEquals("UI export bytes must equal camera-side independent digest",expected.getString("sha256"),hash);
                }
                if(video)try(MediaMetadataRetriever reader=new MediaMetadataRetriever()){
                    reader.setDataSource(context,saved);Bitmap frame=reader.getFrameAtTime(0);
                    assertNotNull("UI-exported real original must decode",frame);
                    actual.put("decoded_width",frame.getWidth());actual.put("decoded_height",frame.getHeight());frame.recycle();
                    actual.put("duration_ms",Long.parseLong(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)));
                    actual.put("has_audio",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
                    assertEquals("yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
                }
                exports.put(actual);
                Bundle result=new Bundle();result.putString("main_ui_export",expected.getString("name"));
                result.putString("sha256",expected.getString("sha256"));result.putLong("bytes",expected.getLong("bytes"));
                getInstrumentation().sendStatus(0,result);
            }
            runUi(() -> MainActivityTestDriver.disconnect(activity));waitText("已断开",10000);
            evidence.put("complete",true);
            Bundle result=new Bundle();result.putString("main_workflow","explicit test endpoint -> real MainActivity Wi-Fi route/API -> categorized Chinese settings (nearby-hotspot selection bypassed) -> media checkboxes/batch export -> MediaStore/hash/decode -> disconnect; AVD via host, not phone hotspot");
            getInstrumentation().sendStatus(0,result);
        }finally{
            if(activity!=null){runUi(activity::finish);getInstrumentation().waitForIdleSync();}
            cleanAdded(true,videosBefore);cleanAdded(false,photosBefore);
            evidence.put("android_added_rows_cleaned",true);
            File directory=new File(context.getExternalFilesDir(null),"acceptance-screens");
            assertTrue(directory.isDirectory()||directory.mkdirs());
            try(OutputStream output=new FileOutputStream(new File(directory,"camera-main.json"))){
                output.write(evidence.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        }
    }

    private void awaitWifi(Context context) throws Exception {
        ConnectivityManager manager=(ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        long deadline=SystemClock.uptimeMillis()+20000;
        do{
            for(Network network:manager.getAllNetworks()){
                NetworkCapabilities caps=manager.getNetworkCapabilities(network);
                if(caps!=null&&caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)){
                    Bundle result=new Bundle();result.putString("available_android_wifi",String.valueOf(caps));
                    getInstrumentation().sendStatus(0,result);return;
                }
            }
            Thread.sleep(200);
        }while(SystemClock.uptimeMillis()<deadline);
        fail("Real Android Wi-Fi Network was not available; no socket/network injection permitted");
    }
    private void click(String text){
        runUi(()->{
            View target=findText(activity.getWindow().getDecorView(),text);assertNotNull(target);
            target.requestRectangleOnScreen(new android.graphics.Rect(0,0,target.getWidth(),target.getHeight()),true);
        });getInstrumentation().waitForIdleSync();
        runUi(()->{
            View target=findText(activity.getWindow().getDecorView(),text);
            assertTrue("Missing enabled UI button: "+text,target instanceof Button&&target.isEnabled());
            assertFullyVisible(target);
            assertTrue(target.performClick());
        });getInstrumentation().waitForIdleSync();
    }
    private boolean hasText(String text){
        AtomicBoolean found=new AtomicBoolean();
        runUi(()->found.set(findText(activity.getWindow().getDecorView(),text)!=null));return found.get();
    }
    private void waitText(String text,long timeout) throws Exception{
        long deadline=SystemClock.uptimeMillis()+timeout;
        do{if(hasText(text))return;Thread.sleep(200);}while(SystemClock.uptimeMillis()<deadline);
        saveScreen("camera-main-timeout.png");AtomicReference<String> visible=new AtomicReference<>();
        runUi(()->{StringBuilder values=new StringBuilder();collectTexts(activity.getWindow().getDecorView(),values);visible.set(values.toString());});
        fail("UI did not reach "+text+"; text: "+visible.get());
    }
    private static View findText(View root,String text){
        if(!root.isShown())return null;
        if(root instanceof TextView&&text.contentEquals(((TextView)root).getText()))return root;
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){
            View found=findText(((ViewGroup)root).getChildAt(i),text);if(found!=null)return found;
        }return null;
    }
    private static View findDescription(View root,String description){
        if(root.getContentDescription()!=null && description.contentEquals(root.getContentDescription()))return root;
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){
            View found=findDescription(((ViewGroup)root).getChildAt(i),description);if(found!=null)return found;
        }return null;
    }
    private static void assertFullyVisible(View target){
        assertNotNull(target);android.graphics.Rect visible=new android.graphics.Rect();
        assertTrue("Capture control must be visible without scrolling",target.getGlobalVisibleRect(visible));
        assertEquals("Capture control must not be clipped horizontally",target.getWidth(),visible.width());
        assertEquals("Capture control must not be clipped vertically",target.getHeight(),visible.height());
    }
    private void runUi(Runnable action){
        AtomicReference<Throwable> failed=new AtomicReference<>();
        getInstrumentation().runOnMainSync(()->{try{action.run();}catch(Throwable error){failed.set(error);}});
        Throwable error=failed.get();
        if(error instanceof Error)throw (Error)error;
        if(error instanceof RuntimeException)throw (RuntimeException)error;
        if(error!=null)throw new AssertionError(error);
    }
    private static View findType(View root,Class<?> type){
        if(type.isInstance(root))return root;
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){
            View found=findType(((ViewGroup)root).getChildAt(i),type);if(found!=null)return found;
        }return null;
    }
    private static void collectTexts(View root,StringBuilder out){
        if(root instanceof TextView)out.append(((TextView)root).getText()).append(" | ");
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++)collectTexts(((ViewGroup)root).getChildAt(i),out);
    }
    private void saveScreen(String name) throws Exception{
        getInstrumentation().waitForIdleSync();Bitmap screen=getInstrumentation().getUiAutomation().takeScreenshot();assertNotNull(screen);
        File directory=new File(getInstrumentation().getTargetContext().getExternalFilesDir(null),"acceptance-screens");
        assertTrue(directory.isDirectory()||directory.mkdirs());
        try(OutputStream output=new FileOutputStream(new File(directory,name))){assertTrue(screen.compress(Bitmap.CompressFormat.PNG,100,output));}
        finally{screen.recycle();}
    }
    private static Uri collection(boolean video){return video?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI;}
    private Set<Long> ownedRows(boolean video){
        Bundle query=new Bundle();query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{getInstrumentation().getTargetContext().getPackageName(),video?"Movies/YI4K/":"Pictures/YI4K/"});
        Set<Long> ids=new HashSet<>();try(Cursor rows=resolver.query(collection(video),new String[]{MediaStore.MediaColumns._ID},query,null)){
            assertNotNull(rows);while(rows.moveToNext())ids.add(rows.getLong(0));
        }return ids;
    }
    private void cleanAdded(boolean video,Set<Long> before){
        Set<Long> added=ownedRows(video);added.removeAll(before);
        for(long id:added)resolver.delete(ContentUris.withAppendedId(collection(video),id),null,null);
    }
    private static String digest(InputStream input) throws Exception{
        assertNotNull(input);MessageDigest hash=MessageDigest.getInstance("SHA-256");byte[] bytes=new byte[65536];int n;
        while((n=input.read(bytes))!=-1)hash.update(bytes,0,n);
        StringBuilder text=new StringBuilder();for(byte b:hash.digest())text.append(String.format(java.util.Locale.ROOT,"%02x",b&255));return text.toString();
    }
}
