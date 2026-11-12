# EIS VCAP update-address 字段的 ARM 所有权边界

日期：2026-11-11。本轮仅扫描固定 1.10.7 ARM 镜像的完整 Ghidra 伪代码和固定调用点，没有执行固件、连接相机、访问 `/dev/mem` 或写入设备。

复现命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_vcap_update_addr_refs.py
```

结果见 [audit.json](../artifacts/device/2026-11-11-eis-vcap-update-addr/audit.json)。镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

## 本轮新增边界

对完整 `full/decompiled/*.c` 做精确 token 扫描，只发现两处直接使用 `DAT_a06f3380 + 0x58`：

| 函数 | 位置 | 语义 | 调用关系 |
|---|---|---|---|
| `A02C5FD8` | `a02c5fd8.c:27` | 仅在 `param_2 == 0` 时把 VCAP `+0x58` 清零 | 4 个固定 ARM 调用点；关停调用 `A0382EE8` 明确传 `r0=0,r1=0` |
| `A02C61D4` | `a02c61d4.c:12` | 读取 VCAP `+0x58`，经地址转换后作为 shared base | 2 个调用点：`A03877A0` 读、`A0387CAC` 写回消费哨兵 |

`A0387CAC` 在调用 `A02C61D4(..., param_2=1)` 前，先把 `DEADBEEF` 写入本地缓存 `+0x20`；因此该写回路径是 CPU 消费后的 reset sentinel。它不会提供 DSP 非哨兵反馈值。`A02C61D4` 的另一种 `param_2=0` 模式只把共享字段复制到 CPU 缓存，不写 shared `+0x3c`。

`A02C5FD8` 的另外两个 EIS 发布/清槽调用都传 `param_2=1`，不会触发清零 VCAP `+0x58` 的分支。该函数的唯一固定 ARM 关停调用传 `r0=0,r1=0`，与“停用并清除地址”一致。

## 结论和限制

这轮把 ARM 侧的直接所有权进一步收窄：在完整反编译集合中没有发现第二个固定 ARM 非哨兵写者。当前仍需把这个结论限定为“精确字面引用和已导出的 ARM 调用点范围”；ORC 的 `smem_2_dram`、DMA/MMIO 和间接跳转不一定出现在 ARM `references.tsv` 中。

因此，下一条安全的静态路径仍是分析 ORC `context+0x10D8` 反馈候选的源值、`smem_2_dram` 的完成/缓存语义和运行期身份。即使确认 ORC 写入，也仍需证明状态槽/warp 表的生命周期和最坏延迟，不能把它升级成自定义 EIS 可写入口。

本轮不产生部署器，不执行原生 EIS，也不改变相机状态。
