package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Locale;

/** Setting values must come from this camera's advertised option list. */
public final class CameraSettings {
    private static final Map<String, String> KEY_NAMES = new LinkedHashMap<>();
    private static final Map<String, String> VALUE_NAMES = new LinkedHashMap<>();
    private static final Map<String, String> KEY_DESCRIPTIONS = new LinkedHashMap<>();
    static {
        // Keep the camera's wire keys intact, but present a readable label in the UI.
        String[][] keys = {
                {"product_name", "相机型号"}, {"sw_version", "固件版本"},
                {"hw_version", "硬件版本"}, {"system_mode", "工作模式"},
                {"video_mode", "录像模式"}, {"video_resolution", "视频分辨率"},
                {"video_standard", "视频制式"}, {"video_quality", "视频质量"},
                {"iq_eis_enable", "电子防抖（EIS）"}, {"sd_card_status", "存储卡状态"},
                {"battery_percent", "电池电量"}, {"battery_type", "电池类型"},
                {"auto_power_off", "自动关机"}, {"loop_rec_duration", "循环录像时长"},
                {"rec_mode", "录像模式"}, {"timelapse_interval", "延时摄影间隔"},
                {"photo_resolution", "照片分辨率"}, {"photo_size", "照片尺寸"}, {"photo_quality", "照片质量"},
                {"fov", "视野范围"},
                {"white_balance", "白平衡"}, {"iso", "ISO 感光度"},
                {"shutter", "快门"}, {"ev", "曝光补偿"}, {"metering", "测光模式"},
                {"date_time", "日期和时间"}, {"language", "语言"},
                {"voice_control", "语音控制"}, {"voice_enable", "语音控制"},
                {"voice_language", "语音语言"}, {"voice_wakeup", "语音唤醒"},
                {"voice_command", "语音命令"}
        };
        for (String[] entry : keys) KEY_NAMES.put(entry[0], entry[1]);
        // Actual 1.10.7 fields from the read-only feature API capture. These
        // labels do not grant write access; msg9 still controls editability.
        String[][] actual = {
                {"serial_number", "相机序列号", "相机的唯一设备编号"},
                {"wifi_ssid", "相机热点名称", "手机连接的相机 Wi-Fi 名称"},
                {"wifi_password", "相机热点密码", "相机 Wi-Fi 连接密码"},
                {"sta_ssid", "外部网络名称", "相机连接的外部 Wi-Fi 名称"},
                {"sta_password", "外部网络密码", "相机连接外部 Wi-Fi 时使用的密码"},
                {"sta_connect_password", "外部网络连接密码", "外部网络连接凭据"},
                {"camera_clock", "相机日期与时间", "用于记录拍摄文件的日期与时间"},
                {"app_status", "拍摄状态", "相机当前处于待机、取景或拍摄状态"},
                {"iq_video_ev", "视频曝光补偿", "负值使画面变暗，正值使画面变亮；单位为 EV"},
                {"iq_photo_ev", "照片曝光补偿", "负值使照片变暗，正值使照片变亮；单位为 EV"},
                {"iq_video_iso", "视频 ISO 感光度", "提高感光度可增加亮度，也可能增加噪点"},
                {"iq_photo_iso", "照片 ISO 感光度", "提高感光度可增加亮度，也可能增加噪点"},
                {"iq_photo_iso_min", "照片最低 ISO", "照片自动感光度范围的最低值"},
                {"iq_photo_shutter", "照片快门时间", "曝光时间越长，越容易记录运动模糊"},
                {"iq_video_wb", "视频白平衡", "调整视频的色温，自动模式由相机判断"},
                {"iq_photo_wb", "照片白平衡", "调整照片的色温，自动模式由相机判断"},
                {"video_photo_resolution", "录像中拍照的视频规格", "用于录像中拍照模式的视频分辨率和帧率"},
                {"timelapse_video_resolution", "延时视频规格", "用于延时摄影模式的成片分辨率和帧率"},
                {"slow_motion_res", "慢动作视频规格", "相机返回的分辨率与倍率组合；倍率不等于拍摄帧率"},
                {"slow_motion_rate", "慢动作倍率", "相机设置的慢动作倍数"},
                {"timelapse_video", "延时视频拍摄间隔", "延时视频相邻拍摄帧之间的间隔，单位为秒"},
                {"timelapse_video_duration", "延时视频时长", "延时视频模式的时长设置"},
                {"timelapse_photo_shutter", "延时照片快门", "延时拍照模式使用的快门时间"},
                {"capture_mode", "拍照模式", "选择单张、定时、连拍或间隔拍照"},
                {"precise_cont_time", "间隔拍照间隔", "连续拍照时相邻两张照片之间的时间"},
                {"precise_cont_poweroff", "间隔拍照关机设置", "相机返回的间隔拍照关机选项"},
                {"precise_cont_poweroff_settable", "间隔拍照关机可设置", "相机报告此选项当前是否可设置"},
                {"precise_cont_capturing", "间隔拍照进行中", "相机报告的连续拍照状态"},
                {"precise_selftime", "自拍倒计时", "按下快门后等待多久再拍照"},
                {"precise_self_running", "自拍倒计时进行中", "相机报告的自拍倒计时状态"},
                {"precise_self_remain_time", "自拍剩余时间", "相机返回的自拍倒计时剩余值"},
                {"burst_capture_number", "连拍速度", "每秒拍摄的照片张数"},
                {"record_photo_time", "录像中拍照间隔", "录像中拍照模式的自动拍照时间设置"},
                {"video_stamp", "视频时间水印", "选择是否将日期或时间叠加到视频画面"},
                {"photo_stamp", "照片时间水印", "选择是否将日期或时间叠加到照片"},
                {"stamp_enable", "时间水印可用", "相机返回的时间水印功能状态"},
                {"video_flat_color", "视频色彩模式", "标准色彩或低对比度的 Flat 色彩，便于后期调色"},
                {"photo_flat_color", "照片色彩模式", "标准色彩或低对比度的 Flat 色彩，便于后期调色"},
                {"video_sharpness", "视频锐度", "控制视频边缘的锐化程度"},
                {"photo_sharpness", "照片锐度", "控制照片边缘的锐化程度"},
                {"meter_mode", "测光模式", "决定相机根据整个画面、中央或点区域计算曝光"},
                {"auto_low_light", "自动低光", "低光环境下允许相机自动调整拍摄参数"},
                {"warp_enable", "镜头畸变校正", "校正广角镜头的画面畸变，和电子防抖是不同设置"},
                {"ev_enable", "曝光补偿可用", "相机返回的曝光补偿功能状态"},
                {"protune", "专业参数设置", "相机的专业影像参数功能开关"},
                {"video_rotate", "画面旋转", "选择自动检测或固定画面旋转状态"},
                {"screen_auto_lock", "自动息屏", "无操作后关闭相机屏幕的等待时间"},
                {"system_default_mode", "开机默认模式", "相机开机后进入的拍摄模式"},
                {"buzzer_volume", "提示音音量", "调整相机操作提示音的音量"},
                {"buzzer_ring", "提示音状态", "相机返回的蜂鸣器提示音状态"},
                {"led_mode", "指示灯", "选择哪些相机指示灯保持启用"},
                {"mic_level", "麦克风音量", "相机麦克风的录音音量档位"},
                {"sound_effect", "录音音效", "选择相机录音的声音处理模式"},
                {"rec_audio_support", "录音支持状态", "相机报告当前是否支持录音"},
                {"sound_effect_support", "录音音效支持状态", "相机报告是否支持录音音效设置"},
                {"quick_view", "拍照后回看", "拍照后是否在相机屏幕上显示照片"},
                {"video_file_max_size", "视频文件大小上限", "控制相机单个视频文件的大小设置"},
                {"photo_file_type", "照片文件格式", "照片使用的文件格式"},
                {"photo_file_type_settable", "照片格式可设置", "相机报告照片文件格式当前是否可设置"},
                {"sdcard_need_format", "存储卡格式检查", "相机报告存储卡是否需要格式化；此处不执行格式化"},
                {"dewarp_support_status", "畸变校正支持状态", "相机报告是否支持镜头畸变校正"},
                {"eis_support_status", "电子防抖支持状态", "相机报告是否支持电子防抖；不代表当前已开启"},
                {"support_auto_low_light", "自动低光支持状态", "相机报告是否支持自动低光设置"},
                {"support_flat_color", "色彩模式支持状态", "相机报告是否支持 Flat 色彩设置"},
                {"support_sharpness", "锐度支持状态", "相机报告是否支持锐度设置"},
                {"support_fov", "视野调整支持状态", "相机报告是否支持调整视野范围"},
                {"support_iso", "ISO 调整支持状态", "相机报告是否支持调整感光度"},
                {"support_wb", "白平衡支持状态", "相机报告是否支持调整白平衡"},
                {"wifi_mode", "Wi-Fi 工作方式", "相机作为热点或连接其他无线网络"},
                {"wifi_country", "Wi-Fi 地区", "相机无线网络的地区设置"},
                {"wifi_country_editable", "Wi-Fi 地区可设置", "相机报告无线地区当前是否可设置"},
                {"sta_ip", "无线客户端地址", "相机连接其他无线网络时使用的地址"},
                {"dual_stream_status", "双码流状态", "相机报告的双码流功能状态"},
                {"streaming_status", "视频推流状态", "相机报告的视频流传输状态"},
                {"piv_enable", "录像中拍照开关", "相机返回的录像中拍照功能状态"},
                {"restore_factory_settings", "恢复出厂设置", "恢复设置动作未在此开放"},
                {"restore_wifi", "重置 Wi-Fi", "无线设置重置动作未在此开放"},
                {"restore_bt", "重置蓝牙", "蓝牙设置重置动作未在此开放"},
                {"dev_functions", "设备功能标志", "相机返回的原始功能位标志"},
                {"long_shutter_define", "长曝光动作设置", "相机返回的长曝光关联动作标识"}
        };
        for (String[] entry : actual) {
            KEY_NAMES.put(entry[0], entry[1]);
            KEY_DESCRIPTIONS.put(entry[0], entry[2]);
        }
        String[][] values = {
                {"record", "录像"}, {"capture", "拍照"}, {"idle", "待机"},
                {"vf", "取景中"}, {"on", "开启"}, {"off", "关闭"},
                {"yes", "是"}, {"no", "否"}, {"true", "是"}, {"false", "否"},
                {"insert", "已插入"}, {"absent", "未插入"}, {"remove", "未插入"},
                {"Fine", "高质量"}, {"Normal", "普通"}, {"low", "低"},
                {"medium", "中"}, {"high", "高"}, {"auto", "自动"},
                {"daylight", "日光"}, {"cloudy", "阴天"}, {"fluorescent", "荧光灯"},
                {"incandescent", "白炽灯"}
        };
        for (String[] entry : values) VALUE_NAMES.put(entry[0].toLowerCase(Locale.ROOT), entry[1]);
        VALUE_NAMES.put("s.fine", "超高质量");
        VALUE_NAMES.put("record_timelapse", "延时摄影");
        VALUE_NAMES.put("record_loop", "循环录像");
        VALUE_NAMES.put("record_photo", "录像中拍照");
        VALUE_NAMES.put("record_slow_motion", "慢动作");
        VALUE_NAMES.put("fov:w", "广角");
        VALUE_NAMES.put("fov:m", "中等视角");
    }

    private CameraSettings() { }
    public static List<String> keys(JSONObject settings) {
        ArrayList<String> keys = new ArrayList<>();
        settings.keys().forEachRemaining(keys::add);
        Collections.sort(keys);
        return keys;
    }
    public static boolean safeKey(String key) {
        if (key == null) return false;
        String value = key.toLowerCase(Locale.ROOT);
        // The camera's voice route is intentionally diagnostic-only. The
        // public 1.10.7 API does not advertise a stable setter contract.
        if (value.matches("voice_(control|enable|language|wakeup|command)")) return false;
        if ("auto_power_off".equals(value)) return true;
        return value.matches("[a-z0-9_]+") && !value.matches(".*(^|_)(format|reset|restore|erase|delete|reboot|shutdown|upgrade|update|factory|power_off|poweroff)(_|$).*");
    }

    public static boolean hasLabel(String key) { return key != null && KEY_NAMES.containsKey(key.toLowerCase(Locale.ROOT)); }

    /** Identifiers and telemetry do not become editable because their keys are syntactically safe. */
    public static boolean readOnly(String key) {
        if (key == null) return true;
        return java.util.Arrays.asList("serial_number", "product_name", "sw_version", "hw_version", "battery_percent", "battery_type",
                "sd_card_status", "sdcard_need_format", "app_status", "sta_ip", "wifi_ssid", "wifi_password",
                "sta_ssid", "sta_password", "sta_connect_password", "camera_clock", "date_time").contains(key.toLowerCase(Locale.ROOT));
    }

    /** Known parameters are localized; unrecognized firmware fields remain identifiable in diagnostics. */
    public static String displayName(String key) {
        if (key == null || key.isEmpty()) return "未知设置";
        String known = KEY_NAMES.get(key.toLowerCase(Locale.ROOT));
        if (known != null) return known;
        String readable = key.replace('_', ' ').trim();
        if (readable.isEmpty()) return key;
        return readable + "（" + key + "）";
    }

    /** Translate common scalar values but preserve technical values verbatim. */
    public static String displayValue(String key, Object value) {
        if (value == null || value == JSONObject.NULL) return "未返回";
        String raw = String.valueOf(value);
        if (raw.trim().isEmpty()) return "未设置";
        if (key != null && key.toLowerCase(Locale.ROOT).contains("password")) return "••••••••";
        String normalizedKey = key == null ? "" : key.toLowerCase(Locale.ROOT);
        String normalizedValue = raw.toLowerCase(Locale.ROOT);
        if ("fov".equals(normalizedKey)) {
            if ("wide".equals(normalizedValue)) return "广角";
            if ("medium".equals(normalizedValue)) return "中等视角";
            if ("narrow".equals(normalizedValue)) return "窄视角";
        }
        if ("video_standard".equals(normalizedKey)) {
            if ("ntsc".equals(normalizedValue)) return "NTSC 制式";
            if ("pal".equals(normalizedValue)) return "PAL 制式";
        }
        if ("rec_mode".equals(normalizedKey) && "record".equals(normalizedValue)) return "普通录像";
        if ("app_status".equals(normalizedKey) && "record".equals(normalizedValue)) return "录像中";
        if ("capture_mode".equals(normalizedKey)) {
            if ("precise quality".equals(normalizedValue)) return "单张拍照";
            if ("precise self quality".equals(normalizedValue)) return "定时自拍";
            if ("burst quality".equals(normalizedValue)) return "连拍";
            if ("precise quality cont.".equals(normalizedValue)) return "间隔拍照";
        }
        if ("video_flat_color".equals(normalizedKey) || "photo_flat_color".equals(normalizedKey)) {
            if ("yi".equals(normalizedValue)) return "标准（YI）";
            if ("flat".equals(normalizedValue)) return "平坦（Flat）";
        }
        if ("iq_video_wb".equals(normalizedKey) || "iq_photo_wb".equals(normalizedKey)) {
            if ("native".equals(normalizedValue)) return "原生白平衡";
            if (raw.matches("(?i)\\d+k")) return raw.substring(0, raw.length() - 1) + " K";
        }
        if ("meter_mode".equals(normalizedKey) || "metering".equals(normalizedKey)) {
            if ("average".equals(normalizedValue)) return "平均测光";
            if ("center".equals(normalizedValue)) return "中央测光";
            if ("spot".equals(normalizedValue)) return "点测光";
        }
        if ("led_mode".equals(normalizedKey)) {
            if ("all enable".equals(normalizedValue)) return "全部开启";
            if ("all disable".equals(normalizedValue)) return "全部关闭";
            if ("status enable".equals(normalizedValue)) return "仅状态灯";
        }
        if ("system_default_mode".equals(normalizedKey) && "last used mode".equals(normalizedValue)) return "上次使用的模式";
        if ("language".equals(normalizedKey) || "voice_language".equals(normalizedKey)) {
            if ("cn".equals(normalizedValue)) return "中文";
            if ("en".equals(normalizedValue)) return "英语";
        }
        if ("video_stamp".equals(normalizedKey) || "photo_stamp".equals(normalizedKey)) {
            if ("date/time".equals(normalizedValue)) return "日期与时间";
            if ("date".equals(normalizedValue)) return "仅日期";
            if ("time".equals(normalizedValue)) return "仅时间";
        }
        if ("burst_capture_number".equals(normalizedKey)) {
            java.util.regex.Matcher burst = java.util.regex.Pattern.compile("(\\d+)\\s*p\\s*/\\s*s").matcher(normalizedValue);
            if (burst.matches()) return "每秒 " + burst.group(1) + " 张";
        }
        if ("record_photo_time".equals(normalizedKey) && raw.matches("\\d+(?:\\.\\d+)?")) return raw + " 秒";
        if ("wifi_country".equals(normalizedKey) && "cn".equals(normalizedValue)) return "中国";
        if ("wifi_mode".equals(normalizedKey)) {
            if ("ap".equals(normalizedValue)) return "相机热点";
            if ("sta".equals(normalizedValue)) return "无线客户端";
        }
        if ("sdcard_need_format".equals(normalizedKey) && "no-need".equals(normalizedValue)) return "无需格式化";
        if ("buzzer_volume".equals(normalizedKey) && "mute".equals(normalizedValue)) return "静音";
        if ("sound_effect".equals(normalizedKey) && "wind".equals(normalizedValue)) return "风噪处理（wind）";
        if ("photo_file_type".equals(normalizedKey) && "jpg".equals(normalizedValue)) return "JPEG 照片";
        if ("loop_rec_duration".equals(normalizedKey)) {
            if ("max".equals(normalizedValue)) return "最长时长（max）";
            if (raw.matches("\\d+ minutes?")) return raw.substring(0, raw.indexOf(' ')) + " 分钟";
        }
        if ("video_file_max_size".equals(normalizedKey) && "max".equals(normalizedValue)) return "最大值（max）";
        if ("slow_motion_rate".equals(normalizedKey) && raw.matches("\\d+")) return raw + " 倍";
        if ("slow_motion_res".equals(normalizedKey)) {
            java.util.regex.Matcher slow = java.util.regex.Pattern.compile("(\\d+)x(\\d+)x(\\d+)").matcher(raw);
            if (slow.matches()) return slow.group(1) + "×" + slow.group(2) + " · " + slow.group(3) + " 倍慢动作";
        }
        if ("timelapse_video".equals(normalizedKey) && raw.matches("\\d+(?:\\.\\d+)?")) return raw + " 秒";
        if ("precise_cont_time".equals(normalizedKey) && "continue".equals(normalizedValue)) return "连续拍摄";
        if ("screen_auto_lock".equals(normalizedKey) && "never".equals(normalizedValue)) return "从不息屏";
        if ("auto_power_off".equals(normalizedKey) && raw.matches("\\d+ minutes?")) return raw.substring(0, raw.indexOf(' ')) + " 分钟";
        if ("screen_auto_lock".equals(normalizedKey) || "precise_selftime".equals(normalizedKey)
                || "precise_cont_time".equals(normalizedKey) || "timelapse_video_duration".equals(normalizedKey)
                || "iq_photo_shutter".equals(normalizedKey) || "timelapse_photo_shutter".equals(normalizedKey)) {
            java.util.regex.Matcher time = java.util.regex.Pattern.compile("(\\d+(?:\\.\\d+)?)\\s*(s|sec|min)").matcher(raw);
            if (time.matches()) return time.group(1) + ("min".equals(time.group(2)) ? " 分钟" : " 秒");
        }
        if ("photo_size".equals(normalizedKey)) {
            java.util.regex.Matcher photo = java.util.regex.Pattern.compile("(\\d+)MP \\((\\d+)x(\\d+) (\\d+:\\d+)\\) fov:([wm])").matcher(raw);
            if (photo.matches()) return photo.group(1) + "00 万像素 · " + photo.group(2) + "×" + photo.group(3)
                    + " · " + photo.group(4) + " · " + ("w".equals(photo.group(5)) ? "广角" : "中等视角");
            if (raw.matches("(?i)\\d+mp")) return raw.substring(0, raw.length() - 2) + "00 万像素";
        }
        if ("battery_percent".equals(normalizedKey) && raw.matches("\\d+")) return raw + "%";
        // A future key may give an existing word a different meaning. Keep it
        // verbatim until this client understands that setting's context.
        if (!KEY_NAMES.containsKey(normalizedKey)) return raw;
        String known = VALUE_NAMES.get(normalizedValue);
        if (known != null) return known;
        return raw;
    }

    public static String description(String key) {
        if (key == null) return "相机返回的设置项";
        String normalized = key.toLowerCase(Locale.ROOT);
        String known = KEY_DESCRIPTIONS.get(normalized);
        if (known != null) return known;
        if ("system_mode".equals(normalized)) return "选择录像或拍照工作模式";
        if ("video_resolution".equals(normalized)) return "分辨率、帧率和画面比例";
        if ("video_quality".equals(normalized)) return "质量越高，文件通常越大";
        if ("iq_eis_enable".equals(normalized)) return "电子防抖开关";
        if ("rec_mode".equals(normalized)) return "普通、延时、循环、录像中拍照或慢动作录像";
        if ("loop_rec_duration".equals(normalized)) return "循环录像每段的时长";
        if ("sd_card_status".equals(normalized)) return "相机存储卡状态";
        if ("auto_power_off".equals(normalized)) return "无操作时自动关机时间";
        if ("fov".equals(normalized)) return "选择广角、中等或较窄的视野范围";
        if ("photo_size".equals(normalized)) return "照片像素、画面比例与视野范围";
        if ("photo_quality".equals(normalized)) return "照片压缩质量；质量越高，文件通常越大";
        if ("video_standard".equals(normalized)) return "PAL 或 NTSC 视频制式会影响可选帧率";
        if ("product_name".equals(normalized)) return "相机报告的产品型号";
        if ("sw_version".equals(normalized)) return "相机正在运行的固件版本";
        if ("hw_version".equals(normalized)) return "相机报告的硬件版本";
        if ("language".equals(normalized)) return "相机界面的显示语言";
        if ("voice_control".equals(normalized) || "voice_enable".equals(normalized))
            return "相机返回的语音控制状态；手机不会采集或识别语音";
        if ("voice_language".equals(normalized)) return "相机语音识别使用的语言（只读）";
        if ("voice_wakeup".equals(normalized) || "voice_command".equals(normalized))
            return "相机返回的语音入口信息（只读）";
        return "相机返回的设置项";
    }
    public static List<Object> writableOptions(String key, JSONObject response) throws JSONException {
        ArrayList<Object> result = new ArrayList<>();
        if (!safeKey(key) || !"settable".equals(response.optString("permission"))) return result;
        JSONArray options = response.optJSONArray("options");
        if (options == null) return result;
        for (int i = 0; i < options.length(); i++) {
            Object value = options.get(i);
            if (!(value instanceof String || value instanceof Number || value instanceof Boolean)) continue;
            String text = value.toString().toLowerCase(Locale.ROOT).trim();
            if (text.matches("(format|reset|restore|erase|delete|reboot|shutdown|factory.?reset|restore.?factory|power.?off|upgrade)(.*)")) continue;
            result.add(value);
        }
        return result;
    }
}
