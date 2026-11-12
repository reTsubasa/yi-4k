# 1.10.7 真机 PTB、启动链与恢复边界

分析对象是已经连接的普通 YI 4K（Linux 报告版本 1.10.7）。本页把真机只读数据和公开的 v1.10.52 BST/BLD/FW_UP 组件分开记录。公开组件用于恢复控制流和格式，不能当成 1.10.7 隐藏启动器的逐字节副本。

## 已闭合的真机证据

- Linux `3.10.71`，ARMv7，设备树为 Ambarella S2E/A9S EVK Cheetah。
- Linux 根为 `/dev/mtdblock5`；`/proc/cmdline` 为 `root=/dev/mtdblock5 rootfstype=squashfs console=ttyS2 nr_cpus=1 maxcpus=0 boss=0xdc950000`。
- Linux 看到 `remoteproc0: c0_and_c1`，固件名是 `dummy`、大小为 0；随后建立 `aipc_rpc`、`aipc_vfs`、`aipc_rfs`、`AmbaRpdev_LinkCtrl` 和 `echo_cortex`。这说明当前 Linux 使用的是已运行的 RTOS/跨核通道，`dummy` 不是可据此替换 RTOS 的镜像。
- NAND 是 Spansion 256 MiB，页 2048、OOB 64、ECC 6-bit、On Flash BBT。驱动明确打印 `Ambarella read-only mtdblock`。
- `/proc/ambarella/uart1_rcvr` 只显示 `UART1, Rx Trigger: 1, FIFO 1/4 full.`；当前 Linux 没有枚举 USB 下载设备，设备节点只看到 `ttyS1`、`ttyS2`。这不是已经证明的 UART recovery 协议。
- Linux 暴露 13 个 MTD，从 `VENDOR_DATA` 到 `RESERVED`。隐藏的 BST/BLD/FW_UP 没有独立 MTD 名称或普通文件。

采集原件在 [boot-chain-readonly](../artifacts/device/2026-11-09-linux/boot-chain-readonly/)；采集脚本是 [device_boot_chain_readonly.py](../scripts/device_boot_chain_readonly.py)。

## PTB 格式与 CRC

`VENDOR_DATA` 原始逻辑读取保存在 [vendor_data.bin](../artifacts/device/2026-11-09-linux/boot-metadata/vendor_data.bin)，SHA-256 为 `69c4fcd4c096e0b02b0c0303483c11a364cafc0c46fe5aefaf73983fff7f3844`。13 条记录从偏移 `0x08` 开始，每条 `0x40` 字节；PTB 数据区是 `[0,0x350)`，CRC 位于 `0x350`，使用 IEEE/zlib CRC32。

记录的稳定字段为：名称窗口 `+0x00..+0x1f`、attribute `+0x20`、分配大小 `+0x24`、块数 `+0x28`、起始块 `+0x2c`、装载地址 `+0x30`、实际长度 `+0x34`、保留/状态字 `+0x38`、数据 CRC `+0x3c`。名称窗口是连续名称的 32 字节滑动窗口，不能把窗口剩余字符串当作额外记录。公开 BLD 在分区扫描失败时会同时把 `+0x34` 清零、把 `+0x38` 和 `+0x3c` 写成 `0xffffffff`；因此 `+0x38` 至少参与失效状态标记，但正常镜像中的具体语义仍未确定。

本机存储 CRC 与重算结果相同：

```text
PTB stored   0x59998e0c
PTB computed 0x59998e0c
```

其中 `SYS_SW` 的记录是：分配大小 `0x02000000`、起始块 `0x0c`、装载地址 `0x00100000`、实际长度 `0x724f68`、数据 CRC `0xb3cb97f7`。从 `/dev/mtdblock1` 读取的 32 MiB 中，前 `0x724f68` 字节的 CRC 恰为 `0xb3cb97f7`。可复现实验：

```sh
.venv-reverse/bin/python scripts/verify_device_ptb_images.py \
  artifacts/device/2026-11-09-linux/boot-metadata/vendor-ptb.json \
  --sys-sw artifacts/device/2026-11-09-linux/sys_sw_partition.bin \
  --output artifacts/device/2026-11-09-linux/boot-metadata/ptb-image-checks.json
```

这一步证明了“记录的实际长度和数据 CRC”在当前设备上是可验证的；它没有证明 Linux 可以读出 NAND OOB，也没有证明修改后的映像会被隐藏启动器接受。

## 公开 BLD 恢复出的启动控制流

对固定 SHA-256 的 v1.10.52 `_part_bld.a9s`（`259ed360...e1c5cbd7`）做 A32 静态解码，关键地址按其加载基址 `0x10000000` 表示：

| 地址 | 观察 |
|---|---|
| `0x10002308` | 根据记录索引返回 `base + index*0x40 + 0x08`（SYS 表）或 `+0x0c`（另一表）。 |
| `0x10002358` | 读取记录 `+0x28/+0x2c/+0x34`，以块/页为单位装载分区。实际长度来自 `+0x34`。 |
| `0x10002780` | 启动次数/状态更新辅助路径。 |
| `0x10005a64` | bootloader 命令分发：`boot/help/show/erase/read/write/memtest/dmesg/blkread/blkmark`。 |
| `0x10006250` | 先校验 `0x1cc` 字节表和其尾部 CRC，再校验 `0x350` 字节 PTB 和 `+0x350` CRC；`show ptb` 走此路径。 |
| `0x10006834` | 读取启动状态并在 updater/system 间作失败回退选择。字符串明确显示连续失败 3 次时切换路径。 |
| `0x10006994` | 从临时加载上下文取 entry，执行 `MOV PC,entry`；最终交接是间接跳转。 |

入口附近的清零代码和字符串 `# Load Kernel`、`# Enter Kernel`、`# Boot-Up Success` 说明它是引导/装载器控制流，而不是 RTOS Shell。地址和指令窗口保存在 [bld-analysis.json](../artifacts/firmware/bld-analysis.json)，脚本是 [analyze_public_bld.py](../scripts/analyze_public_bld.py)。

## BST、BLD、FW_UP 的关系

公共 v1.10.52 的打包头给出：BST `mem_addr=0`、BLD `mem_addr=0x10000000`、FW_UP `mem_addr=0x00100000`。新增的 [boot-components-analysis.json](../artifacts/firmware/boot-components-analysis.json) 记录了三者哈希、入口向量、字符串和有限代码窗口比较。

FW_UP 包含 `c:\firmware.bin`、`c:\firmware_force.bin`、`c:\check_firmware.script`、`Write Back DTB`、`Update dtb...`、`Unable to update ptb %s`、`FirmwareUpdater finish, rebooting...` 等更新器实现字符串；同时包含一部分与 BLD 相同的启动/底层例程，但没有完整连续的 BLD 拷贝。它是“更新器”证据，不是已经验证的运行时救砖接口。`firmware_force.bin` 只能说明公开更新器有强制更新分支，不能推断当前设备会接受任意文件、能绕过 CRC/签名或在 RTOS 崩溃后独立启动。

## Linux MTD 与真实物理布局

PTB 的 `start_block * 0x20000` 描述物理跨度；Linux `/proc/mtd` 给的是逻辑导出的分区大小。当前记录中多个相邻分区之间有固定隐藏间隔，用户数据分区还存在导出范围与 PTB 分配范围不同的情况。因此不能把 `/proc/mtd` 的字节数直接当作 PTB 物理偏移，也不能用 `dd` 读取的逻辑内容重构带 OOB 的完整 NAND 镜像。

当前仍缺少：本机 BST/BLD/FW_UP 原始字节、SYS/USER PTB 的完整副本、NAND OOB、坏块映射细节、签名/版本策略、独立 USB/UART recovery 的握手和写入协议。Linux 侧的 `mtd*` 只覆盖用户可见分区。

## 对二开的实际影响

1. **Linux 层可以先做低风险工作。** 继续使用已建立的 RPMsg/AmbaLink、事件和文件服务，恢复 SharePreview 的只读状态/亮度帧路径，用于离线评估果冻纹和候选算法；不需要先修改 RTOS。
2. **RTOS 原生扩展仍受首次执行门槛限制。** 已恢复的 `t` 注册器、任务和缓存 API 只说明代码接入边界，尚未证明可以从 SD/`loadbin` 安全执行一段新代码；`loadbin` 自身不负责分配、权限或 I-cache 完整同步。
3. **RTOS/分区修改要先获得恢复闭环。** 在拿到本机启动器或独立恢复协议前，不应把 `SYS_SW`、PTB、BST/BLD 组合成刷写包，也不应把 `firmware_force.bin` 当作救砖方法。
4. **最值得继续做的是“观测通道→可回滚扩展→算法替换”。** 先把 RTOS 录像/EIS 状态、IMU 时间戳和预览帧的对应关系测出来，再选择 Linux 端导出防抖或 RTOS/DSP 内替换。这样每一步都能用原厂固件恢复。

## 下一轮执行顺序

- 只读取得更多启动日志和 `/proc/ambarella` 状态，确认 `uart1_rcvr` 的含义；不向 UART 或 `/sys` 写值。
- 离线恢复公开 BLD 的启动计数、分区选择和 NAND page/block 读写辅助函数，标记可迁移字段与 v1.10.7 需要重新定位的地址。
- 以 SharePreview/RPMsg 只读观测为第一条真机实验线；每次实验前后检查录像、温度、重启和文件完整性。
- 只有在本机恢复路径、装载长度、PTB/OOB/CRC 规则都闭合后，才制作离线刷写原型；真机写入仍需单独的回滚条件。
