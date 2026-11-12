package dev.yi4k.control;

import java.io.EOFException;
import java.io.IOException;
import java.io.Reader;

/** Camera TCP replies are concatenated JSON objects, not lines or TCP packets. */
public final class JsonObjectStream {
    private final Reader reader;
    private final int limit;
    public JsonObjectStream(Reader reader, int limit) { this.reader = reader; this.limit = limit; }
    public String next() throws IOException {
        StringBuilder result = new StringBuilder();
        int depth = 0;
        boolean quoted = false, escaped = false;
        for (;;) {
            int value = reader.read();
            if (value < 0) throw new EOFException("相机断开连接，响应未完成");
            char c = (char) value;
            if (result.length() == 0) {
                if (Character.isWhitespace(c)) continue;
                if (c != '{') throw new IOException("无效的相机 JSON 响应");
            }
            result.append(c);
            if (result.length() > limit) throw new IOException("相机响应超过大小限制");
            if (quoted) {
                if (escaped) escaped = false;
                else if (c == '\\') escaped = true;
                else if (c == '"') quoted = false;
            } else if (c == '"') quoted = true;
            else if (c == '{' || c == '[') depth++;
            else if (c == '}' || c == ']') {
                if (--depth == 0) return result.toString();
            }
        }
    }
}
