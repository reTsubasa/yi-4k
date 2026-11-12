package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.net.Network;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.security.MessageDigest;
import java.util.function.BooleanSupplier;
import java.util.function.LongConsumer;

/** Pending MediaStore rows are published only after a complete transfer. */
public final class MediaExporter {
    private volatile HttpURLConnection active;
    public void cancel() { HttpURLConnection c = active; if (c != null) c.disconnect(); }
    public String export(ContentResolver resolver, Network network, String host, MediaEntry entry,
                         BooleanSupplier cancelled, LongConsumer progress) throws Exception {
        return export(resolver, network, host, 80, entry, cancelled, progress);
    }
    String export(ContentResolver resolver, Network network, String host, int port, MediaEntry entry,
                  BooleanSupplier cancelled, LongConsumer progress) throws Exception {
        MediaTransfer.checkCancelled(cancelled);
        Yi4kApplication.awaitOriginalExportRecovery(cancelled);
        boolean video = entry.name.toLowerCase(java.util.Locale.ROOT).endsWith(".mp4");
        HttpURLConnection connection = (HttpURLConnection) (network == null
                ? entry.uri(host, port).toURL().openConnection() : network.openConnection(entry.uri(host, port).toURL()));
        active = connection;
        Uri destination = null;
        boolean complete = false;
        try {
            connection.setInstanceFollowRedirects(false);
            connection.setConnectTimeout(8000); connection.setReadTimeout(15000);
            connection.setRequestProperty("Accept-Encoding", "identity");
            if (connection.getResponseCode() != 200) throw new java.io.IOException("下载失败 HTTP " + connection.getResponseCode());
            long length = connection.getContentLengthLong();
            if (entry.bytes >= 0 && length >= 0 && entry.bytes != length)
                throw new java.io.IOException("文件已变化，请刷新媒体列表");
            long expected = entry.bytes >= 0 ? entry.bytes : length;
            if (expected <= 0) throw new java.io.IOException("无法确认文件大小，请刷新媒体列表");
            MediaTransfer.checkCancelled(cancelled);
            ContentValues values = new ContentValues();
            values.put(MediaStore.MediaColumns.DISPLAY_NAME, entry.name);
            values.put(MediaStore.MediaColumns.MIME_TYPE, video ? "video/mp4" : "image/jpeg");
            values.put(MediaStore.MediaColumns.RELATIVE_PATH, (video ? Environment.DIRECTORY_MOVIES : Environment.DIRECTORY_PICTURES) + "/YI4K");
            values.put(MediaStore.MediaColumns.IS_PENDING, 1);
            destination = resolver.insert(video ? MediaStore.Video.Media.EXTERNAL_CONTENT_URI : MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
            if (destination == null) throw new java.io.IOException("无法创建导出文件");
            MessageDigest hash = MessageDigest.getInstance("SHA-256");
            long count = 0;
            try (InputStream input = connection.getInputStream(); OutputStream output = resolver.openOutputStream(destination)) {
                if (output == null) throw new java.io.IOException("无法写入相册");
                count = MediaTransfer.copy(input, output, expected, cancelled, progress, hash);
            }
            MediaTransfer.checkCancelled(cancelled);
            values.clear(); values.put(MediaStore.MediaColumns.IS_PENDING, 0);
            if (resolver.update(destination, values, null, null) != 1) throw new java.io.IOException("无法发布到相册");
            complete = true;
            StringBuilder digest = new StringBuilder();
            for (byte b : hash.digest()) digest.append(String.format(java.util.Locale.ROOT, "%02x", b & 255));
            return entry.name + " 已保存到相册（" + count + " 字节）\nSHA-256: " + digest;
        } finally {
            connection.disconnect(); active = null;
            if (!complete && destination != null) resolver.delete(destination, null, null);
        }
    }
}
