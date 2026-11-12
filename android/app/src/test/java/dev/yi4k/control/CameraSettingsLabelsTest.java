package dev.yi4k.control;

import org.json.JSONObject;
import org.junit.Test;
import java.util.Arrays;
import static org.junit.Assert.*;

public class CameraSettingsLabelsTest {
    @Test public void actualStampBurstCountryAndVoiceValuesUseChineseLabels() {
        assertEquals("日期与时间", CameraSettings.displayValue("video_stamp", "date/time"));
        assertEquals("仅日期", CameraSettings.displayValue("photo_stamp", "date"));
        assertEquals("每秒 3 张", CameraSettings.displayValue("burst_capture_number", "3 p / s"));
        assertEquals("5 秒", CameraSettings.displayValue("record_photo_time", "5"));
        assertEquals("中国", CameraSettings.displayValue("wifi_country", "CN"));
        assertEquals("中文", CameraSettings.displayValue("voice_language", "cn"));
        assertEquals("英语", CameraSettings.displayValue("voice_language", "EN"));
    }

    @Test public void localizedValuesNeverGuessUnknownFirmwareFormatsOrAlterWireOptions() throws Exception {
        assertEquals("future_stamp", CameraSettings.displayValue("video_stamp", "future_stamp"));
        assertEquals("3 p / future", CameraSettings.displayValue("burst_capture_number", "3 p / future"));
        assertEquals("ZZ", CameraSettings.displayValue("wifi_country", "ZZ"));
        assertEquals("cn", CameraSettings.displayValue("future_language", "cn"));
        JSONObject response = new JSONObject("{\"permission\":\"settable\",\"options\":[\"off\",\"date\",\"date/time\"]}");
        assertEquals(Arrays.asList("off", "date", "date/time"), CameraSettings.writableOptions("video_stamp", response));
    }

    @Test public void actualImageSettingsHaveUsefulNamesAndDescriptions() {
        assertEquals("视频曝光补偿", CameraSettings.displayName("iq_video_ev"));
        assertEquals("照片曝光补偿", CameraSettings.displayName("iq_photo_ev"));
        assertTrue(CameraSettings.description("iq_video_ev").contains("负值使画面变暗"));
        assertTrue(CameraSettings.description("iq_photo_ev").contains("EV"));
        assertEquals("视频白平衡", CameraSettings.displayName("iq_video_wb"));
        assertEquals("照片快门时间", CameraSettings.displayName("iq_photo_shutter"));
        assertTrue(CameraSettings.description("iq_video_iso").contains("噪点"));
        assertEquals("-0.5", CameraSettings.displayValue("iq_video_ev", "-0.5"));
        assertEquals("+1.0", CameraSettings.displayValue("iq_photo_ev", "+1.0"));
        assertEquals("0", CameraSettings.displayValue("iq_video_ev", 0));
    }

    @Test public void sameWireWordUsesItsSettingsContext() {
        assertEquals("中等视角", CameraSettings.displayValue("fov", "medium"));
        assertEquals("中", CameraSettings.displayValue("video_sharpness", "medium"));
        assertEquals("普通录像", CameraSettings.displayValue("rec_mode", "record"));
        assertEquals("录像中", CameraSettings.displayValue("app_status", "record"));
        assertEquals("录像", CameraSettings.displayValue("system_mode", "record"));
        assertEquals("NTSC 制式", CameraSettings.displayValue("video_standard", "NTSC"));
        assertEquals("PAL 制式", CameraSettings.displayValue("video_standard", "pal"));
        assertEquals("间隔拍照", CameraSettings.displayValue("capture_mode", "precise quality cont."));
        assertEquals("单张拍照", CameraSettings.displayValue("capture_mode", "precise quality"));
    }

    @Test public void eachRecordingModeExplainsItsOwnVideoSpecification() {
        assertEquals("录像中拍照的视频规格", CameraSettings.displayName("video_photo_resolution"));
        assertTrue(CameraSettings.description("video_photo_resolution").contains("录像中拍照模式"));
        assertEquals("延时视频规格", CameraSettings.displayName("timelapse_video_resolution"));
        assertTrue(CameraSettings.description("rec_mode").contains("慢动作"));
        assertEquals("1920x1080 120P 16:9", CameraSettings.displayValue("video_resolution", "1920x1080 120P 16:9"));
        assertEquals("1280×720 · 4 倍慢动作", CameraSettings.displayValue("slow_motion_res", "1280x720x4"));
        assertEquals("4 倍", CameraSettings.displayValue("slow_motion_rate", "4"));
        assertTrue(CameraSettings.description("slow_motion_res").contains("不等于拍摄帧率"));
    }

    @Test public void confirmedStructuredValuesAreReadableWithoutGuessingFutureFormats() {
        assertEquals("1200 万像素 · 4000×3000 · 4:3 · 广角",
                CameraSettings.displayValue("photo_size", "12MP (4000x3000 4:3) fov:w"));
        assertEquals("700 万像素 · 3008×2256 · 4:3 · 中等视角",
                CameraSettings.displayValue("photo_size", "7MP (3008x2256 4:3) fov:m"));
        assertEquals("12MP (4000x3000 4:3) fov:w future",
                CameraSettings.displayValue("photo_size", "12MP (4000x3000 4:3) fov:w future"));
        assertEquals("5500 K", CameraSettings.displayValue("iq_video_wb", "5500k"));
        assertEquals("原生白平衡", CameraSettings.displayValue("iq_photo_wb", "native"));
        assertEquals("平均测光", CameraSettings.displayValue("meter_mode", "average"));
        assertEquals("标准（YI）", CameraSettings.displayValue("video_flat_color", "yi"));
    }

    @Test public void durationAndFileSizeNeverShareAnUnlimitedLabel() {
        assertEquals("最长时长（max）", CameraSettings.displayValue("loop_rec_duration", "max"));
        assertEquals("最大值（max）", CameraSettings.displayValue("video_file_max_size", "max"));
        assertEquals("20 分钟", CameraSettings.displayValue("loop_rec_duration", "20 minutes"));
        assertEquals("future5days", CameraSettings.displayValue("loop_rec_duration", "future5days"));
        assertEquals("0.5 秒", CameraSettings.displayValue("precise_cont_time", "0.5 sec"));
        assertEquals("2 秒", CameraSettings.displayValue("timelapse_video", "2"));
        assertEquals("60 秒", CameraSettings.displayValue("screen_auto_lock", "60s"));
    }

    @Test public void missingAndUnknownValuesRemainHonest() {
        assertEquals("未返回", CameraSettings.displayValue("fov", null));
        assertEquals("未返回", CameraSettings.displayValue("fov", JSONObject.NULL));
        assertEquals("未设置", CameraSettings.displayValue("fov", "  "));
        assertEquals("future_fov", CameraSettings.displayValue("fov", "future_fov"));
        assertEquals("medium", CameraSettings.displayValue("future_setting", "medium"));
        assertEquals("record", CameraSettings.displayValue("future_setting", "record"));
        assertEquals("max", CameraSettings.displayValue("future_setting", "max"));
        assertTrue(CameraSettings.displayName("future_setting").contains("future_setting"));
    }

    @Test public void readableLabelsNeverChangeOptionsOrDestructiveActionFiltering() throws Exception {
        JSONObject advertised = new JSONObject("{\"permission\":\"settable\",\"options\":[\"wide\",\"medium\",\"narrow\"]}");
        assertEquals(Arrays.asList("wide", "medium", "narrow"), CameraSettings.writableOptions("fov", advertised));
        assertEquals("medium", advertised.getJSONArray("options").getString(1));
        assertTrue(CameraSettings.writableOptions("restore_factory_settings", advertised).isEmpty());
        assertTrue(CameraSettings.writableOptions("restore_wifi", advertised).isEmpty());
        assertTrue(CameraSettings.writableOptions("restore_bt", advertised).isEmpty());
        JSONObject scalar = new JSONObject("{\"permission\":\"settable\",\"options\":[1,true,\"off\",null,{},\"reboot\"]}");
        assertEquals(Arrays.asList(1, true, "off"), CameraSettings.writableOptions("video_quality", scalar));
    }
}
