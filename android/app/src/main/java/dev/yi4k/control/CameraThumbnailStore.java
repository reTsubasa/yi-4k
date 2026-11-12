package dev.yi4k.control;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Network;
import android.os.Handler;
import android.os.Looper;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Locale;
import java.util.UUID;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * A single camera-session's real thumbnails, never a guessed camera endpoint.
 * Recreate this store on every camera connection to avoid mixing two cameras that
 * share the usual 192.168.42.1 address. This cache is not an original-media archive.
 */
public final class CameraThumbnailStore implements AutoCloseable {
    static final int LONG_EDGE = 384;
    static final long MAX_PHOTO_BYTES = 12L * 1024 * 1024;
    static final long MAX_CACHE_BYTES = 16L * 1024 * 1024;
    static final int MAX_ITEMS = 128;
    public interface Callback {
        /** Called on the main thread. The receiver owns and eventually recycles this bitmap. */
        void loaded(Bitmap thumbnail);
        /** Empty cache or a real decode/transfer failure. Keep an honest placeholder. */
        void unavailable(String explanation);
    }
    private final File directory;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final ThreadPoolExecutor worker = new ThreadPoolExecutor(1, 1, 0, TimeUnit.MILLISECONDS,
            new ArrayBlockingQueue<>(64));
    private final AtomicInteger generation = new AtomicInteger();
    private volatile CameraMediaCache active;
    private volatile boolean closed;

    public CameraThumbnailStore(Context context) throws IOException {
        directory = new File(new File(context.getCacheDir(), "camera-thumbnails"), UUID.randomUUID().toString());
        if (!directory.mkdirs()) throw new IOException("无法创建缩略图缓存");
    }

    /** No network traffic. A video becomes available after its original has been viewed. */
    public void load(MediaEntry entry, Callback callback) {
        int current = generation.get();
        submit(current, callback, () -> deliver(current, callback, read(entry), "打开原片后会保留真实封面"));
    }

    /**
     * Explicit, bounded photo-only request. The caller first checks that the camera
     * is idle and no export is running. Large/unknown-size photos and all videos
     * remain placeholders until an original is viewed. No TCP API calls are made.
     */
    public void requestPhoto(Network network, String host, int port, MediaEntry entry, Callback callback) {
        if (network == null && !"127.0.0.1".equals(host) && !"::1".equals(host)) {
            unavailable(generation.get(), callback, "相机 Wi-Fi 已断开"); return;
        }
        requestPhotoThrough(url -> (HttpURLConnection) (network == null ? url.openConnection() : network.openConnection(url)),
                host, port, entry, callback);
    }

    void requestPhotoThrough(CameraMediaCache.ConnectionFactory route, String host, int port, MediaEntry entry, Callback callback) {
        int current = generation.get();
        submit(current, callback, () -> {
            Bitmap cached = read(entry);
            if (cached != null) { deliver(current, callback, cached, ""); return; }
            if (!isBoundedPhoto(entry)) { unavailable(current, callback, "请打开原片生成此素材的真实封面"); return; }
            CameraMediaCache transfer = new CameraMediaCache(route); active = transfer;
            if (!valid(current)) { transfer.cancel(); active = null; return; }
            File original = null;
            Bitmap decoded = null;
            try {
                original = transfer.fetch(new File(directory, "source"), host, port, entry, (received, total) -> {});
                if (!valid(current)) return;
                decoded = decodePhoto(original);
                remember(entry, decoded);
                Bitmap result = decoded; decoded = null;
                deliver(current, callback, result, "无法解码照片缩略图");
            } finally {
                active = null;
                if (decoded != null) decoded.recycle();
                if (original != null) original.delete();
            }
        });
    }

    /**
     * Save a scaled copy of a real decoded photo/cover on the viewer's worker.
     * Does not take ownership of, mutate, or recycle the supplied original bitmap.
     * A cache failure must not fail playback; callers may ignore IOException.
     */
    public void remember(MediaEntry entry, Bitmap original) throws IOException {
        if (closed || original == null || original.isRecycled() || !entry.isMedia()) return;
        int width = original.getWidth(), height = original.getHeight();
        float factor = Math.min(1f, LONG_EDGE / (float) Math.max(width, height));
        Bitmap scaled = Bitmap.createScaledBitmap(original, Math.max(1, Math.round(width * factor)),
                Math.max(1, Math.round(height * factor)), true);
        try {
            synchronized (this) {
                if (closed) return;
                File temporary = File.createTempFile("thumb-", ".tmp", directory);
                try {
                    try (FileOutputStream output = new FileOutputStream(temporary)) {
                        if (!scaled.compress(Bitmap.CompressFormat.JPEG, 82, output)) throw new IOException("无法保存缩略图");
                    }
                    Files.move(temporary.toPath(), file(entry).toPath(), StandardCopyOption.REPLACE_EXISTING);
                    prune();
                } finally { temporary.delete(); }
            }
        } finally { if (scaled != original) scaled.recycle(); }
    }

    /** Call on navigation/background/export start to stop pending thumbnail work. */
    public void cancelRequests() {
        generation.incrementAndGet();
        CameraMediaCache transfer = active; if (transfer != null) transfer.cancel();
        worker.getQueue().clear();
    }

    @Override public void close() {
        closed = true; cancelRequests(); worker.shutdownNow();
        synchronized (this) { deleteOwnedDirectory(directory); }
    }

    static boolean isBoundedPhoto(MediaEntry entry) {
        return entry != null && entry.isMedia() && !entry.name.toLowerCase(Locale.ROOT).endsWith(".mp4")
                && entry.bytes > 0 && entry.bytes <= MAX_PHOTO_BYTES;
    }
    private synchronized Bitmap read(MediaEntry entry) throws IOException {
        if (closed || entry == null || !entry.isMedia()) return null;
        File cached = file(entry); if (!cached.isFile()) return null;
        BitmapFactory.Options options = new BitmapFactory.Options(); options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(cached.getAbsolutePath(), options);
        if (options.outWidth <= 0 || options.outHeight <= 0 || Math.max(options.outWidth, options.outHeight) > LONG_EDGE) {
            cached.delete(); return null;
        }
        options.inJustDecodeBounds = false; options.inPreferredConfig = Bitmap.Config.RGB_565;
        Bitmap bitmap = BitmapFactory.decodeFile(cached.getAbsolutePath(), options);
        if (bitmap == null) cached.delete(); else cached.setLastModified(System.currentTimeMillis());
        return bitmap;
    }
    private static Bitmap decodePhoto(File file) throws IOException {
        BitmapFactory.Options options = new BitmapFactory.Options(); options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(file.getAbsolutePath(), options);
        if (options.outWidth <= 0 || options.outHeight <= 0) throw new IOException("照片格式无法识别");
        int sample = 1;
        while (Math.max(options.outWidth, options.outHeight) / sample > LONG_EDGE * 2) sample *= 2;
        options.inJustDecodeBounds = false; options.inSampleSize = sample; options.inPreferredConfig = Bitmap.Config.RGB_565;
        Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath(), options);
        if (bitmap == null) throw new IOException("此手机无法解码照片");
        if (Math.max(bitmap.getWidth(), bitmap.getHeight()) > LONG_EDGE) {
            float factor = LONG_EDGE / (float) Math.max(bitmap.getWidth(), bitmap.getHeight());
            Bitmap scaled = Bitmap.createScaledBitmap(bitmap, Math.max(1, Math.round(bitmap.getWidth() * factor)),
                    Math.max(1, Math.round(bitmap.getHeight() * factor)), true);
            if (scaled != bitmap) bitmap.recycle();
            bitmap = scaled;
        }
        return bitmap;
    }
    private File file(MediaEntry entry) throws IOException {
        try {
            byte[] hash = MessageDigest.getInstance("SHA-256").digest((entry.path + "\n" + entry.info).getBytes(StandardCharsets.UTF_8));
            StringBuilder key = new StringBuilder(); for (byte b : hash) key.append(String.format(Locale.ROOT, "%02x", b & 255));
            return new File(directory, key + ".jpg");
        } catch (java.security.NoSuchAlgorithmException error) { throw new IOException(error); }
    }
    private void prune() {
        File[] files = directory.listFiles((dir, name) -> name.endsWith(".jpg")); if (files == null) return;
        Arrays.sort(files, Comparator.comparingLong(File::lastModified).reversed());
        long bytes = 0;
        for (int i=0; i<files.length; i++) {
            bytes += files[i].length(); if (i >= MAX_ITEMS || bytes > MAX_CACHE_BYTES) files[i].delete();
        }
    }
    private boolean valid(int current) { return !closed && current == generation.get(); }
    private interface Work { void run() throws Exception; }
    private void submit(int current, Callback callback, Work work) {
        if (!valid(current)) return;
        try { worker.execute(() -> {
            if (!valid(current)) return;
            try { work.run(); }
            catch (Exception error) { unavailable(current, callback, error.getMessage() == null ? "缩略图读取失败" : error.getMessage()); }
        }); } catch (RejectedExecutionException ignored) { unavailable(current, callback, "稍后再读取缩略图"); }
    }
    private void unavailable(int current, Callback callback, String reason) { deliver(current, callback, null, reason); }
    private void deliver(int current, Callback callback, Bitmap bitmap, String reason) {
        handler.post(() -> {
            if (!valid(current)) { if (bitmap != null) bitmap.recycle(); return; }
            if (bitmap == null) callback.unavailable(reason); else callback.loaded(bitmap);
        });
    }
    private static void deleteOwnedDirectory(File directory) {
        File[] children = directory.listFiles();
        if (children != null) for (File child : children) {
            if (child.isDirectory()) deleteOwnedDirectory(child); else child.delete();
        }
        directory.delete();
    }
}
