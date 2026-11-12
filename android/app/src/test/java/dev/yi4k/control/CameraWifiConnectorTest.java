package dev.yi4k.control;

import android.Manifest;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.IpPrefix;
import android.net.LinkProperties;
import android.net.Network;
import android.net.RouteInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Looper;
import java.lang.reflect.Field;
import java.net.InetAddress;
import java.time.Duration;
import java.util.Arrays;
import java.util.List;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.RuntimeEnvironment;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

/** Offline Wi-Fi contracts; no adapter scan or physical network connection. */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 34)
@LooperMode(LooperMode.Mode.PAUSED)
public class CameraWifiConnectorTest {
    private Application app;
    @Before public void prepare() {
        app = RuntimeEnvironment.getApplication();
        shadowOf(app).grantPermissions(Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.NEARBY_WIFI_DEVICES);
        app.getSystemService(WifiManager.class).setWifiEnabled(true);
        shadowOf(app.getSystemService(LocationManager.class)).setLocationEnabled(true);
    }

    @Test public void filtersCameraPrefixSortsSignalAndKeepsStrongestDuplicate() {
        List<CameraWifiConnector.CameraWifi> results = CameraWifiConnector.filterScanResults(Arrays.asList(
                scan("home", "00:11:22:33:44:01", -10, "[ESS]"),
                scan("YDXJ_second", "00:11:22:33:44:02", -70, "[WPA2-PSK-CCMP][ESS]"),
                scan("YDXJ_first", "00:11:22:33:44:03", -45, "[WPA2-PSK-CCMP][ESS]"),
                scan("YDXJ_second", "00:11:22:33:44:04", -35, "[WPA2-PSK-CCMP][ESS]"),
                scan("ydxj_wrong", "00:11:22:33:44:05", -15, "[ESS]"), null));
        assertEquals(2, results.size());
        assertEquals("YDXJ_second", results.get(0).ssid);
        assertEquals("00:11:22:33:44:04", results.get(0).bssid);
        assertEquals("YDXJ_first", results.get(1).ssid);
        assertThrows(UnsupportedOperationException.class, () -> results.clear());
        assertTrue(CameraWifiConnector.filterScanResults(null).isEmpty());
    }

    @Test public void distinguishesSupportedSecurityFromEnterpriseAndWapi() {
        assertEquals(CameraWifiConnector.Security.OPEN, CameraWifiConnector.security("[ESS]"));
        assertEquals(CameraWifiConnector.Security.WPA2, CameraWifiConnector.security("[WPA2-PSK-CCMP][RSN-SAE-CCMP]"));
        assertEquals(CameraWifiConnector.Security.WPA3, CameraWifiConnector.security("[RSN-SAE-CCMP]"));
        for (String cap : new String[] {"[WEP]", "[WPA2-EAP-CCMP]", "[WAPI-PSK-SMS4]", "[RSN-OWE-CCMP]"})
            assertEquals(cap, CameraWifiConnector.Security.UNSUPPORTED, CameraWifiConnector.security(cap));
    }

    @Test public void validatesPassphraseWithoutTrimmingOrAcceptingControlCharacters() {
        assertTrue(CameraWifiConnector.isValidPassword(CameraWifiConnector.Security.OPEN, null));
        for (String password : new String[] {null, "", "1234567", "1234567\n", "密码12345678", "a".repeat(64)})
            assertFalse(CameraWifiConnector.isValidPassword(CameraWifiConnector.Security.WPA2, password));
        assertTrue(CameraWifiConnector.isValidPassword(CameraWifiConnector.Security.WPA2, " password "));
        assertTrue(CameraWifiConnector.isValidPassword(CameraWifiConnector.Security.WPA2, "a".repeat(63)));
    }

    @Test public void usesOnlyIpv4DefaultGatewayAndHasDeterministicFallback() throws Exception {
        LinkProperties properties = new LinkProperties();
        properties.setInterfaceName("wlan0");
        properties.addRoute(route("192.168.8.0", 24, null));
        properties.addRoute(route("::", 0, "fe80::1"));
        assertEquals("192.168.42.1", CameraWifiConnector.cameraHost(properties));
        properties.addRoute(route("0.0.0.0", 0, "192.168.8.1"));
        assertEquals("192.168.8.1", CameraWifiConnector.cameraHost(properties));
        assertEquals("192.168.42.1", CameraWifiConnector.cameraHost(null));
    }

    @Test public void approximateOnlyPermissionNeedsCoarseFinePairAndNearbyOnAndroid13() {
        shadowOf(app).denyPermissions(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.NEARBY_WIFI_DEVICES);
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            assertArrayEquals(new String[] {Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.NEARBY_WIFI_DEVICES}, connector.missingPermissions());
            Events events = new Events();
            connector.scan(events);
            assertEquals(CameraWifiConnector.Error.PERMISSION_REQUIRED, events.error);
            assertFalse(connector.isScanning());
        }
    }

    @Test public void malformedSavedCiphertextIsDiscardedRatherThanUsedAsPassword() {
        app.getSharedPreferences("camera_wifi_passwords_v1", Context.MODE_PRIVATE)
                .edit().putString("YDXJ_test", "plaintext-secret").commit();
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            assertEquals("", connector.savedPassword("YDXJ_test"));
            assertFalse(app.getSharedPreferences("camera_wifi_passwords_v1", Context.MODE_PRIVATE).contains("YDXJ_test"));
        }
    }

    @Test public void throttledScanLabelsCachedCandidatesAndDoesNotWaitForBroadcast() {
        WifiManager wifi = app.getSystemService(WifiManager.class);
        shadowOf(wifi).setStartScanSucceeds(false);
        shadowOf(wifi).setScanResults(Arrays.asList(scan("YDXJ_cached", "00:11:22:33:44:00", -50, "[ESS]")));
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            Events events = new Events();
            connector.scan(events);
            assertEquals(1, events.scanned);
            assertFalse(events.fresh);
            assertEquals("YDXJ_cached", events.cameras.get(0).ssid);
            assertFalse(connector.isScanning());
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(20));
            assertNull(events.error);
        }
    }

    @Test public void cancelledScanDropsFutureBroadcastAndTimeout() {
        shadowOf(app.getSystemService(WifiManager.class)).setStartScanSucceeds(true);
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            Events events = new Events();
            connector.scan(events);
            assertTrue(connector.isScanning());
            connector.cancelScan();
            app.sendBroadcast(new Intent(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
                    .putExtra(WifiManager.EXTRA_RESULTS_UPDATED, true));
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(20));
            assertEquals(0, events.scanned);
            assertNull(events.error);
        }
    }

    @Test public void cancelledConnectionIgnoresLateAvailableAndReleasesNetworkRequest() throws Exception {
        CameraWifiConnector connector = new CameraWifiConnector(app);
        Events events = new Events();
        connector.connect(camera(), "12345678", false, events);
        ConnectivityManager.NetworkCallback callback = callback(connector);
        assertNotNull(callback);
        assertTrue(connector.isConnecting());
        connector.disconnect();
        callback.onAvailable(org.robolectric.shadows.ShadowNetwork.newInstance(909));
        shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(60));
        assertEquals(0, events.connected);
        assertNull(events.error);
        assertFalse(connector.isConnected());
        assertNull(callback(connector));
        connector.close();
    }

    @Test public void connectionTimesOutAndLateCallbacksCannotReviveIt() throws Exception {
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            Events events = new Events();
            connector.connect(camera(), "12345678", false, events);
            ConnectivityManager.NetworkCallback callback = callback(connector);
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(46));
            assertEquals(CameraWifiConnector.Error.CONNECTION_TIMEOUT, events.error);
            callback.onAvailable(org.robolectric.shadows.ShadowNetwork.newInstance(910));
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(1));
            assertEquals(0, events.connected);
            assertFalse(connector.isConnecting());
        }
    }

    @Test public void replacementConnectionSurvivesThePreviousRequestsLateRejection() throws Exception {
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            Events oldEvents = new Events(), newEvents = new Events();
            connector.connect(camera(), "12345678", false, oldEvents);
            ConnectivityManager.NetworkCallback previous = callback(connector);
            connector.connect(camera(), "87654321", false, newEvents);
            ConnectivityManager.NetworkCallback current = callback(connector);
            previous.onUnavailable();
            assertTrue(connector.isConnecting());
            assertSame(current, callback(connector));
            current.onAvailable(org.robolectric.shadows.ShadowNetwork.newInstance(912));
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(1));
            assertEquals(0, oldEvents.connected);
            assertNull(oldEvents.error);
            assertEquals(1, newEvents.connected);
            assertNull(newEvents.error);
        }
    }

    @Test public void successFallsBackOnceThenLostIsReportedOnce() throws Exception {
        try (CameraWifiConnector connector = new CameraWifiConnector(app)) {
            Events events = new Events();
            connector.connect(camera(), "12345678", false, events);
            ConnectivityManager.NetworkCallback callback = callback(connector);
            Network network = org.robolectric.shadows.ShadowNetwork.newInstance(911);
            callback.onAvailable(network);
            callback.onAvailable(network);
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(1));
            assertEquals(1, events.connected);
            assertEquals("192.168.42.1", events.host);
            assertTrue(connector.isConnected());
            callback.onAvailable(org.robolectric.shadows.ShadowNetwork.newInstance(999));
            callback.onLost(network);
            callback.onLost(network);
            assertEquals(1, events.lost);
            assertFalse(connector.isConnected());
            shadowOf(Looper.getMainLooper()).idleFor(Duration.ofSeconds(60));
            assertNull(events.error);
        }
    }

    private static CameraWifiConnector.CameraWifi camera() {
        return new CameraWifiConnector.CameraWifi("YDXJ_test", "00:11:22:33:44:55", -45, CameraWifiConnector.Security.WPA2);
    }
    private static RouteInfo route(String destination, int prefix, String gateway) throws Exception {
        // Android's route constructor is hidden from the public SDK; exercise the real framework type.
        return RouteInfo.class.getConstructor(IpPrefix.class, InetAddress.class, String.class).newInstance(
                new IpPrefix(InetAddress.getByName(destination), prefix),
                gateway == null ? null : InetAddress.getByName(gateway), "wlan0");
    }
    private static ScanResult scan(String ssid, String bssid, int level, String caps) {
        ScanResult result = new ScanResult();
        result.SSID = ssid; result.BSSID = bssid; result.level = level; result.capabilities = caps;
        return result;
    }
    private static ConnectivityManager.NetworkCallback callback(CameraWifiConnector connector) throws Exception {
        Field field = CameraWifiConnector.class.getDeclaredField("networkCallback");
        field.setAccessible(true);
        return (ConnectivityManager.NetworkCallback) field.get(connector);
    }
    private static final class Events implements CameraWifiConnector.ScanCallback, CameraWifiConnector.ConnectionCallback {
        CameraWifiConnector.Error error;
        int connected, lost, scanned;
        String host;
        boolean fresh;
        List<CameraWifiConnector.CameraWifi> cameras;
        @Override public void onResults(List<CameraWifiConnector.CameraWifi> cameras, boolean fresh) {
            scanned++; this.cameras = cameras; this.fresh = fresh;
        }
        @Override public void onError(CameraWifiConnector.Error error, String message) { this.error = error; }
        @Override public void onConnected(Network network, String cameraHost) { connected++; host = cameraHost; }
        @Override public void onLost() { lost++; }
    }
}
