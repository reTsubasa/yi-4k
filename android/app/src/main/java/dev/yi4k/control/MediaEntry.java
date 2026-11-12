package dev.yi4k.control;

import java.net.URI;
import java.util.Locale;

public final class MediaEntry {
    public static final String DCIM_ROOT = "/tmp/fuse_d/DCIM/";
    public final String path, name, info;
    public final boolean directory;
    public final long bytes;
    public MediaEntry(String folder, String name, String info) {
        if (!folder.endsWith("/") || !folder.startsWith(DCIM_ROOT) || !safeComponents(folder.substring(DCIM_ROOT.length()), true)
                || !safeComponents(name, false)) throw new IllegalArgumentException("无效的媒体路径");
        this.name = name; this.info = info; this.directory = name.endsWith("/");
        this.path = folder + name;
        long size = -1;
        try { if (info.contains(" bytes|")) size = Long.parseLong(info.substring(0, info.indexOf(" bytes|"))); }
        catch (NumberFormatException ignored) { }
        bytes = size;
    }
    private static boolean safeComponents(String text, boolean multi) {
        String value = text.endsWith("/") ? text.substring(0, text.length() - 1) : text;
        if (value.isEmpty()) return multi;
        if (!multi && value.contains("/")) return false;
        for (String part : value.split("/", -1)) {
            if (part.isEmpty() || part.equals(".") || part.equals("..") || !part.matches("[A-Za-z0-9_. -]+")) return false;
        }
        return true;
    }
    public boolean isMedia() {
        String upper = name.toUpperCase(Locale.ROOT);
        return !directory && (upper.endsWith(".MP4") || upper.endsWith(".JPG") || upper.endsWith(".JPEG"));
    }
    public URI uri(String host) throws Exception {
        return uri(host, 80);
    }
    public URI uri(String host, int port) throws Exception {
        if (!isMedia()) throw new IllegalArgumentException("请选择视频或照片");
        return new URI("http", null, host, port, path.substring("/tmp/fuse_d".length()), null, null);
    }
}
