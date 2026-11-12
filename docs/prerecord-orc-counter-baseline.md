# H.264 counter：调用点、头前后快照和未闭合的基线

固定 1.10.7 DSP 镜像中的原码现在已连到初始化、首 slice 头前后快照、low-delay 输出和最终 `picture+0xF4` 更新。**仍不能证明 `0x1A1830` 返回的是绝对计数还是逐 picture 计数，也不能据此保证一个描述符的范围包含 SPS/PPS 和完整 IDR。** 本轮没有猜测专有指令名称或语义。

复现脚本：[prerecord-orc-counter-baseline.py](../scripts/prerecord-orc-counter-baseline.py)。完整原始字、解码窗口和断言见 [audit JSON](../artifacts/device/2026-11-10-prerecord/prerecord-orc-counter-baseline-audit.json)。地址均为 `orccode.bin` 成员偏移，未假定为已验证的 DSP PC。

输入继续固定为 DSP 包 SHA-256 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`、核心编码参考 SHA-256 `4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c`。本轮没有访问设备、执行 ORC、读取真实帧或用成品 MP4/avcC 反推 producer。

## 1. getter 的所有直接编码调用点

对整个 3,036,411-byte 成员逐四字节扫描直接 JAL 编码，`0x1A1830` 的调用位置只有三个：

| 位置 | 调用后的可确认用途 |
| --- | --- |
| `0x163724` | 通用 getter `0x1636AC` 的 H.264 discriminator 分支，将返回的 `r11` 经 `r10` 原样返回 |
| `0x178B54` | 原厂 `eng0_h264enc_lowdelay_ex_code_send2dram` 路径，计算 `(r11+7) >> 3`，再结合 control 的 bits base `+0x0C` 和 write offset `+0x14` |
| `0x178F80` | FinalBS 将返回值保留到 `r20` 和 `r14`，随后读取四个 indexed helper 值并作差 |

通用 getter `0x1636AC` 有四处直接编码调用：`0x163444`、`0x163C64`、`0x163D20`、`0x179184`。其中第一处提供 header 快照，第三处是上一轮已经固定的描述符生成路径，第四处提供最终 `picture+0xF4`。`0x163C64` 的另一路会把返回量右移 9、再左移 6 并减 64，之后进入两个未知字；不能给它补上硬件副作用。

这是整个成员的对齐编码清单，包含数据区；它不等于已恢复的运行期调用图，也不排除间接调用。

## 2. SPS/PPS 之后、slice header 之前的快照

原先 [参数集路径](prerecord-orc-parameter-set-output.md) 和 [IDR 条件不变式](prerecord-orc-idr-header-invariant.md) 已确定 SPS、PPS 和 NAL5 的生产选择。本轮在相同 `eng0_genHeader` 函数内补齐计数快照位置：

1. SPS、PPS 分别经 `0x163278`、`0x163310` 调用共同输出函数 `0x177004`，传入的 picture 参数均为 `r12`。
2. `0x16339C/0x1633A0/0x1633A4` 判断 `picture+0x10A`；值为零的路径进入 `0x16343C`。
3. `0x163444` 调用通用 getter；`0x163448` 将返回的 `r11` 写到同一 `picture+0xFC`，随后跳回 `0x1633A8`。
4. slice header 生成和 NAL 构造之后，`0x16340C` 再以同一 picture 调用 `0x177004`。

因此，在已恢复的 IDR 首 slice 路径里，**源码控制流上的顺序为 SPS/PPS 提交调用 → `picture+0xFC` 快照 → slice header 提交调用**。参数集调用和 slice header 调用使用同一 picture、同一个输出 helper。这里的“提交调用”仅表示静态调用边界；不证明硬件写出完成、相同硬件 FIFO 或同一 ring 区间。

## 3. FinalBS 确实计算差分，但最终字段仍写 getter 原值

`0x178F80` 的快照保存在 `r20`。另一路 `r14` 在四轮循环中，每轮调用 `0x1A187C(index)` 并减去返回值；index 从 0 递增到 3。原厂诊断将相邻记录称为 `CABAC_DATA_ID` 和 `CABAC_BITS`，但 indexed helper 本身仍含未知扩展指令。

接着：

```text
0x179020: call opaque helper 1A1824
0x179028: load picture+FC
0x179038: r5 = retained_getter_snapshot - picture+FC
0x179040: r22 = r5 - 40
```

这些值参与后面的 padding 算术，并可到 `0x1790D8 → 0x1A183C`，该 helper 的真实输出操作同样未知。不能将上面的局部差分直接命名为最终帧长。

最终 `0x179180/0x179184/0x17918C` 是把 picture 传给通用 getter，再将其**返回原值**存到 `picture+0xF4`。该 store 前没有直接做 `getter-picture+FC`。上一轮已经固定描述符普通长度为 `ceil(picture+F4/8)`；现在仍缺硬件 getter 基线，不能把这个关系升级为已证明的逐帧字节范围。

多 slice 路径还会在 `0x164F20` 清零 `picture+F4`，在 `0x164FB4` 写入经过对齐算术转换的值，并在 `0x164F80/0x164F84` 经过两个未知字。它不能与普通路径合并成已验证的聚合模型。

## 4. 找到了零输入 wrapper，未证明逐帧 reset

逐 picture 函数在 H.264 路径经 `0x1650C4 → 0x178388` 进入原厂 `eng0_init_h264`。但初始化内部的分支还取决于 `picture+0x20 bit0` 和 instance control word0 的 bit5：

- 一条分支将 control bit5 置位，随后在 `0x17865C` 调用 `0x1A1850(0)`，在 `0x178664` 调用 `0x1A1814(0)`；循环还以 index `0..3` 及 `12..15`、第二参数 0 调用 `0x1A1868`。
- 另一条分支在 `0x1786F8` 调 `0x1A185C`；部分条件下改经 `0x1A14C4` 从 `0x13010` 读取保存值。原厂字符串明确称为 `cin_bitcnt load from smem to cmem`。
- 对应的备份路径 `0x164140..0x164180` 也调用 `0x1A185C` 并保存到 `0x13010`，原厂字符串为 `cin_bitcnt backup from cmem to smem`。

零参数只是已确认的输入。专有 wrapper 内的 `F0030C0B/F003240B/F0000089` 等字仍未解释，**不能称为已验证的 output counter reset，更不能保证每个 frame/slice 前都会 reset**。`cin_bitcnt` 诊断也不能自动替换成另一个 getter 的输出计数器语义。

在初始化的另一处，control `+0x14` write offset 被分解、打包，再进入 `0x178528/0x17852C` 的未知字。它为“配置偏移参与硬件设置”提供具体邻近证据；没有给出未知字的硬件地址空间或写入语义，仍不足以闭合同一个 base/offset。

## 5. 最小缺口与已验证范围

最小 getter 缺口保持为 `[0x1A1830,0x1A1838)` 的 **8 bytes**：

```text
1A1830  F160240C  unknown
1A1834  F0000089  unknown
```

除 getter 外，本轮将相邻 wrapper、初始化 offset 设置和 multi-slice 调整中的 **29 个未知字位置**按原值固定，没有扩展 decoder 或赋予它们推测语义。检查通过 **142 条核心指令断言、8 个目标/18 个直接调用、7 条精确原厂诊断及引用、15 个完整窗口 hash**。

“计数复位/计数基线、实际输出地址和完成时序、descriptor 中 NAL7/8/5 的实际包含关系”仍需要真正的专有指令证据或获得授权的硬件观测。为继续推进可用代码，本轮另外实现并验证了[独立 payload 复制适配候选](prerecord-payload-copy-candidate.md)，其合同要求调用者事先具备稳定的可读映射和可信 ring bounds；它不假装已经解决这些硬件问题。

```sh
.venv-reverse/bin/python scripts/prerecord-orc-counter-baseline.py
```
