# 预录音视频 producer 跨文件起点审计

2026-11-11，固件 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。本轮把已有音频采集、视频 DSP、pipeline event 和 FIFO callback 证据放到同一条跨文件调用图中，并对“事件是否携带音视频共同采集起点”做了有界缺边检查。只读取固定 Ghidra 导出，没有连接相机、执行 RTOS、调用 API/setter 或写入任何设备内容。

机器结果见 [audit.json](../artifacts/device/2026-11-11-prerecord-cross-file-epoch/audit.json)，复现命令：

```sh
python3 scripts/audit_prerecord_cross_file_epoch.py
```

11 项断言全部通过。脚本记录了 9 个来源函数的 SHA-256、关键行号和跨文件边。

## 已闭合的跨文件边

```text
AudioEnc_StartEncodeImpl A045DA98
  ├─ setup A0290B60（时钟 90000、帧计数状态）
  ├─ BufferOpenSrcIoNode A045D7B8
  │    └─ A02941F4：IoNode flag == 1 才复制 PCM
  └─ A029016C：帧计数 × samples × 90000 / denominator → 音频 PTS
       └─ A045E7DC：编码事件字段 → Audio FrameDesc → FIFO

Video Open A046F4A8
  └─ pipeline +0x0c，并注册 DSP event 0x13 → A046E6FC
       └─ event +4 与视频 context 状态字节比较，且要求该状态为 0
            └─ 从视频 mutex context -4 取已保存的 pipeline 标识
                 └─ A045FD38 → A045D7B8（再次打开音频 source gate）

DSP message 0x82000001 A02CA5A0
  └─ A02C7660：按每流 previous PTS/base 修正 DSP PTS
       └─ event 4 → 视频 FrameDesc/FIFO
```

这条图证明了一个真实的跨模块共享标识：视频上下文的 pipeline 指针可以找到对应音频实例并调用 source gate。它比“音频先启动、视频后启动”的时序猜测更强，但共享的是 pipeline 身份，不是一个已保存的硬件采集时间戳。

## 共同起点仍未闭合

在当前已展开的 event 0x13 回调 `A046E6FC` 中，事件对象 `+4` 与视频 context 的状态字节比较，且要求后者为 0；`event+4` 不是此处的 pipeline 标识。回调从视频 mutex context 的 `-4` 取已保存的 pipeline 标识，传给 `A045FD38`，后者才与音频实例 `+0x14` 匹配并调用 `A045D7B8`。该回调没有读取事件 `+8/+0x0c`、DSP ring index 或 DMA block index。

后续[原始事件链审计](prerecord-gate-epoch.md)已用 8 组完整函数执行验证上述字段身份，并确认再次开门只重复写 source IoNode `+4=1`，不会重置音频编码帧计数。因此下面“gate 重复打开是否重置 producer”这一项已得到成功路径上的否定答案；共同采集 epoch 仍未闭合。旧审计 JSON 与其原始来源 hash 保持原样。

因此这条 event→gate 边无法回答以下问题：

- source gate 第一次从 0 变为 1 时，输入 DMA ring 当前处于哪个 block；
- gate 打开后第一个被 `A02941F4` 接纳的 PCM block 对应何时；
- 该 block 与第一个视频 DSP PTS/FrameDesc 的共同硬件 epoch 是什么；
- gate 重复打开是否只改变接纳状态，还是会重置音频 producer。

音频 PTS 在 `A029016C` 中由局部帧计数合成，视频 PTS 在 `A02CA5A0/A02C7660` 中来自 DSP 描述符并经过每流回绕状态修正。两条 PTS 生产路径没有在本跨文件图中共享同一计数、DMA 索引或硬件 timestamp 字段。文件内两轨各自从 0 开始，也不能补足这个缺口。

## 对预录实现的约束

实现候选应保留原厂录制会话和两轨原始时间线，旁路消费者记录至少以下信息：

1. 视频启动命令提交和 event 0x13 到达时刻；
2. 音频 source gate 首次 0→1 的时刻；
3. 首个被 DMA/PCM writer 接纳的 block 序号；
4. 首个视频 FrameDesc 的 raw/repaired PTS 及每流 base/previous 状态；
5. 音频编码帧计数、samples-per-frame 和 denominator。

这五项目前只在静态代码中分散可见，没有共同运行期记录。不能把 event 0x13 的字段、音频帧序号 0 或首个 MP4 PTS 直接当作共同采集 epoch，也不能据此宣称一分钟预录的音画同步已经完成。

