# Android 真实相机媒体读取和原片导出

2026-11-10，已交付 APK 0.3.2，SHA-256 `b81ba526cf4d39379903a277123bf0115a1864e829c466b29d19c3239a7856a8`。

## 实际组件链路

Android 34 AOSP arm64 模拟器执行 `CameraMediaDeviceTest` 两项用例通过，见 [运行清单](../artifacts/android/0.3.2-device-reports/camera-media-run01/acceptance.json) 与 [实际 instrumentation 输出](../artifacts/android/0.3.2-device-reports/camera-media-run01/instrumentation.log)。

- 实际 Android `Network.getSocketFactory()` → `CameraClient` → 相机 API 媒体列表 → `MediaExporter` 绑定网络的 HTTP 下载 → 真正的 MediaProvider pending 行与发布。
- 既有视频 `YDXJ0140.MP4` 共 9,626,737 bytes，发布内容 SHA-256 `f62d5ec3a230cfdef8d551f497f3f000fcdafb83ed0f51f0ad23d09dc656c9ec`；照片 `YDXJ0141.JPG` 共 4,726,713 bytes，SHA-256 `86059f537396ad61a54f426a128a236eed17ac36f4d7dcff89b2004075752fb0`。两者均与测试前在相机上通过只读 `sha256sum` 独立取得的摘要一致；也核对导出器报告摘要、发布后的内容字节、长度、MIME、路径及 `IS_PENDING=0`。
- 视频用 Android 实际解码得到 1920×1080 首帧，并确认存在音轨；JPEG 以缩小采样解码。该证据不等于音画同步或全片逐帧检查。
- 在真实 HTTP 字节到达后取消下载，确认本轮未留下 pending 或可见残缺文件；取消时已收到 1,240 bytes，不是下载前设置取消标记。

运行前后相机状态、选定设置、DCIM 根及目标目录列表、两份源文件 hash、boot ID 均相等。没有录像、取景切换、配置修改、源文件写入或内存映射。测试只删除本轮模拟器新增的相册行，随后关闭自己的 AVD。

## 范围与复现

这是实际相机素材、实际 Android API/HTTP/MediaStore 组件的集成测试。模拟器经宿主到相机路由，并非物理手机连接相机热点，也未经过 MainActivity 的连接、复选框和导出按钮流程。本轮没有编辑这些原片；完整编辑器此前通过的素材为三秒合成夹具。

```sh
.venv-reverse/bin/python scripts/android_emulator_acceptance.py \
  --apk artifacts/android/yi4k-control-0.3.2-debug.apk \
  --output artifacts/android/0.3.2-device-reports/camera-media-new-run \
  --test-class dev.yi4k.control.CameraMediaDeviceTest \
  --expected-tests 2 --camera-media-host 192.168.42.1
```

仅在确认目标相机身份且文件仍存在时显式运行。可重复指定 `--camera-media-path` 选择一份既有 MP4 和一张 JPEG；脚本会先读取列表、长度和相机端摘要，再把这些独立数据传入测试。普通本地 AVD 七项套件不会访问相机。

## MainActivity 实际界面流程

新增 `CameraMainWorkflowDeviceTest`，同一 0.3.2 APK 在 [camera-main-workflow-run02](../artifacts/android/0.3.2-device-reports/camera-main-workflow-run02/acceptance.json) 通过一项完整界面用例：连接引导三步、输入相机 IP、由 MainActivity 自己选择实际 Android Wi-Fi Network 并连接、读取中文设置页、打开 DCIM 目录、用素材卡复选框选择上述 MP4/JPEG、点击批量导出、核对两份发布文件的独立摘要/长度并解码视频，最后从设置页断开。

没有替换 SocketFactory、反射私有方法、注入设置或伪造 API 回复；通过真实 View 的点击及复选框操作触发产品逻辑。模拟器 Wi-Fi 是经宿主路由的虚拟网络，仍非物理手机连接相机热点。此用例没有修改相机设置、拍摄、开启预览或模拟断线，不能用作这些动作的界面验收。运行前后相机状态、选定设置、目录列表、源文件摘要及 boot ID 全部相等，测试创建的 Android 相册行已清理，AVD 已停止。

首次 [run01](../artifacts/android/0.3.2-device-reports/camera-main-workflow-run01/acceptance.json) 失败保留：测试把 `CompoundButton.performClick()` 返回 false 误判为未选中；该返回值取决于 click listener，而复选框实际已经切换。改为操作后检查真实 checked 状态，并将 UI 线程断言转回测试线程，以便失败仍走 finally。没有修改产品代码来绕过失败。

复现时使用相同脚本和 `--camera-media-host`，将 `--test-class` 改为 `dev.yi4k.control.CameraMainWorkflowDeviceTest`，`--expected-tests` 改为 `1`。runner 现在在每次运行前只清理自身模拟器的截图输出目录，避免把持久 AVD 中的旧截图当成本次证据；旧运行的主机证据保留。

## 0.3.3 实际配置、录像、照片、恢复闭环

APK SHA-256 `7d6f3af2a8576a1f86716e06e55ef42f94e0dfeb3b1abd812949666a91374f99`。AOSP34 arm64 的 [capture-workflow-run02](../artifacts/android/0.3.3-device-reports/camera-capture-workflow-run02/acceptance.json) 一项通过，实际动作记录见 [camera-capture.json](../artifacts/android/0.3.3-device-reports/camera-capture-workflow-run02/workflow-screens/camera-capture/camera-capture.json)。

通过真实 MainActivity 的连接引导/Wi-Fi Network选择、设置对话框将画质S.Fine改Fine，断开后用独立会话确认实际读回；重连后UI开始录像、停录、切换照片并拍一张，再通过UI恢复录像及原画质并断开。没有注入CameraClient、替换SocketFactory、伪造相机回复或反射产品私有操作。界面动作由instrumentation操作真实View；仍非物理手机手指触摸或手机热点验收。

恢复后独立会话发现恰好一份新MP4和一张JPEG（另有原厂次码流），使用实际Android MediaExporter/网络HTTP/MediaStore下载，再独立读取发布字节、摘要和解码：

| 新原片 | 字节数 | Android实际结果 | SHA-256 |
| --- | ---: | --- | --- |
| YDXJ0150.MP4 | 20,542,234 | 1920×1080首帧，3003ms，存在音轨 | `ba30ba2ef270ed3cd65ef351fe7f48383045ae6c0d19d1372613b9ec22c851a9` |
| YDXJ0151.JPG | 4,306,738 | inSampleSize=4缩小解码为1000×750 | `5deaf11984960da61c70de5e063d489550bf94243ef25c0f6592c6b6cee85593` |

两份摘要均与相机端独立只读sha256sum一致。JPEG记录中的`source_width/source_height`来自同一缩小解码的out字段，不把它们当成原文件全尺寸证据；本次证明的是原片字节一致与实际JPEG解码。新素材导出在恢复后的独立会话中调用实际组件，不宣称本项点击了相册导出按钮；按钮流程另见此前MainActivity媒体用例。

主机runner核对初始/最终状态、选定设置、完整DCIM旧条目metadata、旧MP4/JPEG锚点摘要和boot ID相等，新素材保留；只清理本轮模拟器新增MediaStore行并停止自己的AVD。没有内存映射、固件或分区写入。不是4K/长时录像、听感音画同步、延时/慢动作拍摄或物理手机验收。

保留两类失败与根因：0.3.2 run04使用无apply的system_mode setter，见 [模式协议审计](android-camera-mode-apply.md)；0.3.3 [candidate01/run01](../artifacts/android/0.3.3-candidates/candidate01-build.json) 将停录ack后的Unknown过渡过早显示为可开始，后续模式前置检查拒绝，见 [停录就绪审计](android-camera-stop-readiness.md)。最终版本按实际状态有界只读等待；不延迟后盲发模式写入，也不重试不确定拍摄。

```sh
.venv-reverse/bin/python scripts/android_emulator_acceptance.py \
  --apk artifacts/android/yi4k-control-0.3.3-debug.apk \
  --output artifacts/android/0.3.3-device-reports/camera-capture-new-run \
  --test-class dev.yi4k.control.CameraCaptureWorkflowDeviceTest \
  --expected-tests 1 --camera-control-host 192.168.42.1
```

这是显式普通拍摄/配置验收，会新增视频和照片，要求开始为idle/普通录像、SD已插入、电量足够。它不包含危险内存/固件修改；不应与其他相机控制会话并行运行。

## 0.3.4 同一交付包的拍摄与导出回归

最终APK SHA-256 `aad165530f6ef17dc99059a693b4719cf61f9a5a2d280505288fac8226d579d2`。连接层修改后，[capture-workflow-run01](../artifacts/android/0.3.4-device-reports/camera-capture-workflow-run01/acceptance.json) 一项实际MainActivity配置、录像、停止、照片和恢复流程通过；完整动作见 [camera-capture.json](../artifacts/android/0.3.4-device-reports/camera-capture-workflow-run01/workflow-screens/camera-capture/camera-capture.json)。

画质S.Fine→Fine经独立新会话确认，UI录像后真实状态恢复才允许照片，完成后通过UI恢复录像模式和S.Fine。新增YDXJ0152.MP4（20,095,024bytes，1920×1080首帧，2970ms，有音轨）与YDXJ0153.JPG（4,302,765bytes，1/4采样解码1000×750）；两份原片通过真实Android网络下载、MediaStore发布及解码，摘要分别为`698e7f54a89a308f3a30a0c070edaca2bccac56b16c963a6c20331bf861d394a`与`3198bbaf1483a34735bb91fc842599e9d82c0290aed8a0b6c4a236eb0da308bb`，均与相机端独立sha256sum一致。

相机状态、选定设置、旧目录条目、锚点素材摘要和boot ID恢复/保留，新增相机素材保留，只清理模拟器本轮MediaStore行并停止AVD。相机照片全尺寸和听感音画同步未验。

同一APK另有 [main-workflow-run02](../artifacts/android/0.3.4-device-reports/camera-main-workflow-run02/acceptance.json) 一项真实界面批量MP4/JPEG原片导出通过，及 [两轮断网重连](android-camera-disconnect-recovery.md) 一项通过。三套分别运行，不宣称同一进程统一套件；此前0.3.2预览和剪辑证据仍仅归属旧包。不是物理手机、4K/长视频或延时/慢动作拍摄验收。


## 0.3.5 一分钟4K普通录像验收

[最终运行记录](../artifacts/android/0.3.5-device-reports/camera-4k60-workflow-run01/acceptance.json)完整通过；产品APK SHA-256 `c605901430564d874cea8c02aba18e373abb1fc75a5231c2c5b35ae9d366c97f`。真实MainActivity通过选项界面修改画质和分辨率，独立API读回后录制60秒并拍照，再经UI恢复分辨率、画质、FOV、录像模式并断开。新会话将原片下载到Android、解码；主机再独立核对相机端摘要。

- YDXJ0158.MP4：455,840,625 bytes，3840×2160，60,127ms，有音轨；SHA-256 `577e0f8bf89fb00b8fb922137db5bc979deef0f02483e06fb9065c687e1c0d2e`。
- YDXJ0159.JPG：4,309,658 bytes，缩小解码通过；SHA-256 `cb8f262895b70b0136312372244d1d42b03ff7eb15e203d0e292df3458521347`。

相机在该4K规格读回eis_support_status=off、iq_eis_enable=on。新版拍摄页真实显示“防抖 / 规格不支持”，设置行单独保留开启偏好的说明。所有稳定设置（排除时钟/动态状态/倒计时）、旧目录条目、旧素材锚点摘要和boot ID恢复/保留；新增相机素材保留，测试Android相册行清理，AVD已停止。

这是模拟器连接真实相机的一分钟普通录像和下载验收，不是物理手机、预录、听感音画同步或完整批量导出UI验收。0.3.4的四套回归未冒充为0.3.5重新运行。

前序0.3.4的4K run01因测试选项列表不会滚动而失败，且4K自动改变FOV，已通过普通API恢复并补齐后续UI恢复；run02的instrumentation通过，但相机端后处理SHA计算超过原40秒预算，整体记录仍为error。run02随后独立只读补查120秒预算、37.45秒返回，两份新原片摘要均一致，见该目录的supplemental-hash-verification.json；未改写历史失败。0.3.5本次采用大文件120秒SHA预算，得到完整通过。


### 0.3.5 实际界面批量导出一分钟4K原片

同一APK的 [camera-main-4k60-run01](../artifacts/android/0.3.5-device-reports/camera-main-4k60-run01/acceptance.json) 完整通过：真实连接引导/Android Wi-Fi选择、中文设置、DCIM文件夹、两份原片卡片复选框和“导出选中（2）”按钮，批量写入真实MediaStore。455,840,625字节MP4与4,309,658字节JPEG导出共123,946ms，均已解除pending、长度与独立相机SHA一致，视频实际解码3840×2160/60,127ms且有音轨。最终UI断开，清理本轮Android相册行。前后所有稳定设置、状态、目录列表、两份原片摘要与boot ID相等，AVD关闭。

这补齐上一节普通拍摄用例只在独立会话调用导出组件的范围缺口。仍为模拟器经宿主连接相机，不是物理手机或听感音画同步。测试和runner仅为大文件增加有限的导出/摘要/总执行预算，没有改变产品下载或重试行为。


## 0.3.6 固定拍摄操作区与可见控件导出

产品APK SHA-256 `a5f9b62f750d181ff576a89a6b5b211916b3b9e76d314f5b8c08d6d7efabb06e`，versionCode9。快门/四模式移到根布局固定操作区，预览按滚动视口剩余高度自适应；极小窗口仍可滚动上部内容，操作区不随滚动移出。busy或exporting时固定区与原内容/底部导航同步禁用，快门单独遵守相机就绪状态。没有修改相机协议。

主机debug/release各110项测试通过，包括360×560、412×700和700×412三种合成视口内快门/四模式全尺寸可见、忙碌和导出禁用与恢复。视口检查为宿主手动measure/layout，不是物理旋转或字体放大验收。

[实际Android用例](../artifacts/android/0.3.6-device-reports/camera-main-4k60-run01/acceptance.json)一项完整通过：真实MainActivity连接引导、Android Wi-Fi选择后，getGlobalVisibleRect与快门/四模式完整尺寸相等；中文设置→相册→滚动到每个目标复选框→点击批量导出按钮→MediaStore长度/摘要/视频首帧解码→可见设置按钮断开。查找排除GONE页面，并在点击前请求滚动且检查全尺寸可见，避免隐藏操作区的同名“相册”按钮误匹配。仍为instrumentation调用真实View.performClick，不是物理手指触摸。

导出YDXJ0158.MP4与0159.JPG共123,649ms，摘要与本章0.3.5同源文件一致。视频455,840,625bytes，3840×2160，60,127ms且包含音轨；照片4,309,658bytes。运行前后所有稳定设置、状态、目录列表、源摘要与boot ID一致；无相机写入，新增Android行清理，AVD停止。实际截图见 [capture connected](../artifacts/android/0.3.6-device-reports/camera-main-4k60-run01/workflow-screens/camera-main-connected.png)。

0.3.5的60秒4K拍摄、0.3.4断网/中断重试、0.3.2编辑仍保留各自版本归属，未在本包重跑。另新增本包 [两轮完整主页面预览与播放器释放验收](android-camera-preview-runtime.md#036-完整主页面两轮首帧与播放器释放) 通过；产品APK未变。物理手机、字体放大/真实旋转、听感音画同步、EIS替换及相机独立预录仍未完成。
