package dev.yi4k.control;

import android.app.Activity;
import android.content.Intent;
import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.MotionEvent;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.OptIn;
import androidx.media3.common.MediaItem;
import androidx.media3.common.MimeTypes;
import androidx.media3.common.Player;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.transformer.Composition;
import androidx.media3.transformer.ExportException;
import androidx.media3.transformer.ExportResult;
import androidx.media3.transformer.ProgressHolder;
import androidx.media3.transformer.Transformer;
import androidx.media3.ui.PlayerView;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.BooleanSupplier;

/** Local editing of a phone-selected video. No camera writes or network decoding. */
@OptIn(markerClass = UnstableApi.class)
public final class VideoEditorActivity extends Activity {
    private static final int PICK_VIDEO = 410;
    private static final String STAGED_SOURCE = "editor_staged_source", SOURCE_NAME = "editor_source_name";

    /** Launch with a selected document. The caller must still hold its read grant. */
    public static Intent intentForVideo(Context context, Uri video) {
        if (video == null || !"content".equals(video.getScheme())) throw new IllegalArgumentException("请选择本地视频文档");
        return new Intent(context, VideoEditorActivity.class).setDataAndType(video, "video/*")
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    }

    /** Run on a worker. The returned intent owns a copy, independent of the preview cache. */
    public static Intent prepareCachedVideo(Context context, File video, String displayName,
                                             BooleanSupplier cancelled) throws Exception {
        File cache = context.getCacheDir().getCanonicalFile();
        File original = video.getCanonicalFile();
        if (!original.isFile() || !original.getPath().startsWith(cache.getPath() + File.separator))
            throw new IOException("视频预览缓存已失效，请重新读取");
        File inbox = new File(cache, "video-edit-inbox");
        if (!inbox.isDirectory() && !inbox.mkdirs()) throw new IOException("无法创建剪辑缓存");
        File[] pending = inbox.listFiles();
        if (pending != null) for (File stale : pending)
            if (stale.getName().matches("edit-source-[0-9]+\\.mp4")
                    && System.currentTimeMillis() - stale.lastModified() > 24 * 60 * 60 * 1000L) stale.delete();
        File staged = LocalVideoFiles.importVideo(new FileInputStream(original), inbox, cancelled);
        return new Intent(context, VideoEditorActivity.class).putExtra(STAGED_SOURCE, staged.getName())
                .putExtra(SOURCE_NAME, displayName);
    }

    /** Remove a prepared handoff only if launching the editor failed. */
    static void discardPreparedVideo(Context context, Intent intent) {
        try { File file = stagedSource(context, intent); if (file != null) file.delete(); }
        catch (IOException ignored) { }
    }
    private static File stagedSource(Context context, Intent intent) throws IOException {
        String name = intent == null ? null : intent.getStringExtra(STAGED_SOURCE);
        if (name == null) return null;
        if (!name.matches("edit-source-[0-9]+\\.mp4")) throw new IOException("剪辑素材无效");
        File root = new File(context.getCacheDir(), "video-edit-inbox").getCanonicalFile();
        File file = new File(root, name).getCanonicalFile();
        if (!root.equals(file.getParentFile()) || !file.isFile()) throw new IOException("剪辑素材已失效，请重新选择");
        return file;
    }
    private static final int INK = AppPalette.INK, PAPER = AppPalette.SURFACE,
            MUTED = AppPalette.MUTED, LINE = AppPalette.LINE, ACCENT = AppPalette.ACCENT;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final ExecutorService worker = Executors.newSingleThreadExecutor();
    private final AtomicBoolean importCancelled = new AtomicBoolean();
    private volatile boolean destroyed;
    private volatile InputStream importStream;
    private Uri pendingImportUri;
    private String pendingImportName;
    private File stagedImport;
    private boolean savedPendingImport;
    private boolean loading, exporting, muted, grayscale, foreground, previewPlaying;
    private int rotation;
    private long durationMs, startMs, endMs;
    private File sourceFile, exportFile;
    private String sourceDisplayName = "已导入视频";
    private VideoEditSession session;
    private AtomicBoolean exportToken;
    private Transformer transformer;
    private ExoPlayer player;
    private PlayerView playerView;
    private TextView status, range, sourceName, emptyPreview, heading, editorHint;
    private LinearLayout selectionIntro, editorPanel, selectionBody, sourceActions, preciseControls;
    private Button choose, export, cancel, mute, filter, rotate, reset, playSelection, openResult, fineToggle;
    private LinearLayout completion;
    private Uri savedResult;
    private SeekBar start, end;
    private ProgressBar progress;
    private TimelineStrip strip;
    private final Runnable exportProgress = new Runnable() {
        @Override public void run() {
            if (destroyed || transformer == null || !exporting) return;
            ProgressHolder holder = new ProgressHolder();
            int state = transformer.getProgress(holder);
            progress.setIndeterminate(state != Transformer.PROGRESS_STATE_AVAILABLE);
            if (state == Transformer.PROGRESS_STATE_AVAILABLE) {
                progress.setProgress(holder.progress); status.setText("正在导出  " + holder.progress + "%");
            }
            handler.postDelayed(this, 300);
        }
    };

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        getWindow().setStatusBarColor(PAPER); getWindow().setNavigationBarColor(PAPER);
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR | View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
        LinearLayout root = column(); root.setBackground(new PaperDrawable());
        root.setOnApplyWindowInsetsListener((view, insets) -> {
            view.setPadding(insets.getSystemWindowInsetLeft(), insets.getSystemWindowInsetTop(),
                    insets.getSystemWindowInsetRight(), insets.getSystemWindowInsetBottom()); return insets;
        });
        LinearLayout top = row(); top.setGravity(Gravity.CENTER_VERTICAL); top.setPadding(dp(16), dp(8), dp(16), dp(8));
        FrameLayout backSlot = new FrameLayout(this);
        View back = new View(this) {
            private final Paint arrow = new Paint(Paint.ANTI_ALIAS_FLAG);
            @Override protected void onDraw(Canvas canvas) {
                arrow.setColor(INK); arrow.setStyle(Paint.Style.STROKE); arrow.setStrokeWidth(dp(2));
                arrow.setStrokeCap(Paint.Cap.ROUND); arrow.setStrokeJoin(Paint.Join.ROUND);
                float cx = getWidth() / 2f, cy = getHeight() / 2f;
                Path path = new Path(); path.moveTo(cx + dp(5), cy - dp(10));
                path.lineTo(cx - dp(5), cy); path.lineTo(cx + dp(5), cy + dp(10)); canvas.drawPath(path, arrow);
            }
            @Override public CharSequence getAccessibilityClassName() { return Button.class.getName(); }
        };
        back.setFocusable(true); back.setContentDescription("返回"); back.setOnClickListener(v -> finish());
        backSlot.addView(back, new FrameLayout.LayoutParams(dp(48), dp(48), Gravity.START | Gravity.CENTER_VERTICAL));
        top.addView(backSlot, new LinearLayout.LayoutParams(dp(64), dp(48)));
        TextView title = text("选择素材", 20, INK); heading = title; title.setGravity(Gravity.CENTER); title.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        title.setMinHeight(dp(48)); top.addView(title, new LinearLayout.LayoutParams(0, -2, 1));
        export = button("导出", this::export); export.setTextColor(PAPER); export.setBackground(round(ACCENT, 10));
        top.addView(export, new LinearLayout.LayoutParams(dp(64), -2));
        root.addView(top); root.addView(divider(), new LinearLayout.LayoutParams(-1, dp(1)));
        ScrollView scroll = new ScrollView(this); scroll.setFillViewport(true);
        LinearLayout body = column(); body.setPadding(dp(16), dp(16), dp(16), dp(24)); scroll.addView(body);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1));
        selectionIntro = column(); selectionIntro.setPadding(dp(8), dp(40), dp(8), dp(32));
        TextView step = text("开始创作", 13, ACCENT); step.setGravity(Gravity.CENTER); selectionIntro.addView(step);
        TextView prompt = text("让精彩留在片段里", 26, INK); prompt.setGravity(Gravity.CENTER);
        prompt.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        LinearLayout.LayoutParams promptParams = new LinearLayout.LayoutParams(-1, -2); promptParams.topMargin = dp(16);
        selectionIntro.addView(prompt, promptParams);
        TextView help = text("选择一段手机视频，或从相机相册打开原片。", 14, MUTED);
        help.setGravity(Gravity.CENTER); help.setPadding(0, dp(16), 0, 0); selectionIntro.addView(help);
        body.addView(selectionIntro);
        choose = tool("从手机选择视频", this::pick);
        choose.setCompoundDrawablePadding(dp(8));
        choose.setTextColor(Color.WHITE); choose.setBackground(round(ACCENT, 12));
        LinearLayout.LayoutParams chooseParams = new LinearLayout.LayoutParams(-1, -2);
        chooseParams.bottomMargin = dp(20); body.addView(choose, chooseParams);
        LinearLayout outerBody = body; selectionBody = body;
        editorPanel = column(); outerBody.addView(editorPanel); body = editorPanel;
        FrameLayout frame = new FrameLayout(this) {
            @Override protected void onMeasure(int w, int h) {
                int width = View.MeasureSpec.getSize(w);
                super.onMeasure(View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(width * 9 / 16, View.MeasureSpec.EXACTLY));
            }
        };
        frame.setBackground(round(INK, 12)); frame.setClipToOutline(true);
        playerView = new PlayerView(this); playerView.setShowBuffering(PlayerView.SHOW_BUFFERING_WHEN_PLAYING);
        playerView.setControllerAutoShow(false); playerView.setUseController(false); playerView.setVisibility(View.GONE);
        View timelineBar = playerView.findViewById(androidx.media3.ui.R.id.exo_progress);
        if (timelineBar instanceof androidx.media3.ui.DefaultTimeBar) {
            androidx.media3.ui.DefaultTimeBar bar = (androidx.media3.ui.DefaultTimeBar) timelineBar;
            bar.setPlayedColor(ACCENT); bar.setScrubberColor(ACCENT); bar.setBufferedColor(LINE); bar.setUnplayedColor(0x66f4efe7);
        }
        frame.addView(playerView, new FrameLayout.LayoutParams(-1, -1));
        playerView.setOnClickListener(view -> togglePreview());
        emptyPreview = text("选择视频，开始剪辑", 15, Color.WHITE); emptyPreview.setGravity(Gravity.CENTER);
        frame.addView(emptyPreview, new FrameLayout.LayoutParams(-1, -1)); body.addView(frame);
        sourceName = text("手机本地视频", 13, MUTED); sourceName.setSingleLine(true);
        sourceName.setEllipsize(android.text.TextUtils.TruncateAt.MIDDLE);
        LinearLayout.LayoutParams sourceParams = new LinearLayout.LayoutParams(-1, -2);
        sourceParams.topMargin = dp(8); sourceParams.bottomMargin = dp(16);
        sourceActions = row(); sourceActions.setGravity(Gravity.CENTER_VERTICAL);
        sourceActions.addView(sourceName, new LinearLayout.LayoutParams(0, -2, 1));
        body.addView(sourceActions, sourceParams);
        LinearLayout trimHeading = row(); trimHeading.setGravity(Gravity.CENTER_VERTICAL);
        TextView clipTitle = text("截取片段", 18, INK); clipTitle.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        trimHeading.addView(clipTitle, new LinearLayout.LayoutParams(0, -2, 1));
        playSelection = button("播放片段", this::togglePreview); playSelection.setTextColor(ACCENT);
        trimHeading.addView(playSelection, new LinearLayout.LayoutParams(-2, -2)); body.addView(trimHeading);
        TextView subtitle = text("拖动时间轴两端；下方滑条可精确调整", 12, MUTED);
        LinearLayout.LayoutParams subtitleParams = new LinearLayout.LayoutParams(-1, -2);
        subtitleParams.topMargin = dp(8); subtitleParams.bottomMargin = dp(16); body.addView(subtitle, subtitleParams);
        body.addView(divider(), new LinearLayout.LayoutParams(-1, dp(1)));
        strip = new TimelineStrip(); LinearLayout.LayoutParams stripParams = new LinearLayout.LayoutParams(-1, dp(80));
        stripParams.topMargin = dp(16); stripParams.bottomMargin = dp(8); body.addView(strip, stripParams);
        range = text("起点 --:--  ·  终点 --:--", 13, INK); range.setGravity(Gravity.CENTER); body.addView(range);
        preciseControls = column(); preciseControls.setVisibility(View.GONE);
        fineToggle = button("精确调整", () -> {
            boolean show = preciseControls.getVisibility() != View.VISIBLE;
            preciseControls.setVisibility(show ? View.VISIBLE : View.GONE);
            fineToggle.setText(show ? "收起精确调整" : "精确调整");
            fineToggle.setSelected(show);
        });
        fineToggle.setTextColor(ACCENT); fineToggle.setBackgroundColor(Color.TRANSPARENT);
        body.addView(fineToggle, new LinearLayout.LayoutParams(-1, -2));
        body.addView(preciseControls);
        start = slider("片段起点", preciseControls); end = slider("片段终点", preciseControls); end.setProgress(10000);
        start.setOnSeekBarChangeListener(rangeListener(true)); end.setOnSeekBarChangeListener(rangeListener(false));
        mute = tool("保留原声", () -> { muted = !muted; updateTools(); if (player != null) player.setVolume(muted ? 0 : 1); });
        filter = tool("原色", () -> { grayscale = !grayscale; updateTools(); applyPreview(); });
        rotate = tool("旋转 0°", () -> { rotation = (rotation + 90) % 360; updateTools(); applyPreview(); });
        reset = tool("重置", () -> { startMs = 0; endMs = durationMs; muted = grayscale = false; rotation = 0; syncRange(); updateTools(); applyPreview(); });
        LinearLayout tools = column(); tools.setPadding(0, dp(16), 0, dp(16));
        Button[] editingTools = {mute, filter, rotate, reset};
        for (int i = 0; i < editingTools.length; i += 2) {
            LinearLayout pair = row(); pair.setBaselineAligned(false); pair.setGravity(Gravity.CENTER_VERTICAL);
            for (int j = 0; j < 2; j++) {
                LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(0, -2, 1);
                if (j == 0) p.rightMargin = dp(8); pair.addView(editingTools[i + j], p);
            }
            LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(-1, -2);
            if (i > 0) p.topMargin = dp(8); tools.addView(pair, p);
        }
        body.addView(tools);
        body = outerBody;
        status = text("选择后进入剪辑，原视频保留", 13, MUTED);
        status.setGravity(Gravity.CENTER); body.addView(status);
        progress = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        progress.setMax(100); progress.setProgressTintList(ColorStateList.valueOf(ACCENT)); progress.setVisibility(View.GONE);
        LinearLayout.LayoutParams progressParams = new LinearLayout.LayoutParams(-1, dp(4));
        progressParams.topMargin = dp(8); body.addView(progress, progressParams);
        cancel = button("取消导出", this::cancelCurrentTask); cancel.setVisibility(View.GONE);
        LinearLayout.LayoutParams cancelParams = new LinearLayout.LayoutParams(-1, -2);
        cancelParams.topMargin = dp(8); body.addView(cancel, cancelParams);
        completion = column(); completion.setPadding(dp(16), dp(16), dp(16), dp(16));
        GradientDrawable completedBackground = round(PAPER, 10); completedBackground.setStroke(dp(1), LINE);
        completion.setBackground(completedBackground); completion.setVisibility(View.GONE);
        TextView done = text("剪辑已保存", 20, INK); done.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL)); completion.addView(done);
        TextView doneHint = text("新视频已加入手机相册，原视频保留", 12, MUTED); completion.addView(doneHint);
        openResult = button("查看视频", () -> { if (savedResult != null) openSaved(savedResult); });
        openResult.setTextColor(PAPER); openResult.setBackground(round(ACCENT, 10));
        LinearLayout.LayoutParams resultParams = new LinearLayout.LayoutParams(-1, -2); resultParams.topMargin = dp(12);
        completion.addView(openResult, resultParams);
        completion.addView(button("继续剪辑", () -> completion.setVisibility(View.GONE)));
        LinearLayout.LayoutParams completionParams = new LinearLayout.LayoutParams(-1, -2); completionParams.topMargin = dp(16);
        body.addView(completion, completionParams);
        TextView hint = text("导出时请保持本页在前台", 12, MUTED); editorHint = hint;
        hint.setGravity(Gravity.CENTER); hint.setLineSpacing(dp(4), 1);
        LinearLayout.LayoutParams hintParams = new LinearLayout.LayoutParams(-1, -2);
        hintParams.topMargin = dp(16); body.addView(hint, hintParams);
        setContentView(root); updateEnabled();
        try {
            session = VideoEditSession.open(getCacheDir(), state == null ? null : state.getString("edit_session"));
            worker.execute(() -> { try { session.cleanStale(); } catch (IOException ignored) {} });
            restoreSource(state);
            if (state != null && state.containsKey("edit_pending_uri")) {
                String stagedName = state.getString("edit_pending_staged");
                File staged = stagedName == null ? null : stagedSource(this,
                        new Intent().putExtra(STAGED_SOURCE, stagedName));
                Uri requested = Uri.parse(state.getString("edit_pending_uri"));
                if (staged != null || "content".equals(requested.getScheme()))
                    importVideo(requested, staged, state.getString("edit_pending_name"));
            } else if (state == null) {
                File staged = stagedSource(this, getIntent());
                if (staged != null) importVideo(Uri.fromFile(staged), staged, getIntent().getStringExtra(SOURCE_NAME));
                else if (getIntent().getData() != null) {
                    Uri requested = getIntent().getData();
                    if ("content".equals(requested.getScheme())) importVideo(requested);
                    else status.setText("请选择手机文件选择器中的视频");
                }
            }
            updateEnabled();
        } catch (IOException error) { status.setText(message(error)); updateEnabled(); }
        if (android.os.Build.VERSION.SDK_INT >= 33)
            getOnBackInvokedDispatcher().registerOnBackInvokedCallback(android.window.OnBackInvokedDispatcher.PRIORITY_DEFAULT, this::finish);
    }

    private SeekBar slider(String name, LinearLayout parent) {
        TextView label = text(name, 12, MUTED);
        LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(-1, -2);
        labelParams.topMargin = dp(16); parent.addView(label, labelParams);
        SeekBar bar = new SeekBar(this); bar.setMax(10000); bar.setContentDescription(name);
        bar.setProgressTintList(ColorStateList.valueOf(ACCENT)); bar.setThumbTintList(ColorStateList.valueOf(ACCENT));
        bar.setProgressBackgroundTintList(ColorStateList.valueOf(LINE));
        parent.addView(bar, new LinearLayout.LayoutParams(-1, dp(48))); return bar;
    }
    private SeekBar.OnSeekBarChangeListener rangeListener(boolean first) {
        return new SeekBar.OnSeekBarChangeListener() {
            @Override public void onStartTrackingTouch(SeekBar bar) { pausePreview(); }
            @Override public void onProgressChanged(SeekBar bar, int p, boolean user) {
                if (!user || durationMs == 0) return;
                long value = VideoEditPlan.timeAt(p, durationMs);
                if (first) startMs = VideoEditPlan.boundary(true, value, durationMs, startMs, endMs);
                else endMs = VideoEditPlan.boundary(false, value, durationMs, startMs, endMs);
                syncRange();
            }
            @Override public void onStopTrackingTouch(SeekBar bar) { applyPreview(); }
        };
    }
    private void syncRange() {
        if (durationMs < VideoEditPlan.MIN_CLIP_MS) return;
        start.setProgress((int) Math.round(startMs * 10000.0 / durationMs));
        end.setProgress((int) Math.round(endMs * 10000.0 / durationMs));
        range.setText("起点 " + time(startMs) + "  ·  终点 " + time(endMs) + "  ·  保留 " + time(endMs - startMs));
        strip.invalidate();
    }
    private void updateTools() {
        mute.setText(muted ? "已静音" : "保留原声"); filter.setText(grayscale ? "黑白" : "原色"); rotate.setText("旋转 " + rotation + "°");
        styleTool(mute, muted); styleTool(filter, grayscale); styleTool(rotate, rotation != 0);
        if (playSelection != null) playSelection.setText(previewPlaying ? "暂停预览" : "播放片段");
    }
    private void styleTool(Button view, boolean selected) {
        view.setSelected(selected); view.setTextColor(selected ? PAPER : INK);
        GradientDrawable surface = round(selected ? ACCENT : PAPER, 10); surface.setStroke(dp(1), selected ? ACCENT : LINE);
        view.setBackground(surface);
    }
    private void pausePreview() {
        previewPlaying = false;
        if (player != null) player.pause();
        updateTools();
    }
    private void togglePreview() {
        if (sourceFile == null || loading || exporting) return;
        if (player == null) applyPreview();
        if (player == null) return;
        previewPlaying = !player.isPlaying();
        player.setPlayWhenReady(previewPlaying); updateTools();
    }
    private void updateEnabled() {
        boolean ready = sourceFile != null && !loading && !exporting;
        for (View view : new View[]{start, end, strip, playSelection, mute, filter, rotate, reset, export, fineToggle}) {
            view.setEnabled(ready); view.setAlpha(ready ? 1 : 0.4f);
        }
        boolean hasSource = sourceFile != null;
        editorPanel.setVisibility(hasSource ? View.VISIBLE : View.GONE);
        selectionIntro.setVisibility(hasSource ? View.GONE : View.VISIBLE);
        heading.setText(hasSource ? "剪辑" : "选择素材");
        editorHint.setVisibility(hasSource ? View.VISIBLE : View.GONE);
        export.setVisibility(hasSource ? View.VISIBLE : View.INVISIBLE);
        choose.setEnabled(session != null && !loading && !exporting); cancel.setVisibility(loading || exporting ? View.VISIBLE : View.GONE);
        cancel.setText(loading ? "取消读取" : "取消导出");
        ViewGroup chooseParent = (ViewGroup) choose.getParent();
        LinearLayout destination = hasSource ? sourceActions : selectionBody;
        if (chooseParent != destination) {
            if (chooseParent != null) chooseParent.removeView(choose);
            LinearLayout.LayoutParams position = new LinearLayout.LayoutParams(hasSource ? -2 : -1, -2);
            if (hasSource) { position.leftMargin = dp(8); destination.addView(choose, position); }
            else { position.bottomMargin = dp(20); destination.addView(choose, 1, position); }
        }
        choose.setText(hasSource ? "更换" : "从手机选择视频");
        choose.setContentDescription(hasSource ? "更换视频" : "从手机选择视频");
        choose.setTextSize(hasSource ? 13 : 14);
        choose.setTextColor(hasSource ? ACCENT : Color.WHITE);
        choose.setBackground(hasSource ? round(PAPER, 10) : round(ACCENT, 12));
    }
    private void pick() {
        if (loading || exporting) return;
        if (session == null) { status.setText("剪辑缓存尚未准备好，请重新打开剪辑"); return; }
        status.setText("请选择一段视频，选好后会自动进入剪辑");
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT).addCategory(Intent.CATEGORY_OPENABLE).setType("video/*")
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        try { startActivityForResult(intent, PICK_VIDEO); }
        catch (RuntimeException error) { status.setText("手机没有可用的视频选择器"); }
    }
    @Override protected void onActivityResult(int request, int result, Intent data) {
        super.onActivityResult(request, result, data);
        if (request != PICK_VIDEO) return;
        if (result != RESULT_OK || data == null || data.getData() == null) {
            status.setText(sourceFile == null ? "尚未选择视频，点击上方按钮继续" : "已保留当前剪辑素材"); return;
        }
        Uri uri = data.getData();
        if (!"content".equals(uri.getScheme())) { status.setText("请选择手机文件选择器中的视频"); return; }
        importVideo(uri);
    }
    private void importVideo(Uri uri) { importVideo(uri, null, null); }
    private void importVideo(Uri uri, File staged, String providedName) {
        if (loading || exporting || destroyed) return;
        importCancelled.set(false);
        pendingImportUri = uri; pendingImportName = providedName;
        if (staged != null) stagedImport = staged;
        loading = true; updateEnabled(); releasePlayer();
        completion.setVisibility(View.GONE); savedResult = null; previewPlaying = false;
        status.setText("正在读取视频…"); progress.setIndeterminate(true); progress.setVisibility(View.VISIBLE);
        worker.execute(() -> {
            File imported = null; List<Bitmap> frames = new ArrayList<>();
            try {
                String displayName = providedName == null || providedName.trim().isEmpty() ? importedName(uri) : providedName;
                importStream = staged == null ? getContentResolver().openInputStream(uri) : new FileInputStream(staged);
                imported = LocalVideoFiles.importVideo(importStream, session.directory, importCancelled::get);
                importStream = null;
                long duration;
                try (MediaMetadataRetriever reader = new MediaMetadataRetriever()) {
                    reader.setDataSource(imported.getAbsolutePath());
                    String raw = reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
                    String hasVideo = reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO);
                    duration = raw == null ? 0 : Long.parseLong(raw);
                    if (!"yes".equals(hasVideo) || duration < VideoEditPlan.MIN_CLIP_MS)
                        throw new IOException("所选文件没有可剪辑的视频轨道");
                    for (int i = 0; i < 6 && !importCancelled.get(); i++) {
                        Bitmap frame = reader.getScaledFrameAtTime(Math.min(duration - 1, duration * i / 6) * 1000,
                                MediaMetadataRetriever.OPTION_CLOSEST_SYNC, 192, 108);
                        if (frame != null) frames.add(frame);
                    }
                }
                if (importCancelled.get()) throw new IOException("读取已取消");
                File ready = imported; List<Bitmap> readyFrames = frames; long readyDuration = duration;
                handler.post(() -> {
                    if (destroyed) { ready.delete(); recycle(readyFrames); return; }
                    pendingImportUri = null; pendingImportName = null;
                    releaseStagedImport();
                    if (importCancelled.get()) {
                        ready.delete(); recycle(readyFrames); loading = false; progress.setVisibility(View.GONE);
                        status.setText("读取已取消，原视频保留"); updateEnabled(); if (sourceFile != null) applyPreview(); return;
                    }
                    if (sourceFile != null) sourceFile.delete(); sourceFile = ready;
                    strip.replace(readyFrames); durationMs = readyDuration; startMs = 0; endMs = durationMs;
                    rotation = 0; muted = grayscale = false; loading = false;
                    sourceDisplayName = displayName;
                    sourceName.setText(sourceDisplayName + "  ·  " + time(durationMs)); progress.setVisibility(View.GONE);
                    status.setText("调整片段范围，然后点击右上角导出");
                    syncRange(); updateTools(); updateEnabled(); applyPreview();
                });
                imported = null; frames = new ArrayList<>();
            } catch (Exception error) {
                handler.post(() -> { if (!destroyed) {
                    loading = false; pendingImportUri = null; pendingImportName = null;
                    releaseStagedImport(); progress.setVisibility(View.GONE);
                    status.setText(importCancelled.get() ? "读取已取消，原视频保留" : "无法读取视频：" + message(error));
                    updateEnabled(); if (sourceFile != null) applyPreview();
                }});
            } finally { importStream = null; if (imported != null) imported.delete(); recycle(frames); }
        });
    }
    private void releaseStagedImport() {
        // A saved Bundle may still resume this exact file after this callback.
        if (!savedPendingImport && stagedImport != null) { stagedImport.delete(); stagedImport = null; }
    }
    private void cancelCurrentTask() {
        if (loading) {
            pendingImportUri = null; pendingImportName = null;
            importCancelled.set(true); status.setText("正在取消读取…");
            InputStream input = importStream;
            if (input != null) try { input.close(); } catch (IOException ignored) { }
        } else cancelExport("导出已取消，可以调整后重试");
    }
    private String importedName(Uri uri) {
        try (android.database.Cursor row = getContentResolver().query(uri,
                new String[]{android.provider.OpenableColumns.DISPLAY_NAME}, null, null, null)) {
            if (row != null && row.moveToFirst() && !row.isNull(0)) {
                String name = row.getString(0);
                if (!name.trim().isEmpty()) return name;
            }
        } catch (RuntimeException ignored) { }
        return "已导入视频";
    }
    private VideoEditPlan plan() { return new VideoEditPlan(durationMs, startMs, endMs, muted, grayscale, rotation); }
    private void applyPreview() {
        if (sourceFile == null || destroyed || exporting || loading || !foreground) return;
        releasePlayer();
        try {
            VideoEditPlan plan = plan(); player = new ExoPlayer.Builder(this).build(); playerView.setPlayer(player);
            ExoPlayer preview = player;
            player.setVideoEffects(VideoEditMedia.effects(plan)); player.setMediaItem(VideoEditMedia.source(Uri.fromFile(sourceFile), plan));
            player.setVolume(muted ? 0 : 1); player.setRepeatMode(Player.REPEAT_MODE_ONE);
            player.addListener(new Player.Listener() {
                @Override public void onIsPlayingChanged(boolean isPlaying) {
                    if (player != preview || destroyed) return;
                    previewPlaying = isPlaying; updateTools();
                }
                @Override public void onRenderedFirstFrame() {
                    if (player == preview && !destroyed) playerView.setContentDescription("视频预览，首帧已显示");
                }
                @Override public void onPlayerError(androidx.media3.common.PlaybackException error) {
                    if (player != preview || destroyed) return;
                    status.setText("手机暂时无法预览此视频，可调整后尝试导出：" + message(error));
                }
            });
            playerView.setContentDescription("正在准备片段预览");
            playerView.setVisibility(View.VISIBLE); emptyPreview.setVisibility(View.GONE);
            player.setPlayWhenReady(previewPlaying); player.prepare();
        } catch (RuntimeException error) { status.setText("预览失败：" + message(error)); releasePlayer(); }
    }

    private void export() {
        if (sourceFile == null || loading || exporting || !foreground) return;
        VideoEditPlan selected = plan();
        completion.setVisibility(View.GONE); savedResult = null; previewPlaying = false;
        releasePlayer(); exporting = true; exportToken = new AtomicBoolean(); AtomicBoolean token = exportToken;
        updateEnabled(); progress.setIndeterminate(true); progress.setVisibility(View.VISIBLE); status.setText("准备导出…");
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        try {
            if (getCacheDir().getUsableSpace() < 64L * 1024 * 1024) throw new IOException("手机剩余空间不足");
            exportFile = File.createTempFile("edit-output-", ".mp4", session.directory); File output = exportFile;
            transformer = new Transformer.Builder(this).setVideoMimeType(MimeTypes.VIDEO_H264).setAudioMimeType(MimeTypes.AUDIO_AAC)
                    .addListener(new Transformer.Listener() {
                        @Override public void onCompleted(Composition composition, ExportResult result) {
                            if (destroyed || exportToken != token) return;
                            transformer = null; handler.removeCallbacks(exportProgress); status.setText("正在保存到手机相册…");
                            progress.setIndeterminate(true);
                            worker.execute(() -> {
                                try {
                                    if (result.videoFrameCount <= 0 || output.length() <= 0) throw new IOException("导出结果没有视频画面");
                                    Uri saved = LocalVideoFiles.publish(getContentResolver(), output, token::get);
                                    handler.post(() -> { if (!destroyed && exportToken == token) {
                                        finishExport(); status.setText("已保存到相册 Movies/YI4K/Edited");
                                        savedResult = saved; completion.setVisibility(View.VISIBLE);
                                        completion.post(() -> completion.requestRectangleOnScreen(
                                                new Rect(0, 0, completion.getWidth(), completion.getHeight()), false));
                                    }});
                                } catch (Exception error) { handler.post(() -> { if (!destroyed && exportToken == token) {
                                    finishExport(); status.setText("保存失败：" + message(error));
                                }}); } finally { output.delete(); }
                            });
                        }
                        @Override public void onError(Composition composition, ExportResult result, ExportException error) {
                            if (destroyed || exportToken != token) return;
                            cancelExport("导出失败：" + message(error));
                        }
                    }).build();
            transformer.start(VideoEditMedia.edited(Uri.fromFile(sourceFile), selected), output.getAbsolutePath());
            handler.post(exportProgress);
        } catch (Exception error) { cancelExport("无法导出：" + message(error)); }
    }
    private void openSaved(Uri saved) {
        try { startActivity(new Intent(Intent.ACTION_VIEW).setDataAndType(saved, "video/mp4").addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)); }
        catch (RuntimeException error) { Toast.makeText(this, "请在手机相册中查看剪辑视频", Toast.LENGTH_LONG).show(); }
    }
    private void finishExport() {
        exportToken = null; transformer = null; exportFile = null; exporting = false;
        handler.removeCallbacks(exportProgress); progress.setVisibility(View.GONE); updateEnabled();
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); applyPreview();
    }
    private void cancelExport(String reason) {
        if (exportToken != null) exportToken.set(true); exportToken = null;
        if (transformer != null) { transformer.cancel(); transformer = null; }
        File incomplete = exportFile; exportFile = null;
        if (incomplete != null) worker.execute(incomplete::delete);
        exporting = false; handler.removeCallbacks(exportProgress);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        if (!destroyed && progress != null) { progress.setVisibility(View.GONE); status.setText(reason); updateEnabled(); applyPreview(); }
    }
    private void releasePlayer() {
        ExoPlayer previous = player; player = null;
        if (previous != null) { playerView.setPlayer(null); previous.release(); }
    }
    @Override protected void onPause() { pausePreview(); super.onPause(); }
    @Override protected void onSaveInstanceState(Bundle state) {
        if (session != null) state.putString("edit_session", session.id);
        if (loading && !importCancelled.get() && pendingImportUri != null) {
            savedPendingImport = true;
            state.putString("edit_pending_uri", pendingImportUri.toString());
            state.putString("edit_pending_name", pendingImportName);
            if (stagedImport != null) state.putString("edit_pending_staged", stagedImport.getName());
        }
        if (session != null && sourceFile != null && sourceFile.isFile()) {
            state.putString("edit_session", session.id); state.putString("edit_source", sourceFile.getName());
            state.putString("edit_display_name", sourceDisplayName);
            state.putLong("edit_duration", durationMs); state.putLong("edit_start", startMs); state.putLong("edit_end", endMs);
            state.putBoolean("edit_muted", muted); state.putBoolean("edit_grayscale", grayscale); state.putInt("edit_rotation", rotation);
        }
        super.onSaveInstanceState(state);
    }
    private void restoreSource(Bundle state) throws IOException {
        if (state == null || !state.containsKey("edit_source")) return;
        String name = state.getString("edit_source", "");
        if (!name.matches("edit-source-[0-9]+\\.mp4")) return;
        File candidate = new File(session.directory, name).getCanonicalFile();
        if (!candidate.getParentFile().equals(session.directory.getCanonicalFile()) || !candidate.isFile() || candidate.length() == 0) return;
        try {
            VideoEditPlan saved = new VideoEditPlan(state.getLong("edit_duration"), state.getLong("edit_start"), state.getLong("edit_end"),
                    state.getBoolean("edit_muted"), state.getBoolean("edit_grayscale"), state.getInt("edit_rotation"));
            sourceFile = candidate; durationMs = saved.durationMs; startMs = saved.startMs; endMs = saved.endMs;
            muted = saved.muted; grayscale = saved.grayscale; rotation = saved.rotation;
            sourceDisplayName = state.getString("edit_display_name", "已导入视频");
            sourceName.setText(sourceDisplayName + "  ·  " + time(durationMs)); status.setText("已恢复剪辑，导出任务如有中断可重新开始");
            syncRange(); updateTools(); updateEnabled();
            worker.execute(() -> {
                List<Bitmap> frames = new ArrayList<>();
                try (MediaMetadataRetriever reader = new MediaMetadataRetriever()) {
                    reader.setDataSource(candidate.getAbsolutePath());
                    for (int i = 0; i < 6 && !importCancelled.get(); i++) {
                        Bitmap frame = reader.getScaledFrameAtTime(Math.min(saved.durationMs - 1, saved.durationMs * i / 6) * 1000,
                                MediaMetadataRetriever.OPTION_CLOSEST_SYNC, 192, 108);
                        if (frame != null) frames.add(frame);
                    }
                } catch (Exception ignored) {}
                handler.post(() -> { if (destroyed || sourceFile != candidate) recycle(frames); else strip.replace(frames); });
            });
        } catch (IllegalArgumentException invalid) { status.setText("上次剪辑状态无效，请重新选择视频"); }
    }
    @Override protected void onStart() {
        super.onStart(); foreground = true;
        savedPendingImport = false;
        if (!loading) releaseStagedImport();
        applyPreview();
    }
    @Override protected void onStop() {
        foreground = false;
        if (exporting) cancelExport("已离开剪辑页面，导出已取消；返回后可以重试");
        releasePlayer();
        super.onStop();
    }
    @Override protected void onDestroy() {
        destroyed = true; importCancelled.set(true); cancelExport(""); releasePlayer();
        InputStream input = importStream; if (input != null) try { input.close(); } catch (IOException ignored) {}
        sourceFile = null;
        boolean preserve = isChangingConfigurations();
        if (!preserve) {
            savedPendingImport = false; releaseStagedImport();
            discardPreparedVideo(this, getIntent());
        }
        if (session != null) worker.execute(() -> session.close(preserve));
        strip.replace(new ArrayList<>()); worker.shutdown(); super.onDestroy();
    }

    private final class TimelineStrip extends View {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG);
        private List<Bitmap> frames = new ArrayList<>();
        private boolean dragStart;
        TimelineStrip() {
            super(VideoEditorActivity.this); setContentDescription("视频时间轴，可拖动左右边缘调整片段；也可使用下方起点终点滑条");
            setBackground(round(LINE, 12)); setClipToOutline(true); setClickable(true);
        }
        void replace(List<Bitmap> values) { recycle(frames); frames = values; invalidate(); }
        @Override public boolean onTouchEvent(MotionEvent event) {
            if (!isEnabled() || durationMs < VideoEditPlan.MIN_CLIP_MS || loading || exporting || getWidth() <= 0) return false;
            if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
                float left = getWidth() * startMs / (float) durationMs, right = getWidth() * endMs / (float) durationMs;
                dragStart = Math.abs(event.getX() - left) <= Math.abs(event.getX() - right);
                getParent().requestDisallowInterceptTouchEvent(true); pausePreview();
            } else if (event.getActionMasked() == MotionEvent.ACTION_CANCEL) {
                getParent().requestDisallowInterceptTouchEvent(false); applyPreview(); return true;
            }
            if (event.getActionMasked() == MotionEvent.ACTION_DOWN || event.getActionMasked() == MotionEvent.ACTION_MOVE
                    || event.getActionMasked() == MotionEvent.ACTION_UP) {
                int progress = Math.round(Math.max(0f, Math.min(1f, event.getX() / getWidth())) * 10000f);
                long requested = VideoEditPlan.timeAt(progress, durationMs);
                if (dragStart) startMs = VideoEditPlan.boundary(true, requested, durationMs, startMs, endMs);
                else endMs = VideoEditPlan.boundary(false, requested, durationMs, startMs, endMs);
                syncRange();
                if (event.getActionMasked() == MotionEvent.ACTION_UP) {
                    getParent().requestDisallowInterceptTouchEvent(false); performClick(); applyPreview();
                }
                return true;
            }
            return true;
        }
        @Override public boolean performClick() { super.performClick(); return true; }
        @Override protected void onDraw(Canvas canvas) {
            super.onDraw(canvas);
            for (int i = 0; i < frames.size(); i++) {
                Bitmap b = frames.get(i); Rect source = new Rect(0, 0, b.getWidth(), b.getHeight());
                Rect target = new Rect(i * getWidth() / frames.size(), 0, (i + 1) * getWidth() / frames.size(), getHeight());
                canvas.drawBitmap(b, source, target, paint);
            }
            if (durationMs <= 0) {
                paint.setStyle(Paint.Style.FILL); paint.setColor(MUTED); paint.setTextSize(dp(12)); paint.setTextAlign(Paint.Align.CENTER);
                canvas.drawText("视频缩略图时间轴", getWidth() / 2f, getHeight() / 2f + dp(4), paint); return;
            }
            float left = (float) (getWidth() * startMs / (double) durationMs), right = (float) (getWidth() * endMs / (double) durationMs);
            paint.setColor(0x99000000); paint.setStyle(Paint.Style.FILL);
            canvas.drawRect(0, 0, left, getHeight(), paint); canvas.drawRect(right, 0, getWidth(), getHeight(), paint);
            paint.setColor(ACCENT); paint.setStrokeWidth(dp(3)); paint.setStyle(Paint.Style.STROKE);
            canvas.drawRect(left + dp(1), dp(1), right - dp(1), getHeight() - dp(1), paint); paint.setStyle(Paint.Style.FILL);
            float handle = dp(7);
            canvas.drawRoundRect(left, 0, Math.min(right, left + handle), getHeight(), dp(3), dp(3), paint);
            canvas.drawRoundRect(Math.max(left, right - handle), 0, right, getHeight(), dp(3), dp(3), paint);
            paint.setColor(Color.WHITE); paint.setStrokeWidth(dp(1));
            canvas.drawLine(left + handle / 2, getHeight() * .36f, left + handle / 2, getHeight() * .64f, paint);
            canvas.drawLine(right - handle / 2, getHeight() * .36f, right - handle / 2, getHeight() * .64f, paint);
        }
    }
    private static void recycle(List<Bitmap> frames) { for (Bitmap b : frames) if (b != null && !b.isRecycled()) b.recycle(); }
    static String time(long ms) {
        return String.format(Locale.CHINA, "%02d:%02d.%01d", ms / 60000, ms / 1000 % 60, ms / 100 % 10);
    }
    private static String message(Exception error) { return error.getMessage() == null ? error.getClass().getSimpleName() : error.getMessage(); }
    private LinearLayout column() { LinearLayout view = new LinearLayout(this); view.setOrientation(LinearLayout.VERTICAL); return view; }
    private LinearLayout row() { return new LinearLayout(this); }
    private TextView text(String value, int size, int color) { TextView view = new TextView(this); view.setText(value); view.setTextSize(size); view.setTextColor(color); view.setIncludeFontPadding(false); view.setLineSpacing(dp(4), 1); return view; }
    private Button button(String value, Runnable action) {
        Button view = new Button(this); view.setText(value); view.setAllCaps(false); view.setTextColor(INK); view.setTextSize(14);
        view.setMinWidth(0); view.setMinimumWidth(0); view.setMinHeight(dp(48)); view.setMinimumHeight(dp(48));
        view.setGravity(Gravity.CENTER); view.setIncludeFontPadding(false); view.setPadding(dp(8), dp(8), dp(8), dp(8));
        view.setStateListAnimator(null);
        GradientDrawable background = round(PAPER, 10); background.setStroke(dp(1), LINE); view.setBackground(background);
        view.setOnClickListener(v -> action.run()); return view;
    }
    private Button tool(String value, Runnable action) { return button(value, action); }
    private View divider() { View view = new View(this); view.setBackgroundColor(LINE); return view; }
    private GradientDrawable round(int color, int radius) { GradientDrawable shape = new GradientDrawable(); shape.setColor(color); shape.setCornerRadius(dp(radius)); return shape; }
    private int dp(int value) { return Math.round(value * getResources().getDisplayMetrics().density); }
}
