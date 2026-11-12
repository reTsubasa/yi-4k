# 1.10.7 编码输出 FIFO 合约（离线静态证据）

本页只记录 `rtos-window.bin`（SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`）的 ARM 字节与现有 Ghidra 导出。分析脚本是 `scripts/analyze_prerecord_output_contract.py`，输出为 `artifacts/device/2026-11-10-prerecord/output-contract.json`；没有连接或写入相机。

## FrameDesc

`AmpFifo_WriteEntry` 以 32 字节步长复制描述符。视频编码回调 `0xA046CA94` 的 `0x1F` 事件路径在真实字节中把输出事件填入描述符，然后调用 `0xA0452254`。字段是：

| 偏移 | 宽度 | 证据含义 |
|---:|---:|---|
| `+0x00` | u32 | frame/entry sequence；视频从事件 `+0x08` 复制，音频读取并递增实例计数器 `A19C7318 + slot*0xF0`，不是音频事件 `+0x08`（后者是 PTS） |
| `+0x04` | u32 | 保留/未解释 |
| `+0x08` | u64 | PTS（视频从事件 `+0x10`，音频回调同样复制 64 位值） |
| `+0x10` | u8 | 类型；排除 EOS 后，视频 `1` 是同步/随机访问候选，其他值保持 opaque |
| `+0x11` | u8 | 标志/保留 |
| `+0x14` | u32 | 编码环中的 payload 地址 |
| `+0x18` | u32 | payload 字节数，或高层 EOS 哨兵 `0x00FFFFFF` |
| `+0x1c` | u32 | 未解释 |

视频路径目前没有真实静态证据把 `0/2/3` 映射成 I/P/B。音频编码器普通帧路径确实写入 `type=8`，EOS 路径写入 `0xff`；这不足以推出完整的 AAC 枚举。后续 [DSP 到 FrameDesc 合同](prerecord-dsp-framedesc-contract.md) 已证明视频 EOS 也可为 `type=1`，raw 长度 `0xFFFFFFFF` 经 BitsMgr 归一为高层 `0x00FFFFFF`。主机解码器保留原始字段，先识别结束长度；只有非 EOS 的 type1 才是同步候选，还需验证实际 NAL7/8/5 字节。

## virtual FIFO、生产、消费与回收

原生 MP4 启动函数 `0xA01F6340` 为视频、音频及其他轨道创建 virtual FIFO。每次调用 `AmpFifo_Create(0xA04509DC)` 都传入 `0x2000` 个描述符和 virtual 标志 `1`；创建函数按 stream ID 找到对应 base FIFO，并为 virtual handler 单独分配描述符队列。`AmpFifo_Create` 的通用默认配置是 128 个描述符，但 MP4 启动路径覆盖为 8192 个（每个描述符 32 字节，每个队列的描述符存储为 256 KiB（8192 × 32 = 262144 字节））。

视频生产者 `0xA046CA94` 和音频生产者 `0xA045E7DC` 调用 `AmpFifo_WriteEntry(0xA0452254)`。MP4 启动函数 `0xA01F6340` 创建独立 virtual video/audio FIFO。视频消费者 `0xA042D0F8` 和音频消费者 `0xA043173C` 都先 `AmpFifo_PeekEntry(0xA0451960, index=0)`，分别写 H.264/AAC，再用 `AmpFifo_RemoveEntry(0xA0451C94, count)` 推进自己的读取游标。`AmpFifo_SyncWritten(0xA044E8D4)` 将 base 新描述符复制到匹配的 virtual queue。

因此旁路预录消费者需要独立 virtual FIFO，及时复制 payload（地址属于共享编码环），然后只推进自己的游标。`AmpFifo_WriteEntry` 的 base 回收会寻找 virtual consumer 的最小 read index；落后的旁路会反过来限制回收。描述符队列同步不会复制 payload，不能把 virtual queue 当成 payload 所有权转移。

正常 MP4 关闭路径 `0xA01F6088` 先等待 mux 完成，删除 mux 资源，停止 pipe/file 对象，再依次调用 `AmpFifo_Delete` 删除 virtual FIFO。EventRecord 关闭路径 `0xA01F8F08` 的静态顺序是等待 mux 完成、注销 EventRecord 描述符、删除 mux 资源、停止 pipe/file 对象、删除 virtual FIFO。旁路消费者应在自己的写盘和消费任务完全停止后再删除 virtual FIFO；固件静态代码没有提供可复用的外部 quiescence barrier。

旁路不应复用或释放编码器 payload 地址，也不应推进 base FIFO。并发第二个原生 MP4 writer、无缝 rollover 和真机生命周期尚未验证。

## 时钟和安全边界

视频消费者的 `0xA042CE28` 将 descriptor `+0x08/+0x0c` 传给 `AmpFormat_ConvertPTS(0xA03E5B5C)`；该函数按 mux stream 状态和时基换算并维护 PTS/DTS，H.264 setup 结构还暴露 `pts_delta`（配置偏移 `+0x60`）。这证明 mux 会消费 descriptor PTS，但没有恢复出所有模式的源时钟 epoch、单位选择或安全的主机 DTS 重建规则。任何便携实现都应保留原始 u64、显式配置时基并在样本上验证。

上述地址、字段和生命周期是离线分析结果，不构成可直接写入固件或设备的 ABI。

主机侧对应模型的边界也保持这一点：`PreRecordBuffer` 只保存段元数据和时间窗口，不假设段边界等于 PTS/DTS 边界；`FrameDesc.VirtualQueue` 只保存 32 字节描述符对象，`remove()` 不会解引用、复制或释放 `payload_address` 指向的编码环内容。`VirtualPayloadConsumer` 对普通帧先复制并校验 payload 长度，再推进自身读取游标；读取失败、短读或超出上限时保留 descriptor 以便重试。EOS 单独通知、没有 payload 复制或自动推进。真实旁路适配器必须遵守同一顺序，并由存储层只删除自己生成的段文件。

预录段的 `Segment.name` 现在也由主机状态机约束为单一文件名，拒绝空值、`.`、`..` 以及包含 `/` 或 `\\` 的路径。这样，存储适配器可以把淘汰段拼接到自己的 spool 目录而不会因异常生产者元数据删除目录外文件；该检查不涉及文件系统，也不改变相机端 ABI。

## 主机 FrameDesc 的 EOS 返回协议

[prerecord_frame_desc.py](../scripts/prerecord_frame_desc.py) 的 `FrameDesc.is_end_of_stream` 对精确长度 `0x00FFFFFF` 返回 true，同时防御性识别较低层 raw `0xFFFFFFFF`；不把临近长度或相同 type 当 EOS。`is_sync_candidate` 只在非 EOS 且 type1 时为 true。普通帧 `mux_hint` 仍为 `sync_or_random_access` 或 `opaque`，EOS 改为 `end_of_stream`；`to_dict()` 增加两个对应布尔字段，原始长度、地址、PTS 等字段保持原值。

`VirtualPayloadConsumer.consume_one(read_payload)` 现在返回三个互斥类型，调用者必须区分：

| 返回 | 含义及游标行为 |
| --- | --- |
| `None` | 队列为空，没有条目。 |
| `OwnedFrame(descriptor, payload)` | 普通帧已完成长度检查和所有权复制，本 consumer 游标已推进一次；普通复制/重试语义不变。 |
| `EndOfStream(descriptor)` | 结束通知，仅持有原描述符，没有 payload 字段。先于 `max_payload_size` 检查及 `read_payload` 调用识别；不读取地址、不复制字节、不推进游标。 |

EOS 不等于空队列，也不是零字节 `OwnedFrame`。只要 owner 尚未处理，重复调用继续返回同一队首的 `EndOfStream`，不会自动越过它发布后续 payload；调用者应结束消费循环，并自己决定 drain/close/停止任务的顺序。若确实决定丢弃/确认该标记，可由同一 owner 显式调用 `VirtualQueue.remove()`，这不是 `consume_one()` 的隐式 ack，也没有代替真实 FIFO 关闭或释放资源。

兼容性变化是返回 union 从 `OwnedFrame | None` 增加 `EndOfStream`：原先仅检查非 None 然后访问 `.payload` 的调用者需要显式分支。仓库现有调用点只在 host 测试；Android、原生 payload-copy 候选和真实 FIFO ABI 均未因此修改。同步候选仍不保证参数集齐全、payload 合法或独立解码。

```sh
.venv-reverse/bin/python -m unittest scripts.tests.test_prerecord_frame_desc -v
```

13 项 host 测试通过，覆盖两层结束长度、type1 EOS、其他 type EOS、先于读取/长度上限的通知、重复通知不推进、显式 owner 处理、临近长度的普通上限检查，以及原有普通帧复制、失败保留和布局 round-trip。没有访问相机或执行设备地址。
