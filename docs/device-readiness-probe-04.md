# 真机只读 readiness 复核 04

2026-11-12，本轮通过普通 7878 API 和 Telnet 只读取设备状态与 Linux 节点；没有上传脚本、执行 RTOS 命令、重启、录像、拍照、设置写入、RTC 写入或固件/RAM/分区写入。

设备为 `YDXJ2_V13LW` / `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。前后 `app_status=idle`，`iq_eis_enable=on`，SD 为 `insert`，视频规格为 `1920x1080 24P 16:9`，12 项 Linux/节点检查均完成，boot ID 为 `a96eb3f9-9fc5-4adb-b062-a2fe8ebb53c2`。

证据目录：[readiness-probe-04](../artifacts/verification/2026-11-12-readiness-probe-04/)，`session.json` SHA-256 为 `530d1c647d1087f55dfb597ce31638b68335fec4a5e5f0efc92649b6aa89a329`。

该回执只证明相机只读基线稳定，不能证明 EIS 自定义入口、算法替换、实时预录或语音/快门触发已经执行。
