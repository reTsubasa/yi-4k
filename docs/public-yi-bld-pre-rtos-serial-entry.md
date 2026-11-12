# 普通 YI 4K 公共 BLD：RTOS 前串口门控与 USB 工具字段不兼容

本轮取得了新的原码证据：公开 YI v1.10.52 BLD 在加载 RTOS 前先检查串口输入；两个接收到的 `0x17`（Ctrl+W）可以通过命令行门控。12 个合成 MMIO 场景和 21 条固定指令检查通过。这是**同型号公开固件的离线候选**，不是本机 1.10.7 隐藏 BLD 身份、物理串口接线或独立恢复成功的证明。

本轮没有接触相机、USB/UART 接口、驱动或设备复位，没有执行第三方 USB CLI，没有生成修改镜像。

## 公开资料中的型号边界

新保存的社区原件位于 `artifacts/public-reference/2026-11-11-yi4k-board-recovery/`，16 个文件由 `source-manifest.json` 逐一记录 URL、获取时间、SHA-256 和长度。GitHub issue/comment 是可编辑的社区陈述，保存的是本次快照，不能当作官方维修协议。

| 原件 | 能确认什么 | 不能确认什么 |
|---|---|---|
| [普通 4K 多设备 U-Disk issue #17](https://github.com/irungentoo/Xiaomi_Yi_4k_Camera/issues/17) | 作者提供正常 Windows 实例路径 `USBSTOR\DISK&VEN_XIAOYI&PROD_SPORTCAMERA_2&REV_1000\0001&0` | 没有 boot VID/PID、完整 USB descriptor、RTOS 前进入或恢复协议 |
| [USB gadget PR #109](https://github.com/irungentoo/Xiaomi_Yi_4k_Camera/pull/109) 的逐文件 patch | 路径明确在 `4k+/`，依赖偏好、RTOS RPC 和 Linux gadget 模块 | 不属于普通 YDXJ2 的独立 boot/恢复路径 |
| [普通 4K 与 4K+ 差异 issue #25](https://github.com/irungentoo/Xiaomi_Yi_4k_Camera/issues/25) | 讨论明确将 4K+ H2/64-bit 与普通 4K 分开 | 不能将 H2、4255:0010 或 AArch64 loader 代入本机 |
| [可撤销脚本 issue #2](https://github.com/irungentoo/Xiaomi_Yi_4k_Camera/issues/2) | 作者所说移除 SD 即可撤销，指的是原有 RAM 参数脚本 | 不适用于写入 SYS_SW/PTB 的 flash 补丁，也不建立救砖方法 |

普通 4K 的 `4k/Readme.md` 固定到 `75af5a6683e4743a060cfaa6d2f362994ad1db2f`；其余 issue/PR 按 API URL 快照保存。本轮未找到可核验的 YDXJ2 精确 DRAM 初始化、板级 USB loader 或无歧义 boot 入模式说明，因此转查本地已取得的 YI 公共 BLD，避免继续只列缺口。

## RTOS 前的串口门控

固定输入仍是公开 v1.10.52 `_part_bld.a9s`，SHA-256：

`259ed36093252298186c7e39c5f3400ba307f44224aba467ab885da8e1e5cbd7`

原始 A32 控制流表明：

1. 主启动在 `0x10006B38` 检查前一阶段返回值；正常零结果分支在 `0x10006B48` 保持 `r0=0`，于 `0x10006B4C` 调用 `0x10005A64`。
2. 该调用返回后，`0x10006B50` 才进入选择/加载路径 `0x10006834`；后者在 `0x10006960` 调分区读取器，最终 `0x10006998 MOV PC,r3` 交接。
3. `0x10005A64(r0=0)` 从固定指针读取 `0xE8005000` 的 UART 接口、`0xE8170000` 的计数接口。程序先对后者 `+0x258` 写 `1,0`，循环读取 `+0x254`，超过 `0x15F8FF` 即退出；退出或通过门控时再写 `1`。
4. UART `+0x14` 的 bit0 表示当前模型下有接收数据，数据从 `+0` 取低 8 位。两个交替保存的最近接收字节都必须为 `0x17` 才到达 `0x10005B28` 的命令行初始化入口。无数据的 poll 不算新的接收字节。
5. 调用参数非零可以绕过初始接收检查，但当前正常启动调用传零；这不是给外部工具暴露的任意参数入口。

没有将 `0x15F8FF` 换算为毫秒：本轮没有验证该计数器的时钟、预分频或真实开始时刻。也没有将这两个虚拟/物理访问地址转换成相机外壳接口或测试点 pinout。

## 原码仿真覆盖

脚本在 Unicorn 执行原始门控指令，只有 UART/timer MMIO 值由宿主合成，没有调用 target service mock；遇到原厂命令行入口就停止，不执行后续 GPIO 初始化或命令。

| 输入 | 结果 |
|---|---|
| 没有输入、单个 Ctrl+W、两个字母 w、两个 Ctrl+C | 超时返回 |
| 两个 Ctrl+W | 通过门控 |
| Ctrl+W → 无数据 poll → Ctrl+W | 通过门控 |
| Ctrl+W → 其他字节 → Ctrl+W | 超时返回 |
| 其他字节 → Ctrl+W → Ctrl+W | 通过门控 |
| 第二字节恰在计数阈值 | 通过门控，阈值为包含边界 |
| 第二字节在阈值之后、开始时已经超限 | 超时返回，不接受晚到数据 |
| 非零调用参数 | 绕过初始接收门控 |

共 12 个场景。超时场景检查 SP 回到原值；所有观测到的 MMIO store 都只在合成 timer 控制地址，且与 `[1,0,1]` 顺序一致。没有真实时序、信号电压、串口适配器或设备交互。

这使下一步输入更具体：需要本机 BLD 字节，或明确属于普通 YDXJ2 的 RTOS 前串口启动日志与已核验 pinout，以重新绑定该 `Ctrl+W` 门控。现有资料不足以让用户试接、猜电压或短接测试点。即便未来进入了这个 shell，NAND/OOB 读取、备份完整性和恢复写入仍需独立验证；本轮没有把串口 shell 当成已完成救砖。

## 通用 USB 工具的一个具体格式冲突

此前找到的 `getnexar/ambausb_cli` 固定提交 `82414537ff857f3abe4a1bfd19665b6fe4c12f19` 只能作为协议参考。本轮将其 `ctrl_send_binary()` 的固定字段假设与 **YI 公共 BLD 原始字节**逐项核对，得到一个具体的不兼容点：

- CLI 认为 `+0x38` 是版本字段，低于 16 位才令 `have_bld_version=1`；YI 此处为 A32 指令 `0xE38000D1`（`orr r0,r0,#0xd1`），不满足版本条件。
- CLI 在 `patch_amboot` 分支仍会**无条件按偏移 `+0x48` 写入 DRAM 寄存器值**，这条分支不要求有效版本。
- YI 的 `+0x48` 是 `0xE592D000`（`ldr sp,[r2]`），属于早期异常模式栈初始化，不是 DRAM 元数据。
- `amba_elf_extract()` 对无 ELF magic 的文件直接作为 flat binary，不移动这些偏移。

因此把 YI `_part_bld.a9s` 直接送给该通用 patcher，会把启动指令当作 DRAM 字段替换。本轮只审计源码和字节，没有执行 CLI、构建传输或写出修改文件。这个具体冲突也说明：即使 SoC family 相符，也不能把该工具或板级资源当作本机 loader。

## 复现

```sh
.venv-reverse/bin/python scripts/audit_public_yi_bld_serial_entry.py
```

- [独立脚本](../scripts/audit_public_yi_bld_serial_entry.py)
- [结果 JSON](../artifacts/device/2026-11-11-public-yi-bld-serial-entry/audit.json)：12 场景、21 固定指令、公共工具 3 份源码身份和格式冲突。
- 同目录 4 份 `.asm` 窗口：串口门控、超时退出、RTOS 前调用顺序、装载/跳转。
- [本轮公开来源清单](../artifacts/public-reference/2026-11-11-yi4k-board-recovery/source-manifest.json)
- [此前 USB 家族协议调查](device-1107-usb-recovery-source-survey.md)

当前可复现的是公共 BLD 的 RTOS 前输入条件和通用工具格式冲突；本机独立 USB/SRAM 首次执行与恢复仍未建立。
