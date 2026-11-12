# 触发历史的持久化保护与进程退出恢复

2026-11-12。主机增量 ring 原先只在 `ClosedMediaStore.pinned` 内存集合中保存触发保护；重建对象会忘记这些文件已被选中。现已在原组件中加入持久化保护，继续复用原有一分钟选择、成片和发布门禁，没有增加另一套 ring。

触发时，`pin_all()` 先以独占创建方式写入 `trigger-pin.json`，包含完整的历史 custody receipt 集合。文件 flush/fsync、父目录 fsync、独立读回一致之后才确认 pin。触发后新闭段的 pin 身份写入该段自身的已同步 sidecar。任一失败冻结存储 owner，不确认成功、不删除历史、不自动重试。

新建 owner 发现旧 custody 或 pin 文件时拒绝静默接管。显式 `ClosedMediaStore.recover()` 只读重扫全部 sidecar、逐文件重新核对字节数/SHA，并检查触发清单引用的 receipt 没有缺失或变化。恢复结果始终 frozen，所有已验证文件均被保护；即使没有触发清单，也不能由此推断之前没有触发。未取得 receipt 的 producer 文件单独列为保留材料，不冒充已关闭、可播放或完整。容量超限仍允许读取恢复材料，但不恢复写入或淘汰。

这个恢复对象不具备重启 producer、解除 frozen 或删除选中片段的接口。上层必须先独立证明 producer 静止、重建时间线及触发/停止状态，不能仅由文件存在推定 RTOS callback 已停止。

## 实际失败验证

运行：

```sh
python3 scripts/validate_prerecord_media_store_recovery.py \
  --output /absolute/path/to/new-host-recovery-evidence
```

[12 项验证回执](../artifacts/verification/2026-11-12-prerecord-custody-crash-run01/validation.json)记录了原有保管/容量/失败冻结测试，以及新 owner 拒绝、触发前后文件恢复、pin 同步失败、缺失/变更 receipt、满容量恢复和符号链接拒绝。

其中一个测试真实创建子进程并以 `os._exit(71)` 终止写入方，覆盖七个退出位置：admission 前、admission 后、pin 文件截断、pin 文件 fsync 后而目录同步前、pin 确认后、触发后 payload 尚无 receipt、触发后 receipt 完成。恢复方核对退出码及文件集合；完整材料只读恢复为 frozen，截断 pin 拒绝恢复，所有场景不改变任何保留文件。它验证主机进程退出边界，不等于 SD 控制器断电耐久性。

真实归档到 MP4 的恢复入口也改为先重开这些独立 sidecar，与失败 manifest 的集合核对后才复制 payload。原片仍只作为构建完成后的验证 oracle；不能从原片补齐缺失数据。当前失败恢复入口依然需要完整的失败和预发布 manifest，这次没有实现任意时刻进程退出后的自动成片。

[真实媒体 run01](../artifacts/verification/2026-11-12-prerecord-durable-pin-run01/validation.json)的三条路线全部通过：voice 发布前中断后从 31 份 sidecar 以 frozen 身份恢复、篡改保留片段拒绝发布、shutter 独立增量回放并发布。两份成片仍为 347,836,390 字节，SHA-256 均为 `9b9cac86840a00e9781ce9a2428eb4ac91f4474c6d93feebd1b02d4b48ed505c`；严格门禁继续核对 1856 视频包和 2902 AAC 包，时间偏移及 duration 误差未放宽。相关[48 项预录回归](../artifacts/verification/2026-11-12-prerecord-durable-pin-regression/validation.json)全部通过，无 skip。

## 证据边界

JSON/摘要用于本机保管一致性，不提供对恶意同时重写媒体和 receipt 的身份认证。单一 owner、新建专用目录及无并发外部改写仍是前提；普通 `fsync` 和读回不能替代物理 SD 掉电、拔卡、坏块、满卡持续吞吐、相机共同采集时钟或源覆盖封口。没有访问或修改相机。

实现：[prerecord_media_store.py](../scripts/prerecord_media_store.py)；失败回放：[validate_prerecord_media_ring.py](../scripts/validate_prerecord_media_ring.py)；原链路与历史 run02 见[增量 ring 成片记录](prerecord-media-ring-end-to-end.md)。历史回执只对应各自记录的源码摘要，本次改动不能沿用旧摘要宣称重新执行。
