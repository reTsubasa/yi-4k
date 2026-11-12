package dev.yi4k.control;

import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/** Test-only endpoint selection for explicitly opted-in host-routed camera acceptance.
 * This bypasses nearby-hotspot selection; sockets and the Android Wi-Fi route remain real.
 * All methods must run on the instrumentation UI thread.
 */
final class MainActivityTestDriver {
    /** Prevent system permission windows from masking disconnected layout evidence. */
    static void grantLocalUiPermissions(android.app.Instrumentation instrumentation) {
        String packageName = instrumentation.getTargetContext().getPackageName();
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION",
                "android.permission.ACCESS_FINE_LOCATION", "android.permission.NEARBY_WIFI_DEVICES"})
            instrumentation.getUiAutomation().grantRuntimePermission(packageName, permission);
    }

    /** AVD setup: pre-confirm Android's one-time immersive tutorial overlay. */
    static void confirmLocalImmersiveTutorial(android.app.Instrumentation instrumentation) throws Exception {
        try (android.os.ParcelFileDescriptor result = instrumentation.getUiAutomation().executeShellCommand(
                "settings put secure immersive_mode_confirmations confirmed");
             java.io.InputStream input = new android.os.ParcelFileDescriptor.AutoCloseInputStream(result)) {
            while (input.read() != -1) { }
        }
    }
    static void connectEndpoint(android.app.Activity activity, String address) {
        try {
            Field host = MainActivity.class.getDeclaredField("host"); host.setAccessible(true);
            ((EditText) host.get(activity)).setText(address);
            Method connect = MainActivity.class.getDeclaredMethod("connect"); connect.setAccessible(true); connect.invoke(activity);
        } catch (ReflectiveOperationException error) { throw new AssertionError(error); }
    }
    static void openSetting(android.app.Activity activity, String key) {
        View root = activity.getWindow().getDecorView();
        if (findText(root, CameraSettings.displayName(key)) != null) return;
        View back = findText(root, "‹"); if (back != null) back.performClick();
        View group = findDescription(root, SettingsHierarchy.classify(key).groupTitle);
        if (group == null || !group.performClick()) throw new AssertionError("Missing settings group for " + key);
    }
    static void openSettingTitle(android.app.Activity activity, String title) {
        try {
            Field settings = MainActivity.class.getDeclaredField("settings"); settings.setAccessible(true);
            for (String key : CameraSettings.keys((org.json.JSONObject) settings.get(activity))) {
                if (title.equals(CameraSettings.displayName(key))) { openSetting(activity, key); return; }
            }
            throw new AssertionError("Camera did not return setting " + title);
        } catch (ReflectiveOperationException error) { throw new AssertionError(error); }
    }
    static void disconnect(android.app.Activity activity) {
        try {
            Method connection = MainActivity.class.getDeclaredMethod("drawConnection", int.class);
            connection.setAccessible(true); connection.invoke(activity, 1);
            View button = findText(activity.getWindow().getDecorView(), "断开连接");
            if (button == null || !button.performClick()) throw new AssertionError("Missing disconnect action");
        } catch (ReflectiveOperationException error) { throw new AssertionError(error); }
    }
    private static View findText(View root, String text) {
        if (root instanceof TextView && text.contentEquals(((TextView) root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View found = findText(((ViewGroup) root).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
    private static View findDescription(View root, String text) {
        if (root.getContentDescription() != null && text.contentEquals(root.getContentDescription())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View found = findDescription(((ViewGroup) root).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
}
