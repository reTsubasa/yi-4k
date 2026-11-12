# 早期 callback owned-frame 复制适配层（纯 C 离线原型）

已实现 [yi4k_1107_early_copy.h](../sdk/yi4k_1107_early_copy.h) 和 [yi4k_1107_early_copy.c](../sdk/yi4k_1107_early_copy.c)。它复用现有 `yi4k_1107_copy_payload` 的边界、EOS、别名和双段回绕处理，只补 BitsMgr event 到自有 frame 队列的接缝，没有再实现 FIFO owner/start/stop/Delete 状态机，也没有设备地址、注册器、hook、loader、SD 或网络写入。

后续[音频 payload 链与接缝](prerecord-audio-payload-chain.md)已补齐：同一模块现将 owned-frame 入队提成 `early_offer_frame`，供视频入口和独立音频单参数 wrapper 共用；owned slot 增加 source_kind 与 sanitized audio snapshot。每条音频/视频流仍各需独立 SPSC queue，不能共用一个实例接收两个 producer。下面的视频合同保持，代码大小和验证 hash 已更新为共享实现后的结果。

这是对[原厂 payload 回收证据](prerecord-payload-reclaim.md)的实现响应：一分钟历史应保存及时复制后的自有 payload，不能让 virtual FIFO 长时间持有编码 ring 地址。**适配器仍要求调用方已经建立整个 copy 期间的硬件 payload 稳定期与 cache 一致性；目前没有这一真机证据，不能在设备上直接启用，也不能称为相机预录完成。**

## 为什么复用 copy，但不复用 FIFO consumer

现有 `yi4k_1107_payload_copy` 已有固定 32-byte FrameDesc ABI，以及 CPU ring 地址校验、一次回绕复制、EOS 不读 payload、错误不改目标的合同，本模块直接调用该函数，未修改其 ABI 或实现。

现有 `yi4k_1107_fifo_consumer` 采用 `begin_read → Peek → snapshot → copy → persist → Remove → end_read`，必须依赖外部尚未实现的稳定 read lease，并明确禁止在 stock callback 中运行；其中 persist 是同步服务。它适合晚期单 owner，但不能充当早期 callback 的立即复制入口。

新模块只在 callback 中做有界 CPU 复制和发布：无 malloc、互斥锁、重试等待、文件或网络 I/O。初始化检查可遍历全部 slot；它只能在双方静止时调用，不属于 callback 路径。原 callback 自身的耗时/故障不在模块的有界执行承诺之内。

## 数据与队列合同

`yi4k_1107_video_event` 固定 0x30 字节事件布局：sequence `+8`、corrected PTS `+0x10`、CPU payload 地址 `+0x18`、type `+0x1c`、flags `+0x20`、长度 `+0x24`。复制时完整保留 event；另生成与 pinned stock video callback 对齐的 FrameDesc，其中 flags=1，不把 event flags 擅自当成 FrameDesc flags。

调用方预分配 controller、N 个 slot 和 N 份 payload 缓冲。初始化检查 payload 缓冲彼此不重叠，且不与 source ring、controller、slot metadata 重叠。N 至少为 2；以一个空槽区分空/满，实际容量 N−1。没有内部内存分配，也不声称这些空间在相机中可用。

只有一个串行 callback producer 和一个 consumer。head/tail 使用 C11 无锁 `atomic_uint` acquire/release 发布与回收；编译期要求无锁 32-bit unsigned atomics。它支持两个线程的 SPSC，不支持多个 producer。`ingress_busy` 只是 producer 自身同步重入保护，不是跨线程锁。

consumer 用 `early_peek` 借用**已复制的自有 slot**，直到 `early_release` 前该 slot 不会被重用。写盘任务应在接受或另行复制数据后 release；长时间占有导致队列满时，新 callback 立即报告 FULL，不覆盖旧 slot。这个 owned-slot 生命周期和编码器 source ring lease 是两回事。

## 转发及异常路径

`early_on_event` 接收一份独立且不可变的 `chain`，带 injected context 和原 callback 函数。这个 context 仅为离线接缝，不是声称 stock ABI 发现了额外参数。未来真正的 stock wrapper 仍必须保持原三个参数和返回值。

对有效非空 chain，每次 invocation 都恰好一次调用原 callback，并原样传入 handle、event code 和 argument；返回值保留原 callback 的 status。capture status 单独返回，不能覆盖原返回码。

| 捕获分支 | 队列和 payload 行为 | 原 callback |
| --- | --- | --- |
| 普通有效帧 | 先复制 event/payload，发布 owned slot，再 chain | 一次 |
| 两种 EOS 长度 | 发布零 payload 的 end slot，不读 ring | 一次 |
| 队列满，包括 EOS | 报 FULL、增加 dropped，不覆盖任何待消费 slot | 一次 |
| 无效长度/地址、slot 过小 | 报 COPY_FAILED，不发布；下一次有效帧仍可进入 | 一次 |
| NULL/未对齐 event、超界 stream/type | 报 BAD_EVENT，不发布 | 一次 |
| 未知 event code | 不读取 argument，直接 passthrough | 一次 |
| NULL adapter | 不捕获，报 BAD_ADAPTER | 一次 |
| 同步重入 | 跳过 nested capture、报 REENTRY；原调用链仍保留 | 每个 outer/nested invocation 各一次 |
| chain 或原 callback 为空 | 报 BAD_CHAIN | 无法调用；不作恰好一次保证 |

这是普通 C 对有效对象的合同，不捕捉野指针、硬件访存异常、原 callback 不返回或无限递归。non-null adapter 必须成功初始化并存活；source event/ring 必须可读并稳定，不能与输出缓冲重叠。结束/释放/卸载仍需要外部 quiescence；没有提供可在活跃 producer 上安全重置队列的接口。

发布发生在原 callback 之前，因此 owned slot 只证明字节复制成功，不证明后续原 FIFO 接受、mux 写盘或 H.264 可播放。上层仍须根据原 callback status、gap/溢出状态处理本次预录是否有效，不把有界 staging 队列当成一分钟存储。

## 实际编译与执行结果

[validate_prerecord_early_copy.py](../scripts/validate_prerecord_early_copy.py) 编译真实模块和未修改的 payload-copy C；[22 组用例](../sdk/offline/yi4k_early_copy_test.c)分别在宿主和编译后的 ARM Cortex-A9 代码中执行。所有返回码/统计报告一致，ARM 的 SP 与 callee-saved 寄存器保持；链接后无未定义符号和 relocation。

覆盖重点包括：原 callback 改写 source ring/event 仍不影响先前 copied frame；source 后续复用不改变 owned bytes；payload 尾→头的 7+9-byte 双段复制；满队列保留 consumer 已 peek 的队首；17 次 slot index 环绕与复用；EOS 使用无效 ring 映射仍不读 payload；EOS 满队列明确丢失；异常每路径转发；同步 nested invocation 各转发一次；失败后下一帧继续；初始化拒绝 source alias、slot 重叠和单槽队列。

另运行[宿主 pthread SPSC 压力夹具](../sdk/offline/yi4k_early_copy_threads.c)：实际接受并消费 20,000 个带 sequence/byte pattern 的 owned frame，检查发布顺序、源环回绕、FULL 时不覆盖和每次 callback 调用恰好一次转发，完整性错误为 0。调度 yield/等待只存在测试夹具中。它验证 C 队列跨线程发布，不是 RTOS、DSP/DMA、cache 或真机 copy 时限测试。FULL 次数取决于宿主调度，不作为固定基准。

当前 ARM 代码大小：init 556 bytes、共享 offer_frame 1208 bytes、video on_event 440 bytes、peek 44 bytes、release 60 bytes，视频与共享队列合计2308 bytes；另链接原 payload copy496 bytes。最初视频专用快照的1396 bytes是历史大小，不对应现有源文件。测试夹具单独标记，禁止用作相机 payload。编译命令、版本、全部源码/头文件 hash、函数大小和报告均在 [validation.json](../artifacts/device/2026-11-11-prerecord-early-copy/validation.json)。

```sh
.venv-reverse/bin/python scripts/validate_prerecord_early_copy.py
.venv-reverse/bin/python -m py_compile scripts/validate_prerecord_early_copy.py
python3 -m json.tool artifacts/device/2026-11-11-prerecord-early-copy/validation.json >/dev/null
```

仍缺的实际接入条件是：安全安装并保留单槽原 callback、停止和在途 callback quiescence、CPU ring 真实范围与 cache 状态、整个 copy 的硬件稳定期及最坏 copy 耗时、相机内存/带宽预算、后台一分钟 spool/mux 与 gap 处理、音频真实绑定和共同 A/V epoch。原型不调用注册/隐藏 setter，不连接或写入相机，也不改 Android 或共享 roadmap。
