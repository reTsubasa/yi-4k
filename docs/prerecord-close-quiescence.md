# 预录 FIFO 关闭路径与 callback 静止边界

2026-11-11。本轮沿原厂普通 MP4、EventRecord 和 UVCd virtual FIFO 的关闭路径，核对 mux wait、handler unregister、FIFO Delete 三者的实际顺序，并复用已有原始指令交错结果确认 Delete 后仍可能执行在途 callback。分析只读取固定固件的 Ghidra 导出和既有离线审计 JSON，没有连接相机、执行 RTOS 或写入设备。

机器结果见 [audit.json](../artifacts/device/2026-11-11-prerecord-close-quiescence/audit.json)，复现命令：

```sh
python3 scripts/audit_prerecord_close_quiescence.py
```

12 项断言全部通过。

## 三条关闭路径

| 路径 | 已恢复顺序 | 本轮边界 |
|---|---|---|
| 普通 MP4 `A01F6088` | `A043FEC0(pipe,-1)` 等待 mux → `A01F6044` 注销 handler → `A043F9CC` Remove → `A043F82C` Delete pipe → 释放对象 → 多次 `A04514E4` 删除 virtual FIFO | mux WaitComplete 只检查 pipe 状态；未看到 callback 在途计数或 payload lease 屏障 |
| EventRecord `A01F8F08` | `A043FEC0(pipe,-1)` → `A01F8EBC` 注销 EventRecord handler → Remove/Delete pipe → 删除 virtual FIFO | 与普通 MP4 相同，没有新增 callback 静止屏障 |
| UVCd `A02335D0` | handle 非空 → `A04514E4` 删除 → 清空全局 handle | 没有等待 consumer task、callback 或 payload 访问退出 |

`A01F0F2C` 的注销实现只在 registry 中匹配 handler 后把 active 字节写为 0；已审计函数体没有 WaitComplete、callback counter、FIFO Delete 或其他 quiescence 调用。它可以阻止未来某些注册分派，但不证明已经进入的 callback 被取消或等待返回。

`A04514E4` 会获取 FIFO 内部锁、检查 registry/handle、释放 descriptor pool 并清理 registry。内部锁保护 Delete 自身的数据结构，不覆盖已经释放锁后仍在执行的 callback；函数体也没有调用 mux handler 注销器或等待外部 consumer。

## 交错证据

既有 `prerecord-fifo-lifecycle-audit.json` 的 `delete_does_not_barrier_already_released_sync_callback` 用例将 `SyncWritten` 在释放 virtual 锁后暂停，在另一上下文成功 Delete，再恢复旧上下文。结果同时记录：

- `explicit_sequential_interleaving = true`
- `callback_happened_after_successful_delete = true`

这不是 RTOS 调度器或相机运行实验，但它证明原始调用顺序允许“Delete 返回成功后，之前已进入的 callback 仍被调用”。因此不能把“注销 handler + Delete 成功”当作新预录消费者的停止完成条件。

## 对最小预录后端的约束

后端必须在 `QUIESCING` 阶段自行建立以下顺序：

1. 关闭该 handle 的新 callback 准入；
2. 记录并等待所有在途 callback 退出；
3. 保持 descriptor/payload 读 lease，直到复制、持久化和 Remove 完成；
4. 重新核对 handle、registry、base FIFO 和 owner generation；
5. 只有 callback 计数归零且唯一 owner 仍有效时才调用 Delete；
6. Delete 失败保留 handle 和 manifest，禁止猜测性重试或释放 payload。

这些步骤在当前固件中没有发现可直接复用的独立 API。停止原厂编码器不能作为默认解决方案，因为一分钟预录要求编码 producer 持续运行；同时，继续消费也不能绕过 callback 静止和 payload 所有权检查。

## 仍需真机只读证据

需要在可停止、可回滚的真机窗口记录 callback 进入/退出计数、Delete 前后的 registry、实际 FIFO cursor、payload 地址有效期，以及 Delete 返回后是否有旧 callback 访问。只有这些证据闭合，才可以把候选状态机的 `QUIESCING → CLOSED` 转移绑定到相机后端；本轮没有把静态交错结果升级为真机完成证据。

