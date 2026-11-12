# 2026-11-11 拍照真机探针 02

本轮通过 Android `liveCameraProbe` 执行一次不改配置的真实拍照。探针复用了产品配置路径 `CameraConfiguration.selectMode()`：YI 4K 1.10.7 对 `system_mode=capture` 的父字段写入只返回确认但不切换，实际必须写 `capture_mode` 子字段；结束后通过 `rec_mode` 子字段恢复录像模式。

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`
- 硬件：`YDXJ2_V13LW`
- 拍照前状态：`idle`
- 拍照后状态：`vf`
- 拍照请求：`msg_id=16777220`，`rval=0`
- 新增媒体：`YDXJ0162.JPG`，2,490,584 bytes
- JPEG SHA-256：`d95b4360c33853313b2b718a1e1a4e5a31e63109ea0b7075b958df801ff801b2`
- JPEG：Exif baseline，4000×3000，XIAOYI/YDXJ 2
- 媒体条目：46 → 47
- 前后选定设置：一致
- 模式恢复：`capture → record`，通过 `CameraConfiguration.selectMode`
- 通知包含：`switch_to_cap_mode`、`start_photo_capture`、`photo_taken`、`switch_to_rec_mode`

原始会话：[session.json](../artifacts/device/2026-11-11-photo-probe-02/session.json)。原片：[YDXJ0162.JPG](../artifacts/device/2026-11-11-photo-probe-02/session-media/YDXJ0162.JPG)。

本轮补强了真实拍照、模式切换、媒体列表和原片导出证据；仍不代表预录或 EIS 替换已实现。
