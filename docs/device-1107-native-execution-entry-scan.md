# 1.10.7 原生执行入口与指令同步入口扫描

更新时间：2026-11-12。该报告只读固定的 1.10.7 RTOS 窗口和已有 Ghidra 导出，不访问相机，不写 RAM、SD、固件或分区，也没有执行任何固件函数。

复现：

```sh
.venv-reverse/bin/python scripts/audit_native_execution_entry_scan.py
```

结果为 [`scan.json`](../artifacts/device/2026-11-11-native-execution-entry-scan/scan.json)，其 SHA-256 为 `75a1c0193a6b8d14523c23b34e0ed40feafdaf92bcfa26d9296659414c7fbcba`，原始反汇编窗口也保存在同一目录。扫描脚本 SHA-256 为 `515eaba5afa9c59ef053db553b32543db79f18c6a732162981e29b1e3bcfd892`，RTOS 窗口 SHA-256 仍为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。回执明确记录 `device_access=false`、`target_write=false` 和 `payload_or_writer_emitted=false`。

## 扫描结果

固定 A32 对齐窗口内的 10 个指令缓存操作全部能定位到已知上下文或恢复代码片段：

| 地址 | 指令 | 归属 | 直接调用者/含义 |
| --- | --- | --- | --- |
| `A03D0738` | `ICIALLUIS` | `A03D06C8` BOSS resume | BOSS 上下文恢复尾部 |
| `A03D0904` | `ICIALLUIS` | `A03D0780` BOSS restore | 恢复映射、任务和中断状态后执行 |
| `A03D20C8/2108/2148` | `ICIALLU` | 旧上下文恢复片段 | 关闭/恢复 SCTLR、TTBR 后跳到保存 PC；Ghidra 函数边界不是普通函数 |
| `A04A2880` | `ICIALLU` | `A04A283C` | 低功耗 cache lock/prefetch 候选；两个低功耗内部调用者 |
| `A04A42D4/43CC` | `ICIALLU` | `A04A41E8` | MMU 页表初始化；一个启动/内核调用者 |
| `A04A442C/4490` | `ICIALLU` | `A04A43FC` | 第二核心 MMU 初始化；BOSS/启动路径调用者 |

窗口中仍没有 `ICIMVAU (MCR c7,c5,1)`，也没有单独的 `clear_cache(start,size)` 返回函数。旧上下文恢复的三处地址不是独立函数入口：它们随后用 `mov pc,r2` 跳到保存上下文，截取调用会破坏寄存器、栈和返回条件。

## 唯一接近“可返回 callback”的两条线

**BOSS descriptor。** `A03CF01C`（Start）和 `A03CF4A0`（Resume）从固定 manager/descriptor 状态取 `descriptor+0x10` 后调用；`A03CFBCC` 返回固定 descriptor 表 `A078965C`。已审计的 callback slot 写入点只有 `A03CFCAC` 和 `A03D08E0`，都写固定的 `A03CFBD8`。该 helper 只执行 TLB 维护（`c8,c7/6/5/3`）并返回；`A0482F3C` 发送通知时读取当前 core（`A04A2990`），mode=1 使用当前 core 位的反码，调用 `A0497454` 配置目标并调用 `A0497628` 触发中断，然后释放锁。其函数体没有等待循环、generation 或状态回读，因此返回只代表通知已发出，不能作为远端 handler 完成回执。它是内部恢复机制，扫描到的 151 个 stock 命令 handler 没有直接调用它或 BOSS resume/restore。

`A03D06C8` 的入口参数是保存的 BOSS task/context；它先等待事件标志（参数 `0x40`，超时 `5000`），随后恢复上下文并返回。`A03D0780` 还要求 context+`0xAC` 的任务状态满足 `(state-2 & ~2)==0`，然后暂停/恢复任务、映射和 TCB。两者没有 caller-controlled core 参数，不能作为当前任务之外的普通同步调用。

**低功耗 dispatcher。** `A04A5410(r0,r1,r2,r3)` 在 `r0 != 0` 时执行外部传入形态的 `blx r1`，在 `r0 == 0` 时把 `r1/r2` 传给 `A04A5128`；后者在低功耗切换前后调用 callback。它确实可返回，但静态入边只有 `A049A3C8` 跳板，`A04A5294`/`A04A5470` 是内部参数引用，并非 shell/USB/Linux handler。其内部调用的 `A04A283C` 会改动 cache lock/prefetch 控制寄存器，且没有普通代码发布语义、跨核回执或 I-cache `ISB` 合同。不能把 `blx r1` 当作用户可控的代码入口。

## stock 外部 handler 穷尽范围

脚本读取已有固定 command-table 导出，逐个检查 `antscmd(69)`、`imgcmd(17)`、`ipccmd(6)`、`drvcmd(21)`、`shell(38)` 的 **151 个 handler** 与候选同步/恢复函数的直接调用边。结果为 0 个直接命中。这里的“0”只排除了固定导出中的直接边；计算函数指针、未捕获代码和 Thumb 路径仍是未知，不能作为全固件不存在间接入口的证明。

因此当前行动结论是：没有找到能由 stock 外部命令触发、正常返回并提供代码发布完成回执的入口。继续裁剪 BOSS/MMU/低功耗内部函数，或把低功耗 callback 参数当作外部 handler，都会绕过 P1/P5/P6/P10 前置条件。下一步应优先评估启动时静态集成路径；若要重新开启运行期路线，必须先单独建立运行期所有权、I-cache/ISB 顺序、跨核完成回执、指针撤销和冷启动恢复合同。

## 范围限制

扫描只覆盖固定镜像的 A32 指令、已有 Ghidra `functions/references/calls` 导出和五张已知命令表。未覆盖 Thumb 真实可达性、动态生成代码、未捕获区域、运行期页表/缓存状态、间接跳转目标和硬件执行完成性；Unicorn/静态反汇编均未被当作真机运行证据。
