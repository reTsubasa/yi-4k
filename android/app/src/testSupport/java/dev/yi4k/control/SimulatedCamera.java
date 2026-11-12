package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONObject;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

/** Loopback-only test fixture. Never probes or contacts a real camera. */
public final class SimulatedCamera implements AutoCloseable {
    public final ServerSocket api = new ServerSocket(0, 8, InetAddress.getByName("127.0.0.1"));
    public final ServerSocket http = new ServerSocket(0, 8, InetAddress.getByName("127.0.0.1"));
    public final List<Integer> requests = new CopyOnWriteArrayList<>();
    public final List<String> failures = new CopyOnWriteArrayList<>();
    public volatile String rtspAddress = "";
    public final byte[] image = java.util.Base64.getDecoder().decode("/9j/4AAQSkZJRgABAQAASABIAAD/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAQKADAAQAAAABAAAAQAAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgAQABAAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAAgICAgICAwICAwUDAwMFBgUFBQUGCAYGBgYGCAoICAgICAgKCgoKCgoKCgwMDAwMDA4ODg4ODw8PDw8PDw8PD//bAEMBAgICBAQEBwQEBxALCQsQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEP/dAAQABP/aAAwDAQACEQMRAD8A/Gu00rpxXTWmldPlrpbTSunFdNaaT0+Wv7Exmc+Z4HDef7anN2mldPlrprTSuny10tppXT5a6a00np8tfKYzOPM/oDhvP9tTmrTSuny101ppXT5a6W00rpxXT2mldPlr5PGZx5n9AcN5/tqc1aaV0+WumtNK6cV0tppXTiumtNK6fLXyuMznzP6A4bz/AG1P/9D4BtNK6fLXT2mldPlrpLTSeny109ppXT5a/b8ZnHmfzrw3n22pzVppXT5a6a00rp8tdLaaT0+WumtNK6cV8pjM58z+gOG8+21OatNK6fLXT2mldPlrpbTSuny101ppXTivlMZnHmf0Bw3n22pzVppXTiumtNJ6fLXS2mldPlrprTSuny18njM48z+gOG8+21P/0fGLTSuny101ppXT5a6W00rp8tdNaaT0+WvbxmceZ/BXDefbanNWmldPlrprTSuny10tppXTiuntNK6fLXyeMzjzP6A4bz7bU5q00rp8tdNaaV04rpbTSunFdNaaV0+WvlMZnPmf0Bw3n22pzVppPT5a6a00rp8tdLaaV0+WuntNK6fLXymMzjzP6A4bz7bU/9Lr7TSuny101ppXT5a6W00rp8tdNaaV04r4TGZz5n+T3Def7anNWmldPlrp7TSuny10tppXT5a6a00rpxXyuMzjzP6A4bz/AG1OatNK6cV01ppPT5a6W00rp8tdNaaV0+Wvk8ZnHmf0Bw3n+2pzVppXT5a6e00rp8tdLaaV0+WumtNJ6fLXymMznzP6A4bz/bU//9k=");
    public final String imageName = "SIMULATED_YI4K.JPG";
    public final String slowName = "SIMULATED_CANCEL.JPG";
    private final ExecutorService workers = Executors.newCachedThreadPool();
    private final Set<Socket> connections = ConcurrentHashMap.newKeySet();
    private final AtomicBoolean closed = new AtomicBoolean();
    private final AtomicInteger dropAfterRequest = new AtomicInteger(-1);
    private final Map<String, Long> extraMedia = new ConcurrentHashMap<>();
    private volatile String mode = "record", status = "idle", quality = "Fine";
    private volatile int delayedRequest = -1;
    private volatile long responseDelayMs;
    public SimulatedCamera() throws Exception {
        accept(api, this::control); accept(http, this::download);
    }
    private interface Handler { void run(Socket socket) throws Exception; }
    private void accept(ServerSocket server, Handler handler) {
        workers.submit(() -> {
            while (!closed.get()) try {
                Socket socket = server.accept(); connections.add(socket);
                workers.submit(() -> {
                    try (Socket client = socket) { handler.run(client); }
                    catch (Exception e) { if (!closed.get() && server == api) failures.add(e.toString()); }
                    finally { connections.remove(socket); }
                });
            } catch (IOException e) { if (!closed.get()) failures.add(e.toString()); }
        });
    }
    private void control(Socket socket) throws Exception {
        JsonObjectStream stream = new JsonObjectStream(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8), 65536);
        for (;;) {
            JSONObject request;
            try { request = new JSONObject(stream.next()); } catch (EOFException done) { return; }
            int id = request.getInt("msg_id"); requests.add(id);
            if (delayedRequest == id) {
                long delay = responseDelayMs;
                delayedRequest = -1;
                if (delay > 0) Thread.sleep(delay);
            }
            JSONObject reply = new JSONObject().put("msg_id", id).put("rval", 0);
            if (id != 257 && request.optInt("token") != 42) reply.put("rval", -7);
            else switch (id) {
                case 257: reply.put("param", 42); if (!rtspAddress.isEmpty()) reply.put("rtsp", rtspAddress); break;
                case 258: break;
                case 1:
                    reply.put("param", "system_mode".equals(request.optString("type")) ? mode : "video_quality".equals(request.optString("type")) ? quality : status); break;
                case 3:
                    reply.put("param", new JSONArray().put(new JSONObject().put("product_name", "SIMULATED CAMERA"))
                            .put(new JSONObject().put("sw_version", "Z16V13L_1.10.7_SIMULATED"))
                            .put(new JSONObject().put("hw_version", "SIMULATED"))
                            .put(new JSONObject().put("sd_card_status", "insert"))
                            .put(new JSONObject().put("system_mode", mode)).put(new JSONObject().put("video_quality", quality))
                            .put(new JSONObject().put("video_resolution", "1920x1080 30P 16:9"))); break;
                case 9:
                    String key = request.optString("param");
                    reply.put("permission", "settable");
                    if ("system_mode".equals(key)) reply.put("options", new JSONArray().put("record").put("capture"));
                    else if ("video_quality".equals(key)) reply.put("options", new JSONArray().put("Fine").put("Normal"));
                    else reply.put("permission", "readonly");
                    break;
                case 2:
                    if (!CameraState.isReady(status)) reply.put("rval", -7);
                    else if ("system_mode".equals(request.optString("type"))) mode = request.getString("param");
                    else if ("video_quality".equals(request.optString("type"))) quality = request.getString("param");
                    else reply.put("rval", -7);
                    break;
                case 13: reply.put("type", "battery").put("param", 80); break;
                case 5: reply.put("param", "total".equals(request.optString("type")) ? 100000 : 72000); break;
                case 513: status = "record"; break;
                case 514: status = "vf"; extraMedia.put("SIMULATED_NEW_VIDEO.MP4", (long) image.length); break;
                case 16777220: extraMedia.put("SIMULATED_NEW_PHOTO.JPG", (long) image.length); break;
                case 1282:
                    JSONArray listing = new JSONArray();
                    if (request.optString("param").endsWith("EMPTY/")) {
                        // Explicit empty directory used by the UI regression
                        // to prove automatic media loading does not loop.
                    } else if (request.optString("param").equals(MediaEntry.DCIM_ROOT)) listing.put(new JSONObject().put("100MEDIA/", "2|date"));
                    else listing.put(new JSONObject().put(imageName, image.length + " bytes|date"))
                            .put(new JSONObject().put(slowName, (image.length * 64L) + " bytes|date"));
                    if (!request.optString("param").equals(MediaEntry.DCIM_ROOT)) for (Map.Entry<String, Long> entry : extraMedia.entrySet())
                        listing.put(new JSONObject().put(entry.getKey(), entry.getValue() + " bytes|date"));
                    reply.put("listing", listing).put("total", listing.length()); break;
                default: reply.put("rval", -7);
            }
            if (dropAfterRequest.compareAndSet(id, -1)) return;
            byte[] bytes = reply.toString().getBytes(StandardCharsets.UTF_8);
            // Deliberately fragment responses: the app must parse a stream.
            int split = Math.min(5, bytes.length);
            socket.getOutputStream().write(bytes, 0, split); socket.getOutputStream().flush();
            socket.getOutputStream().write(bytes, split, bytes.length - split); socket.getOutputStream().flush();
            if (id == 258) return;
        }
    }
    private void download(Socket socket) throws Exception {
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.US_ASCII));
        String first = reader.readLine(), line;
        do { line = reader.readLine(); } while (line != null && !line.isEmpty());
        boolean slow = first != null && first.contains(slowName);
        long length = slow ? image.length * 64L : image.length;
        OutputStream output = socket.getOutputStream();
        output.write(("HTTP/1.1 200 OK\r\nContent-Type: image/jpeg\r\nContent-Length: " + length + "\r\nConnection: close\r\n\r\n").getBytes(StandardCharsets.US_ASCII));
        for (long count = 0; count < length && !closed.get(); count += image.length) {
            output.write(image); output.flush();
            if (slow) Thread.sleep(5);
        }
    }
    public int apiPort() { return api.getLocalPort(); }
    public int httpPort() { return http.getLocalPort(); }
    /** Drop one API socket after applying the request, before its response is sent. */
    public void dropNextResponseFor(int msgId) { dropAfterRequest.set(msgId); }
    public void delayNextResponseFor(int msgId, long delayMs) {
        delayedRequest = msgId; responseDelayMs = Math.max(0, delayMs);
    }
    @Override public void close() throws Exception {
        closed.set(true); api.close(); http.close();
        for (Socket socket : connections) socket.close();
        workers.shutdownNow(); workers.awaitTermination(3, TimeUnit.SECONDS);
    }
}
