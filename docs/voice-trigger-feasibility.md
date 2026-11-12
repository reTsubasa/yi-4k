# YI 4K 1.10.7：相机内语音触发与预录衔接

## 当前结论

设备 RTOS 中有完整的原生语音命令管线，包含英语和中文两套内置模型、音频 FIFO、识别任务和录像按钮事件转发。既有真机任务表已确认 `VoiceCmd_Task` 存在并等待事件；它是实现独立于手机的语音触发的可复用候选，仍不能认定本机已开启识别或能直接使用。

2026-11-10 的只读 API 检查中，当前设备 `msg_id=3` 设置列表没有 `voice_control`；正确形式的 `msg_id=9,param=voice_control` 在 6 秒内没有回复，随后会话正常关闭。这不能解释为支持，更不能据此写入该设置。见 [真机 API 证据](../artifacts/device/2026-11-10-feature-api/)。本文没有启用语音、切换语言或进行麦克风/口令真机测试。

`“开始录像”`、`“start recording”` 这类**精确自定义短语还没有验证**。已有英文日志写的是 `Yi action begin recording`，中文模型存在不等于中文短语一定是“开始录像”。识别短语属于模型内容，替换日志字符串不会改变识别结果。

## 证据边界与复现

分析对象是此前从本机取得的 RTOS 内存窗口，基址 `0xA0100000`，SHA-256：

```
eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c
```

静态部分使用已有 Ghidra 反编译和本地 Capstone ARM 反汇编；不是 REA 服务返回的执行证据，也没有通过本文新增调用相机函数。另复用此前原生 `ps tsk` 的两份真机快照，范围仅限任务状态观察。Ghidra 推断的类型存在错误，例如 `A01B295C` 显示为 `void`，ARM 实际保留 `VC_Init` 的 `r0` 返回值；不能把伪 C 直接当 ABI 头文件。

复现静态导出：

```
.venv-reverse/bin/python scripts/analyze_native_voice.py
```

导出 [static-evidence.json](../artifacts/device/2026-11-10-native-voice/static-evidence.json)，包含镜像摘要、字符串、模型指针、关键指令区间及既有两份任务表的摘要、表头和解析行。主要伪代码位于 `artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/`，函数名按下表地址命名。

导出还记录了候选口令的原始字符串搜索结果。英文 `begin recording` 命中的是日志文本，不能当作模型词表；中文 `开始录像` 未以 UTF-8/UTF-16 字符串出现。模型是二进制参数，字符串缺失既不能证明中文口令不存在，也不能证明英文日志就是实际声学口令。

## 已找到的输入、识别、触发链

| 地址 | 已观察的静态行为 | 二开价值/限制 |
| --- | --- | --- |
| `A01B29C0` | `VoiceCmd_Init(language)` 仅接受 `0/1`；初始化音频和打包 FIFO、事件组，创建 `VoiceCmd_Task`，优先级 `0xAA`、栈 `0x8000` | 原生任务在真机任务表存在；音频消费及识别成功仍未实测 |
| `A01B295C` | 创建 4 字段配置：语言、浮点 `150.0`、命令数 `5`、5 个 `1.0` 的数组；调用 `A04CAF98` | 该接口没有传入命令文字或自定义模型路径；`150.0` 的物理意义未确认 |
| `A01B18A0` | 16 位输入交错抽取一个通道，调用 `A01CC178` 做抽取/滤波 | 可作为小型关键词识别器前端候选；采样率/通道顺序仍需取样确认 |
| `A01B18E0` | 任务从 FIFO 读取 `0xF00` 字节，前端处理后打包，再取 `0xC80` 字节传给 `A04CB57C(buf,0,0x640)` | 引擎按 1600 个 16 位样本处理；不能只凭该常量断定时长/采样率 |
| `A04CB57C` | 原生 `VC_Process` 候选；构建音频特征、进行识别、返回命令编号加 `1000` | 可将新 KWS 结果映射到现有语义层；推理开销尚未测量 |
| `A01B18E0` | `1001..1005` 分别映射拍照、连拍、开始录像、停止录像、关机事件 | 开始事件为 `F0010338`；受当前 app、RTMP live、skip 标志控制 |
| `A01B22E0` | `VoiceCmd_ProcessRecordStart` 检查 ready；需要时切换 app 和 video 工作模式，随后排队 `F001033B` | 已有开始语义，不能无条件当作任意状态下的 toggle |
| `A019DCA8..DCCC` | 分支树中 `F001033A < event < F001033C` 跳至 `A019F66C`，即 `F001033B` | ARM 指令核实事件落点 |
| `A019F66C..F6C0` | 日志 `AMSG_CMD_VC_RECORD_BUTTON`；检查 active recorder 和状态字节 `>3` | 状态不符会取消，不能跳过条件直接注入 |
| `A01A0958..0988` | 把上述语音按钮操作转为 `E001000C`，通过 app 的 `+0x28` 回调发送 | 语音与录像按钮可以在 app 语义层汇合 |
| `A0113808` | recorder 的 `app_rec_connected_cam_on_message`：`E001000C` 转入录像按钮回调；普通主键路径 `E001001E` 依工作模式转 `E001000C` 或拍照事件 | 统一预录 commit 的候选边界；物理按键的短按/长按/关机策略仍需保留 |

原生英文日志中的五条命令是：`Yi action take photo`、`Yi action shoot burst`、`Yi action begin recording`、`Yi action stop recording`、`Yi action turn off`。它们证明程序如何解释编号，不单独证明声学模型在本机的识别效果或实际允许说法。

## 两套语言模型与可更改程度

`A01ABEC0` 的命令 `vc_switch_lan` 明确比较 `en` 与 `zh`，分别调用 `A01B2C30(0)` 和 `(1)`；用法字符串是 `Usage: vc_switch_lan en | zh`。`A01C7748` 的 UI 管理初始化根据语言 ID 是否为 `0x404` 调用同一语言切换函数。这是英中选择的代码证据，并非根据模型名称猜测。

`A01B2C30` 会暂停识别任务，等待 idle 事件，销毁原引擎、重新初始化所选语言、清空音频缓存，再恢复原 enable 状态。因此已有正确的切换同步流程；不应在任务使用模型时直接改指针。

`A04CACD0` 根据语言选择两组不同的嵌入数据和参数，再调用 `A04CAA78` 构造识别器。其 PIC 表解析基址为 `A0821700`：

| 语言 | 主要内置数据头/引用 |
| --- | --- |
| 英语 `0` | `A0791EC4`、`A079DDE8`、`A079F1B0`，及相关 payload 指针 |
| 中文 `1` | `A07BB6A0`、`A07C75C4`、`A07E3C10`，及相关 payload 指针 |

后续 [GUI与模型资源审计](voice-gui-resource-reachability.md) 已恢复八段资源边界和原厂逐word变换，中英文各两阶段拓扑及51/67项权重容器均解析，8块数据与真实ARM变换逐字节相同。训练工具、准确口令词表、类别到实际声音的关系仍未恢复；没有证据说明可通过SD卡文本添加任意口令。重用原模型实现固定口令优先级高于逆向训练格式。

如果用户必须使用短句而无需原唤醒前缀，更直接的二开方案是在确认音频格式后增加小型离线关键词识别器，输出 `START/STOP` 语义到统一动作队列。应比较其 ROM/RAM、最坏推理耗时和漏识/误触发，而不能仅凭 SoC 有 ARM 核心判断已满足实时性。不要把安卓手机的语音 API 当作“相机内语音”完成。

## 本机启用的未闭合部分

原生设置路径存在：`A014EECC` → `A0148AAC`。当前 voice enable 偏好字段是 `(*A1055CD4)+0x136`；`A0153254` 读该字段，`A0144778` 同步 GUI 偏好字节 `A0FBC191`。切换还检查 recorder 状态/ready，保存偏好并发送 recorder 操作 `0x93/0x94`。

启动/停止识别使用 `A01184C8` / `A0118564` 排队 `F0010334/0335`。初始化任务的调用在主 handler `A019D5D4` 可见，参数 `0`；既有真机任务表使“任务是否存在”得到运行证据，但麦克风管线是否开启仍未知。

此前 `e30da2b76aa5` 诊断的 [tsk1](../artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-03/yi4k_diag_e30da2b76aa5_tsk1.txt) 和 [tsk2](../artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-03/yi4k_diag_e30da2b76aa5_tsk2.txt) 的表头均为 `ID PRI PREEMPT SCHED STAT ... NAME`。第 23 号任务两次均为：`PRI=170`、`PREEMPT=170`、`SCHED=1`、`STAT=EVENT_FLAG`、名称 `VoiceCmd_Task`，栈基址 `A1259FF0`、栈指针 `A1261E98`。因此可以确认该任务已经创建并处于事件等待，两次之间调度计数没有增加。该计数不是识别次数，不能据此确认 enable、等待的是哪个事件、音频有效或识别可用；本次没有为此要求重启或新增探针。

下列条件还没闭合：

- 当前构建固定API注册表未登记voice_control/内部ID84；普通触屏开关路径另有静态及合成执行证据，实际界面/资源和厂商源级型号策略未验，不能从API缺失推断整机禁止语音。
- enable/skip 标志、音频输入是否有效；与正常录像/预录同时占用音频设备是否兼容。
- 内置中文口令的准确读法，噪声、风噪、功耗和误触发率。
- shell `vc_switch_lan` 是 RTOS shell 能力；目前没有 Linux 到通用 RTOS shell 的安全桥，因此不能将其当作现在可随时执行的 Linux 命令。

`A01B34E4` 返回的 `A12596D4` 是 **SavePCM 调试缓存初始化标志**，不是 voice 总功能 gate；`A01B3254/A01B33B8` 的写入和日志可以确认。不要误用该标志判断语音是否支持。

另一个容易误读的 API 字段是会话 `257` 中可选的 `voice_control:1`：`A019C3C8` 通过 `A0195CBC` 仅检查 `A1055F90==1`。追踪写入可知，`A01358C8` 在进入 **GUI Voice Control sampling** 流程时置 `1`，`A013D1D4` 和退出 UI 路径清 `0`；该字段表示语音采样流程状态，不能当作总功能支持标志。该采样流程调用 `A01B2E50/A01B2FF8` 录制并保存 PCM，文件名来自五条现有命令加 `_en/_zh` 后缀；暂未见训练新词或将录样本反写模型的证据。

还存在 RTOS 调试命令 `vc_test`（`A01ABD80`），直接更改同一偏好并发出 `0x93/0x94`。它仍需安全的 RTOS shell 入口，并会保存偏好；本次没有执行，不应通过任意内存写替代它。

## 与一分钟预录共用动作的实现要求

建议新增显式动作层：

```
IDLE -> ARMING -> PREBUFFERING -> COMMITTING -> RECORDING -> FINALIZING
                         START ----^
```

物理短按、原生识别结果 `1003`、未来新 KWS 和 App 的开始操作都投递同一个 `START`。在 `PREBUFFERING` 时它表示固定历史窗口并继续写入正式片段；在 `RECORDING` 时重复 `START` 必须幂等。`STOP` 使用独立语义，并设置去抖/重复识别抑制。

如果预录实现方式是后台持续普通录像，原生 `VoiceCmd_ProcessRecordStart` 可能因 ready 状态不符直接拒绝；绕过该函数注入 `E001000C` 又可能把录像 toggle 成停止。因此必须先在统一语义层拦截预录状态、完成 commit，不能把当前按钮事件直接作为“保存最近一分钟”的实现。

产品gate的后续离线追踪见 [设置注册表](voice-settings-registration-gate.md)：当前固定表没有voice_control/内部ID84，并非msg3在输出时按机型隐藏。普通触屏入口与模型资源的进一步证据见 [GUI与模型审计](voice-gui-resource-reachability.md)：语音对象及下滑、显示、点击控制流均存在，不能只称孤立handler；真实位图、当前屏幕与识别结果仍未验证。应优先核实正常本机界面与任务/音频状态，准确口令和一条识别只产生一次START须实测，再接入预录状态机。自定义代码执行与恢复入口尚未闭合，本文不构成可直接烧录或调用的补丁。
