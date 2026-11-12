# 真机原生 RTOS 日志与录像模式 EIS 时序

2026-11-09，普通 YI 4K / `YDXJ2_V13LW`，实际固件 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。

**原厂 RTOS 文件日志已在本机验证可用：启用日志后，一次短录像开始、停止成功，下载视频完整解码。最重要的新发现是，1080p30 的预览与实际录像使用不同的内部传感器几何和 EIS 提交时序。后续滚动快门校准必须以录像模式为准。**

这次没有运行 `/dev/mem` 探针、修改 RSC 参数、装载新 RTOS 程序或刷机。此前死机原因仍未确认，直接读取 RTOS 私有 DRAM 的工具继续暂停。前情见 [连续观测与死机后恢复](device-live-eis-observation.md)。

## 1. 已验证的日志链路

静态分析基于从本机提取的完整 `SYS_SW` 分区，SHA-256 为 `e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6`。下列地址仅对应这份 1.10.7，不是跨版本 ABI，也不是直接写内存的操作指引。

| 入口 | 恢复的行为 | 验证范围 |
|---|---|---|
| `A019CE8C` | 启动检查 `c:\save_log_enable.script`，存在则调用日志启用函数 | 静态调用链；放置空标记并重启后实际出现日志 |
| `A0197644` | 设置运行期日志开关、轮换文件、打开 `b:\RtosActive.log` | 静态实现；实际文件取得 |
| `A0197098` | 打开文件并注册写入、关闭回调 | 静态实现 |
| `A0191288` / `A0191270` | 文件写入/flush、关闭 | 静态实现 |
| `A01971E0` | 轮换 Active / Older / Oldest | 静态实现；本轮不声称验证了全部轮换条件 |
| `A01972CC` / `A0105918` | 正常关机路径将日志从 b: 复制到 SD 的 c: | 静态实现；本轮直接读取 b:，没有再关机验证复制 |
| `A01ABE20` | `t ants save_log` 修改偏好字段并调用保存函数 | 静态实现；本轮没有执行 |

启用方式是 SD 根目录的原厂空标记，不需要 `autoexec.ash`。工具使用独占创建，已有同名文件时拒绝覆盖；移除时要求创建凭据并检查仍为普通空文件。标记不等于执行任意 RTOS Shell 命令。

Linux 可以通过现有 `ambafs` 服务挂载 RTOS 的 b:。采集器创建临时目录，用 `mount -t ambafs -o ro b: <临时目录>` 挂载，只读取三个指定日志文件；每个文件最多 8 MiB，按读取前文件大小截取，传输后核对字节数与 SHA-256，然后卸载、删除临时目录。它使用 RTOS 文件系统服务，仍有运行开销；不是原子快照，也不是无扰动的全量跟踪。

实际保留：

- 录像前日志：134,134 字节，1,916 行。
- 录像后日志：274,306 字节，3,733 行，SHA-256 `96bad90478592559e50d1dc21a91f8255720e035db7e94dc59424dd67cadbf71`。
- 第二份包含此前启动和录像前记录，不能把两份事件数相加当独立观测次数。
- 默认日志含网络 JSON 和设备标识。原始文件仅保存在本地证据目录；离线解析器输出选定的 EIS 数值与状态，排除网络 JSON、凭据和设备序列号行。

标记还会启用部分 Linux Wi-Fi/蓝牙日志，因而不宜为了 EIS 遥测长期保留。**本轮新增标记已移除**。移除不即时关闭本次启动的 logger；下次正常开机会失去这个强制启用条件，实际开关仍由原有偏好与其他启动条件决定。

证据：[创建凭据](../artifacts/device/2026-11-09-rtos-logging/marker-stage/session.json)、[重启后状态](../artifacts/device/2026-11-09-rtos-logging/after-log-reboot/linux-status.txt)、[成功日志采集](../artifacts/device/2026-11-09-rtos-logging/native-after-recording/session.json)、[移除凭据](../artifacts/device/2026-11-09-rtos-logging/marker-remove/session.json)。

## 2. 启用日志后的实际录像

只通过原厂 TCP API 请求一次约 4 秒录像，设置保持 1080p30 / NTSC / S.Fine / EIS on。

| 检查 | 结果 |
|---|---|
| 513 开始、514 停止 | 均返回 `rval=0` |
| 新主视频 | `DCIM/100MEDIA/YDXJ0136.MP4`，31,400,038 字节 |
| 实际解码 | macOS AVFoundation / AVAssetReader，完成 109 帧，无解码错误 |
| 视频规格 | 1920×1080，约 29.970 fps，时长约 3.637 秒 |
| 停止后状态 | 首次为 `Unknown`，随后 `vf`，并收到 `vf_start` 通知 |
| 最终独立查询 | `idle`，打开和关闭会话均成功 |

API 回执间隔与视频时长不是同一量。解码完成证明文件的视频流可读，不能证明防抖效果改善或每帧都完成 EIS。此次没有受控运动、曝光和果冻程度对比，也没有评估长时间开启日志的实时开销。

证据：[API 会话](../artifacts/device/2026-11-09-rtos-logging/logged-recording/session.json)、[视频解码](../artifacts/device/2026-11-09-rtos-logging/logged-recording/video-validation.json)、[最终设备状态](../artifacts/device/2026-11-09-rtos-logging/final-status/session.json)。

## 3. 预览与录像的 EIS 参数不同

日志的四组 `AmbaImgEisCtrl_ModeInit` 分别出现在启动预览、开始录像过程中的预览初始化、实际录像几何初始化、停止后预览恢复。第三组的 tick 为 `234043..234044`，第四组为 `238743`；这是原生日志 tick，不与主机时间直接相减。

| 原生字段 | 预览 | 实际录像阶段 | 停止后预览 |
|---|---:|---:|---:|
| `VinSensorGeo` | 1920×1080 | **3840×2160** | 1920×1080 |
| `OutputInfo.OutputHeight` | 1098 | **2182** | 1098 |
| `OutputInfo.RecordingPixels.Height` | 1080 | **2160** | 1080 |
| `RowTime×10⁹` 四舍五入值，ns | 7333 | 7333 | 7333 |
| `FrameLengthLines` | 4550 | 4550 | 4550 |
| `DlyMs` | 23 | **16** | 23 |
| `VerticalBlankTime` | 25 | 18 | 25 |
| `EisUpdateEndTime1` | 17 | **10** | 17 |
| `EisUpdateEndTime2` | 23 | **16** | 23 |
| `EisWarpUpdateEndTime1` | 20 | **13** | 20 |

表中除显式标明单位的项外均为日志原值；提交相关字段出现在各初始化后的日志中。内部 3840×2160 不能被解读为最终文件是 4K：本次文件已经实际解码为 1080p。

仅用 `OutputHeight × rounded RowTime` 计算，预览约 8.05 ms，录像约 16.00 ms。这只是几何与行时间的乘积，**还不是经过有效裁切、曝光中心、扫描方向和时间戳对齐验证的滚动快门读出时间**。

这项发现改变了标定输入：以后必须记录录像开始后的 sensor mode、有效窗口、SOF/EOF、曝光和 gyro 时间基准；只对预览数据拟合后套到录像上，可能得到错误的相位或读出模型。它尚不能证明原厂算法使用了错误模型，也不能直接解释用户观察到的果冻。

日志还打印了 `Eis rev. 0xb514c59`，gyro offset 为 8,388,608、sensitivity 为 33,536。它们可作为本机路径识别线索；坐标方向、物理单位换算、偏置漂移仍需独立核对。

结构化依据：[筛选事件与四组初始化](../artifacts/device/2026-11-09-rtos-logging/native-after-recording/eis-events.json)。

## 4. 两处不能按字面理解的调试输出

### EnablePref 归零不表示 EIS/RSC 关闭

录像路径在同一 tick 打印 `EnablePref=1`、`RscEnablePref=1`，随后又打印两个 0。反编译与指令确认：

1. `A0383A68` 处理延迟启用，调用 `A0382F88`；后者在条件满足时置实际活动字段 `A1704044/45/46`。
2. 处理器根据待处理偏好决定是否另行关闭对应路径，随后调用 `A0383740(0,0)` 清理请求。
3. `A0383740` 只写 `A170404E/4F`，与上述活动字段不同。

所以末尾两个 0 是请求字段清理。活动标志存在、原厂设置为 on 和启用日志，都不能替代逐帧执行验证；但也不能把请求字段归零当作 EIS 被关闭的证据。

依据：[延迟处理](../artifacts/device/2026-11-09-rtos-logging/focused/a0383a68.c)、[启用](../artifacts/device/2026-11-09-rtos-logging/focused/a0382f88.c)、[请求字段设置](../artifacts/device/2026-11-09-rtos-logging/focused/a0383740.asm)。

### GyroLogInit 字符串不表示有可开启的采样器

`A037FE20` 在两条 `AmbaImageMainEis_GyroLogInit` 打印之间调用 `A0394BA0`。实际目标只有两条 ARM 指令：`mov r0,r3; bx lr`。这一调用的实现不初始化缓冲、不启动任务、不写文件。

因此，不能从这个名称承诺“打开一个开关就能导出 gyro”。它只证明这处初始化钩子在本机版本是空实现，不能据此排除整份固件存在其他采集出口。后续仍要查实际 gyro 生产/消费路径及其调试分支。

依据：[调用位置](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a037fe20.c)、[本机空实现指令](../artifacts/device/2026-11-09-rtos-logging/focused/a0394ba0.asm)。

本轮日志中 `Eis-Warp calculation not in-time` 和 `Warp content not ready last frame` 均匹配 0 次。这个结论仅限已取得的日志字节；打印可能受开关、缓冲或丢失影响，不能证明没有漏期、丢帧或旧网格复用。

## 5. 为什么暂不恢复 Linux 私有 DRAM 轮询

为核对映射属性，本轮从 `/dev/mtdblock4` 只读取得两个逻辑内核映像窗口，并结合本机 `/proc/kallsyms` 对选定函数反汇编。不是读取运行中内核内存，也不是完整内核逆向。平坦映像基址 `0x40008000` 来自映像布局与符号偏移的推断，未通过运行时代码逐字节核对。

选定的 `mmap_mem` 路径在 `40265BDC` 检查文件 flags 的 `0x1000` 位；该位包含在 O_SYNC 中。置位分支在 `40265BE4` 清除页保护属性的 `0x3C` 掩码；另一分支还依赖物理地址与内核映射边界。由此可知 **O_RDONLY 本身不是“映射一定无缓存”的保证**。没有读取运行时页表，不能声称旧探针实际一定走了缓存路径。

RTOS 映射初始化 `A0295CF8` 为覆盖 EIS 私有数据的区域设置 `0x1060F` 属性；描述符构造在标准 ARM 短描述符解释下给出 TEX=0、C=1、B=1、S=1 的普通 write-back 可缓存页属性。最终行为仍依赖运行期控制寄存器与核间配置，不能只凭静态映射证明一致性。

已有原生 SharePreview 更新 `A0247B8C` 明确包含 cache flush、invalidate、复制、输出 clean 和头部 clean。它说明原厂共享数据通路有生产者侧的缓存处理；给 Linux mmap 加 O_SYNC，不会自动替 RTOS 清理私有脏缓存，也不会建立缓冲所有权和发布协议。

因此保留原有快照作为历史证据，当前使用原生文件日志。以后新增遥测应由 RTOS 在生产者侧复制到有明确 cache/所有权约定的缓冲，再通过文件或 IPC 导出。上述分析不证明上次死机就是缓存别名导致。

依据：[窗口来源与哈希](../artifacts/device/2026-11-09-rtos-logging/kernel-window-capture.json)、[内核选定指令](../artifacts/device/2026-11-09-rtos-logging/kernel-selected.asm)、[RTOS 映射](../artifacts/device/2026-11-09-rtos-logging/focused/a0295cf8.c)、[原生共享预览更新](../artifacts/device/2026-11-09-rtos-logging/focused/a0247b8c.c)。

## 6. 二开下一步

后续进展：原生启动命令、savebin 与 RTOS→Linux 回传已通过；实际采样函数的调试出口取得启动预览 gyro/曝光/帧更新，完整调试表恢复。录像阶段窗口仍未取得，见 [命令与 gyro 调试实测](device-rtos-command-and-gyro-debug.md)。以下是本轮日志完成时的原始关卡。

目前打通的是原生诊断日志，并未打通任意 RTOS 程序执行，也没有得到连续 IMU 或逐帧 warp 遥测。下一步按以下关卡推进：

1. **恢复控制入口。** 继续静态核对本机 RTOS Shell、启动脚本和 Linux→RTOS 通道。使用一次性、可返回的无算法修改命令验证执行与返回，再检查原厂录像。现有 Telnet 是 Linux Shell，不能直接执行 `t ...`。
2. **恢复实际采样出口。** 绕过这处空的 GyroLogInit 线索，检查 gyro 读取结果、帧事件和 EIS 消费位置，优先找原生批量导出通路；若需要新增记录器，应有容量上限、丢失计数、批量写出和生产者侧发布协议，避免每个样本 printf 或重复启动采样总线。
3. **在录像模式建立共同时间基准。** 同时记录 sensor mode、有效窗口、曝光、SOF/EOF、gyro 时间与序号、warp 提交和漏期；先证明记录开/关不会新增超时，并能关联同一帧。
4. **先做可回退消融，再替换算法。** 在控制与观测通过后，才比较原厂 EIS、EIS off、保留整体稳像但去掉已确认的按行修正；用受控运动和曝光判断果冻来自时序、RSC 网格、振动混叠还是其他因素。随后评估时间偏移/读出校准、姿态与轨迹平滑、按行网格生成。

本轮结束状态：API 独立查询 `idle`；本轮日志标记不存在；临时日志挂载和目录均已清理；SD 根目录没有 `autoexec.ash`。本次启动的日志可能继续写到正常关机，未执行持久化的 `t ants save_log`。

工具：[标记管理](../scripts/device_rtos_log_marker.py)、[原生日志采集](../scripts/device_rtos_log_capture.py)、[API 有界录像](../scripts/device_api_record.py)、[离线日志解析](../scripts/analyze_rtos_log.py)。证据目录与校验清单见 [README](../artifacts/device/2026-11-09-rtos-logging/README.md)。
