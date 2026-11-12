# Android 0.4.1：标题、相册与分辨率选择修复

按本次手机截图与相册/回放原型整改，交付 [0.4.1 APK](../artifacts/android/yi4k-control-0.4.1-debug.apk)（versionCode 24）。包摘要、源码摘要、测试与验收范围见[构建证据](../artifacts/android/2026-11-11-build-0.4.1.json)。

| 用户反馈 | 修改后行为 | 验证 |
| --- | --- | --- |
| 标题太大、不协调 | 主页面标题由 30sp 降至 22sp，设置子页由 27sp 降至 20sp；回放、剪辑、选项面板统一 20sp，相机标题 24sp；改用中等字重无衬线字体 | 主机渲染、实际 Android 设置截图和字号检查；旋转/长说明验收保留 |
| 相册每格导出按钮与重复操作栏冗余 | 保留双列圆角缩略图；浏览时无逐格导出按钮、选择框和批量操作栏。顶部只有素材计数、筛选、选择、更多；刷新/上一级收进更多。轻点打开回放，长按进入选择，全选只覆盖当前筛选；进入选择后才显示批量导出，取消或返回退出选择 | AlbumUiTest 4 项；实际 Android 触摸选择、全选、取消、筛选入口截图 |
| 分辨率面板无法选择 | 标签区域的 HorizontalScrollView 会消费触摸并获得焦点，原先依赖 ListView 的行选择不足。现在整行显式绑定原索引，标签轻点转交该行，横向拖动仍滚动且不触发选择 | 主机触摸分发；实际窗口注入点击标题、点击标签均选择原始索引 1，标签拖动不选择 |

完整 Debug 单测 **179 项通过**；Lint **0 errors / 64 warnings**；应用和测试 APK 构建通过。实际 AOSP34 ARM64 四项验收通过：[ui-review-run02](../artifacts/android/0.4.1-device-reports/ui-review-run02/acceptance.json)。覆盖 `CameraOptionSheetDeviceTest`、`AlbumLayoutDeviceTest`、`CaptureLayoutDeviceTest`、`SettingsLayoutDeviceTest`。模拟器已停止，可重建运行磁盘已清理。

已逐张检查系统截图：[相册浏览](../artifacts/android/0.4.1-device-reports/ui-review-run02/workflow-screens/album-layout/album-browse.png)、[上下文选择](../artifacts/android/0.4.1-device-reports/ui-review-run02/workflow-screens/album-layout/album-select.png)、[设置标题](../artifacts/android/0.4.1-device-reports/ui-review-run02/workflow-screens/album-layout/settings-title.png)、[分辨率标签触摸](../artifacts/android/0.4.1-device-reports/ui-review-run02/workflow-screens/option-touch/before-metadata-tap.png)。相册素材与选项为本地测试夹具，封面占位不代表相机真实素材；本轮未在实体手机或相机上验收，也没有重新宣称相机配置写入、真实原片导出、EIS 或一分钟预录已经完成。

初次设备测试的失败保留于 `option-touch-run01` 与 `ui-review-run01`：前者将 Dialog 根相对坐标用于屏幕触摸注入，后者相册测试未处理空 contentDescription。分别改用屏幕坐标与空值保护后，四项统一复跑通过；没有修改测试成功标准。
