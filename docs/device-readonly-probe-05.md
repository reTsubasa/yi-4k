# YI 4K 只读设备复核 05

本轮通过现有 Android `liveCameraProbe` 对 `192.168.42.1` 做只读复核。参数为 `recordSeconds=0`、`capturePhoto=false`、`changeSetting=false`、`syncClock=false`，没有录像、拍照、设置写入或 RTC 写入。

回执：[2026-11-12-readonly-probe-05.json](../artifacts/verification/2026-11-12-readonly-probe-05.json)，SHA-256 为 `b448b390db85d17d111dda7fec3c26c595cd6bec4b934152ac2edd0fea2710fd`。

结果：相机固件为 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`，SD 卡已插入，电量回报 100%，`iq_eis_enable=on`；前后 `app_status` 均为 `vf`，关键设置前后一致，媒体列表没有新增条目。该回执证明当前相机可达和只读状态稳定，不能证明 EIS 替换、预录或语音/快门绑定已经执行。
