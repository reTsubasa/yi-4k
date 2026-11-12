# 相机实时流的主机与 Android 解码验证

## 0.3.12 当前交付包复测

2026-11-11，使用 [0.3.12 APK](../artifacts/android/yi4k-control-0.3.12-debug.apk)（SHA-256 `b242bab1e7c3e80ab5b8bd45821ed3aa3c1eb54a63677dc332ec23f39cf3cc09`）重新跑完整主页面两轮预览和切页释放。两次实际解码 848×480 首帧、decoder 输出计数大于 0；播放器实例不同，离开拍摄页后分别核对实际 release、player/parent 清空和 Surface 脱离窗口。相机前后 idle、稳定设置、47 个媒体文件列表、选定两份原片摘要和 boot ID 相等，没有录像、照片或配置/文件写入，AVD 已停止。

[本次清单](../artifacts/android/0.3.12-device-reports/camera-main-preview-run01/acceptance.json)与[逐步记录](../artifacts/android/0.3.12-device-reports/camera-main-preview-run01/workflow-screens/camera-main-preview/camera-main-preview.json)属于本版本新执行证据。使用模拟器虚拟 Wi-Fi 经宿主到真实相机，竖屏运行；它未验证横屏真实流、物理手机热点、后台/真实断网或长期稳定性。横竖屏布局另有本版本断开相机状态下的 Android 重建检查。详细范围见 [0.3.12 交付审计](android-delivery-audit-0.3.12.md)。以下保留此前各版本证据。

2026-11-10，在本机普通 YI 4K 1.10.7 上通过普通 TCP API 建立会话，使用会话返回的 `rtsp://192.168.42.1/live`。相机初始为 idle，本次通过正常 API 259 进入 VF，用宿主 FFmpeg 6.1 的 TCP interleaved 模式解码首帧，再采集约 3 秒的包元数据，最后 API 260 退出 VF。

结果：H.264、848×480、帧率 30000/1001、RTP 时间基 1/90000，采集 91 个视频包，未发现音轨。首帧实际解码为 PNG；该文件保存在本地证据目录，不是合成 UI 素材。视频帧是当前场景，不在文档中内嵌。

本次会话关闭后，app_status 恢复 idle，选取的模式、分辨率、质量、固件、硬件、SD 和 EIS 设置前后一致。没有发起录像、写入相机文件、修改固件、访问内存或运行 RTOS Shell。

## 2026-11-10 只读 RTSP 复跑

相机热点当前可达时，使用同一只读探针完成了独立复跑，记录见
[session.json](../artifacts/device/2026-11-10-rtsp-readonly-run02/session.json)。相机初始为 `idle`，通过正常 API 259 开启取景，宿主 bundled FFmpeg 以 TCP interleaved 解码首帧并用 ffprobe 读取约 3 秒数据，收到 91 个 H.264 包；流为 848×480、`1/90000`、`30000/1001`，没有音频轨。补充的 [packet-timing-summary.json](../artifacts/device/2026-11-10-rtsp-readonly-run02/packet-timing-summary.json) 记录 90 个 PTS、固定 3003 tick 间隔和 12 个 keyframe。最后调用 API 260，状态恢复 `idle`，稳定设置相等。

这次复跑补强了真实视频预览流及时基证据，但仍不代表录制编码 FIFO 的 payload 顺序、音频生产者、共同 A/V 起点或一分钟预录已实现；探针记录未写入文件、未请求录像、未改设置、未写固件。

## 复现

```sh
.venv-reverse/bin/python scripts/device_rtsp_decode_probe.py \
  --output artifacts/device/2026-11-10-rtsp-first-frame
```

输出目录必须不存在。已保存的 [session.json](../artifacts/device/2026-11-10-rtsp-first-frame/session.json) 包含 API 收发、FFmpeg 参数、首帧 SHA-256、流属性和恢复结果；同目录保留解码日志及 `stream-packets.json`。

## 验证范围

- 证明当前相机在上述模式能通过 TCP RTSP 向宿主传输实际可解码的视频；此前只有模拟 RTSP 握手检查，现在增加了真实源的首帧证据。
- 本节 FFmpeg 证据不覆盖 Android；后续 Android 组件及 0.3.6 主页面运行结果见下节。物理手机 Wi-Fi 继续保留验收。
- 当前预览只有 848×480 视频，不能替代当前 1080p 原片，更不能支持带音频、原片画质的相机一分钟预录目标。该流的 90 kHz 时间基也不能推广到原始编码描述符。
- 约 3 秒采样不能证明长时间无丢帧、录制时并发预览或所有相机模式均可用。

## Android 播放器实际接收真机首帧

2026-11-10，已交付的 0.3.1 APK 在 Android 34 AOSP arm64 模拟器运行 `CameraPreviewDeviceTest`，实际调用 `CameraLivePreview.start`，以 `Network.getSocketFactory()` 绑定网络，接收相机会话返回的 RTSP 地址。测试等待 ExoPlayer 的 `onRenderedFirstFrame`，并核对组件显示“实时画面已连接”且播放器未关闭，用例通过。测试没有替换 RTSP 源、伪造播放器回调或使用合成视频。

[执行清单](../artifacts/android/0.3.1-device-reports/camera-preview-run01/acceptance.json) 和 [instrumentation 输出](../artifacts/android/0.3.1-device-reports/camera-preview-run01/instrumentation.log) 保留已运行 APK/测试 APK 哈希、实际网络属性和首帧结果。相机测试前 idle，经普通 API 259 开启取景，测试结束 API 260 恢复 idle，所选设置前后一致，AVD 进程已停止。没有录像、相机文件写入或固件/内存操作。

验证边界：运行的是实际 Android 网络绑定和播放器组件；模拟器当前网络报告 CELLULAR，经宿主网络到相机，并非物理手机直接加入相机 Wi-Fi。用例主动创建预览容器，没有走 MainActivity 的连接引导、Wi-Fi 选择和点击预览流程。因此不证明这些界面流程、手机硬解兼容性、断网恢复、长时间稳定性或录像并发预览。

```sh
.venv-reverse/bin/python scripts/android_emulator_acceptance.py \
  --apk artifacts/android/yi4k-control-0.3.1-debug.apk \
  --output artifacts/android/0.3.1-device-reports/camera-preview-new-run \
  --test-class dev.yi4k.control.CameraPreviewDeviceTest \
  --expected-tests 1 --camera-host 192.168.42.1
```

该用例需显式给出相机主机，默认离线测试不会连接相机。

## 0.3.2 的真实源回归

Media3 升级到 1.8.0 后，已使用 0.3.2 APK 重新执行真实相机首帧用例，[camera-preview-run02](../artifacts/android/0.3.2-device-reports/camera-preview-run02/acceptance.json) 通过，`onRenderedFirstFrame` 实际触发，相机 idle 状态和所选设置恢复，AVD 关闭。模拟器 CELLULAR/宿主路由和组件测试的边界与上节一致；未新增物理手机 Wi-Fi 选择或完整 MainActivity 流程验收。

## 0.3.6 完整主页面、两轮首帧与播放器释放

同一交付 APK（SHA-256 `a5f9b62f750d181ff576a89a6b5b211916b3b9e76d314f5b8c08d6d7efabb06e`）新增一项 opt-in 真实界面验收，通过 [执行清单](../artifacts/android/0.3.6-device-reports/camera-main-preview-run01/acceptance.json) 和 [逐步记录](../artifacts/android/0.3.6-device-reports/camera-main-preview-run01/workflow-screens/camera-main-preview/camera-main-preview.json)。本轮只新增测试和 runner 支持，产品 APK 字节未变；归档的 [测试 APK](../artifacts/android/yi4k-control-0.3.6-preview-tests.apk) SHA-256 为 `3dce8cf2894c7e4df2917dc30a39bb56cbee104f35b33729b3c01ab689a22271`。

实际流程是连接引导 → 产品选择 Android Wi-Fi Network → 可见预览占位点击 → 相机真实首帧 → 设置页 → 返回拍摄并重新开启预览 → 第二次真实首帧 → 设置页断开。两次视频尺寸均为 848×480，观察到实际 decoder 输出计数大于0、产品首帧状态及占位隐藏；截图保留在逐步记录同目录。测试只从真实 decor 读取公开 PlayerView/ExoPlayer，不注入播放器或首帧回调，也不替换产品 CameraClient/SocketFactory。

两次切入设置页后均核对实际 ExoPlayer `isReleased()==true`、PlayerView 的 player/parent 为 null、SurfaceView 已脱离窗口；第二轮使用不同 player 实例。断开入口位于设置页，所以第二轮播放器先因切页释放，再确认断开/Activity 销毁后持续释放；不声称验收了正在播放时直接断开、后台或真实断网的播放器释放。

宿主预检会话先关闭，再由 MainActivity 自行处理 259，宿主没有提前开启 VF。测试清理仅在本轮 UUID 已确认首帧、初始 idle 且当前 vf 时允许260；本次 UI 断开后独立查询已经是 idle，因此测试和宿主兜底均未发送260。前后状态、全部稳定设置、素材列表/摘要、boot ID 相等，无录像、文件/配置写入或内存映射；自身 AVD 已停止。

```sh
.venv-reverse/bin/python scripts/android_emulator_acceptance.py \
  --apk artifacts/android/yi4k-control-0.3.6-debug.apk \
  --output artifacts/android/0.3.6-device-reports/camera-main-preview-new-run \
  --test-class dev.yi4k.control.CameraMainPreviewWorkflowDeviceTest \
  --expected-tests 1 --camera-media-host 192.168.42.1 --camera-main-preview
```

仍是 AOSP34 arm64 模拟器的虚拟 Wi-Fi 经宿主路由到真实相机，不是物理手机加入相机热点。两轮短预览不证明长期稳定、声音、录像并发或其他模式；当前预览也没有替代相机端原片预录。
