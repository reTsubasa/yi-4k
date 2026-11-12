# Android 0.3.18：快门操作反馈

拍照或录像命令等待相机响应时，快门自身显示蓝色动态进度环，读屏状态同步说明“正在拍照”“正在开始录像”或“正在停止录像”；固定状态槽不再用“正在与相机通信…”代替快门反馈。按下仍有即时压缩和触感反馈。

相机确认拍照后，实时画面闪白并给出确认触感；录像开始或停止只在相机状态确认后改变快门的红色圆形/停止方形，并给出回弹与确认触感。请求失败时保留错误文字，进度环退出。触感效果兼容 Android 10 起的设备。

## 验证

- Debug 主机单元测试 **163 / 163** 通过。新增延迟模拟相机回归，检查请求等待期间的快门进度状态、读屏说明和固定状态槽，并检查成功后进度状态清除、照片画面闪白。
- `:app:lintDebug` 与 `:app:assembleDebug` 通过；Lint **0 errors / 68 warnings**。
- Debug APK v2 签名验证通过；包名 `dev.yi4k.control`，versionCode 21，versionName `0.3.18`。
- 同一产品 APK 在 AOSP34 ARM64 模拟器新增 **1 项实际 Android instrumentation 验收通过**：拍照、开始/停止录像请求各只发送一次；系统合成器截图中等待外环绘制 583–633 个蓝色像素，两次截图之间快门区域有变化；三种操作前/等待中/确认后快门与模式栏边界相等；模式错误不发送录像命令、清除进度并显示实际错误。来源为本机 loopback 模拟相机，没有真实 RTSP。
- [合成器运行与截图证据](../artifacts/android/0.3.18-device-reports/shutter-feedback-compositor-run03/acceptance.json)、[具体断言结果](../artifacts/android/0.3.18-device-reports/shutter-feedback-compositor-run03/workflow-screens/shutter-feedback/shutter-feedback.json)已归档；模拟器正常停止并回收可重建磁盘。测试先授予模拟器应用运行时权限，因而不覆盖首次系统授权流程。
- 初版直接绘制 View 的 [run01](../artifacts/android/0.3.18-device-reports/shutter-feedback-run01/acceptance.json)保留；改为系统截图后的 [run02 失败](../artifacts/android/0.3.18-device-reports/shutter-feedback-compositor-run02/instrumentation.log)由首次定位权限弹窗遮挡拍摄页引起，截图和日志未改写为通过。run03 观察的是系统真正显示的画面，没有由测试代码主动重绘快门。
- 未连接实体手机或相机；实际触感强度、不同 Android 厂商动画手感仍需手动体验。模拟器结果不替代实体手机验收。

APK：`../artifacts/android/yi4k-control-0.3.18-debug.apk`。SHA-256：`86d71ae6b62a6b36a6b325560085d879568e54160305e3f458c855dd150cd9da`。
