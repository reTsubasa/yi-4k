# YI 4K 原厂循环录像与预录能力矩阵

更新时间：2026-11-10。对象为当前可达的 YI 4K 1.10.7（`a8f840ce_r2746`）。本轮只查询 `msg_id=1/3/9`，没有调用 setter、录像、取景或事件操作。

## 只读设备结果

证据：[api-snapshot.json](../artifacts/device/2026-11-10-loop-capability-readonly/api-snapshot.json)。相机为 `idle`、`system_mode=record`、`rec_mode=record`，当前 `loop_rec_duration=5 minutes`；SD 已插入，固件和硬件身份与既有基线一致。可读选项为：

| 设置 | 只读回包选项 | 能证明什么 | 不能证明什么 |
| --- | --- | --- | --- |
| `rec_mode` | `record`、`record_timelapse`、`record_loop`、`record_photo`、`record_slow_motion` | 固件有普通录像、循环录像等模式枚举 | `record_loop` 是否保留触发前一分钟、是否能被语音/快门提交 |
| `loop_rec_duration` | 5/20/60/120 分钟、`max` | 循环录像有总时长配置 | 它是循环录像总时长，不是触发前缓存窗口 |
| `system_mode` | `capture`、`record` | 应用层有拍摄系统模式 | 不代表切换回包已完成实际 native apply |

## 静态能力结论

- `VideoPref.PreRecord` 结构和菜单残留存在，但当前 connected-camera 分派中的相关操作是默认空处理；不能把字段存在当作原厂一分钟预录已实现。
- `record_loop` 与 `loop_rec_duration` 是原厂连续循环录像候选，现有证据没有显示它会在待机时保留最近 60 秒并在触发后提交。
- `EventRecord` MP4/FIFO 封装函数存在，但当前静态路径要求系统处于录像状态；它更像录像中事件保存入口，不能直接当作待机预录入口。
- 因此最现实的产品路线仍是复用硬件编码器和原厂 mux，在 SD 上维护按 IDR 切分的自有短段，再把相机识别出的语音 START 和实体快门转换成同一个 commit。

## 下一步可验证方案

1. 在不改变设置的前提下，继续从已有普通录像样本确认 `record_loop` 的文件生成、删除范围和事件通知语义；任何改变 `rec_mode` 或 `loop_rec_duration` 的设备实验先保存完整前后状态并单独记录。
2. 只读追踪 loop/event 的真实 start/stop 分派、FIFO handle、文件删除游标和音视频 producer ownership；不盲发 `0x1D`/隐藏操作。
3. 只有在 runtime FIFO cursor、首个 IDR/SPS/PPS、AAC config、共同 A/V epoch 和失败恢复合同闭合后，才形成可审阅的最小真机实验方案。

本矩阵不把循环录像选项、`PreRecord` preference 字段或 EventRecord 符号升级为已完成的一分钟预录功能。
