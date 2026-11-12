# 1.10.7 预录音频 PTS 生产者审计

2026-11-10。继 `prerecord-timebase-audit.md` 和 `prerecord-track-writers-audit.md` 后，本轮追到音频编码完成事件的 PTS 生产源头，并在宿主执行固定镜像的原始指令前缀，15 个用例通过。

本轮使用 reverse-engineer-anything 技能约束证据范围，复用已有 Ghidra 导出并使用本地 Unicorn；没有新建 REA 会话，没有连接相机、向相机写入或执行代码，没有修改固件或 MCP 配置。没有实现相机端预录、语音触发或快门绑定。

## 本轮结论

音频 PTS 由编码帧计数合成。`AudioEnc_StartEncodeImpl` 给编码任务设置的时钟是 **90,000**；`AmbaAudio_EncTaskSetUp` 将帧计数清零；每次 `AmbaAudio_EncUpdateBitsBuf` 发送编码完成事件时计算：

```text
PTS = floor(low64(u32(frame_count) × u32(samples_per_frame) × u32(pts_clock))
            / u32(denominator))
frame_count = low32(frame_count + 1)
```

该函数没有读取硬件或系统时钟。90,000 来自原始指令构造的参数，已经不只是人为测试假设；但由此不能推出音频 PTS 与视频传感器 PTS 有共同 epoch。分母与采样率的语义相符，本轮只证明其字段传递与算术用途，**没有证明真机当前模式的分母值就是 48,000**。

## 固定证据

输入镜像 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，加载基址 `0xA0100000`，SHA-256：

`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`

复现脚本 `scripts/audit_prerecord_audio_pts.py`；完整结果 `artifacts/device/2026-11-10-prerecord/audio-producer-audit.json`，含函数体和伪代码 SHA-256、原始指令窗口、每个测试的输入和输出。

| 函数 | 证据与作用 |
|---|---|
| `A045DA98` / `a045da98.c` | `AudioEnc_StartEncodeImpl` 构造 setup。`A045DAFC–A045DB20` 用 `MOVW/BFI` 得到 `0x00015f90 = 90000` 并存到 setup+0x10。setup+4 来自 context+0x60。 |
| `A0290B60` / `a0290b60.c` | setup+4 写 state+0x2c；setup+0x10 写 state+0x24；state+0x1c 及 +0x20 清零；setup+0x1c 写 state+0x44 回调。 |
| `A029016C` / `a029016c.c` | 从 state+0x20 读帧计数、+0x10 读每帧数量、+0x24 读时钟、+0x2c 读分母；通过 `UMULL/MLA` 和 `A0506F38` 无符号除法生成 u64 PTS；递增帧计数。 |
| `A02902B4` / `a02902b4.c` | 音频编码任务调用编码后处理 `A029024C`，再调用 `A029016C`。任务中其他 tick 读取不能当成这条 PTS 公式的输入。 |
| `A0295800` / `a0295800.c` | 将 event 0 分发给已注册回调。 |
| `A045ECD0` / `a045ecd0.c` | 创建编码任务，并通过 `A02955C0` 注册 event 0 回调 `A045E7DC`。 |
| `A045E7DC` / `a045e7dc.c` | 编码事件 +8 的两个 PTS 字直接写入 FrameDesc +8，再交给 `A0452254` FIFO 写入。原始复制窗口 `A045EA38–A045EA4C`。 |

setup 的后半段还按 codec 高半字节选择 state+0x10 数量：高半字节为 1 时默认 1024；完整格式字节为 `0x11/0x12` 时改为 2048。这是静态代码证据；本轮没有执行 codec 初始化或据此证明当前相机选择了哪种格式。

编码事件的字段偏移如下。不要混同 FrameDesc 的 payload 长度偏移：事件长度在 +0x14，FrameDesc 长度在 +0x18。

| event 偏移 | 类型 | 内容 |
|---|---|---|
| +0x00 | u32 | 编码器 handle |
| +0x08 | u64 | 合成 PTS |
| +0x10 | u32 | EOS 标志 |
| +0x14 | u32 | payload 长度 |
| +0x18 | u32 | payload 地址 |

## 离线验证边界与结果

运行：

```sh
.venv-reverse/bin/python scripts/audit_prerecord_audio_pts.py
```

脚本将镜像映射到原始地址，另映射合成 RAM；没有修改任何指令，也没有替代除法 helper。真实运行 ARM 调用、BLX 进入 Thumb 除法及返回。只运行以下前缀：

- 调用者 `A045DAF0 → A045DB5C`：从 mutex／状态检查后的中间地址开始，验证构造的时钟为 90,000，停在 setup 调用前。不能解释为整个 start 函数执行成功。
- setup `A0290B60 → A0290BF8`：构造有效指针图、非零时钟并关闭 debug 日志，验证状态字段与帧计数清零。没有进入后续 codec 初始化、零时钟 fallback 或 RTOS 调用。
- 事件生成 `A029016C → A02901D8`：13 个合成用例，停在 dispatcher 调用之前，验证 PTS、帧计数及事件所有已知字段。没有执行真实编码、RTOS dispatcher 或 FIFO。

部分结果：

| 帧计数 | 每帧数量 | 时钟 | 分母 | 原始指令产生的 PTS |
|---:|---:|---:|---:|---:|
| 0 | 1024 | 90000 | 48000 | 0 |
| 1 | 1024 | 90000 | 48000 | 1920 |
| 2 | 1024 | 90000 | 48000 | 3840 |
| 3 | 1024 | 90000 | 48000 | 5760 |
| 1 | 1024 | 90000 | 44100 | 2089 |
| 3 | 1024 | 90000 | 44100 | 6269 |
| 23，EOS=1 | 2048 | 90000 | 48000 | 88320 |

还覆盖大于 u32 的 PTS、u32 帧计数最大值与回绕，以及乘法溢出后取低 64 位的合成边界。极端参数是算术测试，不是受支持的相机配置。启动清零说明这里存在编码任务局部序列起点；在正常样本配置中，首帧 PTS 是零，但首帧对应的真实采集时刻仍未知。

## 对一分钟预录的影响

此前已确认视频换算参数可来自传感器表，不能统一假定 90 kHz；普通 MP4 音频 mux 又可按每帧采样数推进 DTS，未读取描述符原始 PTS。现在确认音频生产端的 90 kHz 是帧序号合成时钟，不能拿两轨 raw PTS 的数值差直接做同步。

因此保存最近一分钟的编码 payload 与原始描述符仍不够：需记录启动先后／两轨共同采集基准、真实采样率和 codec 帧数量、视频时间线及 mux 状态，再验证从关键帧起始的两轨裁切。当前结果提高了离线适配器的确定性；没有验证相机上的完整音视频同步、内存容量、成片或一分钟循环缓存生命周期。

## 后续配置来源

[音频配置来源与启动顺序](prerecord-audio-config.md) 已将公式分母追到 AppLib 固定表的三个已审计项和替代调用者，均配置 48000；该值现在有固件配置传递证据，仍非当前模式/ADC 的真机实测。输入在 liveview 可能已启动，record 阶段才清零帧计数。视频侧另有 [DSP raw PTS 回绕处理](prerecord-video-producer-audit.md)，两轨共同 epoch 继续未知。
