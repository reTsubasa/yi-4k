package dev.yi4k.control;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.os.SystemClock;
import android.test.InstrumentationTestCase;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import org.json.JSONArray;
import org.json.JSONObject;

/** Actual Android rotation/layout regression, with no camera session or stream. */
public final class CaptureLayoutDeviceTest extends InstrumentationTestCase {
    private Activity activity;
    private final JSONArray screens = new JSONArray();

    public void testRotationKeepsPreviewEntryShutterAndModesReachable() throws Exception {
        MainActivityTestDriver.grantLocalUiPermissions(getInstrumentation());
        Context context = getInstrumentation().getTargetContext();
        SharedPreferences preferences = context.getSharedPreferences("MainActivity", Context.MODE_PRIVATE);
        boolean hadGuide = preferences.contains("connection_guide_seen");
        boolean guideSeen = preferences.getBoolean("connection_guide_seen", false);
        assertTrue(preferences.edit().putBoolean("connection_guide_seen", true).commit());
        try {
            activity = getInstrumentation().startActivitySync(new Intent(context, MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            getInstrumentation().waitForIdleSync();
            showCapture();
            rotate(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, Configuration.ORIENTATION_PORTRAIT);
            inspect("portrait");
            rotate(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE, Configuration.ORIENTATION_LANDSCAPE);
            inspect("landscape");
            // Exercise the public preview tap after the configuration callback.
            // Offline it must still reach connection management.
            runUi(() -> assertTrue(findDescription(root(), "开启相机实时预览").performClick()));
            getInstrumentation().waitForIdleSync();
            runUi(() -> assertNotNull("Preview tap must open the connection guide",
                    findText(root(), "搜索附近相机")));
            showCapture();
            getInstrumentation().waitForIdleSync();
            rotate(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, Configuration.ORIENTATION_PORTRAIT);
            inspect("portrait-return");
            JSONObject report = new JSONObject().put("complete", true).put("screens", screens)
                    .put("preview_tap_opens_connection_guide", true)
                    .put("camera_connected", false).put("live_stream_decoded", false)
                    .put("scope", "Actual Android configuration changes and disconnected capture layout; no physical phone or camera validation");
            File directory = directory();
            try (FileOutputStream output = new FileOutputStream(new File(directory, "capture-layout.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        } finally {
            if (activity != null) runUi(activity::finish);
            SharedPreferences.Editor restore = preferences.edit();
            if (hadGuide) restore.putBoolean("connection_guide_seen", guideSeen);
            else restore.remove("connection_guide_seen");
            assertTrue(restore.commit());
        }
    }

    private void showCapture() {
        runUi(() -> {
            try {
                java.lang.reflect.Method method = MainActivity.class.getDeclaredMethod("drawControl");
                method.setAccessible(true); method.invoke(activity);
            } catch (Exception error) { throw new AssertionError(error); }
        });
        getInstrumentation().waitForIdleSync();
    }

    private void rotate(int request, int expected) throws Exception {
        if (activity.getResources().getConfiguration().orientation == expected) return;
        Object surface = field("previewSurface");
        runUi(() -> activity.setRequestedOrientation(request));
        long deadline = SystemClock.uptimeMillis() + 10000;
        while (SystemClock.uptimeMillis() < deadline) {
            getInstrumentation().waitForIdleSync();
            if (activity.getResources().getConfiguration().orientation == expected
                    && (root().getWidth() > root().getHeight()) == (expected == Configuration.ORIENTATION_LANDSCAPE)) break;
            SystemClock.sleep(50);
        }
        assertEquals(expected, activity.getResources().getConfiguration().orientation);
        assertSame("Rotation must retain the preview surface", surface, field("previewSurface"));
    }

    private Object field(String name) throws Exception {
        java.lang.reflect.Field field = MainActivity.class.getDeclaredField(name);
        field.setAccessible(true); return field.get(activity);
    }

    private void inspect(String name) throws Exception {
        // Wait for the actual Window/layout traversal after onCreate.
        long deadline = SystemClock.uptimeMillis() + 5000;
        while (SystemClock.uptimeMillis() < deadline) {
            final boolean[] ready = {false};
            runUi(() -> ready[0] = root().getWidth() > 0 && root().getHeight() > 0
                    && findDescription(root(), "开启相机实时预览") != null);
            if (ready[0]) break;
            SystemClock.sleep(50);
        }
        runUi(() -> {
            try {
                assertTrue("App Window must have focus for screenshot evidence", root().hasWindowFocus());
                JSONObject screen = new JSONObject().put("name", name)
                        .put("width", root().getWidth()).put("height", root().getHeight())
                        .put("font_scale", activity.getResources().getConfiguration().fontScale);
                View preview = findDescription(root(), "开启相机实时预览");
                screen.put("preview", visible(preview));
                screen.put("shutter", visible(findDescription(root(), "开始录像")));
                for (String mode : new String[]{"录像", "照片", "延时", "慢动作"}) {
                    View target = findText(root(), mode);
                    assertNotNull(mode, target);
                    target.requestRectangleOnScreen(new Rect(0, 0, target.getWidth(), target.getHeight()), true);
                    screen.put(mode, visible(target));
                }
                screens.put(screen);
                Bitmap bitmap = Bitmap.createBitmap(root().getWidth(), root().getHeight(), Bitmap.Config.ARGB_8888);
                root().draw(new Canvas(bitmap));
                try (FileOutputStream output = new FileOutputStream(new File(directory(), name + ".png"))) {
                    assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output));
                } finally { bitmap.recycle(); }
            } catch (Exception error) { throw new AssertionError(error); }
        });
    }

    private JSONObject visible(View target) throws Exception {
        assertNotNull(target);
        Rect actual = new Rect();
        assertTrue("View must be shown", target.isShown() && target.getGlobalVisibleRect(actual));
        assertTrue("View must have a measured size", target.getWidth() > 0 && target.getHeight() > 0);
        assertEquals("View width clipped", target.getWidth(), actual.width());
        assertEquals("View height clipped", target.getHeight(), actual.height());
        return new JSONObject().put("left", actual.left).put("top", actual.top)
                .put("width", actual.width()).put("height", actual.height());
    }

    private File directory() {
        File directory = new File(getInstrumentation().getTargetContext().getExternalFilesDir(null),
                "acceptance-screens/capture-layout");
        assertTrue(directory.isDirectory() || directory.mkdirs());
        return directory;
    }
    private View root() { return activity.getWindow().getDecorView(); }
    private void runUi(Runnable action) { getInstrumentation().runOnMainSync(action); }
    private static View findDescription(View view, String description) {
        if (view.getContentDescription() != null && description.contentEquals(view.getContentDescription())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)view).getChildCount(); i++) {
            View result = findDescription(((ViewGroup)view).getChildAt(i), description);
            if (result != null) return result;
        }
        return null;
    }
    private static View findText(View view, String text) {
        if (view instanceof TextView && text.contentEquals(((TextView)view).getText())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)view).getChildCount(); i++) {
            View result = findText(((ViewGroup)view).getChildAt(i), text);
            if (result != null) return result;
        }
        return null;
    }
}
