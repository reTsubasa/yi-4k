package dev.yi4k.control;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.atomic.AtomicBoolean;

/** One original-media transfer into an app-private directory. Never publishes a file. */
final class CameraMediaCache {
    interface ConnectionFactory { HttpURLConnection open(URL url) throws IOException; }
    interface Progress { void update(long received, long total); }

    private final ConnectionFactory connections;
    private final AtomicBoolean cancelled = new AtomicBoolean();
    private volatile HttpURLConnection active;

    CameraMediaCache(ConnectionFactory connections) { this.connections = connections; }

    void cancel() {
        cancelled.set(true);
        HttpURLConnection connection = active;
        if (connection != null) connection.disconnect();
    }

    File fetch(File directory, String host, int port, MediaEntry entry, Progress progress) throws Exception {
        checkCancelled();
        if (!entry.isMedia()) throw new IOException("请选择照片或视频");
        if (port < 1 || port > 65535) throw new IOException("相机媒体端口无效");
        if (!directory.isDirectory() && !directory.mkdirs()) throw new IOException("无法创建预览缓存");
        HttpURLConnection connection = connections.open(entry.uri(host, port).toURL());
        active = connection;
        File temporary = null;
        boolean complete = false;
        try {
            checkCancelled();
            connection.setInstanceFollowRedirects(false);
            connection.setConnectTimeout(8000);
            connection.setReadTimeout(15000);
            connection.setRequestProperty("Accept-Encoding", "identity");
            int response = connection.getResponseCode();
            if (response != 200) throw new IOException("读取原片失败（HTTP " + response + "）");
            long length = connection.getContentLengthLong();
            if (entry.bytes >= 0 && length >= 0 && entry.bytes != length)
                throw new IOException("相机文件已变化，请返回相册刷新");
            long expected = entry.bytes >= 0 ? entry.bytes : length;
            if (expected <= 0) throw new IOException("无法确认原片大小，请返回相册刷新");
            // Reserve some room for decoding/player metadata and other app operations.
            if (expected > Math.max(0, directory.getUsableSpace() - 16L * 1024 * 1024))
                throw new IOException("手机缓存空间不足，请清理空间后重试");
            checkCancelled();
            String suffix = entry.name.toLowerCase(java.util.Locale.ROOT).endsWith(".mp4") ? ".mp4" : ".jpg";
            temporary = File.createTempFile("original-", suffix, directory);
            progress.update(0, expected);
            try (InputStream input = connection.getInputStream(); FileOutputStream output = new FileOutputStream(temporary)) {
                byte[] buffer = new byte[65536];
                long received = 0, lastUpdate = 0;
                for (;;) {
                    checkCancelled();
                    int count = input.read(buffer);
                    checkCancelled();
                    if (count < 0) break;
                    if (count == 0) continue;
                    if (count > expected - received) throw new IOException("相机文件已变化，请返回相册刷新");
                    output.write(buffer, 0, count);
                    received += count;
                    long now = System.nanoTime();
                    if (now - lastUpdate > 250_000_000L) { progress.update(received, expected); lastUpdate = now; }
                }
                if (received != expected) throw new IOException("原片下载不完整，请重试");
                output.flush();
                checkCancelled();
                progress.update(received, expected);
            }
            checkCancelled();
            complete = true;
            return temporary;
        } finally {
            connection.disconnect();
            active = null;
            if (!complete && temporary != null) temporary.delete();
        }
    }

    private void checkCancelled() throws IOException {
        if (cancelled.get() || Thread.currentThread().isInterrupted()) throw new IOException("预览已取消");
    }
}
