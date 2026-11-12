package dev.yi4k.control;

import android.app.Activity;
import android.app.Instrumentation.ActivityMonitor;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.ConnectivityManager;
import android.net.LinkProperties;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Bundle;
import android.os.SystemClock;
import android.test.InstrumentationTestCase;
import android.test.InstrumentationTestRunner;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import androidx.annotation.OptIn;
import androidx.media3.common.Player;
import androidx.media3.common.VideoSize;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.exoplayer.DecoderCounters;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.ui.PlayerView;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Opt-in real MainActivity flow: pass yi4k_camera_host and yi4k_preview_run_id.
 * Requires initial idle / system_mode=record. The app owns its normal client,
 * network selection, advertised RTSP source and player; none are replaced.
 * Independent API sessions are used only before the UI session and after its
 * Activity is destroyed, for baseline/conditional VF cleanup. No capture or
 * settings commands are sent. Run alone against the explicitly named camera.
 */
@OptIn(markerClass = UnstableApi.class)
public final class CameraMainPreviewWorkflowDeviceTest extends InstrumentationTestCase {
    private Activity activity;
    private Context context;
    private Network checkNetwork;
    private String host, runId, initialStatus;
    private String requestedOrientation;
    private boolean ownedVfStarted;
    private final JSONObject evidence = new JSONObject();
    private final JSONArray events = new JSONArray();
    private final JSONArray firstFrames = new JSONArray();
    private final JSONArray navigationReleases = new JSONArray();
    private final List<ObservedPreview> previews = new ArrayList<>();

    private static final class ObservedPreview {
        final PlayerView view;
        final View surface;
        final ExoPlayer player;
        final int round, width, height, renderedBuffers;
        ObservedPreview(PlayerView view, View surface, ExoPlayer player,
                        int round, int width, int height, int renderedBuffers) {
            this.view = view; this.surface = surface; this.player = player;
            this.round = round; this.width = width; this.height = height; this.renderedBuffers = renderedBuffers;
        }
    }

    private interface UiCondition { boolean matches(); }

    public void testVisibleMainActivityFirstFramesNavigationReleaseAndDisconnect() throws Exception {
        Bundle args = ((InstrumentationTestRunner)getInstrumentation()).getArguments();
        host = args.getString("yi4k_camera_host");
        runId = args.getString("yi4k_preview_run_id");
        assertNotNull("Explicit camera host required", host);
        assertNotNull("Explicit preview run UUID required", runId);
        assertEquals(runId, UUID.fromString(runId).toString());
        requestedOrientation = args.getString("yi4k_preview_orientation", "portrait");
        assertTrue("Explicit supported preview orientation", "portrait".equals(requestedOrientation)
                || "landscape".equals(requestedOrientation));
        context = getInstrumentation().getTargetContext();
        evidence.put("run_id", runId); evidence.put("events", events);
        evidence.put("requested_orientation", requestedOrientation);
        evidence.put("first_frames", firstFrames);
        evidence.put("navigation_releases", navigationReleases);
        evidence.put("complete", false);
        evidence.put("scope", "Real MainActivity visible controls, actual RTSP first frame and public PlayerView/ExoPlayer release state; no physical phone claim");
        Throwable failure = null;
        boolean workflowComplete = false;
        try {
            checkNetwork = awaitWifi();
            CameraClient check = openCheck("preflight");
            try {
                initialStatus = readStatus(check, "preflight");
                assertEquals("Preview workflow requires an initially idle camera", "idle", initialStatus);
                JSONObject settings = CameraClient.flattenSettings(check.call(3));
                assertEquals("Preview workflow requires video mode", "record", settings.getString("system_mode"));
                assertTrue("Expected ordinary YI 4K 1.10.7", settings.getString("sw_version").startsWith("Z16V13L_1.10.7_"));
                evidence.put("initial_status", initialStatus);
                evidence.put("initial_system_mode", settings.getString("system_mode"));
                evidence.put("firmware", settings.getString("sw_version"));
            } finally { check.disconnect(); }
            event("preflight_session_closed");

            activity = getInstrumentation().startActivitySync(new Intent(context, MainActivity.class)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
            getInstrumentation().waitForIdleSync();
            orientBeforeConnection();
            connectExplicitTestEndpoint();
            saveScreen("preview-connected.png");
            ObservedPreview first = openAndObserveFirstFrame(1);
            clickButton("设置");
            runUi(() -> MainActivityTestDriver.openSetting(activity, "sw_version")); waitText("固件版本", 10000);
            assertReleased(first, "settings_after_round_1");
            saveScreen("preview-settings-released-1.png");

            clickButton("拍摄");
            event("capture_page_reopened_for_automatic_preview");
            ObservedPreview second = openAndObserveFirstFrame(2);
            assertNotSame("Reopened preview must use a new actual player", first.player, second.player);
            assertNotSame("Capture page must have a new player view", first.view, second.view);

            // Settings closes preview; connection management exposes the visible disconnect action.
            clickButton("设置");
            runUi(() -> MainActivityTestDriver.openSetting(activity, "sw_version")); waitText("固件版本", 10000);
            assertReleased(second, "settings_before_ui_disconnect");
            runUi(() -> MainActivityTestDriver.disconnect(activity));
            waitText("已断开", 15000);
            waitText("未连接", 5000);
            assertReleased(first, "ui_disconnect_round_1_still_released");
            assertReleased(second, "ui_disconnect_round_2_still_released");
            evidence.put("ui_disconnected", true);
            event("visible_ui_disconnect_no_player_remaining");
            saveScreen("preview-disconnected.png");
            workflowComplete = true;
        } catch (Throwable error) {
            failure = error;
            evidence.put("workflow_error", error.toString());
            if (activity != null) try { saveScreen("preview-failure.png"); }
            catch (Throwable screenshotError) { error.addSuppressed(screenshotError); }
        } finally {
            // Finish the real owner first; do not open a competing API session.
            try {
                if (activity != null) {
                    runUi(activity::finish);
                    getInstrumentation().waitForIdleSync();
                    waitFor("MainActivity destroyed before API cleanup", 10000, () -> activity.isDestroyed());
                    for (ObservedPreview preview : previews) assertReleased(preview, "activity_destroyed");
                    evidence.put("activity_destroyed_before_cleanup", true);
                    evidence.put("all_observed_players_released", true);
                }
            } catch (Throwable finishError) {
                failure = retainFailure(failure, finishError);
                evidence.put("finish_error", finishError.toString());
            }
            try {
                if (initialStatus != null && (activity == null || activity.isDestroyed())) restoreOwnedVf();
                else if (initialStatus != null) throw new AssertionError("Activity still owns its session; independent cleanup skipped");
            } catch (Throwable cleanupError) {
                failure = retainFailure(failure, cleanupError);
                evidence.put("cleanup_error", cleanupError.toString());
            }
            evidence.put("complete", workflowComplete && failure == null);
            try { writeEvidence(); }
            catch (Throwable writeError) { failure = retainFailure(failure, writeError); }
        }
        if (failure != null) rethrow(failure);
        Bundle result = new Bundle();
        result.putString("main_preview_workflow", runId);
        result.putString("main_preview_result", "two real UI first frames; public player release verified; conditional owned VF restored");
        getInstrumentation().sendStatus(0, result);
    }

    private void connectExplicitTestEndpoint() throws Exception {
        runUi(() -> MainActivityTestDriver.connectEndpoint(activity, host));
        waitText("连接成功", 25000);
        event("explicit_test_endpoint_connected_via_product_wifi_route_nearby_selection_bypassed");
    }

    private void orientBeforeConnection() throws Exception {
        boolean landscape = "landscape".equals(requestedOrientation);
        int expected = landscape ? Configuration.ORIENTATION_LANDSCAPE : Configuration.ORIENTATION_PORTRAIT;
        int request = landscape ? ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE : ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
        if (activity.getResources().getConfiguration().orientation != expected) {
            ActivityMonitor monitor = getInstrumentation().addMonitor(MainActivity.class.getName(), null, false);
            try {
                runUi(() -> activity.setRequestedOrientation(request));
                Activity replacement = monitor.waitForActivityWithTimeout(10000);
                assertNotNull("Orientation change must recreate the disconnected Activity", replacement);
                activity = replacement;
            } finally { getInstrumentation().removeMonitor(monitor); }
        }
        getInstrumentation().waitForIdleSync();
        waitFor("requested preview window orientation", 10000, () ->
                activity.getResources().getConfiguration().orientation == expected
                && decor().getWidth() > 0 && decor().getHeight() > 0
                && (decor().getWidth() > decor().getHeight()) == landscape);
        event("disconnected_activity_oriented_" + requestedOrientation);
    }

    private ObservedPreview openAndObserveFirstFrame(int round) throws Exception {
        // First-frame observation deliberately performs no preview tap: capture starts it automatically.
        event("await_automatic_preview_without_tap_round_" + round);
        AtomicReference<ObservedPreview> observed = new AtomicReference<>();
        waitFor("real MainActivity first frame round " + round, 30000, () -> {
            View root = decor();
            TextView status = (TextView)findText(root, "实时画面已连接");
            PlayerView view = (PlayerView)findType(root, PlayerView.class, true);
            View placeholder = findDescription(root, "开启相机实时预览", false);
            if (status == null || view == null || placeholder == null || placeholder.getVisibility() != View.GONE) return false;
            Player attached = view.getPlayer();
            if (!(attached instanceof ExoPlayer)) return false;
            ExoPlayer player = (ExoPlayer)attached;
            if (player.isReleased() || player.getPlayerError() != null) return false;
            View surface = view.getVideoSurfaceView();
            VideoSize video = player.getVideoSize();
            DecoderCounters counters = player.getVideoDecoderCounters();
            if (counters == null) return false;
            counters.ensureUpdated();
            if (surface == null || !surface.isAttachedToWindow() || video.width <= 0 || video.height <= 0
                    || counters.renderedOutputBufferCount <= 0) return false;
            observed.set(new ObservedPreview(view, surface, player, round, video.width, video.height,
                    counters.renderedOutputBufferCount));
            return true;
        });
        ObservedPreview result = observed.get();
        assertNotNull(result); previews.add(result);
        // The production UI string is set by onRenderedFirstFrame (or READY
        // after that real callback); no listener/callback is installed by test.
        if (!ownedVfStarted && "idle".equals(initialStatus)) {
            ownedVfStarted = true;
            evidence.put("owned_vf_confirmed_after_real_first_frame", true);
            Bundle marker = new Bundle(); marker.putString("preview_owned_vf_started", runId);
            getInstrumentation().sendStatus(0, marker);
        }
        // Preserve confirmed VF ownership even if a later geometry assertion
        // fails; the actual first-frame/counter evidence already exists.
        runUi(() -> {
            assertEquals("Exactly one actual player in decor", 1, countPlayers(decor()));
            assertFullyVisible(findText(decor(), "实时画面已连接"));
            assertFullyVisible(result.view); assertFullyVisible(result.surface);
        });
        JSONObject detail = new JSONObject();
        detail.put("event", "real_first_frame"); detail.put("round", round);
        detail.put("run_id", runId); detail.put("elapsed_ms", SystemClock.elapsedRealtime());
        detail.put("ui_status", "实时画面已连接");
        detail.put("video_width", result.width); detail.put("video_height", result.height);
        detail.put("rendered_output_buffers", result.renderedBuffers);
        detail.put("surface_class", result.surface.getClass().getName());
        runUi(() -> {
            try {
                boolean landscape = activity.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE;
                assertEquals("Stream must render in requested orientation", "landscape".equals(requestedOrientation), landscape);
                detail.put("orientation", landscape ? "landscape" : "portrait");
                detail.put("window_width", decor().getWidth()); detail.put("window_height", decor().getHeight());
                detail.put("surface_width", result.surface.getWidth()); detail.put("surface_height", result.surface.getHeight());
                assertFullyVisible(findDescription(decor(), "开始录像", true));
            } catch (org.json.JSONException error) { throw new AssertionError(error); }
        });
        detail.put("player_identity", System.identityHashCode(result.player));
        detail.put("screenshot", "preview-first-frame-" + round + ".png");
        firstFrames.put(detail); events.put(detail); writeEvidence();
        Bundle marker = new Bundle(); marker.putString("preview_first_frame_run_id", runId);
        marker.putInt("preview_first_frame_round", round); getInstrumentation().sendStatus(0, marker);
        saveScreen("preview-first-frame-" + round + ".png");
        return result;
    }

    private void assertReleased(ObservedPreview preview, String phase) throws Exception {
        runUi(() -> {
            assertNull("Released PlayerView must detach its player", preview.view.getPlayer());
            assertNull("Released PlayerView must leave its container", preview.view.getParent());
            assertFalse("Released PlayerView must leave the window", preview.view.isAttachedToWindow());
            assertFalse("Actual video surface must leave the window", preview.surface.isAttachedToWindow());
            assertTrue("Actual ExoPlayer public isReleased must be true", preview.player.isReleased());
            assertEquals("No player may remain in current decor", 0, countPlayers(decor()));
        });
        JSONObject detail = new JSONObject(); detail.put("event", "public_player_release_verified");
        detail.put("phase", phase); detail.put("elapsed_ms", SystemClock.elapsedRealtime());
        detail.put("round", preview.round);
        detail.put("player_identity", System.identityHashCode(preview.player));
        detail.put("player_is_released", true); detail.put("player_view_player_null", true);
        detail.put("player_view_parent_null", true); detail.put("surface_detached_from_window", true);
        if (phase.startsWith("settings_")) navigationReleases.put(detail);
        events.put(detail); writeEvidence();
    }

    private Network awaitWifi() throws Exception {
        ConnectivityManager manager = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        InetAddress target = InetAddress.getByName(host);
        long deadline = SystemClock.uptimeMillis() + 20000;
        do {
            Network fallback = null;
            for (Network network : manager.getAllNetworks()) {
                NetworkCapabilities caps = manager.getNetworkCapabilities(network);
                if (caps == null || !caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) continue;
                if (fallback == null) fallback = network;
                LinkProperties links = manager.getLinkProperties(network);
                if (links != null && links.getRoutes().stream().anyMatch(route -> !route.hasGateway() && route.matches(target))) {
                    evidence.put("independent_check_network", network.toString());
                    evidence.put("independent_check_network_capabilities", String.valueOf(caps));
                    return network;
                }
            }
            if (fallback != null) {
                evidence.put("independent_check_network", fallback.toString());
                evidence.put("independent_check_network_capabilities", String.valueOf(manager.getNetworkCapabilities(fallback)));
                return fallback;
            }
            Thread.sleep(200);
        } while (SystemClock.uptimeMillis() < deadline);
        throw new AssertionError("An actual Android Wi-Fi Network is required; no socket factory injection permitted");
    }

    private CameraClient openCheck(String phase) throws Exception {
        CameraClient client = new CameraClient(event -> { });
        boolean opened = false;
        try {
            client.connect(checkNetwork.getSocketFactory(), host, 7878);
            event("independent_api_session_open_" + phase);
            opened = true;
            return client;
        } finally { if (!opened) client.close(); }
    }

    private String readStatus(CameraClient client, String phase) throws Exception {
        JSONObject reply = client.call(1, CameraClient.args("type", "app_status"));
        JSONObject detail = new JSONObject(); detail.put("event", "independent_app_status");
        detail.put("phase", phase); detail.put("reply", reply); events.put(detail);
        return reply.getString("param");
    }

    private void restoreOwnedVf() throws Exception {
        CameraClient check = openCheck("cleanup_after_activity_destroyed");
        try {
            String status = readStatus(check, "after_ui_disconnect");
            evidence.put("status_before_cleanup", status);
            if ("idle".equals(initialStatus) && "vf".equals(status) && ownedVfStarted) {
                JSONObject reply = check.call(260);
                evidence.put("owned_vf_stop_reply", reply);
                Bundle marker = new Bundle(); marker.putString("preview_owned_vf_stop_requested", runId);
                getInstrumentation().sendStatus(0, marker);
                long deadline = SystemClock.uptimeMillis() + 10000;
                do {
                    status = readStatus(check, "after_owned_vf_stop");
                    if ("idle".equals(status)) break;
                    Thread.sleep(200);
                } while (SystemClock.uptimeMillis() < deadline);
            } else if (!initialStatus.equals(status)) {
                evidence.put("vf_cleanup_skipped_unconfirmed_or_unsafe_state", true);
                throw new AssertionError("Refusing to guess VF/recording ownership: initial=" + initialStatus
                        + ", current=" + status + ", confirmed first frame=" + ownedVfStarted);
            }
            evidence.put("final_status", status);
            assertEquals("Conditional VF cleanup must restore initial camera status", initialStatus, status);
            evidence.put("camera_status_restored", true);
            Bundle marker = new Bundle(); marker.putString("preview_owned_vf_restored", runId);
            getInstrumentation().sendStatus(0, marker);
        } finally { check.disconnect(); }
        event("independent_cleanup_session_closed");
    }

    private void clickButton(String text) throws Exception {
        waitFor("enabled visible button " + text, 10000, () -> {
            Button target = findButton(decor(), text); return target != null && target.isEnabled();
        });
        runUi(() -> {
            Button target = findButton(decor(), text);
            target.requestRectangleOnScreen(new Rect(0, 0, target.getWidth(), target.getHeight()), true);
        });
        getInstrumentation().waitForIdleSync();
        runUi(() -> {
            Button target = findButton(decor(), text); assertFullyVisible(target);
            assertTrue("Button must remain enabled: " + text, target.isEnabled());
            assertTrue(target.performClick());
        });
        getInstrumentation().waitForIdleSync();
    }

    private boolean hasText(String text) {
        AtomicBoolean found = new AtomicBoolean();
        runUi(() -> found.set(findText(decor(), text) != null)); return found.get();
    }

    private void waitText(String text, long timeout) throws Exception {
        waitFor("UI text " + text, timeout, () -> findText(decor(), text) != null);
    }

    private void waitFor(String label, long timeout, UiCondition condition) throws Exception {
        long deadline = SystemClock.uptimeMillis() + timeout;
        do {
            AtomicBoolean matched = new AtomicBoolean(); runUi(() -> matched.set(condition.matches()));
            if (matched.get()) return;
            Thread.sleep(100);
        } while (SystemClock.uptimeMillis() < deadline);
        AtomicReference<String> visible = new AtomicReference<>();
        runUi(() -> { StringBuilder out = new StringBuilder(); collectTexts(decor(), out); visible.set(out.toString()); });
        throw new AssertionError("Timeout waiting for " + label + "; shown text: " + visible.get());
    }

    private View decor() { return activity.getWindow().getDecorView(); }

    private static View findText(View root, String text) {
        if (!root.isShown()) return null;
        if (root instanceof TextView && text.contentEquals(((TextView)root).getText())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) {
            View found = findText(((ViewGroup)root).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }

    private static Button findButton(View root, String text) {
        if (!root.isShown()) return null;
        if (root instanceof Button && text.contentEquals(((Button)root).getText())) return (Button)root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) {
            Button found = findButton(((ViewGroup)root).getChildAt(i), text); if (found != null) return found;
        }
        return null;
    }

    private static View findDescription(View root, String text, boolean shownOnly) {
        if (shownOnly && !root.isShown()) return null;
        if (root.getContentDescription() != null && text.contentEquals(root.getContentDescription())) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) {
            View found = findDescription(((ViewGroup)root).getChildAt(i), text, shownOnly); if (found != null) return found;
        }
        return null;
    }

    private static View findType(View root, Class<?> type, boolean shownOnly) {
        if (shownOnly && !root.isShown()) return null;
        if (type.isInstance(root)) return root;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++) {
            View found = findType(((ViewGroup)root).getChildAt(i), type, shownOnly); if (found != null) return found;
        }
        return null;
    }

    private static int countPlayers(View root) {
        int count = root instanceof PlayerView ? 1 : 0;
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++)
            count += countPlayers(((ViewGroup)root).getChildAt(i));
        return count;
    }

    private static void assertFullyVisible(View target) {
        assertNotNull(target); Rect visible = new Rect();
        assertTrue("View must be shown", target.isShown());
        assertTrue("View must have nonzero bounds", target.getWidth() > 0 && target.getHeight() > 0);
        assertTrue("View must have visible bounds", target.getGlobalVisibleRect(visible));
        assertEquals("View must not be clipped horizontally", target.getWidth(), visible.width());
        assertEquals("View must not be clipped vertically", target.getHeight(), visible.height());
    }

    private static void collectTexts(View root, StringBuilder out) {
        if (!root.isShown()) return;
        if (root instanceof TextView) out.append(((TextView)root).getText()).append(" | ");
        if (root instanceof ViewGroup) for (int i = 0; i < ((ViewGroup)root).getChildCount(); i++)
            collectTexts(((ViewGroup)root).getChildAt(i), out);
    }

    private void runUi(Runnable action) {
        AtomicReference<Throwable> error = new AtomicReference<>();
        getInstrumentation().runOnMainSync(() -> { try { action.run(); } catch (Throwable failure) { error.set(failure); } });
        if (error.get() instanceof Error) throw (Error)error.get();
        if (error.get() instanceof RuntimeException) throw (RuntimeException)error.get();
        if (error.get() != null) throw new AssertionError(error.get());
    }

    private void event(String name) throws Exception {
        JSONObject event = new JSONObject(); event.put("event", name); event.put("run_id", runId);
        event.put("elapsed_ms", SystemClock.elapsedRealtime()); events.put(event); writeEvidence();
    }

    private File directory() {
        File directory = new File(context.getExternalFilesDir(null), "acceptance-screens/camera-main-preview");
        assertTrue(directory.isDirectory() || directory.mkdirs()); return directory;
    }

    private void writeEvidence() throws Exception {
        try (OutputStream output = new FileOutputStream(new File(directory(), "camera-main-preview.json"))) {
            output.write(evidence.toString(2).getBytes(StandardCharsets.UTF_8));
        }
    }

    private void saveScreen(String name) throws Exception {
        getInstrumentation().waitForIdleSync();
        Bitmap screen = getInstrumentation().getUiAutomation().takeScreenshot(); assertNotNull(screen);
        try (OutputStream output = new FileOutputStream(new File(directory(), name))) {
            assertTrue(screen.compress(Bitmap.CompressFormat.PNG, 100, output));
        } finally { screen.recycle(); }
    }

    private static Throwable retainFailure(Throwable first, Throwable next) {
        if (first == null) return next; first.addSuppressed(next); return first;
    }

    private static void rethrow(Throwable failure) throws Exception {
        if (failure instanceof Error) throw (Error)failure;
        if (failure instanceof Exception) throw (Exception)failure;
        throw new AssertionError(failure);
    }
}
