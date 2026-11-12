# 原厂分段的同步帧保留与参数集重建

2026-11-10，固定 1.10.7 镜像，完全离线。新结论：**普通 MP4 mux 只在原厂标为 `type=1` 的视频同步帧前检查分段上限；达到上限时先返回，不写出或移除该帧。但新文件 open 会清空 SPS/PPS 缓存，需要从下一段首个同步帧重新取得参数集。同步帧保留不能单独证明下一文件可以播放。**

这是对 [原生会话分段](prerecord-session-rollover.md) 的边界补充，未连接相机、启用 loop、删除素材或写入固件。脚本 [prerecord-sync-boundary.py](../scripts/prerecord-sync-boundary.py) 将镜像映射至原基址，构造宿主 RAM，执行实际 ARM/Thumb 指令，不替换任何 helper。证据 [prerecord-sync-boundary-audit.json](../artifacts/device/2026-11-10-prerecord/prerecord-sync-boundary-audit.json) 包含 67 组检查、6 条固定指令断言、19 个来源函数的代码/伪代码 SHA，以及五个指令窗口。

## 分段上限检查发生在同步帧写入之前

`AmpMp4Mux_CreateImpl(A03FDEC4)` 使用真实 vtable `A078A404`：open=`A03FE468`，close=`A03FE300`，process=`A03FE1E4`。process 调用 `IsoMux_Process(A04356A4)`，视频轨进入 `IsoMux_ProcessVideo(A042D0F8)`。

`ProcessVideo` 先用 `AmpFifo_PeekEntry(A0451960)` 查看当前描述符。普通帧进入下列代码；EOS/PAUSE 等特殊长度有各自早退路径，不计作分段边界：

1. `A042D398..A042D3A0` 读取描述符 `+0x10`，仅等于 1 时跳到 limit 检查；其它 raw type 直接进入 sample writer `A042CE28`。
2. `A042D3F4` 调用 `AmpFormat_CheckLimit(A03E835C)`。
3. 返回 2（size）或 3（time）时，`A042D400..A042D41C` 将轨道 `+0x20` DTS 写成 `FFFFFFFFFFFFFFFF`，保留返回码并跳到函数尾。此路径没有 sample writer、索引更新、`AmpMuxer_UpdateTrack(A0440948)` 或 `AmpFifo_RemoveEntry(A0451C94)` 调用。
4. 只有返回 0 才继续同步帧索引、参数集检查和 sample writer；普通非 paired 帧在写入完成后才更新轨道并移除一个 FIFO entry。paired 路径具有另外的 peek/write/remove 分支，本轮没有执行其 IO。

因此，在这个函数范围内，触发切段的同步帧仍位于 FIFO 当前项，未进入旧 MP4。后续 `IsoMux_Process`、`AmpMuxer_OnMovieEvent(A0443720)` 和 `AmpMuxer_OnPipeLimit(A0442674)` 将该结果连接到上一报告的 event 3 切文件流程。`OnPipeLimit` 先 `RestoreDTS(A04404D8)`，以轨道 `+0x28` 恢复被置为哨兵的 `+0x20`，再处理其它 format、调用分段回调。不能绕过该状态序列直接调用回调。

8 组原始 gate 片段覆盖 raw type `0/1/2/3/4/8/FE/FF`；没有把其它 type 擅自解释成 I/P/B。另 6 组从该 gate 执行到真实 `CheckLimit` 及其返回分支，覆盖两种 timescale、上限前一 tick/恰好上限/后一 tick，确认描述符内存未变及边界时 DTS 哨兵。它们从已完成 peek 的位置进入，**并没有执行真实 FIFO 或观察编码生产者**。

`type=1` 是原厂 mux 使用的同步/随机访问分类。已有生产者审计把它追到 DSP 事件 low bits，但当前没有真实描述符和 NAL 字节的共同捕获，不能直接宣称每个 type 1 都已经验证为 NAL type 5 IDR，也不能把只看 gate 的测试当作真实连续分段。

## 六十秒是等待同步帧越过阈值，非任意帧硬切

对当前 default video track，完整 `CheckLimit` 采用：

```text
boundary = track.origin18 + ceil(duration_ms * track.timescale04 / 1000)
track.DTS20 >= boundary → return 3
```

36 组完整原函数执行覆盖 timescale `90000/30000/48000/44100`，duration `1/1001/60000 ms`，阈值前/中/后，并使用超过 u32 的 origin，实际执行默认轨选择与 Thumb u64 除法。

若当前轨道不是 default track，只有 default DTS 已为全 1 哨兵且当前 DTS 不小于 default 保存的 `+0x28` 时，才返回 time-limit。12 组原函数执行覆盖 secondary raw track type 1/2、default 已结束/未结束及阈值三侧。`IsoMux_ProcessAudio(A043173C)` 对每个普通 AAC 描述符调用相同 helper，并在 return 2/3 时同样早退，写出和 RemoveEntry 在后；这为音频跟随视频分段边界提供静态证据。

这些算术与分支支持“跨轨按保存 DTS 边界排空，再切文件”的机制。具体被保存的 DTS 与 descriptor PTS、重排序、次码流边界及实际 AAC 采样偏移仍需共同运行轨迹；尚无无缝音视频证明。60 秒限值又只在视频 type 1 时检查，实际段长会受同步帧间距影响，当前不能承诺精确 60.000 秒或固定最大延迟。

## 新文件不会直接沿用复制得到的 SPS/PPS 缓存

上一报告已证明 `CopyMovieInfo` 复制 `[0x50,0x708)`，包含视频额外 metadata 区域。但是真实 `AmpMp4Mux_Open` 调用 `IsoMux_Open(A0435A18)` 后：

- movie 类型 1 时，`A0435A50` 选择 `movie+0x338`；`A0435A94` 设置长度 `0x338`，`A0435AA0` 调用实际 Thumb memset，清零 `[movie+0x338,movie+0x670)`。
- 第 i 个视频参数结构位于 `movie+0x350+i*0xC0`。其中 SPS/PPS 长度为 `+0xB8/+0xBA`，字节缓存起点为 `+0/+0x40`。这些字段属于上述被清零区域。
- 下一段视频处理时，type 1 且任一长度为零，会经 `A042D488..A042D4C0` 调用 `AmpH264_ParseFrame(A03EF858)`，从当前 payload/ring 提取 NAL 7/8 到对应缓存。该 helper 使用实际环形地址加减及按 NAL type 分支；这不是旧报告中 stream→FIFO 的反向输入链。

一组实际 `IsoMux_Open` 前缀执行包含默认轨 helper 及真正 memset，并在 RTC/stream/index IO 前停止，证明被清零范围精确为 `[0x338,0x670)`、其余 movie 字节保留。**复制结构并不等于新段已经持有可用参数集。**

还发现正返回值不足以证明参数集齐全：`AmpH264_ParseFrame` 遇到 slice NAL 的早退路径不检查 SPS/PPS 长度。4 组完整原 helper 执行使用明确标为合成、不可声称可解码的 NAL 1/5 小输入，分别位于连续 ring 和跨尾回绕位置；均返回输入长度 10，同时 SPS/PPS 长度保持为零。没有 helper 桩、没有真实编解码。此例是原始指令可达行为，说明未来适配层须独立检查参数集长度及内容，不能仅依赖 parser 非负返回。

本轮尚未证明原厂硬件在每个分段候选 type 1 payload 中重复 SPS/PPS；原片 MP4 中存在 avcC 参数集也不能证明后续编码 FIFO 每个同步帧都带参数集。不能先删除参数集缓存重建逻辑，也不能在未恢复容量、对象生命周期与码流身份的情况下直接把缓存指针跨段复用。

## 下一步与剩余合同

已有证据把“是否在非同步帧随机切段”缩小为原厂同步帧前的确定 gate，也确认需要验证每段首帧的参数集重建。下一步最有价值的是从普通分段原厂运行中同时关联 boundary descriptor type/PTS/NAL、FIFO peek/remove、format close/open 和新 MP4 首个样本；在可靠原生观测闭环建立前继续追 close/trim 的间接调用与缓存所有权。

当前没有完整执行 master-limit callback、close/trim、次码流切换、FIFO、文件 IO 或硬件编码器。只能证明 `ProcessVideo` 内部的 return-before-consume；完整 close/open 间接闭包是否保留该项仍待验证。参数集/AAC 配置合法性、最终可播放文件、跨段无丢帧/重帧、长时运行、独立会话回收和相机语音/实体快门触发仍未完成。

复现：

```sh
.venv-reverse/bin/python scripts/prerecord-sync-boundary.py
```

后续：[FIFO 所有权的有界离线审计](prerecord-fifo-rollover-ownership.md) 解析了主文件流 vtable、ResetMovie 的真实 peek，以及普通切段 param 3 与 loop 删除 param 2 的区别；完整 close/open 间接闭包仍未闭合。

参数集生产配置见 [H.264 header contract](prerecord-h264-header-contract.md)：恢复到 START command `+0x3A bit5` 的原厂字段名和 36 组构造结果 0，并定位 ORC ENC_START 路径；重复头数值语义及每个 type 1 payload 的 SPS/PPS 仍未证明。
