# EIS ORC 垂直 warp：帧队列接收、消费与硬件准备

本轮把既有 [表生命周期证据](eis-orc-table-lifetime.md) 从 `C49B4` 的整 `0x68` 对象交接推进到了真实下游：第二半部接收帧对象，随后从帧 `+0x18` 读取垂直表指针，调用原厂诊断命名的 `idspdrv_update_vertical_warp_field()`，准备把 **`0xC40` 字节**复制到 controlregs shadow 对象 `+0x100`。可见后续代码清除帧标志 bit 11。**尚未证明复制完成、最终硬件读表结束或任何安全释放时刻。**

所有位置均为固定 `orccode` 成员的存储偏移，非 ARM 地址或已验证的 DSP PC。没有设备访问、DSP 执行、payload 或写入器；没有套用标准 OR1K delay-slot 执行模型。普通 core 指令沿用受限 decoder，专有指令保留原始 word。

复现：

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_vertical_consumer.py
```

脚本固定 DSP SHA-256 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73` 与 decoder 参考文件 SHA-256 `4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c`，校验 95 条关键解码、6 条由 movhi/ori 直接引用的原厂字符串、19 个未解码 word，输出 [audit.json](../artifacts/device/2026-11-10-eis-orc-vertical-consumer/audit.json) 和 16 个完整窗口。字符串地址与成员偏移的 `+0x600000` 关系只用于核对引用，不证明 DRAM 映射。

## 可见对象链

令 `C` 为各函数传入的 context，`Q=C+0x4FC`。以下是相同 context 相对字段的静态生产/消费关系；真实运行中的 context 身份与调度仍需运行证据。

| 阶段 | 可见对象与位置 | 固定指令证据 |
|---|---|---|
| 既有命令处理 | 表指针写入 `lwz(C+654)+byte(C+65D)*68` 的 `+18`，元数据到 `+1C/+1D`，标志 `+20 |= 800` | 既有 `D76F4..D7710` |
| 发送帧 | `S=lwz(C+654)+byte(C+65E)*68`；`S+4=lwz(C+634)`；把完整 `68` 对象交给 staging | `C49B4..C4A2C` |
| 发送队列 | `cap_info_fid` 为 `1AC8C4(byte(C+694),3)` 返回的 16 位 handle；写入 `half[Q+48+2*byte(Q+2)]` | `C4864..C487C`, `C493C..C4950`, `C4A38` |
| 接收队列 | 从 `half[Q+48+2*byte(Q+0)]` 取同一类 handle，经 `1AFF40(handle)` 定位 staging | `D103C..D1054` |
| 接收帧 | `D=lwz(C+658)+byte(C+65F)*68`；`1A14C4(staging,D,68)`；写入索引按 `byte(C+666)` 回绕 | `D1058..D1090` |
| 接收后处理 | 调用 `1ADD2C(handle)`，再推进 `Q+0` 读索引 | `D1094..D10CC` |
| 垂直消费 | `F=lwz(C+658)+byte(C+660)*68`；检查 `F+20` bit 11，读取 `F+18/+1C/+1D` | `B30F8`, `B311C..B3138`, `B3178..B31E4` |

这里补上的第二组数组在 **`C+658`**，与发送数组 `C+654` 不同；三种索引 `65E/65F/660` 也不能混作同一个游标。既有 `65D` 生产索引与本轮发送 `65E` 的关系依然取决于调度，不能把一次回显当成某一帧必已消费。

原厂字符串分别确认发送窗口为 `send_data_to_2nd_half`，接收窗口为 `vcap_idsp_update_sec3_warp_yuv_input_fbid` 且含 `from_secondhalf_q`。发送诊断使用 `cap_info_fid`、`shcb fid`、`input_idx` 等名字。这些是帧对象/队列身份线索，尚未建立到输出 PTS、Android 回显 tag 或 warp 表所有权的映射。

`1AFF40` 是从 packed handle 计算 staging 地址的普通 core helper；其结果本身不读垂直表。整帧交接仍经过 `1A14D8` / `1A14C4` 的专有指令，故上述链是明确匹配的接口与字段关系，不是已经仿真成功的数据传送。

## 帧 `+18` 的实际消费者

在 `B3014` 窗口内，除其他 context 条件外，`B31C4..B31D0` 明确测试帧 `+20` 的 bit 11。取表路径为：

```text
B31D4  lwz r4,24(r22)       ; F+18 表指针
B31D8  addi r3,r0,0
B31DC  lbz r5,28(r22)       ; F+1C
B31E0  lbz r6,29(r22)       ; F+1D
B31E4  jal 17F1B8
```

`17F1B8` 保存表指针与两个字节，调用 `18B448(0,24)` 获得 filter24 对应的 controlregs shadow 对象。它通过三次 `18BF5C` 传递元数据；本报告不为这些位置参数发明硬件字段名。非零表指针路径随后：

```text
17F260  r4 = shadow_pointer + 100
17F264  r3 = retained_table_pointer
17F268  r5 = C40
17F29C..17F2A4  half[2B32] |= 3
17F2A8  jal 18CB2C
```

`2B32` 是该序列零高半地址构造下的相对地址值，实际内存空间身份未验证。`17F280/17F284` 直接引用 `idspdrv_update_vertical_warp_field() done.`，从而给出原厂函数名；`done` 是普通日志文本，不能替代硬件完成条件。

`18CB2C` 由原厂诊断命名为 `idspdrv_dram2dram`，对源/目的/长度执行可见的分块准备。对固定长度 `C40`，普通算术得出六块：

| 表中相对起点 | 长度 |
|---|---|
| `000` | `220` |
| `220` | `220` |
| `440` | `220` |
| `660` | `220` |
| `880` | `220` |
| `AA0` | `1A0` |

合计 `C40`，恰好按 `20` 对齐，故这个长度不进入不足 `40` 字节的 padded 尾部路径。这是固定 core 算术推导，不是 DMA 实测。它把原来仅有“保留外部指针”的结论推进为：该指针会被传入一条要求 `C40` 源范围的复制准备路径。

表路径返回后，可见控制流进入 `B3224..B3230`：重新读 `F+20`，与 `FFFFF7FF` 相与并回写，清除 bit 11。该序列没有清除 `F+18`。bit 清除只证实软件已处理该标志，无法单独证明异步硬件已停止使用源表。

在明确限定的成员 `[0,200000)` 中，语法层直接 `jal 17F1B8` 还出现于 `F8BEC/F8ED4/F9148/17FC2C/18033C/185AD4`。本轮没有宣称这些路径均可达，也没有证明本消费者是所有路径中的最后读者。

## 已识别的释放只属于帧 handle

接收端 `D1098` 调用的 `1ADD2C` 有原厂 `DSP:: relFBuf(...)` 诊断，包含 `fbp_id`、`fb_id`、`top_used_cnt`、`bot_used_cnt`。普通 core 可见它解析 handle 的 group/index/type，访问 `DB0` 系列表项 `+18`，按 type 对低 6 位及其上方 6 位计数执行减一和回写。相关临界区专有指令仍不解码。

这个释放发生在帧对象接收后，而本轮垂直消费在另一后续函数中才读取保留的 `+18`。因此 `relFBuf(cap_info_fid)` 只能提供帧 staging/handle 资源的生命周期证据，不能作为垂直 warp 表可释放的时刻。没有找到将该 handle 计数与表指针所有权绑定的字段。

## 精确的剩余阻断窗口

| 阻断位置 | 原始 word / 可见外围 | 不能据此断言 |
|---|---|---|
| 整帧发送 `1A14E0..1A14E4` | `F1E30223 F0000049`；外围 `r15=r4>>2`, `r17=r5-1` | `68` 字节传送实际完成或排序 |
| 整帧接收 `1A14CC..1A14D0` | `F1E30222 F0000049`；同类外围 | 指针及标志已对接收方可见 |
| 复制描述准备 `1A6F08..1A6F20` | `FC602007 FC602887 FC603107 FC603987 FC604207 FC605A87 F0000049` | 寄存器名、启动/完成语义 |
| 源读循环 `1A1570`, `1A1580`, `1A1594..1A1598` | `FC606000`, `F0000049`, `FC60001C F0000049`；普通 core 包含计数循环 | 最后一次实际源读发生时间、等待完成语义 |
| 目的写准备 `1A1528..1A1554` | 多个 `FC60...` word，完整窗口随 artifact 保存 | 写通道字段含义 |
| 目的写循环 `1A15D8`, `1A15E8`, `1A15FC..1A1600` | `FC606001`, `F0000049`, `FC600008 F0000049` | 目的写完成，以及源表此时是否可复用 |

由此，本轮已经确定**帧字段的实际下游消费者、filter 选择值/相对 shadow 目的区间、固定复制长度、软件标志清除和独立的帧 handle 释放**。剩余最小问题是这些精确专有窗口的传送/完成语义，以及controlregs shadow 对象 `+100..+D40` 的最终硬件使用过程；在这些证据补齐前，不能把回显、`done` 日志、bit 11 清除或 `relFBuf` 中任何一个当成 warp 表释放屏障。


后续更正：`18B448(0,24)` 中24是filter/controlregs shadow选择值，不能称为已恢复的硬件命令opcode。其class2 shadow地址计算及原厂“copied controlregs image”诊断见 [producer合同](eis-stock-producer-contract.md)。本文所述复制准备和bit清除仍不能证明硬件提交/源表释放。
