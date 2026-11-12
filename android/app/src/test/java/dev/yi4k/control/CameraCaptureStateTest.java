package dev.yi4k.control;

import org.json.JSONObject;
import org.junit.Test;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import javax.net.SocketFactory;
import static org.junit.Assert.*;

/** Loopback protocol sequences; never contacts a camera or sends capture commands. */
public final class CameraCaptureStateTest {
    @Test public void startWaitsForActualRecordingState() throws Exception {
        verify(513, "idle", "Unknown", "record");
    }
    @Test public void stopWaitsThroughUnknownAndRecordingUntilReady() throws Exception {
        verify(514, "record", "Unknown", "Unknown", "vf");
    }
    @Test public void photographWaitsUntilCaptureAndUnknownHaveCleared() throws Exception {
        verify(16777220, "capture", "Unknown", "idle");
    }
    @Test public void unresolvedStateTimesOutWithoutRetryingCaptureOrClaimingReady() throws Exception {
        try (StateCamera server = new StateCamera("Unknown"); CameraClient camera = server.connect()) {
            try { CameraState.awaitCaptureState(camera, 514, 0); fail("Unknown is not ready"); }
            catch (java.io.IOException expected) { assertTrue(expected.getMessage().contains("尚未确认")); }
            assertEquals(Arrays.asList(257, 1), server.requests);
        }
    }
    private static void verify(int request, String... states) throws Exception {
        try (StateCamera server = new StateCamera(states); CameraClient camera = server.connect()) {
            assertEquals(states[states.length - 1], CameraState.awaitCaptureState(camera, request, 2000));
            assertEquals(states.length + 1, server.requests.size());
            assertEquals(Integer.valueOf(257), server.requests.get(0));
            for (int i = 1; i < server.requests.size(); i++) assertEquals(Integer.valueOf(1), server.requests.get(i));
        }
    }
    private static final class StateCamera implements AutoCloseable {
        private final ServerSocket listener = new ServerSocket(0, 1, InetAddress.getByName("127.0.0.1"));
        private final ExecutorService worker = Executors.newSingleThreadExecutor();
        final List<Integer> requests = new java.util.concurrent.CopyOnWriteArrayList<>();
        private volatile Socket active;
        StateCamera(String... states) throws Exception {
            worker.submit(() -> {
                try (Socket socket = listener.accept()) {
                    active = socket;
                    JsonObjectStream input = new JsonObjectStream(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8), 4096);
                    int next = 0;
                    for (;;) {
                        JSONObject request = new JSONObject(input.next());
                        int id = request.getInt("msg_id"); requests.add(id);
                        JSONObject reply = new JSONObject().put("msg_id", id).put("rval", 0);
                        if (id == 257) reply.put("param", 17);
                        else if (id == 1) {
                            assertEquals("app_status", request.getString("type"));
                            reply.put("param", states[Math.min(next++, states.length - 1)]);
                        } else if (id != 258) reply.put("rval", -7);
                        socket.getOutputStream().write(reply.toString().getBytes(StandardCharsets.UTF_8));
                        socket.getOutputStream().flush();
                        if (id == 258) return;
                    }
                } catch (Exception ignored) { /* The test owns and closes this socket. */ }
            });
        }
        CameraClient connect() throws Exception {
            CameraClient camera = new CameraClient(event -> {}, 500);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", listener.getLocalPort()); return camera;
        }
        @Override public void close() throws Exception {
            listener.close(); if (active != null) active.close();
            worker.shutdownNow(); worker.awaitTermination(2, TimeUnit.SECONDS);
        }
    }
}
