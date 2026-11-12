# 1.10.7 音频 payload 生产、回调、FIFO 与回收

2026-11-11。本轮将音频调查从已有 PTS 公式推进到实际字节的生产和复用，新增 **20 组原始 ARM 合成执行、9 项来源核对、8 条精确指令断言**，并实现复用现有 owned queue/payload-copy 的音频立即复制接缝。没有连接或写入相机，没有 Android 改动、hook 安装、RTOS 运行、真实 AAC 编码或 SD 写盘。

固定镜像仍为 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `A0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。复用 REA 技能约束、已有 Ghidra 导出与本地 Capstone/Unicorn；没有创建新 REA 会话或修改 MCP 配置。

脚本：[audit_prerecord_audio_payload.py](../scripts/audit_prerecord_audio_payload.py)。证据：[audio-payload audit.json](../artifacts/device/2026-11-11-prerecord-audio-payload/audit.json)。已有时间基与配置结论分别见[音频 producer](prerecord-audio-producer-audit.md)、[audio-config](prerecord-audio-config.md)；本轮不重复 PTS 算术。

## 生产到 FIFO 的实际路径

```text
音频任务 A02906E8
  → state+44 回调 A045D690，返回 CPU 编码输出块地址
  → state+3c = 返回地址
  → A029024C 按 state+38 高半字节选择 codec
      PCM：A028FCE8 实际写出转换后的字节
      AAC：A029011C → A0255FFC，向编码器传入 CPU 目的和输入地址
  → A029016C 构造栈上 event 0
  → A0295800 同步按槽调用事件回调（持有 encoder+100 事件 mutex）
  → 原厂 A045E7DC：复制 metadata、增加预留块记账、构造 FrameDesc
  → 释放全部音频实例 mutex
  → A0452254 WriteEntry：写 FIFO、发送回收与 data-ready 消息
```

原 ARM 夹具从真实 task 的 `A02906E8` 开始，提供该基本块所需的 `r4=state/r10=encoder/r8=buffer graph` 前置条件，执行到 `A0290714`，在输入 buffer 归还之前停止。GetWritePointer、codec dispatcher、PCM 转换、event 构造、同步分发、原厂 callback、FIFO WriteEntry 均执行原镜像指令。外部 mutex/消息队列/日志使用已有 FIFO 夹具的明确模型，没有运行实际任务调度器。

PCM 例子将 8 个合成 32-bit 输入样本的高 16 位写为 16 个输出字节。FrameDesc 的 type/flags 为 `8/1`，地址/长度与真实转换输出相符；格式 0 的预留记账却增加 `0x2000`。这直接区分“实际 payload 长度”与“编码输出块额度”。

AAC 单独用例执行真实 wrapper，但将 `A0255FFC` 明确替换为设置输出 bit 数的测试模型：wrapper 把 `state+3c` 写到 codec context+38，输入地址写 +3c，把 101 bits 向上取整为 13 bytes 后传到 FIFO。**该用例没有生成 AAC 字节，不证明 AAC 编码时间、最大输出或稳定期。**

## 音频事件有两个未初始化字

| event 偏移 | 已恢复内容 |
| --- | --- |
| +00 | encoder handle |
| +04 | **生产者不写入，旧栈字；不得解释** |
| +08 | u64 音频任务合成 PTS |
| +10 | u32 EOS；原厂普通路径为 0、结束为 1 |
| +14 | 实际 payload 字节数 |
| +18 | CPU payload 地址 |
| +1c | **生产者不写入，旧栈字；不得解释** |

原厂 A045E7DC 仍复制完整 32 bytes 到 metadata。两个不同 poison 栈用例实际证明 +04/+1c 保留预置值，并原样进入原厂 metadata。因此新接缝只读取已定义字段，在 owned snapshot 中把两个字清零；不能拿完整 event 字节作可靠内容身份或语义 hash。

## 固定块、回绕与回收

`A045D690 GetWritePointer` 根据实例格式选固定块大小：

| 格式字 | 一帧预留块 |
| --- | ---: |
| 10、11、12 | 0x600 / 1536 bytes |
| 20、40、50 | 0x800 / 2048 bytes |
| 其他已审计分支 | 0x2000 / 8192 bytes |

它返回 `payload_base + write_index × chunk`，随后让 write_index 加一；若新值达到 `floor(capacity/chunk)` 就归零。末尾不足一个块的空间不分配。函数要求实例 flags 的 bit2，但**没有比较 read_index、produced-retired 或 virtual cursor**。这条控制流不提供消费者 lease。

全部 7 个格式分支的原 ARM 例子均用三块加 17 bytes 的合成 ring，实际返回 `base/base+chunk/base+2chunk/base`，17 bytes 尾段不使用；在 read_index=0、retired=0 时仍回绕。

更进一步的原 PCM 用例执行四次真实编码输出到三块 ring，执行真实 `A044E8D4 SyncWritten` 把描述符 fan-out 到 virtual FIFO，保持 virtual read=0，不执行退休 callback。第四帧实际改写首帧地址的 16 bytes，而队首描述符仍指向它。这里是**原始 CPU PCM 指令实际覆盖合成 RAM**，没有模拟 DSP 覆盖；不是当前相机配置、真实 AAC 或 ADC 实验。

回收链也执行了原始代码：

```text
FIFO worker A044F0C0（提供一个收到的 10000000 回收消息）
  → A044F16C 调用 base callback，event=04000000、参数=&removed_count
  → 音频 A045CF84
      按 base FIFO handle 找实例，持有该实例 mutex
      逐条 metadata：size!=0 且 EOS==0 才 retired += chunk / read_index++
      每个被移除项的 PTS 写 00000000fee1dead
      metadata read pointer +=32，超过 limit 则回 base
```

`A045CF84` 未被现有 Ghidra 导出建为函数；本轮绑定其完整原始 ARM 窗口 `A045CF84–A045D263`，并验证 Create 配置明确把此地址设为 FIFO callback、RemoveOnWrite=1。

与视频 BitsMgr 不同，音频回收**不清 metadata 的 payload 地址，也不擦除 payload 字节**。普通 13-byte event 会退休整个 `0x600/0x800/0x2000` 块。EOS、以及 size=0 的普通 event 都不增加退休额度；后者会造成 produced/retired 记账差，因此新复制接缝拒绝零长度普通帧。新增 metadata 三槽回绕例子覆盖普通/零长/EOS 的差异。

原厂 EOS FrameDesc 为 typeFF、地址0、PTS0；正常结束长度 `00ffffff` 并将 stock sequence 清零，实例状态5则是 `00fffffe` 且保留 sequence。后者不能混同现有 payload-copy 的通用 EOS 长度。

另执行 `04000004` EraseAll 通知：produced/retired 和 metadata read/write 指针清到初态，**write/read chunk index 在该 callback 内不清零**。它不是完整音频生命周期重置合同。

关键实例偏移（实例0基址 `A19C7250`，其余步长 F0）：

| 偏移 | 内容 |
| --- | --- |
| +4c | 格式字 |
| +88 / +8c | payload CPU base / capacity |
| +90 / +94 | metadata base / buffer bytes |
| +a8 | base FIFO handle |
| +b0 / +b8 | produced / retired u64 预留额度 |
| +c0 / +c4 | write / retired chunk index |
| +c8 | stock FrameDesc sequence |
| +cc / +d0 / +d4 | metadata write / read / last-slot pointer |
| +e0 | 实际 payload bytes 的独立统计 |

## 最早同步复制接缝与回调顺序

音频与视频 ABI 不同：音频 event 0 的 callback 只有 **event 指针一个参数**。`A0295800` 在调用原 callback 后才继续下一个槽，并持有 encoder 事件 mutex；回调返回值不传播到 dispatcher 的状态。

`A045F204` 给 event 0 配置两个回调槽；`A045ECD0` 通过 `A02955C0` 先注册 A045E7DC。原 ARM 注册用例确认：第二观察者进入 slot1；重复注册不重复插入；**两个槽已满时仍可能返回0，而没有插入**。返回0不能单独作为注册成功证据。

直接加第二 observer 时，真实顺序是 `stock callback → WriteEntry → observer`。已执行的用例中 observer 看到 FIFO write=1，且仍持有 encoder+100 mutex。它晚于原厂 metadata/FIFO 副作用，不能作为所需的最早入口。

候选为 **A045E7DC 之前的同步 wrapper**；或者先建立有证据的 slot0 observer/slot1 original 顺序。构造后者的合成表，实际观察到 observer 看见 FIFO write=0，随后原 callback/WriteEntry 才执行。本轮**没有实现 slot 重排、写入 callback 指针或安全安装/卸载**。也不能在该 mutex 内调用会再次拿相同 mutex 的注册 API。

任务在本帧 codec 返回后、下一帧 GetWritePointer 前同步分发事件，给出了同一任务的控制流顺序；它尚不是针对 DMA、其他核、共享 producer 或 cache 的硬件稳定期证明。不能据此直接在真机启用。

## 实现：音频与视频共用复制队列

新增：

- [audio_event.h](../sdk/yi4k_1107_audio_event.h)：绑定实际 32-byte 布局，明确两个 unwritten word。
- [audio_early_copy.h](../sdk/yi4k_1107_audio_early_copy.h) / [.c](../sdk/yi4k_1107_audio_early_copy.c)：单参数原 callback 的立即复制接缝。
- [共享 early_copy](../sdk/yi4k_1107_early_copy.c)：把原视频捕获中的 owned-frame 发布提成 `early_offer_frame`，复用原 N−1 SPSC queue、payload-copy 和消费 API；owned slot 增加 source_kind 和 sanitized audio snapshot。

没有复制另一个队列或 FIFO 生命周期实现，也没有把音频伪装成 video event。视频仍完整保留 48-byte event；音频保留定义字段，两个 unwritten word 为0。源类型在 release-store 发布前写入；另一类型 snapshot 清零。这个 offline owned-slot 结构新增了字段，依赖它的 C 调用者必须一起重新编译；原厂 FrameDesc 和 payload-copy ABI 未改变。

音频 ordinary 映射 type8/flags1；PTS 原样保存并不做 A/V 对齐。sequence 是适配器自己的观测序号，**不是恢复出来的 stock sequence**，有效普通事件即使 FULL/COPY_FAILED 也推进，以保留 gap；无效事件不推进，u32 回绕有测试。

EOS 使用独立 owned 语义：规范化为 typeFF/length00ffffff，不读 payload、保留 raw EOS 字段到 sanitized snapshot，不读取实例状态、也不生成原厂00fffffe。转发给 original 的 event 指针/内容完全不改。

有效 immutable chain 下，每次 invocation 都恰好转发原 callback 一次，并保留其 status；NULL adapter/event、无效 EOS、无效 payload、队列满、EOS 满、同步重入也如此。无效 chain 无法转发，明确 BAD_CHAIN。未声称野指针或原 callback 故障可恢复。

复制路径无 malloc、锁、等待、重试或 I/O。consumer 仍借用自有 slot 到 release，满队列不覆盖。**音频与视频应各用独立 queue；共享实现不等于可把两个 producer 接到同一个 SPSC 实例。**

## 编译验证与剩余条件

[validate_prerecord_audio_early_copy.py](../scripts/validate_prerecord_audio_early_copy.py) 将真实 C 编译为宿主库与 ARM Cortex-A9，运行[22 组音频用例](../sdk/offline/yi4k_audio_early_copy_test.c)：复制先于 original 改写、sanitized metadata、双段复制、full 不覆盖与序号 gap、EOS 不读无效源、单参数转发、NULL/错位/错误事件、同步重入、序号回绕、源复用、失败恢复全部通过。宿主/ARM 报告一致，SP/callee-saved 保持，链接无未定义符号/relocation。

ARM 访存 hook 另外检查编译后的音频适配器：**没有读取 event+04/+1c**。这比仅检查输出清零更强，避免把旧栈字先读入再伪装成可靠 metadata。

共享队列调整后重跑原视频 22 组宿主/ARM 用例，以及 20,000 帧宿主 pthread SPSC 完整性检查，全部通过，0 字节/顺序错误。调度引起的 FULL 次数不作为稳定基准。该线程用例验证共享 C 队列，不验证 RTOS、cache 或硬件时限。

当前 ARM 大小：audio_on_event 516 bytes；共享 init 556、offer_frame 1208、video_on_event 440、peek44、release60；复用 payload-copy496。构建命令、全部源码/头文件 hash 与报告分别见 [audio validation.json](../artifacts/device/2026-11-11-prerecord-audio-early-copy/validation.json)、[video regression validation.json](../artifacts/device/2026-11-11-prerecord-early-copy/validation.json)。

```sh
.venv-reverse/bin/python scripts/audit_prerecord_audio_payload.py
.venv-reverse/bin/python scripts/validate_prerecord_audio_early_copy.py
.venv-reverse/bin/python scripts/validate_prerecord_early_copy.py
```

仍缺：真实 AAC 输出最大长度和块边界、实际 CPU ring/cache 及跨核稳定期、安全 callback 安装/原回调保留/卸载静止、独立音视频 queue 的吞吐和内存预算、一分钟 SD spool/mux、共同采集 epoch、满卡/掉电恢复、真实语音/快门接入。当前是更完整的离线复制接缝，**不是相机一分钟预录实现**。
