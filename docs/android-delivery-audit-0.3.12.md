# Android 0.3.12 交付审计

修复 0.3.11 横屏拍摄页隐藏真实预览的问题。横屏现为两列：左列保留实时预览容器、点击入口和参数，右列放快门及模式；大字体可滚动到达各控件。0.3.11 把这个预览误称为“装饰性表面”，该描述不准确。

- [安装 APK](../artifacts/android/yi4k-control-0.3.12-debug.apk)，包名 `dev.yi4k.control`，版本 `0.3.12` / `15`。
- SHA-256：`b242bab1e7c3e80ab5b8bd45821ed3aa3c1eb54a63677dc332ec23f39cf3cc09`，11,536,637 bytes。
- minSdk 29 / targetSdk 35；INTERNET、ACCESS_NETWORK_STATE 两项权限。
- APK v2 签名验证通过，1 个 Android Debug 签名者；latest APK 别名与交付包摘要一致。
- [构建记录](../artifacts/android/2026-11-11-build-0.3.12.json)、[完整性记录](../artifacts/android/2026-11-11-apk-integrity-0.3.12.json)、[原始测试与渲染](../artifacts/android/0.3.12-reports/)。

## 构建和测试

`testDebugUnitTest`、`testReleaseUnitTest`、`lintDebug`、`assembleDebug`、`assembleRelease`、`assembleDebugAndroidTest` 均通过。Debug/Release 各 113 项，0 失败/错误/跳过；Lint 0 errors / 62 warnings。

渲染测试保留原控件可见断言，新增同一预览容器在窗口重排后保留、预览入口可点击，以及 1.6 倍字体下预览、参数、快门和模式滚动可达。完整构建后修正了截图 helper，使断言和输出图片使用同一个 DecorView；最终 helper 的 Debug/Release 渲染各 3 项重新通过，独立归档，不把过滤后的报告冒充 113 项全量结果。产品源码/APK 未因 helper 修正而变化。

另外修复宿主真机探针的[精确子模式恢复](android-probe-mode-restoration.md)：子模式先恢复、原父模式最后激活；两项 loopback 用例覆盖延时/连拍偏好及已写入但应答断链后的恢复。没有将这些合成故障用例当成相机实测失败恢复。

## 实际 Android 运行

[capture-layout-run01](../artifacts/android/0.3.12-device-reports/capture-layout-run01/acceptance.json) 在自有 AOSP34 arm64 模拟器执行 1 项测试通过。真实 Activity 经竖屏→横屏→竖屏重建，各次预览入口、快门和模式可见；横屏点击预览能进入连接引导。此用例没有连接相机，字体为 1.0；输出的是实际 Android view 渲染，不是物理手机截图或已解码视频。

[camera-main-preview-run01](../artifacts/android/0.3.12-device-reports/camera-main-preview-run01/acceptance.json) 使用同一交付 APK，通过主页面连接引导、产品 Wi-Fi 选择和预览点击接收真实相机 RTSP。两次均解码 848×480 首帧，decoder 输出计数大于 0；两次切设置页后实际播放器已释放、PlayerView 清空 player/parent、Surface 脱离窗口，第二轮使用新的 player。最后从设置页断开；相机前后 idle、全部稳定设置、47 个媒体文件的列表、两份选定原片摘要及 boot ID 一致。没有录像、照片、相机文件/配置或固件/内存写入；两个测试各自启动的 AVD 均已停止。

这次真实流验收在竖屏、模拟器 Wi-Fi 经宿主路由运行，未证明横屏真实流、物理手机热点选择、后台/真实断网释放或长期稳定性；当前版本未重跑完整拍摄/导出流程，旧版本证据保留原归属。实体手机安装与视觉反馈仍由用户手动验收。相机端预录和 EIS 替换未实现。

## 后续补充证据

上述构建时范围为历史快照。同一 APK 后续已补齐真实相机拍摄/导出、横屏真实流、两种断网恢复、456 MB 4K 原片导出及 65 秒普通录像；见[后续运行期验收](android-runtime-supplement-0.3.12.md)。这些仍是模拟器连接真实相机，未替代实体手机验收。
