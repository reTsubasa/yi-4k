package dev.yi4k.control;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ColorDrawable;
import android.widget.ImageView;
import android.widget.FrameLayout;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.GraphicsMode;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = 35)
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@LooperMode(LooperMode.Mode.PAUSED)
public final class CaptureAlbumFeedbackTest {
    @Test public void realCoverSurvivesSourceReuseAndRecycle() {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            CaptureAlbumFeedback feedback = new CaptureAlbumFeedback(lifecycle.get());
            ImageView button = feedback.createButton(() -> {});
            Bitmap source = Bitmap.createBitmap(24, 18, Bitmap.Config.ARGB_8888);
            source.eraseColor(Color.RED); feedback.setThumbnail(source);
            source.eraseColor(Color.BLUE); source.recycle();
            assertEquals("A source thumbnail can be reused or recycled by its owner", Color.RED, center(button));
            feedback.close();
            assertNull("Destroy detaches the image before recycling its copy", button.getDrawable());
        }
    }

    @Test public void hiddenPageUpdatesRealCoverWithoutInventingFlightOrChangingButtonLayout() {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            CaptureAlbumFeedback feedback = new CaptureAlbumFeedback(lifecycle.get());
            int[] opens = {0};
            ImageView button = feedback.createButton(() -> opens[0]++);
            Bitmap real = Bitmap.createBitmap(24, 18, Bitmap.Config.ARGB_8888); real.eraseColor(Color.GREEN);
            assertFalse("No animation on an unattached page", feedback.play(real, null));
            assertEquals(Color.GREEN, center(button));
            assertFalse("No generated image for decode failures", feedback.play(null, null));
            assertEquals("Failure keeps the previous real cover", Color.GREEN, center(button));
            feedback.cancel();
            assertEquals(Color.GREEN, center(button));
            assertTrue(button.performClick()); assertEquals(1, opens[0]);
            feedback.close();
            assertFalse("The helper never takes ownership of callback bitmaps", real.isRecycled());
            real.recycle();
        }
    }

    @Test public void optimisticPreviewFlightCanBeConsumedByLaterRealThumbnail() {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            FrameLayout root = new FrameLayout(lifecycle.get());
            lifecycle.get().setContentView(root);
            CaptureAlbumFeedback feedback = new CaptureAlbumFeedback(lifecycle.get());
            ImageView button = feedback.createButton(() -> {});
            root.addView(button, new FrameLayout.LayoutParams(64, 64));
            ImageView preview = new ImageView(lifecycle.get()); preview.setImageDrawable(new ColorDrawable(Color.BLUE));
            root.addView(preview, new FrameLayout.LayoutParams(320, 180));
            root.measure(ViewMeasure.spec(400), ViewMeasure.spec(240));
            root.layout(0, 0, 400, 240);
            assertTrue("The local preview must animate before network confirmation", feedback.playPreview(preview));
            assertTrue(feedback.consumeOptimisticFlight());
            assertFalse(feedback.consumeOptimisticFlight());
            Bitmap real = Bitmap.createBitmap(24, 18, Bitmap.Config.ARGB_8888); real.eraseColor(Color.GREEN);
            feedback.setThumbnail(real);
            feedback.close();
        }
    }

    @Test public void realtimeFrameKeepsReservationUntilCameraThumbnailArrives() {
        try (ActivityController<Activity> lifecycle = Robolectric.buildActivity(Activity.class).setup()) {
            FrameLayout root = new FrameLayout(lifecycle.get());
            lifecycle.get().setContentView(root);
            CaptureAlbumFeedback feedback = new CaptureAlbumFeedback(lifecycle.get());
            ImageView button = feedback.createButton(() -> {});
            root.addView(button, new FrameLayout.LayoutParams(64, 64));
            ImageView preview = new ImageView(lifecycle.get());
            preview.setImageDrawable(new ColorDrawable(Color.MAGENTA));
            root.addView(preview, new FrameLayout.LayoutParams(320, 180));
            root.measure(ViewMeasure.spec(400), ViewMeasure.spec(240));
            root.layout(0, 0, 400, 240);

            assertTrue(feedback.reserveOptimisticFlight());
            Bitmap frame = Bitmap.createBitmap(32, 18, Bitmap.Config.ARGB_8888);
            frame.eraseColor(Color.MAGENTA);
            assertTrue(feedback.play(frame, preview));
            assertTrue("The real camera thumbnail must consume the same flight", feedback.hasOptimisticFlight());
            assertTrue(feedback.consumeOptimisticFlight());
            assertFalse(feedback.consumeOptimisticFlight());
            frame.recycle();
            feedback.close();
        }
    }

    /** Keep MeasureSpec calls readable without pulling Android internals into the test body. */
    private static final class ViewMeasure {
        static int spec(int size) { return android.view.View.MeasureSpec.makeMeasureSpec(size, android.view.View.MeasureSpec.EXACTLY); }
    }

    private static int center(ImageView button) {
        Bitmap output = Bitmap.createBitmap(60, 60, Bitmap.Config.ARGB_8888);
        Drawable drawable = button.getDrawable(); drawable.setBounds(0, 0, 60, 60);
        drawable.draw(new Canvas(output));
        int pixel = output.getPixel(30, 30); output.recycle(); return pixel;
    }
}
