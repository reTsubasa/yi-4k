package dev.yi4k.control;

import android.test.InstrumentationTestCase;
import org.json.JSONObject;
import java.util.Arrays;
import java.util.List;

/** Device-side checks for state/config rules; the same assertions also run in host tests. */
public final class CameraLogicInstrumentationTest extends InstrumentationTestCase {
    public void testReadyStatesOnly() {
        assertTrue(CameraState.isReady("idle"));
        assertTrue(CameraState.isReady("vf"));
        assertFalse(CameraState.isReady("record"));
        assertFalse(CameraState.isReady("Unknown"));
    }
    public void testDynamicOptionsKeepScalarValuesAndRejectDangerousActions() throws Exception {
        JSONObject response = new JSONObject("{\"permission\":\"settable\",\"options\":[\"on\",false,3,\"factory_reset\"]}");
        List<Object> values = CameraSettings.writableOptions("iq_eis_enable", response);
        assertEquals(Arrays.asList("on", false, 3), values);
        assertTrue(CameraSettings.writableOptions("format", response).isEmpty());
    }
}
