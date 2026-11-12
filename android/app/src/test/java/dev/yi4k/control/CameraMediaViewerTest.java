package dev.yi4k.control;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.media.MediaMetadataRetriever;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.SeekBar;
import android.widget.VideoView;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.file.Files;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.GraphicsMode;
import org.robolectric.annotation.LooperMode;
import org.robolectric.shadows.ShadowMediaMetadataRetriever;
import org.robolectric.shadows.util.DataSource;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public class CameraMediaViewerTest {
    @Test public void refusesUnboundCameraRouteAndOffersChineseRetryWithoutDownloading() throws Exception {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "192.168.42.1", 80, photo());
            Dialog dialog = (Dialog) field(viewer, "dialog");
            assertTrue(dialog.isShowing());
            assertNotNull(find(dialog.getWindow().getDecorView(), "相机 Wi-Fi 已断开，请返回重新连接相机后再预览"));
            assertNotNull(find(dialog.getWindow().getDecorView(), "重试读取"));
            assertNull(field(viewer, "transfer"));
            viewer.close();
            assertFalse(dialog.isShowing());
            viewer.close();
        }
    }

    @Test public void ownerDestructionClosesViewerAndRejectsLateUiCallbacks() throws Exception {
        ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup();
        CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "192.168.42.1", 80, photo());
        Dialog dialog = (Dialog) field(viewer, "dialog");
        lifecycle.pause().stop().destroy();
        shadowOf(Looper.getMainLooper()).idle();
        assertTrue((boolean) field(viewer, "closed"));
        assertFalse(dialog.isShowing());
    }

    @Test public void videoEditActionStagesIndependentCopyBeforeClosingPreview() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(),null,"127.0.0.1",server.httpPort(),clip(server));
            awaitDownload(viewer);
            File preview = (File)field(viewer,"cached");
            View edit = (View)field(viewer,"edit"); assertTrue(edit.isEnabled());
            edit.performClick(); awaitDownload(viewer);
            android.content.Intent launch = shadowOf(lifecycle.get()).getNextStartedActivity();
            assertNotNull(launch); assertEquals(VideoEditorActivity.class.getName(),launch.getComponent().getClassName());
            assertEquals("SIMULATED_VIDEO.MP4",launch.getStringExtra("editor_source_name"));
            File staged = new File(new File(lifecycle.get().getCacheDir(),"video-edit-inbox"),launch.getStringExtra("editor_staged_source"));
            assertTrue(staged.isFile()); assertArrayEquals(server.image,Files.readAllBytes(staged.toPath()));
            assertFalse(preview.exists()); assertTrue((boolean)field(viewer,"closed"));
            VideoEditorActivity.discardPreparedVideo(lifecycle.get(),launch); assertFalse(staged.exists());
        }
    }

    @Test public void routeFallbackIsRestrictedToLiteralLoopback() {
        assertFalse(CameraMediaViewer.hasBoundRoute(false, "192.168.42.1"));
        assertFalse(CameraMediaViewer.hasBoundRoute(false, "localhost"));
        assertFalse(CameraMediaViewer.hasBoundRoute(false, "127.0.0.1.example.com"));
        assertFalse(CameraMediaViewer.hasBoundRoute(false, null));
        assertTrue(CameraMediaViewer.hasBoundRoute(false, "127.0.0.1"));
        assertTrue(CameraMediaViewer.hasBoundRoute(false, "::1"));
        assertTrue(CameraMediaViewer.hasBoundRoute(true, "192.168.42.1"));
    }

    @Test public void displaysOriginalPhotoAndDestroysOnlyItsPrivateCacheWithOwner() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            MediaEntry entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", server.imageName, server.image.length + " bytes|date");
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "127.0.0.1", server.httpPort(), entry);
            ((ExecutorService) field(viewer, "worker")).submit(() -> {}).get(5, TimeUnit.SECONDS);
            shadowOf(Looper.getMainLooper()).idle();
            Dialog dialog = (Dialog) field(viewer, "dialog");
            assertNotNull(find(dialog.getWindow().getDecorView(), "原片已读取 · 照片适配屏幕显示"));
            File cached = (File) field(viewer, "cached");
            assertNotNull(cached);
            assertTrue(cached.getCanonicalPath().startsWith(lifecycle.get().getCacheDir().getCanonicalPath() + File.separator));
            assertArrayEquals(server.image, Files.readAllBytes(cached.toPath()));
            assertNotNull(field(viewer, "image"));
            assertNull(field(viewer, "video"));
            assertEquals(View.GONE, ((View)field(viewer,"edit")).getVisibility());
            assertEquals("64 × 64", ((TextView) field(viewer, "resolutionValue")).getText().toString());
            assertEquals(View.GONE, ((View) field(viewer, "timeline")).getVisibility());
            lifecycle.pause().stop().destroy();
            shadowOf(Looper.getMainLooper()).idle();
            assertFalse(cached.exists());
            assertNull(field(viewer, "bitmap"));
            assertFalse(dialog.isShowing());
        }
    }

    @Test public void videoWaitsForTapThenSupportsPauseSeekReplayAndBackgroundPause() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "127.0.0.1", server.httpPort(), clip(server));
            awaitDownload(viewer);
            VideoView video = (VideoView) field(viewer, "video");
            assertNotNull(video);
            assertFalse(video.isPlaying());
            File cached = (File) field(viewer, "cached");
            assertEquals(cached.getAbsolutePath(), shadowOf(video).getVideoPath());
            assertFalse(shadowOf(video).getVideoPath().startsWith("http"));
            assertEquals("文件未提供", ((TextView) field(viewer, "resolutionValue")).getText().toString());
            shadowOf(video).setDuration(42000);
            shadowOf(video).getOnPreparedListener().onPrepared(null);
            View play = (View) field(viewer, "play");
            SeekBar seek = (SeekBar) field(viewer, "seek");
            assertTrue(play.isEnabled()); assertTrue(seek.isEnabled());
            assertFalse("Preparing must not autoplay", video.isPlaying());
            assertEquals("播放原片", play.getContentDescription());
            assertEquals("00:42", ((TextView) field(viewer, "total")).getText().toString());
            assertEquals(View.VISIBLE, ((View) field(viewer, "timeline")).getVisibility());
            assertTrue(play.performClick()); assertTrue(video.isPlaying());
            assertEquals("暂停原片", play.getContentDescription());
            assertTrue(play.performClick()); assertFalse(video.isPlaying());
            assertEquals("播放原片", play.getContentDescription());
            SeekBar.OnSeekBarChangeListener scrub = shadowOf(seek).getOnSeekBarChangeListener();
            scrub.onStartTrackingTouch(seek); seek.setProgress(500); scrub.onProgressChanged(seek, 500, true); scrub.onStopTrackingTouch(seek);
            assertEquals(21000, video.getCurrentPosition());
            assertEquals("00:21", ((TextView) field(viewer, "elapsed")).getText().toString());
            assertFalse("Scrubbing a paused video must keep it paused", video.isPlaying());
            play.performClick(); assertTrue(video.isPlaying());
            scrub.onStartTrackingTouch(seek); seek.setProgress(750); scrub.onStopTrackingTouch(seek);
            assertTrue("Scrubbing a playing video resumes playback", video.isPlaying());
            assertEquals(31500, video.getCurrentPosition());
            video.pause(); shadowOf(video).getOnCompletionListener().onCompletion(null);
            assertEquals("00:42", ((TextView) field(viewer, "elapsed")).getText().toString());
            play.performClick(); assertTrue(video.isPlaying()); assertEquals(0, video.getCurrentPosition());
            lifecycle.pause(); assertFalse(video.isPlaying());
            assertEquals("播放原片", play.getContentDescription());
            android.media.MediaPlayer.OnPreparedListener latePrepared = shadowOf(video).getOnPreparedListener();
            viewer.close(); assertFalse(cached.exists());
            latePrepared.onPrepared(null);
            assertNull(field(viewer, "video"));
        }
    }

    @Test public void favoritePersistsAcrossViewerAndActivityRecreationAndCanBeRemoved() throws Exception {
        MediaEntry entry = photo();
        try (ActivityController<Activity> first = Robolectric.buildActivity(Activity.class).setup()) {
            CameraMediaViewer viewer = CameraMediaViewer.show(first.get(), null, "192.168.42.1", 80, entry);
            assertFalse(CameraMediaViewer.isFavorite(first.get(), "192.168.42.1", 80, entry));
            ((View) field(viewer, "favorite")).performClick();
            assertTrue(CameraMediaViewer.isFavorite(first.get(), "192.168.42.1", 80, entry));
            viewer.close();
        }
        try (ActivityController<Activity> second = Robolectric.buildActivity(Activity.class).setup()) {
            CameraMediaViewer viewer = CameraMediaViewer.show(second.get(), null, "192.168.42.1", 80, entry);
            TextView favorite = (TextView) field(viewer, "favorite");
            assertEquals("♥  已收藏", favorite.getText().toString());
            assertEquals(AppPalette.ACCENT, favorite.getCurrentTextColor());assertTrue(favorite.isSelected());
            assertFalse(CameraMediaViewer.isFavorite(second.get(), "192.168.42.2", 80, entry));
            favorite.performClick(); assertEquals("♡  收藏", favorite.getText().toString());
            assertEquals(AppPalette.MUTED, favorite.getCurrentTextColor());assertFalse(favorite.isSelected());
            assertFalse(CameraMediaViewer.isFavorite(second.get(), "192.168.42.1", 80, entry));
            viewer.close();
        }
    }

    @Test public void userReturnNotifiesOwnerOnceAfterMediaAndWindowCleanup() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            MediaEntry entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", server.imageName, server.image.length + " bytes|date");
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "127.0.0.1", server.httpPort(), entry);
            awaitDownload(viewer);
            File cached = (File) field(viewer, "cached");
            Dialog dialog = (Dialog) field(viewer, "dialog");
            AtomicInteger notifications = new AtomicInteger();
            viewer.setOnCloseListener(() -> {
                assertEquals(Looper.getMainLooper(), Looper.myLooper());
                assertFalse("Owner refresh must happen after the window closes", dialog.isShowing());
                assertFalse("Owner refresh must happen after private media is removed", cached.exists());
                notifications.incrementAndGet();
            });
            ((View) field(viewer, "favorite")).performClick();
            assertTrue(CameraMediaViewer.isFavorite(lifecycle.get(), "127.0.0.1", server.httpPort(), entry));
            View back = findDescription(dialog.getWindow().getDecorView(), "返回相册");
            assertNotNull(back); assertTrue(back.performClick());
            assertEquals(1, notifications.get());
            viewer.close(); lifecycle.pause().stop().destroy();
            assertEquals(1, notifications.get());
        }
    }

    @Test public void readsClipMetadataAndThumbnailFromLocalFileAndHandlesUnknownFields() throws Exception {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            File file = File.createTempFile("metadata-", ".mp4", lifecycle.get().getCacheDir());
            Bitmap frame = Bitmap.createBitmap(160, 90, Bitmap.Config.ARGB_8888);
            try {
                ShadowMediaMetadataRetriever.addMetadata(file.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH, "1920");
                ShadowMediaMetadataRetriever.addMetadata(file.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT, "1080");
                ShadowMediaMetadataRetriever.addMetadata(file.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION, "90");
                ShadowMediaMetadataRetriever.addMetadata(file.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_DURATION, "42000");
                ShadowMediaMetadataRetriever.addScaledFrame(DataSource.toDataSource(file.getAbsolutePath()), 0, 640, 360, frame);
                CameraMediaViewer.MediaInfo info = metadata(file);
                assertEquals(1080, info.width); assertEquals(1920, info.height); assertEquals(42000, info.durationMs);
                assertSame(frame, info.cover);
                ShadowMediaMetadataRetriever.reset();
                CameraMediaViewer.MediaInfo unknown = metadata(file);
                assertEquals(0, unknown.width); assertEquals(0, unknown.height); assertEquals(-1, unknown.durationMs); assertNull(unknown.cover);
            } finally { frame.recycle(); file.delete(); }
        }
    }

    /** Host render with a loopback original and explicit decoder fixtures, not a phone screenshot. */
    @Test @Config(sdk = 35, qualifiers = "w412dp-h915dp-mdpi") @GraphicsMode(GraphicsMode.Mode.NATIVE)
    public void rendersPlaybackCoverWithPersistentTimelineAndRealFileDetails() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "127.0.0.1", server.httpPort(), clip(server));
            awaitDownload(viewer);
            File cached = (File) field(viewer, "cached");
            Bitmap frame = BitmapFactory.decodeByteArray(server.image, 0, server.image.length);
            assertNotNull(frame);
            // The loopback fixture transports JPEG bytes; the host decoder fixture supplies video metadata.
            ShadowMediaMetadataRetriever.addMetadata(cached.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH, "1920");
            ShadowMediaMetadataRetriever.addMetadata(cached.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT, "1080");
            ShadowMediaMetadataRetriever.addMetadata(cached.getAbsolutePath(), MediaMetadataRetriever.METADATA_KEY_DURATION, "42000");
            ShadowMediaMetadataRetriever.addScaledFrame(DataSource.toDataSource(cached.getAbsolutePath()), 0, 640, 360, frame);
            CameraMediaViewer.MediaInfo info = metadata(cached);
            Method information = CameraMediaViewer.class.getDeclaredMethod("showInformation", File.class, CameraMediaViewer.MediaInfo.class);
            information.setAccessible(true); information.invoke(viewer, cached, info);
            Field bitmap = viewer.getClass().getDeclaredField("bitmap"); bitmap.setAccessible(true); bitmap.set(viewer, info.cover);
            Method addImage = viewer.getClass().getDeclaredMethod("addImage", Bitmap.class); addImage.setAccessible(true); addImage.invoke(viewer, info.cover);
            View play = (View) field(viewer, "play"); play.bringToFront();
            VideoView video = (VideoView) field(viewer, "video"); shadowOf(video).setDuration(42000);
            shadowOf(video).getOnPreparedListener().onPrepared(null);
            assertFalse(video.isPlaying());
            Dialog dialog = (Dialog) field(viewer, "dialog");
            View root = dialog.findViewById(android.R.id.content);
            root.measure(View.MeasureSpec.makeMeasureSpec(412, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(867, View.MeasureSpec.EXACTLY));
            root.layout(0, 0, 412, 867);
            View media = (View) field(viewer, "media");
            assertEquals(16.0 / 9.0, media.getMeasuredWidth() / (double) media.getMeasuredHeight(), .02);
            Bitmap rendered = Bitmap.createBitmap(412, 867, Bitmap.Config.ARGB_8888); root.draw(new Canvas(rendered));
            File directory = new File("build/reports/prototype-renders"); assertTrue(directory.isDirectory() || directory.mkdirs());
            try (FileOutputStream output = new FileOutputStream(new File(directory, "playback-cover.png"))) {
                assertTrue(rendered.compress(Bitmap.CompressFormat.PNG, 100, output));
            } finally { rendered.recycle(); }
            assertTrue(play.isShown());
            assertNotNull(find(root, "1920 × 1080"));
            viewer.close(); assertTrue(frame.isRecycled()); assertFalse(cached.exists());
        }
    }

    @Test @Config(sdk = 35, qualifiers = "w320dp-h720dp-mdpi") @GraphicsMode(GraphicsMode.Mode.NATIVE)
    public void narrowPlaybackKeepsTimelineAndFileInformationReadableAtLargeFont() throws Exception {
        org.robolectric.RuntimeEnvironment.setFontScale(1.6f);
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            MediaEntry entry = new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "LONG_CAMERA_ORIGINAL_20261111.MP4", "10 bytes|date");
            CameraMediaViewer viewer = CameraMediaViewer.show(lifecycle.get(), null, "192.168.42.1", 80, entry);
            Dialog dialog = (Dialog) field(viewer, "dialog"); View root = dialog.findViewById(android.R.id.content);
            root.measure(View.MeasureSpec.makeMeasureSpec(320, View.MeasureSpec.EXACTLY), View.MeasureSpec.makeMeasureSpec(720, View.MeasureSpec.EXACTLY));
            root.layout(0, 0, 320, 720);
            TextView elapsed = (TextView) field(viewer, "elapsed"), total = (TextView) field(viewer, "total");
            assertEquals(elapsed.getBaseline(), total.getBaseline());
            assertTrue(((View) field(viewer, "seek")).getWidth() >= 48);
            for (String name : new String[]{"elapsed", "total", "status", "action", "favorite", "sizeValue", "resolutionValue", "durationValue"})
                assertTextFits((TextView) field(viewer, name));
            TextView fileName = (TextView) find(root, entry.name); assertNotNull(fileName); assertTextFits(fileName);
            TextView label = (TextView) find(root, "文件名");
            assertEquals(label.getLeft(), fileName.getLeft()); assertEquals(8, fileName.getTop() - label.getBottom());
            TextView title = (TextView) find(root, "回放"); View toolbar = (View) title.getParent();
            assertEquals(toolbar.getWidth(), title.getLeft() + title.getRight());
            Bitmap rendered = Bitmap.createBitmap(320, 720, Bitmap.Config.ARGB_8888); root.draw(new Canvas(rendered));
            assertTimelineInk(root, elapsed, rendered); assertTimelineInk(root, total, rendered);
            File directory = new File("build/reports/prototype-renders"); assertTrue(directory.isDirectory() || directory.mkdirs());
            try (FileOutputStream output = new FileOutputStream(new File(directory, "playback-narrow-large-font.png"))) {
                assertTrue(rendered.compress(Bitmap.CompressFormat.PNG, 100, output));
            } finally { rendered.recycle(); viewer.close(); }
        } finally { org.robolectric.RuntimeEnvironment.setFontScale(1f); }
    }
    private static void assertTimelineInk(View root, TextView time, Bitmap rendered) {
        int[] origin = new int[2], position = new int[2]; root.getLocationOnScreen(origin); time.getLocationOnScreen(position);
        int ink = 0;
        for (int y = position[1] - origin[1]; y < position[1] - origin[1] + time.getHeight(); y++)
            for (int x = position[0] - origin[0]; x < position[0] - origin[0] + time.getWidth(); x++)
                if (android.graphics.Color.red(rendered.getPixel(x, y)) < 100) ink++;
        assertTrue("Time must paint readable text in its actual window: " + time.getText(), ink > 8);
    }
    private static void assertTextFits(TextView view) {
        assertNotNull(view.getLayout()); assertTrue(view.getLayout().getLineCount() > 0);
        int last = view.getLayout().getLineCount() - 1;
        assertTrue(view.getText().toString(), view.getLayout().getLineWidth(last) <= view.getWidth() - view.getCompoundPaddingLeft() - view.getCompoundPaddingRight() + 1);
        assertTrue(view.getText().toString(), view.getLayout().getLineBottom(last) <= view.getHeight() - view.getCompoundPaddingTop() - view.getCompoundPaddingBottom());
    }
    private static CameraMediaViewer.MediaInfo metadata(File file) throws Exception {
        Method method = CameraMediaViewer.class.getDeclaredMethod("readVideoInfo", File.class); method.setAccessible(true);
        return (CameraMediaViewer.MediaInfo) method.invoke(null, file);
    }
    private static MediaEntry clip(SimulatedCamera server) {
        return new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "SIMULATED_VIDEO.MP4", server.image.length + " bytes|date");
    }
    private static void awaitDownload(CameraMediaViewer viewer) throws Exception {
        ((ExecutorService) field(viewer, "worker")).submit(() -> {}).get(5, TimeUnit.SECONDS);
        shadowOf(Looper.getMainLooper()).idle();
    }

    private static MediaEntry photo() { return new MediaEntry(MediaEntry.DCIM_ROOT + "100MEDIA/", "ONE.JPG", "10 bytes|2026"); }
    private static Object field(Object target, String name) throws Exception {
        Field field = target.getClass().getDeclaredField(name); field.setAccessible(true); return field.get(target);
    }
    private static View find(View view, String title) {
        if (view instanceof TextView && title.contentEquals(((TextView) view).getText())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
            View result = find(((ViewGroup) view).getChildAt(i), title); if (result != null) return result;
        }
        return null;
    }
    private static View findDescription(View view, String description) {
        if (description.contentEquals(view.getContentDescription() == null ? "" : view.getContentDescription())) return view;
        if (view instanceof ViewGroup) for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
            View result = findDescription(((ViewGroup) view).getChildAt(i), description); if (result != null) return result;
        }
        return null;
    }
}
