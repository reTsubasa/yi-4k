# AAC 分段边界的有界所有权组件

2026-11-11。组件为 [yi4k_1107_aac_boundary.h](../sdk/yi4k_1107_aac_boundary.h) 与 [C 实现](../sdk/yi4k_1107_aac_boundary.c)。这是独立、单调用方串行的一包 lookahead，补足离线 [AAC 终点归属审计](../scripts/audit_prerecord_minute_aac_schedule.py)中的保管接缝；不提供实时编码器、FIFO、RTOS、文件或相机绑定。

现有 `packet_custody` 保留已经提交的包直到关闭输出独立核验，但不根据视频切点分配包；`owned_mux` 管理上游队列的一次租约，也不决定跨界 AAC 归属。因此此组件复用 `mux_packet`、`frame_desc` 与 `codec_config` 的类型，独立承担切点比较、保留和交接确认，不替代原有组件。

调用方事先验证 raw AAC-LC 与 codec_config，以现有 identity/config_digest 作为配置绑定证明，并提供源时间线 epoch_id、当前 segment_id、当前文件 source_epoch 及精确视频切点。样本必须为固定 1024 ticks，时基为明确 sample_rate，DTS 等于 PTS，且后续包的序号恰好加一、DTS 恰好接上包终点。拒绝包重排、缺口、重复、序号回绕、配置或 epoch 改变；这些不支持的连续性变化会冻结状态，保留已有字节。首包起点及各段 source_epoch 均由调用方提供，组件不会推导共同硬件采集时钟。

`offer` 将完整 AAC 包复制进调用方提供的独占槽位，最多 32 KiB。返回 `READY=1` 或 `NEXT=2` 都表示复制成功并取得独立字节所有权；不是以 `OK=0` 表示成功的 API。只有包的终点不晚于视频切点才返回 READY，跨界包及切点之后的包返回 NEXT，保留到下一段。包 PTS/DTS、原始描述符及 payload 字节不重编码、不修改时间戳。原始描述符的地址只保留为来源记录，不能解引用；如需送入原厂 writer，调用方必须使用独立映射/重定位接缝，不能把来源地址当成当前槽位地址。

成功复制不自动释放上游队列；调用方仍需处理其他 reader。槽位忙、容量不足、时间相加或 ticket 溢出、非法参数都不允许释放上游租约。实现使用精确 96 位乘积比较两个 uint64 ticks / uint32 scale 的有理时间，不需要将视频切点舍入成音频采样点或毫秒，也不依赖可能溢出的 64 位交叉乘法。

`advance` 只接受 NEXT 状态，由调用方确认上一段已完成或恢复后调用。它要求下一段 ID 和切点增加，下一段 source_epoch 不小于旧 origin、不晚于保留 AAC 的 PTS，并且新切点能容纳此完整包。下一段 origin 可以早于第一帧视频。无效 advance 不改变状态，成功后保留同一 ticket 和所有源时间。若调用方提供的新切点仍早于该包终点，拒绝推进；组件只校验显式提供的切点，不推断中间段或替调用方制定分段策略。

READY 的下游交接有三种结果：

- `RETRY_UNTOUCHED=0`：调用方确认下游没有改变字节、索引、游标或事务；保持同一 ticket、字节和元数据，可安全重试。
- `CUSTODY_CONFIRMED=1`：调用方确认另一个独立下游已保管完整字节，保管将持续到关闭后的输出包独立核验完成，或输出已独立验证且持久化；并确认没有 reader 继续使用本槽位。只有此确认可释放槽位。
- `AMBIGUOUS=2`：writer 可能部分提交或状态不清楚，冻结并保留字节，没有自动重放、丢弃或恢复 API。

原厂 ProcessAudio、owned_mux_finish、Close 的成功状态都不足以代替 CUSTODY_CONFIRMED。Close0 可能裁去已经接受的 AAC；调用方需要持续保管并核验最终输出，错误确认无法由此 C 组件识别。错误/过期 ticket、重复 receipt 不能再次释放包。安全重试必须由调用方证明未发生下游副作用，不可用于盲目重试部分写入。

验证命令：

```sh
.venv-reverse/bin/python scripts/validate_prerecord_aac_boundary.py --output-dir /tmp/yi4k-aac-boundary-validation
```

[最终结果](../artifacts/verification/2026-11-11-aac-boundary-owner-run03/validation.json)：32 项 C 场景在本机与编译后的 ARMv7 Cortex-A9 指令中逐项通过，报告相同、调用约定保存；另有 517 项 Python Fraction 独立有理数 oracle，在两种执行环境验证分类一致。ARM ELF 无未解析符号与重定位，不执行原厂固件或硬件。测试覆盖精确等于切点、跨界保留、变更后的上游字节不影响副本、容量失败重试、交接失败保留、歧义冻结、重复提交/receipt、配置与 epoch 改变、源时间缺口、整数极值及 advance 失败事务性。

一项连续测试使用 3003 个合成固定 AAC 包，caller 视频切点为 `1800*1001/30000` 秒：第一段恰好 2815 包，第二段 188 包。包 2815 起点为 `2882560/48000 = 4504/75` 秒，终点晚于 60.06 秒，故整体移入下一段并保留原 epoch。此项验证调度和所有权，不使用可解码 AAC，亦未执行 writer。归档媒体的独立回放另由独立验证脚本记录，不混同此合成测试。

主线程[独立重编译复跑](../artifacts/verification/2026-11-11-aac-boundary-owner-parent-review/validation.json)同样通过全部 32 host/ARM 场景和 517 项有理数比较，ARM ELF 摘要与 run03 相同。另有[真实归档独立回放](prerecord-aac-boundary-owner-independent.md)：3003 包逐包复制后覆盖上游，仍精确分配为 2815/188；4096 项完整宽度有理数比较通过，源码及依赖头文件执行前后摘要一致。这里的下游保管仅为独立 Python 字节副本，不是原厂 writer 或 SD 保管证据。

本组件没有证明实时生产者的 payload 稳定性/缓存一致性、共同 A/V 采集 epoch、SD 持久化、原厂 Close0 修复或固定一分钟预录完成。仍需上游真实租约、下游保管与关闭后核验，以及队列/任务调度、视频 IDR 和段时长策略的独立接入。
