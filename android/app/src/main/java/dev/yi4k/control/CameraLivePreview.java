package dev.yi4k.control;

import android.app.Activity;
import android.graphics.Color;
import android.net.Network;
import android.os.Handler;
import android.os.Looper;
import android.widget.FrameLayout;
import androidx.annotation.OptIn;
import androidx.media3.common.MediaItem;
import androidx.media3.common.PlaybackException;
import androidx.media3.common.Player;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.exoplayer.rtsp.RtspMediaSource;
import androidx.media3.ui.AspectRatioFrameLayout;
import androidx.media3.ui.PlayerView;
import java.io.IOException;
import java.util.function.Consumer;

/** Embedded live video only. The owner controls camera API 259 and closes on navigation/background. */
@OptIn(markerClass = UnstableApi.class)
public final class CameraLivePreview implements AutoCloseable {
    private final FrameLayout container;
    private final PlayerView view;
    private final Consumer<String> status;
    private final Runnable onFirstFrame;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private ExoPlayer player;
    private volatile boolean closed;
    private boolean renderedFirstFrame;

    private final Player.Listener listener = new Player.Listener() {
        @Override public void onPlaybackStateChanged(int playbackState) {
            if (closed) return;
            if (playbackState == Player.STATE_BUFFERING) report("正在缓冲相机画面…");
            else if (playbackState == Player.STATE_READY)
                report(renderedFirstFrame ? "实时画面已连接" : "正在解码相机画面…");
            else if (playbackState == Player.STATE_ENDED) fail("相机画面已结束，请点击重新预览");
        }

        @Override public void onRenderedFirstFrame() {
            if (closed || renderedFirstFrame) return;
            renderedFirstFrame = true;
            report("实时画面已连接");
            if (!closed && onFirstFrame != null) onFirstFrame.run();
        }

        @Override public void onPlayerError(PlaybackException error) {
            fail("实时画面暂时不可用，请检查相机 Wi-Fi 后重试");
        }
    };

    /**
     * Call on the UI thread with the exact camera-advertised address previously checked using
     * CameraPreviewAddress.validate(cameraHost, advertised). A bound Network is always required.
     */
    public static CameraLivePreview start(Activity activity, FrameLayout container, Network network,
            String validatedRtspAddress, Consumer<String> status, Runnable onFirstFrame) throws IOException {
        if (Looper.myLooper() != Looper.getMainLooper())
            throw new IllegalStateException("请在界面线程打开实时画面");
        if (activity == null || container == null) throw new IllegalArgumentException("实时画面容器不可用");
        if (activity.isFinishing() || activity.isDestroyed()) throw new IllegalStateException("页面已关闭");
        if (network == null) throw new IOException("相机 Wi-Fi 已断开，请重新连接相机");
        String address = CameraPreviewAddress.validateForPlayback(validatedRtspAddress);
        CameraLivePreview preview = new CameraLivePreview(activity, container, status, onFirstFrame);
        try {
            preview.open(activity, network, address);
            return preview;
        } catch (RuntimeException failure) {
            preview.close();
            throw failure;
        }
    }

    private CameraLivePreview(Activity activity, FrameLayout container,
            Consumer<String> status, Runnable onFirstFrame) {
        this.container = container;
        this.status = status;
        this.onFirstFrame = onFirstFrame;
        view = new PlayerView(activity);
        view.setUseController(false);
        view.setResizeMode(AspectRatioFrameLayout.RESIZE_MODE_ZOOM);
        view.setShutterBackgroundColor(Color.BLACK);
        view.setBackgroundColor(Color.BLACK);
        view.setKeepContentOnPlayerReset(false);
        view.setShowBuffering(PlayerView.SHOW_BUFFERING_NEVER);
        view.setContentDescription("相机实时画面");
    }

    private void open(Activity activity, Network network, String address) {
        // Verified in androidx/media tag 1.5.1: RtspMediaSource.Factory exposes both APIs.
        // TCP selects TransferRtpDataChannelFactory; control and interleaved RTP share this socket.
        RtspMediaSource.Factory source = new RtspMediaSource.Factory()
                .setSocketFactory(network.getSocketFactory())
                .setForceUseRtpTcp(true)
                .setTimeoutMs(8000);
        player = new ExoPlayer.Builder(activity).build();
        player.addListener(listener);
        player.setVolume(0f);
        view.setPlayer(player);
        // Preserve owner overlays such as the placeholder and connection status above the video.
        container.addView(view, 0, new FrameLayout.LayoutParams(-1, -1));
        report("正在连接相机画面…");
        if (closed) return;
        player.setMediaSource(source.createMediaSource(MediaItem.fromUri(address)));
        player.prepare();
        player.setPlayWhenReady(true);
    }

    private void report(String message) {
        if (!closed && status != null) status.accept(message);
    }

    private void fail(String message) {
        if (closed) return;
        close();
        if (status != null) status.accept(message);
    }

    public void setFill(boolean fill) {
        view.setResizeMode(fill ? AspectRatioFrameLayout.RESIZE_MODE_ZOOM : AspectRatioFrameLayout.RESIZE_MODE_FIT);
    }

    public boolean isClosed() { return closed; }

    /** Releases the RTSP session, decoder and this class's view; never sends camera API commands. */
    @Override public void close() {
        if (Looper.myLooper() != Looper.getMainLooper()) { handler.post(this::close); return; }
        if (closed) return;
        closed = true;
        view.setPlayer(null);
        ExoPlayer active = player;
        player = null;
        try {
            if (active != null) {
                active.removeListener(listener);
                active.release();
            }
        } finally {
            container.removeView(view);
        }
    }
}
