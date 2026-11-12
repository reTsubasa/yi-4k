package dev.yi4k.control;

import android.app.AlertDialog;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import javax.net.SocketFactory;
import org.json.JSONObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import org.robolectric.shadows.ShadowAlertDialog;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

/** Host Android runtime checks, without a phone or a camera network. */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public class CaptureUiTest {
    @Test public void repeatedNavigationReparentsStatusAndHostWithoutCrashing() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            for (int repeat = 0; repeat < 3; repeat++) {
                invoke(activity, "drawSettings");
                invoke(activity, "drawMedia");
                invoke(activity, "drawEdit");
                invoke(activity, "drawControl");
            }
            assertNotNull(find(activity.getWindow().getDecorView(), "FOV --"));
            assertNotNull(find(activity.getWindow().getDecorView(), "EV --"));
            assertNotNull(find(activity.getWindow().getDecorView(), "FPS --"));
            assertNull(find(activity.getWindow().getDecorView(), "相机"));
            assertNull(find(activity.getWindow().getDecorView(), "APEX"));
            assertNull(find(activity.getWindow().getDecorView(), "YI 4K  ·  CAMERA CONTROL"));
            assertNotNull(find(activity.getWindow().getDecorView(), "FOV --"));
            assertNull(find(activity.getWindow().getDecorView(), "视角\n--"));
            java.util.concurrent.atomic.AtomicBoolean busy=(java.util.concurrent.atomic.AtomicBoolean)field(activity,"busy").get(activity);
            java.util.concurrent.atomic.AtomicBoolean exporting=(java.util.concurrent.atomic.AtomicBoolean)field(activity,"exporting").get(activity);
            for(java.util.concurrent.atomic.AtomicBoolean occupied:new java.util.concurrent.atomic.AtomicBoolean[]{busy,exporting}){
                occupied.set(true);invoke(activity,"updateOperation");
                for(String title:new String[]{"录像","照片","延时","慢动作"})
                    assertFalse("Fixed capture action must be disabled while occupied: "+title,find(activity.getWindow().getDecorView(),title).isEnabled());
                assertFalse(((View)field(activity,"primaryShutter").get(activity)).isEnabled());
                occupied.set(false);invoke(activity,"updateOperation");
                assertTrue(find(activity.getWindow().getDecorView(),"录像").isEnabled());
            }
        }
    }

    @Test public void fullscreenKeepsShutterModesAndOsdVisible() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); invoke(activity, "drawControl");
            invoke(activity, "toggleMonitorMode");
            assertSame(field(activity, "monitorLayer").get(activity), ((View) field(activity, "captureActions").get(activity)).getParent());
            assertEquals(View.GONE, ((View) field(activity, "bottomNav").get(activity)).getVisibility());
            assertEquals(View.VISIBLE, ((View) field(activity, "primaryShutter").get(activity)).getVisibility());
            assertNotNull(field(activity, "previewParameters").get(activity));
            invoke(activity, "toggleMonitorMode");
            assertEquals(View.VISIBLE, ((View) field(activity, "bottomNav").get(activity)).getVisibility());
        }
    }

    @Test public void connectedParametersRefreshWithoutRedrawingAndClearAfterDisconnect() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            invoke(activity, "drawControl");
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            field(activity, "settings").set(activity, new JSONObject()
                    .put("system_mode", "record").put("rec_mode", "record").put("product_name", "YI 4K Action Camera")
                    .put("video_resolution", "1920x1080 120P 16:9")
                    .put("iq_video_ev", "-1.0").put("iq_photo_ev", "2.0")
                    .put("fov", "medium").put("iq_eis_enable", "off"));
            invoke(activity, "updateCaptureViews");
            View root = activity.getWindow().getDecorView();
            assertNull(field(activity, "cameraTitle").get(activity));
            assertNull(field(activity, "cameraTitle").get(activity));
            assertNotNull(find(root, "FPS 120"));
            assertNotNull(find(root, "RES 1080p"));
            assertNotNull(find(root, "FOV 中等"));
            assertNotNull(find(root, "EV -1.0"));
            assertNotNull(find(root, "EIS 关闭"));
            JSONObject unsupported = (JSONObject) field(activity, "settings").get(activity);
            unsupported.put("video_resolution", "3840x2160 30P 16:9")
                    .put("iq_eis_enable", "on").put("eis_support_status", "off");
            invoke(activity, "updateCaptureViews");
            assertNotNull(find(root, "EIS 规格不支持"));
            assertNull(find(root, "EIS 开启"));
            invoke(activity, "drawSettings");
            clickGroup(root, "影像参数");
            assertNotNull(find(root, "已保存：开启；当前规格不支持"));
            invoke(activity, "drawControl");
            camera.close();
            invoke(activity, "updateCaptureViews");
            assertNotNull(find(root, "FPS --"));
            assertNotNull(find(root, "EV --"));
            assertNull(find(root, "FPS 120"));
        }
    }

    @Test public void configurationDialogActuallyShowsAdvertisedOptions() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            Method method = MainActivity.class.getDeclaredMethod("options", String.class);
            method.setAccessible(true); method.invoke(activity, "video_quality");
            ((ExecutorService) field(activity, "commands").get(activity)).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            AlertDialog dialog = ShadowAlertDialog.getLatestAlertDialog();
            assertNotNull(dialog);
            assertTrue(dialog.getListView().isShown());
            assertEquals(2, dialog.getListView().getAdapter().getCount());
            assertEquals("高质量", dialog.getListView().getAdapter().getItem(0));
            assertEquals("普通", dialog.getListView().getAdapter().getItem(1));
            dialog.dismiss();
        }
    }

    @Test public void batteryNotificationsUpdateStatusWithoutHidingOperationFailure() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            invoke(activity, "drawControl");
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            Method refresh = MainActivity.class.getDeclaredMethod("refresh", boolean.class);
            refresh.setAccessible(true); refresh.invoke(activity, true);
            shadowOf(Looper.getMainLooper()).idle();
            TextView battery = (TextView) field(activity, "deviceBattery").get(activity);
            assertEquals("80%", battery.getText().toString());
            TextView message = (TextView) field(activity, "message").get(activity);
            message.setText("工作模式未生效，请核对相机状态"); message.setVisibility(View.VISIBLE);
            Method event = MainActivity.class.getDeclaredMethod("handleCameraEvent", JSONObject.class);
            event.setAccessible(true);
            event.invoke(activity, new JSONObject().put("msg_id", 7).put("type", "battery").put("param", 72));
            assertEquals("72%", battery.getText().toString());
            event.invoke(activity, new JSONObject().put("msg_id", 7).put("type", "adapter").put("param", "100"));
            assertEquals("100%", battery.getText().toString());
            for (Object invalid : new Object[]{101, -1, "unknown", JSONObject.NULL})
                event.invoke(activity, new JSONObject().put("msg_id", 7).put("type", "battery").put("param", invalid));
            event.invoke(activity, new JSONObject().put("msg_id", 7).put("type", "untranslated_key"));
            assertEquals("100%", battery.getText().toString());
            assertEquals("工作模式未生效，请核对相机状态", message.getText().toString());
            camera.close(); invoke(activity, "updateCaptureViews");
            event.invoke(activity, new JSONObject().put("msg_id", 7).put("type", "battery").put("param", 50));
            assertEquals("--", battery.getText().toString());
        }
    }

    @Test public void disconnectedSettingsAndMediaRowsAreRemovedImmediately() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            field(activity, "settings").set(activity, new JSONObject().put("sw_version", "OLD CAMERA VERSION"));
            field(activity, "page").set(activity, "settings");
            invoke(activity, "drawSettings");
            clickGroup(activity.getWindow().getDecorView(), "相机信息");
            assertNotNull(find(activity.getWindow().getDecorView(), "OLD CAMERA VERSION"));
            Method clear = MainActivity.class.getDeclaredMethod("clearCameraViews", String.class); clear.setAccessible(true);
            clear.invoke(activity, "相机网络已断开");
            View root = activity.getWindow().getDecorView();
            assertNull(find(root, "OLD CAMERA VERSION")); assertNull(find(root, "固件版本"));
            assertNotNull(find(root, "连接相机后，即可查看和调整全部参数。"));

            MediaEntry entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "OLD_CAMERA.JPG", "100 bytes|date");
            ((java.util.List<MediaEntry>)field(activity, "media").get(activity)).add(entry);
            ((java.util.Map<String, MediaEntry>)field(activity, "selectedMedia").get(activity)).put(entry.path, entry);
            field(activity, "page").set(activity, "media"); invoke(activity, "drawMedia");
            assertNotNull(find(root, "OLD_CAMERA.JPG")); assertNotNull(find(root, "导出选中（1）"));
            clear.invoke(activity, "相机网络已断开");
            assertNull(find(root, "OLD_CAMERA.JPG")); assertNull(find(root, "导出选中（0）"));
            assertNotNull(find(root, "选择"));
            assertFalse((Boolean) field(activity, "mediaSelectionMode").get(activity));
            assertTrue(((java.util.Map<?, ?>)field(activity, "selectedMedia").get(activity)).isEmpty());
            assertNotNull(find(root, "请先连接相机"));
        }
    }

    @Test public void fiveSecondPollKeepsCaptureDrawablesAndDoesNotDisplayOperation() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); invoke(activity, "drawControl");
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            Method refresh = MainActivity.class.getDeclaredMethod("refresh", boolean.class); refresh.setAccessible(true);
            refresh.invoke(activity, true); shadowOf(Looper.getMainLooper()).idle();
            // This fixture has no Wi-Fi/RTSP decoder; isolate the periodic status refresh.
            field(activity, "previewAutoFailed").set(activity, true);
            View shutter = (View) field(activity, "primaryShutter").get(activity);
            ViewGroup modes = (ViewGroup) field(activity, "captureModes").get(activity);
            android.graphics.drawable.Drawable originalShutter = shutter.getBackground();
            android.graphics.drawable.Drawable[] originals = new android.graphics.drawable.Drawable[modes.getChildCount()];
            for (int i = 0; i < originals.length; i++) originals[i] = modes.getChildAt(i).getBackground();
            int previousRequests = server.requests.size();
            shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(5));
            ((ExecutorService) field(activity, "commands").get(activity)).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            assertTrue("Scheduled poll must actually query the camera", server.requests.size() > previousRequests);
            assertSame(originalShutter, shutter.getBackground());
            for (int i = 0; i < originals.length; i++) assertSame(originals[i], modes.getChildAt(i).getBackground());
            assertEquals(View.GONE, ((View) field(activity, "operation").get(activity)).getVisibility());
            assertFalse(((java.util.concurrent.atomic.AtomicBoolean) field(activity, "busy").get(activity)).get());
            assertNull(field(activity, "cameraTitle").get(activity));
            assertNull(field(activity, "cameraTitle").get(activity));
            assertNull(find(activity.getWindow().getDecorView(), "APEX"));
        }
    }

    @Test public void statusHintsUseFixedSlotAndShutterProvidesPressFeedback() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); invoke(activity, "drawControl");
            View status = (View) field(activity, "statusSlot").get(activity);
            int fixedHeight = status.getLayoutParams().height;
            assertTrue(fixedHeight > 0);
            assertEquals("No export means no status strip", View.GONE, status.getVisibility());
            assertNull("Messages are never attached to the workspace", ((View) field(activity, "message").get(activity)).getParent());
            TextView message = (TextView) field(activity, "message").get(activity);
            TextView operation = (TextView) field(activity, "operation").get(activity);
            message.setText("拍摄完成"); message.setVisibility(View.VISIBLE);
            operation.setText("正在与相机通信…"); operation.setVisibility(View.VISIBLE);
            invoke(activity, "updateOperation");
            assertEquals(fixedHeight, status.getLayoutParams().height);
            View shutter = (View) field(activity, "primaryShutter").get(activity);
            assertTrue(shutter.isHapticFeedbackEnabled());
            android.view.MotionEvent down = android.view.MotionEvent.obtain(0, 0, android.view.MotionEvent.ACTION_DOWN, 1, 1, 0);
            shutter.dispatchTouchEvent(down); down.recycle();
            assertEquals("Shutter press should visibly compress immediately", .90f, shutter.getScaleX(), .001f);
            android.view.MotionEvent up = android.view.MotionEvent.obtain(0, 1, android.view.MotionEvent.ACTION_UP, 1, 1, 0);
            shutter.dispatchTouchEvent(up); up.recycle();
        }
    }

    @Test public void successfulPhotoUsesPreviewFlashInsteadOfSuccessText() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); invoke(activity, "drawControl");
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            camera.call(2, CameraClient.args("type", "system_mode").put("param", "capture"));
            field(activity, "settings").set(activity, new JSONObject().put("system_mode", "capture"));
            field(activity, "cameraStatus").set(activity, "idle");
            invoke(activity, "updateCaptureViews");

            Method capture = MainActivity.class.getDeclaredMethod("capture", int.class);
            server.delayNextResponseFor(16777220, 500);
            capture.setAccessible(true); capture.invoke(activity, 16777220);
            long waitUntil = System.nanoTime() + TimeUnit.SECONDS.toNanos(3);
            while (!server.requests.contains(16777220) && System.nanoTime() < waitUntil) Thread.sleep(5);
            assertTrue("The photo request must reach the simulated camera", server.requests.contains(16777220));
            shadowOf(Looper.getMainLooper()).idle();
            View shutter = (View) field(activity, "primaryShutter").get(activity);
            assertTrue("The shutter itself must show that the camera is processing the shot",
                    ((CameraVisuals.Shutter) shutter.getBackground()).isPending());
            assertEquals("正在拍照", shutter.getContentDescription());
            assertEquals("Capture progress belongs on the shutter, not in the generic status slot", View.GONE,
                    ((View) field(activity, "operation").get(activity)).getVisibility());
            assertEquals("", ((TextView) field(activity, "message").get(activity)).getText().toString());

            ((ExecutorService) field(activity, "commands").get(activity)).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();

            assertFalse(((CameraVisuals.Shutter) shutter.getBackground()).isPending());
            assertEquals("A successful capture is conveyed through the camera UI", "",
                    ((TextView) field(activity, "message").get(activity)).getText().toString());
            View flash = (View) field(activity, "captureFlash").get(activity);
            assertNotNull("The preview must include a photo confirmation flash", flash);
            Method confirmation = MainActivity.class.getDeclaredMethod("confirmPhotoCapture");
            confirmation.setAccessible(true); confirmation.invoke(activity);
            assertEquals(View.VISIBLE, flash.getVisibility());
            flash.animate().cancel();
            camera.close();
        }
    }

    @Test public void recordingConfirmationUnlocksBeforeSlowTelemetryRefresh() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); invoke(activity, "drawControl");
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            field(activity, "settings").set(activity, new JSONObject().put("system_mode", "record"));
            field(activity, "cameraStatus").set(activity, "idle");
            invoke(activity, "updateCaptureViews");
            server.delayNextResponseFor(3, 1800);
            Method capture = MainActivity.class.getDeclaredMethod("capture", int.class);
            capture.setAccessible(true); capture.invoke(activity, 513);
            long deadline = System.nanoTime() + TimeUnit.SECONDS.toNanos(1);
            while ((!server.requests.contains(3) || (Boolean) field(activity, "capturePending").get(activity))
                    && System.nanoTime() < deadline) {
                shadowOf(Looper.getMainLooper()).idle(); Thread.sleep(5);
            }
            shadowOf(Looper.getMainLooper()).idle();
            assertTrue("Slow telemetry must actually be in flight", server.requests.contains(3));
            View shutter = (View) field(activity, "primaryShutter").get(activity);
            assertFalse("Capture confirmation cannot wait for all settings", (Boolean) field(activity, "capturePending").get(activity));
            assertEquals("record", field(activity, "cameraStatus").get(activity));
            assertEquals("停止录像", shutter.getContentDescription());
            assertTrue(shutter.isEnabled());
            assertEquals(1, java.util.Collections.frequency(server.requests, 513));
        }
    }

    @Test public void emptyMediaDirectoryAutoLoadDoesNotLoop() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            field(activity, "page").set(activity, "media");
            Method list = MainActivity.class.getDeclaredMethod("listMedia", String.class); list.setAccessible(true);
            list.invoke(activity, MediaEntry.DCIM_ROOT + "EMPTY/");
            ((ExecutorService) field(activity, "commands").get(activity)).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            assertTrue((Boolean) field(activity, "mediaAutoLoadRequested").get(activity));
            int requests = server.requests.size();
            Method draw = MainActivity.class.getDeclaredMethod("drawMedia"); draw.setAccessible(true); draw.invoke(activity);
            shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofSeconds(1));
            assertEquals("An empty folder must be a completed load, not an auto-refresh loop", requests, server.requests.size());
        }
    }

    @Test public void returningToConnectedCaptureAutomaticallyAttemptsPreviewWithoutATap() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            field(activity, "connectedHost").set(activity, "127.0.0.1"); invoke(activity, "drawControl");
            shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofMillis(200));
            ((ExecutorService) field(activity, "commands").get(activity)).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            // No real Wi-Fi route is available on the host. A retry state proves the scheduled attempt ran.
            assertTrue((boolean) field(activity, "previewAutoFailed").get(activity));
            assertEquals("预览未连接 · 轻点重试", ((TextView) field(activity, "previewStatus").get(activity)).getText().toString());
            assertEquals(View.GONE, ((View) field(activity, "operation").get(activity)).getVisibility());
        }
    }
    @Test public void settingsGroupsReachEveryReturnedKeyWithoutLegacySearch() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            JSONObject settings = new JSONObject().put("video_quality", "Fine").put("iq_eis_enable", "on")
                    .put("video_flat_color", "yi").put("sw_version", "1.10.7").put("future_camera_key", "future");
            field(activity, "settings").set(activity, settings); invoke(activity, "drawSettings");
            View root = activity.getWindow().getDecorView();
            assertNull(find(root, "电子防抖（EIS）"));
            for (String key : CameraSettings.keys(settings)) {
                clickGroup(root, SettingsHierarchy.classify(key).groupTitle);
                assertNotNull(key, find(root, CameraSettings.displayName(key)));
                View back = find(root, "‹"); assertNotNull(back); assertTrue(back.performClick());
            }
            assertNull("Settings page intentionally has no global search field", findInput(root));
        }
    }

    @Test public void resolutionPickerShowsReadableMetadataAndFiltersWithoutChangingWireValues() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            JSONObject settings = new JSONObject().put("system_mode", "record").put("video_resolution", "3840x2160 30P 16:9")
                    .put("eis_support_status", "off"); field(activity, "settings").set(activity, settings);
            java.util.List<Object> values = java.util.Arrays.asList("3840x2160 30P 16:9", "1920x1080 60P 16:9 super", "future-format");
            Method picker = MainActivity.class.getDeclaredMethod("showResolutionOptions", String.class, java.util.List.class);
            picker.setAccessible(true); picker.invoke(activity, "video_resolution", values);
            AlertDialog dialog = ShadowAlertDialog.getLatestAlertDialog(); View root = dialog.getWindow().getDecorView();
            android.widget.ListView list = findList(root); assertNotNull(list); assertEquals(3, list.getAdapter().getCount());
            View first = list.getAdapter().getView(0, null, list);
            assertNotNull(find(first, "4K 超高清")); assertNotNull(find(first, "30fps")); assertNotNull(find(first, "无EIS"));
            assertTrue(first.isSelected()); assertNotNull(find(first, "✓")); assertNotNull(find(first, "3840 × 2160 · 16:9"));
            View second = list.getAdapter().getView(1, null, list);
            assertNotNull(find(second, "1080p 全高清")); assertNotNull(find(second, "60fps")); assertNotNull(find(second, "超广视角"));
            assertNull(find(second, "无EIS"));
            assertNull("Resolution picker uses visible tags instead of a second search field", findInput(root));
            assertEquals(3, list.getAdapter().getCount());
            dialog.dismiss();
        }
    }

    @Test @org.robolectric.annotation.GraphicsMode(org.robolectric.annotation.GraphicsMode.Mode.NATIVE)
    public void batteryIconUsesChargeColorAndProportionalFill() {
        CameraVisuals.Battery icon = new CameraVisuals.Battery(); icon.setBounds(0, 0, 240, 180);
        for (int[] sample : new int[][]{{10, android.graphics.Color.rgb(235,64,54)}, {40, android.graphics.Color.rgb(194,142,12)}, {80, android.graphics.Color.rgb(40,161,92)}}) {
            icon.update(sample[0]); android.graphics.Bitmap image = android.graphics.Bitmap.createBitmap(240, 180, android.graphics.Bitmap.Config.ARGB_8888);
            icon.draw(new android.graphics.Canvas(image));
            assertEquals(sample[1], image.getPixel(35, 90));
            assertEquals("Empty portion of battery must stay transparent", 0, android.graphics.Color.alpha(image.getPixel(180, 90)));
            int fillEnd = 30 + Math.round(160 * sample[0] / 100f);
            assertEquals(sample[1], image.getPixel(fillEnd - 5, 90));
            assertEquals(0, android.graphics.Color.alpha(image.getPixel(fillEnd + 8, 90))); image.recycle();
        }
        icon.update(-1); android.graphics.Bitmap unknown = android.graphics.Bitmap.createBitmap(240, 180, android.graphics.Bitmap.Config.ARGB_8888);
        icon.draw(new android.graphics.Canvas(unknown)); assertEquals(0, android.graphics.Color.alpha(unknown.getPixel(35,90))); unknown.recycle();
    }

    private static void clickGroup(View root, String title) {
        View group = findDescription(root, title); assertNotNull(title, group); assertTrue(group.performClick());
    }
    private static View findDescription(View root, String description) {
        if (root.getContentDescription() != null && description.contentEquals(root.getContentDescription())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View found = findDescription(((ViewGroup) root).getChildAt(i), description); if (found != null) return found;
        }
        return null;
    }
    private static android.widget.EditText findInput(View root) {
        if (root instanceof android.widget.EditText) return (android.widget.EditText) root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            android.widget.EditText found = findInput(((ViewGroup) root).getChildAt(i)); if (found != null) return found;
        }
        return null;
    }
    private static android.widget.ListView findList(View root) {
        if (root instanceof android.widget.ListView) return (android.widget.ListView) root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            android.widget.ListView found = findList(((ViewGroup) root).getChildAt(i)); if (found != null) return found;
        }
        return null;
    }
    private static Field field(MainActivity activity, String name) throws Exception {
        Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return field;
    }
    private static void invoke(MainActivity activity, String name) throws Exception {
        Method method = MainActivity.class.getDeclaredMethod(name); method.setAccessible(true); method.invoke(activity);
    }
    private static View find(View view, String text) {
        if (view instanceof TextView && text.contentEquals(((TextView) view).getText())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
            View found = find(((ViewGroup) view).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
}
