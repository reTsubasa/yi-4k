package dev.yi4k.control;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.RippleDrawable;
import android.content.res.ColorStateList;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.PathInterpolator;
import android.widget.ImageView;

/** Real-photo capture feedback. All methods are called on the main thread.
 *
 * The caller discovers a NEW camera photo and obtains its decoded thumbnail.
 * This class never invents a preview, contacts a camera or owns input bitmaps.
 * It copies input before displaying it, so the thumbnail callback may recycle
 * its bitmap immediately after setThumbnail/play returns. The animation lives
 * in the decor overlay and never inserts/removes measured layout children.
 */
final class CaptureAlbumFeedback implements AutoCloseable {
    private static final int INK = AppPalette.INK, SURFACE = AppPalette.BACKGROUND;
    private final Activity activity;
    private ImageView button, flying;
    private ViewGroup overlayHost;
    private ValueAnimator animator;
    private Bitmap thumbnail, incoming;
    private boolean closed;
    private boolean optimisticFlight;

    CaptureAlbumFeedback(Activity activity) { this.activity = activity; }

    /** Add this view to a 48dp or larger slot to the left of the shutter. */
    ImageView createButton(Runnable openAlbum) {
        mainThread();
        if (closed) throw new IllegalStateException("相册反馈已关闭");
        if (button != null) throw new IllegalStateException("相册入口已创建");
        button = new ImageView(activity);
        button.setContentDescription("相册");
        button.setScaleType(ImageView.ScaleType.CENTER_CROP);
        button.setImageDrawable(new AlbumTile(null));
        button.setBackground(new RippleDrawable(ColorStateList.valueOf(0x1ac4622d), null,
                new AlbumTile(null)));
        button.setPadding(dp(3), dp(3), dp(3), dp(3));
        button.setFocusable(true); button.setClickable(true);
        button.setOnClickListener(v -> openAlbum.run());
        return button;
    }

    /** Show an existing real cover without suggesting that a new shot occurred. */
    void setThumbnail(Bitmap photo) {
        mainThread();
        if (closed || !usable(photo)) return;
        Bitmap next = copy(photo);
        cancel();
        optimisticFlight = false;
        replaceThumbnail(next);
    }

    /**
     * Give the user an immediate camera-like response while the real JPEG is
     * still being indexed and downloaded. The frame is a local snapshot only;
     * the caller replaces it with the decoded camera photo through setThumbnail.
     */
    boolean playPreview(View preview) {
        mainThread();
        if (closed || preview == null || preview.getWidth() <= 0 || preview.getHeight() <= 0) return false;
        int width = Math.min(384, preview.getWidth());
        int height = Math.max(1, Math.round(preview.getHeight() * (width / (float) preview.getWidth())));
        Bitmap snapshot = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(snapshot);
        float sx = width / (float) preview.getWidth(), sy = height / (float) preview.getHeight();
        canvas.scale(sx, sy);
        preview.draw(canvas);
        boolean started = play(snapshot, preview);
        snapshot.recycle();
        optimisticFlight = started;
        return started;
    }

    /**
     * Reserve the immediate flight slot before an asynchronous window snapshot
     * is requested.  The real camera thumbnail callback can therefore consume
     * the reservation without starting a second, delayed animation.
     */
    boolean reserveOptimisticFlight() {
        mainThread();
        if (closed) return false;
        optimisticFlight = true;
        return true;
    }

    /** Whether a reserved local flight still awaits its frame or real photo. */
    boolean hasOptimisticFlight() {
        mainThread();
        return !closed && optimisticFlight;
    }

    /** Consume the local preview flight so the real photo updates the cover
     * without making the user watch a second, delayed animation. */
    boolean consumeOptimisticFlight() {
        mainThread();
        boolean result = optimisticFlight;
        optimisticFlight = false;
        return result;
    }

    /**
     * Animate only after camera capture confirmation AND discovery of the new
     * photo. Returns false if the page is not visible; a valid photo still
     * becomes the cover. Null/recycled images leave the previous cover intact.
     */
    boolean play(Bitmap photo, View preview) {
        mainThread();
        if (closed || !usable(photo)) return false;
        Bitmap next = copy(photo);
        // A PixelCopy frame may be starting the flight that was reserved by
        // the shutter tap.  Keep that reservation until the real camera
        // thumbnail arrives; otherwise the thumbnail worker would animate a
        // second time after this immediate frame.
        boolean preserveOptimisticFlight = optimisticFlight;
        cancel();
        optimisticFlight = preserveOptimisticFlight;
        View decor = activity.getWindow().getDecorView();
        Rect source = new Rect(), destination = new Rect();
        if (button == null || preview == null || !(decor instanceof ViewGroup)
                || !button.isAttachedToWindow() || !preview.isAttachedToWindow()
                || !button.getGlobalVisibleRect(destination) || !preview.getGlobalVisibleRect(source)
                || destination.isEmpty() || source.isEmpty()) {
            replaceThumbnail(next); return false;
        }
        overlayHost = (ViewGroup) decor;
        incoming = next;
        int[] origin = new int[2]; overlayHost.getLocationOnScreen(origin);
        float width = Math.min(dp(144), source.width() * .60f);
        float height = Math.min(source.height() * .60f, width * .70f);
        width = Math.max(destination.width(), width);
        height = Math.max(destination.height(), height);
        final float startX = source.exactCenterX() - origin[0] - width / 2;
        final float startY = source.exactCenterY() - origin[1] - height / 2;
        final float endX = destination.left - origin[0], endY = destination.top - origin[1];
        final float startWidth = width, startHeight = height;
        flying = new ImageView(activity);
        flying.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
        flying.setImageDrawable(new AlbumTile(incoming));
        flying.setPivotX(0); flying.setPivotY(0); flying.setElevation(dp(3));
        flying.layout(0, 0, Math.round(width), Math.round(height));
        flying.setTranslationX(startX); flying.setTranslationY(startY);
        overlayHost.getOverlay().add(flying);
        animator = ValueAnimator.ofFloat(0f, 1f);
        animator.setDuration(560);
        animator.setInterpolator(new PathInterpolator(.22f, .0f, .2f, 1f));
        animator.addUpdateListener(value -> {
            if (flying == null) return;
            float t = (Float) value.getAnimatedValue(), one = 1f - t;
            float controlX = startX + (endX - startX) * .25f;
            float controlY = Math.min(startY, endY) - dp(32);
            flying.setTranslationX(one * one * startX + 2 * one * t * controlX + t * t * endX);
            flying.setTranslationY(one * one * startY + 2 * one * t * controlY + t * t * endY);
            flying.setScaleX(1f + (destination.width() / startWidth - 1f) * t);
            flying.setScaleY(1f + (destination.height() / startHeight - 1f) * t);
            flying.setRotation(-5f * (float) Math.sin(t * Math.PI));
        });
        animator.addListener(new AnimatorListenerAdapter() {
            @Override public void onAnimationEnd(Animator animation) {
                removeFlying();
                Bitmap delivered = incoming; incoming = null; animator = null;
                if (delivered != null) replaceThumbnail(delivered);
            }
        });
        animator.start();
        return true;
    }

    /** Navigation/background cleanup; retain the current cover, remove flight. */
    void cancel() {
        mainThread();
        if (animator != null) {
            animator.removeAllUpdateListeners(); animator.removeAllListeners(); animator.cancel(); animator = null;
        }
        removeFlying();
        if (incoming != null) { incoming.recycle(); incoming = null; }
        optimisticFlight = false;
    }

    /** Detach drawables before recycling their private bitmap copies. */
    @Override public void close() {
        mainThread();
        if (closed) return;
        cancel(); closed = true;
        if (button != null) { button.setImageDrawable(null); button.setOnClickListener(null); button = null; }
        if (thumbnail != null) { thumbnail.recycle(); thumbnail = null; }
    }

    private void replaceThumbnail(Bitmap next) {
        Bitmap old = thumbnail; thumbnail = next;
        if (button != null) button.setImageDrawable(new AlbumTile(next));
        if (old != null && old != next) old.recycle();
    }
    private void removeFlying() {
        if (flying != null) {
            if (overlayHost != null) overlayHost.getOverlay().remove(flying);
            flying.setImageDrawable(null); flying = null;
        }
        overlayHost = null;
    }
    private static boolean usable(Bitmap image) {
        return image != null && !image.isRecycled() && image.getWidth() > 0 && image.getHeight() > 0;
    }
    private static Bitmap copy(Bitmap source) {
        float scale = Math.min(1f, 384f / Math.max(source.getWidth(), source.getHeight()));
        Bitmap result = Bitmap.createBitmap(Math.max(1, Math.round(source.getWidth() * scale)),
                Math.max(1, Math.round(source.getHeight() * scale)), Bitmap.Config.ARGB_8888);
        new Canvas(result).drawBitmap(source, null, new Rect(0, 0, result.getWidth(), result.getHeight()),
                new Paint(Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG));
        return result;
    }
    private int dp(float value) { return Math.round(activity.getResources().getDisplayMetrics().density * value); }
    private static void mainThread() {
        if (Looper.myLooper() != Looper.getMainLooper()) throw new IllegalStateException("相册动画需要主线程");
    }

    /** Center-cropped real photo with a quiet border, or an honest album glyph. */
    private static final class AlbumTile extends Drawable {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG);
        private final Path clip = new Path();
        private final Bitmap image;
        AlbumTile(Bitmap image) { this.image = image; }
        @Override public void draw(Canvas canvas) {
            Rect bounds = getBounds();
            if (bounds.isEmpty()) return;
            RectF outer = new RectF(bounds.left + 1, bounds.top + 1, bounds.right - 1, bounds.bottom - 1);
            float radius = Math.min(outer.width(), outer.height()) * .22f;
            paint.setStyle(Paint.Style.FILL); paint.setColor(SURFACE);
            canvas.drawRoundRect(outer, radius, radius, paint);
            if (usable(image)) {
                int save = canvas.save(); clip.reset(); clip.addRoundRect(outer, radius, radius, Path.Direction.CW);
                canvas.clipPath(clip);
                float scale = Math.max(outer.width() / image.getWidth(), outer.height() / image.getHeight());
                float width = image.getWidth() * scale, height = image.getHeight() * scale;
                canvas.drawBitmap(image, null, new RectF(outer.centerX() - width / 2, outer.centerY() - height / 2,
                        outer.centerX() + width / 2, outer.centerY() + height / 2), paint);
                canvas.restoreToCount(save);
            } else {
                float unit = Math.min(outer.width(), outer.height()) / 24f;
                canvas.save(); canvas.translate(outer.centerX() - 12 * unit, outer.centerY() - 12 * unit);
                canvas.scale(unit, unit); paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1.5f); paint.setColor(INK);
                canvas.drawRoundRect(4, 4, 20, 20, 3, 3, paint);
                canvas.drawCircle(9, 9, 1.25f, paint);
                canvas.drawLine(5, 17, 11, 11, paint); canvas.drawLine(11, 11, 16, 16, paint);
                canvas.drawLine(16, 16, 19, 13, paint); canvas.restore();
            }
            paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1); paint.setColor(Color.argb(78, 57, 49, 43));
            canvas.drawRoundRect(outer, radius, radius, paint); paint.setStyle(Paint.Style.FILL);
        }
        @Override public void setAlpha(int alpha) { paint.setAlpha(alpha); }
        @Override public void setColorFilter(ColorFilter filter) { paint.setColorFilter(filter); }
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }
}
