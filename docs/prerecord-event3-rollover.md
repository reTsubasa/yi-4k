# 原厂 event 3 切段：完整回调离线执行

本轮在固定 1.10.7 ARM 镜像的合成 RAM 中运行完整 `OnMovieEvent → OnPipeLimit → event 3` 链，再由真实 event 3 回调执行 `Close(0) → NewMovieInfo → CopyMovieInfo → RelMovieInfo → reset counts → ResetMovie → Open`。旧段的同步视频描述符在回调前后保持逐字节相同，之后被写为新段第一帧；两段各 8 个源视频帧完整解码且与归档原片对应帧相同。

这仍不能发布预录功能：正常关闭确实丢掉跨段 AAC 12/25，第二段消费者时间线仍有精确 `-1/240000s` 偏差。一次模拟文件短写会进入原厂断言，证明该回调不能直接作为失败可恢复的设备后端。

## 复现与身份

```sh
.venv-reverse/bin/python scripts/audit_prerecord_event3_rollover.py \
  --output /tmp/yi4k-event3-normal
.venv-reverse/bin/python scripts/audit_prerecord_event3_rollover.py \
  --output /tmp/yi4k-event3-close-failure --fail-old-close
```

- [脚本](../scripts/audit_prerecord_event3_rollover.py)，冻结 SHA-256 `9679be4f7017200c1247b5a8913ff267cebc33a1b20b006c0722195e9530b570`。
- [正常路径报告](../artifacts/device/2026-11-11-prerecord-event3-run02/audit.json)，同时保留两段 MP4。
- [短写失败报告](../artifacts/device/2026-11-11-prerecord-event3-close-failure-run02/audit.json)。
- 主线程[正常独立复跑](../artifacts/verification/2026-11-11-prerecord-event3-independent-run02/audit.json)与[短写独立复跑](../artifacts/verification/2026-11-11-prerecord-event3-close-failure-independent-run02/audit.json)的全部 JSON 分别与上述最终报告相同，脚本 SHA-256 与冻结版本一致；输出视频摘要再次核对通过。
- 固件 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，每个关键入口 ARM body hash 与原厂调用约定指令保存在报告中。
- 输入为旧普通录像 `YDXJ0161.MP4`，SHA-256 `862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d`；不是本轮相机采集或原始编码 FIFO。

## 实际执行范围

构造时限为 200ms，真实归档同步视频帧 #8 位于 `8008/30000s`，因此超过时限后由原始 `ProcessVideo` 返回 3，且没有写入或移除它。不是将 60 秒失败改成成功，也没有改写返回值。

`AmpMuxer_Process(A043D1C0)` 的五条原始指令确认：处理返回值先保留到 `sl`，再将其放入 `r2`，以 `r0=pipe,r1=format` 调用 `OnMovieEvent(A0443720)`。本轮按该约定传 3。**入口前的 track/FIFO 状态是手动提交包形成的，完整 `IsoMux_Process` 与 mux task 调度未运行。** 只有一个构造 format，未启用次码流。

此次完整执行包含：

1. `OnMovieEvent(A0443720)`、`OnPipeLimit(A0442674)`、`RestoreDTS(A04404D8)`、`ProcessOthersToLimit(A0441FE0)` 和 `SetLimit(A0441D60)`；单 format 无其它 format 待排空。
2. event 3 回调 `A01F569C` 的正常普通模式路径，不是直接从中段跳入，不走 loop 删除。
3. 原始 `AmpMp4Mux_Close(...,0)` 和原始索引/MOOV 封装；双槽原厂 movie factory 在 `0x10000000` 与 `0x10000708` 之间切换，原始 Copy/Rel/Reset/Open 均实际执行。
4. callback 后 FIFO、descriptor 与之前完全相同；随后原始 sample writer 消耗同一个同步描述符，使 read cursor 从 0 变成 1。

明确的外部模型为 RAM 文件 open/close、唯一文件命名、单码流查询、可选 userdata 省略、App 消息、诊断格式化，以及继承的 OS 锁、分配器、RTC、RAM stream。没有运行原厂 CFS、真实 SD 或设备 GUI。保存所有外部事件及顺序，避免把替身服务误称原厂执行。

## 成片与时间线仍拒绝

| 项目 | 第一段 | 第二段 |
| --- | --- | --- |
| 送入 writer 的源视频 | 0–7 | 8–15 |
| 最终可导出视频 | 0–7 | 8–15 |
| 送入 writer 的源 AAC | 0–12 | 13–25 |
| 最终可导出 AAC | 0–11 | 13–24 |
| 视频帧解码与源对照 | 相同 | 相同 |
| 保留包 SHA-256 | 相同 | 相同 |
| 严格包/时间线门禁 | reject：缺 AAC12 | reject：缺 AAC25，时间线不精确 |

原始 ResetMovie 将 `[64064,66560]/240000s` 共同重基准为 `[0,2496]/240000s`，保留了第二轨 10.4ms 的差值。第二段容器 ELST empty edit 为 `312/30000s`，但 ffprobe 的 AAC 首 PTS 为 `499/48000s`，比精确原值少 `1/240000s`；本轮不放宽有理数比较容差。现有结果支持同步视频帧保留与同一 callback 中的对象生命周期，不支持无损 AAC 交接、跨文件音画连续或一分钟历史已经完整持久保存。

## 失败注入与下一步

`--fail-old-close` 在旧段 Close0 第一次 RAM 文件写入返回少 1 byte，原始 MOOV 写尾传播 `-12`，callback 到 `A01F5B24` 调用断言 helper。Unicorn 在该 helper 抛出并停止，不执行后面的关中断/永久循环。此时旧 movie 仍挂在 format 上，文件流未关闭，也没有命名或申请新 movie；没有声称该部分文件可恢复。

下一步需要自有安全调度/错误包装：在交付片段前验证包完整性与时间线；跨界 AAC 应留在自有 payload 队列，直到最终封装承担其归属；Close 或新文件 Open 失败必须停止消费并保存可恢复材料，不能沿用原厂 assert。实时 callback、双轨独立 FIFO、硬件 payload 稳定期、分钟吞吐、真实 SD 故障及相机语音/实体快门绑定仍未实现。

全程离线，没有连接相机、执行 RTOS 真机代码、安装 hook 或写入设备。
