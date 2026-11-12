# 1.10.7 音频采集入口、样本接纳门与共同起点缺口

2026-11-10。本轮向下追到音频 DMA 完成状态、输入 buffer 的生产与编码器消费路径。新增 **11 个原始指令片段仿真、8 个指令断言全部通过**；没有重复音频 PTS 公式用例，没有接设备或写入真机。

## 新增确定证据：输入采集与样本接纳是两个动作

调用链：

```text
AudioEnc_StartAinTask A045D264
→ AmbaAudio_InputTaskStart A0291C5C
→ A02915F4 建立 24 字节 DMA descriptor 环
→ A0291498 / A0482174 提交 DMA
→ A0482DDC 开启音频输入硬件

InputTaskEntry A029262C
→ A02914B4 等待 DMA 完成状态
→ InputDataProc A0292304
→ 容量检查 A02943C0
→ Buffer 写入 A02941F4
→ 编码任务 A02902B4 经 A0294078 取 PCM
```

`A0291C5C` 清零 input state+4 和 +8，初始化 DMA ring 的当前位置与运行状态；`A029262C` 也在任务进入时清零这两个索引。`A02914B4` 读取 DMA status 数组的 `0x08000000` 完成位、`0x10000000` 终止位，清位后推进 ring index，超出 ring 大小则归零。这条完成状态路径没有读取或保存硬件采集时间戳。

`A02915F4` 建立的 24 字节 DMA descriptor 包含外设／内存地址、下一个 descriptor、status 地址、传输大小及控制字。`A0291758` 对其中指定槽位的 +0x14 写终止／重设控制字；4 个实际执行用例得到输入方向 `0x01b20007`、另一方向 `0x01720007`。该写入是 DMA 控制标记，不能命名为首次采集时间戳。

硬件开启 `A0482DDC`（与导出 `A04924E0` 同实现）只更新音频寄存器 base+0x24 的 bit1；`A0482E18` 置该寄存器 bit3。这里没有向 DSP 同步接口提交 epoch 的证据。没有在宿主执行这些 MMIO 函数，也没有把寄存器位进一步命名为未经证实的同步模式。

## record 时打开 source，决定哪些输入样本进入编码 buffer

关键的新增路径在 `A02941F4`：成功获取／释放节点 mutex 后读取 source IoNode+4，**仅值为 1 才进入 payload 复制路径**。值不是 1 时直接返回 0，且不访问 payload ring。实际 ARM 分支位于 `A029423C–A029424C`。本轮对 0、1、2 三个 flag 执行后缀，确认只有 1 走接纳路径。

`A029351C`（BufferOpenSrcIoNode）在 `A0293560` 将该 flag 置为 1；前轮已确认 record start 的 `A045D7B8` 在音频编码器启动后调用它。目的端 `A0293440` 有独立开关，编码任务 `A0294078` 检查目的端开关再读数据。

`A0292304` 先检查输出 PCM buffer 可用容量。在容量足够的节点上，`A02924D4` **在调用 writer 前**递增本轮可写节点计数，`A02924E8` 调用 `A02941F4`。该计数随后允许推进 input state+8 消费索引（`A0292538–A0292578`）。因此存在这条明确的行为：

> 音频输入已经运行、目的 buffer 有容量、source gate 尚未打开时，writer 返回成功但不复制 PCM；生产者仍可推进消费索引，这批采集样本不会送入编码器。

这使 liveview 阶段持续采集与 record 阶段才开始接纳 PCM 在代码上成立。不能扩大为“任意关闭或背压状态都会丢弃”：容量不够、没有可写节点等分支可能不推进索引。

这也说明录制启动时清零编码帧序号、开启音频输入、打开 PCM source gate 并非同一个原子动作。单靠前轮证明的 pipeline 调用顺序无法得到声音首样本与视频首帧的对应时刻。

## MakeUp / overwrite 路径处理 ring 进度

`A0292304` 比较 input state+4 与 +8：相等时本轮处理次数为 1，不等时设为 2，部分相邻／跨环边界会打印 `Warning: Audio Input DMA buffer ...`。旁边 `MakeUp` 日志也属于此比较。这些分支按 DMA ring 索引处理消费进度，本轮没有看到它们读取视频 DSP PTS、按音视频差值丢帧或补帧。

PCM buffer 的 `A0293204`、`A0293FB0`、`A02941F4`、`A0294078` 使用 12 字节项：状态／所有权 word、payload 地址、长度与终止标志 word。沿这条明确的生产／消费路径，没有发现 u64 采集时间戳字段。终止标记在长度最高位，其余位保存有效长度；这里不能套用后面的编码 FrameDesc 结构。

输入和编码任务中的 `A048E3F8` tick 用于计算处理耗时、打印超时日志，当前链条没有把该 tick 传入编码事件 PTS。输入端 effect/FC 配置及可注册回调仍可执行自定义处理；本轮没有穷举所有回调实现，所以不能宣称整个固件完全没有其他同步或丢样机制。

## 复现及有界结论

运行 `.venv-reverse/bin/python scripts/prerecord-capture-epoch.py`。输出 `artifacts/device/2026-11-10-prerecord/prerecord-capture-epoch-audit.json`，包含 18 个函数的伪代码及函数体 SHA-256、指令窗口、各输入／实际结果。

11 例是 4 个 DMA status 消费片段、3 个 source gate 后缀、4 个 DMA 控制字写入；8 个字节断言覆盖 DMA 完成／终止位、source gate、writer 调用前计数、消费索引推进和开门写入。DMA status 仿真从 semaphore 等待成功之后开始；gate 从 mutex 释放成功之后开始。没有执行 RTOS、锁、DMA硬件、PCM复制、effect 回调或完整任务。

固定镜像 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `A0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

**共同音视频采集 epoch 仍未找到。** 新证据说明音频首个被接纳的样本由 source gate 与 DMA block 进度共同决定，而不是编码序号 0 自带硬件时刻。下一方向应追 source gate 开启时刻相对于当前 DMA descriptor 的边界，以及 AppLib 视频启动回调／FIFO 首次事件如何保存“录制请求到首帧”的偏移；必要的后续真机只读观察应同时记录这两个边界，不能从函数调用先后假定同步。
