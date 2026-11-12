package dev.yi4k.control;

import org.json.JSONObject;
import org.junit.Test;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.concurrent.atomic.AtomicBoolean;
import static org.junit.Assert.*;

public class SettingsAndTransferTest {
    @Test public void settingsUseReadableChineseLabelsAndPreserveUnknownWireValues() {
        assertEquals("视频质量", CameraSettings.displayName("video_quality"));
        assertEquals("电子防抖（EIS）", CameraSettings.displayName("iq_eis_enable"));
        assertEquals("高质量", CameraSettings.displayValue("video_quality", "Fine"));
        assertEquals("关闭", CameraSettings.displayValue("iq_eis_enable", "off"));
        assertEquals("1920x1080 30P 16:9", CameraSettings.displayValue("video_resolution", "1920x1080 30P 16:9"));
        assertEquals("future value", CameraSettings.displayValue("future_setting", "future value"));
        assertTrue(CameraSettings.displayName("future_setting").contains("future_setting"));
    }

    @Test public void settingsIncludeCameraSpecificKeysAndPreserveScalarTypes() throws Exception {
        JSONObject settings = new JSONObject("{\"new_camera_setting\":7,\"system_mode\":\"record\",\"sw_version\":\"1.10.7\"}");
        assertEquals(Arrays.asList("new_camera_setting", "sw_version", "system_mode"), CameraSettings.keys(settings));
        assertEquals(Arrays.asList(1, true, "off"), CameraSettings.writableOptions("new_camera_setting",
                new JSONObject("{\"permission\":\"settable\",\"options\":[1,true,\"off\"]}")));
        assertTrue(CameraSettings.writableOptions("sw_version", new JSONObject("{\"permission\":\"readonly\",\"options\":[\"x\"]}")).isEmpty());
    }
    @Test public void destructiveActionsCannotBeEnabledByAdvertisedOptions() throws Exception {
        JSONObject options = new JSONObject("{\"permission\":\"settable\",\"options\":[\"off\",\"format\",\"factory_reset\",\"restore factory settings\",\"reboot\",\"power off\"]}");
        for (String key : new String[]{"format", "factory_reset", "restore_factory_settings", "firmware_update", "delete_all"})
            assertTrue(key, CameraSettings.writableOptions(key, options).isEmpty());
        assertEquals(Arrays.asList("off"), CameraSettings.writableOptions("card_action", options));
        assertTrue(CameraSettings.safeKey("auto_power_off"));
        assertFalse(CameraSettings.safeKey("power_off"));
        assertFalse(CameraSettings.safeKey("factory_reset"));
    }
    @Test public void completeTransferPreservesBytesAndDigest() throws Exception {
        byte[] bytes = new byte[180000];
        for (int i = 0; i < bytes.length; i++) bytes[i] = (byte) i;
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        assertEquals(bytes.length, MediaTransfer.copy(new ByteArrayInputStream(bytes), output, bytes.length, () -> false, n -> {}, digest));
        assertArrayEquals(bytes, output.toByteArray());
        assertArrayEquals(MessageDigest.getInstance("SHA-256").digest(bytes), digest.digest());
    }
    @Test public void shortOversizedAndUnknownTransfersAreRejected() throws Exception {
        for (long expected : new long[]{-1, 0, 2, 4}) {
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            try {
                MediaTransfer.copy(new ByteArrayInputStream(new byte[]{1,2,3}), output, expected, () -> false, n -> {}, MessageDigest.getInstance("SHA-256"));
                fail("expected=" + expected);
            } catch (IOException expectedFailure) {
                if (expected == 2) assertEquals(0, output.size());
            }
        }
    }
    @Test public void cancellationBeforeAndDuringReadStopsBeforePublishingBytes() throws Exception {
        AtomicBoolean cancelled = new AtomicBoolean(true);
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        try {
            MediaTransfer.copy(new ByteArrayInputStream(new byte[]{1}), output, 1, cancelled::get, n -> {}, MessageDigest.getInstance("SHA-256"));
            fail();
        } catch (IOException expected) { assertEquals(0, output.size()); }
        cancelled.set(false);
        InputStream changesDuringRead = new ByteArrayInputStream(new byte[]{1}) {
            @Override public synchronized int read(byte[] bytes, int start, int length) {
                int count = super.read(bytes, start, length); cancelled.set(true); return count;
            }
        };
        try {
            MediaTransfer.copy(changesDuringRead, output, 1, cancelled::get, n -> {}, MessageDigest.getInstance("SHA-256"));
            fail();
        } catch (IOException expected) { assertEquals(0, output.size()); }
    }
    @Test public void ioFailureRemainsFailureAfterPartialTransfer() throws Exception {
        InputStream broken = new InputStream() {
            int calls;
            @Override public int read() throws IOException { throw new IOException("lost connection"); }
            @Override public int read(byte[] bytes, int start, int length) throws IOException {
                if (calls++ > 0) throw new IOException("lost connection");
                bytes[start] = 1; return 1;
            }
        };
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        try {
            MediaTransfer.copy(broken, output, 2, () -> false, n -> {}, MessageDigest.getInstance("SHA-256"));
            fail();
        } catch (IOException expected) { assertEquals("lost connection", expected.getMessage()); assertEquals(1, output.size()); }
    }
}
