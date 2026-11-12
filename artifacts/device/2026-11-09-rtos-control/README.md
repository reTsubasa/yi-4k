# 本机原生 RTOS 控制与 gyro 诊断证据

完整解释见 [报告](../../../docs/device-rtos-command-and-gyro-debug.md)。输入为真机 1.10.7，RTOS 映像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

| 路径 | 内容与边界 |
|---|---|
| `command-probe-stage/`、`command-probe-collect/` | 原生命令执行、8 字节导出、两次 RPC 返回；已清理 |
| `post-probe-recording/` | YDXJ0137.MP4，23,817,714 字节，79 帧完整解码 |
| `focused/`、`focused-extra/` | 共 16 个本机函数导出；原生命令、调试处理与 RPC |
| `native-eis-debug.json`、`debug-flag-xrefs.json` | 调试数组字段和静态引用；不是跨版本 ABI |
| `restart-selected.asm`、`restart-symbols.txt` | 本机逻辑内核映像选定指令与符号，不是运行内核读写 |
| `software-reboot/` | 软件重启发送、返回与失联观察；用户后续重启，无法唯一归因 |
| `native-trace-stage/`、`native-trace-stage-02/` | 两次 Telnet 上传失败；成功安装以 stage-03 为准 |
| `native-trace-stage-03/` | 四字段有限实验的安装凭据、完整脚本与分块传输 SHA |
| `native-trace-collect/` | 11 个文件回收；调试表符合预期，但 worker 开机时 API 连接拒绝，整项采集保留失败状态 |
| `native-trace-log/` | Active / Older 日志，SHA 已核对并卸载；Active 含 31 gyro、47 曝光、47 帧更新；仅预览 |
| `previous-log-trace-baseline.json` | 前一轮未开调试字段的日志，对三种数值格式匹配 0 次 |
| `native-trace-disarm/` | 哈希核对后移除 autoexec、worker、日志标记；不单独声明运行字段恢复 |
| `native-trace-evidence-cleanup/` | 独立验证完整调试表恢复，按采集哈希移除余下八个探针文件 |
| `post-trace-recording/` | YDXJ0138.MP4，16,661,328 字节，50 帧完整解码；这是清理后的独立检查，未与调试窗口重叠 |
| `final-status/` | 原厂 API 非录像状态、11 个探针路径不存在、无临时日志挂载 |
| `verify-evidence.py` | 仅离线复核保留数据，不连接相机 |
| `offline-validation.json`、`findings.json`、`sha256.json` | 结构化结果和本目录/关联工具/文档校验清单 |

未刷机、未替换 EIS/RSC、未运行旧 `/dev/mem` 探针，尚未验证自定义 ARM 代码执行或防抖效果改善。第四个 GyroData 数值不是时间戳，日志 tick 与物理单位/曝光对齐也未标定。原始日志可能包含网络信息，解析输出仅保留精确匹配的数值字段。

配置及本轮探针产物已从相机删除；视频和原始日志保留。删除日志标记不即时关闭本次启动的原厂 logger。下一轮先处理开机 API 就绪，再取得录像窗口；本目录不声称这一步已经完成。
