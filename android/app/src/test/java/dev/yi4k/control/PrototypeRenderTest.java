package dev.yi4k.control;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.view.ViewGroup;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Method;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.GraphicsMode;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;

/** Native host renders for visual review; these are not phone screenshots. */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 35, qualifiers = "w412dp-h915dp-mdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
public class PrototypeRenderTest {
    @Test public void settingsNamesAndValuesRemainSeparateOnNarrowScreens() throws Exception {
        float original = org.robolectric.RuntimeEnvironment.getFontScale();
        try {
            for (float scale : new float[]{1f, 1.6f}) {
                org.robolectric.RuntimeEnvironment.setFontScale(scale);
                try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
                    MainActivity activity = lifecycle.get();
                    java.lang.reflect.Field field = MainActivity.class.getDeclaredField("settings"); field.setAccessible(true);
                    org.json.JSONObject settings = (org.json.JSONObject) field.get(activity);
                    settings.put("video_flat_color", "yi");
                    settings.put("video_photo_resolution", "1920x1080 60P 16:9");
                    settings.put("video_stamp", "date/time");
                    settings.put("burst_capture_number", "3 p / s");
                    settings.put("record_photo_time", "5");
                    settings.put("wifi_country", "CN");
                    settings.put("voice_language", "cn");
                    Method rowMethod = MainActivity.class.getDeclaredMethod("settingRow", String.class); rowMethod.setAccessible(true);
                    for (String key : new String[]{"video_flat_color", "video_photo_resolution", "video_stamp",
                            "burst_capture_number", "record_photo_time", "wifi_country", "voice_language"}) {
                        for (int width : new int[]{288, 360}) {
                            View row = (View) rowMethod.invoke(activity, key);
                            row.measure(View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY),
                                    View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
                            row.layout(0, 0, width, row.getMeasuredHeight());
                            TextView description = (TextView) find(row, CameraSettings.displayName(key));
                            TextView value = (TextView) find(row, CaptureParameters.settingValue(settings, key));
                            assertNotNull(description); assertNotNull(value);
                            assertEquals("Rendered value must be the localized product value", CameraSettings.displayValue(key, settings.opt(key)), value.getText().toString());
                            if ("voice_language".equals(key)) {
                                assertFalse("Voice row is diagnostic-only", row.isClickable());
                                assertNull("Read-only voice row must not show a disclosure arrow", find(row, "›"));
                            }
                            android.graphics.Rect descriptionBounds = new android.graphics.Rect(0, 0, description.getWidth(), description.getHeight());
                            android.graphics.Rect valueBounds = new android.graphics.Rect(0, 0, value.getWidth(), value.getHeight());
                            ((ViewGroup) row).offsetDescendantRectToMyCoords(description, descriptionBounds);
                            ((ViewGroup) row).offsetDescendantRectToMyCoords(value, valueBounds);
                            assertTrue("Name and value must not overlap", descriptionBounds.right <= valueBounds.left);
                            assertNull("Routine descriptions are removed", find(row, CameraSettings.description(key)));
                            assertTrue(descriptionBounds.right <= width - row.getPaddingRight());
                            android.text.Layout text = description.getLayout(); assertNotNull(text);
                            assertEquals(description.getText().length(), text.getLineEnd(text.getLineCount() - 1));
                            for (int line = 0; line < text.getLineCount(); line++)
                                assertTrue("Every description line must fit", text.getLineWidth(line) <= description.getWidth() + 1);
                            Bitmap bitmap = Bitmap.createBitmap(width, row.getHeight(), Bitmap.Config.ARGB_8888);
                            row.draw(new Canvas(bitmap));
                            File directory = new File("build/reports/prototype-renders"); assertTrue(directory.isDirectory() || directory.mkdirs());
                            try (FileOutputStream output = new FileOutputStream(new File(directory,
                                    "settings-" + key + "-" + width + "-font" + scale + ".png"))) {
                                assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output));
                            } finally { bitmap.recycle(); }
                        }
                    }
                }
            }
        } finally { org.robolectric.RuntimeEnvironment.setFontScale(original); }
    }
    @Test @Config(sdk=35, qualifiers="w700dp-h915dp-mdpi")
    public void shutterAndModesStayVisibleOnCompactAndLandscapeScreens() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            Method control = MainActivity.class.getDeclaredMethod("drawControl"); control.setAccessible(true); control.invoke(activity);
            java.lang.reflect.Field messageField = MainActivity.class.getDeclaredField("message"); messageField.setAccessible(true);
            TextView message = (TextView) messageField.get(activity); message.setText("连接成功\n照片与视频保存在相机"); message.setVisibility(View.VISIBLE);
            View originalSurface = fieldView(activity, "previewSurface");
            for (int[] size : new int[][]{{360,560},{412,700},{700,412}}) {
                View root = activity.getWindow().getDecorView();
                // Let the preview settle after the viewport changes, including
                // any status text above the fixed navigation and capture dock.
                for (int pass=0; pass<3; pass++) {
                    root.measure(View.MeasureSpec.makeMeasureSpec(size[0],View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(size[1],View.MeasureSpec.EXACTLY));
                    root.layout(0,0,size[0],size[1]);
                }
                assertFullyVisible(root, findDescription(root,"开始录像"));
                View preview = fieldView(activity, "capturePreviewFrame");
                View surface = fieldView(activity, "previewSurface");
                assertSame("Window reflow must keep the live RTSP surface", originalSurface, surface);
                assertFullyVisible(root, preview); assertFullyVisible(root, surface);
                assertTrue("Preview must retain useful height", preview.getHeight() >= 72);
                View previewEntry = findDescription(root, "开启相机实时预览");
                assertFullyVisible(root, previewEntry); assertTrue(previewEntry.hasOnClickListeners());
                // The compact/landscape regression must keep the parameter
                // chips and both side shortcuts tappable as well as the dock
                // shutter and mode labels.
                for (String chip : new String[]{"RES --", "FPS --", "FOV --", "EV --", "COLOR --"}) {
                    View target = find(root, chip);
                    target.requestRectangleOnScreen(new android.graphics.Rect(0,0,target.getWidth(),target.getHeight()), true);
                    settle(root,size[0],size[1]); assertFullyVisible(root, target);
                }
                for (String mode : new String[]{"录像","照片","延时","慢动作"}) assertFullyVisible(root,find(root,mode));
                renderSize(activity,"capture-fixed-"+size[0]+"x"+size[1],size[0],size[1]);
            }
            Method settings = MainActivity.class.getDeclaredMethod("drawSettings"); settings.setAccessible(true); settings.invoke(activity);
            assertFalse(findDescription(activity.getWindow().getDecorView(),"开始录像").isShown());
        }
    }
    @Test @Config(sdk=35, qualifiers="w700dp-h915dp-mdpi")
    public void largeFontsKeepPreviewAndCaptureControlsReachableByScrolling() throws Exception {
        float original = org.robolectric.RuntimeEnvironment.getFontScale();
        org.robolectric.RuntimeEnvironment.setFontScale(1.6f);
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            Method control = MainActivity.class.getDeclaredMethod("drawControl"); control.setAccessible(true); control.invoke(activity);
            assertEquals(1.6f, activity.getResources().getConfiguration().fontScale, .01f);
            for (int[] size : new int[][]{{360,560},{700,320}}) {
                View root = activity.getWindow().getDecorView();
                settle(root, size[0], size[1]);
                android.widget.ScrollView contentScroll = (android.widget.ScrollView) fieldView(activity, "scroll");
                contentScroll.scrollTo(0, 0); settle(root, size[0], size[1]);
                View preview = fieldView(activity, "capturePreviewFrame");
                preview.requestRectangleOnScreen(new android.graphics.Rect(0, 0, preview.getWidth(), preview.getHeight()), true);
                settle(root, size[0], size[1]);
                assertFullyVisible(root, preview);
                assertFullyVisible(root, fieldView(activity, "previewSurface"));
                assertTrue(findDescription(root, "开启相机实时预览").hasOnClickListeners());
                for (String chip : new String[]{"RES --", "FPS --", "FOV --", "EV --", "COLOR --"}) {
                    TextView target = (TextView) find(root, chip);
                    target.requestRectangleOnScreen(new android.graphics.Rect(0, 0, target.getWidth(), target.getHeight()), true);
                    settle(root, size[0], size[1]); assertFullyVisible(root, target);
                    assertTrue("Single-line capsule must fit", target.getHeight() >= target.getLineHeight() + target.getPaddingTop() + target.getPaddingBottom());
                    android.text.Layout textLayout = target.getLayout();
                    assertNotNull(textLayout);
                    assertEquals("Parameter value must not be truncated", target.getText().length(), textLayout.getLineEnd(textLayout.getLineCount()-1));
                }
                for (String description : new String[]{"开始录像"}) assertReachable(root, findDescription(root, description), size);
                for (String title : new String[]{"录像", "照片", "延时", "慢动作"}) assertReachable(root, find(root, title), size);
                renderSize(activity, "capture-large-font-scrolled-"+size[0]+"x"+size[1], size[0], size[1]);
                contentScroll.scrollTo(0, 0);
                ((android.widget.ScrollView)fieldView(activity, "captureActionScroll")).scrollTo(0, 0);
                settle(root, size[0], size[1]);
                renderSize(activity, "capture-large-font-"+size[0]+"x"+size[1], size[0], size[1]);
            }
        } finally { org.robolectric.RuntimeEnvironment.setFontScale(original); }
    }
    private static void assertReachable(View root, View target, int[] size) {
        assertNotNull(target);
        target.requestRectangleOnScreen(new android.graphics.Rect(0, 0, target.getWidth(), target.getHeight()), true);
        settle(root, size[0], size[1]); assertFullyVisible(root, target); assertTrue(target.isEnabled());
    }
    private static void settle(View root, int width, int height) {
        for (int pass=0; pass<3; pass++) {
            root.measure(View.MeasureSpec.makeMeasureSpec(width,View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(height,View.MeasureSpec.EXACTLY));
            root.layout(0,0,width,height);
        }
    }
    private static View fieldView(MainActivity activity, String name) throws Exception {
        java.lang.reflect.Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return (View) field.get(activity);
    }
    private static void assertFullyVisible(View root, View target) {
        assertNotNull(target); android.graphics.Rect actual=new android.graphics.Rect();
        assertTrue(target.getGlobalVisibleRect(actual));
        assertEquals("width clipped: " + target.getContentDescription(), target.getWidth(),actual.width());
        assertEquals("height clipped: " + target.getContentDescription(), target.getHeight(),actual.height());
        int[] origin=new int[2];root.getLocationOnScreen(origin);
        assertTrue(actual.top>=origin[1]);assertTrue(actual.bottom<=origin[1]+root.getHeight());
    }
    private static View findDescription(View root,String description) {
        if(root.getContentDescription()!=null && description.contentEquals(root.getContentDescription()))return root;
        if(root instanceof ViewGroup)for(int i=0;i<((ViewGroup)root).getChildCount();i++){
            View result=findDescription(((ViewGroup)root).getChildAt(i),description);if(result!=null)return result;
        }return null;
    }
    @Test public void nearbyConnectionPageIsRootWithoutBackAndCaptureHasNoTitle() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            Method guide = MainActivity.class.getDeclaredMethod("drawConnection", int.class); guide.setAccessible(true);
            guide.invoke(activity, 1); View root = activity.getWindow().getDecorView();
            assertNotNull(find(root, "搜索附近相机"));
            assertNotNull(find(root, "开启相机 Wi-Fi，选择设备即可连接"));
            assertNull(find(root, "相机地址")); assertNull(find(root, "相机 Wi-Fi 已开启")); assertNull(find(root, "APEX"));
            assertFalse("Address must not be offered as a manual input", containsInput(root));
            render(activity, "connection-nearby");
            assertNull(find(root, "‹"));
            call(activity, "drawControl");
            assertNull(find(root, "相机"));
            assertNotNull(find(root, "RES --"));
            render(activity, "capture-disconnected");
            for (String screen : new String[]{"drawMedia", "drawSettings"}) {
                Method method = MainActivity.class.getDeclaredMethod(screen); method.setAccessible(true); method.invoke(activity);
                assertNull(find(root, "APEX"));
                render(activity, screen.equals("drawMedia") ? "album-disconnected" : "settings-disconnected");
            }
        }
    }
    /** Native Android widgets with explicitly simulated camera facts; no physical phone or live stream. */
    @Test public void rendersConnectedCaptureLibrarySettingsAndResolutionTags() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            java.lang.reflect.Field cameraField = MainActivity.class.getDeclaredField("camera"); cameraField.setAccessible(true);
            ((CameraClient) cameraField.get(activity)).connect(javax.net.SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            org.json.JSONObject fixture = new org.json.JSONObject().put("product_name", "YI 4K Action Camera")
                    .put("system_mode", "record").put("rec_mode", "record").put("video_resolution", "3840x2160 30P 16:9")
                    .put("video_quality", "Fine").put("sd_card_status", "insert").put("fov", "wide")
                    .put("iq_video_ev", "0").put("iq_eis_enable", "on").put("eis_support_status", "off")
                    .put("video_flat_color", "yi").put("iq_video_wb", "auto").put("mic_level", "100")
                    .put("screen_auto_lock", "60").put("wifi_mode", "ap").put("streaming_status", "off")
                    .put("camera_clock", "2026-11-11 09:00:00").put("sw_version", "Z16V13L_1.10.7_SIMULATED")
                    .put("hw_version", "SIMULATED").put("future_setting", "future");
            setField(activity, "settings", fixture); setField(activity, "sdUsedPercent", 28); setField(activity, "batteryPercent", 80); setField(activity, "cameraStatus", "vf");
            ((TextView) getField(activity, "state")).setText("已连接 · 取景中");
            ((TextView) getField(activity, "detail")).setText("YI 4K · 4K / 30fps · 电子防抖规格不支持");
            call(activity, "drawControl");
            render(activity, "connected-capture"); assertPaintedModeLabels(activity); assertNull(find(activity.getWindow().getDecorView(), "APEX"));

            java.util.List<MediaEntry> entries = (java.util.List<MediaEntry>) getField(activity, "media");
            entries.add(new MediaEntry(MediaEntry.DCIM_ROOT, "100MEDIA/", "3|date"));
            setField(activity, "page", "media"); call(activity, "drawMedia"); render(activity, "library-folders");
            entries.clear(); setField(activity, "folder", MediaEntry.DCIM_ROOT + "100MEDIA/");
            entries.add(new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "YI4K_20261111_090001.MP4", "48234496 bytes|2026-11-11"));
            entries.add(new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "YI4K_20261111_090102.JPG", "4128768 bytes|2026-11-11"));
            entries.add(new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "YI4K_20261111_090203.MP4", "8388608 bytes|2026-11-11"));
            call(activity, "drawMedia"); render(activity, "library");

            setField(activity, "page", "settings"); setField(activity, "settingsGroup", ""); call(activity, "drawSettings");
            render(activity, "settings-categories");
            View group = findDescription(activity.getWindow().getDecorView(), "影像参数"); assertNotNull(group); assertTrue(group.performClick());
            render(activity, "settings-details-image");
            click(activity, "‹"); group = findDescription(activity.getWindow().getDecorView(), "拍摄设置");
            assertNotNull(group); assertTrue(group.performClick()); render(activity, "settings-details-capture");

            Method picker = MainActivity.class.getDeclaredMethod("showResolutionOptions", String.class, java.util.List.class);
            picker.setAccessible(true); picker.invoke(activity, "video_resolution", java.util.Arrays.asList(
                    "3840x2160 30P 16:9", "2704x1520 60P 16:9", "1920x1080 60P 16:9 super", "1280x720 120P 16:9"));
            android.app.AlertDialog dialog = org.robolectric.shadows.ShadowAlertDialog.getLatestAlertDialog();
            renderView(dialog.getWindow().getDecorView(), "resolution-tags", 412, 867); dialog.dismiss();
        }
    }
    @Test @Config(sdk=35, qualifiers="w900dp-h915dp-mdpi")
    public void fullscreenReusesSurfaceAndKeepsControlsOverEntireViewfinder() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get(); call(activity, "drawControl");
            View root = activity.getWindow().getDecorView();
            View surface = fieldView(activity, "previewSurface");
            for (int pass=0; pass<2; pass++) {
                call(activity, "toggleMonitorMode");
                for (int[] size : new int[][]{{844,390},{390,844},{700,320}}) {
                    settle(root,size[0],size[1]);
                    View layer = fieldView(activity,"monitorLayer");
                    View preview = fieldView(activity,"capturePreviewFrame");
                    assertSame(surface,fieldView(activity,"previewSurface"));
                    assertEquals(layer.getWidth(),preview.getWidth()); assertEquals(layer.getHeight(),preview.getHeight());
                    assertFullyVisible(root,fieldView(activity,"primaryShutter"));
                    renderSize(activity,"fullscreen-before-"+size[0]+"x"+size[1],size[0],size[1]);
                    for (String title : new String[]{"录像","照片","延时","慢动作"}) {
                        View target=find(root,title);
                        try { assertFullyVisible(root,target); } catch (AssertionError error) {
                            StringBuilder tree=new StringBuilder(title+" at "+size[0]+"x"+size[1]);
                            for(View cur=target;cur!=null;cur=cur.getParent() instanceof View ? (View)cur.getParent():null) {
                                android.graphics.Rect bounds=new android.graphics.Rect();cur.getGlobalVisibleRect(bounds);
                                tree.append("\n").append(cur.getClass().getSimpleName()).append(" ").append(cur.getWidth()).append("x").append(cur.getHeight()).append(" xy=").append(cur.getX()).append(",").append(cur.getY()).append(" visible=").append(bounds);
                            }
                            throw new AssertionError(tree.toString(),error);
                        }
                    }
                    ViewGroup params = (ViewGroup) fieldView(activity,"captureParameterBar");
                    for (int i=0;i<params.getChildCount();i++) {
                        View chip=params.getChildAt(i);
                        chip.requestRectangleOnScreen(new android.graphics.Rect(0,0,chip.getWidth(),chip.getHeight()),true);
                        settle(root,size[0],size[1]); assertFullyVisible(root,chip);
                    }
                    assertEquals(View.GONE,fieldView(activity,"statusSlot").getVisibility());
                    renderSize(activity,"fullscreen-"+size[0]+"x"+size[1],size[0],size[1]);
                }
                call(activity,"toggleMonitorMode"); settle(root,390,844);
                assertSame(surface,fieldView(activity,"previewSurface"));
                assertFullyVisible(root,fieldView(activity,"primaryShutter"));
                ViewGroup actions=(ViewGroup)fieldView(activity,"captureActions");
                assertEquals(android.view.ViewGroup.LayoutParams.MATCH_PARENT,actions.getLayoutParams().width);
                for(String title:new String[]{"录像","照片","延时","慢动作"}) assertFullyVisible(root,find(root,title));
            }
            ((TextView)fieldView(activity,"previewScale")).performClick();
            call(activity,"drawSettings"); call(activity,"drawControl");
            assertEquals("完整",((TextView)fieldView(activity,"previewScale")).getText().toString());
            call(activity,"toggleMonitorMode"); call(activity,"drawSettings");
            assertEquals(View.GONE,fieldView(activity,"monitorLayer").getVisibility());
            assertEquals(View.VISIBLE,fieldView(activity,"bottomNav").getVisibility());
        }
    }

    private static void assertPaintedModeLabels(MainActivity activity) throws Exception {
        View root = activity.getWindow().getDecorView();
        Bitmap pixels = Bitmap.createBitmap(root.getWidth(), root.getHeight(), Bitmap.Config.ARGB_8888);
        root.draw(new Canvas(pixels)); int[] origin = new int[2]; root.getLocationOnScreen(origin);
        try {
            ViewGroup modes = (ViewGroup) getField(activity, "captureModes");
            for (int i = 0; i < modes.getChildCount(); i++) {
                TextView button = (TextView) modes.getChildAt(i); assertNotNull(button.getLayout());
                assertTrue("Mode baseline must stay inside its button: " + button.getText(),
                        button.getBaseline() >= 0 && button.getBaseline() < button.getHeight());
                assertFullyVisible(root, button);
                int[] location = new int[2]; button.getLocationOnScreen(location);
                int x0 = location[0] - origin[0], y0 = location[1] - origin[1], matching = 0;
                int color = button.getCurrentTextColor();
                // The center of a selected pill is black; an unselected pill is white.
                // Count actual foreground ink in the final window to catch parent clipping.
                for (int y = y0 + button.getHeight()/4; y < y0 + button.getHeight()*3/4; y++)
                    for (int x = x0 + button.getWidth()/4; x < x0 + button.getWidth()*3/4; x++) {
                        int pixel = pixels.getPixel(x, y);
                        if (Math.abs(android.graphics.Color.red(pixel)-android.graphics.Color.red(color)) < 20
                                && Math.abs(android.graphics.Color.green(pixel)-android.graphics.Color.green(color)) < 20
                                && Math.abs(android.graphics.Color.blue(pixel)-android.graphics.Color.blue(color)) < 20) matching++;
                    }
                assertTrue("Mode label must paint visible foreground pixels in its button: " + button.getText()
                        + " color=" + Integer.toHexString(color) + " matching=" + matching, matching > 8);
            }
        } finally { pixels.recycle(); }
    }
    private static Object getField(MainActivity activity, String name) throws Exception {
        java.lang.reflect.Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return field.get(activity);
    }
    private static void setField(MainActivity activity, String name, Object value) throws Exception {
        java.lang.reflect.Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); field.set(activity, value);
    }
    private static void call(MainActivity activity, String name) throws Exception {
        Method method = MainActivity.class.getDeclaredMethod(name); method.setAccessible(true); method.invoke(activity);
    }
    private static boolean containsInput(View view) {
        if (view instanceof android.widget.EditText) return true;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++)
            if (containsInput(((ViewGroup) view).getChildAt(i))) return true;
        return false;
    }
    private static void click(MainActivity activity, String title) {
        View view = find(activity.getWindow().getDecorView(), title); assertTrue(title, view instanceof Button);
        assertTrue(view.performClick());
    }
    private static View find(View view, String title) {
        if (view instanceof TextView && title.contentEquals(((TextView) view).getText())) return view;
        if (view instanceof ViewGroup) for (int i=0; i<((ViewGroup)view).getChildCount(); i++) {
            View result = find(((ViewGroup)view).getChildAt(i), title); if (result != null) return result;
        }
        return null;
    }
    private static void render(MainActivity activity, String name) throws Exception {
        renderSize(activity,name,412,867);
    }
    private static void renderSize(MainActivity activity,String name,int width,int height) throws Exception {
        // Render the same window tree used by the visibility assertions;
        // measuring its content independently changes weighted scroll sizing.
        renderView(activity.getWindow().getDecorView(), name, width, height);
    }
    private static void renderView(View root, String name, int width, int height) throws Exception {
        settle(root, width, height);
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        root.draw(new Canvas(bitmap));
        File directory = new File("build/reports/prototype-renders"); assertTrue(directory.isDirectory() || directory.mkdirs());
        try (FileOutputStream stream = new FileOutputStream(new File(directory, name + ".png"))) {
            assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream));
        }
        bitmap.recycle();
    }
}
