# early-copy 到原厂 mux 的自有描述符适配层

已完成一个可编译的离线 C 适配层，补上 [writer 接缝报告](prerecord-owned-mux-writer.md) 确认的具体缺口：early-copy 原先只保存来源描述符；新层将 payload 地址重定位到自有 arena，给出同时匹配的上下界，并控制原 staging 槽位何时可复用。

验证结果是 **27 组主机 + 27 组编译后 ARM + 10 组接原厂 ARM consumer** 全部通过。它不是一分钟预录实现，没有真实文件/index 生命周期、MP4 收尾或设备安装能力。

## 文件与复跑

- `sdk/yi4k_1107_owned_mux.h`、`.c`：独立适配层，只使用现有 early-copy 公共接口，没有修改共享队列代码。
- `sdk/offline/yi4k_owned_mux_test.c`：主机/ARM 行为测试与串联 fixture。
- `scripts/validate_prerecord_owned_mux.py`：严格编译、ARM ABI 检查及原 consumer 串联。
- `artifacts/device/2026-11-11-prerecord-owned-mux-adapter/validation.json`：完整结果、编译命令、源码/头文件哈希及显式模型边界。

```sh
.venv-reverse/bin/python scripts/validate_prerecord_owned_mux.py
# 可指定独立证据路径，避免覆盖默认产物：
.venv-reverse/bin/python scripts/validate_prerecord_owned_mux.py --output /tmp/owned-mux-independent.json
```

主机与 Cortex-A9 ARM 使用 `-O2 -Wall -Wextra -Werror`；ARM 为 freestanding、soft-float、无 libc。链接检查确认未解析符号和链接后 relocation 都为 0。27 组测试主机/ARM report 相同，ARM 的 R4–R11 与 SP 均保留。此处“编译后 ARM”是新 C 代码，不是原厂固件代码；原 consumer 的入口另行注明。

## 最小接口与生命周期

1. `owned_mux_init`：在 producer/consumer 都静止时，为一个已初始化 early-copy 队列指定 stream kind 与连续 arena。验证所有槽位的完整 allocation 在 arena 内，slot 不重叠，source ring 和 owned arena/control objects 分离，32 位 CPU 上下界不溢出，来源 CPU range 与自有 CPU range 不重叠。失败不改 consumer。
2. `owned_mux_prepare`：peek 一个槽位，验证来源类型、copied 长度/两段长度、type/flags 和容量，创建私有 mux 描述符。`cpu_payload_address = arena.cpu_base + (slot.payload - arena.bytes)`；输出 `ring_base` 和 **end-exclusive** `ring_end`，供 caller 同时设置原 track 的 `+0x34/+0x38`。来源 descriptor/event 不变，sequence 与 corrected PTS 原样保留。
3. 对同一个 held 槽位重复 `prepare` 返回相同 packet，不 release、重拷贝或追加文件。producer 仍受原 SPSC 队列的容量约束，不能复用 held 槽位。
4. caller 完成 sample/terminal 处理后调用 `owned_mux_finish`。只有 `writer_status == 0` 且 `payload_use_complete == 1` 才 release **一个** staging 槽位。零状态本身不足以保证可以复用 payload。
5. 写入错误、缺少 use-complete 确认或无效确认值会 poison，并保留槽位；后续 prepare/finish 都拒绝继续。没有“直接重试”“丢弃并继续”或 reset 接口。真实文件/index 的恢复、回滚、关闭和队列重建必须由外层在双方静止后完成。

这一层没有 stock virtual FIFO allocator。串联测试将 C 生成的 descriptor 原字节放进现有合成 virtual FIFO，真正的 FIFO Peek/Remove 和原 consumer 随后执行；生产环境仍须恢复其创建/调度与隔离方式。

## EOS 与输入边界

视频只接受已证实的 early-copy `type=1, flags=1` 加 `0xFFFFFFFF/0xFFFFFF` 终止长度；音频只接受现有音频适配器的 normalized `type=FF, flags=1, length=FFFFFF, address=0, PTS=0`。两种情况 copied bytes、first/second span 和 sync hint 都必须为 0。错误 type/flags、非零 span 或冒充终止的普通帧均 fail closed，不释放槽位。

视频原始终止事件可带无效来源地址/PTS，它们不是可读 payload，不能用普通 ring 验证方式解引用。输出统一为 owned `type=FF, length=FFFFFF, address=0, PTS=0`，payload 指针为 NULL。`0xFFFFFE` 不在此 owned 终止合同中。END 必须走外层 terminal/close 策略，不能当普通 sample 送 writer；这里不推定 stock EOS 返回值代表文件已关闭。

普通视频限定原报告验证过的 type1–4/flags1，音频限定 type8/flags1。保留 PTS 并不代表已建立共同 A/V epoch、完成切点重基或证明 SPS/PPS 与 AAC 配置正确。这里也不解析媒体字节，不把 type1 等同于已验证可独立解码的 IDR。

## 串联证据

每个串联 case 执行：

`归档样本 → 新编译 C early_offer → 原有 C payload-copy/SPSC → 新 C prepare → 原 ARM ProcessVideo/ProcessAudio → 新 C finish`

fixture 在独立的合成地址写入来源样本，C 真正执行 bounded copy；描述符在来源快照中仍指向旧地址，mux packet 的指针变成自有 `0x20000080`。随后将整个来源 ring 覆盖成 `EE`，只把适配器输出的 32 字节描述符写入合成 virtual FIFO，并应用其两个 track bounds，再执行原 `A042D0F8 ProcessVideo` 或 `A043173C ProcessAudio`。

| 每轨执行的路径 | writer 返回 | stock virtual read | early staging head | 后续 |
| --- | --- | --- | --- | --- |
| 连续来源正常写入 | 0 | 前进 | 前进 | 可准备下一包 |
| 跨来源 ring 尾的正常写入 | 0 | 前进 | 前进 | 可准备下一包 |
| stream 少写 1 字节 | -1 | 不前进 | 不前进 | poison |
| payload 写出后 sample-size index 失败 | -1 | 不前进 | 不前进 | poison |
| index Commit 失败 | -1 | **已前进** | **不前进** | poison |

视频成功输出 468192 字节，hash 为 `299d7eee243e9439e0ff6e778083ec603ea4a0e424f1813a2948bdb7427a16c4`；音频为原 AAC 341 字节，hash 为 `85867eff0bf940a0b082042a415f2f78c0633faa72e088b5879632d0671c9293`。来源跨环 case 输出相同；短写分别为 468191/340 字节，其余失败仍已写出一整帧。这说明为何失败时不能自动重试或根据 stock Remove 就释放 early 槽位。

ARM CPU read hook 在原 writer 阶段未发现来源 ring 读取。视频 parser 真实读取自有字节；raw AAC helper 直接把自有指针传给 stream Write，因此没有必要由 ARM CPU 再 load AAC 字节。stream 抓取模型明确读取该自有指针，并记录写出字节/hash；不把 emulator API 的读操作假冒为 ARM load。

## 模型与不可证明的合同

- 使用原固件镜像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。原 FIFO、track 初始化/advance、视频 PTS convert、H264 parser/serializer 与 AAC raw helper 执行原字节。stream Write/Tell/Length、index Add/Commit、锁/日志等 OS 服务沿用现有明确模型。
- 验证输入来自此前已存档的普通 MP4；不连接相机、不写设备，也不是 raw encoder FIFO、硬件参数集重复或硬件 lease 证据。
- `arena.bytes ↔ cpu_base` 的实际地址映射由 caller 保证。C 只验证数值、对象区间和偏移；不同虚拟地址的物理别名、MMU 映射、DSP/CPU 转换与 cache/DMA 一致性不能由这些检查证明。ARM fixture 使用相同合成 CPU 地址，主机 fixture 使用显式测试映射。
- `payload_use_complete=1` 是外层提供的事实确认，不是 C 模块探测的硬件状态。串联 stream 模型同步复制字节且不保留指针，故测试能如实提供；不能据此推定真实 SD/DMA writer 也同步完成。若 caller 错报完成，模块无法识别。
- 一个独占 consumer、一个 producer、一个 stream/queue；不支持外部 release/reset 或 active 状态改 metadata。测试能发现某些越权 release，但不能证明检测所有 ABA/并发违约。音视频必须使用两个独立 early-copy 队列。

仍需补齐 codec epoch/SPS/PPS、独立解码切点、共同音视频时钟、真实 index/file open-close 与失败恢复、RTOS/cache/hook 的目标端合同，以及一分钟缓存策略。语音/快门触发属于相机侧，当前代码未绑定这些入口。
