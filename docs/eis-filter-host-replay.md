# YI 4K 1.10.7：EIS 标量滤波的主机参考与回放

2026-11-10。本轮提供可执行的主机参考模型，用真实本机 ARM 函数字节在 Unicorn 中作差分验证。没有连接相机，没有制作或应用 hook、payload、刷写镜像。它是继续替换算法的离线基础，还没有改善视频或证明完整 EIS 可替换。

## 已复核的算术

目标为 `A0384710`，本机 RTOS SHA-256 固定为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。可读取 [真实汇编](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0384710.asm)，也可运行 [差分验证器](../scripts/validate_eis_filter_replay.py)从原始镜像重新检查指令。

普通路径的准确含义是：

```text
p = signed32(previous * 99)
i = signed32(input * signed8(gain))
value = signed32(trunc_zero(p / 100) + trunc_zero(i / 100))
return signed_clamp(value, -limit, +limit)
```

- `A038494C..A0384958` 先通过移位/加法得到低 32 位的 `previous*99`，不是 64 位乘法后再除。
- `A038497C..A0384988` 以 `LDRB + SXTB` 读取有符号 8 位 gain，再以 `MUL` 保留低 32 位；镜像初值为 100。
- 每项使用 `SMULL`、`ASR` 和符号修正实现向零截断的有符号 `/100`。Python 的负数 `//` 不等价。
- 两个商以 32 位 `ADD` 相加，之后用有符号条件 `BLE` 限幅；参考模型显式保留每次 wrap。
- 函数没有写回 `previous` 指针。它返回结果，由调用者选择是否存入环形状态。`A0392CB0` 有两个调用；第二次调用不应自动假定以上一次返回值作为 previous。
- runtime limit 位于 BSS `A170AFEC`，不能由静态镜像初值得到。工具要求调用者提供非负 limit，不支持猜测负 limit 的运行含义。

无溢出时，普通路径可写作 `trunc(previous*99/100) + trunc(input*gain/100)`。gain=100 时输入项是完整 input；这不是 `0.99*previous + 0.01*input` 的普通均值滤波。若把它与单位增益 EMA 比较，常量输入的直流增益不同，不能把两条标量曲线的差异直接解释为防抖质量。

可选自适应路径也已建模：小运动阈值经过 32 位左移、双精度弧度换算、向零转换、`/100`；小运动计数器按 8 位递增并可回绕。计数严格大于 `A0757AD8` 后，以 `A0757ADC` 替代反馈系数 99，并将计数夹回阈值。计数器由两个调用共享，不能按独立轴或独立候选滤波器各建一份。

## 回放输入与输出

[回放器](../scripts/eis_filter_replay.py)只依赖 Python 标准库。每次读取并验证本机镜像哈希，加载静态参数默认值，并把参数、输入文件摘要、反馈方式、每项 wrap/限幅及输出写入 JSON。

真实 trace 应使用 `feedback_mode: "explicit_previous"`，每条记录包含严格递增 sequence、变换后的有符号 input、实际解引用的 previous；可附 tick、observed_output、small_count_before、stream。已记录的输出会逐条比较，发现差异的 sequence 写入 summary。tick 只校验非递减，不自动认作曝光时间或视频 PTS。

```json
{
  "sample_kind": "caller captured scalar function-boundary trace",
  "feedback_mode": "explicit_previous",
  "parameters": {"limit": 5000, "adaptive_enabled": false},
  "candidate": {"alpha": 0.2},
  "samples": [
    {"sequence": 0, "input": 100, "previous": 0, "observed_output": 100},
    {"sequence": 1, "input": -100, "previous": 100, "observed_output": -1}
  ]
}
```

上例数值为人工演示，limit=5000 不是相机实测值。`synthetic_chain` 模式允许把每次输出反馈到相同 stream 的下一步，只用于人工实验；这种反馈拓扑不是已恢复的完整原厂调用模型。候选 EMA 保留浮点状态、限制同一输出范围，是可选的因果平滑算术对照，没有套用原厂整数 wrap。

工具拒绝直接读取已有 `gyro-events.json`：这些日志是约每 50 ms 打印的 level-shifted 三轴原始读数；本函数消费的是减偏置并经过环形窗口累计/换算后的有符号量，两者不是相同数据契约。现有数据不足以回放完整 EIS 或识别高频果冻来源。

人工输入和产物：

- [有明确 synthetic 标记的输入](../artifacts/device/2026-11-10-eis-filter-replay/synthetic-input.json)
- [普通参考/候选 EMA 输出](../artifacts/device/2026-11-10-eis-filter-replay/synthetic-output.json)

复现：

```sh
.venv-reverse/bin/python scripts/eis_filter_replay.py \
  artifacts/device/2026-11-10-eis-filter-replay/synthetic-input.json \
  --output artifacts/device/2026-11-10-eis-filter-replay/synthetic-output.json
```

## 与真实 ARM 指令的验证

[验证结果](../artifacts/device/2026-11-10-eis-filter-replay/validation.json)保存目标身份、函数摘要、18 处原始指令检查、3,240 组差分结果、输入拒绝检查和溢出例子；全部差分为 0 mismatch。验证器将保留的原始映像载入 Unicorn，以输入参数和内存状态运行完整 `A0384710`，直到返回哨兵；同时检查返回值、共享计数器、SP 恢复和 previous 指针未被写入。

覆盖普通/自适应路径、正负除法、gain 的 `-128..127` 代表值、INT32 两端、`*99`/`*gain` 溢出、limit=0/1/100/INT32_MAX、阈值正负边缘、计数=0/4/5/6/254/255 和固定种子的随机整数输入。该检查使用真正的指令执行，避免仅拿同一段参考公式自证。

可选验证依赖在 [requirements-eis-replay.txt](../scripts/requirements-eis-replay.txt)。本轮在已有 `.venv-reverse` 中增加 Unicorn 2.1.4，未修改系统 Python/MCP 配置。

```sh
.venv-reverse/bin/python scripts/validate_eis_filter_replay.py \
  --output artifacts/device/2026-11-10-eis-filter-replay/validation.json
```

Unicorn 结果是 CPU 仿真证据，范围限于标量函数和这些输入。它不证明真机可执行内存、cache、多任务并发、时限或调用 hook 的安全；自适应路径只支持有限浮点参数和可转换为 int32 的阈值，异常 VFP 状态仍未知。

## 下一步

在首次自定义原生执行与恢复机制闭合后，优先建立不改变结果的有界边界记录器：捕获两个 `A0384710` 调用的顺序、input、previous、共享计数及返回值，再用 explicit_previous 模式验证主机参考。参考一致后，可先替换这一项旋转平滑，保留 `A02DA164 → A0312460 → A02C5FD8` 的原厂 warp 计算、缓存维护和帧状态发布；X/Y 轨迹、按行 RSC、输入时间轴和表格式仍需分别恢复。
