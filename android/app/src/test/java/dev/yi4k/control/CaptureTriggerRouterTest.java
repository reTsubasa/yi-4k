package dev.yi4k.control;

import org.junit.Test;
import static org.junit.Assert.*;

public class CaptureTriggerRouterTest {
    @Test public void shutterAndVoiceShareOneIdempotentStartPath() {
        CaptureTriggerRouter router = new CaptureTriggerRouter();
        assertTrue(router.arm());
        assertEquals(CaptureTriggerRouter.Action.START, router.onShutter(CaptureTriggerRouter.Shutter.SHORT_PRESS));
        assertEquals(CaptureTriggerRouter.Source.SHUTTER, router.lastSource());
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onCameraVoiceEvent(CameraVoiceEvent.START_RECORDING));
        router.acknowledgeStart();
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onShutter(CaptureTriggerRouter.Shutter.SHORT_PRESS));
        assertEquals(CaptureTriggerRouter.State.RECORDING, router.state());
    }

    @Test public void onlyFirmwareConfirmedStartEventEntersTheSharedPath() {
        CaptureTriggerRouter router = new CaptureTriggerRouter();
        router.arm();
        assertEquals(CaptureTriggerRouter.Action.START, router.onCameraVoiceEvent(CameraVoiceEvent.START_RECORDING));
        router.acknowledgeStart();
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onCameraVoiceEvent(CameraVoiceEvent.START_RECORDING));
    }

    @Test public void longPressUnknownVoiceAndDuplicateStopAreIgnored() {
        CaptureTriggerRouter router = new CaptureTriggerRouter();
        router.arm();
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onShutter(CaptureTriggerRouter.Shutter.LONG_PRESS));
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onCameraVoiceEvent(null));
        assertEquals(CaptureTriggerRouter.Action.START, router.onExternalStart());
        router.acknowledgeStart();
        assertEquals(CaptureTriggerRouter.Action.STOP, router.onStop());
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onStop());
    }

    @Test public void failedStartCanRetryAndDisarmCancelsPendingIntent() {
        CaptureTriggerRouter router = new CaptureTriggerRouter();
        router.arm();
        assertEquals(CaptureTriggerRouter.Action.START, router.onExternalStart());
        router.startFailed();
        assertEquals(CaptureTriggerRouter.Action.START, router.onShutter(CaptureTriggerRouter.Shutter.SHORT_PRESS));
        router.disarm();
        assertEquals(CaptureTriggerRouter.State.DISARMED, router.state());
        assertEquals(CaptureTriggerRouter.Action.NONE, router.onCameraVoiceEvent(null));
    }
}
