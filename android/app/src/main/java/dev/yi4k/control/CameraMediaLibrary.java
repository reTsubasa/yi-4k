package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** A complete camera library snapshot. A failed subdirectory never publishes a partial list. */
final class CameraMediaLibrary {
    interface Listing { JSONObject read(String directory) throws Exception; }
    static List<MediaEntry> load(String root, Listing source) throws Exception {
        ArrayDeque<String> pending = new ArrayDeque<>(); pending.add(root);
        Set<String> visited = new HashSet<>();
        ArrayList<MediaEntry> media = new ArrayList<>();
        while (!pending.isEmpty()) {
            String directory = pending.remove();
            if (!visited.add(directory)) continue;
            if (visited.size() > 512) throw new IOException("相机目录过多，请检查存储卡后重试");
            JSONObject response = source.read(directory);
            JSONArray rows = response.getJSONArray("listing");
            if (response.optInt("total", rows.length()) > rows.length())
                throw new IOException("相机返回的媒体列表不完整，请稍后刷新");
            for (int i = 0; i < rows.length(); i++) {
                JSONObject row = rows.getJSONObject(i);
                java.util.Iterator<String> keys = row.keys();
                while (keys.hasNext()) {
                    String name = keys.next();
                    MediaEntry entry = new MediaEntry(directory, name, row.getString(name));
                    if (entry.directory) pending.add(entry.path);
                    else if (entry.isMedia()) media.add(entry);
                }
            }
        }
        media.sort(Comparator.comparing((MediaEntry e) -> e.name).reversed().thenComparing(e -> e.path));
        return media;
    }
}
