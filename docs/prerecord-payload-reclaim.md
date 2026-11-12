# 一分钟历史必须保存 payload：视频回收与早期复制入口

本轮把视频 producer 的回收消息贯通到原厂 BitsMgr 的字节退休计数，新增 **13 组原始 ARM 执行检查、8 份固定伪代码来源、6 条精确指令断言**。结果明确了一项阻碍：**保留 virtual FIFO descriptor 一分钟，不等于保留其 payload 一分钟；必须在 producer 回收前立即复制到自有存储。** 新入口仍是离线设计，没有相机端可运行 backend。

脚本：[audit_prerecord_payload_reclaim.py](../scripts/audit_prerecord_payload_reclaim.py)。证据：[audit.json](../artifacts/device/2026-11-11-prerecord-payload-reclaim/audit.json)。固定 RTOS 镜像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`；输入来自现有 Ghidra 导出和镜像。没有连接、读写或执行真机，没有修改 Android 或共享 roadmap。

## 原厂视频的回收由 producer 驱动

视频初始化 `A046FECC` 为 base FIFO 配置 `capacity=0x2800`、`RemoveOnWrite=1`、payload ring 上下界及 callback `A046E3E0`，再设置最小空闲 byte 阈值。另一配置入口 `A0470B70` 也设置该模式。这里的配置是固件静态来源，不是本次读取到的真机运行参数。

`RemoveEntry(A0451C94)` 先推进调用者的 virtual read cursor；当其 base `+0xb0==1` 时，不发送普通消费消息。原 ARM 夹具分别构造 base `B0=0/1`，前者发送 `[0x4000000,virtual,1]`，后者没有消息；两者都没有立即改变 BitsMgr retired bytes。这个调用返回不是 payload byte 已释放或 DMA 已完成的确认。

启用 RemoveOnWrite 后，下一次 `WriteEntry(A0452254)` 执行两级回收：

1. 先按 descriptor 容量保留 64 项余量。对 capacity C、当前 pending N，低 64 位常见范围内的回收数为 `max(0,N+65-C)`；这一初始推进发生在后面的 virtual 最小 read cursor 检查之前。
2. 若配置 payload ring 上下界，再用 descriptor payload 地址间的环形距离与 byte 阈值比较，枚举同 stream 的 virtual read cursor，必要时继续推进 base read cursor。这个循环的边界不构成稳定 payload lease。

最后先排队 `[0x10000000,base,removedCount]` 回收消息，再复制新 descriptor、递增 write cursor，排队 `0x4000002` 数据就绪消息。两种消息不能混同。

## 原指令反例：virtual 仍持有旧 payload 地址，byte 记账已退休

夹具使用 4096-byte 合成 payload ring、128 项 descriptor 队列、base read=100/write=102、virtual read=100；virtual 队首实际指向 ring 开头，长度 512。原厂视频 callback、BitsMgr 消费函数和有界 worker dispatch 均执行镜像指令；锁、消息发送、日志等使用现有明确替身。

| payload 最小空闲阈值 | WriteEntry 后 base read | virtual read | worker 后 retired bytes |
| ---: | ---: | ---: | ---: |
| 3000 | 100 | 100 | 0 |
| 4000 | 101 | 100 | 512 |

第二行中，virtual 队首 payload 地址和 read cursor 都没改变，但原 factory 消费链已把第一项 metadata 的 payload 指针清零、head 前进，并增加 512 retired bytes。发送消息后、worker 执行前，retired bytes 仍为 0，证明这个阶段是异步通知。

另隔离 descriptor 余量分支，关闭 payload 上下界计算，capacity=128、virtual read 固定 100：pending=63/64/65 分别回收 0/1/2 项。后两者同样越过 virtual 当前读位置。该夹具只执行原算法的构造状态，不能据此声称现场相机已经发生覆盖或损坏。

**没有模拟或执行 DSP 覆盖。** 合成 payload 字节故意保持不变；这里证明的是持有 virtual descriptor 不能阻止原厂退休路径，真实硬件何时覆盖仍未知。因此不能把“读指针没 Remove”作为 payload 保存承诺。

## worker 到 BitsMgr 的真实释放链

```text
A0452254 WriteEntry / RemoveOnWrite
  → 0x10000000(base, count) 消息
  → A044F0C0..A044F1C4 worker 分支
  → base callback(event=0x4000000, &count)，持有 base +0x48 锁
  → A046E3E0 VideoEnc_BitstreamFifoHandler
  → A0460C98 BitsMgr_ConsumeBitstream(stream, bank, count)
```

脚本从实际 queue receive 之后开始有界 worker dispatch，在下次 receive 之前停止；未替换上述 callback 或 BitsMgr 函数。只通过夹具提供收到的消息和 task-local 初态，不执行真实 RTOS 调度。

BitsMgr 对指定 stream 的 metadata 项在 `+0x10/+0x14` 写入 `0x00000000fee1dead` 已消费标记，随后仅从全局 head 退休连续已标记前缀：普通长度按 `(length+63)&~63` 累加到 bank `+0x40/+0x44` retired bytes；`0x00ffffff` EOS 不计 byte；退休时清 metadata `+0x18` payload 指针和已消费标记。bank 的 produced bytes 在 `+0x38/+0x3c`。

三组调用检查进一步验证全局顺序：metadata 顺序为 stream1/65 bytes、stream0/128 bytes、stream0/EOS、stream2/64 bytes。先消费 stream0，第二项只标记，retired bytes 仍 0；再消费 stream1，连续退休前两项，计数变为 `align64(65)+align64(128)=256`；再消费 stream0 的 EOS，head 前进、计数仍 256。先后 stream 共享 metadata head 的约束不能省略。

`GetUsedSpace(A04612BC)` 读 produced-retired 及阈值标志；独立夹具得到消费前 `[1024,0]`、退休一帧后 `[512,0]`。它是占用记账，未证明 DSP 写指针、DMA 完成、payload byte 稳定期或一分钟可容纳时长。

## 新 backend 候选：先同步复制，再交给原 callback

比 virtual FIFO 晚读更早的候选点是 BitsMgr `ObtainBitstream(A0460754)` 的高层 event `0x1f` callback：该函数先更新 produced bytes，按原厂 cache 配置对 ring payload 做 invalidate，复制 48-byte event 到 metadata ring，释放 BitsMgr 锁，最后才调用已注册高层 callback。现有高层视频 callback 随后构造 FrameDesc 并进入 WriteEntry。因此在**串行原调用链**里，包装这个 callback 可以把当前帧的复制放到本次 WriteEntry 回收之前。

候选接口和约束已经写入 JSON 的 `candidate_backend_interface`：

```text
copy_ready_video_event(event, cpu_ring_bounds, owned_nonblocking_sink)
  → 复制临时 event metadata
  → 排除 EOS、校验地址/长度/回绕
  → 复制 payload 到预分配自有空间
  → 发布 owned frame
  → 每条路径都恰好一次调用原视频 callback
```

callback 不等待 SD/网络；独立任务仅写自有 owned frame，维护一分钟片段窗口。容量不足要明确记录 gap/使本次预录失败，同时让原录像链继续；不自行推进 base、不直接调用 BitsMgr Consume、不释放编码 ring。这里提出的是可验证的接口位置和失败合同，没有添加设备可执行 hook。

有两项现实阻碍：

- `Register(A04611CC)` 是每 stream 一个 callback 槽，slot 空才成功；原 ARM 夹具验证已有 `A046CA94` 时新注册返回 -1 且保留原指针。它没有第二观察者/自动 fan-out API。需要在 producer 启动前建立安全包装链，并证明安装、退出和原 callback 恰好一次调用；不能直接在运行中抢占该槽。
- callback 在 BitsMgr unlock 之后执行，DSP 可能继续生产；原厂 cache invalidate 也不等于授予整个 copy 期间的硬件 lease。必须继续验证 DMA/cache 稳定期、最大帧 copy 时限、实际 ring 容量和吞吐预算，不能把“比本次 WriteEntry 更早”升级为硬件无覆盖保证。音频等价的早期复制/退休链及共同 A/V epoch 仍另缺证据。

本轮把“一分钟历史在哪里保存”收敛为**及时复制后的自有 payload/片段存储**，排除了依靠原厂 virtual descriptor 持有 ring 地址等待一分钟的实现。相机预录、硬件复制时限及实际成片均未完成。

验证：

```sh
.venv-reverse/bin/python scripts/audit_prerecord_payload_reclaim.py
.venv-reverse/bin/python -m py_compile scripts/audit_prerecord_payload_reclaim.py
python3 -m json.tool artifacts/device/2026-11-11-prerecord-payload-reclaim/audit.json >/dev/null
```
