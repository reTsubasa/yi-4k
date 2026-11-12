# 1.10.7 virtual FIFO 旁路消费者候选（离线静态证据）

现有固件已经包含一条可复用的旁路消费者路径：UVCd 的 `A0233508`（`uvcd_fifo_start`）为主视频编码流创建 virtual FIFO。它调用 `AmpFifo_Create`（`A04509DC`）时使用以下已观察参数：

| 配置项 | 静态观察 |
|---|---|
| `stream_id` | `DAT_A13C82D8`（VideoEncPri） |
| `capacity` | `0x2000` 个 descriptor |
| `virtual` | `1` |
| callback | `DAT_A0233434` |
| 输出 handle | `DAT_A142FB60` |

这与原生 MP4 的 virtual 创建调用共享前四个配置字：`stream_id`（`+0x00`）、容量（`+0x04`）、virtual 标志（`+0x08`）和必需 callback（`+0x0c`）。后续[生命周期审计](prerecord-fifo-lifecycle.md) 已恢复完整 0x58 配置布局，并执行 UVCd 构造前缀，确认其余字段保持原厂默认零值；这只验证该零历史 virtual 模式，不代表历史回填模式也可直接复用。

UVCd 的回调 `A0233434` 在 `A0233468..A0233504` 调用 `AmpFifo_PeekEntry(A0451960, index=0)`。在完成 descriptor/payload 处理后，它调用 `AmpFifo_RemoveEntry(A0451C94, count=1)` 推进自己的 virtual 读取游标；遇到不匹配或无效条目也会走移除路径。停止函数 `A02335D0` 在 handle 非空时调用 `AmpFifo_Delete(A04514E4)`，然后清空 `DAT_A142FB60`。

## 回调事件和停止边界

这条 UVCd 路径还给出了一个可验证的通知契约：`A0233434` 比较 callback 的事件参数 `r1`，只在 `0x4000002`（普通数据通知）分支进入 `PeekEntry(index=0)`；`0x4000001` 直接返回，未知事件也不推进游标。后续原码执行已确认：`A044E8D4` 的 base→virtual 分支在 descriptor 长度为 `0x00FFFFFF` 或 type 为 `0xFF` 时发送 **`0x4000001` 结束/特殊结束通知**，不能将它解释为空队列。真正的 Peek 空结果为 `-8`；返回 0 也必须检查输出指针。通知不转移 payload 所有权，也不提供缓存完成屏障。

`A02335D0` 的静态实现是“检查 handle 非空 → `A04514E4` 删除 → 清零全局 handle”，函数体没有等待 UVCd 消费任务退出的同步调用。新 owner 必须先阻止该 handle 的新 callback 进入、等待已有 callback 和所有消费者访问退出，并验证 handle/registry 仍有效，再调用 Delete。后续原码交错执行证明：`SyncWritten` 释放 virtual 锁后暂停，另一上下文成功 Delete，再恢复仍可调用旧 callback。因此 **`A04514E4` 不是 quiescence barrier**；原生 MP4 的 mux wait 也不自动覆盖新旁路任务。

这条路径证明了“同一编码 stream 的独立 virtual descriptor queue + 独立读取游标 + 自己删除”的固件使用方式，适合作为预录旁路消费者的静态 ABI 候选。它没有证明新消费者可以直接复用 UVCd 的 callback、任务、网络缓冲或全局状态。

`AmpFifo_SyncWritten` 只同步 0x20 字节 descriptor，payload 地址仍指向编码器共享 ring。预录消费者必须在推进自身 `RemoveEntry` 前取得稳定读取保障、复制并保存 payload，停止时满足上述 callback/owner 静止条件；不能释放或改写编码器 ring，也不能推进 base FIFO。`RemoveEntry` 非零可能发生在游标已推进之后，不能直接重试同一帧。基础 FIFO 回收受各 virtual consumer 最小读取游标约束，旁路消费者停滞会反向限制生产者回收。

验证命令：

```bash
.venv-reverse/bin/python scripts/analyze_prerecord_output_contract.py
```

该脚本校验固件镜像 SHA-256、UVCd 创建参数、callback 事件分支、peek/remove/delete 调用地址和现有 MP4/FIFO 断言。全部结果都是本地 ARM 字节与 Ghidra 导出的静态证据；没有连接、执行或写入相机。

