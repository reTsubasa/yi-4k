package dev.yi4k.control;

/** Immutable selection in source milliseconds. The source is never overwritten. */
final class VideoEditPlan {
    static final long MIN_CLIP_MS = 100;
    final long durationMs, startMs, endMs;
    final boolean muted, grayscale;
    final int rotation;

    VideoEditPlan(long durationMs, long startMs, long endMs, boolean muted, boolean grayscale, int rotation) {
        if (durationMs < MIN_CLIP_MS || startMs < 0 || endMs <= startMs || endMs > durationMs || endMs - startMs < MIN_CLIP_MS)
            throw new IllegalArgumentException("请选择至少 0.1 秒的视频片段");
        if (rotation < 0 || rotation >= 360 || rotation % 90 != 0)
            throw new IllegalArgumentException("旋转角度无效");
        this.durationMs = durationMs; this.startMs = startMs; this.endMs = endMs;
        this.muted = muted; this.grayscale = grayscale; this.rotation = rotation;
    }

    long selectedDurationMs() { return endMs - startMs; }
    /** Clamp either handle in source time; crossing never swaps the handles. */
    static long boundary(boolean first, long requested, long duration, long from, long to) {
        if (duration < MIN_CLIP_MS || from < 0 || to <= from || to > duration || to - from < MIN_CLIP_MS)
            throw new IllegalArgumentException("片段范围无效");
        return first ? Math.max(0, Math.min(requested, to - MIN_CLIP_MS))
                : Math.min(duration, Math.max(requested, from + MIN_CLIP_MS));
    }
    static long timeAt(int progress, long durationMs) {
        if (progress < 0 || progress > 10000 || durationMs < 0) throw new IllegalArgumentException("时间位置无效");
        return durationMs / 10000 * progress + durationMs % 10000 * progress / 10000;
    }
}
