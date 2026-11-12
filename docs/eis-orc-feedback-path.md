# DSP 侧反馈标签提交路径与 FFFFFFFF 预清除

2026-11-10，完全离线。**在存储的原厂 ORC 微码中，已找到准备状态槽 `+0x20` 标签、调用 EIS 命令处理、再向共享发布字地址 `+0x3C` 提交四字节的代码路径；同时发现另一路提前准备 `FFFFFFFF` 覆盖同一尾字段。** 这把“完全不知道非哨兵反馈从哪里来”缩小为一条具体的静态候选回显协议。

证据尚未覆盖专有 staging/外存指令的实际效果、运行期 DSP 身份、复制完成、缓存可见性或 warp/table 锁存。以下区分固定字节事实、协议推断和仍未知事项；不能把已找到提交路径说成安全释放 ack。

## setup 相对地址修正后的真正入口

[前一轮核心编码定位](eis-orc-core-localization.md) 已恢复 `raw command+0x58 → setup+0x358 → eis_update_addr` 打印实参。本轮继续反查对象基址，在成员 `0x238BC/0x238C0` 找到：

```text
r12 = context
r16 = context + 0xD80          # setup 对象
```

所以相同 EIS 地址字段还有 **`context+0x10D8`** 的直接访问形式，而不只可能出现立即数 `0x358`。这个基址关系把消费者搜索准确引到紧邻 EIS_DEBUG 命令处理函数的 `0xD7844`。

该函数在 `context+0x68 != 20` 或 `context+0x10D8 == 0` 时直接返回。本轮只记录数值 20，不把它猜成 App 录像状态或某种传感器模式；在 gate 之后，下文统一以 `S = context+0x10D8` 中保存的指针值表示共享发布字地址。

## 外存 helper 的原厂身份

两个 helper 不再完全无名。本轮固定验证它们自身的诊断引用，仍沿用前一轮已经交叉建立的字符串地址别名差额 `0x600000`：

| helper 成员偏移 | 真实诊断字符串与引用 | 可证范围 |
|---|---|---|
| `0x1A4890` | `0x1A490C/10 → 0x2C24D8`：`dram_2_smem(), size is not multiple of 128` | 原厂将此函数标识为 dram_2_smem；对长度低 7 位检查 |
| `0x1A4A04` | `0x1A4B80/84 → 0x2C2579`：`smem_2_dram(), size is not multiple of 4` | 原厂将此函数标识为 smem_2_dram；对长度低 2 位检查 |

两者还有 `/src/common/utils/code_dma.c` 的固定断言字符串引用。名称、参数保存、长度检查和调用者 scratch/外存参数提供一致的静态方向证据，因此下文可以使用原厂函数名。**尚未解出底层自定义指令及硬件寄存器合同，不能据名称认定某次复制确已执行/完成。**

`0x1A14C4` 和 `0x1A14D8` 是另一对很短的 staging helper：它们分别包含 `F1E30222` 与 `F1E30223`，随后均有 `F0000049`。这些仍原样保留为未知扩展字，没有伪造 `memcpy`、cache clean、barrier 或等待语义。

## 选槽与标签提交的固定数据流

`0xD7844..0xD796C` 的核心指令和实参如下：

1. 本地反馈变量先写 `-1/FFFFFFFF`。调用原厂 `dram_2_smem(S, 0x2A20, 0x80)`，再调用 staging helper `0x1A14C4(0x2A20, &local_pointer, 4)`，随后普通 `lwz` 从 `local_pointer` 读取一个字。
2. 若该字为零，直接进入公共反馈提交块，跳过状态/EIS 命令处理；本地反馈保持 `FFFFFFFF`。
3. 非零时，将发布指针与 `S` 都按 `0x0FFFFFFF` 掩码处理，计算：

   ```text
   scratch_offset = (2 - ((masked(S) - masked(published_pointer)) >> 6)) << 6
   ```

   调用 `dram_2_smem(S-0x80, 0x2A20, 0x80)`，再把选中的 `0x2A20+scratch_offset`、本地状态地址、长度 `0x40` 传给 staging helper `0x1A14C4`。
4. 本地状态基址是栈 `-64`；`0xD7934` 读取栈 `-32`，所以来源明确是**本地状态快照 `+0x20`**。该值写入前述本地反馈变量。
5. 然后以本地状态地址调用原厂 EIS 命令处理函数 `0xD7454`，返回后跳至公共提交块 `0xD78D8`。命令处理函数包含已定位的 warp cmd_code/active 检查。
6. 公共提交块调用 `0x1A14D8(0x2A20, &local_feedback, 4)`；重新读取 `S`，明确计算 `r3 = S+0x3C`、`r4=0x2A20`、`r5=4`，调用原厂 **`smem_2_dram`**。

这些参数和普通 load/store 来源是固定指令事实；“staging 把外存指针/状态带入本地，再把 tag 带回 scratch”是由两对 helper 的一致调用形状、原厂方向名称与 CPU 布局相互支持的**协议推断**。专有指令仍未独立恢复，也没有让仿真 stub 代替 DSP 后宣称已看见回显。

## 与 CPU 两槽布局的交叉一致性

[CPU 发布契约](eis-indirect-dsp-publication-audit.md) 已恢复发布字位于槽基址 `+0x80`，两槽步长 `0x40`，标签复制到槽 `+0x20`。本轮另重新核对四条 ARM 原始指令及共享字 literal：

- CPU 计算 `slot_base + index*0x40`。
- CPU 从输入 `+0x20` 复制到状态槽 `+0x20`。
- CPU 将转换后的状态槽地址写入 `slot_base+0x80`。
- 固定发布字 literal 为 `A0699160`。

DSP 代码从 `S-0x80` 取长 `0x80` 的区域，选择其中长 `0x40` 的一个快照，最终取 `+0x20`，与上述布局精确匹配。将两个合法相对槽地址代入固定公式，结果分别为 scratch 偏移 `0/0x40`；这是**独立布局算术核对，不是 DSP 指令模拟或实测物理映射**。

因此“发布标签格式相同”现已进一步缩小为“原厂微码存在按相同两槽布局取快照、准备回传其 `+0x20` 原值的具体路径”。尚未证明采样时指针稳定、`0x80` 快照原子或 CPU 覆盖两槽时无竞争。代码没有在这一层比较单调版本、重读发布字再核对相同，也未从标签中恢复完整槽地址。

## FFFFFFFF 的另一条准备路径及调用顺序

相邻函数 `0xD7970` 在每流字段 `context+0xDC0+stream*0x14` 的 bit 8 为零、`context+0x68=20` 且 `S` 非零时，生成 `0x40` 本地结构，将栈 `-4` 的末字显式写为 `FFFFFFFF`，调用 staging helper `0x1A14D8(0x2A20, local_base, 0x40)`，再调用：

```text
smem_2_dram(S+0x20, 0x2A40, 0x20)
```

其目标范围为共享 `+0x20..+0x3F`；若按原厂方向/helper 参数执行，最后四字节正是共享 `+0x3C=FFFFFFFF`。这个结构的其它字段还准备了一组硬件相关地址和零值，本轮不为它们赋予完成语义。

对 `[成员+0, 成员+0x226000)` 的四字节对齐直接 `jal` 编码扫描，并核对局部连续指令，得到三对调用：

| FFFFFFFF 准备函数 `0xD7970` | 标签函数 `0xD7844` | 两者之间的条件 |
|---|---|---|
| `0xD7D1C` | `0xD7D34` | `context+0x10D4 == 0` 才调用后者 |
| `0xD8138` | `0xD8150` | 同上 |
| `0xD8390` | `0xD83A8` | 同上 |

这是有边界的直接调用编码扫描，不宣称排除了间接调用或扫描范围之外的代码；先调用预清除函数不等于其内部 gate 总能通过。它恢复了“先准备 FFFFFFFF、随后有条件提交有效标签”的原厂代码布局，给既有日志中 previous 经常/全部为 FFFFFFFF 提供新的机制候选。**没有取得这两次外存操作与 CPU 轮询的运行期交错，不能直接用它还原日志中每一条 FFFFFFFF 的来源或时间。**

## 证据与尚未解除的门槛

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_feedback_path.py
```

[脚本](../scripts/audit_eis_orc_feedback_path.py) 通过 **81 条 ORC 核心指令、4 条 ARM 布局指令、4 处 helper 诊断字符串引用**；完整固定字节窗口、未知扩展字和输入 hash 见 [audit.json](../artifacts/device/2026-11-10-eis-orc-feedback/audit.json) 与 [feedback-windows.asm](../artifacts/device/2026-11-10-eis-orc-feedback/feedback-windows.asm)。没有连接相机、执行 ORC、使用合成反馈、写 RAM/固件或进行新采集。

反馈代码布局位于 EIS 命令处理返回之后，仍不代表表已被硬件锁存或不再读取。精确剩余问题包括：

- proprietary staging 和 code_dma helper 的实际指令效果、完成/错误和缓存可见性合同；
- `0xD7454` 返回后，下游 IDSP/warp 硬件是否还保留槽/描述/表引用；
- 三处调用对应的帧阶段、运行期 DSP 身份，以及发布→反馈→成品 PTS 的共同序号；
- 最坏延迟、两槽并发覆盖、旧状态/warp 表的安全释放条件。

下一步应沿这些硬件合同继续，不能把原值回传候选升级成可安全替换 warp 的 ack。EIS 算法替换仍未上机。

后续 [表指针生命周期审计](eis-orc-table-lifetime.md) 已把返回后的引用问题收窄：命令 `+0x0C` 保存在逐帧对象 `+0x18`，存在同类对象间浅复制；水平表则进入原厂 `idspdrv_dram2dram` 复制准备。96 条核心指令与 2 处诊断引用通过，硬件实际最后读表及 DMA 完成语义仍未闭合。
