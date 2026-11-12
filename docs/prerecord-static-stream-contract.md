# YI 4K 1.10.7：预录编码流与 EventRecord 静态契约

日期：2026-11-10。本文只记录本机 1.10.7 RTOS 窗口的离线 Ghidra/Capstone 证据，不包含真机写入或自定义代码执行。镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

## 新确认的编码流边界

`FUN_a02b7454`（`0xA02B7454`）打印并整理一份 `H264ENC_SETUP` 参数。除编码尺寸、帧率、码率和音频采样率外，结构中明确包含：

- `bits_fifo_base/limit`：编码 bitstream FIFO 的地址范围；
- `info_fifo_base/limit`：编码信息 FIFO 的地址范围；
- `stat_fifo_base/limit`：编码状态 FIFO 的地址范围；
- `idr_interval`、`gop_structure`、`M/N`、`follow_gop` 及 FGOP 边界；
- `target_storage_space`、`cpb_user_size` 和 `pts_delta`。

这些字段证明原厂编码器已经把“编码输出缓冲区、关键帧间隔、GOP 结构和时间基”作为一套配置传递。直接调用者是 `0xA02D1F50`，它从较高层配置构建 `0x6C` 字节结构后调用此发送器；当前未恢复高层配置的完整 ABI。它们是实现预录所需的研究入口；地址本身不能直接当成可读写 ABI，三个 FIFO 的所有权和生产者/消费者关系仍需通过调用点恢复。

`FUN_a03f1944`（`0xA03F1944`，`AmpFifoPool_GetFifoParam`）接收 FIFO handler，限制索引小于 `0x40`，持有 `0xA19653FC` 互斥锁后返回对应参数。`thunk_FUN_a03f11fc`（`AmpFifoPool_OnDataEvent`）同样通过该互斥锁调用内部回调，`FUN_a03f0c7c` 再把 FIFO 数据事件映射为事件标志。它的已解析直接调用者 `0xA0439B80` 标识为 `AmpDemuxer_OnDataRequest`，因此该通路首先是通用 FIFO/解复用同步证据，不能当成已找到编码输出订阅。尚未证明有安全的第三方订阅接口。

### 32 字节 FrameDesc

对视频回调 `0xA046CA94` 和音频生产者 `0xA045E7DC` 的真实 ARM 读写做了交叉核对：写入 FIFO 的描述符步长为 `0x20` 字节，当前可安全命名的字段如下：

| 偏移 | 大小 | 内容 | 证据边界 |
|---:|---:|---|---|
| `+0x00` | u32 | sequence | 视频从事件 `+0x08` 复制；音频由实例计数器 `A19C7318 + slot*0xf0` 读取并递增（`A045EA1C/A045EA50`），不是音频事件 `+0x08`（后者是 PTS） |
| `+0x04` | u32 | 保留 | 未恢复语义 |
| `+0x08` | u64 | PTS | 视频从事件 `+0x10` 读取（已在 DSP 事件层做回绕修正），音频从编码事件 `+0x08` 直接复制 |
| `+0x10` | u8 | type | 只确认视频 mux 中 `type==1` 走同步/关键帧元数据路径 |
| `+0x11` | u8 | flags | 未恢复逐位语义 |
| `+0x12` | u16 | 保留 | 未恢复语义 |
| `+0x14` | u32 | bitstream address | 生产者直接填入，尚未证明生命周期可供扩展读取 |
| `+0x18` | u32 | payload size | 生产者直接填入 |
| `+0x1c` | u32 | opaque | 音频/解码路径会复用；不可泛化成音频或视频类型 |

`type` 的其余数值目前保持 opaque；不能把它们直接命名为 I/P/B 或 AAC。后续 [DSP 到 FrameDesc 合同](prerecord-dsp-framedesc-contract.md) 证明 EOS 也可带 type1。主机侧 [FrameDesc 解码器](../scripts/prerecord_frame_desc.py) 先按高层长度 `0x00FFFFFF`（兼防御性排除 raw `0xFFFFFFFF`）识别 EOS，只有非 EOS 的 type1 才记录静态同步候选 hint；不解引用地址，也不模拟真实缓冲区所有权。消费接口的独立 `EndOfStream` 通知及不推进规则见 [输出合同](prerecord-output-contract.md#主机-framedesc-的-eos-返回协议)。

视频回调 `0xA046CA94` 由 `0xA0470B70 -> 0xA04611CC` 注册，按事件 `0x1f` 取上述字段后调用 `AmpFifo_WriteEntry`。原厂视频 mux `0xA042D0F8` 的消费顺序是 `PeekEntry(index=0) -> H264 write -> RemoveEntry(handle,1)`；音频 mux `0xA043173C` 对应 `PeekEntry -> WriteStream -> RemoveEntry(handle,2)`。`0xA01F6340` 创建独立 virtual video/audio FIFO，`0xA044E8D4` 将 base 新条目同步到各 virtual queue，base 回收受 virtual read cursor 约束。

这使“旁路消费者”的边界更具体：必须创建自己的 virtual handle，快速复制 descriptor 和 payload，按自己的 cursor remove；停止时先停止消费者，再注销并释放 FIFO。当前仍未恢复第三方创建 virtual handle 的公开 ABI、payload 映射权限、PTS 原点和跨音视频时钟关系；因此这些字段尚未构成可部署的 RTOS 扩展。

## IDR、SPS/PPS 和帧写入

`FUN_a03e8834`（`0xA03E8834`，`AmpFormat_FeedIdrFrame`）是一个具体的关键帧输入路径。其调用者 `0xA03ECE98` 从 `getFrameInfo` 结果的 frame type 选择 IDR、其他视频或音频分支。该路径：

1. 先调用 `AmpFormat_PrepareFrame` 检查目标流的可用空间；
2. 对类型 2 的流调用 `AmpH264_PutGOPHeader`；
3. 调用 `AmpFormat_PutSPSPPS` 写入参数集；
4. 读取/搬运 H.264 stream，处理环形地址回绕；
5. 最后调用 `AmpFormat_WriteFrame`，失败时返回明确错误。

`FUN_a03e6af4` 依次写入 `00 00 00 01`、SPS、另一个 `00 00 00 01` 和 PPS；最后一个 4 字节标记是 PPS 前缀，不是尾部标记。它们能作为参数集和 IDR 格式的参考，但 `FeedIdrFrame` 明确从 stream seek/read 后向 FIFO 写帧，更像格式/解复用输入方向，**尚不能确认可直接用于编码输出切段**。预录方案从最近 IDR 开始并保存对应 SPS/PPS 是设计约束，不能用此函数的存在替代输出切段 ABI 的恢复。

## EventRecord 的边界

`FUN_a01f845c`（`0xA01F845C`）确实创建 EventRecord MP4 mux 资源：

- 为视频和音频分别建立 track/FIFO/流对象；
- 从原厂分辨率、帧率、采样率和存储状态填充 mux 配置；
- 建立最终 mux 对象并注册 `FUN_a01f838c` 回调；
- `FUN_a01f8ebc` 构造含开始回调 `0xA01F8E68`、关闭回调 `FUN_a01F8F08` 和类型 `3` 的 20 字节描述符；它实际调用 `0xA01F0F2C`，该函数匹配类型并清除 enable 字节，日志是 `Unregister handler`，所以这是**关闭时注销**，不是注册入口；
- `FUN_a01f8f08` 关闭 mux、释放 FIFO/track/流对象。

对应注册器是 `0xA01F0E00`（复制 20 字节描述符、最多 8 个 handler，并按类型匹配 enable）；当前已解析直接调用者为 `0xA01F23F0`、`0xA01F5FF0`、`0xA01F7F50` 和 `0xA0211464`，未找到 EventRecord 对应首次注册的调用。EventRecord 开始回调仍可能通过未恢复的间接路径注册，不能宣称当前产品已接通。

`FUN_a012c98c` 只有在 `DAT_a0FB334C == 1`（当前录像状态）时才发送 recorder 操作 `0x1D`；否则打印 `Block eventrecord when system is not in recording`。因此 EventRecord 是“录像中事件保存”的封装候选，尚未证明能够在待机取景阶段承载一分钟历史流。

## 可落地的实现顺序

1. **离线完成调用图。** 以 `0xA02B7454`、`0xA03E8834`、`0xA03F1944`、`0xA03F0C7C` 和 `0xA01F845C` 为种子，恢复当前录像模式实际选用的 FIFO handler、编码通道和 GOP/IDR 参数。先保存只读快照，不修改配置。
2. **先做 5 秒主机/模拟验收。** 使用现有 YDXJ 视频和主机 H.264/MP4 工具，验证“按 IDR 切段、保留 SPS/PPS、记录 PTS、拼接后可解码”的状态机；输出段清单、帧类型和时间戳报告。
3. **真机只读观测。** 在自定义代码执行关卡通过后，优先记录 FIFO 元数据、IDR 序号、bitstream 长度、PTS 和丢失计数；不直接搬运或覆盖编码缓冲。记录器必须有固定容量和超时返回。
4. **首版采用 SD 短段循环。** 先把每个完整 GOP 写成独立短段，维护最近 60 秒的段清单；触发时原子固定清单并继续新段。此前应用池空闲约 223.7 MiB，无法为 4K 高码率的一分钟 RAM 缓冲提供保证，因此 SD 路径更适合作为首个产品原型。
5. **再接原厂 mux 或主机 remux。** 先验证段集合可播放，再判断 `EventRecord` 是否能接受待机状态下的历史段。若不能，先保留带 manifest 的 H.264/AAC 段，最后再实现机内 MP4 remux。

## 触发语义

原生 VoiceCmd 路径已经把识别结果 `1003` 映射到 `F0010338`/`F001033B`，随后通过 `E001000C` 进入 recorder 的录像按钮回调；实体按键路径也会产生 `E001000C`。因此预录扩展应只在统一动作层消费一个幂等的 `START` 事件：

```text
IDLE -> ARMING -> PREBUFFERING -> COMMITTING -> RECORDING -> FINALIZING
                       ^ START（语音 / 快门 / App）
```

当前语音设置未在 API 暴露，精确中文/英文短语和音频有效性仍需真机验证。实现阶段应先验证已有模型产生一次 `1003`，再把它和快门路径接入同一 `START` 队列；不要直接向现有 `0x1D` 或 `E001000C` 注入事件来绕过 recorder 状态检查。

## 当前边界

- **静态观察**：编码配置字段、通用 FIFO 的互斥锁/事件通知、IDR 输入方向的参数集写入、EventRecord mux 资源、注销描述符和录像状态 gate。
- **新增静态观察**：视频事件回调、`0x20` 字节 FrameDesc 写入，以及 base/virtual FIFO 的 peek/remove 和读游标约束。
- **推断/设计**：SD 短段循环、固定最近 60 秒、统一幂等 START，以及将 EventRecord 复用为新预录输出。它们没有真机执行证据。
- **已有运行证据**：VoiceCmd_Task 存在并等待事件；此轮没有新增运行证据，不能把静态短语或任务存在当成识别成功。
- 尚未确认编码 FIFO 的安全订阅方式、段文件的音视频 PTS 规则、待机状态下 EventRecord 是否可用，以及预录期间的 SD 写入峰值。
- 尚未执行任何自定义 RTOS 代码、录像状态改写或真机持久化操作。

## 复现与证据文件

运行 `.venv-reverse/bin/python scripts/analyze_prerecord_routes.py`。固定镜像哈希和既有分派断言通过后，`static-audit.json` 输出增加 `stream_contract`（来源文件及有界字符串清单）、`selected_direct_call_sites_in_existing_export`（已解析直接调用）和三个新的 ARM 指令窗口。字符串清单只用于定位，不代表 ABI 或运行状态成立。

- [编码配置发送器](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02b7454.c) 与[高层构建调用者](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02d1f50.c)。
- [IDR feed](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a03e8834.c)、[frame-type 分派](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a03ece98.c)和[SPS/PPS 前缀写入](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a03e6af4.c)。
- [EventRecord mux 创建](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a01f845c.c)、[注销描述符](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a01f8ebc.c)、[注销器](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a01f0f2c.c)和[注册器](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a01f0e00.c)。
- [机器可读审计](../artifacts/device/2026-11-10-prerecord/static-audit.json)。


## 后续生产者与配置审计

[视频生产者与回绕修正](prerecord-video-producer-audit.md) 新增 19 个原始指令离线用例，确认 DSP 64 字节项先经有状态 PTS 修正，再送入本文的 32 字节 FrameDesc；两层的时间字段不能混称为未经处理的 raw PTS。另见 [音频配置来源与启动顺序](prerecord-audio-config.md)：已审计的主次音轨三个表项都配置 48000，但音频输入可先在 liveview 启动，录像清零帧序号不等于同步开始采集。两轨共同 epoch、相机端一分钟缓存和触发输出仍未证明。
