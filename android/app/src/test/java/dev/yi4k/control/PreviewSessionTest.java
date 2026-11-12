package dev.yi4k.control;

import javax.net.SocketFactory;
import org.junit.Test;
import static org.junit.Assert.*;

public class PreviewSessionTest {
    @Test public void mediaAddressBelongsToTheCurrentSessionAndNeverSurvivesDisconnect() throws Exception {
        try (SimulatedCamera first = new SimulatedCamera(); SimulatedCamera second = new SimulatedCamera();
             CameraClient camera = new CameraClient(ignored -> {})) {
            first.rtspAddress = "rtsp://127.0.0.1/live";
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", first.apiPort());
            assertEquals(first.rtspAddress, CameraPreviewAddress.validate("127.0.0.1", camera.advertisedRtsp()));
            camera.disconnect();
            assertEquals("", camera.advertisedRtsp());
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", second.apiPort());
            assertEquals("", camera.advertisedRtsp());
            assertThrows(java.io.IOException.class, () -> CameraPreviewAddress.validate("127.0.0.1", camera.advertisedRtsp()));
        }
    }
}
