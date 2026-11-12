# A0384710 边界 trace 与替换判定门槛

日期：2026-11-10。本文件把下一阶段的只读证据定义成一个可以离线检查的协议。它不表示已经取得了真实边界 trace，也不产生 loader、hook 或刷写文件。

## 先记录什么

已有日志中的约 50 ms gyro 文本是原始/诊断层读数，不能直接当作 `A0384710` 的输入。这个函数真正消费调用边界上的三个寄存器和若干运行态来源：

```text
r0 = 2                         // 两个已恢复调用点的 mode
r1 = signed32(input)           // 窗口累计/换算后的标量
r2 = &previous                 // 函数解引用 [r2]，但不应写回
r0 = signed32(output)          // 返回给调用者的滤波结果
```

两个调用点都必须记录，不能把第二处写入 `A170AF38` 的后续动作当成函数内部的 previous 拓扑。每条记录至少包含以下字段：

- `sequence`、`site`（1 或 2）、`mode`、`input`、`previous_address`、`previous`、`observed_output`；
- `count_before`/`count_after`，以及 `limit`、signed-byte `gain`、`adaptive_enabled`、`small_motion_degrees`、`scale_shift`、`small_count_limit`、`adaptive_feedback`；
- `tick_before`/`tick_after`，并在会话头写明计时器单位、回绕处理和 tick 的语义；
- `previous_after` 或等价的 `previous_unchanged=true` canary，以及原厂调用次数 `stock_invocations=1`。

`previous_address` 是实际 r2 指针的记录，不是根据 site 猜出来的地址。地址必须非零且 4 字节对齐；`previous_after` 必须等于 `previous`。这一步能把“静态汇编没有写回”与“当前包装器实际没有改变槽位”分开。现有 v1 80 字节影子记录保留了地址和值，但尚未保存 after 值；**v1 记录即使补上同名字段，也不能直接冒充 v2 通过最终替换门槛**。

## 安全采集顺序

1. 先离线固定 RTOS 窗口和 `A0384710` 的镜像哈希，确认两个原始 `BL` 仍在 `0xA03937F0` 和 `0xA0393C00`。
2. 只安装 stock-only 影子路径：包装器先读取边界字段，调用一次原厂函数，再读取 `previous_after`，最后发布有界记录。它不改变 r0、r1、r2，不替换原厂输出，也不在实时路径写文件或等待。
3. 缓冲区由调用者预分配并常驻，满时停止写入并增加丢弃计数；单次 `LDREX/STREX` 竞争失败旁路到原厂函数。导出前先让生产者静止，验证 `commit` 连续、`dropped_records=0`、`busy_seen=false`，再通过已确认的只读通道导出。
4. 导出文件写入会话头：固件哈希、函数地址、模式/裁切、来源表版本、缓冲区容量和导出完整性。不要从 `/dev/mem` 轮询私有 RTOS 内存，也不要用 printf 代替高频边界记录。
5. 主机先运行 [边界 gate](../scripts/eis_boundary_trace_gate.py)，逐条重算原厂整数语义，再决定是否有资格进入单独的原生执行关卡。任何失败都保持原厂函数运行并继续收集，不能在实时路径自动切换候选算法。

推荐的 trace 顶层结构如下（数值只是字段示例，不是实机数据）：

```json
{
  "schema": "yi4k.eis-boundary-trace-gate/v1",
  "target": {"sha256": "<pinned-rtos-sha256>", "function": "0xA0384710"},
  "capture": {
    "source": "yi4k_1107_eis_shadow-v1",
    "synthetic": false,
    "stock_only": true,
    "committed_contiguous": true,
    "previous_after_available": true,
    "record_bytes": 88,
    "dropped_records": 0,
    "busy_seen": false
  },
  "samples": [
    {
      "sequence": 0, "site": 1, "mode": 2,
      "input": 100, "previous_address": 2712717316,
      "previous": 0, "previous_after": 0,
      "previous_unchanged": true, "stock_invocations": 1,
      "observed_output": 100,
      "tick_before": 1000, "tick_after": 1000,
      "count_before": 0, "count_after": 0,
      "limit": 5000, "gain": 100,
      "adaptive_enabled": false,
      "small_motion_degrees": 30, "scale_shift": 24,
      "small_count_limit": 5, "adaptive_feedback": 90
    }
  ]
}
```

## 主机检查和门槛

运行：

```sh
.venv-reverse/bin/python scripts/eis_boundary_trace_gate.py \
  <trace.json> --output <gate-report.json> --strict
```

脚本要求 trace 的固件哈希与本机 1.10.7 镜像一致，检查每条记录的 signed32/signed8 约束、严格递增 sequence、两个 site、`mode=2`、tick 单调性、previous canary、原厂一次调用和 `A0384710` 的精确整数输出。它同时复核已有 Unicorn 标量报告（至少 3,240 组、0 mismatch）。

真实导出应先使用 [导出封装校验器](../scripts/verify_eis_boundary_trace_export.py)：

```sh
.venv-reverse/bin/python scripts/verify_eis_boundary_trace_export.py \
  <stock-only-export.json> --output <export-report.json>
```

导出封装使用 `yi4k.eis-boundary-trace-export/v1`，包含 `evidence.kind=real-stock-only`、固定镜像身份、生产者静止证明、**v2 的 128×88B 缓冲协议（总记录区 11,264B，连同 64B 头为 11,328B）**、连续 `commit_v2`、记录 canonical SHA-256 以及 `records`。校验器只接受声明为 `real-stock-only` 且 `record_bytes=88` 的文件进入真实 gate；旧 v1 的 80B 导出会被明确阻断。`synthetic-test` 只能通过 `--allow-synthetic` 做 schema 回归，报告会标记 `evidence_class=synthetic-test`，且替换 gate 永远为 false。校验器不能对文件来源做硬件级认证，真实类别的含义是“符合 stock-only 导出协议的自声明文件”，不是已经完成真机真实性证明。

“通过”使用以下可审计门槛：

- 至少 2,000 条有效边界记录，site 1 和 site 2 各至少 500 条；
- 至少 32 条自适应路径记录、至少 8 次共享计数变化；
- 至少 100 条被 limit 限幅和 100 条未限幅记录；
- 所有记录都有 tick 和 previous canary，`dropped_records=0`、`busy_seen=false`，每条原厂调用次数为 1；
- 主机重算与 `observed_output`、`count_after` 全部一致，没有任何行错误。

这些数量是替换标量函数前的最低覆盖，不是画质验收。它们覆盖调用拓扑、运行态参数和自适应状态变化；乘法溢出、负数向零除法和边界限幅仍由 Unicorn 报告覆盖。缺少真实自适应记录时，不能以普通路径的通过替代自适应证据。

## 通过之后仍不能做什么

通过只说明“在已记录的调用边界上，候选标量可以复现原厂输出并且没有改变 previous”。它没有证明：

- 自定义代码的可执行放置、入口/返回、I-cache/D-cache 发布、SMP/IRQ 所有权或实时预算；
- `A0392CB0` 外层轨迹、`A02DA164 → A0312460` warp 生成、双槽发布与 DSP 锁存时序；
- 录制视频的全局稳定、按行形变、裁切、丢帧或温升改善。

因此下一步仍应先完成 [原生执行关卡](device-1107-native-execution-gate.md)，再做“保持原厂调用但替换一个标量函数”的可回退实验。算法替换前后都必须保留原厂回退入口，并以直接编码视频和实时/丢帧指标验收。

当前只读验证用合成 trace 测试 gate；它明确标记为测试输入，不构成真机证据。
