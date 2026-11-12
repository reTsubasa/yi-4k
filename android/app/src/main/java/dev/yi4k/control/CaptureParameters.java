package dev.yi4k.control;

import org.json.JSONObject;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Read-only presentation of values actually returned by the camera. */
public final class CaptureParameters {
    private static final Pattern DIMENSIONS = Pattern.compile(
            "^(\\d+)\\s*[xX×]\\s*(\\d+)(?=\\s|$|[xX×]\\d+$)");
    private static final Pattern FRAME_RATE = Pattern.compile(
            "^\\d+\\s*[xX×]\\s*\\d+\\s+(\\d+(?:\\.\\d+)?)\\s*[pP]?(?=\\s|$)");

    private CaptureParameters() { }

    private static String raw(JSONObject settings, String key) {
        if (settings == null || key == null || settings.isNull(key)) return "";
        Object value = settings.opt(key);
        if (!(value instanceof String || value instanceof Number || value instanceof Boolean)) return "";
        return value.toString().trim();
    }

    /** Missing fields stay unknown; no prototype defaults are camera state. */
    public static String value(JSONObject settings, String key) {
        String value = raw(settings, key);
        if (value.isEmpty()) return "--";
        if ("iq_eis_enable".equals(key) && "off".equals(raw(settings, "eis_support_status")))
            return "规格不支持";
        if ("fov".equals(key)) {
            if ("wide".equals(value)) return "广角";
            if ("medium".equals(value)) return "中等视角";
            if ("narrow".equals(value)) return "窄视角";
        }
        return CameraSettings.displayValue(key, value);
    }

    /** Preserve the saved preference while explaining current mode capability. */
    public static String settingValue(JSONObject settings, String key) {
        String saved = CameraSettings.displayValue(key, settings == null ? null : settings.opt(key));
        if ("iq_eis_enable".equals(key) && "off".equals(raw(settings, "eis_support_status")))
            return "已保存：" + saved + "；当前规格不支持";
        return saved;
    }

    /** Mode-specific fields are independent: never substitute ordinary video values. */
    public static String resolutionKey(JSONObject settings) {
        if ("capture".equals(raw(settings, "system_mode"))) return "photo_size";
        String recordMode = raw(settings, "rec_mode");
        if ("record_timelapse".equals(recordMode)) return "timelapse_video_resolution";
        if ("record_slow_motion".equals(recordMode)) return "slow_motion_res";
        if ("record_photo".equals(recordMode)) return "video_photo_resolution";
        return "video_resolution";
    }

    /** Compact dimensions for capture chips; wire resolution stays untouched. */
    public static String resolution(JSONObject settings) {
        String value = raw(settings, resolutionKey(settings));
        if (value.isEmpty()) return "--";
        if ("photo_size".equals(resolutionKey(settings))) {
            Matcher megapixels = Pattern.compile("^(\\d+)MP(?:\\s|$)", Pattern.CASE_INSENSITIVE).matcher(value);
            if (megapixels.find()) return megapixels.group(1) + "00万";
        }
        Matcher dimensions = DIMENSIONS.matcher(value);
        if (!dimensions.find()) return value;
        String width = dimensions.group(1), height = dimensions.group(2);
        if ("3840".equals(width) && "2160".equals(height)) return "4K";
        if ("1920".equals(width) && "1080".equals(height)) return "1080p";
        if ("1280".equals(width) && "720".equals(height)) return "720p";
        return width + "x" + height;
    }

    /** Parse the full, untruncated resolution so 120/240 and decimal fps survive. */
    public static String fps(JSONObject settings) {
        if ("photo_size".equals(resolutionKey(settings))) return "--";
        Matcher rate = FRAME_RATE.matcher(raw(settings, resolutionKey(settings)));
        return rate.find() ? rate.group(1) : "--";
    }

    /** Unknown/unsupported submodes must not select the normal video button. */
    public static String captureMode(JSONObject settings) {
        String systemMode = raw(settings, "system_mode");
        if ("capture".equals(systemMode)) return "capture";
        if (!"record".equals(systemMode)) return systemMode;
        String recordMode = raw(settings, "rec_mode");
        if ("record_timelapse".equals(recordMode)) return "timelapse";
        if ("record_slow_motion".equals(recordMode)) return "slow_motion";
        return recordMode;
    }
}
