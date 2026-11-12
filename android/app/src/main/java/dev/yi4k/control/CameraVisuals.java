package dev.yi4k.control;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.drawable.Drawable;

final class CameraVisuals {
    static int batteryColor(int percent) {
        return percent < 0 ? Color.rgb(142,142,147) : percent <= 20 ? Color.rgb(235,64,54)
                : percent <= 50 ? Color.rgb(194,142,12) : Color.rgb(40,161,92);
    }
    static final class Battery extends Drawable {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private int percent = -2;
        void update(int value) { if (percent != value) { percent = value; invalidateSelf(); } }
        @Override public void draw(Canvas canvas) {
            Rect b = getBounds(); canvas.save(); canvas.translate(b.left,b.top); canvas.scale(b.width()/24f,b.height()/18f);
            paint.setColor(batteryColor(percent)); paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1.4f);
            canvas.drawRoundRect(1,3,21,15,2.3f,2.3f,paint); paint.setStyle(Paint.Style.FILL);
            canvas.drawRoundRect(22,7,24,11,1,1,paint);
            if (percent > 0) canvas.drawRoundRect(3,5,3 + 16 * percent/100f,13,1,1,paint);
            canvas.restore();
        }
        @Override public void setAlpha(int alpha) { paint.setAlpha(alpha); }
        @Override public void setColorFilter(ColorFilter filter) { paint.setColorFilter(filter); }
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }
    static final class Shutter extends Drawable {
        private static final int TERRACOTTA = 0xffc4622d;
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final Runnable pendingFrame = this::invalidateSelf;
        private boolean photo, recording, pending, pressed;
        void update(boolean photo, boolean recording, boolean pending) {
            boolean wasPending = this.pending;
            if (this.photo != photo || this.recording != recording || wasPending != pending) {
                this.photo=photo; this.recording=recording; this.pending=pending;
                if (pending && !wasPending) scheduleSelf(pendingFrame, android.os.SystemClock.uptimeMillis() + 16);
                else if (!pending && wasPending) unscheduleSelf(pendingFrame);
                invalidateSelf();
            }
        }
        boolean isPending() { return pending; }
        @Override public boolean isStateful() { return true; }
        @Override protected boolean onStateChange(int[] states) {
            boolean next=false; for(int state:states) if(state==android.R.attr.state_pressed) next=true;
            if(pressed==next) return false; pressed=next; invalidateSelf(); return true;
        }
        @Override public void draw(Canvas canvas) {
            Rect b=getBounds(); float size=Math.min(b.width(),b.height());
            canvas.save(); canvas.translate(b.centerX(),b.centerY()); canvas.scale(size/88f,size/88f);
            // A quiet paper-white ring with a fine ink keyline; avoid the
            // chrome/bevel stack so the control belongs to the editorial UI.
            paint.setStyle(Paint.Style.FILL); paint.setColor(0x0d30271e); canvas.drawCircle(0,1.5f,40,paint);
            paint.setColor(0xfffaf7f1); canvas.drawCircle(0,0,40,paint);
            paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1.1f);
            paint.setColor(0xff39312b); canvas.drawCircle(0,0,39.5f,paint);
            paint.setColor(0xffded5c9); paint.setStrokeWidth(.8f); canvas.drawCircle(0,0,34.5f,paint);
            paint.setStyle(Paint.Style.FILL);
            if (pending) {
                canvas.save();
                paint.setStyle(Paint.Style.STROKE); paint.setStrokeCap(Paint.Cap.ROUND); paint.setStrokeWidth(2.5f);
                paint.setColor(TERRACOTTA);
                canvas.rotate((android.os.SystemClock.uptimeMillis() % 900L) * 360f / 900f);
                canvas.drawArc(-42,-42,42,42,18,104,false,paint);
                canvas.restore();
                paint.setStyle(Paint.Style.FILL); paint.setStrokeCap(Paint.Cap.BUTT);
                scheduleSelf(pendingFrame, android.os.SystemClock.uptimeMillis() + 16);
            }
            if(recording) {
                paint.setColor(TERRACOTTA);
                float side=pressed?14:15;
                canvas.drawRoundRect(-side,-side,side,side,4,4,paint);
            } else {
                int top=photo?0xfffbf8f2:0xffce7444, bottom=photo?0xffe9dfd0:TERRACOTTA;
                if(pressed) { top=photo?0xffe9dfd0:0xffa94f22; bottom=photo?0xffe3d6c4:0xffb75827; }
                paint.setShader(new LinearGradient(0,-29,0,29,top,bottom,Shader.TileMode.CLAMP));
                float radius=pressed?27:29.5f; canvas.drawCircle(0,0,radius,paint); paint.setShader(null);
                paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(.8f);
                paint.setColor(photo?0xffcfc2b1:0x55fff5e8);
                canvas.drawCircle(0,-.5f,radius-1,paint); paint.setStyle(Paint.Style.FILL);
            }
            canvas.restore();
        }
        @Override public void setAlpha(int alpha) { paint.setAlpha(alpha); }
        @Override public void setColorFilter(ColorFilter filter) { paint.setColorFilter(filter); }
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }

    /**
     * A lightweight liquid-glass surface for controls drawn over the live
     * viewfinder. It deliberately uses translucency and a two-pass keyline so
     * the camera image remains visible underneath instead of becoming a solid
     * panel. The drawable has no state or click affordance; callers decide
     * whether the hosting view is interactive.
     */
    static final class Glass extends Drawable {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final int fill, border;
        private final float radius;
        Glass(int fill, int border, float radius) {
            this.fill = fill; this.border = border; this.radius = radius;
            paint.setStrokeCap(Paint.Cap.ROUND);
        }
        @Override public void draw(Canvas canvas) {
            Rect b = getBounds();
            if (b.isEmpty()) return;
            float inset = Math.max(1f, Math.min(b.width(), b.height()) * .018f);
            RectF outer = new RectF(b.left + inset, b.top + inset, b.right - inset, b.bottom - inset);
            paint.setStyle(Paint.Style.FILL); paint.setColor(fill);
            canvas.drawRoundRect(outer, radius, radius, paint);
            paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1f); paint.setColor(border);
            canvas.drawRoundRect(outer, radius, radius, paint);
            // A narrow upper highlight provides the soft glass edge without
            // adding a bevel or opaque background to the viewfinder.
            paint.setColor(Color.argb(Math.min(120, Color.alpha(border)), 255, 255, 255));
            paint.setStrokeWidth(1.2f);
            canvas.drawArc(outer, 200, 140, false, paint);
            paint.setStyle(Paint.Style.FILL);
        }
        @Override public void setAlpha(int alpha) { paint.setAlpha(alpha); invalidateSelf(); }
        @Override public void setColorFilter(ColorFilter filter) { paint.setColorFilter(filter); invalidateSelf(); }
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }
}
