package dev.yi4k.control;

import org.json.JSONObject;

/** Read both space counters in the camera's same units; no guessed setting keys. */
final class CameraStorage {
    static int usedPercent(long total, long free) {
        if (total <= 0 || free < 0 || free > total) return -1;
        return (int) Math.round((total - free) * 100d / total);
    }
    static int readUsedPercent(CameraClient camera) throws Exception {
        long total = counter(camera.call(5, CameraClient.args("type", "total")));
        long free = counter(camera.call(5, CameraClient.args("type", "free")));
        return usedPercent(total, free);
    }
    private static long counter(JSONObject response) {
        String value = response.optString("param", "");
        if (!value.matches("[0-9]+")) return -1;
        try { return Long.parseLong(value); } catch (NumberFormatException invalid) { return -1; }
    }
}
