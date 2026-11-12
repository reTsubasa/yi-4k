# ORC EIS 反馈窗口直接调用复核

2026-11-11。基于固定的 YI 4K 1.10.7 DSP/ORC member 和同一份核心编码参考，重新执行完整 word-aligned 相对 `l.jal` 扫描。该轮只读离线运行，没有执行 ORC、连接相机或写入设备。

复核命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_feedback_call_sites.py \
  --output artifacts/device/2026-11-11-eis-orc-feedback-call-sites-rerun/audit.json
```

结果：完整 member 共 1,647 个选定目标的直接相对调用候选，其中 `smem_2_dram` 67 个、4 字节 staging helper 1,151 个、128 字节 staging helper 428 个、原厂 EIS command 函数 1 个。在已定位的 feedback/pre-clear 两个窗口内只有 7 个候选：feedback 窗口依次出现 128B staging、4B staging、`smem_2_dram`、128B staging 和原厂 EIS command；pre-clear 窗口出现 4B staging 与 `smem_2_dram`。

这把反馈窗口内的直接调用顺序固定为可审阅证据，支持继续追踪 staging 参数和边界。它仍不能证明专有传输字的完成语义、DMA/MMIO 目的地址、cache/latch、DSP 运行时身份或旧槽安全释放；因此不解除自定义 EIS 上机门槛，也不改变透明原厂路径。

[审计 JSON](../artifacts/device/2026-11-11-eis-orc-feedback-call-sites-rerun/audit.json) 保留了固定镜像哈希、全部候选和 7 条窗口内记录。
