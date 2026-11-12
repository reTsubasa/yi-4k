# 真实录像日志中的 EIS 反馈标签关联

日期：2026-11-10。本轮仅分析已保存的真机日志、调试表和视频，未连接相机，也未使用合成反馈。**真实日志中有 83 条被原厂 CPU 接受的有效反馈打印，其中录像阶段 66 条；按已恢复代码解释，全部为子索引 5/6、`WarpReady` 位为 1。现有资料能关联录像会话和封装裁剪总数，仍不能关联到某个发布槽、gyro 历史内容或某个视频帧。**

## 原始证据与重新解析

本轮重新读取 `native-log-02/RtosActive.log`，234,033 字节，SHA-256 `5529f3828fa987a5e3fefc0955b55a23a92fa3c1d2a7ed333fc386744136083c`，按原始格式解析并与已有 `gyro-events.json` 的每一条事件逐项比较，相同。`RtosOlder.log` 和 `RtosOldest.log` 仅记录身份，不合并进当前会话统计。

模式区间重新按完整初始化块的文件行号分段，不根据 tick 强制对齐，不把内部几何直接当作输出文件分辨率。

| 项目 | 录像前预览 | 录像几何阶段 |
|---|---:|---:|
| 反馈打印数 | 17 | 66 |
| 反馈 tick 范围 | 25000..25534 | 26038..28206 |
| `0x105` 次数 | 15 | 25 |
| `0x106` 次数 | 2 | 41 |
| 相邻反馈 33 tick / 34 tick | 10 / 6 | 42 / 23 |
| previous 为 `FFFFFFFF` | 17 | 66 |

录像阶段的标签与 `DiffTime` 联合统计为：`0x105/16` 13 次，`0x105/17` 12 次，`0x106/17` 41 次。约 33/34 tick 的节律与 30 fps 附近的传感器运行一致，但频率近似不是逐帧身份；计时设计单位和边界沿用 [录像窗口报告](device-eis-recording-trace.md) 中的 1 ms 定时器证据。

可直接复查的真实样例：原始行 2275，tick 26038，`ArmSysTim=0x105, previous=FFFFFFFF, DiffTime=17`；原始行 2278，tick 26071，`ArmSysTim=0x106, previous=FFFFFFFF, DiffTime=17`。所有 83 条原始反馈行另存为 [observed-feedback.txt](../artifacts/device/2026-11-10-eis-feedback-live-correlation/observed-feedback.txt)。

## 从真实标签可以恢复什么

[CPU 完成状态边界](eis-completion-state-boundary.md) 已固定字节恢复以下解释：

- `0x105`：低 8 位索引 5，`0x100` 就绪位被设置。
- `0x106`：低 8 位索引 6，`0x100` 就绪位被设置。

真实消息与固定字符串 `A0600078` 对应，打印站点为 `A03879A4`，位于有效值检查和低位/bit 8 提取之后、`DEADBEEF` 重置之前。这支持“本次真机确实执行 CPU 有效反馈分支”，并非仅在合成环境中演示位运算。它仍不直接观察 DSP 存储、网格锁存、编码完成或槽释放。

代码中这些索引对应的 CPU 数据位置可以精确算出：

| 真实索引 | `Spf` 字节位置 | 六字历史记录起点 |
|---:|---|---|
| 5 | `A170AF9D` | `A170B418` |
| 6 | `A170AF9E` | `A170B430` |

这是**静态地址关联**，不是这些地址当时的内存内容。历史六个字由生产者保存采样时间差、X/Y、两个 gyro 环位置及一个 Y 状态；后续消费者按反馈索引恢复相应值。现有日志没有打印这些历史字段，无法把索引 5/6 追溯到原始 gyro 样本、某次 warp 发布或完整状态槽地址。

`ucodeSampleTime` 的固定计算为 `int8(A1704228) + index × byte(A170404D)`。模式初始化日志确实记录预览 `EisUpdateEndTime1=17`、录像 `=10`，并记录 `ADV time: 6 3`；但当前 `A170404D` 值以及关联的 `Spf` 内容未在这一采集中打印。不能把公式代入某个静态初值后，把计算结果冒充真实捕获的 `ucodeSampleTime`。

## 详细关联日志为何缺失

回收的 `collect-02/active.dat` 是完整 37 项调试表；仅 14/15/20/22 相对 baseline 改为 1/1/1/50，before 与 after 全部一致。关键门控与原始日志搜索结果相互吻合：

| 门控 | 本轮 active 值 | 缺失的详细内容 |
|---|---:|---|
| 下标 0（`A0757AF8 & 2`） | 0 | `Spf[ArmSysTim]`、`ucodeSampleTime`、`WarpReady`、两个 gyro 环位置的详细打印 |
| 下标 15（`A0757B16 & 1`） | 1 | 有效反馈打印已开启，确实取得 83 条 |
| 同一下标的 `& 2` | 未设置 | `current UpdateInfo.ArmSysTime` 无效轮询打印未开启 |
| 下标 17（`A0757B1A`） | 0 | `update_eis_status_do =` 提交相关打印 |
| 下标 27（`A0757B2E`） | 0 | `Warp cmd in shared memory` 内容打印 |
| 下标 1（`A0757AFA`） | 0 | `Do EisPerFrame` 计算时序打印 |

这些前缀在本轮 Active 原始日志中匹配均为零。它们的缺失符合当时的诊断配置，不能作为相关功能未运行的证据。新 CSV 明确保留 `spf_observed=false`、`history_values_observed=false`、`video_frame_identified=false`，不填入推测数据。

对每条反馈，CSV 还列出同模式中按文件顺序最近的先行曝光/gyro 打印，只表示日志邻近性。录像反馈距先行曝光打印为 6 tick（13 次）或 7 tick（53 次）；最近的 gyro 文本则是约 50 tick 抽样后的稀疏记录，间隔并不固定。两种“邻近”都不能确立同帧、同样本或物理曝光中心关系。

## previous 哨兵的正确解释

已有报告关于 `previous` 的限定仍成立。固定 `A03883A8..83BC` 每轮把缓存 `A170AFE8` 写入 `A170B394`，**包括没有有效反馈的轮询**；有效轮询内部则先把缓存和共享末项写为 `DEADBEEF`。日志里的 previous 是这个缓存快照，不是“上一帧已完成标签”。

真实 83 条有效打印的 previous 全为 `FFFFFFFF`，只能报告该观察。由于无效轮询打印当时关闭，不能从这些有效行还原两次有效打印间的完整 `FFFFFFFF/DEADBEEF/有效值` 序列，更不能计算无效轮询次数或认定上一帧丢失。共享字段中 `FFFFFFFF` 和非哨兵值的写入者、缓存时序和跨核可见性仍未在本轮恢复。

## 新找到的录像裁剪关联

文件名证据把这些日志关联到 `YDXJ0139.MP4`：tick 26031 创建主文件，26033 打开，28211 关闭。实际文件 16,254,590 字节，SHA-256 `1dc7d72892e54dcacaf4c6b032e3ec017237a44dad66d24edb4ba305f98970ee`，本轮重新计算并匹配已有下载凭据。

此前 AVFoundation 验证成功：1920×1080，29.970 fps，48 个解码帧，首 PTS 0、末 PTS 1.5682333 秒，时长 1.6016 秒。本轮复用该已有解码报告，没有重新解码视频。

本轮新识别到原始行 **2507/2509，tick 28114**：

```text
pri fps 240000/8008  FrameCount 61 trim frame 13 min frame 16
sec fps 240000/8008  FrameCount 61 trim frame 13 min frame 16
```

固定函数 `A01F4994` 在打印后对主/次视频对象的 `+0x8C` 帧计数减去 trim 值（主：`A01F4A70..4A7C`，次：`A01F4B64..4B74`），并扣减对应时长字段。因此这里的 **61 − 13 = 48** 有实际代码语义支撑，也与成品视频帧数一致。它补充解释了文件帧数不能直接等于录像生命周期内的 66 条反馈；不能把差额 18 全部称为丢帧，也不能把 13 条裁剪直接绑定到前/后某组 EIS 标签。

原始行 2499/2500，tick 28081/28098，还打印了两个视频流的 `pts ffffffffffffffff AMP_FIFO_MARK_EOS`；这是 EOS 哨兵，不能用作有效 PTS 时钟锚。`Strm_0` EOS 之后仍有 4 条反馈打印，说明反馈生命周期延续到流结束之后。全体 66 条录像反馈都落在文件创建至关闭的 tick 区间里，仍不能确定哪 48 条对应最后文件中的 48 帧。

本轮未找到把标签、提交地址、帧号和有效视频 PTS 同时打印在一条记录中的证据。文件名、帧计数裁剪和周期统计属于会话/聚合关联，不能升级成逐帧 warp 生效验证。

## 需要更新和保留的旧解释

[录像窗口报告](device-eis-recording-trace.md) 的事件数量、previous 限定、非单调帧号、稀疏 gyro 与视频不可一一对应等结论保持成立。现在可以补充两点：

1. ArmSysTim 不再只是完全不透明原值：CPU 已证明将其解释为子索引和 `WarpReady`，本轮真实值均为索引 5/6、就绪位 1。原始 JSON 的 `frame_update` 名称仅作为既有解析分类保留，不能理解为一个唯一编码帧。
2. “DSP 共享更新状态字”应限定为“CPU 从共享区域读取和消费的反馈标签”；DSP 非哨兵写入者仍未证明。成品 48 帧另有 `FrameCount 61 − trim 13` 的新聚合证据。

## 复现与证据范围

```sh
.venv-reverse/bin/python scripts/audit_eis_feedback_live_correlation.py \
  --output-directory artifacts/device/2026-11-10-eis-feedback-live-correlation
```

输出 [audit.json](../artifacts/device/2026-11-10-eis-feedback-live-correlation/audit.json)、[feedback.csv](../artifacts/device/2026-11-10-eis-feedback-live-correlation/feedback.csv) 和原始反馈摘录。**83 条真实反馈重解析、66 条录像区间归属、25 条固定 ARM 指令、调试表差异、视频 SHA 与两项裁剪计数一致性检查通过。** 原始日志、旧解析 JSON、调试表和视频都未改动；没有真机操作、合成反馈或新运行轨迹。

剩余精确缺口是完整有效/无效反馈序列、共享标签非哨兵写入、tag 与具体发布的共同序号、gyro 历史内容和视频有效 PTS 的共同时间锚。现有真实证据足以确认 CPU 消费反馈这条路径曾运行，仍不足以证明 DSP latch、缓存协议、旧槽释放或自定义 EIS 安全提交。

## 后续静态代码与 FFFFFFFF 机制候选

[ORC 反馈路径审计](eis-orc-feedback-path.md) 随后恢复了标签提交和 FFFFFFFF 预清除的具体微码代码布局：先准备 shared+0x20..+0x3F（末字FFFFFFFF），随后在条件满足时选择状态槽+0x20标签，经EIS命令处理后准备四字节反馈至shared+0x3C。这为previous=FFFFFFFF提供机制候选，但专有复制指令、运行期交错及每条日志的来源仍未观察，不能反推完整轮询序列或旧槽释放。
