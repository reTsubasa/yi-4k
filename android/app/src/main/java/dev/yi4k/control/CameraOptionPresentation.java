package dev.yi4k.control;

import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Read-only labels for advertised scalar options. Never rewrites a wire value. */
public final class CameraOptionPresentation {
    private static final Pattern VIDEO = Pattern.compile(
            "^(\\d{1,5})\\s*[xX×]\\s*(\\d{1,5})(?:\\s+(\\d+(?:\\.\\d+)?)\\s*[pP]?)?(?:\\s+(\\d+:\\d+))?(?:\\s+(super))?\\s*$",
            Pattern.CASE_INSENSITIVE);
    private static final Pattern SLOW = Pattern.compile("^(\\d{1,5})[xX×](\\d{1,5})[xX×](\\d+)$");
    private static final Pattern PHOTO = Pattern.compile(
            "^(\\d+)MP\\s+\\((\\d+)[xX×](\\d+)\\s+(\\d+:\\d+)\\)\\s+fov:([wm])$",
            Pattern.CASE_INSENSITIVE);

    private CameraOptionPresentation() { }

    public static final class Option {
        /** Exact original scalar text; selection must still submit the original Object. */
        public final String wireValue;
        public final String title;
        public final String subtitle;
        /** Trailing metadata chips, in display order. No tag implies a supported capability. */
        public final List<String> tags;

        private Option(String wireValue, String title, String subtitle, List<String> tags) {
            this.wireValue = wireValue;
            this.title = title;
            this.subtitle = subtitle;
            this.tags = Collections.unmodifiableList(new ArrayList<>(tags));
        }
    }

    public static Option present(String key, Object wireValue, JSONObject currentSettings) {
        String original = scalar(wireValue);
        String value = original.trim();
        String normalized = key == null ? "" : key.toLowerCase(Locale.ROOT);
        List<String> tags = new ArrayList<>();
        if (isVideoResolution(normalized)) {
            Matcher video = VIDEO.matcher(value);
            if (video.matches()) {
                String dimensions = video.group(1) + " × " + video.group(2);
                String aspect = video.group(4);
                if (video.group(3) != null) tags.add(video.group(3) + "fps");
                if (video.group(5) != null) tags.add("超广视角");
                // support_status describes the current mode only. There is no
                // per-option EIS table, and the saved on/off preference is not capability.
                if (isConfirmedCurrentResolution(normalized, value, currentSettings)
                        && "off".equals(scalar(currentSettings.opt("eis_support_status")).trim())) {
                    tags.add("无EIS");
                }
                return new Option(original, resolutionTitle(video.group(1), video.group(2)),
                        dimensions + (aspect == null ? "" : " · " + aspect), tags);
            }
        }
        if ("slow_motion_res".equals(normalized)) {
            Matcher slow = SLOW.matcher(value);
            if (slow.matches()) {
                tags.add(slow.group(3) + "倍慢动作");
                return new Option(original, resolutionTitle(slow.group(1), slow.group(2)),
                        slow.group(1) + " × " + slow.group(2), tags);
            }
        }
        if ("photo_size".equals(normalized)) {
            Matcher photo = PHOTO.matcher(value);
            if (photo.matches()) {
                tags.add("w".equalsIgnoreCase(photo.group(5)) ? "广角" : "中等视角");
                return new Option(original, photo.group(1) + "00万像素",
                        photo.group(2) + " × " + photo.group(3) + " · " + photo.group(4), tags);
            }
        }
        // Unknown formats remain intact instead of inferring dimensions, fps,
        // field of view, or EIS from an incomplete/future camera scalar.
        return new Option(original, CameraSettings.displayValue(key, wireValue), "", tags);
    }

    private static boolean isVideoResolution(String key) {
        return "video_resolution".equals(key) || "video_photo_resolution".equals(key)
                || "timelapse_video_resolution".equals(key);
    }

    private static boolean isConfirmedCurrentResolution(String key, String value, JSONObject settings) {
        return settings != null && key.equals(CaptureParameters.resolutionKey(settings))
                && value.equals(scalar(settings.opt(key)).trim());
    }

    private static String scalar(Object value) {
        return value instanceof String || value instanceof Number || value instanceof Boolean ? value.toString() : "";
    }

    private static String resolutionTitle(String width, String height) {
        String dimensions = width + "x" + height;
        switch (dimensions) {
            case "3840x2160": return "4K 超高清";
            case "2704x1520": case "2704x2032": return "2.7K 超清";
            case "2560x1440": return "2K 超清";
            case "1920x1080": return "1080p 全高清";
            case "1280x720": return "720p 高清";
            case "1920x1440": return "1440p";
            case "1280x960": return "960p";
            case "848x480": return "480p 标清";
            default: return width + " × " + height;
        }
    }
}
