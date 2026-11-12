# Source coverage seal（2026-11-12）

[`yi4k_spool_seal`](../sdk/yi4k_spool_seal.h) 为追加式 packet spool 增加独立 sidecar seal。调用方必须先从自己的 source ledger 形成不可变 closure request；组件随后重新扫描 spool、重算逐条描述符与 payload 的 SHA-256 transcript，核对 expected coverage，按 body → sync → final marker → sync → readback → size check 的顺序写入 280 字节 sidecar。任何 I/O、短读写、大小变化或不一致都会冻结 coverage；冻结后不能原地续写或把失败调用改报成功。

## 2026-11-12 独立复跑

回执位于 [`validation.json`](../artifacts/verification/2026-11-12-spool-seal-run04/validation.json)。使用 `.venv-reverse`（`pyelftools 0.32`、`unicorn 2.1.4`）从当前源码重新编译并执行：

```sh
.venv-reverse/bin/python scripts/validate_spool_seal.py \
  --output artifacts/verification/2026-11-12-spool-seal-run04
```

结果为 `pass_source_coverage_seal_host_arm_posix`：

- 48 个 host/ARM 用例逐项相同；Cortex-A9 ELF 无未解析符号和链接后重定位，并检查 R4–R11、SP 保护。
- 两个实际保留快照场景分别封口 21 条和 1 条记录；新进程 reader 均返回 `status=0, valid=1`。
- 7 个损坏/篡改变体均被拒绝；8 个 seal 写入/同步/读回进程退出点均由新 reader 独立判断。退出到完整 marker 之后的场景可被验证，但不追溯给已退出 writer 成功回执。
- 记录边界截断、最后 marker 撕裂、修复 CRC 的 payload/digest 篡改、closure/scope 不匹配和缺 marker 均不能得到有效 receipt。
- 另以 Apple Clang UBSan 对当前 C 源和 48 个 host case 复跑通过，简要回执见 [`ubsan-host-48.txt`](../artifacts/verification/2026-11-12-spool-seal-run04/ubsan-host-48.txt)。

当前源码与脚本摘要由回执中的 `source_sha256` 固定；ARM ELF 摘要为 `8974659e4f24db278d6899efcb1ec05717f8445f1cb0bf6eb61ee8849ca83e56`。依赖清单见 [`requirements-spool-seal.txt`](../scripts/requirements-spool-seal.txt)。

## 边界

这些是主机文件、`fsync`、Cortex-A9 仿真和新进程 reader 证据，**不是实体相机或物理 SD 掉电验证**。source-stop ledger 仍是 host fixture metadata，没有 RTOS admission/quiescence/clock attestation；没有接入相机 callback、触发路由、1 分钟 live ring/eviction、MP4 publication 或真实 SD backend。SHA/CRC 只提供完整性检查，不提供认证。21+1 条记录是独立 snapshot-set 场景，不能宣称完整录影覆盖；只有外部可信停止证明、完整 expected coverage 和设备后端接入后才能继续产品化门禁。
