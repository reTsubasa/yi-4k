package dev.yi4k.control;

import java.util.Objects;

/**
 * Low-risk boundary between trigger semantics and a future recorder.
 * The sink is injected by the integration layer; this adapter never calls CameraClient.
 */
public final class CaptureTriggerAdapter {
    public interface Sink {
        void onStartRequested(CaptureTriggerRouter.Source source);
        void onStopRequested();
    }

    private final CaptureTriggerRouter router;
    private final Sink sink;

    public CaptureTriggerAdapter(Sink sink) {
        this(new CaptureTriggerRouter(), sink);
    }

    CaptureTriggerAdapter(CaptureTriggerRouter router, Sink sink) {
        this.router = Objects.requireNonNull(router, "router");
        this.sink = Objects.requireNonNull(sink, "sink");
    }

    public synchronized boolean arm() { return router.arm(); }
    public synchronized CaptureTriggerRouter.Action onShutter(CaptureTriggerRouter.Shutter shutter) {
        return dispatch(router.onShutter(shutter));
    }
    /** Receives a typed event emitted after the camera firmware recognizes a command. */
    public synchronized CaptureTriggerRouter.Action onCameraVoiceEvent(CameraVoiceEvent event) {
        return dispatch(router.onCameraVoiceEvent(event));
    }
    public synchronized CaptureTriggerRouter.Action onExternalStart() {
        return dispatch(router.onExternalStart());
    }
    public synchronized CaptureTriggerRouter.Action onStop() {
        return dispatch(router.onStop());
    }
    public synchronized void acknowledgeStart() { router.acknowledgeStart(); }
    public synchronized void startFailed() { router.startFailed(); }
    public synchronized void acknowledgeStop() { router.acknowledgeStop(); }
    public synchronized void disarm() { router.disarm(); }
    public synchronized CaptureTriggerRouter.State state() { return router.state(); }
    public synchronized CaptureTriggerRouter.Source lastSource() { return router.lastSource(); }

    private CaptureTriggerRouter.Action dispatch(CaptureTriggerRouter.Action action) {
        if (action == CaptureTriggerRouter.Action.START) sink.onStartRequested(router.lastSource());
        else if (action == CaptureTriggerRouter.Action.STOP) sink.onStopRequested();
        return action;
    }
}
