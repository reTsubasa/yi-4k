# Android 0.3.11 交付级审计

后续纠正：本页“装饰性预览表面”的描述不准确，该容器也承载真实 RTSP 预览。因此 0.3.11 存在横屏隐藏预览的功能缺陷；已在 [0.3.12](android-delivery-audit-0.3.12.md) 修复。以下测试记录属于 0.3.11 的历史范围，不能证明其横屏预览可用。

本轮完成横屏紧凑布局和相机模式探针修复。构建与 APK 审计没有在构建阶段访问相机；相机验收另见拍照/录像探针报告。

- APK：[yi4k-control-0.3.11-debug.apk](../artifacts/android/yi4k-control-0.3.11-debug.apk)
- 包名：`dev.yi4k.control`
- versionName/versionCode：`0.3.11` / `14`
- SHA-256：`d57372206e94b953f116fe53383f26479fc16178666dc47d3782eaa4a0a5295c`
- minSdk/targetSdk：29 / 35
- 权限：INTERNET、ACCESS_NETWORK_STATE
- APK v2 签名：通过，1 个签名者（Android Debug）

## 本轮修复

- 700×412 等极短横屏布局隐藏装饰性预览表面，参数胶囊收缩为 44dp；中央快门、参数、模式和底部导航保持完整可见。
- 0.3.10 中发现的紧凑快门行 padding/高度裁剪已修正。
- `CameraLiveProbe` 改用 `CameraConfiguration.selectMode()`，通过 `capture_mode`/`rec_mode` 子字段切换和恢复模式；规避相机直接确认 `system_mode` 但不应用的问题。

## 验证

- `testDebugUnitTest`：110 项通过
- `testReleaseUnitTest`：110 项通过
- `lintDebug`：通过
- `assembleDebug`：通过
- `assembleRelease`：通过
- `PrototypeRenderTest`：通过，覆盖 360×560、412×700、700×412
- `CaptureUiTest`：通过

实体 Android 手机安装、旋转、字体放大和直接运行 APK 仍需用户设备验收。
