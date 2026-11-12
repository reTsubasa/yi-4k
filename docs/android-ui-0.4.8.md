# Android 0.4.8：设置参数值中文显示补全

2026-11-12。版本号 0.4.8，versionCode 31。继续沿用 [0.4.7 的拍摄与全屏布局](android-ui-0.4.7.md)，本次仅修复已确认的设置值显示缺口。

## 修复内容

离线复核此前留存的 1.10.7 固件设置快照，发现字段名称已是中文，但部分值仍显示固件原文或缺少单位。本版在 `CameraSettings.displayValue()` 中按字段限定转换：

| 设置 | 原值 | 界面显示 |
| --- | --- | --- |
| 视频日期水印 | `date/time` | 日期与时间 |
| 视频/照片日期水印 | `date` / `time` | 仅日期 / 仅时间 |
| 连拍数量 | `3 p / s` | 每秒 3 张 |
| 录像中拍照间隔 | `5` | 5 秒 |
| Wi-Fi 地区 | `CN` | 中国 |
| 语音语言（仅固件实际返回时） | `cn` / `EN` | 中文 / 英语 |

转换只用于界面。原始 JSON、相机声明的可写选项与写入值均未改变；未知地区、语言或未来格式保留原文。语音语言行仍只读，没有新增语音开关或相机指令。

源快照、摘要和逐项映射见 [离线复核记录](../artifacts/android/0.4.8-host-reports/localized-setting-values.json)。[修复前失败用例](../artifacts/android/0.4.7-host-value-review/before.xml)明确记录 `date/time` 未被翻译，避免把新增断言通过误当作缺陷已复现。

## 验证范围

新增主机断言覆盖精确中文值、未知格式回退、原始可写选项保留。主机原生设置行渲染由两项扩展为七项，在 288/360 宽度和 1.0/1.6 字体下检查名称与值互不重叠，语音语言行无编辑箭头。

208 项 Debug 主机测试全部通过，无失败、错误或跳过；Lint 为 0 errors / 74 warnings。产品 APK 与测试 APK 均通过 v2 签名验证，Debug 证书与 0.4.7 相同。

实际 Android AVD 的 [2 项测试通过](../artifacts/android/0.4.8-device-reports/settings-values-run01/acceptance.json)。设置测试使用七条本地数据，检查独立的预期中文值、名称/值完整可见且无重叠或截断、原始数据不变、语音语言只读。另使用同一新包复跑全屏进入、横竖屏切换、退出和设置导航，检查同一预览容器及控件可达性。[18 张原始截图及视觉复核](../artifacts/android/0.4.8-device-reports/settings-values-run01/ui-review.json)已留档，语音语言行确实无编辑箭头，全屏退出后五个参数完整可见。模拟器已停止，可重建运行磁盘按既有脚本清理。

构建、测试数量、签名、APK 与截图摘要统一记入 [0.4.8 构建回执](../artifacts/android/2026-11-12-build-0.4.8.json)。快速浏览：[设置截图拼图](../artifacts/android/0.4.8-device-reports/settings-values-run01/settings-contact-sheet.png)、[全屏与导航拼图](../artifacts/android/0.4.8-device-reports/settings-values-run01/fullscreen-contact-sheet.png)、[参数完整性拼图](../artifacts/android/0.4.8-device-reports/settings-values-run01/fullscreen-parameters-contact-sheet.png)。拼图仅缩放原始截图，原图仍独立保留。

本次不访问相机、不安装实体手机，不重复大文件导出验收。AVD 使用未连接状态和明确的本地测试数据，不能证明真实 RTSP、手机热点、相机语音识别或手机旋转行为。EIS 替换与一分钟预录仍未接入 App。

[0.4.8 Debug APK](../artifacts/android/yi4k-control-0.4.8-debug.apk)。[0.4.7 APK](../artifacts/android/yi4k-control-0.4.7-debug.apk)及原证据继续保留。
