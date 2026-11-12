package dev.yi4k.control;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import javax.net.SocketFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public final class NavigationFlowTest {
    @Test public void launchAlwaysStartsAtConnectionAndPasswordIsAnInlineStep() throws Exception {
        org.robolectric.RuntimeEnvironment.getApplication().getSharedPreferences("MainActivity", 0)
                .edit().putBoolean("connection_guide_seen", true).commit();
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); View root = activity.getWindow().getDecorView();
            assertEquals("connection", field(activity, "page")); assertNull(find(root, "‹"));
            Method choose = MainActivity.class.getDeclaredMethod("chooseCameraWifi", CameraWifiConnector.CameraWifi.class);
            choose.setAccessible(true); choose.invoke(activity, new CameraWifiConnector.CameraWifi("YDXJ_TEST", "00:11:22:33:44:55", -40, CameraWifiConnector.Security.WPA2));
            assertNotNull(find(root, "YDXJ_TEST")); assertNotNull(find(root, "记住此相机的密码"));
            assertNull(org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog());
            EditText password = (EditText) field(activity, "wifiPassword"); password.setText("short");
            ((View) field(activity, "connectButton")).performClick(); assertNotNull(password.getError());
            assertEquals(2, field(activity, "connectionStep"));
            invoke(activity, "navigateBack"); assertEquals(1, field(activity, "connectionStep"));
            assertFalse(activity.isFinishing()); invoke(activity, "navigateBack"); assertTrue(activity.isFinishing());
        }
    }
    @Test public void libraryEntryLoadsNestedFilesWithoutAnyFolderTap() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            ((CameraClient) field(activity, "camera")).connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            invoke(activity, "drawMedia");
            ((ExecutorService) field(activity, "commands")).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            View root = activity.getWindow().getDecorView();
            assertNotNull(find(root, server.imageName)); assertNotNull(find(root, "2 个素材"));
            assertNull(find(root, "100MEDIA/")); assertNull(find(root, "打开上方文件夹查看拍摄素材"));
            assertEquals(2, java.util.Collections.frequency(server.requests, 1282));
        }
    }
    @Test public void returningToLoadedAlbumAfterPhotoAutomaticallyIncludesNewCapture() throws Exception {
        verifyAlbumReloadAfterCapture(16777220,"SIMULATED_NEW_PHOTO.JPG");
    }
    @Test public void returningToLoadedAlbumAfterRecordingAutomaticallyIncludesNewVideo() throws Exception {
        verifyAlbumReloadAfterCapture(514,"SIMULATED_NEW_VIDEO.MP4");
    }
    private void verifyAlbumReloadAfterCapture(int request,String filename) throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            CameraClient camera = (CameraClient)field(activity,"camera");
            camera.connect(SocketFactory.getDefault(),"127.0.0.1",server.apiPort());
            invoke(activity,"drawMedia"); drain(activity);
            assertNotNull(find(activity.getWindow().getDecorView(),"2 个素材"));
            if (request==16777220) camera.call(2,CameraClient.args("type","system_mode").put("param","capture"));
            else camera.call(513);
            Field page = MainActivity.class.getDeclaredField("page");page.setAccessible(true);page.set(activity,"control");
            Method capture = MainActivity.class.getDeclaredMethod("capture",int.class);capture.setAccessible(true);capture.invoke(activity,request);
            drain(activity);drain(activity);
            invoke(activity,"drawMedia");drain(activity);
            View root = activity.getWindow().getDecorView();
            assertNotNull("A confirmed capture must appear on returning to an already loaded album",find(root,filename));
            assertNotNull(find(root,"3 个素材"));
            int requests = java.util.Collections.frequency(server.requests,1282);
            invoke(activity,"drawMedia");drain(activity);
            assertEquals("Redrawing the loaded album must not reload it repeatedly",requests,
                    java.util.Collections.frequency(server.requests,1282));
        }
    }
    private static void drain(MainActivity activity) throws Exception {
        ((ExecutorService)field(activity,"commands")).submit(() -> {}).get(5,TimeUnit.SECONDS);
        shadowOf(Looper.getMainLooper()).idle();
    }
    @Test public void choosingVideoActuallyLaunchesPickerThenEditorWithReadGrant() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); invoke(activity, "drawEdit");
            while (shadowOf(activity).getNextStartedActivity() != null) {} // Initial OS permission request belongs to connection discovery.
            assertTrue(find(activity.getWindow().getDecorView(), "选择视频").performClick());
            Intent picker = shadowOf(activity).getNextStartedActivity();
            assertEquals(Intent.ACTION_OPEN_DOCUMENT, picker.getAction()); assertEquals("video/*", picker.getType());
            assertTrue(picker.getCategories().contains(Intent.CATEGORY_OPENABLE));
            Uri uri = Uri.parse("content://test.documents/video/1");
            activity.onActivityResult(62, Activity.RESULT_OK, new Intent().setData(uri));
            Intent editor = shadowOf(activity).getNextStartedActivity();
            assertEquals(VideoEditorActivity.class.getName(), editor.getComponent().getClassName());
            assertEquals(uri, editor.getData()); assertTrue((editor.getFlags() & Intent.FLAG_GRANT_READ_URI_PERMISSION) != 0);
            activity.onActivityResult(62, Activity.RESULT_CANCELED, null); assertNull(shadowOf(activity).getNextStartedActivity());
        }
    }
    private static Object field(MainActivity activity, String name) throws Exception { Field f = MainActivity.class.getDeclaredField(name); f.setAccessible(true); return f.get(activity); }
    private static void invoke(MainActivity activity, String name) throws Exception { Method m = MainActivity.class.getDeclaredMethod(name); m.setAccessible(true); m.invoke(activity); }
    private static View find(View view, String text) {
        if (view instanceof TextView && text.contentEquals(((TextView) view).getText())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) { View result = find(((ViewGroup) view).getChildAt(i), text); if (result != null) return result; }
        return null;
    }
}
