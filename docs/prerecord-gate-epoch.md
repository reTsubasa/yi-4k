# 视频就绪事件重复开门，不重建音频 PTS 零点

2026-11-11，1.10.7 固定 RTOS 镜像离线审计。新增结论：**视频 event 0x13 的已匹配成功路径只重复写音频 source IoNode 的开关字节，不重置音频编码帧计数，也不重新选择首 PCM block。它不能作为两轨共同归零的握手。**

本轮补齐 [跨文件起点审计](prerecord-cross-file-epoch.md) 中“gate 重复打开是否重启 producer”的具体缺口。没有访问设备、执行 RTOS、调用相机接口、写 SD、生成目标脚本或修改共享 SDK。

## 原始调用链和字段身份

此次完整执行以下原厂函数，而非只验证设置 flag 的一条指令：

```text
event callback A046E6FC
  └─ audio pipeline lookup A045FD38
       ├─ instance locks A045D570
       ├─ source list opener A045D7B8
       │    └─ BufferOpenSrcIoNode A029351C
       └─ instance unlocks A045D60C
```

有一个需要精确区分的字段关系：`A046E6FC` 读取 `event+4`，将它与 video context 的状态字节比较，并要求状态字节为 0。它随后从该 video mutex context 的 `-4` 取出已保存的 pipeline ID，传入 `A045FD38`。后者才把这个 ID 与 audio instance 的 `+0x14` 比较。**event+4 本身不是此链中的 pipeline ID。** 旧跨文件报告中的对应调用图与说明已按原始指令直接修正，旧审计 JSON 及其来源 hash 保持原样。

匹配实例后，`A045D7B8` 读取 source 数量及 12-byte 节点数组，每项只取 `+8` 的 buffer node。`A029351C` 再取该 buffer node 的 `+0x40`，得到 source IoNode；成功获取 mutex 后，在 `A0293560` 执行：

```text
source_IoNode[4] = 1;  // 单字节
```

然后释放 mutex，返回。已匹配、debug 关闭、mutex 成功的这条链没有进入 `EncTaskSetUp(A0290B60)`、编码事件 PTS 生成器 `A029016C` 或 tick getter `A048E3F8`。它也不读取 source 数组项 `+4` 所指的 encoder 对象，因而不会沿 encoder `+0x188` 去取帧计数状态。没有新的共同时间字段经这条路径传入音频 producer。

## 完整函数执行的新验证

[脚本](../scripts/audit_prerecord_gate_epoch.py) 固定镜像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，在 Unicorn 合成 RAM 中执行原始 ARM 函数，仅对 RTOS mutex take/give 提供成功返回桩，不模拟其内部副作用。核对 8 条关键指令和 4 个原始 literal 指针，记录事件内存读取、所有非栈 store、实际进入的函数与 mutex 参数。

8 组用例全部通过：

| 用例 | 新结果 |
|---|---|
| 原 gate=0，编码帧计数已为 12345 | 只把 gate 写为 1；编码状态保持 |
| 原 gate=1，连续执行 3 次相同事件 | 每次仍只写同一 gate=1；没有重建零点 |
| 两个 source，原 gate 分别为 0、2 | 只对各 source 的 `+4` 写 1 |
| source 数量=0 | 没有非栈 store |
| event+4=1 | 不进入音频开门分支 |
| audio 全局 guard=0 | 没有非栈 store |
| audio pipeline 不匹配 | 没有非栈 store |
| 编码帧计数改为 UINT32_MAX，event+8/+C 改为另一组值 | 开门行为相同；编码状态保持 |

每次原始 callback 遍历三个 video context，只读取事件的 `+4`，三次均为 4-byte load，没有读取 `event+8/+0xC`。所有非栈 store 精确等于已匹配 source 的单字节 gate 写入；source 其他字节及 encoder state 的 0x80-byte canary 全部保持。这里只证明已构造成功路径的直接访存和调用关系，不宣称真实 mutex 没有内部写入，也不覆盖失败日志、错误返回或并发路径。

结果：[audit.json](../artifacts/device/2026-11-11-prerecord-gate-epoch/audit.json)、[原始 ASM](../artifacts/device/2026-11-11-prerecord-gate-epoch/audit.asm)。六个函数的伪代码和固定指令窗口 SHA-256 均记录在 JSON。没有新 REA Evidence ID。

## 对首帧基准的影响

此前已经证明 `AudioEnc_StartEncodeImpl(A045DA98)` 先调用 setup 清零音频局部编码帧计数，然后启动编码并自行调用同一个 `A045D7B8` 开门，见 [音频 producer](prerecord-audio-producer-audit.md)。本轮没有重复执行这项旧测试。

两段证据合起来，消除了“后来的 video event 会再次重置音频，使两轨共同从该事件开始”的解释：**同一 source 已经打开时，后来的事件只是再写一次 1。事件到达时音频帧计数可以已经非零；这条回调不会把它变回零。** 这不是运行时测得的启动提前量，也没有证明所有实际录制模式都会在该事件前完成音频编码。

原始音频 PTS 的零点仍来自编码任务 setup；视频 raw/repaired PTS 的来源及每流回绕状态仍属于另一条链。即使先把比例换成同一单位，再直接相减，也仍缺共同采集 epoch。这次没有发现可用的共同硬件时钟，因此没有给出一个猜测的固定 A/V offset。

## 下一项具体输入

当前有界结论覆盖上述六个原函数的成功、debug 关闭与指定过滤分支；没有覆盖其他 pipeline callbacks、DSP clock 产生端、硬件采样或并发调度。继续离线推进需要一个具体新来源：能把“首个接纳的 PCM DMA block”及“首个视频 raw DSP PTS”挂到同一计数器的原始生产链，或已有同时记录这两个边界的采集件。

只再取得 event 0x13 日志、文件内两轨首 PTS=0、另一份音频帧计数或重复开启 gate，都不足以填上这个缺口。真实同步观测若未来另行设计，应保留同一会话的 setup 时点、首次 gate 0→1、首个被接纳 DMA block、音频帧计数与视频 raw/repaired PTS 及回绕状态，不能用回调到达时间代替 ADC/传感器采集时间。

```sh
.venv-reverse/bin/python scripts/audit_prerecord_gate_epoch.py
.venv-reverse/bin/python scripts/audit_prerecord_gate_epoch.py --output /tmp/yi4k-gate-independent
.venv-reverse/bin/python scripts/audit_prerecord_gate_epoch.py --output /tmp/yi4k-gate-independent/result.json
```
