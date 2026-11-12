package dev.yi4k.control;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.LinkProperties;
import android.net.MacAddress;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.RouteInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiNetworkSpecifier;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Base64;

import java.net.Inet4Address;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

/** Activity-owned Android 10+ local Wi-Fi connection. Call public lifecycle methods on the main thread.
 * The returned Network must be supplied to camera sockets; this helper never binds the whole process.
 */
public final class CameraWifiConnector implements AutoCloseable {
    public static final String FALLBACK_HOST = "192.168.42.1";
    private static final long SCAN_TIMEOUT_MS = 15000;
    private static final int CONNECTION_TIMEOUT_MS = 45000;
    private static final String KEY_ALIAS = "yi4k.camera-wifi.password.v1";

    public enum Security { OPEN, WPA2, WPA3, UNSUPPORTED }
    public enum Error {
        PERMISSION_REQUIRED, WIFI_DISABLED, LOCATION_DISABLED, SCAN_THROTTLED, SCAN_TIMEOUT,
        CONNECTION_TIMEOUT, CONNECTION_REJECTED, INVALID_PASSWORD, UNSUPPORTED_SECURITY,
        UNAVAILABLE, CLOSED
    }

    public static final class CameraWifi {
        public final String ssid;
        public final String bssid;
        public final int signalDbm;
        public final Security security;

        CameraWifi(String ssid, String bssid, int signalDbm, Security security) {
            this.ssid = ssid;
            this.bssid = bssid;
            this.signalDbm = signalDbm;
            this.security = security;
        }

        public boolean needsPassword() { return security == Security.WPA2 || security == Security.WPA3; }
    }

    public interface ScanCallback {
        /** fresh=false means Android throttled the scan and these are cached results. */
        void onResults(List<CameraWifi> cameras, boolean fresh);
        void onError(Error error, String message);
    }

    public interface ConnectionCallback {
        void onConnected(Network network, String cameraHost);
        void onLost();
        void onError(Error error, String message);
        default void onPasswordSaveFailed(String message) { }
    }

    private final Context context;
    private final WifiManager wifi;
    private final ConnectivityManager connectivity;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final SharedPreferences passwords;
    private BroadcastReceiver scanReceiver;
    private Runnable scanTimeout;
    private ConnectivityManager.NetworkCallback networkCallback;
    private Runnable connectionTimeout;
    private Runnable gatewayTimeout;
    private volatile Network connectedNetwork;
    private int scanGeneration;
    private int connectionGeneration;
    private boolean closed;

    public CameraWifiConnector(Context context) {
        this.context = context.getApplicationContext();
        wifi = this.context.getSystemService(WifiManager.class);
        connectivity = this.context.getSystemService(ConnectivityManager.class);
        passwords = this.context.getSharedPreferences("camera_wifi_passwords_v1", Context.MODE_PRIVATE);
    }

    public String[] missingPermissions() {
        List<String> missing = new ArrayList<>();
        if (context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // Android 12+ ignores a fine-only runtime request: ask for coarse and fine together.
            missing.add(Manifest.permission.ACCESS_COARSE_LOCATION);
            missing.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }
        if (Build.VERSION.SDK_INT >= 33 && context.checkSelfPermission(Manifest.permission.NEARBY_WIFI_DEVICES)
                != PackageManager.PERMISSION_GRANTED) missing.add(Manifest.permission.NEARBY_WIFI_DEVICES);
        return missing.toArray(new String[0]);
    }

    public boolean isScanning() { return scanReceiver != null; }
    public boolean isConnecting() { return networkCallback != null && connectedNetwork == null; }
    public boolean isConnected() { return connectedNetwork != null; }

    @SuppressLint("MissingPermission")
    @SuppressWarnings("deprecation")
    public void scan(ScanCallback callback) {
        requireMainThread();
        cancelScan();
        if (closed) { callback.onError(Error.CLOSED, "连接助手已关闭"); return; }
        if (missingPermissions().length > 0) {
            callback.onError(Error.PERMISSION_REQUIRED, "请允许附近设备和精确位置权限，以查找相机 Wi-Fi"); return;
        }
        if (wifi == null || !wifi.isWifiEnabled()) {
            callback.onError(Error.WIFI_DISABLED, "请先开启手机 Wi-Fi"); return;
        }
        LocationManager location = context.getSystemService(LocationManager.class);
        if (location == null || !location.isLocationEnabled()) {
            callback.onError(Error.LOCATION_DISABLED, "Android 扫描 Wi-Fi 需要开启手机定位服务"); return;
        }
        int generation = scanGeneration;
        scanReceiver = new BroadcastReceiver() {
            @Override public void onReceive(Context unused, Intent intent) {
                if (generation != scanGeneration) return;
                boolean fresh = intent.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false);
                finishScan(generation, callback, fresh);
            }
        };
        try {
            IntentFilter filter = new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION);
            if (Build.VERSION.SDK_INT >= 33) context.registerReceiver(scanReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
            else context.registerReceiver(scanReceiver, filter);
            scanTimeout = () -> {
                if (generation != scanGeneration) return;
                cancelScan();
                callback.onError(Error.SCAN_TIMEOUT, "搜索超时，请确认相机 Wi-Fi 已开启后重试");
            };
            handler.postDelayed(scanTimeout, SCAN_TIMEOUT_MS);
            if (!wifi.startScan()) finishScan(generation, callback, false);
        } catch (SecurityException denied) {
            cancelScan();
            callback.onError(Error.PERMISSION_REQUIRED, "无法搜索 Wi-Fi，请检查精确位置和附近设备权限");
        } catch (RuntimeException unavailable) {
            cancelScan();
            callback.onError(Error.UNAVAILABLE, "当前无法搜索 Wi-Fi，请稍后重试");
        }
    }

    @SuppressLint("MissingPermission")
    private void finishScan(int generation, ScanCallback callback, boolean fresh) {
        if (generation != scanGeneration) return;
        List<CameraWifi> results;
        try { results = filterScanResults(wifi.getScanResults()); }
        catch (SecurityException denied) {
            cancelScan();
            callback.onError(Error.PERMISSION_REQUIRED, "Wi-Fi 搜索权限已被关闭"); return;
        }
        cancelScan();
        if (!fresh && results.isEmpty()) callback.onError(Error.SCAN_THROTTLED, "系统暂时限制了 Wi-Fi 搜索，请稍后重试");
        else callback.onResults(results, fresh);
    }

    public void cancelScan() {
        requireMainThread();
        scanGeneration++;
        if (scanTimeout != null) handler.removeCallbacks(scanTimeout);
        scanTimeout = null;
        if (scanReceiver != null) {
            try { context.unregisterReceiver(scanReceiver); } catch (IllegalArgumentException ignored) { }
            scanReceiver = null;
        }
    }

    @SuppressLint("MissingPermission")
    public void connect(CameraWifi camera, String password, boolean remember, ConnectionCallback callback) {
        requireMainThread();
        if (closed) { callback.onError(Error.CLOSED, "连接助手已关闭"); return; }
        if (camera == null || !isCameraSsid(camera.ssid)) {
            callback.onError(Error.UNAVAILABLE, "请选择搜索到的 YDXJ 相机"); return;
        }
        if (missingPermissions().length > 0) {
            callback.onError(Error.PERMISSION_REQUIRED, "请先允许精确位置和附近设备权限"); return;
        }
        if (wifi == null || !wifi.isWifiEnabled()) {
            callback.onError(Error.WIFI_DISABLED, "请先开启手机 Wi-Fi"); return;
        }
        if (connectivity == null) { callback.onError(Error.UNAVAILABLE, "手机网络服务不可用"); return; }
        if (camera.security == Security.UNSUPPORTED) {
            callback.onError(Error.UNSUPPORTED_SECURITY, "相机使用了不支持的 Wi-Fi 加密方式，请检查相机网络设置"); return;
        }
        if (!isValidPassword(camera.security, password)) {
            callback.onError(Error.INVALID_PASSWORD, "Wi-Fi 密码应为 8 至 63 位英文字母、数字或符号"); return;
        }
        cancelScan();
        disconnect();
        int generation = connectionGeneration;
        final String passphrase = camera.needsPassword() ? password : "";
        try {
            WifiNetworkSpecifier.Builder specifier = new WifiNetworkSpecifier.Builder().setSsid(camera.ssid);
            if (camera.bssid != null && !camera.bssid.isEmpty()) specifier.setBssid(MacAddress.fromString(camera.bssid));
            if (camera.security == Security.WPA2) specifier.setWpa2Passphrase(passphrase);
            else if (camera.security == Security.WPA3) specifier.setWpa3Passphrase(passphrase);
            NetworkRequest request = new NetworkRequest.Builder()
                    .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                    .removeCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                    .setNetworkSpecifier(specifier.build()).build();
            networkCallback = new ConnectivityManager.NetworkCallback() {
                private Network available;
                private boolean delivered;

                private void complete(Network network, LinkProperties properties) {
                    if (generation != connectionGeneration || delivered || !network.equals(available)) return;
                    delivered = true;
                    connectedNetwork = network;
                    clearConnectionTimers();
                    callback.onConnected(network, cameraHost(properties));
                    // A callback may close/release this connector immediately.
                    if (generation != connectionGeneration) return;
                    if (remember && camera.needsPassword()) {
                        if (!savePassword(camera.ssid, passphrase))
                            callback.onPasswordSaveFailed("相机已连接，但手机无法安全记住密码，下次连接需要重新输入");
                    } else forgetPassword(camera.ssid);
                }

                @Override public void onAvailable(Network network) {
                    if (generation != connectionGeneration || delivered || network.equals(available)) return;
                    if (gatewayTimeout != null) handler.removeCallbacks(gatewayTimeout);
                    available = network;
                    LinkProperties properties = connectivity.getLinkProperties(network);
                    if (gateway(properties) != null) complete(network, properties);
                    else {
                        gatewayTimeout = () -> complete(network, connectivity.getLinkProperties(network));
                        handler.postDelayed(gatewayTimeout, 600);
                    }
                }

                @Override public void onLinkPropertiesChanged(Network network, LinkProperties properties) {
                    if (network.equals(available) && gateway(properties) != null) complete(network, properties);
                }

                @Override public void onUnavailable() {
                    if (generation != connectionGeneration) return;
                    disconnect();
                    callback.onError(Error.CONNECTION_REJECTED, "连接未完成，请检查密码并在系统提示中允许连接相机");
                }

                @Override public void onLost(Network network) {
                    if (generation != connectionGeneration || !network.equals(available)) return;
                    disconnect();
                    if (delivered) callback.onLost();
                    else callback.onError(Error.CONNECTION_REJECTED, "相机 Wi-Fi 已断开，请重新连接");
                }
            };
            connectionTimeout = () -> {
                if (generation != connectionGeneration || connectedNetwork != null) return;
                disconnect();
                callback.onError(Error.CONNECTION_TIMEOUT, "连接超时，请检查相机 Wi-Fi 和密码后重试");
            };
            handler.postDelayed(connectionTimeout, CONNECTION_TIMEOUT_MS);
            connectivity.requestNetwork(request, networkCallback, handler);
        } catch (SecurityException denied) {
            disconnect();
            callback.onError(Error.PERMISSION_REQUIRED, "连接权限不足，请允许精确位置和附近设备权限");
        } catch (RuntimeException unavailable) {
            disconnect();
            callback.onError(Error.UNAVAILABLE, "当前无法连接相机 Wi-Fi，请稍后重试");
        }
    }

    public void disconnect() {
        requireMainThread();
        connectionGeneration++;
        clearConnectionTimers();
        connectedNetwork = null;
        if (networkCallback != null) {
            try { connectivity.unregisterNetworkCallback(networkCallback); }
            catch (IllegalArgumentException ignored) { }
            networkCallback = null;
        }
    }

    private void clearConnectionTimers() {
        if (connectionTimeout != null) handler.removeCallbacks(connectionTimeout);
        if (gatewayTimeout != null) handler.removeCallbacks(gatewayTimeout);
        connectionTimeout = null;
        gatewayTimeout = null;
    }

    @Override public void close() {
        requireMainThread();
        closed = true;
        cancelScan();
        disconnect();
    }

    /** Passwords are encrypted with an app-scoped Android Keystore AES key, never logged or backed up. */
    public String savedPassword(String ssid) {
        String encoded = passwords.getString(ssid, null);
        if (encoded == null) return "";
        try {
            String[] parts = encoded.split(":", -1);
            if (parts.length != 2) throw new IllegalArgumentException("Invalid ciphertext");
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE, passwordKey(), new GCMParameterSpec(128, Base64.decode(parts[0], Base64.NO_WRAP)));
            cipher.updateAAD(ssid.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            return new String(cipher.doFinal(Base64.decode(parts[1], Base64.NO_WRAP)), java.nio.charset.StandardCharsets.UTF_8);
        } catch (Exception unavailable) {
            forgetPassword(ssid);
            return "";
        }
    }

    public void forgetPassword(String ssid) { passwords.edit().remove(ssid).apply(); }

    private boolean savePassword(String ssid, String password) {
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.ENCRYPT_MODE, passwordKey());
            cipher.updateAAD(ssid.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            byte[] encrypted = cipher.doFinal(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            passwords.edit().putString(ssid, Base64.encodeToString(cipher.getIV(), Base64.NO_WRAP)
                    + ":" + Base64.encodeToString(encrypted, Base64.NO_WRAP)).apply();
            return true;
        } catch (Exception unavailable) { return false; }
    }

    private static SecretKey passwordKey() throws Exception {
        KeyStore store = KeyStore.getInstance("AndroidKeyStore");
        store.load(null);
        SecretKey key = (SecretKey) store.getKey(KEY_ALIAS, null);
        if (key != null) return key;
        KeyGenerator generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
        generator.init(new KeyGenParameterSpec.Builder(KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE).build());
        return generator.generateKey();
    }

    static boolean isCameraSsid(String ssid) { return ssid != null && ssid.startsWith("YDXJ"); }

    static Security security(String capabilities) {
        String caps = capabilities == null ? "" : capabilities.toUpperCase(Locale.ROOT);
        if (caps.contains("WEP") || caps.contains("EAP") || caps.contains("OWE") || caps.contains("WAPI"))
            return Security.UNSUPPORTED;
        if (caps.contains("PSK")) return Security.WPA2;
        if (caps.contains("SAE")) return Security.WPA3;
        if (caps.contains("RSN") || caps.contains("WPA")) return Security.UNSUPPORTED;
        return Security.OPEN;
    }

    static boolean isValidPassword(Security security, String password) {
        if (security == Security.OPEN) return true;
        if (security == Security.UNSUPPORTED || password == null || password.length() < 8 || password.length() > 63)
            return false;
        for (int i = 0; i < password.length(); i++) if (password.charAt(i) < 32 || password.charAt(i) > 126) return false;
        return true;
    }

    static List<CameraWifi> filterScanResults(List<ScanResult> results) {
        List<CameraWifi> candidates = new ArrayList<>();
        if (results != null) for (ScanResult result : results) {
            if (result != null && isCameraSsid(result.SSID))
                candidates.add(new CameraWifi(result.SSID, result.BSSID, result.level, security(result.capabilities)));
        }
        candidates.sort(Comparator.comparingInt((CameraWifi camera) -> camera.signalDbm).reversed()
                .thenComparing(camera -> camera.ssid).thenComparing(camera -> camera.bssid == null ? "" : camera.bssid));
        Map<String, CameraWifi> unique = new LinkedHashMap<>();
        for (CameraWifi camera : candidates) if (!unique.containsKey(camera.ssid)) unique.put(camera.ssid, camera);
        return Collections.unmodifiableList(new ArrayList<>(unique.values()));
    }

    static String cameraHost(LinkProperties properties) {
        String gateway = gateway(properties);
        return gateway == null ? FALLBACK_HOST : gateway;
    }

    private static String gateway(LinkProperties properties) {
        if (properties != null) for (RouteInfo route : properties.getRoutes()) {
            if (route.isDefaultRoute() && route.getGateway() instanceof Inet4Address
                    && !route.getGateway().isAnyLocalAddress()) return route.getGateway().getHostAddress();
        }
        return null;
    }

    private static void requireMainThread() {
        if (Looper.myLooper() != Looper.getMainLooper()) throw new IllegalStateException("Call on the main thread");
    }
}
