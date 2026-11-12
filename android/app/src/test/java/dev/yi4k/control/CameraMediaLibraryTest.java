package dev.yi4k.control;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

public final class CameraMediaLibraryTest {
    @Test public void automaticallyCollectsEveryFolderAndRetainsFullFileIdentity() throws Exception {
        List<String> requested = new ArrayList<>();
        List<MediaEntry> entries = CameraMediaLibrary.load(MediaEntry.DCIM_ROOT, path -> {
            requested.add(path);
            if (path.equals(MediaEntry.DCIM_ROOT)) return listing("100MEDIA/", "101MEDIA/");
            return listing("SAME.MP4", "PHOTO.JPG", "IGNORE.THM");
        });
        assertEquals(3, requested.size()); assertEquals(4, entries.size());
        assertTrue(entries.stream().noneMatch(e -> e.directory));
        assertEquals(4, entries.stream().map(e -> e.path).distinct().count());
    }
    @Test public void incompleteSubfolderRejectsEntireSnapshot() throws Exception {
        try {
            CameraMediaLibrary.load(MediaEntry.DCIM_ROOT, path -> path.equals(MediaEntry.DCIM_ROOT)
                    ? listing("100MEDIA/") : listing("ONE.MP4").put("total", 4));
            fail("Must reject a partial library");
        } catch (java.io.IOException expected) { assertTrue(expected.getMessage().contains("不完整")); }
    }
    @Test public void emptyLibraryCompletesAfterOneRequest() throws Exception {
        List<String> requested = new ArrayList<>();
        assertTrue(CameraMediaLibrary.load(MediaEntry.DCIM_ROOT, path -> { requested.add(path); return listing(); }).isEmpty());
        assertEquals(1, requested.size());
    }
    private static JSONObject listing(String... names) throws Exception {
        JSONArray rows = new JSONArray();
        for (String name : names) rows.put(new JSONObject().put(name, "10 bytes|date"));
        return new JSONObject().put("listing", rows).put("total", rows.length());
    }
}
