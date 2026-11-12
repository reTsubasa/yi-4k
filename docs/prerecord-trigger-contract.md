# 预录触发路由契约（主机侧）

`scripts/prerecord_trigger.py` 是主机/仿真侧的统一 START 语义模块。规范输入是已经由相机固件动作层送达的 typed `CameraEventType.START_RECORDING` 事件；相机固件负责把识别到的 `开始录像` / `start recording` 映射为该事件。本模块不访问相机、麦克风或固件语音模型，也不执行语音识别。

`on_camera_voice_event()` 仅是离线测试夹具适配器，用于把“已经识别”的文本模拟成 typed START；它不是 App 或主机 ASR 功能。该适配器对两个完整短语按 Android `CaptureTriggerRouter` 的同一规则规范化：NFKC、转小写、去除首尾空白、将标点/分隔符转换为空格并合并连续空白。快门只接受 `press` 动作。

第一个有效语音或快门事件返回 `ACCEPTED`，调用方可以把 `at_us` 传给 `PreRecordBuffer.start()`。之后所有有效触发都返回 `DUPLICATE`，不会把 START 变成 STOP，也不会重复创建录制会话。`reset()` 清除本轮状态并递增 generation；下一次有效事件可以重新产生一次 START。

示例：

```python
from prerecord_trigger import CameraEvent, CameraEventType, PreRecordTriggerRouter
from prerecord_buffer import PreRecordBuffer

router = PreRecordTriggerRouter()
buffer = PreRecordBuffer()
result = router.on_camera_event(CameraEvent(CameraEventType.START_RECORDING, at_us))
if result.accepted:
    buffer.start(result.at_us)
```

文本夹具若要覆盖短语映射，应显式标注为测试输入：`router.on_camera_voice_event("start recording", at_us)`。

测试：

```bash
python3 -m unittest scripts.tests.test_prerecord_trigger -v
```

通过该模块的测试只代表主机路由契约成立，不代表相机端已经识别这两个口令，也不代表相机事件或快门事件已经连接到预录消费者。
