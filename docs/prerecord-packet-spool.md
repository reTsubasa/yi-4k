# 编码包追加日志与宿主恢复

[C 接口](../sdk/yi4k_packet_spool.h)和[实现](../sdk/yi4k_packet_spool.c)为自有编码包提供一个追加式保管文件。它把 RAM custody 的恢复材料交给明确的存储适配器，保留源描述符、音视频轨道、PTS/DTS、时基、duration、session/segment/epoch 和配置摘要。每次调用只需要一个调用方指定大小的读回缓冲，不把一分钟码流放进 RAM。

接口没有相机地址、原厂文件 API、回调安装、任务、环形淘汰或文件名删除。当前 POSIX 绑定仅在验证脚本中存在；尚未接入 RTOS/SD 后端或正在编码的生产者。

## 提交顺序

每条记录使用固定 160 字节小端头、完整 payload、24 字节提交标记。头、payload、提交标记分别有 CRC32；CRC 只检出意外损坏，不提供认证。

实际顺序是：写头和 payload → 存储 sync → 写提交标记 → 再次 sync → 从存储单独读回头、payload、标记并逐字节核对 → 检查文件长度 → 更新本地 offset/ordinal 并返回成功。存储回调必须同步完成，`sync` 必须覆盖该适配器声明的持久性域。

任何存储错误、短写、短读、同步失败、读回不符或文件长度变化都会冻结 writer。即使完整记录已经写入，也不允许调用方据失败返回释放唯一副本、盲目重试或原地续写。冻结后只能用独立只读扫描器检查新文件，并由外部恢复生命周期决定后续动作。参数、容量、时间溢出和连续性等 I/O 前置拒绝保持原状态，允许修正未提交输入。

视频与 AAC 的序号、时基和源时间分别检查连续，DTS 必须等于 PTS，不隐式修正缺口或重排。视频 type 范围不能代替 NAL 语义验证；codec 与共同采集时钟由调用方预先验证。原 descriptor 地址仅为来源记录，恢复时不能解引用，送入 writer 前必须重新映射。

## 扫描与完整性边界

只读扫描逐条验证身份、顺序、CRC、提交标记和轨道连续性。末条头、payload 或 marker 不完整时返回 INCOMPLETE，保留已经独立验证的前缀；完整但损坏的记录返回 MISMATCH，不跳过坏记录继续读取。

扫描回调只能暂存结果。最终文件大小复核、完整扫描状态和外部 expected-count/coverage 门禁通过前，不能从回调发布成片或回执释放最后副本。

**扫描返回 OK 也不证明完整会话。** 空文件或恰好在记录边界被截断的文件可以构成合法前缀。必须另外保存封口清单、期望包数/轨道范围、停止和触发边界，并与完整源覆盖核验。当前格式没有终止记录，不冒充已解决掉电后全部会话完成判定。

## 已执行验证

[验证脚本](../scripts/validate_packet_spool.py)及[run02 回执](../artifacts/verification/2026-11-11-packet-spool-run02/validation.json)：

- 31 个主机/编译 Cortex-A9 ARM 场景逐项报告相同，检查 R4–R11/SP 和无未解析符号/链接后重定位。覆盖所有写入、同步、读回阶段失败/短操作、读回篡改、连续性拒绝、真实双轨交错、非法轨道/视频类型、扫描回调拒绝、最终 size 变化、记录边界截断及空文件。
- 实际 POSIX 文件追加 3003 个真实归档 AAC 包，每次经历双 fsync 和独立 readback；成功后覆盖上游内存，文件中完整字节仍与输入逐包一致。文件关闭后用新的 C reader 扫描，另用 Python/zlib 独立解析格式与 CRC，再核对源 payload SHA 顺序。
- 新子进程在 8 个写入/同步/读取阶段 `_exit(73)`。新进程结束后，独立读取真实文件：提交标记前的截断只得到未完成前缀；完整 marker 已到达的情况可恢复该记录，但不能追溯给已退出 writer 一个成功回执。
- POSIX adapter 使用 O_EXCL 创建新文件，并同步父目录项；不覆盖既有文件。记录 I/O 是位置写入，单次短操作就冻结，不以自动重试掩盖不确定提交。

[独立重编译复跑](../artifacts/verification/2026-11-11-packet-spool-independent-run03/validation.json)再次通过全部 31 host/ARM、3003 实际 AAC 和 8 个进程退出点。另行逐字段核对实际日志的 3003 个描述符、时间、类型、flags、来源地址、payload 长度与 CRC；20 个源码/依赖摘要与 run02 及当前文件一致。两次实际 AAC 日志均为 1,577,576 字节，SHA256 `4fc6bea71943aa3687a27761b4708f65d3e13a7905472e36d2e5dc882ea47c8c`。

```sh
.venv-reverse/bin/python scripts/validate_packet_spool.py \
  --output artifacts/verification/new-packet-spool-run
```

这是主机文件、fsync 和进程退出证据，**不是物理 SD 掉电/拔卡耐久性证明**。真实文件系统、驱动、卡控制器对 flush 的保证必须另行验证。当前也不证明一分钟容量、持续码率吞吐、满卡恢复、片段淘汰、语音/快门触发或最终 MP4 发布。
