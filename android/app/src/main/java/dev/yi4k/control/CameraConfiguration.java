package dev.yi4k.control;

import java.io.IOException;
import java.time.Clock;
import java.time.Duration;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Objects;

/** Verified configuration writes. A lost response is never retried or rolled back. */
public final class CameraConfiguration {
    private static final DateTimeFormatter CAMERA_CLOCK = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private CameraConfiguration() { }

    /** Synchronizes the camera RTC from the Android device clock and verifies the readback. */
    public static String syncClock(CameraClient camera) throws Exception {
        return syncClock(camera, Clock.systemDefaultZone());
    }

    /** Clock-injected form keeps the protocol and second-level tolerance testable on the host. */
    static String syncClock(CameraClient camera, Clock clock) throws Exception {
        if (camera == null || clock == null) throw new IllegalArgumentException("相机时钟参数不可用");
        synchronized (camera) {
            requireReady(camera);
            String requested = CAMERA_CLOCK.withZone(clock.getZone()).format(clock.instant());
            camera.call(2, CameraClient.args("type", "camera_clock").put("param", requested));
            String actual = camera.call(1, CameraClient.args("type", "camera_clock")).optString("param", "");
            try {
                ZonedDateTime expected = ZonedDateTime.parse(requested, CAMERA_CLOCK.withZone(clock.getZone()));
                ZonedDateTime observed = ZonedDateTime.parse(actual, CAMERA_CLOCK.withZone(clock.getZone()));
                long seconds = Math.abs(Duration.between(expected, observed).getSeconds());
                if (seconds > 2) throw new IOException("相机时间读回不一致：请求 " + requested + "，读回 " + actual);
            } catch (java.time.DateTimeException malformed) {
                throw new IOException("相机时间格式无法确认：" + actual, malformed);
            }
            return actual;
        }
    }

    /** Selects a camera mode, preserving the camera's advertised wire values. */
    public static void selectMode(CameraClient camera, String uiMode) throws Exception {
        final String recorderMode;
        if ("capture".equals(uiMode)) recorderMode = null;
        else if ("record".equals(uiMode)) recorderMode = "record";
        else if ("timelapse".equals(uiMode)) recorderMode = "record_timelapse";
        else if ("slow_motion".equals(uiMode)) recorderMode = "record_slow_motion";
        else throw new IllegalArgumentException("不支持的拍摄模式");

        // CameraClient.call uses the same monitor. Hold it across validation,
        // write and readback so another command cannot interleave a mode change.
        synchronized (camera) {
            requireReady(camera);
            String systemMode = recorderMode == null ? "capture" : "record";
            String key = recorderMode == null ? "capture_mode" : "rec_mode";
            Object value = recorderMode == null
                    ? camera.call(1, CameraClient.args("type", key)).get("param") : recorderMode;
            selectSubmode(camera, systemMode, key, value);
        }
    }

    /** Rechecks permission, options and status, then verifies the actual value. */
    public static void set(CameraClient camera, String key, Object value) throws Exception {
        if (key == null || !CameraSettings.safeKey(key)
                || !(value instanceof String || value instanceof Number || value instanceof Boolean))
            throw new IllegalArgumentException("此设置不允许修改");
        synchronized (camera) {
            // Stock 1.10.7 acknowledges system_mode writes without applying
            // them. Its child-mode setters dispatch the actual mode event.
            if ("system_mode".equals(key)) {
                if (!("capture".equals(value) || "record".equals(value)))
                    throw new IOException("相机不支持所选的工作模式");
                requireReady(camera);
                String child = "capture".equals(value) ? "capture_mode" : "rec_mode";
                Object selected = camera.call(1, CameraClient.args("type", child)).get("param");
                selectSubmode(camera, (String) value, child, selected);
                return;
            }
            requireReady(camera);
            List<Object> options = CameraSettings.writableOptions(key,
                    camera.call(9, CameraClient.args("param", key)));
            if (options.stream().noneMatch(option -> Objects.equals(option, value)))
                throw new IOException("相机不支持所选的" + CameraSettings.displayName(key) + "，请刷新后重新选择");
            // Querying the option list can take time; check immediately before
            // writing too. The camera remains responsible for atomic rejection.
            requireReady(camera);
            try {
                camera.call(2, CameraClient.args("type", key).put("param", value));
                if ("capture_mode".equals(key) || "rec_mode".equals(key)) {
                    awaitMode(camera, "capture_mode".equals(key) ? "capture" : "record", key, value);
                    return;
                }
                Object actual = camera.call(1, CameraClient.args("type", key)).get("param");
                if (!Objects.equals(value, actual))
                    throw new IOException(CameraSettings.displayName(key) + "未生效：请求 "
                            + CameraSettings.displayValue(key, value) + "，读回 "
                            + CameraSettings.displayValue(key, actual) + "；请刷新核对相机状态");
            } catch (CameraClient.CameraRejectedException rejected) {
                throw rejected;
            } catch (Exception error) {
                throw new IOException(CameraSettings.displayName(key)
                        + "写入结果未确认，请重新连接并刷新相机实际状态：" + error.getMessage(), error);
            }
        }
    }

    private static void selectSubmode(CameraClient camera, String systemMode, String key, Object requested) throws Exception {
        String parent = camera.call(1, CameraClient.args("type", "system_mode")).getString("param");
        Object current = camera.call(1, CameraClient.args("type", key)).get("param");
        // The child value can already match while its parent mode is inactive.
        // Reapplying that child once is the stock mode-switch operation.
        if (!systemMode.equals(parent) || !Objects.equals(current, requested)) set(camera, key, requested);
    }

    private static void awaitMode(CameraClient camera, String parent, String key, Object requested) throws Exception {
        long deadline = System.nanoTime() + 3_000_000_000L;
        do {
            Object actual = camera.call(1, CameraClient.args("type", key)).get("param");
            String systemMode = camera.call(1, CameraClient.args("type", "system_mode")).getString("param");
            requireReady(camera);
            if (Objects.equals(requested, actual) && parent.equals(systemMode)) return;
            if (System.nanoTime() >= deadline)
                throw new IOException("工作模式未生效，请刷新核对相机状态");
            // Read-only polling for the asynchronous stock GUI mode event;
            // never resend a write whose result is uncertain.
            Thread.sleep(100);
        } while (true);
    }

    private static void requireReady(CameraClient camera) throws Exception {
        String status = camera.call(1, CameraClient.args("type", "app_status")).getString("param");
        if (!CameraState.isReady(status)) throw new IOException("请先停止拍摄再修改配置；相机当前"
                + CameraSettings.displayValue("app_status", status));
    }
}
