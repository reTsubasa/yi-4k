# Android 0.4.3：断线后的连接页恢复

版本 0.4.3（26），2026-11-11。[安装包](../artifacts/android/yi4k-control-0.4.3-debug.apk)、[完整构建证据](../artifacts/android/2026-11-11-build-0.4.3.json)。通用下载名 `artifacts/android/yi4k-control-debug.apk` 已更新为相同内容。

本版修复相机 Wi-Fi 断线时的回调顺序竞态。App 同时接收专用连接请求和通用 Wi-Fi 的断线通知：专用通知先到时会清空网络对象，通用通知随后忽略旧网络，原先可能把用户留在已断开的拍摄、相册或设置页。现在专用通知也负责返回连接页并启动附近相机搜索，两个顺序都能恢复连接入口。

新增两项主机回归，通过真实 CameraWifiConnector 回调和本地模拟相机覆盖两种通知顺序；之后建立替代会话，再发送旧网络的重复断线和拒绝通知，确认新连接、页面和状态不会被清除。主机用例验证的是可控回调交错，尚未替代实体手机系统 Wi-Fi 验收。

保留 [0.4.2 的连接、相册与两阶段剪辑流程](android-ui-0.4.2.md)。本次重跑系统选片、时间轴、预览首帧、静音/黑白/旋转和 Media3 导出流程；保存结果再次通过 MediaStore 发布状态与实际解码检查。相册布局、分辨率标题/标签触摸、设置说明、旋转和页面内密码流程也重新通过。

验证结果：

- 193 项主机测试，0 failures / 0 errors / 0 skipped；[原始结果](../artifacts/android/0.4.3-reports/unit-results/TEST-dev.yi4k.control.NetworkLossUiTest.xml)包含 4 项断线回归。
- Lint 0 errors / 66 warnings；[Lint XML](../artifacts/android/0.4.3-reports/lint-results-debug.xml)和[完整构建日志](../artifacts/android/0.4.3-reports/build.log)已归档。
- AOSP34 ARM64 无窗口模拟器 6 项通过；[验收记录](../artifacts/android/0.4.3-device-reports/ui-flow-run01/acceptance.json)、[用例输出](../artifacts/android/0.4.3-device-reports/ui-flow-run01/instrumentation.log)和截图保留。模拟器已停止，已回收 522,129,408 bytes 可重建运行磁盘。
- 产品包与测试包 APK v2 签名均验证通过，使用相同 Debug 证书；[产品签名](../artifacts/android/0.4.3-reports/product-signature.txt)、[测试签名](../artifacts/android/0.4.3-reports/tests-signature.txt)。全部 Android 源码、构建配置及 Gradle wrapper 摘要见构建证据。

产品 APK：11,645,241 bytes，SHA256 `3dd75fbfa9fa393fd54bd33ca4da61920163ce38410adada739bd92626f3efdf`。

测试 APK：660,184 bytes，SHA256 `3243881f32a934e4f4a8ce96de62018969405e3b6b7fe66d52af2e27c451041d`。测试包与上一版相同，因为此补丁仅修改产品断线回调和主机测试；它已在本版产品 APK 上重新执行。

本版没有实体手机或真实相机运行验收。宿主只读 TCP 连接检查中，相机地址的 80、554、7878、23 端口均超时，ADB 无实体设备；未发送相机设置或拍摄命令。实体手机的 Wi-Fi/蜂窝组合、权限弹窗、真实断网重连仍需手动安装验收。EIS 替换及固定一分钟预录尚未接通，不由本次 Android 补丁完成。
