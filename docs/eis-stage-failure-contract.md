# EIS 生成、准备与读取三阶段的错误传播

本轮发现一个会改变后续记录器和替换验收设计的边界：**原厂 EIS 协调器检查生成返回值，但不检查后续 SetWarp 返回值；零分支还不检查 GetWarp 返回值。`A170AFB8=1` 或生成成功，因此都不能独立证明本次生成的表已完成准备。**

这是固定 1.10.7 CPU 原始指令在合成 RAM 中的有界执行结果，不是相机上发生这些故障的证据，也不是对原厂正常录像稳定性的评价。本轮没有连接相机、读取真实私有 RAM、安装 wrapper、修改 firmware 或执行 DSP。

脚本：[eis_stage_failure_contract.py](../scripts/eis_stage_failure_contract.py)。证据：[audit.json](../artifacts/device/2026-11-11-eis-stage-failure-contract/audit.json)，另有五份原始反汇编窗口。固定 CPU SHA-256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

主线程[独立复跑](../artifacts/verification/2026-11-11-eis-stage-failure-independent-run01/audit.json)的全部 JSON 与上述证据相同，脚本哈希与当前冻结源码一致。

```sh
.venv-reverse/bin/python scripts/eis_stage_failure_contract.py
```

脚本核对 22 条固定指令，执行 36 个场景：`A17045DA` 的零/非零两条尾路径 × 生成返回 `0/1/FFFFFFFF` × 无故障/SetWarp mutex lookup 失败/GetWarp mutex lookup 失败 × descriptor enable `0/1`。生成失败时后两种故障不触发，作为生成关卡的负对照。

## 原厂分支的准确含义

| 调用点 | 原始指令行为 | 本轮证明的边界 |
| --- | --- | --- |
| `A0394740`、`A0394960` → `A02DA164` | 返回后 `cmp r3,#0`，非零跳到 `A0394B98` | 生成非零确实跳过 SetWarp/Getter 及本段候选状态复制 |
| `A0394760`、`A0394980` → `A02DA514` → `A0312460` | 返回后直接重新装载临时寄存器，没有比较 `r0` | SetWarp 失败不能沿这条调用链自动阻止后续代码 |
| `A039499C` → `A0312F74` | 返回后直接从 `A17045EC` 取字段，没有比较 `r0` | Getter 错误不阻止本段候选状态复制 |
| `A0394A98..A0394AB0` | 从 `A17045EC` 取 enable；非零写 `A170AFB8=1` | 该字节只表明所读结果的 enable，不能证明它由本次 Set/Get 成功产生 |

`A17045DA!=0` 分支的 Getter 及详情日志受 `A0757B2E` 门控。本轮保持该调试字为零，只执行 SetWarp，未把它扩大成两分支都会复制候选状态。`A17045DA==0` 分支必然在生成成功后调用 Getter 并复制候选字段，本轮执行了这些原始指令。

## 两个可达的失败后继续场景

SetWarp 和 GetWarp 均执行原始 `A0312460` / `A0312F74`。只在它们调用 context-mutex lookup `A0308880` 时，按场景让该依赖返回 `FFFFFFFF`；对应原函数错误分支和返回指令仍原样执行。脚本在返回协调器的第一条指令处保存真实 `r0`，证明观察到的失败码来自完整原函数返回，而不是直接把 SetWarp/Getter 整个替换掉。

| 生成 | SetWarp | GetWarp | 零分支实际结果 |
| --- | --- | --- | --- |
| 0 | 0 | 0 | 两平面复制/clean 参数正确；读出新 bank 的 X/Y 地址；enable 非零时置 ready |
| 0 | `FFFFFFFF`，lookup 失败 | 0 | 没有复制新 bank；Getter 仍读旧 descriptor 地址；候选状态随后保存旧地址，enable 非零时仍置 ready |
| 0 | 0 | `FFFFFFFF`，lookup 失败 | SetWarp 已准备新 bank；Getter 输出全局区保留旧内容，协调器将旧输出复制到候选状态，enable 非零时仍置 ready |
| 1 或 `FFFFFFFF` | 未调用 | 未调用 | 原生成错误关卡生效；候选区与 ready 保持不变 |

所有“旧”地址和 enable 都是脚本预先放置的合成内容。它们用于证明错误路径没有清除或替换相应对象，不表示从历史设备日志捕获了陈旧表。成功对照另核对了源 scratch 与新 X/Y 两平面的全部 `0x3000` 字节一致；cache clean 仅记录调用和参数，不能证明真实硬件可见性。

## 对下一步实现的约束

[原厂 producer 合同](eis-stock-producer-contract.md) 继续成立：保留原 scratch、table bank、copy/clean 和发布调用顺序可以避免另建外部表寿命。但不能把“原生成器返回零”和后续“ready 字节为一”合并成同一次调用成功的证据。

下一份透明记录器必须为同一 invocation 分别保留：

1. Calc 返回值、mode/context 和 scratch 结果身份。
2. SetWarp 返回值、实际 bank/X/Y、copy/clean 是否走到及其顺序。
3. GetWarp 返回值、读取结果身份与之前的 descriptor 是否区分。
4. 候选状态复制、ready 字节及后续发布状态；这些字段分别记录，不能自行推断成功。

任何离线单变量实验若只检查生成零返回或 ready，验收应拒绝。真实替换前仍须先有安全原生入口、返回/卸载、恢复、同 invocation 关联和实际时限证据。**本轮不提出给原厂协调器加错误分支的真机补丁**：改变其控制流可能影响原状态机，当前尚无恢复与行为证据可授权这样的修改。

## 覆盖限制

本轮从上游 mode/几何计算之后的两个明确尾路径进入，不执行完整 EIS 主任务。生成函数本轮为选定返回码替身；原生成算法的独立范围证据仍见[生成范围合同](eis-generator-scope-and-frame-contract.md)。context/mutex lookup 用合成地址，锁仅记录，memcpy 逻辑复制，地址转换为恒等映射，cache clean 与日志不模拟硬件，`A0308B8C` 固定为零。

没有执行完整状态发布、ORC、DMA/MMIO、真实 SMP 交错或编码帧关联。注入依赖失败说明原始分支可达，不能推导真机故障率、现有日志中的某帧已经失败或原厂表已经被错误复用。`custom_eis_replacement_ready` 继续为 `false`。
