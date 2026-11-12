# DSP 核心编码与 EIS 诊断真实引用

2026-11-10，完全离线。**本机存储镜像的 `orccode.bin` 中，已能按 little-endian OpenRISC OR1K 兼容的核心编码恢复一组连贯窗口，并找到七处 EIS/gyro 诊断字符串的真实地址构造引用。** 这补上此前仅有字符串、无代码引用的缺口；不表示已经恢复完整 ORC ISA、执行模型、DSP 共享反馈写入或旧槽释放。

本轮使用 reverse-engineer-anything 的证据边界：本会话无 REA MCP，复用现有镜像和宿主工具，没有修改 MCP 注册、安装引擎、连接设备或运行微码。独立编码参考来自 [OpenRISC binutils 的固定提交](https://github.com/openrisc/binutils-gdb/blob/c7c6e55b60b072cdcc5c3fc27164b890a0f34520/opcodes/or1k-opc.c)，原文件、GPL 许可证头和来源摘要保留于 [reference](../artifacts/device/2026-11-10-eis-orc-core/reference/source.json)。下载的分支文件另与该固定提交逐字节 hash 核对。

## 编码、地址与引用

输入 DSP 包 SHA-256 为 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`。严格 ROM-directory 解析器重新验证四成员 CRC/边界，再取 `orccode.bin`；未将 ORC 数据解释为 ARM。以下地址均为 **成员内字节偏移**，不是 ARM 地址或已经验证的 DSP PC。

每处引用都有相同形式的真实原始字：`l.movhi r3,high16` 和 `l.ori r3,r3,low16`。构造的地址恰好等于对应字符串的成员偏移加 `0x600000`：

| 字符串成员偏移 | movhi / ori 站点 | 构造地址 | 诊断内容 |
|---|---|---|---|
| `0x22E4BA` | `0x258EC / 0x258F0` | `0x82E4BA` | setup 的 `eis_update_addr` |
| `0x260B98` | `0x9174C / 0x91750` | `0x860B98` | `gyro delay sleep` |
| `0x260C57` | `0x917B4 / 0x917B8` | `0x860C57` | cap fid/hw pts/diff_pts/gyro_delay |
| `0x288191` | `0xD7728 / 0xD772C` | `0x888191` | EIS warp cmd_code 检查失败 |
| `0x288257` | `0xD7784 / 0xD7788` | `0x888257` | h_warp_cmd_active 未设置 |
| `0x28CCCE` | `0xE2FFC / 0xE3000` | `0x88CCCE` | warp-control helper 进入 |
| `0x28CCFB` | `0xE3014 / 0xE3018` | `0x88CCFB` | warp-control helper 离开 |

前五处紧接的相对 `l.jal` 都定位到成员 `0x19FE44`；后两处通过条件分支通往同一目标。独立的 opcode/mask、连续寄存器数据流、七个一致地址差额及共同诊断调用共同支持这些是核心指令引用。`0x600000` 只作为此处的静态字符串别名关系记录，不推导为 ARM 物理映射，也不强加给代码 PC 或其它 DSP 成员。

解码器仅输出显式支持的 opcode 和 operand format；未知字保留 `.word (unsupported encoding)`。尤其不能默认标准 OR1K delay-slot 行为：窗口存在连续 `jal`，`jr` 后紧接下一函数的栈分配，盲目执行延迟槽会改变语义。本轮不模拟控制流、不执行任何 ORC 指令，不把编码兼容扩大为完整 CPU/工具链身份。

## 已缩小的三处路径

### setup 字段

诊断字符串依次打印 `pts_delta / idsp_cmd_dly / dec_rate / eis_update_addr / main_w_extra`。其调用前：`r7` 从 setup 对象 `r16+0x358` 载入，而 `0x2453C..0x24540` 已从原始命令 `r14+0x58` 载入一个字并写至同一 `r16+0x358`。

因此 DSP 侧现在有具体的静态追踪起点：**命令 `+0x58 → setup +0x358 → eis_update_addr` 打印实参**。这与 ARM 侧 [VCAP_SETUP 的同名字段](eis-indirect-dsp-publication-audit.md) 形成结构上的交叉支持；尚未跟完原始命令到该函数的全部所有权/映射路径，不能当作运行期地址抓取或实际共享内存读取。

### 逐帧 gyro 等待

`0x916F0..0x917C8` 在时间差为正的路径，把 `r10+0x142C` 与差值比较；满足相关条件后将两者差传给 `0x1A16B8`。`gyro delay sleep` 正位于这一差值的诊断分支；cap-info 打印也从相同 `+0x142C` 取值。

`0x1A16B8` 的身体含 `F000002A/F1A00019/F00D0818/F0000029` 等未解释的扩展字，夹有可解的加法，最后返回。本轮不为其定义 sleep 单位、硬件时钟、屏障或完成语义。现在能定位等待候选 helper，仍未恢复它实际等待什么、何时返回。

### EIS warp 命令检查与外存访问候选

包含两条 EIS_DEBUG 的函数起于 `0xD7454`。`0xD7690..0xD76A0` 从传入对象 `+0x24` 取地址，以 scratch `0x2A20` 和长度 `0x80` 调用 `0x1A4890`。后续以该 scratch、栈内 `-0x50` 和长度 `0x50` 调用 `0x1A14C4`，再读取栈中首字，与 `0x09005008` 比较；不等分支打印 cmd_code 失败并进入原厂断言路线。另一个检查使用 context `+0x68C` 的 `0x20000` 位，失败时打印 `h_warp_cmd_active`。

这是后续恢复外存 warp 描述消费的具体窗口；当前不能直接把两个 helper 命名为完成的 DMA-copy 协议。`0x1A14C4` 读取参数后遇到 `F1E30222/F0000049` 扩展字，这些编码没有在本轮的标准核心参考中恢复；其方向、等待、可见性和错误合同仍未证明。上下文中的 `+0x24` 也不能仅凭偏移相同就认定与 CPU 状态槽同一个对象。

另一个双诊断 helper `0xE2FCC` 的可解身体仅把输入首字、`+4/+5` 两个字节写入目标 `+0x18/+0x1C/+0x1D`。**名称含 warp-control 不代表 shared 标签写回、网格锁存或旧槽释放。**

## 复现与边界

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_core.py
```

[脚本](../scripts/audit_eis_orc_core.py) 验证固定输入 hash 和上游 opcode 参考 hash，执行 **24 条固定核心指令检查、7 处字符串地址构造检查**；输出 [audit.json](../artifacts/device/2026-11-10-eis-orc-core/audit.json) 及 [core-windows.asm](../artifacts/device/2026-11-10-eis-orc-core/core-windows.asm)。397 个窗口字中 386 个按支持的核心格式解码，11 个扩展字原样保留，不将未解码字吞掉或当 nop。

顺便修正 [DSP inventory 脚本](../scripts/audit_eis_dsp_reference.py) 中过期的“无直接调用者”摘要，并重新运行其完整存储身份检查：21 条 ARM 加载指令、4 成员 CRC/边界、3 个损坏输入拒绝和完整相机存储镜像比对通过。`A02C61D4` 的两个 CPU read/reset caller 以已完成的 [CPU 完成状态边界](eis-completion-state-boundary.md) 为准，未重定义为 DSP ack。

下一步从 `setup+0x358` 的传递和 `0x1A4890/0x1A14C4` 的扩展外存访问合同入手，再寻找共享 `+0x3C` 非哨兵写入。当前尚无标签原样回显、发布共同序号、DSP latch/cache 或状态槽/warp表释放证明；自定义提交门槛不变。

## 后续：沿真实 setup 基址找到标签提交路径

[ORC 反馈路径](eis-orc-feedback-path.md) 已补齐 setup=context+0xD80，因此同一字段还能按 context+0x10D8 访问。新定位的原厂微码按两槽布局取 `+0x20` 标签，在 EIS 命令处理之后准备向 shared+0x3C 提交；原厂 helper 自身诊断已确认 `dram_2_smem` / `smem_2_dram` 身份。另一路 FFFFFFFF 预清除也已定位。81条核心指令、4条CPU布局指令、4处helper诊断引用检查通过；扩展指令/实际执行与释放合同依然缺失。
