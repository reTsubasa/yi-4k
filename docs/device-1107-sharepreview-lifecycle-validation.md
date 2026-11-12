# YI 4K 1.10.7 SharePreview 生命周期真机验证

日期：2026-11-09；2026-11-10补充恢复检查。目标：验证静态恢复的 `t app test sharepv init/en/dis` 生命周期，以及 Linux RPC 状态回读。固件身份为 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。

后续已完成[初始化依赖审计](device-1107-sharepreview-init-dependencies.md)：26 个函数、18 处指令复核；探针已改为 init-only、SD 阶段标记和分离采集/清理，仅完成主机验证，尚未重新部署。下文 stage-06 是修订前的历史实验。

**当前状态：用户重启后 Telnet/API 恢复，API 为 `idle`；本次探针的 8 个路径全部不存在。SharePreview 仍返回服务未找到。没有取得上次 init/en/dis 的执行回执，无法把网络失联归因于 `sharepv init`。**

## 已完成

主机先后修正了探针的两类传输问题：长 heredoc 会被 Telnet PTY 丢字节，随后改用逐块 Base64 上传并在目标端 SHA-256 校验。最终 [stage-06](../artifacts/device/2026-11-09-sharepreview-lifecycle/stage-06/session.json) 返回 `created_exclusively=true`，只创建了本次唯一命名的：

- `/tmp/SD0/autoexec.ash`
- `/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc.py`

脚本内容是原厂 RTOS Shell 命令序列：开始标记、`sharepv init`、状态 RPC、`sharepv en`、状态 RPC、`sharepv dis`、状态 RPC、结束标记。没有刷写固件、映射 `/dev/mem`、录像或写 PTB。

## 重启结果

第一次 `/sbin/reboot` 和一次 `/sbin/reboot -f` 的即时返回不足以证明整机已重启；随后通过带回显等待的调用观察到 Telnet 连接掉线。此后连续 180 秒轮询 192.168.42.1 的 23 和 7878 端口，两者始终不可用，当时无法采集 `begin/init_after/enable_after/disable_after/done` 标记或 RPC JSON。

这只能说明本次网络路径没有恢复，实验没有取得生命周期回执。此前把失联描述为“很可能停在 init”缺乏证据，现予纠正：Linux 重启、RTOS 状态、Wi-Fi 恢复和 autoexec 执行均未有足够观测来区分。不能把“端口未恢复”写成 `init` 已执行、卡死或导致异常。原始轮询 JSON 中的解释保留为当时推测，以本节更正为准。

证据：

- [stage-06 主机回执](../artifacts/device/2026-11-09-sharepreview-lifecycle/stage-06/session.json)
- [目标端传输回执](../artifacts/device/2026-11-09-sharepreview-lifecycle/stage-06/transport.json)
- [强制重启尝试](../artifacts/device/2026-11-09-sharepreview-lifecycle/reboot-02/attempt.json)
- [端口轮询结果](../artifacts/device/2026-11-09-sharepreview-lifecycle/reboot-02/poll-result.json)

## 2026-11-10 恢复检查与清理

用户报告已重启后，实测 23/7878 端口可连接，首次 Linux uptime 为 54.87 秒，固件身份未变，API 状态为 `idle`。SD 根目录的 `autoexec.ash` 已不存在，唯一遗留文件为 `/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc.py`，没有 RPC 结果文件。五个 `/tmp` 标记也不存在，但它们位于 tmpfs，重启后的缺失不能反推上次命令未运行。

先将遗留脚本读回电脑，再验证其 1,304 字节及 SHA-256 `babc8811ea985563707209748645029f74001c449c13336e56ca1e06fe6114a9` 与 stage-06 一致。随后再次在目标核对全部路径和该文件哈希，只删除这个归属文件并 sync。最终独立检查确认 8 个探针路径全部不存在，传输临时源文件已清理，没有遗留日志临时挂载，API 仍为 `idle`。本轮未重启、未录像、未改设置、未初始化或启用 SharePreview、未映射 `/dev/mem`。

只读调用 SharePreview proc 3 返回 `-1`，库明确打印 service not found；输出槽仍是预填的 `0xDEADBEEF`，它不是服务状态，未继续调用 meminfo。

另通过临时只读 ambafs 挂载取得 b: 下三份原厂日志，共 2,851,415 字节，传输长度与 SHA-256 均核对通过，挂载已卸载。在这三份文件内，SharePreview、探针标识、autoexec、exception/data abort/assert/panic 的限定搜索均为 0；每份包含一次 VideoAnal 初始化完成打印。但文件没有与本次实验关联的唯一标记、共同时间基准或执行回执，不能认定它们覆盖故障时刻，也不能用字符串缺失证明未执行或无异常。

恢复证据：

- [初始状态与 API 回执](../artifacts/device/2026-11-10-sharepreview-recovery/initial/session.json)
- [文件检查与主机备份](../artifacts/device/2026-11-10-sharepreview-recovery/file-inspection/files.json)
- [按哈希清理回执](../artifacts/device/2026-11-10-sharepreview-recovery/cleanup/result.json)
- [只读 SharePreview 查询](../artifacts/device/2026-11-10-sharepreview-recovery/rpc-status/session.json)
- [日志采集与卸载](../artifacts/device/2026-11-10-sharepreview-recovery/native-log/session.json)、[限定搜索结果](../artifacts/device/2026-11-10-sharepreview-recovery/native-log/bounded-findings.json)
- [最终状态](../artifacts/device/2026-11-10-sharepreview-recovery/final-status/session.json)

## 结论边界

本轮证明探针文件成功 stage、恢复后能够按归属备份与清理，原厂 API 在恢复检查时可用。没有证明 `sharepv init` 被执行或能返回，也没有证明 EIS 效果改变、当前视频完整解码或自定义 ARM 执行。尚不重放该启动实验。

离线恢复已补充 `init` 的调用上下文、VideoAnal/memory pool 前提、分配等待方式及 RPC 错误处理缺口，见[初始化依赖审计](device-1107-sharepreview-init-dependencies.md)。下一步仍需建立初始化前即可工作的独立观测通路。普通 `en/dis` 只能在初始化返回后运行；Linux RPC 的超时或 Python alarm 也不能中断已经卡在 RTOS 内的初始化调用，不能把这些顺序清理或超时称为独立 watchdog。只有可区分 Linux 重启、RTOS 执行和网络恢复的证据齐备后，才部署下一次单步真机实验。
