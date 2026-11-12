# `false` 单字节指令可见性候选

2026-11-10。本轮把首次执行问题收窄为一个离线可审阅的 **单字节原位修改候选**，不把它描述成通用 payload 入口，也没有访问设备、写 RAM/SD/固件或生成部署器。

复现：

```sh
.venv-reverse/bin/python scripts/audit_false_instruction_visibility.py
```

结果在 [audit.json](../artifacts/device/2026-11-10-false-instruction-visibility/audit.json)，并保存候选行邻居、解释器、`loadbin` 和字节复制 helper 的反汇编。

## 候选字节和原厂调用 ABI

固件表 `A06F2F0C` 的 `false` 项指向 `A02A0AA8`。该函数正好8字节：

```text
A02A0AA8  00 00 E0 E3    MVN r0,#0       ; 返回 0xffffffff
A02A0AAC  1E FF 2F E1    BX  lr
```

候选只改变 `A02A0AAA` 一个 byte：`E0 → A0`。结果为合法原生指令：

```text
A02A0AA8  00 00 A0 E3    MOV r0,#0       ; 返回 0
A02A0AAC  1E FF 2F E1    BX  lr
```

`BX lr`、栈、寄存器保存都不变；同一 **32-byte 对齐、与原厂 cache 维护使用的粒度相符的窗口** 内，`A02A0AA0` 是 `MOV r0,#0`/`POP`，`A02A0AB0` 是 `CMP`/后续 `echo` 命令处理。这里保留邻居事实，不把硬件实际 cache-line 大小当作已观测值，也不能把该窗口当作孤立可执行 RAM。

对整个固定 A32 镜像的字节指针、短距离分支和有限 MOVW/MOVT 常量扫描只找到一个 `false` 表项指针，没有直接入边。这只说明已恢复索引范围内未找到额外静态引用；不能排除计算指针、Thumb、复制表、脚本或未捕获代码。

普通命令执行器的真实 ABI 已在合成内存中执行：原始 handler 接收 `argc/argv/print`，返回值进入 `$?`。`false` 原码得到 `0xffffffff`，`if $?; then ... else ... fi` 走 ELSE；修改后的 handler 得到 `0`，走 THEN；恢复数据 byte 后再次走 ELSE。三种场景保持 SP 与 callee-saved 寄存器，输出均为原 dispatcher 路径的打印回调。

解释器并非只由 Shell 任务使用。已恢复的直接调用包括主应用 `A019D1E0 → A029DE98`，以及 `A01AC580` 内五个 `t audio-enc init/create/encstart/stop/delete` 命令构造路径。它们说明不能凭“Shell 同步”假定 `false` 代码行没有后台/主应用调用；运行时仍需先证明实验窗口无这些命令和任务并发。

## `loadbin` 精确写入边界

原厂 `loadbin` 只接受三个参数：文件名、目标地址、打印回调。它先用文件 `stat` 得到长度，然后调用：

```text
fread(destination, size=1, count=stat_length, file)
```

离线真实 ARM 执行场景核对了目标 `A02A0AAA` 和 `size=1`。长度为1时请求恰为1 byte；长度为2时会请求2 bytes，不能用“大于1文件”做试验。更关键的是，`stat` 失败分支只打印错误后仍落入后续流程；若栈上长度未被安全初始化，可能向目标地址发出不受控长度请求。因此真机实验若获批准，文件必须由独立主机校验为精确1 byte、文件系统返回成功，且 `loadbin` 返回码和原值读回都必须核对；本轮没有执行该操作。

底层分段读取 helper 的离线原码场景（sector offset 0、17、511）均只向目标写入一个 byte，验证了“单字节读取/复制”在声明的文件服务与缓存对象替身下不会扩展为整 sector 写入。它不是实际 SD/FAT 语义证明；真实文件服务、DMA、错误处理和设备写入仍未观察。

## 能证明什么、不能证明什么

该候选可以把真机问题定义成“一个原位 byte 是否被随后调用观察到”，而不是先承担任意代码 heap、任务栈和新函数指针。但它仍然需要写入现有 WB text，风险包括：

- 当前核心可能继续从旧 I-cache 执行 `MVN`，所以行为不变不能区分写入失败与取指未更新；
- 恢复 byte 后，核心可能继续执行旧 `MOV`，所以内存恢复不等于执行状态恢复；
- 其他核心或后台调用可能落入同一 handler；
- 失败、掉电或不返回时，Shell 连接、录制状态和相机任务可能失联。

原厂已有的 cache 命令只覆盖 D-cache；现有 I-cache 指令位于 BOSS/MMU/低功耗路径，没有独立可返回的 `clear_cache(start,size)`。BOSS 核间 callback 目前固定做 TLB 维护，并无 I-cache 失效或远端完成回执。因此不能声称 stock 命令已经提供 WB text 的发布顺序。

最小候选状态表只能写成：

| 阶段 | 明确字节/结果 |
|---|---|
| before | `A02A0AAA = E0`; `false` 返回 `FFFFFFFF`，条件走 ELSE |
| proposed | 单字节 `A02A0AAA = A0`; `false` 应返回 `0`，条件走 THEN |
| restore | 单字节 `A02A0AAA = E0`; 内存读回应为原 byte，行为仍需再次验证 |
| cold reset | 必须确认真实 RTOS 冷启动重新装载原固件、命令表和该代码行；BOSS resume/休眠恢复不等价 |

离线证据因此支持“用户可审阅的单字节可见性探针候选”，不支持现在提出真机执行命令。要进入用户确认的真机步骤，还必须额外闭合：独占窗口、文件服务精确1B成功、写入前后原值读回、无法返回时的独立冷复位路径，以及对旧/新 I-cache 结果的可区分观测。
