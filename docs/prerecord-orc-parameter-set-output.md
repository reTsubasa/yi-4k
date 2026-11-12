# ORC 参数集：从生成函数追到专有输出边界

本轮在固定 DSP 镜像中，首次把原厂 SPS 结构生成、参数集序列化、明确的 **NAL 类型 7/8** 和共同输出 helper 连成具体路径。输出路径已经缩到 `0x1A1794`；该 helper 内尚未解码的八个指令位置阻断了“最终字节被提交到哪个 FIFO/ring”的证明。

同时定位了进入参数集生产路径的三个原始 picture 字段。它们的 gate 在两种显式假设的分支模型下得出相同结果；**尚未证明这些 picture 字段与 CPU 的 `sps_pps_header_mode`、ORC encoder-state `+0x50C bit21` 或 mux `type=1` 的对应关系**。因此本轮没有把 mode0/1 定义为重复头开关，也不宣称每个同步帧都会带参数集。

复现脚本：[prerecord-orc-parameter-set-output.py](../scripts/prerecord-orc-parameter-set-output.py)。结果：[audit JSON](../artifacts/device/2026-11-10-prerecord/prerecord-orc-parameter-set-output-audit.json)；保留指令窗口：[ASM](../artifacts/device/2026-11-10-prerecord/prerecord-orc-parameter-set-output-audit.asm)。本轮没有连接设备、写入真机、使用成品 MP4/avcC 倒推生产者或执行 ORC 微码。

## 镜像和可复查定位

所有地址均为 `orccode.bin` 成员内偏移，不是已验证的 DSP PC 或 ARM 地址。输入沿用已有严格 ROM directory/CRC inventory 和核心编码参考：

- DSP 包 SHA-256：`9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`。
- decoder 参考 SHA-256：`4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c`。
- `0x2B499C` 的完整诊断为 `ENG0: === eng0_GenerateSequenceParameterSet() (sps != NULL)\n`；`0x1734E4/0x1734E8` 构造 `0x8B499C`，与字符串成员偏移差 `0x600000`，随后调用共同日志 helper `0x19FE44`。
- 该诊断属于入口 `0x1730D0` 的空目标断言分支；正常路径将传入 `r3` 保存为 SPS 结构目标，将 `r4` 保存为输入配置。不是仅凭源文件名给一片代码命名。

## 生成、序列化、NAL 字段和输出链

`0x1630B8` 函数保存输入 picture 对象为 `r12`，局部 NAL 对象为 `r20=picture+0x64`，其 payload 起点为 `r20+8`。

| 阶段 | SPS 路径 | PPS 路径 |
| --- | --- | --- |
| 结构目标 | `0x163220`：由编码上下文和索引得到 `+0xAC` 的目标 | `0x1632A4`：由同一上下文和索引得到 `+0xBC` 的目标 |
| 构造结构 | `0x163230 → 0x1730D0`，已用精确原厂诊断确认 SPS 身份 | `0x1632C0 → 0x173544`；其身份由后续 NAL8 路径约束 |
| 参数集序列化调用 | `0x163248 → 0x173ED4`，输出参数 `r7=r20+8` | `0x1632DC → 0x1744A4`，输出参数同样为 `r20+8` |
| 传递长度/类型 | 返回值 `r11 → r5`；`0x163258` 设置 `r6=7` | 返回值 `r11 → r5`；`0x1632F0` 设置 `r6=8` |
| 建 NAL 对象 | `0x16326C → 0x172D24` | `0x163304 → 0x172D24` |
| 共同输出 | `0x163278 → 0x177004` | `0x163310 → 0x177004` |

`0x172D24` 保存传入的 type 参数，`0x172E20/0x172E2C` 取其低四位并移到对象 word0 的 bits11..14；`0x172E3C` 写回 word0，`0x172F98` 将 payload bit-length 写入 word1。这里是具体的字段赋值，不是因为某个局部常数等于 7/8 就断言 NAL 类型。

`0x177004` 从同一 word0 提取 header 字段：`0x177024/0x177030` 取 bits11..14；word1 则作为长度传下去。它将 payload 指针设置为 NAL 对象 `+8`，调用 `0x176EFC`。后者处理尾 bit 与四字节组的字节顺序，再于 `0x176FF0` 调用 `0x1A1794`。该调用前，`r3` 为 payload，`r4` 为整 32-bit 组数，`r5` 为余 bit 数，`r6=1`，`r7` 为先前提取的 header byte 字段。

这条链证明了静态生产路径已到提交边界；不能据此声称 helper 已在真实帧上执行、输出目的地址已恢复或实际字节必然以 Annex-B start code 开头。

## 是否生成参数集的具体 gate

进入 `0x16318C` 的前提取值来自 `picture+0x10 bits28..29`。为了不把未知枚举误命名为现有 CPU header mode，下表只用临时字母：

| 临时名 | 原始位置 | 读取与判断 |
| --- | --- | --- |
| M | `picture+0x10 bits28..29` | `0x163150/0x163154`；gate 要求等于 1 |
| C | `picture+0x20 bits4..5` | `0x16318C..0x163198`；比较数值 2 |
| R | `picture+0x20 bit7` | `0x1631BC..0x1631C4`；比较非零 |
| F | `picture+0x28 bit11` | `0x1631A0..0x1631AC` 和 `0x1631CC..0x1631D8`；比较非零 |

该有限区间选择 `0x1631E0` 参数集生产路径的条件可写为：

```text
M == 1 && (F || (C == 2 && R))
```

脚本对 M/C 各 0..3、R/F 各 0/1 的 **64 个宿主构造组合**，分别按“无分支延迟”和“执行一条延迟指令”的显式模型解释匹配的核心读取、位运算和条件分支，共 **128 组有限解释**；两者结果相同。所有解释只涉及固定短窗口，没有调用 helper、解释未知扩展字或把宿主运算当作相机实测。`picture+0x14` 在假设延迟模型的末分支中可能被读取，但该读取结果不影响本段 gate；脚本将它构造为 0。

例如，在 `M=1, C=2, F=0, R=0` 时会绕过 SPS/PPS 生产路径；`R=1` 才进入。**C=2 尚未证明为编码 IDR，M=1 也不是已证明的 `sps_pps_header_mode=1`。** 因而即使将来恢复 C 的枚举，也还需要恢复 R/F 的来源，不能仅凭“关键帧分类成立”跳过参数集验证。

这是指令模型的有界一致性检查，不是 ORC 执行模型已确认的证明。已有核心编码审计明确禁止默认套用普通 OR1K 的延迟槽行为，本轮保留该限制。

## 现在真正卡住的最小输出窗口

`0x1A1794` 是实际输出链最后一个已连通 helper。其开始两次设置 `r8`，分别为 `31` 与 `7`，随后遇到核心 decoder 不支持的字：

| member offset | 原始 little-endian word | 前后已解码上下文 |
| --- | --- | --- |
| `0x1A17A4` | `F0083012` | 前面构造 `r8=31`；输入 `r6=1` |
| `0x1A17A8` | `F0000089` | 第一处未知操作之后 |
| `0x1A17B4` | `F0083812` | 前面构造 `r8=7`；header 字段在 `r7` |
| `0x1A17B8` | `F0000089` | 第二处未知操作之后 |
| `0x1A17D8` | `F0085832` | 整组循环从 payload 读取 `r11` 后 |
| `0x1A17DC` | `F0000089` | 整组未知操作之后 |
| `0x1A1800` | `F0055832` | 余 bit 路径从 payload 读取 `r11`、长度 `r5--` 后 |
| `0x1A1804` | `F0000089` | 余 bit 未知操作之后 |

优先恢复的最小前缀窗口为 **`[0x1A179C,0x1A17BC)`，32 bytes**，包含四个未知位置、三个不同的原始编码。寄存器和位数的形态与输出前缀/header 有关，但本轮不给这些专有指令杜撰名称，也不把 `F0000089` 擅自解释为 barrier、flush 或 FIFO push。末端字节、ring 目标及缓存完成语义均仍缺证。

独立于这些专有指令，下一条可验证路径是沿 `0x164ED0`、`0x164FDC` 两处调用者恢复 picture 对象的创建/复制来源，追 `+0x20 bit7` 和 `+0x28 bit11` 的上游赋值。**这个问题的 gate 完全可用现有核心 decoder 读取，不依赖先猜最终输出指令。** 若能连到 encoder-state 或 CPU 命令字段，就能进一步判定何种原厂配置会在什么帧上进入参数集生产分支。

## 验证范围

脚本通过 **74 条核心 opcode 断言、64 个输入组合/128 组有界 gate 解释、8 个未知输出字断言、9 个完整小窗口 hash**。另外按整个成员的四字节对齐位置清点相关直接 JAL 编码：SPS builder、第二参数集 builder 各一处，外层生产函数两处。它是直接编码清单，未解决间接调用，也不冒充完整运行期调用图。

CPU 默认 AU=0、CPU header mode 的已测构造值为 0，沿用 [AU 来源](prerecord-h264-au-provenance.md) 和 [header contract](prerecord-h264-header-contract.md) 的有限结论。本轮没有把它们与新定位的 M/C/R/F 合并。一分钟预录、相机语音/快门触发、ring 保帧与最终可播放文件仍需各自完成。

```sh
.venv-reverse/bin/python scripts/prerecord-orc-parameter-set-output.py
```
