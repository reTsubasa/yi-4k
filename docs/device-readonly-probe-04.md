# 2026-11-11 相机只读探针 04

本轮通过 Android `liveCameraProbe` 运行显式只读探针：`recordSeconds=0`、不拍照、不改配置。相机热点 `192.168.42.1` 的 TCP 80 和 7878 均可达。

原始会话：[session.json](../artifacts/device/2026-11-11-readonly-probe-04/session.json)。

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`
- 硬件：`YDXJ2_V13LW`
- 操作前后状态：`idle` / `idle`
- 操作前后媒体条目：44 / 44
- 关键设置：1920×1080 30P、S.Fine、EIS on、SD 已插入、system_mode=record
- 操作前后选定设置：一致
- 电量：100%
- 新媒体导出：0
- 通知：0
- session SHA-256：`e04a90238a292f8a53248622ac0b0443f0beec3c86595fb573f3d3d7c7588666`

本轮没有录像、拍照、配置修改、隐藏 setter、固件/RAM/分区写入或 RTOS 自定义执行。该结果只证明当前只读 API 会话和状态保持，不证明预录或 EIS 替换已实现。
