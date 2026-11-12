package dev.yi4k.control;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.os.SystemClock;
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
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONArray;
import org.json.JSONObject;

/** Actual emulator Wi-Fi loss/recovery; no fake Network, socket or camera response. */
public final class CameraDisconnectRecoveryDeviceTest extends InstrumentationTestCase {
    private Activity activity;
    private Context context;
    private final JSONObject evidence = new JSONObject();
    private final JSONArray events = new JSONArray();

    public void testWifiLossClearsSettingsAndReconnectsThroughProductUi() throws Exception {
        assertEquals("Only the managed emulator may have Wi-Fi toggled", "ranchu", Build.HARDWARE);
        Bundle args = ((InstrumentationTestRunner)getInstrumentation()).getArguments();
        String host = args.getString("yi4k_camera_host"); assertNotNull("Explicit camera host required", host);
        JSONArray manifest = new JSONArray(args.getString("yi4k_media_manifest", "[]")); assertEquals(2, manifest.length());
        context = getInstrumentation().getTargetContext();
        evidence.put("events", events);
        boolean wifiDisabled = false;
        try {
            Network first = awaitWifi(true, 20000); evidence.put("initial_wifi", first.toString());
            activity = getInstrumentation().startActivitySync(new Intent(context, MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            getInstrumentation().waitForIdleSync();
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host));
            waitText("连接成功", 20000); click("设置");
            runUi(() -> MainActivityTestDriver.openSetting(activity, "sw_version")); waitText("固件版本", 10000);
            runUi(() -> MainActivityTestDriver.openSetting(activity, "video_resolution")); waitText("视频分辨率", 10000);
            event("real_camera_settings_visible"); saveScreen("connected.png");

            wifiDisabled = true; shell("svc wifi disable"); awaitWifi(false, 20000);
            event("actual_android_wifi_lost");
            waitText("连接相机后，即可查看和调整全部参数。", 15000);
            assertFalse("Disconnected settings must not retain stale camera values", hasText("固件版本"));
            event("disconnected_settings_cleared"); saveScreen("disconnected.png");

            shell("svc wifi enable"); Network restored = awaitWifi(true, 25000); wifiDisabled = false;
            assertFalse("Android must provide a new Wi-Fi Network after loss", first.equals(restored));
            evidence.put("restored_wifi", restored.toString());
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host)); waitText("连接成功", 20000); click("设置");
            runUi(() -> MainActivityTestDriver.openSetting(activity, "sw_version")); waitText("固件版本", 10000);
            runUi(() -> MainActivityTestDriver.openSetting(activity, "iq_eis_enable")); waitText("电子防抖（EIS）", 10000);
            event("product_reconnected_and_refreshed"); saveScreen("reconnected.png");

            // A second real loss verifies that old camera files and a selected
            // export cannot remain actionable after their Network disappears.
            click("相册"); String path = manifest.getJSONObject(0).getString("path");
            String folder = path.substring(0, path.lastIndexOf('/') + 1);
            String folderName = folder.substring(MediaEntry.DCIM_ROOT.length());
            waitText(folderName, 10000); click(folderName); click("选择");
            String name = manifest.getJSONObject(0).getString("name"); waitText(name, 10000);
            runUi(() -> {
                View label = findText(activity.getWindow().getDecorView(), name); assertNotNull(label);
                CheckBox box = (CheckBox)findType((View)label.getParent(), CheckBox.class); assertNotNull(box);
                box.performClick(); assertTrue(box.isChecked());
            }); getInstrumentation().waitForIdleSync(); waitText("导出选中（1）", 5000);
            event("real_camera_media_selected"); saveScreen("media-selected.png");
            wifiDisabled = true; shell("svc wifi disable"); awaitWifi(false, 20000);
            waitText("请先连接相机", 15000);
            assertFalse("Disconnected album must leave selection mode", hasText("导出选中（0）"));
            assertFalse("Old camera media card must be removed", hasText(name));
            assertFalse("Old directory must be removed", hasText("上一级"));
            event("disconnected_media_and_selection_cleared"); saveScreen("media-disconnected.png");
            shell("svc wifi enable"); Network secondRestored = awaitWifi(true, 25000); wifiDisabled = false;
            assertFalse(restored.equals(secondRestored)); evidence.put("second_restored_wifi", secondRestored.toString());
            runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host)); waitText("连接成功", 20000); click("设置");
            runUi(() -> MainActivityTestDriver.openSetting(activity, "sw_version")); waitText("固件版本", 10000);
            event("second_product_reconnect_confirmed");
            runUi(() -> MainActivityTestDriver.disconnect(activity)); waitText("已断开", 10000);
            evidence.put("complete", true);
            evidence.put("scope", "Real MainActivity and camera API on AOSP emulator; two real Wi-Fi Network losses via emulator svc, immediate settings/media/selection clearing and two fresh-network reconnects via an explicit test endpoint (nearby-hotspot selection bypassed). No camera writes, captures or phone hotspot acceptance.");
        } catch (Throwable failure) {
            evidence.put("failure", failure.toString());
            if (failure instanceof Error) throw (Error)failure;
            if (failure instanceof Exception) throw (Exception)failure;
            throw new AssertionError(failure);
        } finally {
            try {
                if (wifiDisabled) { shell("svc wifi enable"); awaitWifi(true, 25000); event("finally_restored_emulator_wifi"); }
            } finally {
                try { if (activity != null) { runUi(activity::finish); getInstrumentation().waitForIdleSync(); } }
                finally { try (OutputStream output = new FileOutputStream(new File(directory(), "camera-disconnect.json"))) { output.write(evidence.toString(2).getBytes(StandardCharsets.UTF_8)); } }
            }
        }
    }
    private void shell(String command) throws Exception {
        try (ParcelFileDescriptor fd = getInstrumentation().getUiAutomation().executeShellCommand(command);
             InputStream input = new ParcelFileDescriptor.AutoCloseInputStream(fd)) {
            byte[] bytes = new byte[1024]; int total = 0, count;
            while ((count = input.read(bytes)) != -1) { total += count; assertTrue("Bounded shell output", total < 8192); }
        }
    }
    private Network awaitWifi(boolean present, long timeout) throws Exception {
        ConnectivityManager manager = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        long deadline = SystemClock.uptimeMillis() + timeout;
        do {
            Network wifi = null;
            for (Network network : manager.getAllNetworks()) {
                NetworkCapabilities caps = manager.getNetworkCapabilities(network);
                if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) { wifi = network; break; }
            }
            if ((wifi != null) == present) return wifi;
            Thread.sleep(150);
        } while (SystemClock.uptimeMillis() < deadline);
        throw new AssertionError("Actual emulator Wi-Fi did not become " + present);
    }
    private void click(String text) throws Exception {
        long deadline = SystemClock.uptimeMillis() + 15000;
        do {
            AtomicReference<Boolean> clicked = new AtomicReference<>(false);
            runUi(() -> { View button = findButton(activity.getWindow().getDecorView(), text); if (button != null && button.isEnabled()) { assertTrue(button.performClick()); clicked.set(true); } });
            if (clicked.get()) { getInstrumentation().waitForIdleSync(); event("ui_click_" + text); return; }
            Thread.sleep(150);
        } while (SystemClock.uptimeMillis() < deadline);
        throw new AssertionError("Enabled UI button missing: " + text);
    }
    private boolean hasText(String text) {
        AtomicReference<Boolean> found = new AtomicReference<>(false);
        runUi(() -> found.set(findText(activity.getWindow().getDecorView(), text) != null)); return found.get();
    }
    private void waitText(String text, long timeout) throws Exception {
        long deadline = SystemClock.uptimeMillis() + timeout;
        do { if (hasText(text)) return; Thread.sleep(150); } while (SystemClock.uptimeMillis() < deadline);
        saveScreen("timeout.png"); throw new AssertionError("UI did not reach: " + text);
    }
    private static View findText(View root, String text) {
        if (root instanceof TextView && text.contentEquals(((TextView)root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) { View found = findText(((ViewGroup)root).getChildAt(i), text); if (found != null) return found; }
        return null;
    }
    private static View findButton(View root, String text) {
        if (root instanceof Button && text.contentEquals(((Button)root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) { View found = findButton(((ViewGroup)root).getChildAt(i), text); if (found != null) return found; }
        return null;
    }
    private static View findType(View root, Class<?> type) {
        if (type.isInstance(root)) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) { View found = findType(((ViewGroup)root).getChildAt(i), type); if (found != null) return found; }
        return null;
    }
    private void runUi(Runnable action) {
        AtomicReference<Throwable> failure = new AtomicReference<>();
        getInstrumentation().runOnMainSync(() -> { try { action.run(); } catch (Throwable error) { failure.set(error); } });
        Throwable error = failure.get(); if (error instanceof Error) throw (Error)error;
        if (error instanceof RuntimeException) throw (RuntimeException)error; if (error != null) throw new AssertionError(error);
    }
    private File directory() { File dir = new File(context.getExternalFilesDir(null), "acceptance-screens/camera-disconnect"); assertTrue(dir.isDirectory() || dir.mkdirs()); return dir; }
    private void event(String name) throws Exception { events.put(new JSONObject().put("event", name).put("elapsed_realtime_ms", SystemClock.elapsedRealtime())); }
    private void saveScreen(String name) throws Exception {
        getInstrumentation().waitForIdleSync(); Bitmap bitmap = getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(bitmap);
        try (OutputStream output = new FileOutputStream(new File(directory(), name))) { assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)); } finally { bitmap.recycle(); }
    }
}
