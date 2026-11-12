# 固定一分钟预录：主机分段回放原型

2026-11-12 增量续推见[真实归档 ring 与成片恢复](prerecord-media-ring-end-to-end.md)：复用本回放器及原门禁，新增闭段通知/进程背压、实际 MP4 custody、pin/eviction、voice/shutter 与失败恢复。真实非零窗口同时发现并修复 MOV 末 AAC duration 裁短；新输出采用共同整秒偏移，保留来源相位。后文 2026-11-10/11 的数值与“先全量分段”的限制描述对应历史默认模式，不能替代新增量路径的回执，也不代表机内预录已完成。

2026-11-10。新增可运行的主机原型，验证最近 60 秒短段窗口、幂等 START、STOP 和无重编码合并。输入是已有本地 H.264 MP4，输出是本机新目录中的 MP4；它不连接相机，不读取 RTOS FIFO，不识别语音，也没有实现相机内预录。

## 2026-11-11 真实原片暴露并修复拼接漂移

真实相机 65 秒普通录像的首轮主机回放虽然能完整解码，32 段压缩包也完全相同，但包级校验发现视频累计漂移约 **315.67 ms**、音频约 **315.13 ms**。失败证据 [real-camera run01](../artifacts/host-prerecord/real-camera-65s-replay-run01/packet-fidelity.json) 完整保留。此前人工样本通过或成片可解码，都不能替代对真实样本的时间保真检查。

原因是旧实现将每段时间归零，concat 默认按容器时长推进；AAC 包跨越视频切点后，容器取较长轨道的时长作为下一段起点，误差逐段累加。现改为：

- MP4 分段保留同一个源时间轴（`reset_timestamps=0`），禁用逐段负时间自动平移；movie timescale 使用 1,000,000，避免各段起点被量化到毫秒。
- ffconcat 每个文件使用 `inpoint 0` 和 `duration 0`，使 concat 不再减去各文件推定起点或累计添加容器时长。这两个参数只控制 demuxer 的时间平移；没有 `outpoint` 或丢弃所选包。
- 输出从所选段读取全部媒体，只对整个选择应用一次共同 `itsoffset`。不直接裁源、不独立移动音频/视频、不重编码，也不以放宽容差解决问题。

修复后的 [真实 run02](../artifacts/host-prerecord/real-camera-65s-replay-run02/manifest.json) 仍选择 32 段、1920 个视频包和 3003 个音频包。未修改的 [保真校验器](../scripts/validate_prerecord_packet_fidelity.py) 全部六项检查通过：所选段逐包等于成片、两轨均为源连续子序列、DTS 严格递增、共同 A/V 偏移，且 **PTS/DTS/duration 相对源文件误差均为零**；见 [run02 包级结果](../artifacts/host-prerecord/real-camera-65s-replay-run02/packet-fidelity.json)。32 段独立视频解码和最终完整音视频解码也通过。这个源是普通录像文件，本轮只读取本地文件，未接触相机。

新增回归专门组合 29.97 fps / 64 帧 GOP、B 帧和 48 kHz / 1024-sample AAC 的非整齐切点，并用 5 秒窗口产生非零选择起点；它调用同一包级校验器，防止只在源文件零起点通过。回放专属测试现在为 9 项通过，包含原 74 秒人工源场景、精确 STOP、失败保留和源文件保护。保留的人工源另生成 [synthetic-timing-fix-run01](../artifacts/host-prerecord/synthetic-timing-fix-run01/manifest.json)：34 段、2040 个视频包、3191 个音频包，相对源的共同偏移为 `-4.004s`，两轨时间戳和 duration 误差均为零；[包级校验](../artifacts/host-prerecord/synthetic-timing-fix-run01/packet-fidelity.json)通过。输入/代码/结果摘要和单测记录见[修复回归索引](../artifacts/host-prerecord/2026-11-11-timestamp-fix-regression.json)。

本修复只解决本地 MP4 分段/拼接时间线，不证明相机 FIFO、共同硬件采集 epoch 或机内 60 秒预录已实现。后文旧示例时长和窗口数值按其原版本保留；不能当作修复后新输出的精确数值。

## 已实现

- [状态模型](../scripts/prerecord_buffer.py)：使用整数微秒维护连续段元数据，淘汰已过期且未提交的段；START 后固定历史清单并继续保存。重复 START 不会变成停止，STOP 为独立动作。
- [FrameDesc payload 消费模型](../scripts/prerecord_frame_desc.py)：`VirtualPayloadConsumer` 对普通帧先复制并校验 descriptor 指定的 payload，再推进 virtual cursor；失败时保留 descriptor，复制结果不受后续编码环复用影响。EOS 长度 `0x00FFFFFF`（兼防御性 raw `0xFFFFFFFF`）先于上限检查和 reader 调用返回独立 `EndOfStream`，不复制、不推进；调用者必须单独处理结束，详见 [返回协议](prerecord-output-contract.md#主机-framedesc-的-eos-返回协议)。
- [媒体回放](../scripts/prerecord_replay.py)：FFmpeg 按关键帧分段，通过状态模型选择历史及后续段，再以 stream copy 合并为单个 MP4。
- 只有新建输出目录可用，拒绝覆盖既有目录；源视频不写入、不删除。淘汰仅删除本轮生成的自有段。
- 每个所选视频段单独完整解码，合并后再次完整解码，通过后才发布 `clip.mp4`。最终解码失败时只保留 `clip.pending.mp4`、自有段和失败 manifest，不发布 `clip.mp4`。manifest 保存源文件/段/成片 SHA-256、窗口、触发、停止、段清单及失败信息。
- 暖机不足一分钟时仍可保存已有历史，但明确返回 `full_window_available=false`，不会宣称已有 60 秒。时间线缺口、重叠、缺失 START 覆盖或未收到覆盖 STOP 的末段会拒绝完成。
- 主机状态模型只维护段边界和触发时间；回放媒体保留统一源时间轴，并在最终输出对所有包统一减去所选窗口起点。包级检查负责验证相对源文件的 PTS/DTS、duration 和共同 A/V 偏移。FrameDesc 的 payload 地址/长度同样只是元数据，主机队列不解引用、不释放固件编码环 payload；真实适配器必须先复制 payload，再推进自己的 virtual cursor。

## 运行

需要本机可运行的 FFmpeg 和 ffprobe。脚本会优先使用仓库内 `.tools/ffmpeg-host/` 的独立二进制；没有该目录时才回退到系统 PATH。也可使用 `YI4K_FFMPEG` 和 `YI4K_FFPROBE` 显式指定工具，避免系统动态库变化把环境问题误报成预录逻辑失败。

```sh
python3 scripts/prerecord_replay.py /absolute/path/source.mp4 \
  --output /absolute/path/new-result \
  --trigger-seconds 65 --stop-seconds 71
```

默认窗口 60 秒、目标段长 2 秒。源视频必须足够长，STOP 须早于文件结束。输入段时间使用 FFmpeg segment-list 的时间轴，并以首段起点归零；它是文件回放时钟，不是曝光时间、相机实时触发或严格的视频 PTS 对齐证明。

STOP 在包含该时刻的段关闭后结束，末尾会多出至下一段边界的内容，实际 `stop_overshoot_us` 写入 manifest。预录从所需历史范围之前的最近段起点开始，因此通常略长于一分钟。目标段长不是硬上限；源文件 GOP 较长时，分段也会更长。首版不重编码截断这些边界。

输出：

```text
new-result/
  manifest.json          来源、状态、时序、段列表与摘要
  selected.ffconcat      所选段清单
  clip.mp4               通过检查的最终 MP4
  segments/              原始生成段与 CSV 时间轴
```

失败保留 manifest 和段，不发布成功状态；应检查失败原因后使用新的输出目录，不自动重试覆盖。

## 本轮验证

[测试](../scripts/tests/test_prerecord_buffer.py)覆盖一分钟保留、重复 START、提前触发、STOP 段尾边界、时间缺口、非关键帧、未覆盖 START、段名不能越出自有 spool、失败输出恢复和源文件保护；完整测试集在独立 FFmpeg 运行时下为 33 项通过。

状态机回归还覆盖 5、15、60 秒三档窗口，确认每档都保留完整关键帧段、达到请求的历史时长、重复 START 不会切换为 STOP，并在段尾停止后只报告实际 overshoot。媒体集成样本为人工 74 秒、29.97 fps H.264（含 B 帧）和 48 kHz AAC。在 65 秒 START、71 秒 STOP 的条件下，核对视频及音频 packet hash 为原文件的连续子序列；合并前后所选压缩包逐个相同，PTS/DTS 相对源文件保持同一固定偏移（容器精度容差 2 ms），各轨 DTS 严格递增，未出现分段累积时移。另测实际段尾精确 STOP，额外尾部为 0。

- [历史媒体回归结果](../artifacts/host-prerecord/test-result.json)及[运行输出](../artifacts/host-prerecord/test-output.txt)；本轮包含段名边界、失败恢复和 EIS gate 的 [33 项完整主机测试结果](../artifacts/host-prerecord/full-test-result.json)及[运行输出](../artifacts/host-prerecord/full-test-output.txt)。
- 2026-11-11 独立复跑 [31 项 prerecord/FrameDesc/trigger 单测](../artifacts/host-prerecord/2026-11-11-python-test-run.json)全部通过；该结果仍是主机合同验证，不替代相机端 FIFO、音视频共同采集起点或真机触发验收。
- [独立审查的包完整性与时序证据](../artifacts/host-prerecord/independent-review.json)。
- 人工源视频与成片的二进制文件未随当前归档保留；对应的 [示例选择清单](../artifacts/host-prerecord/demo/trigger-65-stop-71/selected.ffconcat) 和 [完整 manifest](../artifacts/host-prerecord/demo/trigger-65-stop-71/manifest.json) 仍可审阅。
- 独立复跑结果保留为 [replay-run03 manifest](../artifacts/host-prerecord/replay-run03/manifest.json)；在 bundled FFmpeg/ffprobe 6.1 下得到 `complete`、触发前 `60.929267s`、STOP 段尾 `1.138733s`、34 段及约 `68.125s` 成片。输入源与既有示例相同，未连接相机。
- 触发接缝回归：[trigger-buffer-integration.json](../artifacts/host-prerecord/trigger-buffer-integration.json)。已分类的 camera voice START 与 shutter START 各运行一遍，另一来源随后均被判为 duplicate；两种情况都保留完整 60 秒历史并在 71 秒边界完成 STOP。该结果只证明 typed-event 与 host buffer 的组合，不证明相机语音识别或 GPIO 接线。

复现触发接缝：

```sh
.venv-reverse/bin/python scripts/prerecord_trigger_buffer_integration.py
```

该示例保留约 **60.929 秒**触发前窗口，STOP 后保留约 **1.139 秒**的段尾；共 34 段，成片约 **68.125 秒**。时长差异与容器轨道、B 帧/音频起始时间有关，原始时间值均保留，不把段 CSV 时钟直接改写为视频 PTS。

本机系统 FFmpeg 因动态库缺失无法启动，验证使用 `.tools/ffmpeg-host/` 中独立的 FFmpeg/ffprobe 6.1；来源为 ffbinaries-prebuilt 的 v6.1 macOS release，下载地址和二进制 SHA-256 见该目录的 `acquisition.json`。没有替换系统 FFmpeg，也没有修改 MCP 配置。

```sh
YI4K_FFMPEG=/absolute/path/ffmpeg \
YI4K_FFPROBE=/absolute/path/ffprobe \
python3 -m unittest discover -s scripts/tests -p 'test_prerecord_buffer.py' -v
```

## 距离机内实现的缺口

这份回放器先把完整本地源文件分段，再按事件模拟淘汰。因此它验证的是状态、媒体连续性和封装行为；主机磁盘峰值仍包含完整输入，不证明相机已能持续、受限地写入环形段。实时适配层还需按完成事件交付关闭的段，管理未关闭段、SD 峰值、掉电持久化和错误恢复。

下一步仍要恢复编码输出 FIFO 的安全订阅及所有权、音视频时间基、可重用的 mux 生命周期，并完成最小原生执行关卡。现有 `FeedIdrFrame` 属于输入方向，不能直接作为输出适配器；见[编码流静态契约](prerecord-static-stream-contract.md)。

相机固件识别出的语音事件和快门事件应在同一个相机动作层生成幂等 START。主机侧统一路由契约已实现于 [prerecord_trigger.py](../scripts/prerecord_trigger.py)，规范输入是已送达的 typed `START_RECORDING` 相机事件和快门 press；文本方法只用于离线测试夹具，不代表 App/主机执行识别。重复触发抑制和 reset 已覆盖；相机内识别、模型替换或手机断开后独立运行仍未实现或实测。最终仍以相机独立保存触发前至少 60 秒及触发后录像、输出可直接播放的视频为验收目标。
