package dev.yi4k.control;

import android.app.Activity;
import android.app.Instrumentation.ActivityMonitor;
import android.app.Instrumentation.ActivityResult;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.SystemClock;
import android.test.InstrumentationTestCase;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.concurrent.atomic.AtomicReference;
import javax.net.SocketFactory;

/** Actual Window touch, Activity result routing and loopback library traversal. No physical camera. */
public final class NavigationFlowDeviceTest extends InstrumentationTestCase {
    private MainActivity activity;
    public void testConnectionInlinePasswordAutomaticAlbumAndPickerTouch() throws Exception {
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION", "android.permission.ACCESS_FINE_LOCATION", "android.permission.NEARBY_WIFI_DEVICES"}) {
            try (android.os.ParcelFileDescriptor result = getInstrumentation().getUiAutomation().executeShellCommand(
                    "pm grant " + getInstrumentation().getTargetContext().getPackageName() + " " + permission)) {
                try (java.io.InputStream input = new android.os.ParcelFileDescriptor.AutoCloseInputStream(result)) { while (input.read() != -1) {} }
            }
        }
        try (SimulatedCamera server = new SimulatedCamera()) {
            activity = (MainActivity) getInstrumentation().startActivitySync(new Intent(getInstrumentation().getTargetContext(), MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            getInstrumentation().waitForIdleSync();
            ui(() -> { assertNotNull(find("搜索附近相机")); assertNull(find("‹")); });
            screenshot("connection");
            ui(() -> {
                try {
                    Method choose = MainActivity.class.getDeclaredMethod("chooseCameraWifi", CameraWifiConnector.CameraWifi.class);
                    choose.setAccessible(true); choose.invoke(activity, new CameraWifiConnector.CameraWifi("YDXJ_TEST", "00:11:22:33:44:55", -40, CameraWifiConnector.Security.WPA2));
                    assertNotNull(find("记住此相机的密码")); assertNull(find("‹"));
                } catch (Exception e) { throw new AssertionError(e); }
            });
            getInstrumentation().waitForIdleSync(); screenshot("password-inline");
            // Use a real loopback camera session to exercise both directory requests.
            ((CameraClient) field("camera")).connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            ui(() -> invoke("drawMedia"));
            long deadline = SystemClock.uptimeMillis() + 8000;
            AtomicReference<View> loaded = new AtomicReference<>();
            do { ui(() -> loaded.set(find("2 个素材"))); if (loaded.get() != null) break; SystemClock.sleep(50); } while (SystemClock.uptimeMillis() < deadline);
            ui(() -> { assertNotNull(find("2 个素材")); assertNotNull(find(server.imageName)); assertNull(find("100MEDIA/")); });
            assertEquals(2, java.util.Collections.frequency(server.requests, 1282)); screenshot("album-auto");
            ui(() -> invoke("drawEdit")); getInstrumentation().waitForIdleSync(); screenshot("edit-select");
            IntentFilter pickerFilter = new IntentFilter(Intent.ACTION_OPEN_DOCUMENT);
            pickerFilter.addCategory(Intent.CATEGORY_OPENABLE); pickerFilter.addDataType("video/*");
            ActivityMonitor picker = getInstrumentation().addMonitor(pickerFilter, new ActivityResult(Activity.RESULT_CANCELED, null), true);
            try {
                final int[] location = new int[2];
                ui(() -> { View select = find("选择视频"); assertNotNull(select); select.getLocationOnScreen(location); location[0] += select.getWidth() / 2; location[1] += select.getHeight() / 2; });
                long now = SystemClock.uptimeMillis();
                getInstrumentation().sendPointerSync(MotionEvent.obtain(now, now, MotionEvent.ACTION_DOWN, location[0], location[1], 0));
                getInstrumentation().sendPointerSync(MotionEvent.obtain(now, now + 50, MotionEvent.ACTION_UP, location[0], location[1], 0));
                getInstrumentation().waitForIdleSync(); assertEquals("Video selection must respond to a real touch", 1, picker.getHits());
            } finally { getInstrumentation().removeMonitor(picker); }
            ui(() -> invoke("drawControl")); getInstrumentation().waitForIdleSync();
            ui(() -> { assertNull(find("相机")); assertNull(find("YI 4K")); }); screenshot("capture-no-title");
        } finally { if (activity != null) ui(activity::finish); }
    }
    public void testReturningToLoadedAlbumAfterPhotoIncludesNewCapture() throws Exception {
        verifyAlbumReloadAfterCapture(16777220,"SIMULATED_NEW_PHOTO.JPG","photo");
    }
    public void testReturningToLoadedAlbumAfterRecordingIncludesNewVideo() throws Exception {
        verifyAlbumReloadAfterCapture(514,"SIMULATED_NEW_VIDEO.MP4","video");
    }
    private void verifyAlbumReloadAfterCapture(int request,String name,String label) throws Exception {
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION","android.permission.ACCESS_FINE_LOCATION","android.permission.NEARBY_WIFI_DEVICES"}) {
            try (android.os.ParcelFileDescriptor result = getInstrumentation().getUiAutomation().executeShellCommand(
                    "pm grant "+getInstrumentation().getTargetContext().getPackageName()+" "+permission);
                 java.io.InputStream input = new android.os.ParcelFileDescriptor.AutoCloseInputStream(result)) {
                while (input.read()!=-1) { }
            }
        }
        try (SimulatedCamera server = new SimulatedCamera()) {
            activity = (MainActivity)getInstrumentation().startActivitySync(new Intent(getInstrumentation().getTargetContext(),MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_CLEAR_TASK));
            CameraClient camera = (CameraClient)field("camera");
            camera.connect(SocketFactory.getDefault(),"127.0.0.1",server.apiPort());
            ui(() -> invoke("drawMedia"));awaitText("2 个素材");screenshot("before-"+label);
            if (request==16777220) camera.call(2,CameraClient.args("type","system_mode").put("param","capture"));
            else camera.call(513);
            ui(() -> {
                invoke("drawControl");
                try {
                    Method capture = MainActivity.class.getDeclaredMethod("capture",int.class);
                    capture.setAccessible(true);capture.invoke(activity,request);
                } catch (Exception error) { throw new AssertionError(error); }
            });
            drainCommands();drainCommands();
            ui(() -> { View nav = find("相册");assertNotNull(nav);assertTrue(nav.performClick()); });
            awaitText(name);awaitText("3 个素材");screenshot("after-"+label);
            int requests = java.util.Collections.frequency(server.requests,1282);
            ui(() -> invoke("drawMedia"));drainCommands();
            assertEquals("An ordinary redraw must retain the completed snapshot",requests,
                    java.util.Collections.frequency(server.requests,1282));
        } finally { if (activity!=null)ui(activity::finish); }
    }
    private void drainCommands() throws Exception {
        ((java.util.concurrent.ExecutorService)field("commands")).submit(() -> {}).get(8,java.util.concurrent.TimeUnit.SECONDS);
        getInstrumentation().waitForIdleSync();
    }
    private void awaitText(String text) throws Exception {
        AtomicReference<View> found = new AtomicReference<>();long deadline = SystemClock.uptimeMillis()+10000;
        do {
            ui(() -> found.set(find(text)));if (found.get()!=null)return;SystemClock.sleep(50);
        } while (SystemClock.uptimeMillis()<deadline);
        fail("Missing text: "+text);
    }
    private void screenshot(String name) throws Exception {
        ui(() -> {
            View root = activity.getWindow().getDecorView();
            Bitmap bitmap = Bitmap.createBitmap(root.getWidth(), root.getHeight(), Bitmap.Config.ARGB_8888); root.draw(new Canvas(bitmap));
            File directory = new File(activity.getExternalFilesDir(null), "acceptance-screens/navigation-flow");
            assertTrue(directory.isDirectory() || directory.mkdirs());
            try (FileOutputStream out = new FileOutputStream(new File(directory, name + ".png"))) { bitmap.compress(Bitmap.CompressFormat.PNG, 100, out); }
            catch (Exception e) { throw new AssertionError(e); } finally { bitmap.recycle(); }
        });
    }
    private Object field(String name) throws Exception { Field f = MainActivity.class.getDeclaredField(name); f.setAccessible(true); return f.get(activity); }
    private void invoke(String name) { try { Method m = MainActivity.class.getDeclaredMethod(name); m.setAccessible(true); m.invoke(activity); } catch (Exception e) { throw new AssertionError(e); } }
    private void ui(Runnable action) { getInstrumentation().runOnMainSync(action); }
    private View find(String text) { return find(activity.getWindow().getDecorView(), text); }
    private static View find(View root, String text) {
        if (root instanceof TextView && text.contentEquals(((TextView) root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) { View result = find(((ViewGroup) root).getChildAt(i), text); if (result != null) return result; }
        return null;
    }
}
