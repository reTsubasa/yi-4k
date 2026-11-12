# ORC 专有传输字跨 member 交叉比对

日期：2026-11-11。本轮把 `FC60xxxx`、`F1E3xxxx` 和 `F0000049` 在 DSP 包四个 member 中做固定字节交叉扫描，并在 `orccode.bin` 的传输 helper 集中保留有限解码上下文。结果用于确认重复形态和排除范围，不为专有字赋予未经证实的 DMA、MMIO、cache 或完成语义。

复现命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_proprietary_crossmember.py
.venv-reverse/bin/python -m json.tool artifacts/device/2026-11-11-eis-orc-proprietary-crossmember/audit.json
```

结果见 [audit.json](../artifacts/device/2026-11-11-eis-orc-proprietary-crossmember/audit.json)。固定 DSP 容器 SHA-256 为 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`；`orccode.bin` SHA-256 为 `9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6`。没有执行 ORC、连接相机或写入设备。

## 交叉扫描结果

四个 member 中只有 `orccode.bin` 出现这些形态：

- `F0000049`：119 次；
- `FC60xxxx` 家族：若干次，集中在已知传输/硬件辅助窗口；
- `F1E3xxxx` 家族：集中在 staging 变体；
- `orcme.bin`、`orcmdxf.bin` 和 `default_binary.bin`：三类形态均为 0 次。

这排除了在其他已捕获 member 中直接寻找同一字节并借此命名的路径。它没有排除未捕获微码、间接硬件表或运行期外设语义。

## 本地传输簇的重复形态

在成员偏移 `0x1A14C4..0x1A1688` 内，`F0000049` 紧随多种前导字出现，包括：

| 前导字 | 可见位置/形态 | 能确认的范围 |
| --- | --- | --- |
| `F1E30222` | `0x1A14CC` | 与 128 字节 staging 入口相邻 |
| `F1E30223` | `0x1A14E0` | 与 4 字节 staging 入口相邻 |
| `F1E32222` | `0x1A1504` | 另一 staging-like 变体 |
| `FC606E06` | `0x1A1550`、`0x1A6EDC` 附近 | 描述/准备路径中的专有字 |
| `FC60001C` | 读循环末端 | 计数循环中的专有字 |
| `FC600008` | 写循环末端，多处重复 | 计数循环中的专有字 |
| `FC606F87` | 地址打包后 | 单独的专有操作 |

同一 `F0000049` 后面有时是 `jr r9`，有时是条件分支和计数更新；因此它不是普通函数返回指令。它可能是专有操作的完成/提交/序列化标记，但静态字节不足以在这些含义中选择一个。

另有 `F1E30223`（`0x1A14F4`）没有立即跟随 `F0000049`，说明“每个 staging 字都必有相同 fence”也不成立。这个差异可能来自不同调用协议或相邻数据/代码边界，不能仅凭排列推断方向。

## 仍然无法确认的语义

交叉 member 没有提供第二个已知架构或已知驱动上下文，因此没有新增可证实的低层语义。以下仍是停止条件：

- `FC60xxxx`、`F1E3xxxx`、`F0000049` 的 operand 格式和真实操作；
- 源/目的方向、物理地址、DMA/MMIO 寄存器、错误码；
- 是否等待传输完成、维护 cache、建立原子发布或执行硬件 latch；
- ORC 运行期 PC、微码身份、间接 dispatch 和这些字与具体帧的对应；
- warp/状态槽/共享反馈的最终读者及可安全复用时刻。

因此，本轮只把“专有字只出现在 `orccode.bin`、并在本地传输簇重复出现”建立为有界事实；没有解除 EIS 最小原生执行或算法替换关卡。

