# Android 0.3.10 交付级只读审计

更新时间：2026-11-10 UTC。审计没有连接相机，也没有写入设备。

## 结论

0.3.10 APK 可以手动安装到 Android 10（API 29）及以上设备。`aapt dump badging` 确认包名为 `dev.yi4k.control`、版本 `0.3.10`、versionCode `13`、target SDK 35；`apksigner verify --verbose` 确认 APK Signature Scheme v2 有效。APK 仅声明 INTERNET 和 ACCESS_NETWORK_STATE 权限，主 Activity 可启动，使用明文 HTTP 是为了连接相机的原厂 7878/80 接口。

本轮发现的高优先级问题是短屏和横屏拍摄页的预览最小高度会压住参数胶囊和固定快门区。已将预览高度改为按可用空间动态收缩，最低 72dp；紧凑预览隐藏说明文字、缩小相机图标与元数据角标。PrototypeRenderTest 覆盖 360×560、412×700 和 700×412，全部通过。

## 验证

- `testDebugUnitTest`：通过
- `lintDebug`：通过
- `assembleDebug`：通过
- `PrototypeRenderTest`：通过
- `CaptureUiTest`：通过
- Manifest、版本、权限和签名：通过
- 真机和相机热点：本轮未执行

APK 及 SHA-256 见 [2026-11-11-build-0.3.10.json](../artifacts/android/2026-11-11-build-0.3.10.json)。

## 交付边界

该 APK 是 debug 构建，使用 Android Debug 证书，适合用户手动安装测试；若后续需要覆盖已经安装的其他签名版本，必须使用同一签名或先卸载旧包。实体手机 Wi-Fi、字体放大、旋转、长文件导出和完整相机拍摄仍需用户设备验收。
