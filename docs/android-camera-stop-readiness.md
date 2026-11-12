# 停止录像回包与 app_status 的完成边界

2026-11-10，固定 1.10.7 镜像。**msg514 的成功回包没有等待相机回到 idle/vf；停止完成必须另查实际状态。** 最新 Android capture workflow 的失败尚未记录每个前置检查的原始 `app_status`，因此不能仅凭最后画面为 vf 推断点击照片当时也为 vf。

本报告仅离线读取已有镜像、反编译资料和失败记录，没有连接或操作相机。

后续主 agent 已补真实普通 API [stop-state-probe-run01](../artifacts/android/0.3.3-stop-state-probe-run01.json)：一次正常三秒录像、单次成功停止后，立即读回及接下来30次只读采样均为 `Unknown`；更晚的新会话读回 `idle`，原录像/照片子模式与画质保留。没有将其解释为录像仍在持续，也没有重发stop。该证据确认原厂停录回包与稳定就绪之间确有过渡；最后一次Unknown与更晚idle之间存在未采样间隔，不能宣称精确收尾耗时。

产品现增加拍摄请求后的有界状态等待：开始录像须读到record；停止/照片须读到idle或vf，最多20秒，仅发msg1查询。期间保持操作忙碌，Unknown不开放新快门。超时提示状态未确认并不重发拍摄。此实现仍须新一轮MainActivity验收，不能用上述主机探针替代。

## 实际状态枚举

`A0155D9C` 是 msg1 `app_status` getter。逐项优先检查如下：

| 检查函数 | 返回条件成立时的字面值 | 主要状态来源 |
|---|---|---|
| `A011F21C` | `idle` | app state 为0、内部忙碌检查不成立、D08 bit2未置位 |
| `A011F084` | `record` | app state 为1；或 flags bit9置位且native mode>3 |
| `A011F0C8` | `capture` | app state为4；或state0且flags含0x22；或state5且flags bit1置位 |
| `A011F758` | `vf` | app state为5且flags bit1未置位 |
| 均未成立 | `Unknown` | 多种中间/不可归类状态 |

`idle` 字符串直接位于 `A054F6B8`，`vf` 位于 `A054F6C0`，fallback `Unknown` 位于 `A063B584`。这里没有单独输出 `busy` 的分支。早期只看反编译符号名可能把 `idle`/`vf` 分支说反，必须以镜像内字节字符串核对。

`A011EFC4` 的内部忙碌判定比表面状态更细：读取 `A069B3C8`、`A069B3CC`、`A069B3C4` 多组flag以及app state `A0FB334C`。照片/录像apply叶setter还分别检查 `A011F0C8`/`A011F084` 和这个内部忙碌函数。因此 `idle/vf` 是允许发送普通请求的外部状态，不是对所有内部条件的原子锁定；最终必须保留相机拒绝和实际读回检查。

固定例子：app state为2/6/FF、native mode4、flags清零时getter返回 `Unknown`；state0但某些忙碌位仍在时也会返回 `Unknown`。这些是原始代码在合成RAM中运行的分类结果，**不是已经观察到本次停止录像经过这些具体状态**。

## 停止 API 没有完成等待

普通停止 handler `A0165B98` 验证录像条件后，调用当前app vtable `(0x13,0,0)`，按调用返回生成 msg514 的 JSON回包。直接调用序列没有循环等待 `app_status`，也没有等待 `video_record_complete` 通知。不能把 `rval=0` 当作已完成文件封装、停止编码和恢复待机。

原厂 `A0121178` 另构造 `msg_id=7/type=video_record_complete`，在查出最后文件名等元数据后发送。它是另一个路径；现有Android `CameraClient.call` 会把此类通知交给事件回调，不能仅依赖514回包证明通知已发生。

建议产品合同：确认由自己发出的单次停止请求成功后，只读、有界轮询 `app_status`，到 `idle/vf` 才呈现可继续拍摄和配置。轮询不能再次发stop，不能把 `Unknown` 全局加入ready。超时应明确显示“停止结果尚未确认”，让用户刷新实际状态。

## 本次失败能说明什么

[0.3.3 capture run01](../artifacts/android/0.3.3-device-reports/camera-capture-workflow-run01/workflow-screens/camera-capture/camera-capture.json) 中，`ui_record_stop_confirmed` 和 `ui_click_照片` 同为 elapsed 29922ms；前者来自界面快门状态，不是独立相机稳定就绪证据。最后失败文本为裸 `请先停止拍摄再修改配置`，没有设置写入异常包装前缀。

对应产品代码里，`set` 的msg2及 `awaitMode` 在try/catch内，错误会被包装为“写入结果未确认”；`selectMode`/`set` 写入前的 `requireReady` 则直接产生裸错误。因此现有记录更支持前置检查碰到非ready状态，**尚不支持已经派发照片模式后在awaitMode内误拒**。新增逐检查原始状态证据才能准确区分。

模式请求被ack后也可能处于正常GUI过渡，但现有离线分类无法证明具体过渡时序。`awaitMode` 可在有界期限内对未匹配/暂不可归类状态继续只读等待，不应通过重新发送模式apply来“修复”；`record/capture` 等主动拍摄状态仍应谨慎处理。需要实际trace和一次完整录像→停止→照片→拍照验收确认产品时序。

## 复现

```sh
.venv-reverse/bin/python scripts/audit_camera_app_status.py
```

[audit.json](../artifacts/device/2026-11-10-camera-app-status/audit.json) 固定镜像SHA和七份伪代码摘要，执行实际getter及readiness helpers，12组合成状态覆盖五种字面值及多种Unknown来源。只有 `snprintf` 和诊断打印被stub；未stub状态判定、未执行任何真实设备、未伪造运行期过渡日志。
