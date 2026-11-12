# 原厂关闭失败与末尾持有包的 POSIX spool 恢复

新增 `scripts/recover_prerecord_retained_spool.py`，将此前真实组合运行实际留下的 C custody/owner 快照写入编译后的 spool，再由全新进程读取恢复。已恢复关闭失败时的8个视频包、12个音频包、持有的边界 AAC12，以及正常末尾仍由 owner 持有的 AAC25，共22个实际保留包。所有恢复 payload 和已记录规范元数据均与原快照清单精确一致。

没有读取原片 MP4 补缺包，没有再次运行原厂 mux，没有构建或宣称完整录像。整个原始窗口的发布门禁继续 **reject**。

## 复现及固定输入

```sh
.venv-reverse/bin/python scripts/recover_prerecord_retained_spool.py \
  --output artifacts/verification/2026-11-11-prerecord-retained-spool-recovery-new-run
```

最终证据为 `artifacts/verification/2026-11-11-prerecord-retained-spool-recovery-run02/audit.json`。同目录保存实际 POSIX C wrapper、编译库、两个正常 spool、两种截断负例、外部期望快照清单，以及每个新进程的 `readback.json` 和逐包恢复文件。

唯一媒体输入是 `artifacts/verification/2026-11-11-prerecord-aac-custody-native-integration-run03` 中已经生成的快照：

- `close_failure/custody-seg1-track0-slot0..7.bin`：真实原厂 Close0 短写后冻结的8个视频槽。
- `close_failure/custody-seg1-track1-slot0..11.bin`：相同失败后冻结的12个音频槽。
- `close_failure/held-boundary-aac12.bin`：关闭失败后仍在 C owner NEXT 的边界包。
- `normal/final-held-aac25.bin`：正常短窗口结束后仍在 C owner NEXT 的末尾包。

冻结 integration audit SHA256 为 `53d9d44471a71b35af4dd83049640310eaeae57b1edc4ce7665eea089c682471`。恢复先检查该摘要、它固定的原实现/头文件摘要，再核对每个 bin 与 audit 的包 SHA。结束后重新核对原快照未变化。不会把原有 frozen C 控制器“解冻”或丢弃其材料。

## 元数据范围

原失败快照文件只保存 payload；audit 记录了规范 sequence、PTS/DTS、type/flags/length，并保存正常第一段关闭文件的零epoch精确时间表。恢复使用这一冻结映射绑定失败槽的元数据：第一段视频0–7、AAC0–11，以及audit记录的heldAAC12/25。音频时基48000、duration1024，视频时基30000、duration1001。

旧快照没有完整保存 descriptor 的源地址和 reserved 字段，因此本项 **不声称完整位级 descriptor 恢复**。新 spool 中源地址明确设为未知0、reserved为0，且只作不解引用的 provenance 字段。恢复保证覆盖已记录的规范元数据和每个 payload 字节。

config_digest 保留冻结 integration C wrapper 实际使用的32个 `0x02`，属于该离线调用者的外部配置 attestation。它没有从AAC推断配置，也不是硬件配置事件或共享时钟的认证。

## 实际存储与新进程恢复

独立 POSIX adapter 以 `O_EXCL` 创建新文件并 fsync 父目录；每个 append 实际执行 header+payload、fsync、commit marker、fsync、pread 独立回读，只有编译 C spool 返回OK才覆写上游输入缓冲。所有原始bin本身仍保持不变。

写入进程关闭文件后，以全新 Python 子进程加载同一编译库，以新的只读 fd 执行 C spool_scan。回调只复制到 staging 文件；扫描结束后，外部期望快照清单逐条检查 ordinal、source_kind、sequence、DTS、PTS、scale、duration、type、flags、长度和SHA。只有扫描成功且清单完整一致，才把 staging目录改名为 `verified-snapshot-set`。主进程又重新读取恢复文件，逐字节比较原始C快照，而不是只相信子进程状态。

这是 host POSIX fsync与跨进程读取证据，不是SD掉电、控制器缓存、介质耐久性或RTOS存储绑定证明。期望清单仅用于本次独立完整性门禁，没有实现生产环境的持久化密封manifest生命周期。

## 正负例结果

| 场景 | C扫描 | 实际恢复记录 | 外部快照完整性门禁 |
| --- | --- | --- | --- |
| Close失败20槽+heldAAC12 | OK | 21/21 | pass |
| 同文件在最后记录之前恰好截断 | OK，有效前缀 | 20/21 | **reject** |
| 同文件最后commit marker截断12字节 | INCOMPLETE(-5) | 20/21 | **reject** |
| finalheldAAC25 | OK | 1/1 | pass |

两个负例仅留下 staging材料，没有 `verified-snapshot-set`。这实测说明 **C scan返回OK仍不能证明完整快照或完整会话**，记录边界截断必须由外部期望覆盖门禁发现；没有让扫描前缀替代整段发布。

正常21记录spool SHA256为 `162c78775a7f23829ac475fbabee4064e92f8d0b0e6015ef1efad8e423126eb1`。独立AAC25 spool SHA256为 `39b45734db911d4c842b9b69ea2227610fc27ba26f4c9ebc159f4e30a53c948c`。

主线程审查原输入绑定、metadata缺失声明和子进程门禁后，[独立复跑](../artifacts/verification/2026-11-11-prerecord-retained-spool-recovery-parent-review/audit.json)同样恢复 21+1 个实际包，并拒绝20记录合法前缀和20记录加torn marker的两个负例。原快照未修改，完整录像发布保持reject。

## spool 复审与范围

冻结 spool C/H 摘要分别为 `300196050a915e8bf2716044c3ddde718f45379d9d08c407a9326116ebfa9ebe` 和 `36758602a36841d8253daa57d069399387b74baaac0adee45945e14ce516ba80`，与主验证 `2026-11-11-packet-spool-run02/validation.json` 的31个host/ARM案例版本一致。此前审查反馈已在合同中明确：存储回调错误/短IO冻结；纯前置拒绝不等同于部分写入；视频语义需调用者验证；扫描回调必须暂存；完整前缀不证明整段完整；host fsync不证明SD掉电耐久。

本恢复没有扩大原短窗口范围：关闭失败的前20槽加held12尚无后续8帧等原窗口完整材料；另一个正常场景的AAC25仅独立保留。不会把不同运行的材料拼成完整42包录像，也不会读取源oracle填补它们。仍缺真实生产者lookahead所有权、长时环形缓存、并发队列、实机callback、耐久manifest协议以及错误恢复后安全重启mux的目标绑定。
