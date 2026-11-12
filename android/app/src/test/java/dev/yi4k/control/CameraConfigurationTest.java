package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.stream.Collectors;
import javax.net.SocketFactory;
import static org.junit.Assert.*;

public final class CameraConfigurationTest {
    @Test public void liveProbeRestoresTimelapseAndInactiveBurstPreference() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.values.put("rec_mode", "record_timelapse");
            server.values.put("capture_mode", "burst quality");
            JSONObject before = new JSONObject(server.values);
            LinkedHashMap<String, Object> restore = new LinkedHashMap<>();
            CameraLiveProbe.changeMode(client, restore, before, "record");
            CameraLiveProbe.changeMode(client, restore, before, "capture");
            assertEquals("precise quality", server.values.get("capture_mode"));
            JSONArray cleanup = new JSONArray();
            CameraLiveProbe.restoreSettings(client, restore, cleanup);
            assertEquals("record", server.values.get("system_mode"));
            assertEquals("record_timelapse", server.values.get("rec_mode"));
            assertEquals("burst quality", server.values.get("capture_mode"));
            assertEquals("system_mode", cleanup.getJSONObject(cleanup.length() - 1).getString("restored_key"));
            assertFalse(server.writes().stream().anyMatch(w -> w.startsWith("system_mode=")));
        }
    }

    @Test public void liveProbeRestoresPhotoParentAfterUncertainChildWrite() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.values.put("system_mode", "capture");
            server.values.put("capture_mode", "burst quality");
            server.values.put("rec_mode", "record_slow_motion");
            JSONObject before = new JSONObject(server.values);
            LinkedHashMap<String, Object> restore = new LinkedHashMap<>();
            server.dropWriteResponse = true;
            expectIOException(() -> CameraLiveProbe.changeMode(client, restore, before, "record"), "写入结果未确认");
            assertEquals("record", server.values.get("system_mode"));
            assertEquals("record_slow_motion", restore.get("rec_mode"));
            client.connect(SocketFactory.getDefault(), "127.0.0.1", server.port());
            CameraLiveProbe.restoreSettings(client, restore, new JSONArray());
            assertEquals("capture", server.values.get("system_mode"));
            assertEquals("burst quality", server.values.get("capture_mode"));
            assertEquals("record_slow_motion", server.values.get("rec_mode"));
            assertFalse(server.writes().stream().anyMatch(w -> w.startsWith("system_mode=")));
        }
    }

    @Test public void verifiedPhotoAndVideoSubmodesUseCameraAdvertisedValues() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            CameraConfiguration.selectMode(client, "capture");
            assertEquals("capture", server.values.get("system_mode"));
            assertEquals(Arrays.asList("capture_mode=precise quality"), server.writes());
            CameraConfiguration.selectMode(client, "timelapse");
            assertEquals("record", server.values.get("system_mode"));
            assertEquals("record_timelapse", server.values.get("rec_mode"));
            CameraConfiguration.selectMode(client, "slow_motion");
            assertEquals("record_slow_motion", server.values.get("rec_mode"));
            CameraConfiguration.selectMode(client, "record");
            assertEquals("record", server.values.get("rec_mode"));
            assertEquals(Arrays.asList("capture_mode=precise quality",
                    "rec_mode=record_timelapse", "rec_mode=record_slow_motion", "rec_mode=record"), server.writes());
            // Every successful write is immediately followed by its own readback.
            for (int i = 0; i < server.requests.size(); i++) {
                JSONObject request = server.requests.get(i);
                if (request.optInt("msg_id") == 2) {
                    JSONObject next = server.requests.get(i + 1);
                    assertEquals(1, next.getInt("msg_id"));
                    assertEquals(request.getString("type"), next.getString("type"));
                }
            }
        }
    }

    @Test public void alreadySelectedModeDoesNotWriteOrDemandWritablePermission() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.readonly.add("system_mode"); server.readonly.add("rec_mode");
            CameraConfiguration.selectMode(client, "record");
            assertTrue(server.writes().isEmpty());
        }
    }

    @Test public void unadvertisedOrReadonlyModesNeverSendAWrite() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.options.put("rec_mode", new JSONArray().put("record"));
            expectIOException(() -> CameraConfiguration.selectMode(client, "timelapse"), "不支持");
            server.readonly.add("capture_mode");
            expectIOException(() -> CameraConfiguration.selectMode(client, "capture"), "不支持");
            assertTrue(server.writes().isEmpty());
        }
    }

    @Test public void busyCameraNeverWritesEvenIfOptionsAreAdvertised() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.status = "record";
            expectIOException(() -> CameraConfiguration.selectMode(client, "capture"), "停止拍摄");
            assertTrue(server.writes().isEmpty());
        }
    }

    @Test public void statusIsRecheckedAfterReadingOptionsBeforeWrite() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.becomeBusyOnOptions = true;
            expectIOException(() -> CameraConfiguration.set(client, "system_mode", "capture"), "停止拍摄");
            assertTrue(server.writes().isEmpty());
        }
    }

    @Test public void acknowledgedUnappliedChildDoesNotCountAsParentModeSwitch() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.ignoreWrites = true;
            expectIOException(() -> CameraConfiguration.selectMode(client, "capture"), "未生效");
            assertEquals(Arrays.asList("capture_mode=precise quality"), server.writes());
            assertEquals("record", server.values.get("system_mode"));
        }
    }

    @Test public void systemModeSettingReappliesUnchangedChildWithoutFakeParentWrite() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            CameraConfiguration.set(client, "system_mode", "capture");
            CameraConfiguration.selectMode(client, "record");
            assertEquals(Arrays.asList("capture_mode=precise quality", "rec_mode=record"), server.writes());
            assertEquals("record", server.values.get("system_mode"));
            CameraConfiguration.set(client, "system_mode", "record");
            assertEquals(2, server.writes().size());
        }
    }

    @Test public void delayedModeEventIsObservedWithoutResendingAppliedWrite() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.parentDelayReads = 2;
            CameraConfiguration.selectMode(client, "capture");
            assertEquals("capture", server.values.get("system_mode"));
            assertEquals(Arrays.asList("capture_mode=precise quality"), server.writes());
        }
    }

    @Test public void matchingReadbackButNewlyBusyCameraIsNotReportedReady() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.becomeBusyAfterWrite = true;
            expectIOException(() -> CameraConfiguration.selectMode(client, "capture"), "停止拍摄");
            assertEquals("capture", server.values.get("system_mode"));
            assertEquals(Arrays.asList("capture_mode=precise quality"), server.writes());
        }
    }

    @Test public void lostAppliedWriteIsReportedWithoutRetryOrRollback() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.dropWriteResponse = true;
            expectIOException(() -> CameraConfiguration.selectMode(client, "capture"), "写入结果未确认");
            assertFalse(client.isConnected());
            assertEquals("capture", server.values.get("system_mode"));
            assertEquals(Arrays.asList("capture_mode=precise quality"), server.writes());
            client.connect(SocketFactory.getDefault(), "127.0.0.1", server.port());
            assertEquals("capture", client.call(1, CameraClient.args("type", "system_mode")).getString("param"));
            assertEquals(1, server.writes().size());
        }
    }

    @Test public void scalarTypesStayExactAndDangerousOrUnknownInputsAreRejected() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.values.put("test_scalar", false);
            server.options.put("test_scalar", new JSONArray().put(false).put(true).put(3));
            CameraConfiguration.set(client, "test_scalar", true);
            assertEquals(Boolean.TRUE, server.values.get("test_scalar"));
            expectIOException(() -> CameraConfiguration.set(client, "test_scalar", "true"), "不支持");
            try { CameraConfiguration.selectMode(client, "future_mode"); fail(); }
            catch (IllegalArgumentException expected) { }
            try { CameraConfiguration.set(client, "factory_reset", "on"); fail(); }
            catch (IllegalArgumentException expected) { }
            assertEquals(Arrays.asList("test_scalar=true"), server.writes());
        }
    }

    @Test public void syncClockWritesAndroidTimeAndVerifiesCameraReadback() throws Exception {
        try (ProtocolCamera server = new ProtocolCamera(); CameraClient client = server.connect()) {
            server.values.put("camera_clock", "2014-01-01 00:00:00");
            Clock fixed = Clock.fixed(Instant.parse("2026-11-12T03:04:05Z"), ZoneOffset.UTC);
            assertEquals("2026-11-12 03:04:05", CameraConfiguration.syncClock(client, fixed));
            assertEquals(Arrays.asList("camera_clock=2026-11-12 03:04:05"), server.writes());
        }
    }

    private interface Action { void run() throws Exception; }
    private static void expectIOException(Action action, String text) throws Exception {
        try { action.run(); fail("expected IOException"); }
        catch (IOException expected) { assertTrue(expected.getMessage(), expected.getMessage().contains(text)); }
    }

    /** Explicit loopback-only protocol fixture, with no real camera network. */
    private static final class ProtocolCamera implements AutoCloseable {
        private final ServerSocket listener = new ServerSocket(0, 4, InetAddress.getByName("127.0.0.1"));
        private final ExecutorService worker = Executors.newSingleThreadExecutor();
        private final List<JSONObject> requests = new CopyOnWriteArrayList<>();
        private final Map<String, Object> values = new ConcurrentHashMap<>();
        private final Map<String, JSONArray> options = new ConcurrentHashMap<>();
        private final Set<String> readonly = ConcurrentHashMap.newKeySet();
        private volatile Socket active;
        private volatile String status = "idle";
        private volatile boolean closed, becomeBusyOnOptions, ignoreWrites, dropWriteResponse;
        private volatile boolean becomeBusyAfterWrite;
        private volatile int parentDelayReads;
        private String pendingParent;

        ProtocolCamera() throws Exception {
            values.put("system_mode", "record"); values.put("rec_mode", "record");
            values.put("capture_mode", "precise quality");
            options.put("system_mode", new JSONArray().put("record").put("capture"));
            options.put("capture_mode", new JSONArray().put("precise quality").put("burst quality"));
            options.put("rec_mode", new JSONArray().put("record").put("record_timelapse").put("record_slow_motion"));
            worker.submit(() -> {
                while (!closed) try (Socket socket = listener.accept()) {
                    active = socket; serve(socket);
                } catch (Exception e) {
                    if (!closed) throw new RuntimeException(e);
                } finally { active = null; }
            });
        }

        private void serve(Socket socket) throws Exception {
            JsonObjectStream stream = new JsonObjectStream(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8), 4096);
            while (!closed) {
                JSONObject request;
                try { request = new JSONObject(stream.next()); }
                catch (java.io.EOFException end) { return; }
                requests.add(request);
                int id = request.getInt("msg_id");
                JSONObject response = new JSONObject().put("msg_id", id).put("rval", 0);
                if (id == 257) response.put("param", 17);
                else if (id == 1) {
                    String key = request.getString("type");
                    if ("system_mode".equals(key) && pendingParent != null && parentDelayReads-- <= 0) {
                        values.put("system_mode", pendingParent); pendingParent = null;
                    }
                    response.put("param", "app_status".equals(key) ? status : values.get(key));
                } else if (id == 9) {
                    String key = request.getString("param");
                    response.put("permission", readonly.contains(key) ? "readonly" : "settable");
                    response.put("options", options.get(key));
                    if (becomeBusyOnOptions) status = "record";
                } else if (id == 2) {
                    String key = request.getString("type");
                    // Mirror the observed stock protocol: parent writes only
                    // acknowledge; child writes dispatch the actual mode event.
                    if (!ignoreWrites && !"system_mode".equals(key)) {
                        values.put(key, request.get("param"));
                        if ("capture_mode".equals(key) || "rec_mode".equals(key)) {
                            String parent = "capture_mode".equals(key) ? "capture" : "record";
                            if (parentDelayReads > 0) pendingParent = parent;
                            else values.put("system_mode", parent);
                        }
                    }
                    if (dropWriteResponse) { dropWriteResponse = false; return; }
                    if (becomeBusyAfterWrite) status = "record";
                } else if (id != 258) response.put("rval", -7);
                socket.getOutputStream().write(response.toString().getBytes(StandardCharsets.UTF_8));
                socket.getOutputStream().flush();
                if (id == 258) return;
            }
        }
        int port() { return listener.getLocalPort(); }
        CameraClient connect() throws Exception {
            CameraClient client = new CameraClient(event -> {}, 500);
            client.connect(SocketFactory.getDefault(), "127.0.0.1", port()); return client;
        }
        List<String> writes() {
            return requests.stream().filter(item -> item.optInt("msg_id") == 2)
                    .map(item -> item.optString("type") + "=" + item.opt("param")).collect(Collectors.toList());
        }
        @Override public void close() throws Exception {
            closed = true; listener.close(); Socket socket = active; if (socket != null) socket.close();
            worker.shutdownNow(); worker.awaitTermination(2, TimeUnit.SECONDS);
        }
    }
}
