# EIS 日志门控字段的实际软件所有者

2026-11-11。新增结论：垂直 warp 调用者的 `r18+120` 与 `idspdrv_dram2dram` 的同偏移字段，对应原厂 **debug-level 数组 module 5 的 32 位配置项**。这次已找到命名有依据的 indexed writer，能把该字段从“对象身份未知”收窄为调试输出 mask；不是新增传输完成回执。

分析仅使用已固定的本地 ORC member 和标准核心编码参考。未访问设备、执行 ORC/RTOS、发送调试命令或改 Android/roadmap。使用 reverse-engineer-anything 的证据区分原则；本会话未提供 REA MCP，结果来自现有本地文件与受限 decoder，不是 REA Evidence ID。旧报告已检索，之前只恢复了 `+120` 读取和日志分支，没有恢复下列 set/add writer。

## 字段基址与写入者

垂直函数 `0x17F1EC/1F0` 把 `r18` 构造成零基址；读取位于 `0x17F27C: lwz r6,120(r18)`，低两位决定是否输出日志。复制 helper `0x18CB5C/60` 同样把 `r16` 构造成零基址，`0x18CB68/70` 读取 `+120` 并测试 bit 0，条件满足才转向 src/dst/size 日志分支。

这里的“零基址+偏移”是原始指令地址表达式，**不把它命名为 ARM 物理地址、MMIO 地址或已观测的 DSP DMEM 地址**。

两个新恢复的写入者给出精确数组关系：

| 原厂诊断/入口 | 固定地址计算与写入 | 对 `+120` 的关系 |
| --- | --- | --- |
| `setDebugLevel`，`0x1A0AFC` | `0x1A0B4C..5C`：`base=0x64`；`array[module]=level` | `0x64+5*4=0x78=120` |
| `addDebugLevel`，`0x1A0B78` | `0x1A0BB4..DC`：读取同数组，`array[module] |= level` | 相同 module 5 元素 |

函数名有固定原厂日志支持：成员 `0x2C027E` 的 `DSP:: setDebugLevel module=%d, dbg_lvl=%d`，由 `0x1A0B38/3C` 构造引用；`0x2C02A9` 的 `DSP:: addDebugLevel module=%d, dbg_lvl=%d, after=%d`，由 `0x1A0BC8/CC` 引用。数据流同时保存输入 module/level、计算 module×4 和实际执行 store，结论不只依赖字符串名字。

## 命令分派和独立直接写入

`CMD_DSP_SET_DEBUG_LEVEL` 的诊断引用位于 `0x1A85B0/B4`，字段形态由固定指令确认：命令 `+4` 为 module 字节，`+5` 为 add 字节，`+8` 为 mask 字。分派使用 `setDebugLevel` 或 `addDebugLevel`；另有遍历 module `0..7` 的分支。这里只恢复本地静态 dispatcher，不声称该命令已对外开放或当前可由相机 API 触发，也没有发送它。

还有多处独立的直接 writer，与同一零基址 `+0x78` 对应：`0xD36C` 清零；`0x98E24` 清零而 `0x98EAC` 写 7；`0x1A03B0` 和 `0x1FC208` 写 7。这些片段与通用 set/add writer 共同建立配置所有权线索，但不构成全固件无间接 writer 的证明。

新结论的实用意义是：`+120` 的低位已有明确的 **软件调试配置写入解释**，且同一个数组项同时控制多个诊断输出。后续不需要再沿该字段寻找 DMA done 或硬件完成状态；应将调查转到专有传输协议及其硬件消费者。

## 可复现证据与剩余缺口

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_debug_mask_owner.py
.venv-reverse/bin/python -m json.tool artifacts/device/2026-11-11-eis-orc-debug-mask-owner/audit.json
```

[审计 JSON](../artifacts/device/2026-11-11-eis-orc-debug-mask-owner/audit.json) 包含 **60 条固定指令检查、3 处原厂字符串引用、9 个完整窗口及各窗口 SHA-256**。容器 SHA-256 为 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`；ORC member 为 `9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6`；解码参考 SHA-256 为 `4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c`。

仍缺的是专有 `FC60/F1E3/F0000049` 的执行和完成语义、真实 DMA/MMIO 目标、硬件最终读表时间、cache/atomic 发布及安全复用条件。运行期 debug mask、DSP 映射和代码身份也未观测。本轮没有恢复 `0x18CB2C` 隐含传输完成条件，没有解除[最小原生执行前置矩阵](device-1107-native-execution-prereq-matrix.md)中的入口、缓存/SMP、撤销及恢复关卡。
