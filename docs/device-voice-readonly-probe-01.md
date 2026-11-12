# 真机语音/录制设置只读探针 01

本轮通过普通 7878 API 读取 `app_status` 和 `msg_id=3`，随后正常关闭会话；没有调用 setter、录制、拍照、语音命令、RTC 写入、RTOS shell 或启动脚本。

设备仍为 `Z16V13L_1.10.7` / `YDXJ2_V13LW`。前后 `app_status` 都是 `idle`，状态未变化。

证据：[voice-readonly-probe-01.json](../artifacts/verification/2026-11-12-voice-readonly-probe-01.json)。当前设置回包没有 `voice_*`、`speech_*`、`keyword_*` 或 `wakeup_*` 字段；声音相关字段为 `buzzer_ring=off`、`sound_effect=wind`、`sound_effect_support=on`、`mic_level=low`。录制字段为 `rec_mode=record`、`loop_rec_duration=5 minutes`、`rec_audio_support=on`。`camera_clock` 可读为 `2026-11-12 18:54:02`，本轮没有写入。

这说明语音识别启用状态和具体口令不能通过当前普通设置列表证明；仍需相机现场准确识别“开始录像”/`start recording`，并验证事件是否进入预录状态机。`sound_effect=wind` 也只是一项当前设置读回，未被本轮修改。
