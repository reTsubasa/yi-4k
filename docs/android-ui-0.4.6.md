# Android 0.4.6：全屏取景、语音诊断与相机时间同步

版本 0.4.6（29），2026-11-12。[产品 APK](../artifacts/android/yi4k-control-0.4.6-debug.apk)、[测试 APK](../artifacts/android/yi4k-control-0.4.6-tests.apk)、[构建证据](../artifacts/android/2026-11-12-build-0.4.6.json)。

本版响应四项界面与相机控制问题：

- 全屏取景隐藏系统栏，但保留模式选择、快门和常用参数 OSD；横竖屏按窗口重新布局。
- 取景 Surface 按 RTSP 的 16:9 比例布局，减少上下黑边；预览尺寸随方向和可用空间调整。
- “更多设置”提供语音控制只读诊断。当前 1.10.7 的 msg3 设置列表没有 `voice_control`，界面明确说明缺少 API，不伪造开关，也不在手机侧采集或识别语音。
- “系统与存储 → 时间与电源”增加“同步手机时间”，按相机合同发送 `msg2 type=camera_clock`，随后用 `msg1` 读回并要求两秒内一致；失败会保留错误，不报告成功。

验证结果：204 项 Debug/Release 主机单测通过，0 failures / errors / skipped；Lint 0 errors / 66 warnings；Debug 产品包和测试包均构建成功。新增覆盖包括 `CameraConfiguration.syncClock` 协议读回、语音设置分类/诊断、全屏保留取景控制和方向重排。

本版没有实体手机或真实相机验收。语音 API 缺失仍是固件能力边界；时间同步只有在相机接受该写入并读回确认时才会改变相机时钟。EIS 替换与一分钟预录仍未接通。

产品 APK：11,653,761 bytes，SHA-256 `ea100efc6d6f2dba3423a9c93d21c1c0606810f4c8e996938ea959260f5a34b3`。

测试 APK：414,016 bytes，SHA-256 `d2ce36be9bcb6435f578117c30c8655f08e90dc23d015777899371363747f40b`。
