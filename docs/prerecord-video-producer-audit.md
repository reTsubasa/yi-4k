# 1.10.7 视频 DSP 描述符、回绕修正与 FIFO PTS

2026-11-10。复用现有 Ghidra 导出，以固定 RTOS 镜像执行原始 ARM 指令窗口，新增 19 个离线用例通过。没有连接相机、写入设备、执行 RTOS 或替换指令。当前仍未实现相机端一分钟预录。

## 视频 FIFO 中的 PTS 已经过原厂修正

路径已追到：

```text
DSP H.264 信息 ring A06890E0，1024 × 64 字节
  → A02CA5A0 处理 DSP 消息 0x82000001
  → A02C7660 修正描述符 +8 的 u64 PTS（非结束哨兵）
  → event 4，48 字节事件对象的 +0x10
  → A0460754 BitsMgr
  → 已注册 A046CA94，事件 0x1f
  → FrameDesc +8
  → A0452254（本轮停在 FIFO 写调用之前）
```

环形索引位于 `A1458568`，每次递增并在 1024 回到 0。每项的原始 `+8` 是 u64 时间字段；`+0x18 == 0xffffffff` 时跳过 PTS 修正。普通条目会调用地址翻译 `A04A3BD4` 处理 payload 地址，不能将 DSP 地址原样当作 CPU 指针。

此前报告的“原始描述符 PTS”若指 FrameDesc，应理解为 **尚未经过 mux 时间线换算的 PTS**；它不是未经处理的 DSP raw PTS。预录观测若在更早层插入，必须区分两者，不能重复修正，也不能假定数值始终相等。

## 回绕处理是有状态的，不能简单套用单调递增

`A02C7660` 使用每个编码流的状态。按该函数内的局部符号表示：

| 状态偏移 | 作用 |
|---|---|
| +8，u32 | 修正模式；值为 1 时强制走 c1 分支 |
| +0x0c，u32 | 与前一 raw PTS 的绝对差阈值 |
| +0x10，u64 | PTS base |
| +0x18，u64 | 前一 raw PTS |

`A02CB7C8(channel, stream_selector, mode)` 写模式和阈值 `0xffff0000`，不清除 base 或前一 PTS。四个初始化用例直接执行该函数，覆盖主/另一路、通道 0/1，确认保留旧状态；这不证明真机当前模式参数值。

设 raw PTS 为 R，前一值为 P，base 为 B，阈值为 T；所有加法按 u64 回绕：

- `abs(R-P) <= T`：返回 `R+B`，更新前一值为 R，保留 B。
- 超过阈值且 `mode == 1` 或 `(DSP descriptor[+0x14] & 7) != 3`：日志标作 c1；先 `B += 2^32`，返回 `R+B`，更新前一值。
- 超过阈值且 `mode != 1` 且低三位等于 3：日志标作 c0；只为本次返回 `R+B+2^32`，**不更新 B 或前一值**。没有把类型 3 直接命名为具体编码帧类型。

注意代码检查的是绝对差，普通小幅回退也会走第一条。该函数并不单独保证时间线严格递增，更不能拿修正后的高位变化当作新的拍摄起点。

## 从 DSP ring 到 FrameDesc 的字段传递

| DSP 64 字节项 | event 4 对象 | FrameDesc |
|---|---|---|
| +0x04，u32 | +0x08 | +0x00，序号 |
| +0x08，u64，经上述修正 | +0x10 | +0x08，PTS |
| +0x10，地址，经 CPU 地址翻译 | +0x18 | +0x14，payload 地址 |
| `+0x14 & 7` | +0x1c，u32 | +0x10，type 字节 |
| `+0x14 >> 7` | +0x20，u32 | 本回调没有直接复制该字段；FrameDesc +0x11 被设为 1 |
| +0x18，u32 | +0x24 | 普通条目 +0x18，payload 长度 |
| +0x24/+0x26，两个 u16 | +0x28/+0x2a | 本轮不命名为尺寸或断言下游复制 |
| +0x28，u32 | +0x2c | 本轮保持 opaque |

低层 `0xffffffff` 结束哨兵不能与高层 `0x00ffffff` 长度哨兵混淆；BitsMgr 的 `A0460754` 会将前者改为后者，再调用高层 callback。脚本只在低层验证哨兵跳过修正，没有执行完整 BitsMgr，也没有声称 EOS 下游分支已经执行通过。

## 可复现验证及边界

```sh
.venv-reverse/bin/python scripts/audit_prerecord_video_pts.py
```

[机器可读结果](../artifacts/device/2026-11-10-prerecord/video-producer-audit.json) 固定镜像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，保留五个已索引函数的函数体与伪代码 hash、未索引 callback 的原始窗口及反汇编。

19 个用例组成如下：4 个状态配置、11 个修正算术/分支、1 个 c0 后普通帧状态衔接、3 个 ring 构造与回绕。普通路径执行完整 helper 返回；c0/c1 路径在 printf 调用前停止，c1 日志后的状态写回后缀单独运行，没有执行或替换 printf。三个 ring 用例运行原始适配前缀及真实地址翻译 helper，停在事件 dispatcher 前；普通条目随后以生成的事件运行实际高层 callback，停在 FIFO write 前。ring 索引 1023→0、已含非零 base 的事件与 FrameDesc PTS，以及结束哨兵绕过修正均核对通过。

所有 RAM、描述符、模式和极端算术输入由宿主构造，没有 DSP 硬件、RTOS 调度、真实编码 payload、FIFO 并发或 mux 文件写入。因此不构成真机运行或可播放成片证据。DSP raw PTS 的硬件时钟来源仍未知；其原点与音频编码帧计数起点的对应关系也未证明。

## 对一分钟预录的约束

旁路点优先选在原厂 FrameDesc/virtual FIFO 之后，可以复用已有视频回绕处理，避免自行猜测 DSP 时钟宽度。若必须在 DSP 事件层采样，应同时保留 raw PTS、修正状态和修正结果，才能检查重排、暂停/重启和回绕。该选择仍须先满足安全原生执行、payload 复制所有权和消费者退出的关卡。

结合 [音频配置与启动顺序](prerecord-audio-config.md)：已审计的音频表项有 48 kHz 配置来源，但音频输入可在 liveview 提前启动，录像时才清零编码帧序号；pipeline 先音频后视频的顺序启动不提供共同硬件 epoch。保存两轨首帧并各自归零，仍不能证明一分钟边界的音画同步。

## 已保存真机原片的封装时间线交叉检查

只读检查此前相机录像 `artifacts/device/2026-11-10-feature-api/YDXJ0142.MP4`，不连接相机、延长或重制素材。其创建来源见同目录 `android-client-live.json`（正常 API start/stop，原记录的 status_after 为 Unknown，不能将该记录当作全部状态验收通过）及 `new-recording-decode.json`（此前 AVFoundation 实际解码 80 帧）。

新 [original-media-timing.json](../artifacts/device/2026-11-10-prerecord/original-media-timing.json) 固定该本地文件 SHA-256、FFprobe 版本和参数，检查全部封装包：80 个 H.264 包，时基 1/30000，每包 1001；125 个 AAC 包，48 kHz 双声道，时基 1/48000，每包 1024。两轨 DTS 均严格递增，文件内首 PTS 均为 0；视频尾端 2.669333 秒，音频尾端 2.666667 秒。

这给出了现有真机原片的实际封装样本，与静态 48 kHz 配置和按 AAC 采样数推进的时间线吻合；**文件内归零不反映 ADC 与视频首帧的真实采集偏差**。本次没有新增设备端独立摘要，不宣称测得感知音画同步或共同硬件 epoch。复现：

```sh
.venv-reverse/bin/python scripts/inspect_camera_media_timing.py \
  --input artifacts/device/2026-11-10-feature-api/YDXJ0142.MP4 \
  --output artifacts/device/2026-11-10-prerecord/original-media-timing-new.json
```
