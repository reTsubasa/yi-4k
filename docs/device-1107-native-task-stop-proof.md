# 1.10.7 TaskQuery 与外部停止证明

固定 1.10.7 映像中的 `TaskQuery` 可以给出经过 SMP 全局锁保护的任务状态快照；它不是对任意任务都成立的“所有执行代码、栈、退出通知和外部控制器已静止”证明。自然完成状态 `1` 的原厂路径比此前仅查看状态写入顺序得到的判断更强：全局计数会保留 SMP 锁，直到当前任务上下文退出。因此不能简单声称“写完 state=1 后别的核即可删除”。但状态 `2` 的挂起任务终止路径存在不同顺序，不能把 `state ∈ {1,2}` 加 `delete=0` 直接绑定为通用 stopped proof。

本轮对本机留存的原始固件字节执行 32 个用例、3 个控制指令交错，以及一个完整到调度选取边界的已完成任务移除路径。全程离线，无相机访问。保持现有 owned-retirement 组件冻结，没有添加相机服务绑定。

## 输入与证据类型

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。
- 映像 SHA-256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，基址 `0xA0100000`。
- 反汇编使用 Capstone，执行使用 Unicorn；已有 Ghidra 导出用于边界与调用者定位。可执行验证每次重新核验整幅映像哈希。
- 本会话无 REA MCP 工具；遵循 reverse-engineer-anything 的证据区分原则，复用既有导出与普通本地工具，没有虚构 REA Evidence ID，也未修改 REA 注册配置。

## 查询合同

`0xA03BC324(task, out)` 的外部输出是三个 32 位字：

| out 偏移 | 来源 | 意义 |
|---|---|---|
| `+0` | task `+0x30` | 原始线程状态 |
| `+4` | task `+0xB0` | 优先级字段 |
| `+8` | task `+0x28` | 名称指针 |

它通过 `0xA03C4500` 调用底层 `0xA03C0190`，后者在原始 `0xA03C13B0 / 0xA03C1428` 临界区内复制字段，成功返回 `0`。八个输出可分别为 NULL；底层查询顺序为 name、state、run count、priority、preemption threshold、time slice、next-created、next-suspended。测试核验了全部八字和全 NULL 输出。

检查层只验证 task 非 NULL 且首字等于 `THRD = 0x54485244`；不检查全局创建链、所有权、generation、当前执行者或栈安全。NULL/映射内坏 magic 返回 `0x0E`。未映射 task 仍会在读取 magic 时 fault，输出 NULL 会在写出时 fault，不能把 API 当成任意指针校验器。

上层 `0xA03BC324` 保留底层返回码，但**即使底层失败仍把未初始化的栈临时值复制到 out**。以 `0xA5` 预填的离线栈会得到三字 `0xA5A5A5A5`，同时 R0=`0x0E`。因此必须先检查状态码为零，才可解释 out；提前清零 out 不会修复这个行为。查询不改变任务对象；它也不将未知状态值正规化。

## 删除与终止的真实失败行为

| API / 条件 | 返回 | 对已映射合法任务的影响 |
|---|---:|---|
| delete `0xA03BC30C → 0xA03C448C`：非法调用上下文 | `0x13` | 对象、magic 和链保留；上下文检查先于 magic 检查 |
| delete：NULL/坏 magic，且上下文正常 | `0x0E` | 不删除 |
| delete：state 不是 `1` 或 `2` | `0x11` | 完整对象和创建链保留 |
| delete：state=`1/2` | `0` | 清 magic，创建数量减一并摘除链；不执行 allocator free |
| 再次 delete 已删除对象 | `0x0E` | 不再次删除 |
| terminate `0xA03BC310 → 0xA03C4694`：NULL/坏 magic | `0x0E` | 不改变任务；magic 检查先于上下文检查 |
| terminate：合法任务、非法上下文 | `0x13` | 完整对象和状态保留，不能假定任务停止 |
| terminate：已完成=`1` 或已终止=`2` | `0` | 不清 magic，不执行 delete |
| terminate：构造的 suspended=`3`、无通知回调 | `0` | 执行原始移除/锁/调度再考虑，改 state=`2`；对象仍存在 |

失败结果来自原始分支，不是向服务 stub 注入错误。实测 delete state=`0/3/4/5/6` 时保持完整 TCB；terminate 非法上下文时同样保持原对象。对于错误指针或损坏链，仍可能 fault，不能外推为恢复安全。

## 三个指令交错与关键纠正

两个任务自然完成/ready 终止路径在写 state=`1/2` 前把全局 `0xA1796780` 加一。`0xA03C1428` 即使将锁递归深度减到零，也因该计数非零而不清全局锁。锁状态保持 occupied、owner=CPU0、depth=0。逻辑 CPU1 的原始 TaskQuery 因此停在 `0xA03C13E4` 的 WFE 入口，不会得到成功快照。

此处 Unicorn 的 MPIDR 是只读 CPU0；测试仅在四处 MPIDR 读取指令用 observer=CPU1 的值替代。真正的锁判断、LDREX/STREX、全局计数、barrier 和等待分支均执行原始指令。不伪造 unlock，不把等待转换成超时。它是受控跨核指令顺序证据，并未运行真实 SMP 调度。

第三条路径不同：非 ready 的任务被 terminate 后，在 `0xA03C25E4` 已将 `+0x38` 清零，随后的原始临界退出释放锁；之后才执行 `+0xC8` 退出通知，然后调用 `0xA03C16E4` 调度再考虑。测试停在退出通知入口，允许逻辑 CPU1 执行真实 TaskQuery 得到 `0/state2`，再执行真实 delete 得到 `0` 并清 magic。恢复原终止控制器后，它仍执行退出通知返回后的原厂代码，并进入调度再考虑。此时另一控制器已删除对象。

这证明 generic `state2 + delete0` 缺少“终止控制器和 notifier 已返回”的合同；`+0x38 == 0` 也不能补足。它没有证明相机已经发生 use-after-free；样本保留 TCB 内存以观察后续顺序，没有在活代码下实际释放或制造损坏。单一所有者若自行同步调用 terminate 并等它正常返回，可以避免这个特定交错，但还需确保没有其他 stop/delete/reset 控制器和旧引用，不能从查询本身获得这些所有权证明。

## 自然完成路径继续追踪

额外执行了一种合法构造的当前任务自然完成移除：设置栈哨兵、ready list、自环任务和原始全局锁/计数，执行 `0xA03C1D5C`，继续经过 `0xA03C1C8C` 的原始上下文保存，包括 VFP 保存。只有硬件时钟读取 `0xA048EF98` 替换为返回零；不替换任务或调度函数。

观察到以下先后关系：保存 SP → `0xA03C1D08` 清 current-task 指针 → 更新上下文可调度标志 → 清全局计数/锁 → DSB/SEV → 进入 `0xA03C08F4` 下一任务选择入口。停止时 state=`1`、`+0x38=0`、current=0、next=0、全局锁释放。旧退出 notifier 已在进入这一移除函数前返回。

因此，在本轮执行的自然完成路径中，**外部查询获得 state=`1` 的锁快照时，不能跨越前述未完成 notifier 的阶段**。这为“自有有限任务正常 return、独占生命周期、检查 TaskQuery 成功且 state1，再独立 delete 并检查成功”的候选绑定提供了原始字节依据，比一个任务自己写的 pre-return marker 更强。

但目前只执行了一个 ready-list/scheduler 配置；跨核任务移交、其他 scheduler 分支、IRQ/FIQ 交错、task reset/restart、代码消费者与所有权 generation 未形成完整证明。没有把该候选直接绑定为 owned-retirement 的 `verify_stopped`，也没有声称能回收任意任务栈或 gateway 代码。若仅需要保持资源到重启，此处无需冒险缩短生命周期。

## 固件实际调用者

完整保留调用索引中有六个对 TaskQuery 的直接调用：

| 调用点 | 所属函数 | 原厂行为边界 |
|---|---|---|
| `0xA03CAD68` | RPC unregister `0xA03CAC1C` | 不检查查询失败；接受 state1/2 的删除路径；已另证会吞掉终止/删除错误并释放 |
| `0xA0407C70` | `AmpEditor_SubTaskGc` `0xA0407BF4` | 循环查询 state1，睡眠 `0x1E`；随后删除与 block release；错误路径仍需独立审计 |
| `0xA0436738` | `AmpDemuxer_RemoveImpl` `0xA0436574` | 检查查询返回，state1 通过；state3 使用 terminate，其他状态释放锁/睡眠后再查 |
| `0xA043CAE8` | `AmpMuxer_RemoveImpl` `0xA043CA4C` | 与 Demuxer 类似，在对象 mutex 下查询/终止 |
| `0xA044E808` | FIFO 诊断 `0xA044E734` | 取得当前任务名称用于诊断；不构成 join 屏障 |
| `0xA048DCD8` | `0xA048DCBC` | state3 后设置任务参数/核心排除和调度操作；不用于资源回收 |

此表为导出的直接调用范围，未声明全部间接调用。原厂部分代码对状态的使用不能自动证明其所有错误处理可安全复用。

## 复现与范围

```sh
.venv-reverse/bin/python scripts/audit_native_task_stop_proof.py \
  --output artifacts/verification/2026-11-11-native-task-stop-proof-review
```

[本轮最终回执](../artifacts/verification/2026-11-11-native-task-stop-proof-run03/audit.json) 包含每次调用、原始锁状态、三个交错、上下文保存轨迹、六处调用索引和导出函数哈希。其 SHA-256 为 `1bd819bd1f9879d9e78e88439b3bf07a2cc08ff669ea9a4f753008012bfca2d7`。[验证脚本](../scripts/audit_native_task_stop_proof.py) 严格匹配映像 SHA，导出同一函数所有 body ranges。

主线程审查锁保留与实际替代服务边界后，[独立复跑](../artifacts/verification/2026-11-11-native-task-stop-proof-parent-review/audit.json)再次通过 32 用例、3 交错和同一自然完成调度清理路径。没有把逻辑 CPU1 指令交错当成实体多核运行，也没有修改原始锁状态来促成查询成功。

结论是部分可用、尚未绑定：TaskQuery 是可信的原始状态快照；正常完成 state1 有已确认的锁保护和一条 scheduler 移除实证。它仍不能为通用 state1/2 或任意代码卸载提供完整 stopped proof，实际独立恢复、首次执行与发布机制也未解决。EIS 整体目标继续保持未完成。
