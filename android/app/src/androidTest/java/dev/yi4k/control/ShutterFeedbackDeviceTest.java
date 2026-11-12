package dev.yi4k.control;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.SystemClock;
import android.test.InstrumentationTestCase;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.net.SocketFactory;
import org.json.JSONArray;
import org.json.JSONObject;

/** Actual Android rendering with loopback-only camera responses; no physical camera or phone. */
public final class ShutterFeedbackDeviceTest extends InstrumentationTestCase {
    private Activity activity;
    private final JSONArray cases = new JSONArray();

    public void testNewPhotoDiscoveryFliesRealThumbnailIntoAlbumWithoutMovingDock() throws Exception {
        Context context = getInstrumentation().getTargetContext();
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION",
                "android.permission.ACCESS_FINE_LOCATION", "android.permission.NEARBY_WIFI_DEVICES"})
            getInstrumentation().getUiAutomation().grantRuntimePermission(context.getPackageName(), permission);
        try (SimulatedCamera server = new SimulatedCamera()) {
            activity = getInstrumentation().startActivitySync(new Intent(context, MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            CameraClient camera = (CameraClient) field("camera");
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            camera.call(2, CameraClient.args("type", "system_mode").put("param", "capture"));
            prepare("capture", "idle");
            CameraThumbnailStore store = new CameraThumbnailStore(context);
            // Decode bytes actually fetched through the fixture HTTP server.
            // Cache the known soon-to-be-created path before the shot; it is
            // absent from the camera listing until the product sends capture.
            Bitmap source;
            try (java.io.InputStream input = new java.net.URL("http://127.0.0.1:" + server.httpPort() + "/DCIM/100MEDIA/SIMULATED_NEW_PHOTO.JPG").openStream()) {
                source = android.graphics.BitmapFactory.decodeStream(input);
            }
            assertNotNull(source);
            MediaEntry entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "SIMULATED_NEW_PHOTO.JPG", server.image.length + " bytes|date");
            try { store.remember(entry, source); } finally { source.recycle(); }
            runUi(() -> { setUnchecked("thumbnails", store); setUnchecked("connectedHost", "127.0.0.1"); });
            Rect[] dock = new Rect[1];
            runUi(() -> { dock[0] = bounds((View) value("primaryShutter")); assertTrue(((Button) value("primaryShutter")).performClick()); });
            long deadline = SystemClock.uptimeMillis() + 5000;
            AtomicBoolean flying = new AtomicBoolean();
            while (!flying.get() && SystemClock.uptimeMillis() < deadline) {
                runUi(() -> flying.set(albumValue("flying") != null)); SystemClock.sleep(10);
            }
            assertTrue("Newly listed photo must fly into the album using its decoded image", flying.get());
            runUi(() -> { assertEquals(dock[0], bounds((View) value("primaryShutter"))); saveScreen("photo-to-album-flight"); });
            SystemClock.sleep(650);
            runUi(() -> {
                assertNull(albumValue("flying"));
                assertNotNull("Flight must finish with a real album cover", albumValue("thumbnail"));
                assertEquals(dock[0], bounds((View) value("primaryShutter")));
                assertEquals(entry.path, ((MediaEntry) value("captureAlbumEntry")).path);
                saveScreen("photo-to-album-complete");
            });
            assertEquals(1, count(server, 16777220));
            JSONObject report = new JSONObject().put("scope", "Actual MainActivity, local simulated camera listing and HTTP JPEG; no physical camera")
                    .put("new_photo_discovered", true).put("real_decoded_preview_flown", true)
                    .put("dock_bounds_stable", true).put("request_count", 1).put("complete", true);
            try (FileOutputStream output = new FileOutputStream(new File(directory(), "album-flight.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
            camera.close();
        } finally { if (activity != null) runUi(activity::finish); }
    }

    private Object albumValue(String name) {
        try { Object album = value("captureAlbum"); Field f = album.getClass().getDeclaredField(name); f.setAccessible(true); return f.get(album); }
        catch (Exception error) { throw new AssertionError(error); }
    }
    private void setUnchecked(String name, Object next) {
        try { set(name, next); } catch (Exception error) { throw new AssertionError(error); }
    }

    public void testPhotoConfirmationDoesNotWaitForSlowTelemetry() throws Exception {
        Context context = getInstrumentation().getTargetContext();
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION",
                "android.permission.ACCESS_FINE_LOCATION", "android.permission.NEARBY_WIFI_DEVICES"})
            getInstrumentation().getUiAutomation().grantRuntimePermission(context.getPackageName(), permission);
        try (SimulatedCamera server = new SimulatedCamera()) {
            activity = getInstrumentation().startActivitySync(new Intent(context, MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            CameraClient camera = (CameraClient) field("camera");
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            camera.call(2, CameraClient.args("type", "system_mode").put("param", "capture"));
            prepare("capture", "idle");
            int reads = count(server, 3);
            server.delayNextResponseFor(3, 2500);
            long started = SystemClock.uptimeMillis();
            runUi(() -> assertTrue(((Button) value("primaryShutter")).performClick()));
            runUi(() -> {
                assertTrue("The shutter becomes pending immediately, before camera confirmation", pending());
                assertEquals("The local click must flash immediately", View.VISIBLE, ((View) value("captureFlash")).getVisibility());
                assertNotNull("The album flight starts from the local preview", albumValue("flying"));
            });
            awaitFinished();
            long elapsed = SystemClock.uptimeMillis() - started;
            assertTrue("Confirmed capture cannot wait for the 2500ms settings response: " + elapsed, elapsed < 1500);
            long deadline = SystemClock.uptimeMillis() + 700;
            while (count(server, 3) == reads && SystemClock.uptimeMillis() < deadline) SystemClock.sleep(5);
            assertEquals(reads + 1, count(server, 3));
            runUi(() -> {
                assertEquals("拍照", ((View) value("primaryShutter")).getContentDescription());
                assertTrue(((View) value("primaryShutter")).isEnabled());
                assertEquals("", ((TextView) value("message")).getText().toString());
                saveScreen("photo-confirmed-slow-telemetry");
            });
            assertEquals(1, count(server, 16777220));
            JSONObject report = new JSONObject().put("scope", "AOSP emulator, loopback camera; settings response delayed 2500ms")
                    .put("capture_confirmed_ms", elapsed).put("capture_confirmed_before_telemetry", true)
                    .put("request_count", 1).put("complete", true);
            try (FileOutputStream output = new FileOutputStream(new File(directory(), "shutter-latency.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
            camera.close();
        } finally { if (activity != null) runUi(activity::finish); }
    }

    public void testPhotoVideoAndFailureKeepDockStableAndAnimateTheShutter() throws Exception {
        Context context = getInstrumentation().getTargetContext();
        JSONObject report = new JSONObject().put("scope", "Actual Android emulator, local simulated camera, no RTSP or physical device")
                .put("cases", cases).put("haptic_strength_verified", false);
        // This test measures the shutter in the foreground after permission
        // setup; it does not validate the first-run authorization flow.
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION",
                "android.permission.ACCESS_FINE_LOCATION", "android.permission.NEARBY_WIFI_DEVICES"})
            getInstrumentation().getUiAutomation().grantRuntimePermission(context.getPackageName(), permission);
        report.put("emulator_runtime_permissions_pregranted", true);
        try (SimulatedCamera server = new SimulatedCamera()) {
            activity = getInstrumentation().startActivitySync(new Intent(context, MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            CameraClient camera = (CameraClient) field("camera");
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            camera.call(2, CameraClient.args("type", "system_mode").put("param", "capture"));
            prepare("capture", "idle");
            runCase(server, 16777220, "photo", "正在拍照", "拍照");

            camera.call(2, CameraClient.args("type", "system_mode").put("param", "record"));
            prepare("record", "vf");
            runCase(server, 513, "record-start", "正在开始录像", "停止录像");
            runCase(server, 514, "record-stop", "正在停止录像", "开始录像");

            // Deliberately stale UI mode: camera rejects before any start command.
            camera.call(2, CameraClient.args("type", "system_mode").put("param", "capture"));
            prepare("record", "vf");
            int starts = count(server, 513);
            runUi(() -> assertTrue(((Button) value("primaryShutter")).performClick()));
            awaitFinished();
            runUi(() -> {
                assertFalse(pending());
                TextView error = (TextView) value("message");
                assertTrue(error.isShown());
                assertTrue(error.getText().toString().contains("拍照") || error.getText().toString().contains("录像"));
                assertEquals("开始录像", ((View) value("primaryShutter")).getContentDescription());
                saveScreen("mode-rejected");
            });
            assertEquals("A rejected mode must not send the capture command", starts, count(server, 513));
            report.put("mode_rejection_clears_pending_without_capture", true).put("complete", true);
            camera.close();
        } finally {
            try (FileOutputStream output = new FileOutputStream(new File(directory(), "shutter-feedback.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
            if (activity != null) runUi(activity::finish);
        }
    }

    private void prepare(String mode, String status) throws Exception {
        runUi(() -> {
            try {
                set("settings", new JSONObject().put("system_mode", mode).put("product_name", "SIMULATED CAMERA")
                        .put("video_resolution", "1920x1080 30P 16:9"));
                set("cameraStatus", status);
                invoke("drawControl");
                set("previewAutoFailed", true); // This fixture has no RTSP decoder/stream.
            } catch (Exception error) { throw new AssertionError(error); }
        });
        getInstrumentation().waitForIdleSync();
        SystemClock.sleep(250);
    }

    private void runCase(SimulatedCamera server, int request, String name, String waiting, String finished) throws Exception {
        int before = count(server, request);
        Rect[] original = new Rect[2];
        runUi(() -> {
            original[0] = bounds((View) value("primaryShutter"));
            original[1] = bounds((View) value("captureModes"));
        });
        server.delayNextResponseFor(request, 1400);
        runUi(() -> assertTrue(((Button) value("primaryShutter")).performClick()));
        long deadline = SystemClock.uptimeMillis() + 5000;
        while (count(server, request) == before && SystemClock.uptimeMillis() < deadline) SystemClock.sleep(10);
        assertEquals("The UI must send exactly one request", before + 1, count(server, request));
        SystemClock.sleep(200); // Allow the press/release feedback to finish before comparing layout.
        Bitmap[] ringFrames = new Bitmap[2];
        for (int frame = 0; frame < 2; frame++) {
            final int index = frame;
            runUi(() -> {
                View shutter = (View) value("primaryShutter");
                assertTrue(pending());
                assertFalse(shutter.isEnabled());
                assertEquals(waiting, shutter.getContentDescription());
                assertEquals(View.GONE, ((View) value("operation")).getVisibility());
                assertEquals("", ((TextView) value("message")).getText().toString());
                assertEquals(original[0], bounds(shutter));
                assertEquals(original[1], bounds((View) value("captureModes")));
            });
            // Observe the compositor output, without manually drawing the
            // Drawable: a broken scheduleSelf invalidation must fail here.
            Bitmap screenshot = getInstrumentation().getUiAutomation().takeScreenshot();
            assertNotNull("Android compositor screenshot required", screenshot);
            try {
                Rect area = original[0];
                ringFrames[index] = Bitmap.createBitmap(screenshot, area.left, area.top, area.width(), area.height());
                saveBitmap(screenshot, name + "-pending-" + index);
            } finally { screenshot.recycle(); }
            if (frame == 0) SystemClock.sleep(180);
        }
        int changed = 0, ringPixels = 0;
        for (int y = 0; y < ringFrames[0].getHeight(); y++) for (int x = 0; x < ringFrames[0].getWidth(); x++) {
            int a = ringFrames[0].getPixel(x,y), b = ringFrames[1].getPixel(x,y);
            if (a != b) changed++;
            if (Color.red(a) > 20 && Color.red(a) < 65 && Color.green(a) > 20 && Color.green(a) < 65 && Color.blue(a) > 20 && Color.blue(a) < 65) ringPixels++;
        }
        for (Bitmap bitmap : ringFrames) bitmap.recycle();
        assertTrue("Graphite progress ring must actually render", ringPixels > 15);
        assertTrue("Progress must animate between actual Android frames", changed > 15);
        awaitFinished();
        SystemClock.sleep(300);
        runUi(() -> {
            View shutter = (View) value("primaryShutter");
            assertFalse(pending());
            assertTrue(shutter.isEnabled());
            assertEquals(finished, shutter.getContentDescription());
            assertEquals(original[0], bounds(shutter));
            assertEquals(original[1], bounds((View) value("captureModes")));
            assertEquals("", ((TextView) value("message")).getText().toString());
            saveScreen(name + "-confirmed");
        });
        cases.put(new JSONObject().put("name", name).put("request_count", count(server, request) - before)
                .put("graphite_ring_pixels", ringPixels).put("animated_pixels", changed)
                .put("dock_bounds_stable", true).put("confirmed_action", finished));
    }

    private void awaitFinished() throws Exception {
        long deadline = SystemClock.uptimeMillis() + 6000;
        final AtomicBoolean finished = new AtomicBoolean();
        do {
            runUi(() -> finished.set(!pending() && !((AtomicBoolean) value("busy")).get()));
            if (finished.get()) return;
            SystemClock.sleep(10);
        } while (SystemClock.uptimeMillis() < deadline);
        fail("Camera request must finish within the bounded loopback timeout");
    }
    private int count(SimulatedCamera camera, int request) {
        int count=0; for (int actual : camera.requests) if (actual == request) count++; return count;
    }
    private boolean pending() { return (Boolean) value("capturePending"); }
    private Object value(String name) { try { return field(name); } catch (Exception error) { throw new AssertionError(error); } }
    private Object field(String name) throws Exception { Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return field.get(activity); }
    private void set(String name, Object value) throws Exception { Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); field.set(activity, value); }
    private void invoke(String name) throws Exception { Method method = MainActivity.class.getDeclaredMethod(name); method.setAccessible(true); method.invoke(activity); }
    private Rect bounds(View view) {
        Rect bounds = new Rect(); assertTrue(view.getGlobalVisibleRect(bounds));
        assertEquals(view.getWidth(), bounds.width()); assertEquals(view.getHeight(), bounds.height()); return bounds;
    }
    private void runUi(Runnable action) { getInstrumentation().runOnMainSync(action); }
    private File directory() {
        File directory = new File(getInstrumentation().getTargetContext().getExternalFilesDir(null), "acceptance-screens/shutter-feedback");
        assertTrue(directory.isDirectory() || directory.mkdirs()); return directory;
    }
    private void saveScreen(String name) {
        View root = activity.getWindow().getDecorView();
        Bitmap bitmap = Bitmap.createBitmap(root.getWidth(), root.getHeight(), Bitmap.Config.ARGB_8888);
        root.draw(new Canvas(bitmap));
        try { saveBitmap(bitmap, name); }
        finally { bitmap.recycle(); }
    }
    private void saveBitmap(Bitmap bitmap, String name) {
        try (FileOutputStream output = new FileOutputStream(new File(directory(), name + ".png"))) {
            assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output));
        } catch (Exception error) { throw new AssertionError(error); }
    }
}
