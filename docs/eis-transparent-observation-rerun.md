# EIS 同 invocation 透明观测复跑

日期：2026-11-11。该轮只在主机和 Unicorn 合成 RAM 中执行冻结的 C 记录器与原始 ARM 失败场景，没有连接相机、读取私有 RAM、安装 hook、修改固件或写入设备。

## 复跑结果

复现命令：

```sh
.venv-reverse/bin/python scripts/validate_eis_stage_trace.py \
  --output artifacts/verification/2026-11-11-eis-stage-trace-independent-run02
```

本轮通过 33 个场景；每个场景的记录都以唯一 `token + context` 关联同一次调用，并按 `CALC → SET → GET → CANDIDATE` 顺序提交。`SET` 只有同时观察到 X/Y copy 和 X/Y clean（mask `15`），且 bank、平面地址及摘要与生成结果一致时才会保存 prepared identity；`GET` 必须再次匹配该 identity；候选记录要求自身 status 为零，且不会把 ready 字节当成成功条件。

完整状态、每个场景的 stage 顺序和哈希见[独立复跑索引](../artifacts/verification/2026-11-11-eis-stage-trace-independent-run02/index.json)及[验证 JSON](../artifacts/verification/2026-11-11-eis-stage-trace-independent-run02/validation.json)。本轮 ABI 检查为 trace 244 bytes、receipt 44 bytes，并核对 ARM 被调用者寄存器与 SP 保持。固定 1.10.7 CPU 镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

## 这条证据能支持的结论

- 同一次调用的生成、准备、读取和候选状态可以被分开记录，旧 bank 不能仅因地址相同而被当作新调用结果。
- Set/Get 返回值、表身份、copy/clean 观察和候选 ready 是独立字段；其中任一失败或 stale identity 都会拒绝 `PREPARED`。
- 该记录器能够作为未来只读观测的输入合同，避免用 `Calc == 0` 或 `ready == 1` 推断本次 warp 已发布。

记录器的 token、context、表摘要和状态快照仍由调用方提供；它们不是已认证的硬件日志。原始 ARM 失败路径中的 mutex lookup、copy 和 clean 仍是合成依赖/调用记录，不是 DSP 完成回执。

## 仍未关闭的运行期门槛

当前 `replacement_ready` 仍为 `false`。还缺：

1. 在实际 1.10.7 RTOS 中安装可卸载、生命周期有界的只读记录器，并证明入口/返回和冷启动恢复。
2. 记录运行期 DSP 镜像身份，把同一视频帧的 gyro、曝光、warp 表和编码时间关联起来。
3. 证明专有传输、cache 可见性、DSP latch/消费完成及旧 bank 安全释放。
4. 在 stock fallback 保持可用的前提下，先做单变量替换，再分别验收预览和编码录像。

因此本轮完成的是透明记录合同和独立复跑索引，不是 EIS 算法替换或真机部署授权。
