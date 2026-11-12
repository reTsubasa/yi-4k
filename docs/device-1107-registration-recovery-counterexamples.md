# 1.10.7 注册入口与退出恢复反例

2026-11-11。本轮执行原始 `t_register(A029E098)` 和 dispatcher `A029E1A4`，把[既有注册器静态边界](device-1107-shell-memory-and-registration.md)变成五个可复现反例。结果排除了两个看似方便的退出方案：**同名重注册不能替换旧 handler；持有注册锁也不能使 dispatcher 静止。** 这不是新的真机入口，没有连接或写入相机。

```sh
.venv-reverse/bin/python scripts/audit_native_registration_recovery.py \
  --output artifacts/verification/2026-11-11-native-registration-recovery-run01
```

[审计 JSON](../artifacts/verification/2026-11-11-native-registration-recovery-run01/audit.json)记录五个场景的原码返回、服务参数、节点地址和调用次序；[反汇编](../artifacts/verification/2026-11-11-native-registration-recovery-run01/registry-dispatch.asm)固定原始注册/分发代码。固定 CPU SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

| 场景 | 原始 ARM 执行结果 | 对实现的影响 |
| --- | --- | --- |
| 两次分配均成功 | 返回 0，唯一 take/give 配对，追加一个节点 | 正常注册合同成立于模型边界内 |
| 第一次 12-byte 节点分配失败 | 返回 `FFFFFFFF`，take 后未 give | 返回失败不能被当作“所有注册资源已恢复” |
| 第二次名字分配失败 | 调用一次节点 free，返回 `FFFFFFFF`，仍未 give | 释放节点不代表释放注册锁 |
| 先后用相同 `probe` 名字注册两个不同 handler | 两次都成功，第二节点追加到链尾；实际 dispatcher 调到第一个 handler | 重新注册原厂/空 handler 不是替换或撤销机制，旧代码仍保持可达 |
| 注册锁由 owner 1 持有，owner 2 调实际 dispatcher | dispatcher 不调用任何 mutex 服务，仍尾调用第一个 handler并返回 | 持锁不能充当卸载时的 admission gate 或 quiescence 证明 |

分配失败后另一个 owner 再注册，实际参数再次请求同一个 mutex，timeout 为 `FFFFFFFF`。夹具在该服务入口停止，不伪造超时或声称已经运行真实 ThreadX 死锁；它只证明错误返回前没有 Give，下一次不同 owner 会请求无界等待。当前服务模型是显式 owner/count 的递归锁，不把模型调度当作硬件观测。

## 原码与模型的边界

注册、追加链表、dispatcher 的遍历和尾调用执行固定原始 ARM 字节；`strlen/strcmp/memcpy`、分配/释放、锁、handler 和打印是声明的替身。每条正常返回核对 R4–R11 与 SP。夹具不执行被替身覆盖的 OS 函数、不模拟 SMP、不验证 I-cache，也不实现注册器或 dispatcher 的修补。

本轮没有把已知分配失败静态缺陷重新命名为新发现；新增的是完整原函数的可复现失败执行，以及同名追加和锁不能静止调用者的具体反例。

## 仍需实现的退出合同

P1 首次入口仍缺外部可达的受控 entry；P5 指令发布仍缺；P10 退出不能靠“handler 返回”“同名覆盖”或“拿住注册锁”关闭。未来实现必须有独立 admission gate、调用在途计数、真实指针撤销和所有消费者静止的回执，或让不可撤销的 handler/节点/名字在整个运行期保持驻留。即便驻留，也不能替代错误状态、冷复位和独立恢复验证。

这份反例不授权修改注册链，也不提供设备写入器。共享 README、目标矩阵和 Android 均未改动。

主线程独立复跑：`artifacts/verification/2026-11-11-native-registration-recovery-independent-run02/audit.json`，相同固定脚本摘要，5 场景通过，`device_access=false`。
