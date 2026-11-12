# 原始 ARM 索引与完整 MP4 的离线执行

## 结论

`scripts/audit_prerecord_native_mp4.py` 已把原来显式模拟的索引 Add/Commit 替换为固件原始 ARM 执行，并执行完整 MP4 Open → 视频/音频写入 → Flush → Close。生成的文件由独立 ffprobe 检查，并由 ffmpeg 完整解码。这里证明了离线封装链，不代表相机上的一分钟预录已经完成。

固定输入镜像：`artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。报告还固定 19 个根函数的 ARM body 和反编译文本哈希。

```sh
.venv-reverse/bin/python scripts/audit_prerecord_native_mp4.py --output /tmp/yi4k-native-mp4-independent
```

`--output` 与 `--output-dir` 等价，输出目录包含 `audit.json`、可解码 MP4 和故障注入留下的部分文件。

## 执行边界

以下是原始固件代码，未使用 Add/Commit 成功桩：

| 路径 | 原始 ARM 入口 |
| --- | --- |
| MemIdx Create / Open / Write / Read / Close | `A0402610 / A04032FC / A0402750 / A0402884 / A0402ED8` |
| IsoIdx Create / Add / Commit / Flush / Delete | `A040F710 / A0411E88 / A04111AC / A0411048 / A040FC04` |
| IndexCache Read | `A0401AE4` |
| MP4 Open / Close / MOOV builder-serializer | `A0435A18 / A0436004 / A0433AF0` 及其被调用函数 |
| ProcessVideo / ProcessAudio | `A042D0F8 / A043173C` |

`NativeMachine.hook` 对 Add/Commit 明确绕过旧 `WriterMachine` 的替代钩子；每个成功文件断言旧模拟索引事件数为零。原始 MemIdx Write/Read 会执行实际 memcpy，报告记录后端读写计数和根函数调用计数。

仍然显式模拟的边界：RAM 字节数组文件的 Write/Read/Seek/Tell/Length/Sync/Func、OS 分配器和互斥锁、固定 RTC，以及构造的 movie/FIFO/注册表 RAM。没有执行物理 CFS/SD、编码器生产者、DMA 或真实按键/语音。

Seek 的 ABI 为：64 位偏移在 `r2/r3`，`r1` 是对齐空位，origin 位于入口 `SP+0`。文件模型按此执行位置写入，关闭时原始代码回 seek 修补 mdat 长度。

另外显式设置 Amba metadata version 2.0（`A19653F9=2`、`A19653FA=0`）。原始 Format Init `A03E3C48` 从配置写这些字节，`A03E4D1C` 读取；这里构造等价前置 RAM，并不声称获得过真机当前值。全零版本会被原始 Amba box writer 拒绝。

## 成功场景

1. **最小完整文件**：原始 Open、一个 H264 IDR、一个 AAC 包、原始 Close，生成 `native-output.mp4`。视频为 H264 Main 1920×1080，音频为 AAC LC 48 kHz 双声道；视频解码帧 MD5 与归档原文件首帧相同，单个 AAC 包解码 PCM SHA-256 也相同。
2. **多样本与原始索引读回**：3 个 IDR、4 个 AAC，cache count=2，触发录制期间真实 Commit/flush。显式原始 Flush 后，对每条 Add 输入逐项执行 IndexCache Read，校验 sample size、offset、ctts、sync 和 timing 原始字节相同，并要求确实发生 MemIdx 后端 Read。
3. **同一 MemIdx 对象、两次独立构造的 movie**：关闭第一段后，用同一对象、全新文件、全新构造的 movie epoch，再执行原始 Open、2 个 IDR、3 个 AAC、读回、Close。两段分别独立解码。必须先清零 movie structure 再执行原始 init；这不是原厂相机重开/复用生命周期验证。
4. **末尾音频裁剪**：输入 3 视频、5 音频，原始 Close 最终保留 4 个音频包。第 5 包超出视频结束时间，由原始 Trim 删除。

所有多帧都重复同一个归档 IDR 和 AAC 包，并赋予单调 PTS（视频 1001/30000 秒，音频 1024/48000 秒）。这是合成时间线，不能用于证明连续相机捕获、P/B 帧重排或实际关键帧间隔。重复 AAC 包在连续解码时保留 overlap 状态，所以多包只断言包数、PCM 长度及完整解码成功，不把单包 PCM 简单拼接当作正确答案。

`negative_reinit_without_fresh_movie` 保留了不清零的实际负例。第一段后的 video/audio sample count 是 `[3,4]`，再次原始 track init 后仍是 `[3,4]`；新一段 sync sample 序号继续为 4/5。第二段 Add 的首个音频 offset 为 `000e49e8`，原始 cache read index 0 却返回上一段的 `00156ec8`，原始 Close 随后触发 assertion。报告保留字段、Add 输入与日志，并输出 `no-movie-reset-media.bin`、`no-movie-reset-index.bin`。上层需要如何调用原厂 reset/init 仍待查证。

## 故障与恢复边界

| 注入点 | 已验证结果 | 可采取的动作 |
| --- | --- | --- |
| 原始 Open 内 byte / block allocator 失败 | Open 失败，MemIdx data pointer 清零；清故障后新 Open 可成功生成有效 MP4 | 新建 segment；报告记录实际清理状态 |
| 视频媒体 Write 短写 | 写入部分媒体，ProcessVideo 失败，FIFO read cursor 仍为 0 | 放弃该部分输出；向同一输出直接重放会留下重复/残缺媒体 |
| cache=1 的真实 Commit 中 MemIdx mutex 失败 | 原始 Commit 返回 -1，视频已经消耗（cursor=1）；索引缓存仍在 | 清除该短暂 RAM backend lock 故障，原始 Flush/Close 可保全文件；不重放已消耗帧 |
| 第一次 MOOV Write 短写 | Close 失败，但原始索引已删除、MemIdx 已关闭 | 放弃部分文件并新建 segment；不能把 retry Close 当作恢复 |
| Close 的 seek 失败 | Close 失败，原始索引和 MemIdx 已清理 | 同上，新 segment 可成功 |

Commit 恢复案例只证明显式 RAM 模型下的一次瞬态互斥失败，不证明 SD 部分写入、断电、崩溃恢复或任意错误都能重试。

## 尚未完成的产品链

尚未证明：实际编码器到自有缓冲的输入映射和 DMA 完成、一分钟容量与长期运行、真实 GOP/音视频时间线、设备侧常驻触发、语音识别、快门触发与物理 SD 文件可靠性。这里没有向真机写入任何代码或配置。

主线程在冻结脚本 `3dc7b00032803b6440124e8e6ce7316701a595333365253da935494bf208da99` 上[独立复跑全部 11 场景](../artifacts/verification/2026-11-11-native-mp4-independent-run01/audit.json)通过。独立目录保留成片、故障部分文件及未清零负例，没有覆盖 agent 原始结果。

与前序交付的关系：`prerecord-owned-mux-adapter.md` 证明 owned descriptor/数据生命周期；本报告接通其后方的原始索引与文件封装。新的 codec epoch 验证器可以导入稳定的 `NativeMachine`、`setup_index` 和地址常量，把无 SPS/PPS 的切片补齐后交给同一原始完整 MP4 路径。
