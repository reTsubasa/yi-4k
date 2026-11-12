# EIS shared feedback 引用边界

本轮对固定 1.10.7 ARM 镜像及完整 Ghidra `references.tsv`/`calls.tsv` 做了定向扫描，目标是区分 CPU 的共享状态读写与可能的非哨兵反馈写入者。没有执行固件、连接相机或写入设备。

复现：

```sh
.venv-reverse/bin/python scripts/audit_eis_shared_feedback_refs.py
```

结果见 [audit.json](../artifacts/device/2026-11-10-eis-shared-feedback-refs/audit.json)。输入镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

## 固定引用结果

- 发布字 `A0699160` 有 5 个直接引用，全部位于 `A02C5FD8` 的状态发布范围内；完整索引没有外部固定代码引用。
- CPU 共享状态 helper `A02C61D4` 在调用图中有 2 个调用站点，均来自巨函数 `A0385780`：`A03877A0` 读取共享字段，`A0387CAC` 写回消费哨兵。
- `A02C6214` 是固定 ARM 路径中明确可见的 `translated_shared + 0x3c` store；`A02C6260` 是对应 load。它们属于 CPU helper 的读/重置流程。
- 完整索引没有把 `A0699160 + 0x3c = A069919C` 作为独立固定数据目标引用；该地址由运行期转换后的 base 加偏移得到。

这使“当前固定 ARM 索引中没有第二个直接反馈 alias 写者”的范围更明确，但不能把它说成整个系统没有写者：ORC 的 `smem_2_dram`、MMIO/DMA 和间接表跳转不一定出现在 ARM 固定引用索引中。

## 仍然未知

该审计不能证明 `smem_2_dram` 已完成、共享字段具备 cache 可见性或原子发布，也不能将 CPU 的 `DEADBEEF` 重置和两个 helper 调用解释为 DSP latch、编码帧关联或旧表释放。下一步若要闭合非哨兵写入者，必须获得 ORC 运行身份与共享写回的真机只读时序证据；本轮不设计或部署写入探针。
