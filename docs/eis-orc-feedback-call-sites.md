# EIS ORC feedback call-site inventory

本审计对固定 ORC 成员做完整的 4 字节对齐扫描，枚举指向已知 helper 偏移的直接相对 `l.jal` 编码。扫描是离线静态证据：不执行 ORC、不连接相机，也不把候选调用自动解释为运行期 writer、完成信号或 DSP ack。

结果见 [audit.json](../artifacts/device/2026-11-10-eis-orc-feedback-call-sites/audit.json)。本次固定镜像共发现 1,647 个候选编码：`smem_2_dram` 67 个、4 字节 opaque staging 1,151 个、128 字节 opaque staging 428 个、原厂 EIS command 1 个。已知 feedback/pre-clear 窗口内有 7 个候选：

| ORC 偏移 | 候选目标 | 所在窗口 |
| --- | --- | --- |
| `0xD78B4` | 128 字节 opaque staging | feedback |
| `0xD78E4` | 4 字节 opaque staging | feedback |
| `0xD78F8` | `smem_2_dram` | feedback |
| `0xD7930` | 128 字节 opaque staging | feedback |
| `0xD7948` | 原厂 EIS command | feedback |
| `0xD7A90` | 4 字节 opaque staging | pre-clear |
| `0xD7AA4` | `smem_2_dram` | pre-clear |

这些位置与此前恢复的 `shared + 0x20..+0x3f` 快照、`+0x3c` 复制和 `FFFFFFFF` 预清除窗口一致，但目标 helper 的参数、外存完成语义、缓存/原子发布、运行期 DSP 身份和旧槽安全释放仍未闭合。其余 1,640 个候选可能是数据字或其他 helper 用途；间接分派、DMA/MMIO 和专有指令不在本扫描范围内。

边界：候选总数不等于真实调用数，feedback 窗口候选也不等于非哨兵反馈写入者。任何原生执行、RAM/固件/分区写入仍需单独形成可回滚方案并确认。
