package dev.yi4k.control;

import android.app.Application;
import java.io.IOException;
import java.util.function.BooleanSupplier;

/** Start abandoned-original recovery without blocking the first screen. */
public final class Yi4kApplication extends Application {
    private static volatile PendingOriginalExports originalExports, editedExports;

    @Override public void onCreate() {
        super.onCreate();
        PendingOriginalExports recovery = new PendingOriginalExports(getContentResolver(), getPackageName());
        originalExports = recovery;
        recovery.start();
        PendingOriginalExports edited = new PendingOriginalExports(() -> PendingOriginalExports.cleanupCollection(
                getContentResolver(), android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                getPackageName(), "Movies/YI4K/Edited/"));
        editedExports = edited; edited.start();
    }

    static void awaitEditedExportRecovery(BooleanSupplier cancelled) throws IOException {
        PendingOriginalExports recovery = editedExports;
        if (recovery == null) throw new IOException("剪辑导出初始化尚未完成，请重启应用后重试");
        recovery.await(cancelled);
    }

    static void awaitOriginalExportRecovery(BooleanSupplier cancelled) throws IOException {
        PendingOriginalExports recovery = originalExports;
        if (recovery == null) throw new IOException("导出初始化尚未完成，请重启应用后重试");
        recovery.await(cancelled);
    }
}
