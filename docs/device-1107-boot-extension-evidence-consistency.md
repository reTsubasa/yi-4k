# 启动扩展评估：离线证据一致性复核

2026-11-12。对[已有启动扩展评估](device-1107-static-boot-extension.md)新增独立读取检查，
复核评估 JSON、固定本机捕获、已有 96 字节 marker、补丁跨度与反汇编字节的一致性。
本轮重新运行旧评估脚本，但没有连接相机、执行 RTOS 或输出完整修改镜像。

34 项检查通过，覆盖固定输入 SHA、窗口/分区前缀关系、payload SHA 和跨度一致、
启动 BL 目标、原始字节、93 个变化字节、完整分区主机内存撤销，以及四份导出反汇编
所列字节与固定镜像的一致性。已有 payload 是离线标记原型，不是本轮新增的可部署入口。
source 与旧评估脚本 SHA 被记入回执，供复核当前版本；检查器本身不重新编译汇编源，
也不把源码摘要相等视为运行证明。

两个临时主机文件反例均被拒绝：把独立恢复字段改为 `true` 时由
`recovery_still_unproven` 拒绝，改动 payload 的一个 bit 时由 `payload_sha256` 拒绝。
反例不修改原证据文件，也不生成目标固件。

```sh
.venv-reverse/bin/python scripts/device_boot_patch_assessment.py
.venv-reverse/bin/python scripts/audit_boot_extension_evidence_consistency.py
```

- [检查器](../scripts/audit_boot_extension_evidence_consistency.py)
- [34 项检查回执](../artifacts/verification/2026-11-12-boot-extension-consistency-run01/audit.json)
- [反例回执](../artifacts/verification/2026-11-12-boot-extension-consistency-run01/negative-checks.json)

| 材料 | SHA-256 |
|---|---|
| 检查器 | `f477e0cca9f2c42b6563beecd32e3350d21040417b6c0470ea8b180bee75159e` |
| 旧评估脚本 | `f626ed3a276048f855fa253df1880607321539c7bf4dc64aec8f65f7c9e9a88c` |
| marker 汇编源 | `453fbcf1cb5abb7254eb63db85e160c6bb5fbffa6f6678ffb21f379f4b2e597b` |
| 旧评估 JSON | `d4d5dd19cbe7808c28aaed71b3c2b4b258c1142230983926884a2405bb724a74` |
| 本轮检查回执 | `6e7dab50df62815e7b6145f90edb0a318a7e20ef790c51ab1dae90277cd445c7` |
| 反例回执 | `12aefbdf19df6ffa1f7daba0deac77ccf9b0ce55a45efd7434427d4e108bc3e6` |

P1 外部首次进入、P5 普通 I-cache 发布/ISB 与 SMP 完成、P11 独立恢复和冷启动回滚
仍未解决。回执只证明指定本地文件之间的字节一致性和主机内存撤销，不证明填充区
运行期所有权、硬件权限、真实返回、掉电恢复或算法替换。
