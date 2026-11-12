package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import static org.junit.Assert.*;

public class SettingsHierarchyTest {
    // Key inventory from the pinned 1.10.7 read-only feature capture, including
    // statuses, currently unset fields and actions that must remain read-only.
    private static final String REAL_KEYS = "camera_clock video_standard app_status video_resolution video_stamp video_quality timelapse_video capture_mode photo_size photo_stamp photo_quality precise_cont_time precise_cont_poweroff precise_cont_poweroff_settable buzzer_volume buzzer_ring burst_capture_number restore_factory_settings restore_wifi restore_bt sta_ip wifi_mode led_mode meter_mode sd_card_status sw_version hw_version dual_stream_status streaming_status precise_cont_capturing piv_enable auto_low_light warp_enable support_auto_low_light precise_selftime precise_self_running auto_power_off system_mode system_default_mode precise_self_remain_time sdcard_need_format video_rotate rec_mode record_photo_time dev_functions timelapse_video_duration timelapse_video_resolution video_photo_resolution slow_motion_rate slow_motion_res loop_rec_duration iq_eis_enable iq_photo_iso_min iq_photo_iso iq_video_iso iq_photo_shutter iq_photo_ev iq_video_ev iq_photo_wb iq_video_wb protune screen_auto_lock dewarp_support_status eis_support_status mic_level photo_flat_color video_flat_color long_shutter_define product_name stamp_enable ev_enable fov wifi_country wifi_country_editable rec_audio_support photo_sharpness video_sharpness support_flat_color support_sharpness timelapse_photo_shutter support_fov support_iso support_wb quick_view video_file_max_size language photo_file_type photo_file_type_settable sound_effect sound_effect_support";

    private static List<String> flatten(List<SettingsHierarchy.Group> groups) {
        List<String> keys = new ArrayList<>();
        for (SettingsHierarchy.Group group : groups) for (SettingsHierarchy.Section section : group.sections) keys.addAll(section.keys);
        return keys;
    }

    @Test public void curatedInventoryAccountsForEveryRawKeyWithoutChangingValues() throws Exception {
        JSONObject settings = new JSONObject();
        for (String key : REAL_KEYS.split(" ")) settings.put(key, key.equals("sta_ip") ? "" : JSONObject.NULL);
        settings.put("future_debug_status", new JSONObject().put("nested", true));
        settings.put("future_option_array", new JSONArray().put(1));
        settings.put("future_adjustable", false);
        String before = settings.toString();
        List<SettingsHierarchy.Group> groups = SettingsHierarchy.build(settings);
        List<String> keys = flatten(groups);
        List<String> expected = new ArrayList<>();
        for (String key : CameraSettings.keys(settings)) {
            if (SettingsHierarchy.hiddenReason(key, settings).isEmpty()) expected.add(key);
            else assertFalse(keys.contains(key));
        }
        assertEquals(expected.size(), keys.size());
        assertEquals(keys.size(), new HashSet<>(keys).size());
        assertEquals(new HashSet<>(expected), new HashSet<>(keys));
        assertEquals(before, settings.toString());
        for (String key : REAL_KEYS.split(" ")) assertNotEquals("other", SettingsHierarchy.classify(key).groupId);
        assertEquals("other", SettingsHierarchy.classify("future_adjustable").groupId);
        assertFalse(keys.contains("restore_factory_settings"));
        for (String key : expected) if (!key.startsWith("future_")) assertTrue(key, CameraSettings.hasLabel(key));
        assertFalse(CameraSettings.safeKey("restore_factory_settings"));
        assertTrue(CameraSettings.safeKey("video_resolution"));
    }

    @Test public void categoriesHaveStableUsefulPathsAndEmptySectionsDoNotCreateDeadEnds() throws Exception {
        JSONObject settings = new JSONObject().put("video_resolution", "1920x1080 60P 16:9")
                .put("fov", "medium").put("wifi_mode", "ap").put("sw_version", "1.10.7").put("unknown", 9);
        List<SettingsHierarchy.Group> groups = SettingsHierarchy.build(settings);
        List<String> ids = new ArrayList<>();
        for (SettingsHierarchy.Group group : groups) {
            ids.add(group.id);
            assertFalse(group.sections.isEmpty());
            for (SettingsHierarchy.Section section : group.sections) assertFalse(section.keys.isEmpty());
        }
        assertEquals(Arrays.asList("capture", "image", "connection", "information", "other"), ids);
        assertEquals("照片与连拍", SettingsHierarchy.classify("photo_file_type").sectionTitle);
        assertEquals("镜头与防抖", SettingsHierarchy.classify("IQ_EIS_ENABLE").sectionTitle);
        assertEquals("相机信息", SettingsHierarchy.classify("eis_support_status").groupTitle);
        assertEquals(Collections.emptyList(), SettingsHierarchy.build(null));
        assertEquals(Collections.emptyList(), SettingsHierarchy.build(new JSONObject()));
    }

    @Test public void searchFindsChineseNamesDescriptionsWireKeysValuesAndNewResolutionLabels() throws Exception {
        JSONObject settings = new JSONObject().put("video_resolution", "3840x2160 24P 16:9 super")
                .put("iq_video_iso", "auto").put("wifi_mode", "ap").put("future_answer", "Custom-42");
        assertEquals(Arrays.asList("video_resolution"), flatten(SettingsHierarchy.build(settings, "4K 超广")));
        assertEquals(Arrays.asList("video_resolution"), flatten(SettingsHierarchy.build(settings, "录像 24fps")));
        assertEquals(Arrays.asList("iq_video_iso"), flatten(SettingsHierarchy.build(settings, "感光度 噪点")));
        assertEquals(Arrays.asList("iq_video_iso"), flatten(SettingsHierarchy.build(settings, "IQ_VIDEO_ISO AUTO")));
        assertEquals(Arrays.asList("wifi_mode"), flatten(SettingsHierarchy.build(settings, "连接　相机热点")));
        assertEquals(Arrays.asList("future_answer"), flatten(SettingsHierarchy.build(settings, "CUSTOM-42")));
        assertTrue(SettingsHierarchy.build(settings, "4K 120fps").isEmpty());
        assertEquals(settings.length(), flatten(SettingsHierarchy.build(settings, " \t ")).size());
    }

    @Test public void hierarchyCollectionsCannotBeMutatedOrHideKeysOnSubsequentBuild() throws Exception {
        JSONObject settings = new JSONObject().put("video_resolution", "1920x1080 60P 16:9");
        List<SettingsHierarchy.Group> result = SettingsHierarchy.build(settings);
        try { result.clear(); fail(); } catch (UnsupportedOperationException expected) { }
        try { result.get(0).sections.clear(); fail(); } catch (UnsupportedOperationException expected) { }
        try { result.get(0).sections.get(0).keys.clear(); fail(); } catch (UnsupportedOperationException expected) { }
        assertEquals(Arrays.asList("video_resolution"), flatten(SettingsHierarchy.build(settings)));
    }

    @Test public void aliasesAndInactiveNetworkFieldsDoNotCreateDuplicateRows() throws Exception {
        JSONObject values = new JSONObject().put("video_mode", "record").put("rec_mode", "record")
                .put("sta_password", "").put("sta_connect_password", "").put("wifi_mode", "ap")
                .put("wifi_ssid", "YDXJ").put("wifi_password", "1234567890").put("serial_number", "SERIAL");
        List<String> keys = flatten(SettingsHierarchy.build(values));
        assertFalse(keys.contains("video_mode")); assertTrue(keys.contains("rec_mode"));
        assertFalse(keys.contains("sta_password")); assertFalse(keys.contains("sta_connect_password"));
        assertTrue(keys.contains("wifi_ssid")); assertTrue(keys.contains("wifi_password"));
        assertEquals("相机序列号", CameraSettings.displayName("serial_number"));
        assertEquals("相机热点名称", CameraSettings.displayName("wifi_ssid"));
        assertTrue(CameraSettings.readOnly("serial_number"));
        assertEquals("••••••••", CameraSettings.displayValue("wifi_password", "1234567890"));
        values.put("wifi_mode", "sta");
        assertTrue(flatten(SettingsHierarchy.build(values)).contains("sta_password"));
    }

    @Test public void voiceFieldsRemainReachableUnderMoreSettings() throws Exception {
        JSONObject settings = new JSONObject().put("voice_control", "off").put("voice_language", "cn");
        List<SettingsHierarchy.Group> groups = SettingsHierarchy.build(settings);
        assertEquals("other", groups.get(0).id);
        assertEquals("voice", groups.get(0).sections.get(0).id);
        assertEquals(Arrays.asList("voice_control", "voice_language"), groups.get(0).sections.get(0).keys);
        assertEquals("语音控制", CameraSettings.displayName("voice_control"));
        assertTrue(CameraSettings.description("voice_control").contains("不会采集"));
        assertFalse("voice fields must stay diagnostic-only", CameraSettings.safeKey("voice_control"));
    }
}
