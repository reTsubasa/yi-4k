# 真机 RTSP 只读复核 03

通过已有 `device_rtsp_decode_probe.py` 从相机读取一帧真实 RTSP 取景并用 FFmpeg 解码。探针只在 `idle` 与 `vf` 间成对调用原厂 `START_VF/STOP_VF`，没有录像、拍照、设置、SD、固件或 RAM 写入。

回执：[session.json](../artifacts/verification/2026-11-12-rtsp-readonly-run03/session.json)，SHA-256 为 `a47fc2f3e7576ba9a79f8388e84e97edc771eebb23a369cd7c9f32b11b6480c2`。

结果：真实 H.264 取景流为 `848x480`、`24000/1001` fps、`1/90000` 时基；读取 73 个包并成功解码首帧。停止后 `app_status=idle`，前后设置完全一致，探针报告 `status_restored=true`、`settings_equal=true`。这建立了真实 EIS 开启取景基线，但没有证明 EIS 算法替换或编码后画质改善。
