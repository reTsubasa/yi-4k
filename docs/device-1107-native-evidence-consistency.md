# 原生 EIS 证据一致性审计

2026-11-12 对固定的 1.10.7 RTOS 窗口执行了一次离线证据核对。目的只是防止首入口扫描、首次执行合同、TaskQuery 停止保护和自然完成尾部证据在脚本更新后发生源码、映像或文档漂移；它不增加新的设备执行能力。

运行脚本：

```sh
.venv-reverse/bin/python scripts/audit_eis_native_evidence_consistency.py \\
  --output artifacts/verification/2026-11-12-eis-native-evidence-consistency-run01
```

回执：[audit.json](../artifacts/verification/2026-11-12-eis-native-evidence-consistency-run01/audit.json)，SHA-256 `429ce7b14bd29229f50874c19c99f41e83520ea3f44d8cf79b633dde87c9f0c8`。脚本 SHA-256 为 `474faf3226cc732ded5e0ac22e368ad745d747c8dd187d335bf05d5ce7d5d38d`。

## 核对内容

49 项检查全部通过：

- 四组证据都指向同一 RTOS 窗口，SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- P1/P5 的原生入口扫描回执纳入核对：151 个 stock handler 中无直接同步候选，10 个 A32 I-cache 指令仍只位于 BOSS/MMU/低功耗上下文；扫描回执明确无设备访问、无写入和无 payload。
- 首入口脚本的回执现在带有 `schema=native-first-entry-contract/v2` 和自身 `script_sha256`；回执中的映像、`device_access=false`、`target_write=false` 和 `payload_or_writer_emitted=false` 均被复核。
- TaskStop `run03` 与自然完成同址复用 `run05` 的脚本 SHA、回执 SHA、映像 SHA 和文档链接均与文件实际内容一致；两份回执均为 `device_access=false`。
- 三份说明都保留“部分/未完成/不构成部署”的边界词，审计不会把离线结果升级成真机执行许可。
- 计划、目标矩阵和原生执行前置矩阵仍明确保留 2b 未完成、I-cache/回滚缺口，以及 P1/P5/P11 的缺失状态。

本轮改动只增加首入口回执的 schema/脚本哈希字段和上述审计脚本；没有连接相机，没有写 RAM、固件、分区或 SD，没有生成可执行 payload，也没有运行任何目标固件指令。

## 证据边界

一致性通过只证明当前源码、固定映像、JSON 回执和 Markdown 互相指向且离线标记一致。它不证明外部首入口、I-cache 发布、跨核完成、任务/handler 撤销、代码回收、冷复位或回滚。EIS 最小原生执行仍受前置矩阵 P1/P3/P4/P5/P6/P8/P10/P11 约束，EIS 算法替换和真机验证状态不变。
