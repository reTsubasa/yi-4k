package dev.yi4k.control;

import java.io.IOException;
import org.junit.Test;
import static org.junit.Assert.*;

public class CameraPreviewAddressTest {
    private static final String HOST = "192.168.42.1";

    @Test public void acceptsTheActualSession257AddressWithoutInventingAPathOrPort() throws Exception {
        // artifacts/device/2026-11-10-project-continuation/baseline-01/session.json
        assertEquals("rtsp://192.168.42.1/live", CameraPreviewAddress.validate(HOST, "rtsp://192.168.42.1/live"));
        assertEquals("rtsp://192.168.42.1:8554/live/main.sdp", CameraPreviewAddress.validate(HOST, "rtsp://192.168.42.1:8554/live/main.sdp"));
        assertEquals("rtsp://192.168.42.1:65535/", CameraPreviewAddress.validate(HOST, "rtsp://192.168.42.1:65535/"));
    }

    @Test public void missingAdvertisedStreamFailsInsteadOfGuessingTheLiveEndpoint() {
        for (String missing : new String[] {null, "", " ", "rtsp://192.168.42.1", "/live"})
            rejected(HOST, missing);
    }

    @Test public void rejectsOtherCamerasHostnamesAndAmbiguousIpSpellingsWithoutDns() {
        for (String address : new String[] {
                "rtsp://192.168.42.2/live", "rtsp://camera.local/live", "rtsp://localhost/live",
                "rtsp://192.168.42.1.example.com/live", "rtsp://192.168.042.1/live",
                "rtsp://3232246273/live", "rtsp://0xc0a82a01/live", "rtsp://[::1]/live",
                "rtsp://192.168.42.1./live", "rtsp://%31%39%32.168.42.1/live"})
            rejected(HOST, address);
        for (String cameraHost : new String[] {null, "", "camera.local", "192.168.42", "192.168.42.256",
                "192.168.42.01", "192.168.42.1:554", " 192.168.42.1", "192.168.42.1\n"})
            rejected(cameraHost, "rtsp://192.168.42.1/live");
    }

    @Test public void rejectsCredentialsQueryFragmentsAndOtherSchemes() {
        for (String address : new String[] {
                "http://192.168.42.1/live", "https://192.168.42.1/live", "rtsps://192.168.42.1/live",
                "rtsp://user@192.168.42.1/live", "rtsp://user:pass@192.168.42.1/live",
                "rtsp://192.168.42.1/live?token=secret", "rtsp://192.168.42.1/live?",
                "rtsp://192.168.42.1/live#frame", "rtsp://192.168.42.1/live#"})
            rejected(HOST, address);
    }

    @Test public void rejectsMalformedOrOutOfRangePorts() {
        for (String port : new String[] {"", "0", "65536", "-1", "+554", "five", "9999999999999999"})
            rejected(HOST, "rtsp://192.168.42.1:" + port + "/live");
    }

    @Test public void rejectsBrokenEscapingControlCharactersAndTraversalPaths() {
        for (String path : new String[] {"/bad%", "/live\n", "/live%0d%0aInjected", "/live%00",
                "/a/../live", "/a/%2e%2e/live", "/./live", "/a%2f..%2flive", "/a%5clive"})
            rejected(HOST, "rtsp://192.168.42.1" + path);
    }

    private static void rejected(String cameraHost, String advertised) {
        IOException error = assertThrows(IOException.class, () -> CameraPreviewAddress.validate(cameraHost, advertised));
        assertNotNull(error.getMessage());
    }
}
