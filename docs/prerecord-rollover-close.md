# 原厂切段关闭模式与 AAC 交接审计

本轮新增脚本 [`audit_prerecord_rollover_close.py`](../scripts/audit_prerecord_rollover_close.py)，在固定 1.10.7 ARM 镜像的合成 RAM 中，先经原始 `ProcessVideo`/`ProcessAudio` 写入真实归档 MP4 的一段 8 个视频包和 13 个 AAC 包，再执行 `A03FE300 AmpMp4Mux_Close` 的三种模式 `0/0x40/0x80`。它保留真实包 payload、原始 index Add/Commit 事件与关闭前后的 movie/index 状态；没有访问相机或写入固件。

复现：

```sh
.venv-reverse/bin/python scripts/audit_prerecord_rollover_close.py
```

结果写入 [`audit.json`](../artifacts/device/2026-11-11-prerecord-rollover-close/audit.json)，并保存三个关闭结果文件。

## 结论

| Close 参数 | `IsoMux_Trim` | MOOV 收尾 | 结果 | 调用语义 |
|---|---:|---:|---|---|
| `0` | 执行 | 完成 | 可被 ffprobe 打开 | 正常结束路径；Trim 仍决定尾 AAC 是否出现在样本表 |
| `0x40` | 跳过 | **跳过** | `moov atom not found` | 已展开调用者只见于暂停/limit 错误清理或错误回调；不能当保留 AAC 的成功切段 API |
| `0x80` | 跳过 | **跳过** | `moov atom not found` | 启动失败清理路径；不能当正常切段 API |

`0x40` 与 `0x80` 都返回 0，但这只是原始 close 清理函数的返回值。两者输出长度相同，均只有已写媒体/头部字节，没有最终 `moov`；重新 `Open` 可以重新初始化合成 mux 对象，不能使已关闭的文件变成可播放段。脚本同时记录 `index` 被清零、底层关闭调用和重开状态，避免把“包曾经写入”误当成可交付文件。

## 调度含义

当前能支持的候选仍是正常 mux pipe 的 `master limit → OnPipeLimit → event 3 → close/open → movie copy/reset → open`。`OnPipeLimit (A0442674)` 的 `Close(...,0x40)` 只位于错误回收分支；`OnPipePaused (A044195C)` 和 `OnPipeError (A0442BAC)` 同样不是成功 rollover。`A0441550` 的 `Close(...,0x80)` 是启动错误清理。没有找到将这些参数作为正常成功切段关闭模式的官方调用者。

正常切段仍需让 mux 自身先处理同步边界，并完整走 format/file close、movie copy/reset、stream/format open；AAC 是否跨界保留要在合法 close/open 合同内验证。直接把 `0x40`/`0x80` 传给 close 不能解决 AAC 交接，且会生成不可播放文件。

后续[完整 event 3 回调离线执行](prerecord-event3-rollover.md)已串联原厂 OnMovieEvent/OnPipeLimit/Close0/New/Copy/Rel/Reset/Open，并确认短构造 FIFO 的同步帧保留与下一段首帧；正常 Close0 仍丢跨界 AAC，严格时间线拒绝，短写进入原厂断言，未形成安全设备后端。

## 限制

脚本执行了原始封装和 index 模型，但没有执行真实编码器、DMA、CFS/SD、调度器、payload lease 或相机 API。只覆盖一个归档窗口；没有宣称一分钟预录、生产者连续性、跨文件 A/V 时间线或真机可部署。Ghidra 伪代码仅作调用定位，ARM 镜像字节和已有固定 harness hash 均由脚本校验。
