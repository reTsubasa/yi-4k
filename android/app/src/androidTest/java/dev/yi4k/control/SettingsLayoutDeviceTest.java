package dev.yi4k.control;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.test.InstrumentationTestCase;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import org.json.JSONArray;
import org.json.JSONObject;

/** Actual Android settings geometry with explicit local values; no camera access. */
public final class SettingsLayoutDeviceTest extends InstrumentationTestCase {
    public void testChineseNamesAndValuesHaveIndependentVisibleSpace() throws Exception {
        MainActivityTestDriver.grantLocalUiPermissions(getInstrumentation());
        MainActivity activity = (MainActivity) getInstrumentation().startActivitySync(
                new Intent(getInstrumentation().getTargetContext(), MainActivity.class)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
        String[][] fixtures = {
                {"video_flat_color", "yi", "标准（YI）"},
                {"video_photo_resolution", "1920x1080 60P 16:9", "1920x1080 60P 16:9"},
                {"video_stamp", "date/time", "日期与时间"},
                {"burst_capture_number", "3 p / s", "每秒 3 张"},
                {"record_photo_time", "5", "5 秒"},
                {"wifi_country", "CN", "中国"},
                {"voice_language", "cn", "中文"}
        };
        JSONArray evidence = new JSONArray();
        try {
            getInstrumentation().runOnMainSync(() -> {
                try {
                    Field field = MainActivity.class.getDeclaredField("settings"); field.setAccessible(true);
                    JSONObject settings = (JSONObject) field.get(activity);
                    for (String[] fixture : fixtures) settings.put(fixture[0], fixture[1]);
                    Method draw = MainActivity.class.getDeclaredMethod("drawSettings"); draw.setAccessible(true); draw.invoke(activity);
                } catch (Exception error) { throw new AssertionError(error); }
            });
            getInstrumentation().waitForIdleSync();
            View root = activity.getWindow().getDecorView();
            for (String[] fixture : fixtures) {
                String key = fixture[0];
                getInstrumentation().runOnMainSync(() -> {
                    try {
                        Field group = MainActivity.class.getDeclaredField("settingsGroup"); group.setAccessible(true); group.set(activity, "");
                        Method draw = MainActivity.class.getDeclaredMethod("drawSettings"); draw.setAccessible(true); draw.invoke(activity);
                        View category = findDescription(root, SettingsHierarchy.classify(key).groupTitle);
                        assertNotNull(category); assertTrue(category.performClick());
                    } catch (Exception error) { throw new AssertionError(error); }
                });
                getInstrumentation().waitForIdleSync();
                getInstrumentation().runOnMainSync(() -> {
                    TextView name = find(root, CameraSettings.displayName(key)); assertNotNull(name);
                    View row = (View) name.getParent().getParent();
                    row.requestRectangleOnScreen(new Rect(0, 0, row.getWidth(), row.getHeight()), true);
                });
                getInstrumentation().waitForIdleSync();
                getInstrumentation().getUiAutomation().waitForIdle(500, 5000);
                getInstrumentation().runOnMainSync(() -> {
                    try {
                        assertTrue("App Window must have focus for screenshot evidence", root.hasWindowFocus());
                        TextView name = find(root, CameraSettings.displayName(key));
                        assertNotNull(name);
                        ViewGroup row = (ViewGroup) name.getParent();
                        TextView value = find(row, fixture[2]);
                        assertNotNull("Current setting value", value);
                        Field settingsField = MainActivity.class.getDeclaredField("settings"); settingsField.setAccessible(true);
                        JSONObject settings = (JSONObject) settingsField.get(activity);
                        assertEquals("Rendering must preserve wire value", fixture[1], settings.getString(key));
                        if ("voice_language".equals(key)) {
                            assertFalse("Voice row remains read-only", ((View) row.getParent()).isClickable());
                            assertNull("Voice row has no edit arrow", find(row, "›"));
                        }
                        Rect n = new Rect(), v = new Rect();
                        assertTrue(name.getGlobalVisibleRect(n)); assertTrue(value.getGlobalVisibleRect(v));
                        assertEquals(name.getWidth(), n.width()); assertEquals(name.getHeight(), n.height());
                        assertEquals(value.getWidth(), v.width()); assertEquals(value.getHeight(), v.height());
                        assertTrue("Chinese name must not overlap current value", n.right <= v.left);
                        assertFalse("Name/value rectangles overlap", Rect.intersects(n, v));
                        assertTrue("Chinese name has visible width", name.getWidth() > name.getPaddingRight());
                        assertNotNull(name.getLayout()); assertNotNull(value.getLayout());
                        assertEquals(name.length(), name.getLayout().getLineEnd(name.getLineCount() - 1));
                        assertEquals(0, name.getLayout().getEllipsisCount(name.getLineCount() - 1));
                        assertEquals(value.length(), value.getLayout().getLineEnd(value.getLineCount() - 1));
                        assertEquals(0, value.getLayout().getEllipsisCount(value.getLineCount() - 1));
                        evidence.put(new JSONObject().put("key", key).put("name", name.getText())
                                .put("raw_value", fixture[1]).put("value", value.getText()).put("name_bounds", n.toShortString())
                                .put("value_bounds", v.toShortString()).put("non_overlapping", true));
                    } catch (Exception error) { throw new AssertionError(error); }
                });
                Bitmap image = getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(image);
                try (FileOutputStream output = new FileOutputStream(new File(directory(), key + ".png"))) {
                    assertTrue(image.compress(Bitmap.CompressFormat.PNG, 100, output));
                } finally { image.recycle(); }
            }
            JSONObject report = new JSONObject().put("complete", true).put("rows", evidence)
                    .put("scope", "Actual Android settings page with local fixture values; no camera or physical phone");
            try (FileOutputStream output = new FileOutputStream(new File(directory(), "settings-layout.json"))) {
                output.write(report.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        } finally { getInstrumentation().runOnMainSync(activity::finish); }
    }
    private File directory() {
        File directory = new File(getInstrumentation().getTargetContext().getExternalFilesDir(null), "acceptance-screens/settings-layout");
        assertTrue(directory.isDirectory() || directory.mkdirs()); return directory;
    }
    private static View findDescription(View root, String description) {
        if (root.getContentDescription() != null && description.contentEquals(root.getContentDescription())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            View result = findDescription(((ViewGroup) root).getChildAt(i), description); if (result != null) return result;
        }
        return null;
    }
    private static TextView find(View root, String text) {
        if (root instanceof TextView && text.contentEquals(((TextView) root).getText())) return (TextView) root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) root).getChildCount(); i++) {
            TextView result = find(((ViewGroup) root).getChildAt(i), text); if (result != null) return result;
        }
        return null;
    }
}
