# 本机原生 RTOS 日志证据

设备：普通 YI 4K / YDXJ2_V13LW / 1.10.7。解释与二开关卡见 [报告](../../../docs/device-native-rtos-logging.md)。本轮没有运行 /dev/mem 探针、刷机、修改 RSC 或持久化日志偏好。

| 路径 | 内容 |
|---|---|
| `marker-stage/` | 独占创建空日志标记的凭据、实际目标代码、API 预检 |
| `after-log-reboot/` | 用户确认重启后的状态；初次 b: 探索挂载及其清理记录 |
| `native-baseline-03/` | 成功取得的录像前原生 RTOS 日志，134,134 字节 |
| `logged-recording/` | 原厂 API 录像会话、下载的 YDXJ0136.MP4、AVFoundation 完整解码结果 |
| `native-after-recording/` | 成功取得的录像后日志，274,306 字节；筛选后的 EIS 事件与四组模式初始化 |
| `marker-remove/` | 移除本轮新增标记的凭据 |
| `final-status/` | API idle、标记不存在、无临时挂载/目录、无 autoexec.ash |
| `focused/` | 40 个选定函数的 Ghidra 伪代码、指令和数据引用；40/40 导出成功 |
| `focus-seeds.tsv` | 本轮静态分析函数与推断名称；名称不是原始符号或稳定 ABI |
| `kernel-*.bin` | 从本机逻辑闪存 /dev/mtdblock4 只读取得的选定窗口；不是运行内存 |
| `kernel-window-capture.json` | 窗口偏移、长度、SHA-256 与基址推断 |
| `kernel-selected.asm` | 选定的 Linux /dev/mem 和映射检查路径 |
| `eis-enable-and-gyrolog-selected.asm` | Capstone 交叉核对：请求字段设置、GyroLogInit 的两条空实现指令 |
| `findings.json` | 本轮结构化结论、模式差异、边界和输入身份 |
| `offline-validation.json` | 保留证据上的语法、模式字段、过滤、长度与哈希验证 |
| `verify-evidence.py` | 可重复运行的离线证据核对，不连接相机 |
| `sha256.json` | 本目录及关联工具/报告/输入的 SHA-256，排除自身和可变的 Ghidra 工程 |

`native-baseline/`、`native-baseline-02/` 是早期目标脚本语法错误尝试，未创建挂载、未取得日志；实际成功采集是 `native-baseline-03/`。为保留过程证据，没有删除失败记录。headless 控制台与日志也保留各次静态导出；最终函数名称和计数以 `focused/functions.json` 为准。

日志按初始文件大小复制，可能增长、轮换或丢失打印，不能当作无损逐帧跟踪。前后两份日志存在重叠。原始 RTOS、Wi-Fi 日志及 Telnet 传输文件可能含设备标识或网络信息，不宜直接公开；`eis-events.json` 仅提取指定数值与状态行。

本轮标记已移除；这不会即时关闭本次启动的 logger。未调用会保存偏好的 `t ants save_log`。新脚本只是使用原厂诊断链路，未建立任意 RTOS 代码执行能力。

在工作区根目录执行 `python3 artifacts/device/2026-11-09-rtos-logging/verify-evidence.py` 可复核保留证据；视频像素解码由已保留的 AVFoundation 验证完成，该命令不重复解码。
