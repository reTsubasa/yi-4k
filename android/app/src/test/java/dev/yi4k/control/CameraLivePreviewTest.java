package dev.yi4k.control;

import android.app.Activity;
import android.media.MediaCodecInfo;
import android.media.MediaFormat;
import android.net.Network;
import android.os.Looper;
import android.view.View;
import android.widget.FrameLayout;
import androidx.media3.common.Player;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.BooleanSupplier;
import java.util.function.Supplier;
import javax.net.SocketFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.Implementation;
import org.robolectric.annotation.Implements;
import org.robolectric.annotation.LooperMode;
import org.robolectric.shadow.api.Shadow;
import org.robolectric.shadows.MediaCodecInfoBuilder;
import org.robolectric.shadows.ShadowMediaCodecList;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29, shadows = CameraLivePreviewTest.BoundNetworkShadow.class)
@LooperMode(LooperMode.Mode.PAUSED)
public class CameraLivePreviewTest {
    @Test public void refusesTheDefaultNetworkBeforeCreatingAPlayerOrReplacingOwnerOverlays() {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            Activity activity = lifecycle.get();
            FrameLayout container = new FrameLayout(activity);
            View overlay = new View(activity);
            container.addView(overlay);
            List<String> statuses = new ArrayList<>();
            IOException error = assertThrows(IOException.class, () -> CameraLivePreview.start(activity, container,
                    null, "rtsp://192.168.42.1/live", statuses::add,
                    () -> fail("没有相机网络时不能宣称首帧已到达")));
            assertTrue(error.getMessage().contains("Wi-Fi"));
            assertEquals(1, container.getChildCount());
            assertSame(overlay, container.getChildAt(0));
            assertTrue(statuses.isEmpty());
        }
    }

    @Test public void rejectsClosingActivityBeforeOpeningAnyConnection() {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            Activity activity = lifecycle.get();
            FrameLayout container = new FrameLayout(activity);
            activity.finish();
            assertThrows(IllegalStateException.class, () -> CameraLivePreview.start(activity, container,
                    null, "rtsp://192.168.42.1/live", ignored -> {}, () -> {}));
            assertEquals(0, container.getChildCount());
        }
    }

    @Test public void rtspUsesSuppliedNetworkSocketFactoryAndTcpInterleavingThenClosesSocket() throws Exception {
        // Advertise a decoder so track selection can reach SETUP. No RTP payload is sent or decoded.
        MediaCodecInfo.CodecProfileLevel profile = new MediaCodecInfo.CodecProfileLevel();
        profile.profile = MediaCodecInfo.CodecProfileLevel.AVCProfileMain;
        profile.level = MediaCodecInfo.CodecProfileLevel.AVCLevel52;
        ShadowMediaCodecList.addCodec(MediaCodecInfoBuilder.newBuilder()
                .setName("OMX.google.h264.decoder").setIsEncoder(false)
                .setCapabilities(MediaCodecInfoBuilder.CodecCapabilitiesBuilder.newBuilder()
                        .setMediaFormat(MediaFormat.createVideoFormat("video/avc", 1920, 1080))
                        .setColorFormats(new int[] {MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface})
                        .setIsEncoder(false).setProfileLevels(new MediaCodecInfo.CodecProfileLevel[] {profile}).build())
                .build());
        try (LoopbackRtspServer server = new LoopbackRtspServer();
             ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            Activity activity = lifecycle.get();
            FrameLayout container = new FrameLayout(activity);
            View overlay = new View(activity);
            container.addView(overlay);
            activity.setContentView(container);
            RecordingSocketFactory factory = new RecordingSocketFactory(server.port());
            Network network = Shadow.newInstanceOf(Network.class);
            BoundNetworkShadow networkShadow = Shadow.extract(network);
            networkShadow.socketFactory = factory;
            List<String> statuses = new ArrayList<>();
            AtomicBoolean firstFrame = new AtomicBoolean();
            CameraLivePreview preview = CameraLivePreview.start(activity, container, network,
                    CameraPreviewAddress.validate("127.0.0.1", server.address()), statuses::add,
                    () -> firstFrame.set(true));
            Field playerField = CameraLivePreview.class.getDeclaredField("player");
            playerField.setAccessible(true);
            Player player = (Player) playerField.get(preview);
            try {
                await(() -> server.setupTransport.get() != null || preview.isClosed(),
                        () -> "RTSP SETUP 未到达；requests=" + server.methods + "; statuses=" + statuses
                                + "; server failure=" + server.failure.get());
                assertNull("Loopback RTSP server failed", server.failure.get());
                assertNotNull("实际播放器必须完成 SETUP；requests=" + server.methods + "; statuses=" + statuses
                                + "; player error=" + errorChain(player.getPlayerError()),
                        server.setupTransport.get());
                assertTrue("播放器必须向传入 Network 请求 SocketFactory", networkShadow.factoryRequests.get() > 0);
                assertEquals("唯一 RTSP 连接必须通过传入的 SocketFactory", 1, factory.sockets.size());
                assertTrue(server.methods.contains("OPTIONS"));
                assertTrue(server.methods.contains("DESCRIBE"));
                String transport = server.setupTransport.get().toUpperCase(Locale.ROOT);
                assertTrue("必须从首次 SETUP 就使用 TCP：" + transport, transport.contains("RTP/AVP/TCP"));
                assertTrue("必须使用 RTSP interleaved：" + transport, transport.contains("INTERLEAVED="));
                assertFalse("禁止 UDP client_port：" + transport, transport.contains("CLIENT_PORT="));
                assertFalse("服务器未发送视频，不能宣称已解码首帧", firstFrame.get());
            } finally {
                server.clientCloseExpected = true;
                preview.close();
                preview.close();
            }
            assertTrue(preview.isClosed());
            assertEquals("仅移除播放器自己的视图", 1, container.getChildCount());
            assertSame(overlay, container.getChildAt(0));
            await(() -> server.clientDisconnected.getCount() == 0,
                    () -> "关闭播放器后，RTSP 服务端未收到连接结束；server failure=" + server.failure.get());
            assertNull("Loopback RTSP server failed", server.failure.get());
            for (Socket socket : factory.sockets) assertTrue("RTSP socket 未释放", socket.isClosed());
        }
    }

    private static String errorChain(Throwable failure) {
        StringBuilder result = new StringBuilder();
        while (failure != null) { result.append(failure).append(" -> "); failure = failure.getCause(); }
        return result.toString();
    }

    private static void await(BooleanSupplier condition, Supplier<String> failure) throws Exception {
        long deadline = System.nanoTime() + TimeUnit.SECONDS.toNanos(8);
        while (!condition.getAsBoolean() && System.nanoTime() < deadline) {
            shadowOf(Looper.getMainLooper()).idle();
            Thread.sleep(10);
        }
        assertTrue(failure.get(), condition.getAsBoolean());
    }

    @Implements(Network.class)
    public static class BoundNetworkShadow {
        SocketFactory socketFactory;
        final AtomicInteger factoryRequests = new AtomicInteger();

        @Implementation protected SocketFactory getSocketFactory() {
            factoryRequests.incrementAndGet();
            if (socketFactory == null) throw new AssertionError("No bound test SocketFactory configured");
            return socketFactory;
        }
    }

    /** Every creation overload is restricted to this one literal loopback endpoint. */
    private static final class RecordingSocketFactory extends SocketFactory {
        final List<Socket> sockets = new CopyOnWriteArrayList<>();
        final int port;

        RecordingSocketFactory(int port) { this.port = port; }

        @Override public Socket createSocket(String host, int requestedPort) throws IOException {
            if (!"127.0.0.1".equals(host) || requestedPort != port)
                throw new IOException("Test forbids non-loopback RTSP connection: " + host + ":" + requestedPort);
            Socket socket = new Socket(loopback(), port);
            sockets.add(socket);
            return socket;
        }

        @Override public Socket createSocket(InetAddress host, int requestedPort) throws IOException {
            return createSocket(host.getHostAddress(), requestedPort);
        }

        @Override public Socket createSocket(String host, int requestedPort, InetAddress local, int localPort) throws IOException {
            if (!local.isLoopbackAddress()) throw new IOException("Test forbids non-loopback local binding");
            return createSocket(host, requestedPort);
        }

        @Override public Socket createSocket(InetAddress host, int requestedPort, InetAddress local, int localPort) throws IOException {
            return createSocket(host.getHostAddress(), requestedPort, local, localPort);
        }

        @Override public Socket createSocket() throws IOException {
            throw new IOException("Test requires the destination to be checked before creating a socket");
        }
    }

    private static InetAddress loopback() throws IOException {
        return InetAddress.getByAddress(new byte[] {127, 0, 0, 1});
    }

    /** Protocol-only peer: valid SDP and RTSP handshake, deliberately no RTP/video payloads. */
    private static final class LoopbackRtspServer implements AutoCloseable {
        final ServerSocket listener;
        final ExecutorService worker = Executors.newSingleThreadExecutor();
        final List<String> methods = Collections.synchronizedList(new ArrayList<>());
        final AtomicReference<String> setupTransport = new AtomicReference<>();
        final AtomicReference<Throwable> failure = new AtomicReference<>();
        final CountDownLatch clientDisconnected = new CountDownLatch(1);
        final Future<?> serving;
        volatile Socket client;
        volatile boolean closed;
        volatile boolean clientCloseExpected;

        LoopbackRtspServer() throws IOException {
            listener = new ServerSocket(0, 1, loopback());
            serving = worker.submit(this::serve);
        }

        int port() { return listener.getLocalPort(); }
        String address() { return "rtsp://127.0.0.1:" + port() + "/live"; }

        private void serve() {
            try (Socket accepted = listener.accept()) {
                client = accepted;
                BufferedReader input = new BufferedReader(new InputStreamReader(accepted.getInputStream(), StandardCharsets.US_ASCII));
                OutputStream output = accepted.getOutputStream();
                for (String line; (line = input.readLine()) != null;) {
                    if (line.isEmpty()) continue;
                    String method = line.split(" ", 2)[0];
                    methods.add(method);
                    Map<String, String> headers = new LinkedHashMap<>();
                    while ((line = input.readLine()) != null && !line.isEmpty()) {
                        int colon = line.indexOf(':');
                        if (colon > 0) headers.put(line.substring(0, colon).toLowerCase(Locale.ROOT), line.substring(colon + 1).trim());
                    }
                    String body = "";
                    String extra = "";
                    if ("OPTIONS".equals(method)) extra = "Public: OPTIONS, DESCRIBE, SETUP, PLAY, GET_PARAMETER, TEARDOWN\r\n";
                    else if ("DESCRIBE".equals(method)) {
                        body = "v=0\r\no=- 1 1 IN IP4 127.0.0.1\r\ns=Loopback transport test\r\nt=0 0\r\n"
                                + "a=range:npt=0-50.46\r\na=control:*\r\n"
                                + "m=video 0 RTP/AVP 96\r\nc=IN IP4 127.0.0.1\r\n"
                                + "a=rtpmap:96 H264/90000\r\n"
                                + "a=fmtp:96 packetization-mode=1;profile-level-id=4dE01E;"
                                + "sprop-parameter-sets=Z01AHpZ2BQHtgKBAAAOpgACvyA0YAgQAgRe98HhEI3A=,aN48gA==\r\n"
                                + "a=control:track1\r\n";
                        extra = "Content-Type: application/sdp\r\nContent-Base: " + address() + "/\r\n";
                    } else if ("SETUP".equals(method)) {
                        String transport = headers.get("transport");
                        if (transport == null) throw new IOException("SETUP omitted Transport");
                        setupTransport.set(transport);
                        extra = "Session: loopback-test;timeout=60\r\nTransport: " + transport + "\r\n";
                    } else if ("PLAY".equals(method)) {
                        extra = "Session: loopback-test\r\nRange: npt=0.000-\r\nRTP-Info: url="
                                + address() + "/track1;seq=0;rtptime=0\r\n";
                    } else if ("GET_PARAMETER".equals(method) || "TEARDOWN".equals(method)) {
                        extra = "Session: loopback-test\r\n";
                    } else throw new IOException("Unexpected RTSP method: " + method);
                    byte[] payload = body.getBytes(StandardCharsets.US_ASCII);
                    String response = "RTSP/1.0 200 OK\r\nCSeq: " + headers.get("cseq") + "\r\n"
                            + extra + "Content-Length: " + payload.length + "\r\n\r\n";
                    output.write(response.getBytes(StandardCharsets.US_ASCII));
                    output.write(payload);
                    output.flush();
                }
                clientDisconnected.countDown();
            } catch (SocketException stopped) {
                if (clientCloseExpected) clientDisconnected.countDown();
                else if (!closed) failure.set(stopped);
            } catch (Throwable problem) {
                if (!closed) failure.set(problem);
            }
        }

        @Override public void close() throws Exception {
            closed = true;
            listener.close();
            Socket active = client;
            if (active != null) active.close();
            worker.shutdownNow();
            serving.get(3, TimeUnit.SECONDS);
            assertTrue("Loopback server worker leaked", worker.awaitTermination(3, TimeUnit.SECONDS));
        }
    }
}
