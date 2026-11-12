# 真机只读 readiness 复核 03

本轮仅通过现有 Telnet 和 7878 API 读取 Linux/节点信息与相机状态，没有上传脚本、执行 RTOS 命令、重启、录像、拍照、设置写入或 RTC 写入。

设备仍为 `YDXJ2_V13LW` / `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。API 前后均为 `idle`，视频模式为 `record`，SD 为 `insert`，`iq_eis_enable=on`，设置快照完全一致；共 12 项 Linux/节点检查完成。

证据目录：[readiness-probe-03](../artifacts/verification/2026-11-12-readiness-probe-03/)，其中 `session.json` 保存 API 前后状态和事件，`boot_id.txt`、`uptime_*`、节点、挂载和进程文件保存只读快照。

这次复核只证明设备当前可达且基线稳定，不能证明 EIS 自定义入口、算法替换、实时预录或语音/快门绑定已经执行。
