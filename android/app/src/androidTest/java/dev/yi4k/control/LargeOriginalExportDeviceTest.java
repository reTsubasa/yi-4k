package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.os.StatFs;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.test.InstrumentationTestCase;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONObject;

/** Explicitly selected, local-only capacity test. Never targets a physical phone.
 * A real short MP4 followed by a valid extended-size free box exceeds 4 GiB;
 * the padding is NOT additional footage or a long camera recording.
 * The HTTP body and MediaStore file really contain every byte (no sparse output).
 */
public final class LargeOriginalExportDeviceTest extends InstrumentationTestCase {
    private static final long TOTAL = (1L << 32) + 1024 * 1024 + 123;
    private static final long CANCEL_AT = (1L << 31) + 256 * 1024;
    private Context context;
    private ContentResolver resolver;
    private byte[] prefix;

    @Override protected void setUp() throws Exception {
        super.setUp();
        assertEquals("Large fixture is restricted to the dedicated emulator", "ranchu", Build.HARDWARE);
        context = getInstrumentation().getTargetContext(); resolver = context.getContentResolver();
        Yi4kApplication.awaitOriginalExportRecovery(() -> false);
        assertTrue("Dedicated AVD needs >5 GiB free before this explicit test",
                new StatFs(context.getExternalFilesDir(null).getAbsolutePath()).getAvailableBytes() > TOTAL + 1024L * 1024 * 1024);
        try (InputStream input = getInstrumentation().getContext().getAssets().open("editor-av-fixture.mp4");
                ByteArrayOutputStream bytes = new ByteArrayOutputStream()) {
            byte[] block = new byte[65536]; int n;
            while ((n = input.read(block)) != -1) bytes.write(block, 0, n);
            prefix = bytes.toByteArray();
        }
        assertTrue(prefix.length > 0 && prefix.length < 1024 * 1024);
    }

    public void testExportAboveFourGiBPublishesExactDecodableBytes() throws Exception {
        runTransfer(false);
    }

    public void testCancellationAboveTwoGiBDeletesUnpublishedBytes() throws Exception {
        runTransfer(true);
    }

    private void runTransfer(boolean cancel) throws Exception {
        String name = "large-original-" + (cancel ? "cancel-" : "complete-") + System.nanoTime() + ".mp4";
        JSONObject evidence = new JSONObject().put("scope", "local generated HTTP fixture; no camera or physical phone")
                .put("fixture", "short real MP4 plus extended-size free box padding; not >4GiB encoded footage")
                .put("declared_bytes", TOTAL).put("source_mp4_bytes", prefix.length)
                .put("cancel", cancel).put("cancel_threshold", CANCEL_AT)
                .put("max_heap_bytes", Runtime.getRuntime().maxMemory()).put("complete", false);
        Set<Long> before = ownedRows();
        AtomicLong progress = new AtomicLong(), pendingObserved = new AtomicLong(-1);
        String[] response = new String[1];
        long started = SystemClock.elapsedRealtime();
        Uri saved = null;
        try (FixtureServer http = new FixtureServer(prefix)) {
            try {
                response[0] = new MediaExporter().export(resolver, null, "127.0.0.1", http.port(),
                        new MediaEntry(MediaEntry.DCIM_ROOT, name, TOTAL + " bytes|generated capacity fixture"),
                        () -> cancel && progress.get() >= CANCEL_AT, bytes -> {
                            long previous = progress.getAndSet(bytes);
                            if (bytes < previous) throw new AssertionError("Progress wrapped at an integer boundary");
                            if (pendingObserved.get() < 0) {
                                Uri row = find(name);
                                if (row == null || pending(row) != 1) throw new AssertionError("Actual writing row must be pending");
                                pendingObserved.set(bytes);
                            }
                            if (bytes >= TOTAL || (cancel && bytes >= CANCEL_AT)) {
                                Bundle update = new Bundle(); update.putString("large_export_bytes", Long.toString(bytes));
                                getInstrumentation().sendStatus(0, update);
                            }
                        });
                assertFalse("Cancellation must throw after real bytes cross 2 GiB", cancel);
            } catch (IOException error) {
                if (!cancel || !error.getMessage().contains("取消")) throw error;
                evidence.put("cancel_error", error.getMessage());
            }
            evidence.put("progress_bytes", progress.get()).put("pending_observed_at_bytes", pendingObserved.get());
            assertTrue("Observed an actual pending row while writing", pendingObserved.get() > 0);
            if (cancel) {
                assertTrue(progress.get() >= CANCEL_AT && progress.get() < TOTAL);
                assertNull("Cancelled original must not be published or left pending", find(name));
                assertEquals("Only the cancelled row may change", before, ownedRows());
                evidence.put("pending_deleted", true).put("other_owned_rows_preserved", true);
            } else {
                assertEquals(TOTAL, progress.get());
                assertTrue("HTTP producer must finish", http.finished.await(30, TimeUnit.SECONDS));
                if (http.failure.get() != null) throw new AssertionError("HTTP producer failed", http.failure.get());
                assertEquals(TOTAL, http.sent.get());
                saved = find(name); assertNotNull(saved);
                assertEquals(0, pending(saved));
                long fdBytes;
                try (ParcelFileDescriptor fd = resolver.openFileDescriptor(saved, "r")) {
                    assertNotNull(fd); fdBytes = fd.getStatSize();
                }
                assertEquals(TOTAL, fdBytes);
                MessageDigest digest = MessageDigest.getInstance("SHA-256"); long count = 0;
                try (InputStream input = resolver.openInputStream(saved)) {
                    assertNotNull(input); byte[] block = new byte[256 * 1024]; int n;
                    while ((n = input.read(block)) != -1) { digest.update(block, 0, n); count += n; }
                }
                String readbackHash = hex(digest.digest());
                assertEquals(TOTAL, count);
                assertEquals(http.sha256.get(), readbackHash);
                assertTrue("Product exporter must report the real long byte count", response[0].contains(Long.toString(TOTAL)));
                assertTrue("Product exporter and independent HTTP/readback hashes must agree", response[0].contains(readbackHash));
                try (MediaMetadataRetriever decoder = new MediaMetadataRetriever()) {
                    decoder.setDataSource(context, saved);
                    assertEquals("yes", decoder.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO));
                    Bitmap frame = decoder.getFrameAtTime(0);
                    assertNotNull("Published >4GiB content URI must decode a real frame", frame);
                    evidence.put("decoded_frame_width", frame.getWidth()).put("decoded_frame_height", frame.getHeight());
                    frame.recycle();
                    evidence.put("duration_ms", decoder.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
                }
                evidence.put("http_bytes", http.sent.get()).put("stat_bytes", fdBytes).put("readback_bytes", count)
                        .put("http_sha256", http.sha256.get()).put("readback_sha256", readbackHash)
                        .put("exporter_result", response[0]).put("published", true);
            }
            evidence.put("complete", true);
        } finally {
            // Find by unique fixture name even if an assertion failed before saved was assigned.
            if (saved == null) saved = find(name);
            if (saved != null) resolver.delete(saved, null, null);
            evidence.put("elapsed_ms", SystemClock.elapsedRealtime() - started)
                    .put("fixture_row_removed", find(name) == null)
                    .put("owned_rows_restored", before.equals(ownedRows()));
            File dir = new File(context.getExternalFilesDir(null), "acceptance-screens/large-original-export");
            if (!dir.isDirectory() && !dir.mkdirs()) throw new IOException("Evidence directory unavailable");
            try (FileOutputStream output = new FileOutputStream(new File(dir, cancel ? "cancel.json" : "complete.json"))) {
                output.write(evidence.toString(2).getBytes(StandardCharsets.UTF_8));
            }
        }
        assertTrue("Fixture cleanup must restore exact row set", before.equals(ownedRows()));
    }

    private Bundle query(String name) {
        Bundle args = new Bundle(); args.putInt(MediaStore.QUERY_ARG_MATCH_PENDING, MediaStore.MATCH_INCLUDE);
        args.putString(ContentResolver.QUERY_ARG_SQL_SELECTION, MediaStore.MediaColumns.OWNER_PACKAGE_NAME
                + "=? AND " + MediaStore.MediaColumns.RELATIVE_PATH + "=?"
                + (name == null ? "" : " AND " + MediaStore.MediaColumns.DISPLAY_NAME + "=?"));
        args.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS, name == null
                ? new String[]{context.getPackageName(), "Movies/YI4K/"}
                : new String[]{context.getPackageName(), "Movies/YI4K/", name});
        return args;
    }

    private Set<Long> ownedRows() {
        Set<Long> ids = new HashSet<>();
        try (Cursor rows = resolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                new String[]{MediaStore.MediaColumns._ID}, query(null), null)) {
            assertNotNull(rows); while (rows.moveToNext()) ids.add(rows.getLong(0));
        }
        return ids;
    }

    private Uri find(String name) {
        try (Cursor rows = resolver.query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                new String[]{MediaStore.MediaColumns._ID}, query(name), null)) {
            assertNotNull(rows); if (!rows.moveToFirst()) return null;
            Uri result = android.content.ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, rows.getLong(0));
            assertFalse("Unique fixture name returned multiple rows", rows.moveToNext()); return result;
        }
    }

    private int pending(Uri uri) {
        try (Cursor row = resolver.query(uri, new String[]{MediaStore.MediaColumns.IS_PENDING}, null, null, null)) {
            assertNotNull(row); assertTrue(row.moveToFirst()); return row.getInt(0);
        }
    }

    private static String hex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte value : bytes) result.append(String.format(java.util.Locale.ROOT, "%02x", value & 255));
        return result.toString();
    }

    private static final class FixtureServer implements AutoCloseable {
        final ServerSocket server;
        final AtomicReference<Throwable> failure = new AtomicReference<>();
        final AtomicReference<String> sha256 = new AtomicReference<>();
        final AtomicLong sent = new AtomicLong();
        final CountDownLatch finished = new CountDownLatch(1);
        volatile Socket active;
        final Thread thread;
        FixtureServer(byte[] source) throws IOException {
            server = new ServerSocket(0, 1, InetAddress.getByName("127.0.0.1"));
            thread = new Thread(() -> {
                try (Socket socket = server.accept()) {
                    active = socket; socket.setSoTimeout(30000);
                    InputStream request = socket.getInputStream(); int matched = 0;
                    byte[] end = "\r\n\r\n".getBytes(StandardCharsets.US_ASCII);
                    while (matched < end.length) {
                        int b = request.read(); if (b < 0) throw new IOException("Incomplete HTTP request");
                        matched = b == end[matched] ? matched + 1 : 0;
                    }
                    OutputStream output = socket.getOutputStream();
                    output.write(("HTTP/1.1 200 OK\r\nContent-Type: video/mp4\r\nContent-Length: " + TOTAL
                            + "\r\nConnection: close\r\n\r\n").getBytes(StandardCharsets.US_ASCII));
                    MessageDigest hash = MessageDigest.getInstance("SHA-256");
                    write(output, hash, source, source.length);
                    byte[] header = ByteBuffer.allocate(16).putInt(1).put(new byte[]{'f','r','e','e'})
                            .putLong(TOTAL - source.length).array();
                    write(output, hash, header, header.length);
                    byte[] zeros = new byte[256 * 1024];
                    while (sent.get() < TOTAL) write(output, hash, zeros, (int) Math.min(zeros.length, TOTAL - sent.get()));
                    output.flush(); sha256.set(hex(hash.digest()));
                } catch (Throwable error) { failure.set(error); }
                finally { active = null; finished.countDown(); }
            }, "large-original-local-http");
            thread.setDaemon(true); thread.start();
        }
        int port() { return server.getLocalPort(); }
        void write(OutputStream output, MessageDigest hash, byte[] bytes, int count) throws IOException {
            output.write(bytes, 0, count); hash.update(bytes, 0, count); sent.addAndGet(count);
        }
        @Override public void close() throws Exception {
            server.close(); Socket socket = active; if (socket != null) socket.close();
            thread.join(5000);
            if (thread.isAlive()) throw new IOException("Local HTTP fixture thread did not stop");
        }
    }
}
