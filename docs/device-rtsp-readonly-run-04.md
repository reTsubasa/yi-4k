# 真机 RTSP 只读取景复核 04

本轮从相机公布的 `rtsp://192.168.42.1/live` 读取有限视频包，在主机解码一帧后停止取景并核对状态。没有录像、拍照、设置写入、RTC 写入或固件/RAM/分区写入。

结果：收到 73 个包，视频为 H.264、848×480、`1/90000` 时间基、`24000/1001` 帧率；首帧 PNG 为 321178 bytes，SHA-256 为 `3b54619e798190f347499a3b0d1e49a148623bed1612068b9ce1f82da16120ab`。结束后 `app_status` 恢复为 `idle`，设置快照保持一致。

证据目录：[rtsp-readonly-run04](../artifacts/verification/2026-11-12-rtsp-readonly-run04/)，`session.json` SHA-256 为 `d2da3a699ce4437c70d802d12f1bc34535bbb6b99267d242d5d812e95d11af90`。

该结果证明真实取景链路可读和可恢复，不等同于实体 Android 手机的横屏、刘海、触感或飞入动画验收。
