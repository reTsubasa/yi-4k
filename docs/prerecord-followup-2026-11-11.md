# 预录目标续推：保管、切段与触发边界

日期：2026-11-11。本文把本轮继续复跑的预录证据收敛到同一索引： [独立续推索引](../artifacts/verification/2026-11-11-prerecord-followup-index.json)。所有结果都在主机或编译 ARM 的合成内存中完成，没有安装相机 hook、执行 RTOS、写入固件/RAM/分区/SD，也没有把离线结果升级为真机完成。

## 已推进的离线门

- `packet_custody` 独立复跑通过 34 个 host/ARM 场景。视频和音频都覆盖正常回收、容量不足、Close 失败、缺失/重复/额外/乱序回执、字节和 PTS 改变、错误 segment、别名、提前提交和空段关闭。失败后原始保管字节保持不变，状态冻结，不能盲目重试。
- event 3 正常链继续实际执行 `Close(0) → NewMovieInfo → CopyMovieInfo → RelMovieInfo → ResetMovie → Open`。同步视频边界帧保留并能解码；发布门仍拒绝跨界 AAC12/AAC25 丢失，以及第二段消费者时间线偏移。
- Close 短写对照继续保留原始故障：旧 movie 仍挂接、文件流未关闭、新 movie 尚未分配，原厂路径进入 assert。这个结果定义了“必须先停消费并保留可恢复材料”的停止条件，不能当作设备侧安全恢复。
- SDK 组合链继续验证 early-copy、owned mux、codec epoch 和 writer 的失败持槽位语义。触发路由的既有 host/ARM 13068 项语义检查也保留，语音 START/STOP 与物理短按只是类型化动作和异步回执模型。

## 仍未闭合的目标

真实相机仍缺 callback 静止期、payload 稳定和 cache 所有权证明；跨界 AAC 仍须在合法 mux 边界前保持独立所有权。还缺共同 A/V 采集 epoch、连续一分钟 SD spool、满卡/拔卡/掉电恢复，以及相机侧准确口令 `开始录像` / `start recording` 和实体快门事件的实测绑定。原生执行和可回滚恢复路径闭合前，不进入设备写入或运行期替换。

复现入口：

```sh
.venv-reverse/bin/python scripts/validate_prerecord_packet_custody.py \
  --output-dir artifacts/verification/2026-11-11-prerecord-packet-custody-independent-run02
.venv-reverse/bin/python scripts/audit_prerecord_event3_rollover.py \
  --output artifacts/verification/2026-11-11-prerecord-event3-independent-run02
.venv-reverse/bin/python scripts/validate_capture_trigger.py
```
