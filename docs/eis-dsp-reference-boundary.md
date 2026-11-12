# EIS 的 DSP 微码参考与身份边界

2026-11-10。初版离线核对设备 DSP 前缀、PTB 与公开参考；随后完成了完整本机 DSP 有效镜像的只读捕获。继 [间接发布链](eis-indirect-dsp-publication-audit.md) 后，现在确认：**公开参考与本机存储的 DSP 有效镜像逐字节相同；仍缺运行期 DSP 身份、正确 ORC 指令语义及锁存/完成证据。** 没有执行微码、写入固件或提交 warp。

## 本机证据与公开参考的关系

公开包为 `artifacts/firmware/v1.10.52/_part_dsp.a9s`，大小 **4,038,656** 字节，SHA-256：

`9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`

与本机已有捕获交叉验证：

- `boot-metadata/dsp_prefix.bin` 的 **65,536 字节全部与公开包前缀相等**。
- 直接重算设备 `vendor_data.bin` 的 PTB CRC，验证通过；直接解析第 2 条 `DSP_uCode` 记录，其 `actual_size=4,038,656`，`data_crc32=0x1435ADC7`。
- 公开包整体 CRC32 同为 **`0x1435ADC7`**。

上述是初版的前缀与 CRC 边界，不能独立证明完整相等。后续只读捕获已补齐这一缺口：通过 Linux `/dev/mtdblock2` 按 128 KiB 分块读取 PTB 的有效长度 **4,038,656 bytes**，得到 SHA-256 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`；相机端独立重读的 SHA-256 相同，完整字节与公开参考相等。见 [capture.json](../artifacts/device/2026-11-10-dsp-full-readonly/capture.json) 和 [捕获脚本](../scripts/device_dsp_capture.py)。API 状态/设置前后一致，boot ID 未改变；没有写入相机、调用 RTOS Shell 或访问 `/dev/mem`。

这里证明的是**存储分区有效镜像**。没有读取运行期 DSP RAM、PC 或 SD 回退结果，因此仍不能证明当前正在执行的微码身份；也没有采集逻辑分区尾部、NAND OOB 或整个物理 NAND。这份证据不支持使用公开 RTOS 地址替代本机 1.10.7 地址。

## 四个成员与原厂加载器

包内开头两字固定为 `0x66FC328A, 4`；本轮不为首字赋予额外语义。成员表从 `+8` 起，每条 `0x4C` 字节：64 字节名称和三个 u32（大小、包内偏移、CRC32）。四成员边界、顺序、非重叠与各自 CRC 均验证通过。

| 成员 | 包内偏移 | 字节数 | CRC32 | RTOS CPU 加载地址 |
|---|---:|---:|---|---|
| `orccode.bin` | `0xA000` | `0x2E54FB` | `0x206BF8F5` | `0xA1B00000` |
| `orcme.bin` | `0x2EF800` | `0x73A3C` | `0xE762BBA4` | `0xA1F80000` |
| `orcmdxf.bin` | `0x363800` | `0x24CE8` | `0x610E8918` | `0xA2000000` |
| `default_binary.bin` | `0x388800` | `0x512C0` | `0xA4DF8625` | `0xA2080000` |

本机固定 RTOS 镜像 SHA-256 仍为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。加载器 `A029A824` 从 `A05ADC20` 复制 `0xA0` 字节的四项文件名列表，以每项 `0x28` 字节推进；`A02C6C5C` 返回表中的四个 CPU 地址。加载器把这些返回值依次写入本地条目 `+0x24`，通过 `A04839C0` 查询大小，再调用 `A0483A10` 的间接文件读取通路。**21 条 ARM 加载指令已按原始字节核对。**

这些是 ARM 侧 CPU 目标地址，不是已证明的 ORC PC、字符串地址空间或物理映射。加载器还包含 SD 文件回退，因此静态默认加载路线也不能证明相机当前确实运行这份包。没有观察运行期微码 hash、回退状态或 DSP PC。

## 定位到的 EIS 诊断区域

已提取成员中以下真实字符串，偏移均相对 `orccode.bin`：

| 偏移 | 定位信息 |
|---|---|
| `0x22E4BA` | `pp_setup ... setup_params->eis_update_addr 0x%x ...` |
| `0x260B98` | `gyro delay sleep %d` |
| `0x260C57` | `mpVideoProcOnePicSec2ToDram ... cap info hw pts ... icb->gyro_delay ...` |
| `0x288191` | `EIS_DEBUG: cmd_code (0x%x) check fail` |
| `0x288257` | `EIS_DEBUG: h_warp_cmd_active(%d) is not set` |
| `0x28CCCE`、`0x28CCFB` | `vcap_update_warp_ctrl_command()` 的前后诊断 |

初版由字符串把范围缩小到 setup、逐帧 gyro 等待和 EIS 命令检查区域。后续 [DSP 核心编码与真实引用](eis-orc-core-localization.md) 已用固定 OpenRISC opcode 参考，恢复七处 little-endian OR1K 兼容核心地址构造引用及有限窗口；未使用 ARM 解码器。字符串和静态引用仍不证明分支执行，也不证明 `h_warp_cmd_active` 是槽回收标志。ORC 扩展指令、执行/延迟槽模型、完整调用图、读写顺序和缓存屏障仍未恢复。

后续已纠正 CPU 读回函数 `A02C61D4` 的调用者结论：完整导出的巨函数反编译超时，但已有 focused 导出与 calls.tsv 保留 `A03877A0`、`A0387CAC` 两处调用。原厂 CPU 读取共享 `+0x3C` 为 `UpdateInfo.ArmSysTime`，提取低八位子索引和 `0x100` 的 WarpReady 位，消费后写回 `DEADBEEF`；CPU 发布状态槽 `+0x20` 的标签格式相同。新证据见 [反馈标签与完成边界](eis-completion-state-boundary.md)。非哨兵值的写入者、DSP 原样回显、锁存及旧槽释放仍未恢复，不能把 CPU 标签消费当作 DSP completion 或 ack。

## 复现与下一步

```sh
.venv-reverse/bin/python scripts/audit_eis_dsp_reference.py \
  --output-directory artifacts/device/2026-11-10-eis-dsp-reference \
  --device-capture artifacts/device/2026-11-10-dsp-full-readonly
```

输出包含完整 [audit.json](../artifacts/device/2026-11-10-eis-dsp-reference/audit.json)、四个独立成员、输入/成员 hash、21 条加载指令和 7 条选择字符串。目录解析器另外验证损坏 payload CRC、越界大小和成员重叠三种输入都会拒绝。

下一步按依赖顺序：

1. 已完成 `DSP_uCode` 有效镜像的完整只读捕获及 SHA-256/逐字节比对；继续区分存储身份和运行期身份，不扩展为刷写或运行微码。
2. 七处诊断字符串的核心编码引用已恢复；继续恢复 ORC 扩展外存访问指令、执行模型和 CPU/DSP 地址关系，不能把核心编码兼容当完整 ISA。
3. 在 setup/逐帧路径恢复发布字、状态槽和 warp 描述的解引用与尾字段写入顺序。
4. 取得原厂路径的锁存/完成/旧槽释放观测后，才评估自定义提交。

当前 **DSP latch/ack、缓存所有权、双槽复用安全以及算法替换效果均未证明**。REA 工具仍未出现在本会话，未修改 MCP 配置、安装分析引擎或生成新的 REA Evidence；证据来源为现有文件、Capstone 和保留 Ghidra 导出。
