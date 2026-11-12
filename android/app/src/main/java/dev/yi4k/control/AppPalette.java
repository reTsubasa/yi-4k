package dev.yi4k.control;

/** Shared visual tokens. Camera status colors remain semantic, not accents. */
final class AppPalette {
    static final int ACCENT = 0xffc4622d;
    static final int INK = 0xff24211d;
    static final int BACKGROUND = 0xfff4efe7;
    static final int SURFACE = 0xfffbf7f0;
    static final int MUTED = 0xff8b8074;
    static final int LINE = 0xffddd3c6;
    static final int SELECTED = 0xffefe1d3;
    static int tagBackground(String label) {
        if (label.contains("EIS")) return 0xffeed4c3;
        if (label.endsWith("fps") || label.contains("慢动作")) return 0xffe4e8db;
        if (label.contains("视角") || label.contains("广角")) return 0xfff0e2bd;
        return 0xffe9e1d7;
    }
    static int tagText(String label) {
        if (label.contains("EIS")) return 0xffa64e23;
        if (label.endsWith("fps") || label.contains("慢动作")) return 0xff5f6c51;
        if (label.contains("视角") || label.contains("广角")) return 0xff8c6d2c;
        return 0xff716150;
    }
    private AppPalette() { }
}
