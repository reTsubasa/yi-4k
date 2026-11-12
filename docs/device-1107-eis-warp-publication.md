# YI 4K 1.10.7：EIS warp 准备与发布契约

2026-11-10。本轮只分析保留的本机 RTOS 字节与既有 Ghidra 反编译，没有连接相机、提交自定义表或修改固件。

**新收紧的边界：原厂 EIS 调用 `SetWarpCompensation` 时使用 `0xF` selector，准备/清理表缓存后跳过独立 DSP 命令发送；录像 EIS 的后续状态发布经过 `AmbaDSP_LiveviewEisConfig`。** 所以独立调用 `A0312460` 返回成功，不能证明自定义表已经作用于正确录像帧。SharePreview 不参与这条链。

## 证据身份与复核

设备窗口：`artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `0xA0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

[复核脚本](../scripts/analyze_eis_warp_publication.py)先固定该哈希，再以 Capstone 检查 31 处 A32 指令，新增核对 `A02C5FD8` 的双槽写入、`+0x80` 发布指针和索引回绕顺序，导出相关反汇编片段和契约：[结果 JSON](../artifacts/device/2026-11-10-eis-warp-publication/contract.json)。这是离线字节验证，不能当成实际执行轨迹。

```sh
.venv-reverse/bin/python scripts/analyze_eis_warp_publication.py \
  --output artifacts/device/2026-11-10-eis-warp-publication/contract.json
```

补充的[消费者/缓存审计](eis-warp-consumer-audit.md)重新固定同一镜像，确认 `checks=31` 与 roadmap 一致，并区分了三个代码分支中的 6 个静态 clean 调用站点（每次执行路径仍清理两个 `0x1800` 平面）。该审计没有找到 DSP 消费确认或旧槽回收条件，因此不扩大原有契约结论。

## 准备表与实际发送是两个边界

`A0312460` 的输入是图像控制上下文；`+0x04` 的 32 位 selector 不可直接命名为编码帧号。

- 视频管线读取本上下文的计算暂存区，将两个 `0x1800` 字节平面复制到选定 warp 缓冲，并更新描述中的 X/Y 指针。
- selector **恰好等于** `0xF` 时，缓冲选择由当前上下文计数器及偏移决定；其他值经过 `A03089AC` 映射。因此两个条件不能混淆。
- 随后调用 `A04A22CC` clean 两个 `0x1800` 字节平面。
- selector **低四位等于** `0xF` 时跳过 `A02BD9F0`，也跳过后续辅助命令 `A02BC3F8`。这时仍会更新上下文 dirty 位，返回值可以是成功。
- 不满足该条件时可进入 `A02BD9F0`，形成大小 `0x50`、命令码 `0x09005008` 的 `SET_WARP_CONTROL_CMD`，并转换表地址。

关键指令：`A031274C..A0312764` 与 `A031280C..A0312820` 的 mask/compare/branch/call。协调器的两处原厂调用在 `A0394760`、`A0394980`，前面均把输入 `+4` 设为 `0xF`；跳板 `A02DA514` 直接跳往 `A0312460`。

`0x1800` 只界定本函数固定复制长度。它不能单独证明网格宽高、有效点数、行 pitch、Q 格式、位移方向或表的最大安全生存时间。

## Warp 生成器约束

`A03119A8` 在正常算法路径调用 `A032CF38`。固定字节检查确认该生成器拒绝未知校准版本，只接受 `0x20140701` 或 `0x20130101`，并在多个分支检查 `HorGridNum * VerGridNum <= 0x12c0`。校准 warp 输入按每个网格点两个有符号 16 位坐标读取，步长为 4 字节；生成后分别进入 pipe-0/pipe-1 输出路径，并通过状态参数返回生成完成与变化的阶段索引。

这些约束说明自定义算法至少要保持版本/网格容量、坐标对齐和状态返回语义，才能继续复用原厂后续表处理。它们仍不能推出坐标 Q 格式、实际 pitch、DSP 锁存时间或 MP4 帧号映射；本节来自固定固件字节和 Ghidra 伪代码，没有真机提交。

## 原厂 EIS 后续发布

从既有反编译可以恢复以下数据链；是否进入分支由运行状态决定，本轮没有动态观察：

1. `A0392CB0` 经过 `A02DA164 → A03119A8` 计算 warp，再调用上述 selector `0xF` 的 SetWarp。
2. 正常状态分支调用 `A0312F74` 提取 warp 描述至 `A17045EC`，将 control、网格参数和转换后的表地址写到 `A1704334..A1704345`，有效时置 `A170AFB8`。另一分支只在调试开关启用时提取描述，不能假定每次计算都执行同一发布步骤。
3. `A0385780` 在帧/采样状态更新中组装以 `A1704310` 开始的 EIS 状态块。其 `+0x20` 包含子阶段索引和 `0x100` 标志；当前没有证据能把该值等同于 MP4 帧序号。
4. 当 `A17045DA == 0` 且相应调试旁路未启用时，`A038B2A8` 调用 `A02C5FD8(&A1704310, 1, A1704550)`。函数自带日志字符串 `AmbaDSP_LiveviewEisConfig`。
5. `A02C5FD8` 向两个 `0x40` 字节状态槽交替填充内容，更新其基址 `+0x80` 的发布指针，再将槽索引递增并在大于 1 时归零。入口启用状态变化时，还会更新 DSP 侧全局对象的指针/参数字段。

正常分支的“先表计算、后状态发布”说明替换算法应沿原厂帧状态机接入。直接调用另一个可发送命令的 selector，可能绕过原厂时序和缓冲选择；当前没有证据支持这样使用。

## 状态块与 warp 描述字段

以下是 `A02C5FD8` **输入块**的偏移；这些是从赋值关系和原厂 warp command 调试字段对应得到的静态结构，不是可直接对外调用的稳定 SDK。

| 输入偏移 | 当前能确认的内容 | 消费方式 |
|---|---|---|
| `+0x00..0x0C` | 四个窗口坐标字段 | 复制到所选状态槽相同偏移 |
| `+0x10..0x1C` | skew/比例/窗口相关字段 | word 或 halfword 复制 |
| `+0x20` | 帧阶段相关索引/标志 | 复制到所选槽 `+0x20` |
| `+0x24` | warp control | 零时槽 `+0x24=0`；非零时构建独立 warp 描述 |
| `+0x28/+0x29` | 水平表 grid_array_width/height | 写入描述 `+0x30/+0x31` |
| `+0x2A/+0x2B` | 水平/垂直 grid spacing exponent | 写入描述 `+0x32/+0x33` |
| `+0x2C/+0x30` | 水平/垂直 warp 表地址 | 经 `A04A3B24` 转换后写描述 `+0x08/+0x0C` |
| `+0x34/+0x35` | 垂直 warp 的 spacing exponent 字段 | 写入描述 `+0x37/+0x38` |

非零 warp 分支最后转换描述地址，并将其放进状态槽 `+0x24`。状态槽 `+0x24` 因而是描述指针，和输入块 `+0x24` 的 control 含义不同。`A0392CB0` 已转换表地址、而 `A02C5FD8` 再调用地址转换助手；本轮未把这种转换推断为可以对任意地址重复调用的规则。

两槽交替是状态记录的行为，**不能据此认为两个 warp 表就足够**。该函数的 warp 描述来源是一个共享全局指针，需继续恢复它的分配、消费者锁存和覆盖条件。

## 对自定义 EIS 的直接影响

已回答：存在可保留原厂传感器、硬件重采样及编码链，替换 ARM 侧轨迹和表生成的具体路径；其输出接入需要同时处理表准备和帧状态发布。

尚未闭合：

- 校正输入的成对 `int16` 网格，与计算后 X/Y 两平面表之间的精度、坐标方向、pitch 和裁切变换。
- gyro 的物理单位与轴、采样时间相对 SOF/曝光中心/逐行读出的关系。
- 双槽状态发布后的消费者锁存、旧表回收、共享描述重用，以及 cache/barrier 协议。`A02C5FD8` 函数内部没有可见 cache clean 调用，不能据此认定该区域必然无缓存。
- 目标帧和阶段索引的映射、DSP 截止时间及超时回退条件。
- 安全的自定义原生代码载入、执行与恢复；已执行的原厂 Shell 诊断不满足该条件。

静态闭环是：输入先复制到 `slot[index]`（每槽 `0x40` 字节），warp 描述地址经 `A04A3B24` 转换后写入槽 `+0x24`，再把转换后的**状态槽指针**发布到 `+0x80`，最后把索引加一并在 `1` 后回绕为 `0`。此前将后者写成“描述指针”的措辞不准确，已由完整寄存器数据流更正。这只证明固件的发布顺序和槽位布局，仍没有证明 DSP 何时锁存、何时释放旧槽，或两个槽是否足以覆盖最坏延迟。

后续已找到发布字地址经 `VCAP_SETUP.eis_update_addr` 进入 CPU 侧 DSP 命令缓冲的间接路径，见[间接发布审计](eis-indirect-dsp-publication-audit.md)。该路径解释了为何不需要其他 CPU 代码直接读取 `+0x80`，但不构成 DSP 锁存、确认或旧槽可复用的证据。

下一步应追 `A03119A8 → A032CF38` 的输出格式，以及 `A02C5FD8` 发布指针之后的消费时机。完成这些静态契约后，再设计原表不变的有界观测 hook；随后才进入单项消融和自定义轨迹替换。

原始反编译依据：

- [SetWarp](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0312460.c)
- [提取 warp 描述](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0312f74.c)
- [算法协调器](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0392cb0.c)
- [采样与帧状态](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0385780.c)
- [LiveviewEisConfig](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02c5fd8.c)
- [直接 warp DSP command](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02bd9f0.c)
