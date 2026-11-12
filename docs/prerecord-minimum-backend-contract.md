# 固定一分钟预录：最小相机后端状态机与失败恢复合同

2026-11-11。本页把已有 FIFO ownership、普通 mux rollover、跨文件音视频起点和 loop recovery 证据收敛成一个**候选设计合同**。它不是固件补丁，也不是已经接入相机的实现。机器可读版本见 [contract.json](../artifacts/device/2026-11-11-prerecord-backend-contract/contract.json)，复现命令：

```sh
python3 scripts/build_prerecord_backend_contract.py
```

v2 脚本读取 9 份已有审计结果，7 项来源一致性检查通过；全程没有连接相机、执行 RTOS、调用隐藏 setter 或写入固件/RAM/分区。

**适用性修正：**[原始 ARM 回收链反例](prerecord-payload-reclaim.md) 已证明，virtual read cursor 保持不变时，原厂视频 producer 仍可退休底层 payload。下述消费模型仅适用于已有独立稳定 lease 或已经复制到自有存储的数据，不能直接作为 stock virtual FIFO 后端部署。当前候选改为原视频 callback 前及时同步复制，再由自有有界队列交给落盘任务；硬件复制稳定期和安全安装仍未证明。

## 候选所有权模型

后端只拥有一个串行 owner，负责 virtual FIFO、段文件 manifest 和 mux writer。编码器 base FIFO、payload 地址和原厂 loop 删除游标不属于这个 owner。每一帧的读取顺序固定为：

```text
begin_read
  → Peek(index=0)
  → 复制 descriptor 快照
  → 校验并复制 payload
  → 持久化到当前段/manifest
  → Remove(1)
  → end_read
```

`persist` 成功之前不能 Remove。这个顺序本身不建立 stock payload lease，也不能阻止 producer 回收。Remove 返回非零时，即使原 FIFO 可能已经推进游标，也必须进入 `CURSOR_UNCERTAIN`，不能重新保存或重试同一帧。EOS 是停止标记，不是空队列，也不自动 Remove；它不能触发 payload 读取。

## 状态机

| 状态 | 进入条件 | 正常离开 | 失败处理 |
|---|---|---|---|
| `OFF` | 没有 owner、handle 或 writer | `prepare` | 留在 `OFF` |
| `ARMING` | 校验录制管线、SD、base stream，创建 virtual FIFO，打开自有 manifest | 所有 ownership token 已记录 → `ARMED` | `CREATE_UNCERTAIN`；保留任何返回 handle，禁止自动重试/Delete |
| `ARMED` | callback 已准入，read guard 可用 | 首个稳定 descriptor → `ROLLING` | 读保护失败时停止消费，不删除 handle |
| `ROLLING` | payload 已复制并写入当前段 | sync-frame rollover、START、EOS 或 STOP | `COPY_RETRY`、`STORAGE_FULL`、`CURSOR_UNCERTAIN` |
| `ROLLOVER_PENDING` | 原厂 mux 自身在同步帧处发出 event 3 | 旧文件关闭、新文件收到参数集/IDR、manifest 提交 → `ROLLING` | 保留旧段，停止发布新段 |
| `COMMITTING` | 相机已确认的语音 START 或快门 START 被幂等接受 | 预录段冻结并进入触发后持续写入 | `COMMIT_UNCERTAIN`；保留 manifest，不把重复 START 变成 STOP |
| `FINALIZING` | 明确 STOP 或 EOS | 所选文件可播放且 manifest 持久化 → `QUIESCING` | 保留待完成文件，进入 `FINALIZE_FAILED` |
| `QUIESCING` | 关闭 callback 准入，等待在途 owner/callback | callback 数为零、handle/registry 仍有效 → `CLOSED` | `QUIESCE_FAILED`；绝不调用 Delete |
| `CLOSED` | quiesce 通过且唯一 handle 删除成功 | 下一 generation 重新 `ARMING` | 本地 close 幂等，不重复调用原厂 Delete |
| `RECOVERY_REQUIRED` | 重启、掉电、SD 错误或任何不确定返回 | 只在自有 manifest 和文件身份核验后重新建 owner | 保留 UNKNOWN/ORPHAN 文件，禁止原厂 loop 删除 |

`COMMITTING` 的触发事件只来自相机固件已识别并送达的类型化 START 或实体快门事件。Android 不使用手机麦克风，也不匹配“开始录像”或“start recording”文本；App 只负责显示状态和导出。

## 分段和成片条件

段切换必须由原厂 mux 线程在同步边界触发，不能从应用线程裸调用 event-3 回调。新段在收到真实参数集和可独立解码的 IDR 后才发布为 `COMPLETE`；在此之前保持 `OPENING`，不能把文件名存在当作可播放证据。切段应保持编码 producer 继续运行，但这一点仍需真机证明：静态 close/open 路径没有显式重启编码器，却尚未闭合 vtable、FIFO cursor 和 storage 叶。

每段 manifest 至少保存：session/generation、相机文件身份、路径、创建/关闭状态、首个同步帧 descriptor、NAL7/NAL8/NAL5 检查、首尾视频 raw/repaired PTS、音频 frame counter/采样配置、payload 字节数、SHA-256、错误码和 owner generation。触发提交时冻结所需历史段，再把触发后的新段加入同一 session；不重编码、不把每轨各自归零当作音画同步证明。

## 失败恢复合同

| 失败 | 合同动作 |
|---|---|
| Create 返回错误或 handle 不确定 | 进入 `CREATE_UNCERTAIN`，保留返回值和 registry 证据，禁止猜测清理或自动重试 |
| Peek 为空 | 保持当前状态，不推进游标 |
| 读保护、payload 复制或 persist 失败 | 只有自有 payload 或独立重新验证的稳定 lease 才允许重试；不能因 virtual 游标未变重读原厂地址，无法建立保护时记录 gap / 预录失败 |
| Remove 非零 | 进入 `CURSOR_UNCERTAIN`，停止该 descriptor 的保存/删除重试 |
| EOS/特殊结束 | 停止读取，不读取 payload，不隐式 ack |
| rollover close/open 失败 | 保留已关闭段和 manifest；不发布半开的新段，停止继续消费或转错误态 |
| quiesce 失败 | 保留 handle，继续阻止新 callback，等待新的静止屏障；绝不 Delete |
| Delete 失败 | 保留 handle、registry 和 manifest，进入 `DELETE_FAILED` |
| 满卡、拔卡、掉电、重启 | 将未完成文件标为 `UNKNOWN`；只扫描和删除本 session 明确拥有且身份核验通过的文件 |

恢复路径不能调用原厂 `DelLoopEncFile`。已有静态证据显示它依赖持久游标、分段计数和数据库“下一个 ID”，没有闭合的会话归属过滤；把它用于预录可能误删旧素材或在删除失败后使计数失真。

## 仍需真机只读验收的门

当前合同可作为后续实验的审阅基线，但还不能部署。必须先在可停止、可回滚的真机只读/普通录像窗口中逐项记录：

1. virtual FIFO 的真实 stream/base/handle、Create 失败后的残留和 registry 状态；
2. 及时复制期间的硬件 DMA/cache 稳定期、自有存储容量和吞吐；软件 begin/end guard 或未变的 virtual 游标不满足此项；
3. callback 禁入、在途 callback 归零、Delete 后是否仍会调用旧 callback；
4. 每个新段首个 NAL7/NAL8/NAL5 的交付顺序和真实可播放性；
5. rollover 前后视频 PTS、音频 PTS/AAC 配置和 producer 是否连续；
6. gate 首次 0→1、首个接纳 DMA block、首个视频 PTS 与音频帧计数的关联；
7. 满卡、拔卡、掉电、重启后的 manifest、孤儿文件和恢复行为；
8. 相机识别语音 START、实体快门去抖和重复事件是否只产生一次 commit。

在这些门闭合前，不能把主机回放、离线 ARM 状态机或普通录像 MP4 证据升级为“相机已实现一分钟预录”。

