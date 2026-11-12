# 自有预录 payload 到原厂 MP4 writer 的接缝

本轮把已复制到自有 RAM 的音视频样本送进原厂 writer，完成 **19 组原 ARM 执行验证**。原厂 `ProcessVideo`、`ProcessAudio` 都实际读取了自有地址的字节，并通过原 FIFO Peek/Remove 与 track advance 路径。这把最小缺口收窄到：把 early-copy 槽位转换为独立可消费队列、补齐新文件 codec 配置、建立真实文件/index/open/close 生命周期，以及处理失败后的部分提交。

这不是可安装的一分钟预录功能，也没有设备访问。stream 的 Write/Tell/Length、index Add/Commit 是明确的字节捕获/错误注入模型；没有执行真实 SD 卡、文件/index 存储和完整 MP4 收尾。普通存档 MP4 提取的样本不能证明 encoder FIFO 会按相同方式交付参数集。

## 复跑与证据

```sh
.venv-reverse/bin/python scripts/audit_prerecord_owned_mux_writer.py
```

- 脚本：`scripts/audit_prerecord_owned_mux_writer.py`。
- 结果：`artifacts/device/2026-11-11-prerecord-owned-mux-writer/audit.json`。
- 固件镜像 SHA-256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- JSON 固定了 14 份反编译源码哈希、6 个原字节窗口哈希和 9 条准确指令检查。
- 输入来自已存档普通录像 `artifacts/device/2026-11-11-record-probe-01/session-media/YDXJ0161.MP4`，SHA-256 为 `862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d`。H.264 经 `h264_mp4toannexb` 后统一为四字节 start code；AAC 直接读取首包的文件区间。

合成 RAM 为 `owned=[0x20000000,0x20100000)`，原 encoder ring 替身为 `original=[0x20200000,0x20300000)`。描述符直接构造在有效 virtual FIFO 中，没有伪称经过 encoder base。锁、分配、消息和诊断沿用现有 FIFO harness 的模型。

## 已执行的实际入口

| 原入口 | 本轮证明 | 保留边界 |
| --- | --- | --- |
| `A03E627C AmpFormat_WriteStream` | 自有 AAC 连续及跨环两段精确写出；旧 ring bounds 拒绝自有指针 | stream Write 为同步抓字节模型 |
| `A03EFE74 AmpH264_WriteStream` | 自有 H.264 连续/跨环输出一致；原函数去除 SPS/PPS，转换长度前缀与 32 字节对齐 | 不等同生成完整 MP4 |
| `A042D0F8 ProcessVideo` | 原 Peek、limit、SPS/PPS parse、PTS convert、sample write、advance、Remove 均执行 | index Add/Commit、stream 为模型 |
| `A043173C ProcessAudio` | 原 Peek、limit、AAC raw write、advance、Remove 均执行 | 同上 |
| `A0432230` → `A042FAFC` → `A0429290` | 原 AAC STSD builder 与 serializer 实际生成 `mp4a/esds` 字节 | 输入为构造的 track/index-info，不是完整 close |

原 AAC 包为 341 字节，输出 hash 与输入完全相同：`85867eff0bf940a0b082042a415f2f78c0633faa72e088b5879632d0671c9293`。原 H.264 输入有 NAL `[7,8,5]`，长度 `[54,4,468188]`；输出恰为大端长度加最后的 slice，共 468192 字节，SHA-256 `299d7eee243e9439e0ff6e778083ec603ea4a0e424f1813a2948bdb7427a16c4`。连续与跨环完全一致。另用明确不可解码的短合成 NAL 验证原 padding helper：5 字节 NAL 被写成长度 28，加 23 个零，共 32 字节。

## 自有地址不是只改一个字段

原 `WriteStream(stream,len,ptr,base,end)` 的 `end` 为 exclusive。它先检查 `base <= ptr < end`，跨尾时从 `base` 写第二段。把 desc 的 payload 指针换成自有地址，却仍用原 encoder ring bounds，会返回 **-3，零次 stream write**。因此 mux track 的 `+0x34/+0x38` 必须与自有连续 arena 一致，且 caller 自行保证 length 不超过有效 owned allocation/ring 容量；该低层 writer 没有替 caller 完成全部长度约束。

现有 `yi4k_1107_early_copy.c` 复制 payload 到 `slot->payload`，但 `slot->descriptor = *descriptor` 保留来源地址。这是来源快照，不能直接作为 mux 输入。后续适配器必须创建 mux 专用 FrameDesc：`+0x14` 改为该 owned payload 的真实 CPU 地址，`+0x18` 为已复制长度，并放入自有消费队列；不能修改来源快照后就假定源 FIFO 生命周期已解决。若槽位是分散分配，单个固定 ring bounds 不自动覆盖全部槽位，需要连续 arena 或逐轨受控映射。

本轮是同步执行原 writer，成功返回前模型已经抓取全部媒体字节。真实文件流是否保留源指针、DMA/cache 一致性、队列并发，以及什么时候可安全复用槽位，仍需恢复实际 stream 合同。

## 时间与新文件参数集

`A0440CD4 InitMovieInfo` 用视频 `30000/1001`、音频 `48000/1024` 建立 track；video-only 的视频 scale/period 是 `30000/1001`，音视频 movie 的公倍数时间基为 `240000`，音频 period 被转换为 `5120`。`A0440948` 按 period 增加 DTS 和样本计数。原 `ProcessAudio` 本轮走的 raw AAC 路径不使用 desc PTS 来逐包对齐，不能据 writer 成功就宣称音视频捕获时钟或一分钟切点已对齐。

完整视频 case 读出 SPS 54 字节、PPS 4 字节，保存在传入视频参数区。另一个反例只提供同一真实 IDR slice，清空参数缓存后执行整个 `ProcessVideo`：**返回 0、写出媒体、Remove 成功，但 SPS/PPS 长度仍都为 0**。原 parser 先遇 slice 可以成功，writer return 不能代表新段可独立解码。需要在新 open 前保存并复用属于该 codec epoch 的 SPS/PPS，或以经过验证的输入拼接补入；本轮没有证明硬件每个 IDR 自动重复 SPS/PPS。四字节 Annex B prefix 是本轮验证的输入合同，不能把从成品 MP4 重建后的格式外推为真实 FIFO 格式。

默认 movie type 1 的 limit 路径依赖 video default track；本轮音频消费用 video+audio movie，音频是第二轨。没有用 audio-only type 1 的无效状态冒充成功。

## AAC 配置依赖已从实际序列化确认

AAC track type 为 `0x21`，track `+0x40` 是 sample rate、`+0x45` channels、`+0x46` bit depth。原 builder 按采样率索引与声道数生成两字节 ASC：`0x1000 | (samplingIndex << 7) | (channels << 3)`，AAC object type 固定为 LC。它没有从本轮 raw AAC payload 提取 transport configuration。

| 配置 | builder ASC | 原 serializer 的 DecoderSpecificInfo |
| --- | --- | --- |
| 48000 Hz / 2 声道 | `1190` | `11 90 00 00 00` |
| 48000 Hz / 1 声道 | `1188` | `11 88 00 00 00` |
| 44100 Hz / 2 声道 | `1210` | `12 10 00 00 00` |
| 12345 Hz / 2 声道，负例 | `7f90` | `7f 90 00 00 00`，仍返回 0 |

四组均由原 `A042FAFC` 完整序列化出 102 字节 STSD，包含 `mp4a`、`esds` 和实际 ASC；二声道 48 kHz 输出的 5 字节配置与存档 MP4 的 ffprobe extradata 一致。不支持的 sample rate 在 `A0432188` 返回 `0xff`，builder 未拒绝，形成无效配置仍成功；适配器必须限制已验证采样率/声道/codec，并从真实 encoder 配置建立 codec epoch。支持索引表为 48k、44.1k、32k、24k、22.05k、16k、12k、11.025k、8k；本轮仅执行表中前两种及无效值。

## 失败后的槽位与文件状态

视频与音频各执行 short write、payload 后 index Add 失败、Commit 失败三组原 consumer 反例：

| 失败点 | 返回 | 媒体字节 | FIFO read | DTS/计数 | 直接重试 |
| --- | --- | --- | --- | --- | --- |
| stream 少写 1 字节 | -1 | 视频 468191；音频 340，已部分追加 | 不前进 | 不前进 | 不能无回滚继续 |
| payload 后 sample-size index 失败 | -1 | 完整一帧已追加 | 不前进 | 不前进 | 消除注入错误后重试返回 0，媒体字节翻倍 |
| index Commit 失败 | -1 | 完整一帧已追加 | 已前进 | 已前进 | 同一来源描述符已经移除 |

因此不能把 `status != 0` 一律解释为“尚未消费，可保留并重试”，也不能只用 FIFO cursor 代表 MP4 已提交。后续实际 adapter 应在消费前建立文件/index 恢复边界；失败则终止/恢复该 segment，完成截断或重建后才重试。owned 槽位释放必须与描述符移除、stream 对 payload 的实际使用完成和 segment 状态协调，不能仅凭返回值决定。

## 最小下一步

1. 在离线 owned queue 接缝中实现 desc 地址重定位与连续 arena bounds，接现有音视频各自 SPSC early-copy 队列。
2. 恢复真实 index 与文件流的 init/open/write/close，执行完整 MP4 输出及独立 ffprobe/解码检查；保留本轮失败注入。
3. 证明参数集来源/codec epoch、音视频时钟和可独立解码切点，再接一分钟保留策略。
4. 之后才是目标 RTOS 的内存、cache、hook、调度与负载。语音/快门触发属于相机侧；本轮没有接这些入口。
