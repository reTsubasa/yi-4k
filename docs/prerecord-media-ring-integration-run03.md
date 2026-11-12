# 预录触发、ring 与封装恢复统一回执（run03）

2026-11-12 在主机离线环境复跑了 [`validate_prerecord_media_ring.py`](../scripts/validate_prerecord_media_ring.py)。它把 typed camera voice `START_RECORDING`、物理快门 `press`、60 秒历史窗口、闭合段 custody、发布 gate 和 MP4 恢复放进同一条验证链；不执行语音识别、不访问相机或实体 SD。

回执：[`validation.json`](../artifacts/verification/2026-11-12-prerecord-media-ring-run03/validation.json)，状态为 `pass_archived_media_incremental_ring_publication_and_recovery`，3 个 case，`device_access=false`。

- 语音 START 在发布阶段注入中断后，保留闭合段和 manifest；独立恢复只从 retained custody 重建，并通过完整解码与 packet fidelity gate。恢复 MP4 SHA-256 为 `9b9cac86840a00e9781ce9a2428eb4ac91f4474c6d93feebd1b02d4b48ed505c`。
- 对 retained segment 内容做篡改时，恢复在 remux 前拒绝，原始失败 custody 保持不变。
- 快门触发完成同样的 60 秒窗口和发布 gate；其最终 MP4 与语音恢复片段逐字节 SHA 一致，证明两种 typed START 走同一封装输入。

复跑命令：

```sh
python3 scripts/validate_prerecord_media_ring.py \
  --output artifacts/verification/2026-11-12-prerecord-media-ring-run03
```

这份回执只证明主机文件级语义、失败保留和恢复路径。相机端语音识别、快门 GPIO/固件事件传输、实时编码器/FIFO、实体 SD 吞吐与掉电耐久性仍需单独批准后的真机验收。
