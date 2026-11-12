# 原厂 60000ms event3 换段离线验证（2026-11-11）

结论：归档 65 秒真实音视频包在原厂 60000ms 限时下，于第 1800 帧（60.06 秒关键帧）返回状态 3，随后完整执行原厂 Close0 / New / Copy / Rel / Reset / Open。两段共 1920 帧视频均严格解码匹配源素材。发布门禁仍为 **reject**：第一段丢失跨边界 AAC 包 2815，第二段编辑列表造成消费者末包时长少 14.6667ms。

本项是桌面 Unicorn 执行原厂 ARM 指令、使用 RAM 文件和显式 OS/命名模型的归档包回放；不是实机一分钟预录、实时环形缓冲或 SD 写入证明。没有安装回调、修改固件或访问相机。

## 复现与证据

```sh
.venv-reverse/bin/python -u scripts/audit_prerecord_minute_rollover.py \
  --output artifacts/verification/2026-11-11-prerecord-minute-rollover-new-run
```

- 实现：`scripts/audit_prerecord_minute_rollover.py`。
- 成功执行报告：`artifacts/verification/2026-11-11-prerecord-minute-rollover-run02/audit.json`。
- 独立摘要及输出 SHA 复核：同目录 `review.json`。
- 完整命令输出：`artifacts/verification/2026-11-11-prerecord-minute-rollover-run02.log`。
- 两段文件：同目录 `minute-segment-1.mp4`、`minute-segment-2.mp4`。
- 缺失源 AAC 独立保留：同目录 `missing-source-aac-2815.bin`。

源文件 `artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4` SHA256 为 `7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c`。原厂镜像 SHA256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。报告保存全部冻结依赖与执行脚本摘要；`review.json` 已重新读取两段文件并验证摘要及执行脚本一致。

## 已验证行为

1. 使用完整 EventMachine 继承链，先做 8 帧过滤/非过滤 hook 差分；输出文件字节、全部既有事件与日志相同。过滤只避免对无观察点指令读取寄存器，没有替换 ARM 指令。
2. 工厂配置保留两个 movie 槽，所有 ProcessVideo、ProcessAudio、mux 与 event3 的时长参数均为 60000ms。没有沿用旧 200ms 合成限时。
3. 第一段提交 1800 个视频包及 2816 个 AAC 包；第 1800 帧为保留边界，视频处理返回 3，没有推进 FIFO cursor。
4. 原厂 `OnMovieEvent(PIPE,mux,3)` 调用链执行至 Close0、新建、复制、释放、计数重置、ResetMovie 与 Open。新 movie 为 `0x10000708`，split counter 为 2，format open 为 1。
5. 回调前后 FIFO、descriptor、cursor 字节完全相同；边界帧再次提交返回 0，cursor 从 0 变为 1，确认只被消费一次。
6. 最终第二段提交 120 个视频包及 187 个 AAC 包，Close0 返回 0。两段分别有 1800 / 120 帧，FFmpeg `-xerror` 解码 MD5 逐帧匹配归档源对应窗口。全过程没有模拟 index 事件。

## 完整性拒绝原因

| 项目 | 第一段 | 第二段 |
| --- | --- | --- |
| 视频提交/输出 | 1800 / 1800 | 120 / 120 |
| AAC 提交/输出 | 2816 / 2815 | 187 / 187 |
| 保留包 SHA | 全匹配 | 全匹配 |
| PTS / DTS 精确误差 | 均为零 | 均为零 |
| 已保留包 duration | 精确 | 消费者末个 AAC 少 11/750 秒 |
| 全提交 AAC 解码 PCM 比较 | 少 4096 字节，拒绝 | 全匹配 |
| 严格包及时间门禁 | reject | reject |

第一段缺失源 AAC 索引 2815：PTS/DTS 2882560，时基 1/48000，原 duration 为 1024。它从 60.053333… 秒延续到 60.074666… 秒，跨越 60.06 秒视频边界。独立包大小为 346 字节，SHA256 为 `ef96aaeaa91e39baf9abaf7a6edcf1b129482b5522cfb130d86b83413bf4ba5a`。所有提交包保留在比较输入，未删掉跨边界 AAC 来放宽门禁。

第二段源 AAC 2816–3002 全部保留、包 SHA 与连续解码 PCM 全匹配，原始 STTS 的每个 AAC duration 仍为 1024。其音轨 edit list 是 440/30000 秒空编辑及 119680/30000 秒媒体编辑，延迟为 11/750 秒。FFprobe 应用 edit list 后，将末个 AAC（源索引 3002）的消费者 duration 缩短 11/750 秒，PTS/DTS 仍无误差。因此不能只凭 STTS 或成功解码宣称精确时间线通过。

输出摘要：

- 第一段：336632257 字节，SHA256 `84252722f3928926f3f79d9a7617efc5fe2413e3d827d9daa10e41ca20e99c42`。
- 第二段：22430113 字节，SHA256 `93af88608b02ea405b59c3a1ea731ea24236bb7605848de31686200679567a28`。

## RAM 文件模型容量修正与保留失败

首次 `run01` 已证实状态 3 和边界未消费，但原厂 Close0 的 seek 目标为 336593149 字节，超过冻结小样本模型的 256MiB 上限。该次异常属于宿主文件模型容量，不能视为固件失败；`run01/audit.json` 与 `partial-segment-1.mp4` 原样保留。

新脚本独立覆写同一个显式 RAM seek 模型，把宿主文件容量提高到归档源大小加 1MiB；保留 AAPCS 64 位偏移、origin、失败注入、seek 日志和返回值语义。冻结脚本与原厂 ARM 字节均未修改。该修正没有扩大限时参数或弱化包/时间线门禁。`run02` 运行约 90.34 秒是桌面仿真与解码用时，不是相机实时吞吐证明。

## 尚未证明

仍未证明活体编码器数据捕获、回调安装、生产者/消费者并发队列、负载下的一分钟历史保留、实机 SD 持久化、错误恢复、声控/快门绑定或用户可用的完整预录功能。后续需要首先设计跨视频分段点的完整 AAC 包归属及 edit list/消费者时间策略，并保持本次严格拒绝结果为回归基线。
