package dev.yi4k.control;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

final class CameraPreviewLayout {
    private static final Pattern DIMENSIONS = Pattern.compile("(\\d{3,5})\\s*[xX×]\\s*(\\d{3,5})");
    private static final float STREAM_FALLBACK = 16f / 9f;

    static float aspectRatio(String selectedResolution) {
        if (selectedResolution != null) {
            Matcher match = DIMENSIONS.matcher(selectedResolution);
            if (match.find()) {
                try {
                    int width = Integer.parseInt(match.group(1));
                    int height = Integer.parseInt(match.group(2));
                    if (width > 0 && height > 0) return (float) width / height;
                } catch (NumberFormatException ignored) { }
            }
        }
        return STREAM_FALLBACK;
    }

    static final class Bounds {
        final int left, top, right, bottom;
        Bounds(int left, int top, int right, int bottom) {
            this.left = left; this.top = top; this.right = right; this.bottom = bottom;
        }
    }

    static Bounds centeredFit(int viewportWidth, int viewportHeight, float aspectRatio) {
        int width = Math.max(0, viewportWidth), height = Math.max(0, viewportHeight);
        float ratio = aspectRatio > 0 && Float.isFinite(aspectRatio) ? aspectRatio : STREAM_FALLBACK;
        if (width == 0 || height == 0) return new Bounds(0, 0, width, height);
        int frameWidth = width;
        int frameHeight = Math.round(frameWidth / ratio);
        if (frameHeight > height) {
            frameHeight = height;
            frameWidth = Math.round(frameHeight * ratio);
        }
        int left = (width - frameWidth) / 2;
        int top = (height - frameHeight) / 2;
        return new Bounds(left, top, left + frameWidth, top + frameHeight);
    }

    private CameraPreviewLayout() { }
}
