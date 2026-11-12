# 普通 YI 4K：USB 恢复协议来源与描述符探针

本轮找到 **S2E(A9s) 同芯片家族的 USB 下载协议源码**，尚未找到可验证的普通 YI 4K / `YDXJ2_V13LW` 板级入模式步骤或成功恢复证据。因此目前可准备描述符级探针，不能据此执行 SRAM 装载、套用其他相机 DRAM 初始化或读出隐藏 BLD。

所有新增动作均为主机公共源码下载、静态阅读及合成快照判读。没有读取 USB 设备、安装驱动、运行第三方刷机工具、连接相机或输出刷写包。

## 来源与身份

公开参考保存在 `artifacts/public-reference/2026-11-11-usb-recovery/`。`source-manifest.json` 逐文件记录原始 URL、固定 Git 提交、SHA-256 和长度，共 232 个公开参考文件；包含两仓库源码及第三方 S2E 原始 board/ADS/BLD 参考，不是为本机生成的固件。两份 GitHub tree JSON 同目录保留。

| 来源 | 固定提交 | 能支持的结论 |
|---|---|---|
| [getnexar/ambausb_cli](https://github.com/getnexar/ambausb_cli/tree/82414537ff857f3abe4a1bfd19665b6fe4c12f19) | `82414537ff857f3abe4a1bfd19665b6fe4c12f19` | 第三方 C 移植，声明从 ambausb-5.0.7 Qt 源转化；有 S2E(A9s) 平台、boot control/bulk 协议和装载流程 |
| [tmbinc/ambaflash](https://github.com/tmbinc/ambaflash/tree/22e771615f5648ce2c64e90c3b01cfcea8ed12be) | `22e771615f5648ce2c64e90c3b01cfcea8ed12be` | 使用 `4255:0010`，目标代码为 AArch64；不作为普通 YI 4K 可执行候选 |

`ambausb_cli` 的 README 明确实测 B0/B2/B4，预设是 Nexar 相机，不包含 YI。代码和平台配置可作协议参考，移植者声明不等于已验证的官方 YI 工具或原 SDK 的独立复现。仓库名、同 VID 和同家族标签均不证明板级兼容。

仓库既有文档未收录 USB boot 工具实现；已有本机资料只确认设备树 S2E/A9S 与用户 MTD，未出现隐藏启动器或独立 USB 握手。本轮有限的 GitHub 仓库/issue 检索未找到明确 `YDXJ2` 的成功恢复原件；普通网页搜索未取得可核验的型号说明，不以负向搜索证明没有恢复功能。

## 新的同家族证据

`getnexar_ambausb_cli/platform/s2e/chip.conf` 明确包含：

```ini
Name             = s2e
PrettyName       = S2E(A9s)
Id               = 9100
Product          = 4255/000C/0
DramStartAddress = 0x00000000
DramSizeReg      = 0xDFFE0804
PtbVersion       = 1
RegBits          = 32
```

其中 `Id` 在该 CLI 中由 `strtoul(...,0)` 解析，`9100` 是十进制配置值；VID/PID 单独按十六进制解析。不可把 9100 写成芯片寄存器实测值或 `0x9100`。平台表还区分 `A9AQ/4255:000F`、`S2L(A12/A16)/4255:000A`，这些不能因同为 Ambarella 就代用。

S2E 目录同时有 A9s NAND 与多种 Micron/Hynix LPDDR3 配置。本机现有材料没有证明 DRAM 料号/时序等于其中任一 board。`A9s_DDR3_NAND.board` 指向 `s2e_ddr3.ads` 与 `a9s_bld_nand.bin`，只是公开通用板配置；不能据此选中本机用的初始化参数。

## 已恢复的协议层次

来源为该固定提交的 `src/usb.c`、`src/session.c`、`src/ambausb_proto.h`：

| 层次 | 源码事实 | 本轮处理 |
|---|---|---|
| 标准 USB 描述符 | 字符串按 `Amba` → FORCEUSB；`AMBA` + `Ambarella USB generic class` → AMBOOT；`Ambarella` + 同 product → UST 分类 | 仅作为描述符启发式，不证明相机型号或 RTOS 前进入 |
| 原始 boot control read | vendor IN `0xC0`、request 0、地址高/低 16 位分别放入 value/index、返回 4 字节 | 不发送；读寄存器也可能有硬件副作用，且本机地址空间未证明 |
| 原始 boot write/jump | vendor OUT `0x40`、request 0、12 字节 command/address/value；write=`0x30000000`，jump=`0x00010000` | 不发送，不生成装载器 |
| AMBOOT/UST inquiry | 32 字节 bulk OUT 命令 `signature=0x55434D44, command=4, p0=1`，16 字节 bulk IN 回包，签名 `0x55525350` | 不把名字为 inquiry 当成零输出探测；尚无本机协议验证，不发送 |
| 原始 USB → AMBOOT | 先执行 ADS 写 DRAM 控制器，再下载 HAL/BLD、写 boardinfo、jump、重新枚举 | 是 DRAM 初始化/代码装载流程，并未提供可直接套用本机的 SRAM 入口或 SRAM 映射 |

**不能直接运行这个 CLI 做只读识别。** `open_one()` 会 detach kernel driver 并 claim interface；`amba_session_run()` 在 FORCEUSB 模式自动调用 `dram_init_and_reconnect()`，随后继续普通 firmware flash 流程。README 的模式错误文案与当前源中的自动初始化行为不能混为一谈。即使只想 inquiry，也不能复用整个 session。

隐藏 BLD 的取得仍有另外的缺口：vendor read 证明的是通用字读取命令形态，不是 NAND 地址到逻辑内容的映射。当前没有读出本机隐藏 NAND 区的合法地址窗口/控制器状态合同，不能拿任意 MMIO 读循环代替只读备份。

## 已准备的只读探针

目前只准备**系统缓存的 USB 描述符快照 → 离线分类**，不打开 USB 接口或发 vendor 命令。采集阶段若后续执行，可使用 macOS 自带的系统信息输出：

```sh
system_profiler SPUSBDataType -json > usb-descriptors.json
python3 scripts/classify_usb_recovery_snapshot.py usb-descriptors.json --output usb-classification.json
```

本轮没有运行第一条命令，没有进行任何 USB 枚举。第二条是已实现的离线工具，仅读入指定 JSON：

- 记录 `4255` 候选节点的 PID、manufacturer、product 和 location；不输出序列号。
- `4255:000C` 只标为“匹配公开 S2E 平台 PID”，不判定为 YDXJ2、可恢复或可装载。
- 按上述精确字符串给模式启发式；字符串缺失/不一致时保留 unknown，不按 PID 推测模式。
- 没有候选仅说明这份快照没看到，不证明相机没有 USB boot。
- 不调用 subprocess/USB 库，不枚举、reset、set configuration、detach、claim，不做 bulk 或 vendor control。

后续真机快照需附普通 4K 型号/板号、USB 接线、开关机和按键时序，以及当时是否已进入 RTOS。正常 MTP/大容量存储连接的描述符不能证明独立恢复；同一 PID 在正常启动后出现也不能证明 RTOS 前可进入。

## 仍缺的具体输入

最有价值的是普通 **YDXJ2** 的型号绑定原始恢复资料：官方维修/DirectUSB 配置及版本、明确板号的进入条件和 USB 描述符原件、RTOS 前串口日志，或本机隐藏 BST/BLD/SYS PTB 原始捕获。若涉及拆机，还需要清晰板号/芯片与测试点照片和已验证 pinout；当前没有依据让用户短接某焊点或照搬 4K+ 操作。

可以先由用户后续配合用数据线连接普通 4K，保留正常连接描述符作为基线；是否存在不拆机的 boot 按键组合目前未知，不能编造。取得型号可靠的进入方法后，再决定描述符观察和 inquiry 是否足够安全，并单独审查最小 RAM 装载。**当前已有协议来源，不足以宣称独立恢复或首次执行已打通。**

证据索引：[公开来源 manifest](../artifacts/public-reference/2026-11-11-usb-recovery/source-manifest.json) · [离线分类器](../scripts/classify_usb_recovery_snapshot.py) · [此前 PTB/启动链边界](device-1107-ptb-and-bld-findings.md)
