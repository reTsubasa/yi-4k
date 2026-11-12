# H.264 AU 字段的默认配置与创建来源

本轮离线确认：`VideoEnc` 原厂默认配置例程把 `config+0x53` 清为 **0**；创建编码器时，此 byte 通过真实 100-byte copy 进入 `context+0x97`，再原样送入 start-config `+6`。结合上一轮已经执行的命令构造，得到 `config+0x53 → context+0x97 → start-config+6 → H264ENC_START command+0x39 (au_type)` 的具体来源链。

这里的 **0 是默认例程结果**，不是读取相机当前状态所得的值；AU 枚举语义和后续覆盖仍未闭合。它也不是 `command+0x3A bit5` 的 `sps_pps_header_mode`，不能据此认定每个关键帧都会生成 SPS/PPS。

复现脚本：[prerecord-h264-au-provenance.py](../scripts/prerecord-h264-au-provenance.py)。输出：[prerecord-h264-au-provenance-audit.json](../artifacts/device/2026-11-10-prerecord/prerecord-h264-au-provenance-audit.json)。本轮固定 CPU 镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，没有设备连接、真机写入、DSP 提交或视频码流执行。

## 指令证据

| 阶段 | 原始指令与行为 | 结论 |
| --- | --- | --- |
| 默认配置 `A046FD8C` | `A046FDA4` 调用真实 memset 清整个 `0xB4` 配置；`A046FE38..A046FE4C` 再清 `config+0x4C` 起的 `0x64` 字节；其余实际执行的字段赋值不覆盖 `+0x53` | 默认 `config+0x53=0` |
| 创建 `A046FECC` | `A04700E0 ADD r1,r5,#0x4C`；`A04700E8 MOV r2,#0x64`；`A04700EC ADD r0,r4,#0x90`；`A0470118 BL A029C680` | 100 bytes 从 config+4C 复制到 context+90，偏移 7 即 AU byte |
| 启动配置 `A046C454` | `A046C6C4 LDRB r3,[r4,#0x97]`；`A046C6C8 STRB r3,[r5,#6]` | context+97 原样转发 |
| App 调用者 `A021D274` | 原始直接调用清单含一次 default-config `A046FD8C` 和两次 create `A046FECC`；伪代码对应主/次编码器配置 | App 的创建路径确实调用该默认例程；此项为静态调用证据 |

## 执行验证与边界

脚本共有 **6 组执行检查、11 条 ARM opcode 断言、3 个 App 直接调用地址和 9 个相关函数 hash**：

- 3 组完整执行 `A046FD8C`，覆盖可选输入为空、非空且 global flag 为 0/1；执行原 Thumb memset，确认 AU byte 为 0、codec 默认字段为 1、可选指针保留、返回值为 0。
- 3 组执行创建函数的实际 copy 区间和启动字段的两条原指令，注入 AU taint 0/1/255，验证完整 100-byte pattern 逐字节一致且 AU byte 原值传递。1/255 是追踪用输入，不宣称为合法枚举或当前相机设置。
- 原 copy wrapper 会读取 MPIDR 对应的 RTOS per-core context flag。宿主把四个 slot 均构造为 1，执行原 wrapper、context helper 与 scalar copy，未替换任何 helper。没有执行完整创建、分配器、任务启动或 DSP enqueue。

App 的直接调用清单并未执行整个 App，也没有穷举所有后续重配/覆盖；默认值不能直接升级为所有录像模式实际值。上一轮 [header contract](prerecord-h264-header-contract.md) 中 mode0/1 与 ORC 真实 NAL7/NAL8 生成之间仍有缺口，本轮没有把 AU 默认值当作该缺口的替代证据。

对于一分钟预录，这补上了一个编码参数的来源；关键帧实际参数集、ring 回绕、跨文件连续保帧和可播放结果仍需各自验证。

```sh
.venv-reverse/bin/python scripts/prerecord-h264-au-provenance.py
```
