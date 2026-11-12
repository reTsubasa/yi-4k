# Android 0.4.4：导入恢复与剪辑半文件清理

版本 0.4.4（27），2026-11-11。[安装包](../artifacts/android/yi4k-control-0.4.4-debug.apk)、[完整构建证据](../artifacts/android/2026-11-11-build-0.4.4.json)。通用下载名 `artifacts/android/yi4k-control-debug.apk` 已更新为相同内容。

本版修复导入尚未完成时旋转页面丢失选片的问题。保存状态时记录同一剪辑会话、选片 URI 和相册交接缓存，新页面继续读取同一素材；旧页面在保存状态后完成读取，也保留新页面可能需要的交接文件。取消读取后重建页面不会重放初始选片；完成或最终退出后清理交接缓存，原片保留。

剪辑导出新增独立的一次性启动恢复屏障。只删除本应用在 `Movies/YI4K/Edited/` 精确目录中的未发布行；保留已发布文件、原片目录、其他应用和更深层目录。每次发布先等待启动清理完成，避免清理误删本进程正在写的新文件。原片恢复机制继续独立覆盖 `Movies/YI4K/` 和 `Pictures/YI4K/`。

保留 [0.4.3 的断线连接页恢复](android-ui-0.4.3.md)及现有连接、相册与剪辑流程。本版验证：

- 199 项主机测试全部通过，0 failures / errors / skipped；包含新增的导入中旋转、相册交接、取消后重建、剪辑目录过滤和发布屏障回归。[测试结果](../artifacts/android/0.4.4-reports/unit-results/TEST-dev.yi4k.control.VideoEditorTest.xml)。
- Lint 0 errors / 66 warnings；[Lint XML](../artifacts/android/0.4.4-reports/lint-results-debug.xml)、[构建日志](../artifacts/android/0.4.4-reports/build.log)。产品和测试 APK v2 签名均通过，使用相同 Debug 证书。
- AOSP34 ARM64 模拟器 8 项常规测试通过：连接导航、参数触摸、相册布局、拍摄布局、设置布局、系统 DocumentsUI 选片到 Media3 导出，以及原片/剪辑目录实际 MediaProvider 过滤。[验收](../artifacts/android/0.4.4-device-reports/ui-flow-run03/acceptance.json)、[输出](../artifacts/android/0.4.4-device-reports/ui-flow-run03/instrumentation.log)。
- 原片和剪辑各 1 项进程终止恢复测试通过，每项都有准备/验证两阶段，共 2 项恢复测试。脚本看到实际部分写入后，确认准备方法仍运行且目标 PID 存在，再 force-stop 并确认 PID 消失；新进程在任何导出调用前依靠 Application 启动清理。准备阶段被刻意终止，不计为完成的测试。连同常规用例共 10 项完成测试、12 个检查阶段。[原片验收](../artifacts/android/0.4.4-device-reports/original-process-death-run02/acceptance.json)、[剪辑验收](../artifacts/android/0.4.4-device-reports/edited-process-death-run01/acceptance.json)。

剪辑的真实 `LocalVideoFiles.publish` 写入 65,536 / 8,388,608 bytes 时被终止，新进程删除未发布行并保留已发布与更深目录文件。原片的真实 `MediaExporter` 写入 8,192 / 8,388,608 bytes 时被终止，新进程清除未发布视频/照片，并保留已发布、其他目录及独立测试 APK UID 所属文件。未用正常取消替代进程终止。旧脚本在准备方法正常返回后才 force-stop，新增的 PID 检查发现 Android 已结束测试进程；本版因此改成流式等待准备信号并在方法返回前终止。旧历史报告不补记为本版严格验证。

首轮常规检查的新增测试在收尾时重复删除已清理行，引发 MediaProvider 权限异常；已改为确认行仍存在才删除，[失败记录保留](../artifacts/android/0.4.4-device-reports/ui-flow-run01/acceptance.json)。最终归档 APK 与三份成功验收记录的摘要一致。模拟器均已停止，最后一次验收保留配置并回收 572,829,696 bytes 可重建运行磁盘。

产品 APK：11,646,801 bytes，SHA256 `d1de574a209126534b89cd5c5e98657ebdb8d83ed9e66e3c72cec386bf2884c8`。

测试 APK：670,224 bytes，SHA256 `b353f10f5df81544b95e6026a8606dddb4969e3c44cb0dc4f4ca8dea11fe097e`。

本版没有实体手机或真实相机运行验收。旋转和取消交错由可控主机生命周期回归覆盖；模拟器流程不能替代实体手机权限、后台及编解码兼容性验证。未发送相机设置或拍摄命令，未修改固件。EIS 替换及固定一分钟预录仍未接通。
