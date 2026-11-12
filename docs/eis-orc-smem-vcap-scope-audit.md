# ORC `smem_2_dram` 与 EIS shared feedback 的有界关联

日期：2026-11-11。本轮只扫描固定 1.10.7 ORC member 的直接相对调用和 `smem_2_dram` helper 本体，没有执行 ORC、连接相机、访问 `/dev/mem` 或写入设备。

复现命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_smem_vcap_scope.py
```

结果见 [audit.json](../artifacts/device/2026-11-11-eis-orc-smem-vcap-scope/audit.json)。输入 ORC member SHA-256 为 `9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6`。

## 调用点分类

全 member 的字对齐扫描得到 67 个直接 `l.jal 0x1a4a04` 候选。按调用前 12 个字中可见的参数形态分类：

| 类别 | 数量 | 位置 | 可见参数形态 |
|---|---:|---|---|
| EIS feedback 候选 | 1 | `0xd78f8` | `r4=0x2a20`，`r3=base+60`，长度 `4` |
| EIS pre-clear 候选 | 1 | `0xd7aa4` | `r4=0x2a40`，`r3=base+32`，长度 `32` |
| 相邻但未归属字段 | 1 | `0xd7b2c` | `r4=0x2ac0`，`r3=base+16`，长度 `4` |
| 其他候选 | 64 | 其余位置 | 未出现上述 EIS 参数形态 |

`0xd78f8` 与已恢复的 `shared+0x3c` 候选完全一致；`0xd7aa4` 与 `shared+0x20..+0x3f` 预清除路径一致。`0xd7b2c` 位于相邻函数，使用 `0x2ac0` 和另一个数据结构的 `+16`，本轮没有证据把它归入 EIS shared block，因此保留为未知。

## helper 本体边界

`0x1a4a04` 本体没有直接出现 VCAP/shared 地址常量，也没有解码出 `mfspr/mtspr`；它直接调用的低层目标包括：

```text
0x1a16d8, 0x1a16e4, 0x1a1528, 0x1a6ef4,
0x1a15d4, 0x1a0bfc, 0x19fd94, 0x19fe44,
0x19fcac, 0x84
```

其中 `0x1a16d8` 是固定的 SPR 读取 helper；`0x1a1528`、`0x1a6ef4` 等属于低层/不透明代码路径，当前扫描不能赋予 DMA 完成、缓存同步或硬件 latch 语义。helper 自身没有把任意调用点升级成 VCAP 写入者。

## 结论

在 direct `smem_2_dram` caller 范围内，只有一个 `shared+0x3c` 反馈候选和一个 pre-clear 候选；没有发现第二个同形态的直接调用者。这比“所有 `smem_2_dram` 都可能是 EIS feedback”更窄，但仍不是运行期证明。

仍未闭合的范围包括：间接 ORC 分派、DMA/MMIO 真实目的地址、专有 staging 指令、外部复制完成、cache/atomic 发布、运行期 ORC 身份以及状态槽/warp 表的安全释放。当前结果只能继续支持只读观测和静态调用图工作，不能解除自定义 EIS 执行门槛。
