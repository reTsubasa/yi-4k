# 预录主机回放的发布前保真门禁

2026-11-11。仅验证宿主本地 MP4，没有相机访问、固件执行、真实语音或快门接入。

`scripts/prerecord_replay.py` 现在在临时成片完整解码后、发布 `clip.mp4` 前，强制运行 `validate_prerecord_packet_fidelity.py`。解码通过只证明媒体可解码；门禁同时检查源文件/选段/输出摘要、压缩包连续性和顺序、PTS/DTS/时长、DTS 单调，以及音视频共同时间偏移。容差仍为 2 ms。

发布前保存 `prepublish-manifest.json`，其状态为 `validating`，指向 `clip.pending.mp4`；再保存 `prepublish-packet-fidelity.json`。主 manifest 记录两个文件的 SHA-256 和通过状态。保真失败或探测异常会将主 manifest 标为 `failed`，保留 pending、所选分段、来源快照及拒绝结果，不发布 `clip.mp4`。检查通过后再次确认 pending 摘要，才完成状态机并改名。

成功发布后 pending 路径已改名；快照作为发布前事实保留，不改写为最终路径。可核验快照摘要与门禁结果的 `manifest_sha256`，以及门禁 `clip_sha256` 与最终 `clip.mp4`/主 manifest 的摘要；最终成片另用默认 `published` 模式重新验证。失败样例仍保留 pending，可直接用 `--phase prepublish` 复核快照。当前没有自动恢复发布或重试。

源文件必须有一条 H.264 视频，可无音频。视频-only 仍须满足包和时间线检查；结果显式记录 `track_types=["video"]` 与 `common_audio_video_offset_applicable=false`。若源文件有音频，选段和输出均须有相同轨道，音视频共同偏移检查保持强制。

## 无 B 帧 AAC 首包修复

从零起点选择的无 B 帧 H.264/AAC，首个 AAC 包位于 `PTS=-1024/48000`。MOV 默认 `advanced_editlist=1` 将它标记为 DISCARD，FFmpeg streamcopy 会丢弃该包。旧路径的严格门禁已能拒绝该输出；修复在每个内部生成的 concat 文件项增加 `option advanced_editlist 0`，保留编辑列表的共同时间偏移及 skip-samples 元数据，同时避免丢弃 priming 包。没有使用会改变各段时间线的 `ignore_editlist=1`。

concat 的 file option 要求 `safe=0`；文件清单仍只由程序从已校验、自有 spool 的片段名生成，额外用 `protocol_whitelist=file` 限制读取协议。保真要求、2 ms 容差及发布前失败关闭不变。

本次新证据全部使用新目录，旧失败和已通过证据未覆盖：

- `aac-priming-old-reproduction-run01/`：同一旧源重现首包缺失，仅选段包顺序/数量检查失败，375 对 376 个 AAC 包。
- `aac-priming-same-source-fixed-run01/`：同源修复后 376 个 AAC 包全部保留，首个压缩包摘要与源相同，视频/音频 PTS、DTS、duration 误差均为 0，六项门禁及最终成片检查全通过。
- `real-camera-65s-aac-priming-fix-run01/`：已有真实 65 秒素材回放，触发 62 秒、停止 64 秒；完整历史 62 秒，1920 个视频包、3003 个音频包，视频和音频时间线误差均为 0，门禁及最终成片检查通过。
- `synthetic-aac-priming-fix-run01/`：非零选择起点的 B 帧 A/V 素材，触发 65 秒、停止 71 秒；视频/音频误差均为 0，门禁及最终成片检查通过。
- `publication-gate-aac-priming-audit-run01/`：无 B 帧源的同源正对照通过。实际 FFmpeg remux 将音频延后 100 ms 的负对照可完整解码；所有压缩包仍在，轨道内时间线误差为 0，仅共同 A/V 偏移检查失败。没有 `clip.mp4`，pending、分段及失败快照完整保留，11 项审计断言全通过。
- 最终 `test_prerecord_buffer.py` 共 12 项通过，含新增无 B 帧、零起点 AAC priming 回归；原 video-only、非零选择、完整一分钟、解码失败和 100 ms 偏移负对照全部保留。

以上目录均位于 `artifacts/host-prerecord/`。最终源码摘要和回归索引见 `2026-11-11-aac-priming-fix-regression.json`。

## 已保留的验证证据

- `artifacts/host-prerecord/real-camera-65s-publication-gate-run01/`：已有真实 65 秒普通录像在本机回放，触发 62 秒、停止 64 秒；完整一分钟历史，门禁通过并发布；最终成片再次独立验证通过。旧时间戳失败 run01 和修复 run02 未改动。
- `artifacts/host-prerecord/synthetic-publication-gate-run01/`：74 秒合成 A/V 素材，触发 65 秒、停止 71 秒，非零选择起点；新门禁与最终成片验证通过。
- `artifacts/host-prerecord/publication-gate-audit-run01/`：同一合成源的正对照正常发布，负对照在实际 FFmpeg 重封装后将音频延后 100 ms。负对照完整解码通过，所有压缩包及轨道内时间线检查通过，仅共同 A/V 偏移失败；门禁拒绝，未出现 `clip.mp4`，pending、分段、失败 manifest 和来源快照全部保留。`audit.json` 的 11 项断言全通过。
- `scripts/tests/test_prerecord_buffer.py`：11 项回归通过，覆盖旧 9 项、video-only 发布及可解码的真实音频偏移拒绝。

复现命令（输出必须换成不存在的新目录）：

```sh
python3 -m unittest discover -s scripts/tests -p test_prerecord_buffer.py -v
python3 scripts/audit_prerecord_publication_gate.py --output /tmp/yi4k-new-publication-audit
python3 scripts/validate_prerecord_packet_fidelity.py artifacts/host-prerecord/publication-gate-audit-run01/audio-shift-negative/prepublish-manifest.json --phase prepublish --output /tmp/yi4k-new-negative-verification.json
```

最后一条应退出 1，结果 `passed=false`，只有共同音视频偏移检查为 false。

## 边界与额外发现

这不是相机独立预录完成证据，不能证明 RTOS payload 所有权、硬件共同采集 epoch、callback 安装、SD spool 或真实触发。

从零起点选择丢 AAC priming 包已按上节修复；最初混合了首包缺失与音频偏移的失败调查仍保留在 `publication-gate-negative-investigation-run01/`，不把它当作仅音频偏移的正式负对照。

扩展检查发现另一种工具限制，保留在 `aac-priming-nonzero-investigation-run01/`：无 B 帧、非零起点选择后，音频首 PTS 为正 `512/48000` 秒，FFmpeg 6.1 `ffprobe` 将最后一个 AAC 包的 duration 报为 512 ticks，而源对应包为 1024。直接解析源、选段和输出 MP4 的 STTS，确认这 375 个音频样本的 duration 全部仍为 1024，最后一个样本也为 1024，压缩包摘要、PTS/DTS 和源对应关系均保持一致。这是工具对末包时长的解释差异，当前证据没有表明实际 STTS 或压缩数据损坏。

该行为可由公开 FFmpeg 6.1 `libavformat/mov.c` 9017–9023 行解释：没有 CTTS 的最后一包用 `st->duration - pkt->dts` 推断时长，未计正起点；相关原码摘要/片段保留在 `ffmpeg-6.1-duration-inference.json`。`inspect_timing_tables.py` 和 `timing-table-proof.json` 提供独立于 ffprobe 的实际 STTS/MDHD 核查，三个直接表格对比均通过。

本轮未修改 FFmpeg/ffprobe 依赖或保真验证器，也未添加额外时间偏移、修改元数据来迎合探测器。因此该特定无 B 帧、非零起点样例仍被现有门禁拒绝，主 manifest 为 `failed`，pending 和分段保留，没有成功成片；它不代表所有非零起点失败，既有 B 帧非零起点样例继续通过。后续可升级探测工具后另做同源复核，不能提前将其视为通过。
