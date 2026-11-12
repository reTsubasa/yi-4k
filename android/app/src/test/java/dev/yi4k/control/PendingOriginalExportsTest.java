package dev.yi4k.control;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.provider.MediaStore;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.RuntimeEnvironment;
import org.robolectric.annotation.Config;
import org.robolectric.shadows.ShadowContentResolver;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {29, 34}, application = android.app.Application.class)
public class PendingOriginalExportsTest {
    private static final String OWNER = "dev.yi4k.control";

    @Test public void cleanupPreservesPublishedForeignAndNestedRowsEvenIfProviderIgnoresQueryFilter() throws Exception {
        Rows provider = new Rows();
        provider.rows.add(new Row(1, OWNER, "Movies/YI4K/", 1));
        provider.rows.add(new Row(2, OWNER, "Pictures/YI4K/", 1));
        provider.rows.add(new Row(3, OWNER, "Movies/YI4K/", 0));
        provider.rows.add(new Row(4, "other.camera", "Movies/YI4K/", 1));
        provider.rows.add(new Row(5, OWNER, "Movies/YI4K/Edited/", 1));
        provider.rows.add(new Row(6, OWNER, "Movies/YI4K-Other/", 1));
        provider.rows.add(new Row(7, OWNER, "Pictures/YI4K/", 0));
        ShadowContentResolver.registerProviderInternal("media", provider);
        assertEquals(2, PendingOriginalExports.cleanup(RuntimeEnvironment.getApplication().getContentResolver(), OWNER));
        assertEquals(Arrays.asList(3L, 4L, 5L, 6L, 7L), provider.ids());
    }

    @Test public void editedCleanupIsSeparateAndPreservesOriginalPublishedForeignAndOtherNestedRows() throws Exception {
        Rows provider = new Rows();
        provider.rows.add(new Row(1,OWNER,"Movies/YI4K/Edited/",1));
        provider.rows.add(new Row(2,OWNER,"Movies/YI4K/",1));
        provider.rows.add(new Row(3,OWNER,"Movies/YI4K/Edited/",0));
        provider.rows.add(new Row(4,"other.editor","Movies/YI4K/Edited/",1));
        provider.rows.add(new Row(5,OWNER,"Movies/YI4K/Edited/Other/",1));
        provider.rows.add(new Row(6,OWNER,"Pictures/YI4K/",1));
        ShadowContentResolver.registerProviderInternal("media",provider);
        assertEquals(1,PendingOriginalExports.cleanupCollection(RuntimeEnvironment.getApplication().getContentResolver(),
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI,OWNER,"Movies/YI4K/Edited/"));
        assertEquals(Arrays.asList(2L,3L,4L,5L,6L),provider.ids());
    }

    @Test public void deletionRechecksPendingToPreserveConcurrentPublication() throws Exception {
        Rows provider = new Rows();
        provider.rows.add(new Row(1, OWNER, "Movies/YI4K/", 1));
        provider.publishBeforeDelete = true;
        ShadowContentResolver.registerProviderInternal("media", provider);
        assertEquals(0, PendingOriginalExports.cleanup(RuntimeEnvironment.getApplication().getContentResolver(), OWNER));
        assertEquals(Arrays.asList(1L), provider.ids());
        assertEquals(0, provider.rows.get(0).pending);
    }

    @Test public void waitsForRecoveryAndNeverSweepsNewExportsAgain() throws Exception {
        CountDownLatch entered = new CountDownLatch(1), release = new CountDownLatch(1);
        AtomicInteger runs = new AtomicInteger();
        PendingOriginalExports recovery = new PendingOriginalExports(() -> {
            runs.incrementAndGet(); entered.countDown();
            if (!release.await(5, TimeUnit.SECONDS)) throw new IOException("test release timeout");
            return 1;
        });
        ExecutorService worker = Executors.newSingleThreadExecutor();
        try {
            // start() must return while MediaProvider is still blocked.
            recovery.start(); assertTrue(entered.await(5, TimeUnit.SECONDS));
            CountDownLatch waiting = new CountDownLatch(1);
            Future<?> export = worker.submit(() -> {
                waiting.countDown(); recovery.await(() -> false); return null;
            });
            assertTrue(waiting.await(5, TimeUnit.SECONDS));
            assertFalse("Export must wait for startup cleanup", export.isDone());
            release.countDown(); export.get(5, TimeUnit.SECONDS);
            recovery.await(() -> false);
            assertEquals("Later exports must not delete this process's pending rows", 1, runs.get());
        } finally { release.countDown(); worker.shutdownNow(); }
    }

    @Test public void failedRecoveryBlocksFirstExportAndNextAttemptRetries() throws Exception {
        AtomicInteger attempts = new AtomicInteger();
        PendingOriginalExports recovery = new PendingOriginalExports(() -> {
            if (attempts.incrementAndGet() == 1) throw new SecurityException("provider denied");
            return 0;
        });
        try { recovery.await(() -> false); fail("Failed recovery must block export"); }
        catch (IOException expected) { assertTrue(expected.getMessage().contains("无法清理")); }
        recovery.await(() -> false); recovery.await(() -> false);
        assertEquals(2, attempts.get());
    }

    @Test public void cancelledWaitDoesNotCancelOrRestartSharedRecovery() throws Exception {
        CountDownLatch entered = new CountDownLatch(1), release = new CountDownLatch(1);
        AtomicInteger runs = new AtomicInteger();
        PendingOriginalExports recovery = new PendingOriginalExports(() -> {
            runs.incrementAndGet(); entered.countDown(); release.await(5, TimeUnit.SECONDS); return 0;
        });
        try {
            recovery.start(); assertTrue(entered.await(5, TimeUnit.SECONDS));
            try { recovery.await(() -> true); fail("Cancelled export waited for recovery"); }
            catch (IOException expected) { assertTrue(expected.getMessage().contains("取消")); }
            release.countDown(); recovery.await(() -> false);
            assertEquals(1, runs.get());
        } finally { release.countDown(); }
    }

    @Test public void absentProviderResultFailsClosed() throws Exception {
        Rows provider = new Rows(); provider.nullCursor = true;
        ShadowContentResolver.registerProviderInternal("media", provider);
        try {
            PendingOriginalExports.cleanup(RuntimeEnvironment.getApplication().getContentResolver(), OWNER);
            fail("An unavailable MediaProvider cannot count as successful cleanup");
        } catch (IOException expected) { assertTrue(expected.getMessage().contains("无法读取")); }
        assertTrue(provider.ids().isEmpty());
    }

    private static final class Row {
        final long id; final String owner, directory; int pending;
        Row(long id, String owner, String directory, int pending) {
            this.id=id; this.owner=owner; this.directory=directory; this.pending=pending;
        }
    }

    public static final class Rows extends ContentProvider {
        final List<Row> rows = new ArrayList<>();
        boolean nullCursor, publishBeforeDelete;
        List<Long> ids() { List<Long> ids=new ArrayList<>(); for(Row row:rows)ids.add(row.id); return ids; }
        @Override public boolean onCreate() { return true; }
        @Override public Cursor query(Uri uri, String[] columns, String where, String[] args, String order) {
            if (nullCursor) return null;
            MatrixCursor result = new MatrixCursor(columns);
            for (Row row : rows) result.addRow(new Object[]{row.id, row.owner, row.directory, row.pending});
            return result;
        }
        @Override public int delete(Uri uri, String where, String[] args) {
            assertTrue("Deletion must recheck pending", where.contains(MediaStore.MediaColumns.IS_PENDING+"=1"));
            assertTrue(where.contains(MediaStore.MediaColumns.OWNER_PACKAGE_NAME+"=?"));
            assertTrue(where.contains(MediaStore.MediaColumns.RELATIVE_PATH+"=?"));
            long id=Long.parseLong(uri.getLastPathSegment());
            for (Row row : new ArrayList<>(rows)) {
                if (row.id!=id) continue;
                if (publishBeforeDelete) row.pending=0;
                if (row.pending==1 && row.owner.equals(args[0]) && row.directory.equals(args[1])) {
                    rows.remove(row); return 1;
                }
            }
            return 0;
        }
        @Override public Uri insert(Uri uri, ContentValues values) { throw new UnsupportedOperationException(); }
        @Override public int update(Uri uri, ContentValues values, String where, String[] args) { throw new UnsupportedOperationException(); }
        @Override public String getType(Uri uri) { return null; }
    }
}
