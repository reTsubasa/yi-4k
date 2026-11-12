# 有界预录 ring 与 SD 适配器最小模拟（2026-11-12）

[`validate_prerecord_ring_sd_backend.py`](../scripts/validate_prerecord_ring_sd_backend.py) 实现一个可复跑的 host POSIX 存储模拟，用来补上 packet spool 与 source seal 之间的 ring/eviction 门禁。它把每个 15 秒窗口写成独立 append-only segment，执行头与 payload 写入、`fsync`、commit marker、再次 `fsync`、逐字节 readback 和文件大小检查；封口后写 280 字节 sidecar，并用新的 reader 重扫整个 segment。

ring 容量固定为四段，即 60 秒的合成窗口。触发快照先取得每个已封口 segment 的 lease；lease 未释放时，最老 segment 不能淘汰，继续开段返回 backpressure。释放 lease 后才允许 oldest-first 删除 spool 与 seal，并同步父目录。event3 以显式 epoch rollover 开新段，epoch 不匹配的 packet 会被拒绝。跨分界的 AAC lookahead packet 暂存到下一段，转移后只出现一次。任意同步失败把当前 segment 冻结并保留文件，不更新 eviction manifest。

## 当前回执

最新的 [`run13b/validation.json`](../artifacts/verification/2026-11-12-ring-sd-run13b/validation.json) 在 run12 的基础上增加了关闭 writer 后的独立重启 reader：reader 只从 `segment-0004.spool` 与 `.seal` 文件恢复 session/segment/epoch、逐轨连续性、CRC、payload 总量和 transcript；随后对已关闭 writer 的 spool 注入篡改，reader 在没有任何内存状态可用时拒绝该文件。回执为 `pass_host_bounded_ring_sd_simulation`、`device_access=false`、15 个断言，脚本 SHA-256 为 `8415240d935956abaf30743073884c5f14262db6c27e398ed50d4a579fd4861f`。

[`run12/validation.json`](../artifacts/verification/2026-11-12-ring-sd-run12/validation.json) 的状态为 `pass_host_bounded_ring_sd_simulation`，`device_access=false`，12 个断言通过：

- 60 秒快照包含 4 段、120 个合成 A/V packet；租约期间淘汰被 backpressure 阻止，释放后淘汰最老段。
- event3 epoch rollover 成功；一个跨分界 AAC packet 先 held，之后在下一段转移一次。
- 注入第三次 `sync` 失败后 segment 为 frozen，spool 保留且 eviction manifest 为空。
- 新 reader 会拒绝篡改后的 sidecar body，即使文件仍保持 280 字节。
- 创建和删除文件后都同步父目录；回执固定脚本 SHA 与 Python/host 信息。

```sh
python3 scripts/validate_prerecord_ring_sd_backend.py \
  --output artifacts/verification/2026-11-12-ring-sd-run12
```

关闭 writer 后重启 reader 的新回归使用独占输出目录：

```sh
python3 scripts/validate_prerecord_ring_sd_backend.py \
  --output artifacts/verification/2026-11-12-ring-sd-run13b
```

这是严格的**主机文件系统模拟**，sidecar 遵循 `YI4KSE01` 形状但不替代 [`yi4k_spool_seal.c`](../sdk/yi4k_spool_seal.c) 的 C 实现。packet 是合成一秒 A/V fixture，不是实际编码器输出；AAC lookahead 只验证保管与转移顺序，不验证 ASC、采样时钟或原厂 consumer。它没有安装相机 callback、证明 RTOS admission/quiescence、绑定真实 session epoch、写实体 SD、模拟掉电控制器或发布 MP4。`fsync`、文件删除和 epoch/lease 状态都不能被解释为实体 SD 耐久性、真机运行或完整一分钟预录已完成。
