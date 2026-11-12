# DSP IDR 分类到 CPU FrameDesc：类型、地址与长度合同

本轮连通了 **ORC 正常 H.264 编码的 IDR 分类 → 64-byte bits_info → ARM event → 32-byte FrameDesc type=1**。该 IDR 位组合与前轮的 NAL5/SPS/PPS 选择条件相同。原生预录适配器因此有了具体同步候选判据，但仍必须先排除结束哨兵、复制有所有权的 payload，并验证实际 NAL7/8/5。

同时恢复了描述符的起点和长度来源：普通路径报告 `bits_fifo_base + write_offset`、`ceil(picture+0xF4 bits / 8)`；另有 property 模式覆盖起点和长度。**尚未证明该硬件 counter 的 reset/baseline，以及 SPS/PPS 和 slice 最终处于同一 descriptor 范围**。本轮没有把静态参数集生产选择升级为实际字节包含保证。

复现：[prerecord-dsp-framedesc-contract.py](../scripts/prerecord-dsp-framedesc-contract.py)。结果：[audit JSON](../artifacts/device/2026-11-10-prerecord/prerecord-dsp-framedesc-contract-audit.json)。新增 [SDK 布局定义](../sdk/yi4k_1107_video_descriptor.h) 仅包含已经核对的字段、偏移和哨兵，没有安装 hook 或设备访问函数。

## 最短证据链和固定输入

本轮从既有 [ARM 视频生产者](prerecord-video-producer-audit.md) 的已执行合同反向定位 ORC `eng0_send_bits_info(0x163CB0)`，避免猜未知输出 op。输入保持固定：

- CPU RTOS 镜像 SHA-256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- DSP 包 SHA-256：`9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`。
- 核心 decoder 参考 SHA-256：`4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c`。

ORC 地址都是成员内偏移，不是 ARM 指针或已经观察的 DSP PC。本轮没有连接设备、写真机、执行 DSP/DMA/消息队列，也没有使用成品 MP4/avcC 反推生产者。

## 正常描述符 type1 与 NAL5 的对应

前轮 [IDR 首 slice 审计](prerecord-orc-idr-header-invariant.md) 已恢复 picture 的三个字段：H.264 discriminator `M=picture+0x10 bits28..29`、`C=picture+0x20 bits4..5`、`R=picture+0x20 bit7`。同一 `C=2,R=1` 位组合既选择切片 NAL5，也强制选择 SPS/PPS 生产。

本轮 `eng0_send_bits_info` 的正常状态分支使用完全相同组合：

| ORC 位置 | 具体行为 |
| --- | --- |
| `0x163D70..0x163DAC` | 从当前 picture 提取 C、M、R；只有 `C=2,M=1,R=1` 将局部 IDR predicate `r10=1` |
| `0x163DF8/0x163DFC` | predicate 非零跳到 `0x164424` |
| `0x164424/0x164428` | 保留 picture+0x20 的 word，设置 `r4=1` |
| `0x16442C → 0x163E20` | 进入共同字段写入 |
| `0x163E20..0x163E38` | 清局部 bits_info `+0x14` word 的低三位，再 OR 上 `r4`，写回 |

正常 H.264 路径的低三位分类表为：

| picture 条件 | bits_info+0x14 低三位 | 本轮可命名的范围 |
| --- | --- | --- |
| C2/R1，且 M1 | 1 | 与该路径的 NAL5/IDR predicate 相同 |
| C2/R0 | 2 | 非 IDR 的 C2 类；不与 type1 混称 |
| C0 | 3 | 原始分类值；本轮不扩展枚举语义 |
| C1 / C3 | 4 | 原始分类值；本轮不扩展枚举语义 |

脚本对 picture+0x20 low byte 的 256 值解释上述短核心区间，并检查分类表；这是**显式无延迟分支模型下的宿主解释**。只对 IDR 赋值子集，另按一条延迟指令模型复查，结果也为 type1。完整 ORC 执行模型仍未恢复；不能把所有其他分类的无延迟解释当作真机运行结果。

ARM 原厂适配器的传递没有重分类：

```text
bits_info[+0x14] & 7
  → A02CA9B8/A02CA9D0/A02CA9D4
  → event4[+0x1C]
  → A046CB2C/A046CB38
  → FrameDesc[+0x10] byte
```

本轮实际执行原 ARM ring→event 前缀与正常 callback 到 FIFO write 前，验证 type1/2/3/4 原值传递、raw bit7 与高层 flags 的区别、1023→0 ring 回绕和 payload 地址/长度传递。高层 `FrameDesc+0x11` 原厂填 1，不能将其当作 raw descriptor bit7 的直接副本。

## 结束哨兵也可能带 type1

`eng0_send_bits_info` 非正常状态走 `0x164454`，用真实 memset helper 参数 `value=-1,size=64` 填整项 FF，再在 `0x164494..0x1644AC` 修改 type/flags，**低三位同样设为 1**。所以 `type==1` 本身不能作为正常 IDR payload 的充分验证。

低层 raw `bits_info+0x18 == 0xFFFFFFFF` 是结束长度。ARM `A0460754` 的 `A04607A4..A04607C4` 将 event 长度归一为 `0x00FFFFFF`，再继续高层转发。脚本单独执行了这段原始归一化区间，未执行前面的 mutex、完整 BitsMgr 或结束 callback。

因此适配器面对两种不同层次，必须使用各层哨兵：

| 层次 | 长度字段 | 结束标记 |
| --- | --- | --- |
| DSP 64-byte bits_info | `+0x18` | `0xFFFFFFFF` |
| BitsMgr 后的 event / FrameDesc | event `+0x24` / FrameDesc `+0x18` | `0x00FFFFFF` |

SDK 常量明确区分两者。正常同步候选是排除 EOS 后的 type1；它仍需 payload 合法性检查。

## 起点、长度、ring 和发布

在 `eng0_send_bits_info` 内，`r14` 保存当前 picture，`r16` 保存编码实例，`*(r16+0x4C)` 是 FIFO 控制对象，局部 64-byte bits_info 从 `[r2-0x40]` 开始。

普通路径的地址和长度由原始核心指令形成：

| 字段 | 来源与赋值 |
| --- | --- |
| bits_info `+0x10`，payload start | `0x163D10` 取 control+0x0C 的 bits base，`0x163D04` 取 control+0x14 的 write offset，`0x163D1C` 相加，`0x163F28` 写局部 `+0x10` |
| bits_info `+0x18`，payload length | `0x163CEC` 取 picture+0xF4，`0x163CFC/0x163D08` 做 `(value+7)>>3`，`0x163F2C` 写局部 `+0x18` |
| 特殊 property 覆盖 | 若 picture+0x20 bits26..27==1，`0x163F18..0x163F24 → 0x164394`；start 改取 picture+0x54，length 改取 picture+0x58 的低24位 |

正常源路径的长度是 snapshot，不能把 `picture+0xF4` 错当作已证明的整帧最终字节数。`0x179184/0x17918C` 在 `eng0_genFinalBS` 中调用 counter helper 并把结果写入该字段；H.264 helper `0x163724` 调到 `0x1A1830`，其两条指令字 **`F160240C / F0000089`** 仍不在核心 decoder 范围。本轮没有给它们编造 read/reset 语义。最小尚未知的 counter getter 窗口是 **`[0x1A1830,0x1A1838)`，8 bytes**。

写入信息 ring 的链已恢复：

1. `0x163F94..0x163FB0` 读取 control 的 info staging pointer `+0x24`、info ring base `+0x18` 与 info write offset `+0x20`，计算目标。
2. `0x163FB4` 用 `0x1A14D8` 将局部 64-byte descriptor 提交到 staging 区。
3. `0x163FC4` 调用 `0x1A4A04(staging, info_base+info_offset, 64)`。该 helper 的精确原厂诊断 `0x1A4B80/0x1A4B84 → 0x2C2579` 为 `smem_2_dram(), size is not multiple of 4 (%d)`，不是仅凭调用参数给 DMA 命名。
4. `0x1640C0..0x1640D8` 将 info write offset 加 64，再对 control+0x1C 的 info ring 字节数取模。bits write offset 的另一支在 `0x16409C..0x1640BC` 用已对齐的 counter 量推进，再对 bits ring 字节数取模。
5. 另一个 `eng0_send_arm_msg_to_smem(0x163748)` 构造通知码 `0x82000001`，正是既有 ARM ring handler 处理的消息。通知携带生产计数；**真实 queue/DMA 顺序和完成可见性不在本轮执行范围**。

ARM 从固定 `1024 × 64` 项 ring 取 entry，先用 `A04A3BD4` 转换 payload 地址，再把地址和长度送到高层；上层 FrameDesc 没有因为本轮类型关联而获得额外 payload 生命周期保证。

## 对 native 适配器的具体约束

目前可以按真实结构规划适配器：优先旁路原厂 FrameDesc/virtual FIFO，保留经过原厂回绕修正的 PTS；先排除高层 EOS，type1 只作为候选同步入口；复制 descriptor 和 payload 后，再按 ring 上下界检查 NAL7/8/5、长度和回绕。raw DSP 地址不得直接作为 CPU 指针解引用，也不能绕过原厂 cache/ownership 合同。

尤其不能从“原厂会选择生成 SPS/PPS”直接跳到“本 descriptor 长度一定覆盖 SPS/PPS+IDR”。仍需闭合：硬件 counter 的 reset/baseline、头和切片是否共用同一输出计数器、特殊 property 覆盖路径、slice 聚合，以及实际 ring 区间。SDK 布局头没有把这些未知内容伪装成可执行 API。

本轮通过 **86 条 ORC 核心断言、15 条 ARM 断言、256 个类型宿主解释、6 个地址/长度算术解释、7 个原始 ARM 执行用例**，并保存10个相关窗口；SDK 头通过 C11 `-Wall -Wextra -Werror` 编译布局检查。所有输入 RAM 为宿主构造，执行在 event dispatch/FIFO write 前停止；没有真实 DMA、FIFO 消费、视频字节或机内预录输出。

```sh
.venv-reverse/bin/python scripts/prerecord-dsp-framedesc-contract.py
cc -std=c11 -Wall -Wextra -Werror -fsyntax-only -x c sdk/yi4k_1107_video_descriptor.h
```
