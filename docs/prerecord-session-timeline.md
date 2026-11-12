# 原厂同会话切段：完整 DTS 重基准链

2026-11-11，固定本机保留的 1.10.7 RTOS 镜像，完全离线。新增结果：**完整 `RestoreDTS → ResetMuxMediaInfo → ResetMovie → AdjustDTS → 真实 FIFO Peek → ConvertPTS` 在合成 RAM 中执行通过。正常、无需时间修正的构造输入下，ResetMovie 对音视频使用同一个 DTS 减数，保留调整后的轨间差值，且不推进视频 FIFO 游标或改写队首描述符。**

这将 [旧分段报告](prerecord-session-rollover.md) 中仅执行 reset 后半段、[FIFO 所有权报告](prerecord-fifo-rollover-ownership.md) 中仅有调用图的证据推进到完整时间线调用链。它仍然不是共同采集时钟、真实编码连续性或跨段可播放成片的证明。本轮没有 MP4/index Open/Close、目标运行、设备访问、Android 或 SDK 改动。

## 共同采集 epoch 的证据边界

首个 PCM block 的现有生产链是音频 DMA 完成位和 ring 消费索引，继而通过 source gate 才复制到编码 buffer；该 24-byte DMA descriptor 和 12-byte PCM buffer 项的已有原始指令审计没有留下可与视频 raw DSP PTS 直接相减的采集时间戳，见 [DMA 采集边界](prerecord-capture-epoch.md)。[事件开门新审计](prerecord-gate-epoch.md)又排除了“video event 会重新归零音频编码计数”的解释。

这些是明确链条内的缺边，不能扩大成整个芯片没有共同硬件时钟。公开 v1.10.52 ORC 包中的 video PTS 候选也不能未经镜像及生产链身份核对就提升成本机 1.10.7 的硬件时钟来源。本轮没有取得新的 DMA/传感器同步计数证据，因此转向可验证的同一会话 mux 时间线，避免为两轨猜一个固定起始偏移。

## 本轮执行的真实原厂方式

已有 limit 生命周期先恢复结束标记前保存的 DTS，再进入 event 3 切文件 callback，见 [同步帧边界](prerecord-sync-boundary.md)。主 callback 中的实际顺序进一步固定在原码：

```text
A01F59D8  call A01F68B8        清每轨 sample counters
A01F59F0  store64 0→A13C1758  主文件本次重建前清共享基准
A01F59F4  call A01F3124        ResetMovie(movie)

ResetMovie A01F3124
  → AdjustDTS A01F705C
       → 原 memcpy，备份视频轨道
       → AmpFifo_PeekEntry A0451960，原 FIFO handler，index=0
       → AppLib ConvertPTS A01F6BE8
  → GetShortestTrack A01F69B0
  → 两轨减同一个基准
  → 视频轨额外 ResetPTS A01F721C
```

新测试执行完整 `RestoreDTS(A04404D8)`、计数 reset `A01F68B8` 和 `ResetMovie(A01F3124)`，没有把 Peek 或 ConvertPTS 换成成功桩。输入把各轨当前 DTS 设为结束哨兵、`+0x28` 设为待恢复的边界 DTS；真实 RestoreDTS 先将其恢复，随后走完整 reset 链。输入结构、同步帧描述符和 FIFO 均为合成对象，不是相机观测值。

外部模型沿用现有 FIFO harness：成功 mutex 与诊断返回；原 memcpy wrapper 使用明确构造的 core0 RTOS context，原始拷贝和数学 helper 都实际执行。没有真实锁、调度器、DMA/cache 一致性或存储。在本轮路径中未触发 allocator、queue message 或 callback 模型；唯一负例会到达原厂错误诊断，由诊断桩返回。

## 一个共同减数，保留的是什么差值

设 `AdjustDTS` 完成后的轨道状态为 `V`、`A`，当前最短 DTS 为 `S=min(V,A)`，共享全局为 `G=u64(A13C1758)`。原始 unsigned 比较和带 borrow 的 64-bit 减法给出的行为是：

```text
if G == 0: G = S
B = min(G, S)
video.DTS = V - B
audio.DTS = A - B
```

每轨结果同时写入 `track+0x18/+0x20/+0x28`。这里比较的是共同 mux 比例下的轨道状态，不能将 raw 音频 PTS 与 raw 视频 PTS 填进该公式。

主 callback 每次先清 G，因而主文件正常路径的 B=S。已有 G 不为零时，并非无条件减 G；若 G 大于当前最短 DTS，实际减 S。这个分支也在本轮完整执行中覆盖，不能把全局值本身不加条件地当作每次实际使用的减数。

新执行用例使用显式合成配置 `D=S_video=90000`、视频 period=3000、音频 period=1920，避免把这些值误写成实际相机模式。结果：

| 输入 video/audio DTS | 原共享 G | 实际 B | 输出 video/audio DTS |
|---|---:|---:|---|
| 900000 / 901920 | 0 | 900000 | 0 / 1920 |
| 903000 / 900000 | 0 | 900000 | 3000 / 0 |
| 900000 / 900000 | 0 | 900000 | 0 / 0 |
| 4294968000 / 4294969920 | 0 | 4294968000 | 0 / 1920 |
| 900000 / 901920 | 600000 | 600000 | 300000 / 301920 |
| 900000 / 901920 | 1200000 | 900000 | 0 / 1920 |

这些成功例中，`AdjustDTS` 所消费的下一视频描述符经真实 ConvertPTS 恰好匹配已恢复 DTS，不进入改变帧周期的修正分支。因此证明的是 **ResetMovie 保留 post-AdjustDTS 的差值**；没有证明任意原始输入在 AdjustDTS 前后的差值恒定，或覆盖重排、VFR 修正和非法配置。

当 video DTS 输出为 3000、audio 输出为 0 时，差值仍为 -3000。不能把它们分别重设为 0 后声称维持了原厂时间线。分段 manifest 若将各文件重接到同一会话，应记录本次实际 B、同一配置的 mux 比例、轨间差值，以及累计到该段的会话偏移；本轮没有实现 manifest 或做跨文件重接。

## 真实 Peek 保留首帧，音频 raw PTS 未参与

成功用例中，原 FIFO Peek 恰好执行一次，目标为视频 FIFO。完整 reset 前后，真实 handler 的整个 0xD0-byte 区间、两个游标及 256-byte descriptor ring 均保持；没有用 opaque canary 代替视频 FIFO 逻辑。队首描述符仍为相同 ring 槽、相同原始 PTS。

视频 reset 把 `track+0x50` 设为 rebased video DTS，并清原点 `+0x58`、帧计数 `+0x48`、换算结果 `+0x60` 及初始偏移。接着执行原 `ProcessVideo` 的首原点选择前缀 `A042D378..A042D398`，再执行完整 mux `ConvertPTS(A03E5B5C)`：保留的同一个视频描述符成为新原点，relative converted PTS 为 0，但 video DTS 可以保留正的轨间偏移。**relative PTS=0 不表示两轨首样本都从同一采集时刻开始。**

音频有独立、结构化填入的 handler 和 descriptor ring；访问 hook 确认本 reset 链既不读该音频 handler，也不读其 descriptor。另将音频 descriptor 原始 PTS 从一个人工填入值改为全 1，时间线输出相同。它支持“此重基准消费的是现存轨道 DTS，而不是重新比较两路 raw PTS”的结论；不是音频 FIFO 自身 API 的验证，也不是音频硬件同步证明。

额外的空视频 FIFO 负例执行真实 Peek，导致完整 ResetMovie 返回 `-1`；两轨媒体状态、全局、游标和 ring 均保持，记录两层错误诊断。不能在没有下一视频项时自行补一个零原点，再把它解释成原厂正常开段。

## 交付与仍未知

[审计脚本](../scripts/audit_prerecord_session_timeline.py) 固定 RTOS SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，记录 10 个函数体/伪代码 SHA-256、FIFO harness SHA、11 处精确指令 pin、8 组完整调用链的参数/结果、实际模型调用和错误诊断。

```sh
.venv-reverse/bin/python scripts/audit_prerecord_session_timeline.py
.venv-reverse/bin/python scripts/audit_prerecord_session_timeline.py --output /tmp/yi4k-session-timeline-check
```

结果：[audit.json](../artifacts/device/2026-11-11-prerecord-session-timeline/audit.json)、[原始 ASM](../artifacts/device/2026-11-11-prerecord-session-timeline/audit.asm)。`--output` 也可指定 JSON 文件，ASM 使用相同 stem。没有新 REA Evidence ID。

主线程[独立复跑](../artifacts/verification/2026-11-11-session-timeline-independent-run01/audit.json)的8例与11处指令核对通过；保留独立输出目录，不替代原始结果。

可继续采用的方向是：保持同一录制会话，沿原厂 mux limit 路径在同步候选前排空并切文件，保留共同 DTS 重基准和每段偏移。它避免重新猜测每段两轨的独立起点，但还缺真实生产者连续性、payload 稳定期、首段参数集/AAC 配置、Open/Close 完整合同、满卡/掉电处理和实际跨段音画连续验证。当前不能宣称相机一分钟预录或硬件 A/V epoch 已实现。
