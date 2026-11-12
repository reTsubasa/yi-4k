# 1.10.7 RPC 注销成功码不是停止回执

原厂 RPC 注销器 `0xA03CAC1C(program, version)` 即使遇到任务终止、删除失败，仍继续摘链、释放复制的 procedure 表和服务对象，最后返回 `0`。因此它的返回码不能直接用作 EIS 扩展安全退出、回收常驻代码或栈的依据。

本轮执行固定固件映像中的原始 ARM 指令，以显式服务模型注入依赖调用结果；没有访问相机、写入设备或修改固件。它补充 [RPC ABI 静态合同](device-1107-rpc-extension-contract.md) 的注销部分，以及 [普通注册器恢复反例](device-1107-registration-recovery-counterexamples.md) 尚未覆盖的 RPC 专用任务退出路径。

## 原始控制流

| 位置 | 原始行为 | 对退出回执的影响 |
|---|---|---|
| `0xA03CAC8C` | 设置事件位 `4` | 不检查返回码 |
| `0xA03CACB4` | 等待事件位 `8`，等待参数 `0xFFFFFFFF` | 不检查返回码或输出事件位；真实无限等待的调度过程未模拟 |
| `0xA03CAD68` | 查询任务状态 | 不检查查询返回码；输出状态栈槽此前置为 `0` |
| `0xA03CAD74` | 状态 `1` 或 `2` 直接进入 delete | 其余状态进入 terminate |
| `0xA03CAD90` | terminate | 非零结果仅记录日志，仍进入 delete |
| `0xA03CADA0` | delete | 非零结果仅记录日志，仍进入摘链和释放 |
| `0xA03CACC4` | 修改双向服务链 | 不以 terminate/delete 成功作为条件 |
| `0xA03CACE0` | 移除端口 | 本轮替换为显式服务模型 |
| `0xA03CACE8` / `0xA03CACF0` | 分别释放 `service+0x34C` 指向的表和服务对象 | 即使此前 terminate/delete 失败仍调用 |
| `0xA03CACF4` | 返回 `0` | 吞掉前述错误 |

原厂 worker `0xA03CAE84` 的退出分支在 `0xA03CB0A8` 释放自己的临时消息对象，随后设置事件位 `8`，再返回。仅看到位 `8` 不能跳过后续任务状态、对象删除和消费者停止确认；本轮没有运行 worker 或模拟两个线程交错。

## 八个离线用例

| 用例 | 注入条件 | 原始注销器结果 |
|---|---|---|
| completed | 状态 `1`，delete 成功 | 不调用 terminate；摘链、两次 free、返回 `0` |
| terminated | 状态 `2`，delete 成功 | 同上 |
| running | 状态 `3`，terminate/delete 成功 | terminate → delete → 摘链 → 两次 free；返回 `0` |
| 两次停止操作失败 | 状态 `3`，terminate/delete 均返回非零 | 记录错误后继续摘链、两次 free，返回 `0` |
| delete 失败 | 状态 `1`，delete 非零 | 继续摘链、两次 free，返回 `0` |
| 事件等待失败 | event-get 非零且不写出事件位；terminate/delete 非零 | 继续查询任务、停止尝试、摘链、两次 free，返回 `0` |
| 设置结束事件失败 | event-set 非零，状态 `1` | 继续等待及删除路径，返回 `0` |
| 查询状态失败 | task-info 非零且不写状态；terminate/delete 非零 | 使用初始 `0` 状态进入 terminate，仍释放并返回 `0` |

所有依赖错误以抽象非零值 `1` 注入，不赋予其某个具体 ThreadX 错误名称。每个用例检查原始函数正常返回、`R4–R11` 和 SP 保持、双向链恢复为空链、释放顺序严格为表后对象。

`worker_alive_model` 只表示服务模型中的状态：terminate 失败不改变存活标志，delete 失败不改变已删除标志。由此得到的是“原始调用方在未取得模型中的停止成功时仍释放”的控制流反例，不是实际运行调度器后观察到的悬空访问，也没有证明真机必然发生这些错误。

## 对 EIS 退出设计的约束

不能采用“调用原厂 unregister，见 `0` 就释放扩展”作为回收方案。需要独立保留停止请求、停止确认、任务实际结束与删除结果，确认所有消费者不再持有旧 handler/table，再释放对象、栈和代码；任一失败必须保留仍可能被引用的资源及可观察状态。原厂函数自身会释放对象，因此仅在它外面检查最终返回码不能补齐这个合同。

本轮收紧了退出路径可复用性的判断，没有解决首次执行入口、代码发布、相机 RAM 所有权或真机恢复。EIS 整体目标仍未完成。

## 复现

```sh
.venv-reverse/bin/python scripts/audit_native_rpc_teardown.py \
  --output artifacts/verification/2026-11-11-native-rpc-teardown-run02
```

输入映像 SHA-256 固定为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。证据：

- [脚本](../scripts/audit_native_rpc_teardown.py)
- [8 个用例及逐调用回执](../artifacts/verification/2026-11-11-native-rpc-teardown-run01/audit.json)
- [本轮从映像导出的原始 ARM](../artifacts/verification/2026-11-11-native-rpc-teardown-run01/unregister.asm)

主线程独立复跑：`artifacts/verification/2026-11-11-native-rpc-teardown-independent-run02/audit.json`，8 场景通过、device_access=false。
