package dev.yi4k.control;

/**
 * Pure semantic router for future pre-recording integration.
 * It emits START/STOP intents only; it does not call the camera or change UI state.
 */
public final class CaptureTriggerRouter {
    public enum State { DISARMED, PREBUFFERING, STARTING, RECORDING, FINALIZING }
    public enum Action { START, STOP, NONE }
    public enum Source { SHUTTER, CAMERA_VOICE, EXTERNAL }
    public enum Shutter { SHORT_PRESS, LONG_PRESS }

    private State state = State.DISARMED;
    private Source lastSource;

    public synchronized State state() { return state; }
    public synchronized Source lastSource() { return lastSource; }

    /** Arms a prebuffering session. Re-arming is idempotent while already active. */
    public synchronized boolean arm() {
        if (state == State.DISARMED) { state = State.PREBUFFERING; return true; }
        return false;
    }

    /** A short shutter press is the same START semantic as a camera voice event. */
    public synchronized Action onShutter(Shutter shutter) {
        if (shutter != Shutter.SHORT_PRESS) return Action.NONE;
        return start(Source.SHUTTER);
    }

    /** Consumes only a typed START_RECORDING event already confirmed by camera firmware. */
    public synchronized Action onCameraVoiceEvent(CameraVoiceEvent event) {
        if (event != CameraVoiceEvent.START_RECORDING) return Action.NONE;
        return start(Source.CAMERA_VOICE);
    }

    /** Allows a future app or hardware adapter to share the same idempotent START path. */
    public synchronized Action onExternalStart() { return start(Source.EXTERNAL); }

    /** Moves the router after the underlying recorder acknowledges START. */
    public synchronized void acknowledgeStart() {
        if (state == State.STARTING) state = State.RECORDING;
    }

    /** Returns to PREBUFFERING after a failed START so a later trigger can retry. */
    public synchronized void startFailed() {
        if (state == State.STARTING) state = State.PREBUFFERING;
    }

    /** STOP is emitted once from an active recording; duplicate stops are ignored. */
    public synchronized Action onStop() {
        if (state != State.RECORDING) return Action.NONE;
        state = State.FINALIZING;
        return Action.STOP;
    }

    /** Marks finalization complete and resumes the armed prebuffering state. */
    public synchronized void acknowledgeStop() {
        if (state == State.FINALIZING) state = State.PREBUFFERING;
    }

    public synchronized void disarm() { state = State.DISARMED; lastSource = null; }

    private Action start(Source source) {
        if (state != State.PREBUFFERING) return Action.NONE;
        state = State.STARTING;
        lastSource = source;
        return Action.START;
    }

}
