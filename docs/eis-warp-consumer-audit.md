# EIS warp 消费者与缓存边界审计

日期：2026-11-10。本审计只读取固定的 1.10.7 RTOS 窗口，补充 [warp 发布契约](device-1107-eis-warp-publication.md) 对消费者锁存、旧槽回收和缓存边界的负面证据。没有运行固件、提交表或访问真机。

后续补充：[间接 DSP 发布审计](eis-indirect-dsp-publication-audit.md) 已恢复 `VCAP_SETUP.eis_update_addr` 注册发布字地址及 CPU 命令入队路径。本文“未找到消费者”的结论应限定为未证明 DSP 锁存/确认和旧槽回收，不能再理解为缺少 CPU 侧传递链。指针层级也已更正：`+0x80` 保存转换后的状态槽地址，状态槽 `+0x24` 才保存 warp 描述地址。

复现：

```sh
.venv-reverse/bin/python scripts/audit_eis_warp_consumer.py \
  --output artifacts/device/2026-11-10-eis-warp-consumer-audit/audit.json
```

本轮同时扫描固定镜像对应的完整 Ghidra `references.tsv`。发布指针是
`0xA0699160`（`A02C5FD8` 状态块的 `+0x80`）；索引中共发现 5 个引用，全部来自
`A02C5FD8` 自身的写入/参数位置，外部固定代码引用为 0。这个结果加强了“静态资料中
尚未找到消费者”的负面证据，但不能排除通过间接 DSP/MMIO 通道运行时消费。

## 31 条契约的一致性

原有 [contract.json](../artifacts/device/2026-11-10-eis-warp-publication/contract.json) 的 `checks` 数量为 31，目标镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。审计重新复核相同镜像及 `A02C5FD8` 的发布序列，没有发现报告或 roadmap 中的数量/身份不一致：

- `A0312460` 的三个代码分支各自清理两个 `0x1800` 平面；固定字节中有 6 个 `A04A22CC` 调用站点，语义上每次执行仍是两平面 clean；
- `A02C5FD8` 的 `+0x24` 槽描述写入、`+0x80` 发布指针、索引递增和大于 1 回绕均与 31 条契约一致；
- `A03119A8 → A032CF38` 的网格容量限制和 selector `0xF` 分支没有被本次审计扩大解释。

因此 roadmap 中“31 条设备字节静态契约检查全部通过”的说法保持成立。它描述的是固定指令检查，不是运行轨迹或 DSP 接收确认。

## 当前能证明的缓存边界

`A0312460` 在三个代码路径中分别把两个表平面送给 `A04A22CC`，每次长度都是 `0x1800`。这说明表内容在进入后续状态发布前有明确的 CPU 侧 clean 边界。固定字节检查没有把 `0x1800` 扩展解释成网格 pitch、有效点数、Q 格式或整张表的生命周期。

`A02C5FD8` 的审计范围内没有可见的 `A04A22CC` 调用。它复制 0x40 字节状态、转换描述地址、写入选定槽的 `+0x24`，再写共享发布指针 `+0x80` 并回绕索引。这个“没有可见 clean”是一个边界事实，不代表状态槽一定不需要 clean：调用者、地址转换助手、DSP 驱动或其他 cache/barrier 路径仍可能承担该职责。

## 消费者和回收的负面证据

- 固定反汇编中没有发现 `A02C5FD8` 内部对 DSP latch、acknowledge、完成计数或旧槽释放的调用；
- 完整固定引用索引中 `0xA0699160` 的 5 个引用均来自 `A02C5FD8` 自身，未发现外部固定代码读取发布指针；间接 DSP/MMIO 消费仍无法由该索引排除；
- `A02C61D4` 通过 `A04A3BD4` 访问一组转换后的共享字段，可读写 `+0x10..+0x3C`，但没有证据表明它读取两个 LiveviewEisConfig 槽、确认 `+0x80` 已被 DSP 锁存，或释放旧描述；
- 两槽索引回绕只说明生产者选择下一个槽，不能证明 DSP 最坏延迟小于两次发布间隔，也不能证明旧描述地址不会被覆盖；
- `A0385780`/`A037E218` 的调用关系说明状态更新会触发 `A02C5FD8`，但当前静态资料没有把子阶段索引与编码帧号、DSP completion 或 MP4 PTS 关联起来。

这些结论是停止条件：在消费者锁存、旧槽回收、cache/barrier 所有权和最坏延迟未闭合前，不设计复用两个槽的自定义 hook，不把一次 `A0312460` 返回成功当成表已作用于某个编码帧，也不提交自定义 warp。

## 下一项静态契约与停止门槛

当前最小、可继续离线推进的契约是“发布指针之后的消费者引用链”：从 `+0x80` 的状态指针存储出发，寻找唯一的下游读取、DSP command 构造、completion/ack 和旧槽释放条件。只有找到固定指令证据，才能把以下字段写成可验证协议：

```text
publication word -> state slot -> warp descriptor -> DSP read/latch -> completion/ack -> safe reuse
```

如果完整代码/符号索引中仍找不到这条链，必须保留当前负面结论，并停止向真机推进。需要真机才能回答的事项包括：cache 属性和跨核可见性、DSP 实际锁存时刻、表覆盖是否造成撕裂、状态索引与编码帧的对应关系以及最坏消费者延迟。

报告：[离线审计结果](../artifacts/device/2026-11-10-eis-warp-consumer-audit/audit.json)。结果明确 `consumer_acknowledgement_found=false`、`old_slot_reclamation_found=false`、`device_contacted=false`。
