# C AAC owner、C custody 与原厂 event3 的组合验证

新增 `scripts/integrate_prerecord_aac_custody_native.py`，实际组合编译后的 `yi4k_1107_aac_boundary.c`、`yi4k_1107_packet_custody.c` 与原厂 ARM ProcessVideo/ProcessAudio/event3/Close0。真实归档包驱动 C owner 决定音频归属；Python 没有预先把 AAC 列表分配给两个文件。

本轮正常链、容量反压、关闭失败三个场景均通过各自预期检查，发布门禁仍是 **reject**。该结论是短窗口离线组合验证，不是可部署的实机预录。

## 复现与证据

```sh
.venv-reverse/bin/python -u scripts/integrate_prerecord_aac_custody_native.py \
  --output artifacts/verification/2026-11-11-prerecord-aac-custody-native-integration-new-run
```

最终报告：`artifacts/verification/2026-11-11-prerecord-aac-custody-native-integration-run03/audit.json`。同目录保留独立 C wrapper、编译库和三个场景的输出/保留包。报告保存实现与依赖头文件、冻结原厂执行 harness 的摘要，结束后重新核对源文件未变化。

主线程审查实际 C store/receipt 与原厂 writer 的先后关系后，[独立重编译复跑](../artifacts/verification/2026-11-11-prerecord-aac-custody-native-parent-review/audit.json)再次通过正常、容量和原厂关闭短写三个场景。完整发布继续拒绝，没有用 custody 的源字节校验替代消费者 duration 或尾部覆盖门禁。

输入使用此前真实短归档源的前16个 I/P 视频包和26个 AAC 包。视频窗口为 `[0,16016/30000)` 秒，按源包起点收集 AAC；第25个 AAC 的完整结束时间超过这个视频尾部。原厂短测试限时为200ms，于视频8的关键帧 `8008/30000` 秒触发真实状态3。它刻意复用冻结短 event3 的限时，不声称已经再次执行60000ms一分钟边界；一分钟基础证据另见既有文档。

## 组合所有权路径

1. 按实际归档包顺序提交。AAC 输入首先经编译 C owner 的完整包 `end<=split` 判定，offer 成功后立即覆写上游输入内存，并检查 owner bytes 未受影响。
2. READY 的音频先执行真实 `yi4k_1107_custody_store`，成功复制到独立 C custody 后，才给 owner `CUSTODY_CONFIRMED`。此回执证明这里的另一个 C 槽持续持有字节，不是 writer 成功回执。
3. 从 C custody 的实际副本提交原厂 ProcessAudio；每次 writer 成功后检查 custody 仍在 COLLECT 状态，没有因此释放。视频也先经 C custody 复制再提交原厂 writer。
4. AAC12 的 end 超过第一段视频切点，C owner 返回 NEXT。原厂 event3 执行完整 Close0/New/Copy/Rel/Reset/Open，边界视频8的 FIFO/descriptor/cursor 保持不变。
5. 从原厂关闭文件真正写出的字节建立宿主文件并重新读取。忽略消费者 edit 裁剪读取样本表，再使用原始空编辑和共同源 epoch 精确反向映射 PTS；只有可精确恢复的 canonical source PTS/sequence/type/flags/length 与独立文件 extent 才传给 C custody_check。实际 payload 来自关闭文件 readback，不能引用 custody bytes 冒充验证。
6. 每轨所有检查成功后才调用真实 C custody_commit，提交槽归零。消费者严格时间门禁独立运行，不因 custody payload/identity 校验通过而放宽。

原 descriptor sequence 是归档调用者映射，MP4 无法认证原 FIFO 序号。这里的精确时间反向映射没有使用舍入修补，也没有把 payload 校验等同于消费者 duration 通过。

## 正常场景的实际结果

| 项目 | 第一段 | 第二段 |
| --- | --- | --- |
| 原厂输出视频 | 0–7，共8 | 8–15，共8 |
| 原厂输出 AAC | 0–11，共12 | 12–24，共13 |
| 真实 C closed-output check | 20包全部通过 | 21包全部通过 |
| C custody commit后 | 两轨均IDLE/count0 | 两轨均IDLE/count0 |
| 视频 decode | 8帧逐帧匹配源 | 8帧逐帧匹配源 |
| 连续已提交 AAC PCM | 全匹配 | 全匹配 |
| 严格消费者门禁 | pass | reject |

AAC12 由 C owner 决定跨界保留，advance 后 source epoch 为 `12288/48000=0.256` 秒；原厂 Reset 得到 video/audio DTS `[2624,0]/240000`，视频相对音频晚 `41/3750=10.9333…ms`。保留的视频8只消费一次；随后 AAC12 的 C 副本进入第二段。

第二段消费者末视频包 duration 短 `41/3750` 秒，严格门禁继续拒绝。该行为与此前“延迟轨道 STTS完整但消费者末包 duration 裁剪”判别一致，没有据此修改门禁。

最终 AAC25（源 PTS=25600，时基48000，321字节，SHA256 `ab05749b33fdaeb529f011f7cafc05c6522815c0280357407fbec87c1ffb0cf4`）在第二段尾部再次由 C owner 返回 NEXT。它没有被提交 writer，也没有释放。原字节留在 owner，并导出为 `normal/final-held-aac25.bin`。没有伪造第三段、未知终点或未知 Close1 来让它消失。因此42个源包中，41个在实际关闭文件，最后1个仍被 caller owner 保留；不能把当前两个文件发布为完整26 AAC覆盖。

## 反压与原厂关闭失败

容量场景把每段音频 custody 限制为11槽。AAC11 到达时 owner 处于 READY，C custody_store 返回 FULL；脚本不提交该包给原厂 ProcessAudio，也不回执释放 owner。实际原厂只收到11个 AAC，owner仍保留 AAC11（ticket12），C custody保持8视频/11音频。所有未commit槽在场景结束逐字节重新核对原提交包，并独立落盘；没有让槽数溢出后继续运行。

关闭失败场景在第一段原厂 Close0 的第一个写操作注入模型短写。原厂 callback 真实执行至断言；没有创建下一 movie。调用 C custody_closed(failure) 后，两轨均FROZEN：视频8槽、音频12槽全部保留，checked=0。与此同时跨界 AAC12 仍为 owner NEXT，字节未变；脚本保留它、全部C槽及原厂部分输出。没有自动重试或把错误改成成功。

`run01` 是首轮成功组合；`run02` 添加保留字节复核时，审计器误要求已commit的空槽还保有活动count，该次失败JSON保留。`run03` 修正这一审计断言：IDLE必须count0，未commit槽必须逐字节匹配其实际提交列表。没有修改C实现、冻结harness或原厂ARM。

## 剩余缺口

C owner/custody仅保留RAM，没有耐久spool、掉电恢复、冻结事务恢复生命周期或真正生产者并发调度。主机将文件写出并readback不证明fsync/物理SD持久化；实际产品仍需在释放任何唯一副本前建立耐久custody。身份/config attestation仍来自离线调用者，未认证实机公共硬件时钟。

后续新增[追加包日志](prerecord-packet-spool.md)与[实际快照新进程恢复](prerecord-retained-spool-recovery.md)，补上上述失败材料的宿主文件保存/重新读取证据。它们未改变本次 C RAM controller 的生命周期，也未把物理 SD、正常 producer 或冻结事务恢复后重启 writer 的缺口追溯升级为完成。

本项执行的是host编译C控制器加Unicorn原厂ARM mux，文件/OS/命名服务为显式RAM模型；没有连接设备、安装回调或运行实际SD。后续合理步骤是为最终NEXT包、Close失败事务及未验证槽建立独立耐久host spool及恢复门禁，再考虑真实目标队列/存储绑定。原厂分段消费者时间拒绝和末尾包归属均应保留为独立验收项。
