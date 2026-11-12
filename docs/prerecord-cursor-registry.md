# FIFO 暂停门控、游标与 registry 的独立生命周期

本轮继续检查已确认的 virtual FIFO ABI，新增 **9 组原始 ARM 指令执行检查、6 份固定 SHA-256 的伪代码字段校验**。结果见 [audit JSON](../artifacts/device/2026-11-11-prerecord-cursor-registry/audit.json)，复现脚本为 [audit_prerecord_cursor_registry.py](../scripts/audit_prerecord_cursor_registry.py)。所有 RAM、锁、allocator、消息和 callback 环境均为明确夹具；没有连接或写入相机。

## 两个字段不是 lease/callback 计数

`handler+0xc4` 控制 virtual descriptor 同步。`SyncWritten(A044E8D4)` 仅在它为 0 时向该 virtual ring 复制 descriptor；`Resume(A0452E9C)` 要求它非零，并在同步游标后清零。`Create(A04509DC)` 默认置零，历史 selector 4 会置 1。这些直接用途支持将它细化为**暂停/恢复门控**，不能当成在途 callback 数量。

原始指令检查构造 `+0xc4=1` 后调用 `SyncWritten`，virtual write cursor 保持 9、descriptor 队列逐字节保持、没有 callback。随后独立执行 `Resume(selector=0)`，virtual read/write 都重置到 base 当前 write 9，`+0xc4` 清零、registry 保持。这个默认 Resume 会丢弃待消费范围的游标身份，不能作为保存一分钟历史的无损恢复入口。没有执行 selector 1/2/3 的历史语义，也没有证明并发 Resume 安全。

`handler+0xf4` 由 `AmpFifoPrint` 辅助函数 `A044E734` 检查：它和 trace mask 一起决定是否向 trace ring 写一条 0x30 字节诊断记录。该函数递增的是全局 trace index `DAT_a19c6340`。因此 `+0xf4` 也不是 payload lease 或 callback 引用计数。至今在声明的函数范围内未找到真实 payload lease 或 callback 在途计数；这不是整个固件不存在该机制的证明。

## GetInfo 的可用量受最慢消费者限制

`GetInfo(A04534AC)` 输出 capacity、pending descriptor 数和可用量。base handler 会遍历 stream ID 相同的 virtual handler，比较 `virtual.read + virtual.capacity - virtual.write`，取最小值；对 virtual handle 调用 GetInfo 还会递归查询 base，再取最小值。

| 原始指令夹具 | 输出 `[capacity,pending,available]` |
| --- | --- |
| base capacity 8、read 5、write 9，无 virtual slot | `[8,4,4]` |
| 同一 base，virtual read 5、write 12 | `[8,4,1]` |
| virtual 自身 pending 4、base 可用量 1 | `[8,4,1]` |

另构造“virtual inactive flag 为 0、旧 stream ID 仍匹配”的不一致状态，base GetInfo 仍得到 `[8,4,1]`：这条遍历按 stream 匹配，不检查 virtual in-use flag。它只说明 API 的前提边界，未证明真实相机正常生命周期会出现这个组合。GetInfo 的数字也不是 payload 可安全读取的 byte 数或剩余时间，不能当作一分钟缓存容量。

## cursor、descriptor 和 registry 不是同一个状态

`EraseAll(A0452B68)` 对 base handle 调用时，会清零本 base 的 read/write cursor 和 descriptor ring，并清同一 stream 下匹配 virtual 的 cursor/descriptor。夹具执行后两套 cursor 都为 0，两套 descriptor ring 都为零，但 virtual 的 in-use flag、registry 槽仍保留，也没有 callback。**重置游标不是注销 handle，更不是 callback 或 payload 访问静止屏障。** 本轮没有建议在设备上调用 EraseAll。

两组不一致 registry 夹具进一步说明调用者必须核验身份：

- 保留 virtual in-use flag，却把 registry 槽设零，`Peek` 仍返回队首 descriptor 指针。Peek 自身不以 registry 身份为前提检查。
- 把该 handle 的 registry 槽改为另一个非零指针，`Delete` 仍清当前 handler 并把该槽置零。原函数检查的是“槽非零”，没有在已审计路径中比较“槽指针等于当前 handler”，也没有 generation token。

这两项是合成的不一致状态，不是发现了设备上的内存破坏。它们明确了真实 backend 的边界：有效 registry 槽值、handler self pointer、in-use、stream/base 绑定必须由 owner 在外部核验；不能用 Delete 返回 0、Peek 成功或 registry 非零替代身份和 lease 合同。

## 与普通 rollover 入口的关系

本轮同时核对既有所有权审计的固定结果：普通 event 3 callback 范围为 `[A01F569C,A01F5FF0)`，直接调用中不含 Create/Delete/Remove/EraseAll、完整关闭 `A01F6088` 或重新创建 virtual FIFO `A01F6340`；完整关闭函数有 6 处 Delete，作为正向对照。

因此实际候选仍是 mux 自身 `master limit → OnPipeLimit → event 3 → format/file close/open` 的路径。它没有因此获得额外 lease 或 registry 屏障；不能从任意线程裸调 callback，也不能用 EraseAll/Resume 替代保留帧并切文件。此前的直接调用图不能证明所有间接/外部副作用，真实下一帧身份、payload 生命周期、首帧参数集、A/V 连续性仍未知。

验证：

```sh
.venv-reverse/bin/python scripts/audit_prerecord_cursor_registry.py
.venv-reverse/bin/python -m py_compile scripts/audit_prerecord_cursor_registry.py
python3 -m json.tool artifacts/device/2026-11-11-prerecord-cursor-registry/audit.json >/dev/null
```
