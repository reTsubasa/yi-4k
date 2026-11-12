package dev.yi4k.control;

import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

public class CaptureTriggerAdapterTest {
    private static final class Sink implements CaptureTriggerAdapter.Sink {
        final List<String> events = new ArrayList<>();
        @Override public void onStartRequested(CaptureTriggerRouter.Source source) { events.add("start:" + source); }
        @Override public void onStopRequested() { events.add("stop"); }
    }

    @Test public void adapterDispatchesOnlyAcceptedActions() {
        Sink sink = new Sink(); CaptureTriggerAdapter adapter = new CaptureTriggerAdapter(sink);
        assertTrue(adapter.arm());
        assertEquals(CaptureTriggerRouter.Action.NONE, adapter.onCameraVoiceEvent(null));
        assertEquals(CaptureTriggerRouter.Action.START, adapter.onCameraVoiceEvent(CameraVoiceEvent.START_RECORDING));
        assertEquals(java.util.Arrays.asList("start:CAMERA_VOICE"), sink.events);
        adapter.acknowledgeStart();
        assertEquals(CaptureTriggerRouter.Action.NONE, adapter.onShutter(CaptureTriggerRouter.Shutter.SHORT_PRESS));
        assertEquals(CaptureTriggerRouter.Action.STOP, adapter.onStop());
        assertEquals(java.util.Arrays.asList("start:CAMERA_VOICE", "stop"), sink.events);
    }

    @Test public void failedStartDoesNotCallStopAndCanRetry() {
        Sink sink = new Sink(); CaptureTriggerAdapter adapter = new CaptureTriggerAdapter(sink);
        adapter.arm();
        assertEquals(CaptureTriggerRouter.Action.START, adapter.onShutter(CaptureTriggerRouter.Shutter.SHORT_PRESS));
        adapter.startFailed();
        assertEquals(CaptureTriggerRouter.Action.START, adapter.onExternalStart());
        assertEquals(2, sink.events.size());
        assertEquals("start:EXTERNAL", sink.events.get(1));
        assertEquals(CaptureTriggerRouter.Action.NONE, adapter.onStop());
    }

    @Test public void adapterDisarmPreventsFutureTriggerDispatch() {
        Sink sink = new Sink(); CaptureTriggerAdapter adapter = new CaptureTriggerAdapter(sink);
        adapter.arm(); adapter.disarm();
        assertEquals(CaptureTriggerRouter.Action.NONE, adapter.onShutter(CaptureTriggerRouter.Shutter.SHORT_PRESS));
        assertTrue(sink.events.isEmpty());
        assertEquals(CaptureTriggerRouter.State.DISARMED, adapter.state());
    }
}
