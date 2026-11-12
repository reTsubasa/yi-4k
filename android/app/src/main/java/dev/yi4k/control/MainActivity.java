package dev.yi4k.control;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.Canvas;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.drawable.GradientDrawable;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Shader;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.view.View;
import android.view.ViewGroup;
import android.view.Gravity;
import android.view.PixelCopy;
import android.view.SurfaceView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;


public class MainActivity extends Activity {
    /** Product accent used consistently for active controls, tags, and actions. */
    private static final int ACCENT = AppPalette.ACCENT;
    private static final int DANGER = Color.rgb(255, 59, 48);
    private final ExecutorService commands = Executors.newSingleThreadExecutor();
    private final ExecutorService downloads = Executors.newSingleThreadExecutor();
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final AtomicBoolean busy = new AtomicBoolean(), exporting = new AtomicBoolean(), exportCancelled = new AtomicBoolean();
    private final java.util.concurrent.atomic.AtomicLong connectionGeneration = new java.util.concurrent.atomic.AtomicLong();
    private final Object connectionLock = new Object();
    private final MediaExporter exporter = new MediaExporter();
    private final CameraClient camera = new CameraClient(event -> handler.post(() -> handleCameraEvent(event)));
    private volatile boolean destroyed;
    private volatile boolean foreground;
    private boolean previewStarting, previewAutoFailed;
    private int previewRetryCount;
    private final AtomicBoolean refreshing = new AtomicBoolean();
    private CameraWifiConnector wifiConnector;
    private LinearLayout wifiResults;
    private TextView wifiHint, cameraTitle;
    private CameraWifiConnector.CameraWifi selectedCandidate;
    /** Candidate used for the last successful Wi-Fi handoff; retained only as metadata. */
    private CameraWifiConnector.CameraWifi pendingWifiCandidate;
    private boolean initialAutoConnectPending = true;
    private boolean savedAutoConnectActive;
    private EditText wifiPassword;
    private CheckBox rememberWifi;
    private String settingsGroup = "", settingsQuery = "";
    private LinearLayout settingsList;
    private final Map<String, TextView> settingValues = new LinkedHashMap<>();
    private volatile Network network;
    private volatile String connectedHost = "192.168.42.1";
    private ConnectivityManager connectivity;
    private ConnectivityManager.NetworkCallback networkCallback;
    private Network selectedWifiNetwork;
    private EditText host;
    private TextView state, detail, message, operation, connectionStatus;
    private FrameLayout statusSlot;
    private FrameLayout monitorLayer;
    private LinearLayout captureParameterBar;
    private android.widget.HorizontalScrollView captureParameterScroll;
    private ScrollView monitorParameterScroll;
    private View captureDeviceBar;
    private TextView previewScale;
    private boolean previewFill = true;
    private android.widget.Toast feedbackToast;
    private Button connectButton, disconnectButton, cancelExport;
    private LinearLayout bottomNav;
    private LinearLayout captureActions;
    private View capturePreviewFrame;
    private Button navCapture, navMedia, navEdit, navSettings;
    private final ArrayList<MediaEntry> media = new ArrayList<>();
    private final Map<String, MediaEntry> selectedMedia = new LinkedHashMap<>();
    private LinearLayout content;
    private ScrollView scroll, captureActionScroll;
    private LinearLayout captureWorkspace;
    private View captureHeader, captureDivider;
    private boolean landscapeCapture;
    private LinearLayout captureModes;
    private String captureMode = "";
    private String cameraStatus = "";
    private int batteryPercent = -1;
    private int sdUsedPercent = -1;
    private CaptureAlbumFeedback captureAlbum;
    private MediaEntry captureAlbumEntry;
    private long albumLoadGeneration;
    private TextView deviceName, deviceWifiDot, deviceWifiQuality, deviceBattery, deviceCard, previewQuality, previewFov, previewStatus, previewRec;
    private TextView previewMonitor;
    private TextView previewParameters;
    private boolean monitorMode;
    private int monitorPreviousOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED;
    private final android.graphics.Rect monitorCutoutInsets = new android.graphics.Rect();
    private boolean optimisticPhotoFeedback;
    private Button primaryShutter;
    private View captureFlash;
    private final Map<String, TextView> captureParameters = new LinkedHashMap<>();
    private String mediaFilter = "all";
    private boolean mediaSelectionMode;
    private boolean mediaAutoLoadRequested, mediaLoading;
    private String mediaLoadError = "";
    private Button exportSelectedButton;
    private CameraMediaViewer mediaViewer;
    private CameraThumbnailStore thumbnails;
    private final ArrayList<android.widget.ImageView> thumbnailViews = new ArrayList<>();
    private final ArrayList<android.graphics.Bitmap> thumbnailBitmaps = new ArrayList<>();
    private CameraLivePreview livePreview;
    private FrameLayout previewSurface;
    private View previewArt;
    private volatile long previewGeneration;
    private String livePreviewStatus = "";
    private JSONObject settings = new JSONObject();
    private String folder = MediaEntry.DCIM_ROOT;
    private volatile String page = "control";
    private int connectionStep = 1;
    private boolean compactCaptureDock;
    private volatile boolean capturePending;
    private volatile int pendingCaptureRequest = -1;
    interface Work { void run() throws Exception; }

    @Override public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        connectivity = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        wifiConnector = new CameraWifiConnector(this);
        getWindow().setStatusBarColor(AppPalette.BACKGROUND);
        getWindow().setNavigationBarColor(AppPalette.BACKGROUND);
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR | View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
        LinearLayout root = column();
        root.setBackground(new PaperDrawable());
        root.setOnApplyWindowInsetsListener((view, insets) -> {
            view.setPadding(insets.getSystemWindowInsetLeft(), insets.getSystemWindowInsetTop(),
                    insets.getSystemWindowInsetRight(), insets.getSystemWindowInsetBottom());
            return insets;
        });
        String savedHost = getPreferences(MODE_PRIVATE).getString("camera_host", "192.168.42.1");
        host = new EditText(this); host.setSingleLine(true);
        host.setText(savedInstanceState == null ? savedHost : savedInstanceState.getString("host", savedHost));
        host.setHint("192.168.42.1"); host.setInputType(android.text.InputType.TYPE_CLASS_PHONE);
        host.setTextSize(16); host.setTextColor(Color.rgb(28, 28, 30)); host.setSingleLine(true);
        state = label("未连接", 18);
        detail = label("", 13);
        scroll = new CaptureScrollView(this); scroll.setFillViewport(true); scroll.setVerticalScrollBarEnabled(false); content = column();
        content.setPadding(dp(20), dp(18), dp(20), dp(12)); scroll.addView(content);
        captureWorkspace = new CaptureWorkspace(this);
        captureWorkspace.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1));
        captureActions = column(); captureActions.setVisibility(View.GONE);
        captureActions.setPadding(dp(16), 0, dp(16), 0);
        captureActionScroll = new ScrollView(this); captureActionScroll.setVerticalScrollBarEnabled(false);
        captureActionScroll.addView(captureActions); captureActionScroll.setVisibility(View.GONE);
        captureWorkspace.addView(captureActionScroll, new LinearLayout.LayoutParams(-1, -2));
        FrameLayout workspaceLayer = new FrameLayout(this);
        workspaceLayer.addView(captureWorkspace, new FrameLayout.LayoutParams(-1, -1));
        monitorLayer = new MonitorWorkspace(this); monitorLayer.setVisibility(View.GONE);
        workspaceLayer.addView(monitorLayer, new FrameLayout.LayoutParams(-1, -1));
        root.addView(workspaceLayer, new LinearLayout.LayoutParams(-1, 0, 1));
        operation = label("", 13); operation.setGravity(Gravity.CENTER); operation.setPadding(dp(16), dp(6), dp(16), dp(6));
        operation.setVisibility(View.GONE);
        cancelExport = button("取消导出", this::cancelExport); cancelExport.setVisibility(View.GONE);
        message = label("", 13); message.setTextIsSelectable(true); message.setMaxLines(3); message.setGravity(Gravity.CENTER);
        message.setVisibility(View.GONE);
        // Export progress belongs below the workspace; notices never cover the viewfinder.
        statusSlot = new FrameLayout(this); statusSlot.setVisibility(View.GONE);
        statusSlot.addView(operation, new FrameLayout.LayoutParams(-1, dp(48), Gravity.CENTER));
        statusSlot.addView(cancelExport, new FrameLayout.LayoutParams(dp(104), dp(48), Gravity.RIGHT));
        root.addView(statusSlot, new LinearLayout.LayoutParams(-1, dp(48)));
        bottomNav = createBottomNav(); root.addView(bottomNav, new LinearLayout.LayoutParams(-1, dp(68)));
        setContentView(root);
        // Every cold launch starts with connection discovery.
        drawConnection(1);
        if (android.os.Build.VERSION.SDK_INT >= 33)
            getOnBackInvokedDispatcher().registerOnBackInvokedCallback(android.window.OnBackInvokedDispatcher.PRIORITY_DEFAULT, this::navigateBack);
        networkCallback = new ConnectivityManager.NetworkCallback() {
            @Override public void onLost(Network lost) {
                final long lostGeneration;
                synchronized (connectionLock) {
                    if (!lost.equals(network) || destroyed) return;
                    lostGeneration = connectionGeneration.incrementAndGet();
                    network = null;
                    camera.close();
                    exportCancelled.set(true); exporter.cancel();
                }
                ui(() -> {
                    synchronized (connectionLock) {
                        if (lostGeneration != connectionGeneration.get()) return;
                        closeMediaViewer(); closeThumbnails(); closeLivePreview(); clearCameraViews("相机网络已断开"); note("相机连接已断开，可重新搜索附近的相机"); updateOperation();
                        if (!camera.isConnected() && !"connection".equals(page)) drawConnection(1);
                    }
                });
            }
        };
        connectivity.registerNetworkCallback(new android.net.NetworkRequest.Builder().addTransportType(NetworkCapabilities.TRANSPORT_WIFI).build(), networkCallback);
        handler.postDelayed(poll, 5000);
    }
    @Override public void onSaveInstanceState(Bundle bundle) {
        bundle.putString("host", host.getText().toString()); bundle.putString("page", page);
        bundle.putInt("connection_step", connectionStep); super.onSaveInstanceState(bundle);
    }
    @Override protected void onResume() {
        super.onResume();
        foreground = true;
        if (!destroyed && camera.isConnected()) { refreshQuietly(); schedulePreview(); }
    }
    @Override public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        if (captureWorkspace != null) {
            captureWorkspace.requestLayout();
            captureWorkspace.post(this::updateMonitorLayout);
        }
    }
    private final Runnable poll = new Runnable() {
        @Override public void run() {
            if (destroyed) return;
            if (foreground && camera.isConnected()) refreshQuietly();
            handler.postDelayed(this, 5000);
        }
    };
    private void refreshQuietly() {
        if (busy.get() || exporting.get() || !refreshing.compareAndSet(false, true)) return;
        commands.submit(() -> {
            try { if (camera.isConnected()) refresh(true); }
            catch (Exception error) { ui(() -> {
                if (!camera.isConnected()) { closeLivePreview(); clearCameraViews("连接已断开"); }
            }); }
            finally { refreshing.set(false); }
        });
    }
    private void schedulePreview() {
        handler.postDelayed(() -> {
            if (destroyed || !foreground || !"control".equals(page) || !camera.isConnected()
                    || previewStarting || livePreview != null || previewAutoFailed) return;
            if (busy.get() || exporting.get()) return;
            startLivePreview();
        }, 180);
    }
    private void connect() {
        final String address = host.getText().toString().trim();
        if (!validHost(address)) { note("请输入有效的 IPv4 相机地址"); return; }
        if (exporting.get()) { note("请等待当前导出完成"); return; }
        closeMediaViewer();
        closeThumbnails();
        closeLivePreview();
        work(() -> {
            final long attempt;
            synchronized (connectionLock) {
                if (destroyed) return;
                attempt = connectionGeneration.incrementAndGet();
                camera.disconnect(); network = wifiConnector.isConnected() ? selectedWifiNetwork : null;
            }
            ui(() -> clearCameraViews("正在连接…"));
            final javax.net.SocketFactory socketFactory;
            synchronized (connectionLock) {
                if (destroyed || attempt != connectionGeneration.get()) throw new java.io.IOException("连接已取消");
                socketFactory = cameraSocketFactory(address);
            }
            connectedHost = address;
            camera.connect(socketFactory, address, cameraApiPort());
            synchronized (connectionLock) {
                if (destroyed || attempt != connectionGeneration.get()) {
                    camera.close();
                    throw new java.io.IOException("相机网络已断开，请重新连接");
                }
            }
            rememberConnectedCamera(address);
            ui(() -> { media.clear(); selectedMedia.clear(); folder = MediaEntry.DCIM_ROOT; mediaAutoLoadRequested = false; mediaLoading = false; mediaLoadError = ""; });
            refresh(true); ui(() -> {
                if (attempt != connectionGeneration.get() || !camera.isConnected()) return;
                savedAutoConnectActive = false;
                try { thumbnails = new CameraThumbnailStore(this); }
                catch (java.io.IOException error) { note("缩略图缓存暂不可用：" + error.getMessage()); }
                note("连接成功");
                getPreferences(MODE_PRIVATE).edit().putBoolean("connection_guide_seen", true).apply();
                if (page.equals("connection")) { page = "control"; drawControl(); }
                else if (page.equals("media")) drawMedia();
            });
        });
    }
    protected int cameraApiPort() { return 7878; }
    protected int cameraHttpPort() { return 80; }
    protected javax.net.SocketFactory cameraSocketFactory(String address) throws Exception {
            if (selectedWifiNetwork != null && wifiConnector.isConnected()) { network = selectedWifiNetwork; return network.getSocketFactory(); }
            java.net.InetAddress targetAddress = java.net.InetAddress.getByName(address);
            Network fallback = null;
            for (Network candidate : connectivity.getAllNetworks()) {
                NetworkCapabilities capabilities = connectivity.getNetworkCapabilities(candidate);
                if (capabilities == null || !capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) continue;
                if (fallback == null) fallback = candidate;
                android.net.LinkProperties links = connectivity.getLinkProperties(candidate);
                if (links != null && links.getRoutes().stream().anyMatch(route -> !route.hasGateway() && route.matches(targetAddress))) {
                    network = candidate; break;
                }
            }
            if (network == null) network = fallback;
            if (network == null) throw new java.io.IOException("未找到 Wi-Fi，请先连接相机热点");
            return network.getSocketFactory();
    }
    private static boolean validHost(String value) {
        String[] parts = value.split("\\.", -1);
        if (parts.length != 4) return false;
        for (String p : parts) try { if (!p.matches("[0-9]{1,3}") || Integer.parseInt(p) > 255) return false; } catch (Exception e) { return false; }
        return true;
    }
    private void disconnect() {
        if (exporting.get()) { note("请等待当前导出完成"); return; }
        closeMediaViewer();
        closeThumbnails();
        closeLivePreview();
        wifiConnector.disconnect(); selectedWifiNetwork = null;
        work(() -> {
            synchronized (connectionLock) {
                connectionGeneration.incrementAndGet(); camera.disconnect(); network = null;
            }
            ui(() -> {
                clearCameraViews("未连接"); note("已断开");
                if (!camera.isConnected()) drawConnection(1);
            });
        });
    }
    private void refresh(boolean all) throws Exception {
        long generation = connectionGeneration.get();
        JSONObject current = camera.call(1, CameraClient.args("type", "app_status"));
        JSONObject snapshot = all ? CameraClient.flattenSettings(camera.call(3)) : null;
        JSONObject power = all ? camera.call(13) : null;
        int storage = sdUsedPercent;
        if (all) {
            if (snapshot != null && "insert".equals(snapshot.optString("sd_card_status"))) {
                try { storage = CameraStorage.readUsedPercent(camera); }
                catch (Exception unavailable) { /* Unknown capacity stays unknown; no fabricated percentage. */ }
            } else storage = -1;
        }
        final int cardUsed = storage;
        String status = current.optString("param");
        ui(() -> {
            if (generation != connectionGeneration.get() || !camera.isConnected()) return;
            boolean changed = snapshot != null && !snapshot.toString().equals(settings.toString());
            boolean membershipChanged = snapshot != null && !settingsMembership(settings).equals(settingsMembership(snapshot));
            if (snapshot != null) settings = snapshot;
            if (power != null) updateBattery(power);
            sdUsedPercent = cardUsed;
            cameraStatus = status;
            state.setText("已连接 · " + CameraSettings.displayValue("app_status", status));
            detail.setText(cameraModel() + " · " + CaptureParameters.resolution(settings)
                    + " · " + CaptureParameters.fps(settings));
            updateCaptureViews();
            if (all && changed && page.equals("settings")) {
                if (membershipChanged) { int position = scroll.getScrollY(); renderSettingsList(); scroll.post(() -> scroll.scrollTo(0, position)); }
                for (Map.Entry<String, TextView> row : settingValues.entrySet())
                    setTextIfChanged(row.getValue(), CaptureParameters.settingValue(settings, row.getKey()));
            }
        });
    }
    private static final int CAPTURE_BG = Color.rgb(15, 17, 21);
    private static final int CAPTURE_CARD = Color.rgb(29, 32, 38);
    private static final int CAPTURE_MUTED = Color.rgb(166, 171, 182);

    private void drawControl() {
        if (monitorMode) toggleMonitorMode();
        clearAlbumThumbnails();
        closeLivePreview();
        page = "control"; bottomNav.setVisibility(View.VISIBLE);
        captureActions.removeAllViews(); captureActions.setVisibility(View.VISIBLE);
        compactCaptureDock = false;
        monitorMode = false;
        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR | View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
        bottomNav.setVisibility(View.VISIBLE);
        content.removeAllViews();
        detach(state); detach(detail);
        captureParameters.clear();
        getWindow().setStatusBarColor(AppPalette.BACKGROUND);
        scroll.setBackground(new PaperDrawable()); content.setBackgroundColor(Color.TRANSPARENT);
        content.setPadding(dp(16), dp(14), dp(16), dp(18));

        cameraTitle = null; deviceName = null; captureHeader = null; captureDivider = null;
        captureDeviceBar = captureDeviceRow(); content.addView(captureDeviceBar);
        capturePreviewFrame = capturePreview(); content.addView(capturePreviewFrame);
        captureParameterBar = captureParameterRow();
        captureParameterScroll = new android.widget.HorizontalScrollView(this);
        captureParameterScroll.setHorizontalScrollBarEnabled(false); captureParameterScroll.setFillViewport(true);
        captureParameterScroll.addView(captureParameterBar, new FrameLayout.LayoutParams(-2, -2));
        content.addView(captureParameterScroll, new LinearLayout.LayoutParams(-1, -2));
        captureModes = row(); captureModes.setGravity(Gravity.CENTER); captureModes.setPadding(0, 0, 0, dp(4));
        captureModes.addView(modeButton("录像", "record"), weight());
        captureModes.addView(modeButton("照片", "capture"), weight());
        captureModes.addView(modeButton("延时", "timelapse"), weight());
        captureModes.addView(modeButton("慢动作", "slow_motion"), weight());
        LinearLayout shutterRow = row(); shutterRow.setGravity(Gravity.CENTER); shutterRow.setPadding(0, dp(6), 0, dp(2));
        if (captureAlbum != null) captureAlbum.close();
        captureAlbum = new CaptureAlbumFeedback(this);
        FrameLayout albumSide = new FrameLayout(this);
        android.widget.ImageView albumButton = captureAlbum.createButton(() -> { page = "media"; drawMedia(); });
        albumSide.addView(albumButton, new FrameLayout.LayoutParams(dp(48), dp(48), Gravity.CENTER));
        shutterRow.addView(albumSide, new LinearLayout.LayoutParams(0, dp(88), 1));
        primaryShutter = shutterButton(); shutterRow.addView(primaryShutter, new LinearLayout.LayoutParams(dp(88), dp(88)));
        shutterRow.addView(new View(this), new LinearLayout.LayoutParams(0, dp(88), 1));
        captureActions.addView(shutterRow);
        captureActions.addView(captureModes);
        updateCaptureViews(); selectNav(0); updateOperation(); previewAutoFailed = false; schedulePreview();
        loadCaptureAlbum(false, null);
    }

    private void drawConnection(int step) {
        if (monitorMode) toggleMonitorMode();
        clearAlbumThumbnails(); closeLivePreview();
        page = "connection"; connectionStep = 1; selectedCandidate = null; wifiPassword = null; rememberWifi = null;
        captureActions.setVisibility(View.GONE); bottomNav.setVisibility(View.GONE);
        content.removeAllViews(); detach(host); detach(state); detach(detail);
        getWindow().setStatusBarColor(AppPalette.BACKGROUND); scroll.setBackground(new PaperDrawable());
        content.setBackgroundColor(Color.TRANSPARENT); content.setPadding(dp(20), dp(18), dp(20), dp(20));
        content.addView(pageTitle("连接相机", ""));
        TextView connectionTitle = label("搜索附近相机", 20);
        connectionTitle.setTextColor(TEXT); connectionTitle.setTypeface(null, android.graphics.Typeface.BOLD);
        content.addView(connectionTitle);
        TextView connectionHint = label("开启相机 Wi-Fi，选择设备即可连接", 13);
        connectionHint.setTextColor(SECONDARY); content.addView(connectionHint);
        android.content.SharedPreferences saved = getPreferences(MODE_PRIVATE);
        String savedSsid = saved.getString("camera_saved_ssid", "");
        if (saved.getBoolean("camera_connection_saved", false) && !savedSsid.isEmpty()) {
            TextView remembered = label("已保存相机 · " + savedSsid, 14);
            remembered.setTextColor(TEXT); content.addView(remembered, spaced(-1, -2, 8));
            Button reconnect = textButton("连接已保存相机", false, () -> {
                initialAutoConnectPending = true;
                if (!attemptSavedCameraAutoConnect())
                    note("已保存的密码不可用，请从搜索结果选择相机并重新输入密码。");
            });
            content.addView(reconnect, spaced(-1, dp(44), 4));
        }
        CameraIllustration illustration = new CameraIllustration(this);
        content.addView(illustration, new LinearLayout.LayoutParams(-1, dp(150)));
        wifiHint = label("仅显示 YDXJ 开头的相机热点。首次连接需允许系统搜索附近设备。", 14);
        wifiHint.setTextColor(SECONDARY); wifiHint.setLineSpacing(dp(4), 1); content.addView(wifiHint);
        // Search starts as soon as the disconnected landing page is shown.
        // Keep a retry action available only after the first result/error so
        // the user never has to press a redundant “search” button on entry.
        connectButton = textButton("重新搜索", false, this::scanCameraWifi);
        connectButton.setVisibility(View.GONE);
        content.addView(connectButton, spaced(-1, dp(46), 12));
        wifiResults = column(); content.addView(wifiResults, spaced(-1, -2, 16));
        if (camera.isConnected()) {
            content.addView(label("已连接 · " + cameraModel(), 16));
            content.addView(actionButton("进入拍摄", ACCENT, this::drawControl), spaced(-1, dp(48), 8));
            disconnectButton = textButton("断开连接", false, this::disconnect);
            content.addView(disconnectButton, spaced(-1, dp(48), 8));
        }
        updateOperation(); scroll.scrollTo(0, 0);
        // On a cold launch, prefer a previously successful camera session when
        // Android already has the saved camera network. Manual navigation to
        // this page never retries it, so a failed auto-connect falls back to
        // the normal scan without creating a reconnect loop.
        content.post(() -> {
            if (!attemptSavedCameraAutoConnect()) scanCameraWifi();
        });
    }
    private void scanCameraWifi() {
        if (!"connection".equals(page) || connectionStep != 1) return;
        String[] missing = wifiConnector.missingPermissions();
        if (missing.length > 0) { requestPermissions(missing, 44); return; }
        wifiHint.setText("正在搜索附近的相机…"); wifiResults.removeAllViews();
        if (connectButton != null) { connectButton.setEnabled(false); connectButton.setVisibility(View.GONE); }
        wifiConnector.scan(new CameraWifiConnector.ScanCallback() {
            @Override public void onResults(List<CameraWifiConnector.CameraWifi> cameras, boolean fresh) {
                if (!"connection".equals(page) || connectionStep != 1) return;
                if (connectButton != null) { connectButton.setEnabled(true); connectButton.setText("重新搜索"); connectButton.setVisibility(View.VISIBLE); }
                wifiHint.setText(cameras.isEmpty() ? "未找到相机。请确认相机已开启 Wi-Fi，并将手机靠近相机后重试。"
                        : fresh ? "选择要连接的相机，随后确认 Android 的连接请求。" : "以下是最近发现的相机，可选择连接或稍后重新搜索。");
                wifiResults.removeAllViews();
                for (CameraWifiConnector.CameraWifi candidate : cameras) {
                    Button choice = textButton(candidate.ssid + "    ›", false, () -> chooseCameraWifi(candidate));
                    choice.setGravity(Gravity.LEFT | Gravity.CENTER_VERTICAL);
                    choice.setContentDescription(candidate.ssid + "，点击连接");
                    wifiResults.addView(choice, spaced(-1, -2, 8));
                }
            }
            @Override public void onError(CameraWifiConnector.Error error, String message) { showWifiError(error, message); }
        });
    }
    private void showWifiError(CameraWifiConnector.Error error, String message) {
        if (!"connection".equals(page)) return;
        wifiHint.setText(message); if (connectButton != null) { connectButton.setEnabled(true); connectButton.setVisibility(View.VISIBLE); } wifiResults.removeAllViews();
        if (error == CameraWifiConnector.Error.WIFI_DISABLED) {
            Button enable = textButton("开启手机 Wi-Fi", false, () -> startActivity(new Intent(Settings.Panel.ACTION_WIFI)));
            wifiResults.addView(enable, spaced(-1, dp(48), 8));
        } else if (error == CameraWifiConnector.Error.LOCATION_DISABLED) {
            wifiResults.addView(textButton("开启定位服务", false, () -> startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS))), spaced(-1, dp(48), 8));
        }
    }
    @Override public void onRequestPermissionsResult(int request, String[] permissions, int[] grants) {
        super.onRequestPermissionsResult(request, permissions, grants);
        if (request == 44 && "connection".equals(page)) {
            if (wifiConnector.missingPermissions().length == 0) scanCameraWifi();
            else showWifiError(CameraWifiConnector.Error.PERMISSION_REQUIRED, "需要精确位置和附近设备权限才能搜索相机，请允许后重试。");
        }
    }
    private void chooseCameraWifi(CameraWifiConnector.CameraWifi candidate) {
        if (!candidate.needsPassword()) { connectCameraWifi(candidate, "", false); return; }
        wifiConnector.cancelScan(); selectedCandidate = candidate; connectionStep = 2;
        content.removeAllViews();
        content.addView(pageTitle("连接相机", "输入相机屏幕中显示的 Wi-Fi 密码"));
        content.addView(new CameraIllustration(this), new LinearLayout.LayoutParams(-1, dp(140)));
        TextView device = label(candidate.ssid, 18); device.setTextColor(TEXT);
        content.addView(device, spaced(-1, -2, 12));
        wifiPassword = new EditText(this); wifiPassword.setSingleLine(true);
        wifiPassword.setInputType(129); wifiPassword.setHint("相机 Wi-Fi 密码");
        wifiPassword.setTextSize(16); wifiPassword.setTextColor(TEXT);
        wifiPassword.setText(wifiConnector.savedPassword(candidate.ssid));
        content.addView(wifiPassword, spaced(-1, dp(56), 12));
        rememberWifi = new CheckBox(this); rememberWifi.setText("记住此相机的密码");
        rememberWifi.setTextColor(SECONDARY); rememberWifi.setTextSize(13); rememberWifi.setChecked(true);
        content.addView(rememberWifi, spaced(-1, dp(48), 4));
        wifiHint = label("连接后即可预览、拍摄和查看相册", 13); wifiHint.setTextColor(SECONDARY);
        content.addView(wifiHint, spaced(-1, -2, 12));
        connectButton = actionButton("连接相机", ACCENT, () -> {
            String value = wifiPassword.getText().toString();
            if (value.length() < 8 || value.length() > 63) { wifiPassword.setError("请输入 8–63 位 Wi-Fi 密码"); return; }
            android.view.inputmethod.InputMethodManager keyboard = (android.view.inputmethod.InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
            if (keyboard != null) keyboard.hideSoftInputFromWindow(wifiPassword.getWindowToken(), 0);
            connectCameraWifi(candidate, value, rememberWifi.isChecked());
        });
        content.addView(connectButton, spaced(-1, dp(52), 20));
        content.addView(textButton("选择其他相机", false, () -> drawConnection(1)), spaced(-1, dp(48), 8));
        wifiResults = column(); content.addView(wifiResults);
        scroll.scrollTo(0, 0);
    }
    private void connectCameraWifi(CameraWifiConnector.CameraWifi candidate, String password, boolean remember) {
        if (busy.get() || exporting.get() || wifiConnector.isConnecting()) { note("请等待当前操作完成"); return; }
        closeLivePreview(); camera.close(); selectedWifiNetwork = null;
        connectionGeneration.incrementAndGet(); network = null; clearCameraViews("正在连接相机…");
        pendingWifiCandidate = candidate;
        wifiHint.setText("正在连接 " + candidate.ssid + "，请确认系统弹窗…"); connectButton.setEnabled(false);
        wifiConnector.connect(candidate, password, remember, new CameraWifiConnector.ConnectionCallback() {
            @Override public void onConnected(Network route, String address) {
                selectedWifiNetwork = route; host.setText(address); connect();
            }
            @Override public void onLost() {
                selectedWifiNetwork = null; network = null; connectionGeneration.incrementAndGet(); camera.close();
                exportCancelled.set(true); exporter.cancel();
                closeLivePreview(); closeMediaViewer(); closeThumbnails(); clearCameraViews("相机连接已断开");
                // This callback and the general Wi-Fi callback can arrive in either order.
                // Finish navigation here as well: clearing network above makes the other callback ignore this loss.
                if (!"connection".equals(page)) drawConnection(1);
                wifiHint.setText("相机连接已断开，请重新选择连接。");
                if (connectButton != null) { connectButton.setEnabled(true); connectButton.setVisibility(View.VISIBLE); }
                updateOperation();
            }
            @Override public void onError(CameraWifiConnector.Error error, String message) {
                if (savedAutoConnectActive) {
                    savedAutoConnectActive = false;
                    if (wifiHint != null) wifiHint.setText("已保存的相机连接未建立，正在搜索可用设备…");
                    scanCameraWifi();
                } else showWifiError(error, message);
            }
            @Override public void onPasswordSaveFailed(String message) { note(message); }
        });
    }

    /**
     * Start the saved-camera path only once, on the first connection page of a
     * process. The camera Wi-Fi must already be available to the system; this
     * method does not display or log the stored password. The existing Wi-Fi
     * connector performs the normal Android network handoff and the camera
     * API handshake; its failure handler returns to scanning.
     */
    private boolean attemptSavedCameraAutoConnect() {
        if (!initialAutoConnectPending) return false;
        initialAutoConnectPending = false;
        android.content.SharedPreferences preferences = getPreferences(MODE_PRIVATE);
        if (!preferences.getBoolean("camera_connection_saved", false)) return false;
        String savedHost = preferences.getString("camera_host", "").trim();
        String savedSsid = preferences.getString("camera_saved_ssid", "").trim();
        if (!validHost(savedHost) || savedSsid.isEmpty()) return false;
        CameraWifiConnector.Security security;
        try { security = CameraWifiConnector.Security.valueOf(preferences.getString("camera_saved_security", "UNSUPPORTED")); }
        catch (IllegalArgumentException invalid) { return false; }
        if (security == CameraWifiConnector.Security.UNSUPPORTED) return false;
        String password = security == CameraWifiConnector.Security.OPEN ? "" : wifiConnector.savedPassword(savedSsid);
        if (security != CameraWifiConnector.Security.OPEN && password.isEmpty()) return false;
        CameraWifiConnector.CameraWifi candidate = new CameraWifiConnector.CameraWifi(savedSsid,
                preferences.getString("camera_saved_bssid", ""), -100, security);
        host.setText(savedHost);
        pendingWifiCandidate = candidate;
        savedAutoConnectActive = true;
        if (wifiHint != null) wifiHint.setText("正在连接已保存的相机 " + savedSsid + "…");
        connectCameraWifi(candidate, password, true);
        return true;
    }

    private void rememberConnectedCamera(String address) {
        android.content.SharedPreferences.Editor editor = getPreferences(MODE_PRIVATE).edit()
                .putString("camera_host", address).putBoolean("camera_connection_saved", true);
        if (pendingWifiCandidate != null) {
            editor.putString("camera_saved_ssid", pendingWifiCandidate.ssid)
                    .putString("camera_saved_bssid", pendingWifiCandidate.bssid == null ? "" : pendingWifiCandidate.bssid)
                    .putString("camera_saved_security", pendingWifiCandidate.security.name());
        }
        editor.apply();
    }

    private void navigateBack() {
        if (monitorMode) { toggleMonitorMode(); return; }
        if ("media".equals(page) && mediaSelectionMode) {
            selectedMedia.clear(); mediaSelectionMode = false; drawMedia(); return;
        }
        if ("connection".equals(page)) {
            if (connectionStep > 1) drawConnection(1); else if (camera.isConnected()) drawControl(); else finish();
        } else if ("settings".equals(page) && (!settingsGroup.isEmpty() || !settingsQuery.isEmpty())) { settingsGroup = ""; settingsQuery = ""; drawSettings(); }
        else if (!"control".equals(page)) drawControl();
        else finish();
    }
    @Override public void onBackPressed() { navigateBack(); }

    private final class CameraIllustration extends View {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        CameraIllustration(Context context) { super(context); setContentDescription("YI 4K 相机连接示意"); }
        @Override protected void onDraw(Canvas canvas) {
            float cx = getWidth() / 2f, cy = getHeight() / 2f, scale = Math.min(getWidth(), getHeight()) / 250f;
            canvas.save(); canvas.translate(cx, cy); canvas.scale(scale, scale);
            paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1); paint.setColor(AppPalette.LINE);
            canvas.drawCircle(0, 0, 113, paint); canvas.drawCircle(0, 0, 94, paint);
            paint.setColor(Color.BLACK); paint.setStrokeWidth(2);
            canvas.drawRoundRect(-69, -42, 69, 47, 14, 14, paint);
            canvas.drawRoundRect(-66, -39, 66, 44, 12, 12, paint);
            canvas.drawRoundRect(2, -34, 60, 24, 14, 14, paint);
            canvas.drawCircle(31, -5, 23, paint); canvas.drawCircle(31, -5, 16, paint); canvas.drawCircle(31, -5, 4, paint);
            canvas.drawRoundRect(-55, -29, -43, -25, 2, 2, paint);
            canvas.drawRoundRect(-46, -47, -20, -42, 3, 3, paint);
            paint.setStyle(Paint.Style.FILL); paint.setTextSize(12); canvas.drawText("YI 4K", -54, 25, paint); canvas.restore();
        }
    }

    private View divider() {
        View line = new View(this); line.setBackgroundColor(Color.rgb(228, 228, 231));
        LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(-1, 1); p.setMargins(0, dp(10), 0, dp(8));
        line.setLayoutParams(p); return line;
    }

    private View captureDeviceRow() {
        LinearLayout device = row(); device.setGravity(Gravity.CENTER_VERTICAL); device.setPadding(0, dp(3), 0, dp(12));
        deviceWifiDot = label("●", 13); deviceWifiDot.setPadding(0, 0, dp(6), 0); device.addView(deviceWifiDot);
        deviceWifiQuality = label("未连接", 11); deviceWifiQuality.setTextColor(SECONDARY);
        deviceWifiQuality.setMaxLines(1); deviceWifiQuality.setEllipsize(android.text.TextUtils.TruncateAt.END);
        device.addView(deviceWifiQuality, new LinearLayout.LayoutParams(0, -2, 1));
        device.addView(verticalRule(), new LinearLayout.LayoutParams(dp(1), dp(28)));
        deviceBattery = label("--", 12); deviceBattery.setTextColor(TEXT);
        deviceBattery.setGravity(Gravity.CENTER_VERTICAL); deviceBattery.setPadding(dp(10), 0, dp(10), 0); device.addView(deviceBattery);
        device.addView(verticalRule(), new LinearLayout.LayoutParams(dp(1), dp(28)));
        deviceCard = label("SD --", 12); deviceCard.setTextColor(TEXT); deviceCard.setGravity(Gravity.CENTER_VERTICAL);
        deviceCard.setPadding(dp(10), 0, 0, 0); addIcon(deviceCard, 5, TEXT, false); device.addView(deviceCard);
        device.setContentDescription("相机连接"); device.setOnClickListener(v -> drawConnection(1)); return device;
    }

    private View verticalRule() {
        View line = new View(this); line.setBackgroundColor(Color.rgb(220, 220, 224));
        return line;
    }

    private View capturePreview() {
        FrameLayout preview = new FrameLayout(this); preview.setBackground(round(Color.rgb(58, 61, 60), 18)); preview.setClipToOutline(true);
        // The camera RTSP feed is 16:9; matching the host surface avoids the
        // oversized artificial top/bottom bars of the former 0.76 ratio.
        int previewHeight = Math.round(Math.min(getResources().getDisplayMetrics().widthPixels / getResources().getDisplayMetrics().density * .5625f, 330));
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(-1, dp(previewHeight)); params.setMargins(0, 0, 0, dp(12)); preview.setLayoutParams(params);
        previewSurface = new FrameLayout(this); preview.addView(previewSurface, new FrameLayout.LayoutParams(-1, -1));
        previewArt = new PreviewArtView(this); preview.addView(previewArt, new FrameLayout.LayoutParams(-1, -1));
        previewArt.setOnClickListener(v -> startLivePreview()); previewArt.setContentDescription("开启相机实时预览");
        captureFlash = new View(this); captureFlash.setBackgroundColor(Color.WHITE); captureFlash.setAlpha(0f);
        captureFlash.setVisibility(View.GONE); captureFlash.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
        preview.addView(captureFlash, new FrameLayout.LayoutParams(-1, -1));
        previewQuality = overlayPill("--", Gravity.TOP | Gravity.LEFT);
        previewFov = overlayPill("视角 --", Gravity.TOP | Gravity.RIGHT);
        previewStatus = overlayPill("连接相机", Gravity.BOTTOM | Gravity.LEFT);
        previewRec = overlayPill("--", Gravity.BOTTOM | Gravity.RIGHT);
        previewMonitor = overlayPill("全屏", Gravity.TOP | Gravity.RIGHT);
        previewParameters = overlayPill("EIS --", Gravity.BOTTOM | Gravity.LEFT);
        previewParameters.setContentDescription("电子防抖，点击调整");
        previewParameters.setOnClickListener(v -> { if (camera.isConnected() && settings.has("iq_eis_enable")) options("iq_eis_enable"); });
        previewScale = overlayPill(previewFill ? "铺满" : "完整", Gravity.BOTTOM | Gravity.RIGHT);
        previewScale.setContentDescription("切换完整画面与铺满取景");
        previewScale.setOnClickListener(v -> {
            previewFill = !previewFill;
            previewScale.setText(previewFill ? "铺满" : "完整");
            if (livePreview != null) livePreview.setFill(previewFill);
        });
        previewMonitor.setContentDescription("全屏监看");
        previewMonitor.setOnClickListener(v -> toggleMonitorMode());
        preview.addView(previewQuality, overlayParams(Gravity.TOP | Gravity.LEFT)); preview.addView(previewFov, overlayParams(Gravity.TOP | Gravity.RIGHT));
        preview.addView(previewStatus, overlayParams(Gravity.BOTTOM | Gravity.LEFT));
        preview.addView(previewRec, overlayParams(Gravity.BOTTOM | Gravity.RIGHT));
        FrameLayout.LayoutParams monitorParams = overlayParams(Gravity.TOP | Gravity.RIGHT);
        monitorParams.topMargin = dp(48); monitorParams.height = dp(40);
        preview.addView(previewMonitor, monitorParams);
        FrameLayout.LayoutParams scaleParams = overlayParams(Gravity.TOP | Gravity.LEFT);
        scaleParams.topMargin = dp(48); scaleParams.height = dp(40);
        preview.addView(previewScale, scaleParams);
        FrameLayout.LayoutParams parameterParams = overlayParams(Gravity.BOTTOM | Gravity.LEFT);
        preview.addView(previewParameters, parameterParams);
        previewStatus.setVisibility(View.GONE);
        return preview;
    }

    private final class CaptureWorkspace extends LinearLayout {
        CaptureWorkspace(Context context) { super(context); setOrientation(VERTICAL); }
        @Override protected void onMeasure(int widthSpec, int heightSpec) {
            int width = View.MeasureSpec.getSize(widthSpec), height = View.MeasureSpec.getSize(heightSpec);
            boolean capture = "control".equals(page);
            landscapeCapture = capture && width > height;
            setOrientation(landscapeCapture ? HORIZONTAL : VERTICAL);
            applyLayout(scroll, landscapeCapture
                    ? new LinearLayout.LayoutParams(0, -1, 1)
                    : new LinearLayout.LayoutParams(-1, 0, 1));
            captureActionScroll.setVisibility(capture ? VISIBLE : GONE);
            applyLayout(captureActionScroll, landscapeCapture
                    ? new LinearLayout.LayoutParams(dp(208), -1)
                    : new LinearLayout.LayoutParams(-1, -2));
            if (capture) adaptCaptureDock(height < dp(640), landscapeCapture);
            super.onMeasure(widthSpec, heightSpec);
        }
    }

    /** Same live decoder and controls, reparented over the edge-to-edge viewfinder. */
    private void toggleMonitorMode() {
        if (capturePreviewFrame == null) return;
        monitorMode = !monitorMode;
        if (monitorMode) {
            monitorPreviousOrientation = getRequestedOrientation();
            // A monitor is a camera viewfinder, so entering it follows the
            // conventional landscape camera interaction immediately. The
            // activity keeps configChanges and reflows the existing surface;
            // no player or camera session is recreated.
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
            bottomNav.setVisibility(View.GONE); captureWorkspace.setVisibility(View.GONE);
            detach(capturePreviewFrame); detach(captureParameterBar); detach(captureActions); detach(captureDeviceBar);
            monitorLayer.addView(capturePreviewFrame, new FrameLayout.LayoutParams(-1, -1));
            monitorParameterScroll = new ScrollView(this); monitorParameterScroll.setVerticalScrollBarEnabled(false);
            monitorParameterScroll.addView(captureParameterBar, new FrameLayout.LayoutParams(-1, -2));
            monitorLayer.addView(monitorParameterScroll);
            monitorLayer.addView(captureActions); monitorLayer.addView(captureDeviceBar);
            monitorLayer.setVisibility(View.VISIBLE); previewMonitor.setText("退出全屏");
            capturePreviewFrame.setBackgroundColor(Color.BLACK);
        } else {
            setRequestedOrientation(monitorPreviousOrientation);
            getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR | View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
            detach(capturePreviewFrame); detach(captureParameterBar); detach(captureActions); detach(captureDeviceBar);
            monitorLayer.removeAllViews(); monitorLayer.setVisibility(View.GONE); monitorParameterScroll = null;
            captureWorkspace.setVisibility(View.VISIBLE); bottomNav.setVisibility(View.VISIBLE);
            content.addView(captureDeviceBar, 0); content.addView(capturePreviewFrame, 1,
                    new LinearLayout.LayoutParams(-1, dp(240)));
            restoreParameterBar();
            captureParameterScroll.addView(captureParameterBar, new FrameLayout.LayoutParams(-2, -2));
            captureParameterScroll.scrollTo(0, 0); captureParameterBar.scrollTo(0, 0);
            captureParameterScroll.requestLayout();
            scroll.scrollTo(0, 0);
            captureActionScroll.addView(captureActions, new FrameLayout.LayoutParams(-1, -2));
            captureParameterBar.setOrientation(LinearLayout.HORIZONTAL);
            captureDeviceBar.setBackgroundColor(Color.TRANSPARENT);
            captureDeviceBar.setPadding(0, dp(3), 0, dp(12));
            capturePreviewFrame.setBackground(round(Color.BLACK, 18));
            previewMonitor.setText("全屏");
        }
        updateMonitorLayout(); captureWorkspace.requestLayout();
    }

    private final class MonitorWorkspace extends FrameLayout {
        MonitorWorkspace(Context context) { super(context); }
        @Override public android.view.WindowInsets onApplyWindowInsets(android.view.WindowInsets insets) {
            monitorCutoutInsets.set(0, 0, 0, 0);
            if (android.os.Build.VERSION.SDK_INT >= 28 && insets.getDisplayCutout() != null) {
                android.view.DisplayCutout cutout = insets.getDisplayCutout();
                monitorCutoutInsets.set(cutout.getSafeInsetLeft(), cutout.getSafeInsetTop(),
                        cutout.getSafeInsetRight(), cutout.getSafeInsetBottom());
            }
            requestLayout();
            return super.onApplyWindowInsets(insets);
        }
        @Override protected void onMeasure(int widthSpec, int heightSpec) {
            if (monitorMode) layoutMonitor(MeasureSpec.getSize(widthSpec), MeasureSpec.getSize(heightSpec));
            super.onMeasure(widthSpec, heightSpec);
        }
    }
    private void updateMonitorLayout() { if (monitorMode) monitorLayer.requestLayout(); }
    private void layoutMonitor(int width, int height) {
        boolean wide = width > height;
        int leftSafe = Math.max(dp(14), monitorCutoutInsets.left);
        int topSafe = Math.max(dp(14), monitorCutoutInsets.top);
        int rightSafe = Math.max(dp(14), monitorCutoutInsets.right);
        int bottomSafe = Math.max(dp(12), monitorCutoutInsets.bottom);
        int rail = Math.min(Math.max(dp(184), Math.round(width * .20f)), Math.max(dp(160), width / 3));
        int dock = Math.min(dp(152), Math.max(dp(124), height / 3));
        previewFov.setVisibility(wide ? View.VISIBLE : View.GONE);
        captureParameterBar.setOrientation(LinearLayout.VERTICAL);
        captureParameterBar.setPadding(dp(8), dp(7), dp(8), dp(3));
        for (TextView chip : captureParameters.values()) {
            LinearLayout.LayoutParams cp = new LinearLayout.LayoutParams(-1, Math.max(dp(46), chip.getLineHeight()+dp(16)));
            cp.setMargins(0, 0, 0, dp(3)); chip.setLayoutParams(cp);
        }
        FrameLayout.LayoutParams rp = new FrameLayout.LayoutParams(rail,
                Math.max(dp(72), height - topSafe - bottomSafe - dock - dp(30)), Gravity.RIGHT | Gravity.TOP);
        rp.setMargins(0, topSafe + dp(64), rightSafe, dock + bottomSafe + dp(4)); monitorParameterScroll.setLayoutParams(rp);
        monitorParameterScroll.setClipToPadding(false);
        monitorParameterScroll.setBackground(glassSurface(0xb51a2028, 0x80ffffff, 18));
        FrameLayout.LayoutParams ap = new FrameLayout.LayoutParams(Math.max(dp(220), width - rail - leftSafe - rightSafe - dp(28)), -2,
                Gravity.BOTTOM | Gravity.LEFT);
        ap.setMargins(leftSafe, 0, rail + rightSafe + dp(14), bottomSafe + dp(8)); captureActions.setLayoutParams(ap);
        captureActions.setPadding(dp(8), dp(6), dp(8), dp(6));
        captureActions.setBackground(glassSurface(0xa91a2028, 0x80ffffff, 24));
        captureModes.setOrientation(LinearLayout.HORIZONTAL);
        captureModes.setBackground(glassSurface(0x401a2028, 0x33ffffff, 20));
        captureModes.setPadding(dp(5), dp(4), dp(5), dp(4));
        for (int i=0; i<captureModes.getChildCount(); i++) {
            TextView mode = (TextView) captureModes.getChildAt(i);
            mode.setLayoutParams(new LinearLayout.LayoutParams(0, Math.max(dp(48), mode.getLineHeight()+dp(14)), 1));
        }
        LinearLayout shutterRow = (LinearLayout) captureActions.getChildAt(0);
        shutterRow.setGravity(Gravity.CENTER_VERTICAL);
        for (int i=0; i<shutterRow.getChildCount(); i++) {
            View child = shutterRow.getChildAt(i);
            child.setLayoutParams(child == primaryShutter ? new LinearLayout.LayoutParams(dp(wide ? 78 : 86), dp(wide ? 78 : 86))
                    : new LinearLayout.LayoutParams(0, dp(wide ? 78 : 86), 1));
        }
        FrameLayout.LayoutParams hp = new FrameLayout.LayoutParams(-1, dp(52), Gravity.TOP);
        hp.setMargins(leftSafe, topSafe, rightSafe, 0); captureDeviceBar.setLayoutParams(hp);
        captureDeviceBar.setPadding(dp(12), 0, dp(12), 0);
        captureDeviceBar.setBackground(glassSurface(0xb51a2028, 0x80ffffff, 24));
        deviceWifiDot.setTextColor(0xff62d69b);
        deviceWifiQuality.setTextColor(Color.WHITE);
        deviceBattery.setTextColor(0xff88e0a7);
        deviceCard.setTextColor(Color.WHITE);
        for (android.graphics.drawable.Drawable icon : deviceCard.getCompoundDrawables()) if (icon != null) icon.setTint(Color.WHITE);
        for (TextView pill : new TextView[]{previewQuality, previewFov, previewMonitor, previewScale}) {
            FrameLayout.LayoutParams pp = (FrameLayout.LayoutParams) pill.getLayoutParams();
            pp.topMargin = topSafe + dp(pill == previewMonitor || pill == previewScale ? 66 : 64);
            pp.leftMargin = leftSafe;
            if (pill == previewFov || pill == previewMonitor) pp.rightMargin = rail + rightSafe + dp(20);
            pill.setLayoutParams(pp);
        }
        for (TextView pill : new TextView[]{previewRec, previewParameters, previewStatus}) {
            FrameLayout.LayoutParams pp = (FrameLayout.LayoutParams) pill.getLayoutParams();
            pp.bottomMargin = bottomSafe + dock + dp(18); pp.leftMargin = leftSafe; pp.rightMargin = rail + rightSafe + dp(20);
            pill.setLayoutParams(pp);
        }
    }

    private android.graphics.drawable.Drawable glassSurface(int fill, int border, int radiusDp) {
        return new CameraVisuals.Glass(fill, border, dp(radiusDp));
    }

    private void applyLayout(View view, LinearLayout.LayoutParams wanted) {
        ViewGroup.LayoutParams current = view.getLayoutParams();
        if (current instanceof LinearLayout.LayoutParams) {
            LinearLayout.LayoutParams p = (LinearLayout.LayoutParams) current;
            if (p.width == wanted.width && p.height == wanted.height && p.weight == wanted.weight) return;
        }
        view.setLayoutParams(wanted);
    }

    private final class CaptureScrollView extends ScrollView {
        CaptureScrollView(Context context) { super(context); }
        @Override protected void onMeasure(int widthSpec, int heightSpec) {
            super.onMeasure(widthSpec, heightSpec);
            if (fitCapturePreview()) super.onMeasure(widthSpec, heightSpec);
        }
    }

    /** Landscape keeps the live Surface in the left column and scrollable controls in the right. */
    private void adaptCaptureDock(boolean compact, boolean landscape) {
        compactCaptureDock = compact;
        if (capturePreviewFrame != null) capturePreviewFrame.setVisibility(View.VISIBLE);
        if (!monitorMode && previewQuality != null) {
            previewFov.setVisibility(View.VISIBLE);
            for (TextView pill : new TextView[]{previewQuality, previewFov, previewMonitor, previewScale}) {
                FrameLayout.LayoutParams pp = (FrameLayout.LayoutParams) pill.getLayoutParams();
                pp.topMargin = dp(pill == previewMonitor || pill == previewScale ? 48 : 10); pp.rightMargin = dp(10); pill.setLayoutParams(pp);
            }
            for (TextView pill : new TextView[]{previewRec, previewParameters, previewStatus}) {
                FrameLayout.LayoutParams pp = (FrameLayout.LayoutParams) pill.getLayoutParams(); pp.bottomMargin = dp(10); pill.setLayoutParams(pp);
            }
        }
        // Only the brand heading is omitted from the short landscape column;
        // camera state remains in the device row and the real preview overlays.
        if (captureHeader != null) captureHeader.setVisibility(View.VISIBLE);
        if (captureDivider != null) captureDivider.setVisibility(landscape ? View.GONE : View.VISIBLE);
        content.setPadding(monitorMode ? 0 : dp(16), monitorMode ? 0 : dp(landscape ? 6 : 14),
                monitorMode ? 0 : dp(16), monitorMode ? 0 : dp(landscape ? 8 : 18));
        captureActions.setPadding(dp(landscape ? 4 : 16), dp(landscape ? 4 : 0), dp(landscape ? 4 : 16), 0);
        restoreParameterBar();
        if (captureActions.getChildCount() == 0) return;
        LinearLayout shutterRow = (LinearLayout) captureActions.getChildAt(0);
        shutterRow.setPadding(0, dp(2), 0, dp(2));
        for (int i = 0; i < shutterRow.getChildCount(); i++) {
            View child = shutterRow.getChildAt(i);
            LinearLayout.LayoutParams p = (LinearLayout.LayoutParams) child.getLayoutParams();
            int height = dp(compact ? 64 : 88), width = child == primaryShutter ? dp(compact ? 68 : 88) : p.width;
            if (p.height != height || p.width != width) {
                p.height = height; p.width = width; child.setLayoutParams(p);
            }
        }
        captureModes.setBackgroundColor(Color.TRANSPARENT);
        captureModes.setOrientation(landscape ? LinearLayout.VERTICAL : LinearLayout.HORIZONTAL);
        for (int i = 0; i < captureModes.getChildCount(); i++) {
            Button child = (Button) captureModes.getChildAt(i);
            int height = Math.max(dp(48), child.getLineHeight() + dp(16));
            child.setMinimumHeight(height); child.setMinHeight(height);
            applyLayout(child, landscape
                    ? new LinearLayout.LayoutParams(-1, height)
                    : new LinearLayout.LayoutParams(0, height, 1));
        }
    }

    private void restoreParameterBar() {
        if (captureParameterBar == null) return;
        captureParameterBar.setOrientation(LinearLayout.HORIZONTAL);
        captureParameterBar.setPadding(0, dp(12), 0, dp(10));
        for (TextView chip : captureParameters.values()) {
            LinearLayout.LayoutParams current = (LinearLayout.LayoutParams) chip.getLayoutParams();
            int height = Math.max(dp(44), chip.getLineHeight() + dp(18));
            if (current.width != -2 || current.height != height || current.weight != 0
                    || current.leftMargin != 0 || current.topMargin != 0 || current.rightMargin != dp(6) || current.bottomMargin != 0) {
                LinearLayout.LayoutParams normal = new LinearLayout.LayoutParams(-2, height);
                normal.rightMargin = dp(6); chip.setLayoutParams(normal);
            }
        }
    }

    private boolean fitCapturePreview() {
        if (!"control".equals(page) || monitorMode || capturePreviewFrame == null || capturePreviewFrame.getParent() != content || scroll.getMeasuredHeight() == 0) return false;
        int reserved = content.getPaddingTop() + content.getPaddingBottom();
        for (int i = 0; i < content.getChildCount(); i++) {
            View child = content.getChildAt(i);
            if (child.getVisibility() == View.GONE) continue;
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) child.getLayoutParams();
            reserved += params.topMargin + params.bottomMargin;
            if (child != capturePreviewFrame) reserved += child.getMeasuredHeight();
        }
        int preferred = landscapeCapture
                ? Math.max(dp(100), Math.round((content.getMeasuredWidth() - content.getPaddingLeft() - content.getPaddingRight()) * 9f / 16f))
                : Math.min(Math.round(content.getMeasuredWidth() * 9f / 16f), dp(330));
        // The shutter dock and four-tab navigation are fixed below the
        // scroll area. On a short portrait window or landscape phone the
        // previous 128dp floor let the preview overlap the parameter chips.
        // Allow a compact but still visible preview so every control remains
        // readable and tappable instead of being painted underneath the dock.
        int minimum = dp(landscapeCapture ? 100 : 72);
        int available = Math.max(minimum, scroll.getMeasuredHeight() - reserved);
        int height = landscapeCapture ? Math.max(minimum, Math.min(preferred, available)) : available;
        ViewGroup.LayoutParams params = capturePreviewFrame.getLayoutParams();
        if (params.height == height) return false;
        params.height = height; capturePreviewFrame.setLayoutParams(params); return true;
    }

    private FrameLayout.LayoutParams overlayParams(int gravity) {
        FrameLayout.LayoutParams p = new FrameLayout.LayoutParams(-2, dp(28), gravity); p.setMargins(dp(6), dp(6), dp(6), dp(6)); return p;
    }
    private TextView overlayPill(String text, int gravity) {
        TextView pill = label(text, 12); pill.setTypeface(android.graphics.Typeface.MONOSPACE); pill.setTextColor(TEXT); pill.setGravity(Gravity.CENTER); pill.setPadding(dp(12), 0, dp(12), 0);
        pill.setMaxLines(1); pill.setMaxWidth(dp(260)); pill.setEllipsize(android.text.TextUtils.TruncateAt.END);
        pill.setTextColor(Color.WHITE); pill.setBackground(glassSurface(0xb51a2028, 0x80ffffff, 22)); return pill;
    }

    private final class PreviewArtView extends View {
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        PreviewArtView(Context context) { super(context); }
        @Override protected void onDraw(Canvas canvas) {
            super.onDraw(canvas); float w = getWidth(), h = getHeight();
            Path clip = new Path(); clip.addRoundRect(0, 0, w, h, dp(18), dp(18), Path.Direction.CW); canvas.save(); canvas.clipPath(clip);
            paint.setShader(new LinearGradient(0, 0, w, h, 0xffd9d9d3, 0xff989e97, Shader.TileMode.CLAMP)); canvas.drawRect(0, 0, w, h, paint); paint.setShader(null);
            LineIcon cameraIcon = new LineIcon(0, Color.argb(210, 255, 255, 255));
            boolean compact = h < dp(120);
            int size = compact ? dp(30) : dp(52);
            int centerOffset = compact ? 0 : -dp(12);
            cameraIcon.setBounds((int)(w-size)/2, (int)(h-size)/2+centerOffset,
                    (int)(w+size)/2, (int)(h+size)/2+centerOffset); cameraIcon.draw(canvas);
            if (!compact) {
                paint.setColor(Color.WHITE); paint.setTextSize(dp(13)); paint.setTextAlign(Paint.Align.CENTER);
                canvas.drawText(camera.isConnected() ? "正在连接实时画面" : "连接相机，开始拍摄", w/2, h/2+dp(39), paint); paint.setTextAlign(Paint.Align.LEFT);
            }
            canvas.restore();
        }
    }

    private LinearLayout captureParameterRow() {
        LinearLayout parameters = row(); parameters.setGravity(Gravity.CENTER_VERTICAL); parameters.setPadding(0, dp(12), 0, dp(10));
        parameters.addView(parameterChip("RES", "resolution"));
        parameters.addView(parameterChip("FPS", "fps"));
        parameters.addView(parameterChip("FOV", "fov"));
        parameters.addView(parameterChip("EV", "ev"));
        parameters.addView(parameterChip("COLOR", "color"));
        return parameters;
    }

    private TextView parameterChip(String title, String parameter) {
        TextView chip = label(title + " --", 12); chip.setTextColor("resolution".equals(parameter) ? Color.WHITE : TEXT); chip.setGravity(Gravity.CENTER);
        chip.setTypeface(android.graphics.Typeface.MONOSPACE); chip.setPadding(dp(10), dp(5), dp(10), dp(5)); chip.setMaxLines(1);
        chip.setBackgroundColor(Color.TRANSPARENT);
        chip.setFocusable(false); chip.setClickable(false); chip.setLongClickable(false);
        LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(-2, dp(44)); p.setMargins(0, 0, dp(6), 0); chip.setLayoutParams(p);
        captureParameters.put(parameter, chip);
        String spoken = "resolution".equals(parameter) ? "分辨率" : "fps".equals(parameter) ? "帧率"
                : "fov".equals(parameter) ? "视角" : "ev".equals(parameter) ? "曝光补偿" : "色彩";
        chip.setContentDescription(spoken + "参数显示");
        return chip;
    }

    private Button modeButton(String title, String mode) {
        Button b = button(title, () -> {
            closeLivePreview();
            work(() -> configureAndRefresh(() -> CameraConfiguration.selectMode(camera, mode)));
        });
        b.setTextSize(13); b.setTextColor(SECONDARY); b.setBackground(round(Color.TRANSPARENT, 20)); b.setTag(mode); b.setMaxLines(1); b.setHorizontallyScrolling(false); b.setGravity(Gravity.CENTER); b.setPadding(dp(4), 0, dp(4), 0); return b;
    }

    private Button shutterButton() {
        Button b = button("", this::capturePrimary);
        b.setContentDescription("快门");
        b.setBackground(new CameraVisuals.Shutter());
        // The native Button state animator briefly fades/replaces custom
        // drawables while the preview surface is attaching. Disable it so
        // the shutter dock stays visually stable during preview refreshes.
        if (android.os.Build.VERSION.SDK_INT >= 21) b.setStateListAnimator(null);
        b.setAllCaps(false); b.setFocusable(false); b.setHapticFeedbackEnabled(true);
        b.setOnTouchListener((view, event) -> {
            switch (event.getActionMasked()) {
                case android.view.MotionEvent.ACTION_DOWN:
                    view.animate().cancel(); view.setScaleX(.90f); view.setScaleY(.90f); return false;
                case android.view.MotionEvent.ACTION_UP:
                case android.view.MotionEvent.ACTION_CANCEL:
                    view.animate().scaleX(1f).scaleY(1f).setDuration(110).start(); return false;
                default: return false;
            }
        });
        b.setPadding(0, 0, 0, 0);
        return b;
    }

    private Button captureTextButton(String text, int color, Runnable action) { Button b = button(text, action); b.setTextSize(12); b.setTextColor(Color.WHITE); b.setBackground(round(color, 18)); return b; }

    private TextView captureNotice(String text) { TextView note = label(text, 11); note.setTextColor(CAPTURE_MUTED); note.setGravity(Gravity.CENTER); note.setPadding(dp(8), dp(5), dp(8), dp(10)); return note; }

    private void updateCaptureViews() {
        boolean connected = camera.isConnected();
        if (connectionStatus != null) connectionStatus.setText(connected ? "● 相机会话已连接" : "○ 相机会话未连接");
        JSONObject shown = connected ? settings : new JSONObject();
        captureMode = CaptureParameters.captureMode(shown);
        for (Map.Entry<String, TextView> item : captureParameters.entrySet()) {
            String key = item.getKey(), title, value;
            switch (key) {
                case "resolution": title = "RES"; value = CaptureParameters.resolution(shown); break;
                case "fps": title = "FPS"; value = CaptureParameters.fps(shown); break;
                case "fov": title = "FOV"; value = CaptureParameters.value(shown, "fov"); break;
                case "ev": title = "EV"; value = CaptureParameters.value(shown, "capture".equals(shown.optString("system_mode")) ? "iq_photo_ev" : "iq_video_ev"); break;
                default: title = "COLOR"; value = CaptureParameters.value(shown, "capture".equals(shown.optString("system_mode")) ? "photo_flat_color" : "video_flat_color"); break;
            }
            if ("fps".equals(key) && "capture".equals(shown.optString("system_mode"))) { item.getValue().setVisibility(View.GONE); continue; }
            item.getValue().setVisibility(View.VISIBLE);
            if ("color".equals(key)) value = value.replace("（YI）", "").replace("（Flat）", "");
            if ("fov".equals(key)) value = value.replace("中等视角", "中等");
            setTextIfChanged(item.getValue(), title + " " + value);
        }
        if (deviceWifiQuality != null) {
            if (cameraTitle != null) setTextIfChanged(cameraTitle, connected ? cameraModel() : "相机");
            if (deviceWifiDot != null) {
                deviceWifiDot.setTextColor(wifiSignalColor(connected));
                deviceWifiDot.setContentDescription(connected ? "Wi‑Fi " + wifiSignalText() : "未连接");
            }
            if (deviceWifiQuality != null) {
                setTextIfChanged(deviceWifiQuality, connected ? "Wi-Fi " + wifiSignalText() + " · "
                        + CameraSettings.displayValue("app_status", cameraStatus) : "未连接");
                deviceWifiQuality.setTextColor(SECONDARY);
                deviceWifiQuality.setContentDescription(connected ? "Wi‑Fi 信号" + wifiSignalText() : "未连接");
            }
            if (!connected) batteryPercent = -1;
            updateBatteryView();
            setTextIfChanged(deviceCard, sdCardLabel(shown));
            previewQuality.setText(CaptureParameters.resolution(shown) + " / " + CaptureParameters.fps(shown));
            previewFov.setText("视角 " + CaptureParameters.value(shown, "fov"));
            previewStatus.setText(!connected ? "等待连接相机" : livePreviewStatus.isEmpty() ? "正在连接实时画面" : livePreviewStatus);
            if (previewArt != null) previewArt.invalidate();
            previewRec.setText(connected ? CameraSettings.displayValue("app_status", cameraStatus) : "--");
            if (previewParameters != null) previewParameters.setText("EIS " + CaptureParameters.value(shown, "iq_eis_enable"));
            previewStatus.setVisibility(!connected || !"实时画面已连接".equals(livePreviewStatus) ? View.VISIBLE : View.GONE);
            previewParameters.setVisibility(previewStatus.getVisibility() == View.VISIBLE ? View.GONE : View.VISIBLE);

        }
        if (captureModes != null) for (int i = 0; i < captureModes.getChildCount(); i++) {
            Button b = (Button) captureModes.getChildAt(i);
            boolean selected = captureMode.equals(b.getTag());
            if (b.getBackground() == null || b.isSelected() != selected) {
                b.setSelected(selected);
                b.setBackground(round(selected ? AppPalette.SELECTED : Color.TRANSPARENT, 20));
                b.setTextColor(selected ? ACCENT : SECONDARY);
            }
        }
        if (primaryShutter != null) {
            boolean recording = connected && "record".equals(cameraStatus);
            if (primaryShutter.getBackground() instanceof CameraVisuals.Shutter)
                ((CameraVisuals.Shutter) primaryShutter.getBackground()).update("capture".equals(captureMode), recording, capturePending);
            String pendingDescription = pendingCaptureRequest == 16777220 ? "正在拍照"
                    : pendingCaptureRequest == 513 ? "正在开始录像"
                    : pendingCaptureRequest == 514 ? "正在停止录像" : "相机处理中";
            primaryShutter.setContentDescription(capturePending ? pendingDescription : connected && !recording && !CameraState.isReady(cameraStatus)
                    ? "相机处理中" : recording ? "停止录像" : "capture".equals(captureMode) ? "拍照" : "开始录像");
            updateShutterEnabled();
        }
    }

    private void capturePrimary() {
        if (!camera.isConnected()) { drawConnection(1); return; }
        if (primaryShutter != null) {
            primaryShutter.performHapticFeedback(android.view.HapticFeedbackConstants.VIRTUAL_KEY);
            primaryShutter.animate().cancel(); primaryShutter.setScaleX(.90f); primaryShutter.setScaleY(.90f);
            primaryShutter.animate().scaleX(1f).scaleY(1f).setDuration(120).start();
        }
        if ("record".equals(cameraStatus)) { capture(514); return; }
        if ("capture".equals(settings.optString("system_mode"))) {
            // The camera click belongs to the local interaction. Network
            // confirmation, media indexing and JPEG decoding continue on the
            // command/thumbnail workers after this immediate response.
            beginPhotoFeedback();
            capture(16777220);
        }
        else if ("record".equals(settings.optString("system_mode"))) capture(513);
        else note("请先选择相机支持的拍摄模式");
    }

    private void beginPhotoFeedback() {
        optimisticPhotoFeedback = true;
        // Capture the viewfinder before adding the white confirmation layer.
        // Otherwise the optimistic thumbnail can inherit the flash overlay and
        // fly into the album as a blank white tile.
        if (captureAlbum != null && capturePreviewFrame != null) {
            final CaptureAlbumFeedback target = captureAlbum;
            final View preview = capturePreviewFrame;
            if (target.reserveOptimisticFlight() && !requestRealtimePreviewFrame(target, preview))
                target.playPreview(preview);
        }
        if (captureFlash != null) {
            captureFlash.animate().cancel(); captureFlash.setVisibility(View.VISIBLE); captureFlash.setAlpha(.82f);
            captureFlash.animate().alpha(0f).setDuration(180).withEndAction(() -> {
                if (captureFlash != null) captureFlash.setVisibility(View.GONE);
            }).start();
        }
    }

    /**
     * Copy the visible video surface. Media3 normally uses a SurfaceView,
     * whose pixels are not included by View.draw(Canvas). Copying its surface
     * also excludes the app's flash/OSD overlays. The request is
     * deliberately asynchronous so the shutter interaction remains immediate.
     */
    private boolean requestRealtimePreviewFrame(CaptureAlbumFeedback target, View preview) {
        if (destroyed || target == null || preview == null || !preview.isAttachedToWindow()
                || preview.getWidth() <= 0 || preview.getHeight() <= 0
                || android.os.Build.VERSION.SDK_INT < 26) return false;
        SurfaceView surface = findVideoSurface(preview);
        if (surface == null || !surface.getHolder().getSurface().isValid()) return false;
        Rect visible = new Rect();
        if (!surface.getGlobalVisibleRect(visible) || visible.isEmpty()) return false;
        int[] surfaceOrigin = new int[2]; surface.getLocationOnScreen(surfaceOrigin);
        visible.offset(-surfaceOrigin[0], -surfaceOrigin[1]);
        if (!visible.intersect(0, 0, surface.getWidth(), surface.getHeight()) || visible.isEmpty()) return false;
        int max = 512;
        float scale = Math.min(1f, max / (float) Math.max(visible.width(), visible.height()));
        int width = Math.max(1, Math.round(visible.width() * scale));
        int height = Math.max(1, Math.round(visible.height() * scale));
        final Bitmap snapshot = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        try {
            PixelCopy.request(surface, visible, snapshot, result -> {
                if (!destroyed && target == captureAlbum
                        && preview == capturePreviewFrame && foreground && target.hasOptimisticFlight()) {
                    // play() takes its own copy, so this callback can always
                    // recycle the PixelCopy buffer after returning.
                    if (result == PixelCopy.SUCCESS) target.play(snapshot, preview);
                    else target.playPreview(preview);
                }
                snapshot.recycle();
            }, handler);
            return true;
        } catch (RuntimeException unavailable) {
            snapshot.recycle();
            return false;
        }
    }

    private static SurfaceView findVideoSurface(View view) {
        if (view instanceof SurfaceView) return (SurfaceView) view;
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                SurfaceView surface = findVideoSurface(group.getChildAt(i));
                if (surface != null) return surface;
            }
        }
        return null;
    }

    private void confirmPhotoCapture() {
        if (captureFlash == null || primaryShutter == null) return;
        if (!optimisticPhotoFeedback) {
            captureFlash.animate().cancel();
            captureFlash.setVisibility(View.VISIBLE);
            captureFlash.setAlpha(.82f);
            captureFlash.animate().alpha(0f).setDuration(240).withEndAction(() -> {
                if (captureFlash != null) captureFlash.setVisibility(View.GONE);
            }).start();
            primaryShutter.performHapticFeedback(shutterConfirmFeedback());
        }
        optimisticPhotoFeedback = false;
        primaryShutter.animate().cancel();
        primaryShutter.setScaleX(.90f); primaryShutter.setScaleY(.90f);
        primaryShutter.animate().scaleX(1f).scaleY(1f).setDuration(150)
                .setInterpolator(new android.view.animation.OvershootInterpolator(1.35f)).start();
    }
    private void confirmVideoCapture() {
        if (primaryShutter == null) return;
        primaryShutter.performHapticFeedback(shutterConfirmFeedback());
        primaryShutter.animate().cancel();
        primaryShutter.setScaleX(.94f); primaryShutter.setScaleY(.94f);
        primaryShutter.animate().scaleX(1f).scaleY(1f).setDuration(130)
                .setInterpolator(new android.view.animation.OvershootInterpolator(1.25f)).start();
    }
    private int shutterConfirmFeedback() {
        return android.os.Build.VERSION.SDK_INT >= 30
                ? android.view.HapticFeedbackConstants.CONFIRM
                : android.view.HapticFeedbackConstants.VIRTUAL_KEY;
    }
    private void rejectCapture() {
        if (primaryShutter == null || !"control".equals(page)) return;
        primaryShutter.performHapticFeedback(android.os.Build.VERSION.SDK_INT >= 30
                ? android.view.HapticFeedbackConstants.REJECT : android.view.HapticFeedbackConstants.LONG_PRESS);
        primaryShutter.animate().cancel();
        primaryShutter.setScaleX(1f); primaryShutter.setScaleY(1f);
        // Translate the visual only; its measured bounds and neighboring
        // controls remain fixed. No successful-capture flash on this path.
        primaryShutter.setTranslationX(0f);
        android.animation.ObjectAnimator shake = android.animation.ObjectAnimator.ofFloat(primaryShutter,
                "translationX", 0f, -dp(4), dp(4), -dp(2), dp(2), 0f);
        shake.setDuration(220); shake.start();
    }
    private static final int TEXT = AppPalette.INK;
    private static final int SECONDARY = AppPalette.MUTED;

    private LinearLayout pageTitle(String title, String subtitle) {
        LinearLayout header = column();
        TextView heading = label(title, 22); heading.setPadding(0, 0, 0, dp(12)); heading.setTextColor(TEXT); heading.setTypeface(android.graphics.Typeface.create("sans-serif-medium", android.graphics.Typeface.NORMAL));
        TextView sub = label(subtitle, 14); sub.setTextColor(SECONDARY); sub.setPadding(0, 0, 0, dp(12));
        header.addView(heading); if (!subtitle.isEmpty()) header.addView(sub); return header;
    }

    private View navigationHeading(String title, String backLabel, Runnable back) {
        LinearLayout heading = row(); heading.setGravity(Gravity.CENTER_VERTICAL);
        Button arrow = button("‹", back); arrow.setContentDescription(backLabel);
        arrow.setTextColor(TEXT); arrow.setTextSize(28); arrow.setBackgroundColor(Color.TRANSPARENT);
        arrow.setPadding(0, 0, dp(12), 0); heading.addView(arrow, new LinearLayout.LayoutParams(dp(40), dp(52)));
        TextView name = label(title, 20); name.setTypeface(android.graphics.Typeface.create("sans-serif-medium", android.graphics.Typeface.NORMAL)); name.setPadding(0,0,0,0);
        name.setMaxLines(1); name.setEllipsize(android.text.TextUtils.TruncateAt.END);
        heading.addView(name, weight()); return heading;
    }

    private TextView sectionHeader(String title) {
        TextView view = label(title, 13); view.setTextColor(SECONDARY); view.setTypeface(null, android.graphics.Typeface.BOLD);
        view.setPadding(dp(4), dp(18), dp(4), dp(7)); return view;
    }

    private TextView sectionTitle(String title) {
        TextView view = label(title, 13); view.setTextColor(SECONDARY); view.setTypeface(null, android.graphics.Typeface.BOLD);
        view.setPadding(0, 0, 0, dp(6)); return view;
    }

    private LinearLayout card() {
        LinearLayout view = column(); view.setPadding(dp(16), dp(14), dp(16), dp(14));
        view.setBackground(round(AppPalette.SURFACE, 16)); view.setElevation(0);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(-1, -2); params.setMargins(0, 0, 0, dp(10)); view.setLayoutParams(params);
        return view;
    }

    private View settingRow(String key) {
        LinearLayout row = column();
        row.setPadding(dp(16), dp(13), dp(12), dp(13)); row.setBackgroundColor(AppPalette.SURFACE);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(-1, -2); params.setMargins(0, 0, 0, 1); row.setLayoutParams(params);
        LinearLayout heading = row(); heading.setGravity(Gravity.CENTER_VERTICAL);
        TextView name = label(CameraSettings.displayName(key), 16); name.setTextColor(TEXT); name.setPadding(0, 0, dp(12), 0);
        heading.addView(name, new LinearLayout.LayoutParams(0, -2, 1));
        boolean editable = CameraSettings.safeKey(key) && !CameraSettings.readOnly(key);
        boolean clock = "camera_clock".equals(key);
        TextView value = label(CaptureParameters.settingValue(settings, key), 13); settingValues.put(key, value);
        // Make the active value read as a control state at a glance. The
        // affordance remains compact so long values still fit beside the row
        // title and disclosure indicator.
        value.setTextColor(editable ? ACCENT : SECONDARY);
        value.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL); value.setMaxWidth(dp(138)); value.setMaxLines(2);
        value.setEllipsize(android.text.TextUtils.TruncateAt.END); value.setPadding(dp(8), dp(2), dp(8), dp(2));
        heading.addView(value);
        TextView accessory = label(clock ? "同步" : editable ? "›" : "", editable ? 28 : 12); accessory.setTextColor(editable ? ACCENT : SECONDARY);
        accessory.setGravity(Gravity.CENTER); accessory.setPadding(0, 0, 0, 0); heading.addView(accessory, new LinearLayout.LayoutParams(clock ? dp(38) : editable ? dp(24) : 0, dp(34)));
        row.addView(heading, new LinearLayout.LayoutParams(-1, -2));
        if (clock) { row.setOnClickListener(v -> syncCameraClock()); row.setContentDescription("相机日期与时间，点击同步手机时间"); }
        else if (editable) { row.setOnClickListener(v -> options(key)); row.setClickable(true); }
        return row;
    }

    private String settingGroup(String key) {
        String value = key.toLowerCase(java.util.Locale.ROOT);
        if (value.contains("product") || value.contains("version") || value.contains("battery") || value.contains("sd_card")) return "相机信息";
        if (value.contains("system_mode") || value.contains("rec_") || value.contains("loop") || value.contains("timelapse")) return "拍摄";
        if (value.contains("video") || value.contains("eis") || value.contains("photo") || value.contains("iso") || value.contains("white") || value.contains("shutter") || value.equals("ev")) return "画面与质量";
        if (value.contains("power") || value.contains("date") || value.contains("language")) return "通用";
        return "其他相机设置";
    }

    private View mediaFileCard(MediaEntry entry) {
        // Playback is the primary action; selection is contextual.
        LinearLayout card = column(); card.setPadding(0, dp(3), 0, dp(5)); card.setBackgroundColor(Color.TRANSPARENT); card.setElevation(0);
        LinearLayout.LayoutParams cardParams = new LinearLayout.LayoutParams(0, -2, 1); cardParams.setMargins(0, dp(8), 0, 0); card.setLayoutParams(cardParams);
        FrameLayout thumb = new FrameLayout(this); thumb.setBackground(round(mediaColor(entry), 14));
        int widthDp = Math.max(1, Math.round(getResources().getDisplayMetrics().widthPixels / getResources().getDisplayMetrics().density));
        int cardWidth = Math.max(1, (widthDp - 56) / 2);
        int thumbHeight = Math.max(dp(104), Math.min(dp(180), Math.round(dp(cardWidth) * 9f / 16f)));
        LinearLayout.LayoutParams thumbParams = new LinearLayout.LayoutParams(-1, thumbHeight); thumbParams.setMargins(0, 0, 0, dp(7)); thumb.setLayoutParams(thumbParams);
        boolean video = "VIDEO".equals(mediaType(entry));
        TextView type = label(video ? "视频" : "照片", 13); type.setTextColor(Color.WHITE); type.setGravity(Gravity.CENTER); type.setTypeface(null, android.graphics.Typeface.BOLD); type.setLetterSpacing(0.08f);
        thumb.addView(type, new FrameLayout.LayoutParams(-1, -1));
        type.setContentDescription("打开原片：" + entry.name); type.setOnClickListener(v -> activateMediaCard(entry));
        thumb.setClipToOutline(true);
        android.widget.ImageView image = new android.widget.ImageView(this);
        image.setScaleType(android.widget.ImageView.ScaleType.CENTER_CROP);
        image.setContentDescription("原片封面：" + entry.name); image.setVisibility(View.GONE);
        image.setOnClickListener(v -> activateMediaCard(entry));
        thumb.addView(image, new FrameLayout.LayoutParams(-1, -1)); thumbnailViews.add(image);
        if (thumbnails != null) {
            CameraThumbnailStore.Callback cover = thumbnailCallback(image, type);
            if (video) {
                // Video covers are loaded from the session cache after a
                // viewer has opened the original; never download a whole
                // video just to draw the grid.
                thumbnails.load(entry, cover);
            } else if (camera.isConnected() && network != null && CameraState.isReady(cameraStatus)
                    && CameraThumbnailStore.isBoundedPhoto(entry)) {
                // Photo covers are small and bounded, so the library starts
                // the real preview request automatically as soon as the
                // folder is drawn. This removes the per-card "读取封面"
                // action and keeps every grid cell aligned.
                thumbnails.requestPhoto(network, connectedHost, cameraHttpPort(), entry, cover);
            } else {
                thumbnails.load(entry, cover);
            }
        }
        if (mediaSelectionMode) {
            CheckBox choose = new CheckBox(this);
            choose.setContentDescription("选择原片：" + entry.name);
            choose.setButtonTintList(android.content.res.ColorStateList.valueOf(Color.WHITE));
            choose.setChecked(selectedMedia.containsKey(entry.path));
            choose.setOnCheckedChangeListener((view, checked) -> {
                if (checked) selectedMedia.put(entry.path, entry); else selectedMedia.remove(entry.path);
                updateExportSelectedButton();
            });
            FrameLayout.LayoutParams checkParams = new FrameLayout.LayoutParams(dp(48), dp(48), Gravity.TOP | Gravity.RIGHT);
            thumb.addView(choose, checkParams);
        }
        card.addView(thumb);
        TextView badge = mediaOverlayBadge(video ? "视频" : "照片", Gravity.BOTTOM | Gravity.LEFT);
        thumb.addView(badge, overlayParams(Gravity.BOTTOM | Gravity.LEFT));
        if (CameraMediaViewer.isFavorite(this, connectedHost, cameraHttpPort(), entry)) {
            TextView favorite = mediaOverlayBadge("★", Gravity.TOP | Gravity.LEFT);
            favorite.setTextSize(16); favorite.setTextColor(Color.WHITE); favorite.setContentDescription("已收藏：" + entry.name);
            thumb.addView(favorite, overlayParams(Gravity.TOP | Gravity.LEFT));
        }
        TextView name = label(entry.name, 12); name.setTextColor(TEXT); name.setMaxLines(1); name.setEllipsize(android.text.TextUtils.TruncateAt.MIDDLE); name.setPadding(dp(2), 0, dp(2), dp(1)); card.addView(name);
        name.setOnClickListener(v -> activateMediaCard(entry));
        String size = entry.bytes < 0 ? "大小未知" : String.format(java.util.Locale.CHINA, entry.bytes >= 1048576 ? "%.1f MB" : "%.0f KB", entry.bytes / (entry.bytes >= 1048576 ? 1048576.0 : 1024.0));
        String favorite = CameraMediaViewer.isFavorite(this, connectedHost, cameraHttpPort(), entry) ? " · 已收藏" : "";
        TextView info = label(size + favorite, 11); info.setTextColor(SECONDARY); info.setMaxLines(1); info.setEllipsize(android.text.TextUtils.TruncateAt.END); info.setPadding(dp(2), 0, dp(2), dp(2)); card.addView(info);
        View.OnLongClickListener select = view -> {
            mediaSelectionMode = true; selectedMedia.put(entry.path, entry); redrawMediaSelection(); return true;
        };
        card.setOnClickListener(v -> activateMediaCard(entry));
        thumb.setOnClickListener(v -> activateMediaCard(entry));
        card.setOnLongClickListener(select); thumb.setOnLongClickListener(select);
        type.setOnLongClickListener(select); image.setOnLongClickListener(select);
        name.setOnLongClickListener(select); info.setOnLongClickListener(select);
        return card;
    }

    /** Compact translucent metadata pill used on media thumbnails, matching the prototype grid. */
    private TextView mediaOverlayBadge(String text, int gravity) {
        TextView badge = label(text, 11); badge.setTextColor(Color.WHITE); badge.setGravity(Gravity.CENTER);
        badge.setTypeface(null, android.graphics.Typeface.BOLD); badge.setPadding(dp(9), 0, dp(9), 0);
        badge.setMinWidth(dp(42)); badge.setBackground(round(Color.argb(168, 25, 31, 40), 18));
        badge.setContentDescription(text); return badge;
    }

    private String mediaType(MediaEntry entry) { return entry.name.toLowerCase(java.util.Locale.ROOT).endsWith(".mp4") ? "VIDEO" : "PHOTO"; }
    private int mediaColor(MediaEntry entry) { return "VIDEO".equals(mediaType(entry)) ? Color.rgb(42, 46, 49) : Color.rgb(103, 112, 118); }
    private boolean mediaMatchesFilter(MediaEntry entry) { return "all".equals(mediaFilter) || ("video".equals(mediaFilter) && "VIDEO".equals(mediaType(entry))) || ("photo".equals(mediaFilter) && "PHOTO".equals(mediaType(entry))) || ("favorite".equals(mediaFilter) && CameraMediaViewer.isFavorite(this, connectedHost, cameraHttpPort(), entry)); }
    private void activateMediaCard(MediaEntry entry) {
        if (!mediaSelectionMode) { openMedia(entry); return; }
        if (selectedMedia.containsKey(entry.path)) selectedMedia.remove(entry.path);
        else selectedMedia.put(entry.path, entry);
        redrawMediaSelection();
    }
    private void redrawMediaSelection() {
        int position = scroll.getScrollY(); drawMedia(); scroll.post(() -> scroll.scrollTo(0, position));
    }
    private String mediaFilterLabel() {
        switch (mediaFilter) {
            case "video": return "视频";
            case "photo": return "照片";
            case "favorite": return "收藏";
            default: return "全部";
        }
    }
    private void showMediaFilters() {
        String[] names = {"全部", "视频", "照片", "收藏"};
        String[] values = {"all", "video", "photo", "favorite"};
        ArrayList<CameraOptionSheet.Row> rows = new ArrayList<>();
        for (int i = 0; i < values.length; i++) rows.add(new CameraOptionSheet.Row(
                names[i], "", java.util.Collections.emptyList(), values[i].equals(mediaFilter)));
        CameraOptionSheet.show(this, "筛选相册", rows, which -> { mediaFilter = values[which]; drawMedia(); });
    }
    private void showMediaMore(View anchor) {
        android.widget.PopupMenu menu = new android.widget.PopupMenu(this, anchor);
        menu.getMenu().add("刷新").setOnMenuItemClickListener(item -> { listMedia(folder); return true; });
        menu.show();
    }
    private void updateExportSelectedButton() {
        if (exportSelectedButton != null) exportSelectedButton.setText("导出选中（" + selectedMedia.size() + "）");
    }

    private LinearLayout createBottomNav() {
        LinearLayout nav = row(); nav.setGravity(Gravity.CENTER); nav.setPadding(0, dp(5), 0, dp(5)); nav.setBackgroundColor(Color.TRANSPARENT);
        nav.setElevation(0);
        navCapture = navButton("拍摄", 0, () -> { page = "control"; drawControl(); });
        navMedia = navButton("相册", 1, () -> { page = "media"; drawMedia(); });
        navEdit = navButton("剪辑", 2, () -> { page = "edit"; drawEdit(); });
        navSettings = navButton("设置", 3, () -> { page = "settings"; drawSettings(); });
        nav.addView(navCapture, weight()); nav.addView(navMedia, weight()); nav.addView(navEdit, weight()); nav.addView(navSettings, weight()); return nav;
    }

    private Button navButton(String title, int icon, Runnable action) { Button b = button(title, action); b.setTextSize(11); b.setGravity(Gravity.CENTER); b.setTextColor(SECONDARY); b.setBackgroundColor(Color.TRANSPARENT); b.setPadding(0, dp(3), 0, 0); addIcon(b, icon, SECONDARY, true); return b; }
    private Button captureShortcut(String title, int icon, Runnable action) { Button b = navButton(title, icon, action); b.setTextSize(12); addIcon(b, icon, Color.BLACK, true); b.setCompoundDrawablePadding(dp(8)); return b; }
    private void selectNav(int index) {
        captureActions.setVisibility(index == 0 ? View.VISIBLE : View.GONE);
        if (navCapture == null) return;
        Button[] buttons = {navCapture, navMedia, navEdit, navSettings};
        for (int i = 0; i < buttons.length; i++) {
            int color = index == i ? ACCENT : SECONDARY; buttons[i].setTextColor(color);
            for (android.graphics.drawable.Drawable icon : buttons[i].getCompoundDrawables()) if (icon != null) icon.setTint(color);
        }
    }
    private Button actionButton(String text, int color, Runnable action) { Button b = button(text, action); b.setTextSize(17); b.setTextColor(Color.WHITE); b.setBackground(round(color, 14)); return b; }
    private Button textButton(String text, boolean filled, Runnable action) { Button b = button(text, action); b.setTextSize(14); b.setTextColor(filled ? Color.WHITE : ACCENT); b.setBackground(round(filled ? ACCENT : AppPalette.BACKGROUND, 12)); b.setPadding(dp(12), 0, dp(12), 0); return b; }
    private LinearLayout.LayoutParams buttonParams(int margin, int height) { LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(-2, height); p.setMargins(margin, 0, 0, 0); return p; }
    private LinearLayout.LayoutParams weightWithMargin(int margin) { LinearLayout.LayoutParams p = weight(); p.setMargins(margin, 0, margin, 0); return p; }
    private GradientDrawable round(int color, int radius) { GradientDrawable d = new GradientDrawable(); d.setColor(color); d.setCornerRadius(dp(radius)); return d; }

    private void addIcon(TextView view, int type, int color, boolean above) {
        LineIcon icon = new LineIcon(type, color); icon.setBounds(0, 0, dp(23), dp(23));
        view.setCompoundDrawables(above ? null : icon, above ? icon : null, null, null);
        view.setCompoundDrawablePadding(dp(5));
    }
    private static final class LineIcon extends android.graphics.drawable.Drawable {
        private final int type;
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        LineIcon(int type, int color) { this.type = type; paint.setColor(color); paint.setStyle(Paint.Style.STROKE); paint.setStrokeWidth(1.6f); paint.setStrokeCap(Paint.Cap.ROUND); paint.setStrokeJoin(Paint.Join.ROUND); }
        @Override public void draw(Canvas c) {
            c.save(); c.translate(getBounds().left, getBounds().top); c.scale(getBounds().width()/24f, getBounds().height()/24f);
            switch (type) {
                case 0:
                    c.drawRoundRect(2, 6, 22, 21, 3, 3, paint); c.drawCircle(12, 13, 4, paint);
                    c.drawLine(7, 6, 9, 3, paint); c.drawLine(9, 3, 15, 3, paint); c.drawLine(15, 3, 17, 6, paint); break;
                case 1:
                    c.drawRoundRect(3, 3, 21, 21, 3, 3, paint); c.drawCircle(8, 8, 1.3f, paint);
                    Path mountains = new Path(); mountains.moveTo(4, 18); mountains.lineTo(10, 12); mountains.lineTo(14, 16); mountains.lineTo(17, 13); mountains.lineTo(21, 17); c.drawPath(mountains, paint); break;
                case 2:
                    c.drawCircle(6, 18, 3, paint); c.drawCircle(18, 18, 3, paint);
                    c.drawLine(8, 16, 20, 3, paint); c.drawLine(16, 16, 4, 3, paint); break;
                case 3:
                    c.drawCircle(12, 12, 7, paint); c.drawCircle(12, 12, 2.5f, paint);
                    for (int i=0; i<8; i++) { c.save(); c.rotate(i*45, 12, 12); c.drawLine(12, 2, 12, 5, paint); c.restore(); } break;
                case 4:
                    c.drawRoundRect(2, 6, 20, 18, 2, 2, paint); c.drawLine(22, 10, 22, 14, paint); break;
                case 5:
                    Path card = new Path(); card.moveTo(5, 3); card.lineTo(19, 3); card.lineTo(19, 21); card.lineTo(4, 21); card.lineTo(4, 8); card.close(); c.drawPath(card, paint);
                    for (int i=8; i<=16; i+=3) c.drawLine(i, 6, i, 9, paint); break;
                case 7:
                    // Camera switch glyph used by the capture shortcut. Keep
                    // it as a line icon so it remains legible in light and
                    // dark states without importing a bitmap asset.
                    c.drawRoundRect(3, 7, 21, 18, 3, 3, paint);
                    c.drawCircle(12, 12.5f, 3.2f, paint);
                    c.drawArc(1, 3, 9, 11, 300, 180, false, paint);
                    c.drawArc(15, 13, 23, 21, 120, 180, false, paint);
                    c.drawLine(2, 5, 5, 3, paint); c.drawLine(2, 5, 5, 7, paint);
                    c.drawLine(22, 19, 19, 21, paint); c.drawLine(22, 19, 19, 17, paint); break;
                default:
                    c.drawArc(2, 4, 22, 24, 220, 100, false, paint); c.drawArc(6, 9, 18, 21, 220, 100, false, paint); c.drawCircle(12, 19, .8f, paint); break;
            }
            c.restore();
        }
        @Override public void setTint(int color) { paint.setColor(color); invalidateSelf(); }
        @Override public void setAlpha(int alpha) { paint.setAlpha(alpha); }
        @Override public void setColorFilter(android.graphics.ColorFilter filter) { paint.setColorFilter(filter); }
        @Override public int getOpacity() { return android.graphics.PixelFormat.TRANSLUCENT; }
    }

    private void capture(int id) {
        final long generation = connectionGeneration.get();
        work(() -> {
            java.util.Set<String> photoBaseline = null;
            if (id == 16777220) {
                try { photoBaseline = readCameraPhotos().keySet(); }
                catch (Exception unavailable) { /* Taking a photo must not depend on album indexing. */ }
            }
            final java.util.Set<String> previousPhotos = photoBaseline;
            String status = camera.call(1, CameraClient.args("type", "app_status")).getString("param");
            if (id != 514 && !CameraState.isReady(status)) throw new java.io.IOException("相机当前忙碌：" + status);
            if (id != 514) {
                String mode = camera.call(1, CameraClient.args("type", "system_mode")).getString("param");
                if (!mode.equals(id == 513 ? "record" : "capture")) throw new java.io.IOException("请先在配置页选择" + (id == 513 ? "录像" : "拍照") + "模式");
            }
            camera.call(id, id == 16777220 ? CameraClient.args("param", "precise quality;off") : new JSONObject());
            String confirmedStatus = CameraState.awaitCaptureState(camera, id);
            // Capture confirmation must not wait for unrelated configuration
            // and battery requests. Preserve the actual observed status;
            // telemetry refresh runs separately after the action unlocks.
            ui(() -> {
                if (generation != connectionGeneration.get() || !camera.isConnected()) return;
                cameraStatus = confirmedStatus;
                // A confirmed photo or completed recording invalidates the
                // album snapshot, including an already populated library.
                if (id == 16777220 || id == 514) mediaAutoLoadRequested = false;
                capturePending = false; pendingCaptureRequest = -1;
                updateCaptureViews();
                if (!"control".equals(page)) return;
                if (id == 16777220) {
                    confirmPhotoCapture();
                    if (previousPhotos != null) loadCaptureAlbum(true, previousPhotos);
                }
                else confirmVideoCapture();
            });
        }, true, id);
    }
    private void drawSettings() {
        page = "settings";
        // Settings are browsed by category; keep this page free of a second
        // search surface so hierarchy and current values stay prominent.
        settingsQuery = "";
        prepareLightPage(); content.removeAllViews(); settingValues.clear();
        String title = "other".equals(settingsGroup) ? "更多设置" : "设置";
        for (SettingsHierarchy.Group group : SettingsHierarchy.build(settings)) if (group.id.equals(settingsGroup)) title = group.title;
        if (settingsGroup.isEmpty()) content.addView(pageTitle(title, "按分类查找相机功能与参数"));
        else content.addView(navigationHeading(title, "返回设置", () -> { settingsGroup = ""; settingsQuery = ""; drawSettings(); }));
        settingsList = column(); content.addView(settingsList, spaced(-1, -2, 8)); renderSettingsList();
        selectNav(3); updateOperation();
    }
    private List<String> settingsMembership(JSONObject values) {
        ArrayList<String> keys = new ArrayList<>();
        for (SettingsHierarchy.Group group : SettingsHierarchy.build(values, settingsQuery))
            if (!settingsQuery.trim().isEmpty() || settingsGroup.isEmpty() || settingsGroup.equals(group.id))
                for (SettingsHierarchy.Section section : group.sections) keys.addAll(section.keys);
        return keys;
    }
    private void renderSettingsList() {
        settingsList.removeAllViews(); settingValues.clear();
        List<SettingsHierarchy.Group> groups = SettingsHierarchy.build(settings, settingsQuery);
        if (groups.isEmpty()) { settingsList.addView(label(camera.isConnected() ? "没有匹配的设置" : "连接相机后，即可查看和调整全部参数。", 14)); return; }
        for (SettingsHierarchy.Group group : groups) {
            if (settingsGroup.isEmpty() && settingsQuery.trim().isEmpty()) {
                LinearLayout item = card(); item.setElevation(0); item.setPadding(dp(16), dp(12), dp(16), dp(12));
                LinearLayout heading = row(); heading.setGravity(Gravity.CENTER_VERTICAL);
                TextView name = label(group.title, 17); name.setTypeface(null, android.graphics.Typeface.BOLD);
                heading.addView(name, weight()); heading.addView(label("›", 26)); item.addView(heading);
                String sections = group.sections.stream().map(section -> section.title).collect(java.util.stream.Collectors.joining(" · "));
                TextView sub = label(sections, 12); sub.setTextColor(SECONDARY); item.addView(sub);
                item.setContentDescription(group.title); item.setOnClickListener(v -> { settingsGroup = group.id; drawSettings(); scroll.scrollTo(0, 0); });
                settingsList.addView(item);
            } else if (!settingsQuery.trim().isEmpty() || settingsGroup.isEmpty() || settingsGroup.equals(group.id)) {
                for (SettingsHierarchy.Section section : group.sections) {
                    settingsList.addView(sectionHeader(settingsQuery.isEmpty() ? section.title : group.title + " · " + section.title));
                    // Keep related controls inside a single surface so each
                    // option reads as a distinct row while the section itself
                    // remains visually separated from the next one.
                    LinearLayout sectionCard = column();
                    sectionCard.setPadding(0, 0, 0, 0); sectionCard.setElevation(0);
                    sectionCard.setBackground(round(AppPalette.SURFACE, 14));
                    LinearLayout.LayoutParams cardParams = new LinearLayout.LayoutParams(-1, -2);
                    cardParams.setMargins(0, 0, 0, dp(10)); sectionCard.setLayoutParams(cardParams);
                    for (String key : section.keys) sectionCard.addView(settingRow(key));
                    settingsList.addView(sectionCard);

                }
            }
        }
    }

    private void syncCameraClock() {
        if (!camera.isConnected()) { note("请先连接相机"); return; }
        closeLivePreview();
        work(() -> {
            String actual = CameraConfiguration.syncClock(camera);
            refresh(true);
            ui(() -> note("相机时间已同步：" + actual));
        });
    }

    private static final int PICK_EDIT_VIDEO = 62;
    private void drawEdit() {
        page = "edit"; prepareLightPage(); content.removeAllViews();
        content.addView(pageTitle("剪辑", ""));
        TextView step = label("01  /  选择素材", 12); step.setTextColor(ACCENT); step.setLetterSpacing(.08f);
        content.addView(step, spaced(-1, -2, 24));
        TextView title = label("从一段视频开始", 22); title.setTextColor(TEXT);
        title.setTypeface(android.graphics.Typeface.create("sans-serif-medium", android.graphics.Typeface.NORMAL));
        content.addView(title, spaced(-1, -2, 12));
        TextView hint = label("选择视频后进入编辑。截取片段、调整画面，再保存为新的副本。", 14);
        hint.setTextColor(SECONDARY); hint.setLineSpacing(dp(5), 1);
        content.addView(hint, spaced(-1, -2, 12));
        LinearLayout sources = column(); sources.setPadding(dp(18), dp(16), dp(18), dp(16));
        sources.setBackground(round(AppPalette.SURFACE, 16));
        TextView local = label("手机视频", 17); local.setTextColor(TEXT); sources.addView(local);
        TextView localHint = label("从手机相册或文件中选择视频", 13); localHint.setTextColor(SECONDARY); sources.addView(localHint);
        sources.addView(actionButton("选择视频", ACCENT, this::pickEditVideo), spaced(-1, dp(52), 18));
        content.addView(sources, spaced(-1, -2, 28));
        TextView cameraHint = label("相机素材", 17); cameraHint.setTextColor(TEXT);
        content.addView(cameraHint, spaced(-1, -2, 28));
        TextView detail = label("在相册打开视频，选择“在剪辑中打开”", 13); detail.setTextColor(SECONDARY);
        content.addView(detail, spaced(-1, -2, 6));
        content.addView(textButton("浏览相机相册  ›", false, () -> { page = "media"; drawMedia(); }), spaced(-1, dp(48), 12));
        selectNav(2); updateOperation(); scroll.scrollTo(0, 0);
    }
    private void pickEditVideo() {
        Intent picker = new Intent(Intent.ACTION_OPEN_DOCUMENT).setType("video/*")
                .addCategory(Intent.CATEGORY_OPENABLE)
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
        try { startActivityForResult(picker, PICK_EDIT_VIDEO); }
        catch (android.content.ActivityNotFoundException unavailable) { note("未找到视频选择器，请先安装文件管理器后重试"); }
    }
    @Override protected void onActivityResult(int request, int result, Intent data) {
        super.onActivityResult(request, result, data);
        if (request != PICK_EDIT_VIDEO || result != RESULT_OK || data == null || data.getData() == null) return;
        android.net.Uri uri = data.getData();
        if ((data.getFlags() & Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION) != 0) {
            try { getContentResolver().takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION); }
            catch (SecurityException ignored) { /* The current read grant can still import this selection. */ }
        }
        startActivity(new Intent(this, VideoEditorActivity.class).setData(uri)
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION));
    }

    private void prepareLightPage() {
        if (monitorMode) toggleMonitorMode();
        clearAlbumThumbnails();
        closeLivePreview();
        bottomNav.setVisibility(View.VISIBLE);
        getWindow().setStatusBarColor(AppPalette.BACKGROUND);
        scroll.setBackground(new PaperDrawable()); content.setBackgroundColor(Color.TRANSPARENT);
        content.setPadding(dp(20), dp(18), dp(20), dp(12));
    }
    private void options(String key) {
        work(() -> {
            JSONObject response = camera.call(9, CameraClient.args("param", key));
            List<Object> values = CameraSettings.writableOptions(key, response);
            if (values.isEmpty()) {
                ui(() -> CameraOptionSheet.info(this, CameraSettings.displayName(key),
                        "当前值：" + CameraSettings.displayValue(key, settings.opt(key)) + "\n相机没有提供可修改的选项。"));
                return;
            }
            if (key.contains("resolution") || "slow_motion_res".equals(key) || "photo_size".equals(key)) {
                ui(() -> showResolutionOptions(key, values)); return;
            }
            ui(() -> {
                ArrayList<CameraOptionSheet.Row> rows = new ArrayList<>();
                for (Object value : values) rows.add(new CameraOptionSheet.Row(
                        CameraSettings.displayValue(key, value), "", java.util.Collections.emptyList(),
                        String.valueOf(value).equals(String.valueOf(settings.opt(key)))));
                CameraOptionSheet.show(this, CameraSettings.displayName(key), rows, which -> {
                    closeLivePreview(); work(() -> {
                        configureAndRefresh(() -> CameraConfiguration.set(camera, key, values.get(which)));
                        ui(() -> note("配置已更新"));
                    });
                });
            });
        });
    }
    private void showResolutionOptions(String key, List<Object> values) {
        ArrayList<CameraOptionSheet.Row> rows = new ArrayList<>();
        for (Object value : values) {
            CameraOptionPresentation.Option option = CameraOptionPresentation.present(key, value, settings);
            ArrayList<String> tags = new ArrayList<>();
            if (option.title.contains(" ")) tags.add(option.title.substring(0, option.title.indexOf(' ')));
            tags.addAll(option.tags);
            rows.add(new CameraOptionSheet.Row(option.title, option.subtitle, tags,
                    String.valueOf(value).equals(String.valueOf(settings.opt(key)))));
        }
        CameraOptionSheet.show(this, CameraSettings.displayName(key), rows, which -> {
            closeLivePreview(); work(() -> {
                configureAndRefresh(() -> CameraConfiguration.set(camera, key, values.get(which)));
                ui(() -> note("配置已更新"));
            });
        });
    }
    private void configureAndRefresh(Work change) throws Exception {
        Exception original = null;
        try { change.run(); } catch (Exception error) { original = error; }
        if (camera.isConnected()) try { refresh(true); }
        catch (Exception error) { if (original != null) original.addSuppressed(error); else original = error; }
        // Configuration changes invalidate the camera's viewfinder stream.
        // Re-arm it after the new status/settings snapshot is available so a
        // mode, frame-rate, or resolution change never leaves a stale preview.
        if (original == null) ui(this::schedulePreview);
        if (original != null) throw original;
    }
    private void listMedia(String directory) {
        if (busy.get() || exporting.get() || mediaLoading) return;
        mediaLoading = true; mediaLoadError = ""; mediaAutoLoadRequested = true;
        long generation = connectionGeneration.get();
        work(() -> {
            try {
                List<MediaEntry> entries = CameraMediaLibrary.load(directory, path -> {
                    if (generation != connectionGeneration.get()) throw new java.io.IOException("相机连接已变化");
                    return camera.call(1282, CameraClient.args("param", path));
                });
                ui(() -> {
                    if (generation != connectionGeneration.get() || !camera.isConnected()) return;
                    mediaLoading = false; folder = directory; media.clear(); media.addAll(entries);
                    selectedMedia.keySet().retainAll(entries.stream().map(e -> e.path).collect(java.util.stream.Collectors.toSet()));
                    for (MediaEntry entry : entries) if (selectedMedia.containsKey(entry.path)) selectedMedia.put(entry.path, entry);
                    if (page.equals("media")) drawMedia();
                });
            } catch (Exception error) {
                ui(() -> {
                    if (generation != connectionGeneration.get()) return;
                    mediaLoading = false; mediaLoadError = "素材加载失败，请重试";
                    if (page.equals("media")) drawMedia();
                });
                throw error;
            }
        });
        if ("media".equals(page)) drawMedia();
    }
    private void drawMedia() {
        page = "media"; prepareLightPage();
        scroll.setBackground(new PaperDrawable()); content.setBackgroundColor(Color.TRANSPARENT);
        content.removeAllViews(); content.addView(pageTitle("相册", ""));
        if (!selectedMedia.isEmpty()) mediaSelectionMode = true;
        exportSelectedButton = null;
        LinearLayout libraryHeader = row(); libraryHeader.setGravity(Gravity.CENTER_VERTICAL);
        long mediaCount = media.stream().filter(entry -> entry.isMedia() && mediaMatchesFilter(entry)).count();
        TextView countLabel = label(mediaCount + " 个素材", 13); countLabel.setTextColor(SECONDARY);
        libraryHeader.addView(countLabel, new LinearLayout.LayoutParams(0, -2, 1));
        Button filter = textButton(mediaFilterLabel() + "⌄", false, this::showMediaFilters);
        filter.setContentDescription("筛选相册：" + mediaFilterLabel());
        libraryHeader.addView(filter, buttonParams(0, dp(40)));
        Button select = textButton(mediaSelectionMode ? "完成" : "选择", false, () -> {
            mediaSelectionMode = !mediaSelectionMode;
            if (!mediaSelectionMode) selectedMedia.clear();
            drawMedia();
        });
        select.setContentDescription(mediaSelectionMode ? "结束选择" : "选择原片");
        libraryHeader.addView(select, buttonParams(dp(4), dp(40)));
        Button more = textButton("···", false, () -> { }); more.setContentDescription("相册更多操作");
        more.setOnClickListener(view -> showMediaMore(view));
        libraryHeader.addView(more, buttonParams(dp(4), dp(40))); content.addView(libraryHeader);
        if (mediaSelectionMode) {
            LinearLayout batch = row(); batch.setGravity(Gravity.CENTER_VERTICAL);
            batch.setPadding(0, dp(6), 0, dp(4));
            Button all = textButton("全选", false, () -> {
                for (MediaEntry entry : media) if (entry.isMedia() && mediaMatchesFilter(entry)) selectedMedia.put(entry.path, entry);
                redrawMediaSelection();
            });
            batch.addView(all, buttonParams(0, dp(42)));
            Button cancel = textButton("取消", false, () -> { selectedMedia.clear(); mediaSelectionMode = false; drawMedia(); });
            batch.addView(cancel, buttonParams(dp(4), dp(42)));
            exportSelectedButton = actionButton("导出选中（" + selectedMedia.size() + "）", ACCENT,
                    () -> export(new ArrayList<>(selectedMedia.values())));
            exportSelectedButton.setTextSize(13);
            batch.addView(exportSelectedButton, new LinearLayout.LayoutParams(0, dp(42), 1));
            content.addView(batch);
        }
        LinearLayout grid = column(); grid.setPadding(dp(0), dp(4), dp(0), dp(4)); content.addView(grid);
        LinearLayout gridRow = null; int columns = 0; int visible = 0;
        for (MediaEntry entry : media) {
            if (!entry.directory && mediaMatchesFilter(entry)) {
                if (columns == 0) { gridRow = row(); grid.addView(gridRow, new LinearLayout.LayoutParams(-1, -2)); }
                gridRow.addView(mediaFileCard(entry)); spaceChildren(gridRow); columns = (columns + 1) % 2; visible++;
            }
        }
        if (columns == 1 && gridRow != null) { View spacer = new View(this); gridRow.addView(spacer, weight()); spaceChildren(gridRow); }
        if (mediaLoading || !mediaLoadError.isEmpty() || visible == 0) {
            String hint = !camera.isConnected() ? "请先连接相机" : mediaLoading ? "正在加载相机素材…"
                    : !mediaLoadError.isEmpty() ? mediaLoadError : media.isEmpty() ? "相机中还没有照片或视频" : "当前筛选没有匹配素材";
            TextView empty = label(hint, 14); empty.setTextColor(SECONDARY); empty.setGravity(Gravity.CENTER);
            content.addView(empty, spaced(-1, -2, 24));
            if (!mediaLoadError.isEmpty()) content.addView(textButton("重新加载", false, () -> listMedia(MediaEntry.DCIM_ROOT)), spaced(-1, dp(48), 8));
        }
        selectNav(1);
        updateOperation();
        // Opening the library should immediately populate the remembered
        // camera folder. The request is guarded so redraws from thumbnails or
        // selection changes never enqueue duplicate network calls.
        if (camera.isConnected() && !mediaAutoLoadRequested
                && !busy.get() && !exporting.get()) {
            mediaAutoLoadRequested = true;
            listMedia(MediaEntry.DCIM_ROOT);
        }
    }
    private void openMedia(MediaEntry entry) {
        if (!camera.isConnected()) { drawConnection(1); return; }
        work(() -> {
            if (!CameraState.isReady(camera.call(1, CameraClient.args("type", "app_status")).getString("param")))
                throw new java.io.IOException("请先停止拍摄再查看原片");
            Network route = network; String address = connectedHost;
            ui(() -> {
                if (!camera.isConnected() || network != route) { note("相机连接已变化，请重新连接后再打开原片"); return; }
                closeMediaViewer();
                if (!"media".equals(page)) return;
                if (thumbnails != null) thumbnails.cancelRequests();
                CameraMediaViewer opened = CameraMediaViewer.show(this, route, address, cameraHttpPort(), entry, thumbnails); mediaViewer = opened;
                opened.setOnCloseListener(() -> ui(() -> {
                    if (mediaViewer == opened) mediaViewer = null;
                    if (page.equals("media")) drawMedia();
                }));
            });
        });
    }
    private void closeMediaViewer() {
        if (mediaViewer != null) { mediaViewer.close(); mediaViewer = null; }
    }
    private CameraThumbnailStore.Callback thumbnailCallback(android.widget.ImageView image, TextView placeholder) {
        return new CameraThumbnailStore.Callback() {
            @Override public void loaded(android.graphics.Bitmap bitmap) {
                if (destroyed || !"media".equals(page) || !thumbnailViews.contains(image)) { bitmap.recycle(); return; }
                android.graphics.Bitmap old = image.getDrawable() instanceof android.graphics.drawable.BitmapDrawable
                        ? ((android.graphics.drawable.BitmapDrawable) image.getDrawable()).getBitmap() : null;
                thumbnailBitmaps.add(bitmap); image.setImageBitmap(bitmap); image.setVisibility(View.VISIBLE);
                if (old != null && old != bitmap) { thumbnailBitmaps.remove(old); if (!old.isRecycled()) old.recycle(); }
                placeholder.setVisibility(View.GONE);
            }
            @Override public void unavailable(String reason) { /* Keep the media type when a real cover is unavailable. */ }
        };
    }
    private void requestPhotoThumbnail(MediaEntry entry, android.widget.ImageView image, TextView placeholder) {
        CameraThumbnailStore store = thumbnails; Network route = network; String address = connectedHost;
        if (store == null || !camera.isConnected()) { note("请先连接相机"); return; }
        work(() -> {
            if (!CameraState.isReady(camera.call(1, CameraClient.args("type", "app_status")).getString("param")))
                throw new java.io.IOException("请先停止拍摄再读取照片封面");
            ui(() -> {
                if (store != thumbnails || route != network || !"media".equals(page) || exporting.get()) return;
                note("正在读取照片封面…");
                store.requestPhoto(route, address, cameraHttpPort(), entry, new CameraThumbnailStore.Callback() {
                    @Override public void loaded(android.graphics.Bitmap bitmap) {
                        thumbnailCallback(image, placeholder).loaded(bitmap); note("照片封面已读取");
                    }
                    @Override public void unavailable(String reason) { note(reason); }
                });
            });
        });
    }
    private void clearAlbumThumbnails() {
        ++albumLoadGeneration;
        if (captureAlbum != null) captureAlbum.cancel();
        if (thumbnails != null) thumbnails.cancelRequests();
        for (android.widget.ImageView view : thumbnailViews) { view.setImageDrawable(null); view.setVisibility(View.GONE); }
        thumbnailViews.clear();
        for (android.graphics.Bitmap bitmap : thumbnailBitmaps) if (!bitmap.isRecycled()) bitmap.recycle();
        thumbnailBitmaps.clear();
    }
    private void closeThumbnails() {
        captureAlbumEntry = null;
        if (captureAlbum != null) { captureAlbum.close(); captureAlbum = null; }
        clearAlbumThumbnails(); if (thumbnails != null) { thumbnails.close(); thumbnails = null; }
    }

    /** Read real camera folder entries; a complete before/after set prevents
     * an old photo from being animated as the just-confirmed capture. */
    private Map<String, MediaEntry> readCameraPhotos() throws Exception {
        LinkedHashMap<String, MediaEntry> photos = new LinkedHashMap<>();
        ArrayList<String> directories = new ArrayList<>(); directories.add(MediaEntry.DCIM_ROOT);
        for (int next = 0; next < directories.size(); next++) {
            JSONObject reply = camera.call(1282, CameraClient.args("param", directories.get(next)));
            JSONArray rows = reply.getJSONArray("listing");
            if (reply.optInt("total", rows.length()) > rows.length()) throw new java.io.IOException("相册列表未完整返回");
            for (int i = 0; i < rows.length(); i++) {
                JSONObject row = rows.getJSONObject(i);
                java.util.Iterator<String> keys = row.keys();
                while (keys.hasNext()) {
                    String name = keys.next(); MediaEntry entry = new MediaEntry(directories.get(next), name, row.getString(name));
                    if (entry.directory && !directories.contains(entry.path)) {
                        if (directories.size() >= 33) throw new java.io.IOException("相册文件夹数量超出预览范围");
                        directories.add(entry.path);
                    } else if (entry.isMedia() && !entry.name.toUpperCase(java.util.Locale.ROOT).endsWith(".MP4")) photos.put(entry.path, entry);
                }
            }
        }
        return photos;
    }

    private void loadCaptureAlbum(boolean animate, java.util.Set<String> before) {
        loadCaptureAlbum(animate, before, 0);
    }
    private void loadCaptureAlbum(boolean animate, java.util.Set<String> before, int attempt) {
        if (!camera.isConnected() || !"control".equals(page) || captureAlbum == null || thumbnails == null || exporting.get()) return;
        final long request = ++albumLoadGeneration, connection = connectionGeneration.get();
        final CaptureAlbumFeedback target = captureAlbum;
        final CameraThumbnailStore store = thumbnails;
        commands.submit(() -> {
            try {
                if (!CameraState.isReady(camera.call(1, CameraClient.args("type", "app_status")).getString("param"))) return;
                MediaEntry newest = readCameraPhotos().values().stream()
                        .filter(entry -> !animate || before != null && !before.contains(entry.path))
                        .max(Comparator.comparing(entry -> entry.path)).orElse(null);
                ui(() -> {
                    if (request != albumLoadGeneration || connection != connectionGeneration.get() || target != captureAlbum
                            || store != thumbnails || !"control".equals(page)) return;
                    if (newest == null) {
                        if (animate && attempt < 3) handler.postDelayed(() -> loadCaptureAlbum(true, before, attempt + 1), 350);
                        return;
                    }
                    captureAlbumEntry = newest;
                    store.requestPhoto(network, connectedHost, cameraHttpPort(), newest, new CameraThumbnailStore.Callback() {
                        @Override public void loaded(android.graphics.Bitmap bitmap) {
                            try {
                                if (request != albumLoadGeneration || connection != connectionGeneration.get() || target != captureAlbum
                                        || !"control".equals(page) || !foreground) return;
                                if (animate) {
                                    if (!target.consumeOptimisticFlight()) target.play(bitmap, capturePreviewFrame);
                                    else target.setThumbnail(bitmap);
                                } else target.setThumbnail(bitmap);
                            } finally { bitmap.recycle(); }
                        }
                        @Override public void unavailable(String explanation) { /* Keep last real cover; no simulated success flight. */ }
                    });
                });
            } catch (Exception unavailable) { /* Album preview is optional; capture outcome is independent. */ }
        });
    }
    private void startLivePreview() {
        if (!camera.isConnected()) { drawConnection(1); return; }
        if (livePreview != null && livePreview.isClosed()) closeLivePreview();
        if (livePreview != null || previewStarting || busy.get() || !foreground) return;
        previewStarting = true; previewAutoFailed = false;
        livePreviewStatus = "正在连接实时画面…"; if (previewStatus != null) previewStatus.setText(livePreviewStatus);
        final long generation = previewGeneration;
        final long cameraGeneration = connectionGeneration.get();
        final FrameLayout surface = previewSurface;
        commands.submit(() -> {
          try {
            if (!previewRequestCurrent(generation, cameraGeneration)) return;
            String address = CameraPreviewAddress.validate(connectedHost, camera.advertisedRtsp());
            Network route = network;
            if (route == null) throw new java.io.IOException("相机 Wi-Fi 已断开，请重新连接");
            String status = camera.call(1, CameraClient.args("type", "app_status")).getString("param");
            if (!previewRequestCurrent(generation, cameraGeneration)) return;
            if ("idle".equals(status)) camera.call(259);
            else if (!"vf".equals(status) && !"record".equals(status)) throw new java.io.IOException("相机忙碌，请稍后再开启预览");
            refresh(false);
            ui(() -> {
                if (generation != previewGeneration || !foreground || !"control".equals(page) || route != network || !camera.isConnected()) return;
                try {
                    livePreview = CameraLivePreview.start(this, surface, route, address,
                            text -> { if (generation == previewGeneration) {
                                livePreviewStatus = text; previewStatus.setText(text);
                                previewStatus.setVisibility("实时画面已连接".equals(text) ? View.GONE : View.VISIBLE);
                                previewParameters.setVisibility("实时画面已连接".equals(text) ? View.VISIBLE : View.GONE);
                                if (livePreview != null && livePreview.isClosed()) { if (previewArt != null) previewArt.setVisibility(View.VISIBLE); retryPreview(generation); }
                            } },
                            () -> { if (generation == previewGeneration && previewArt != null) { previewArt.setVisibility(View.GONE); previewRetryCount = 0; } });
                    if (livePreview != null) livePreview.setFill(previewFill);
                    previewStatus.setOnClickListener(v -> { closeLivePreview(); startLivePreview(); });
                } catch (Exception error) { closeLivePreview(); note("无法打开实时预览：" + error.getMessage()); }
            });
          } catch (Exception error) { ui(() -> {
                if (generation != previewGeneration) return;
                previewAutoFailed = true; livePreviewStatus = "预览未连接 · 轻点重试";
                if (previewStatus != null) { previewStatus.setText(livePreviewStatus); previewStatus.setOnClickListener(v -> { previewAutoFailed = false; startLivePreview(); }); }
                retryPreview(generation);
          }); } finally { ui(() -> { if (generation == previewGeneration) previewStarting = false; }); }
        });
    }
    private void retryPreview(long failedGeneration) {
        if (previewRetryCount >= 2) return;
        handler.postDelayed(() -> {
            if (failedGeneration != previewGeneration || !foreground || !"control".equals(page)
                    || !camera.isConnected()) return;
            if (busy.get() || exporting.get()) { retryPreview(failedGeneration); return; }
            int retries = previewRetryCount + 1;
            closeLivePreview(); previewRetryCount = retries; startLivePreview();
        }, 900);
    }
    private boolean previewRequestCurrent(long preview, long connection) {
        return !destroyed && foreground && "control".equals(page) && camera.isConnected()
                && preview == previewGeneration && connection == connectionGeneration.get();
    }
    private void closeLivePreview() {
        ++previewGeneration; previewStarting = false; previewAutoFailed = false; previewRetryCount = 0;
        if (livePreview != null) { livePreview.close(); livePreview = null; }
        livePreviewStatus = "";
        if (previewArt != null) previewArt.setVisibility(View.VISIBLE);
        if (previewStatus != null) { previewStatus.setOnClickListener(null); previewStatus.setText(camera.isConnected() ? "正在连接实时画面" : "等待连接相机"); }
    }
    private void export(List<MediaEntry> entries) {
        if (entries.isEmpty()) { note("请先选择视频或照片"); return; }
        if (!camera.isConnected()) { note("请先连接相机"); return; }
        if (!busy.compareAndSet(false, true)) { note("请等待当前操作完成"); return; }
        if (thumbnails != null) thumbnails.cancelRequests();
        exporting.set(true); exportCancelled.set(false); updateOperation();
        Network selected = network; String address = connectedHost;
        downloads.submit(() -> {
            int saved = 0;
            try {
                if (!CameraState.isReady(camera.call(1, CameraClient.args("type", "app_status")).getString("param")))
                    throw new java.io.IOException("请先停止拍摄再导出文件");
                for (MediaEntry entry : entries) {
                    MediaTransfer.checkCancelled(exportCancelled::get);
                    final int index = saved + 1;
                    String result = exporter.export(getContentResolver(), selected, address, cameraHttpPort(), entry,
                            () -> destroyed || exportCancelled.get(),
                            count -> ui(() -> operation.setText("导出 " + index + "/" + entries.size() + " · " + entry.name + " · " + count / 1024 + " KiB" + (entry.bytes > 0 ? " / " + entry.bytes / 1024 + " KiB" : ""))));
                    saved++;
                    final MediaEntry completed = entry;
                    ui(() -> { selectedMedia.remove(completed.path); note(result); });
                }
                int completed = saved;
                ui(() -> note("已导出 " + completed + " 个文件到相册"));
            } catch (Exception e) {
                int completed = saved;
                ui(() -> note((exportCancelled.get() ? "导出已取消" : "导出失败：" + e.getMessage()) + "；已完成 " + completed + "/" + entries.size() + "，已完成文件保留，当前未完成文件不发布"));
            } finally {
                exporting.set(false); busy.set(false);
                ui(() -> { if (page.equals("media")) drawMedia(); updateOperation(); });
            }
        });
    }
    private void cancelExport() {
        if (!exporting.get()) return;
        exportCancelled.set(true); exporter.cancel();
        operation.setText("正在取消导出…"); cancelExport.setEnabled(false);
    }
    private void updateOperation() {
        boolean occupied = busy.get() || exporting.get();
        if (exporting.get()) getWindow().addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        else getWindow().clearFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        if (connectButton != null) connectButton.setEnabled(!occupied);
        if (disconnectButton != null) disconnectButton.setEnabled(!occupied);
        if (host != null) host.setEnabled(!occupied);
        enable(content, !occupied);
        enable(captureActions, !occupied);
        if (monitorMode) enable(monitorLayer, !occupied);
        enable(bottomNav, !occupied);
        updateShutterEnabled();
        cancelExport.setVisibility(exporting.get() ? View.VISIBLE : View.GONE);
        cancelExport.setEnabled(exporting.get() && !exportCancelled.get());
        operation.setVisibility(exporting.get() ? View.VISIBLE : View.GONE);
        statusSlot.setVisibility(exporting.get() ? View.VISIBLE : View.GONE);
        operation.setPadding(dp(12), 0, exporting.get() ? dp(108) : dp(12), 0);
        operation.setBackground(round(AppPalette.SELECTED, 14));
        if (exporting.get()) message.setVisibility(View.GONE);
        if (!occupied) operation.setText("");
        else if (!exporting.get()) operation.setText("");
    }
    private void enable(View view, boolean enabled) {
        // Re-applying the same enabled state on every poll causes Android to
        // replay the pressed/disabled drawable transition around the shutter
        // dock. Guard the assignment so periodic status refreshes stay
        // visually stable.
        if (view.isEnabled() != enabled) view.setEnabled(enabled);
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) enable(group.getChildAt(i), enabled);
        }
    }
    private void updateShutterEnabled() {
        if (primaryShutter != null) primaryShutter.setEnabled(!busy.get() && !exporting.get()
                && (!camera.isConnected() || CameraState.isReady(cameraStatus) || "record".equals(cameraStatus)));
    }
    private void work(Work operation) { work(operation, false, -1); }
    private void work(Work operation, boolean shutterAction, int requestId) {
        if (destroyed) return;
        if (!busy.compareAndSet(false, true)) { note("请等待当前操作完成"); return; }
        if (shutterAction) {
            capturePending = true;
            pendingCaptureRequest = requestId;
            updateCaptureViews();
        }
        // Clear the previous completion hint before the fixed status slot is
        // reused for the next command.
        note("");
        if (thumbnails != null) thumbnails.cancelRequests();
        updateOperation();
        commands.submit(() -> {
            try { operation.run(); }
            catch (Exception e) { ui(() -> {
                boolean retrySaved = savedAutoConnectActive;
                savedAutoConnectActive = false;
                if (shutterAction) rejectCapture();
                if (requestId == 16777220) { optimisticPhotoFeedback = false; if (captureAlbum != null) captureAlbum.cancel(); }
                note(e.getMessage() == null ? e.getClass().getSimpleName() : e.getMessage());
                if (!camera.isConnected()) {
                    closeLivePreview(); closeMediaViewer(); closeThumbnails(); clearCameraViews("未连接 · 请重新选择相机");
                    if ("connection".equals(page) && wifiHint != null) {
                        wifiHint.setText(retrySaved ? "已保存的相机暂不可达，请选择设备重新连接。" : "未能建立相机连接。请确认相机已开机，再次选择相机重试。");
                        if (retrySaved) handler.postDelayed(this::scanCameraWifi, 100);
                    } else if (!"connection".equals(page)) drawConnection(1);
                }
            }); }
            finally { busy.set(false); ui(() -> {
                if (shutterAction) {
                    capturePending = false;
                    pendingCaptureRequest = -1;
                    updateCaptureViews();
                }
                updateOperation(); schedulePreview();
                if (shutterAction && foreground && camera.isConnected()) refreshQuietly();
            }); }
        });
    }
    private void detach(View view) {
        if (view.getParent() instanceof ViewGroup) ((ViewGroup) view.getParent()).removeView(view);
    }
    private void ui(Runnable action) { handler.post(() -> { if (!destroyed) action.run(); }); }
    private void clearCameraViews(String status) {
        settings = new JSONObject(); cameraStatus = ""; batteryPercent = -1; sdUsedPercent = -1;
        capturePending = false; pendingCaptureRequest = -1;
        media.clear(); selectedMedia.clear(); mediaSelectionMode = false;
        folder = MediaEntry.DCIM_ROOT; mediaAutoLoadRequested = false; mediaLoading = false; mediaLoadError = "";
        state.setText(status); detail.setText(""); updateCaptureViews();
        // Rows are separate Views, so clearing their model alone leaves old
        // camera parameters and media selections on screen until navigation.
        if ("settings".equals(page)) drawSettings();
        else if ("media".equals(page)) drawMedia();
    }
    private void handleCameraEvent(JSONObject event) {
        if (destroyed || !camera.isConnected() || event.optInt("msg_id") != 7) return;
        // Telemetry belongs in the device status. It must not replace an
        // operation failure (or expose untranslated protocol keys as a notice).
        updateBattery(event);
    }
    private void updateBattery(JSONObject power) {
        String type = power.optString("type"), value = power.optString("param");
        if (!("battery".equals(type) || "adapter".equals(type)) || !value.matches("\\d{1,3}")) return;
        int percent = Integer.parseInt(value);
        if (percent > 100) return;
        batteryPercent = percent;
        updateBatteryView();
    }
    private void updateBatteryView() {
        if (deviceBattery == null) return;
        setTextIfChanged(deviceBattery, batteryPercent < 0 ? "--" : batteryPercent + "%");
        int color = CameraVisuals.batteryColor(batteryPercent); deviceBattery.setTextColor(color);
        android.graphics.drawable.Drawable icon = deviceBattery.getCompoundDrawables()[0];
        if (!(icon instanceof CameraVisuals.Battery)) {
            icon = new CameraVisuals.Battery(); icon.setBounds(0, 0, dp(24), dp(18));
            deviceBattery.setCompoundDrawables(icon, null, null, null); deviceBattery.setCompoundDrawablePadding(dp(5));
        }
        ((CameraVisuals.Battery) icon).update(batteryPercent);
    }
    private int cameraWifiDbm() {
        int dbm = Integer.MIN_VALUE;
        try {
            Network route = network;
            NetworkCapabilities caps = route == null ? null : connectivity.getNetworkCapabilities(route);
            if (caps != null) {
                dbm = caps.getSignalStrength();
                if (dbm == Integer.MIN_VALUE && caps.getTransportInfo() instanceof android.net.wifi.WifiInfo)
                    dbm = ((android.net.wifi.WifiInfo) caps.getTransportInfo()).getRssi();
            }
        } catch (RuntimeException ignored) { }
        return dbm >= -126 && dbm <= -1 ? dbm : Integer.MIN_VALUE;
    }
    private int wifiSignalColor(boolean connected) {
        if (!connected) return AppPalette.MUTED;
        int dbm = cameraWifiDbm();
        if (dbm == Integer.MIN_VALUE) return AppPalette.MUTED;
        if (dbm != Integer.MIN_VALUE && dbm < -75) return Color.rgb(235, 64, 54);
        if (dbm != Integer.MIN_VALUE && dbm < -58) return Color.rgb(194, 142, 12);
        return Color.rgb(40, 161, 92);
    }
    private String wifiSignalText() {
        int dbm = cameraWifiDbm();
        if (dbm == Integer.MIN_VALUE) return "已连接";
        if (dbm != Integer.MIN_VALUE && dbm < -75) return "较弱";
        if (dbm != Integer.MIN_VALUE && dbm < -58) return "一般";
        return "良好";
    }
    private String sdCardLabel(JSONObject values) {
        String raw = values.optString("sd_card_status", "").trim();
        if (!camera.isConnected()) return "SD —";
        if (sdUsedPercent >= 0 && "insert".equalsIgnoreCase(raw)) return "已用 " + sdUsedPercent + "%";
        if ("insert".equalsIgnoreCase(raw) || raw.isEmpty()) return "容量 —";
        return "SD " + CameraSettings.displayValue("sd_card_status", raw);
    }

    private String cameraModel() {
        String value = camera.isConnected() ? settings.optString("product_name", "").trim() : "";
        if (value.isEmpty()) return "相机";
        String model = value.replace('_', ' ').replace(" Action Camera", "").trim();
        // A few app/firmware builds expose their UI placeholder as the
        // product name. Do not let that leak into the title once a real model
        // is connected; the status card remains the source of truth.
        if (model.equalsIgnoreCase("apex") || model.equalsIgnoreCase("camera")
                || model.equalsIgnoreCase("yi camera") || model.equalsIgnoreCase("unknown")) return "相机";
        return model;
    }
    private void setTextIfChanged(TextView view, String text) { if (!text.contentEquals(view.getText())) view.setText(text); }
    private LinearLayout.LayoutParams spaced(int width, int height, int top) {
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(width, height); params.topMargin = dp(top); return params;
    }
    private void spaceChildren(LinearLayout row) {
        for (int i=0; i<row.getChildCount(); i++) {
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) row.getChildAt(i).getLayoutParams();
            params.leftMargin = i == 0 ? 0 : dp(8); params.rightMargin = 0; row.getChildAt(i).setLayoutParams(params);
        }
    }
    private void note(String text) {
        if (destroyed || message == null) return;
        // Keep the last result for diagnostics without inserting a banner into the camera UI.
        message.setText(text); message.setVisibility(View.GONE);
        if (feedbackToast != null) feedbackToast.cancel();
        if (text == null || text.isEmpty()) return;
        feedbackToast = android.widget.Toast.makeText(this, text, android.widget.Toast.LENGTH_SHORT);
        feedbackToast.show();
    }
    private int dp(int value) { return (int) (value * getResources().getDisplayMetrics().density + 0.5f); }
    private LinearLayout column() { LinearLayout layout = new LinearLayout(this); layout.setOrientation(LinearLayout.VERTICAL); return layout; }
    private LinearLayout row() { LinearLayout layout = new LinearLayout(this); layout.setOrientation(LinearLayout.HORIZONTAL); layout.setBaselineAligned(false); return layout; }
    private LinearLayout.LayoutParams weight() { return new LinearLayout.LayoutParams(0, -2, 1); }
    private TextView label(String text, int size) { TextView view = new TextView(this); view.setText(text); view.setTextSize(size); view.setTextColor(Color.rgb(25, 35, 48)); view.setPadding(0, dp(6), 0, dp(6)); return view; }
    private Button button(String text, Runnable action) { Button button = new Button(this); button.setText(text); button.setAllCaps(false); button.setMinHeight(dp(44)); button.setMinimumHeight(dp(44)); button.setMinWidth(0); button.setMinimumWidth(0); button.setStateListAnimator(null); button.setOnClickListener(v -> action.run()); return button; }

    @Override protected void onDestroy() {
        synchronized (connectionLock) {
            destroyed = true;
            connectionGeneration.incrementAndGet(); network = null; camera.close();
        }
        closeMediaViewer();
        closeThumbnails();
        closeLivePreview();
        wifiConnector.close();
        handler.removeCallbacksAndMessages(null);
        if (host != null) getPreferences(MODE_PRIVATE).edit().putString("camera_host", host.getText().toString().trim()).apply();
        if (networkCallback != null) connectivity.unregisterNetworkCallback(networkCallback);
        exportCancelled.set(true); exporter.cancel(); camera.close(); commands.shutdownNow(); downloads.shutdownNow(); super.onDestroy();
    }
    @Override protected void onPause() {
        foreground = false;
        ++albumLoadGeneration;
        if (captureAlbum != null) captureAlbum.cancel();
        if (thumbnails != null) thumbnails.cancelRequests();
        closeLivePreview(); super.onPause();
    }
}
