# Android 已保存相机自动连接

App 在成功建立相机 API 会话后保存 SSID、BSSID、Wi-Fi 安全类型和相机地址。密码仍由 `CameraWifiConnector` 使用 Android Keystore 加密保存；这组连接元数据不含明文密码。

冷启动首次显示连接页时，若存在完整的已保存 SSID/地址配置，App 会先通过 Android `WifiNetworkSpecifier` 请求该相机热点，再走同一套 7878 握手。系统网络请求、地址无效或握手失败时只执行一次回退，回到常规 Wi-Fi 搜索，不循环重连，也不自动发送拍摄命令。

主机回归覆盖：成功连接元数据写入、未保存密码、缺失/非法配置回退。实体手机还需验证 Android 系统 Wi-Fi 已连接相机热点、冷启动直达拍摄页、断网和密码失效后的手动恢复。
