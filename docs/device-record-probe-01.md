# 2026-11-11 普通录像真机探针 01

通过 Android `liveCameraProbe` 对当前相机执行一次 3 秒普通录像：不改配置、不拍照，探针负责停止自己发起的录像并记录状态。原始会话和导出的 MP4 保存在 [record-probe-01](../artifacts/device/2026-11-11-record-probe-01/)。

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`
- 硬件：`YDXJ2_V13LW`
- 录像前状态：`idle`
- 录像中状态：`record`
- 停止后状态：`vf`
- `record_start` / `record_stop`：均返回 `rval=0`
- 新增媒体：`YDXJ0161.MP4`，22,743,256 bytes；另有对应 `.SEC`
- 导出 MP4 SHA-256：`862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d`
- 容器时长：2.7027 秒
- 视频：H.264，81 包，30,000 Hz 时基，首包 IDR，PTS/DTS 单调
- 音频：AAC，126 包，48,000 Hz 时基，PTS/DTS 单调
- 完整 H.264/AAC 解码：通过
- 选定设置前后保持一致：通过

原始会话：[session.json](../artifacts/device/2026-11-11-record-probe-01/session.json)。封装/逐包审计：[packet-audit.json](../artifacts/device/2026-11-11-record-probe-01/packet-audit.json)。

该证据证明普通录像、停止、媒体新增和原片导出链路在当前相机上可工作；它不证明一分钟预录、相机语音绑定或 EIS 算法替换已经实现。
