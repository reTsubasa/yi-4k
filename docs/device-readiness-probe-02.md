# 真机 Linux/API readiness 只读复核 02

本轮执行 `device_readiness_baseline.py`，只读取 Linux `/proc`、设备节点、挂载、RPMsg 列表和普通 API 状态。脚本没有执行 RTOS shell、内存映射、文件上传、重启、录像、拍照或设置修改。

回执：[session.json](../artifacts/verification/2026-11-12-readiness-probe-02/session.json)，SHA-256 为 `62d17700aa0b52d9d9cec2ba98b1ba554ce29461f94ae2d66b89b0d1a914096f`。

结果：前后 `app_status=idle`，固件仍为 `Z16V13L_1.10.7`，SD 为 `insert`，`iq_eis_enable=on`，12 项 Linux/节点检查完成且设置一致。该复核确认只读通道和恢复状态稳定；Linux `ps` 不等于 RTOS 任务表，因此不能据此确认 `VoiceCmd_Task` 当前识别或语音开关状态。
