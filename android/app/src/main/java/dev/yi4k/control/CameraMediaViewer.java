package dev.yi4k.control;

import android.app.Activity;
import android.app.Application;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaMetadataRetriever;
import android.net.Network;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.VideoView;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** In-app original preview. Network transfers are bound to the camera Wi-Fi. */
public final class CameraMediaViewer implements AutoCloseable, Application.ActivityLifecycleCallbacks {
    private static final String FAVORITES = "camera_media_favorites";
    private static final int PAPER = AppPalette.BACKGROUND, INK = AppPalette.INK,
            MUTED = AppPalette.MUTED, LINE = AppPalette.LINE, ACCENT = AppPalette.ACCENT;
    private final Activity activity;
    private final Network network;
    private final String host;
    private final int port;
    private final MediaEntry entry;
    private final Dialog dialog;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final ExecutorService worker = Executors.newSingleThreadExecutor();
    private final FrameLayout media;
    private final TextView status, elapsed, total, sizeValue, resolutionValue, durationValue;
    private final LinearLayout timeline;
    private final SeekBar seek;
    private final ProgressBar progress;
    private final Button action, favorite, edit;
    private boolean preparingEdit;
    private final PlayToggle play;
    private volatile CameraMediaCache transfer;
    private volatile boolean closed;
    private volatile int attempt;
    private File cached;
    private Bitmap bitmap;
    private ImageView image;
    private VideoView video;
    private Runnable onCloseListener;
    private CameraThumbnailStore thumbnails;
    private boolean loading, prepared, seeking, resumeAfterSeek, ended;
    private long durationMs = -1;
    private final Runnable ticker = new Runnable() {
        @Override public void run() {
            if (closed || video == null || !prepared) return;
            if (!seeking) updateTimeline(video.getCurrentPosition());
            if (video.isPlaying()) handler.postDelayed(this, 250);
        }
    };

    /** Call on the UI thread. Null Network is accepted only for a literal loopback simulator. */
    public static CameraMediaViewer show(Activity activity, Network network, String host, int httpPort, MediaEntry entry) {
        return show(activity, network, host, httpPort, entry, null);
    }

    /** Pass the current camera-session thumbnail store to retain this real cover for its album. */
    public static CameraMediaViewer show(Activity activity, Network network, String host, int httpPort, MediaEntry entry,
                                         CameraThumbnailStore thumbnails) {
        if (Looper.myLooper() != Looper.getMainLooper()) throw new IllegalStateException("请在界面线程打开原片");
        if (activity.isFinishing() || activity.isDestroyed()) throw new IllegalStateException("页面已关闭");
        if (entry == null || !entry.isMedia()) throw new IllegalArgumentException("请选择照片或视频");
        CameraMediaViewer viewer = new CameraMediaViewer(activity, network, host, httpPort, entry);
        viewer.thumbnails = thumbnails;
        activity.getApplication().registerActivityLifecycleCallbacks(viewer);
        viewer.dialog.show();
        Window window = viewer.dialog.getWindow();
        if (window != null) {
            window.setLayout(-1, -1);
            window.setBackgroundDrawableResource(android.R.color.transparent);
            window.setStatusBarColor(PAPER); window.setNavigationBarColor(PAPER);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR | View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
        }
        viewer.start();
        return viewer;
    }

    private CameraMediaViewer(Activity activity, Network network, String host, int port, MediaEntry entry) {
        this.activity = activity; this.network = network; this.host = host; this.port = port; this.entry = entry;
        dialog = new Dialog(activity, android.R.style.Theme_Material_Light_NoActionBar);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setOnDismissListener(ignored -> close());
        LinearLayout root = column(); root.setBackground(new PaperDrawable());
        root.setOnApplyWindowInsetsListener((view, insets) -> {
            view.setPadding(insets.getSystemWindowInsetLeft(), insets.getSystemWindowInsetTop(),
                    insets.getSystemWindowInsetRight(), insets.getSystemWindowInsetBottom());
            return insets;
        });
        LinearLayout top = new LinearLayout(activity); top.setGravity(Gravity.CENTER_VERTICAL);
        top.setPadding(dp(16), dp(8), dp(16), dp(8));
        View back = new View(activity) {
            private final Paint arrow = new Paint(Paint.ANTI_ALIAS_FLAG);
            @Override protected void onDraw(Canvas canvas) {
                arrow.setColor(INK); arrow.setStyle(Paint.Style.STROKE);
                arrow.setStrokeWidth(dp(2)); arrow.setStrokeCap(Paint.Cap.ROUND); arrow.setStrokeJoin(Paint.Join.ROUND);
                float cx = getWidth() / 2f, cy = getHeight() / 2f;
                Path path = new Path(); path.moveTo(cx + dp(5), cy - dp(10));
                path.lineTo(cx - dp(5), cy); path.lineTo(cx + dp(5), cy + dp(10)); canvas.drawPath(path, arrow);
            }
            @Override public CharSequence getAccessibilityClassName() { return Button.class.getName(); }
        };
        back.setFocusable(true); back.setContentDescription("返回相册");
        back.setOnClickListener(v -> close());
        FrameLayout backSlot = new FrameLayout(activity);
        backSlot.addView(back, new FrameLayout.LayoutParams(dp(48), dp(48), Gravity.START | Gravity.CENTER_VERTICAL));
        top.addView(backSlot, new LinearLayout.LayoutParams(dp(64), dp(48)));
        TextView heading = text("回放", 20, INK); heading.setGravity(Gravity.CENTER);
        heading.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        heading.setMinHeight(dp(48)); top.addView(heading, new LinearLayout.LayoutParams(0, -2, 1));
        top.addView(new View(activity), new LinearLayout.LayoutParams(dp(64), 1)); root.addView(top);
        root.addView(divider(), new LinearLayout.LayoutParams(-1, dp(1)));
        ScrollView scroll = new ScrollView(activity); scroll.setFillViewport(true);
        LinearLayout content = column(); content.setPadding(dp(16), dp(16), dp(16), dp(24)); scroll.addView(content);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1));
        media = new FrameLayout(activity) {
            @Override protected void onMeasure(int width, int height) {
                int available = View.MeasureSpec.getSize(width);
                super.onMeasure(View.MeasureSpec.makeMeasureSpec(available, View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(Math.round(available * 9f / 16f), View.MeasureSpec.EXACTLY));
            }
        };
        media.setBackground(rounded(INK, 12)); media.setClipToOutline(true);
        content.addView(media, new LinearLayout.LayoutParams(-1, -2));
        play = new PlayToggle(activity); play.setOnClickListener(v -> togglePlayback()); play.setVisibility(View.GONE);
        timeline = new LinearLayout(activity); timeline.setGravity(Gravity.CENTER_VERTICAL); timeline.setBaselineAligned(false);
        timeline.setPadding(0, dp(8), 0, dp(8));
        elapsed = text("00:00", 12, INK); total = text("--:--", 12, MUTED);
        elapsed.setTypeface(Typeface.MONOSPACE); total.setTypeface(Typeface.MONOSPACE);
        elapsed.setGravity(Gravity.CENTER); total.setGravity(Gravity.CENTER);
        elapsed.setMaxLines(1); total.setMaxLines(1);
        elapsed.setHorizontallyScrolling(false); total.setHorizontallyScrolling(false);
        elapsed.setMinWidth(dp(48)); total.setMinWidth(dp(48));
        timeline.addView(elapsed, new LinearLayout.LayoutParams(-2, dp(48)));
        seek = new SeekBar(activity); seek.setMax(1000); seek.setEnabled(false); seek.setContentDescription("播放进度");
        seek.setProgressTintList(android.content.res.ColorStateList.valueOf(ACCENT));
        seek.setProgressBackgroundTintList(android.content.res.ColorStateList.valueOf(LINE));
        seek.setThumbTintList(android.content.res.ColorStateList.valueOf(ACCENT));
        timeline.addView(seek, new LinearLayout.LayoutParams(0, dp(48), 1));
        timeline.addView(total, new LinearLayout.LayoutParams(-2, dp(48)));
        timeline.setVisibility(isVideo() ? View.VISIBLE : View.GONE); content.addView(timeline);
        seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override public void onStartTrackingTouch(SeekBar bar) {
                seeking = true; resumeAfterSeek = prepared && video != null && video.isPlaying(); pausePlayback();
            }
            @Override public void onProgressChanged(SeekBar bar, int position, boolean fromUser) {
                if (fromUser && durationMs > 0) elapsed.setText(time(Math.round(durationMs * position / 1000.0)));
            }
            @Override public void onStopTrackingTouch(SeekBar bar) {
                if (prepared && video != null && durationMs > 0) {
                    int target = (int) Math.min(Integer.MAX_VALUE, Math.round(durationMs * bar.getProgress() / 1000.0));
                    video.seekTo(target); ended = false; updateTimeline(target);
                    if (image != null) image.setVisibility(View.GONE);
                }
                seeking = false; if (resumeAfterSeek) startPlayback(); resumeAfterSeek = false;
            }
        });
        status = text("准备读取原片…", 12, MUTED); status.setGravity(Gravity.START);
        status.setPadding(0, dp(8), 0, dp(8)); content.addView(status);
        progress = new ProgressBar(activity, null, android.R.attr.progressBarStyleHorizontal);
        progress.setMax(1000); progress.setProgressTintList(android.content.res.ColorStateList.valueOf(ACCENT));
        progress.setProgressBackgroundTintList(android.content.res.ColorStateList.valueOf(LINE));
        content.addView(progress, new LinearLayout.LayoutParams(-1, dp(4)));
        action = button("取消读取", true); action.setOnClickListener(v -> { if (loading) cancel(); else start(); });
        LinearLayout.LayoutParams actionLayout = new LinearLayout.LayoutParams(-1, -2);
        actionLayout.topMargin = dp(16); content.addView(action, actionLayout);
        LinearLayout informationHeading = new LinearLayout(activity); informationHeading.setGravity(Gravity.CENTER_VERTICAL);
        TextView informationTitle = text("原片信息", 19, INK); informationTitle.setTypeface(Typeface.create("serif", Typeface.NORMAL));
        informationHeading.addView(informationTitle, new LinearLayout.LayoutParams(0, -2, 1));
        favorite = button("♡  收藏", false); favorite.setOnClickListener(v -> toggleFavorite()); updateFavorite();
        informationHeading.addView(favorite, new LinearLayout.LayoutParams(-2, -2));
        LinearLayout.LayoutParams headingParams = new LinearLayout.LayoutParams(-1, -2); headingParams.topMargin = dp(16); headingParams.bottomMargin = dp(8);
        content.addView(informationHeading, headingParams);
        content.addView(divider(), new LinearLayout.LayoutParams(-1, dp(1)));
        LinearLayout information = column(); information.setPadding(0, dp(4), 0, dp(4));
        addInfo(information, "文件名", entry.name);
        sizeValue = addInfo(information, "文件大小", "待读取");
        resolutionValue = addInfo(information, "分辨率", "待读取");
        durationValue = addInfo(information, "时长", isVideo() ? "待读取" : "照片");
        addInfo(information, "存储位置", "相机存储卡 · 手机临时预览");
        LinearLayout.LayoutParams informationParams = new LinearLayout.LayoutParams(-1, -2);
        informationParams.topMargin = dp(0); content.addView(information, informationParams);
        edit = button("在剪辑中打开", true); edit.setEnabled(false);
        edit.setVisibility(isVideo() ? View.VISIBLE : View.GONE); edit.setOnClickListener(v -> openEditor());
        LinearLayout.LayoutParams editParams = new LinearLayout.LayoutParams(-1, -2); editParams.topMargin = dp(16);
        content.addView(edit, editParams);
        TextView hint = text("预览缓存在返回后清理。\n保存原片可回到相册选择「导出」。", 12, MUTED);
        hint.setGravity(Gravity.START); hint.setLineSpacing(dp(4), 1);
        LinearLayout.LayoutParams hintParams = new LinearLayout.LayoutParams(-1, -2);
        hintParams.topMargin = dp(16); content.addView(hint, hintParams);
        dialog.setContentView(root);
    }

    private void start() {
        if (closed || loading) return;
        releaseMedia();
        int current = ++attempt;
        loading = true; action.setText("取消读取"); action.setVisibility(View.VISIBLE);
        progress.setVisibility(View.VISIBLE); progress.setIndeterminate(true);
        sizeValue.setText("待读取"); resolutionValue.setText("待读取"); durationValue.setText(isVideo() ? "待读取" : "照片");
        status.setText("正在通过相机 Wi-Fi 读取原片…");
        if (!hasBoundRoute(network != null, host)) { error("相机 Wi-Fi 已断开，请返回重新连接相机后再预览"); return; }
        CameraMediaCache download = new CameraMediaCache(url -> (HttpURLConnection)
                (network == null ? url.openConnection() : network.openConnection(url)));
        transfer = download;
        worker.execute(() -> {
            File file = null;
            Bitmap decoded = null;
            try {
                file = download.fetch(new File(activity.getCacheDir(), "original-preview"), host, port, entry,
                        (received, bytes) -> post(current, () -> {
                            progress.setIndeterminate(false);
                            progress.setProgress((int) Math.min(1000, received * 1000.0 / bytes));
                            status.setText(String.format(Locale.CHINA, "正在读取原片  %.0f%% · %s / %s",
                                    received * 100.0 / bytes, size(received), size(bytes)));
                        }));
                MediaInfo info;
                if (isVideo()) { info = readVideoInfo(file); decoded = info.cover; }
                else { info = readPhotoInfo(file); decoded = decode(file); }
                if (decoded != null && thumbnails != null) {
                    try { thumbnails.remember(entry, decoded); }
                    catch (IOException ignored) { /* A cache miss must never prevent original playback. */ }
                }
                File readyFile = file; Bitmap readyBitmap = decoded;
                handler.post(() -> {
                    if (closed || current != attempt) { if (readyBitmap != null) readyBitmap.recycle(); readyFile.delete(); return; }
                    cached = readyFile; bitmap = readyBitmap; loading = false; edit.setEnabled(isVideo());
                    progress.setVisibility(View.GONE); action.setVisibility(View.GONE);
                    showInformation(readyFile, info);
                    if (isVideo()) showVideo(readyFile); else showPhoto(readyBitmap);
                });
                file = null; decoded = null;
            } catch (Exception failure) { post(current, () -> error("无法预览：" + readableError(failure))); }
            finally { if (decoded != null) decoded.recycle(); if (file != null) file.delete(); }
        });
    }

    private void openEditor() {
        if (closed || preparingEdit || loading || !isVideo() || cached == null) return;
        pausePlayback(); preparingEdit = true; edit.setEnabled(false); edit.setText("正在准备素材…");
        status.setText("正在准备剪辑素材，原片保留");
        File source = cached;
        worker.execute(() -> {
            Intent launch = null;
            try {
                launch = VideoEditorActivity.prepareCachedVideo(activity, source, entry.name, () -> closed);
                Intent ready = launch;
                handler.post(() -> {
                    if (closed || activity.isFinishing() || activity.isDestroyed()) {
                        VideoEditorActivity.discardPreparedVideo(activity, ready); return;
                    }
                    try { activity.startActivity(ready); close(); }
                    catch (RuntimeException failure) {
                        VideoEditorActivity.discardPreparedVideo(activity, ready);
                        preparingEdit = false; edit.setText("在剪辑中打开"); edit.setEnabled(cached != null);
                        status.setText("无法打开剪辑：" + readableError(failure));
                    }
                });
                launch = null;
            } catch (Exception failure) {
                handler.post(() -> { if (!closed) {
                    preparingEdit = false; edit.setText("在剪辑中打开"); edit.setEnabled(cached != null);
                    status.setText("无法准备素材：" + readableError(failure));
                }});
            } finally { if (launch != null) VideoEditorActivity.discardPreparedVideo(activity, launch); }
        });
    }

    static final class MediaInfo {
        int width, height;
        long durationMs = -1;
        Bitmap cover;
    }

    private static MediaInfo readPhotoInfo(File file) {
        BitmapFactory.Options options = new BitmapFactory.Options(); options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(file.getAbsolutePath(), options);
        MediaInfo info = new MediaInfo(); info.width = options.outWidth; info.height = options.outHeight; return info;
    }

    private static MediaInfo readVideoInfo(File file) {
        MediaInfo info = new MediaInfo();
        MediaMetadataRetriever reader = new MediaMetadataRetriever();
        try {
            reader.setDataSource(file.getAbsolutePath());
            info.width = positiveInt(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
            info.height = positiveInt(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));
            String duration = reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            try { info.durationMs = Long.parseLong(duration); } catch (NumberFormatException ignored) { }
            int rotation = positiveInt(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION));
            if (rotation == 90 || rotation == 270) { int width = info.width; info.width = info.height; info.height = width; }
            try { info.cover = reader.getScaledFrameAtTime(0, MediaMetadataRetriever.OPTION_CLOSEST_SYNC, 640, 360); }
            catch (RuntimeException ignored) { /* Playback may still work if thumbnail extraction is unavailable. */ }
        } catch (RuntimeException ignored) { /* Keep unknown fields honest; VideoView can still try playback. */ }
        finally { try { reader.release(); } catch (IOException | RuntimeException ignored) { } }
        return info;
    }

    private static int positiveInt(String value) {
        try { return Math.max(0, Integer.parseInt(value)); } catch (NumberFormatException ignored) { return 0; }
    }

    private void showInformation(File file, MediaInfo info) {
        durationMs = info.durationMs > 0 ? info.durationMs : -1;
        sizeValue.setText(size(file.length()));
        resolutionValue.setText(info.width > 0 && info.height > 0 ? info.width + " × " + info.height : "文件未提供");
        durationValue.setText(isVideo() ? (durationMs > 0 ? time(durationMs) : "文件未提供") : "照片");
        total.setText(durationMs > 0 ? time(durationMs) : "--:--"); updateTimeline(0);
    }

    private Bitmap decode(File file) throws IOException {
        BitmapFactory.Options options = new BitmapFactory.Options(); options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(file.getAbsolutePath(), options);
        if (options.outWidth <= 0 || options.outHeight <= 0) throw new IOException("照片格式无法识别");
        options.inSampleSize = 1;
        while ((options.outWidth / options.inSampleSize) * (long) (options.outHeight / options.inSampleSize) > 4_000_000L)
            options.inSampleSize *= 2;
        options.inJustDecodeBounds = false; options.inPreferredConfig = Bitmap.Config.RGB_565;
        Bitmap result = BitmapFactory.decodeFile(file.getAbsolutePath(), options);
        if (result == null) throw new IOException("此手机无法解码照片");
        return result;
    }

    private void showPhoto(Bitmap photo) { addImage(photo); status.setText("原片已读取 · 照片适配屏幕显示"); }

    private void addImage(Bitmap photo) {
        image = new ImageView(activity); image.setScaleType(ImageView.ScaleType.FIT_CENTER); image.setImageBitmap(photo);
        image.setContentDescription("相机原片：" + entry.name); media.addView(image, new FrameLayout.LayoutParams(-1, -1));
    }

    private void showVideo(File file) {
        VideoView playerView = new VideoView(activity); video = playerView;
        media.addView(video, new FrameLayout.LayoutParams(-1, -1, Gravity.CENTER));
        if (bitmap != null) addImage(bitmap);
        media.addView(play, new FrameLayout.LayoutParams(dp(68), dp(68), Gravity.CENTER));
        play.setVisibility(View.VISIBLE); play.setEnabled(false); play.setPlaying(false);
        video.setOnPreparedListener(player -> {
            if (closed || video != playerView) return;
            prepared = true; ended = false;
            if (durationMs <= 0 && video.getDuration() > 0) {
                durationMs = video.getDuration(); durationValue.setText(time(durationMs)); total.setText(time(durationMs));
            }
            play.setEnabled(true); seek.setEnabled(durationMs > 0); updateTimeline(0);
            if (bitmap == null) video.seekTo(1);
            status.setText("点击画面中央播放 · 可拖动下方进度");
            // There is deliberately no start(): opening an original must not autoplay.
        });
        video.setOnCompletionListener(player -> {
            if (!closed && video == playerView) {
                ended = true; handler.removeCallbacks(ticker); play.setPlaying(false); updateTimeline(durationMs);
                status.setText("播放结束 · 点击中央按钮重新观看");
            }
        });
        video.setOnErrorListener((player, what, extra) -> {
            if (!closed && video == playerView) error("此手机无法播放该原片编码，可返回相册导出后使用兼容的播放器"); return true;
        });
        status.setText("正在打开原片…");
        // Only a private local path reaches the player, never an unbound camera URL.
        video.setVideoPath(file.getAbsolutePath());
    }

    private void togglePlayback() {
        if (!prepared || video == null) return;
        if (video.isPlaying()) pausePlayback(); else startPlayback();
    }

    private void startPlayback() {
        if (!prepared || video == null || closed) return;
        if (ended) { video.seekTo(0); ended = false; updateTimeline(0); }
        if (image != null) image.setVisibility(View.GONE);
        video.start(); play.setPlaying(true); status.setText("正在播放原片");
        handler.removeCallbacks(ticker); handler.post(ticker);
    }

    private void pausePlayback() {
        if (!prepared || video == null) return;
        video.pause(); play.setPlaying(false); handler.removeCallbacks(ticker);
        if (!seeking) updateTimeline(video.getCurrentPosition());
        status.setText("已暂停 · 点击中央按钮继续");
    }

    private void updateTimeline(long position) {
        long safe = Math.max(0, durationMs > 0 ? Math.min(position, durationMs) : position);
        elapsed.setText(time(safe));
        if (!seeking) seek.setProgress(durationMs > 0 ? (int) Math.min(1000, safe * 1000.0 / durationMs) : 0);
    }

    private void cancel() {
        ++attempt; CameraMediaCache download = transfer; if (download != null) download.cancel();
        loading = false; progress.setVisibility(View.GONE);
        status.setText("已取消读取，未保存到手机相册"); action.setText("重新读取");
    }

    private void error(String message) {
        loading = false; releaseMedia(); status.setText(message); progress.setVisibility(View.GONE);
        action.setVisibility(View.VISIBLE); action.setText("重试读取");
    }

    private void releaseMedia() {
        edit.setEnabled(false);
        prepared = false; seeking = false; resumeAfterSeek = false; ended = false; handler.removeCallbacks(ticker);
        play.setVisibility(View.GONE); play.setEnabled(false); play.setPlaying(false);
        seek.setEnabled(false); durationMs = -1; total.setText("--:--"); updateTimeline(0);
        if (video != null) {
            video.setOnPreparedListener(null); video.setOnErrorListener(null); video.setOnCompletionListener(null);
            video.stopPlayback(); video = null;
        }
        if (image != null) { image.setImageDrawable(null); image = null; }
        media.removeAllViews();
        if (bitmap != null) { bitmap.recycle(); bitmap = null; }
        if (cached != null) { cached.delete(); cached = null; }
    }

    private void toggleFavorite() {
        boolean selected = !isFavorite(activity, host, port, entry);
        activity.getSharedPreferences(FAVORITES, Context.MODE_PRIVATE).edit().putBoolean(favoriteKey(host, port, entry), selected).apply();
        updateFavorite();
    }

    private void updateFavorite() {
        boolean selected = isFavorite(activity, host, port, entry);
        favorite.setText(selected ? "♥  已收藏" : "♡  收藏"); favorite.setContentDescription(selected ? "取消收藏" : "收藏原片");
        favorite.setSelected(selected); favorite.setTextColor(selected ? ACCENT : MUTED);
        favorite.setBackgroundColor(Color.TRANSPARENT);
    }

    /** Local bookmark only; it does not modify the camera or retain the media file. */
    public static boolean isFavorite(Context context, String host, int port, MediaEntry entry) {
        return context.getSharedPreferences(FAVORITES, Context.MODE_PRIVATE).getBoolean(favoriteKey(host, port, entry), false);
    }
    private static String favoriteKey(String host, int port, MediaEntry entry) { return host + ":" + port + entry.path; }

    /** Notified once, on the UI thread, after the window and private media have been released. */
    public void setOnCloseListener(Runnable listener) {
        if (Looper.myLooper() != Looper.getMainLooper()) throw new IllegalStateException("请在界面线程设置关闭回调");
        if (!closed) onCloseListener = listener;
    }

    /** Safe to call from Activity.onDestroy or when disconnecting the camera. */
    @Override public void close() {
        if (Looper.myLooper() != Looper.getMainLooper()) { handler.post(this::close); return; }
        if (closed) return;
        closed = true; ++attempt; CameraMediaCache download = transfer; if (download != null) download.cancel();
        worker.shutdownNow();
        try { releaseMedia(); }
        finally {
            activity.getApplication().unregisterActivityLifecycleCallbacks(this);
            if (dialog.isShowing()) dialog.dismiss();
            Runnable listener = onCloseListener; onCloseListener = null;
            if (listener != null) listener.run();
        }
    }

    static boolean hasBoundRoute(boolean hasNetwork, String host) { return hasNetwork || "127.0.0.1".equals(host) || "::1".equals(host); }
    private void post(int current, Runnable runnable) { handler.post(() -> { if (!closed && current == attempt) runnable.run(); }); }
    private boolean isVideo() { return entry.name.toLowerCase(Locale.ROOT).endsWith(".mp4"); }
    private static String readableError(Exception failure) {
        if (failure instanceof java.net.SocketTimeoutException) return "读取超时，请确认相机 Wi-Fi 后重试";
        if (failure instanceof java.net.ConnectException || failure instanceof java.net.UnknownHostException)
            return "无法连接相机，请确认相机 Wi-Fi 后重试";
        String message = failure.getMessage(); return message == null ? "读取失败，请检查相机连接后重试" : message;
    }
    private static String time(long millis) {
        long seconds = Math.max(0, millis) / 1000;
        return seconds >= 3600 ? String.format(Locale.CHINA, "%d:%02d:%02d", seconds / 3600, seconds / 60 % 60, seconds % 60)
                : String.format(Locale.CHINA, "%02d:%02d", seconds / 60, seconds % 60);
    }
    private static String size(long bytes) {
        return bytes >= 1048576 ? String.format(Locale.CHINA, "%.1f MB", bytes / 1048576.0)
                : bytes >= 1024 ? String.format(Locale.CHINA, "%.1f KB", bytes / 1024.0) : bytes + " 字节";
    }
    private int dp(int value) { return Math.round(value * activity.getResources().getDisplayMetrics().density); }
    private LinearLayout column() { LinearLayout view = new LinearLayout(activity); view.setOrientation(LinearLayout.VERTICAL); return view; }
    private TextView text(String title, int size, int color) {
        TextView view = new TextView(activity); view.setText(title); view.setTextSize(size); view.setTextColor(color); view.setIncludeFontPadding(false); view.setLineSpacing(dp(4), 1); return view;
    }
    private TextView addInfo(LinearLayout parent, String title, String value) {
        LinearLayout row = new LinearLayout(activity); row.setGravity(Gravity.TOP); row.setPadding(0, dp(8), 0, dp(8));
        boolean stacked = activity.getResources().getConfiguration().fontScale > 1.3f
                || activity.getResources().getConfiguration().screenWidthDp < 360;
        row.setOrientation(stacked ? LinearLayout.VERTICAL : LinearLayout.HORIZONTAL); row.setBaselineAligned(false);
        TextView label = text(title, 13, MUTED);
        row.addView(label, new LinearLayout.LayoutParams(stacked ? -1 : dp(88), -2));
        TextView detail = text(value, 14, INK); detail.setTextIsSelectable(true);
        LinearLayout.LayoutParams detailParams = new LinearLayout.LayoutParams(stacked ? -1 : 0, -2, stacked ? 0 : 1);
        if (stacked) detailParams.topMargin = dp(8);
        row.addView(detail, detailParams); parent.addView(row);
        parent.addView(divider(), new LinearLayout.LayoutParams(-1, dp(1))); return detail;
    }
    private View divider() { View view = new View(activity); view.setBackgroundColor(LINE); return view; }
    private Button button(String title, boolean filled) {
        Button view = new Button(activity); view.setText(title); view.setTextSize(15); view.setAllCaps(false);
        view.setTextColor(filled ? PAPER : INK);
        GradientDrawable background = rounded(filled ? ACCENT : PAPER, 10); background.setStroke(dp(1), filled ? ACCENT : LINE); view.setBackground(background);
        view.setMinWidth(0); view.setMinimumWidth(0); view.setMinHeight(dp(48)); view.setMinimumHeight(dp(48));
        view.setGravity(Gravity.CENTER); view.setIncludeFontPadding(false); view.setPadding(dp(16), dp(8), dp(16), dp(8));
        view.setStateListAnimator(null); return view;
    }
    private GradientDrawable rounded(int color, int radius) {
        GradientDrawable shape = new GradientDrawable(); shape.setColor(color); shape.setCornerRadius(dp(radius)); return shape;
    }
    private static final class PlayToggle extends View {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private boolean playing;
        PlayToggle(Context context) { super(context); setFocusable(true); setPlaying(false); }
        void setPlaying(boolean value) { playing = value; setContentDescription(value ? "暂停原片" : "播放原片"); invalidate(); }
        @Override protected void onDraw(Canvas canvas) {
            float cx = getWidth() / 2f, cy = getHeight() / 2f, radius = Math.min(cx, cy) - 3;
            paint.setStyle(Paint.Style.FILL); paint.setColor(ACCENT); paint.setAlpha(isEnabled() ? 245 : 110); canvas.drawCircle(cx, cy, radius, paint);
            paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1); paint.setColor(PAPER); canvas.drawCircle(cx, cy, radius - 1, paint);
            paint.setStyle(Paint.Style.FILL); paint.setAlpha(isEnabled() ? 255 : 110);
            if (playing) {
                canvas.drawRect(cx - radius * .30f, cy - radius * .38f, cx - radius * .10f, cy + radius * .38f, paint);
                canvas.drawRect(cx + radius * .10f, cy - radius * .38f, cx + radius * .30f, cy + radius * .38f, paint);
            } else {
                Path triangle = new Path(); triangle.moveTo(cx - radius * .23f, cy - radius * .43f);
                triangle.lineTo(cx + radius * .44f, cy); triangle.lineTo(cx - radius * .23f, cy + radius * .43f); triangle.close();
                canvas.drawPath(triangle, paint);
            }
        }
    }
    @Override public void onActivityPaused(Activity owner) { if (owner == activity) pausePlayback(); }
    @Override public void onActivityDestroyed(Activity owner) { if (owner == activity) close(); }
    @Override public void onActivityCreated(Activity owner, Bundle state) { }
    @Override public void onActivityStarted(Activity owner) { }
    @Override public void onActivityResumed(Activity owner) { }
    @Override public void onActivityStopped(Activity owner) { }
    @Override public void onActivitySaveInstanceState(Activity owner, Bundle state) { }
}
