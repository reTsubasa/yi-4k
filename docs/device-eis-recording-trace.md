# 真机 EIS 录像窗口采集

本轮延续 [RTOS 命令与 gyro 调试实测](device-rtos-command-and-gyro-debug.md)，目标是在实际录像时取得原生 gyro、曝光偏移和帧相关更新，先建立观测基础。没有刷机、修改算法或运行旧 `/dev/mem` 探针。

设备为普通 YI 4K / YDXJ2_V13LW / 1.10.7，构建 a8f840ce_r2746。地址仅对应已提取的本机 RTOS 映像，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

**录像窗口已取得：第二轮原生条件、四字段生效、完整恢复和 API 录像均通过。实际录像模式内保留 48 条 gyro、67 条曝光偏移、66 条更新打印；生成的 1080p 视频完整解码 48 帧。实验文件和目录已清理，相机最后为 idle。尚未修改防抖算法或测量果冻改善。**

## 这次如何避免开机过早录像

原实验在 Linux uptime 5.54 秒请求 API，被拒绝。本轮启动脚本先调用六次 Linux `sleep 3`，每次低于原生 RPC 的约 5 秒等待上限；18 秒是启动缓冲，**真正的开关条件是后续实际预检**。

预检 worker 读取 RTOS 原生导出的代码指纹和完整调试表，要求四个目标字段初值为零；随后用原厂 API 检查固件、空闲/取景、录像模式、SD、EIS on 和电量，再关闭会话。只有成功才创建唯一、空的 ready 目录。RTOS 以该目录的可访问性决定是否执行诊断与录像。

接着仅设置 14/15/20/22 为 1/1/1/50，导出 active 表，运行第二个 worker。它再次核对表和 API 状态，通过原厂 API 录像约 2 秒，然后停止。RTOS 顺序恢复四个字段、导出 after 表并回传结束标记。全部命令行低于原生 256 字节限制。

这是有限的顺序脚本，不是能在 RTOS 卡死时独立恢复的 watchdog。worker 有 alarm 与 socket 超时，但 RPC 等待超时不保证 Linux worker 已退出；必须结合实际日志与回执判断诊断窗口覆盖范围。该路径仍不是任意自定义 ARM 代码执行。

## 第一轮：API 就绪，但原生条件分支跳过

`stage/`、`collect/` 为第一轮凭据。实际预检在 uptime 25.08..25.17 秒完成，API 打开、状态、设置、电量、关闭均成功，ready 目录存在。代码指纹正确，before 与 after 的 74 字节一致；没有 active、record、attempt，日志中也没有新增 gyro/曝光/帧更新打印。

这一轮把条件写成 `if cd ...; then ...; fi`。原生解析器 `A029CCB8` 对普通条件的处理不能直接按 POSIX Shell 理解；实际没有进入正分支。修正方式为独立 `cd`，再用 `if $?; then ...; fi` 读取前一命令的返回值。原生 `cd` 的文件系统失败会返回非零，与先前不适合作存在性判断的 `cat` 不同。

第一轮作为失败记录保留。清理器核对代码指纹、before==after、安装文件和采集文件哈希后，删除全部自建文件和空 ready 目录，没有改写失败回执。没有删除视频或原始日志。

## 第二轮：返回值条件分支

`stage-02/` 安装了修正后的脚本。增加一个缺失目录对应的负分支标记，以及 ready 目录对应的正分支标记：负标记必须不存在、正标记必须为空文件。这样能区分 API 就绪、目录可见、原生条件执行和实际录像四个不同关卡。

重启后已回收并通过验证：开始与结束标记存在；负标记不存在，正标记为空文件；active 表只有 14/15/20/22 从 0 变成 1/1/1/50；before 与 after 全部 37 项一致，第 35 项始终为 1。预检在 Linux uptime 25.09..25.20 秒完成，录像 worker 在 25.52..28.47 秒完成。

开始、停止均返回 `rval=0`。停止后的立即查询为 `Unknown`，稍后的独立查询为 `idle`，因此没有把过渡状态改写成取景。证据见 [第二轮采集](../artifacts/device/2026-11-09-eis-recording/collect-02/session.json)、[独立状态与新文件清单](../artifacts/device/2026-11-09-eis-recording/recording-files/session.json)。

## 实际录像窗口与模式差异

Active 日志 234,033 字节，SHA-256 `5529f3828fa987a5e3fefc0955b55a23a92fa3c1d2a7ed333fc386744136083c`。另取 Older/Oldest 作为历史文件，不合并进本次统计。临时只读挂载已卸载，传输长度和 SHA 一致。

按文件行顺序，在完整 ModeInit 结束与下一次初始化开始之间分段；不把日志 tick 自动对齐到视频 PTS。

| 观测 | 启动预览 | 实际录像几何阶段 | 停止后预览 |
|---|---:|---:|---:|
| 内部 Vin 几何 | 1920×1080 | 3840×2160 | 1920×1080 |
| 输出有效高度打印 | 1098 | 2182 | 1098 |
| DlyMs | 23 | 16 | 23 |
| gyro 打印数 | 11 | **48** | 0 |
| 曝光偏移打印数 | 17 | **67** | 0 |
| 更新打印数 | 17 | **66** | 0 |
| `GyroSampleOffset` 与括号内值 | 18 (26) | **12 (20)** | 无诊断窗口 |
| `ExposureTime` 打印原值 | 16 | 16 | 无诊断窗口 |
| `DiffTime` 打印 | 23×13 次，24×4 次 | **16×13 次，17×53 次** | 无诊断窗口 |

本次录像阶段三种数值事件的 tick 范围为 25851..28233；gyro 相邻打印差均为 50 tick。跨预览→录像切换出现一次 350 tick 的 gyro 打印间隔，不能据此宣布 IMU 硬件丢了 6 个样本：这是取模抽样的文本日志，模式切换、诊断分支和缓冲也会影响可见记录。

ArmSysTim 的打印值在 `0x105`、`0x106` 之间，低 8 位为 5/6、bit 8 为 1。它没有随视频帧数单调增加，不能作为独立视频帧序号。previous 字段全为 `0xFFFFFFFF`；采样循环每次轮询都会更新该变量，不能把名称中的 previous 理解为上一帧的有效状态，也不能单凭此哨兵判定帧丢失。

视频为 YDXJ0139.MP4，16,254,590 字节，1920×1080、约 29.970 fps、1.6016 秒，AVFoundation 完整解码 48 帧，无错误。原生日志在 tick 26031、26033、28211 提到同一文件；此前最近已知视频为 YDXJ0138。worker 回执、文件清单、原生日志文件名和实际 MP4 相互支持这次录像的归属。

**48 条 gyro 与 48 帧视频并非一对一对应。** gyro 打印约每 50 tick 一条；录像几何的初始化/退出窗口比已编码片段更长。67/66 条曝光/更新记录也不等于文件的有效帧数，当前不能做逐帧关联或从计数差推导丢帧。

证据：[数值事件](../artifacts/device/2026-11-09-eis-recording/native-log-02/gyro-events.json)、[模式分段](../artifacts/device/2026-11-09-eis-recording/native-log-02/phases.json)、[时序统计与文件名提及](../artifacts/device/2026-11-09-eis-recording/timing-summary.json)、[视频下载 SHA](../artifacts/device/2026-11-09-eis-recording/video/download.json)、[完整解码](../artifacts/device/2026-11-09-eis-recording/video/video-validation.json)。

## 静态时序线索

`A02C61D4` 从配置根指针的 `+0x58` 取共享状态地址，经 `A04A3BD4` 的地址转换，复制共享结构的 `+0x10`、`+0x20..+0x3C` 到 RTOS。末项进入 `A170AFE8`，即 gyro 函数打印的 ArmSysTim。另一个方向仅把末项写回共享结构 `+0x3C`。

`A0385780` 消费该值后取低 8 位和 bit 8，再写 `0xDEADBEEF` 并调用反向传递。后续 [CPU 反馈审计](eis-completion-state-boundary.md) 已恢复该编码为历史子索引与 `WarpReady` 位，因此应称为 **CPU 从共享区读取和消费的反馈标签**；DSP 的非哨兵写入者尚未恢复，不能把连续日志 tick、该标签和视频 PTS 直接等同。

后续 [真实日志关联](eis-feedback-live-correlation.md) 独立重解析全部 83 条有效反馈，其中录像阶段 66 条均为子索引 5/6、`WarpReady=1`。原日志另有 `FrameCount 61 / trim frame 13`，固定原始代码确实扣减这项计数，`61−13=48` 与成品实际解码帧数一致。它补充了会话级裁剪解释，但仍不能把某条反馈绑定到有效视频帧；Spf/gyro 历史、提交地址与有效视频 PTS 的共同记录当时未开启。

曝光来源也已找到：gyro 函数调用 sensor ops `+0x28`，乘本机常数 1000.0，转无符号整数并截取 uint16 后打印。默认传感器表将该回调指向 `A0479A10`，后者按浮点时间尺度及快门控制字段计算输出。打印精度已损失小数，物理单位与曝光中心仍要沿传感器状态和实际帧验证；不能只靠这条整数打印做亚毫秒同步。

### 新确认的计时来源

本机 gyro 读取的 `A048E3F8` 与日志前缀读取的 `A048E63C` 都返回计数器 `A1A3A528`。`A0495C7C` 按 timer clock / 1,000,000 建立每微秒计数尺度；`A04A1D2C` 以初始/周期 1000 配置 timer 7。该 timer 表项指向 `A0495C30`，指令明确将同一计数器加 1，然后调用 RTOS tick 处理。

所以本机这些日志 tick 的**设计单位为 1 ms**。这来自定时器配置与指令链，尚未独立校准时钟频率或证明中断无延迟。它也不是 IMU 内部硬件采样时间，更不是曝光中心时间。原始解析器继续保留无换算值；独立时序摘要记录了新的单位依据。

依据：[六个计时与日志函数](../artifacts/device/2026-11-09-eis-recording/clock-focused/functions.json)、[ISR 与计数器指令交叉核对](../artifacts/device/2026-11-09-eis-recording/gyro-tick-selected.asm)。曝光与 gyro 时间仍需另行对齐。

## 清理和下一步

第二轮凭据核对后，已删除 autoexec、worker、空日志标记、全部探针输出及空 ready 目录。最后检查 16 个相关路径全部不存在，临时日志挂载/目录和其他分块传输文件均为 0，API 为 `idle`。视频及原生日志保留。移除日志标记不会立即停止本次启动的 logger，未写持久化日志偏好。

本次日志的两类漏期字符串匹配均为 0，但并未打开所有错误诊断分支，不能证明没有漏期或旧网格复用。也没有受控运动和 EIS 开关对照，不能评价防抖质量。

下一步可脱离反复重启的短 printf 实验，聚焦下面两个缺口：

1. **恢复可关联的原始记录格式。** 找到每个 gyro 样本的采集时刻/序号、传感器帧事件及曝光控制值的精度，明确 DSP 更新字低位的实际含义。当前每 50 ms 打印约一条，无法识别高频振动，不能作为新 EIS 的完整输入。
2. **准备有限二进制记录器的加载关卡。** 先确定有所有权的可执行/数据缓冲、原生入口、返回与 cache 发布，再做最小自定义代码执行验证；通过后才在 RTOS 生产者侧批量记录，带容量上限和丢失计数。不恢复 Linux 私有 DRAM 轮询，不在日志证据不足时直接修改 RSC 参数。

这些缺口补齐后，才适合比较“整体稳像保持、改变按行修正”的消融，判断果冻是否主要来自时序偏移、读出模型或网格行为。现有模式差异本身不是原厂 bug 的证据。

清理证据：[删除回执](../artifacts/device/2026-11-09-eis-recording/cleanup-02/session.json)、[最终状态](../artifacts/device/2026-11-09-eis-recording/final-status/session.json)。

## 工具与验证范围

使用 [实验管理器](../scripts/device_eis_recording_trace.py)、[相机 worker](../sdk/device-probe/native-eis-recording/worker.py)、[原生日志采集](../scripts/device_rtos_log_capture.py)、[精确数值解析](../scripts/analyze_native_eis_trace.py)。旧实验及其模板保持可复现。

本地模拟 API 检查通过：API 拒绝连接不生成 ready；调试字段初值非零不生成 ready；成功预检后恰好一次开始/停止；重复执行被独占结果文件阻止。这些检查只验证 Linux worker 的逻辑，不代替真机、原生条件解析或实时开销验证。证据见 [模拟检查](../artifacts/device/2026-11-09-eis-recording/worker-validation.json)。

第二轮上述关卡均已核对；[离线校验器](../artifacts/device/2026-11-09-eis-recording/verify-evidence.py) 可复核保留数据。成功仅说明本轮观测链路成立，尚不意味着果冻已改善。
