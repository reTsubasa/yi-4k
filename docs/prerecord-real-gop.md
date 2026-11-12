# 真实 I/P GOP 与 AAC 的原厂封装审计

已用归档相机原片 `YDXJ0161.MP4` 的前两个 GOP，经原始 movie factory 和 MP4 mux 分别生成两段文件。视频及 AAC 包哈希与选择的原始包逐项相同，全部视频帧解码与源文件对应帧一致，音频也完整解码。

**严格交付门禁仍拒绝。** 两种配置的第二段都未通过 ffprobe 消费者时间线检查；当前选包策略还丢弃了跨 GOP 边界的 AAC 第 12 包，不能把它称为连续两段无缺无重成功。240000 Hz 只是离线调用方配置实验，没有消除所有失败。

```sh
.venv-reverse/bin/python scripts/audit_prerecord_real_gop.py --output /tmp/yi4k-real-gop-independent
```

输出为 `audit.json`、四个 MP4、各自的 probe JSON，以及两个仅供独立音频解码基准使用的 ADTS 文件。ADTS 没有进入原厂目标 MP4 路径。

## 原片与输入范围

原片路径为 `artifacts/device/2026-11-11-record-probe-01/session-media/YDXJ0161.MP4`，SHA-256 为 `862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d`。它来自普通录像，不是原始编码器 FIFO 抓取。

实际 slice header 分类是 **11 个 I、70 个 P，零个 B**。虽然 ffprobe 的 SPS 字段 `has_b_frames` 为 4，本轮不会用它声称存在真实 B 帧。前 16 帧解码哈希各不相同，也不再使用重复 IDR 作为连续画面。

| 段 | 视频时间窗 | 源视频序号 | 源音频序号 | 首音频相对窗口起点 |
| --- | --- | --- | --- | --- |
| 1 | `[0,8008)/30000` 秒 | 0–7，1 I + 7 P | 0–11，12 AAC 包 | 0 |
| 2 | `[8008,16016)/30000` 秒 | 8–15，1 I + 7 P | 13–24，12 AAC 包 | `2496/240000` 秒，即 **10.4 ms** |

AAC 以“整个包均在窗口内”为条件选择。源包 12 的范围是 `[12288,13312)/48000` 秒，即约 `[0.256,0.277333)` 秒，横跨 GOP 分界 `8008/30000≈0.266933` 秒。因此它不属于任一完整包窗口，被明确排除。两段音频之间有一个 1024-sample 包的缺口；视频连续不代表音频连续。

报告 `audio_boundary.continuous_audio_coverage_gate` 固定为 `reject`，保留被排除包的 offset、size、PTS、DTS 和 SHA-256。另有 AAC 25 起于最终窗口结束前、结束于窗口外，也因相同完整包策略排除；报告将它列为最终端点的 partial packet，与段间缺失 AAC 12 分开记录。这里只能证明选中包本身无损，不能证明整段音频无损。

## 原始执行与共同起点

每种配置在同一个 movie 地址、MemIdx 与 mux 对象上执行两段，沿用冻结 factory 的原始 `FormatInit / NewMovieInfo / InitMovieInfo / Mp4Mux_Create / Open / Close / RelMovieInfo`。原始 `Add/Commit/Flush/Read` 同样实际执行，读回逐项等于 Add 输入，不使用模拟索引成功桩。

调用方用原片包时间构造初始状态，经原始 `InitMovieInfo` 得到共同 240000 Hz 内部时基。第二段起始 DTS 为 `[64064,66560]`。原始 `ResetMovie A01F3124` 执行真实 FIFO Peek，并对两轨减去同一个 64064，结果为 `[0,2496]`。队首描述符和 FIFO 游标保持不变；没有分别把音视频归零。

这些初始 DTS、video origin、配置毫秒值和 FrameDesc 映射来自离线调用方输入，并非相机运行期观测。本轮为 M=1 的真实 P 数据选择 descriptor type=3；归档 MP4 不包含真实 FrameDesc，不能反过来证明相机 P 帧枚举或实时编码器绑定。

视频从原片 AVC length-prefixed 包转换为 Annex B，段首插入同一原片 avcC 的 SPS/PPS。原始视频 writer 再生成 AVC 包，输出包与原片包括 padding 在内逐字节哈希相同。AAC 原样写入；48 kHz、双声道和 ASC `11 90 00 00 00` 均显式来自原片配置。

## 精度观测：容器与消费者都记录，门禁不放宽

原始 mux 输出的 **movie timescale 实际为 30000 Hz**，两种实验都一样。第二段原始 audio `elst` empty edit 是 **312/30000 秒，正好 10.4 ms**，正常 media edit 是 7680/30000 秒，STTS 有 12 个完整 AAC 时长。

这修正了先前探索中“原厂 edit list 整数转换直接丢失 1/240000 秒”的推测：原始 `elst` 的整数值恰好可精确表示本例差值。默认 ffprobe 应用 edit 后，将该延迟映射到 1/48000 秒音轨时间基，得到整数 499 ticks，才出现这里观测的量化。报告保留原始 `ELST/STTS` 十六进制和解码的整数值，结论不依赖四舍五入后的时间字符串。

| 配置 | 第二段 ffprobe 首音频 PTS | 最后 AAC 报告 duration | 严格消费者时间线门禁 |
| --- | --- | --- | --- |
| 默认 48000 音轨时基、1024 ticks/AAC | `499/48000` 秒，早 `1/240000` 秒（约 4.167 μs） | 525 ticks，源应为 1024 | **reject**，12 个音频包 PTS/DTS 不等，末包 duration 也不等 |
| 离线 240000 音轨时基、5120 ticks/AAC | `2496/240000` 秒，精确 10.4 ms | 2624 ticks，源应为 5120 | **reject**，末包 duration 不等 |

原始 STTS 中末包仍是完整 1024/48000 秒或等价 5120/240000 秒。ffprobe 设置 `-ignore_editlist 1` 时也报告全部 12 个完整时长；应用 edit 后则呈现上述末包缩短。这里只记录该消费者行为，不据此推断所有播放器都会裁音，也不调整容差来判通过。

240000 实验只更改离线调用方的音轨 mux clock 和对应 sample duration，AAC 采样率字段仍是 48000。它不是相机当前支持能力、通用解决方案或已经完成的真实 encoder 配置绑定。两种配置的首段都通过严格时间线检查，第二段都保持失败；报告顶层明确给出两个 `reject`。

## 验证内容

- 每个输出 packet 按文件 offset/size 取实际字节，与相应源 packet 比较 SHA-256；每段 8 视频、12 音频，所有选中包哈希相同。
- 对每包 PTS、DTS、duration 使用有理数精确比较，输出每项误差；两个默认/实验第二段失败均为预期保留结果。
- 直接解析原始 MP4 的 MVHD、MDHD、ELST、STTS，确认原始容器延迟和 STTS 时长，与 ffprobe 消费者结果同时保留。
- ffmpeg `-xerror` 完整解码。两段各 8 个视频帧哈希精确等于源视频对应 8 帧；AAC 输出各 49152 字节 PCM，逐字等于同一组选中 raw AAC 包独立包装 ADTS 后的新 decoder 基准。

第二段 AAC 基准从包 13 启动新 decoder；该验证不保证与从源包 0 一直连续解码到包 13 的 overlap/priming 状态相同。没有隐去缺包，也不把 PCM 解码成功等同于连续音频或完全无剪切接缝。

## 剩余工作

下一步可单独尝试把跨边界 AAC 12 完整归前段，再核对原厂正常 Close 是否 Trim 掉它，并检查两段合计包无缺无重。当前版本不包含这项实验，也不把未知关闭 mode 当成安全设备接口。

冻结 native、factory 和 timeline 脚本均未修改。新审计固定导入脚本哈希、固件和相关原始函数哈希。没有连接相机，没有验证真实 SD、DMA、一分钟缓存、实时性能、语音或快门触发。

主线程在冻结脚本 `a2b0835d771a1775bf8a60f8ee96c2d110fe7c16e899a855f793f7939ae7f12f` 上[独立复跑四场景](../artifacts/verification/2026-11-11-real-gop-independent-run01/audit.json)完成，选中包和解码比对成立；默认/实验第二段消费者时间线及完整音频覆盖仍为拒绝，不提升为连续成片验收。
