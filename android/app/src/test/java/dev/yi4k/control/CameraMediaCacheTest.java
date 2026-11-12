package dev.yi4k.control;

import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import static org.junit.Assert.*;

/** Original-byte HTTP checks using loopback only; no Android/device network. */
public class CameraMediaCacheTest {
    @Rule public TemporaryFolder temporary = new TemporaryFolder();

    @Test public void fetchesOriginalViaSuppliedRouteAndReportsCompleteProgress() throws Exception {
        byte[] original = new byte[131089];
        for (int i = 0; i < original.length; i++) original[i] = (byte) (i * 31);
        AtomicInteger routed = new AtomicInteger();
        AtomicReference<long[]> progress = new AtomicReference<>();
        File cache = temporary.newFolder();
        try (HttpFixture http = new HttpFixture("200 OK", "Content-Length: " + original.length + "\r\n", original)) {
            CameraMediaCache transfer = new CameraMediaCache(url -> {
                routed.incrementAndGet();
                assertEquals("/DCIM/100MEDIA/YI%20ONE.MP4", url.getPath());
                return (HttpURLConnection) url.openConnection();
            });
            File result = transfer.fetch(cache, "127.0.0.1", http.port(), entry("YI ONE.MP4", original.length),
                    (received, total) -> progress.set(new long[]{received, total}));
            assertEquals(1, routed.get());
            assertArrayEquals(original, Files.readAllBytes(result.toPath()));
            assertArrayEquals(new long[]{original.length, original.length}, progress.get());
            assertEquals(cache.getCanonicalFile(), result.getParentFile().getCanonicalFile());
            assertTrue(result.getName().endsWith(".mp4"));
            assertEquals(1, cache.list().length);
        }
    }

    @Test public void rejectsChangedLengthBeforeCreatingCacheFile() throws Exception {
        File cache = temporary.newFolder();
        try (HttpFixture http = new HttpFixture("200 OK", "Content-Length: 5\r\n", new byte[5])) {
            assertFailure(cache, http, entry("ONE.JPG", 4), "文件已变化");
        }
    }

    @Test public void truncatedAndOversizeBodiesNeverLeavePartialFile() throws Exception {
        File truncated = temporary.newFolder();
        try (HttpFixture http = new HttpFixture("200 OK", "", new byte[]{1, 2})) {
            assertFailure(truncated, http, entry("ONE.MP4", 5), "不完整");
        }
        File oversized = temporary.newFolder();
        try (HttpFixture http = new HttpFixture("200 OK", "", new byte[]{1, 2, 3, 4, 5, 6})) {
            assertFailure(oversized, http, entry("ONE.MP4", 5), "文件已变化");
        }
    }

    @Test public void refusesRedirectAndUnknownSizeWithoutPublishingAnything() throws Exception {
        File redirect = temporary.newFolder();
        try (HttpFixture http = new HttpFixture("302 Found", "Location: http://127.0.0.1:1/private\r\nContent-Length: 0\r\n", new byte[0])) {
            assertFailure(redirect, http, entry("ONE.MP4", 4), "HTTP 302");
        }
        File unknown = temporary.newFolder();
        try (HttpFixture http = new HttpFixture("200 OK", "", new byte[]{1})) {
            assertFailure(unknown, http, entry("ONE.JPG", -1), "无法确认原片大小");
        }
    }

    @Test public void cancellationCleansPartialAndCannotAccidentallyRestartSameTransfer() throws Exception {
        File cache = temporary.newFolder();
        byte[] bytes = new byte[150000]; Arrays.fill(bytes, (byte) 7);
        AtomicInteger routes = new AtomicInteger();
        try (HttpFixture http = new HttpFixture("200 OK", "Content-Length: " + bytes.length + "\r\n", bytes)) {
            CameraMediaCache transfer = new CameraMediaCache(url -> { routes.incrementAndGet(); return (HttpURLConnection) url.openConnection(); });
            try {
                transfer.fetch(cache, "127.0.0.1", http.port(), entry("ONE.MP4", bytes.length),
                        (received, total) -> { if (received > 0) transfer.cancel(); });
                fail("Cancellation must fail the transfer");
            } catch (IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
            assertEquals(0, cache.list().length);
            try {
                transfer.fetch(cache, "127.0.0.1", http.port(), entry("ONE.MP4", bytes.length), (a, b) -> {});
                fail("A cancelled transfer must stay cancelled");
            } catch (IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
            assertEquals(1, routes.get());
        }
    }

    @Test public void unsupportedFileAndInvalidPortNeverOpenNetwork() throws Exception {
        AtomicInteger routes = new AtomicInteger();
        CameraMediaCache transfer = new CameraMediaCache(url -> { routes.incrementAndGet(); throw new IOException("Unexpected connection"); });
        File cache = temporary.newFolder();
        try {
            transfer.fetch(cache, "127.0.0.1", 80, entry("UNKNOWN.BIN", 2), (a, b) -> {});
            fail("Unsupported media accepted");
        } catch (IOException expected) { assertTrue(expected.getMessage().contains("照片或视频")); }
        try {
            transfer.fetch(cache, "127.0.0.1", 0, entry("ONE.MP4", 2), (a, b) -> {});
            fail("Invalid port accepted");
        } catch (IOException expected) { assertTrue(expected.getMessage().contains("端口")); }
        assertEquals(0, routes.get());
    }

    private void assertFailure(File cache, HttpFixture http, MediaEntry entry, String message) throws Exception {
        CameraMediaCache transfer = new CameraMediaCache(url -> (HttpURLConnection) url.openConnection());
        try {
            transfer.fetch(cache, "127.0.0.1", http.port(), entry, (a, b) -> {});
            fail("Incomplete or unsafe file accepted");
        } catch (IOException expected) { assertTrue(expected.getMessage(), expected.getMessage().contains(message)); }
        assertEquals(0, cache.list().length);
    }
    private static MediaEntry entry(String name, long size) {
        return new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", name, size < 0 ? "unknown" : size + " bytes|2026-11-10");
    }
    private static final class HttpFixture implements AutoCloseable {
        private final ServerSocket server = new ServerSocket(0, 1, InetAddress.getByName("127.0.0.1"));
        private final ExecutorService worker = Executors.newSingleThreadExecutor();
        private final Future<?> response;
        HttpFixture(String status, String headers, byte[] body) throws IOException {
            response = worker.submit(() -> {
                try (Socket client = server.accept()) {
                    client.setSoTimeout(3000);
                    int matched = 0;
                    byte[] end = "\r\n\r\n".getBytes(StandardCharsets.US_ASCII);
                    while (matched < end.length) {
                        int next = client.getInputStream().read();
                        if (next < 0) return;
                        matched = next == end[matched] ? matched + 1 : 0;
                    }
                    client.getOutputStream().write(("HTTP/1.1 " + status + "\r\nConnection: close\r\n" + headers + "\r\n").getBytes(StandardCharsets.US_ASCII));
                    client.getOutputStream().write(body); client.getOutputStream().flush();
                } catch (IOException ignored) { /* A cancelled client may disconnect while we send. */ }
            });
        }
        int port() { return server.getLocalPort(); }
        @Override public void close() throws Exception {
            server.close(); response.get(3, TimeUnit.SECONDS); worker.shutdownNow();
        }
    }
}
