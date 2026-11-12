# YI 4K 项目目标与验收路线


2026-11-12续推：Android 0.4.8 已完成主机/AVD范围验证并修正设置中文值；预录新增[C spool/seal→原厂ARM mux](prerecord-native-spool-ring.md) run03，voice/shutter 两路同 SHA 成片，interrupted/Close 失败和输入篡改均可保留/拒绝。EIS 原生线新增[RPC 外部入口负向审计](device-1107-native-rpc-external-entry-audit.md)与[原生证据一致性复跑](../artifacts/verification/2026-11-12-eis-native-consistency-run02/audit.json)，并复核[间接 DSP 发布](../artifacts/verification/2026-11-12-eis-indirect-publication-run02)和[ORC 可见性](../artifacts/verification/2026-11-12-eis-orc-visibility-run02)；这些结果仍确认没有受控自定义入口、DSP latch/ack 或可证明的缓存发布。三条底层目标仍未完成：没有实时相机 FIFO/实体 SD/真机语音快门绑定，也没有自定义 EIS 代码执行、算法画质对比或独立恢复。


2026-11-12续推：原厂封装由[固定窗口ARM最终导出](prerecord-native-session-export.md)补上最终成片证据，预录[触发历史持久化](prerecord-trigger-pin-recovery.md)补上进程退出保管边界；EIS新增[局部坐标合同](eis-stock-coordinate-contract.md)，执行线排除[看门狗恢复候选](device-1107-native-watchdog-recovery-boundary.md)。新增[非零START63/STOP64窗口](prerecord-native-window-export.md)在显式公共起点/MVHD适配、约0.923秒初始空白的范围内通过严格门禁及失败重试。三条目标仍未完成，原厂event3独立第二段拒绝、通用任意触发窗口和真机运行/恢复仍待验证；最新证据见[紧凑成片、Android消费者与stock真机验收索引](../artifacts/verification/2026-11-12-compact-android-and-stock-entry-continuation.json)，此前窗口为历史基线。

本文把当前项目目标拆成三个并行工作流。所有地址、结构和行为结论都必须绑定到具体固件身份；本机普通 YI 4K 当前基线为 1.10.7、构建 `a8f840ce_r2746`。公开 v1.10.52 只能作为静态参考，不能直接当成本机可写接口。

最新预录[紧凑原厂ARM导出](prerecord-native-window-compact.md)补齐从封口SPS派生的轨道几何，两个非零窗口经普通FFmpeg8严格包时间及完整解码通过，无共同前导空白；[Android平台独立验证](prerecord-android-native-mux-consumer.md)在API34模拟器读取全部1831视频/2863AAC并完整解码，独立选段像素/PCM一致。旧6.1与AVFoundation拒绝仍按消费者保留，实时相机SD/触发/实体手机尚缺。此前零轨道宽高输出仅有FFmpeg路径证据，不能沿用其宽泛兼容解释。

用户明确批准的[最小stock入口真机验收](device-1107-stock-entry-approved-run01.md)已完成：正常开关机后得到新boot ID、稳定任务概要和固定8字节指纹，脚本与三个归属诊断文件已清理，最终只读预检及所选API基线通过。这是原厂诊断入口证据，没有自定义ARM、固件或RAM写入授权。

EIS新增[陀螺仪输入合同](eis-gyro-input-contract.md)：22场景原码执行确认unsigned16/32768格式、原厂名义131 counts/(°/s)，并保留SPI失败仍返回成功的旧样本反例。输入的新鲜度、实际配置、相机轴标定及共同帧锚仍须设备证据，尚未接入候选算法或上机。

## 当前进展：0.4.7、真实归档增量 ring 与原厂语音复用

2026-11-12：Android [0.4.7](android-ui-0.4.7.md)移除顶部消息，重做单行参数与整窗全屏叠层，补齐中文设置并清理冗余。实际测试、构建和 AVD 范围见[回执](../artifacts/android/2026-11-12-build-0.4.7.json)；实体手机仍缺。

预录[真实归档增量闭环](prerecord-media-ring-end-to-end.md)将源录像按实际闭段通知交付、有界淘汰、触发锁定，再成片/失败保留恢复；两条 typed voice/shutter 路线均通过前60.864533秒+后1.064秒窗口，1856视频/2902AAC的字节和时间保真门禁，非零窗口末AAC时长问题已修复。它使用主机FFmpeg streamcopy，不冒充原厂event3、RTOS、实体SD或真实声音/GPIO触发。

EIS [候选v2](eis-candidate-mesh-replacement.md)修复持续转向漂移/采样边界，[归档ABI审计](eis-candidate-archive-abi.md)核对9组原厂输出；真实gyro仍缺标定/共同帧锚，不能声称画质改善或部署兼容。[autoexec存储门禁](device-1107-autoexec-storage-gate.md)恢复StorageIdle→Shell事件→固定脚本路径，缩小stock进入验收缺口；任意ARM入口、cache/SMP和独立回滚仍未完成。

[语音复用/关键词替换](voice-keyword-replacement-path.md)确认两语言共用1003/F0010338 START，沿用原厂成功口令无需改模型；任意新短语缺训练与完整推理/加载证据。该语音复用分析为离线范围；本轮设备操作仅含单独批准的stock诊断与归属清理，三项目标继续 active，状态见[矩阵](goal-evidence-matrix.md)。

## 历史进展：0.4.4、保留包存储恢复与退出证明

本轮交付、独立复跑和仍缺条件汇总在 [统一证据索引](../artifacts/verification/2026-11-11-goal-continuation-044.json)。

- Android [0.4.4 安装包及验收](android-ui-0.4.4.md)修复选片导入中旋转丢状态、交接文件提前删除，以及剪辑导出进程退出后的 pending 记录清理；保留连接首屏、页面内密码、相册自动加载、两阶段剪辑、统一标题、纸纹渐变及 Wi-Fi 断线竞态修复。199 项主机测试、Lint 0 errors / 66 warnings、同包 8 项常规 AVD 测试及原片/剪辑各 1 项实际 force-stop 恢复测试通过。两类恢复均先确认进程与准备任务仍在运行，再终止并启动新进程；准备阶段不计通过测试。实体手机和真实 Wi-Fi 断网仍待验收。
- 预录 [AAC 边界调度](prerecord-minute-aac-schedule.md)在原厂 event3+Close0 下完整保留 1920 视频包与 3003 AAC；原始第二段消费者末包时长仍拒绝。[宿主连续会话恢复](prerecord-minute-session-recovery.md)已将两段的归档 source epoch 与原始时间表接回 64.064 秒窗口，独立核对 4923 包字节/时间、1920 解码帧和完整 PCM 通过。不是相机实时一分钟缓存或实际触发绑定。
- [AAC 一包边界保管组件](prerecord-aac-boundary-owner.md)已实现精确切点比较、复制后独立持有、跨界推进与确认交接；32 host/ARM 和 517 项有理数比较经主线程复跑，真实 3003 AAC 及另 4096 项比较[独立回放](prerecord-aac-boundary-owner-independent.md)通过。下游确认不能以 writer/Close 成功替代，实际 producer/custody/SD 仍需绑定。
- 后续已把[C owner/custody 和原厂 event3](prerecord-aac-custody-native-integration.md)实际串联，短窗口41个已提交包关闭后核验再释放，尾AAC25仍持有；容量和关闭失败保留。新增[可编译追加包日志](prerecord-packet-spool.md)，31 host/ARM、3003实际AAC和8进程退出点独立通过；[22个实际失败/尾包快照](prerecord-retained-spool-recovery.md)从新文件在新进程精确恢复，记录边界缺包与torn marker均拒绝整套恢复。尚非实时一分钟环、物理SD耐久性或完整成片发布。
- EIS/预录共同的[自有退出保护组件](../sdk/offline/owned-retirement-contract.md)实现关闭准入、在途计数、外部停止证明、任务删除后单次释放；10 host/ARM、2 ARM 指令交错和 20 轮线程经独立复跑。相机服务尚未绑定，常驻 gateway/guard/context 不由该组件回收，首次执行、缓存发布和真实恢复门仍保持未完成。
- [TaskQuery 停止证明调查](device-1107-native-task-stop-proof.md)独立复跑32原ARM用例、3交错与一条context-save/调度清理。自然完成state1有实际锁保护；state2挂起终止允许在notifier返回前query/delete，查询错误还会拷无效栈输出。候选自然return绑定仍缺完整scheduler/SMP/独占生命周期验证。
- 本轮只读连通检查中相机 23/80/554/7878 均超时，ADB 无实体设备；没有新增相机写入或自定义 RTOS 执行。当前状态和下一步缺口以[证据矩阵](goal-evidence-matrix.md)为准。

## 历史进展：0.3.18 快门反馈与两条底层只读复核

- Android 0.3.18 修复拍摄时只看到通用状态文字的问题：快门按下立即反馈，等待相机时显示自身进度环，拍照闪光及录像圆/方状态均跟随相机确认；[APK](../artifacts/android/yi4k-control-0.3.18-debug.apk)、[说明与验证](android-ui-feedback-0.3.18.md)。Debug 单测 163 项通过、Lint 0 errors；实体手机仍待手动验收。
- EIS 新增[三阶段错误传播](eis-stage-failure-contract.md)：原厂协调器忽略 SetWarp 返回值，零分支还忽略 Getter 返回值。36 个原 ARM 有界场景、22 条固定指令经独立复跑一致；注入依赖查询失败时仍可能复制旧结果并置 ready。后续观测必须关联同一次 Calc/Set/Get 的返回和表身份，不能把生成零返回或 ready 当作本次准备成功。
- 预录新增[正常 event 3 完整切段回调](prerecord-event3-rollover.md)：原同步视频帧经 Close0/New/Copy/Rel/Reset/Open 仍保留，成为新段首帧，两段各 8 个视频帧与源解码一致；正常/短写故障两条路径均已独立复跑。严格发布仍拒绝 AAC12/25 被 Trim 丢弃及第二段时间线偏差；短写进入原厂断言，不能直接当作失败可恢复的设备后端。以上均为短构造 FIFO 的离线原码执行，没有实际分钟预录或真机部署。
- Android 0.3.16 的 UI follow-up 包已归档：[APK](../artifacts/android/yi4k-control-0.3.16-debug.apk)、[构建证据](../artifacts/android/2026-11-11-build-0.3.16-ui-followup.json)。未连接时自动扫描 YDXJ 热点，设备卡显示型号/Wi‑Fi/电池/SD，拍摄状态槽固定、快门有触感反馈，模式和规格切换自动刷新预览，设置/素材库默认目录与封面预览已收口；实体手机仍待用户手动验收。
- 预录新增[后端门禁完整性审计](prerecord-backend-gate-audit.md)：6 项检查通过，9 份基础证据哈希一致，8 个真机门仍明确保持未完成，没有把离线合同升级成相机实现。
- EIS 重新执行[ORC feedback 直接调用复核](eis-orc-feedback-call-sites-rerun.md)：1,647 个候选中反馈/pre-clear 窗口固定 7 个调用；仍未证明传输完成、cache/latch、DSP 运行时身份或旧槽安全释放。
- EIS 影子包装器与预录 SDK 组合链也完成新一轮离线复跑：[EIS v2 validation](../artifacts/device/2026-11-11-eis-shadow-v2-rerun/validation.json) 的差分 mismatch 为 0；[SDK pipeline validation](../artifacts/device/2026-11-11-prerecord-sdk-pipeline-rerun/validation.json) 保留成功/容量/参数变化/写短等失败分支。两者均明确无设备访问，不能替代真机 hook 或分钟预录。

## 历史进展：0.3.14 设置可读性与预录原厂封装

- [项目磁盘清理](project-disk-cleanup-2026-11-11.md)释放约8.04 GiB，保留固件、全部验收与失败证据及工具安装；归档APK本地9项复跑通过，runner可在成功并确认退出后回收AVD运行磁盘。
- EIS新增[原厂 GetPartitionInfo 复制合同](device-1107-get-partition-info-contract.md)：35复制、15拒绝、6风险模型经独立复跑通过。它只复制单条64字节记录，无表CRC/映射/缓冲容量保障，异常指针可能原生读失败，尚不是可安全部署的外部查询入口或恢复证明。

- Android [0.3.14](android-delivery-audit-0.3.14.md)修复真实截图暴露的长设置说明与参数值重叠，小屏/大字体及实际 Android 设置页验证通过；Debug/Release 各 128 项、本地 9 项与真实进程终止恢复两阶段通过。没有新增相机访问，旧相机证据保留版本归属。
- 同一产品 APK 的[大文件本地验收](android-large-original-export-0.3.14.md)另有两项通过：实际导出 4,296,015,995 bytes，源/输出/完整读回摘要一致，发布后可解码；超过 2 GiB 后取消不留半文件。输入为短 MP4 加合法填充，不代表相机长片或实体手机大容量兼容。
- Android 0.3.12 已补齐[同包完整 UI 拍摄/导出、横屏真实 RTSP、两种断网恢复](android-runtime-supplement-0.3.12.md)，并完成 455.7 MB、60 秒 4K 原片批量导出，以及 65 秒普通录像/照片与设置恢复。这些是模拟器连接真实相机，不是实体手机验收。0.3.13 已完成本轮交付验收，修复旧网络回调关闭新会话的竞态与进程终止后的 pending 原片清理；Debug/Release 各 127 项、同包四类真实相机回归、实际 force-stop/新进程恢复及本地 8 项媒体/编辑回归通过，详见[交付审计](android-delivery-audit-0.3.13.md)及[补充验收](android-runtime-supplement-0.3.13.md)。实体手机仍待用户测试。
- EIS 新增[公开版本启动加载器/CRC 边界](device-1107-boot-loader-crc-boundary.md)、[USB 家族源码调查](device-1107-usb-recovery-source-survey.md)、[公开 YI BLD 的 RTOS 前串口门控](public-yi-bld-pre-rtos-serial-entry.md)及[本机 SYS PTB RAM 候选](device-1107-hidden-ptb-ram-candidate.md)。SYS/USER 双组静态指针、15 个原选择器场景和 CRC/坏表控制通过；[读取路径安全审计](device-1107-ptb-read-path-safety.md)确认普通 Linux read 拒绝低页、历史快照未覆盖，原厂 RTOS 输出仍是未验证运行期安全性的候选；尚未采集候选 RAM 或隐藏启动内容。12 个原码门控场景通过，通用 Nexar loader 的字段假设与 YI 启动指令存在实际冲突。本机隐藏 BLD 身份、可靠板级恢复、首次原生执行和实际算法替换仍未闭合。后续采集中已有 USER PTB，不能继续把它整体描述为“没有 PTB”；隐藏启动区、另一 SYS PTB、OOB 和独立恢复仍缺。
- 预录[视频 early-copy](prerecord-early-copy-adapter.md)和[音频复制接缝](prerecord-audio-payload-chain.md)各 22 组宿主及编译 ARM 用例通过，共享队列 20,000 帧回归通过。没有安装 hook；仍需硬件稳定期、cache、callback 安装/卸载、真实 AAC 绑定和共同 A/V epoch。
- [自有 payload 到原厂 writer](prerecord-owned-mux-writer.md)的地址重定位与[可编译自有描述符适配层](prerecord-owned-mux-adapter.md)已离线验证。后续[原始 ARM 索引与完整 MP4](prerecord-native-mp4.md)进一步执行真实 MemIdx/IsoIdx Add/Commit/Read 与 MP4 Open/Close，11 个场景经主线程独立复跑；成功文件完整音视频解码通过。旧“只初始化 track”的第二段确实残留索引，现已用[原厂 movie factory 释放/重建](prerecord-movie-factory.md)补齐：同一 movie/MemIdx/mux 两段独立解码、索引读回通过，第二段清零由原厂 ARM memset 执行。文件/锁/分配器仍是 RAM 模型，样本为重复归档包，不等于真实 SD 或连续捕获；整个 AppLib 调度尚未执行。
- [codec epoch 与参数集缓存](prerecord-codec-epoch-adapter.md)的 49 组主机、49 组编译 ARM 和两条原厂完整 MP4 路径已在冻结源码上独立复跑。新段 slice-only IDR 补入同配置 SPS/PPS 后可解码，已携带参数时原样保留；实际编码器配置绑定、真实 GOP 和一分钟 SD spool 仍未接入。
- [SDK实际组合接缝](prerecord-sdk-pipeline-integration.md)将early-copy、自有队列、owned-mux、codec epoch和私有writer描述符真正串联，18组host+ARM及1条原厂完整索引/MP4路径经主线程独立复跑。源环覆盖后仍使用自有字节；配置/容量/写入失败保留槽位且禁止直接重试。桥接仍是离线fixture，完整MP4每轨一个归档sample，无真实callback/存储/并发或分钟吞吐证据。
- [视频就绪事件与音频 gate](prerecord-gate-epoch.md)的 8 组完整原函数执行独立复跑通过：该事件只重复开门，不重置音频计数/PCM 游标，不能充当共同 A/V 零点。旧跨文件说明的 event+4 字段身份已纠正，共同采集时钟仍缺。
- [原厂同会话 DTS 重基准](prerecord-session-timeline.md)完整 RestoreDTS/ResetMovie/真实 FIFO Peek/ConvertPTS 的 8 例独立复跑通过；正常无需 AdjustDTS 修正的输入对两轨减同一个基准，保留调整后差值，队首视频描述符不消耗。尚未覆盖任意重排/VFR 或真实连续 GOP，不能把 mux DTS 当作共同硬件采集 epoch。
- [真实 I/P GOP 与 AAC 封装](prerecord-real-gop.md)用归档原片前16个不同视频帧替代重复IDR，经原厂factory和mux输出两段，选中包hash/视频帧/独立AAC解码相同，四场景独立复跑完成。但按完整包窗口选取漏掉段间AAC12；两种时基的第二段消费者时间线均被严格拒绝，原始ELST/STTS与ffprobe差异保留，不能称连续音频无损切段。
- [跨界AAC归前段与Close](prerecord-aac-boundary-close.md)进一步将26个AAC包无缺无重提交writer，正常Close0仍裁掉跨界AAC12/25且原offset被MOOV覆盖。未知Close1离线对照可保留26包，但调用来源、消费者时间线和真机集成均未通过；不能把ProcessAudio成功当作分钟历史持久保留，下一步为合法切段调度或独立跨界AAC保留。
- [真实 65 秒素材的主机分段回放](prerecord-host-replay.md)发现并修复 AAC 段尾导致的约 315ms 累计时间漂移。失败 run01 保留；run02 的 32 段、1,920 视频包与 3,003 音频包全部相同，PTS/DTS/duration 与来源一致，共同偏移为零。另已加入[发布前保真门禁](prerecord-publication-gate.md)，主线程独立复核正常发布与真实 100ms 音频偏移拒绝共 11 项检查通过；AAC 首包修复后的 35 项预录单测通过，主线程独立重跑了无 B 帧同源正负对照；实际音频延后 100ms 仍被拒绝。无 B 帧非零起点另有 FFmpeg 6.1 末包时长误报限制，直接 STTS 对照一致，但当前保真检查继续拒绝发布。人工 B 帧/非零选择起点也有独立样例。该结果不等于相机端实时预录、语音或物理快门绑定。

本轮有普通 API 配置恢复和录像/照片写入；没有固件、RAM、分区或启动区写入，没有执行自定义 RTOS/ORC。旧节的数值和散列属于各自历史快照，当前要求与缺口以[验收证据矩阵](goal-evidence-matrix.md)为准。

## A. 完整 Android App

目标是交付一个可日常使用的 Android App，覆盖相机连接、配置、拍摄、媒体浏览和原片导出。

阶段验收：

1. 连接：按相机热点路由选择 Wi-Fi、建立 7878 会话、处理通知/超时/断线并能安全重连。
2. 配置：读取设置和选项，显示权限，修改可写配置；修改前后检查相机状态，失败时保留会话并提示实际错误。
3. 拍摄：照片、开始录像、停止录像、状态刷新和模式检查；异常中断后能重新连接并确认实际状态。
4. 媒体：浏览 `/tmp/fuse_d/DCIM/`，限制路径在 DCIM 内，显示大小和时间，完整下载到 MediaStore，并校验长度和 SHA-256。
5. 验证：主机 Gradle test/lint 通过；协议测试覆盖粘连 JSON、通知、拒绝、超时和路径穿越；真机验收覆盖连接、配置恢复、短录像、照片和视频导出。

## B. EIS 替换路径

目标是先恢复可关联的原始观测，再以单变量方式替换原厂轨迹或 warp 生成逻辑，保留原厂视频管线和回滚能力。

阶段验收：

1. 固件对齐：记录完整 RTOS SHA-256、函数体指纹和地址适用范围。
2. 只读契约：记录 gyro 样本序号/时间、曝光、帧状态、warp 表标识/尺寸/格式、提交耗时、丢样和表未就绪计数。
3. 最小执行：在有恢复方案的前提下验证自定义代码进入、打印/标记、返回和任务生命周期；先不读 gyro、不写 warp。
4. 影子模式：复制原厂输入和输出，离线比较平滑、相位、网格和提交时序，不改变录像结果。
5. 单变量替换：依次评估时间对齐、轨迹平滑、逐行 RSC 和网格发布；每次保留原厂路径作为回退。
6. 真机验收：预览和录像分别验证，检查 1080p/4K、启停、长录、低光、温升、丢帧、音画同步和重启恢复。

## C. 固定一分钟预录

目标是实现类似 DJI Osmo 的固定一分钟预录。首版优先使用原厂硬件编码和 SD 卡分段，避免把高码率一分钟视频放入 RTOS 应用池；最终输出应为可直接播放的视频。

状态机：

```text
OFF -> ARMING -> PREBUFFERING -> COMMITTING -> RECORDING -> FINALIZING
                                  START -----------^
```

阶段验收：

1. 静态闭环：确认编码 bitstream/FIFO 的订阅边界、IDR/SPS/PPS、音视频时间基、EventRecord/mux 的可复用入口和生命周期。
2. 分段原型：按关键帧切分短段，保留最近 60 秒，触发后停止淘汰并继续写入；每段带 manifest、PTS/DTS、码率和完整性信息。
3. 触发统一：快门短按和相机固件已经识别出的语音事件都转换为幂等 `START`；目标事件对应准确口令 `开始录像`/`start recording`，必须在相机侧实测。App 不承担语音识别，也不替换相机关键词模型。`STOP` 单独处理并抑制重复事件。
4. 封装发布：先验收“片段集合可播放”，再实现相机内无重编码合并为单个 MP4；触发前窗口从最近 IDR 开始，实际时长必须记录。
5. 真机验收：固定 60 秒预录加触发后录像，检查第一次播放、音画同步、触发点连续、重复触发、满卡、拔卡/掉电、长时间温升和恢复普通录像。

## 变更与设备安全边界

主机代码、离线逆向、已有固件读取、证据整理、编译和协议测试可直接推进。普通 API 录像和可恢复的只读实验必须保存前后状态并清理探针。涉及 RTOS/启动区/分区/持久化补丁、无法确认回滚的文件写入或可能导致设备无法启动的操作，必须先得到用户确认，并提交变更范围、风险、回滚步骤和停止条件。

## 当前依赖顺序

Android App 可以独立完成并作为后续真机实验控制器。EIS 和预录的静态追踪可以并行；两者进入 RTOS 运行期替换前，都依赖最小原生执行闭环和可靠恢复路径。预录还依赖编码流订阅和 mux 生命周期，不能把现有 `PreRecord` 偏好字段直接视为已经存在的功能。

## 2026-11-11 UI 视觉重做与新增只读边界

### 2026-11-11 独立回归与低层边界补充

- Android 0.3.11 修复极短横屏布局：隐藏装饰性预览表面、参数胶囊收缩为 44dp，中央快门、参数、模式和底部导航保持完整可见；真机探针改用 `capture_mode`/`rec_mode` 子字段切换和恢复模式。Debug/Release 各 110 项、Lint、PrototypeRenderTest、CaptureUiTest、Debug/Release 构建均通过。交付包与证据见 [0.3.11 APK](../artifacts/android/yi4k-control-0.3.11-debug.apk)、[构建摘要](../artifacts/android/2026-11-11-build-0.3.11.json) 和 [交付审计](android-delivery-audit-0.3.11.md)。实体手机验收仍待执行。
- Android 0.3.10 修复短屏/横屏预览高度挤压参数与快门区的问题；预览高度可降至 72dp，紧凑布局隐藏说明文字并保留实时预览入口。PrototypeRenderTest、CaptureUiTest、Gradle/Lint 和 APK v2 签名验证通过。交付包与证据见 [0.3.10 APK](../artifacts/android/yi4k-control-0.3.10-debug.apk)、[构建摘要](../artifacts/android/2026-11-11-build-0.3.10.json)、[完整性证据](../artifacts/android/2026-11-11-apk-integrity-0.3.10.json) 和 [交付审计](android-delivery-audit-0.3.10.md)；仍未完成实体手机验收。
- Android 0.3.9 在本机重新执行 `testDebugUnitTest`、`lintDebug`、`assembleDebug` 并通过；APK 仍由 v2 签名验证通过，SHA-256 与交付包一致。记录见 [independent build rerun](../artifacts/android/2026-11-11-independent-build-rerun.json)。当前没有可用的实体 Android 设备，未把这次构建升级为物理手机验收。
- EIS 新增 [ORC 低层传输依赖审计](eis-orc-transfer-dependency-audit.md)。成功路径的普通控制流、分块准备和唯一可见 SPR 读取已固定；真正的传输点仍是未解码的专有字，不能解释为 DMA/MMIO、完成回执或缓存发布。
- EIS 新增 [ORC 专有传输字跨 member 交叉审计](eis-orc-proprietary-crossmember-audit.md)。`F0000049`、`FC60xxxx`、`F1E3xxxx` 只出现在 `orccode.bin`；局部排列有返回和循环两种后继，不能把它们命名为固定 fence、返回或 DMA 指令。语义和硬件完成边界仍未知。
- 预录新增 [关闭/静止边界审计](prerecord-close-quiescence.md)。原厂普通 MP4、EventRecord 和 UVCd 路径都缺少可复用的 callback quiescence；已有交错证据显示 Delete 成功后旧 callback 仍可能执行，因此预录后端必须自有 admission gate、在途计数、payload lease 和 Delete 前 ownership 检查。
- 预录新增 [producer 连续性与 virtual FIFO 审计](prerecord-producer-continuity.md)。已确认 virtual descriptor ring、读写游标初始化、producer fan-out 和 virtual read cursor 参与 base 回收边界；payload lease、运行时背压、跨 rollover 连续性、callback quiescence 和共同 A/V epoch 仍未证明。
- 真机新增 [只读探针 04](device-readonly-probe-04.md)：相机热点 80/7878 可达，操作前后均为 `idle`，媒体条目 44/44，关键设置和选定设置一致，未拍照、录像或修改配置。
- 真机新增 [普通录像探针 01](device-record-probe-01.md)：3 秒录像成功进入 `record`，停止后回到 `vf`，新增 MP4 可导出；H.264/AAC 完整解码、首个 IDR、PTS/DTS 单调和设置恢复均通过。该证据不冒充一分钟预录或 EIS 替换。
- 真机新增 [拍照探针 02](device-photo-probe-02.md)：通过 `capture_mode` 子字段完成 `record → capture`，真实 4000×3000 JPEG 拍摄、导出和 JPEG 元数据校验通过；随后通过 `rec_mode` 恢复 `record`，前后选定设置一致。
- 本轮离线/真机回归索引见 [independent regression rerun 05](../artifacts/verification/2026-11-11-independent-regression-rerun-05.json)。真机操作仅限只读探针和可恢复的普通拍照/录像；没有执行 ORC/RTOS 代码或写入固件、RAM、分区或启动区。

- Android 0.3.8：按参考原型进一步重排拍摄页、相册和设置页。拍摄页加入设备状态分隔、电量/存储卡信息、参数胶囊、中央快门和相机切换；相册使用图像优先的 16:9 双列卡片和紧凑导出操作；设置行采用中文标题/说明、右侧当前值胶囊和箭头；底部导航增加层次。debug/release 各 110 项单元测试、Lint、PrototypeRenderTest 和 APK 构建通过，APK 与截图证据见 [0.3.8 构建摘要](../artifacts/android/2026-11-11-build-0.3.8.json)。本轮仍未访问物理手机或相机，0.3.6 的真实相机证据继续按版本归属。
- Android 0.3.9：根据文案审计清理拍摄页 `CAMERA CONTROL`、`FOV` 和摘要中的 `EIS`，分别改为“相机控制”“视角”“防抖”，并补充 NTSC/PAL 的中文制式值。最终源码独立复跑 debug/release 单测各 110 项、Lint、PrototypeRenderTest 和 APK 构建通过；交付包与证据见 [0.3.9 构建摘要](../artifacts/android/2026-11-11-build-0.3.9.json)。技术标准名和未知原始字段仍保留，避免丢失排障信息；尚无物理手机验收。
- EIS：新增 [VCAP update address 所有权审计](eis-vcap-update-address-owner-audit.md)。固定镜像 ARM 路径只找到两处 `DAT_a06f3380+0x58` 引用：关停清零和 CPU 读取；`DEADBEEF` 写入属于消费后的哨兵重置，未发现第二个非哨兵 writer。ORC `smem_2_dram`、DMA/MMIO 及间接路径仍未闭合，不能升级为 DSP ack 或替换入口。
- EIS：新增 [ORC smem_2_dram 范围审计](eis-orc-smem-vcap-scope-audit.md)。固定 ORC 的 67 个直接候选中，只有一个匹配 `shared+0x3c` feedback 参数形态，一个匹配 pre-clear 形态；其余 64 个不匹配。helper 和 staging/代码传输路径仍不透明，不能升级为 DSP ack 或替换入口。
- EIS：新增 [ORC staging helper 范围审计](eis-orc-staging-helper-scope-audit.md)。两个不透明 helper 的直接调用和 `0x2a20` 参数窗口已固定，但专有 opcode 未能解码；没有发现标准 shared+0x3c 写集，复制方向、DMA/MMIO、cache/atomic 和硬件 latch 语义仍未知。
- EIS：新增 [最小原生执行前置条件矩阵](device-1107-native-execution-prereq-matrix.md)，覆盖 P0–P12 的固件身份、独占 NC 分配、页表/缓存/SMP、ABI、结果通道、隔离、撤销释放、冷启动恢复和分阶段真机验证。矩阵仍把 D/I-cache 发布、独占入口、回滚和冷启动恢复标为缺失或部分，未形成可执行真机方案。
- 预录：新增 [loop 删除游标门控审计](prerecord-loop-delete-gate.md) 和 [loop 恢复游标审计](prerecord-loop-recovery.md)。`DelLoopEncFile` 受 loop mode（mode 6）和删除计数/数据库游标推进门控；恢复会话保留旧游标，新会话从主文件 ID 初始化。未发现文件名、时间或会话标识归属校验，不能把原厂 loop 恢复直接用于相机预录后端。
- 预录：新增 [跨文件共同采集起点审计](prerecord-cross-file-epoch.md)。音频 source gate、音频 PTS、视频 DSP PTS 修正和 event/FIFO 关系已固定，但 event→gate 路径只传 pipeline 身份，没有传递 PTS、DMA block 或视频 ring index，共同采集 epoch 仍未证明。
- 预录：新增 [最小相机后端合同](prerecord-minimum-backend-contract.md)，把单一 FIFO owner、`Peek → Copy → Persist → Remove`、EOS、`CURSOR_UNCERTAIN`、quiesce/Delete、mux 切段和恢复策略固定成 10 状态/9 转移模型；8 个真机门槛（virtual lease、callback 静止、首帧参数集、A/V epoch、producer 连续性、掉电/满卡、语音/快门绑定等）仍缺证据。
- 回归：独立复跑 ORC 表生命周期/垂直消费者、EIS v2 影子包装器、触发路由、FIFO consumer 和主机分段运行期验证；结果索引见 [2026-11-11 independent regression](../artifacts/verification/2026-11-11-independent-regression.json)。

本节新增执行均在主机离线完成，未连接或写入相机。

随后单独运行了一次 `recordSeconds=0` 的普通 Android 探针，只读确认相机仍为 `idle`、关键设置未变化、媒体条目数量前后一致；证据见 [2026-11-11 只读复跑](device-readonly-probe-03.md)。该探针没有录像、拍照或修改设置。


## 2026-11-10 首版基线（后续进展见下节）

- Android：动态配置、批量媒体导出、取消、忙碌状态和断网处理已实现；主拍摄页按 APEX 原型重做为白色设备工作台，包含品牌/设备状态、宽幅山景占位预览、状态胶囊、五项参数、中央快门，以及“拍摄 / 相册 / 剪辑 / 设置”四栏导航；设置页提供中文名称、中文值和用途说明，同时保留未知 wire key。新增注入式 `CaptureTriggerAdapter`，但仍只停留在未来预录后端的语义边界，不调用 `CameraClient`。debug/release 各 23 个主机测试通过，lint、APK 构建和 instrumentation 源码编译通过，构建摘要见 [Android build evidence](../artifacts/android/2026-11-10-build.json)。统一触发路由覆盖快门短按、相机动作层已确认的类型化 `CameraVoiceEvent.START_RECORDING`、幂等 START 和失败重试；App 不接收语音文本、不使用麦克风、不做语音识别，尚未接入相机事件或预录。最新只读设备基线见 [current-readonly.json](../artifacts/device/2026-11-10-current-readonly.json)：固件 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`、硬件 `YDXJ2_V13LW`、`record/idle`、电量 100%、SD 已插入、18 个媒体条目，前后设置和媒体列表一致；手机路由、UI 与 MediaStore 仍待设备级验收。真实探针现在要求模式设置读回目标值后才会继续拍摄。
- EIS：标量定点滤波参考和回放器已实现；完整原始 ARM 函数在 Unicorn 下 3,240 组输入对比为零差异；固定容量影子记录器在 ARM/Unicorn 下 512 组包装调用零差异，并通过满缓冲、嵌套调用和栈边界检查。v2 离线 wrapper 已验证 512 组、`previous_after`、v2 commit 发布顺序、满缓冲丢弃、原厂旁路和寄存器/SP 保持，报告见 [v2 validation](../artifacts/device/2026-11-10-eis-shadow-v2/validation.json)。warp 发布生成器的 31 条设备字节静态契约检查全部通过，报告见 [warp publication contract](../artifacts/device/2026-11-10-eis-warp-publication/contract.json)；最新完整固定镜像引用审计发现发布指针 5 个引用均来自 `A02C5FD8` 自身，外部固定代码引用为 0，仍不能排除间接 DSP/MMIO 消费，见 [warp consumer audit](eis-warp-consumer-audit.md)。消费者/缓存边界仍没有可见 DSP latch/ack、旧槽回收或状态函数中的 clean helper。新增 stock-only 边界 trace 严格 gate：要求不少于 2,000 行、双站点覆盖、自适应/限幅覆盖、previous canary 和全行零差异；尚无真机边界 trace、hook 或算法效果结果，已整理 [待确认真机采集方案](eis-stock-boundary-capture-proposal.md)，见 [回放说明](eis-filter-host-replay.md)、[影子记录器](eis-1107-shadow-recorder.md) 和 [边界 gate](eis-boundary-trace-gate.md)。
- 预录：修正 EventRecord 注销路径和 IDR feed 输入方向的静态解释；新增一分钟分段主机原型，H.264 B 帧/AAC 的包完整性与时序检查通过，并增加 5/15/60 秒窗口阶梯回归；进一步确认视频 `FrameDesc`、编码事件回调、virtual FIFO 同步以及 mux 的 peek/write/remove 链。最新 39 项静态断言确认原生 MP4 和 UVCd virtual FIFO 创建参数、旁路消费/删除调用、descriptor/payload 所有权、PTS 转换和关闭顺序；FrameDesc/Buffer 边界回归覆盖最大 PTS、payload 元数据、空队列、段名路径越界、解码失败恢复和“先复制 payload 再推进 cursor”，完整 Python 测试现为 33 项通过。主机侧规范输入是相机动作层已送达的 typed `START_RECORDING` 事件与快门 press；短语只在离线测试夹具中映射，不代表 App/主机识别。相机编码流适配、相机语音事件的真实来源和预录落盘仍未接通，见 [主机原型](prerecord-host-replay.md)、[触发契约](prerecord-trigger-contract.md)、[virtual FIFO](prerecord-virtual-consumer.md) 与 [输出契约](prerecord-output-contract.md)。

以上为三条主线的阶段进展，不能视为项目完成；本轮所有新增执行均在主机，未写入相机。

## 2026-11-10 原型重做与离线链路补充

- Android 0.2.0：新增三步连接引导；拍摄参数改为实际相机读回值与中文标题，切换录像/照片/延时/慢动作通过协议验证、写入及读回确认。补齐大量 1.10.7 设置项的中文用途和值。原片回放新增绑定相机网络的完整下载、照片查看、视频封面/播放暂停/常驻时间轴、真实文件信息与本地收藏。RTSP 预览采用相机会话返回地址、绑定 Wi-Fi SocketFactory 和 TCP interleaved，首帧前保留占位图；尚无真机解码验收。主机运行界面测试和原生绘制结果可复查，但不能替代手机显示、Wi-Fi、解码和 MediaStore 验收。五张原型尚未完全落地：素材缩略图和剪辑处理仍待完成。最新测试数量、APK 哈希及界面范围以构建证据 JSON 为准。
- EIS：新增 [间接 DSP 发布审计](eis-indirect-dsp-publication-audit.md)，43 条固定指令及 5 项数据检查通过。已恢复 `VCAP_SETUP.eis_update_addr` 经 0x80 字节命令缓冲传递发布字地址的 CPU 路径；修正 `+0x80` 是状态槽地址，状态槽 `+0x24` 才是 warp 描述地址。DSP 锁存/ack、缓存所有权和旧槽回收仍未证明，不能进入自定义 warp 提交。
- 预录：新增 [时间戳换算审计](prerecord-timebase-audit.md) 和 [轨道字段来源审计](prerecord-track-writers-audit.md)。后者通过 29 条指令检查、25 组宿主执行并提取 176 项 sensor 表；源比例来自 sensor 配置，原点来自首个消费描述符，正常 DTS 按轨道周期推进，恢复时另修正偏移。普通 MP4 和 EventRecord 音频配置不同，真实 A/V 起始偏差、编码器时钟与完整 60 秒生命周期仍未验收。描述符队列存储已更正为每队列 256 KiB，不含 payload。

本节新增执行均在主机，未连接或写入相机。EIS 替换和相机独立预录仍未实现，App 不承担语音识别。

## 近期执行队列

1. **Android 可验收包**：0.3.5已交付，同包60秒4K配置/拍摄/照片/恢复、455.8MB实际界面批量原片导出两项通过。0.3.4四套断网/拍摄/导出用例保留版本归属。0.3.6固定快门/模式、自适应预览和同包4K界面批量导出已验收并更新latest。继续覆盖用户手机热点、完整预览/回放/编辑及音画同步；五张原型未实现交互保持明确。
2. **EIS 原厂生产边界与执行入口**：已找到持原厂context mutex的A0311D8C生成边界，可继续复用原厂scratch→ring→copy/clean→发布；限定EIS调用链，避免hook测试/Ituner入口。验证原厂生成器有效写集、profile和帧身份，随后才讨论单变量替换。首次原生执行、同步、返回和恢复仍未打通，不能用allocator锁或软件标志代替这些关卡。
3. **预录生产合同**：已连通正常IDR/NAL5→bits_info→FrameDesc type1，并识别EOS同type的例外。继续闭合硬件counter baseline、SPS/PPS+slice实际payload范围、runtime FIFO cursor和共同音视频时间线，落成native复制/分段后端，再验证60秒片段保留、触发停止淘汰及完整输出。
4. **相机触发接入**：语音START/STOP类别和物理快门/电源长按、消息owner/gate均有原码审计，纯C统一router离线通过。仍须补来源/按压周期去重、实际后端确认、准确中英文口令和设备GUI运行验证；不由App识别代替。
5. **真机边界**：普通相机 API 及可恢复观测按用户既有授权推进并保留证据。涉及启动/固件/分区写入、无法确认回滚或可能导致设备不能启动的实验，先完成具体补丁和恢复方案，再请求用户确认；不把所有 SD 文件操作一概设为审批事项。

每个工作流只有在对应阶段验收证据齐全后才进入下一阶段；静态反编译、合成 trace、主机回放和渲染不能替代真实设备证据。

## 2026-11-10 Android 0.3.0 补充

新增本地视频编辑：系统文件选择器导入、片段范围、静音、旋转、黑白效果、新 MP4 导出和 pending MediaStore 提交。旋转后恢复编辑参数，按 UUID 会话清理失效缓存。相册新增真实封面缓存：显式读取有大小上限的照片，视频从已打开原片取得封面；不自动下载大视频。配乐、文字、转场、变速和多片段编辑尚未实现。主机测试、Lint 和 APK 的最终结果以对应版本构建证据为准；设备编解码用例仅编译，手机实际效果待验收。此轮没有新的 EIS 或预录真机执行证据，相关目标保持未完成。

## 2026-11-10 DSP 完整只读身份与预录音频生产者

- EIS：完成 [本机 DSP 有效镜像只读捕获](../artifacts/device/2026-11-10-dsp-full-readonly/capture.json)，4,038,656 bytes 的完整 SHA-256 与相机端独立重读、公开参考均一致；API 前后状态一致、boot ID 未变。四个成员 CRC、21 条本机 ARM 加载指令和七处 EIS 诊断字符串可复查，见 [DSP 参考边界](eis-dsp-reference-boundary.md)。这证明存储镜像相同，不能证明运行期微码身份、ORC 指令语义、DSP latch/ack 或安全旧槽复用，尚未替换算法。
- 预录：新增 [音频 PTS 生产者审计](prerecord-audio-producer-audit.md)，原始 ARM/Thumb 指令的 15 个宿主用例通过。确认启动清零的编码帧计数按 90 kHz 合成音频 PTS；仍缺视频与音频的共同采集起点，因此不能直接比较两轨 raw PTS 裁切一分钟。没有在相机端执行预录代码或触发绑定。
- 最新相机只读就绪快照：[native-entry-readiness-03](../artifacts/device/2026-11-10-native-entry-readiness-03/session.json)。1.10.7、record/idle、1080p30、EIS on；未上传启动脚本、未写固件/分区/内存、未重启。独立恢复协议仍未验证，启动补丁继续保留为离线候选。
- 实时预览增加 [真实相机流的主机首帧解码证据](android-camera-preview-runtime.md)：正常 API 进入/退出 VF，FFmpeg 通过 TCP RTSP 解码 H.264 848×480 画面，约三秒采集 91 个包，未发现音轨；状态/设置恢复。这不是 Android/手机验收，预览流也不能代替原片画质及带音频预录。
- Android 后续验证：修复测试 APK 中重复打包系统 JUnit 类的问题；完整 `test lintDebug assembleDebug assembleDebugAndroidTest` 通过。Android 34 AOSP arm64 AVD 实际安装已交付 0.3.0 APK并运行四项 instrumentation 全部通过，包括 Media3 实际截取、静音、旋转、黑白像素和保留 AAC 样本。见 [执行证据](../artifacts/android/0.3.0-device-reports/aosp-api34-run02/acceptance.json)。已检查连接引导实际截图，AVD 进程已关闭。物理手机、4K、大文件、音画同步和完整 MediaStore 流程仍待验收。

## 2026-11-10 Android 0.3.1 运行验证修正

实际 Android 截图发现白色底部系统栏中的浅色导航键对比度不足，已为主页面和剪辑页面设置深色导航键。交付 `artifacts/android/yi4k-control-0.3.1-debug.apk`（versionCode 4），0.3.0 包与证据保留。debug/release 各 95 项主机测试、Lint 0 errors / 54 warnings、应用与测试 APK 构建通过，V2 签名通过。新版 APK 在 Android 34 AOSP arm64 模拟器重新安装运行四项 instrumentation 全部通过，导航键实际截图已复查；见 [构建证据](../artifacts/android/2026-11-10-build-0.3.1.json) 和 [运行记录](../artifacts/android/0.3.1-device-reports/aosp-api34-run01/acceptance.json)。物理手机验收及 EIS/预录实现仍未完成。

## 2026-11-10 Android 真机源预览与完整剪辑流程

- 实际相机 RTSP 已通过 Android AOSP 34 arm64 的 `CameraLivePreview` 组件接收和显示首帧，用例等待真实 ExoPlayer `onRenderedFirstFrame`；[camera-preview-run01](../artifacts/android/0.3.1-device-reports/camera-preview-run01/acceptance.json) 通过，相机 idle/VF/idle 恢复、所选设置一致，AVD 关闭。模拟器经宿主路由，网络报告 CELLULAR；物理手机 Wi-Fi 选择及 MainActivity 全流程尚未验收。
- 0.3.1 的真实 Android MediaProvider 发布/取消两项检查通过，加上已有四项，[mediastore-run01](../artifacts/android/0.3.1-device-reports/mediastore-run01/acceptance.json) 共六项通过。
- 真实系统 DocumentsUI 选择视频、编辑界面调整范围/静音/旋转/黑白、点击导出并发布可解码 MediaStore 结果的完整流程通过，见 [editor-workflow-run02](../artifacts/android/0.3.1-device-reports/editor-workflow-run02/acceptance.json)。源为三秒小型合成夹具，不证明相机原片画质、手机大文件和音画同步。产品 APK 仍为同一 0.3.1 哈希。
- EIS 替换及相机独立一分钟预录、相机语音/快门触发仍未执行；本轮未增加有变砖风险的相机写入。

## 2026-11-10 Android 0.3.2 连续效果释放修复及交付

合并七项实际 Android 用例暴露旧 Media3 1.5.1 的 EGL 上下文释放原生崩溃；对照上游资源所有权后统一升级至 1.8.0。已交付 `yi4k-control-0.3.2-debug.apk`（versionCode 5），旧包和失败日志保留。debug/release 各 95 项单元测试、Lint 0 errors / 54 warnings、应用/测试 APK 构建与 V2 签名通过；同一 Android 进程七项本地用例全通过，实际相机 RTSP 首帧一项单独通过。证据见 [0.3.2 构建摘要](../artifacts/android/2026-11-10-build-0.3.2.json)。相机状态/设置恢复，模拟器关闭；最新 APK 别名已更新。物理手机、真实大文件/音画同步、EIS 替换和相机独立预录仍未完成。

## 2026-11-10 预录生产者与音视频起点约束

并行追查新增两条证据链：[视频 DSP 描述符与 PTS 回绕修正](prerecord-video-producer-audit.md) 的 19 个原始指令离线用例通过；[音频配置来源与启动顺序](prerecord-audio-config.md) 的 10 个 ARM 前缀用例和 10 个指令核对通过。确认 FrameDesc 视频 PTS 已经过 DSP 事件层有状态修正，c0/c1 分支的 base/previous 更新不同；主次音轨的三个已审计配置项均给出 48000。音频输入可在 liveview 提前启动，录像时才清零编码帧数，按顺序先音频后视频调用 start 不证明同步采集。

已更正旧描述符表关于音频序号来源的表述：来自实例计数器，事件+8是音频 PTS。以上均复用固定 1.10.7 镜像、宿主构造 RAM，没有设备连接或写入。原生执行入口、真实共同采集起点、一分钟 payload/文件生命周期、相机语音和快门绑定尚未完成，不能将上述离线检查当作相机预录已经可用。

另对已保存的真机原片 YDXJ0142.MP4 只读检查全部封装包，确认视频 80 包为 30000/1001 时序，音频 125 包为 48 kHz/1024 采样时序，DTS 均递增；[时间线证据](../artifacts/device/2026-11-10-prerecord/original-media-timing.json)。文件内两轨归零仍不能证明实际采集同步，没有将短原片重复扩展为一分钟验收。

## 2026-11-10 真实 Android 相机原片导出与音频采集门

- Android：已交付 0.3.2 APK 在 AOSP 34 arm64 通过两项显式真实相机媒体用例，既有 MP4/JPEG 经实际 CameraClient、绑定网络 HTTP、MediaStore 发布后，与相机端只读 sha256sum 独立摘要一致；视频/JPEG 实际解码，收到真实字节后取消不留残缺条目。相机状态、选定设置、完整目标目录列表、源文件摘要和 boot ID 前后相等，AVD 停止；不是物理手机或 MainActivity 完整流程。见 [媒体运行证据](android-camera-media-runtime.md)。
- 预录：新增 [输入采集与样本接纳门审计](prerecord-capture-epoch.md)，11 个原始 ARM 片段与 8 条指令断言通过并由主 agent 复现。liveview 可提前启动输入，但 source gate 未打开时 writer 不复制 PCM，输入消费索引仍可推进；录制开启 source gate 才决定被接纳样本边界。DMA ring/PCM buffer 本链未发现共同采集时间戳，不证明全固件没有其他同步机制。相机独立一分钟预录、语音和快门触发尚未实现。

## 2026-11-10 完整界面原片导出、真实素材剪辑与固件反馈新证据

- Android：同一 0.3.2 APK 的 [MainActivity 完整只读流程](../artifacts/android/0.3.2-device-reports/camera-main-workflow-run02/acceptance.json) 一项通过：实际连接引导和 Wi-Fi Network 选择、中文设置、相册两份真实素材选择与批量原片导出、独立 SHA 校验及断开。另有 [真实原片编辑流程](../artifacts/android/0.3.2-device-reports/camera-original-editor-run01/acceptance.json) 一项通过：既有 31.4MB/3.637s 1080p 视频经真实下载、DocumentsUI 和编辑器 UI，以非关键帧 500–2500ms 范围保留原声、灰度及90°旋转，发布后实际解码为1080×1920/2017ms，60个视频样本和94个AAC样本可读；源哈希保留。两次运行均核对相机前后状态/设置/列表/源摘要/boot ID相等并停止自身AVD。不是物理手机、4K/长文件或听感同步验收；各套件分别运行，未称为统一12项套件。
- EIS：新增 [CPU反馈标签和完成边界](eis-completion-state-boundary.md)。63条固定指令、4个helper、128组合成反馈、4个哨兵守卫和3次无反馈发布通过并复现。纠正此前遗漏focused导出造成的“没有直接调用者”：原厂CPU会读取shared+3C的子索引/WarpReady标签并写DEADBEEF，发布state slot+20格式匹配，但DSP非哨兵写入/latch/旧槽释放仍未恢复，不能据此提交自定义warp。
- 预录：新增 [原厂DSP事件到音频gate钩子](prerecord-start-anchor.md)。14个实际指令片段和11个字节断言通过并复现。视频context和音频context通过同pipeline标识关联，DSP event13可调用音频开门；但本构建音频启动已直接提前开门，该事件不是首样本共同epoch。后续优先保留同一原厂录制会话/时间线探索裁切，继续核实gate首次0→1、DMA block与视频首PTS；尚未实现相机独立预录或语音/快门绑定。

## 2026-11-10 模式切换根因、DSP 微码与分段边界

- Android：0.3.2 的 capture-workflow run04 已通过真实 MainActivity 修改画质、独立新会话读回及约三秒录像启停，生成 `YDXJ0147.MP4`（19,813,286 bytes）；随后照片切换失败，整项验收不通过。状态、原设置、旧素材摘要和 boot ID 恢复/保留。固定原码和三次有界普通 API 实验证明 [system_mode 的假成功根因](android-camera-mode-apply.md)：该 msg2 handler 只回成功，不执行切换；实际要通过 capture_mode/rec_mode 的原厂 GUI apply。run03 已真实完成 capture→record 并恢复 idle，未拍摄。产品修复正在按父/子模式联合读回、不重发不确定写入验证，不能用该 API 探针代替 MainActivity 拍摄闭环。
- EIS：新增 [真实反馈日志关联](eis-feedback-live-correlation.md)：83 条真实反馈、其中录像 66 条，均支持子索引5/6与WarpReady解释；聚合 `FrameCount61−trim13=48` 对应成品48帧，仍无逐帧发布身份。另新增 [DSP 核心编码与真实引用](eis-orc-core-localization.md)：24条固定核心指令、7处EIS/gyro字符串地址构造；397个窗口字中386解码、11个扩展字明确保留。已定位原始命令+58→setup+358→eis_update_addr，尚未恢复外存访问扩展、非哨兵反馈写入、latch/cache和槽释放；没有运行自定义EIS。
- 预录：新增 [原生会话分段生命周期](prerecord-session-rollover.md) 与 [同步帧/参数集边界](prerecord-sync-boundary.md)，分别21组和67组原始指令片段检查通过并复现。普通mux在type1同步帧前检查time/size，越界后在本函数写入及RemoveEntry前返回；60秒为同步帧阈值而非任意帧硬切。新文件open会清空SPS/PPS，parser正返回仍可能未取得参数集。短时枚举在普通setup被覆盖，loop删除边界未证明，不直接启用。仍需完整close/open FIFO所有权、各段参数集及真实音视频连续可播放；相机独立60秒预录和语音/实体快门绑定尚未完成。

后续 EIS 已从微码具体追到 [DSP 反馈标签准备与提交](eis-orc-feedback-path.md)：`context+10D8`指向发布字，按`S−80`的两槽布局取40字节快照、从`+20`取标签，处理EIS命令后准备`smem_2_dram(S+3C,scratch,4)`；另有FFFFFFFF预清除和三对有条件调用。81条ORC核心指令、4条ARM布局指令、4处原厂DMA helper诊断引用已通过并复现。专有staging/硬件复制指令、运行期身份、缓存可见性和下游warp/table引用生命周期仍未知，不能将静态回传路径当安全释放ack。

预录另完成 [FIFO所有权有界审计](prerecord-fifo-rollover-ownership.md)：6组原始执行、8条链接断言、87函数来源固定并复现；movie复制保留handle，ResetMovie真实peek当前帧并调整时间基，普通split尾通知param3不会走loop删除param2。MP4 close/open已展开42/25函数，但仍分别有35/15处未解间接位置；没有运行期cursor/首帧身份，完整保帧和连续播放仍未宣告。

## 2026-11-10 Android 0.3.3 拍摄闭环通过

已交付 [0.3.3 APK](../artifacts/android/yi4k-control-0.3.3-debug.apk)，versionCode6、SHA-256 `7d6f3af2a8576a1f86716e06e55ef42f94e0dfeb3b1abd812949666a91374f99`。debug/release各103项测试、Lint0errors/55warnings、应用/测试包构建和V2签名通过，[构建清单](../artifacts/android/2026-11-10-build-0.3.3.json)与原始报告已保留。

新增真实证据确认停录ack后至少本次约3.4秒的采样窗口均返回Unknown，更晚恢复idle。最终产品只发一次拍摄请求，开始后等record、停止/照片后等idle/vf，最多20秒，Unknown不开放快门；电量显示实际读数且不覆盖操作错误。模式切换使用真实子模式apply并联合读回父/子模式及就绪状态。

实际MainActivity [capture-workflow-run02](../artifacts/android/0.3.3-device-reports/camera-capture-workflow-run02/acceptance.json) 一项通过：连接引导、画质S.Fine→Fine、独立断开重连读回、UI录像/停录/照片切换/拍照、UI恢复原配置并断开；再独立会话导出新视频与照片，Android实际解码且与相机端sha256sum一致。新视频YDXJ0150.MP4为20,542,234bytes/3003ms/1920×1080且存在音轨，照片YDXJ0151.JPG为4,306,738bytes并以1/4采样解码。旧目录条目、锚点原片摘要、选定设置、状态及boot ID保留/恢复，AVD关闭，新增相机素材保留。详见 [运行边界](android-camera-media-runtime.md)。

失败candidate01和旧run04保留，未改成通过。此前0.3.2的预览/媒体/编辑运行证据仍只归属该版本。本次不是物理手机、4K/长文件、听感同步或延时/慢动作原生生效验收；同父子模式偏好读回仍可能早于GUI执行。EIS算法替换、最小原生执行恢复闭环、相机独立一分钟预录和相机语音/实体快门触发仍未完成。

## 2026-11-10 表生命周期、非缓存 RAM 与语音注册新证据

- EIS：[ORC 表生命周期审计](eis-orc-table-lifetime.md) 的96条核心指令和2处诊断引用已由主线程复现。垂直表地址保存到逐帧对象且存在浅复制，水平表进入原厂复制准备流程；反馈标签的位置在指针保存之后，仍不能证明硬件最后一次读表或安全释放点。没有提交自定义warp。
- 原生入口：[RAM 首次进入边界](device-1107-ram-first-entry-boundary.md) 仍未得到安全的首次取指与恢复合同。[MMU 审计](device-1107-noncache-executable-ram.md) 已由主线程复现原厂初始化前缀的14次构造并遍历页表：存在Normal非缓存、XN=0的RAM映射，但不是运行期页表读回。低区零段有真实引用，不能占用；`A2100000..A3100000`属于原厂secondary byte pool，尚未取得独占分配或可首次调用的入口。没有payload、设备写入器或真机执行。
- 预录：[索引与文件流接口审计](prerecord-index-stream-vtables.md) 在原厂默认MP4/file创建路径与三种索引后端并集条件下，close/open分别展开137/73个函数，本范围内未解间接调用已归零，未到达FIFO API。CFS、内核、原始存储等外部叶和运行期对象/cursor仍未证明，不能据此宣告连续保帧。继续追每段首帧参数集、编码payload和音视频时间线。
- 相机语音：[固定注册表与启用入口审计](voice-settings-registration-gate.md) 已由主线程复现96项表、28条指令、7个API用例、96项msg3枚举、12个原生设置用例和3个调试绕过用例。本构建没有登记voice_control/内部ID84，msg3没有在输出时另做机型隐藏。普通触屏到原生启用函数有静态路径，但界面可达、语音启动和准确口令未验。vc_test持久化且绕过状态检查，不作为安全启用方案。

以上固件研究均离线，不访问设备。Android断线恢复已完成下述0.3.4回归并交付。

预录参数集进一步完成 [H.264头生产配置审计](prerecord-h264-header-contract.md)，48组原始ARM执行、15条ARM与27条ORC断言已由主线程复现。真实命令构造路径的sps_pps_header_mode保持0，AU字段另有独立来源；ORC启动分支已定位，但mode0/1与NAL7/NAL8输出的语义尚未闭合。不能据此保证每个同步帧或每个新分段包含参数集。

## 2026-11-10 Android 0.3.4 断网恢复与同包拍摄验收交付

交付 [0.3.4 APK](../artifacts/android/yi4k-control-0.3.4-debug.apk)，versionCode7、SHA-256 `aad165530f6ef17dc99059a693b4719cf61f9a5a2d280505288fac8226d579d2`，最新APK别名与构建清单已同步。debug/release各108项主机测试、Lint0errors/55warnings、应用/测试APK构建及V2签名通过，见 [构建清单](../artifacts/android/2026-11-10-build-0.3.4.json)。

修复实际断网后设置行仍显示旧值，统一清理设置、状态、电量、媒体/选中和目录，旧generation异步快照不再填回。扩大测试发现新Network已枚举、socket绑定权限暂未就绪的EPERM，仅在本地未连接socket创建时最多等待3秒；close可取消等待并关闭迟到socket，TCP/API/拍摄不重试。旧失败和build02候选包保留。详见 [断网恢复](android-camera-disconnect-recovery.md)。

同一最终APK分别通过三项AOSP34 arm64模拟器连接真实相机的实际界面用例：两轮Wi-Fi丢失与新Network重连、真实MP4/JPEG批量原片导出、配置→录像→照片→恢复。最后一项新增YDXJ0152.MP4（20,095,024bytes/2970ms/1080p/有音轨）与YDXJ0153.JPG（4,302,765bytes/缩小解码），Android下载发布后的摘要与相机独立sha256sum一致。三次运行均恢复或保留相机状态/选定设置/既有条目/锚点摘要/boot ID并停止AVD；新增拍摄素材保留。详见 [同包拍摄与导出回归](android-camera-media-runtime.md#034-同一交付包的拍摄与导出回归)。

尚无物理手机、4K/长文件、听感同步及延时/慢动作拍摄验收；旧0.3.2预览/编辑证据未冒充新版结果。EIS替换、可靠原生执行与恢复、相机独立60秒预录及相机语音/实体快门联动仍未完成。

原生入口续查完成 [非缓存池分配/释放合同](device-1107-nc-pool-allocation-contract.md)，39次原始函数合成调用及7组对齐已由主线程复现，包含真实检查层、链表分割/合并、锁、MPIDR、memset和除法，无mock且禁止池内取指。确认现成不等待的对齐分配及original释放API；原厂已有使用者属于音频/中间件/USB。已查命令没有形成对外独占buffer入口，缓存池随机malloc压测不能代用。锁的DMB/DSB不等于代码发布或首次取指同步；没有真实分配、设备访问或payload。

预录AU来源补齐 [默认配置到编码上下文链](prerecord-h264-au-provenance.md)：6组原始执行、11条指令和3个App调用已由主线程复现，默认cfg+53=0，经100字节原厂复制到context+97再到启动命令。默认值不是当前相机状态，AU枚举、后续覆盖和重复参数集仍未恢复。

同一0.3.4产品APK新增 [真实批量导出中断与重试](android-camera-disconnect-recovery.md#实际批量导出中断与显式重试) 一项通过：先完成JPEG，再在视频已收到8KiB真实数据后关闭模拟器Wi-Fi；MediaStore含pending查询证实无中断视频行、完整照片保留且摘要一致。恢复新Network102后从界面重连、重选视频并显式导出，唯一完整原片摘要和解码通过，照片不重复。相机前后状态/选定设置/列表/源摘要/boot ID相等，无相机写入，AVD停止。仅新增测试，产品APK摘要不变；四套实际相机用例独立执行。

相机语音进一步完成 [普通GUI与模型资源审计](voice-gui-resource-reachability.md)，主线程完整复现通过：真实对象描述符及7组成员、6组页面、5组普通下滑、8组点击条件、通用type4对象创建、2组语言构造封装、8块模型的ARM变换逐字节比较。确认当前构建的下滑快捷页正常控制流包含语音开关；中英文两阶段拓扑/权重及版本容器均可解析，没有恢复准确口令词表。位图元数据在测试中合成，未捕获对应NAND/ROMFS资源，不宣称真机图标、触摸区域、识别器启动或指定口令已验证；没有设备访问/设置或缓存写入。

## 2026-11-10 EIS实际消费者、参数集输出与语音语义

- [EIS垂直表实际消费者](eis-orc-vertical-consumer.md) 已由主线程复现95条指令、6处原厂诊断、19个未知word和C40六块算术。第二半部接收68字节帧对象后，真正从`+18`取表，调用原厂vertical update并准备复制C40到command24+100，随后清软件bit11。relFBuf发生在消费前且只减帧handle计数，不能当warp表释放。DMA专有指令、最后硬件读者和缓存完成合同仍未知；没有设备写入。
- [参数集生产到输出边界](prerecord-orc-parameter-set-output.md) 已复现74条core断言、64输入/128种有界解释、8个未知word及9窗口hash。连通SPS/PPS结构、序列化、NAL7/8构造与共同输出helper；生产gate取picture对象M/C/R/F四字段，输出前缀最小未知窗口32字节。尚未将该gate与CPU header mode、IDR或mux type1关联，不把专有指令猜作FIFO push。
- [语音类别与动作语义](voice-class-semantics.md) 已由主线程复现26类别/阈值、14 stage1、8 engine、11 task-event、10 action-gate、6 ready及真实reset用例。原始class3→1003/F0010338 START，class2→1004/F0010339 STOP，5..9作为最大类别时拒绝。命令后特征重积累并不保证按上一命令去重；预录应在START语义层接入幂等commit，不能注入公共录像按钮toggle。准确中英文发音仍须声学与真机证明。


## 2026-11-10 最新进度：0.3.5与4K实拍

已交付 [0.3.5 APK](../artifacts/android/yi4k-control-0.3.5-debug.apk)，latest别名和构建清单同步。debug/release各109项主机测试通过，Lint 0 errors / 55 warnings，V2签名通过。新增 [60秒4K普通录像闭环](android-camera-media-runtime.md#035-一分钟4k普通录像验收)：真实UI配置、录像启停、照片、设置恢复，455.8MB原片下载、Android解码和独立相机SHA一致。修复当前规格不支持EIS时仍显示开启的误导。仍无物理手机验收，未把普通录像当作预录。旧包断网/批量导出、预览/编辑证据维持各自版本归属。

预录新增 [IDR首slice参数集静态关联](prerecord-orc-idr-header-invariant.md)，父任务复现87条指令断言及1544组有界解释：同一picture字段选择NAL5时也满足SPS/PPS生产条件，首slice每picture重新判断。实际输出helper、mux描述符与同一ring中NAL7/8/5的边界仍未闭合，不能据此声称预录可播放文件已完成。

新增 [相机端纯C触发路由](camera-capture-trigger-router.md)：语音START幂等；已分类实体短按在预录时commit、录像时独立STOP；提交期间STOP可暂存，旧token回执拒绝，结果未知保持操作与资源所有权。独立agent的宿主/ARM同源验证各13068项断言通过，ABI检查通过，最大观察栈204字节。仅离线逻辑，无预录后端、真实口令验证、实际按键接入或固件补丁；父任务已审阅报告及审计产物。


## 2026-11-10 原生接入与编码描述符推进

- EIS：父任务复现 [stock producer合同](eis-stock-producer-contract.md) 的48 CPU/10 ORC断言、6生成包装场景及36 ring组合。A0311D8C处在原厂mutex内，可在保留原返回值和状态副作用的前提下研究局部输入/原scratch单变量改动；后续沿用原厂ring地址、copy/clean和发布，不新建表所有权。首次执行/恢复仍未实现。同步修正旧vertical审计的command24误称：24是filter/controlregs shadow选择值，未证明硬件opcode。
- 预录：父任务复现 [DSP→FrameDesc合同](prerecord-dsp-framedesc-contract.md)，86 ORC/15 ARM断言及7原始ARM场景通过。正常H264 IDR分类与FrameDesc type1已连通；EOS也可带type1，必须先排除长度FFFFFFFF/归一后00FFFFFF。仍未证明SPS/PPS与slice处于同一payload。
- 触发：父任务复现 [物理快门接入审计](camera-shutter-integration-contract.md)，8物理输入/5队列/15模式/10toggle场景共57次原码调用通过。GPIO13兼任快门/电源，原厂重复low可在长按后多投SHORT，不能声称严格去抖；普通消息ID又混合软件来源。未来适配器需在来源未丢失处做周期关联，并在主循环owner中保留原厂gate、长按、明确START/STOP语义。

上述固件工作全部离线，无设备写入或可部署补丁。


### 原码生成器与native复制候选

父任务复现 [EIS逐帧/网格合同](eis-generator-scope-and-frame-contract.md)：26固定指令、8完整A032CF38场景、1最小helper、4个VFP theta更新场景通过。完整生成未替换算法/插值/数学/memset；输出两signed16平面间距1800，每个受测profile只更新有效矩形，padding保留；1080与宽幅profile行距不同。A039C140已确认为AmbaItuner_Execute，排除全局warp hook；参数变更计数不是帧号，实际Vin/gyro时间锚和原厂超时门槛仍需运行期验证。

父任务复现 [预录counter基线审计](prerecord-orc-counter-baseline.md) 的142原码断言、18处直接调用及15窗口：参数集写出后、slice header之前存在pic+FC快照，但8-byte专有getter的absolute/per-picture语义仍未闭合。新增 [无分配payload复制候选](prerecord-payload-copy-candidate.md) 已通过40宿主+40编译ARM场景，496字节ARM函数；先排除EOS、检查ring/alias/容量并最多两段跨环复制，成功后才允许外层验证并推进自身cursor。本函数没有真实映射/缓存/owner/FIFO接入，不是预录后端已完成。


### Android 0.3.6交付

[0.3.6 APK](../artifacts/android/yi4k-control-0.3.6-debug.apk)已通过debug/release各110主机测试、Lint0errors/55warnings、V2签名；[实际可见控件与4K批量导出](android-camera-media-runtime.md#036-固定拍摄操作区与可见控件导出)一项完整通过。快门/四模式固定且全尺寸可见，busy/exporting禁用恢复有主机回归；可见相册导航、素材滚动勾选及批量导出455.8MB原片实际执行，源摘要/设置/列表/boot ID保留，AVD关闭。latest APK和build.json已同步；未声称本包重跑普通拍摄/断网/预览/编辑全部链路。

### Android 0.3.7 相册视觉收口

[0.3.7 APK](../artifacts/android/yi4k-control-0.3.7-debug.apk)在相册页将素材卡片改为动态 16:9 两列大图，缩略图叠加视频/照片类型和收藏星标；真实封面缓存、照片显式读取、勾选、导出和打开原片行为保留。debug/release 各 110 项主机测试、Lint（0 errors / 55 warnings）、PrototypeRenderTest 和 APK 构建通过。该轮只改 UI 与主机回放工具默认路径，未访问相机；0.3.6 的真实相机证据继续按版本归属，见 [0.3.7 构建证据](../artifacts/android/2026-11-10-build-0.3.7.json)。

### 真实 RTSP 只读复跑

在相机热点可达时完成一次独立只读取景观测：[RTSP 复跑说明](device-rtsp-readonly-run02.md)。正常 API 259/260 之间收到 91 个 H.264 包，视频为 848×480、90 kHz 时间基、3003 tick 帧间隔，未发现音频；最终恢复 `idle` 且设置相等。该证据只覆盖 live-view 视频流，不能替代录制 FIFO、AAC 生产者或预录共同时间线。

随后通过原厂普通录像 API 完成 [普通录像封装时序基线](prerecord-normal-recording-timing.md)：真实 4.67 秒 MP4 含 140 个 H.264 包和 218 个 AAC 包，首包 IDR、AVC extradata 含 SPS/PPS、两轨 PTS/DTS 单调且完整解码通过。该样本补强了普通封装输出和 48 kHz 音频配置，但仍不证明预录 FIFO、每段参数集交付或共同采集 epoch。

随后通过原厂普通录像 API 生成 5 秒真机样本，并只读下载原片：[普通录像封装时间线](prerecord-normal-recording-timing.md)。原片包含 140 个 H.264 视频包和 218 个 48 kHz AAC 包，容器级 PTS/DTS 严格递增，完整解码通过；该样本补强了复用原厂 MP4 封装的真实基础，但没有证明 FIFO payload 生命周期或共同硬件采集 epoch。

同时完成 [循环录像与预录能力矩阵](loop-record-capability-matrix.md) 的只读设备核对：`rec_mode` 确实包含 `record_loop`，`loop_rec_duration` 提供 5/20/60/120 分钟和 `max`，但现有静态路径仍不能证明触发前缓存；`PreRecord` 相关 connected-camera 操作是默认空处理，EventRecord 入口要求录像状态。本轮没有调用 setter 或隐藏事件操作。


### EOS证据已落实到主机预录模型

`FrameDesc`新增精确结束长度识别，EOS优先于type1同步分类；`VirtualPayloadConsumer.consume_one()`新增独立`EndOfStream`返回，在长度上限和payload reader之前分流，不复制、不自动推进游标，由owner决定关闭/显式移除。普通帧语义保留，仓库调用点仅host测试，未影响Android包；父任务复现13项模块测试全部通过。见 [接口与兼容性](prerecord-output-contract.md#主机-framedesc-的-eos-返回协议) 和 [验证记录](../artifacts/offline/2026-11-10-framedesc-eos/validation.json)。

### 0.3.6 完整实时预览与首次执行新边界

同一0.3.6产品APK新增 [真实MainActivity两轮预览验收](android-camera-preview-runtime.md#036-完整主页面两轮首帧与播放器释放) 通过：连接引导/产品Wi-Fi选择、可见预览点击、两轮848×480实际首帧及decoder输出、进入设置后的公开ExoPlayer释放/PlayerView清空/Surface脱离、重新打开使用新实例、可见断开。测试和宿主会话没有并发；宿主没有提前259。断开后已经idle，本次条件清理未发260；所有稳定设置/状态/素材列表及摘要/boot ID保留，AVD停止。测试包单独归档，产品包未变。仍不证明实体手机、后台/断网预览释放、长期或录像并发。

父任务复现 [首次原生执行实现合同](device-1107-first-entry-implementation-contract.md) 的26固定指令及4个原厂查询dispatcher场景，重新核对旧8 byte pools/590 fragments采集。BOSS跨核callback已知目标只维护TLB，发送端无完成回执，不能冒充Icache发布。下一份有界观测可用一次ps mem和48字节NC池头savebin；它仅核对池身份，不建立独占代码分配或首次进入。本轮未访问固件RAM、刷写或运行自定义相机代码。

### 预录 FIFO 生命周期与原生消费者候选

新增 [FIFO 生命周期报告](prerecord-fifo-lifecycle.md) 和 `yi4k_1107_fifo_consumer.{h,c}`。已恢复 UVCd 的完整 0x58-byte 配置、Create/Peek/Remove/Delete 失败副作用，并通过 24 条指令断言、33 组原 ARM/交错检查，以及 20 组 host + 20 组编译 ARM 状态机执行。确认 `0x4000001` 是 EOS/特殊结束通知，Remove 非零可能已经推进游标，Delete 不是 callback 静止屏障。候选只提供单 owner 状态机和 backend 合同，没有接通真实 callback bridge、稳定读取保护、quiescence、RTOS worker 或 SD 持久化，不能称为相机预录后端。

### 原生单字节可见性探针候选

新增 [单字节指令可见性候选](device-1107-false-instruction-visibility-candidate.md) 及离线审计。固定原厂 `false` 叶函数的一条指令可从 `MVN r0,#0` 改为 `MOV r0,#0`，解析器/分发器三组场景均保留 ABI；loadbin 的精确 1-byte 读取边界和 partial-sector 写入也已离线核对。该材料只形成可审阅的 before/after/restore 候选，仍不能作为真机执行方案：WB I-cache 的旧/新可见性、后台解释器并发和掉电恢复均未闭合，因此没有设备写入或部署器。

### 主编码持续切段的主机复跑

普通 mux rollover 的 21 组原码窗口、FIFO 所有权 6 组执行和同步帧边界 67 组检查均已重新复现。主机固定 60 秒模型又完成一次独立复跑：[manifest](../artifacts/host-prerecord/replay-run03/manifest.json) 显示触发前 `60.929267s`、STOP 段尾 `1.138733s`、34 个关键帧段，最终成片约 `68.125s` 并完成整片解码。它验证的是本地文件级分段/无重编码合并，仍不能替代相机 RTOS 编码 FIFO 和真实语音/快门触发。

另有 [typed-event → buffer 接缝回归](../artifacts/host-prerecord/trigger-buffer-integration.json)：voice START 和 shutter START 两种来源分别组合 60 秒缓冲，随后另一来源只产生 duplicate，边界 STOP 完成且无 overshoot。事件已经是相机分类后的输入；识别、GPIO、FIFO、封装和相机端持久化仍未接入。

Android 当前功能 API 的 90 余个返回字段已做静态标签覆盖核对，未发现本机实际只读字段会直接以英文 wire key 出现在设置列表；未知未来字段仍保留原文并附带可读化 key，避免误译。`testDebugUnitTest` 本轮通过，未改变 0.3.6 产品 APK。

### EIS 反馈与表生命周期交叉审计

新增 [EIS 反馈闭环说明](eis-feedback-table-closure.md) 和对应审计结果。六份既有固定审计已统一核对：CPU 状态槽发布、ORC 两槽快照、共享反馈字段、CPU 哨兵解析、垂直 controlregs shadow 复制及水平表分块准备。低 8 位只作为可重复的历史子索引，`0x100` 只表示 CPU 的 WarpReady 解释，均不能当作 DSP ack 或帧号。仍有 7 个关键边界未闭合，包括非哨兵反馈写者、发布/反馈原子与缓存可见性、DSP 运行身份、最终读表/复制完成和安全释放点；本轮没有设备访问或写入。

### EIS CPU 命令队列只读审计

新增 [EIS CPU 命令队列合同](eis-command-queue-contract.md) 和固定镜像审计结果。16 条 ARM 指令检查确认 `VCAP_SETUP` 的 `0x80` 字节命令经模式表间接分发，mode1 在入队前等待事件掩码和有限超时，再清零槽、更新游标并复制命令。审计窗口未发现直接 `dmb/dsb/isb` 或已知 D-cache helper，这只是有限范围的负向静态证据；队列返回值和游标都不能升级为 DSP latch/ack 或旧槽安全复用证明。本轮没有设备访问或写入。

随后对完整 ORC 成员进行了 [可见性指令扫描](eis-orc-visibility.md)：759,102 个对齐字中没有标准 `l.msync/l.psync/l.csync`，反馈、预清除和复制窗口也没有标准同步指令。`l.rfe` 编码模式保留为不透明字，不能解释为完成语义；专有 staging、`code_dma`、缓存控制和硬件 latch 仍未闭合。本轮仍未访问或写入设备。

随后对完整固定 ORC 成员做了 [可见性指令扫描](eis-orc-visibility.md)：759,102 个对齐字中没有标准 `l.msync/l.psync/l.csync`，反馈、预清除和复制窗口也没有这些指令。扫描保留 566 个 `l.rfe` 编码模式匹配，但不为其保留位赋予同步语义；专有 staging、`code_dma`、缓存和硬件 latch 仍需运行期证据，不能把该负向结果当成“没有缓存协议”。

### 预录分段合同 manifest

新增 [预录分段合同清单](prerecord-segment-manifest.md)，把同步边界 67 例、音频配置 10 例、音频生产者 15 例、mux rollover 21 例和输出合同 9 项固定到同一 manifest。它确认普通 event-3 同一 mux pipe 的 close/copy/reset/open 是可复用候选，且音频配置常见为 48 kHz/1024 samples；同时明确四个 slice-only parser 例子虽返回成功但 SPS/PPS 为空，AAC 连续性、共同采集 epoch、A/V 连续性、producer 重启和最终可播放性均仍为 false。

### 预录主机分段文件边界

新增 [预录分段运行期合同](prerecord-segment-runtime-contract.md) 和逐段校验结果。对主机回放的 34 个选中分段逐一核对 SHA-256、首个视频包的 keyframe/NAL5、MP4 AVC extradata 中的 SPS/PPS（NAL7/8）以及 AAC `AudioSpecificConfig` 的跨段一致性；最终合并文件通过完整 H.264/AAC 解码。该结果把“主机文件可播放”与“相机 FIFO 运行期已闭合”分开，descriptor/FIFO cursor、payload 生命周期、close/open ownership 和相机 A/V 共同 epoch 仍需真机只读证据。
