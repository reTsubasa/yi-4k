package dev.yi4k.control;

import android.content.SharedPreferences;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import org.robolectric.RobolectricTestRunner;
import static org.junit.Assert.*;

/** Saved camera metadata stays useful for reconnect without persisting a password. */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public final class SavedCameraConnectionTest {
    @Test public void successfulConnectionMetadataStoresRouteIdentityWithoutSecret() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            Field candidate = MainActivity.class.getDeclaredField("pendingWifiCandidate");
            candidate.setAccessible(true);
            candidate.set(activity, new CameraWifiConnector.CameraWifi(
                    "YDXJ_saved", "00:11:22:33:44:55", -40, CameraWifiConnector.Security.WPA2));
            Method remember = MainActivity.class.getDeclaredMethod("rememberConnectedCamera", String.class);
            remember.setAccessible(true); remember.invoke(activity, "192.168.42.1");
            SharedPreferences saved = activity.getPreferences(0);
            assertTrue(saved.getBoolean("camera_connection_saved", false));
            assertEquals("YDXJ_saved", saved.getString("camera_saved_ssid", ""));
            assertEquals("00:11:22:33:44:55", saved.getString("camera_saved_bssid", ""));
            assertEquals("WPA2", saved.getString("camera_saved_security", ""));
            assertEquals("192.168.42.1", saved.getString("camera_host", ""));
            assertFalse("The route metadata must never contain a Wi-Fi password", saved.contains("camera_password"));
        }
    }

    @Test public void incompleteSavedMetadataFallsBackToNormalConnectionPage() throws Exception {
        try (ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            activity.getPreferences(0).edit().putBoolean("camera_connection_saved", true)
                    .putString("camera_host", "not-an-ip").putString("camera_saved_ssid", "YDXJ_saved").commit();
            Method attempt = MainActivity.class.getDeclaredMethod("attemptSavedCameraAutoConnect");
            attempt.setAccessible(true);
            assertFalse((Boolean) attempt.invoke(activity));
            assertEquals("connection", field(activity, "page"));
        }
    }

    private static Object field(MainActivity activity, String name) throws Exception {
        Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return field.get(activity);
    }
}
