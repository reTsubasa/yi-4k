# 2026-11-10 RTSP 只读取景流复核

本次只使用相机正常的 API 会话和 RTSP 取景流，不录像、不拍照、不改设置，不写入固件、分区或 RAM。相机初始为 `idle`；探针调用 `259` 进入 VF，宿主使用 TCP interleaved 接收实际流，随后在 `finally` 中调用 `260`，恢复到 `idle`。

证据保存在 [运行记录](../artifacts/device/2026-11-10-rtsp-readonly-run02/session.json)、[原始包信息](../artifacts/device/2026-11-10-rtsp-readonly-run02/stream-packets.json) 和 [PTS 摘要](../artifacts/device/2026-11-10-rtsp-readonly-run02/packet-timing-summary.json)。本轮收到 91 个 H.264 包，解码出 848×480 首帧；视频 time base 为 `1/90000`、帧率为 `30000/1001`，观测到 3003 tick 的 PTS/DTS 间隔。输出中没有音频流，设置前后一致，状态恢复成功。

这只证明当前取景链能提供实际 H.264 视频及时基。取景流不包含录制时的 AAC、编码 FIFO descriptor、payload 所有权或录制共同采集 epoch，因此不能作为一分钟预录已经实现的证据。
