# YI 4K Android Control

Android 10+ 原生控制工具，使用相机原厂 TCP 7878 API 与 HTTP 原片下载，不修改相机固件。

最新安装包为 [0.5.0](../artifacts/android/yi4k-control-0.5.0-debug.apk)。进入全屏会自动横向取景并适配刘海安全区，玻璃叠层保留取景可见；拍照无咔擦声，立即从实时取景帧飞入相册，真实照片在后台确认后替换临时封面。已保存相机配置会在冷启动尝试自动连接，失败只回退一次到搜索。214 项主机测试、Lint 0 errors / 74 warnings；证据见 [0.5.0 任务清单](../docs/android-ui-tasklist-0.5.0.md)和[构建回执](../artifacts/android/2026-11-12-build-0.5.0.json)。实体手机和真实相机仍待手动验收。

历史 [0.4.7](../artifacts/android/yi4k-control-0.4.7-debug.apk)：按新原型移除顶部消息条，重做参数胶囊与全屏叠层，提供铺满/完整画面切换；补齐真实字段中文名称，清理能力位、运行状态、无效动作和兼容重复设置。相机日期时间行可同步手机时间并读回确认。206 项主机测试、Lint 0 errors / 74 warnings、最终同包 3 项实际 AVD 布局/触摸/旋转测试通过，见 [0.4.7 交付](../docs/android-ui-0.4.7.md)和[构建回执](../artifacts/android/2026-11-12-build-0.4.7.json)。实体手机仍待手动验收。

历史 [0.3.14](../artifacts/android/yi4k-control-0.3.14-debug.apk)：修复设置页长用途说明与右侧参数值相交的问题：名称/值在上，用途说明独占下方整行。Debug/Release 各 128 项测试、Lint 0 errors / 64 warnings、实际 Android 本地 9 项及进程终止恢复两阶段通过；APK v2 签名仍为同一 Debug 证书。小屏及 1.6 字体渲染和实际截图见 [0.3.14 交付审计](../docs/android-delivery-audit-0.3.14.md)。本版没有新增相机访问，实体手机仍由用户手动安装测试。

同一 0.3.14 产品 APK 又通过[大于 4 GiB 本地 HTTP/MediaStore 传输及大于 2 GiB 后取消](../docs/android-large-original-export-0.3.14.md)两项实际 Android 检查：完整 4,296,015,995 bytes 源/输出/读回摘要一致并可解码，取消不留半文件。素材为短 MP4 加合法填充，证明大文件字节传输，不代表相机长片或实体手机。新增测试包与原 9 项本地/进程终止测试包分别留档。

历史 0.3.13 产品 APK 已在 AOSP34 ARM64 模拟器连接真实相机，完成配置/短录像/拍照/恢复、横屏两轮 RTSP 首帧与释放、真实断网重连、批量导出断网与显式重试。另完成实际原片部分写入后 force-stop / 新进程启动恢复两阶段验收，以及本地媒体/编辑 8 项回归。以上均不代表实体手机验收；实体手机 Wi-Fi/蜂窝组合、完整视觉与体验、长期后台、系统低内存、真实相机大于 4 GiB 编码素材仍待测试。配乐、文字、转场、变速和多片段编辑尚未实现。

0.3.13 版本证据见 [构建](../artifacts/android/2026-11-11-build-0.3.13.json)、[签名与摘要](../artifacts/android/2026-11-11-apk-integrity-0.3.13.json)、[交付审计](../docs/android-delivery-audit-0.3.13.md)及 [进程终止/本地运行补充](../docs/android-runtime-supplement-0.3.13.md)。较早的 456 MB 4K 原片导出和 65 秒普通录像属于 [0.3.12](../docs/android-runtime-supplement-0.3.12.md)，不转记为本版复测。下文旧版本记录仅为历史证据，最新范围以上述本版报告为准。

保留 [0.3.5真实一分钟4K拍摄证据](../artifacts/android/2026-11-10-build-0.3.5.json)，包括配置/录像/照片/恢复及防抖规格支持提示；未冒充为0.3.6重新拍摄。

保留 [0.3.4 APK及四项独立相机用例](../artifacts/android/2026-11-10-build-0.3.4.json)：两轮真实断网/重连、原片批量导出、短录像/照片、批量导出断网和显式重试。这些用例未在0.3.5重新运行。

保留0.3.3的模式apply、停录就绪等待、电量修复及 [构建证据](../artifacts/android/2026-11-10-build-0.3.3.json)。

此前0.3.2的七项本地Android运行用例、真实RTSP首帧、原片导出/取消和真实原片编辑证据保留于 [0.3.2构建范围](../artifacts/android/2026-11-10-build-0.3.2.json)，没有将其冒充为0.3.3重新运行结果。

## 当前功能

- 在 App 内搜索并筛选 YDXJ 相机热点，选择、输入相机密码并通过 Android 系统授权连接；自动推导相机地址，不要求手动输入 IP。支持加密记忆密码、重新搜索、断开和断网状态更新。扫描需要精确位置、附近设备权限及定位服务，手机实际热点体验仍需用户测试。
- 相机状态轮询；开始/停止录像、拍照，发送前检查工作状态与拍摄模式。请求只发送一次；开始录像后等待record，停止/拍照后等待idle或vf，最多20秒。Unknown不视为ready，未完成时快门保持不可操作，超时提示重新核对实际状态。
- 配置页显示相机 msg_id=3 返回的全部字段。界面按七个一级分类、十七个二级小类导航，不再放置全局搜索框；每个字段显示中文名称、当前值胶囊和用途说明，未知字段保留原始 key 便于排查。点击可写字段后查询 msg_id=9，只有相机声明 settable 且给出标量选项时允许修改；提交前重新检查状态和选项。格式化、重置、升级等动作键和值不开放。
- DCIM 素材库目录浏览、视频/照片筛选、两列类型色块占位卡片、单文件与批量导出、全选/清空、逐文件进度、取消。进入目录后会自动读取已缓存的视频封面，并对已知大小且不超过 12 MiB 的照片请求真实封面；大视频不为生成封面而下载。封面尚未生成时显示中文类型占位。缓存按相机会话隔离，最多 128 项、16 MiB。
- 导出从 HTTP 原样复制到 MediaStore 的 Movies/YI4K 或 Pictures/YI4K。完整长度核对后才发布；截断、文件变大、网络失败或取消时删除当前未完成行。批量中已完成文件保留，未完成选择可再次导出。
- 导出期间锁住相机命令，保持屏幕亮起；需要让 App 保持前台。关闭 Activity 会取消下载，不会停止相机正在进行的录像。
- 界面按用户提供的 iOS 工具原型重做为黑白圆角工作台，顶栏显示已连接型号，连接页提供附近相机搜索。拍摄页的分辨率、帧率、视角、曝光、色彩和防抖均读取相机实际设置，未返回时显示 `--`；支持点击参数查询可写选项。录像、拍照、延时与慢动作切换会验证相机选项、发送协议并读回确认，不再仅改变本地选中项。
- 实时预览采用 Media3 RTSP：连接成功进入拍摄、返回拍摄、切换模式与规格后自动连接，无需点击。校验会话 257 返回的同相机地址；空闲时调用标准 259 开启取景，使用所选 Wi-Fi 的 SocketFactory，强制 TCP interleaved。首帧到达前显示连接占位，失败可重试；切页、后台、断网或销毁时释放本地播放器，不自动发送可能影响拍摄的 260。真实相机流已在宿主 FFmpeg 及 Android 模拟器的实际网络绑定/ExoPlayer 组件解码首帧；0.3.6 已通过实际 MainActivity 连接引导、产品 Wi-Fi 选择、两轮真实首帧及切页释放验收；物理手机 Wi-Fi、后台/断网预览释放仍待验收，见 [预览证据](../docs/android-camera-preview-runtime.md)。
- 相册点击素材卡片可打开原片回放：先绑定相机网络下载并检查长度，再从应用私有缓存查看照片或播放视频。支持进度、取消、重试、常驻播放时间轴、播放/暂停及本地收藏，退出后清理临时缓存。文件信息来自实际文件，无法确认时显示未知。剪辑入口支持从手机文件选择器导入视频，截取片段、静音、90° 旋转与黑白滤镜，使用 Media3 Transformer 导出新副本到 Movies/YI4K/Edited；原片保留。剪辑页面离开前台会取消导出，失败或取消不发布半文件；旋转后恢复导入文件与编辑参数。参见 [本地剪辑说明](../docs/android-local-editor.md)。

## 构建与主机验证

磁盘清理后可以直接用归档 APK 运行验收：`scripts/android_emulator_acceptance.py` 支持 `--test-apk` 和 `--discard-avd-on-success`。后一项只在验收通过、模拟器已停止后保留配置/报告并删除可重建运行磁盘；失败保留现场。实际归档 APK 的9项复跑与清理均通过，见[清理记录与示例](../docs/project-disk-cleanup-2026-11-11.md)。

需要 JDK 17+、Android SDK 35 与相应 build-tools。本机可用 JDK 为 `/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home`，SDK 为 `/Users/hyc/Library/Android/sdk`。其他机器使用自己的路径：

```sh
JAVA_HOME=/path/to/jdk ANDROID_HOME=/path/to/android-sdk ./gradlew test lintDebug assembleDebug
```

输出 APK：`app/build/outputs/apk/debug/app-debug.apk`；本轮构建证据见 [Android build evidence](../artifacts/android/2026-11-10-build.json)。主机测试包含 TCP JSON 分片/通知、错误/超时、媒体路径、动态配置选项与危险动作过滤，以及下载字节/摘要、取消、超长、截断、连接中断和不确定 START 后重连同步。`SimulatedCameraIntegrationTest` 在 loopback 上启动隔离 TCP/HTTP 相机服务，覆盖连接、msg3/msg9、配置、开始/停止、vf 就绪、DCIM 扫描、原片下载、取消，以及“相机已开始录像但响应断链”后的状态恢复。

## 验证边界

2026-11-10 的 0.3.2 完整 `test lintDebug assembleDebug assembleDebugAndroidTest` 通过，debug/release 各 95 项主机测试，Lint 0 errors / 54 warnings，V2 签名通过。[七项本地 Android 用例](../artifacts/android/0.3.2-device-reports/local-suite-run01/acceptance.json) 在同一 AOSP 34 arm64 进程全部通过，覆盖状态/选项、实际编解码、MediaStore 发布/取消和真实系统 DocumentsUI 到编辑保存的完整流程。另有 [一项真实相机 RTSP 首帧用例](../artifacts/android/0.3.2-device-reports/camera-preview-run02/acceptance.json) 通过并恢复相机状态/设置；使用模拟器网络经宿主到相机，不证明手机直接选择相机 Wi-Fi。五张原型尚未全部实现；配乐、文字、转场、变速和多片段编辑未实现。模拟器小型合成素材不能替代物理手机编解码兼容性、真实相机大文件、音画同步、后台/旋转及真机拍摄验收。

### P1 实体手机手动验收清单

下面的检查需要真实 Android 手机和相机热点；主机测试只能验证协议和恢复语义，不能替代设备结果。

- [ ] 在连接页搜索 YDXJ 热点，填写密码并确认系统授权；7878 会话可连接、刷新、断开和重新连接。
- [ ] 读取 msg3 全量配置；对 msg9 声明可写且有选项的字段修改并读回，拒绝/超时后重连核对实际值。
- [ ] 在 `record`/`capture` 模式分别完成短录像、停止、拍照；断链后不自动重发 START，重连先读 `app_status` 再决定停止或继续。
- [ ] 连接后自动出现 RTSP 首帧；录像/照片/延时/慢动作切换后自动刷新；切页、后台、断网后释放并可恢复。
- [ ] 相册打开原片照片/视频，检查下载、播放/暂停、拖动时间轴、收藏及关闭清理；照片显式读取封面，视频打开后返回相册应显示实际封面，断开重连应隔离缓存。
- [ ] 将视频导出后进入剪辑，导入、截取、静音、旋转与黑白滤镜导出；确认新视频可播放、时长与音轨正确，旋转屏幕后编辑参数保留，取消/后台/失败没有可见半文件。
- [ ] 浏览 DCIM 子目录，导出单个和批量 MP4/JPG；验证 MediaStore 可播放/查看、长度和 SHA-256 记录正确。
- [ ] 导出中断网或取消：已完成项目保留，当前项目不留下可见的半文件，恢复网络后可再次导出。
- [ ] 旋转屏幕、切到后台和恢复；长文件导出期间保持前台并正确显示进度，Activity 销毁时取消 HTTP 传输。
- [ ] 记录固件版本、手机 Android 版本、网络地址、操作时间和每项结果；失败时保留 `evidence.json` 与相机实际状态。

相机返回的列表若声明 total 大于实际返回条目数，目前明确报不完整；分页协议尚未验证。某字段拒绝 msg9 或无选项时保留只读值，不臆造自由文本写入。录像请求超时不会自动重试，须重连查看实际状态。导出使用文件长度核对与本地 SHA-256，不代表有来自相机的独立摘要校验或支持断点续传。EIS 替换与相机独立预录尚未接通，App 不显示虚假的预录/语音功能开关。

### 统一触发语义（仅逻辑层）

`CaptureTriggerRouter` 是独立的纯 Java 状态机，`CaptureTriggerAdapter` 是注入式的回调边界，供未来预录实现接入。它把快门短按、相机固件确认后的类型化 `CameraVoiceEvent.START_RECORDING` 事件和外部 START 适配到同一个幂等 START 语义；App 不接收文本、不使用麦克风，也不执行语音识别。`开始录像` / `start recording` 是固件侧口令的文档名称，不是 App 的匹配输入。STARTING 或 RECORDING 状态收到重复触发时返回 `NONE`。长按和未确认的事件会被忽略。底层录像确认后调用 `acknowledgeStart()`，失败调用 `startFailed()`；停止同样需要确认完成。当前两个类不调用相机 API，不改变 App UI，也不宣称相机已有预录功能。MainActivity 当前仍使用原厂拍摄按钮路径；只有未来明确接入相机事件和预录后端时，才应把适配器的 Sink 绑定到真实录像状态机。

### 真机探针（显式 opt-in）

只读检查：

```sh
JAVA_HOME=/path/to/jdk ANDROID_HOME=/path/to/android-sdk \
  ./gradlew liveCameraProbe -PcameraHost=192.168.42.1 -PrecordSeconds=0 \
  -PprobeOutput=/absolute/path/evidence.json
```

需要实际录像/拍照/配置改动或时钟同步时，显式增加 `-PrecordSeconds=3 -PcapturePhoto=true -PchangeSetting=true -PsyncClock=true` 中对应的选项；时钟同步默认关闭，写入后立即读回并把请求时间、读回值和校验结果写入 evidence。探针会预检固件、SD、电量与状态，记录操作前后的完整媒体列表，自动识别本轮新增媒体并下载到 `evidence-media/`，在 finally 中停止自己发起且仍在进行的录像并恢复自己修改的配置。录像请求超时不会自动重发；出现不确定状态时应先检查证据和相机状态。

`CameraLiveProbe` 不是普通单元测试，Gradle `test` 不会调用它。它可能写入相机配置、生成录像/照片和 SD 文件，必须由操作者在确认风险后显式运行。
