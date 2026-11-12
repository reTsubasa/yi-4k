package dev.yi4k.control;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Rect;
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
import org.json.JSONArray;
import org.json.JSONObject;

/** Real Android Window geometry and touch, using only disconnected local UI. */
public final class FullscreenLayoutDeviceTest extends InstrumentationTestCase {
    private MainActivity activity;
    private Object surface;
    private Object previewFrame;
    private final JSONArray screens = new JSONArray();
    private static final String[] PARAMETERS = {"分辨率", "帧率", "视角", "曝光补偿", "色彩"};

    public void testFullscreenRotationsExitAndSettingsRetainPreviewSurface() throws Exception {
        MainActivityTestDriver.grantLocalUiPermissions(getInstrumentation());
        MainActivityTestDriver.confirmLocalImmersiveTutorial(getInstrumentation());
        try {
            activity = (MainActivity) getInstrumentation().startActivitySync(
                    new Intent(getInstrumentation().getTargetContext(), MainActivity.class)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            ui(() -> invoke("drawControl"));
            rotate(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, Configuration.ORIENTATION_PORTRAIT);
            surface = field("previewSurface"); previewFrame = field("capturePreviewFrame");
            capture("capture-portrait", false);
            tap((View) field("previewMonitor"));
            assertEquals(Boolean.TRUE, field("monitorMode"));
            long landscapeDeadline = SystemClock.uptimeMillis() + 10000;
            while (SystemClock.uptimeMillis() < landscapeDeadline) {
                settle();
                if (activity.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE
                        && root().getWidth() > root().getHeight()) break;
                SystemClock.sleep(50);
            }
            assertEquals("Entering fullscreen must request a landscape viewfinder", Configuration.ORIENTATION_LANDSCAPE,
                    activity.getResources().getConfiguration().orientation);
            capture("fullscreen-portrait", true);
            rotate(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE, Configuration.ORIENTATION_LANDSCAPE);
            capture("fullscreen-landscape", true);
            rotate(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, Configuration.ORIENTATION_PORTRAIT);
            capture("fullscreen-portrait-return", true);
            tap((View) field("previewMonitor"));
            assertEquals(Boolean.FALSE, field("monitorMode"));
            capture("capture-after-exit", false);
            tap(findText(root(), "设置"));
            settle();
            ui(() -> {
                assertEquals("settings", uncheckedField("page"));
                assertEquals(View.VISIBLE, ((View) uncheckedField("bottomNav")).getVisibility());
                assertEquals(View.GONE, ((View) uncheckedField("monitorLayer")).getVisibility());
                assertNotNull(findText(root(), "按分类查找相机功能与参数"));
            });
            samePreview(); screenshot("settings-after-fullscreen");
            JSONObject report = new JSONObject().put("complete", true).put("screens", screens)
                    .put("preview_surface_same_object", true).put("preview_frame_same_object", true)
                    .put("fullscreen_enter_exit_and_settings_real_touch", true)
                    .put("camera_connected", false).put("live_stream_decoded", false)
                    .put("scope", "Actual Android AVD layout/configuration/touch; disconnected local UI, no camera or physical phone");
            try (FileOutputStream output = new FileOutputStream(new File(directory(), "fullscreen-layout.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        } finally { if (activity != null) ui(activity::finish); }
    }

    private void capture(String stage, boolean fullscreen) throws Exception {
        settle(); samePreview();
        ui(() -> assertTrue("App Window must have focus for screenshot evidence", root().hasWindowFocus()));
        screenshot(stage);
        JSONObject evidence = new JSONObject().put("stage", stage).put("fullscreen", fullscreen);
        ui(() -> {
            try {
                evidence.put("width", root().getWidth()).put("height", root().getHeight())
                        .put("orientation", activity.getResources().getConfiguration().orientation)
                        .put("surface_identity", System.identityHashCode(surface));
                evidence.put("preview", visible((View) uncheckedField("previewSurface"), false));
                evidence.put("fullscreen_toggle", visible((View) uncheckedField("previewMonitor"), true));
                evidence.put("shutter", visible((View) uncheckedField("primaryShutter"), true));
                for (String mode : new String[]{"录像", "照片", "延时", "慢动作"})
                    evidence.put(mode, visible(findText(root(), mode), true));
            } catch (Exception error) { throw new AssertionError(error); }
        });
        JSONArray parameters = new JSONArray();
        for (String name : PARAMETERS) {
            View parameter = findDescription(root(), name + "，点击调整");
            assertNotNull(name, parameter);
            ui(() -> parameter.requestRectangleOnScreen(new Rect(0, 0, parameter.getWidth(), parameter.getHeight()), true));
            settle();
            ui(() -> {
                try { parameters.put(new JSONObject().put("name", name).put("bounds", visible(parameter, true))); }
                catch (Exception error) { throw new AssertionError(error); }
            });
            // Offline parameter taps have no camera action, but exercise real Window routing.
            tap(parameter); samePreview();
        }
        SystemClock.sleep(2500); // Let the disconnected-parameter toast leave the screenshot.
        evidence.put("parameters_reachable_by_scroll", parameters);
        screens.put(evidence);
        screenshot(stage + "-parameters");
    }

    private JSONObject visible(View target, boolean control) throws Exception {
        assertNotNull(target);
        Rect rect = new Rect();
        assertTrue("View must be visible", target.isShown() && target.getGlobalVisibleRect(rect));
        assertTrue("View must have measured size", target.getWidth() > 0 && target.getHeight() > 0);
        assertEquals("View width clipped: " + target.getContentDescription() + ancestors(target), target.getWidth(), rect.width());
        assertEquals("View height clipped: " + target.getContentDescription() + ancestors(target), target.getHeight(), rect.height());
        if (control) {
            assertTrue("Control must be enabled and clickable", target.isEnabled() && target.isClickable());
            assertSame("Control center must not be covered by another touch target", target,
                    clickableAt(root(), rect.centerX(), rect.centerY()));
        }
        return new JSONObject().put("left", rect.left).put("top", rect.top)
                .put("right", rect.right).put("bottom", rect.bottom);
    }

    private String ancestors(View target) {
        StringBuilder detail = new StringBuilder();
        View current = target;
        while (current != null) {
            Rect bounds = new Rect(); current.getGlobalVisibleRect(bounds);
            ViewGroup.LayoutParams lp = current.getLayoutParams();
            detail.append("\n").append(current.getClass().getSimpleName())
                    .append(" measured=").append(current.getWidth()).append("x").append(current.getHeight())
                    .append(" visible=").append(bounds.toShortString())
                    .append(" padding=").append(current.getPaddingLeft()).append(",").append(current.getPaddingTop())
                    .append(",").append(current.getPaddingRight()).append(",").append(current.getPaddingBottom())
                    .append(" scroll=").append(current.getScrollX()).append(",").append(current.getScrollY());
            if (lp != null) detail.append(" lp=").append(lp.width).append("x").append(lp.height);
            if (lp instanceof ViewGroup.MarginLayoutParams) {
                ViewGroup.MarginLayoutParams m = (ViewGroup.MarginLayoutParams) lp;
                detail.append(" margins=").append(m.leftMargin).append(",").append(m.topMargin)
                        .append(",").append(m.rightMargin).append(",").append(m.bottomMargin);
            }
            current = current.getParent() instanceof View ? (View) current.getParent() : null;
        }
        return detail.toString();
    }

    private static View clickableAt(View view, int x, int y) {
        Rect rect = new Rect();
        if (!view.isShown() || !view.getGlobalVisibleRect(rect) || !rect.contains(x, y)) return null;
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = group.getChildCount() - 1; i >= 0; i--) {
                View hit = clickableAt(group.getChildAt(i), x, y); if (hit != null) return hit;
            }
        }
        return view.isClickable() && view.isEnabled() ? view : null;
    }

    private void tap(View target) throws Exception {
        settle();
        final int[] point = new int[2];
        ui(() -> {
            try { visible(target, true); } catch (Exception error) { throw new AssertionError(error); }
            target.getLocationOnScreen(point); point[0] += target.getWidth()/2; point[1] += target.getHeight()/2;
        });
        long now = SystemClock.uptimeMillis();
        MotionEvent down = MotionEvent.obtain(now, now, MotionEvent.ACTION_DOWN, point[0], point[1], 0);
        MotionEvent up = MotionEvent.obtain(now, now + 60, MotionEvent.ACTION_UP, point[0], point[1], 0);
        try { getInstrumentation().sendPointerSync(down); getInstrumentation().sendPointerSync(up); }
        finally { down.recycle(); up.recycle(); }
        settle();
    }

    private void rotate(int requested, int expected) throws Exception {
        ui(() -> activity.setRequestedOrientation(requested));
        long deadline = SystemClock.uptimeMillis() + 10000;
        while (SystemClock.uptimeMillis() < deadline) {
            settle();
            if (activity.getResources().getConfiguration().orientation == expected
                    && (root().getWidth() > root().getHeight()) == (expected == Configuration.ORIENTATION_LANDSCAPE)) break;
            SystemClock.sleep(50);
        }
        assertEquals(expected, activity.getResources().getConfiguration().orientation);
        assertEquals(expected == Configuration.ORIENTATION_LANDSCAPE, root().getWidth() > root().getHeight());
    }
    private void samePreview() throws Exception {
        assertSame("Fullscreen/rotation must retain the preview surface", surface, field("previewSurface"));
        assertSame("Fullscreen/rotation must retain the preview frame", previewFrame, field("capturePreviewFrame"));
        assertSame(previewFrame, ((View) surface).getParent());
    }
    private void settle() throws Exception {
        getInstrumentation().waitForIdleSync();
        getInstrumentation().getUiAutomation().waitForIdle(150, 5000);
    }
    private void screenshot(String name) throws Exception {
        settle(); Bitmap bitmap = getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(bitmap);
        try (FileOutputStream output = new FileOutputStream(new File(directory(), name + ".png"))) {
            assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output));
        } finally { bitmap.recycle(); }
    }
    private File directory() {
        File dir = new File(getInstrumentation().getTargetContext().getExternalFilesDir(null), "acceptance-screens/fullscreen-layout");
        assertTrue(dir.isDirectory() || dir.mkdirs()); return dir;
    }
    private Object field(String name) throws Exception {
        Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return field.get(activity);
    }
    private Object uncheckedField(String name) {
        try { return field(name); } catch (Exception error) { throw new AssertionError(error); }
    }
    private void invoke(String name) {
        try { Method method = MainActivity.class.getDeclaredMethod(name); method.setAccessible(true); method.invoke(activity); }
        catch (Exception error) { throw new AssertionError(error); }
    }
    private View root() { return activity.getWindow().getDecorView(); }
    private void ui(Runnable action) {
        java.util.concurrent.atomic.AtomicReference<Throwable> failure = new java.util.concurrent.atomic.AtomicReference<>();
        getInstrumentation().runOnMainSync(() -> {
            try { action.run(); } catch (Throwable error) { failure.set(error); }
        });
        if (failure.get() != null) throw new AssertionError("Android UI assertion failed", failure.get());
    }
    private static View findText(View view, String text) {
        if (view instanceof TextView && text.contentEquals(((TextView) view).getText())) return view;
        if (view instanceof ViewGroup) for (int i=0; i<((ViewGroup) view).getChildCount(); i++) {
            View found = findText(((ViewGroup) view).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
    private static View findDescription(View view, String description) {
        if (view.getContentDescription() != null && description.contentEquals(view.getContentDescription())) return view;
        if (view instanceof ViewGroup) for (int i=0; i<((ViewGroup) view).getChildCount(); i++) {
            View found = findDescription(((ViewGroup) view).getChildAt(i), description); if (found != null) return found;
        }
        return null;
    }
}
