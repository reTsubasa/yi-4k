# Android 0.3.13 交付审计

本版修复两处异常恢复边界：旧 Wi-Fi 的断开回调与重连并发时，不能清空新 Network 或关闭新会话；原片导出中进程被终止后，下次启动应清理本包遗留的隐藏部分文件。

网络状态的匹配、失效和新连接路由选择由同一锁保护，迟到 UI 更新还要核对 connection generation。连接过程中丢失网络也不能发布“连接成功”。两项宿主测试用实际 loopback 相机会话、受控 SocketFactory 和 Android 主消息队列验证上述交错，不把它们冒充真实网络故障。

应用启动时异步扫描精确的 `Movies/YI4K/`、`Pictures/YI4K/` 目录，仅删除本包拥有且 `IS_PENDING=1` 的条目。导出必须先等待这次恢复成功；失败则停止该次导出，后续可重试。成功后本进程不再扫描，避免清理正在导出的新文件。删除时再次检查条件；已发布文件、其他包、编辑目录和相似目录均保留。

- [APK](../artifacts/android/yi4k-control-0.3.13-debug.apk)：包名 `dev.yi4k.control`，版本 `0.3.13` / `16`，11,542,029 字节。
- SHA-256：`a8ca9f71ea049ce7d0dabc0cefd672737e128637b4c0efc47555713e8e2e6e42`。
- minSdk 29 / targetSdk 35；INTERNET、ACCESS_NETWORK_STATE。APK v2 签名验证通过，仍使用同一 Android Debug 证书。
- [完整构建日志](../artifacts/android/2026-11-11-build-0.3.13.log)：Debug/Release 各 127 项测试通过；Lint 0 errors / 64 warnings；Debug、Release、测试 APK 构建通过。[原始报告与渲染](../artifacts/android/0.3.13-reports/)已独立归档。

## 同一产品 APK 的真实相机回归

补充完成 [真实进程终止与本地 8 项运行验收](android-runtime-supplement-0.3.13.md)：实际原片写入 8192 字节后 force-stop，另一进程仅靠 Application 启动恢复移除残片；已发布/其他目录/其他包文件保留。产品 APK 未变化，测试夹具版本与失败历史单独记录。

运行环境均为项目自有 AOSP34 arm64 模拟器，经宿主网络访问真实 YI 4K 1.10.7，未在实体手机执行。

| 场景 | 证据 |
| --- | --- |
| 两轮真实 Android Wi-Fi 丢失与新 Network 重连，旧设置/媒体/选择清除 | [camera-disconnect-run01](../artifacts/android/0.3.13-device-reports/camera-disconnect-run01/acceptance.json) |
| 实际批量导出中断网；完整照片保留，残缺视频移除，新 Network 显式重试哈希/解码通过 | [camera-export-disconnect-run01](../artifacts/android/0.3.13-device-reports/camera-export-disconnect-run01/acceptance.json) |
| 横屏两轮真实 848×480 预览、可见快门、播放器与 Surface 释放 | [camera-main-preview-landscape-run01](../artifacts/android/0.3.13-device-reports/camera-main-preview-landscape-run01/acceptance.json) |
| UI 修改画质、3 秒录像、照片、恢复设置；新文件下载/独立摘要与解码 | [camera-capture-run01](../artifacts/android/0.3.13-device-reports/camera-capture-run01/acceptance.json) |

拍摄回归新增 `YDXJ0167.MP4`（18,045,957 字节，2936ms，1920×1080，有音轨）、原厂 `YDXJ0167.SEC` 和 `YDXJ0168.JPG`。既有条目保留、稳定设置恢复、旧原片摘要和 boot ID 一致；新增素材保留在相机。各次模拟器均已关闭。没有固件、RAM、分区写入或自定义 RTOS 执行。

456 MB 4K 原片批量导出和 65 秒普通录像的补充证据属于 [0.3.12](android-runtime-supplement-0.3.12.md)，不转记为本版复测。实体手机热点/蜂窝组合、实际视觉反馈、超过 4GB 文件、长期后台和系统低内存环境仍待验收。相机端 EIS 替换及一分钟预录尚未实现。
