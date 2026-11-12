package dev.yi4k.control;

/** Only confirmed quiescent camera states allow a new capture or configuration. */
public final class CameraState {
    private CameraState() { }
    public static boolean isReady(String status) { return "idle".equals(status) || "vf".equals(status); }

    /** A capture acknowledgement can precede the real state transition. Never resends it. */
    public static String awaitCaptureState(CameraClient camera, int request) throws Exception {
        return awaitCaptureState(camera, request, 20_000);
    }
    static String awaitCaptureState(CameraClient camera, int request, long timeoutMillis) throws Exception {
        if (request != 513 && request != 514 && request != 16777220)
            throw new IllegalArgumentException("不支持的拍摄操作");
        long deadline = System.nanoTime() + timeoutMillis * 1_000_000L;
        do {
            String status = camera.call(1, CameraClient.args("type", "app_status")).getString("param");
            if (request == 513 ? "record".equals(status) : isReady(status)) return status;
            if (System.nanoTime() >= deadline)
                throw new java.io.IOException("相机拍摄状态尚未确认，请刷新核对实际状态；操作未重发");
            Thread.sleep(100);
        } while (true);
    }
}
