# Android 0.3.14 大于 4 GiB 原片传输边界

本轮没有修改产品代码或 APK。已交付的 `yi4k-control-0.3.14-debug.apk` 在单独 AOSP 34 ARM64、8 GiB data partition 的模拟器，使用实际 `MediaExporter`、本地 HTTP 与 MediaStore 完成两项显式大文件测试。不是实体手机或真实相机长录像验收。

## 实际结果

| 检查 | 结果 |
| --- | --- |
| 完整 HTTP body / 导出进度 / 输出 FD stat / 全量读回 | 全部为 4,296,015,995 bytes（大于 2^32） |
| HTTP 源、产品导出结果与独立读回 SHA-256 | 全部为 `b2091c7cf29c5012e039cec4e3978fe8b1eb2039740f4b42d0ef84eae76d990f` |
| 主机从 test APK 重新构造输入并计算摘要 | 与上述一致 |
| 写入期间与发布后 | 实际 `IS_PENDING=1 → 0`；发布后 content URI 可解码 320×180 首帧 |
| 超过 2 GiB 后取消 | 实际进度 2,174,780,138 bytes 后收到取消错误；未发布/残留半文件 |
| 隔离与清理 | 两项测试后自身 Movies/YI4K 行集合与开始相等；模拟器已关闭 |

完整用例约 21.6 秒，取消用例约 9.8 秒；这是本机模拟器/loopback 和此测试素材的执行时间，不是相机 Wi-Fi 吞吐或实体手机性能指标。Android 最大堆记录为 192 MiB，未将整个大文件装入内存。

输入为 test APK 中 99,034 bytes、约 3 秒的真实短 MP4，末尾追加一个合法 64-bit extended-size `free` box 与零填充。HTTP 确实发送所有字节，MediaStore 确实逐字节写入并全量读回，不是 sparse 文件跳过数据，也不是计数器直接跳过 4 GiB。填充不代表新增画面，不证明 4 GiB 编码素材、真实相机大 GOP/长时音画同步、手机文件系统容量或真实热点性能。

## 复现与身份

测试文件为 `android/app/src/androidTest/java/dev/yi4k/control/LargeOriginalExportDeviceTest.java`。默认小型套件不包含此类；runner 必须显式指定 `--large-original-export`，拒绝与相机/进程终止测试混用，并采用独立 `yi4k-large-export-api34` AVD。测试还检查 `Build.HARDWARE=ranchu` 和剩余空间，不安装到实体手机。

```sh
cd android
JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home \
ANDROID_HOME=/Users/hyc/Library/Android/sdk ./gradlew assembleDebugAndroidTest
cd ..
python3 scripts/android_emulator_acceptance.py \
  --output /tmp/yi4k-large-export-independent \
  --apk artifacts/android/yi4k-control-0.3.14-debug.apk \
  --large-original-export \
  --test-class dev.yi4k.control.LargeOriginalExportDeviceTest --expected-tests 2
```

- 产品 APK SHA-256 保持 `1503d3bd73d39cd9985c69c2aea04e81b1d863c31e2486cad943a2aa77f6ebe6`，latest 别名仍相同。
- 本轮新增 test APK 独立保存在 `artifacts/android/yi4k-control-0.3.14-tests-largev1.apk`，SHA-256 `779a78d6ea81d992cf97f085e30c346f97722cf4529ec53882ebbad77ca921e8`。旧 0.3.14 测试包与既有本地 9 项/进程终止证据保持原身份。
- [实际运行记录](../artifacts/android/0.3.14-device-reports/large-original-export-run01/acceptance.json)、[完整导出记录](../artifacts/android/0.3.14-device-reports/large-original-export-run01/workflow-screens/large-original-export/complete.json)、[取消记录](../artifacts/android/0.3.14-device-reports/large-original-export-run01/workflow-screens/large-original-export/cancel.json)、[主机独立摘要与源码绑定](../artifacts/verification/2026-11-11-android-large-export-independent.json)。

没有新相机访问、录制、配置、固件/RAM/分区写入。后续仍需要用户实体手机热点与普通长原片导出验收。
