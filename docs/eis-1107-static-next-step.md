# YI 4K 1.10.7：EIS 替换路径的静态收紧

日期：2026-11-10。本文只使用本机 1.10.7 RTOS 窗口及已有 Ghidra 反编译，不连接相机、不写入固件，也不把静态控制流当作运行期证据。

## 已确认的链路边界

本机 EIS 的主要数据边界可以收紧为（两个任务通过事件/共享状态协作，图中箭头不表示这些函数都在 1 ms 任务中同步调用）：

```text
主任务的 1 ms 事件 -> A0385780：读取 gyro、写 132 槽环形区、更新偏置/帧状态
主任务的 SOF/EOF 与计时条件 -> 事件 0x10000 -> Algo2Task -> 命令 0x1010
  -> A03852F8 -> A0392CB0：从环形窗口计算旋转/平移，生成 local_64 控制结构
  -> A02DA164：恢复 warp context，调用 A03119A8 计算 warp
  -> A0312460：selector=0xF，复制两个 0x1800 字节表并 clean cache
  -> A0312F74：提取 warp 描述和表地址
  -> 共享的 warp 描述/有效状态
A0385780 的后续帧阶段
  -> A02C5FD8：以两个 0x40 字节槽交替发布 LiveviewEisConfig 状态
```

`A0385780` 在采样 tick 后读取三轴数据，写入 raw X/Y/Z 槽位，发布 `A170AB60`，推进写指针，随后将原始值左移 8 位并继续更新偏置/积分状态。因此 Linux 侧轮询环形区不能得到无损输入流。

`A0392CB0` 中的两个 `A0384710` 调用是独立的旋转滤波边界：输入为当前窗口累计量和上一状态槽，输出经过固定点限幅的单个轨迹值。普通路径不能按无限精度公式直接实现：`previous*99` 和 `input*gain` 都先保留 ARM 低 32 位，再分别作向零截断的有符号 `/100`，两项求和保留低 32 位后才限幅。`gain` 由 `LDRB + SXTB` 读取，是有符号 8 位；镜像初值为 100。无溢出时可简写为 `trunc(previous*99/100) + trunc(input*gain/100)`。自适应路径还使用 `A0757AD8/A0757ADC` 及一个共享 8 位计数器。这个函数是最小算法替换候选，影响范围小于直接重写整段网格生成；它主要覆盖 Z 旋转轨迹，单独替换它不能称为完整 EIS/RSC 算法替换。

`A0312460` 的 selector=0xF 分支会按上下文计数器选择 warp 缓冲，复制两个固定 `0x1800` 字节平面，更新上下文指针并执行 D-cache clean；随后跳过 `A02BD9F0` 的独立 `SET_WARP_CONTROL_CMD`。因此它返回成功只证明准备/缓存路径成功，不能证明自定义表已经绑定到正确录像帧。

`A02C5FD8` 不是简单的表指针写入：它维护发布模式、将表地址转换到共享地址、复制输入状态到两个交替槽，并更新槽索引和共享指针。自定义算法若只调用 `A0312460`，可能绕过后续 DSP 消费所需的状态发布。

## 最小可验证替换点

建议把替换分为三个离线/运行期层级：

1. **主机回放层**：已提供 [整数参考/回放工具](../scripts/eis_filter_replay.py)，用人工有序边界数据验证定点滤波、限幅和候选因果 EMA；待有真实函数边界记录后再回放。输入必须是偏置/窗口变换后的函数输入，禁止把现有 50 ms 文本 raw gyro 事件作为本函数的完整输入流。外层环形窗口索引仍需单独恢复。
2. **影子观测层**：自定义代码进入后只在 `A0384710` 或 `A0392CB0` 的边界复制输入/输出到有界缓冲，不改变原厂表和 `A02C5FD8` 发布；记录序号、采样 tick、SOF/EOF、网格尺寸、提交耗时和丢弃计数。
3. **单项替换层**：先替换 `A0384710` 的平滑器，保留 `A02DA164 → A0312460 → A02C5FD8`；确认原厂录像稳定后，再考虑替换 `A03119A8` 的轨迹/网格生成。任何直接修改 `A0312460` 或绕过 `A02C5FD8` 的方案都应排在后面。

## 仍需恢复的契约

- gyro 量程、灵敏度、轴极性、level shift 与实际物理单位；
- SOF、EOF、曝光中心、RowTime、gyro_delay 与 warp 提交截止时间的共同时间基；
- `A02DA164` 产生的 `local_64` 控制结构中两张表的真实宽高、pitch、定点格式和坐标方向；
- `A0312F74` 输出描述与 `A02C5FD8` 两槽发布后的 DSP 锁存/回收时机；
- 自定义代码加载、ARM/Thumb 状态、I-cache、数据缓存、任务栈和失败回收。

## 证据与复现

[主机参考工具说明和仿真验证](eis-filter-host-replay.md)记录了 18 处真实指令校验、Unicorn 对本机完整 `A0384710` 函数的 3,240 组差分验证及边界限制。该验证证明参考模型与选定固件函数在这些输入上的算术结果相同，不证明 CPU/任务/缓存或真机运行安全。

- 本机镜像：`artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- [采样与帧状态](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0385780.c)
- [旋转/网格协调器](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0392cb0.c)
- [旋转滤波器](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0384710.c)
- [warp 计算](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a032cf38.c)
- [warp 提交](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0312460.c)
- [warp 描述提取](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0312f74.c)
- [LiveviewEisConfig 发布](../artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02c5fd8.c)
- [离线 selector/缓存复核](../artifacts/device/2026-11-10-eis-warp-publication/contract.json)

可重复运行：

```sh
.venv-reverse/bin/python scripts/analyze_eis_warp_publication.py \
  --output artifacts/device/2026-11-10-eis-warp-publication/contract.json
.venv-reverse/bin/python scripts/rtos_ring_contract.py
```

