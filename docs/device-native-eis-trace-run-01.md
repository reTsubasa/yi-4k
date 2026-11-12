# Stock-only EIS 真机边界实验 run01（2026-11-12）

本次实验验证了原厂诊断文件的暂存、失败识别和清理路径，没有执行自定义 EIS 代码或写入固件/RAM。目标相机为 `192.168.42.1`，固件为 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。

## 执行记录

1. `stage` 使用唯一标识 `0de69306cc9a` 独占写入 `autoexec.ash`、worker 和空日志标记，回读 hash 一致。
2. `collect` 按原设计尝试读取 `before/active/after` 快照。`active` 文件不存在，验证器返回 `Operation not confirmed`，没有把失败误记为 EIS 执行成功。该缺失本身不直接证明 reader 未进入；本轮未记录新的脚本触发事件或 reader 前段执行回执。
3. `disarm` 使用原 stage 回执核对并删除本次创建的配置文件，回执为 `owned_configuration_removed=true`、`evidence_retained=true`。
4. 清理后只读复核回到 `idle`，EIS 仍为 `on`，SD 仍为 `insert`，固件和设置保持一致。

证据目录：

- [stage 回执](../artifacts/device/2026-11-12-native-eis-trace-stage-01/session.json)
- [collect 失败回执](../artifacts/device/2026-11-12-native-eis-trace-collect-01/session.json)
- [collect 原始输出](../artifacts/device/2026-11-12-native-eis-trace-collect-01/telnet-output.txt)
- [disarm 回执](../artifacts/device/2026-11-12-native-eis-trace-disarm-01/session.json)
- [清理后只读复核](../artifacts/device/2026-11-12-readiness-probe-02/session.json)

## 结论与下一步

该 run 证明了设备可达、临时文件可独占暂存、未触发时能识别缺失证据并安全清理；它**不证明 EIS 原生执行、算法替换或 warp 表生效**。要触发这条 stock-only 诊断链，需要一次受控的相机启动/重启窗口；在没有该窗口前不重复执行 collect，也不把 `vf/capture` 状态变化解释为自定义代码进入。

后续静态/原 ARM 验证把触发条件收窄到[合格 StorageIdle 事件](device-1107-autoexec-storage-gate.md)：
`A01A0C94 → A029DE88` 给 Shell 置 `0x2`，Shell 才读取固定 `c:\autoexec.ash`。
文件存在不自动产生事件，打开失败也会清事件；下一次先验收 stock reader 的最小前段输出，避免把缺失 active 直接归因于 EIS。
