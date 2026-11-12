package dev.yi4k.control;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.util.function.BooleanSupplier;
import java.util.function.LongConsumer;

/** Bounded original-byte transfer, shared by device export and host verification. */
public final class MediaTransfer {
    private MediaTransfer() { }
    public static void checkCancelled(BooleanSupplier cancelled) throws IOException {
        if (cancelled.getAsBoolean() || Thread.currentThread().isInterrupted()) throw new IOException("导出已取消");
    }
    public static long copy(InputStream input, OutputStream output, long expected, BooleanSupplier cancelled,
                            LongConsumer progress, MessageDigest hash) throws IOException {
        if (expected <= 0) throw new IOException("无法确认文件大小，请刷新媒体列表");
        byte[] buffer = new byte[65536];
        long count = 0, lastUpdate = 0;
        for (;;) {
            checkCancelled(cancelled);
            int n = input.read(buffer);
            checkCancelled(cancelled);
            if (n < 0) break;
            if (n == 0) continue;
            if (n > expected - count) throw new IOException("文件已变化，未保存到相册");
            output.write(buffer, 0, n); hash.update(buffer, 0, n); count += n;
            long now = System.nanoTime();
            if (now - lastUpdate > 250_000_000L) { progress.accept(count); lastUpdate = now; }
        }
        if (count != expected) throw new IOException("下载不完整，未保存到相册");
        output.flush();
        checkCancelled(cancelled);
        progress.accept(count);
        return count;
    }
}
