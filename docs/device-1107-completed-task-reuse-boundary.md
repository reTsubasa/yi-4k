# 1.10.7 自然完成尾部与同址复用边界

本轮沿固定固件的原始自然完成路径继续执行到 `0xA03C08F4`，检查旧 TCB、旧栈在解锁后的最后访问，并把旧存储从 Unicorn 地址空间撤掉后继续跑调度器。结果给出一个有限的正向边界：在这条实际执行到的自然完成路径中，旧栈最后一次读取和旧 TCB 最后一次写入都发生在全局锁清除之前；之后的 idle、四种上下文恢复以及受控 IRQ/FIQ 入口均不再访问旧存储。它仍不能把 `TaskQuery state=1` 变成通用的跨核、跨代生命周期证明。

## 输入和执行证据

- 固件：`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。
- RTOS 映像：`artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `0xA0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- 脚本：[audit_native_completed_task_reuse.py](../scripts/audit_native_completed_task_reuse.py)，SHA-256 `77c753c48c8976e64e1b273b63e93909904a70c615d37275d7eba4e5bd9109a7`。
- 最终回执：[run05/audit.json](../artifacts/verification/2026-11-11-native-completed-task-reuse-run05/audit.json)，SHA-256 `24a220cf1fe6bb4f1a76814a614b00fe91ac25eaa9fe8e9015078b871220c9fd`。
- 运行：

  ```sh
  .venv-reverse/bin/python scripts/audit_native_completed_task_reuse.py \\
    --output artifacts/verification/2026-11-11-native-completed-task-reuse-run05
  ```

共 8 个用例通过，全程 `device_access=false`。执行使用 Unicorn，反汇编使用 Capstone；固定的 TaskStop 依赖脚本 SHA 和整幅映像 SHA 都在回执中复核。没有写入相机、启动真实固件或部署。

## 解锁前后的旧存储访问

自然完成入口 `0xA03C0A74` 返回后，原始退出通知进入 `0xA03C1D5C`，再经过上下文保存 `0xA03C1C8C`。记录到的最后访问是：

| 资源 | 最后访问 | 含义 |
|---|---|---|
| 旧栈 `0x70018000..0x7001FFFF` | `0xA03C1CE0`，read | 保存上下文尾部的 `pop {r0,r3,ip}` |
| 旧 TCB `0x70001000` 页 | `0xA03C1D18`，write | 写入退出链/状态相关字段 |
| SMP 全局锁 | `0xA03C1D3C`，write | 清除实际锁字；随后 `0xA03C1D40` DSB、`0xA03C1D44` SEV |

在 `0xA03C1D3C` 之前暂停时，逻辑 CPU1 执行原始 TaskQuery 会停在 WFE 入口，不能得到成功快照。仅在顺序模型中执行完锁清除、尚未执行 DSB/SEV 时，CPU1 的原始 Query 返回 `state=1`，随后原始 Delete 返回 `0`。这一步不模拟物理 cache/coherence 可见性。

成功 Query/Delete 后，脚本撤掉旧 TCB 整页和旧栈的 8 页映射。Unicorn 若有任何旧引用会立即失败；它随后可走到原始 idle `WFI`，此时 SP 数值仍在旧栈范围，但没有发生旧栈读写。撤映射比填充 poison 更严格地检查了尾部的真实内存引用。

## 调度器和异常边界

撤掉旧存储后，原始 `0xA03C08F4` 在以下四种 next-context 形态都完成了恢复并到达哨兵地址：普通 solicited、带 VFP 的 solicited、普通 interrupt 保存帧、带 VFP 的 interrupt 保存帧。原始代码在 `0xA03C0988` 才从旧 SP 切换到 next SP；next TCB、next 栈和保存帧均位于独立映射区域。

另有两个 idle 边界用例。harness 手工构造 ARM IRQ/FIQ 的 banked CPSR、SPSR、LR 和独立异常栈，然后执行原始入口、记账、空 dispatcher 返回和原始尾部。IRQ/FIQ 的物理投递和真实 ISR 图没有运行；在这个声明的模型内，两条路径均未访问已撤掉的旧 TCB/旧栈，并可恢复到 SVC 调度入口。

## 同址 TaskCreate 复用暴露的代际问题

最后一个用例暂停旧 CPU0 尾部，先用原始 TaskQuery/Delete 删除旧代，再用原始 `TaskCreate` wrapper `0xA03BC2BC`、检查层 `0xA03C4240`、初始化体 `0xA03BFC90` 和 Thumb memset `0xA04F8DEC` 在**同一 TCB 地址**创建新代任务（`auto_start=0`）。新任务处于 `state=3` 时，旧 Delete receipt 被原始状态检查拒绝 `0x11`。

随后 harness 只发布一个明确标注的 ready/current/next CPU1 调度 fixture；新任务的初始化、保存帧恢复、Query 和 Delete 均执行原始字节，entry 和 exit notifier 使用合成的 BX LR 回调让路径自然返回。新代进入 `state=1` 后，旧代留下的“指针 + state1 receipt”无法区分代际，旧 Delete 再次返回 `0`，删除了**新代**任务。该结果是 API generation/ownership ABA 反例：独占生命周期或 generation receipt 仍是必要合同。它不表示自然完成调度尾部自身发生 UAF，也不表示这个同址复用 fixture 是允许的运行时协议。

回执额外导出了 scheduler/context-save、TaskCreate 检查和初始化体的原始 ARM 字节，以及 `0xA04F8DEC` 的 Thumb 字节；每个导出均有 SHA-256。CPU1 的 MPIDR 只在精确的原始 MRC 指令处做逻辑值替代，锁、Query、Delete、Create、上下文保存/恢复仍执行固件字节。

## 结论和未覆盖范围

这组证据支持一个受限结论：若同一任务确实走完这条自然完成路径，并且外部拥有独占生命周期，解锁后可先取得 `state=1` 快照、成功 Delete，再回收该次执行所用旧栈/TCB；本轮的撤映射和四种恢复尾部没有发现旧存储访问。它不支持通用 `state∈{1,2}` stopped proof，也不覆盖完整 SMP/cache/coherence、其他 scheduler 分支、reset/rebind、分配器所有权、未执行的 ISR/callback/代码消费者或 stale external pointer。永久 gateway/code/context 的存活仍需单独管理。

因此本证据不绑定 frozen owned-retirement helper，不改变 P10 或独立 recovery 的未完成状态，也不构成部署授权。
