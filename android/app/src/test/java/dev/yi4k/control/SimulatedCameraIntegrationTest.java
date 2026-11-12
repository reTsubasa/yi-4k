package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.util.*;
import static org.junit.Assert.*;

public class SimulatedCameraIntegrationTest {
    @Test public void loopbackCameraExercisesSessionConfigCaptureAndMediaExport() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera()) {
            CameraClient camera = new CameraClient(event -> {});
            try {
                camera.connect(javax.net.SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
                assertEquals(42, camera.call(257).optInt("param"));
                JSONObject settings = CameraClient.flattenSettings(camera.call(3));
                assertEquals("record", settings.getString("system_mode"));
                List<Object> options = CameraSettings.writableOptions("video_quality", camera.call(9, CameraClient.args("param", "video_quality")));
                assertTrue(options.contains("Normal"));
                camera.call(2, CameraClient.args("type", "video_quality").put("param", "Normal"));
                assertEquals("Normal", camera.call(1, CameraClient.args("type", "video_quality")).getString("param"));
                camera.call(513);
                assertEquals("record", camera.call(1, CameraClient.args("type", "app_status")).getString("param"));
                camera.call(514);
                assertTrue(CameraState.isReady(camera.call(1, CameraClient.args("type", "app_status")).getString("param")));
                Map<String, String> media = new LinkedHashMap<>();
                media.put("100MEDIA/", "2|date");
                JSONObject listing = camera.call(1282, CameraClient.args("param", MediaEntry.DCIM_ROOT));
                assertEquals(1, listing.getJSONArray("listing").length());
                JSONObject files = camera.call(1282, CameraClient.args("param", MediaEntry.DCIM_ROOT + "100MEDIA/"));
                JSONArray rows = files.getJSONArray("listing");
                assertTrue(rows.length() >= 2);
                MediaEntry entry = null;
                for (int i = 0; i < rows.length(); i++) {
                    JSONObject row = rows.getJSONObject(i);
                    Iterator<String> keys = row.keys();
                    while (keys.hasNext()) {
                        String name = keys.next();
                        if (name.endsWith(".JPG")) entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", name, row.getString(name));
                    }
                }
                assertNotNull(entry);
                URL url = entry.uri("127.0.0.1", server.httpPort()).toURL();
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                try {
                    assertEquals(200, connection.getResponseCode());
                    Path temporary = Files.createTempFile("yi4k-simulated-", ".jpg");
                    try (InputStream input = connection.getInputStream(); OutputStream output = Files.newOutputStream(temporary)) {
                        long count = MediaTransfer.copy(input, output, entry.bytes, () -> false, n -> {}, MessageDigest.getInstance("SHA-256"));
                        assertEquals(entry.bytes, count);
                    } finally { Files.deleteIfExists(temporary); }
                } finally { connection.disconnect(); }
                assertTrue(server.requests.containsAll(Arrays.asList(257, 3, 9, 2, 513, 514, 1282)));
            } finally { camera.disconnect(); }
            assertTrue(server.failures.toString(), server.failures.isEmpty());
        }
    }

    @Test public void loopbackCancelStopsSlowTransferBeforeExpectedLength() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera()) {
            CameraClient camera = new CameraClient(event -> {});
            try {
                camera.connect(javax.net.SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
                JSONObject files = camera.call(1282, CameraClient.args("param", MediaEntry.DCIM_ROOT + "100MEDIA/"));
                MediaEntry entry = null;
                for (int i = 0; i < files.getJSONArray("listing").length(); i++) {
                    JSONObject row = files.getJSONArray("listing").getJSONObject(i);
                    Iterator<String> keys = row.keys();
                    while (keys.hasNext()) {
                        String name = keys.next();
                        if (name.contains("CANCEL")) entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", name, row.getString(name));
                    }
                }
                assertNotNull(entry);
                HttpURLConnection connection = (HttpURLConnection) entry.uri("127.0.0.1", server.httpPort()).toURL().openConnection();
                try {
                    assertEquals(200, connection.getResponseCode());
                    java.util.concurrent.atomic.AtomicBoolean cancel = new java.util.concurrent.atomic.AtomicBoolean();
                    Path temporary = Files.createTempFile("yi4k-cancel-", ".part");
                    try (InputStream input = connection.getInputStream(); OutputStream output = Files.newOutputStream(temporary)) {
                        try {
                            MediaTransfer.copy(input, output, entry.bytes, () -> { boolean was = cancel.get(); cancel.set(true); return was; },
                                    n -> {}, MessageDigest.getInstance("SHA-256"));
                            fail("transfer should cancel");
                        } catch (java.io.IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
                    } finally { Files.deleteIfExists(temporary); }
                } finally { connection.disconnect(); }
            } finally { camera.disconnect(); }
        }
    }

    @Test public void reconnectResynchronizesAfterUncertainStartWithoutRetryingIt() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera()) {
            CameraClient camera = new CameraClient(event -> {}, 250);
            try {
                camera.connect(javax.net.SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
                // Configuration writes use the same no-retry rule: the camera may have
                // applied the value even when its response is lost.
                server.dropNextResponseFor(2);
                try { camera.call(2, CameraClient.args("type", "video_quality").put("param", "Normal"));
                    fail("uncertain configuration must not be retried"); }
                catch (java.io.IOException expected) { }
                assertFalse(camera.isConnected());
                camera.connect(javax.net.SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
                assertEquals("Normal", camera.call(1, CameraClient.args("type", "video_quality")).getString("param"));

                // The fixture applies START before dropping the response. This models a
                // real network loss where retrying could create a duplicate recording.
                server.dropNextResponseFor(513);
                try { camera.call(513); fail("uncertain START must not be retried"); }
                catch (java.io.IOException expected) { }
                assertFalse(camera.isConnected());

                camera.connect(javax.net.SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
                assertEquals("record", camera.call(1, CameraClient.args("type", "app_status")).getString("param"));
                camera.call(514);
                assertTrue(CameraState.isReady(camera.call(1, CameraClient.args("type", "app_status")).getString("param")));
            } finally { camera.disconnect(); }
            assertTrue(server.failures.toString(), server.failures.isEmpty());
        }
    }
}
