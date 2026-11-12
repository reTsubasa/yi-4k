# 预录原包保管层：关闭成功也不提前释放

新增的 C 层把原包复制进独立、容量有界的 RAM 保管区，再释放 early-copy 队列的借用槽。原厂 `ProcessAudio/Video` 返回成功和 `Close(0)` 返回成功都不构成保管区回收许可。只有最终输出的逐包字节、顺序与原始身份全部核对，且调用者确认没有残余读取依赖，才能一次释放该轨整段。关闭失败、缺包、重复、乱序、改字节、改 PTS 或错误分段身份会冻结事务，全部已保管原包仍可读取。

实现：[packet_custody.h](../sdk/yi4k_1107_packet_custody.h)、[packet_custody.c](../sdk/yi4k_1107_packet_custody.c)。新增独立模块，没有改变原 SDK 或冻结原厂 mux 审计脚本。它没有安装钩子、连接相机、执行 RTOS 真机代码或写入设备。

## 实际接缝与所有权

离线 fixture 运行实际既有 `early_offer_frame → owned_mux_prepare`，随即把源环写为 `EE`，将 held packet 复制到 custody，再通过 `owned_mux_finish(0,1)` 释放 early-copy 槽。后续原包会复用、覆盖两个早期槽，但保管字节仍保持不变。

fixture 的 `payload_use_complete=1` 只表示**测试没有 writer、DMA 或文件消费者持有早期槽**；不能把这个例子理解为真实 writer 完成前即可释放。实际接线必须先持有原包，再让 codec/writer 使用各自合法的租约，直到 writer 的实际内存依赖结束。原厂码流的 SPS/PPS 注入及容器长度前缀变化不在本层实现，最终读回若需要归一化必须由独立解析器准确完成。

一份实例只接受一个轨、一个串行所有者，sequence 与原始 corrected PTS 在段内严格增加；不同轨使用独立实例。两轨各自检查通过仍不是 A/V 文件发布许可，最终发布协调器还必须同时检查共同 epoch、轨配置、DTS/duration、精确时间线、视频独立解码点与持久存储条件。MP4 不含原 FIFO sequence，原序号/PTS 映射是调用方证明，虚假的映射无法由此 C 模块辨别。

存储满返回 `FULL`，不会覆盖未验证字节，也不会释放 held upstream 槽。调用方必须停止消费并报告容量不足。源编码器若继续生产，既有有界早期队列最终会满并拒收；本层没有将“不丢已保管材料”扩大成“任何压力下编码永不丢帧”。失败状态没有 reset/retry/discard API，防止在原厂文件/索引可能部分写入后无依据地继续提交；恢复还需要外部流程将保管材料重建到新输出并重新验证。

## 验证与真实缺包负例

[验证器](../scripts/validate_prerecord_packet_custody.py)编译实际 C 源码为宿主动态库与 Cortex-A9 ARM ELF，在 Unicorn 合成 RAM 中执行后者。每次调用核对宿主/ARM 返回值、12 个状态字和完整 32 KiB 保管区；同时核对 R4–R11/SP，ELF 无未定义符号和链接后 relocation。

[最终 run01](../artifacts/device/2026-11-11-prerecord-packet-custody-run01/validation.json)包含 **34 个 host/ARM 场景、268 次配对调用，以及 2 个已有原厂完整封装结果的负例**。覆盖视频/音频各自的正常回收、存储满、单槽容量不足、Close 失败、缺失/重复/额外/乱序回执、字节/PTS/segment 改变、自证 alias、缺失 use-complete、重复入库和 PTS 逆序、空段关闭、提前提交。失败后 begin/commit 不能绕过冻结。

负例直接读取[原厂 event 3 审计](prerecord-event3-rollover.md)归档的两段 MP4，不用本轮伪造 mux 成片：

| 输入 | 已保管源 AAC | 最终 MP4 读出 | 结果 |
| --- | --- | --- | --- |
| 第一段 | 0–12 共 13 包 | 0–11 共 12 包 | `commit=-5`，保留全部 13 包，包括 AAC12 |
| 第二段 | 13–25 共 13 包 | 13–24 共 12 包 | `commit=-5`，保留全部 13 包，包括 AAC25 |

逐个实际 MP4 文件 extent 读出的 AAC 字节，与独立原片映射对应后交给 C 检查。最终结果保存缺失两包 `.bin` 和 SHA-256；这两包原本没有出现在可导出 MP4 索引中，现在可以从保管材料提取。**尚未实现将其重新封装成完整可播放分段**。第二段原有精确 `-1/240000s` 时间偏差单独核对仍被拒绝；本轮包核对没有放宽时间线容差，也没有称源身份映射已由 MP4 自行认证。

本轮没有再次执行原厂 mux；使用已有冻结 event3 的正常产物，报告记录输入文件摘要。测试不证明 SD flush、断电持久性、真实 CFS 恢复或实时吞吐。RAM 在崩溃或断电后会丢失；要满足最终预录要求，必须配套常驻 spool、同步提交与外部恢复。

## 容量与 60 秒历史

本轮 fixture 固定 16 槽，每槽 2048 字节，仅够验证 AAC 和短合成视频包；**不能作为 60 秒容量配置**。部署前必须按实测峰值、最大视频 AU、闭合延迟和可分配资源计算，没有合适容量必须拒绝启用。

以示例 60 Mb/s 视频、192 kb/s AAC 计算，60 秒原始 payload 至少为 `60 × (60,000,000 + 192,000) / 8 = 451,440,000` 字节，约 **430.5 MiB**，另加 metadata、codec 缓冲、索引、对齐和安全余量。这只是示例码率，不能声称相机有足够独占 RAM。若视频 30 fps、AAC 48 kHz/1024 samples，则一分钟约需 1800 个视频样本与 2813 个 AAC 样本，VBR 峰值和关键帧尤其不能按平均包大小分固定槽。

常驻 spool 可以把完整一分钟历史放在存储上，RAM custody 只跨越“写入到最终封装验证完成”的窗口。例如同样示例码率、2 秒分段、暂同时持有两个段，payload 约 30.1 MB（28.7 MiB），但必须再覆盖 codec、最大包及验证并发。Close 失败的保管时间没有有限保证；达到配置上界时应冻结/停用新采集，不能无限占用或覆盖未恢复样本。当前模块既不提供常驻 spool，也没有证明可分配这些容量。

## 复现与冻结

```sh
.venv-reverse/bin/python scripts/validate_prerecord_packet_custody.py \
  --output-dir /tmp/yi4k-custody-independent
```

输出目录必须不存在。验证器 SHA-256：`484ccef9d98a89c83cd2df2e6a01f14158283668f10fbc2dd8a23d7aa93fe1ed`。完整源码/头文件/fixture 摘要在报告中；每次结束核对输入不变。`/tmp/yi4k-custody-dev01` 是较小的 26 例开发验证，`dev02` 是补全后的 34 例验证，均不替代最终归档。该进展提供了关闭前后原包所有权与失败保留的具体实现，尚未完成相机预录、最终重封装、真实故障恢复或语音/实体快门接线。
