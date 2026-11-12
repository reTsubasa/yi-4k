# 预录分段合同 manifest（离线证据）

本页对应 `scripts/prerecord-segment-manifest.py` 与
`artifacts/device/2026-11-10-prerecord/prerecord-segment-manifest.json`。
脚本只读取已有审计 JSON 和固定的 `rtos-window.bin`，用于把分段设计的已知事实、可复用候选和未闭合边界固定成可复现的清单；没有连接相机、写固件或写设备 RAM。

运行：

```sh
python3 scripts/prerecord-segment-manifest.py
```

固定镜像 SHA-256 为
`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。本次 manifest 校验了同步边界 67 例、音频配置 10 例、音频生产者 15 例、会话 rollover 21 例以及 9 个输出合同检查；每个输入审计文件的 SHA-256 也写入 manifest。

## 可以复用的静态机制

- 普通视频 `ProcessVideo` 只对 `type=1` 同步候选在写出前执行时长/大小界限检查。达到界限时写 DTS 结束标记，保留当前 descriptor，不写出或移除该帧。
- 新 `IsoMux_Open` 的已执行前缀清空 movie `0x338..0x670`，其中包含视频参数集缓存；下一段必须重新从同步 payload 检查 NAL7/NAL8，再确认 NAL5/IDR。
- 普通 MP4 的 event-3 生命周期是同一 mux pipe 内关闭旧 format/stream、复制 movie 信息、重置计数和 PTS、打开新 stream/format 的候选路径。它可以作为单 writer 分段适配的研究入口。
- 主、次轨道共享静态 mux limit helper；次轨道的边界判断要求默认轨道已经结束。音频配置审计的三个 selector 都把 48000 传入 create config，典型音频帧为 1024 samples。

上述内容是固件字节和合成 RAM 的静态/前缀仿真结果，不能当作生产者已经重启、真实 payload 已跨段交付或硬件已经按预期运行。

## 仍未闭合的播放边界

parser 对只含 slice NAL 的四个构造用例返回 10，但 SPS/PPS 长度仍为 0。这说明“解析成功”不能替代参数集完整性检查；manifest 因而把 `sps_pps_complete` 和 `playable_output` 固定为 false。

当前音频证据是配置与 PTS 算式，不是每个新文件的 AAC `AudioSpecificConfig` 字节或实际采集频率。音频输入可能在 liveview 阶段启动，尚未证明音频与视频共用采集 epoch，也未捕获 A/V 首样本时间戳。因此 `aac_config_continuity` 与 `av_sync_continuity` 仍为 false。

EventRecord 的普通录制状态回调、并发第二 writer、virtual FIFO 删除后的 callback quiescence、producer 跨段重启和最终文件可播放性都没有被证明。要闭合这些边界，必须在允许的真机测试中记录 descriptor/NAL 字节、FIFO 游标、close/open 返回值、首帧 SPS/PPS、AAC 配置、A/V 时间戳，并用独立 MP4/H.264/AAC 检查器打开每个结果文件。
