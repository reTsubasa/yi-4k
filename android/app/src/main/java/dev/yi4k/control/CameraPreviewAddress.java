package dev.yi4k.control;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

/** Validates the RTSP field advertised by the camera's session response, without DNS or I/O. */
public final class CameraPreviewAddress {
    private CameraPreviewAddress() {}

    /** No stream path or address is invented when the camera does not advertise one. */
    public static String validate(String cameraHost, String advertised) throws IOException {
        if (!isLiteralIpv4(cameraHost)) throw new IOException("相机地址必须是完整的 IPv4 地址");
        URI uri = parse(advertised);
        if (!"rtsp".equalsIgnoreCase(uri.getScheme()) || uri.isOpaque())
            throw new IOException("相机未提供可用的实时画面地址");
        String host = uri.getHost();
        if (!isLiteralIpv4(host) || !cameraHost.equals(host))
            throw new IOException("实时画面地址与当前相机不一致");
        if (uri.getRawUserInfo() != null || uri.getRawQuery() != null || uri.getRawFragment() != null)
            throw new IOException("相机实时画面地址包含不支持的附加信息");

        String authority = uri.getRawAuthority();
        if (authority == null || !authority.startsWith(host))
            throw new IOException("相机实时画面地址无效");
        String suffix = authority.substring(host.length());
        if (!suffix.isEmpty()) {
            if (suffix.charAt(0) != ':' || suffix.length() == 1)
                throw new IOException("相机实时画面端口无效");
            for (int index = 1; index < suffix.length(); index++)
                if (suffix.charAt(index) < '0' || suffix.charAt(index) > '9')
                    throw new IOException("相机实时画面端口无效");
            if (uri.getPort() < 1 || uri.getPort() > 65535)
                throw new IOException("相机实时画面端口无效");
        }
        String path = uri.getPath();
        if (path == null || !path.startsWith("/") || path.indexOf('\\') >= 0)
            throw new IOException("相机未提供实时画面路径");
        for (int index = 0; index < path.length(); index++)
            if (Character.isISOControl(path.charAt(index)))
                throw new IOException("相机实时画面路径无效");
        for (String segment : path.split("/", -1))
            if (".".equals(segment) || "..".equals(segment))
                throw new IOException("相机实时画面路径无效");
        return uri.toASCIIString();
    }

    /** Playback still rechecks structure; callers must first validate against their camera host. */
    static String validateForPlayback(String advertised) throws IOException {
        URI uri = parse(advertised);
        return validate(uri.getHost(), advertised);
    }

    private static URI parse(String advertised) throws IOException {
        if (advertised == null || advertised.isEmpty())
            throw new IOException("相机没有提供实时画面地址，请重新连接后重试");
        try {
            return new URI(advertised);
        } catch (URISyntaxException failure) {
            throw new IOException("相机实时画面地址无效", failure);
        }
    }

    private static boolean isLiteralIpv4(String host) {
        if (host == null) return false;
        String[] parts = host.split("\\.", -1);
        if (parts.length != 4) return false;
        for (String part : parts) {
            if (part.isEmpty() || part.length() > 3 || (part.length() > 1 && part.charAt(0) == '0')) return false;
            int value = 0;
            for (int index = 0; index < part.length(); index++) {
                char digit = part.charAt(index);
                if (digit < '0' || digit > '9') return false;
                value = value * 10 + digit - '0';
            }
            if (value > 255) return false;
        }
        return true;
    }
}
