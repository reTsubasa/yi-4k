# EIS 替换就绪度离线复核

本复核将当前已有的 ARM filter replay、shadow wrapper、VCAP 发布地址、ORC 调用点/传输窗口和反馈表生命周期审计并到一个只读 readiness ledger。脚本：[`audit_eis_replacement_readiness.py`](../scripts/audit_eis_replacement_readiness.py)；机器可读结果：[`audit.json`](../artifacts/device/2026-11-11-eis-replacement-readiness/audit.json)。

复核从既有 JSON 读取七组证据，并重新计算固定 RTOS 窗口、DSP 容器、OR1K decoder reference 与 Ghidra calls inventory 的 SHA-256。八项一致性检查均通过，输入哈希匹配。固定镜像上的 stock filter 主机差分为零 mismatch；离线 shadow v2 wrapper 对照为 512 例、零 mismatch；ORC 静态调用点 inventory 为 1,647 个候选。这里的通过只表示该版本离线证据互相一致。

替换仍未就绪。现有材料没有证明 ORC 专有传输完成、DSP 运行时微码身份和 warp 锁存、旧 state/table/scratch 的安全释放，或反馈与编码帧的 PTS 关联。水平/垂直完成日志不等于硬件 ack。ledger 明确保留 `custom_eis_replacement_ready=false`。

建议的下一步是真机只读关联观测：为运行中的 DSP 身份、单次 warp 发布、feedback tag 及视频帧时间戳建立同一帧关联，并验证何时旧表不再被读取。该脚本没有连接设备、执行 ORC/RTOS、自定义算法，也没有写入 RAM、固件、分区或启动区，因此不能替代该观测或解锁自定义代码执行。

后续[三阶段错误传播执行](eis-stage-failure-contract.md)新增 36 个原码有界场景和 22 条固定指令检查：生成零返回不能保证随后 SetWarp/GetWarp 成功；协调器忽略后两者返回值，注入依赖查询失败时仍可复制旧结果并置 ready。下一份透明观测必须记录同一次 invocation 的 Calc/Set/Get 三阶段返回和结果身份，不能只检查生成成功或 ready 字节。这是离线错误分支证据，未声称真机发生该故障。

复跑：

```sh
python3 scripts/audit_eis_replacement_readiness.py
python3 -m json.tool artifacts/device/2026-11-11-eis-replacement-readiness/audit.json
```
