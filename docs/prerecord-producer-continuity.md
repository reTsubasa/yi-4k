# Producer 连续性与 virtual FIFO 句柄（离线静态证据）

本轮固定固件 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746` 的 Ghidra 导出，追踪 `AmpFifo_Create (A04509DC)`、`WriteEntry (A0452254)`、`SyncWritten (A044E8D4)` 以及音视频调用点。脚本和逐文件 SHA-256 记录在 [`audit.json`](../artifacts/device/2026-11-11-prerecord-producer-continuity/audit.json)，可由 [`audit_prerecord_producer_continuity.py`](../scripts/audit_prerecord_producer_continuity.py) 重跑。

## 已确认的句柄和游标关系

`Create` 的 `param[2] != 0` 进入 virtual 表 `DAT_a1966194`，按 `stream_id` 找 base 表 `DAT_a1966190`，并把匹配的 base 指针放入 virtual handler。descriptor pool 按 `capacity << 5` 分配，每项 0x20 字节，pool 指针/token 存在 handler `+0x80/+0xa0` 对应字段。创建 virtual 时读取 base 的当前写游标，初始化 virtual 的写游标和读游标；历史回填模式还会按容量和时间字段复制旧 descriptor。零历史配置会从当前 base 写位置开始，因此新建旁路不会自动回填一分钟历史。

审计中使用的 handler 字段映射如下：

| 偏移 | 静态用途 |
| --- | --- |
| `+0x80` | descriptor ring 指针 |
| `+0x88` | descriptor capacity |
| `+0x90/+0x94` | read cursor 低/高字 |
| `+0x98/+0x9c` | write cursor 低/高字 |
| `+0xa4` | callback 指针 |
| `+0xc0` | 历史 descriptor 类型筛选字段 |
| `+0xc4` | `SyncWritten` 检查的 virtual 活跃门控 |

## Producer fan-out

`WriteEntry` 先在 base handler 的写锁和数据锁范围内将一个 0x20 字节 descriptor 写入当前槽位，并递增 base `+0x98/+0x9c`。base 数据就绪路径把 `0x4000002` 消息送入 `Mw_FifoTask`；`0x10000000` 是前面 RemoveOnWrite 分支的回收消息，两者用途不同。virtual 路径直接调用 `SyncWritten`。因此两条路径的线程/锁上下文不同，不能假定所有 callback 都在同一个任务中。

`SyncWritten` 遍历 virtual registry，按 stream ID 匹配并检查 `+0xc4` 门控，然后把 producer descriptor 的 0x20 字节复制到 virtual 自己的 descriptor ring，递增 virtual 写游标。复制的是 descriptor；其中的 payload 地址仍指向共享编码 ring，没有在这些函数中看到 payload 字节复制或稳定的 DMA/cache lease。callback 事件是 `0x4000002` 普通数据、`0x4000001` 结束/特殊 sentinel、`0x4000005` full。函数在 callback 前释放 virtual 数据锁，callback 参数可能是栈上的临时 word，不能保存该指针异步使用。

`WriteEntry` 的 RemoveOnWrite 分支会枚举同一 stream 的 virtual handler，读取各 virtual `+0x90/+0x94` read cursor，寻找最小游标；落后超过阈值时可能推进 base read cursor。由此可以确认 virtual consumer 的滞后参与 base descriptor 回收边界，但无法从静态代码推出“无背压”或“永不丢帧”。payload ring 的实际回收、cache/DMA 完成和满队列运行时行为仍没有证据。

后续[原始指令回收链审计](prerecord-payload-reclaim.md) 已细化该边界：RemoveOnWrite 在 byte 阈值/descriptor 余量压力下可越过仍持有旧项的 virtual read cursor；有界 worker 进入真实视频 callback 和 BitsMgr 后，retired bytes 前进而 virtual 队首仍保留旧 payload 地址。因此最小游标参与回收不代表 payload lease，不能借此保留一分钟历史。

## 音视频调用点与 epoch 边界

音频 bitstream ready handler、视频 `PutEndMark` 和 `PutDecodeMark` 都调用 `WriteEntry`；视频结束路径自行按 90 kHz 计算 PTS。音频 stop 路径在改变 encoder 状态后可以通过同一 API 发送 `0xffffff` 结束 descriptor。这说明 producer 输入包含正常帧、标记帧和停止 sentinel，不能把一次 `WriteEntry` 成功解释为跨 stop/rollover 的 producer 连续性。

已有跨文件 epoch 审计仍明确记录：event→gate 只携带 pipeline 身份，未见 PTS、DMA block 或 video ring index；音频 PTS 由帧计数合成，视频 PTS 来自 DSP descriptor 并修正。因此共同 A/V 采集 epoch 和首个接纳 DMA block 对应关系仍未证明。

## 仍缺少的真机证据

- `Create` 返回的真实 virtual handle、base handle 和 registry 生命周期；
- `Peek` 解锁后到 payload copy、persist、`Remove` 完成之间的稳定读取 lease；
- producer payload ring 的 DMA/cache 生命周期、virtual consumer 落后时的背压/覆盖行为；
- callback 禁入、在途 callback 计数和 Delete 的调度器级 quiescence；
- rollover 前后首个 IDR/参数集、A/V PTS 连续性、掉电/满卡恢复。

所以本轮结论是：固件已有“base producer → 独立 virtual descriptor ring → callback”的静态 ABI 候选，并且 virtual read cursor 会影响 base 回收；预录所需的 payload lease、producer continuity 和共同 A/V epoch 仍未完成。全程未连接相机、未写 RAM/分区、未调用隐藏 setter，也未执行 RTOS。

验证命令：

```sh
.venv-reverse/bin/python scripts/audit_prerecord_producer_continuity.py
.venv-reverse/bin/python -m py_compile scripts/audit_prerecord_producer_continuity.py
python3 -m json.tool artifacts/device/2026-11-11-prerecord-producer-continuity/audit.json >/dev/null
```
