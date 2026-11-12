# 1.10.7 autoexec：存储事件门禁与下一次最小验收

2026-11-12。本机 `autoexec.ash` 不是文件监视器：**正常入口由存储初始化完成消息触发，
并在一次读取尝试后清掉事件；把文件放到已经启动的相机上，不会因此自动执行。**
本轮只使用固定本机 RTOS 镜像与既有采集，未连接、重启或修改相机。
新增的是原 ARM 控制流和脚本 reader 的有界执行证据，不是另一份摘要一致性检查。

RTOS 窗口 SHA-256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
REA MCP 在本会话不可用；依据为既有 Ghidra 导出、固定字节、Capstone 与 Unicorn。

## 实际触发链及分支

| 环节 | 固定地址和行为 | 不满足时的行为 |
|---|---|---|
| 存储 refresh | `A0224318` 先发送 `0x38010001`，refresh 后发送 `0x38010002`，后者第三个消息字为 0 | refresh 是否成功仍由具体服务与调用者处理 |
| 消息分派 | `AppHandler_Entry A019D1E0`；`A019E7E8..7F4` 比较 `0x38010002`；固定日志名 `HMSG_STORAGE_IDLE` | 其他消息走其他分支 |
| 特殊 completion | `A019E818` 检查消息第三字 `r8==1` | `A01A054C..57C` 调应用 callback 后返回，不置 autoexec 事件 |
| 插卡状态 | `A019E820` 调 `A02231E0`，要求返回 0 | 非 0 经 `A01A04E8 → A01E659C` 重投同一 StorageIdle 消息；这是应用消息重投，不是脚本打开失败重试 |
| drive/busy slot | `A0222DE8` 把消息 drive 字符转 slot，`c` 对应 2；`A019E874` 与 `A1055CD8+0x18` busy slot 比较 | 不符打印 `The storage idle slot ... is not the same as busy slot ...`，清 busy slot 后返回 |
| 优先级 | `A01A0BEC..C24` 查询 `A02237CC`、`A0223274` | 有更高优先级 slot 时经 `A01A10E0 → A0223854` 返回 |
| primary slot | `A01A0C28` 调 `A022328C`，`A01A0C2C` 要求 primary 与本次 slot 相同 | 不同则返回 |
| 置位 | `A01A0C94 → A029DE88`；thunk 向事件组 `A1446558` 置 mask `0x2` | 文件存在本身不调用这个 thunk |
| 消费 | `AmbaShell_ExecTask A029D4D8` 等待 mask `0x3`；`A029D508` 检查 `0x2`，`A029D570 → A029D3B4` | mask `0x1` 是普通命令/显式 `.ash` 路径，不能混成同一触发来源 |
| 固定路径 | `A05AE4A8` 存放 `c:\autoexec.ash`，`A029D3C4 → A032E0C8` 按 `r` 模式打开 | 失败返回 `0xffffffff`；Shell 不检查 reader 返回值，仍在 `A029D57C` 清 `0x2` 并再次等待 |

置位前还会调用偏好处理、日志配置、RTOS 日志复制等原厂服务。
本探针把这些服务和应用 callback 设为返回的 host mock；若服务在硬件上阻塞，静态条件满足也不能保证到达置位点。
原厂 Shell 创建条件同样必须成立：`A029DC38` 建立事件组并创建/启动 CliTask 与 ExecTask；
其真实运行存在性可由此前采集的 `ps tsk` 证明，不能从固件内有名字就断言当前实例存在。

这不是“只在冷启动调用一次”的保证。`A0223A24` 的插卡/SetRoot 成功路径在
`A0223DC8` 调 refresh；已有其他 refresh 调用点也会发送存储消息。
新一次合格 StorageIdle 可再次触发 autoexec，多个事件也可能合并。
因此不建议用伪造消息、格式化或反复插拔卡替代已审阅的启动验收；不能把脚本天然视为 exactly-once。

## 已用原 ARM 指令验证的边界

[探针](../scripts/audit_autoexec_storage_gate.py)覆盖 18 条固定指令、7 个存储分支场景、
4 个 Shell 事件场景、6 个 reader 场景。合成 RAM 中运行原指令；卡状态、事件服务、
文件服务、应用服务和命令 parser 是明确的 host mock，未运行真实命令 handler。

- completion=1、busy slot 不匹配、primary 不匹配、优先级分流均不置脚本事件；卡状态尚未就绪时重投消息。
- 符合条件时实际走到原 thunk，记录 group=`A1446558`、flags=`2`。
- flags=2 时 reader 返回 0 或 -1 都清 mask 2；flags=3 时先处理 autoexec，仅清 mask 2。
- 文件打开失败无命令交给 parser；EOF 只关闭文件，**未以 LF/CR/NUL 结束的最后一行不会提交**。
- CRLF 会额外提交空行；tab 分支写入空格但不推进游标，后一个字符覆盖该位置，`ps\ttsk` 到 parser 时变成 `pstsk`。

对 run01 归档脚本也执行了原 reader：SHA 为
`6ceda2695f5e56ba5bb1b246c3bd1ccc78389413bdd469dede25f4effc0cc06e`，
16 次行提交全部到 parser mock，最长行 68 字节、末尾 LF、没有 tab。
这排除了上述 EOF/tab 分帧缺陷作为该文件的解释，**不证明 parser、RPC、EIS handler 或 worker 在相机上成功**。

## run01 为什么没有 active

run01 的 stage 和 collect 相隔约 31 秒；操作分别是文件暂存和采集，回执没有提供这段期间
新的合格 StorageIdle 事件或 Shell reader 进入记录。归档没有 active，故不能证明 reader 到达。
根据本轮机制，继续等待/重复 collect 不会因文件存在而创建执行事件。

同时，`active` 缺失单独不能排除“reader 已进入但某个较早命令失败”。旧说明的
“启动流程尚未触发”应当视为当时的机制判断，而不是已直接观测的失败根因。
下一次必须先取得 reader 前段的独立证据，才能将失败定位在门禁、文件打开、命令分派或 EIS 之后。

已有成功样本 `e30da2b76aa5` 在重启后取得相同固件指纹、任务文本和 claim/done，
claim/done Linux uptime 为 23.90/27.26 秒，且任务文本列出 `AmbaShell_ExecTask`。
这证明本机该固件确实能执行 stock autoexec 诊断，故无需再猜文件名是否整体被删除或禁止。
该历史样本不证明 run01 的当前启动也进入 reader。

## 只读确认与下一次最小验收

当前只读复核应记录：API 固件/硬件、`sd_card_status`、`app_status`；Linux boot ID/uptime；
`/tmp/SD0` 的挂载身份、脚本文件类型/大小/SHA。它们能验证前置状态，**不能直接证明 RTOS busy/primary slot 或事件 bit**。
已存在且当前可读的 RTOS 日志可搜索以下固定行，不为此启用新 logger 或触发新存储消息：

```text
[HMSG_STORAGE_IDLE]
chk inserting card complete,slot = ..., busyslot = ...
ReturnValue:...,ActiveCardId:...
PrimarySlot:...,CurApp:...
```

这些行能区分卡状态等待、busy mismatch、primary 检查到达；日志有范围/丢失限制，
不见日志不等于事件没发生。若已无可读日志，本轮应报告不可观测，不通过 `/dev/mem` 或消息重放补齐。

下一次独立审阅的验收只验证 stock 脚本进入和返回：使用单一 nonce、已校验的 LF 文本，
只保留一份原厂任务概要输出与固定 8 字节代码指纹；在受控正常启动窗口前完成暂存回读，
启动后仅采集输出、启动身份、文件摘要和 API 就绪状态。结果不完整则保留部分输出，逐层判断门禁/读取/分派，
不直接运行长 EIS 配置/录像 worker 链。此处仅描述下一次方案，没有生成、暂存或执行该脚本。
普通启动即便证明 stock reader 可用，仍不能证明补丁前失联时的独立恢复。

后续已准备[确切两行脚本及 dry-run 验收包](device-1107-stock-entry-acceptance-plan.md)，
包含独占 claim、stage/collect/disarm/cleanup review 文本、目标文件清单与停止条件；当前仍未执行。

本增量缩小了 P1 的外部 stock 命令触发条件；它仍未建立外部任意 ARM entry。
P5 I-cache/ISB/SMP 与 P11 独立恢复、冷启动回滚均未解锁。

## 复现与材料

```sh
.venv-reverse/bin/python scripts/audit_autoexec_storage_gate.py
```

- [结构化 ARM 场景回执及导出片段](../artifacts/verification/2026-11-12-autoexec-storage-gate-run01/audit.json)
- [存储 refresh 原反编译](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0224318.c)
- [插卡/SetRoot 原反编译](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0223a24.c)
- [历史成功样本](../artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-03/session.json)
- [run01 暂存](../artifacts/device/2026-11-12-native-eis-trace-stage-01/session.json)、[采集失败](../artifacts/device/2026-11-12-native-eis-trace-collect-01/session.json)

检查器 SHA：`3553869b4ab41d06b1435dcc1527d88ab0f5dc466b90855c868fbb8d46202eed`。
回执 SHA：`5c71cf0a3f5470c31b824938c7b76e6d8f82c64c0fd919cdc34a3ed3522cfa61`。
