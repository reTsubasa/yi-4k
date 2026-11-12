package dev.yi4k.control;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.os.SystemClock;
import android.content.Intent;
import android.test.InstrumentationTestCase;
import android.view.InputDevice;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;
import org.json.JSONObject;

/** System-rendered album acceptance with fixture metadata, no camera connection. */
public final class AlbumLayoutDeviceTest extends InstrumentationTestCase {
    private Activity activity;

    public void testCompactAlbumSelectionFilterAndSettingsTitle() throws Exception {
        activity = getInstrumentation().startActivitySync(new Intent(
                getInstrumentation().getTargetContext(), MainActivity.class)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
        try {
            runUi(() -> {
                try {
                    @SuppressWarnings("unchecked") List<MediaEntry> entries = (List<MediaEntry>) field("media");
                    for (int i = 1; i <= 8; i++) entries.add(new MediaEntry(MediaEntry.DCIM_ROOT,
                            String.format(java.util.Locale.ROOT, "YDXJ%04d.%s", i, i % 2 == 0 ? "JPG" : "MP4"),
                            "4194304 bytes|2026-11-11"));
                    setField("page", "media"); call("drawMedia");
                } catch (Exception error) { throw new AssertionError(error); }
            });
            idle();
            runUi(() -> {
                assertEquals(0, count(CheckBox.class, root()));
                assertNull(findText(root(), "导出原片"));
                assertNull(findText(root(), "刷新"));
                assertNull(findText(root(), "全选 / 清空"));
                assertTrue(((TextView) findText(root(), "相册")).getTextSize()
                        / activity.getResources().getDisplayMetrics().scaledDensity <= 22.1f);
            });
            shot("album-browse");
            tap(findDescription(root(), "选择原片"));
            tap(findText(root(), "全选"));
            runUi(() -> {
                assertEquals(8, count(CheckBox.class, root()));
                assertNotNull(findText(root(), "导出选中（8）"));
            });
            shot("album-select");
            tap(findText(root(), "取消"));
            runUi(() -> assertEquals(0, count(CheckBox.class, root())));
            tap(findDescription(root(), "筛选相册：全部"));
            idle(); shot("album-filter");
            getInstrumentation().sendKeyDownUpSync(android.view.KeyEvent.KEYCODE_BACK);
            idle();
            runUi(() -> {
                try {
                    setField("settings", new JSONObject().put("video_resolution", "1920x1080 60P 16:9")
                            .put("video_quality", "Fine").put("system_mode", "record").put("video_stamp", "date/time"));
                    setField("settingsGroup", "capture"); call("drawSettings");
                    assertTrue(((TextView) findText(root(), "拍摄设置")).getTextSize()
                            / activity.getResources().getDisplayMetrics().scaledDensity <= 20.1f);
                }
                catch (Exception error) { throw new AssertionError(error); }
            });
            idle();
            shot("settings-title");
            File report = new File(directory(), "album-layout.json");
            try (FileOutputStream out = new FileOutputStream(report)) {
                out.write(new JSONObject().put("complete", true).put("browse_without_per_item_export", true)
                        .put("selection_toolbar_only_on_demand", true).put("touch_select_all_and_cancel", true)
                        .put("scope", "Actual Android layout and touch with fixture metadata; no physical phone/camera or media export")
                        .toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        } finally { if (activity != null) runUi(activity::finish); }
    }

    private void tap(View target) throws Exception {
        assertNotNull(target); Rect hit = new Rect();
        runUi(() -> {
            assertTrue(target.getGlobalVisibleRect(hit));
            int[] origin = new int[2]; target.getLocationOnScreen(origin);
            hit.set(origin[0], origin[1], origin[0] + target.getWidth(), origin[1] + target.getHeight());
        });
        long now = SystemClock.uptimeMillis();
        MotionEvent down = MotionEvent.obtain(now, now, MotionEvent.ACTION_DOWN, hit.centerX(), hit.centerY(), 0);
        MotionEvent up = MotionEvent.obtain(now, now + 70, MotionEvent.ACTION_UP, hit.centerX(), hit.centerY(), 0);
        down.setSource(InputDevice.SOURCE_TOUCHSCREEN); up.setSource(InputDevice.SOURCE_TOUCHSCREEN);
        try { getInstrumentation().sendPointerSync(down); getInstrumentation().sendPointerSync(up); }
        finally { down.recycle(); up.recycle(); }
        idle();
    }
    private void idle() throws Exception {
        getInstrumentation().waitForIdleSync();
        getInstrumentation().getUiAutomation().waitForIdle(500, 5000);
    }
    private void shot(String name) throws Exception {
        Bitmap screenshot = getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(screenshot);
        try (FileOutputStream output = new FileOutputStream(new File(directory(), name + ".png"))) {
            assertTrue(screenshot.compress(Bitmap.CompressFormat.PNG, 100, output));
        } finally { screenshot.recycle(); }
    }
    private File directory() {
        File directory = new File(activity.getExternalFilesDir(null), "acceptance-screens/album-layout");
        assertTrue(directory.isDirectory() || directory.mkdirs()); return directory;
    }
    private View root() { return activity.getWindow().getDecorView(); }
    private void runUi(Runnable task) { getInstrumentation().runOnMainSync(task); }
    private Object field(String name) throws Exception {
        Field f = MainActivity.class.getDeclaredField(name); f.setAccessible(true); return f.get(activity);
    }
    private void setField(String name, Object value) throws Exception {
        Field f = MainActivity.class.getDeclaredField(name); f.setAccessible(true); f.set(activity, value);
    }
    private void call(String name) throws Exception {
        Method m = MainActivity.class.getDeclaredMethod(name); m.setAccessible(true); m.invoke(activity);
    }
    private static View findText(View view, String text) {
        if (view instanceof TextView && text.contentEquals(((TextView) view).getText())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
            View found = findText(((ViewGroup) view).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
    private static View findDescription(View view, String text) {
        if (view.getContentDescription() != null && text.contentEquals(view.getContentDescription())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
            View found = findDescription(((ViewGroup) view).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
    private static int count(Class<?> kind, View view) {
        int total = kind.isInstance(view) ? 1 : 0;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++)
            total += count(kind, ((ViewGroup) view).getChildAt(i));
        return total;
    }
}
