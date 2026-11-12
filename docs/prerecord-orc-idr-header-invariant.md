# 原厂 H.264：IDR 首 slice 与 SPS/PPS 生产条件的关联

本轮得到一个比“找到参数集函数”更强的静态结论：**在已定位的原厂 H.264 头生成路径中，同一组 picture 位既决定切片 NAL 类型为 5（IDR），也必然满足 SPS/PPS 生产条件；该判断在每张 picture 的首个 slice 上生效，不局限于整段录像的第一帧。**

这条关联不需要先解释 CPU `sps_pps_header_mode=0/1`，也不需要猜专有输出指令。仍未证明 mux `type=1` 的实际 FIFO descriptor 与这里的 NAL5 分类相同，或参数集与切片最终落入同一个可回放 ring/payload。因此这是原厂编码生产条件的证据，尚不是“预录任意同步帧都可独立解码”的完整保证。

复现脚本：[prerecord-orc-idr-header-invariant.py](../scripts/prerecord-orc-idr-header-invariant.py)。结果：[audit JSON](../artifacts/device/2026-11-10-prerecord/prerecord-orc-idr-header-invariant-audit.json)。本轮固定镜像离线分析，没有设备访问、相机写入、成品 avcC 倒推、未知输出 op 解码或实际 ORC 执行。

## 1. M=1 已有原厂 H.264 诊断约束

上一轮将 `M=picture+0x10 bits28..29` 保留为未知枚举。本轮在随后 `eng0_genFinalBS` 路径找到明确原厂分支：

- `0x16356C..0x16357C` 提取同一 picture `+0x10 bits28..29`，比较 1；该路径的诊断 `0x1635D8/0x1635DC → member 0x2B2160` 是 `ENG0: === eng0_genFinalBS() h.264 bitstream coding -> call low-level code.`。
- 非 1 分支再比较 3；相应诊断 `0x163614/0x163618 → member 0x2B21AC` 明确为 `jpeg bitstream coding`。

因此本文将 M=1 称为此路径的 H.264 discriminator。它与 CPU `sps_pps_header_mode` 的同名数字 1 没有建立联系。

## 2. 原来未知的 C/R 组合，正是切片 NAL5 的选择条件

上一轮恢复 SPS/PPS gate 为：

```text
M == 1 && (F || (C == 2 && R))
C = picture+0x20 bits4..5
R = picture+0x20 bit7
F = picture+0x28 bit11
```

同一 `eng0_genHeader` 函数随后在构造切片头时，使用同一 picture `+0x20`：

| member offset | 核心指令 | 含义 |
| --- | --- | --- |
| `0x1633B8` | `LWZ r19,32(r12)` | 读取 picture+0x20 |
| `0x1633C0` | `ANDI r16,r19,0xB0` | 只保留 bits4、5、7 |
| `0x1633C4` | `SFNEI r16,160` | 比较 `0xA0` |
| `0x1633C8` | `BF 0x163434` | 不相等走另一类型 |
| `0x1633CC` | `ADDI r6,r0,5` | 相等路径的 NAL type=5 |
| `0x163434` | `ADDI r6,r0,1` | 不相等路径的 NAL type=1 |
| `0x163400` | `JAL 0x172D24` | 类型参数送入已恢复的共同 NAL 构造器 |
| `0x16340C` | `JAL 0x177004` | 进入同一输出 helper |

`0xB0` 恰好是 C 与 R 的全部位；`0xA0` 恰好是 `C=2,R=1`。NAL 构造器将 `r6` 写入 type 字段的证据已在 [参数集输出审计](prerecord-orc-parameter-set-output.md) 固定。

令 `D = ((picture+0x20 & 0xB0) == 0xA0)`，则原厂静态判断简化为：

```text
切片类型选择：D ? NAL5 : NAL1
参数集生产选择：H264 && (F || D)
所以：H264 && D  =>  选择 SPS/PPS 生产路径，不依赖 F。
```

**R 不应再被单独称为“repeat-header 开关”**；它与 C 共同决定该处的 NAL5 分类。这里的重复参数集关联来自 IDR 分类本身，而非仅在某个未知配置值上作推测。

这是一组同一 picture 字段快照上的控制条件不变式。完整 helper 副作用、异常返回、实际调度及最终输出完成不在本轮执行验证范围内。

## 3. 首 slice gate 在每张 picture 上重新开始

`eng0_genHeader` 最早在 `0x163110` 读取 `picture+0x10A` halfword，非零时通过 `0x163118 → 0x16348C` 跳过参数集生产 gate。它是多 slice 路径的适用范围，而不是“只允许 session 第一帧”的计数。

上游调用链为消息处理 `0x16581C` → `0x165A1C` 调用逐 picture 函数 `0x164CC0`，后者将输入 picture 保存为 `r10`：

- 普通路径在 `0x164D9C` 构造 0，`0x164DA4` 写 `picture+0x10A=0`，随后 `0x164ECC/0x164ED0` 把同一 picture 传入 `eng0_genHeader`。
- 多 slice 路径在 `0x164F00` 初始化累计位置 `r12=0`、`0x164F2C` 初始化 slice 索引 `r18=0`，每次在 `0x164F60` 将当前累计位置写入 `picture+0x10A`。首轮为 0，`0x164FD8/0x164FDC` 调用同一头生成函数；后续 slice 使用更新后的累计位置。

因此，对进入这条逐 picture 路径的 H.264 IDR，首 slice 的参数集 gate 会重新被求值。后续 slice 跳过重复参数集，与“每个 IDR picture 首 slice 生成参数集”的条件一致。本文没有将 slice 数组初始化、消息队列和完整编码任务当作已经在 DSP 上执行过。

## 4. picture 字段已追到 encoder state 和消息传输

字段来源已由具体的两段复制连通，未再停在 picture 局部名称：

1. producer `0xA0B08`：消息类型 0 时，`0xA0B44..0xA0B54` 选择 `encoder_state+0x51C`、5 个 word；类型 1 时，`0xA0C00..0xA0C10` 选择 `encoder_state+0x530`、7 个 word。共同循环 `0xA0B78..0xA0B98` 将这些 word 复制到 `message+4`。
2. 类型 1 的实际调用 `0xAB3BC/0xAB3C0` 将 1 传给该 packer；`0xAB3C8/0xAB3CC` 也将 1 传给消息发送 wrapper。wrapper `0x164BFC` 传给 header setter `0x1B2EE8`，后者在 `0x1B2EF8` 将类型 byte 写入 `message+2`。
3. consumer `0x16581C` 读取同一 `message+2`。类型 0 的循环将 `message+4` 的 5 个 word 复制到 `picture+0x0C`；类型 1 将 7 个 word 复制到 `picture+0x20`，随后把该 picture 传给 `0x164CC0`。

| 已恢复的字段 | encoder-state 来源 | 消息类型/位置 | picture 位置 |
| --- | --- | --- | --- |
| M：H.264=1 / JPEG=3 discriminator | `+0x520 bits28..29` | type0 / `message+8` | `+0x10 bits28..29` |
| C/R：共同决定 NAL5 的分类位 | `+0x530 bits4..5,7` | type1 / `message+4` | `+0x20 bits4..5,7` |
| F：额外进入参数集生产的条件 | `+0x538 bit11` | type1 / `message+0x0C` | `+0x28 bit11` |

这些是固定指令和结构偏移形成的静态来源关系。实际 queue delivery、消息一致性、运行时镜像身份和完整 producer 初始化尚未执行验证。F 的具体赋值/业务含义仍未恢复，但它已不是证明 IDR 参数集分支必选所需的条件。

## 5. 可复现检查与结论边界

独立脚本通过 **87 条核心 opcode 断言、2 处精确原厂诊断引用、16 个完整核心窗口 hash**。所有新保存窗口都能被现有核心 decoder 解码，没有为未知扩展指令添加猜测规则。

宿主解释检查包括：

- picture+0x20 low byte 的全部 256 值 × 两种显式分支模型，**512 组切片 NAL 类型选择解释**，均符合 `mask 0xB0 == 0xA0 ? 5 : 1`。
- 同一 256 值 × F 0/1 × 两种模型，**1024 组 H.264 参数集选择解释**，所有 NAL5 条件都选择 SPS/PPS 分支。
- 首 slice 索引 0/1/7/65535 × 两种模型，**8 组首 slice gate 解释**，仅 0 继续进入参数集 gate。

两种模型仅分别解释这些短核心区间，不能据此宣布完整 ORC 延迟槽语义已恢复。脚本没有调用固件 helper、执行未知 op、投递消息或产生/采集视频流。更没有用合成输出冒充设备码流。

本轮可以明确收窄后续工作：不必继续把“原厂是否会为自己的 IDR 分类选择 SPS/PPS 生成”当作完全未知；应转而验证 **mux 同步 descriptor 与该 IDR 分类的关联、SPS/PPS 和 NAL5 是否落入同一 descriptor/ring 区间，以及新文件打开后实际解析/缓存成功**。CPU header-mode0/1 的完整语义和 `state+0x50C bit21` 仍保持未闭合；它们不能覆盖或替代这里独立得到的 IDR 条件证据。

```sh
.venv-reverse/bin/python scripts/prerecord-orc-idr-header-invariant.py
```
