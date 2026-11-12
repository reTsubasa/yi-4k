package dev.yi4k.control;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.Shader;
import android.graphics.drawable.Drawable;

/** Warm paper: ivory at the top, a warmer wash at the bottom, and fine fixed fibres. */
final class PaperDrawable extends Drawable {
    private final Paint ink = new Paint(Paint.ANTI_ALIAS_FLAG);
    private LinearGradient wash;
    private int alpha = 255;
    @Override protected void onBoundsChange(Rect bounds) {
        wash = new LinearGradient(0, bounds.bottom, 0, bounds.top,
                Color.rgb(231, 219, 202), AppPalette.BACKGROUND, Shader.TileMode.CLAMP);
    }
    @Override public void draw(Canvas canvas) {
        ink.setShader(wash); ink.setAlpha(alpha); canvas.drawRect(getBounds(), ink); ink.setShader(null);
        int seed = 731;
        int count = Math.min(16000, Math.max(800, getBounds().width() * getBounds().height() / 150));
        for (int i = 0; i < count; i++) {
            seed = seed * 1664525 + 1013904223;
            float x = getBounds().left + ((seed >>> 8) & 65535) / 65535f * getBounds().width();
            seed = seed * 1664525 + 1013904223;
            float y = getBounds().top + ((seed >>> 8) & 65535) / 65535f * getBounds().height();
            ink.setColor((i & 1) == 0 ? 0x11836a50 : 0x28ffffff);
            ink.setAlpha(ink.getAlpha() * alpha / 255); ink.setStrokeWidth(.65f);
            canvas.drawLine(x, y, x + 1.2f + (i % 3), y + .4f, ink);
        }
    }
    @Override public void setAlpha(int value) { alpha = value; invalidateSelf(); }
    @Override public void setColorFilter(ColorFilter value) { ink.setColorFilter(value); invalidateSelf(); }
    @Override public int getOpacity() { return alpha == 255 ? PixelFormat.OPAQUE : PixelFormat.TRANSLUCENT; }
}
