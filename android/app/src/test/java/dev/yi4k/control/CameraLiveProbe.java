package dev.yi4k.control;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.net.HttpURLConnection;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.util.*;
import javax.net.SocketFactory;
import org.json.JSONArray;
import org.json.JSONObject;

/** Explicit real-camera acceptance probe; never runs in the unit-test task. */
public final class CameraLiveProbe {
    private static final String[] SAVED = {"sw_version", "hw_version", "sd_card_status", "system_mode", "rec_mode", "capture_mode", "video_resolution", "iq_eis_enable", "video_quality"};
    public static void main(String[] args) throws Exception {
        String host = args[0]; Path output = Path.of(args[1]).toAbsolutePath();
        int seconds = Integer.parseInt(args[2]);
        boolean photo = args.length > 3 && Boolean.parseBoolean(args[3]);
        boolean config = args.length > 4 && Boolean.parseBoolean(args[4]);
        int optionalIndex = 5;
        boolean syncClock = false;
        // Keep the historical positional API/HTTP port arguments working;
        // Gradle appends the new boolean before them when supplied.
        if (args.length > optionalIndex && ("true".equalsIgnoreCase(args[optionalIndex])
                || "false".equalsIgnoreCase(args[optionalIndex]))) {
            syncClock = Boolean.parseBoolean(args[optionalIndex++]);
        }
        int apiPort = args.length > optionalIndex ? Integer.parseInt(args[optionalIndex]) : 7878;
        int httpPort = args.length > optionalIndex + 1 ? Integer.parseInt(args[optionalIndex + 1]) : 80;
        if (seconds != 0 && (seconds < 2 || seconds > 5)) throw new IllegalArgumentException("recordSeconds must be 0 or 2..5");
        if (Files.exists(output)) throw new IllegalStateException("Refusing to overwrite probe evidence: " + output);
        Files.createDirectories(output.getParent());
        JSONObject evidence = new JSONObject().put("host", host).put("record_seconds_requested", seconds)
                .put("capture_photo_requested", photo).put("change_setting_requested", config)
                .put("sync_clock_requested", syncClock)
                .put("started_at", java.time.Instant.now().toString())
                .put("client_source", "android/app/src/main/java/dev/yi4k/control/CameraClient.java");
        JSONArray notifications = new JSONArray();
        CameraClient camera = new CameraClient(event -> {
            try { notifications.put(new JSONObject().put("msg_id", event.optInt("msg_id")).put("type", event.optString("type"))); } catch (org.json.JSONException error) { throw new IllegalStateException(error); }
        });
        boolean mayRecord = false;
        JSONObject before = null;
        LinkedHashMap<String, Object> restore = new LinkedHashMap<>();
        Exception failure = null;
        try {
            camera.connect(SocketFactory.getDefault(), host, apiPort);
            before = CameraClient.flattenSettings(camera.call(3));
            evidence.put("before", selected(before));
            if (!before.getString("sw_version").startsWith("Z16V13L_1.10.7_")) throw new IllegalStateException("Unexpected firmware");
            evidence.put("status_before", awaitIdle(camera, 3000));
            JSONObject power = camera.call(13); evidence.put("power", power);
            if (seconds > 0 || photo || config || syncClock) {
                if (!Arrays.asList("battery", "adapter").contains(power.optString("type")) || power.optInt("param", -1) < 20)
                    throw new IllegalStateException("Battery/adapter below 20% or invalid");
                if (!"insert".equals(before.optString("sd_card_status"))) throw new IllegalStateException("SD card is not inserted");
            }
            Map<String, MediaEntry> original = snapshot(camera);
            evidence.put("media_before", describe(original.values()));
            if (syncClock) {
                String requestedAt = java.time.ZonedDateTime.now(java.time.Clock.systemDefaultZone())
                        .format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                String readback = CameraConfiguration.syncClock(camera);
                evidence.put("clock_sync", new JSONObject().put("requested_at", requestedAt)
                        .put("readback", readback).put("readback_verified", true));
            }
            if (config) {
                String key = "video_quality";
                List<Object> options = CameraSettings.writableOptions(key, camera.call(9, CameraClient.args("param", key)));
                Object originalValue = before.get(key);
                Object value = options.stream().filter(v -> !v.equals(originalValue)).findFirst().orElseThrow(() -> new IllegalStateException("No alternative video quality"));
                change(camera, restore, key, originalValue, value);
                JSONObject actual = camera.call(1, CameraClient.args("type", key));
                evidence.put("setting_change", new JSONObject().put("key", key).put("before", originalValue).put("requested", value).put("readback", actual));
                if (!value.equals(actual.get("param"))) throw new IllegalStateException("Setting readback mismatch");
            }
            if (seconds > 0) {
                changeMode(camera, restore, before, "record");
                awaitIdle(camera, 5000);
                mayRecord = true;
                try { evidence.put("record_start", camera.call(513)); }
                catch (CameraClient.CameraRejectedException rejected) { mayRecord = false; throw rejected; }
                Thread.sleep(seconds * 1000L);
                JSONObject during = camera.call(1, CameraClient.args("type", "app_status")); evidence.put("during_status", during);
                if (!"record".equals(during.optString("param"))) throw new IllegalStateException("Recording was not observed");
                evidence.put("record_stop", camera.call(514));
                evidence.put("status_after_record", awaitIdle(camera, 12000)); mayRecord = false;
            }
            if (photo) {
                changeMode(camera, restore, before, "capture");
                awaitIdle(camera, 5000);
                evidence.put("photo_request", camera.call(16777220, CameraClient.args("param", "precise quality;off")));
                evidence.put("status_after_photo", awaitIdle(camera, 12000));
            }
            Map<String, MediaEntry> after = snapshot(camera);
            long deadline = System.nanoTime() + 10_000_000_000L;
            while ((!hasNew(original, after, ".MP4") && seconds > 0 || !hasNew(original, after, ".JPG") && photo) && System.nanoTime() < deadline) {
                Thread.sleep(400); after = snapshot(camera);
            }
            evidence.put("media_after", describe(after.values()));
            if (seconds > 0 && !hasNew(original, after, ".MP4")) throw new IllegalStateException("No new MP4 appeared");
            if (photo && !hasNew(original, after, ".JPG")) throw new IllegalStateException("No new JPEG appeared");
            JSONArray exports = new JSONArray(); evidence.put("new_media_exports", exports);
            Path directory = output.resolveSibling(output.getFileName().toString().replaceFirst("\\.json$", "") + "-media");
            for (MediaEntry entry : after.values()) {
                if (entry.isMedia() && !original.containsKey(entry.path)) exports.put(download(host, httpPort, directory, entry));
            }
        } catch (Exception error) {
            failure = error; evidence.put("error", error.toString());
        } finally {
            JSONArray cleanup = new JSONArray(); evidence.put("cleanup", cleanup);
            try {
                if ((mayRecord || !restore.isEmpty()) && !camera.isConnected()) camera.connect(SocketFactory.getDefault(), host, apiPort);
                if (mayRecord && "record".equals(camera.call(1, CameraClient.args("type", "app_status")).optString("param"))) {
                    cleanup.put(new JSONObject().put("stop_own_recording", camera.call(514)));
                    awaitIdle(camera, 12000);
                }
                if (!restore.isEmpty()) {
                    awaitIdle(camera, 12000);
                    restoreSettings(camera, restore, cleanup);
                }
                if (camera.isConnected()) {
                    evidence.put("status_after", awaitIdle(camera, 12000));
                    JSONObject after = CameraClient.flattenSettings(camera.call(3)); evidence.put("after", selected(after));
                    boolean equal = before != null;
                    for (String key : SAVED) if (before != null && before.has(key)) equal &= before.get(key).equals(after.opt(key));
                    evidence.put("selected_settings_unchanged", equal);
                    if (!equal) throw new IllegalStateException("Selected settings not restored");
                }
            } catch (Exception error) {
                evidence.put("cleanup_error", error.toString()); if (failure == null) failure = error;
            }
            camera.disconnect(); evidence.put("notifications", notifications).put("finished_at", java.time.Instant.now().toString());
            Files.write(output, evidence.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8), StandardOpenOption.CREATE_NEW);
            System.out.println(evidence.toString(2));
        }
        if (failure != null) throw failure;
    }
    private static JSONObject selected(JSONObject settings) throws Exception {
        JSONObject selected = new JSONObject(); for (String key : SAVED) if (settings.has(key)) selected.put(key, settings.get(key)); return selected;
    }
    private static void change(CameraClient camera, Map<String, Object> restore, String key, Object saved, Object value) throws Exception {
        if (value.equals(camera.call(1, CameraClient.args("type", key)).get("param"))) return;
        if (!CameraSettings.writableOptions(key, camera.call(9, CameraClient.args("param", key))).contains(value)) throw new IllegalStateException("Unsupported option: " + key);
        restore.putIfAbsent(key, saved); // Retain original even when the mutation reply is uncertain.
        camera.call(2, CameraClient.args("type", key).put("param", value));
    }
    static void changeMode(CameraClient camera, Map<String, Object> restore, JSONObject before, String mode) throws Exception {
        restore.putIfAbsent("system_mode", before.get("system_mode"));
        String child = "capture".equals(mode) ? "capture_mode" : "rec_mode";
        // Preserve the inactive child too: selecting ordinary video can
        // overwrite a previously selected timelapse/slow-motion preference.
        restore.putIfAbsent(child, before.has(child) ? before.get(child)
                : camera.call(1, CameraClient.args("type", child)).get("param"));
        // The stock camera applies capture/record transitions through the
        // advertised child setting (capture_mode or rec_mode). The parent
        // system_mode setter can acknowledge without changing hardware state.
        if ("capture".equals(mode)) CameraConfiguration.set(camera, child, "precise quality");
        else CameraConfiguration.selectMode(camera, mode);
    }
    static void restoreSettings(CameraClient camera, Map<String, Object> restore, JSONArray cleanup) throws Exception {
        List<String> keys = new ArrayList<>(restore.keySet()); Collections.reverse(keys);
        // Child setters can change the parent mode. Restore every original
        // child first, then activate the original parent using its now-restored
        // child; selectMode("record") would incorrectly force ordinary video.
        keys.remove("system_mode");
        if (restore.containsKey("system_mode")) keys.add("system_mode");
        for (String key : keys) {
            Object saved = restore.get(key);
            CameraConfiguration.set(camera, key, saved);
            JSONObject readback = camera.call(1, CameraClient.args("type", key));
            cleanup.put(new JSONObject().put("restored_key", key).put("expected", saved)
                    .put("path", "CameraConfiguration.set").put("readback", readback));
            if (!saved.equals(readback.get("param"))) throw new IllegalStateException("Restoration readback mismatch: " + key);
        }
    }
    private static JSONObject awaitIdle(CameraClient camera, long milliseconds) throws Exception {
        long deadline = System.nanoTime() + milliseconds * 1_000_000L;
        JSONObject status;
        do {
            status = camera.call(1, CameraClient.args("type", "app_status"));
            if (CameraState.isReady(status.optString("param"))) return status;
            Thread.sleep(250);
        } while (System.nanoTime() < deadline);
        throw new IllegalStateException("Camera did not become idle: " + status);
    }
    private static Map<String, MediaEntry> snapshot(CameraClient camera) throws Exception {
        LinkedHashMap<String, MediaEntry> result = new LinkedHashMap<>();
        ArrayDeque<String> directories = new ArrayDeque<>(); directories.add(MediaEntry.DCIM_ROOT);
        int visited = 0;
        while (!directories.isEmpty()) {
            if (++visited > 100) throw new IllegalStateException("Too many DCIM directories");
            String folder = directories.remove();
            JSONObject response = camera.call(1282, CameraClient.args("param", folder)); JSONArray list = response.getJSONArray("listing");
            if (response.optInt("total", list.length()) > list.length()) throw new IllegalStateException("Incomplete media listing");
            for (int i = 0; i < list.length(); i++) {
                JSONObject row = list.getJSONObject(i); Iterator<String> keys = row.keys();
                while (keys.hasNext()) {
                    String key = keys.next(); MediaEntry entry = new MediaEntry(folder, key, row.getString(key));
                    if (entry.directory) directories.add(entry.path); else result.put(entry.path, entry);
                }
            }
        }
        return result;
    }
    private static boolean hasNew(Map<String, MediaEntry> before, Map<String, MediaEntry> after, String suffix) {
        return after.values().stream().anyMatch(e -> !before.containsKey(e.path) && e.name.toUpperCase(Locale.ROOT).endsWith(suffix));
    }
    private static JSONArray describe(Collection<MediaEntry> entries) throws Exception {
        JSONArray result = new JSONArray(); for (MediaEntry entry : entries) result.put(new JSONObject().put("path", entry.path).put("bytes", entry.bytes)); return result;
    }
    private static JSONObject download(String host, int port, Path directory, MediaEntry entry) throws Exception {
        Files.createDirectories(directory);
        Path target = directory.resolve(entry.name), temporary = Files.createTempFile(directory, "download-", ".part");
        boolean complete = false;
        HttpURLConnection connection = (HttpURLConnection) entry.uri(host, port).toURL().openConnection();
        connection.setConnectTimeout(5000); connection.setReadTimeout(15000); connection.setInstanceFollowRedirects(false);
        connection.setRequestProperty("Accept-Encoding", "identity");
        try {
            if (connection.getResponseCode() != 200) throw new java.io.IOException("HTTP " + connection.getResponseCode());
            long length = connection.getContentLengthLong();
            if (entry.bytes > 0 && length >= 0 && entry.bytes != length) throw new java.io.IOException("Media length changed");
            MessageDigest digest = MessageDigest.getInstance("SHA-256"); long count;
            try (InputStream input = connection.getInputStream(); OutputStream output = Files.newOutputStream(temporary)) {
                count = MediaTransfer.copy(input, output, entry.bytes > 0 ? entry.bytes : length, () -> false, n -> {}, digest);
            }
            Files.move(temporary, target); complete = true;
            StringBuilder hash = new StringBuilder(); for (byte b : digest.digest()) hash.append(String.format(Locale.ROOT, "%02x", b & 255));
            return new JSONObject().put("source", entry.path).put("local_file", target.toString()).put("bytes", count).put("sha256", hash.toString());
        } finally { connection.disconnect(); if (!complete) Files.deleteIfExists(temporary); }
    }
}
