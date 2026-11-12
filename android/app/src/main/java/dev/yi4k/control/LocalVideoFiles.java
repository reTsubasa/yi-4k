package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.util.function.BooleanSupplier;

/** Local-only import and pending-row publication for edited copies. */
final class LocalVideoFiles {
    static File importVideo(InputStream input, File directory, BooleanSupplier cancelled) throws Exception {
        if (input == null) throw new IOException("无法读取所选视频");
        File result = null;
        boolean complete = false;
        try (InputStream source = input) {
            check(cancelled);
            if (!directory.isDirectory() && !directory.mkdirs()) throw new IOException("无法创建剪辑缓存");
            long budget = directory.getUsableSpace() - 64L * 1024 * 1024;
            if (budget <= 0) throw new IOException("手机空间不足，请清理空间后重试");
            result = File.createTempFile("edit-source-", ".mp4", directory);
            long received = 0;
            try (OutputStream output = new FileOutputStream(result)) {
                byte[] buffer = new byte[65536];
                for (;;) {
                    check(cancelled);
                    int n = source.read(buffer);
                    if (n < 0) break;
                    if (n == 0) continue;
                    if (n > budget - received) throw new IOException("视频超过手机可用缓存空间");
                    output.write(buffer, 0, n); received += n;
                }
            }
            check(cancelled);
            if (received == 0) throw new IOException("所选视频为空");
            complete = true; return result;
        } finally { if (!complete && result != null) result.delete(); }
    }

    static Uri publish(ContentResolver resolver, File completedVideo, BooleanSupplier cancelled) throws Exception {
        Yi4kApplication.awaitEditedExportRecovery(cancelled);
        check(cancelled);
        long expected = completedVideo.length();
        if (expected <= 0) throw new IOException("剪辑结果为空，请重新导出");
        ContentValues values = new ContentValues();
        values.put(MediaStore.MediaColumns.DISPLAY_NAME, "YI4K_EDIT_" + System.currentTimeMillis() + ".mp4");
        values.put(MediaStore.MediaColumns.MIME_TYPE, "video/mp4");
        values.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_MOVIES + "/YI4K/Edited");
        values.put(MediaStore.MediaColumns.IS_PENDING, 1);
        Uri destination = resolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, values);
        if (destination == null) throw new IOException("无法创建剪辑导出文件");
        boolean complete = false;
        try {
            try (InputStream source = new FileInputStream(completedVideo);
                 OutputStream output = resolver.openOutputStream(destination)) {
                if (output == null) throw new IOException("无法写入手机相册");
                MediaTransfer.copy(source, output, expected, cancelled, bytes -> {}, MessageDigest.getInstance("SHA-256"));
            }
            check(cancelled);
            values.clear(); values.put(MediaStore.MediaColumns.IS_PENDING, 0);
            if (resolver.update(destination, values, null, null) != 1) throw new IOException("无法发布剪辑视频");
            complete = true; return destination;
        } finally { if (!complete) resolver.delete(destination, null, null); }
    }

    private static void check(BooleanSupplier cancelled) throws IOException {
        if (cancelled.getAsBoolean() || Thread.currentThread().isInterrupted()) throw new IOException("操作已取消");
    }
}
