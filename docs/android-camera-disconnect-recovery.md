# Android 0.3.4 断网清理与重连

2026-11-10。连接失效时，设置和素材页立即移除上一会话的数据；旧异步结果不能重新填回界面。新 Wi-Fi Network 可枚举但尚未获得本地 socket 绑定权限时，只在发送任何 TCP/API 请求之前等待，最多3秒。配置和拍摄请求仍只发送一次。

## 实际失败与修复

0.3.3 的 [disconnect-run01](../artifacts/android/0.3.3-device-reports/camera-disconnect-run01/acceptance.json) 在实际关闭模拟器 Wi-Fi 后失败：模型被清理，但设置行没有重绘，仍显示旧参数。0.3.4 统一清空并重绘设置、状态、电量、媒体、选中项和目录；为连接维护 generation，刷新和列表结果仅在原会话仍有效时提交到UI。

第一版0.3.4通过一轮设置断网测试，扩大为两轮后，[disconnect-run02](../artifacts/android/0.3.4-device-reports/camera-disconnect-run02/acceptance.json) 遇到 `Binding socket to network 102 failed: EPERM (Operation not permitted)`。Android 已返回新的 Wi-Fi Network，而应用对该 Network 的套接字绑定权限尚未就绪。异常发生于 `SocketFactory.createSocket()`，尚未连接相机。

修复仅识别上述本地 bind/EPERM，间隔100ms有界等待。其它创建错误、TCP连接失败和API错误不重试。超过3秒显示中文未就绪提示。关闭会话会使等待失效；即使工厂随后才返回socket，也会关闭它而不连接。主机新增四项回归覆盖前三次EPERM后仅一次257/258、非EPERM立即失败、持续EPERM超时、取消后关闭迟到socket；原有不确定录像请求不重试测试继续通过。

## 同一最终 APK 的运行证据

APK SHA-256：`aad165530f6ef17dc99059a693b4719cf61f9a5a2d280505288fac8226d579d2`。

[disconnect-run03](../artifacts/android/0.3.4-device-reports/camera-disconnect-run03/acceptance.json) 一项完整用例通过，动作见 [camera-disconnect.json](../artifacts/android/0.3.4-device-reports/camera-disconnect-run03/workflow-screens/camera-disconnect/camera-disconnect.json)：

1. 真实 MainActivity 引导、选择 Android Wi-Fi、连接真实相机并显示中文设置。
2. 仅在自有 AOSP 模拟器执行 `svc wifi disable`，确认实际 Network 消失，设置行立即清空。
3. 恢复Wi-Fi，通过产品连接按钮从Network101重连到102，读取实际设置。
4. 在相册进入真实目录并选中已有素材；再次丢网后，素材卡、选中数量和旧目录全部清空。
5. 恢复Network103，再次从产品界面连接、读取设置并主动断开。

不是注入Network、替换SocketFactory、伪造API回复或反射产品私有方法。测试通过 Android instrumentation 操作真实View。设备Wi-Fi开关有 `Build.HARDWARE == ranchu` 限制，仅操作自有AVD。

同一APK另有 [main-workflow-run02](../artifacts/android/0.3.4-device-reports/camera-main-workflow-run02/acceptance.json) 一项通过：真实连接、设置读取、相册选择MP4/JPEG、批量原片导出、与相机独立摘要相等、Android解码和主动断开。两次运行的相机状态、选定设置、目录列表、源文件摘要和boot ID前后相等；无相机写入、录像或内存映射，AVD均已停止。

这些证据不是物理手机连接相机热点验收，也没有覆盖4K/长文件、音画同步或所有预览/剪辑流程。旧失败和build02包/清单保留在候选目录，没有改写成通过。导出中途丢网另有下述独立用例。

## 实际批量导出中断与显式重试

同一最终APK的 [export-disconnect-run01](../artifacts/android/0.3.4-device-reports/camera-export-disconnect-run01/acceptance.json) 一项通过，详见 [动作与素材记录](../artifacts/android/0.3.4-device-reports/camera-export-disconnect-run01/workflow-screens/camera-export-disconnect/camera-export-disconnect.json)。通过真实相册复选框先选照片YDXJ0153.JPG、再选视频YDXJ0152.MP4并批量导出；观察到第二项真实进度8KiB后关闭自有模拟器Wi-Fi，实际Network101丢失。

产品结束导出并清除旧目录/选中项后，查询包含pending的MediaStore：中断视频没有新行，已完成照片恰好一行、已发布、长度及独立相机SHA均正确。恢复Network102后从产品界面重连、重选视频并显式导出，恰好发布一份完整原片，摘要与相机端相等、Android实际解码首帧且有音轨，已完成照片保留且不重复。

未替换网络、socket、HTTP或产品私有方法，没有下载前直接置取消标记；中断发生在实际数据到达后。网络loss由系统回调触发产品取消。前后相机状态/选定设置/目录列表/源摘要/boot ID相等，无相机写入，清理测试新增Android行并停止AVD。只新增instrumentation测试及构建测试APK，产品APK摘要保持不变。不同用例分别执行，不能视为一次统一进程连续运行。

该用例的复现参数为 `--test-class dev.yi4k.control.CameraExportDisconnectDeviceTest --expected-tests 1 --camera-media-host 192.168.42.1`，另显式指定上述视频与照片的 `--camera-media-path`。不能用较小或已完成的传输冒充中断：测试必须实际观察第二项非零且小于总量的进度，否则失败。

```sh
.venv-reverse/bin/python scripts/android_emulator_acceptance.py \
  --apk artifacts/android/yi4k-control-0.3.4-debug.apk \
  --output artifacts/android/0.3.4-device-reports/camera-disconnect-new-run \
  --test-class dev.yi4k.control.CameraDisconnectRecoveryDeviceTest \
  --expected-tests 1 --camera-media-host 192.168.42.1
```

需要真实相机可读、既有MP4/JPEG存在；不与其它控制会话并行运行。runner记录前后相机基线并停止自己启动的模拟器。
