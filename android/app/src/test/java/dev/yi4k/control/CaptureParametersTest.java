package dev.yi4k.control;

import org.json.JSONObject;
import org.junit.Test;
import static org.junit.Assert.*;

public class CaptureParametersTest {
    @Test public void unsupportedCurrentModeDoesNotPresentSavedEisPreferenceAsActive() throws Exception {
        JSONObject settings = new JSONObject().put("video_resolution", "3840x2160 30P 16:9")
                .put("iq_eis_enable", "on").put("eis_support_status", "off");
        assertEquals("规格不支持", CaptureParameters.value(settings, "iq_eis_enable"));
        assertEquals("已保存：开启；当前规格不支持", CaptureParameters.settingValue(settings, "iq_eis_enable"));
        assertEquals("on", settings.getString("iq_eis_enable"));
        settings.put("iq_eis_enable", "off");
        assertEquals("已保存：关闭；当前规格不支持", CaptureParameters.settingValue(settings, "iq_eis_enable"));
        settings.put("eis_support_status", "on");
        assertEquals("关闭", CaptureParameters.value(settings, "iq_eis_enable"));
        settings.remove("eis_support_status"); settings.put("iq_eis_enable", "on");
        assertEquals("开启", CaptureParameters.value(settings, "iq_eis_enable"));
        assertEquals("开启", CaptureParameters.settingValue(settings, "iq_eis_enable"));
        settings.remove("iq_eis_enable"); settings.put("eis_support_status", "off");
        assertEquals("--", CaptureParameters.value(settings, "iq_eis_enable"));
    }

    @Test public void unavailableVoiceFieldsRemainTruthfulAndPublishedValuesStillTranslate() throws Exception {
        JSONObject settings = new JSONObject().put("sw_version", "Z16V13L_1.10.7")
                .put("voice_control", JSONObject.NULL);
        assertEquals("相机未公开", CaptureParameters.settingValue(settings, "voice_control"));
        assertEquals("相机未公开", CaptureParameters.settingValue(settings, "voice_language"));
        settings.put("voice_control", "off");
        assertEquals("关闭", CaptureParameters.settingValue(settings, "voice_control"));
    }
    private JSONObject resolution(String value) throws Exception {
        return new JSONObject().put("video_resolution", value);
    }

    @Test public void missingAndNullFieldsNeverInventCameraValues() throws Exception {
        for (JSONObject settings : new JSONObject[]{null, new JSONObject(),
                new JSONObject().put("video_resolution", JSONObject.NULL),
                new JSONObject().put("video_resolution", "  ")}) {
            assertEquals("--", CaptureParameters.resolution(settings));
            assertEquals("--", CaptureParameters.fps(settings));
            assertEquals("--", CaptureParameters.value(settings, "fov"));
            assertEquals("--", CaptureParameters.value(settings, "iq_video_ev"));
            assertEquals("", CaptureParameters.captureMode(settings));
        }
        assertEquals("--", CaptureParameters.value(new JSONObject().put("fov", new JSONObject()), "fov"));
    }

    @Test public void compactResolutionPreservesUnknownDimensionsAndWireValue() throws Exception {
        JSONObject source = resolution("1920x1080 30P 16:9");
        assertEquals("1080p", CaptureParameters.resolution(source));
        assertEquals("1920x1080 30P 16:9", source.getString("video_resolution"));
        assertEquals("4K", CaptureParameters.resolution(resolution("3840x2160 24P 16:9 super")));
        assertEquals("720p", CaptureParameters.resolution(resolution("1280x720 240P 16:9")));
        assertEquals("2704x2032", CaptureParameters.resolution(resolution("2704x2032 30P 4:3")));
        assertEquals("future camera format", CaptureParameters.resolution(resolution("future camera format")));
    }

    @Test public void frameRatesUseFullResolutionWithoutClippingDigits() throws Exception {
        assertEquals("120", CaptureParameters.fps(resolution("1920x1080 120P 16:9")));
        assertEquals("240", CaptureParameters.fps(resolution("1280x720 240P 16:9")));
        assertEquals("29.97", CaptureParameters.fps(resolution("1920x1080 29.97p 16:9")));
        assertEquals("30", CaptureParameters.fps(resolution("1920x1080 30 16:9")));
        assertEquals("--", CaptureParameters.fps(resolution("1920x1080")));
        assertEquals("--", CaptureParameters.fps(resolution("future camera format")));
    }

    @Test public void actualFovAndExposureValuesOverridePrototypeDefaults() throws Exception {
        JSONObject settings = new JSONObject().put("fov", "medium")
                .put("iq_video_ev", "-0.5").put("iq_photo_ev", "+1.0").put("iq_eis_enable", "off");
        assertEquals("中等视角", CaptureParameters.value(settings, "fov"));
        assertEquals("-0.5", CaptureParameters.value(settings, "iq_video_ev"));
        assertEquals("+1.0", CaptureParameters.value(settings, "iq_photo_ev"));
        assertEquals("关闭", CaptureParameters.value(settings, "iq_eis_enable"));
        assertEquals("--", CaptureParameters.value(settings, "ev"));
        assertEquals("0", CaptureParameters.value(new JSONObject().put("iq_video_ev", 0), "iq_video_ev"));
        assertEquals("--", CaptureParameters.value(new JSONObject().put("iq_video_ev", JSONObject.NULL), "iq_video_ev"));
    }

    @Test public void selectedModeComesFromConfirmedSystemAndRecordSubmode() throws Exception {
        JSONObject settings = new JSONObject().put("system_mode", "record");
        assertEquals("", CaptureParameters.captureMode(settings));
        for (String[] mode : new String[][]{{"record", "record"}, {"record_timelapse", "timelapse"},
                {"record_slow_motion", "slow_motion"}, {"record_loop", "record_loop"},
                {"record_photo", "record_photo"}, {"future_mode", "future_mode"}}) {
            settings.put("rec_mode", mode[0]);
            assertEquals(mode[1], CaptureParameters.captureMode(settings));
        }
        settings.put("system_mode", "capture");
        assertEquals("capture", CaptureParameters.captureMode(settings));
        settings.put("system_mode", "future_system_mode");
        assertEquals("future_system_mode", CaptureParameters.captureMode(settings));
    }

    @Test public void modeSpecificResolutionNeverFallsBackToOrdinaryVideo() throws Exception {
        // Values copied from the pinned 1.10.7 read-only feature API capture.
        JSONObject settings = new JSONObject().put("system_mode", "record").put("rec_mode", "record")
                .put("video_resolution", "1920x1080 30P 16:9")
                .put("timelapse_video_resolution", "3840x2160 30P 16:9")
                .put("video_photo_resolution", "1920x1080 60P 16:9")
                .put("slow_motion_res", "1280x720x4")
                .put("photo_size", "12MP (4000x3000 4:3) fov:w");
        assertEquals("video_resolution", CaptureParameters.resolutionKey(settings));
        assertEquals("1080p", CaptureParameters.resolution(settings));
        assertEquals("30", CaptureParameters.fps(settings));
        settings.put("rec_mode", "record_timelapse");
        assertEquals("timelapse_video_resolution", CaptureParameters.resolutionKey(settings));
        assertEquals("4K", CaptureParameters.resolution(settings));
        assertEquals("30", CaptureParameters.fps(settings));
        settings.remove("timelapse_video_resolution");
        assertEquals("--", CaptureParameters.resolution(settings));
        assertEquals("--", CaptureParameters.fps(settings));
        settings.put("rec_mode", "record_slow_motion");
        assertEquals("slow_motion_res", CaptureParameters.resolutionKey(settings));
        assertEquals("720p", CaptureParameters.resolution(settings));
        assertEquals("--", CaptureParameters.fps(settings));
        settings.put("rec_mode", "record_photo");
        assertEquals("video_photo_resolution", CaptureParameters.resolutionKey(settings));
        assertEquals("60", CaptureParameters.fps(settings));
        settings.put("system_mode", "capture");
        assertEquals("photo_size", CaptureParameters.resolutionKey(settings));
        assertEquals("1200万", CaptureParameters.resolution(settings));
        assertEquals("--", CaptureParameters.fps(settings));
        assertEquals("12MP (4000x3000 4:3) fov:w", settings.getString("photo_size"));
    }
}
