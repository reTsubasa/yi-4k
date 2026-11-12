package dev.yi4k.control;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.GraphicsMode;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 35, qualifiers = "w360dp-h780dp-mdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
public final class CameraOptionSheetTest {
    @Test public void resolutionTouchesSelectFromTitleOrTagsAndDraggingDoesNotSelect() throws Exception {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            Activity activity = lifecycle.get();
            for (boolean tags : new boolean[]{false, true}) {
                AtomicInteger selected = new AtomicInteger(-1);
                AlertDialog dialog = CameraOptionSheet.show(activity, "视频分辨率", Arrays.asList(
                        new CameraOptionSheet.Row("4K 超高清", "3840 × 2160 · 16:9", Arrays.asList("4K", "30fps"), true),
                        new CameraOptionSheet.Row("1080p 全高清", "1920 × 1080 · 16:9", Arrays.asList("1080p", "60fps", "超广视角"), false)), selected::set);
                View row = dialog.getListView().getAdapter().getView(1, null, dialog.getListView());
                activity.setContentView(row);
                row.measure(View.MeasureSpec.makeMeasureSpec(312, View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
                row.layout(0, 0, row.getMeasuredWidth(), row.getMeasuredHeight());
                View target = tags ? row.findViewWithTag("option-tags") : row;
                if (tags) {
                    touch(target, MotionEvent.ACTION_DOWN, 80, 10);
                    touch(target, MotionEvent.ACTION_MOVE, 10, 10);
                    touch(target, MotionEvent.ACTION_UP, 10, 10);
                    assertEquals("Scrolling metadata must not change resolution", -1, selected.get());
                    assertTrue(dialog.isShowing());
                }
                touch(target, MotionEvent.ACTION_DOWN, 10, 10);
                touch(target, MotionEvent.ACTION_UP, 10, 10);
                org.robolectric.Shadows.shadowOf(android.os.Looper.getMainLooper()).idle();
                assertEquals("Actual touch path, tags=" + tags, 1, selected.get());
                assertFalse(dialog.isShowing());
            }
        }
    }
    private static void touch(View view, int action, float x, float y) {
        long time = android.os.SystemClock.uptimeMillis();
        MotionEvent event = MotionEvent.obtain(time, time, action, x, y, 0);
        try { view.dispatchTouchEvent(event); } finally { event.recycle(); }
    }
    @Test public void ordinaryOptionsUseTheSameBottomSurfaceAndSelectTheOriginalIndex() throws Exception {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            Activity activity = lifecycle.get(); AtomicInteger selected = new AtomicInteger(-1);
            AlertDialog dialog = CameraOptionSheet.show(activity, "照片质量", Arrays.asList(
                    new CameraOptionSheet.Row("超高质量", "", Collections.emptyList(), true),
                    new CameraOptionSheet.Row("高质量", "", Collections.emptyList(), false),
                    new CameraOptionSheet.Row("普通", "", Collections.emptyList(), false)), selected::set);
            assertEquals(Gravity.BOTTOM, dialog.getWindow().getAttributes().gravity);
            assertEquals(3, dialog.getListView().getAdapter().getCount());
            assertEquals("高质量", dialog.getListView().getAdapter().getItem(1));
            assertNull("Native radio groups are replaced by individually styled rows", findType(dialog.getWindow().getDecorView(), android.widget.RadioButton.class));
            dialog.getListView().performItemClick(null, 1, 1);
            assertEquals(1, selected.get()); assertFalse(dialog.isShowing());
        }
    }
    @Test public void resolutionTagsHaveOneAlignedTrailingColumnAndDistinctSemanticColors() throws Exception {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            Activity activity = lifecycle.get();
            CameraOptionSheet.Row[] options = {
                    new CameraOptionSheet.Row("4K 超高清", "3840 × 2160 · 16:9", Arrays.asList("4K", "30fps"), false),
                    new CameraOptionSheet.Row("4K 超高清", "3840 × 2160 · 16:9", Arrays.asList("4K", "24fps", "超广视角"), false),
                    new CameraOptionSheet.Row("1080p 全高清", "1920 × 1080 · 16:9", Arrays.asList("1080p", "120fps", "无EIS"), true)};
            for (int width : new int[]{312, 360}) {
                LinearLayout surface = new LinearLayout(activity); surface.setOrientation(LinearLayout.VERTICAL);
                int edge = -1, tagColumnWidth = -1;
                for (CameraOptionSheet.Row option : options) {
                    View row = CameraOptionSheet.optionRow(activity, option);
                    surface.addView(row, new LinearLayout.LayoutParams(-1, -2));
                    row.measure(View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
                    row.layout(0, 0, width, row.getMeasuredHeight());
                    HorizontalScrollView tags = (HorizontalScrollView) row.findViewWithTag("option-tags"); assertNotNull(tags);
                    if (edge < 0) { edge = tags.getRight(); tagColumnWidth = tags.getWidth(); }
                    assertEquals(edge, tags.getRight()); assertEquals(tagColumnWidth, tags.getWidth());
                    LinearLayout line = (LinearLayout) tags.getChildAt(0);
                    int top = -1;
                    for (int i = 0; i < line.getChildCount(); i++) {
                        TextView tag = (TextView) line.getChildAt(i);
                        assertEquals(1, tag.getLineCount());
                        if (top < 0) top = tag.getTop(); assertEquals(top, tag.getTop());
                        assertEquals(AppPalette.tagText(tag.getText().toString()), tag.getCurrentTextColor());
                        if (i > 0) assertTrue(tag.getLeft() >= line.getChildAt(i - 1).getRight() + 4);
                    }
                    TextView title = (TextView) ((ViewGroup) ((ViewGroup) row).getChildAt(0)).getChildAt(0);
                    assertTrue("Resolution title must retain readable space", title.getWidth() >= 60);
                }
                assertNotEquals(AppPalette.tagBackground("4K"), AppPalette.tagBackground("60fps"));
                assertNotEquals(AppPalette.tagBackground("60fps"), AppPalette.tagBackground("超广视角"));
                assertNotEquals(AppPalette.tagBackground("超广视角"), AppPalette.tagBackground("无EIS"));
                surface.measure(View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
                surface.layout(0, 0, width, surface.getMeasuredHeight());
                Bitmap bitmap = Bitmap.createBitmap(width, surface.getHeight(), Bitmap.Config.ARGB_8888); surface.draw(new Canvas(bitmap));
                File folder = new File("build/reports/option-sheet-renders"); assertTrue(folder.isDirectory() || folder.mkdirs());
                try (FileOutputStream output = new FileOutputStream(new File(folder, "resolution-rows-" + width + ".png"))) { bitmap.compress(Bitmap.CompressFormat.PNG, 100, output); }
                finally { bitmap.recycle(); }
            }
        }
    }
    private static View findType(View view, Class<?> type) {
        if (type.isInstance(view)) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
            View result = findType(((ViewGroup) view).getChildAt(i), type); if (result != null) return result;
        }
        return null;
    }
}
