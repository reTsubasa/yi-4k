package dev.yi4k.control;

import android.app.AlertDialog;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.shadows.ShadowAlertDialog;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public final class AlbumUiTest {
    @Test public void browsingKeepsImagesPrimaryAndLongPressOpensOneSelectionToolbar() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); seed(activity);
            View root = activity.getWindow().getDecorView();
            assertNull(findText(root, "导出原片"));
            assertNull(findText(root, "全选 / 清空"));
            assertNull(findText(root, "刷新"));
            assertEquals(0, countType(root, CheckBox.class));
            View photo = findDescription(root, "打开原片：YDXJ0002.JPG"); assertNotNull(photo);
            assertTrue(photo.performLongClick());
            assertEquals(2, countType(root, CheckBox.class));
            assertNotNull(findText(root, "导出选中（1）"));
            assertNull(findText(root, "导出原片"));
            assertTrue(findText(root, "全选").performClick());
            assertNotNull(findText(root, "导出选中（2）"));
            assertEquals(2, ((Map<?, ?>) field(activity, "selectedMedia")).size());
            assertTrue(findText(root, "取消").performClick());
            assertEquals(0, countType(root, CheckBox.class));
            assertEquals(0, ((Map<?, ?>) field(activity, "selectedMedia")).size());
            assertNotNull(findText(root, "选择"));
        }
    }

    @Test public void filterSheetScopesTheGridAndSelectAllToVisibleItems() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); seed(activity);
            View root = activity.getWindow().getDecorView();
            assertTrue(findDescription(root, "筛选相册：全部").performClick());
            AlertDialog dialog = ShadowAlertDialog.getLatestAlertDialog(); assertNotNull(dialog);
            dialog.getListView().performItemClick(null, 2, 2);
            assertNotNull(findDescription(root, "打开原片：YDXJ0002.JPG"));
            assertNull(findDescription(root, "打开原片：YDXJ0001.MP4"));
            assertNotNull(findText(root, "1 个素材"));
            assertTrue(findText(root, "选择").performClick());
            assertTrue(findText(root, "全选").performClick());
            assertEquals(1, ((Map<?, ?>) field(activity, "selectedMedia")).size());
            assertNotNull(findText(root, "导出选中（1）"));
        }
    }

    @Test public void normalTapUsesPlaybackConnectionGateInsteadOfSelecting() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); seed(activity);
            View root = activity.getWindow().getDecorView();
            assertTrue(findDescription(root, "打开原片：YDXJ0001.MP4").performClick());
            assertEquals("connection", field(activity, "page"));
            assertEquals(0, ((Map<?, ?>) field(activity, "selectedMedia")).size());
        }
    }

    @Test public void backCancelsSelectionWhileStayingInAlbum() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); seed(activity);
            View root = activity.getWindow().getDecorView();
            assertTrue(findDescription(root, "打开原片：YDXJ0002.JPG").performLongClick());
            Method back = MainActivity.class.getDeclaredMethod("navigateBack"); back.setAccessible(true); back.invoke(activity);
            assertEquals("media", field(activity, "page"));
            assertFalse(activity.isFinishing());
            assertEquals(0, ((Map<?, ?>) field(activity, "selectedMedia")).size());
            assertEquals(0, countType(root, CheckBox.class));
            assertNotNull(findText(root, "选择"));
        }
    }

    @SuppressWarnings("unchecked") private static void seed(MainActivity activity) throws Exception {
        List<MediaEntry> entries = (List<MediaEntry>) field(activity, "media");
        entries.add(new MediaEntry(MediaEntry.DCIM_ROOT, "YDXJ0001.MP4", "4096 bytes|2026-11-11"));
        entries.add(new MediaEntry(MediaEntry.DCIM_ROOT, "YDXJ0002.JPG", "2048 bytes|2026-11-11"));
        Field page = MainActivity.class.getDeclaredField("page"); page.setAccessible(true); page.set(activity, "media");
        Method draw = MainActivity.class.getDeclaredMethod("drawMedia"); draw.setAccessible(true); draw.invoke(activity);
    }
    private static Object field(MainActivity activity, String name) throws Exception {
        Field value = MainActivity.class.getDeclaredField(name); value.setAccessible(true); return value.get(activity);
    }
    private static View findText(View root, String text) {
        if (root instanceof TextView && text.contentEquals(((TextView) root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View found = findText(((ViewGroup) root).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }
    private static View findDescription(View root, String description) {
        if (root.getContentDescription() != null && description.contentEquals(root.getContentDescription())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View found = findDescription(((ViewGroup) root).getChildAt(i), description); if (found != null) return found;
        }
        return null;
    }
    private static int countType(View root, Class<?> type) {
        int count = type.isInstance(root) ? 1 : 0;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++)
            count += countType(((ViewGroup) root).getChildAt(i), type);
        return count;
    }
}
