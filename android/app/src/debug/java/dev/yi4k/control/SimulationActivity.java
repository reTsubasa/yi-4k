package dev.yi4k.control;

/** Debug APK only: loopback transport for instrumentation, never a camera network. */
public final class SimulationActivity extends MainActivity {
    @Override protected javax.net.SocketFactory cameraSocketFactory(String host) throws Exception {
        if (!"127.0.0.1".equals(host)) throw new java.io.IOException("模拟验收仅允许本机回环地址");
        return javax.net.SocketFactory.getDefault();
    }
    @Override protected int cameraApiPort() { return getIntent().getIntExtra("simulation_api_port", 7878); }
    @Override protected int cameraHttpPort() { return getIntent().getIntExtra("simulation_http_port", 80); }
}
