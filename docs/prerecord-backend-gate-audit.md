# 预录后端门禁完整性审计

`scripts/audit_prerecord_backend_gate.py` 对固定一分钟预录候选合同做只读完整性检查：核对合同仍明确标记为离线设计、所有安全标记保持关闭、8 个真机运行门都已表达且没有被误标为完成，并重新计算 9 份基础证据的 SHA-256。

运行：

```sh
python3 scripts/build_prerecord_backend_contract.py
python3 scripts/audit_prerecord_backend_gate.py
```

结果写入 `artifacts/device/2026-11-11-prerecord-backend-gate-audit/audit.json`。通过只表示已有离线证据没有漂移，也表示没有把主机回放或 ARM 离线执行升级为相机已实现预录；它不会连接相机、执行 RTOS、安装 callback 或写入固件、RAM、分区。

当前输出中的 `open_gates` 是下一轮真机只读验收清单，尤其包括 payload 稳定复制窗口、callback 静止屏障、跨段 A/V 连续性、存储故障恢复和相机语音/快门 START 送达。任何一个门没有真机证据，都不能发布预录功能。
