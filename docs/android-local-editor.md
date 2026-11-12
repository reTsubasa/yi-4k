# Android 本地剪辑 0.3.2

从 App「剪辑」进入编辑器，通过系统文件选择器选择手机视频。相机原片先从相册导出；编辑器本身不连接或写入相机。导入复制到应用私有会话缓存，源视频保留。

当前支持片段起止选择（至少 0.1 秒）、保留原声/静音、90° 旋转、原色/黑白滤镜，以及新 MP4 导出。真实关键帧缩略图来自所选文件，不生成虚假波形、配乐名称或素材画面。没有配乐、文字、转场、变速和多片段编辑。

预览与导出使用同一范围和视频效果；预览采用 Media3 ExoPlayer，导出采用 Media3 Transformer 1.8.0（0.3.2；此前为 1.5.1），目标为 H.264/AAC。它会根据源文件和效果选择复制或编解码，具体能力依赖手机。Android 34 AOSP arm64 模拟器已实际执行两种导出，物理手机仍待验收。导出必须保持页面前台，离开页面、取消或销毁会停止任务并清理临时结果。完成后按完整字节数写入 pending MediaStore 行，再发布到 Movies/YI4K/Edited；失败或取消删除未完成行。

剪辑状态保存会话 ID、源文件名、时长、范围、静音、滤镜和角度；Activity 配置重建可恢复私有源文件与参数，已经中断的导出可重新开始。各会话使用独立 UUID 目录；打开编辑器后清理已失效会话，仅删除本功能命名的源/输出文件，保留活动编辑器。系统清理缓存后需要重新选择源视频。

## 验证范围

主机测试覆盖范围交叉/边界和溢出、编辑参数进入 Media3、系统选择器入口、文件导入/中断/关闭、pending 行提交顺序与失败清理、后台取消、会话隔离/回收和状态恢复。原生绘制的 editor-empty.png 是 Robolectric 主机渲染。以上都不是 Android 编解码验收。

VideoEditDeviceTest 使用 androidTest/assets/editor-av-fixture.mp4（三秒 H.264 320×180、15fps + AAC 48kHz），在 Android 34 AOSP arm64 模拟器实际运行并通过两个用例：

- 0.5–2.5 秒截取、静音、90° 旋转和黑白效果：输出约两秒、首帧实际解码、竖向画幅、采样像素 RGB 通道近似相等、无音轨并有至少 25 个视频样本。
- 同范围截取并保留原声：横向画幅、一条音轨、至少 70 个 AAC 样本、音频时间戳单调递增且跨度符合两秒片段。

连同 CameraLogicInstrumentationTest 共四项 Android 用例通过。证据见 [instrumentation.log](../artifacts/android/0.3.0-device-reports/aosp-api34-run02/instrumentation.log)、[运行清单](../artifacts/android/0.3.0-device-reports/aosp-api34-run02/acceptance.json)。运行的是已交付的 0.3.0 APK，SHA-256 保持不变。夹具通过项目独立 FFmpeg 6.1 生成，不使用相机素材。这些用例运行实际编解码和 mux，但不经过系统文件选择器或完整编辑 Activity 的 MediaStore 发布流程，也不证明真实素材音画同步。

本次修复了仅编译未暴露的测试 APK 打包问题：Android 系统测试库改为 compileOnly，不再将 Android 自带的 JUnit 类重复打包。可用 `scripts/android_emulator_acceptance.py` 在项目独立 AVD 重现运行；脚本只安装到自己的模拟器，完成后停止该进程。

0.3.1 进一步修正主页面和编辑器的系统导航键对比度，同样在实际 Android 模拟器重跑四项用例通过，见 [0.3.1 运行记录](../artifacts/android/0.3.1-device-reports/aosp-api34-run01/acceptance.json)。脚本可通过 `--apk` 指定保留版本；默认使用最新 APK 别名。

手动验收应覆盖普通 1080p、4K、大视频与非关键帧起点；分别检查保留音轨时的同步、静音、旋转、黑白、重置、选另一视频、屏幕旋转、后台取消、重试、空间不足及源文件保留。真实精度、音画同步和手机温升仍需设备证据。

## 实际 MediaStore 发布和取消

0.3.1 增加 `MediaStoreDeviceTest`：真实 Android MediaProvider 发布后，核对 IS_PENDING=0、路径、MIME、字节长度及 SHA-256，使用内容 URI 解码首帧，并确认源文件保留；另一个用例在 pending 行和输出流创建后取消，核对不留下 pending 或可见结果。测试只清理自己创建的行。

连同已有四项运行用例，[mediastore-run01](../artifacts/android/0.3.1-device-reports/mediastore-run01/acceptance.json) 六项实际 Android 用例通过。这些新增用例调用实际保存帮助类，尚不能单独证明系统选择器和编辑 Activity 的完整操作流程。物理手机、大文件和真实相机素材的音画同步继续待验收。

## 实际系统选择器和完整编辑保存流程

新增 `VideoEditorWorkflowDeviceTest`，在独立 AVD 的 MediaStore 创建三秒合成源视频，通过真实 ACTION_OPEN_DOCUMENT 打开 AOSP DocumentsUI 并选择该文件。测试没有拦截选择器 Intent 或手动调用 Activity 结果回调；通过实际界面控件设置 0.5–2.5 秒范围、静音、黑白和旋转 90°，点击导出，等待“已保存到相册”状态，再从真实 MediaStore 读取结果并实际解码。

[editor-workflow-run02](../artifacts/android/0.3.1-device-reports/editor-workflow-run02/acceptance.json) 用例通过：结果已解除 pending，约两秒，无音轨，竖向画幅，采样像素为灰度，源文件保留。证据目录含系统选择器、时间轴和导出完成截图。测试关闭编辑器并清理本轮源/输出行。首次失败记录 `editor-workflow-run01` 保留：自动化匹配到了文件预览入口，未选择文件；修正为点击文件卡片后完整流程通过，未修改产品代码来绕过失败。

该结果覆盖实际系统选择器、编辑 Activity、实际编码与 MediaProvider 保存，但源素材仍为小型合成夹具，并非物理手机或真实相机 4K 素材。后台取消、配置重建、空间不足及长素材继续按手机验收清单检查。默认 AVD 脚本已包含该用例，七项本地用例；相机 RTSP 首帧用例保持显式 opt-in。

## 0.3.2 修复合并测试暴露的 EGL 释放崩溃

0.3.1 的单独编辑流程成功，然而 `local-suite-run02` 将此前六项与完整编辑流程放在同一进程运行时，第七项发生 SIGSEGV。原始 [崩溃日志](../artifacts/android/0.3.1-device-reports/local-suite-run02/logcat.txt) 定位到 Effect 线程的 `eglDestroyContextImpl`，经 `GlUtil.destroyEglContext`、`DefaultGlObjectsProvider.release` 调用；该失败未删去或标成成功。

对照上游 1.5.1 源码：PlaybackVideoGraphWrapper 静态 memoize 工厂，DefaultVideoFrameProcessor.Factory 在构建时创建并保留 DefaultGlObjectsProvider，后者 release 遍历上下文但不清空。1.8.0 改为处理实例默认创建独立的 GL provider，播放图反射缓存也不再复用同一工厂实例。这与旧版重复销毁上下文的崩溃路径吻合，故统一升级 Media3 各模块到 1.8.0，而非隔离测试进程以绕过失败。源文件审计保留在 `artifacts/android/media3-1.5.1-source-audit/`。

0.3.2 在同一 AVD 进程的 [完整七项回归](../artifacts/android/0.3.2-device-reports/local-suite-run01/acceptance.json) 全部通过，包含实际编解码、MediaProvider 和完整选择/编辑/保存流程；已查看系统选择器、真实彩色预览、黑白旋转预览和导出完成截图。用例结束清理本轮媒体并停止 AVD。该一次完整回归证明已复现序列在新版通过，不能推广为所有手机/GPU 或任意重复次数均无崩溃。

## 真实相机原片的完整编辑保存

同一已交付 0.3.2 APK 在 [camera-original-editor-run01](../artifacts/android/0.3.2-device-reports/camera-original-editor-run01/acceptance.json) 通过 `CameraOriginalEditorDeviceTest` 一项用例。素材来自相机既有 `YDXJ0136.MP4`：31,400,038 bytes，3,637 ms，1920×1080 H.264/AAC；经实际 CameraClient 媒体列表、绑定 Android Network 的 HTTP 下载和 MediaStore 发布后，与相机端独立 `sha256sum` 一致，SHA-256 `c4c3040fa00d536637632c1d8e2d8403a87e78473a3f6382a0704de91fff91cf`。

测试只在模拟器侧给导出源添加唯一显示名，通过真正 DocumentsUI 选择它，再用编辑器控件设置 500–2500 ms，保留原声、灰度和 90° 旋转。源关键帧经过实际 MediaExtractor 扫描，所选起点距离最近关键帧 33,866 µs，因此确实覆盖非关键帧起点。输出已发布并实际解码为 1080×1920 灰度画面，时长 2,017 ms；60 个 H.264 样本、94 个 AAC 样本可读，AAC PTS 严格递增。视频首末 PTS 为 0 / 1,969,133 µs，音频为 12,000 / 1,996,000 µs。

编辑前后手机源文件 SHA-256 一致；相机状态、所选设置、目录列表、源摘要和 boot ID 前后相等。用例关闭编辑器、清理仅本轮新增的源/输出 MediaStore 行、断开相机会话，runner 停止自身 AVD。已检查真实导入画面、调整和完成截图；详细数字见 [camera-original-editor.json](../artifacts/android/0.3.2-device-reports/camera-original-editor-run01/workflow-screens/camera-original-editor/camera-original-editor.json)。这证明短 1080p 原片链路和采样时间边界，尚不证明声音内容已逐样本解码、听感同步、长片/4K、物理手机编解码及温升。

```sh
.venv-reverse/bin/python scripts/android_emulator_acceptance.py \
  --apk artifacts/android/yi4k-control-0.3.2-debug.apk \
  --output artifacts/android/0.3.2-device-reports/camera-original-editor-new-run \
  --test-class dev.yi4k.control.CameraOriginalEditorDeviceTest \
  --expected-tests 1 --camera-media-host 192.168.42.1 \
  --camera-media-path /tmp/fuse_d/DCIM/100MEDIA/YDXJ0136.MP4 \
  --camera-media-path /tmp/fuse_d/DCIM/100MEDIA/YDXJ0141.JPG
```

默认短视频 YDXJ0140.MP4 仅 700.7 ms，不适合两秒编辑用例；必须显式选择足够长且仍在相机中的既有视频。不要为满足测试伪造或延长原片。
