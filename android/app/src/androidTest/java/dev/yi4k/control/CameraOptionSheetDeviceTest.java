package dev.yi4k.control;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.os.SystemClock;
import android.test.InstrumentationTestCase;
import android.view.InputDevice;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ListView;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Arrays;
import java.util.concurrent.atomic.AtomicInteger;
import org.json.JSONObject;

/** Actual finger events traverse the window, ListView and metadata scroller.
 * Local option fixtures only; no camera, Wi-Fi choice or setting writes. */
public final class CameraOptionSheetDeviceTest extends InstrumentationTestCase {
    public void testTitleAndMetadataTapsSelectAndMetadataDragDoesNot() throws Exception {
        Context context = getInstrumentation().getTargetContext();
        for (String permission : new String[]{"android.permission.ACCESS_COARSE_LOCATION",
                "android.permission.ACCESS_FINE_LOCATION", "android.permission.NEARBY_WIFI_DEVICES"})
            getInstrumentation().getUiAutomation().grantRuntimePermission(context.getPackageName(), permission);
        MainActivity activity = (MainActivity) getInstrumentation().startActivitySync(new Intent(context, MainActivity.class)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
        AlertDialog[] dialog = {null};
        JSONObject report = new JSONObject().put("scope", "Actual AOSP window touch injection with local option fixtures; no camera or physical phone");
        try {
            for (boolean tags : new boolean[]{false, true}) {
                AtomicInteger selected = new AtomicInteger(-1);
                getInstrumentation().runOnMainSync(() -> dialog[0] = CameraOptionSheet.show(activity, "视频分辨率", Arrays.asList(
                        new CameraOptionSheet.Row("4K 超高清", "3840 × 2160 · 16:9", Arrays.asList("4K", "30fps"), true),
                        new CameraOptionSheet.Row("1080p 全高清", "1920 × 1080 · 16:9", Arrays.asList("1080p", "60fps", "超广视角", "无EIS"), false)), selected::set));
                getInstrumentation().waitForIdleSync();
                getInstrumentation().getUiAutomation().waitForIdle(500, 5000);
                Rect[] hit = {null};
                getInstrumentation().runOnMainSync(() -> {
                    ListView list = dialog[0].getListView();
                    View row = list.getChildAt(1 - list.getFirstVisiblePosition());
                    assertNotNull("Second advertised option must be visible", row);
                    View target = tags ? row.findViewWithTag("option-tags") : row;
                    int[] origin = new int[2]; target.getLocationOnScreen(origin);
                    hit[0] = new Rect(origin[0], origin[1], origin[0] + target.getWidth(), origin[1] + target.getHeight());
                    assertTrue(target.isShown());
                    if (!tags) hit[0].right = hit[0].left + 60;
                });
                if (tags) {
                    gesture(hit[0].right - 8, hit[0].centerY(), hit[0].left + 8, hit[0].centerY());
                    getInstrumentation().waitForIdleSync();
                    assertEquals("Dragging labels must not choose a setting", -1, selected.get());
                    assertTrue(dialog[0].isShowing());
                    report.put("metadata_drag_no_selection", true);
                }
                screenshot(tags ? "before-metadata-tap.png" : "before-title-tap.png");
                gesture(hit[0].centerX(), hit[0].centerY(), hit[0].centerX(), hit[0].centerY());
                long deadline = SystemClock.uptimeMillis() + 3000;
                while (selected.get() < 0 && SystemClock.uptimeMillis() < deadline) SystemClock.sleep(20);
                assertEquals("Window-injected tap must select exact advertised row: tags=" + tags + " bounds=" + hit[0], 1, selected.get());
                assertFalse(dialog[0].isShowing());
                report.put(tags ? "metadata_tap_selected_index" : "title_tap_selected_index", selected.get());
            }
            report.put("complete", true);
            try (FileOutputStream output = new FileOutputStream(new File(directory(), "option-touch.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        } finally {
            getInstrumentation().runOnMainSync(() -> { if (dialog[0] != null) dialog[0].dismiss(); activity.finish(); });
        }
    }
    private void gesture(float fromX, float fromY, float toX, float toY) {
        long down = SystemClock.uptimeMillis();
        inject(down, down, MotionEvent.ACTION_DOWN, fromX, fromY);
        for (int i = 1; i <= 4; ++i) {
            SystemClock.sleep(20);
            inject(down, SystemClock.uptimeMillis(), MotionEvent.ACTION_MOVE,
                    fromX + (toX - fromX) * i / 4, fromY + (toY - fromY) * i / 4);
        }
        inject(down, SystemClock.uptimeMillis(), MotionEvent.ACTION_UP, toX, toY);
    }
    private void inject(long down, long time, int action, float x, float y) {
        MotionEvent event = MotionEvent.obtain(down, time, action, x, y, 0);
        event.setSource(InputDevice.SOURCE_TOUCHSCREEN);
        try { assertTrue(getInstrumentation().getUiAutomation().injectInputEvent(event, true)); }
        finally { event.recycle(); }
    }
    private File directory() {
        File folder = new File(getInstrumentation().getTargetContext().getExternalFilesDir(null), "acceptance-screens/option-touch");
        assertTrue(folder.isDirectory() || folder.mkdirs()); return folder;
    }
    private void screenshot(String name) throws Exception {
        Bitmap bitmap = getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(bitmap);
        try (FileOutputStream output = new FileOutputStream(new File(directory(), name))) {
            assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output));
        } finally { bitmap.recycle(); }
    }
}
