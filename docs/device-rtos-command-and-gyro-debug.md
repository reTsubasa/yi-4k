# 本机 RTOS 命令验证与 gyro 诊断入口

2026-11-09，普通 YI 4K / YDXJ2_V13LW / 固件 1.10.7，构建 a8f840ce_r2746。

**已验证启动脚本能执行原生 RTOS 命令、导出指定代码字节、通过 RPC 回传 Linux，并正常返回。随后原厂录像完整解码。实际 gyro 诊断也已执行：取得 31 条三轴读数、47 条曝光偏移、47 条帧更新打印，四个字段生效且全部 37 项恢复一致。自动录像因开机 API 尚未监听而失败，当前证据仅覆盖启动预览；配置及探针结果文件已清理。**

本轮没有刷写固件、替换算法、装载自定义 ARM 程序或执行此前暂停的 `/dev/mem` 探针。此前死机原因仍未确认。

## 已通过的真机关卡

使用独占创建的 SD 根目录 `autoexec.ash`，执行三条命令：RTOS→Linux `touch` 开始标记、原生 `savebin` 导出 8 字节、RTOS→Linux `touch` 结束标记。用户确认物理重启后：

| 检查 | 实际结果 |
|---|---|
| 开始、结束标记 | 均存在 |
| `savebin` 输出 | 8 字节，`0300a0e11eff2fe1` |
| 与本机固件核对 | 等于 `A0394BA0` 的 `mov r0,r3; bx lr` |
| SHA-256 | `5e64b91b57eaf124341a5f84484d853cfe5e97bae40e8d7c8bf60c7ed4c6969d` |
| 文件清理 | 内容/类型核对后，新增脚本、导出文件、两个标记均已删除 |
| 后续原厂录像 | 开始、停止均 `rval=0`，停止后 `vf` |
| 主视频 | YDXJ0137.MP4，23,817,714 字节 |
| 像素解码 | AVFoundation 完整解码 79 帧，1920×1080、29.970 fps、2.636 秒，无解码错误 |

这证明了**原生命令执行与返回**，尚未证明自定义机器码可执行，也没有建立任意 Linux→RTOS Shell 通道。Telnet 本身仍是 Linux Shell。

证据：[探针回执](../artifacts/device/2026-11-09-rtos-control/command-probe-collect/session.json)、[录像回执](../artifacts/device/2026-11-09-rtos-control/post-probe-recording/session.json)、[完整解码](../artifacts/device/2026-11-09-rtos-control/post-probe-recording/video-validation.json)。

## 本机恢复的命令链

地址仅适用于已提取的本机 RTOS 映像，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`；不能直接套用社区其他版本。

| 位置 | 静态恢复的作用 | 真机边界 |
|---|---|---|
| `A02A3DB0` | `savebin` 解析文件、地址和长度，原生 fwrite/close | 上述 8 字节导出成功 |
| `A029DE88` | 置 Shell 事件 bit 2，触发 autoexec | 启动路径实际执行 |
| `A029DE98` → `A029CCB8` | Shell 解析入口的跳转封装 | 尚未从自定义程序调用 |
| `A0245CF4` → `A03C9188` | `t ipc rpc clnt exec1`，101 字节命令缓冲，Linux RPC program `0x20000001`、proc 1、5 秒等待 | touch 回传成功 |
| `A01C98C0` → `A01C8E20` | 注册 `t imgproc`；`-eis` 解析一个 ID 和两个 float，经 `0x10FF` 分派 | 四字段实际写入与还原均通过 |
| `A0394CC0` case 100 | 以参数 1 为下标、参数 2 为值，写 `A0757AF8` 的 37 个 uint16 调试字段 | 完整 37 项 before/active/after 已验证 |

示例语法为 `t imgproc -eis 100 20 1`。数字 100、20 是十进制。调用链与函数导出见 [字段清单](../artifacts/device/2026-11-09-rtos-control/native-eis-debug.json)、[11 个函数](../artifacts/device/2026-11-09-rtos-control/focused/functions.json)、[补充 5 个函数](../artifacts/device/2026-11-09-rtos-control/focused-extra/functions.json)。

两个负面结论也已核对：Linux command RPC `0x1000000B` 的状态回调只将首字节归为 0/1/2，并非 Shell 桥；原生 Shell 读写回调走 UART0，不能据此声称已有网络控制台。原生 `cat` 即使找不到匹配文件也返回 0，不能用其退出码保护一次性执行。

## 实际 gyro 诊断实现

此前的 `GyroLogInit` 空实现不负责采样。实际采样函数 `A0385780` 从 gyro ops 的 `+8` 回调读取数据，写入环形数组，再按调试字段选择打印。对应 [采样伪代码](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0385780.c) 和 [驱动读取](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a047ede4.c)。

| 下标 | 行为 | 本次处理 |
|---:|---|---|
| 14 | 每帧相关更新打印 `GyroSampleOffset`、调整前偏移、`ExposureTime` | 临时置 1 |
| 15 | bit 1 打印 ArmSysTim 更新；bit 2 打印无效更新哨兵 | 临时置 1 |
| 20 | bit 1 原始 gyro，bit 2 环形数组，bit 4 bias 右移 8；也用于 LBC 网格行诊断 | 临时置 1 |
| 22 | 前一次采样 tick 对该值取模为 0 才打印；也用于 LDC 网格列诊断 | 临时置 50 |
| 21 | 非零会跳过真实 gyro 读取 | 不修改 |
| 29 | 涉及硬件时序寄存器的调试 | 不修改 |
| 35 | 原映像默认值为 1 | 保留；不得清空整个数组 |

`GyroData= %8u, %8u, %8u, %5u` 的前三项来自本次三轴读取。第四项位于 `A1702C36`，mode-1 驱动只填写前三项，**第四项不是有效样本时间戳**。不做物理单位、符号或轴方向转换。

`GyroSampleOffset=%d (%d), ExposureTime=%d` 在帧相关更新中打印，之后还会执行曝光半宽和其他偏移调整。打印值不能不经分析就当作最终采样时间。ArmSysTim 也先按原始值保留，不假定其低位等于可直接关联视频的帧号。

字段 22 是 tick 取模门控，不能保证固定采样频率。文本缓冲还可能丢失、延迟和重排。这条路径适合核对已有采样/帧事件；最终算法验证需要有序、带丢失计数和共同时间基准的批量记录器。

## 有限实验的实际结果与清理

成功安装凭据为 [native-trace-stage-03](../artifacts/device/2026-11-09-rtos-control/native-trace-stage-03/session.json)，标识 `f1f114115096`。以下三个配置已按哈希核对并移除：

- `/tmp/SD0/autoexec.ash`
- `/tmp/SD0/yi4k_trace_f1f114115096.py`
- `/tmp/SD0/save_log_enable.script`（原厂空日志标记）

流程：开始标记 → 固件指纹 → 74 字节完整调试表 before → 仅设置 14/15/20/22 → active 表 → Linux worker 通过原厂 API 请求约 2 秒录像 → 四字段归零 → after 表 → 结束标记。worker 使用独占 `_attempt` 文件避免再次录像，有 API 超时及 12 秒 alarm。

这里的自动恢复是顺序执行的脚本，**不是在 RTOS 卡死时仍能运行的独立 watchdog**。RPC 等待上限也不保证整个实验硬实时结束。四个字段的默认零值来自静态映像，脚本在修改前导出 baseline，但没有运行期“非零则拒绝修改”的前置条件；采集器事后验证四项初值为零、active 只有预期改变、before 与 after 全 37 项相同。回收文件后已验证上述全部条件：只有 14/15/20/22 改变，第 35 项始终为 1，before 与 after 逐项相同。该验证对应当时导出的状态，不是后续持续监控。

上传先遇到 Telnet 长行和大段输入丢失，前两次失败证据保留。第三次使用每块 384 字节、逐块确认长度、执行前 SHA-256 核对，传输临时文件已删除；[传输凭据](../artifacts/device/2026-11-09-rtos-control/native-trace-stage-03/transport.json) 记录 `verified=true`、`removed=true`。执行 worker 的模板在回收前保持不变。

软件重启前再次核对非录像状态、三个配置文件哈希并 sync。第一次立即关闭 Telnet 的发送未观察到重启；第二次保留连接，`/sbin/reboot` 返回 0，随后失联，电脑无法找到已保存的相机热点。用户随后确认已经重启连接，现已取回原生输出；但两次操作之间没有独立采集，不能将这些输出唯一归因于软件重启，仍不能承诺软件命令可可靠完成整机重启并恢复热点。未继续重复软件重启。

静态内核分析显示 machine_restart 经函数指针调用重启实现；选定的 `ambarella_restart_machine` 路径有 IRQ/cache 处理及复位寄存器写入，但运行期函数指针和实际走向未验证，不能凭这段代码保证全 SoC 复位。证据：[重启回执与网络观察](../artifacts/device/2026-11-09-rtos-control/software-reboot/acknowledged-attempt.json)、[选定指令](../artifacts/device/2026-11-09-rtos-control/restart-selected.asm)。

## 已取得的 gyro 与帧相关事件

从 b: 取得 Active 日志 180,296 字节、Older 日志 740,381 字节，传输 SHA-256 一致，临时只读挂载已卸载。Older 是历史轮换文件，不与本次事件合并。Active 的数值过滤结果：

| 项目 | 观测 |
|---|---|
| 三轴 gyro | 31 条，tick 3851..5351，相邻打印均差 50 |
| 曝光偏移 | 47 条，tick 3840..5375；打印 `18 (26), ExposureTime=16` |
| 帧更新 | 47 条，tick 3846..5381；本段 ArmSysTim 原值 261、previous 为 0xFFFFFFFF、DiffTime 为 23 |
| gyro 第一条 | 32731、32812、32793；第四槽为 0 |
| 完整调试表 | before == after；active 只有四个指定字段改变 |
| 自动录像 | worker 在 Linux uptime 5.54 秒连接 localhost:7878，被拒绝，5.57 秒退出；未发开始录像请求 |

该窗口只对应启动预览，不能用于录像模式的读出/曝光校准。ArmSysTim 原值在本窗口没有变化，也不能凭名称就当成逐帧时钟或视频帧序号。本次 50 tick 间隔是这段实际打印的分布，不证明采样总线只有该速率。默认日志的两类漏期字符串均为 0，但本次未打开所有相关错误诊断分支，不能据此证明没有漏期。

证据：[采集凭据](../artifacts/device/2026-11-09-rtos-control/native-trace-log/session.json)、[数值事件](../artifacts/device/2026-11-09-rtos-control/native-trace-log/gyro-events.json)、[模式事件](../artifacts/device/2026-11-09-rtos-control/native-trace-log/eis-events.json)、[worker 原始结果](../artifacts/device/2026-11-09-rtos-control/native-trace-collect/record.dat)、[完整调试表核对与结果文件清理](../artifacts/device/2026-11-09-rtos-control/native-trace-evidence-cleanup/session.json)。

失败采集回执保留其原始失败状态，不能把它改写成整项实验通过。`disarm` 先按安装哈希移除三个配置；随后独立核对保存的 before/active/after，并按采集哈希移除余下八个探针文件。相机上的视频和原生日志未删除。

## 清理后的独立录像检查

另外通过原厂 API 新录制 YDXJ0138.MP4，16,661,328 字节；开始/停止均返回 0，停止后 `vf`，AVFoundation 完整解码 50 帧，1920×1080、约 29.970 fps、1.668 秒，无解码错误。这是诊断字段恢复后的功能检查，不能补算作诊断窗口内的录像证据。

最后独立查询为非录像状态，11 个探针路径全部不存在、临时日志挂载为 0，传输脚本也已清理。视频及原生日志保留；移除标记不会立即关闭本次启动的 logger。证据：[录像](../artifacts/device/2026-11-09-rtos-control/post-trace-recording/session.json)、[解码](../artifacts/device/2026-11-09-rtos-control/post-trace-recording/video-validation.json)、[最终状态](../artifacts/device/2026-11-09-rtos-control/final-status/session.json)。

## 下一步二开关卡

后续已取得实际录像窗口：API 就绪、原生条件分支、诊断字段恢复及视频完整解码均通过，详见 [录像窗口与计时来源](device-eis-recording-trace.md)。以下保留本次启动预览实验完成时的原始关卡。

1. **修正启动就绪问题。** 下轮先等待原厂 API 服务实际就绪，再进入短时诊断窗口，不能直接在开机早期发录像请求。不得通过延长 gyro printf 窗口来掩盖服务未就绪。原生 RPC 每次只等待约 5 秒，Linux worker 的总超时不能替代 RTOS 侧的恢复约束。
2. **取得录像模式窗口。** 同时取得原生表与日志、开始/停止回执、实际视频并完整解码；核对录像内部几何而非套用预览参数。
3. **建立共同时间基准。** 明确 ArmSysTim 的来源与编码、实际帧身份、曝光单位和最终 gyro 索引；需要时做 RTOS 生产者侧的有限二进制记录器，带序号、丢失计数、缓存发布和批量导出。
4. **再做 RSC 消融与校准。** 在不丢失整体稳像的前提下，区分时序偏差、按行网格、高频振动与运动模糊，再评估替代轨迹平滑和滚动快门补偿。本轮未改变算法、未测得果冻改善，也尚未证明自定义 ARM 程序执行。

工具：[原生探针](../scripts/device_rtos_command_probe.py)、[有限实验](../scripts/device_native_eis_trace.py)、[相机 worker](../sdk/device-probe/native-eis-trace/worker.py)、[分块传输](../scripts/device_python_transport.py)、[数值解析](../scripts/analyze_native_eis_trace.py)。后续同一证据链见 [目录](../artifacts/device/2026-11-09-rtos-control/README.md)。
