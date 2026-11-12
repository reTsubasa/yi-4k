# 2026-11-11 配置修改真机探针 01

本轮执行一次可恢复配置修改：将相机 `video_quality` 从 `S.Fine` 临时切换为相机通过 msg_id=9 声明的 `Fine`，读回确认后恢复 `S.Fine`。没有拍照或录像。

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`
- 原值：`S.Fine`
- 临时请求值：`Fine`
- 临时读回：`Fine`，`rval=0`
- 恢复请求：`S.Fine`，`rval=0`
- 恢复读回：`S.Fine`
- 前后状态：`idle` / `idle`
- 媒体列表：47 / 47（路径和长度逐项一致）
- 前后选定设置：一致
- 电量：100%

原始会话：[session.json](../artifacts/device/2026-11-11-config-probe-01/session.json)。

本次通过宿主运行 Android 协议客户端，确认了配置写入、读回及正常恢复原值；未注入失败，也未运行实体手机 UI。媒体列表保持一致。探针只使用相机公开设置 API，没有调用隐藏 setter，也没有写入固件、RAM、分区或启动区。
