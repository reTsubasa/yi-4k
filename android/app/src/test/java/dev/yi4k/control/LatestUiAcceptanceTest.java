package dev.yi4k.control;

import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import org.robolectric.RobolectricTestRunner;
import static org.junit.Assert.*;

/** Regression checks for the current prototype contract; no camera or Wi-Fi is used. */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public final class LatestUiAcceptanceTest {
    @Test public void disconnectedLandingHidesManualSearchAndAddressInputs() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            invoke(activity, "drawConnection", int.class, 1);
            View root = activity.getWindow().getDecorView();
            View retry = field(activity, "connectButton").get(activity) instanceof View
                    ? (View) field(activity, "connectButton").get(activity) : null;
            assertNotNull(retry);
            assertEquals("Search is automatic on entry; retry appears only after a result/error", View.GONE, retry.getVisibility());
            assertNotNull(find(root, "开启相机 Wi-Fi，选择设备即可连接"));
            assertNotNull(find(root, "搜索附近相机"));
            assertNull(visibleInput(root));
        }
    }

    @Test public void fullMonitorToggleKeepsCaptureDockAndRestoresNavigation() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            invoke(activity, "drawControl");
            Method toggle = MainActivity.class.getDeclaredMethod("toggleMonitorMode"); toggle.setAccessible(true);
            toggle.invoke(activity);
            assertTrue((Boolean) field(activity, "monitorMode").get(activity));
            // Immersive mode hides system/navigation chrome while preserving
            // the controls users need during monitoring.
            assertEquals(View.VISIBLE, ((View) field(activity, "monitorLayer").get(activity)).getVisibility());
            assertSame(field(activity, "monitorLayer").get(activity), ((View) field(activity, "captureActions").get(activity)).getParent());
            assertEquals(View.GONE, ((View) field(activity, "bottomNav").get(activity)).getVisibility());
            toggle.invoke(activity);
            assertFalse((Boolean) field(activity, "monitorMode").get(activity));
            assertEquals(View.VISIBLE, ((View) field(activity, "bottomNav").get(activity)).getVisibility());
        }
    }

    @Test public void settingsAndMediaDoNotExposeLegacySearchOrConnectionCard() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            invoke(activity, "drawSettings");
            View root = activity.getWindow().getDecorView();
            assertNull(find(root, "搜索设置，如防抖、曝光、提示音"));
            assertNull(find(root, "连接管理"));
            invoke(activity, "drawMedia");
            root = activity.getWindow().getDecorView();
            assertNull(find(root, "连接管理"));
        }
    }

    private static Field field(MainActivity activity, String name) throws Exception {
        Field f = MainActivity.class.getDeclaredField(name); f.setAccessible(true); return f;
    }
    private static void invoke(MainActivity activity, String name, Class<?> type, Object value) throws Exception {
        Method m = MainActivity.class.getDeclaredMethod(name, type); m.setAccessible(true); m.invoke(activity, value);
    }
    private static void invoke(MainActivity activity, String name) throws Exception {
        Method m = MainActivity.class.getDeclaredMethod(name); m.setAccessible(true); m.invoke(activity);
    }
    private static View find(View root, String text) {
        if (root instanceof TextView && text.contentEquals(((TextView) root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View found = find(((ViewGroup) root).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
    private static EditText visibleInput(View root) {
        if (root instanceof EditText && root.getVisibility() == View.VISIBLE) return (EditText) root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            EditText found = visibleInput(((ViewGroup) root).getChildAt(i)); if (found != null) return found;
        }
        return null;
    }
}
