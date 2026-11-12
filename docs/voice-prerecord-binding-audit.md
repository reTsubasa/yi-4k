# 原厂语音 START 与预录接缝审计

日期：2026-11-12。该审计把固定镜像的语音语义、已有 `VoiceCmd_Task` 静态证据、Android/主机类型化触发边界和预录主机成片回执放在同一份回执中。它没有连接相机、读取麦克风、访问 GPIO/SD，也没有写入固件、RAM、分区或模型。

## 结论

如果相机原厂已经能识别“开始录像”或 `start recording`，接入一分钟预录时应复用原厂的 START 语义，不需要为了预录更换关键词。固定镜像的类别表为 `[1002, 1001, 1004, 1003, 1005]`，其中原始类别 3 映射公共结果 `1003`（`Yi_action_begin_recording`），类别 2 映射 `1004`（`Yi_action_stop_recording`）。两种语言最终汇入同一结果，不需要为中英文各写一套预录动作。

更换为原厂不认识的新关键词需要重新验证声学模型、特征前处理、加载/校验、推理阈值和可恢复部署入口。GUI 文本、日志名或命令语义字符串的替换不会训练模型；当前证据明确把准确声学短语验证标为 false。

## 可复跑证据

```sh
python3 scripts/audit_voice_prerecord_binding.py \
  --output artifacts/verification/2026-11-12-voice-prerecord-binding/audit.json
```

本轮回执为 [audit.json](../artifacts/verification/2026-11-12-voice-prerecord-binding/audit.json)，8 项检查通过。它确认：

- 原厂语义 START/STOP 的类别和公共结果固定；`VoiceCmd_Task` 出现在既有任务快照中。
- Python、C、Android 路由都以类型化 START/STOP 为边界；Android `CaptureTriggerAdapter` 不调用 `CameraClient`，也不接收音频文本。
- 主机预录链的语音 START 中断恢复、篡改拒绝和快门同 SHA 成片回执均存在。

## 证据边界

`VoiceCmd_Task` 和编译后的 ARM 路径不能证明某个具体中文或英文发音在当前相机上被识别。主机里的“开始录像”/`start recording` 只是离线测试夹具，不是 ASR。预录回执把类型化事件注入归档 H.264/AAC 回放，不能证明相机事件送达、实时编码/FIFO、实体 SD 耐久性或原厂 mux 已绑定。进入这些真机阶段前，仍需单独审阅可恢复方案和授权。
