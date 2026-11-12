# 垂直 warp `done` 日志与传输完成边界

日期：2026-11-11。本轮检查原厂字符串 `idspdrv_update_vertical_warp_field() done.` 与其调用窗口，确认日志出现前的可见日志门控和复制分支。该证据只说明日志控制流，不把日志升级为硬件 DMA 完成、cache 同步或旧表释放确认。

复现命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_vertical_done_log_gate.py
.venv-reverse/bin/python -m json.tool artifacts/device/2026-11-11-eis-vertical-done-log-gate/audit.json
```

## 固定字节关系

在 `orccode.bin` 成员偏移 `0x17F27C..0x17F2AC`：

```text
0x17F26C..270  若 source != 0，进入 0x17F29C 的复制分支
0x17F29C..2A4  设置 r18+0x2B32 的低位
0x17F2A8       调用 0x18CB2C（idspdrv_dram2dram）
0x17F2AC       跳到 0x17F27C 的日志门控
0x17F27C       r6 = lwz(r18 + 120)
0x17F288       r5 = r6 & 3
0x17F290       若 r5 == 0，直接跳到 0x17F2B0 退出
0x17F294       否则调用 logger 0x19FE44，随后退出
```

日志字符串位于 `0x2B7BA9`，其地址由 `0x17F280/0x17F284` 构造。复制返回后会进入日志门控；source 为零的路径也会进入同一个门控而不执行复制。因此，`done` 日志由 `r18+120` 的低两位非零条件控制，并非读取硬件完成标志的循环；该窗口不存在从日志门控回到复制分支的边。

`0x18CB2C` 的可见调用链仍是：按不超过 `0x220` 的块调用 `0x1A46A0`（`dram_2_smem`）和 `0x1A4A04`（`smem_2_dram`），尾部路径再调用 `0x1A4A04`。在本轮固定窗口内没有标准 done-register 轮询。`r18+120` 和 `r18+0x2B32` 的完整对象类型与硬件所有权尚未恢复。

## 能确认与不能确认

能确认的是：日志存在明确的低两位输出门控；source 非零时复制 helper 返回后进入该门控，source 为零时也可直接进入。零 gate 跳过日志，非零 gate 打印 `done`；二者随后均退出。这里没有完成轮询或复制重试。

不能确认的是：`r18+120` 是否由硬件更新、是否代表 DMA/IDSP 完成、`0x18CB2C` 是否等待专有传输完成、缓存/原子发布是否已经完成，以及硬件是否仍持有源 warp 表。`done` 字符串、bit 清除和 helper 返回都不能单独作为旧表释放屏障。

因此本轮没有解除 EIS 最小原生执行关卡。下一步若要推进，只能先恢复 `r18+120` 的生产者/写入者、`0x18CB2C` 返回条件和运行期状态关联；在此之前不应替换 warp、覆盖状态槽或释放表源。

后续[调试 mask 所有者审计](eis-orc-debug-mask-owner.md)已恢复 `+120` 为 `+0x64` debug-level 数组的 module 5 元素，并定位原厂 `setDebugLevel` / `addDebugLevel` 和多处直接配置写入；本报告中“该字段完整对象类型未恢复”的历史边界由该审计进一步收窄。传输完成、最终硬件读者和安全释放仍未恢复。

