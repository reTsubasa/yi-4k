# 预录 payload 复制适配候选：C / ARM 离线验证

已新增可复用的 C 接口：在调用方提供稳定 CPU 映射、可信 ring bounds 和已快照的 FrameDesc 后，复制其报告的 payload 到调用方所有的缓冲区。实现支持一次跨环、没有动态分配，也不访问或推进任何 FIFO cursor。

这是**离线集成候选**。相机的实际读接口、CPU/DSP 地址映射、缓存一致性、producer 静止/所有权、virtual FIFO 的获取与释放仍未接通；复制成功也不保证 H.264 可独立解码或已实现一分钟预录。

实现：[yi4k_1107_payload_copy.c](../sdk/yi4k_1107_payload_copy.c)、[头文件](../sdk/yi4k_1107_payload_copy.h)，沿用已固定的 [FrameDesc 布局](../sdk/yi4k_1107_video_descriptor.h)。验证脚本：[validate_prerecord_payload_copy.py](../scripts/validate_prerecord_payload_copy.py)，结果：[validation JSON](../artifacts/device/2026-11-10-prerecord/prerecord-payload-copy-validation.json)。

## 输入与返回值

`yi4k_1107_copy_payload(descriptor, ring, destination, capacity, result)` 接受：

- descriptor：32-byte `yi4k_1107_frame_desc` 的稳定快照。
- ring：可读 `bytes` 指针、descriptor 地址所用的 32-bit `cpu_base`、ring 字节数；映射指针和逻辑 CPU base 可以不同。
- destination/capacity：调用者已分配的目标空间。
- result：成功后才写入复制长度、第一段长度、跨环第二段长度以及 descriptor 分类提示。

`bytes` 与 `cpu_base` 的对应关系及真实 ring 边界由调用者事先验证。函数仅做本地算术与别名检查，不能验证映射背后的物理所有权或有效性。descriptor、ring view、result 要指向有效对象；函数会排除空指针、可检测的地址回绕和不满足对象对齐的指针。

| 返回值 | 含义 |
| --- | --- |
| 0 / `YI4K_COPY_OK` | 已复制 payload 并写 result |
| 1 / `YI4K_COPY_END` | 已识别结束长度，未读 ring/payload、未写输出 |
| 2 / `YI4K_COPY_BAD_ARGUMENT` | 参数为空、对象未对齐或指针范围回绕 |
| 3 / `YI4K_COPY_BAD_RING` | ring 空、逻辑基址为零、范围回绕等 |
| 4 / `YI4K_COPY_BAD_PAYLOAD` | payload 零长度、长于 ring 或起点不在 ring 内 |
| 5 / `YI4K_COPY_NO_SPACE` | 目标容量不足 |
| 6 / `YI4K_COPY_OVERLAP` | 目标/result 与源 ring、descriptor、view 或彼此重叠 |

结束判断先检查 `payload_size`，同时排除高层 `0x00FFFFFF` 和防御性的 raw `0xFFFFFFFF`。上一轮已证明 **EOS 也可能是 type 1**，所以 type 1 单独不能作为同步起点。成功结果中的 `descriptor_sync_hint` 只反映 `type==1`；外层仍须单独验证参数集和 IDR/NAL 字节。

所有可检测的验证都在复制之前完成。非成功返回时 destination/result 保持原值；硬件访问故障或调用期间 producer 改写不在此合同内。成功也不操作 cursor；外层必须在复制完成、验证并保存这份拥有的字节之后，才能推进自己的 virtual cursor。

## 复制方式

计算 `offset = payload_address - cpu_base`，要求 `offset < ring_size` 且 `0 < length <= ring_size`。随后执行：

```text
first  = min(length, ring_size - offset)
second = length - first
copy bytes[offset : offset+first] → destination[0 : first]
copy bytes[0 : second]           → destination[first : length]
```

最多经过一次 ring 末端；没有 malloc、libc 调用、缓存维护、设备地址常量或 release/advance API。它不会写源 ring、descriptor 或 view。

## 实际编译与执行验证

脚本用现有 clang 编译主机 shared library，另以 `armv7-none-eabi / cortex-a9 / ARM / soft-float / freestanding / -O2 / -Wall -Wextra -Werror` 编译同一份 C，再用已有 NDK `ld.lld` 链接离线 ELF。完整命令、编译器版本和各文件 SHA-256 均保存到 validation JSON。

ARM 函数大小 **496 bytes**；链接后没有未定义符号或保留 relocation。它被装入 Unicorn 的构造 RAM 并执行实际编译的 ARM 指令，没有将 copy 函数或循环替换为 Python stub。这里的 ARM 执行是离线指令执行，**不是相机执行**。

共 **40 个用例，每个分别执行主机 C 和编译 ARM，共 80 次**，全部通过并比较 status、payload 和 result：

- 连续、恰好至 ring 末端、两段跨环、从非零 offset 复制整圈、一字节边界。
- CPU 逻辑基址与实际映射指针不同、靠近 32-bit 地址上界、目标容量恰好够用。
- 容量不足、零长度、长度大于 ring、起点在 ring 前/末端、空 ring、地址回绕。
- 空指针、descriptor/view/result 未对齐、destination/result 与所有受保护区域的 alias。
- 两种 EOS 长度，均用 type 1 和空 ring/输出参数，证实结束检查在 ring 使用之前。
- 非 IDR 类型成功复制但不返回 sync hint。

ARM 内存 hook 检查每次成功只读取被请求的源字节范围，错误和 EOS 的 payload 读取数为零；检查非成功不写输出。主机及 ARM 均检查失败后所有测试输入/输出区域不变，成功后输入不变、目标尾部不变。ARM 另检查 callee-saved `r4..r11` 与 SP 恢复。

这些是接口安全边界和复制行为的测试；没有使用真实帧、真实 ring、真实 queue 或 DMA，不能用它们替代 [counter 和硬件输出基线](prerecord-orc-counter-baseline.md) 尚缺的证据。

```sh
.venv-reverse/bin/python scripts/validate_prerecord_payload_copy.py
```
