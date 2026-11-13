# YI 4K RTOS 定制研究

目标：开发完整的普通版 YI 4K 安卓控制 App，推进机内 EIS 替换，并探索固定一分钟预录及语音/快门触发。RTOS 定制研究为后两条主线提供底层能力。

当前三条产品化主线和验收门槛见 [项目目标与验收路线](docs/project-roadmap.md)：完整 Android App、EIS 替换路径、固定一分钟预录及语音/快门触发。

当前每项要求对应的证据、状态和缺口见 [三条主线验收证据矩阵](docs/goal-evidence-matrix.md)。

[项目磁盘清理](docs/project-disk-cleanup-2026-11-11.md)：释放约8.04 GiB，可重建的AVD/构建缓存及已核对重复的工具压缩包已删除，固件与全部历史证据保留。归档APK本地9项复跑通过，runner支持验收成功后回收模拟器磁盘。

- [Android App 使用、构建与验证](android/README.md)：最新可手动安装 [0.5.1 APK](artifacts/android/yi4k-control-0.5.1-debug.apk)。全屏沉浸取景隐藏系统栏，画面按所选分辨率居中等比 fit，浅色毛玻璃控制层保留取景可见；参数集中在下方可调栏，拍照无咔擦声，实时取景帧飞入相册，后台完成相机确认和真实照片替换；保存的相机配置支持冷启动自动连接；216 项 Debug 测试、Lint 0 errors/66 warnings；[任务清单](docs/android-ui-tasklist-0.5.0.md)与[构建回执](artifacts/android/2026-11-13-build-0.5.1.json)。实体手机和真实相机仍待手动验收。
- Android 时钟同步入口已补 [主机契约审计](docs/android-clock-sync-probe.md)：`syncClock` 默认关闭，显式开启才写入并读回 `camera_clock`；[回执](artifacts/verification/2026-11-12-android-clock-probe-contract/clock-probe-contract.json)只证明源码和 loopback 契约，尚未执行真实相机 RTC 写入。
- 原厂封装历史：[零起点 ARM 导出](docs/prerecord-native-session-export.md)通过固定64.064秒、1920视频/3003AAC的FFmpeg时间线/解码和失败门禁。后续普通播放器复核发现harness未配置轨道宽高，AVFoundation只识别音轨；旧通过范围不能扩展为通用播放兼容，未上机。
- [START63/STOP64历史候选](docs/prerecord-native-window-export.md)通过1831视频/2863AAC的FFmpeg校验和失败重试，保留约0.923秒开头空白；同样存在零轨道尺寸的播放器兼容缺口。后续正确几何及紧凑窗口结果见下一项；仍不代表任意窗口或实机一分钟预录。
- 最新[紧凑原厂ARM导出](docs/prerecord-native-window-compact.md)从封口SPS补齐容器几何，两个非零窗口在FFmpeg8通过原严格门禁与完整解码，无共同开头空白；[Android34独立消费者](docs/prerecord-android-native-mux-consumer.md)对同SHA文件读取全部1831视频/2863AAC，全部视频像素和独立选段PCM一致。6.1/AVFoundation限制保留，未做实体手机/实时SD验收。
- 预录恢复补齐：[触发历史持久化](docs/prerecord-trigger-pin-recovery.md)覆盖7个进程退出位置；新owner冻结保护全部保留片段，真实媒体恢复/快门三路线及48项相关回归通过。
- 2026-11-12 新增[原生 spool ring 到原厂 MP4 离线闭环](docs/prerecord-native-spool-ring.md)：当前源脚本 run03 的 C spool/seal、新 reader、原始 ARM mux、voice/shutter 两路同 SHA 成片，以及 interrupted/Close 失败保留和三类负例拒绝均通过；不等同实时 encoder/FIFO、实体 SD 或真机语音/快门绑定。
- EIS局部合同新增：[原厂坐标](docs/eis-stock-coordinate-contract.md)17场景确认限定几何的1/16位移及旋转量化；[看门狗恢复边界](docs/device-1107-native-watchdog-recovery-boundary.md)排除原厂WDT命令作为同流后台恢复期限。执行、DSP方向与独立恢复仍未闭合。
- EIS输入新增：[陀螺仪合同](docs/eis-gyro-input-contract.md)22个原码场景确认三轴格式、原厂名义131 counts/(°/s)及SPI错误仍成功/可能交旧样本；配置读回、实际节律、三轴标定与视频共同时间锚仍缺，未改动相机。
- EIS采样集成：[13场景原码链](docs/eis-gyro-sampler-contract.md)确认SPI失败仍推进历史环、软件tick不能逐槽推导采样时间、printf按上次tick门控；通道步距137含132数据word及5元数据word。候选回放仍缺真实采样/帧共同身份。
- [最小stock入口真机验收](docs/device-1107-stock-entry-approved-run01.md)已完成：用户正常开关机后取得稳定任务概要与正确8字节指纹，脚本及归属诊断文件全部清理，最终API所选基线一致；没有自定义ARM/固件/RAM写入，首次自定义执行与恢复门仍未闭合。最新结果汇总在[本轮证据索引](artifacts/verification/2026-11-12-goal-continuation-050.json)。
- 本轮三条主线：[autoexec 存储事件门禁](docs/device-1107-autoexec-storage-gate.md)恢复原厂脚本何时读取，并准备[两行 stock 进入验收方案](docs/device-1107-stock-entry-acceptance-plan.md)（当时仅 dry-run，后续真机结果见上一项）；[EIS 候选 v2 与原厂布局](docs/eis-candidate-archive-abi.md)核对九组双平面数据并修正持续转向漂移；[真实归档增量预录](docs/prerecord-media-ring-end-to-end.md)通过前60.86秒+触发后片段成片、失败恢复与篡改拒绝。全部为主机/原码离线范围，未部署相机。
- [原厂语音复用与关键词替换](docs/voice-keyword-replacement-path.md)：复用已有开始录像识别事件可接预录，无需更换关键词；更换任意短语仍缺训练/完整推理/加载与运行期校验证据。原厂语音 START 必须在普通 ready/toggle 汇合前保留语义，不能直接注入录像按钮。
- 历史 0.3.18 哈希及验证范围见 [构建证据](artifacts/android/2026-11-11-build-0.3.18.json)；预录后端门禁与 EIS ORC 复核分别见 [预录门禁审计](docs/prerecord-backend-gate-audit.md) 和 [EIS feedback 复核](docs/eis-orc-feedback-call-sites-rerun.md)。
- 本轮底层新增[三阶段 EIS 错误传播](docs/eis-stage-failure-contract.md)及[预录正常 event 3 完整切段/短写断言](docs/prerecord-event3-rollover.md)，均已独立复跑：[证据索引](artifacts/verification/2026-11-11-three-lines-followup.json)。它们约束后续实现，不代表真机算法替换或一分钟预录已完成。
- 2026-11-11 续推已收口：[EIS 同 invocation 透明观测复跑](docs/eis-transparent-observation-rerun.md)（33 场景）和[预录 packet custody / event3 跟进](docs/prerecord-followup-2026-11-11.md)（34 个 host/ARM 场景）；统一状态与缺口见[三条主线验收证据矩阵](docs/goal-evidence-matrix.md)。
- 本轮底层推进：[60000ms event3 换段](docs/prerecord-minute-rollover.md)完整保留 1920 帧视频，但跨界 AAC 与末包时长使发布门禁仍拒绝；[注册/卸载反例](docs/device-1107-registration-recovery-counterexamples.md)五场景独立复跑通过，证实同名注册和注册锁不能替代安全撤销。均为离线验证。
- 最新预录进展：[AAC 边界调度](docs/prerecord-minute-aac-schedule.md)完整保留 1920 视频包与 3003 AAC 包；[连续会话宿主重建](docs/prerecord-minute-session-recovery.md)的 64.064 秒归档窗口逐包字节/时间、1920 帧与完整 PCM 独立校验通过。原始第二段消费者时长门禁仍拒绝；宿主重建不等于相机实时预录。
- 新增[可编译 AAC 边界保管组件](docs/prerecord-aac-boundary-owner.md)：32 host/ARM 场景、517 项精确有理数比较独立复跑通过；[真实 3003 AAC 包回放](docs/prerecord-aac-boundary-owner-independent.md)按 2815/188 归属且上游覆盖后副本不变，另有 4096 项完整宽度比较。下游保管与真实 SD 后端仍需接入。
- 最新退出保护：[RPC 原码失败反例](docs/device-1107-rpc-teardown-counterexamples.md)确认返回成功仍可能释放活动资源；新增[自有退出保护组件](sdk/offline/owned-retirement-contract.md)，10 host/ARM、2 ARM 指令交错与 20 轮线程独立复跑通过。相机撤销入口与调度器停止证明仍未绑定。
- 最新组合与恢复：[C owner/custody 接原厂 event3](docs/prerecord-aac-custody-native-integration.md)仅在关闭文件独立核验后释放，满槽和原厂短写失败保留；[包追加日志](docs/prerecord-packet-spool.md)31 host/ARM、3003实际AAC和8进程退出点独立通过，[22个实际失败/尾部快照](docs/prerecord-retained-spool-recovery.md)新进程精确恢复。原始消费者时序与完整录像覆盖仍拒绝，没有冒充SD掉电或实机预录。
- 2026-11-12 新增[源覆盖封口 sidecar](docs/prerecord-spool-seal.md)：48 host/ARM 与 17 个实际 POSIX/进程退出、篡改和截断场景独立复跑通过；回执固定在 [run04](artifacts/verification/2026-11-12-spool-seal-run04/validation.json)。这是离线 source-coverage/sidecar 完整性证据，未接入相机、RTOS 或物理 SD，不能宣称完整一分钟预录或真机完成。
- 2026-11-12 新增[有界 ring/SD 适配器最小模拟](docs/prerecord-ring-sd-backend.md)：四段×15秒 host POSIX ring、lease backpressure、oldest-first eviction、event3 epoch rollover、跨界 AAC held/transfer、同步失败冻结和篡改 sidecar 拒绝均通过；回执见 [run12](artifacts/verification/2026-11-12-ring-sd-run12/validation.json)。这是合成 fixture 的离线存储模拟，未接入实体 SD、相机 callback、RTOS 或实时一分钟预录。
- 2026-11-12 新增[触发到成片统一离线闭环](docs/prerecord-media-ring-integration-run03.md)：语音 typed START 在发布中断后从保留闭段恢复为可播放 MP4，篡改片段被 custody 拒绝，快门路径与语音恢复成片 SHA 一致；回执见 [run03](artifacts/verification/2026-11-12-prerecord-media-ring-run03/validation.json)。它仍不代表相机语音识别、物理快门、实时编码器、实体 SD 或真机绑定。
- ring/SD 适配器新增[关闭 writer 后重建校验](docs/prerecord-ring-sd-backend.md)：run13b 在所有 FD 关闭后从 spool/seal 重建 session、segment、epoch、CRC、payload 总量和 transcript，并拒绝关闭后篡改；仍是 host POSIX 模拟，未接入实体 SD 或 RTOS。
- 2026-11-12 新增[EIS 候选 mesh 算法](docs/eis-candidate-mesh-replacement.md)：v2 使用有界姿态残差，6604 帧模型检查覆盖持续转向、节律等价、停转收敛与网格边界；另有 9 组原厂双平面逐字节回读。候选仍不兼容实际 warp 发布 ABI，未执行真机替换。
- 2026-11-12 新增[EIS 候选仿射三轴扫测](docs/eis-candidate-stock-affine-sweep.md)：27/27 组三轴离散姿态进入未修改原厂 ARM 生成器，双平面逐项整数参考一致，越界姿态拒绝；仍是合成标定的 CPU 离线接缝，未部署真机。
- 2026-11-12 重跑[EIS 原生证据一致性与入口扫描](docs/device-1107-native-evidence-consistency.md)：49 项固定映像/脚本/回执交叉检查通过；扫描到 10 个 I-cache 操作、151 个 stock handler、0 个直接同步候选。首入口、I-cache/SMP 完成协议和回滚仍未闭合。
- 2026-11-12 新增[原厂 RPC 外部入口负向审计](docs/device-1107-native-rpc-external-entry-audit.md)：原始 ARM 在合成 allocator/port/task 环境中确认 `rpc svc test +` 只注册固定 handler，重复注册会留下无归属的 4 KiB 栈分配；没有受控函数指针、I-cache/SMP 完成或恢复语义，因此降级为不可用 EIS loader 候选。
- 2026-11-12 [只读设备可达性复核](docs/device-readiness-probe-01.md)重新确认 1.10.7 固件、EIS on、SD 已插入和 12 条 Linux/节点检查；没有执行 RTOS shell、内存映射、录像或目标写入。
- stock-only EIS 真机边界 [run01](docs/device-native-eis-trace-run-01.md)验证了临时诊断文件独占暂存、未触发时的失败识别和哈希清理恢复；未取得 active，不能证明 reader 到达；新的存储事件门禁分析进一步界定了原因范围，没有把它记为原生执行成功。
- [原厂任务停止证明审计](docs/device-1107-native-task-stop-proof.md)：32原始ARM用例、3指令交错及一条自然完成调度清理独立通过。自然完成state1有SMP锁保护；挂起终止state2在退出通知返回前仍可被query/delete，通用状态1/2不能直接作为安全回收依据。
- [历史只读设备基线](artifacts/device/2026-11-10-readonly-baseline-02/session.json)：该次采集时相机热点可达；1.10.7 实机为 `idle`、`record`、EIS on、SD 已插入，前后状态和设置一致，12 条 Linux 只读检查完成，未录像、未拍照、未改设置。历史完整基线仍见 [current-readonly.json](artifacts/device/2026-11-10-current-readonly.json)。
- [2026-11-11 Android 只读复跑](docs/device-readonly-probe-03.md)：`recordSeconds=0` 探针确认相机前后均为 `idle`，关键设置未变化，44 个媒体条目前后一致；未录像、未拍照、未改配置。
- [2026-11-11 独立回归索引](artifacts/verification/2026-11-11-independent-regression.json)：重新运行 EIS staging helper、预录恢复/共同 epoch 审计、31 项主机预录单测，并核对只读相机证据哈希。
- [真实 RTSP 只读复跑](docs/device-rtsp-readonly-run02.md)：91 个 H.264 取景包、90 kHz/3003 tick 视频时基和 12 个 keyframe，正常 259/260 恢复；明确不等同录制 FIFO、AAC 或预录证据。
- [真实普通录像封装时序基线](docs/prerecord-normal-recording-timing.md)：YDXJ0160.MP4 的 H.264/AAC 逐包、参数集和时序审计；可播放普通录像，不冒充一分钟预录。
- [本机 SYS PTB RAM 候选](docs/device-1107-hidden-ptb-ram-candidate.md)：从 1.10.7 原码定位隐藏启动分区元数据的静态入口，已做选择器/CRC/坏表与旧真实 USER 控制；[读取路径安全审计](docs/device-1107-ptb-read-path-safety.md)进一步确认普通 Linux read 拒绝低页，原厂 RTOS 输出仍为候选；运行时指针、映射和 SYS 表仍待核验，未新增设备读取或证明恢复可用。
- [GetPartitionInfo内部复制合同](docs/device-1107-get-partition-info-contract.md)：35复制、15拒绝和6风险模型独立复跑通过，恢复64字节单记录ABI及风险；不是新外部命令、完整SYS表捕获或安全首次执行入口。
- [EIS 定点滤波主机回放](docs/eis-filter-host-replay.md)：真实 ARM 仿真差分，非真机替换。
- [EIS 影子记录器](docs/eis-1107-shadow-recorder.md)：固定容量、原输出保留的 A32 边界记录器，已做 Unicorn 仿真，非真机部署。
- [EIS v2 离线包装器验证](artifacts/device/2026-11-10-eis-shadow-v2/validation.json)：88B 记录布局、`previous_after` 与 v2 commit 发布顺序已在主机/Unicorn 验证，仍不是可刷写 payload。
- [原厂 EIS 生产边界](docs/eis-stock-producer-contract.md) 与 [逐帧/网格生成合同](docs/eis-generator-scope-and-frame-contract.md)：保留原厂缓冲、复制、缓存维护和发布的接入候选；完整原码网格生成已离线执行，尚未接入设备。
- [EIS 边界 trace gate](docs/eis-boundary-trace-gate.md)：真实 stock-only 边界导出的封装校验与替换前门槛，synthetic 证据永不通过替换 gate。
- [EIS warp 消费者审计](docs/eis-warp-consumer-audit.md)：完整固定引用索引中发布指针的 5 个引用均来自生产者自身，外部固定引用为 0；未把间接 DSP/MMIO 消费误判为已排除。
- [EIS ORC staging helper 审计](docs/eis-orc-staging-helper-scope-audit.md)：固定 `0x2a20` 参数窗口和专有 opcode 边界，仍未把不透明 helper 误判为 DSP ack。
- [EIS 真机采集方案](docs/eis-stock-boundary-capture-proposal.md)：待确认的 v2 stock-only 采集、停止条件、清理和回滚方案。
- [一分钟预录主机原型](docs/prerecord-host-replay.md)：真实 65 秒来源的分段/无重编码拼接及时间戳修复；[发布前门禁](docs/prerecord-publication-gate.md)同时核对压缩包和 A/V 时间线，可拒绝能解码但音画错位的成片。另有 [自有 payload 到原厂 writer](docs/prerecord-owned-mux-writer.md) 的 19 组原 ARM 离线验证及[自有描述符适配](docs/prerecord-owned-mux-adapter.md)的 27+27+10 组串联验证；均不代表相机实时预录已实现。
- [原始 ARM 索引与完整 MP4](docs/prerecord-native-mp4.md)：执行原厂 index 与 Open/Close，11 个场景独立复跑、成功文件完整解码；[原厂 factory 重开](docs/prerecord-movie-factory.md)另验证同一 movie/MemIdx/mux 原始释放重建两段。文件/锁仍为 RAM 模型。另有[参数集与 codec epoch 适配](docs/prerecord-codec-epoch-adapter.md)的 49+49+2 独立验证；真实编码器绑定、完整任务调度及 SD 分段仍缺。
- [SDK组合链](docs/prerecord-sdk-pipeline-integration.md)：实际编译复制→自有队列→codec→私有描述符→原厂writer，18组host/ARM与1条完整原厂MP4独立复跑通过。离线fixture与每轨单sample不等于已安装callback或分钟预录。
- [真机普通录像封装时间线](docs/prerecord-normal-recording-timing.md)：5 秒原厂录像的 H.264/AAC 逐包证据和完整解码；为复用封装链路提供真实样本，但不等同预录 FIFO 证据。
- [循环录像与预录能力矩阵](docs/loop-record-capability-matrix.md)：只读核对 `record_loop`、`loop_rec_duration`、PreRecord 残留和 EventRecord 状态门；未把循环录像误称为触发前一分钟预录。
- [预录完整主机回归证据](artifacts/host-prerecord/full-test-result.json)：使用项目内独立 FFmpeg 运行时，EIS gate、预录状态机、FrameDesc 和触发路由共 32 项通过，未接触真机。
- [预录触发路由契约](docs/prerecord-trigger-contract.md)：相机固件已识别并映射的 typed 语音事件、快门短按和幂等 START 的主机/Android 逻辑层；App 不做语音识别。
- [相机内语音触发静态证据](docs/voice-trigger-feasibility.md)：确认 `VoiceCmd_Task`、英中模型和 `1003 → E001000C` 动作链；精确口令和启用状态仍需相机侧验证，App 不做语音识别。
- [预录输出 FIFO 契约](docs/prerecord-output-contract.md)：视频事件回调、FrameDesc 和 virtual FIFO 消费链的静态证据。
- [DSP IDR 到 FrameDesc](docs/prerecord-dsp-framedesc-contract.md) 与 [native payload 复制候选](docs/prerecord-payload-copy-candidate.md)：正常同步分类、EOS 例外、跨环复制及宿主/ARM 验证；硬件计数基线和真实预录后端仍未闭合。
- [相机端 C 触发路由](docs/camera-capture-trigger-router.md) 与 [真实快门接入合同](docs/camera-shutter-integration-contract.md)：语音 START 幂等、录像中短按 STOP、原厂 gate/长按保留；真实来源与按压周期去重尚需接入。
- [预录 virtual FIFO 旁路消费者](docs/prerecord-virtual-consumer.md)：基于 UVCd 现有调用点恢复的创建、消费、payload 所有权和停止候选 ABI。
- [预录共同采集起点审计](docs/prerecord-cross-file-epoch.md)：固定音频 source gate、音频 PTS、视频 DSP PTS 修正和 event/FIFO 关系，但共同 A/V epoch 仍未证明。
- [视频就绪事件重复开门审计](docs/prerecord-gate-epoch.md)：8 组完整原函数执行确认只开音频 gate、不重置计数/PCM 游标，不能作为共同 A/V 零点。
- [原厂同会话切段时间线](docs/prerecord-session-timeline.md)：完整 ResetMovie/FIFO Peek/ConvertPTS 的 8 例独立执行确认正常输入下两轨共同减数、post-AdjustDTS轨差保持、视频队首不消耗；共同硬件时钟和真实跨段连续性仍未验证。
- [真实 I/P GOP 与 AAC 封装](docs/prerecord-real-gop.md)：16个不同源视频帧与选中音频包经原厂封装完整解码且字节/帧相同；段间AAC选包缺失和第二段消费者时间线均保留为reject，尚未达到连续无损切段。
- [跨界AAC与原始关闭裁剪](docs/prerecord-aac-boundary-close.md)：正常Close0会删除已写入的跨界AAC并覆盖其媒体位置；未知Close1仅为离线对照，不是可部署方案。分钟历史完整性不能只凭writer成功判断。
- [预录最小相机后端合同](docs/prerecord-minimum-backend-contract.md)：把 FIFO owner、复制/持久化/游标推进、EOS、切段、恢复和失败路径固定为可审阅状态机，真机门槛仍未满足。

**结论：RTOS 已有可复用的原生命令注册、文件、任务/内存、GUI/应用消息和图像/DSP控制接口。全映像静态分析已完成一轮，重点接口有指令与伪代码证据；部分原生命令已通过真机执行/返回验证，首次自定义 ARM 代码加载执行仍待验证。**

已拆解社区 `v1.10.52` 固件，验证整包和 ROMFS 的无修改重打包逐字节一致，建立 Ghidra 工程、全函数索引、伪代码、汇编、交叉引用和二开接口目录。

- **[RTOS 逆向结果与二次开发手册](docs/rtos-reverse-engineering.md)**
- **[Linux 系统组成、启动与二开边界](docs/linux-system-analysis.md)**（实际 RFS 清单、内核配置、原厂导入/社区差异、RPC与共享预览）
- **[真机 Linux 运行时桥接核对](docs/device-linux-runtime-followup.md)**（进程、端口、RPMsg 端点、专用共享内存和实际挂载）
- **[真机首轮采集：1.10.7 系统与固件身份](artifacts/device/2026-11-09-linux/README.md)**（2026-11-09，Wi-Fi/Telnet只读采集，与旧样本版本不同）
- **[真机 1.10.7 PTB、启动链与恢复边界](docs/device-1107-ptb-and-bld-findings.md)**（PTB CRC 闭环、公开 BLD 控制流、BST/BLD/FW_UP 关系、隐藏启动区与恢复缺口）
- **[公共 BLD 描述符和启动回退进一步恢复](docs/public-bld-descriptor-recovery.md)**（分区加载器、`+0x38` 失效状态、三次失败回退）
- **[真机 1.10.7 EIS 核对与 RTOS 内存观测](docs/device-1107-eis-validation.md)**（独立反编译、函数比对、实际 RPC 查询及只读 DRAM 快照；连续遥测仍待验证）
- **[真机 1.10.7 SharePreview 契约](docs/device-1107-sharepreview-contract.md)**（注册条件、状态机、shell 入口、三缓冲亮度帧格式）
- **[SharePreview 生命周期实验与重启后恢复](docs/device-1107-sharepreview-lifecycle-validation.md)**（2026-11-10：Telnet/API 恢复、探针文件已清理；服务仍未注册，失联原因未定位）
- **[SharePreview 初始化依赖审计](docs/device-1107-sharepreview-init-dependencies.md)**（同池分配、有限等待、RPC 错误处理缺口；init-only 探针与分离采集/清理已在主机验证，尚未部署）
- **[原厂内存池查询与运行基线](docs/device-1107-readiness-observation.md)**（原生查询与结构恢复；后续真机已取得 RTOS 池统计）
- **[RTOS 控制台与诊断真机验证](docs/device-1107-console-and-readiness-validation.md)**（应用池余量 223.7 MiB；VideoAnal 已初始化、等待队列，EIS 任务调度增长；输出已回收，探针已清理）
- **[真机 1.10.7 EIS 任务生命周期](docs/device-1107-eis-task-lifecycle.md)**（确认核心排除掩码设置与 `TaskResume` 顺序；用于后续最小任务模板）
- **[真机 1.10.7 最小任务模板](docs/device-1107-minimal-task-template.md)**（仅编译检查 entry ABI 与返回标记，不包含加载器或真机执行入口）
- **[首次原生执行实现合同](docs/device-1107-first-entry-implementation-contract.md)**（核间TLB通知不等于Icache发布；有界NC池身份观测及volatile RAM进入/恢复缺口）
- **[单字节指令可见性候选](docs/device-1107-false-instruction-visibility-candidate.md)**（只读/离线核对的原厂 false 叶函数 before/after/restore 边界；未部署）
- **[EIS 反馈与表生命周期闭环](docs/eis-feedback-table-closure.md)**（CPU/ORC 反馈字段、垂直/水平表消费和仍未闭合的安全释放边界）
- **[EIS CPU 命令队列合同](docs/eis-command-queue-contract.md)**（固定镜像下的 mode1 入队、事件等待、游标更新和有限负向屏障证据；不等同 DSP ack）
- **[ORC 可见性指令边界](docs/eis-orc-visibility.md)**（完整 ORC 成员 759,102 个字的标准同步指令扫描；结果仍是有限负向证据）
- **[ORC 可见性指令边界](docs/eis-orc-visibility.md)**（完整 ORC 成员扫描未见标准 `l.msync/l.psync/l.csync`；专有 staging/cache/latch 语义仍未闭合）
- **[ORC feedback 调用点清单](docs/eis-orc-feedback-call-sites.md)**（固定成员 1,647 个直接调用候选；feedback/pre-clear 窗口 7 个，仍不等于运行期 writer 或 DSP ack）
- **[预录 FIFO 生命周期与 native consumer 候选](docs/prerecord-fifo-lifecycle.md)**（Create/Peek/Remove/Delete 副作用、EOS、callback 静止屏障及可编译状态机）
- **[固定一分钟预录主机回放与触发接缝](docs/prerecord-host-replay.md)**（分段合并、完整解码、voice/shutter typed-event 组合；不冒充相机固件实现）
- **[预录分段合同 manifest](docs/prerecord-segment-manifest.md)**（同步帧、音频配置、mux rollover 和可播放性边界的统一清单）
- **[预录分段运行期合同（主机回放）](docs/prerecord-segment-runtime-contract.md)**（34 个分段逐段通过哈希、首个 IDR、SPS/PPS、AAC 配置连续性和完整解码；不替代相机 FIFO/RTOS 运行证据）
- **[真机 EIS 连续观测与 API 故障定位](docs/device-live-eis-observation.md)**（340 个样本；用户确认死机后暂停内存探针，重启后原厂 API 单独录像成功，109 帧完整解码）
- **[真机原生 RTOS 日志与录像时序](docs/device-native-rtos-logging.md)**（原厂日志通路验证、启用日志后录像成功；1080p30 录像内部几何与预览不同，GyroLogInit 在本机为空实现）
- **[本机 RTOS 命令与 gyro 调试实测](docs/device-rtos-command-and-gyro-debug.md)**（启动命令/导出/RPC 返回通过；31 条 gyro、47 组曝光/帧更新，完整调试表恢复；录像窗口待取得）
- **[本机 1.10.7 RTOS 命令表对齐](docs/device-1107-command-tables.md)**（真实 RTOS 镜像中确认 `loadbin/savebin/t` 与 4 张子命令表）
- **[1.10.7 loader 函数差分](artifacts/device/2026-11-09-linux/rtos-analysis/loader-diff/summary.json)**（确认差异仅为字符串地址低位变化）
- **[录像窗口采集与计时来源核对](docs/device-eis-recording-trace.md)**（实际录像阶段 48 gyro / 67 曝光 / 66 更新；视频完整解码 48 帧，调试表恢复与清理通过，计数器设计单位为 1 ms）
- [EIS 算法实现定位](docs/eis-reverse-engineering.md)、[主流/前沿算法选型与果冻问题](docs/eis-algorithm-survey.md)
- [RTOS gyro 环形区与帧事件契约](docs/rtos-ring-and-frame-contract.md)（1 ms 配置路径、132 槽布局、SOF/EOF/采样命令顺序；静态证据）
- [EIS 后续执行计划与验收](docs/eis-execution-plan.md)
- [真机验证操作：Telnet 与 RTOS 启动探针](docs/device-validation.md)
- [前期结构调查](docs/rtos-customization.md)
- [基础接口](artifacts/rtos-reverse/core/findings.md)、[命令与应用入口](artifacts/rtos-reverse/tables/findings.md)、[图像与IPC](artifacts/rtos-reverse/image-ipc/findings.md)
- [候选 ABI 头文件](sdk/yi4k_11052_internal.h)、[集成示例](sdk/examples/hello.c)
- [固件分区清单](artifacts/firmware/partition-inventory.json)
- [候选 RTOS Shell 命令表](artifacts/firmware/shell-command-candidates.json)
- [固件静态字符串线索](artifacts/firmware/rtos-string-leads.json)
- [验证与来源清单](artifacts/firmware/verification.json)

2026-11-09继续检查：相机只读 API 健康状态为 `idle`，固件/硬件身份与此前一致；本次未录像、未读 DRAM、未改设置。回执见 [continuation status](artifacts/device/2026-11-09-continuation/status/session.json)。

本地 `references/` 保存参考项目；`artifacts/firmware/` 保存公开固件、拆包结果和日志。2026-11-09已连接实体相机并完成Linux/逻辑分区采集和RTOS只读DRAM观测，未刷机或修改算法。真机为1.10.7；重点EIS入口已逐项核对，仍不能把旧1.10.9地址表整体当成本机可写接口。
