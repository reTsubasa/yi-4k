package dev.yi4k.control;

import java.io.File;
import java.nio.file.Files;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import static org.junit.Assert.*;

public class VideoEditSessionTest {
    @Rule public TemporaryFolder temporary = new TemporaryFolder();
    @Test public void recreationKeepsSourceAndInactiveSessionsAreReclaimed() throws Exception {
        File cache=temporary.newFolder();
        VideoEditSession before=VideoEditSession.open(cache,null);
        File original=new File(before.directory,"edit-source-123.mp4");assertTrue(original.createNewFile());
        VideoEditSession after=VideoEditSession.open(cache,before.id);
        before.close(true);after.cleanStale();assertTrue(original.exists());
        after.close(true);
        VideoEditSession another=VideoEditSession.open(cache,null);another.cleanStale();
        assertFalse(original.exists());assertFalse(after.directory.exists());another.close(false);
    }
    @Test public void liveEditorsAreKeptAndNormalCloseRemovesOnlyOwnedFiles() throws Exception {
        File cache=temporary.newFolder();VideoEditSession first=VideoEditSession.open(cache,null);
        File original=new File(first.directory,"edit-source-123.mp4");assertTrue(original.createNewFile());
        VideoEditSession second=VideoEditSession.open(cache,null);second.cleanStale();assertTrue(original.exists());
        File unrelated=new File(second.directory,"unrelated.txt");assertTrue(unrelated.createNewFile());
        second.close(false);assertTrue(unrelated.exists());assertTrue(original.exists());
        first.close(false);assertFalse(original.exists());
    }
    @Test public void rejectsPathIdsAndNeverTraversesSymlinkedWorkspaces() throws Exception {
        File cache=temporary.newFolder(),outside=temporary.newFolder();
        File keep=new File(outside,"edit-source-keep.mp4");assertTrue(keep.createNewFile());
        VideoEditSession session=VideoEditSession.open(cache,"../../outside");
        assertEquals(new File(cache,"video-edit").getCanonicalFile(),session.directory.getCanonicalFile().getParentFile());
        File link=new File(session.directory.getParentFile(),"11111111-1111-1111-1111-111111111111");
        Files.createSymbolicLink(link.toPath(),outside.toPath());
        session.cleanStale();assertTrue(keep.exists());session.close(false);
    }
}
