# Android 0.3.13 本地运行补充验收

2026-11-11。同一产品 APK 的额外 AOSP34 ARM64 模拟器验收，未访问相机或实体手机。产品 SHA-256 仍为 `a8ca9f71ea049ce7d0dabc0cefd672737e128637b4c0efc47555713e8e2e6e42`；测试夹具修正单独构建为 `yi4k-control-0.3.13-tests-v9.apk`，SHA-256 `6af885d50dc913cb3b18fb5dc5011ea15f70c6708e914ee8e2f13c203cd69df4`。没有重写最初构建或真实相机回归的版本记录。

## 实际进程终止与启动恢复

[pending-process-death-run09](../artifacts/android/0.3.13-device-reports/pending-process-death-run09/acceptance.json) 两阶段通过。实际 `MediaExporter` 从本地 HTTP 获取预期 8 MiB 的视频，写入 8192 字节后阻塞；宿主对专用模拟器的目标包执行 force-stop 并确认进程不存在，再启动第二次 instrumentation。准备 PID 为 1983，新进程 PID 为 2044，启动时间也不同。

验证方法没有调用 cleanup 或恢复等待器：仅观察 `Application.onCreate` 自动移除未发布视频与照片。已发布照片/视频、编辑子目录、相似目录均保留；另一个 APK/UID 在同一原片目录拥有的 1024 字节 pending 视频也保留，前后 SHA-256 均为 `5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef`。详见 [prepare](../artifacts/android/0.3.13-device-reports/pending-process-death-run09/workflow-screens/pending-export-death/prepare.json) 与 [verify](../artifacts/android/0.3.13-device-reports/pending-process-death-run09/workflow-screens/pending-export-death/verify.json)。

run01..08 的失败保留。它们暴露测试夹具对 shell 插入归属、MediaStore SIZE 延迟、并发删除观察和已删文件 teardown 的错误假设。run06 的恢复断言成功但 teardown 失败，不能算整轮通过；run07 被残留 journal 拦截，run08 的旧 foreign row 缺少文件导致 teardown 失败。run09 显式执行独立 preflight，仅按 journal 清理旧夹具并保留快照，然后重新准备一轮；preflight 不计作恢复成功证据，也没有删除新的 pending 来代替启动恢复。

## 本地媒体与编辑回归

[local-suite-run01](../artifacts/android/0.3.13-device-reports/local-suite-run01/acceptance.json) 共 8 项通过：状态/选项、实际视频截取/静音/旋转/黑白/音轨保留、MediaStore 原片发布与取消，以及系统文件选择器到编辑界面再导出的完整流程。新增 actual-provider 用例验证精确过滤和恢复完成后不再扫描本进程正在导出的文件。

最终 test APK 构建和 Lint 均通过。两轮模拟器均已关闭。[补充摘要与哈希](../artifacts/android/2026-11-11-runtime-supplement-0.3.13.json) 单独记录测试版本。真实相机的拍摄、预览和断网验收见 [交付审计](android-delivery-audit-0.3.13.md)；实体手机、长期后台、系统低内存及超过 4GB 文件仍待验收。
