# 预录首同步帧：H.264 参数集生产配置审计

本轮离线恢复了 CPU 的具体参数集配置字段和部分 ORC ENC_START 处理路径，但**没有证实“每个 mux type 1 描述符都包含 SPS/PPS”**。CPU 中存在原厂命名的 `sps_pps_header_mode`，本轮执行的命令构造路径将其保留为 **0**；当前没有恢复出 0/1 对重复参数集的准确语义，不能将这个值宣称为“每个 IDR 插头已开启”。

复现脚本：[prerecord-h264-header-contract.py](../scripts/prerecord-h264-header-contract.py)。结果：[prerecord-h264-header-contract-audit.json](../artifacts/device/2026-11-10-prerecord/prerecord-h264-header-contract-audit.json)。固定 CPU 镜像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`；使用已有库存 DSP 镜像、严格 ROM inventory 与已验证的 ORC 核心 decoder，未安装工具、连接设备或写入真机。未使用成品 MP4/avcC 反推生产者，也未生成合成码流作为设备证据。

## CPU 字段、来源和赋值时机

`H264ENC_SETUP(A02B7454)` 和 `H264ENC_START(A02B7914)` 是不同命令。SETUP 中可以看到 GOP 的 M/N、`idr_interval`、bits/info FIFO 等字段，但“存在 IDR 间隔”并不等于重复参数集。

START wrapper 的真实 `MOV #2; MOVT #0x200; STR` 将 command 首字置为 `0x02000002`。该命令的原厂打印代码给出了字段的明确名称和位宽：

| START 位置 | 原厂打印名称 | 原始指令证据 |
| --- | --- | --- |
| `+0x39` byte | `au_type` | `A02B7914` 诊断路径 |
| `+0x3A bit0` | `sync_with_piv` | `A02B7BB4` 读取后 AND 1 |
| `+0x3A bits1..4` | `rc_init_complexity` | `A02B7BC8` 读取，UBFX 1,4 |
| `+0x3A bit5` | `sps_pps_header_mode` | `A02B7BDC` 读取，`A02B7BE8 UBFX 5,1`，字符串 `A05BA3B8` |
| `+0x3A bit6` | `sync_with_vcap` | `A02B7BF0` 读取，UBFX 6,1 |
| `+0x3A bits7..9` | `smvmax_scale` | `A02B7C04` 读取 halfword，UBFX 7,3 |

真实命令构造器 `A02D296C` 在尚未启动的编码 context 分支，于 `A02D2ACC..A02D2ADC` 将栈 command `[sp+0x28,sp+0x88)` 用原 memset 清零，后续填充，再在 `A02D2DA4` 调用 START wrapper。已启动 context 走另一个 update 命令 `A02B8044`，不能混称为每次切 MP4 都重新发 H264ENC_START。

对 `cmd+0x3A`，可见后续赋值涉及 sync bit0、复杂度 bits1..4、scale bits7..9、encoder/pipeline bits10..11，未将 header bit5 从零置一。特别是 `A02D3080 BFI #1,#4` 修改的是 rc complexity，不能因为其中包含数字 5 就解释为 header bit5。脚本同时记录实际覆盖此字节的全部写入位置和写值。

`au_type` 有独立来源：`VideoEnc` context `+0x97` → `A046C6C4/A046C6C8` → start-config `+6` → command `+0x39`。它没有被当作 SPS/PPS header bit。当前尚未恢复 `context+0x97` 的 App 配置来源、枚举值语义及真机当前值；不能将 `au_type=0/1/255` 的构造用例作为相机实际 AUD 设置。

启动调用链可见 `VideoEnc_StartEncodeImpl(A046E788)` 先构造 start-config（`A046C454`）、执行 setup `A02D28D0`，再调用 `A02D296C`；另一个低层调用者为 `A0458914`。原生 event 3 只切 mux 文件的链没有因此变成编码器重新启动。由此，首段启动参数与后续每段同步帧是否带头是两项不同合同。

## 原始指令执行结果

脚本共 **48 组执行检查**，不替换 helper：

- 36 组从 `A02D2ACC` 执行真实 memset、模式分支和原 helper，到实际提交调用 `A02D2DA4` 前停止。构造 system mode `0/5/6`、fps `30/120/300`、主/次 stream、pipeline 数 `1/2`，并构造不同 syscfg、复杂度、AU 值。`cmd+3A` halfword 出现 `0x4/0x5/0x104/0x105/0x184/0x284/0x904/0x984/0xA84`，header bit5 均为 0，AU byte 等于对应输入。
- 1 组执行 START wrapper 的命令码前缀，确认 `0x02000002`，在地址转换和实际 enqueue 前停止。
- 8 组执行真实 header diagnostic 提取指令，覆盖 byte `0/1F/20/3F/40/60/80/FF`，结果等于 bit5，实际字符串指针为 `A05BA3B8`。
- 3 组执行 context+97 到 start-config+6 的两条原始指令，确认 byte 原值传递。

另有 15 条 ARM opcode 断言、7 个相关函数代码/伪代码 SHA。**输入和全局状态由宿主构造**，命令构造从已经选好 stream 的位置进入；没有执行整个录像启动、RTOS enqueue、硬件 DSP 或当前模式读取，不构成全部配置路径的穷举证明。

## ORC 已定位到 ENC_START，重复头语义还没有闭合

DSP 输入为 `artifacts/firmware/v1.10.52/_part_dsp.a9s`，SHA-256 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`。它与相机存储镜像身份的证据范围沿用 [DSP reference boundary](eis-dsp-reference-boundary.md)，不能把存储一致升级为运行时执行状态。本轮 ORC 只静态解码，不执行、不猜未支持 opcode。

ORC member offset `0x9E3A4/0x9E3A8` 构造 `0x02000002`，随后同时处理另一命令 `0x04000002`。`0x9EDCC/0x9EDD0` 构造字符串地址 `0x866B8B`，对应 member `0x266B8B` 的 `HENC:CMD: [ENC_START]`（字符串 alias `+0x600000`），确认本轮定位的是编码 START 路径。

在同一路径可解码以下相邻字段的传递：

- `0x9E67C` 读 command `r12+0x38`，`>>13 &0xF0`，写入 encoder state `+0x50C` 的 bits4..7。这与 CPU 命令 rc complexity bits17..20 的位置相容。
- `0x9E6F4` 读 command `+0x3A` halfword，取 bit0 后移至对象 `r14+0x10` 的 bit28；不能把它当 header bit5。
- `0x9E7F4..0x9E818` 读 state `+0x50C`，与 `0xFFDFFFFF` 后写回，明确清 state bit21。
- `0x9E848..0x9E860` 又读 command `+0x38`，右移4后用 `0x00400000` mask 写 state `+0x50C` bit22。这消费 command bit26，与 single-encoder 邻近字段相容。
- 下游 `0x9FEF8..0x9FF08` 确实读取 state `+0x50C bit21` 并分支，说明被清的状态有消费者。

脚本核对 **27 条 ORC 核心指令**，保留 5 个完整小窗口及 hash。上述窗口中的指令均能被现有核心 decoder 明确解码。**尚未证明 state bit21 与 CPU command bit21 是同一语义，也未恢复其分支到 SPS/PPS NAL 写出的完整链。** 两处都出现 bit21，不能据此直接把 mode0 定义为“重复插入”，或把 ORC 清零定义为“禁用参数集”。

## 对预录方案的影响

[同步帧审计](prerecord-sync-boundary.md) 已确认每次新 open 会清参数集缓存，随后同步帧处理器需要从 payload/ring 解析 SPS/PPS。因此现在有一个具体可复查的配置入口，但仍缺少以下连线：

1. `sps_pps_header_mode` 的数值语义，以及原厂 ORC/编码引擎如何决定在每个 IDR 前生成或复用 NAL7/NAL8。
2. 当前录像设置、真实 H264ENC_START command 与实际执行 DSP 状态的一致性。
3. mux `type=1`、编码 IDR 分类和同一 descriptor 的真实 NAL7/8/5 字节边界，包括跨 ring 回绕。
4. 后续新文件首帧参数集重建和最终解码结果。

在这些证据取得前，应保留 mux 的参数集解析与合法性检查；不能把本轮 mode0 配置结果作为“每个同步帧自带参数集”的保证。相机端一分钟预录、语音/实体快门触发及连续可播放输出均未在本轮实现。

```sh
.venv-reverse/bin/python scripts/prerecord-h264-header-contract.py
```
