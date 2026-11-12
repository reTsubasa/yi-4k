# 一分钟分段会话的宿主恢复与独立校验

本项将按 AAC 包结束点分配的两段原厂 MP4 恢复为一份连续时间线文件。重建 payload 和 codec 配置仅来自两段原厂输出；归档原片在候选文件写入后才用于独立门禁与解码比较。它是宿主 ISO 容器重建，不是原厂 mux 已直接输出消费者兼容连续文件，也不是实机预录完成。

实现为 `scripts/recover_prerecord_minute_session.py`，复用已审计的 `recover_prerecord_custody.py` ISO 重建器。独立校验器为 `scripts/verify_prerecord_minute_session_recovery.py`；它不运行恢复或生成媒体，只读取已经产生的实际正负例文件。

## 数据与时间线合同

输入是 `artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01` 中两个 `native-segment-*.mp4`，原厂模式为 event3 + Close0。第一段含视频 0–1799 / AAC 0–2814；第二段含视频 1800–1919 / AAC 2815–3002。跨界 AAC 2815 留给下一段，所有 1920 个视频包和 3003 个 AAC 包完整且各一次。

恢复读取 MP4 时忽略消费者 edit-list 裁剪，但不丢弃原始时间信息。每段源 epoch 加原始空编辑延迟及本地 PTS，必须精确等于连续轨道的期望时间，才接受样本。第二段源 epoch 是 4504/75 秒，首视频再延后 1/150 秒；因此 AAC 和视频都接回各自的连续源时间，不按文件 duration 拼接。

重建只支持已固定的零原点、无 B 帧的 29.97fps H.264 I/P 和 48kHz stereo AAC：video delta=1001/30000 秒、audio delta=1024/48000 秒。保留原始 sample entry 与所有压缩样本；重建 STTS/STSC/STSZ/STCO/STSS 等样本表并去掉失效的分段 edit list，不重编码。恢复窗口是 `1920×1001/30000=64.064` 秒，其中 60.06 秒触发换段，随后还有 4.004 秒视频。64.064 秒是视频和 AAC 的共同精确端点；本项没有验证恰好 60.000 秒的任意触发预录窗口。

## 独立验收要求

独立校验器检查：

1. 执行恢复脚本、ISO 重建器和全部输入 SHA 与运行报告一致。
2. 从实际 native 文件导出的每轨包 SHA 顺序，与恢复输出一致，再与归档原片选定窗口独立比较。
3. 正例必须有 `session.mp4`、没有 pending，包数精确为 1920 / 3003；逐包 SHA、PTS、DTS 和 duration 必须全通过，不能只看解码。
4. 读取实际样本表，要求无 EDTS/ELST/CTTS，STTS 精确是 1920×1001 与 3003×1024；codec 配置保持原样。
5. FFmpeg `-xerror` 全片解码、1920 个源帧 MD5 和连续完整 AAC PCM 必须精确匹配；PCM 长度应为 12300288 字节。
6. 缺失 AAC2815 的负例只能保留 `session.pending.mp4`，不得发布 `session.mp4`；实际 AAC 数应为 3002，逐包身份必须恰好等于原序列删除该边界包。

源 epoch 来自归档调用者映射，不能被 MP4 自身认证。即使这些宿主验收通过，仍不证明真实编码器/FIFO lookahead 所有权、回调安装、并发调度、一分钟活体历史保留、SD 持久化或错误恢复。

## 复现独立检查

先完成正例恢复以及 `--drop-boundary-aac` 负例，再运行：

```sh
.venv-reverse/bin/python scripts/verify_prerecord_minute_session_recovery.py \
  --positive artifacts/verification/2026-11-11-prerecord-minute-session-recovery-run01 \
  --negative artifacts/verification/2026-11-11-prerecord-minute-session-recovery-drop-run01 \
  --output artifacts/verification/2026-11-11-prerecord-minute-session-recovery-review.json
```

此文档的验收要求不替代实际输出报告；执行结果另记录于独立 review JSON。

## 正例独立实测

`artifacts/verification/2026-11-11-prerecord-minute-session-recovery-run01/independent-review.json` 已完成实际文件复核：1920 个视频包与 3003 个 AAC 包的 native 输入来源、归档原片 SHA、PTS、DTS、duration 全部精确通过；1920 个视频帧 MD5、12300288 字节连续音频 PCM 和 FFmpeg `-xerror` 全片解码通过。实际输出没有 EDTS/ELST/CTTS，STTS 为要求的两组恒定时长。

恢复文件 SHA256 为 `25e6c7a429d7cda35e329aa1c77376dc99dd9ff4f89884b5366f52e9bb2f3c28`，PCM SHA256 为 `fd7def7d1214705f61861e6120fccc28df28fbb490d1b636575438ae9dc54523`。独立 review 同时保存恢复脚本、ISO 重建器、校验器及实际输入/输出摘要。

校验器可用 `--positive` 和 `--negative` 分别执行，review 内的 `positive_reviewed` / `negative_reviewed` 明确说明实际覆盖，避免把单个正例报告误认为负例也通过。

## 缺包负例独立实测

`artifacts/verification/2026-11-11-prerecord-minute-session-recovery-drop-run01/independent-review.json` 已通过发布拒绝验证。负例实际导出视频 1920 包、AAC 3002 包；逐项 SHA 顺序恰好是原始完整输入删除 AAC2815，其余包保持原序及原字节。该缺失包 SHA256 为 `ef96aaeaa91e39baf9abaf7a6edcf1b129482b5522cfb130d86b83413bf4ba5a`。

恢复报告状态为 `rejected_retained_for_recovery`，严格门禁因包数不符而拒绝；实际文件系统只保留 `session.pending.mp4`，没有 `session.mp4`。校验器重新读取 pending 文件验证了上述缺失位置、包数、codec 配置、输入摘要与样本表，并核对 pending SHA 与运行报告一致。因原始 AAC 已缺失，该负例没有被要求或宣称解码后与完整源 PCM 相同。

因此本轮同时建立了完整归档会话的宿主恢复通过证据，以及缺失一个边界 AAC 时拒绝发布的独立证据；该结果没有改变实机预录与原厂分段消费者门禁的既有限制。
