# Android 0.3.12 后续运行期验收

更新时间：2026-11-11。使用已交付的同一份 0.3.12 产品 APK，SHA-256 为 `b242bab1e7c3e80ab5b8bd45821ed3aa3c1eb54a63677dc332ec23f39cf3cc09`。本页为构建后的补充证据，不修改历史构建结果。运行环境为 Android API 34 ARM64 模拟器连接真实相机，不代表实体手机验收。

| 场景 | 结果 | 证据 |
| --- | --- | --- |
| 连接引导、中文设置、相册选择和批量原片导出 | 通过；视频与照片哈希匹配，视频可解码且有音频 | [完整 UI 流程](../artifacts/android/0.3.12-device-reports/camera-main-export-run01/acceptance.json) |
| 横屏真实 RTSP 预览 | 两轮通过；848×480 视频有实际渲染帧，快门可见，播放器释放后重新建立 | [横屏预览](../artifacts/android/0.3.12-device-reports/camera-main-preview-landscape-run01/acceptance.json) |
| 网络断开与重连 | 两轮通过；旧设置、媒体及选择清除，重新连接成功 | [断网恢复](../artifacts/android/0.3.12-device-reports/camera-disconnect-run01/acceptance.json) |
| 批量导出中断网 | 已完成照片保留；未完成视频不留残缺 MediaStore 项；重新连接后显式重试成功，照片未重复 | [导出恢复](../artifacts/android/0.3.12-device-reports/camera-export-disconnect-run01/acceptance.json) |
| 4K 大原片批量导出 | 455,696,822 字节、60.127 秒视频与照片批量导出耗时 122,904ms；源摘要一致，视频可解码且有音轨 | [大文件 UI 导出](../artifacts/android/0.3.12-device-reports/camera-main-large-export-run01/acceptance.json) |
| 65 秒普通录像、照片与恢复 | 新视频 367,326,906 字节、65.098 秒、1080p、有音轨；下载摘要与相机一致，原设置恢复 | [较长录像采样](../artifacts/android/0.3.12-device-reports/camera-capture-65s-run01/acceptance.json) |
| UI 修改画质、录像、拍照和恢复 | 通过；新录像 1920×1080、2936ms、有音频；新照片可解码；独立相机文件哈希与 Android 下载一致 | [拍摄验收](../artifacts/android/0.3.12-device-reports/camera-capture-run01/acceptance.json) |

拍摄运行保留了相机 SD 卡上的 `YDXJ0163.MP4`、原厂伴随文件 `YDXJ0163.SEC` 和 `YDXJ0164.JPG`。原有 47 个条目保留，选定旧文件哈希不变。测试后相机 idle、完整稳定设置（包括原始 `capture_mode`）和 boot ID 均与测试前一致；模拟器已关闭。

65 秒采样另外保留 `YDXJ0165.MP4`、`YDXJ0165.SEC`、`YDXJ0166.JPG`；该轮之前的 50 个条目全部保留，设置与 boot ID 一致。

本次只有普通相机 API 设置修改与拍摄文件写入，没有固件、RAM、分区写入或自定义 RTOS 代码执行。仍待用户实体手机手动验收、更长/超过 4GB 文件导出及实际视觉交互反馈。
