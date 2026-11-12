package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.Closeable;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import javax.net.SocketFactory;

/** Single owner session; serialized requests; never retries an uncertain mutation. */
public final class CameraClient implements Closeable {
    private final Object lifecycleLock = new Object();
    private volatile long sessionGeneration;
    private volatile Socket socket;
    private JsonObjectStream input;
    private int token;
    private volatile String advertisedRtsp = "";
    private final int timeoutMs;
    private final java.util.function.Consumer<JSONObject> events;
    public CameraClient(java.util.function.Consumer<JSONObject> events) { this(events, 8000); }
    CameraClient(java.util.function.Consumer<JSONObject> events, int timeoutMs) { this.events = events; this.timeoutMs = timeoutMs; }
    public synchronized void connect(SocketFactory factory, String host, int port) throws Exception {
        long generation = closeSession();
        Socket next = createSessionSocket(factory, generation);
        try {
            synchronized (lifecycleLock) {
                if (generation != sessionGeneration) throw new IOException("连接已取消");
                socket = next;
            }
            next.connect(new InetSocketAddress(host, port), 5000);
            next.setSoTimeout(timeoutMs);
            input = new JsonObjectStream(new InputStreamReader(next.getInputStream(), StandardCharsets.UTF_8), 2 * 1024 * 1024);
            JSONObject reply = call(257, new JSONObject());
            synchronized (lifecycleLock) {
                if (generation != sessionGeneration) throw new IOException("连接已取消");
                token = reply.getInt("param");
                if (token <= 0) throw new IOException("相机会话令牌无效");
                advertisedRtsp = reply.optString("rtsp", "");
            }
        } catch (Exception e) {
            try { next.close(); } catch (IOException ignored) { }
            close(); throw e;
        }
    }
    private Socket createSessionSocket(SocketFactory factory, long generation) throws Exception {
        long deadline = System.nanoTime() + 3_000_000_000L;
        for (;;) {
            if (generation != sessionGeneration) throw new IOException("连接已取消");
            try { return factory.createSocket(); }
            catch (IOException error) {
                // A newly listed Android Network can precede netd's socket
                // permission update. Only retry this local, unconnected bind:
                // no TCP connection or camera command has been sent yet.
                String message = error.getMessage();
                boolean pendingPermission = message != null && message.contains("Binding socket to network") && message.contains("EPERM");
                if (!pendingPermission) throw error;
                if (System.nanoTime() >= deadline)
                    throw new IOException("相机 Wi-Fi 尚未就绪，请稍候重新连接", error);
                Thread.sleep(100);
            }
        }
    }
    public synchronized JSONObject call(int id, JSONObject args) throws Exception {
        Socket current = socket;
        if (current == null || current.isClosed()) throw new IOException("请先连接相机");
        JSONObject request = new JSONObject(args.toString());
        request.put("msg_id", id).put("token", token);
        try {
            current.getOutputStream().write(request.toString().getBytes(StandardCharsets.UTF_8));
            current.getOutputStream().flush();
            long deadline = System.nanoTime() + timeoutMs * 1_000_000L;
            for (;;) {
                long left = deadline - System.nanoTime();
                if (left <= 0) throw new java.net.SocketTimeoutException("相机响应超时；请重连并检查实际状态");
                current.setSoTimeout((int) Math.max(1, left / 1_000_000));
                JSONObject reply = new JSONObject(input.next());
                if (reply.optInt("msg_id", -1) == id && reply.has("rval")) {
                    if (reply.getInt("rval") != 0) throw new CameraRejectedException(reply.getInt("rval"));
                    return reply;
                }
                events.accept(reply);
            }
        } catch (CameraRejectedException e) { throw e; }
        catch (Exception e) { close(); throw e; }
    }
    public JSONObject call(int id) throws Exception { return call(id, new JSONObject()); }
    public static JSONObject args(String key, Object value) throws JSONException { return new JSONObject().put(key, value); }
    public static JSONObject flattenSettings(JSONObject response) throws JSONException {
        JSONObject result = new JSONObject();
        JSONArray array = response.getJSONArray("param");
        for (int i = 0; i < array.length(); i++) {
            JSONObject item = array.getJSONObject(i);
            java.util.Iterator<String> keys = item.keys();
            while (keys.hasNext()) { String key = keys.next(); result.put(key, item.get(key)); }
        }
        return result;
    }
    public boolean isConnected() { Socket s = socket; return s != null && !s.isClosed() && token > 0; }
    /** Session-advertised media address; callers must validate against the connected host. */
    public String advertisedRtsp() { return advertisedRtsp; }
    public void close() {
        closeSession();
    }
    private long closeSession() {
        synchronized (lifecycleLock) {
            sessionGeneration++;
            Socket s = socket;
            socket = null;
            token = 0;
            advertisedRtsp = "";
            if (s != null) try { s.close(); } catch (IOException ignored) { }
            return sessionGeneration;
        }
    }
    public synchronized void disconnect() {
        try { if (isConnected()) call(258); } catch (Exception ignored) { } finally { close(); }
    }
    public static final class CameraRejectedException extends IOException {
        public final int code;
        CameraRejectedException(int code) { super("相机拒绝操作，错误码 " + code); this.code = code; }
    }
}
