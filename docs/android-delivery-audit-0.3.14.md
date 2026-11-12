# Android 0.3.14：设置说明排版修复

真实相机验收截图暴露旧设置行的问题：长用途说明会伸入右侧参数值的区域。新版把名称/值放在同一行，用途说明放到下方独占整行，并提高说明文字对比度；完整行仍可点击。协议、相机命令和媒体处理没有新增行为。

- [安装 APK](../artifacts/android/yi4k-control-0.3.14-debug.apk)，版本 `0.3.14` / `17`，11,542,013 字节。
- SHA-256：`1503d3bd73d39cd9985c69c2aea04e81b1d863c31e2486cad943a2aa77f6ebe6`。`yi4k-control-debug.apk` 默认包与它字节一致。
- [完整构建](../artifacts/android/2026-11-11-build-0.3.14.json)：Debug/Release 各 128 项测试通过，Lint 0 errors / 64 warnings，Debug/Release/测试 APK 构建通过；签名仍为同一 Debug 证书，v2 验证通过。报告已独立归档。
- 小屏 288/360dp 内容宽度、1.0/1.6 字体渲染覆盖长名称、长规格和中文用途说明，断言说明与参数值不相交、末行完整且宽度不越界。
- [实际 Android 本地 9 项](../artifacts/android/0.3.14-device-reports/local-suite-run01/acceptance.json)通过，包括设置页实际几何/截图，以及媒体发布/取消、文件选择器到剪辑导出、原片残留过滤。本地设置值是明确测试夹具，没有冒充相机读回。
- [真实进程终止两阶段](../artifacts/android/0.3.14-device-reports/pending-process-death-run01/acceptance.json)通过：实际本地 HTTP 原片部分写入后 force-stop，新进程启动清理；其他目录、已发布文件与另一包拥有的文件保留。两轮模拟器均已关闭。

[设置页实际截图](../artifacts/android/0.3.14-device-reports/local-suite-run01/workflow-screens/settings-layout/video_flat_color.png)和[几何记录](../artifacts/android/0.3.14-device-reports/local-suite-run01/workflow-screens/settings-layout/settings-layout.json)可直接复查。

同一产品 APK 后续又通过[大于 4 GiB 的实际 HTTP/MediaStore 传输和大于 2 GiB 后取消](android-large-original-export-0.3.14.md)两项独立用例；输入为短 MP4 加合法填充，不是大于 4 GiB 编码录像，也不冒充实体手机/相机热点验收。新增 test APK 独立留档，原构建与旧测试包身份不改写。

本版没有新增相机访问或固件/RAM/分区写入。真实相机配置/拍摄/预览/断网/导出证据仍属于 [0.3.13](android-delivery-audit-0.3.13.md)，456 MB 4K 导出与 65 秒录像属于 [0.3.12](android-runtime-supplement-0.3.12.md)，不转记为本版复测。实体手机由用户手动安装验收；完整原型交互、配乐/文字/转场/变速/多片段、长期后台、真实相机大于 4 GiB 编码素材及实体手机容量兼容仍未完成。相机端预录与 EIS 替换尚未实现。
