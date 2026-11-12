# 2026-11-11 相机只读探针复跑

使用 Android 项目内的 `liveCameraProbe`，参数为 `recordSeconds=0`、`capturePhoto=false`、`changeSetting=false`，目标为当前相机热点 `192.168.42.1`。探针只读取固件、状态、设置、电量和 DCIM 列表，不录像、不拍照、不修改配置。

证据：[session.json](../artifacts/device/2026-11-11-readonly-probe-03/session.json)

结果：

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`
- 硬件：`YDXJ2_V13LW`
- 探针前后状态均为 `idle`
- 探针前后关键设置一致：`1920x1080 30P 16:9`、`S.Fine`、EIS `on`、SD `insert`
- 探针前后媒体条目均为 44 个
- `selected_settings_unchanged=true`，无通知和清理动作

这次复跑只证明普通 API 只读状态和媒体枚举仍可恢复，不能证明 EIS 替换、相机独立一分钟预录或语音/快门触发已经实现。
