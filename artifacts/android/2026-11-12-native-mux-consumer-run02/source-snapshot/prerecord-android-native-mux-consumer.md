# Android 原厂封装紧凑窗口消费者验证

2026-11-12，独占冷启动的 AOSP Android 34 arm64 模拟器对 geometry 补全后的紧凑 START63/STOP64 原厂 ARM 封装文件完成全部样本读取与全段解码。**Android 可提供字段通过，不等于 DTS/逐包 duration 全时间门禁或真实手机播放验收。**

输出使用 [geometry 补全紧凑候选](../artifacts/verification/2026-11-12-prerecord-native-window-compact-run02/compact.ffmpeg8-reviewed.mp4)，343,127,606 bytes，SHA256 `cffc226da6e496cd6df8d4294c1d295c4bdefe7ece4efe289f597b7b85e3ee5a`。测试实际 push 的早期 `compact-run01/session.pending.mp4` 与最终文件同 SHA；未改动媒体。独立源片为 `YDXJ0165.MP4`，SHA256 `7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c`。

证据：[独立 review](../artifacts/android/2026-11-12-native-mux-consumer-run02/review.json)、[模拟器生命周期](../artifacts/android/2026-11-12-native-mux-consumer-run02/session.json)、[原片平台读取/选段解码](../artifacts/android/2026-11-12-native-mux-consumer-run02/source.json)、[候选平台读取/解码](../artifacts/android/2026-11-12-native-mux-consumer-run02/candidate.json)。

## 实际通过的范围

| 项目 | 视频 | 音频 |
| --- | --- | --- |
| 原片选中索引 | 88–1918 | 137–2999 |
| MediaExtractor 样本数 | 1831 | 2863 |
| 原片选段与候选压缩数据 | 每包 bytes/SHA256 全相同 | 每包 bytes/SHA256 全相同 |
| 候选首 PTS | 13,600 μs | 0 μs |
| 全部 PTS | 源 PTS 减同一 `1096/375` 秒，再投影到整数微秒，逐项相等 | 同左 |
| 系统解码器 | `c2.goldfish.h264.decoder` | `c2.android.aac.decoder` |
| 解码输出 | 1831 张有效1920×1080 YUV420图像 | 2863块、2,931,712采样帧、11,726,848 bytes PCM |
| 独立选段解码比较 | 全部有效像素SHA逐帧相等 | 全部PCM缓冲SHA及拼接PCM SHA相等 |

MediaExtractor 从候选明确读出1920×1080、48kHz stereo、encoder-delay=0、encoder-padding=0。没有发生 AVFoundation 在本fixture中观察到的2112采样裁切。PCM SHA256为 `c54e52309ff674dadd35a2f695e7983450980c13034de65b58379206e7e5d9c2`；不同解码实现可能产生不同PCM，因此这里使用**同一 Android 解码实现**的源/候选比较，不强求它与 FFmpeg PCM SHA相同。

## Oracle 与时间边界

原片解码路径先用 MediaExtractor `advance` 到 video88（IDR）和 AAC137，随后为每轨各创建一个**新的 MediaCodec**，只喂选中的1831/2863包。候选也分别启动新的同实现解码器。音频比较证明选中AAC独立重新解码与候选相同；**没有从原片0连续解码再裁PCM，因此不宣称与连续全程PCM子段逐字节相同**。解码器起始滤波/重叠状态属于这个边界。

MediaExtractor 公共 API不给 DTS、单个样本 duration，也不保留分数微秒。校验器对固定源原片再次使用已固定 ffprobe读取其有理数PTS，只检查其精确整数微秒投影；没有填造 DTS 或以相邻 PTS差推断末包duration。轨道 `durationUs` 是平台给出的媒体时长，此处不据其认定完整 edited presentation endpoint。原始 FFmpeg6.1末duration限制、AVFoundation兼容性限制仍分别保留，未通过改 gate 擦除。

有效YUV哈希逐行取crop范围，并按各plane rowStride/pixelStride去掉padding。音频记录每个解码缓冲大小及SHA，并额外对全部PCM拼接数据计算SHA。所有输出直到明确 EOS，解码 PTS逐项等于同轨Extractor PTS。

## 隔离、失败与复现

本轮使用全新名为 `yi4k-native-mux-api34` 的独占 AVD，明确 serial `emulator-5590`，无快照冷启动；未安装/启动相机控制App。启动后禁用模拟器WiFi与移动数据，仅运行 `app_process` Java/Dex，从 `/data/local/tmp` 读本地MP4。没有摄像头、麦克风、网络、相机API或真实设备访问。runner已停止其启动的模拟器，源/候选与源代码散列核对一致。

首次 run01只因使用不存在的MediaFormat API导致javac失败，未启动模拟器；失败证据保留。run02修正为SDK公开访问方法后实际完成并停止AVD。独立 verifier只读保存结果，不启动任何模拟器或改动媒体。

实现：[Java消费者](../scripts/android-native-mux-consumer/NativeMuxConsumer.java)、[独占runner](../scripts/android-native-mux-consumer/run.py)、[独立校验](../scripts/android-native-mux-consumer/verify.py)。再次运行需明确选择新的独占AVD名称/端口或在核对旧实例已停止后清理原runner创建的AVD；脚本拒绝复用现存目录，避免误操作别人的模拟器。

```sh
python3 scripts/android-native-mux-consumer/verify.py \
  --run artifacts/android/2026-11-12-native-mux-consumer-run02
```

这是平台Extractor/ByteBuffer/Image解码证据，没有Surface/Media3实际界面播放、扬声器输出、实体手机、实时SD预录、相机语音/快门触发或原生部署验收。
