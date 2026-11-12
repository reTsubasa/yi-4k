# ORC 不透明 staging helper 的参数与写集边界

日期：2026-11-11。本轮对固定 1.10.7 ORC member 做直接调用图、参数形态和原始字窗口审计。没有执行 ORC、连接相机、访问 `/dev/mem` 或写入设备。

复现命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_staging_helper_scope.py
```

结果见 [audit.json](../artifacts/device/2026-11-11-eis-orc-staging-helper-scope/audit.json)。ORC member SHA-256 为 `9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6`。

## 直接调用图与参数

固定 member 中两个 staging 入口的直接相对调用数量为：

| 入口 | 候选调用数 | 既有工作假名 |
|---|---:|---|
| `0x1a14c4` | 428 | 128 字节 staging 候选 |
| `0x1a14d8` | 1151 | 4 字节 staging 候选 |

在每个调用点从上一个直接调用/返回边界开始追踪最后一次 `r3/r4/r5` 赋值，只有 5 个调用显式使用 `0x2a20`：

| 入口 | member offset | `r3` | `r4` | `r5` |
|---|---|---|---|---|
| `0x1a14c4` | `0xd76b8` | `0x2a20` | `r10` | `80` |
| `0x1a14c4` | `0xd78b4` | `0x2a20` | `sp-68` | `4` |
| `0x1a14c4` | `0xd7930` | `r11+0x2a20` | `r16` | `64` |
| `0x1a14d8` | `0xd78e4` | `0x2a20` | `sp-72` | `4` |
| `0x1a14d8` | `0xd7a90` | `0x2a20` | `sp-64` | `64` |

这 5 个调用覆盖不同长度和不同源/目的寄存器。`0x2a20` 是共享区域参数线索，但仅凭参数无法确定 copy 方向，也不能将它们全部命名为 feedback、pre-clear 或完成通知。

## helper 本体

两个入口的固定字窗口都呈现相同结构：

```text
l.srli  r15,r4,2
l.addi  r17,r5,-1
<两个未被当前 ORC decoder 支持的字>
l.jr    r9
```

原始不透明字为：

```text
0x1a14c4: 22 02 e3 f1, 49 00 00 f0
0x1a14d8: 23 02 e3 f1, 49 00 00 f0
```

因此当前可见写集为空：窗口中没有标准 `l.sw`、`l.sb`、`l.sh`、`l.lwz`、`l.mfspr` 或 `l.mtspr`。两个入口只在不透明 opcode 的一个字段上不同；这不足以判断方向、DMA、cache barrier 或硬件 latch。

## 结论

本轮把“可能参与 shared feedback 的不透明 staging 调用”收窄到 5 个可复查的参数形态，并确认 helper 本体无法用现有标准解码器给出内存目的地或完成语义。没有从 helper 本体发现直接写 `shared+0x3c` 的标准指令。

仍需解决的边界是专有 opcode 的真实语义、DMA/MMIO 目的地址、完成/缓存顺序、间接分派和运行期 ORC 身份。在这些证据闭合前，不能把任何 staging helper 当作安全的 EIS publication、ack 或旧槽释放点，也不能执行自定义 EIS。
