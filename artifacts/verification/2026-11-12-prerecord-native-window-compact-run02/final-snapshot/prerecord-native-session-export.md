# 原厂 ARM mux 最终会话导出与末包 duration 根因

2026-11-12，已封口的原厂 event3 两段经独立原始 ARM mux 导出成连续 64.064 秒文件，在固定普通消费者上通过全部包 SHA、PTS、DTS、duration 和完整解码门禁。输入包含视频 1920 包及 AAC 3003 包，全部来自此前原厂两段；归档完整源仅在候选文件生成后用于独立比较。

这里通过的是**封口后的独立最终导出会话**。录制阶段的原厂 60000ms event3 行为、第二段消费者拒绝和历史失败记录均保留。不是两段原厂 MP4 直接拼接已兼容，也不是实机一分钟预录完成。

## 剩余 duration 拒绝的原码与消费者证据

[原始 AAC end-assignment 基线](prerecord-minute-aac-schedule.md) 已保留边界 AAC2815；第一段 AAC 为 0–2814，第二段为 2815–3002。第二段共同 source epoch 为 4504/75 秒，首视频在 60.06 秒，因此视频真实延后 1/150 秒，不能分别归零两轨消去这个差值。

新增 [ARM 构造器审计](../scripts/audit_prerecord_native_edit_duration.py)直接执行固定 1.10.7 镜像的 `A0425E18`，构造与归档第二段一致的轨道状态：common clock 240000、起点 1600、终点 962560。原指令生成 30000 movie clock 下的空编辑 200 ticks 和媒体编辑 120120 ticks；没有缩短 STTS 或样本数据。

固定 `ffprobe 6.1-tessus` 的普通读取报告首视频 PTS200、末视频 PTS119319、轨道 media duration120120，末包 duration 为 `120120−119319=801`；忽略 edit 的诊断末 duration 为1001。正确保留空编辑后的总终点应为120320，故剩余差额为200/30000秒。忽略 edit 仅用于读出原始样本表，最终输出验收仍是普通读取。

保留的上游 FFmpeg n6.1 `mov.c` 显示：`st->duration` 取较短媒体/编辑长度；末包无下一索引时使用 `st->duration`，再计算 `next_dts−pkt->dts`。这与实测精确重现同一801-tick结果。上游源码 SHA 不认证本地 tessus 二进制的构建来源，报告分别固定源码、消费者二进制及固件摘要，未声称完成本地消费者二进制的反编译。

根因回执与保留源码：[audit.json](../artifacts/verification/2026-11-12-prerecord-native-timing-root-cause/audit.json)、[mov.c](../artifacts/verification/2026-11-12-prerecord-native-timing-root-cause/ffmpeg-n6.1-mov.c)。REA 工具在本会话不可用，doctor 报告 registration 缺失及运行时不匹配；没有修改客户端配置或安装引擎。本次用既存 Ghidra 导出、固定 ARM 字节和 Unicorn 执行证据，未生成新的 REA Evidence ID。

## 最终导出路径

实现：[export_prerecord_native_session.py](../scripts/export_prerecord_native_session.py)。输入只读两段原厂文件、其封口 SHA 和调用者 source epoch；按原生 STTS 与空编辑恢复共同源时间，逐轨检查连续性、codec epoch 和精确公共端点。视频和 AAC 不做独立时间归零，不按 MP4 file duration 追加，也不补缺包。

之后创建独立原始 ARM factory/index/mux 会话，执行 `Open → ProcessVideo/ProcessAudio → Close0`。压缩 payload 仅从原厂分段导入；H.264 格式适配复用冻结 harness。该**最终导出会话**请求64064ms输出边界，对应已选64.064秒；录制event3基线的60000ms限时没有改动。没有 FFmpeg mux、宿主 ISO 重建、原厂指令补丁、Close1、跳过 Trim 或门禁容差。

两轨恢复为同一零源起点后，原厂最终文件只需零 media-time edit，避免非零空编辑造成固定消费者末 duration裁切。输出普通消费者时间为视频 `i×1001/30000`、duration1001/30000；AAC `i×1024/48000`、duration1024/48000。

## 正负例与独立复核

- [正例](../artifacts/verification/2026-11-12-prerecord-native-session-export-run02/audit.json)：4923次原始 sample处理、全部返回0；原厂Close0返回0，1920视频包/3003AAC包全部SHA与PTS/DTS/duration精确匹配分段输入和源素材。1920源帧MD5及12300288字节连续AAC PCM通过。
- [可播放输出](../artifacts/verification/2026-11-12-prerecord-native-session-export-run02/session.mp4)：359061384字节，SHA256 `158084641d87323c44a70926bc08d6aba51d22145e67ed8ee5aa3d5cc45cd0e6`。
- [缺包负例](../artifacts/verification/2026-11-12-prerecord-native-session-missing-aac-run01/audit.json)：删除AAC2815后，时间连续性预检在原厂Open前拒绝；没有发布文件，原生两段保持原SHA。
- [Close短写负例](../artifacts/verification/2026-11-12-prerecord-native-session-close-failure-run01/audit.json)：提交4923包后注入最终MOOV写短写，原厂Close0返回−12，保留pending文件，不发布；全部原生输入SHA不变。与录制event3回调遇到Close失败断言的历史不同，本例是独立导出会话直接调用Close0返回错误。
- [独立review](../artifacts/verification/2026-11-12-prerecord-native-session-export-review.json)：独立读取实际输入/输出、原始STTS、codec配置与普通消费者包，重新对照原片、全部帧和连续音频；同时核对缺包无Open、短写无发布及pending保留。校验器不导入导出脚本，不生成媒体。

首次run01是导出脚本报告合并时重复字段的主机错误，未进入原始mux，失败目录和日志保留；run02已修复该报告错误。历史原厂第二段普通消费者仍为reject，最终成功不覆盖它。

## 复现

```sh
.venv-reverse/bin/python -u scripts/export_prerecord_native_session.py --output <新的正例目录>
.venv-reverse/bin/python -u scripts/export_prerecord_native_session.py --output <新的缺包目录> --drop-boundary-aac
.venv-reverse/bin/python -u scripts/export_prerecord_native_session.py --output <新的短写目录> --fail-close
.venv-reverse/bin/python scripts/verify_prerecord_native_session_export.py \
  --positive <正例目录> --missing <缺包目录> --close-failure <短写目录> --output <新的review.json>
```

仍只支持已有零起点29.97fps H.264 I/P、48kHz stereo AAC归档和精确64.064秒公共端点；没有任意触发窗口、真实FIFO lookahead并发、callback安装、主编码器/DMA、实体SD吞吐或掉电持久化证明。source epoch仍依赖调用者封口回执，MP4不能自行认证它。本轮没有设备访问、固件部署、相机状态变化、共享SDK生产文件或Android生产文件改动。

后续的[非零触发窗口候选](prerecord-native-window-export.md)独立保留了 START63/STOP64 的测试：原厂指令加显式公共起点/MVHD调用者适配、保留约0.923秒起始空白，普通消费者严格包时间和完整解码通过；未改写本页零起点历史，也未把任意窗口或真实相机验收标为完成。

后续兼容性发现：本页历史原生fixture的caller未填写video track宽高，AVC1/TKHD序列化尺寸为0。固定FFmpeg从SPS推断尺寸仍通过本页包/解码gate；AVFoundation只枚举音轨，不能把旧结果泛化为普通播放器均支持。[紧凑窗口后续](prerecord-native-window-compact.md)从封口SPS正确配置轨道几何并分别记录FFmpeg8、6.1与AVFoundation消费者行为。本页历史JSON与旧source/doc pins不改写，旧pin属于当时快照。
