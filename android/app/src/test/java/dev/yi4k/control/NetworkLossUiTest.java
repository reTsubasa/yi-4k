package dev.yi4k.control;

import android.net.ConnectivityManager;
import android.net.Network;
import android.os.Looper;
import android.widget.EditText;
import android.widget.TextView;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.Socket;
import java.io.IOException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;
import javax.net.SocketFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.android.controller.ActivityController;
import org.robolectric.annotation.Config;
import org.robolectric.annotation.LooperMode;
import static org.junit.Assert.*;
import static org.robolectric.Shadows.shadowOf;

/** Local socket/Android lifecycle interleavings; no real Wi-Fi or camera. */
@RunWith(RobolectricTestRunner.class)
@Config(sdk = 29)
@LooperMode(LooperMode.Mode.PAUSED)
public class NetworkLossUiTest {
    @Test public void queuedOldNetworkLossCannotClearReconnectedSession() throws Exception {
        try (SimulatedCamera server = new SimulatedCamera();
             ActivityController<MainActivity> lifecycle = Robolectric.buildActivity(MainActivity.class).setup()) {
            MainActivity activity = lifecycle.get();
            CameraClient camera = (CameraClient) field(activity, "camera").get(activity);
            AtomicLong generation = (AtomicLong) field(activity, "connectionGeneration").get(activity);
            ConnectivityManager.NetworkCallback callback = (ConnectivityManager.NetworkCallback) field(activity, "networkCallback").get(activity);
            Network first = org.robolectric.shadows.ShadowNetwork.newInstance(101), second = org.robolectric.shadows.ShadowNetwork.newInstance(102);
            field(activity, "network").set(activity, first);
            camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            Thread lost = new Thread(() -> callback.onLost(first));
            lost.start(); lost.join(3000); assertFalse(lost.isAlive());
            assertFalse(camera.isConnected());
            // Reconnect while the old onLost UI message is still queued.
            synchronized (field(activity, "connectionLock").get(activity)) {
                generation.incrementAndGet();
                field(activity, "network").set(activity, second);
                camera.connect(SocketFactory.getDefault(), "127.0.0.1", server.apiPort());
            }
            TextView state = (TextView) field(activity, "state").get(activity);
            state.setText("新会话已连接");
            shadowOf(Looper.getMainLooper()).idle();
            assertTrue(camera.isConnected());
            assertEquals(second, field(activity, "network").get(activity));
            assertEquals("新会话已连接", state.getText().toString());
            long current = generation.get();
            callback.onLost(first);
            shadowOf(Looper.getMainLooper()).idle();
            assertEquals(current, generation.get());
            assertTrue(camera.isConnected());
            assertEquals("idle", camera.call(1, CameraClient.args("type", "app_status")).getString("param"));
        }
    }

    public static class ConnectingActivity extends MainActivity {
        static SocketFactory factory;
        static int port;
        static Network route;
        @Override protected SocketFactory cameraSocketFactory(String address) throws Exception {
            field(this, "network").set(this, route);
            return factory;
        }
        @Override protected int cameraApiPort() { return port; }
    }

    @Test public void networkLossDuringSocketCreationCannotPublishSuccessfulConnection() throws Exception {
        CountDownLatch entered = new CountDownLatch(1), release = new CountDownLatch(1);
        try (SimulatedCamera server = new SimulatedCamera()) {
            ConnectingActivity.port = server.apiPort();
            ConnectingActivity.route = org.robolectric.shadows.ShadowNetwork.newInstance(103);
            ConnectingActivity.factory = new SocketFactory() {
                @Override public Socket createSocket() throws IOException {
                    entered.countDown();
                    try { if (!release.await(5, TimeUnit.SECONDS)) throw new IOException("test release timed out"); }
                    catch (InterruptedException e) { Thread.currentThread().interrupt(); throw new IOException(e); }
                    return new Socket();
                }
                @Override public Socket createSocket(String h, int p) throws IOException { return new Socket(h, p); }
                @Override public Socket createSocket(InetAddress h, int p) throws IOException { return new Socket(h, p); }
                @Override public Socket createSocket(String h, int p, InetAddress l, int lp) throws IOException { return new Socket(h, p, l, lp); }
                @Override public Socket createSocket(InetAddress h, int p, InetAddress l, int lp) throws IOException { return new Socket(h, p, l, lp); }
            };
            try (ActivityController<ConnectingActivity> lifecycle = Robolectric.buildActivity(ConnectingActivity.class).setup()) {
                MainActivity activity = lifecycle.get();
                ((EditText) field(activity, "host").get(activity)).setText("127.0.0.1");
                Method connect = MainActivity.class.getDeclaredMethod("connect"); connect.setAccessible(true); connect.invoke(activity);
                assertTrue(entered.await(5, TimeUnit.SECONDS));
                ConnectivityManager.NetworkCallback callback = (ConnectivityManager.NetworkCallback) field(activity, "networkCallback").get(activity);
                callback.onLost(ConnectingActivity.route);
                release.countDown();
                ((ExecutorService) field(activity, "commands").get(activity)).submit(() -> {}).get(5, TimeUnit.SECONDS);
                shadowOf(Looper.getMainLooper()).idle();
                assertNull(field(activity, "network").get(activity));
                assertFalse(((CameraClient) field(activity, "camera").get(activity)).isConnected());
                assertFalse(((TextView) field(activity, "message").get(activity)).getText().toString().contains("连接成功"));
            } finally { release.countDown(); ConnectingActivity.factory = null; ConnectingActivity.route = null; }
        }
    }

    @Test public void connectorFirstNetworkLossReturnsToDiscoveryAndIgnoresDuplicate() throws Exception {
        assertBothLossCallbacksReturnToDiscovery(true);
    }

    @Test public void generalFirstNetworkLossReturnsToDiscoveryAndIgnoresStaleConnector() throws Exception {
        assertBothLossCallbacksReturnToDiscovery(false);
    }

    private void assertBothLossCallbacksReturnToDiscovery(boolean connectorFirst) throws Exception {
        android.app.Application app = org.robolectric.RuntimeEnvironment.getApplication();
        shadowOf(app).grantPermissions(android.Manifest.permission.ACCESS_FINE_LOCATION,
                android.Manifest.permission.ACCESS_COARSE_LOCATION);
        app.getSystemService(android.net.wifi.WifiManager.class).setWifiEnabled(true);
        Network first = org.robolectric.shadows.ShadowNetwork.newInstance(104);
        Network second = org.robolectric.shadows.ShadowNetwork.newInstance(105);
        try (SimulatedCamera server = new SimulatedCamera()) {
            ConnectingActivity.port = server.apiPort();
            ConnectingActivity.route = first;
            ConnectingActivity.factory = new SocketFactory() {
                @Override public Socket createSocket() {
                    return new Socket() {
                        @Override public void connect(java.net.SocketAddress address,int timeout) throws IOException {
                            super.connect(new java.net.InetSocketAddress("127.0.0.1",server.apiPort()),timeout);
                        }
                    };
                }
                @Override public Socket createSocket(String h,int p) throws IOException { return new Socket("127.0.0.1",server.apiPort()); }
                @Override public Socket createSocket(InetAddress h,int p) throws IOException { return new Socket("127.0.0.1",server.apiPort()); }
                @Override public Socket createSocket(String h,int p,InetAddress l,int lp) throws IOException { return new Socket("127.0.0.1",server.apiPort()); }
                @Override public Socket createSocket(InetAddress h,int p,InetAddress l,int lp) throws IOException { return new Socket("127.0.0.1",server.apiPort()); }
            };
            try (ActivityController<ConnectingActivity> lifecycle = Robolectric.buildActivity(ConnectingActivity.class).setup()) {
                MainActivity activity = lifecycle.get();
                CameraWifiConnector connector = (CameraWifiConnector) field(activity,"wifiConnector").get(activity);
                Method connectWifi = MainActivity.class.getDeclaredMethod("connectCameraWifi",CameraWifiConnector.CameraWifi.class,String.class,boolean.class);
                connectWifi.setAccessible(true);
                connectWifi.invoke(activity,new CameraWifiConnector.CameraWifi("YDXJ_test","00:11:22:33:44:55",-40,
                        CameraWifiConnector.Security.OPEN),"",false);
                Field connectorCallbackField = CameraWifiConnector.class.getDeclaredField("networkCallback");
                connectorCallbackField.setAccessible(true);
                ConnectivityManager.NetworkCallback specific = (ConnectivityManager.NetworkCallback) connectorCallbackField.get(connector);
                assertNotNull(specific);
                specific.onAvailable(first);
                shadowOf(Looper.getMainLooper()).idleFor(java.time.Duration.ofMillis(600));
                ((ExecutorService)field(activity,"commands").get(activity)).submit(() -> {}).get(5,TimeUnit.SECONDS);
                shadowOf(Looper.getMainLooper()).idle();
                CameraClient camera = (CameraClient)field(activity,"camera").get(activity);
                assertTrue(camera.isConnected());
                assertEquals("control",field(activity,"page").get(activity));
                ConnectivityManager.NetworkCallback general = (ConnectivityManager.NetworkCallback)field(activity,"networkCallback").get(activity);
                if (connectorFirst) { specific.onLost(first); general.onLost(first); }
                else { general.onLost(first); specific.onLost(first); }
                shadowOf(Looper.getMainLooper()).idle();
                assertFalse(camera.isConnected());
                assertNull(field(activity,"network").get(activity));
                assertNull(field(activity,"selectedWifiNetwork").get(activity));
                assertEquals("connection",field(activity,"page").get(activity));
                assertEquals(1,field(activity,"connectionStep").get(activity));
                assertEquals("正在搜索附近的相机…",((TextView)field(activity,"wifiHint").get(activity)).getText().toString());
                assertTrue(connector.isScanning());

                // The old specifier callback must not tear down a replacement camera session.
                AtomicLong generation = (AtomicLong)field(activity,"connectionGeneration").get(activity);
                generation.incrementAndGet(); field(activity,"network").set(activity,second);
                field(activity,"selectedWifiNetwork").set(activity,second);
                camera.connect(SocketFactory.getDefault(),"127.0.0.1",server.apiPort());
                field(activity,"page").set(activity,"media");
                TextView state = (TextView)field(activity,"state").get(activity); state.setText("新会话已连接");
                long current = generation.get();
                specific.onLost(first); general.onLost(first); specific.onUnavailable();
                shadowOf(Looper.getMainLooper()).idle();
                assertEquals(current,generation.get()); assertTrue(camera.isConnected());
                assertEquals(second,field(activity,"network").get(activity));
                assertEquals("media",field(activity,"page").get(activity));
                assertEquals("新会话已连接",state.getText().toString());
            } finally { ConnectingActivity.factory = null; ConnectingActivity.route = null; }
        }
    }

    private static Field field(MainActivity activity, String name) throws Exception {
        Field field = MainActivity.class.getDeclaredField(name); field.setAccessible(true); return field;
    }
}
