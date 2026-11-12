# 真实归档编码包的增量 ring 与成片恢复（2026-11-12）

本轮直接扩展现有 [`prerecord_replay.py`](../scripts/prerecord_replay.py)、`PreRecordBuffer` 和 publication gate，将真实普通录像的编码包送入按闭段通知驱动的 host ring，再生成可播放 MP4。没有另建合成 packet 模拟来代替成片验收。

输入为已归档的 `YDXJ0165.MP4`，SHA256 `7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c`。源文件只读，H.264/AAC 均使用 stream copy，不重编码。START 注入在来源时间 63 秒，STOP 在 64 秒；每次都要求触发前至少 60 秒，并保留原 GOP 的段尾 overshoot。

## 组合链路

1. FFmpeg `-re` 逐步读取本地归档，只在 segment 已关闭后向 CSV pipe 发出交付通知。消费者在通知到达后用 POSIX `SIGSTOP` 暂停 producer，完成当前段处理后 `SIGCONT`，不再预先生成整条录像的所有段。
2. [`ClosedMediaStore`](../scripts/prerecord_media_store.py) 为实际关闭的 MP4 做 `fsync`、父目录同步、独立句柄完整 SHA256 读回和 JSON custody receipt。现有 `PreRecordBuffer` 决定 60 秒淘汰；store 检查回执后才删除自己拥有的过期段。
3. 复用现有 typed camera voice START / shutter press 路由。START 固定历史段的 pin，之后另一个来源的 START 为 duplicate；已 pin 的文件不能淘汰。
4. 复用原先独立视频段解码、整体 A/V 解码、压缩包 SHA 顺序、源连续子序列、PTS/DTS/duration、共同音视频时间偏移 publication gate。全部通过后才能将 pending 文件发布为 `clip.mp4`。
5. 注入“门禁通过后、发布前中断”，只保留 pending、选中段、receipt 和失败 manifest。恢复仅从这些保留段的校验副本重新封装，再重复完整解码和 publication gate；原片仅作为候选构建完成后的验收 oracle，不作为恢复 payload 来源。改变一个保留段时，恢复必须拒绝，不能发布。

## 真实非零窗口发现的问题

首轮 [run01 拒绝回执](../artifacts/verification/2026-11-12-prerecord-media-ring-run01/voice-interrupted/prepublish-packet-fidelity.json) 中，1856 个视频包、2902 个 AAC 包的字节和连续顺序都正确，但小数秒归零的 MOV edit list 将最后一包 AAC duration 从源 `1024/48000` 裁成 `102/48000`。原 gate 拒绝，没有发布成片，也没有放宽 2ms 容差。

实现改为只对两轨共同减去所选起点之前的整秒，保留不足一秒的来源相位。该素材共同偏移精确为 −2 秒，首视频保留约 0.135467 秒时间相位。这样避免以逐轨移位或隐藏音视频延迟来归零；真实窗口回归要求所有包的 PTS/DTS offset spread 和 duration error 都精确为零。

## 验证入口

[`validate_prerecord_media_ring.py`](../scripts/validate_prerecord_media_ring.py) 同时执行 voice 中断/恢复、保留段篡改拒绝、shutter 独立增量回放，并要求两种成功输出的 MP4 SHA 相同。

```sh
python3 scripts/validate_prerecord_media_ring.py \
  --output artifacts/verification/new-prerecord-media-ring-run
```

相关测试为现有 replay 的 12 项、实际文件保管的 5 项，以及真实非零 60 秒窗口的 1 项专门回归。

## 2026-11-12 实测结果

最终 [run02 回执](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/validation.json) 为 `pass_archived_media_incremental_ring_publication_and_recovery`，三项实际场景通过：voice 中断后恢复、改变保留段拒绝恢复、shutter 独立增量回放并发布。实施文件的 SHA256 与回执逐项核对一致；[18 项测试回执](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/regression.json)也已固定测试来源。

两次真实媒体交付均淘汰 1 个过期段，触发后 pin 31 段；保留触发前 **60.864533 秒**、触发后 **1.064 秒**，其中 STOP 后的段尾 overshoot 为 0.064 秒。checkpoint 观察到的 segment 文件总量峰值为 348,664,986 bytes，低于 536,870,912 bytes 预算。该数不包括成片和恢复副本，不代表持续时间无限的硬配额。

[恢复成片](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/voice-recovered/clip.mp4)与 [shutter 成片](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/shutter/clip.mp4)均可完整音视频解码，实际文件均为 347,836,390 bytes，SHA256 相同：`9b9cac86840a00e9781ce9a2428eb4ac91f4474c6d93feebd1b02d4b48ed505c`。

[独立成片门禁](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/shutter/independent-packet-fidelity.json)核对视频 1856 包、AAC 2902 包，分别为源索引 64、101 开始的完整连续子序列。所选段与成片压缩字节逐包相同；两轨相对原片的共同 PTS/DTS 偏移为精确 −2 秒，各轨 offset spread 和最大 duration error 都为 **0**，而非仅落入容差。

[voice 失败 manifest](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/voice-interrupted/manifest.json)仅保留 pending 和恢复材料，没有 `clip.mp4`；[恢复回执](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/voice-recovered/recovery.json)说明 payload 只来自保留段。[篡改负例](../artifacts/verification/2026-11-12-prerecord-media-ring-run02/tampered-recovery-rejected/recovery.json)状态为 `rejected_retained_for_recovery`，没有发布成片。上述恢复不依赖从原片补回丢失 payload。

## 证明范围

这里的“增量”是本地普通录像文件的有节奏回放；voice/shutter 是已分类的 host 注入事件，没有识别语音或访问物理按键。512MiB 容量在闭段交付/checkpoint 观察，包含 producer 当前打开的 MP4，但不是持续的块设备配额。触发后内容、待发布成片和恢复副本另占磁盘；元数据与历史 pin 不意味着无限持续录制有固定总容量。

JSON custody receipt 只证明关闭的 MP4 文件完整性，不能代替 C packet spool/source seal 的独立 source ledger、RTOS callback 静止或共同硬件 epoch。SIGSTOP 背压不能证明相机 producer 吞吐或 RTOS 调度。未写相机固件、RAM、启动区，未改变相机运行状态；没有实体 SD、拔卡/掉电、满卡/坏块或真机实时一分钟预录证据。原厂 event3 两段消费者的历史 duration 门禁拒绝仍保留，当前成片使用 FFmpeg 的 host 封装链。
