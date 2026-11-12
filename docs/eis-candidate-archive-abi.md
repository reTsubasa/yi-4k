# EIS 候选算法：真实归档资格与原厂双平面接缝

日期：2026-11-12。本轮仅在主机读取已有归档，未连接或写入相机。执行 [audit_eis_candidate_archive.py](../scripts/audit_eis_candidate_archive.py) 的 [回执](../artifacts/verification/2026-11-12-eis-candidate-archive/audit.json) 包含逐文件 SHA-256、真实日志资格检查和九组原厂生成器输出的双平面回读结果。

## 真实输入已有，但不满足候选回放条件

重新解析 `native-log-02/RtosActive.log`，逐项匹配已有 `gyro-events.json`；录像几何阶段保留 48 条 gyro、67 条曝光和 66 条反馈。48 条 gyro 的相邻日志 tick 均为 50（共 47 个间隔），这些是抽样打印，不是 IMU 硬件时间戳或完整采样。日志 tick 的设计尺度为 1 ms，不能转换为每样本真实采集时刻。

同次 `YDXJ0139.MP4` 的 SHA-256 仍为 `1dc7d72892e54dcacaf4c6b032e3ec017237a44dad66d24edb4ba305f98970ee`。本轮使用仓库 `.tools/ffmpeg-host/ffprobe` 重新数帧、`ffmpeg` 完整解码，48 帧、1920×1080，通过且无解码错误。没有对视频施加候选 warp，也没有新增画质比较。

不能把真实日志直接导成候选 dps trace 的原因是：

- 三轴仍是带 level shift 的原值，缺少采样边界上的轴向、偏置和物理灵敏度绑定。减去 32768 不能得到 dps。
- 每 50 ms 的文本抽样缺少高频振动、逐样本序号与采集时刻，插值不能恢复丢失频带。
- 曝光打印原值 16 已截断精度，没有对应的曝光中心、逐行读出和有效帧身份。
- 反馈只重复 `0x105/0x106`，没有与 gyro 历史、warp generation 和编码 PTS 一起记录的单调身份。

因此 `candidate_replay_eligible=false`、`optical_quality_comparison_eligible=false`；同为 48 条 gyro 和 48 帧视频不构成一一映射。没有伪造标定或强行匹配最近时间戳。相关原始边界见 [真实录像日志说明](device-eis-recording-trace.md)。

后续[驱动输入合同](eis-gyro-input-contract.md)已恢复unsigned16减32768的格式及原厂名义131 counts/(°/s)，仍非本机标定；[采样器集成合同](eis-gyro-sampler-contract.md)进一步证实失败旧样本仍入环、相同软件tick可多次入环、printf按上次tick门控，通道步距137中只有132个数据word。它们收窄后续采集要求，没有补回历史日志丢失的样本、传感器时间或视频共同帧锚；本页两项资格仍为false。

## 可落地增量：严格解析原厂生成器输出布局

[eis_stock_mesh_layout.py](../scripts/eis_stock_mesh_layout.py) 加入纯主机双平面适配层：

- scratch 固定两个 `0x1800` 字节平面；元素为 little-endian signed int16。
- descriptor `+30/+31`、`+35/+36` 是 X/Y 列行索引上界，点数必须加一。
- pitch 必须由已验证 profile 显式提供，不由 descriptor 猜测通用规则。
- 主机重打包只接受 stock signed-int16 数值，保存所有非有效点/padding 字节，严格拒绝越界布局、短缓冲、错误点数和数值溢出。

从 [原厂生成范围审计](eis-generator-scope-and-frame-contract.md) 保存的九组 `.planes.bin` 与 `.descriptor.bin` 中回读 18 个平面：scratch 哈希、descriptor、有效值哈希和极值均匹配；重打包逐字节等于原归档，校准场景的非有效点继续保留 `A5`。原始归档没有被改写。

两个实用反例已校验：1920×1080 的 X/Y 是 `31×35` 和 `31×36`、pitch 均为 32；3840×2160 虽有同样点数，pitch 均为 31。候选的单个 `columns×rows` 二维网格不能直接逐点塞入原厂两表。

这九组是 **原始 ARM 代码在合成输入下的输出**，不是本次录像的表 dump，也不是 DSP 锁存后的实际网格。适配层只解决有界的存储视图与不破坏 padding 的主机回读。后续 [坐标合同审计](eis-stock-coordinate-contract.md) 新增 17 组原码场景，确认校准位移的 1/16 坐标精度、旋转量化和限定 1080p profile 的采样位置；实际运行几何变换及 DSP 方向仍未闭合。不能把 Q16.16 截位、缩放或强转 int16 就宣称兼容。当前没有 normalized→stock 转换，也没有设备地址写入或部署器。

## 复现与下一步边界

```sh
.venv-reverse/bin/python scripts/audit_eis_candidate_archive.py \
  --output artifacts/verification/2026-11-12-eis-candidate-archive/audit.json
.venv-reverse/bin/python scripts/audit_eis_candidate_quality.py \
  --output artifacts/verification/2026-11-12-eis-candidate-quality/audit.json
.venv-reverse/bin/python -m unittest scripts.tests.test_eis_candidate_mesh scripts.tests.test_eis_stock_mesh_layout -q
```

现可用适配层读取下一批带 mode/geometry/pitch 身份的原始表；在单位及采样位置得到独立证据前，不提供候选转换。真实算法替换仍需连续标定 IMU、曝光/编码帧共同时间锚、原生入口/缓存/回退、DSP latch 和编码视频单变量对照。本轮 `replacement_deployment_ready=false`，并未推进这些运行期门槛为通过。
