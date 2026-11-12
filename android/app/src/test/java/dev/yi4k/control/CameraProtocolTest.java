package dev.yi4k.control;

import org.junit.Test;
import org.json.JSONObject;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.StringReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import javax.net.SocketFactory;
import static org.junit.Assert.*;

public class CameraProtocolTest {
    private static final String NETWORK_BIND_PENDING = "Binding socket to network 102 failed: EPERM (Operation not permitted)";
    abstract static class UnconnectedFactory extends SocketFactory {
        @Override public Socket createSocket(String host, int port) { throw new UnsupportedOperationException(); }
        @Override public Socket createSocket(String host, int port, InetAddress local, int localPort) { throw new UnsupportedOperationException(); }
        @Override public Socket createSocket(InetAddress host, int port) { throw new UnsupportedOperationException(); }
        @Override public Socket createSocket(InetAddress host, int port, InetAddress local, int localPort) { throw new UnsupportedOperationException(); }
    }
    interface Peer { void run(Socket socket) throws Exception; }
    static final class Rig implements AutoCloseable {
        final ServerSocket server = new ServerSocket(0);
        final ExecutorService executor = Executors.newSingleThreadExecutor();
        final Future<?> peer;
        Rig(Peer action) throws Exception {
            peer = executor.submit(() -> { try (Socket s = server.accept()) { s.setSoTimeout(2000); action.run(s); } catch (Exception e) { throw new RuntimeException(e); } });
        }
        int port() { return server.getLocalPort(); }
        @Override public void close() throws Exception { try { peer.get(4, TimeUnit.SECONDS); } finally { server.close(); executor.shutdownNow(); } }
    }
    static JSONObject request(JsonObjectStream reader, int id, int token) throws Exception {
        JSONObject object = new JSONObject(reader.next()); assertEquals(id, object.getInt("msg_id")); assertEquals(token, object.getInt("token")); return object;
    }
    static void send(Socket s, String value) throws Exception { s.getOutputStream().write(value.getBytes(StandardCharsets.UTF_8)); s.getOutputStream().flush(); }
    static JsonObjectStream reader(Socket s) throws Exception { return new JsonObjectStream(new InputStreamReader(s.getInputStream(), StandardCharsets.UTF_8), 65536); }
    @Test public void pendingNetworkBindRetriesBeforeOneSessionHandshake() throws Exception {
        AtomicInteger attempts = new AtomicInteger();
        SocketFactory factory = new UnconnectedFactory() {
            @Override public Socket createSocket() throws IOException {
                if (attempts.incrementAndGet() <= 3) throw new IOException(NETWORK_BIND_PENDING);
                return new Socket();
            }
        };
        try (Rig rig = new Rig(s -> {
            JsonObjectStream r = reader(s);
            request(r,257,0); send(s,"{\"rval\":0,\"msg_id\":257,\"param\":9}");
            request(r,258,9); send(s,"{\"rval\":0,\"msg_id\":258}");
            assertEquals(-1,s.getInputStream().read());
        }); CameraClient client = new CameraClient(e -> {})) {
            client.connect(factory,"127.0.0.1",rig.port());
            assertTrue(client.isConnected());
            assertEquals(4,attempts.get());
            client.disconnect();
        }
    }
    @Test public void unrelatedSocketCreationFailureIsNotRetried() throws Exception {
        AtomicInteger attempts = new AtomicInteger();
        IOException failure = new IOException("Network is unreachable");
        SocketFactory factory = new UnconnectedFactory() {
            @Override public Socket createSocket() throws IOException { attempts.incrementAndGet(); throw failure; }
        };
        try (CameraClient client = new CameraClient(e -> {})) {
            try { client.connect(factory,"127.0.0.1",1); fail(); }
            catch (IOException expected) { assertSame(failure,expected); }
            assertEquals(1,attempts.get()); assertFalse(client.isConnected());
        }
    }
    @Test public void pendingNetworkBindHasABoundedChineseFailure() throws Exception {
        AtomicInteger attempts = new AtomicInteger();
        SocketFactory factory = new UnconnectedFactory() {
            @Override public Socket createSocket() throws IOException { attempts.incrementAndGet(); throw new IOException(NETWORK_BIND_PENDING); }
        };
        try (CameraClient client = new CameraClient(e -> {})) {
            long started = System.nanoTime();
            try { client.connect(factory,"127.0.0.1",1); fail(); }
            catch (IOException expected) {
                assertEquals("相机 Wi-Fi 尚未就绪，请稍候重新连接",expected.getMessage());
                assertEquals(NETWORK_BIND_PENDING,expected.getCause().getMessage());
            }
            assertTrue(TimeUnit.NANOSECONDS.toMillis(System.nanoTime()-started)<6000);
            assertTrue(attempts.get()>1); assertFalse(client.isConnected());
        }
    }
    @Test public void closeCancelsNetworkBindRecoveryAndClosesLateSocket() throws Exception {
        AtomicInteger attempts = new AtomicInteger();
        CountDownLatch creating = new CountDownLatch(1), release = new CountDownLatch(1);
        Socket lateSocket = new Socket();
        ExecutorService worker = Executors.newSingleThreadExecutor();
        SocketFactory factory = new UnconnectedFactory() {
            @Override public Socket createSocket() throws IOException {
                if (attempts.incrementAndGet()==1) throw new IOException(NETWORK_BIND_PENDING);
                creating.countDown();
                try { if (!release.await(2,TimeUnit.SECONDS)) throw new IOException("test gate timed out"); }
                catch (InterruptedException e) { Thread.currentThread().interrupt(); throw new IOException(e); }
                return lateSocket;
            }
        };
        try (CameraClient client = new CameraClient(e -> {})) {
            Future<Exception> result = worker.submit(() -> {
                try { client.connect(factory,"127.0.0.1",1); return null; }
                catch (Exception e) { return e; }
            });
            assertTrue(creating.await(2,TimeUnit.SECONDS));
            client.close(); release.countDown();
            Exception error = result.get(2,TimeUnit.SECONDS);
            assertNotNull(error); assertEquals("连接已取消",error.getMessage());
            assertTrue(lateSocket.isClosed()); assertFalse(client.isConnected());
            assertEquals(2,attempts.get());
        } finally { release.countDown(); lateSocket.close(); worker.shutdownNow(); }
    }
    @Test public void realStreamFramingWithEscapesUnicodeAndNotifications() throws Exception {
        ArrayList<JSONObject> events = new ArrayList<>();
        try (Rig rig = new Rig(s -> {
            JsonObjectStream r = reader(s); request(r, 257, 0);
            byte[] response = "{\"rval\":0,\"msg_id\":257,\"param\":42}".getBytes(StandardCharsets.UTF_8);
            for (byte b : response) { s.getOutputStream().write(b); s.getOutputStream().flush(); }
            JSONObject q = request(r, 1, 42); assertEquals("app_status", q.getString("type"));
            send(s, "{\"msg_id\":7,\"type\":\"通知}\\\"[{\"}{\"rval\":0,\"msg_id\":1,\"param\":\"idle\"}");
            request(r, 258, 42); send(s, "{\"rval\":0,\"msg_id\":258}");
        }); CameraClient client = new CameraClient(events::add)) {
            client.connect(SocketFactory.getDefault(), "127.0.0.1", rig.port());
            assertEquals("idle", client.call(1, CameraClient.args("type", "app_status")).getString("param"));
            assertEquals(1, events.size()); assertTrue(events.get(0).getString("type").contains("通知"));
            client.disconnect(); assertFalse(client.isConnected());
        }
    }
    @Test public void rejectionIsNotConnectionLossOrAnAutomaticRetry() throws Exception {
        try (Rig rig = new Rig(s -> {
            JsonObjectStream r = reader(s); request(r,257,0); send(s,"{\"rval\":0,\"msg_id\":257,\"param\":9}");
            request(r,513,9); send(s,"{\"rval\":-7,\"msg_id\":513}");
            request(r,1,9); send(s,"{\"rval\":0,\"msg_id\":1,\"param\":\"idle\"}");
        }); CameraClient client = new CameraClient(e -> {})) {
            client.connect(SocketFactory.getDefault(),"127.0.0.1",rig.port());
            try { client.call(513); fail(); } catch (CameraClient.CameraRejectedException e) { assertEquals(-7,e.code); }
            assertTrue(client.isConnected()); assertEquals("idle",client.call(1).getString("param"));
        }
    }
    @Test public void timeoutInvalidatesSessionInsteadOfRetryingRecording() throws Exception {
        try (Rig rig = new Rig(s -> {
            JsonObjectStream r = reader(s); request(r,257,0); send(s,"{\"rval\":0,\"msg_id\":257,\"param\":9}");
            request(r,513,9); assertEquals(-1,s.getInputStream().read());
        }); CameraClient client = new CameraClient(e -> {},150)) {
            client.connect(SocketFactory.getDefault(),"127.0.0.1",rig.port());
            try { client.call(513); fail(); } catch (java.net.SocketTimeoutException expected) { }
            assertFalse(client.isConnected());
            try { client.call(513); fail(); } catch (java.io.IOException expected) { }
        }
    }
    @Test public void eofAndOversizedFramesAreRejected() throws Exception {
        for (String value : new String[]{"{\"incomplete\":", "{\"tooLong\":\"1234567890123456789\"}"}) {
            try { new JsonObjectStream(new StringReader(value),20).next(); fail(); } catch (java.io.IOException expected) { }
        }
    }
    @Test public void cameraListingPathsCannotEscapeDcimOrBecomeUrls() throws Exception {
        MediaEntry entry = new MediaEntry("/tmp/fuse_d/DCIM/100MEDIA/","YDXJ0140.MP4","9626737 bytes|2014-01-01");
        assertEquals(9626737,entry.bytes); assertEquals("http://192.168.42.1:80/DCIM/100MEDIA/YDXJ0140.MP4",entry.uri("192.168.42.1").toString());
        assertTrue(new MediaEntry("/tmp/fuse_d/DCIM/","100MEDIA/","13|date").directory);
        for (String name : new String[]{"../secret.MP4", "/secret.JPG", "evil%2f.MP4", "http:x.JPG", "a\\b.JPG"}) {
            try { new MediaEntry("/tmp/fuse_d/DCIM/",name,"1 bytes|date"); fail(name); } catch (IllegalArgumentException expected) { }
        }
    }
    @Test public void flattenRetainsSettingsFromEveryObject() throws Exception {
        JSONObject settings = CameraClient.flattenSettings(new JSONObject("{\"param\":[{\"system_mode\":\"record\"},{\"iq_eis_enable\":\"on\",\"video_quality\":\"S.Fine\"}]}"));
        assertEquals(3, settings.length()); assertEquals("on", settings.getString("iq_eis_enable"));
    }
}
