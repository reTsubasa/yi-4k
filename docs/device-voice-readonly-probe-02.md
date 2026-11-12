# 真机语音/录制设置只读探针 02

本轮通过普通 7878 API 读取 `app_status` 和 `msg_id=3` 后关闭会话；没有调用 setter、录制、拍照、语音命令、RTC 写入、RTOS shell 或启动脚本。

设备为 `Z16V13L_1.10.7` / `YDXJ2_V13LW`。前后状态均为 `idle`，`voice_keys` 为空；当前读到 `buzzer_ring=off`、`sound_effect=wind`、`sound_effect_support=on`、`mic_level=low`，录制字段包含 `rec_mode=record`、`loop_rec_duration=5 minutes`、`rec_audio_support=on`，`camera_clock=2026-11-12 19:25:24`。

证据：[voice-readonly-probe-02.json](../artifacts/verification/2026-11-12-voice-readonly-probe-02.json)，SHA-256 为 `0da493b126bc10e22bef3adf95536ede8033cab57d7a464ca5e0e391814c5fcf`。

普通设置列表仍不能证明原厂语音识别已启用或具体口令可用；“开始录像”/`start recording` 的真实识别、事件送达和预录绑定仍需现场验收。
