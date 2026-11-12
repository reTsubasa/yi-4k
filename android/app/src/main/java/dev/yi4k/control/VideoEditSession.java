package dev.yi4k.control;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/** Private editing workspaces. Active editors and restored sessions keep their own files. */
final class VideoEditSession {
    private static final Map<String, Integer> ACTIVE = new HashMap<>();
    final File directory;
    final String id;
    private final String key;
    private boolean closed;

    private VideoEditSession(File directory, String id) throws IOException {
        this.directory = directory; this.id = id; key = directory.getCanonicalPath();
    }
    static synchronized VideoEditSession open(File cacheDirectory, String requested) throws IOException {
        String id = validId(requested) ? requested : UUID.randomUUID().toString();
        File root = new File(cacheDirectory, "video-edit").getCanonicalFile();
        File directory = new File(root, id);
        if (!directory.isDirectory() && !directory.mkdirs()) throw new IOException("无法创建剪辑缓存");
        VideoEditSession session = new VideoEditSession(directory, id);
        ACTIVE.put(session.key, ACTIVE.getOrDefault(session.key, 0) + 1);
        return session;
    }
    /** Only files inside inactive UUID workspaces created by this feature are candidates. */
    synchronized void cleanStale() throws IOException {
        synchronized (VideoEditSession.class) {
            File[] siblings = directory.getParentFile().listFiles();
            if (siblings == null) return;
            for (File candidate : siblings) {
                if (candidate.isDirectory() && validId(candidate.getName())
                        && candidate.getCanonicalFile().getParentFile().equals(directory.getParentFile().getCanonicalFile())
                        && !ACTIVE.containsKey(candidate.getCanonicalPath())) deleteOwned(candidate);
            }
        }
    }
    synchronized void close(boolean preserve) {
        if (closed) return; closed = true;
        synchronized (VideoEditSession.class) {
            int owners = ACTIVE.getOrDefault(key, 1) - 1;
            if (owners > 0) ACTIVE.put(key, owners);
            else { ACTIVE.remove(key); if (!preserve) deleteOwned(directory); }
        }
    }
    private static boolean validId(String value) {
        return value != null && value.matches("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}");
    }
    private static void deleteOwned(File directory) {
        File[] files = directory.listFiles();
        if (files != null) for (File file : files) {
            // No recursive traversal: only editor-created flat files are removed.
            if (file.isFile() && (file.getName().startsWith("edit-source-") || file.getName().startsWith("edit-output-"))) file.delete();
        }
        directory.delete();
    }
}
