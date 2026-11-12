# 真机 EIS 连续观测与 API 故障定位

日期：2026-11-09。设备仍为普通 YI 4K，`YDXJ2_V13LW`，原厂 `1.10.7`。本轮没有刷机、修改设置、写 RTOS 内存或部署启动脚本。

本轮实现了连续只读采集，并把“帧回调仍运行、EIS 处理字段停止更新”定位到具体字段与任务等待路径。**本次 API 录像没有获得成功回执，也未取得可评价防抖效果的视频。不能用这些数据判定果冻根因或宣称算法改善。**

**后续更新：用户确认此前相机确实死机。正常重启后，未运行内存探针，仅通过原厂 API 成功完成一次短录像，并下载、完整解码了 109 帧 1080p 视频。直接 DRAM 探针暂停使用；详见第 6 节。**

## 1. 录像尝试与实际状态

开始前，API 返回 `app_status=idle`、1080p30 NTSC、`iq_eis_enable=on`、SD 插入、电池 99%。`system_mode=record` 表示视频模式，不表示正在录像。

只尝试一次普通录像：采集启动约 2 秒后发送 513，8 秒未收到回复；随后清理用的 514 等待 5 秒也超时，258 关闭会话同样超时。用户随后确认：**正常取景，未显示录像计时**。Linux 检查的 `/tmp/SD0/DCIM` 为空。综合这些证据，本次没有确认录像启动；保留“未确认”状态，不能把预设 8 秒当作成功录制时长。

首次连续采集中，处理计数最后变化在约 1.15 秒，513 实际发送在约 2.005 秒。因此不能把计数停止归因于开始录像命令。

原始记录：[会话](../artifacts/device/2026-11-09-live-eis/stock-eis-01/session.json)、[分析](../artifacts/device/2026-11-09-live-eis/stock-eis-01/analysis.json)、[用户确认后的 Linux 状态](../artifacts/device/2026-11-09-live-eis/stock-eis-01/after-user-confirmation.txt)。

## 2. 三组连续观测

| 采集 | 样本 | 间隔中位数 | 行为 |
|---|---:|---:|---|
| stock-eis-01 | 260 | 50.00 ms | 普通只读映射，期间尝试一次 API 录像 |
| readonly-osync-01 | 40 | 100.00 ms | `O_RDONLY | O_SYNC`，没有拍摄 API 请求 |
| readonly-task-01 | 40 | 100.00 ms | 普通只读映射，补充任务栈、事件对象和系统时钟；没有 API 请求 |

每次在采集前核对两个 64 字节 RTOS 代码指纹。`/dev/mem` 使用只读 fd、`MAP_SHARED` 和 `PROT_READ`；未执行 cache clean/invalidate。第一组最大窗口复制跨度为 1.365 ms，该数字不含 JSON/网络开销，不是算法执行耗时。

首次采集的重要区分：

| 字段 | 地址 | 首值 → 末值 | 不同值数量 |
|---|---|---|---:|
| gyro 处理读取的 tick | A1702C40 | 2556013 → 2557120 | 6 |
| 环形区下次写槽 | A1702F14 | 2 → 110 | 4 |
| 处理侧 SOF | A1704300 | 2556004 → 2557105 | 4 |
| 回调侧 SOF | A170BC90 | 2556004 → 2568950 | 256 |
| 回调侧 EOF | A170BA84 | 2556012 → 2568958 | 260 |
| 主任务已消费 SOF | A170BC88 | 2556004 → 2557105 | 4 |
| 主任务调度计数 | A170BBB4 | 563939 → 564150 | 6 |

后续 `readonly-task-01` 中，系统 tick `A1A3A528` 从 3220049 增至 3223948，回调侧 SOF 从 3220028 增至 3223932，而已消费 SOF、gyro 环形区、主任务调度计数均保持先前的末值。`O_SYNC` 对照没有使这些处理字段重新变化。

这说明实际读到的内存具有不同的更新行为，不能笼统说整个 RTOS 停止。也不能因为某些地址变化，就认定所有地址都有一致、实时的跨核可见性。两个 tick getter `A048E3F8` 和 `A048E63C` 静态上读取同一个 `A1A3A528`；处理侧旧值不是另一个独立时钟的证明。

## 3. 主任务与 gyro 通信等待路径

本机创建函数 `A03975BC` 确定：

- EIS 主任务控制块：`A170BBB0`，名称指针指向 `AmbaImageMainEisTask`。
- 栈分配范围：`[A0AC9200, A0ACB200)`，大小 0x2000。
- 图像事件对象：`A170BB88`；SOF/EOF 回调写时间戳并置位 4/8。
- 主循环 `A0396F34` 在消费 SOF 时，将 `A170BC90` 复制到 `A170BC88`。

本次控制块快照中：魔数 `THRD=0x54485244`，保存 SP=`A0ACAD30`，等待状态字段 `+0x30=7`，等待对象 `+0x70=A1A38EE4`，等待 mask `+0x7C=2`，选项 `+0x84=3`，等待 tick 字段 `+0x4C=1000`。字段语义由本机 `A03C38D0` 的事件等待实现核对；调度计数 `+4` 由 `A03C1C8C` 的恢复调度路径递增指令核对。

`A1A38EE4` 是 `A048E12C` 使用的通信完成事件组。gyro 读取 `A047EDE4` 的参数 1 分支调用：

```c
A048E12C(1, A078B0B0, 7, command_0x8c, A1A35610, 1000);
```

该函数先取得通道 mutex，再启动传输、等待事件 bit 2，后续还有定时器/完成状态检查与清理。其低层启动函数为 `A04956A0`。这些证据将后续排查范围缩小到 gyro 通信及其等待/缓存可见性。

新增只读栈窗口中出现 `A048E1F4`、`A0385C04`、`A0397474` 等代码地址，分别与通信等待函数、gyro 间接调用后的指令、主任务分派 0x100F 后的指令相符。但这是**栈中的候选代码字，不是经过校验的栈回溯**。未恢复完整寄存器上下文，也未证明这些栈字都是当前有效的返回地址。

尤其需要保留以下限制：同一 DRAM 读取可能混合旧缓存行；等待字段不变与事件对象中的等待队列字段也不能假定原子一致。当前证据支持“任务快照落在通信等待路径”这一候选，**不足以证明持续死锁、确定卡住的 CPU 指令或排除缓存问题**。没有强制唤醒线程、置位事件、重置总线或改写任务控制块。

证据：[任务采集分析](../artifacts/device/2026-11-09-live-eis/readonly-task-01/analysis.json)、[栈中代码候选](../artifacts/device/2026-11-09-live-eis/readonly-task-01/stack-code-candidates.json)、本机 [gyro 读取伪代码](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a047ede4.c)、[主任务伪代码](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0396f34.c)。

## 4. API 回复路径

Linux `remoteapi_cmd_daemon` PID 176 仍在运行，TCP 7878 可连接，主循环可接受连接、读取 JSON 并转发。两次有界 strace 都已正常脱离；后续 `/proc/176/status` 显示 `TracerPid=0`。

详细跟踪观察到：

1. Linux `accept` 后读取 257 会话请求。
2. `netctrl_send_command` 将 1024 字节命令缓冲、长度、socket fd、连接 cookie 封装，发送给 RTOS RPC `host=1/program=0x10000005/version=1`。
3. 详细 4 秒观察窗口没有收到对应 RTOS 回调，也没有向 TCP 客户端发送 JSON 回复。
4. 另一段跟踪出现一份 112 字节 RPC 回调和 92 字节 ACK，但未看到 TCP 发送；尚不能建立该回调与当次请求的一一对应关系。

实际库 `libremoteapicmddaemon.so.1` 的 `LU_NetCtrl_Reply_Svc` 静态上先通过 `AmbaMem_convert` 转换回复指针，再把 pointer/length/socket/cookie 交给 `cmd_server_send_data`。后者匹配最多 10 个客户端槽的 socket 和 cookie，匹配后才调用 `send`。因此“TCP 能连上”不表示拍摄控制已恢复；Linux 转发成功也不表示 RTOS 已完成请求。

还未确定无回复的根因是 RTOS 请求任务等待、回复路由/会话状态还是其他暂态问题。没有杀进程或重复重启 Linux daemon；当前证据不能保证这样能恢复 RTOS 端。已请用户通过电源键正常关机再开机，重建可复验的启动状态。

证据：[详细跟踪](../artifacts/device/2026-11-09-live-eis/stock-eis-01/api-strace-detailed.txt)、[另一段跟踪](../artifacts/device/2026-11-09-live-eis/stock-eis-01/api-strace.txt)、[库反汇编](../artifacts/device/2026-11-09-live-eis/api-evidence/libremoteapicmddaemon.so.1.selected.asm)。strace 中相机墙上时间与主机时间有偏差，跨记录对齐使用主机 monotonic/请求顺序，不将两者 UTC 字面值直接相减。

## 5. 工具与下一步

新增独立只读观察入口，不建立拍摄 API 会话：

```sh
python3 scripts/device_eis_observe.py --seconds 10 --interval 0.1 --output /path/to/new-observation
python3 scripts/analyze_eis_live.py /path/to/new-observation
```

原始录像工具和分析器也已保存。录像入口必须显式提供 `--record-seconds`（2..15 秒），会创建普通视频并尝试清理停止；在 API 恢复前不应再次运行。当前版本将采集窗口扩展到 `record_seconds+23`，覆盖基线、开始/停止请求的超时预算及停止后观察；失败尝试保留的 `target-probe.py` 仍是当时实际运行的 13 秒版本。

已检查三个 Python 脚本的语法；通过 socketpair 验证 API 收包器可处理 JSON 跨包和多个 JSON 连包。本轮真机只读工具完整返回 40 个样本。没有以模拟收包测试代替真机录像成功验证。

此前拟定的顺序如下；用户确认死机后，第 2 步直接内存采集暂停，执行顺序以第 6 节为准：

1. 正常重启并恢复 Wi-Fi 连接后，先只查询会话、`app_status`、设置和电池，验证 API 回复恢复。
2. 不发录像指令，先采集 4 秒基线；检查 tick、回调 SOF、已消费 SOF、环形槽与调度计数。若再次出现不一致，优先建立 RTOS 自身输出到共享缓冲/文件的观测路径，核实 cache 协议。
3. 基线可解释后，做一次有界短录像，核对开始/停止回执、相机计时及实际视频文件；若 API 再失败，停止自动拍摄请求，改用用户物理按键协助记录时间。
4. 在可靠遥测、RTOS 命令入口及恢复方式具备后，才进行 EIS off / 原厂 EIS / 保留 EIS 关闭 RSC 的对照；本轮未修改 RSC 开关。

| 原问题 | 本轮状态 |
|---|---|
| 连续只读采集是否可运行 | 已验证，三组共 340 个样本 |
| 是否获得连续、无丢样的 gyro | 未验证；环形区快照不能直接当 IMU 流 |
| 能否区分回调和处理侧状态 | 已恢复字段并观察到不同变化行为 |
| API 录像与视频基线 | 未完成；无成功回执、无确认的视频 |
| 果冻来源及 RSC 改善 | 未验证 |
| 自定义固件/实时替换 EIS | 未执行 |

## 6. 用户确认死机后的恢复与隔离验证

用户补充“已重启，刚才相机死机了”。因此此前“正常取景、没有录像计时”只能保留为当时屏幕描述，不能用来证明 UI、拍摄控制或 RTOS 任务工作正常。帧回调字段变化也只能证明对应路径有活动，不能证明整台相机健康。

重启后首先通过 Telnet 检查：Linux uptime 约 130 秒，API daemon 为 PID 175。会话、app_status、设置、电源状态、会话关闭均返回成功。app_status=idle，原模式仍为 1080p30 NTSC、EIS on；电源状态为 adapter/100。本轮未启动直接内存映射、strace 或 RTOS RPC 探针。

随后只使用原厂拍摄 API：

- 513 开始与 514 停止均返回 rval=0，两个回执之间约 4.301 秒。
- SD 新增 `DCIM/100MEDIA/YDXJ0135.MP4`，31,575,424 字节；另有 `YDXJ0135.SEC`，584,032 字节。原文件保留。
- 停止后立即查询 app_status 返回 Unknown；文件处理后的独立会话查询恢复为 idle，打开和关闭会话均成功。不能把最初的 Unknown 直接改记为 idle。
- 通过相机原厂 HTTP 服务下载文件。主视频由 macOS AVFoundation 实际解码像素帧，109 帧全部完成，无解码错误：1920×1080、约 29.970 fps、时长 3.637 秒。实际视频时长与回执间隔不同，后者不能当视频时长。
- `.SEC` 文件原扩展名下 AVFoundation 未识别视频轨；主机上以 `.mp4` 符号链接读取相同字节后，成功解码为 848×480、109 帧、同样 3.637 秒的视频。确认其中有低分辨率视频流，但未全面检查其他 box 或元数据，不能宣称不存在 gyro 数据。

本机安装的 ffprobe 因缺失 libjxl 动态库无法启动；没有修改依赖，改用系统 AVFoundation。验证脚本和输出一并保留。完整解码验证的是文件可读和视频流完整性，没有进行防抖质量评价、曝光/运动标定或原厂 EIS 效果对照。

目前证据支持：**重启后原厂 API 基本拍摄链路恢复，API 单独工作的一次短录像成功。** 上次故障发生在包含 DRAM 探针的测试期间，但没有对照复现，不能据此断言探针是唯一原因，也不能认定已经排除硬件或固件自身问题。只读 mmap 不等于对异构核缓存、总线或实时任务零影响；此前返回的快照不能作为该观测方法稳定性的证明。

下一步调整为：

1. 暂停 `device_rtos_snapshot.py`、`device_eis_observe.py`、`device_eis_live_capture.py` 的真机执行，保留它们用于审阅和离线生成目标代码。
2. 从本机固件和现有静态证据继续核对 `/dev/mem` 映射属性、RTOS 缓存及共享区协议；优先准备由 RTOS 自身复制/输出的最小日志路径，而不是重复 Linux 轮询 RTOS 私有内存。
3. 以此次无探针的原厂录像作为基本操作基线；需要动态素材时再安排受控运动与曝光条件。本段视频不作为果冻改善的证据。
4. 在观测入口稳定并验证可恢复之后，才实施 RSC 消融和相位标定。

证据：[重启后查询](../artifacts/device/2026-11-09-live-eis/reboot-recovery-01/session.json)、[API 单独录像](../artifacts/device/2026-11-09-live-eis/reboot-api-only-01/session.json)、[主视频解码结果](../artifacts/device/2026-11-09-live-eis/reboot-api-only-01/video-validation.json)、[文件处理后的状态](../artifacts/device/2026-11-09-live-eis/reboot-api-only-01/status-after-finalization.json)。

## 7. 后续原生日志路线已验证

随后通过本机原厂 `save_log_enable.script` 启用 RTOS 文件日志，用户完成重启；Linux 经临时只读 ambafs b: 挂载取得日志，启用日志后的一次原厂短录像成功并完整解码 109 帧。录像阶段内部几何由预览的 1920×1080 切到 3840×2160，最终编码仍为 1080p；EIS 时序参数同时变化，因此不能把旧预览快照直接当成录像模式的滚动快门模型。

详见 [原生日志与录像时序报告](device-native-rtos-logging.md)。本轮日志标记已移除、临时挂载已清理，没有恢复直接内存探针或修改 RSC；连续 IMU 与逐帧遥测仍未取得。
