# Android 0.4.9：横向全屏与即时快门反馈

本版针对实际使用反馈修复两个交互问题：进入全屏监看时立即请求横向方向；拍照按下时先完成本地快门反馈，再由后台完成相机确认、相册索引和照片缩略图读取。

## 行为变化

- 全屏监看进入时请求 `SCREEN_ORIENTATION_LANDSCAPE`，沿用同一个实时预览 Surface 和控制层；退出全屏恢复进入前的方向设置。
- 拍照点击立即完成本地闪光和触感反馈；App 不播放相机咔擦声，主线程不等待 `app_status`、相册列表或 JPEG 下载。
- 快门旁相册入口优先从实时预览 Surface 复制当前取景帧并飞入相册；PixelCopy 不可用时保留轻量截图兜底。真实新照片确认后在后台替换缩略图，不再重复播放第二次延迟动画。
- 相机请求失败会取消临时动画、恢复快门状态并保留明确错误；不会伪造相机已保存照片。

## 验证

```sh
cd android
./gradlew :app:testDebugUnitTest :app:lintDebug :app:assembleDebug
```

209 项 Debug 单测通过，0 failures/errors；Lint 为 0 errors / 74 warnings。构建回执见 [2026-11-12-build-0.4.9.json](../artifacts/android/2026-11-12-build-0.4.9.json)，本次快门专项复跑见 [fast-shutter-regression](../artifacts/android/2026-11-12-fast-shutter-regression.json)，APK 为 [yi4k-control-0.4.9-debug.apk](../artifacts/android/yi4k-control-0.4.9-debug.apk)。

验证仍属于主机/AVD范围；真实手机的横向旋转、系统快门音量和相机实际照片列表需要安装后手动验收。
