# 普通录像封装时序基线

2026-11-10，在真实 YI 4K 1.10.7 相机上通过原厂 `513/514` API 完成一次约 5 秒的普通录像。相机生成 `YDXJ0160.MP4`，下载后只在主机上审计；本次没有执行预录逻辑，也没有修改固件、分区或 RAM。

证据：

- [相机录像会话](../artifacts/device/2026-11-10-normal-recording-05/session.json)
- [原片](../artifacts/device/2026-11-10-normal-recording-05/YDXJ0160.MP4)
- [逐包审计](../artifacts/device/2026-11-10-normal-recording-05/audit/packet-audit.json)
- [轨道时序摘要](../artifacts/device/2026-11-10-normal-recording-05/audit/media-timing.json)
- [审计后相机状态确认](../artifacts/device/2026-11-10-normal-recording-05/post-cleanup.json)

实际文件为 37,740,507 bytes，SHA-256 为 `7f2c1834ee24951da429eefe920ff15c41ee4de08b3173420b2dd38a264977fa`，容器时长约 4.671333 秒。视频轨为 1920×1080 H.264，140 个包，时间基 `1/30000`，每包 1001 tick，首包带 keyframe/NAL5；SPS/PPS 位于 AVC extradata。音频轨为 48 kHz、双声道 AAC，218 个包，每包 1024 samples，AudioSpecificConfig 存在。两轨首 PTS 都为 0，DTS 严格递增，完整 H.264/AAC 解码通过；视频比音频容器尾部多约 20.667 ms。

该文件的 H.264 payload 中没有 NAL7/NAL8，参数集由 MP4 AVC extradata 提供。这说明普通录制的封装器可以生成可播放的独立 MP4，但不能证明预录分段时 FIFO payload 会在每个新文件以 NAL7/NAL8/NAL5 顺序交付。两轨都从 PTS 0 开始也不能证明硬件采集共用同一物理 epoch。

仍未闭合的预录边界包括 RTOS FIFO descriptor/cursor、payload 所有权、close/open rollover、AAC 生产者重启、掉电恢复，以及相机语音和实体快门事件绑定。因此本报告是普通录像封装基线，不是固定一分钟预录完成证据。
