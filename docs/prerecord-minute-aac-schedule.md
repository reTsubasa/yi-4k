# 一分钟换段 AAC 归属与 ISO 时间线判别（2026-11-11）

只把跨越 60.06 秒切点的完整 AAC 包 2815 留给第二段，就能在原厂 event3 和正常 Close0 下完整导出所选 64.064 秒的 **1920 个视频包和 3003 个 AAC 包**。全部包按源顺序 SHA 匹配、无缺无重，两段视频均严格解码匹配对应源帧，音频均匹配全部提交包的独立 AAC 解码序列。未使用未知 Close1，也未跳过原厂 Trim。

严格消费者时间门禁仍为 **reject**。第一段全部通过；第二段全部 PTS/DTS、AAC duration 和包内容通过，仅消费者报告的末视频包 duration 少 1/150 秒（6.6667ms）。这一拒绝没有被隐藏或改为容差通过。

## 实验与证据

```sh
.venv-reverse/bin/python -u scripts/audit_prerecord_minute_aac_schedule.py \
  --output artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-new-run
.venv-reverse/bin/python scripts/review_prerecord_minute_aac_schedule.py \
  --input artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-new-run
```

- 主报告：`artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01/audit.json`。
- 独立逐包身份、源 epoch、STTS/空编辑重建及消费者对照：同目录 `timing-review.json`。
- 日志：`artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01.log`。
- 原厂输出：同目录 `native-segment-1.mp4`、`native-segment-2.mp4`。

脚本复用已固定摘要的一分钟 event3 离线模型；原厂限时仍是 60000ms，正常关闭参数仍是 0。输入与原厂镜像分别保留此前 65 秒归档和固定 1.10.7 ARM 镜像摘要。实验没有访问设备或修改冻结脚本。

## 调度变化及实际结果

| 项目 | 原 run02 按包起点分段 | 本次按 AAC 包结束点分段 |
| --- | --- | --- |
| 第一段提交/导出 AAC | 2816 / 2815 | 2815 / 2815 |
| 第二段提交/导出 AAC | 187 / 187 | 188 / 188 |
| 跨界 AAC 2815 | 进入第一段后被 Trim 删除 | 暂留并完整进入第二段 |
| 源包总覆盖 | 缺 2815 | 0–3002 全部且各一次 |
| 原厂 Reset 后 video/audio DTS，时基 240000 | `[0,3520]` | `[1600,0]` |
| 第二段音视频相对关系 | 音频晚 14.6667ms | 视频晚 6.6667ms |
| 严格消费者门禁 | 拒绝 | 仍拒绝，仅末视频 duration 偏差 |

跨界 AAC 2815 的源窗口为 `[60.053333…,60.074666…)` 秒。第一段只提交在 60.06 秒之前完整结束的 AAC；第二段完整保留这个跨界包。原厂 Reset 自动选取最早音轨作为共同 epoch，不需要分别归零或改写内部 DTS。第二段源 epoch 因此为 `4504/75=60.053333…` 秒，首视频仍精确位于源 60.06 秒。所有严格比较均使用这一由原厂 Reset 确定的共同源 epoch，音视频相对关系未移动。

边界第 1800 帧仍返回 3，不消费描述符；FIFO、descriptor 和 cursor 在原厂 Close/New/Copy/Rel/Reset/Open 前后相同。保留视频只重新提交一次，再提交暂留的 AAC，各轨内部源顺序保持不变。

## 容器与消费者的判别

第二段原厂视频 STTS 是 120 个完整 1001-tick 样本，media clock 为 30000；ELST 是 200-tick 空编辑加 120120-tick 完整媒体编辑。音频 STTS 是 188 个完整 1024-tick 样本，media clock 为 48000；媒体 duration 为 192512 ticks，即 120320 个 movie ticks。视频延迟加完整媒体长度也正好是 120320 movie ticks。TKHD/MVHD 与这些时长自洽。

因此，按 MDHD 的完整媒体长度重算 ELST/TKHD/MVHD 的宿主副本没有改变任何字节（两段 `iso_changes=[]`），也没有修复消费者拒绝。它没有被宣传为成功的 ISO 修复。

固定消费者 `ffprobe 6.1-tessus` 的普通与 `-ignore_editlist 1` 结果如下：

| 第二段视频 | 首 PTS | 末 PTS | 末 duration |
| --- | --- | --- | --- |
| 普通，应用 edit list | 200 | 119319 | **801** |
| 忽略 edit list | 0 | 119119 | **1001** |
| STTS + 200-tick 空编辑的精确重建 | 200 | 119319 | **1001** |

这将剩余问题定位到消费者应用 edit list 后报告 duration 的行为；结果与按未平移的 duration 裁剪相符，但没有审计该消费者内部实现，不能据此宣布所有播放器都存在同样问题。

独立 review 对忽略 edit 后的真实导出包检查 STTS，再按原始空编辑精确重建时间；两段逐包 SHA、PTS、DTS、duration 与共同 epoch 下的源时间全部通过。这个额外诊断 **不替代普通消费者门禁**，后者仍保留 `reject`。没有增加不存在的媒体时间、延长样本、重编码、重写 sample tables，或仅因解码成功就放宽精确时间要求。

## 源时间与集成限制

第一文件时间范围到 60.06 秒，第二文件共同源 epoch 为 60.053333… 秒，因此文件范围交叠 6.6667ms；各轨媒体本身仍连续：第一段 AAC 到 60.053333… 秒，第二段 AAC 从同点开始；视频第一段到 60.06 秒，第二段也从同点开始。导出/会话重建必须保存每段源 epoch，不能把 MP4 file duration 直接相加，否则会推迟下一段视频。这里没有把跨轨文件范围交叠误判为包重复。

这项结果是可供后续实现验证的具体调度候选：切段前保有一个完整 AAC lookahead 包，将其归下一段，并保留共同源 epoch。仍未证明真实生产者队列的 lookahead 所有权、并发调度、实时性能、SD 持久化、错误恢复、相机回调安装或完整预录功能。下一步应以严格消费者拒绝为基线，决定会话级原始包重建或兼容消费者策略，而不是使用来源不明的关闭参数。

## 2026-11-12 后续

[原厂 ARM 最终会话导出](prerecord-native-session-export.md)已从这两段封口文件恢复共同源时间，再通过独立原始ARM mux会话生成普通消费者逐包精确通过的连续文件。该最终导出请求64064ms输出边界，不改录制event3的60000ms限时；本页原厂第二段末duration拒绝仍保留。新增原厂edit构造器执行与消费者端点公式证据解释剩余801-tick报告，但没有据此放宽本页门禁。
