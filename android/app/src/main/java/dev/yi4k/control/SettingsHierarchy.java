package dev.yi4k.control;

import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/** Curated user controls; raw settings stay intact for capability checks and diagnostics. */
public final class SettingsHierarchy {
    private static final Map<String, Location> LOCATIONS = new LinkedHashMap<>();
    private static final List<Location> ORDER = new ArrayList<>();
    private static final Location OTHER;

    static {
        register("capture", "拍摄设置", "video", "录像规格",
                "system_mode rec_mode video_mode video_resolution video_quality video_standard video_rotate video_stamp video_file_max_size");
        register("capture", "拍摄设置", "special_video", "特殊录像",
                "loop_rec_duration timelapse_interval timelapse_video timelapse_video_duration timelapse_video_resolution slow_motion_res slow_motion_rate video_photo_resolution record_photo_time piv_enable");
        register("capture", "拍摄设置", "photo", "照片与连拍",
                "capture_mode photo_resolution photo_size photo_quality photo_stamp photo_file_type photo_file_type_settable precise_selftime precise_cont_time precise_cont_poweroff precise_cont_poweroff_settable burst_capture_number quick_view timelapse_photo_shutter long_shutter_define");
        register("image", "影像参数", "lens", "镜头与防抖",
                "fov warp_enable iq_eis_enable");
        register("image", "影像参数", "exposure", "曝光与测光",
                "iso shutter ev metering meter_mode iq_video_ev iq_photo_ev iq_video_iso iq_photo_iso iq_photo_iso_min iq_photo_shutter auto_low_light protune");
        register("image", "影像参数", "color", "色彩与细节",
                "white_balance iq_video_wb iq_photo_wb video_flat_color photo_flat_color video_sharpness photo_sharpness");
        register("interface", "声音与屏幕", "audio", "录音与提示音",
                "mic_level sound_effect buzzer_volume buzzer_ring");
        register("interface", "声音与屏幕", "display", "屏幕与指示灯",
                "screen_auto_lock led_mode language");
        register("connection", "连接设置", "wifi", "无线网络",
                "wifi_mode wifi_country wifi_country_editable sta_ip wifi_ssid wifi_password sta_ssid sta_password sta_connect_password");
        register("connection", "连接设置", "stream", "视频传输",
                "dual_stream_status streaming_status");
        register("system", "系统与存储", "general", "时间与电源",
                "camera_clock date_time auto_power_off system_default_mode");
        register("system", "系统与存储", "storage", "存储卡",
                "sd_card_status sdcard_need_format");
        register("system", "系统与存储", "restore", "重置选项",
                "restore_factory_settings restore_wifi restore_bt");
        register("information", "相机信息", "device", "设备信息",
                "product_name sw_version hw_version serial_number battery_percent battery_type dev_functions");
        register("information", "相机信息", "state", "拍摄状态",
                "app_status precise_cont_capturing precise_self_running precise_self_remain_time");
        register("information", "相机信息", "capabilities", "功能支持状态",
                "rec_audio_support sound_effect_support dewarp_support_status eis_support_status support_auto_low_light support_flat_color support_sharpness support_fov support_iso support_wb stamp_enable ev_enable");
        register("other", "更多设置", "voice", "语音控制",
                "voice_control voice_enable voice_language voice_wakeup voice_command");
        OTHER = new Location("other", "更多设置", "other", "其他相机设置");
        ORDER.add(OTHER);
    }

    private SettingsHierarchy() { }

    public static final class Location {
        public final String groupId, groupTitle, sectionId, sectionTitle;
        private Location(String groupId, String groupTitle, String sectionId, String sectionTitle) {
            this.groupId = groupId; this.groupTitle = groupTitle;
            this.sectionId = sectionId; this.sectionTitle = sectionTitle;
        }
    }

    public static final class Section {
        public final String id, title;
        /** Original camera wire keys; route each row through the existing option lookup. */
        public final List<String> keys;
        private Section(Location location, List<String> keys) {
            id = location.sectionId; title = location.sectionTitle;
            this.keys = Collections.unmodifiableList(new ArrayList<>(keys));
        }
    }

    public static final class Group {
        public final String id, title;
        public final List<Section> sections;
        private Group(Location location, List<Section> sections) {
            id = location.groupId; title = location.groupTitle;
            this.sections = Collections.unmodifiableList(new ArrayList<>(sections));
        }
    }

    public static Location classify(String key) {
        Location known = LOCATIONS.get(key == null ? "" : key.toLowerCase(Locale.ROOT));
        return known == null ? OTHER : known;
    }

    public static List<Group> build(JSONObject settings) { return build(settings, ""); }

    public static List<Group> build(JSONObject settings, String query) {
        if (settings == null) return Collections.emptyList();
        Map<Location, List<String>> found = new LinkedHashMap<>();
        for (String key : CameraSettings.keys(settings)) {
            if (hiddenReason(key, settings).isEmpty() && matches(key, settings.opt(key), query)) {
                Location location = classify(key);
                found.computeIfAbsent(location, ignored -> new ArrayList<>()).add(key);
            }
        }
        List<Group> result = new ArrayList<>();
        List<Section> sections = new ArrayList<>();
        Location last = null;
        for (Location location : ORDER) {
            List<String> keys = found.get(location);
            if (keys == null || keys.isEmpty()) continue;
            if (last != null && !last.groupId.equals(location.groupId)) {
                result.add(new Group(last, sections)); sections = new ArrayList<>();
            }
            sections.add(new Section(location, keys)); last = location;
        }
        if (last != null) result.add(new Group(last, sections));
        return Collections.unmodifiableList(result);
    }

    /** Every omitted item has a specific reason, without mutating camera data. */
    public static String hiddenReason(String key, JSONObject settings) {
        String k = key == null ? "" : key.toLowerCase(Locale.ROOT);
        if (k.startsWith("support_") || k.endsWith("_support") || k.endsWith("_support_status")
                || k.endsWith("_settable") || k.endsWith("_editable")
                || java.util.Arrays.asList("dev_functions", "stamp_enable", "ev_enable", "piv_enable").contains(k)) return "功能能力标志";
        if (java.util.Arrays.asList("restore_factory_settings", "restore_wifi", "restore_bt", "long_shutter_define").contains(k)) return "未开放的操作";
        if (java.util.Arrays.asList("app_status", "battery_percent", "battery_type", "dual_stream_status", "streaming_status",
                "precise_cont_capturing", "precise_self_running", "precise_self_remain_time", "buzzer_ring").contains(k)) return "运行状态，不是设置";
        String[][] aliases = {{"video_mode", "rec_mode"}, {"date_time", "camera_clock"}, {"photo_resolution", "photo_size"},
                {"metering", "meter_mode"}, {"voice_enable", "voice_control"}, {"sta_connect_password", "sta_password"}};
        for (String[] alias : aliases) if (k.equals(alias[0]) && settings.has(alias[1])) return "同一功能的兼容字段";
        if (k.startsWith("sta_") && !"sta".equalsIgnoreCase(settings.optString("wifi_mode"))
                && (settings.isNull(key) || settings.optString(key).trim().isEmpty())) return "未使用的外部网络配置";
        return "";
    }

    /** AND search across Chinese labels, descriptions, raw key/value, and the navigation path. */
    public static boolean matches(String key, Object value, String query) {
        String request = normalize(query).trim();
        if (request.isEmpty()) return true;
        Location path = classify(key);
        CameraOptionPresentation.Option option = CameraOptionPresentation.present(key, value, null);
        String haystack = normalize((key == null ? "" : key) + " " + CameraSettings.displayName(key) + " "
                + CameraSettings.description(key) + " " + String.valueOf(value) + " "
                + CameraSettings.displayValue(key, value) + " "
                + option.title + " " + option.subtitle + " " + String.join(" ", option.tags) + " "
                + path.groupTitle + " " + path.sectionTitle);
        for (String token : request.split("\\s+")) if (!haystack.contains(token)) return false;
        return true;
    }

    private static String normalize(String value) {
        return value == null ? "" : value.toLowerCase(Locale.ROOT).replace('\u3000', ' ').replace('\u00a0', ' ');
    }

    private static void register(String groupId, String groupTitle, String sectionId, String sectionTitle, String keys) {
        Location location = new Location(groupId, groupTitle, sectionId, sectionTitle);
        ORDER.add(location);
        for (String key : keys.split(" ")) {
            if (LOCATIONS.put(key, location) != null) throw new IllegalStateException("重复设置分类：" + key);
        }
    }
}
