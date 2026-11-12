# Android 0.3.17：素材库空目录与自动加载

本版在 0.3.16 拍摄工作台 UI 基础上修复素材库空目录自动重复请求。

成功加载目录后，App 保留该目录已完成加载的状态。空目录重绘不会再次发起 `listMedia` 请求；用户手动刷新或打开其他目录仍会发起新请求。连接会话重置时，自动加载标记随媒体数据一并清除。

新增 `CaptureUiTest.emptyMediaDirectoryAutoLoadDoesNotLoop`，用隔离的模拟相机空目录验证网络请求次数保持不变。主机全量单元测试通过。未连接实体手机或相机；DCIM 分页和大型目录表现仍需设备验收。

本版没有固件、RTOS、RAM、分区或启动区访问。APK：`../artifacts/android/yi4k-control-0.3.17-debug.apk`。
