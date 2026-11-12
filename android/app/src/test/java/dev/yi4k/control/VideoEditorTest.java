package dev.yi4k.control;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.net.Uri;
import android.os.Looper;
import android.os.Bundle;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;
import androidx.media3.transformer.EditedMediaItem;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.GraphicsMode;
import org.robolectric.annotation.LooperMode;
import org.robolectric.annotation.Implementation;
import org.robolectric.annotation.Implements;
import android.media.MediaMetadataRetriever;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

@RunWith(RobolectricTestRunner.class)
@Config(sdk=35,qualifiers="w412dp-h915dp-mdpi")
@LooperMode(LooperMode.Mode.PAUSED)
public class VideoEditorTest {
    @Test public void usesSystemPickerAndNeverEnablesExportBeforeImport() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity=lifecycle.get(); assertFalse(((View)get(activity,"export")).isEnabled());
            assertEquals(View.INVISIBLE, ((View)get(activity,"export")).getVisibility());
            assertEquals(View.GONE, ((View)get(activity,"editorPanel")).getVisibility());
            assertEquals("选择素材", ((TextView)get(activity,"heading")).getText().toString());
            ((View)get(activity,"choose")).performClick(); Intent intent=shadowOf(activity).getNextStartedActivityForResult().intent;
            assertEquals(Intent.ACTION_OPEN_DOCUMENT,intent.getAction()); assertEquals("video/*",intent.getType());
            assertTrue(intent.hasCategory(Intent.CATEGORY_OPENABLE));
        }
    }
    @Test public void sliderCrossingKeepsANonemptyRangeAndExactSourceTimes() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity=lifecycle.get(); set(activity,"durationMs",42000L); set(activity,"startMs",7000L);set(activity,"endMs",31000L);
            SeekBar start=(SeekBar)get(activity,"start"),end=(SeekBar)get(activity,"end");
            shadowOf(start).getOnSeekBarChangeListener().onProgressChanged(start,10000,true);
            assertEquals(30900L,get(activity,"startMs"));
            shadowOf(end).getOnSeekBarChangeListener().onProgressChanged(end,0,true);
            assertEquals(31000L,get(activity,"endMs"));
            assertTrue(((TextView)get(activity,"range")).getText().toString().contains("保留 00:00.1"));
        }
    }
    @Test public void passesClipAudioAndActualEffectsToTransformer() {
        VideoEditPlan plan=new VideoEditPlan(42000,7000,31000,true,true,90);
        Uri source=Uri.parse("file:///private/original.mp4"); EditedMediaItem edited=VideoEditMedia.edited(source,plan);
        assertTrue(edited.removeAudio);assertFalse(edited.removeVideo);
        assertEquals(7000,edited.mediaItem.clippingConfiguration.startPositionMs);
        assertEquals(31000,edited.mediaItem.clippingConfiguration.endPositionMs);
        assertEquals(source,edited.mediaItem.localConfiguration.uri);
        assertEquals(2,edited.effects.videoEffects.size());
        assertTrue(edited.effects.audioProcessors.isEmpty());
    }
    @Test public void draggingTimelineMovesNearestHandleAndKeepsMinimumRange() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity=lifecycle.get();
            set(activity,"durationMs",10000L);set(activity,"startMs",0L);set(activity,"endMs",10000L);
            View strip=(View)get(activity,"strip"); strip.setEnabled(true); strip.layout(0,0,1000,80);
            touch(strip,android.view.MotionEvent.ACTION_DOWN,0);
            touch(strip,android.view.MotionEvent.ACTION_MOVE,300);
            touch(strip,android.view.MotionEvent.ACTION_UP,300);
            assertEquals(3000L,get(activity,"startMs"));assertEquals(10000L,get(activity,"endMs"));
            touch(strip,android.view.MotionEvent.ACTION_DOWN,1000);
            touch(strip,android.view.MotionEvent.ACTION_MOVE,200);
            touch(strip,android.view.MotionEvent.ACTION_UP,200);
            assertEquals(3000L,get(activity,"startMs"));assertEquals(3100L,get(activity,"endMs"));
            assertTrue(((TextView)get(activity,"range")).getText().toString().contains("保留 00:00.1"));
            assertEquals(3000,((SeekBar)get(activity,"start")).getProgress());
            assertEquals(3100,((SeekBar)get(activity,"end")).getProgress());
        }
    }
    @Test public void effectButtonsExposeSelectedStateAndResultIsInline() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity=lifecycle.get();
            for(String key:new String[]{"mute","filter","rotate"}){
                View button=(View)get(activity,key);button.setEnabled(true);button.performClick();
                assertTrue(key,button.isSelected());
            }
            assertEquals(View.GONE,((View)get(activity,"completion")).getVisibility());
            assertFalse(((View)get(activity,"playSelection")).isEnabled());
            assertEquals("查看视频",((TextView)get(activity,"openResult")).getText().toString());
        }
    }
    @Test public void cancellingImportClosesOnlyTheOwnedStream() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity=lifecycle.get(); AtomicBoolean closed=new AtomicBoolean();
            java.io.InputStream owned=new java.io.ByteArrayInputStream(new byte[]{1,2,3}) {
                @Override public void close(){closed.set(true);}
            };
            set(activity,"importStream",owned);set(activity,"loading",true);
            java.lang.reflect.Method cancel=VideoEditorActivity.class.getDeclaredMethod("cancelCurrentTask");cancel.setAccessible(true);cancel.invoke(activity);
            assertTrue(closed.get());assertTrue(((AtomicBoolean)get(activity,"importCancelled")).get());
            assertEquals("正在取消读取…",((TextView)get(activity,"status")).getText().toString());
            assertFalse((Boolean)get(activity,"exporting"));
        }
    }
    private static void touch(View view,int action,float x) {
        android.view.MotionEvent e=android.view.MotionEvent.obtain(0,1,action,x,40,0);
        try{assertTrue(view.dispatchTouchEvent(e));}finally{e.recycle();}
    }
    @Test public void leavingEditorCancelsJobAndRemovesOnlyItsTemporaryOutput() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity=lifecycle.get(); File incomplete=File.createTempFile("edit-test-",".mp4",activity.getCacheDir());
            File unrelated=File.createTempFile("keep-",".mp4",activity.getCacheDir());
            AtomicBoolean token=new AtomicBoolean(); set(activity,"exporting",true);set(activity,"exportToken",token);set(activity,"exportFile",incomplete);
            lifecycle.pause().stop(); ((ExecutorService)get(activity,"worker")).submit(()->{}).get(5,TimeUnit.SECONDS);
            assertTrue(token.get());assertFalse(incomplete.exists());assertTrue(unrelated.exists());
            assertFalse((boolean)get(activity,"exporting"));unrelated.delete();
        }
    }
    @Test public void restoresPrivateSourceAndEditingParametersAfterActivityRecreation() throws Exception {
        VideoEditSession session=VideoEditSession.open(org.robolectric.RuntimeEnvironment.getApplication().getCacheDir(),null);
        File source=new File(session.directory,"edit-source-123.mp4");
        java.nio.file.Files.write(source.toPath(),new byte[]{1,2,3});
        Bundle saved=new Bundle();saved.putString("edit_session",session.id);saved.putString("edit_source",source.getName());
        saved.putLong("edit_duration",42000);saved.putLong("edit_start",7000);saved.putLong("edit_end",31000);
        saved.putBoolean("edit_muted",true);saved.putBoolean("edit_grayscale",true);saved.putInt("edit_rotation",270);
        session.close(true);
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).create(saved)) {
            VideoEditorActivity restored=lifecycle.get();
            assertEquals(source.getCanonicalFile(),get(restored,"sourceFile"));
            assertEquals(7000L,get(restored,"startMs"));assertEquals(31000L,get(restored,"endMs"));
            assertEquals(true,get(restored,"muted"));assertEquals(true,get(restored,"grayscale"));assertEquals(270,get(restored,"rotation"));
            assertTrue(((View)get(restored,"export")).isEnabled());
            ((ExecutorService)get(restored,"worker")).submit(()->{}).get(5,TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
        }
    }
    @Test @GraphicsMode(GraphicsMode.Mode.NATIVE) public void rendersHonestEditorEmptyState() throws Exception {
        try(ActivityController<VideoEditorActivity> lifecycle=Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            View root=lifecycle.get().findViewById(android.R.id.content);
            root.measure(View.MeasureSpec.makeMeasureSpec(412,View.MeasureSpec.EXACTLY),View.MeasureSpec.makeMeasureSpec(867,View.MeasureSpec.EXACTLY));root.layout(0,0,412,867);
            Bitmap image=Bitmap.createBitmap(412,867,Bitmap.Config.ARGB_8888);root.draw(new Canvas(image));
            File directory=new File("build/reports/prototype-renders");assertTrue(directory.isDirectory()||directory.mkdirs());
            try(FileOutputStream output=new FileOutputStream(new File(directory,"editor-empty.png"))){assertTrue(image.compress(Bitmap.CompressFormat.PNG,100,output));}image.recycle();
        }
    }
    @Test @Config(qualifiers="w320dp-h720dp-mdpi") @GraphicsMode(GraphicsMode.Mode.NATIVE)
    public void narrowEditorKeepsToolLabelsAndAlignedActionsAtLargeFont() throws Exception {
        org.robolectric.RuntimeEnvironment.setFontScale(1.6f);
        try (ActivityController<VideoEditorActivity> lifecycle = Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity = lifecycle.get();
            VideoEditSession session = (VideoEditSession) get(activity, "session");
            File source = new File(session.directory, "edit-source-123.mp4");
            java.nio.file.Files.write(source.toPath(), new byte[]{1,2,3});
            set(activity, "sourceFile", source);
            java.lang.reflect.Method enable = VideoEditorActivity.class.getDeclaredMethod("updateEnabled");
            enable.setAccessible(true); enable.invoke(activity);
            View root = activity.findViewById(android.R.id.content);
            root.measure(View.MeasureSpec.makeMeasureSpec(320, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(720, View.MeasureSpec.EXACTLY));
            root.layout(0, 0, 320, 720);
            TextView mute = (TextView) get(activity, "mute"), filter = (TextView) get(activity, "filter");
            TextView rotate = (TextView) get(activity, "rotate"), reset = (TextView) get(activity, "reset");
            for (String field : new String[]{"mute", "filter", "rotate", "reset", "export", "choose"})
                assertTextFits((TextView) get(activity, field));
            assertEquals(mute.getBaseline(), filter.getBaseline()); assertEquals(rotate.getBaseline(), reset.getBaseline());
            assertEquals(8, filter.getLeft() - mute.getRight()); assertEquals(8, reset.getLeft() - rotate.getRight());
            assertEquals(8, ((View) rotate.getParent()).getTop() - ((View) mute.getParent()).getBottom());
            TextView title = findText(root, "剪辑");
            View toolbar = (View) title.getParent(); assertEquals(toolbar.getWidth(), title.getLeft() + title.getRight());
            assertTrue(((View) get(activity, "choose")).getHeight() >= 48);
            Bitmap image = Bitmap.createBitmap(320, 720, Bitmap.Config.ARGB_8888); root.draw(new Canvas(image));
            File directory = new File("build/reports/prototype-renders"); assertTrue(directory.isDirectory() || directory.mkdirs());
            try (FileOutputStream output = new FileOutputStream(new File(directory, "editor-narrow-large-font.png"))) {
                assertTrue(image.compress(Bitmap.CompressFormat.PNG, 100, output));
            } finally { image.recycle(); }
        } finally { org.robolectric.RuntimeEnvironment.setFontScale(1f); }
    }
    @Test public void cancellingPickerKeepsSelectionStageWithClearStatus() throws Exception {
        try (ActivityController<VideoEditorActivity> lifecycle = Robolectric.buildActivity(VideoEditorActivity.class).setup()) {
            VideoEditorActivity activity = lifecycle.get();
            activity.onActivityResult(410,android.app.Activity.RESULT_CANCELED,null);
            assertEquals("尚未选择视频，点击上方按钮继续",((TextView)get(activity,"status")).getText().toString());
            assertEquals(View.GONE,((View)get(activity,"editorPanel")).getVisibility());
            assertTrue(((View)get(activity,"choose")).isEnabled());
        }
    }
    @Test public void unreadableDocumentShowsFailureAndAllowsAnotherSelection() throws Exception {
        Uri selected = Uri.parse("content://videos/expired/404");
        shadowOf(org.robolectric.RuntimeEnvironment.getApplication().getContentResolver()).registerInputStream(selected,new java.io.InputStream() {
            @Override public int read() throws java.io.IOException { throw new java.io.IOException("文档已失效"); }
        });
        Intent launch = VideoEditorActivity.intentForVideo(org.robolectric.RuntimeEnvironment.getApplication(),selected);
        try (ActivityController<VideoEditorActivity> lifecycle = Robolectric.buildActivity(VideoEditorActivity.class,launch).setup()) {
            VideoEditorActivity activity = lifecycle.get();
            ((ExecutorService)get(activity,"worker")).submit(() -> {}).get(5,TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            assertEquals("无法读取视频：文档已失效",((TextView)get(activity,"status")).getText().toString());
            assertNull(get(activity,"sourceFile")); assertTrue(((View)get(activity,"choose")).isEnabled());
            assertEquals(View.GONE,((View)get(activity,"editorPanel")).getVisibility());
            assertFalse(((View)get(activity,"export")).isEnabled());
        }
    }
    @Test @Config(shadows = ReadyVideoMetadata.class)
    public void selectedDocumentLaunchImportsThenRevealsEditor() throws Exception {
        Uri selected = Uri.parse("content://videos/selected/42");
        shadowOf(org.robolectric.RuntimeEnvironment.getApplication().getContentResolver()).registerInputStream(selected,
                new java.io.ByteArrayInputStream(new byte[]{1,2,3,4}));
        Intent launch = new Intent(org.robolectric.RuntimeEnvironment.getApplication(), VideoEditorActivity.class)
                .setData(selected).addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        try (ActivityController<VideoEditorActivity> lifecycle = Robolectric.buildActivity(VideoEditorActivity.class, launch).setup()) {
            VideoEditorActivity activity = lifecycle.get();
            ((ExecutorService)get(activity,"worker")).submit(() -> {}).get(5,TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            assertNotNull(get(activity,"sourceFile")); assertEquals(42000L,get(activity,"durationMs"));
            assertEquals(View.VISIBLE,((View)get(activity,"editorPanel")).getVisibility());
            assertEquals(View.GONE,((View)get(activity,"selectionIntro")).getVisibility());
            assertEquals(View.VISIBLE,((View)get(activity,"export")).getVisibility());
            assertTrue(((View)get(activity,"export")).isEnabled());
            assertEquals("剪辑",((TextView)get(activity,"heading")).getText().toString());
        }
    }
    @Test @Config(shadows = ReadyVideoMetadata.class)
    public void cachedHandoffSurvivesOriginalDeletionAndOwnsItsCleanup() throws Exception {
        android.content.Context context = org.robolectric.RuntimeEnvironment.getApplication();
        File original = File.createTempFile("preview-", ".mp4", context.getCacheDir());
        java.nio.file.Files.write(original.toPath(),new byte[]{5,6,7,8});
        Intent launch = VideoEditorActivity.prepareCachedVideo(context,original,"CAMERA_ORIGINAL.MP4",() -> false);
        File staged = new File(new File(context.getCacheDir(),"video-edit-inbox"),launch.getStringExtra("editor_staged_source"));
        assertTrue(original.delete()); assertTrue(staged.exists());
        File editorCopy;
        try (ActivityController<VideoEditorActivity> lifecycle = Robolectric.buildActivity(VideoEditorActivity.class,launch).setup()) {
            VideoEditorActivity activity = lifecycle.get();
            ((ExecutorService)get(activity,"worker")).submit(() -> {}).get(5,TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            editorCopy = (File)get(activity,"sourceFile"); assertNotNull(editorCopy);
            assertArrayEquals(new byte[]{5,6,7,8},java.nio.file.Files.readAllBytes(editorCopy.toPath()));
            assertEquals("CAMERA_ORIGINAL.MP4",get(activity,"sourceDisplayName"));
            assertFalse(staged.exists());
            assertTrue(((View)get(activity,"export")).isEnabled());
            lifecycle.pause().stop().destroy();
            ((ExecutorService)get(activity,"worker")).awaitTermination(5,TimeUnit.SECONDS);
            assertFalse(editorCopy.exists());
        }
    }
    @Test public void cancelledCachedHandoffLeavesOriginalAndNoInboxCopy() throws Exception {
        android.content.Context context = org.robolectric.RuntimeEnvironment.getApplication();
        File original = File.createTempFile("preview-", ".mp4", context.getCacheDir());
        java.nio.file.Files.write(original.toPath(),new byte[]{1,2,3});
        try {
            VideoEditorActivity.prepareCachedVideo(context,original,"original.mp4",() -> true);
            fail("Cancelled copy must not produce a launch");
        } catch (java.io.IOException expected) { assertTrue(original.exists()); }
        finally { original.delete(); }
    }
    @Test @Config(shadows = ReadyVideoMetadata.class)
    public void rotationBeforePickerImportResumesTheExactPendingSelection() throws Exception {
        Uri selected = Uri.parse("content://videos/pending/replacement");
        shadowOf(org.robolectric.RuntimeEnvironment.getApplication().getContentResolver()).registerInputStreamSupplier(selected,
                () -> new java.io.ByteArrayInputStream(new byte[]{9,8,7,6}));
        Bundle saved = new Bundle();
        ActivityController<VideoEditorActivity> before = Robolectric.buildActivity(VideoEditorActivity.class).setup();
        VideoEditorActivity old = before.get(); ExecutorService oldWorker = (ExecutorService)get(old,"worker");
        java.util.concurrent.CountDownLatch entered = new java.util.concurrent.CountDownLatch(1);
        java.util.concurrent.CountDownLatch release = new java.util.concurrent.CountDownLatch(1);
        oldWorker.execute(() -> { entered.countDown(); try { release.await(5,TimeUnit.SECONDS); } catch (InterruptedException error) { Thread.currentThread().interrupt(); } });
        assertTrue(entered.await(5,TimeUnit.SECONDS));
        try {
            old.onActivityResult(410,android.app.Activity.RESULT_OK,new Intent().setData(selected));
            before.saveInstanceState(saved);
            assertEquals(selected.toString(),saved.getString("edit_pending_uri"));
            assertNotNull(saved.getString("edit_session"));
            org.robolectric.util.ReflectionHelpers.setField(old,"mChangingConfigurations",true);
            before.pause().stop().destroy();
        } finally { release.countDown(); }
        assertTrue(oldWorker.awaitTermination(5,TimeUnit.SECONDS));
        shadowOf(Looper.getMainLooper()).idle();
        try (ActivityController<VideoEditorActivity> after = Robolectric.buildActivity(VideoEditorActivity.class).create(saved).start().resume()) {
            VideoEditorActivity restored = after.get(); awaitImport(restored);
            assertArrayEquals(new byte[]{9,8,7,6},java.nio.file.Files.readAllBytes(((File)get(restored,"sourceFile")).toPath()));
            assertTrue(((View)get(restored,"export")).isEnabled());
            assertEquals(saved.getString("edit_session"),((VideoEditSession)get(restored,"session")).id);
        }
    }
    @Test @Config(shadows = ReadyVideoMetadata.class)
    public void rotationAfterCopyBeforeUiCommitKeepsAlbumHandoffForRestoredImport() throws Exception {
        android.content.Context context = org.robolectric.RuntimeEnvironment.getApplication();
        File original = File.createTempFile("preview-", ".mp4", context.getCacheDir());
        java.nio.file.Files.write(original.toPath(),new byte[]{4,3,2,1});
        Intent launch = VideoEditorActivity.prepareCachedVideo(context,original,"PENDING_CAMERA.MP4",() -> false);
        File staged = new File(new File(context.getCacheDir(),"video-edit-inbox"),launch.getStringExtra("editor_staged_source"));
        Bundle saved = new Bundle();
        ReadyVideoMetadata.entered = new java.util.concurrent.CountDownLatch(1);
        ReadyVideoMetadata.gate = new java.util.concurrent.CountDownLatch(1);
        ActivityController<VideoEditorActivity> before = Robolectric.buildActivity(VideoEditorActivity.class,launch).setup();
        VideoEditorActivity old = before.get(); ExecutorService oldWorker = (ExecutorService)get(old,"worker");
        assertTrue(ReadyVideoMetadata.entered.await(5,TimeUnit.SECONDS)); // copy finished, metadata still running
        assertTrue(staged.exists()); assertTrue((boolean)get(old,"loading"));
        before.saveInstanceState(saved);
        org.robolectric.util.ReflectionHelpers.setField(old,"mChangingConfigurations",true);
        before.pause().stop().destroy(); ReadyVideoMetadata.gate.countDown();
        assertTrue(oldWorker.awaitTermination(5,TimeUnit.SECONDS)); ReadyVideoMetadata.gate = null;
        shadowOf(Looper.getMainLooper()).idle(); assertTrue(staged.exists());
        try (ActivityController<VideoEditorActivity> after = Robolectric.buildActivity(VideoEditorActivity.class,launch).create(saved).start().resume()) {
            VideoEditorActivity restored = after.get(); awaitImport(restored);
            assertEquals("PENDING_CAMERA.MP4",get(restored,"sourceDisplayName"));
            assertArrayEquals(new byte[]{4,3,2,1},java.nio.file.Files.readAllBytes(((File)get(restored,"sourceFile")).toPath()));
            assertFalse(staged.exists()); assertTrue(original.exists());
        } finally { original.delete(); }
    }
    @Test @Config(shadows = ReadyVideoMetadata.class)
    public void cancelledLaunchImportIsNotReplayedAfterRecreation() throws Exception {
        android.content.Context context = org.robolectric.RuntimeEnvironment.getApplication();
        Uri selected = Uri.parse("content://videos/cancelled/launch");
        java.util.concurrent.atomic.AtomicInteger opens = new java.util.concurrent.atomic.AtomicInteger();
        shadowOf(context.getContentResolver()).registerInputStreamSupplier(selected,() -> { opens.incrementAndGet(); return new java.io.ByteArrayInputStream(new byte[]{1,2,3}); });
        Intent launch = VideoEditorActivity.intentForVideo(context,selected); Bundle saved = new Bundle();
        ReadyVideoMetadata.entered = new java.util.concurrent.CountDownLatch(1);
        ReadyVideoMetadata.gate = new java.util.concurrent.CountDownLatch(1);
        ActivityController<VideoEditorActivity> before = Robolectric.buildActivity(VideoEditorActivity.class,launch).setup();
        VideoEditorActivity old = before.get(); assertTrue(ReadyVideoMetadata.entered.await(5,TimeUnit.SECONDS));
        java.lang.reflect.Method cancel = VideoEditorActivity.class.getDeclaredMethod("cancelCurrentTask");cancel.setAccessible(true);cancel.invoke(old);
        ReadyVideoMetadata.gate.countDown(); awaitImport(old); ReadyVideoMetadata.gate = null;
        shadowOf(Looper.getMainLooper()).idle();
        assertNull(get(old,"sourceFile")); before.saveInstanceState(saved);
        assertFalse(saved.containsKey("edit_pending_uri"));
        org.robolectric.util.ReflectionHelpers.setField(old,"mChangingConfigurations",true);
        before.pause().stop().destroy(); ((ExecutorService)get(old,"worker")).awaitTermination(5,TimeUnit.SECONDS);
        try (ActivityController<VideoEditorActivity> after = Robolectric.buildActivity(VideoEditorActivity.class,launch).create(saved).start().resume()) {
            VideoEditorActivity restored = after.get(); awaitImport(restored);
            assertNull(get(restored,"sourceFile")); assertFalse((boolean)get(restored,"loading"));
            assertEquals(1,opens.get()); assertTrue(((View)get(restored,"choose")).isEnabled());
        }
    }
    private static void awaitImport(VideoEditorActivity activity) throws Exception {
        ((ExecutorService)get(activity,"worker")).submit(() -> {}).get(5,TimeUnit.SECONDS);
        shadowOf(Looper.getMainLooper()).idle();
    }
    @Implements(MediaMetadataRetriever.class)
    public static class ReadyVideoMetadata {
        static volatile java.util.concurrent.CountDownLatch gate, entered;
        @Implementation public void setDataSource(String path) {
            java.util.concurrent.CountDownLatch wait = gate;
            if (wait != null) {
                entered.countDown();
                try { if (!wait.await(5,TimeUnit.SECONDS)) throw new IllegalStateException("metadata test gate timed out"); }
                catch (InterruptedException error) { Thread.currentThread().interrupt(); throw new IllegalStateException(error); }
            }
        }
        @Implementation public String extractMetadata(int key) {
            if (key == MediaMetadataRetriever.METADATA_KEY_DURATION) return "42000";
            if (key == MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO) return "yes";
            return null;
        }
        @Implementation public Bitmap getScaledFrameAtTime(long time,int option,int width,int height) { return null; }
        @Implementation public void release() { }
        @Implementation public void close() { }
    }
    private static void assertTextFits(TextView view) {
        assertNotNull(view.getLayout()); assertTrue(view.getLayout().getLineCount() > 0);
        int last = view.getLayout().getLineCount() - 1;
        assertTrue(view.getText().toString(), view.getLayout().getLineWidth(last) <= view.getWidth() - view.getCompoundPaddingLeft() - view.getCompoundPaddingRight() + 1);
        assertTrue(view.getText().toString(), view.getLayout().getLineBottom(last) <= view.getHeight() - view.getCompoundPaddingTop() - view.getCompoundPaddingBottom());
    }
    private static TextView findText(View view, String text) {
        if (view instanceof TextView && text.contentEquals(((TextView) view).getText())) return (TextView) view;
        if (view instanceof android.view.ViewGroup) for (int i = 0; i < ((android.view.ViewGroup) view).getChildCount(); i++) {
            TextView result = findText(((android.view.ViewGroup) view).getChildAt(i), text); if (result != null) return result;
        }
        return null;
    }
    private static Object get(Object o,String key)throws Exception{Field f=o.getClass().getDeclaredField(key);f.setAccessible(true);return f.get(o);}
    private static void set(Object o,String key,Object value)throws Exception{Field f=o.getClass().getDeclaredField(key);f.setAccessible(true);f.set(o,value);}
}
