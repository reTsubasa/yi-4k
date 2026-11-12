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
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
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
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONObject;

/** Product UI, real camera HTTP bytes, actual managed-emulator Network loss. */
public final class CameraExportDisconnectDeviceTest extends InstrumentationTestCase {
    private Activity activity;
    private Context context;
    private ContentResolver resolver;
    private final JSONObject evidence = new JSONObject();
    private final JSONArray events = new JSONArray();

    public void testPartialBatchNetworkLossPreservesCompletedAndRetryPublishesOriginal() throws Exception {
        assertEquals("Only the managed emulator may have Wi-Fi toggled", "ranchu", Build.HARDWARE);
        Bundle args = ((InstrumentationTestRunner)getInstrumentation()).getArguments();
        String host = args.getString("yi4k_camera_host"); assertNotNull(host);
        JSONArray manifest = new JSONArray(args.getString("yi4k_media_manifest", "[]")); assertEquals(2, manifest.length());
        JSONObject video = null, photo = null;
        for (int i=0; i<manifest.length(); i++) {
            JSONObject item=manifest.getJSONObject(i);
            if (item.getString("name").endsWith(".MP4")) video=item; else photo=item;
        }
        assertNotNull(video); assertNotNull(photo);
        context=getInstrumentation().getTargetContext(); resolver=context.getContentResolver();
        Set<Long> videosBefore=ownedRows(true), photosBefore=ownedRows(false);
        evidence.put("events",events);
        boolean wifiDisabled=false;
        try {
            Network first=awaitWifi(true,20000); evidence.put("initial_network",first.toString());
            activity=getInstrumentation().startActivitySync(new Intent(context,MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            getInstrumentation().waitForIdleSync();
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host));
            waitText("连接成功",20000); click("相册"); openFolder(video);
            assertEquals(folder(video),folder(photo));
            select(photo.getString("name")); select(video.getString("name"));
            waitText("导出选中（2）",5000); click("导出选中（2）");
            long partialKiB=awaitPartialProgress(video.getString("name"),30000);
            evidence.put("video_progress_kib_before_loss",partialKiB);
            event("real_video_bytes_received_after_photo_completed");
            wifiDisabled=true; shell("svc wifi disable"); awaitWifi(false,20000);
            waitText("请先连接相机",15000); awaitExportEnd(20000);
            assertEquals("Interrupted video must leave no pending or visible row",videosBefore,ownedRows(true));
            Set<Long> completed=ownedRows(false); completed.removeAll(photosBefore);
            assertEquals("Completed batch photo must be preserved",1,completed.size());
            Uri savedPhoto=ContentUris.withAppendedId(collection(false),completed.iterator().next());
            verifyOriginal(savedPhoto,photo);
            assertFalse("Old video card removed after loss",hasText(video.getString("name")));
            // A disconnected library returns to browsing, without a stale
            // selection/export toolbar from the lost camera session.
            saveScreen("interrupted.png");
            event("no_partial_video_completed_photo_verified");
            shell("svc wifi enable"); Network restored=awaitWifi(true,25000); wifiDisabled=false;
            assertFalse(first.equals(restored)); evidence.put("restored_network",restored.toString());
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host)); waitText("连接成功",20000); click("相册"); openFolder(video);
            select(video.getString("name")); click("导出选中（1）");
            waitText("已导出 1 个文件到相册",60000); awaitExportEnd(5000);
            Set<Long> retried=ownedRows(true); retried.removeAll(videosBefore);
            assertEquals("Explicit retry publishes exactly one complete video",1,retried.size());
            Uri savedVideo=ContentUris.withAppendedId(collection(true),retried.iterator().next());
            verifyOriginal(savedVideo,video);
            try (MediaMetadataRetriever reader=new MediaMetadataRetriever()) {
                reader.setDataSource(context,savedVideo); Bitmap frame=reader.getFrameAtTime(0);
                assertNotNull("Retried real camera original must decode",frame); frame.recycle();
                assertEquals("yes",reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_AUDIO));
            }
            Set<Long> photosAfter=ownedRows(false); photosAfter.removeAll(photosBefore);
            assertEquals("Retry must retain the already completed photo without duplication",completed,photosAfter);
            saveScreen("retried.png"); event("fresh_network_explicit_retry_hash_decode_passed");
            runUi(() -> MainActivityTestDriver.disconnect(activity)); waitText("已断开",10000);
            evidence.put("video",video); evidence.put("photo",photo); evidence.put("complete",true);
            evidence.put("scope","Real MainActivity batch photo then video, actual HTTP progress before emulator Wi-Fi loss, no incomplete video row, completed photo hash retained, fresh-Network explicit retry and original video hash/decode. No socket injection, physical phone or camera writes.");
        } catch (Throwable error) {
            evidence.put("failure",error.toString());
            if (error instanceof Error) throw (Error)error;
            if (error instanceof Exception) throw (Exception)error;
            throw new AssertionError(error);
        } finally {
            try {
                if (wifiDisabled) { shell("svc wifi enable"); awaitWifi(true,25000); event("finally_restored_wifi"); }
            } finally {
                try { if (activity!=null) { runUi(activity::finish); getInstrumentation().waitForIdleSync(); } }
                finally {
                    try { cleanAdded(true,videosBefore); cleanAdded(false,photosBefore); }
                    finally { try (OutputStream output=new FileOutputStream(new File(directory(),"camera-export-disconnect.json"))) { output.write(evidence.toString(2).getBytes(StandardCharsets.UTF_8)); } }
                }
            }
        }
    }

    private static String folder(JSONObject item) throws Exception { String path=item.getString("path"); return path.substring(0,path.lastIndexOf('/')+1); }
    private void openFolder(JSONObject item) throws Exception { String label=folder(item).substring(MediaEntry.DCIM_ROOT.length()); waitText(label,10000); click(label); waitText(item.getString("name"),10000); click("选择"); }
    private void select(String name) {
        runUi(() -> { View label=findText(activity.getWindow().getDecorView(),name); assertNotNull(label); CheckBox box=(CheckBox)findType((View)label.getParent(),CheckBox.class); assertNotNull(box); box.performClick(); assertTrue(box.isChecked()); });
        getInstrumentation().waitForIdleSync();
    }
    private long awaitPartialProgress(String name,long timeout) throws Exception {
        Pattern pattern=Pattern.compile("导出 2/2 · "+Pattern.quote(name)+" · ([0-9]+) KiB / ([0-9]+) KiB");
        long deadline=SystemClock.uptimeMillis()+timeout;
        do {
            AtomicReference<String> progress=new AtomicReference<>();
            runUi(() -> progress.set(findProgress(activity.getWindow().getDecorView(),pattern)));
            if (progress.get()!=null) {
                Matcher match=pattern.matcher(progress.get()); assertTrue(match.matches());
                long received=Long.parseLong(match.group(1)), total=Long.parseLong(match.group(2));
                if (received>0 && received<total) return received;
            }
            Thread.sleep(5);
        } while (SystemClock.uptimeMillis()<deadline);
        throw new AssertionError("No observed real partial video transfer; cannot claim network interruption");
    }
    private static String findProgress(View root,Pattern pattern) {
        if (root instanceof TextView && root.isShown()) { String value=((TextView)root).getText().toString(); if (pattern.matcher(value).matches()) return value; }
        if (root instanceof ViewGroup) for (int i=0;i<((ViewGroup)root).getChildCount();i++) { String value=findProgress(((ViewGroup)root).getChildAt(i),pattern); if (value!=null) return value; }
        return null;
    }
    private void awaitExportEnd(long timeout) throws Exception {
        long deadline=SystemClock.uptimeMillis()+timeout;
        do {
            AtomicReference<Boolean> ended=new AtomicReference<>(false);
            runUi(() -> { View cancel=findText(activity.getWindow().getDecorView(),"取消导出"); View settings=findText(activity.getWindow().getDecorView(),"设置"); ended.set((cancel==null || !cancel.isShown()) && settings!=null && settings.isEnabled()); });
            if (ended.get()) return;
            Thread.sleep(100);
        } while (SystemClock.uptimeMillis()<deadline);
        throw new AssertionError("Product export did not release busy state after network loss");
    }
    private void verifyOriginal(Uri uri,JSONObject expected) throws Exception {
        try (Cursor row=resolver.query(uri,new String[]{MediaStore.MediaColumns.IS_PENDING,MediaStore.MediaColumns.SIZE},null,null,null)) {
            assertNotNull(row); assertTrue(row.moveToFirst()); assertEquals(0,row.getInt(0)); assertEquals(expected.getLong("bytes"),row.getLong(1));
        }
        MessageDigest hash=MessageDigest.getInstance("SHA-256");
        try (InputStream input=resolver.openInputStream(uri)) { assertNotNull(input); byte[] data=new byte[65536]; int count; while ((count=input.read(data))!=-1) hash.update(data,0,count); }
        StringBuilder digest=new StringBuilder(); for (byte b:hash.digest()) digest.append(String.format(java.util.Locale.ROOT,"%02x",b&255));
        assertEquals("Published original must equal independent camera SHA",expected.getString("sha256"),digest.toString());
    }
    private static Uri collection(boolean video) { return video?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI; }
    private Set<Long> ownedRows(boolean video) {
        Bundle query=new Bundle(); query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING,MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION,MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?");
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,new String[]{context.getPackageName(),video?"Movies/YI4K/":"Pictures/YI4K/"});
        Set<Long> ids=new HashSet<>(); try (Cursor rows=resolver.query(collection(video),new String[]{MediaStore.MediaColumns._ID},query,null)) { assertNotNull(rows); while (rows.moveToNext()) ids.add(rows.getLong(0)); } return ids;
    }
    private void cleanAdded(boolean video,Set<Long> before) { Set<Long> added=ownedRows(video); added.removeAll(before); for (long id:added) resolver.delete(ContentUris.withAppendedId(collection(video),id),null,null); }
    private void shell(String command) throws Exception {
        try (ParcelFileDescriptor fd=getInstrumentation().getUiAutomation().executeShellCommand(command); InputStream input=new ParcelFileDescriptor.AutoCloseInputStream(fd)) { byte[] data=new byte[1024]; int count,total=0; while ((count=input.read(data))!=-1) { total+=count; assertTrue(total<8192); } }
    }
    private Network awaitWifi(boolean present,long timeout) throws Exception {
        ConnectivityManager manager=(ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE); long deadline=SystemClock.uptimeMillis()+timeout;
        do { Network wifi=null; for (Network candidate:manager.getAllNetworks()) { NetworkCapabilities caps=manager.getNetworkCapabilities(candidate); if (caps!=null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) { wifi=candidate; break; } } if ((wifi!=null)==present) return wifi; Thread.sleep(100); } while (SystemClock.uptimeMillis()<deadline);
        throw new AssertionError("Actual emulator Wi-Fi did not become "+present);
    }
    private void click(String text) throws Exception {
        long deadline=SystemClock.uptimeMillis()+15000;
        do { AtomicReference<Boolean> clicked=new AtomicReference<>(false); runUi(() -> { View target=findText(activity.getWindow().getDecorView(),text); if (target instanceof Button && target.isEnabled()) { assertTrue(target.performClick()); clicked.set(true); } }); if (clicked.get()) { getInstrumentation().waitForIdleSync(); return; } Thread.sleep(100); } while (SystemClock.uptimeMillis()<deadline);
        throw new AssertionError("Enabled UI button missing: "+text);
    }
    private boolean hasText(String text) { AtomicReference<Boolean> found=new AtomicReference<>(false); runUi(() -> found.set(findText(activity.getWindow().getDecorView(),text)!=null)); return found.get(); }
    private void waitText(String text,long timeout) throws Exception { long deadline=SystemClock.uptimeMillis()+timeout; do { if (hasText(text)) return; Thread.sleep(100); } while (SystemClock.uptimeMillis()<deadline); saveScreen("timeout.png"); throw new AssertionError("UI did not reach: "+text); }
    private static View findText(View root,String text) { if (root instanceof TextView && text.contentEquals(((TextView)root).getText())) return root; if (root instanceof ViewGroup) for (int i=0;i<((ViewGroup)root).getChildCount();i++) { View found=findText(((ViewGroup)root).getChildAt(i),text); if (found!=null) return found; } return null; }
    private static View findType(View root,Class<?> type) { if (type.isInstance(root)) return root; if (root instanceof ViewGroup) for (int i=0;i<((ViewGroup)root).getChildCount();i++) { View found=findType(((ViewGroup)root).getChildAt(i),type); if (found!=null) return found; } return null; }
    private void runUi(Runnable action) { AtomicReference<Throwable> failure=new AtomicReference<>(); getInstrumentation().runOnMainSync(() -> { try { action.run(); } catch (Throwable error) { failure.set(error); } }); Throwable error=failure.get(); if (error instanceof Error) throw (Error)error; if (error instanceof RuntimeException) throw (RuntimeException)error; if (error!=null) throw new AssertionError(error); }
    private File directory() { File dir=new File(context.getExternalFilesDir(null),"acceptance-screens/camera-export-disconnect"); assertTrue(dir.isDirectory() || dir.mkdirs()); return dir; }
    private void event(String name) throws Exception { events.put(new JSONObject().put("event",name).put("elapsed_realtime_ms",SystemClock.elapsedRealtime())); }
    private void saveScreen(String name) throws Exception { getInstrumentation().waitForIdleSync(); Bitmap bitmap=getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(bitmap); try (OutputStream output=new FileOutputStream(new File(directory(),name))) { assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG,100,output)); } finally { bitmap.recycle(); } }
}
