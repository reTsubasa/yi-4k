# 录像窗口实验与启动就绪关卡

详见 [报告](../../../docs/device-eis-recording-trace.md)。本轮没有刷机、修改 EIS/RSC 或使用旧 `/dev/mem` 工具。

| 路径 | 内容 |
|---|---|
| `stage/`、`collect/` | 第一轮：API 预检在 uptime 25.08..25.17 秒通过；原生直接条件分支未执行，未录像 |
| `cleanup-first/` | 完整 before==after 及代码指纹核对后，按哈希移除第一轮全部文件和 ready 目录 |
| `native-log/` | 第一轮日志及数值过滤；没有新增 gyro/曝光/帧更新事件，临时挂载已清理 |
| `stage-02/`、`collect-02/` | 独立 cd + if $? 的正负分支通过；调试表生效/恢复、API 预检和录像成功 |
| `native-log-02/` | 实际录像阶段 48 gyro / 67 曝光 / 66 更新；含原始日志、数值事件与模式分段 |
| `timing-summary.json` | 分模式曝光/间隔统计、视频文件名提及；计时单位依据与边界 |
| `video/` | YDXJ0139.MP4，16,254,590 字节，1080p29.97、48 帧完整解码 |
| `recording-files/` | 稍后的独立 API idle 及 SD 视频清单 |
| `cleanup-02/`、`final-status/` | 第二轮文件/目录清理；16 个路径不存在，API idle，无临时挂载/目录/其他传输文件 |
| `stage-02-boot-observation*.json` | 只查 uptime 和本轮结束标记，不打开 API 干扰 worker |
| `focused/` | 5 个原生 Shell 函数的伪代码、指令和引用 |
| `timing-focused/` | 5 个 DSP 共享状态、地址转换、曝光回调与驱动选择函数 |
| `clock-focused/`、`gyro-tick-selected.asm` | 6 个计时/日志函数，加 timer7 ISR 指令；gyro/log 共用计数器，设计单位 1 ms |
| `timing-field-refs.json`、`update-structure-refs.json` | 从本机全引用索引筛选的时序字段引用，有搜索范围限制 |
| `verify-worker.py`、`worker-validation.json` | 本地模拟 API 的不就绪、非零 baseline、单次录像与重复拒绝检查；不代表真机验证 |
| `previous-preview-phases.json` | 旧预览事件按模式重新分类，31 gyro / 47 曝光 / 47 更新均落在预览阶段 |
| `verify-evidence.py`、`offline-validation.json`、`findings.json` | 当前保留证据复核；区分第一轮失败和第二轮通过 |
| `sha256.json` | 本目录和关联工具、文档、输入的哈希；不包含自身 |

**第二轮已执行、验证并清理，相机最后为 idle。** 配置、结果文件和空 ready 目录均已从相机删除；视频和原始日志保留。移除日志标记不会即时关闭本次启动的 logger。

原始日志可能含网络或设备信息；分析输出仅保留指定数值。ArmSysTim 是共享更新状态字，第四个 gyro 数值不是时间戳，打印曝光值已被整数化。1 ms 是软件计数器的设计单位，尚未对齐传感器硬件采样、曝光或视频 PTS。当前没有可量化的果冻改善结论。
