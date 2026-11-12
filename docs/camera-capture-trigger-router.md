# 相机端统一触发路由：纯 C 离线候选

日期：2026-11-10。

本轮将已恢复的相机语音 START/STOP 语义落实为独立纯 C 状态机。它只产生 commit/finalize/原厂透传意图，没有预录、编码、写卡或固件接入后端，不能宣称相机已实现一分钟预录。

## 文件与复现

- 公共接口：[yi4k_capture_trigger.h](../sdk/yi4k_capture_trigger.h)。
- 实现：[yi4k_capture_trigger.c](../sdk/yi4k_capture_trigger.c)。
- 同源宿主/ARM 用例：[yi4k_capture_trigger_test.c](../sdk/offline/yi4k_capture_trigger_test.c)。
- 编译和 Unicorn 验证：[validate_capture_trigger.py](../scripts/validate_capture_trigger.py)。
- 本轮证据：[audit.json](../artifacts/offline/2026-11-10-capture-trigger/audit.json)。同目录 ELF 仅含离线测试程序，不是固件补丁。

```sh
.venv-reverse/bin/python scripts/validate_capture_trigger.py
```

结果：宿主和 ARM 各通过 **13068** 项相同语义断言；ARM 执行 828694 条指令，检查 8552 个调用边界的 8 字节栈对齐；R4–R11、D8–D15 与 SP 保持，最大观察栈用量 204 字节。编译器开启 `-Wall -Wextra -Werror`；ARM 为 `armv7-none-eabi` / Cortex-A9 / ARM 指令集，无浮点、无 libc、无未解析符号或重定位。结构体 ABI 由编译期断言同时约束宿主和 ARM。

这些结果只验证新增路由逻辑及编译产物，不涉及相机固件执行、真实音频、实际按键、文件可靠性或真实预录效果。

## 与既有逻辑的关系

先参考了 Android `CaptureTriggerRouter`、Python `PreRecordTriggerRouter` 和 `PreRecordBuffer`。保留它们共同的规则：语音 START 幂等、第一次 START 固定触发时间、明确 STOP、失败不假装完成。

相机端按当前产品要求作两处明确细化，未修改既有 Java/Python 文件：

1. Java 将所有实体短按视为 START。新相机端路由在 **RECORDING 中把已分类短按解释为独立 STOP**，保留相机实体快门的正常停录能力；语音 START 仍不会停录。COMMITTING 中短按继续忽略，防止重复提交。
2. Java 的 STARTING 中 STOP 被忽略。新路由的等价状态名为 COMMITTING，该阶段的明确 STOP 暂存一次；commit 成功后立即发出独立 finalize，commit 确认失败/回滚则清除暂存 STOP。

Python buffer 的 `start()` 是同步元数据提交，STOPPING / FINALIZING 还要等待末段覆盖；C 路由只表示异步操作生命周期，不能用 C 的状态变化替代 Python 层的片段覆盖、时间戳或 MP4 发布校验。

## 输入与语义

`yi4k_capture_decode_voice()` 接受明确的命名空间，避免混淆引擎结果和消息 ID：

| 输入域 | START | STOP |
| --- | --- | --- |
| `ENGINE_RESULT` | `1003` | `1004` |
| `VOICE_MESSAGE` | `F0010338` | `F0010339` |

其他代码返回 UNKNOWN，交回原厂路线。映射依据见 [语音类别审计](voice-class-semantics.md)。接口不接受短语、不进行识别，也不声称已验证“开始录像”/“start recording”的实际读法。

实体快门输入必须来自上层**已消抖、已分类且一次按压只投递一次**的 `SHUTTER_SHORT` / `SHUTTER_LONG` 事件。本模块不读取 GPIO，不测量按住时长，不识别按下/抬起电平。把重复原始按键电平当作多个短按可能在 commit 完成后误触发 STOP，因此禁止这样接入。

OFF 状态中的 START、STOP、长短按和其他原厂输入都返回 `PASS_STOCK`；长按在所有状态都透传。路由不调用原厂函数。未来适配器必须保留原始消息与载荷，并且仅在收到透传结果时把原始输入原样交回一次，不能把转换后的共享按钮事件再次当成 START。

内部回执不是原厂输入，即便处于 OFF，旧/无效回执也只忽略，不透传。

## 状态与操作

| 当前状态 | 语音/外部 START | 实体短按 | 明确 STOP |
| --- | --- | --- | --- |
| OFF | 原厂透传 | 原厂透传 | 原厂透传 |
| PREBUFFERING | 发 COMMIT，进入 COMMITTING | 同左 | 忽略 |
| COMMITTING | 忽略 | 忽略 | 暂存第一次 STOP |
| RECORDING | 忽略 | 发独立 FINALIZE，进入 FINALIZING | 发 FINALIZE，进入 FINALIZING |
| FINALIZING | 忽略 | 忽略 | 忽略 |

COMMIT 输出包含第一次触发的完整 64 位微秒时间戳及 `window_us=60000000`；它只是请求最近一分钟，不保证历史已经积累满一分钟。实际可用窗口、关键帧、音频对齐及资源固定必须由后端验证。

`arm()` 仅在 OFF 进入 PREBUFFERING，表示调用者已确认真正的缓存后端就绪；函数本身不启动缓存。PREBUFFERING 重复 arm 幂等，其他活动状态返回 BUSY。DISARM 只允许在 OFF / PREBUFFERING，活动提交/录像/收尾中拒绝，避免直接丢弃后端所有权。DISARM 是逻辑禁用；适配器仍负责停止/排空真实预录生产者，不能把路由的 OFF 当作硬件已经停机。

## 异步身份与恢复

每次 COMMIT / FINALIZE 分配递增非零 token；回执必须同时匹配 token 和操作类型。旧成功、旧失败、重复回执、错误类型回执和 token=0 均忽略。禁止仍有旧回执可能到达时重新初始化对象。arm/disarm 不清零计数器。

token 不回绕；耗尽返回 `TOKEN_EXHAUSTED`，不发新操作，并预留最后一个 token 供最终合法 COMMIT 后的 STOP 使用。该错误必须由适配器显式处理。重新初始化需要后端停机、所有旧回执排空，不能在活动操作中简单清零；极端的 token 耗尽后 STOP 重试也不能静默绕过该边界。

| 回执 | 前提与状态结果 |
| --- | --- |
| COMMIT_OK | 后端已固定选中历史且正式录制真正开始；进入 RECORDING；若有暂存 STOP，同一次 reducer 调用直接进入 FINALIZING 并发一个新 token 的 FINALIZE。 |
| COMMIT_FAILED | 仅限已确认没有生效，或已完成回滚且预录缓存可继续使用；回 PREBUFFERING、清暂存 STOP，可接受新的 START。 |
| STOP_OK | 真实停止/收尾已完成，且后端已可继续预录；回 PREBUFFERING。只停止编码但文件未收尾，不满足该回执条件。 |
| STOP_FAILED | 仅限已确认没有停录，或已回滚到可安全继续录像；回 RECORDING，允许明确 STOP 重试。 |
| COMMIT_UNKNOWN / STOP_UNKNOWN | 适用于超时、响应丢失或结果不确定；保持 COMMITTING / FINALIZING、原 token 及所有权，不重新 commit，不释放后端资源。等待同 token 的明确回执或外部核对。 |

**超时不能转成 FAILED。** 如果适配器不知道后端是否执行，必须使用 UNKNOWN，不能由软件计时器合成成功/回滚。

同一 operation 的异步提交在输出之前就将状态改为 COMMITTING / FINALIZING；后续 START 不会再输出第二次 COMMIT。若发往后端的队列明确拒绝且确认未执行，可按失败契约回执；若队列接收结果不明，使用 UNKNOWN。

## 同步与 ABI

路由无分配器、无线程、无回调、无原子锁。**一个对象的所有输入、arm/disarm 和异步回执必须在同一个 owner 线程顺序处理，或用同一外部锁完整包围调用。** 输出发布给后端必须在 reducer 返回之后；回调重新投递给该 owner，避免直接在硬件回调/ISR 中并发改同一对象。`volatile` 不能替代此合同。

公共结构只保存 `uint32_t` / `uint64_t`，不把 enum 的编译器大小当作 ABI：router 56 字节、event 24 字节、output 32 字节。触发时间与 STOP 时间使用同一单调采集时钟；STOP 早于本次 START 会被拒绝。三参数对象不得内存重叠；调用方不得自行改状态字段或复制活动对象后由两个 owner 使用。

## 还未实现的接入工作

真实 encoder/FIFO 消费者、最近一分钟资源固定、MP4 / AAC / H.264 封装、异步 commit/finalize 后端、原厂动作适配、快门分类和 shutdown 协调均未由本模块完成。也没有地址 patch、trampoline、写入器、上机安装或真实相机调用。

因此下一阶段只有在后端能够兑现上述确认/回滚/UNKNOWN 契约，并且原生执行与恢复路径闭合后，才适合把该候选路由接到相机事件层。当前测试通过代表纯 C 行为可复现，不代表产品预录功能已交付。
