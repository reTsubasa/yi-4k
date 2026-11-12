package dev.yi4k.control;

import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Binder;
import android.os.Bundle;
import android.os.Process;
import android.os.ParcelFileDescriptor;
import android.provider.MediaStore;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/** Installed in the test APK's own UID, never the instrumented target process. */
public final class PendingExportFixtureProvider extends ContentProvider {
    private static final String TARGET = "dev.yi4k.control";
    private static final String OWNER = "dev.yi4k.control.test";
    private static final String DIRECTORY = "Movies/YI4K/";
    private static final Uri COLLECTION = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
    private static final String FILTER = MediaStore.MediaColumns.DISPLAY_NAME + "=? AND "
            + MediaStore.MediaColumns.OWNER_PACKAGE_NAME + "=? AND "
            + MediaStore.MediaColumns.RELATIVE_PATH + "=? AND " + MediaStore.MediaColumns.IS_PENDING + "=1";

    @Override public boolean onCreate() { return true; }

    @Override public Bundle call(String method, String name, Bundle extras) {
        int caller = Binder.getCallingUid();
        try {
            int targetUid = getContext().getPackageManager().getApplicationInfo(TARGET, 0).uid;
            if (caller != Process.myUid() && caller != 2000 && caller != targetUid)
                throw new SecurityException("Fixture access is restricted to target, shell and self");
            if (Process.myUid() == targetUid || !OWNER.equals(getContext().getPackageName()))
                throw new IllegalStateException("Fixture provider must run in the independent test APK UID");
        } catch (android.content.pm.PackageManager.NameNotFoundException error) {
            throw new IllegalStateException(error);
        }
        if (name == null || !name.matches("yi4k-foreign-owner-[a-f0-9-]{36}\\.mp4"))
            throw new IllegalArgumentException("Expected a unique fixture filename");
        long identity = Binder.clearCallingIdentity();
        try {
            ContentResolver resolver = getContext().getContentResolver();
            if ("create".equals(method)) {
                ContentValues values = new ContentValues();
                values.put(MediaStore.MediaColumns.DISPLAY_NAME, name);
                values.put(MediaStore.MediaColumns.MIME_TYPE, "video/mp4");
                values.put(MediaStore.MediaColumns.RELATIVE_PATH, DIRECTORY);
                values.put(MediaStore.MediaColumns.IS_PENDING, 1);
                Uri uri = resolver.insert(COLLECTION, values);
                if (uri == null) throw new IOException("Test APK could not create its own pending row");
                try (OutputStream output = resolver.openOutputStream(uri)) {
                    if (output == null) throw new IOException("Test APK could not write fixture bytes");
                    output.write(new byte[1024]);
                } catch (Exception error) { resolver.delete(uri, null, null); throw error; }
            } else if (!"status".equals(method) && !"delete".equals(method)) {
                throw new IllegalArgumentException("Unknown fixture operation");
            }
            // Teardown must also handle a stale MediaProvider row whose file
            // was already removed by a prior failed teardown. Status/create
            // still require actual bytes and a digest for preservation proof.
            Bundle result = find(resolver, name, !"delete".equals(method));
            result.putInt("provider_uid", Process.myUid());
            result.putInt("provider_pid", Process.myPid());
            if ("delete".equals(method) && result.getBoolean("exists")) {
                int deleted = resolver.delete(Uri.parse(result.getString("uri")), FILTER, new String[]{name, OWNER, DIRECTORY});
                result.putInt("deleted", deleted);
                if (find(resolver, name, false).getBoolean("exists"))
                    throw new IOException("Foreign fixture row survived exact teardown");
            }
            return result;
        } catch (IOException error) { throw new IllegalStateException("Foreign fixture I/O failed", error); }
        finally { Binder.restoreCallingIdentity(identity); }
    }

    private Bundle find(ContentResolver resolver, String name, boolean inspectBytes) throws IOException {
        Bundle query = new Bundle(); query.putInt(MediaStore.QUERY_ARG_MATCH_PENDING, MediaStore.MATCH_INCLUDE);
        query.putString(ContentResolver.QUERY_ARG_SQL_SELECTION, FILTER);
        query.putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS, new String[]{name, OWNER, DIRECTORY});
        String[] columns = {MediaStore.MediaColumns._ID, MediaStore.MediaColumns.OWNER_PACKAGE_NAME,
                MediaStore.MediaColumns.RELATIVE_PATH, MediaStore.MediaColumns.IS_PENDING, MediaStore.MediaColumns.SIZE};
        Bundle result = new Bundle();
        try (Cursor rows = resolver.query(COLLECTION, columns, query, null)) {
            if (rows == null) throw new IOException("Cannot query the test APK's fixture");
            result.putBoolean("exists", rows.moveToFirst());
            if (!result.getBoolean("exists")) return result;
            result.putString("uri", ContentUris.withAppendedId(COLLECTION, rows.getLong(0)).toString());
            result.putString("owner", rows.getString(1)); result.putString("directory", rows.getString(2));
            result.putInt("pending", rows.getInt(3)); result.putLong("reported_media_size", rows.getLong(4));
            if (rows.moveToNext()) throw new IOException("Fixture name is not unique");
        }
        if (!inspectBytes) return result;
        Uri item = Uri.parse(result.getString("uri"));
        try (ParcelFileDescriptor file = resolver.openFileDescriptor(item, "r")) {
            if (file == null) throw new IOException("Cannot open the foreign fixture");
            result.putLong("bytes", file.getStatSize());
        }
        try (InputStream input = resolver.openInputStream(item)) {
            if (input == null) throw new IOException("Cannot read the foreign fixture");
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] buffer = new byte[1024]; int count; long total = 0;
            while ((count = input.read(buffer)) != -1) {
                total += count;
                if (total > 1024) throw new IOException("Foreign fixture exceeds its expected size");
                digest.update(buffer, 0, count);
            }
            if (total != result.getLong("bytes")) throw new IOException("Foreign fixture changed while reading");
            StringBuilder hash = new StringBuilder();
            for (byte b : digest.digest()) hash.append(String.format(java.util.Locale.ROOT, "%02x", b & 255));
            result.putString("sha256", hash.toString());
        } catch (NoSuchAlgorithmException error) { throw new IllegalStateException(error); }
        return result;
    }

    @Override public Cursor query(Uri uri, String[] projection, String selection, String[] args, String order) { throw new UnsupportedOperationException(); }
    @Override public Uri insert(Uri uri, ContentValues values) { throw new UnsupportedOperationException(); }
    @Override public int update(Uri uri, ContentValues values, String selection, String[] args) { throw new UnsupportedOperationException(); }
    @Override public int delete(Uri uri, String selection, String[] args) { throw new UnsupportedOperationException(); }
    @Override public String getType(Uri uri) { return null; }
}
