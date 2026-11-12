package dev.yi4k.control;

import org.json.JSONObject;
import org.junit.Test;
import java.util.Arrays;
import static org.junit.Assert.*;

public class CameraOptionPresentationTest {
    @Test public void actualResolutionScalarsKeepAllDigitsAndTheirOriginalWireValues() {
        String[][] source = {
                {"3840x2160 24P 16:9 super", "4K 超高清", "24fps", "超广视角"},
                {"2704x1520 60P 16:9", "2.7K 超清", "60fps"},
                {"2704x2032 30P 4:3", "2.7K 超清", "30fps"},
                {"1920x1440 48P 4:3", "1440p", "48fps"},
                {"1920x1080 120P 16:9", "1080p 全高清", "120fps"},
                {"1920x1080 90P 16:9 super", "1080p 全高清", "90fps", "超广视角"},
                {"1280x960 120P 4:3", "960p", "120fps"},
                {"1280x720 240P 16:9", "720p 高清", "240fps"},
                {"848x480 240P 16:9", "480p 标清", "240fps"},
                {"2560x1440 29.97p 16:9", "2K 超清", "29.97fps"}
        };
        for (String[] row : source) {
            CameraOptionPresentation.Option shown = CameraOptionPresentation.present("video_resolution", row[0], null);
            assertEquals(row[0], shown.wireValue);
            assertEquals(row[1], shown.title);
            assertEquals(Arrays.asList(Arrays.copyOfRange(row, 2, row.length)), shown.tags);
            assertFalse(shown.subtitle.isEmpty());
        }
    }

    @Test public void currentEisSupportNeverLeaksToUnselectedResolutionOrDifferentMode() throws Exception {
        JSONObject current = new JSONObject().put("system_mode", "record").put("rec_mode", "record")
                .put("video_resolution", "3840x2160 30P 16:9").put("iq_eis_enable", "on")
                .put("eis_support_status", "off").put("timelapse_video_resolution", "3840x2160 30P 16:9");
        String before = current.toString();
        assertEquals(Arrays.asList("30fps", "无EIS"), CameraOptionPresentation.present(
                "video_resolution", current.get("video_resolution"), current).tags);
        assertFalse(CameraOptionPresentation.present("video_resolution", "1920x1080 60P 16:9", current).tags.contains("无EIS"));
        assertFalse(CameraOptionPresentation.present("timelapse_video_resolution", current.get("video_resolution"), current).tags.contains("无EIS"));
        assertEquals(before, current.toString());
        current.put("rec_mode", "record_timelapse");
        assertTrue(CameraOptionPresentation.present("timelapse_video_resolution", current.get("video_resolution"), current).tags.contains("无EIS"));
        current.put("system_mode", "capture");
        assertFalse(CameraOptionPresentation.present("timelapse_video_resolution", current.get("video_resolution"), current).tags.contains("无EIS"));
    }

    @Test public void savedEisOffIsNotAnUnsupportedCapabilityAndMissingStateStaysUnknown() throws Exception {
        JSONObject current = new JSONObject().put("video_resolution", "3840x2160 30P 16:9")
                .put("iq_eis_enable", "off");
        for (Object supported : new Object[]{JSONObject.NULL, "", "on", "future_status"}) {
            current.put("eis_support_status", supported);
            assertFalse(CameraOptionPresentation.present("video_resolution", current.get("video_resolution"), current).tags.contains("无EIS"));
        }
        assertFalse(CameraOptionPresentation.present("video_resolution", current.get("video_resolution"), null).tags.contains("无EIS"));
    }

    @Test public void superAndPhotoFovAreExplicitAndSlowMotionMultiplierIsNotFps() {
        CameraOptionPresentation.Option slow = CameraOptionPresentation.present("slow_motion_res", "1280x720x4", null);
        assertEquals("720p 高清", slow.title);
        assertEquals(Arrays.asList("4倍慢动作"), slow.tags);
        assertFalse(slow.tags.toString().contains("fps"));
        CameraOptionPresentation.Option photo = CameraOptionPresentation.present("photo_size", "12MP (4000x3000 4:3) fov:w", null);
        assertEquals("1200万像素", photo.title);
        assertEquals(Arrays.asList("广角"), photo.tags);
        assertFalse(photo.tags.contains("超广视角"));
        assertEquals(Arrays.asList("中等视角"), CameraOptionPresentation.present("photo_size", "7MP (3008x2256 4:3) fov:m", null).tags);
        assertEquals(Arrays.asList("60fps"), CameraOptionPresentation.present("video_resolution", "1920x1080 60P 16:9", null).tags);
    }

    @Test public void futureFormatsAndOtherScalarTypesRemainHonestAndResultListsAreImmutable() {
        for (String value : new String[]{"future camera format", "1920x1080 30P 16:9 future-view", "12K UNKNOWN"}) {
            CameraOptionPresentation.Option result = CameraOptionPresentation.present("video_resolution", value, null);
            assertEquals(value, result.wireValue);
            assertEquals(value, result.title);
            assertTrue(result.tags.isEmpty());
        }
        assertEquals("1920x1080 60P 16:9", CameraOptionPresentation.present("future_key", "1920x1080 60P 16:9", null).title);
        assertEquals("0", CameraOptionPresentation.present("future_key", 0, null).wireValue);
        assertEquals("false", CameraOptionPresentation.present("future_key", false, null).wireValue);
        assertEquals("未返回", CameraOptionPresentation.present("video_resolution", JSONObject.NULL, null).title);
        CameraOptionPresentation.Option result = CameraOptionPresentation.present("video_resolution", "1920x1080 120P 16:9", null);
        try { result.tags.add("无EIS"); fail("caller must not mutate metadata"); }
        catch (UnsupportedOperationException expected) { }
    }
}
