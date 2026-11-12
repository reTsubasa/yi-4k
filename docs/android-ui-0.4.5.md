# Android 0.4.5：拍摄后自动刷新相册

版本 0.4.5（28），2026-11-11。[安装包](../artifacts/android/yi4k-control-0.4.5-debug.apk)、[构建证据](../artifacts/android/2026-11-11-build-0.4.5.json)。通用安装包 `artifacts/android/yi4k-control-debug.apk` 已更新为相同内容。

2026-11-12 续做：补齐设置页“更多设置”的语音可达性诊断。当前 1.10.7 相机的 msg3 不返回 `voice_control`，页面仍保留“语音控制 · 只读诊断”入口并明确说明手机不会采集或识别语音；若未来固件返回 `voice_control`、`voice_enable`、`voice_language`、`voice_wakeup` 或 `voice_command`，字段会按原始值显示在同一入口，不会臆造写入能力。拍摄页全屏改为只隐藏系统栏，保留模式、快门和常用参数 OSD；同一预览表面按 16:9 布局并随横竖屏重新测量，减少上下黑边。系统设置增加“同步手机时间”动作，使用 API `msg_id=2,type=camera_clock` 写入 `yyyy-MM-dd HH:mm:ss` 后读回确认；仅在用户点击时执行，未做实体相机同步宣称。

新增主机回归覆盖语音字段归类、全屏控制可见性及相机时钟写入/读回。Android 构建仍需按本报告原有 AOSP 模拟器和实体手机边界理解；本续做没有连接实体手机、真实相机或相机语音服务。

修复一个可复现的旧列表问题：先打开相册，再拍照或结束录像，返回相册仍显示拍摄前的素材和数量，必须手动刷新才能看到新增文件。原先自动加载只在素材列表为空时触发，且拍摄完成没有使缓存失效。现在确认拍照或停录成功后标记旧快照失效，返回相册会自动重新汇总目录；等待期间保留现有列表，刷新成功后更新素材和选中项。普通重绘不会重复请求。

产品变更仅限 MainActivity 的快照失效和自动加载条件。两项新增主机回归分别在修复前失败，[失败日志](../artifacts/android/0.4.5-reports/album-regression-before-fix.log)与[失败 XML](../artifacts/android/0.4.5-reports/album-regression-before-fix.xml)保留。修复后两项通过，并确认加载完成后的重绘不重复读取目录。[最终主机结果](../artifacts/android/0.4.5-reports/unit-results/TEST-dev.yi4k.control.NavigationFlowTest.xml)。

本版验证：

- 201 项主机测试全部通过，0 failures / errors / skipped。Lint 0 errors / 66 warnings；[构建日志](../artifacts/android/0.4.5-reports/build.log)、[Lint XML](../artifacts/android/0.4.5-reports/lint-results-debug.xml)。
- AOSP34 ARM64 模拟器 2 项实际 Android 回归通过。每项先加载两个素材，通过产品 MainActivity 拍照/停录路径向本机 loopback 模拟相机发送一次命令，再点击实际相册导航，确认新增文件及三个素材显示；重绘没有额外请求。[验收记录](../artifacts/android/0.4.5-device-reports/album-refresh-run01/acceptance.json)、[用例输出](../artifacts/android/0.4.5-device-reports/album-refresh-run01/instrumentation.log)、[前后截图](../artifacts/android/0.4.5-device-reports/album-refresh-run01/workflow-screens/navigation-flow)。命令在模拟器本机执行，未访问相机。
- 产品包与测试包 APK v2 签名均通过，使用同一 Debug 证书。Android 源码、配置、Gradle wrapper、APK 和实际验收摘要均归档。模拟器已停止，保留配置并回收 505,745,408 bytes 可重建运行磁盘。

本轮同时审查了相册完整目录遍历与失败重试、分辨率原始值展示和配置读回、系统选片交接/旋转/取消，以及原片和剪辑发布恢复。未建立其他新的可复现缺陷。相关产品文件与 0.4.4 的摘要一致，清单和历史证据引用见本版构建记录；[0.4.4 的系统选片/剪辑、参数触摸及进程终止恢复证据](android-ui-0.4.4.md)继续保留，没有重跑未改领域或记作本版模拟器结果。

产品 APK：11,646,801 bytes，SHA256 `7b6c7e2ae37632f45a6e5a1016cf5f6a9f465c4140f44f75981770a539109166`。

测试 APK：674,900 bytes，SHA256 `1795864a51ed87af0ab6db8b7e8c0ce5109f0a1cae5704d89f75034904965458`。

本版没有实体手机或真实相机验收，模拟相机立即更新目录，尚未验证真实相机文件索引延迟。未发送真实相机拍摄或设置命令，未修改固件。EIS 替换和固定一分钟预录仍未接通。
