# Android 0.4.0 界面整改交付

0.4.0 收口了连接页、设置页和拍摄页的视觉与导航反馈。已实现统一底部选项面板、设置/连接页内返回、共享暖灰/石墨色板、分辨率元数据标签对齐、固定拍摄操作区、真实相册缩略图入口和新照片确认动画。首次连接完成后，应用重建或断开时保留拍摄工作区；从预览入口仍可进入连接引导。

验证范围：主机 Debug 单元测试 174 项通过，Lint 为 0 errors / 64 warnings；AOSP 34 ARM64 系统合成器运行 `CaptureLayoutDeviceTest` 和 `SettingsLayoutDeviceTest` 共 2 项通过，覆盖旋转后拍摄入口/快门/模式可见、预览入口进入连接页、返回拍摄页以及设置长说明排版。运行报告为 [ui-layout-run05](../artifacts/android/0.4.0-device-reports/ui-layout-run05/acceptance.json)，构建哈希与 APK 路径见 [build-0.4.0](../artifacts/android/2026-11-11-build-0.4.0.json)。

本证据没有访问实体手机或相机，也不覆盖首次系统授权弹窗、实体触感、真实相机响应速度、长文件和完整剪辑体验。上述项目仍在手动验收清单中保留。
