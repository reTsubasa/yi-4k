# 1.10.7 音频配置来源与启动顺序

2026-11-10。复用固定镜像与已有 Ghidra 导出；本轮新增 **10 个原始指令前缀仿真用例及 10 个启动指令核对，全部通过**。没有连接、写入或运行真机，没有执行 RTOS、codec、实际 memcpy 或音视频采集，没有重复上一轮 15 个 PTS 算术用例。

## 配置来源已收紧

此前只知道 `A045DA98` 将实例 `context+0x60` 送入音频 setup+4，作为 PTS 公式的分母。现在恢复出这条配置链：

```text
AppLibAudioEnc_Setup A0210894
  固定表 A06D4508 + selector×28，字段 +8
  → create config+0x14
  → A046012C → AmpAudioEnc_CreateImpl A045F204
  → memcpy(context+0x4c, create config, 0x5c)
  → context+0x60
  → A045DA98 setup+4
  → A0290B60 state+0x2c
```

`A045F308–A045F328` 的原始指令明确构造源、目的及长度，两个不同空闲实例槽的离线前缀确认目的为 `context+0x4c`，长度 `0x5c`；仿真在 memcpy 调用前停止。由字节偏移可得 `0x4c+0x14=0x60`，无需依赖反编译器的局部变量命名。

`A0210B40–A0210B7C` 为主音轨装配，`A021094C–A02109C8` 为次音轨装配，均读取同一表。实际字节如下：

| selector | 表项地址 | 格式字 | 字段+4 | 字段+8（PTS 分母来源） | +0x0c / +0x0e |
|---:|---|---:|---:|---:|---|
| 0 | `A06D4508` | `0x00` | 48000 | **48000** | 2 / 2 |
| 1 | `A06D4524` | `0x10` | 48000 | **48000** | 2 / 2 |
| 2 | `A06D4540` | `0x10` | 48000 | **48000** | 2 / 2 |

原始字段+8字节均为 `80 bb 00 00`。主次音轨 × 三个 selector 的 6 例实际指令前缀都将 48000 写到 create config+0x14。主轨配置未改变、编码器尚未创建的特殊分支 `A0210F88–A0210FCC` 直接使用第 1 项，也得到 48000。没有据此宣称表项总数或完整 selector 范围。

另一路创建调用者 `A0189A28` 在 `A0189AF0` 直接构造 `0xbb80=48000`，`A0189B10` 写 create config+0x14。本轮也执行此前缀核对。因此 48000 现在有**固件配置字节及调用传递证据**，不再只是上一轮合成用例参数；这仍不是真机 ADC 实测频率或当前模式实测值。

## 录制启动是顺序调用，尚未找到共同采集 epoch

`AppLibVideoEnc` 的 `A021D274` 与 `A021E464` 构造 AV pipeline 时，按条件先加入主音频 handle `A13C7D20`，可再加入次音频 `A13C7D0C`，随后加入视频主／次 handle。可选前置 handle `A13C7ED8` 也可能更早加入；本轮未将其命名。`A045BE3C` 按输入数组顺序复制 pipeline handle 列表。

`A021E7F8` 调用 `AmpEnc_StartRecord A045C6E8`。后者在 `A045C778–A045C7A0` 按数组正序读取每个 handle，调用其 vtable+0x10；不会在这里取得一个时间戳再传给所有组件。传递给每个组件的第二参数相同，但本轮没有将其误认成硬件 epoch。

音频 vtable 位于 `A078A7BC`：+0x08 为 `A045DD8C`（StartLiveViewImpl），+0x10 为 `A045DA98`（StartEncodeImpl）。因此在上述列表构造路径，音频录制启动回调先于后续视频启动回调进入。

音频内部成功路径进一步为：

1. `A045DB5C` 调用 setup `A0290B60`，将音频帧计数清零。
2. `A045DB6C` 调用 `A045D390`，其中 `A045D4D0` 调用 `AmbaAudio_EncTaskStart A0290F14`。
3. 若实例 `context+0xa4 == 0`，才在 `A045D4F8` 调用 `AudioEnc_StartAinTask A045D264`；非零则跳过。
4. 返回后通过 `A045D7B8` 打开音频 buffer source node，最后将编码状态置为 2。

`context+0xa4` 来自 create config+0x58，因为 `0x4c+0x58=0xa4`。`A0210894` 将全局 `A13C7C38` 的低字节写到该配置字段，旁边日志明确称 **InputTaskStartInLiveView**。对应 `A045DD8C` 在 liveview 启动时若该字段非零，会提前调用 `A045D264` 启动音频输入。

所以音频输入可能早在 liveview 阶段开始；record 阶段的音频帧序号起点，也不能直接解释为 ADC 和视频传感器同时采集的起点。当前证据只确定配置传递与函数调用顺序，没有确定 RTOS 调度时刻、首个 ADC buffer 和首个视频 DSP 时间戳的对应关系。

## 复现与边界

运行：

```sh
.venv-reverse/bin/python scripts/prerecord-audio-config.py
```

结果：`artifacts/device/2026-11-10-prerecord/prerecord-audio-config-audit.json`。记录镜像、函数索引、13 个相关函数伪代码／函数体 SHA-256、表项原始字节、启动 vtable、原始指令窗口及逐例结果。

镜像仍为 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `A0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。10 例由 6 个主／次表项前缀、1 个主轨特殊分支、1 个替代调用者常量前缀、2 个实例复制参数前缀构成。没有执行完整 setup/start/pipeline。

后续应把音频输入 buffer 的首个采集标记、输入在 liveview／record 的实际开关状态，与视频 DSP 原始事件时间戳放在同一条可验证证据链中。当前未证明共同 epoch，不能据此启用一分钟预录或给出可刷写补丁。
