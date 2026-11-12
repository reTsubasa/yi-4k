package dev.yi4k.control;

import javax.net.SocketFactory;
import org.junit.Test;
import static org.junit.Assert.*;

public final class CameraStorageTest {
    @Test public void capacityUsesSameUnitCountersAndRejectsInvalidReadback() {
        assertEquals(4, CameraStorage.usedPercent(61444608, 59193344));
        assertEquals(0, CameraStorage.usedPercent(Long.MAX_VALUE, Long.MAX_VALUE));
        assertEquals(100, CameraStorage.usedPercent(Long.MAX_VALUE, 0));
        assertEquals(-1, CameraStorage.usedPercent(0, 0));
        assertEquals(-1, CameraStorage.usedPercent(10, 11));
        assertEquals(-1, CameraStorage.usedPercent(10, -1));
    }
    @Test public void queriesActualCapacityApiInsteadOfGuessingSettingsKeys() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera(); CameraClient camera = new CameraClient(event -> {})) {
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            assertEquals(28, CameraStorage.readUsedPercent(camera));
            assertEquals(2, java.util.Collections.frequency(server.requests, 5));
        }
    }
}
