package dev.yi4k.control;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import java.io.IOException;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.function.BooleanSupplier;

/** One recovery barrier per process; never sweep after this process starts exporting. */
final class PendingOriginalExports {
    private static final String SELECTION = MediaStore.MediaColumns.OWNER_PACKAGE_NAME + "=? AND "
            + MediaStore.MediaColumns.RELATIVE_PATH + "=? AND " + MediaStore.MediaColumns.IS_PENDING + "=1";
    private final Callable<Integer> cleanup;
    private FutureTask<Integer> task;

    PendingOriginalExports(ContentResolver resolver, String packageName) {
        this(() -> cleanup(resolver, packageName));
    }

    PendingOriginalExports(Callable<Integer> cleanup) { this.cleanup = cleanup; }

    synchronized FutureTask<Integer> start() {
        if (task == null) {
            task = new FutureTask<>(cleanup);
            Thread worker = new Thread(task, "yi4k-original-export-recovery");
            worker.start();
        }
        return task;
    }

    void await(BooleanSupplier cancelled) throws IOException {
        FutureTask<Integer> pending = start();
        long deadline = System.nanoTime() + TimeUnit.SECONDS.toNanos(15);
        for (;;) {
            MediaTransfer.checkCancelled(cancelled);
            try {
                pending.get(250, TimeUnit.MILLISECONDS);
                MediaTransfer.checkCancelled(cancelled);
                return;
            } catch (TimeoutException error) {
                // Keep the running task as the barrier: starting a second sweep
                // could otherwise race a new export's pending destination.
                if (System.nanoTime() >= deadline)
                    throw new IOException("正在清理上次未完成的导出，请稍候重试", error);
            } catch (InterruptedException error) {
                Thread.currentThread().interrupt();
                throw new IOException("导出已取消", error);
            } catch (ExecutionException error) {
                synchronized (this) { if (task == pending) task = null; }
                throw new IOException("无法清理上次未完成的导出，请重试：" + error.getCause().getMessage(), error.getCause());
            }
        }
    }

    static int cleanup(ContentResolver resolver, String packageName) throws IOException {
        if (packageName == null || packageName.isEmpty()) throw new IOException("无法确认导出文件归属");
        return cleanupCollection(resolver, MediaStore.Video.Media.EXTERNAL_CONTENT_URI, packageName, "Movies/YI4K/")
                + cleanupCollection(resolver, MediaStore.Images.Media.EXTERNAL_CONTENT_URI, packageName, "Pictures/YI4K/");
    }

    static int cleanupCollection(ContentResolver resolver, Uri collection, String packageName, String directory)
            throws IOException {
        String[] args = {packageName, directory};
        String[] projection = {MediaStore.MediaColumns._ID, MediaStore.MediaColumns.OWNER_PACKAGE_NAME,
                MediaStore.MediaColumns.RELATIVE_PATH, MediaStore.MediaColumns.IS_PENDING};
        Uri pendingCollection = collection;
        Cursor result;
        if (Build.VERSION.SDK_INT >= 30) {
            Bundle query = new Bundle();
            query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING, MediaStore.MATCH_INCLUDE);
            query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION, SELECTION);
            query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS, args);
            result = resolver.query(collection, projection, query, null);
        } else {
            pendingCollection = MediaStore.setIncludePending(collection);
            result = resolver.query(pendingCollection, projection, SELECTION, args, null);
        }
        int removed = 0;
        try (Cursor rows = result) {
            if (rows == null) throw new IOException("无法读取未完成的导出文件");
            while (rows.moveToNext()) {
                // Check the returned row too; never trust a provider that
                // accidentally ignores a selection argument.
                if (!packageName.equals(rows.getString(1)) || !directory.equals(rows.getString(2)) || rows.getInt(3) != 1) continue;
                Uri item = ContentUris.withAppendedId(pendingCollection, rows.getLong(0));
                // Re-check pending at deletion, preserving a row published
                // between the query and deletion.
                removed += resolver.delete(item, SELECTION, args);
            }
        }
        return removed;
    }
}
