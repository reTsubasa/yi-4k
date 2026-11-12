# 1.10.7 拍摄模式切换：确认回包与实际 apply 路径

2026-11-10。**相机的 `system_mode` 虽通过 msg9 宣告 `settable`，其 msg2 handler 只生成成功回包，并不切换拍摄模式。真正可切换模式的普通配置入口是 `capture_mode` 和 `rec_mode`。** 这一结论由固定真机镜像原码和三次普通 API 实验交叉确认，不需要新增裸内存写入、调试命令或固件补丁。

本报告的静态研究和脚本只读取已有镜像。三次普通 API 实验由主 agent 执行；本研究 agent 没有连接设备。实验没有录像或拍照，最终恢复 `idle/record` 和原有照片/录像子模式。

## 假成功为何能被读回检查发现

固定镜像为 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，ARM base `A0100000`。

msg2 通用 dispatcher `A01649A0` 解析 `type`、`param`，查找 100 字节设置表记录，调用记录中保存的 handler。以下地址是 key 字符串所在位置，handler 在 key+`0x58`：

| key | 表中 key 地址 | msg2 handler | 行为 |
|---|---|---|---|
| `system_mode` | `A06A7078` | `A0158844` | 生成 rval=0 / msg_id=2 / param / type / related 回包 |
| `capture_mode` | `A06A6268` | `A0157204` | 调用照片子模式 apply，再生成回包 |
| `rec_mode` | `A06A726C` | `A0158AA8` | 调用录像子模式 apply，再生成回包 |

`A0158844` 的调用只涉及 JSON 构造、`A01555C8` 查询相关设置数量、发送 JSON、释放 JSON；没有调用照片/录像 apply 或 GUI 模式切换事件。`A01555C8 → A01554BC` 枚举相关设置表，不是隐含模式 apply。

读 `system_mode` 的 handler `A015663C` 则检查当前 native mode 字节 `A1055CFA`：小于 4 返回 `capture`，否则返回 `record`。因此回包中的请求回显 `param=capture` 不能替代对该实际状态的独立读回。

真实证据：

- [run01](../artifacts/android/0.3.2-mode-switch-probe-run01.json)：先启动普通 viewfinder，再发 `system_mode=capture`，返回 rval0；立即及 0.5 秒后仍 `record/vf`；结束停止自己的 viewfinder，恢复 `record/idle`。
- [run02](../artifacts/android/0.3.2-mode-switch-probe-run02.json)：初始 idle 下相同请求 rval0，立即及后续累计约 2.5 秒读回均为 `record/idle`。

这解释此前 Android capture workflow run04 的照片切换失败；延长等待时间不能补上该 handler 缺失的 apply。

## 真正的原厂模式 apply

照片：`A0157204 → A014BDD0 → A0145E10`。原始 ARM `A0157244` 为 `bl A014BDD0`。叶 setter 逐一比较原厂照片子模式字符串，并与 **当前 native mode** 比较。不同才经 `A01881F4` 获取 GUI 对象，通过 vtable+`0x28` 派发 `0xD8090004`，r1 为目标 native mode；其前还派发 `0xF0010309`。目标如下：

| `capture_mode` 值 | native mode |
|---|---:|
| `precise quality` | 0 |
| `precise self quality` | 1 |
| `burst quality` | 2 |
| `precise quality cont.` | 3 |

录像：`A0158AA8 → A014BF24 → A0146228`。原始 ARM `A0158AD8` 为 `bl A014BF24`。叶 setter 同样按当前 native mode 判断并派发 `0xD8090004`：

| `rec_mode` 值 | native mode |
|---|---:|
| `record` | 4 |
| `record_timelapse` | 5 |
| `record_loop` | 6 |
| `record_photo` | 7 |
| `record_slow_motion` | 8 |

关键点：**跨照片/录像切换时，即使 `capture_mode` 或 `rec_mode` 的读回字符串已经等于目标值，仍必须调用对应 apply。** 字符串保存了各自子模式，不能证明当前激活的系统模式。只有系统模式和对应子模式都已匹配时，才可省略写入。

这不是建议启用 loop 模式；表中模式只说明固件已有映射。本项目普通拍摄继续选择相机实际宣告的照片/普通录像值。

## 已验证的普通请求

[run03](../artifacts/android/0.3.2-mode-switch-probe-run03.json) 先读原值，确认 msg9 权限和选项后执行：

```json
{"msg_id":2,"type":"capture_mode","param":"precise quality","token":"<session token>"}
```

实际回包 rval0/related1，随后 msg1 `system_mode` 读回 `capture`。恢复用实际原值：

```json
{"msg_id":2,"type":"rec_mode","param":"record","token":"<session token>"}
```

随后读回 `system_mode=record`，最终 `app_status=idle`，`capture_mode`、`rec_mode` 均保持初始值。没有重试拍摄或任意命令探测。

产品必须继续验证实际 `system_mode` 和对应子模式，不能把 rval0 或 related1 单独当作应用完成。模式 apply 经 GUI 事件异步执行，真实忙碌/拒绝/超时仍需要明确呈现，不应自动重发不确定写入。

## 可复现离线证据

```sh
.venv-reverse/bin/python scripts/audit_camera_mode_apply.py
```

输出 [audit.json](../artifacts/device/2026-11-10-camera-mode-apply/audit.json) 与 [audit.asm](../artifacts/device/2026-11-10-camera-mode-apply/audit.asm)。脚本固定三个表项、六个关键 ARM 指令，以及十一个函数的字节和伪代码摘要，并在 Unicorn 中执行两个真实叶 setter，共 27 组：九种模式各覆盖跨模式、相同模式和忙碌情况。另核对主 agent 保存的 run03 摘要和 capture→record/idle 结果；此处只是读取已保存证据，没有重新连接相机。

readiness、偏好服务和 GUI dispatch 是显式 stub；测试只验证实际原始 CPU 代码选择和派发正确目标，没有执行 GUI 消费者、传感器、编码器或文件系统，也没有伪造 `A1055CFA` 的运行期切换结果。真实模式完成证据来自独立 run03，不来自模拟执行。

以上修复方向仍需重新构建产品并通过真实 MainActivity 的录像→照片→拍照→恢复全流程；本报告本身不宣告 Android 拍摄闭环已验收。
