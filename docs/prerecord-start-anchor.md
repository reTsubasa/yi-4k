# 1.10.7 原厂 DSP 事件到音频接纳门的关联钩子

2026-11-10。新增 **14 个原始指令片段仿真和 11 个字节断言，全部通过**。只离线使用固定镜像、已有 Ghidra 导出和合成 RAM；没有连接设备、写固件、执行 RTOS、dispatcher 或实际音频 gate 函数。

## 新增证据足以改变后续调查方向

发现一条此前未确认的**原厂跨音视频模块钩子**，它以同一个 pipeline 指针关联视频上下文与音频上下文，并从 DSP 事件回调再次打开音频 source gate：

```text
视频 Open A046F4A8
  video context+0x0c = pipeline
  为 video context+0x44==0 注册 DSP event 0x13 → A046E6FC

音频 Open A045ECD0
  audio context+0x14 = 同一个 pipeline

DSP event 0x13
  → A046E6FC
  → 以 video context+0x0c 为参数调用 A045FD38
  → 遍历音频实例，匹配 audio context+0x14 == pipeline
  → A045D7B8
  → BufferOpenSrcIoNode A029351C
```

这不是根据“音频先调用、视频后调用”推断的同步，而是镜像中真实存在的跨模块调用与共享标识。`A046F4CC` 注册、`A046E77C` 调用音频实例查找、`A045FDB8` 调用 gate helper 都已核对原始字节。

但它还不能作为当前录像的首样本锚点：**同一固件的音频 StartEncodeImpl 已经直接提前打开 source gate**。当前证据支持将调查重点转向这个原厂钩子与直接开门路径的关系，而不是继续猜 raw PTS 的差值。

## event 0x13 的来源是待发计数条件，事件没有采集时间字段

`A02D296C` 的视频启动命令构造成功路径，将当前 `A1456ABC` 值写入 `A14BDB5C` 起的待发数组；当 `A1457FE0 > 0xef` 时先加 3。`A02D3648` 的另一命令路径同样写当前／当前+3。这里只按原始字段命名，没有把阈值 239 的变量解释成帧率。

`A02C78D8` 处理 DSP 消息前扫描该待发数组，条件为：

```text
pending != 0 && pending < current_A1456ABC
```

满足时先清 pending，构造两个 u32 索引字段，再触发 event 0x13；若另一 mode 字段为 2，则触发 event 0x20。严格比较是 `<`，相等不会触发。

事件对象只是栈上两个 word，在已审计构造路径不含 PTS、DMA block index 或 PCM sample count。`A02B38B4` 在自身不同服务分支中都会递增 `A1456ABC` 并将其传给 `A02C6A50`；未证明这个计数与传感器帧、ADC 时钟或 DSP raw PTS 同单位。因此“延迟 3”暂不能写成“三帧”或具体毫秒。

`A046E6FC` 只比较事件+4 与 video context+0x44，并要求该上下文字节为 0；没有使用事件+0 生成时间锚点。本轮 4 个过滤片段确认只有 context 值为 0 且事件+4为0才进入音频 gate 查找。不要因事件含两个索引就擅自把两者解读成带时间关系的传感器标识。

## 当前构建提前开门，不能把后续钩子当作首样本时刻

`A045DA98` 音频录制启动的原始指令为：

```text
A045DB78  movw r3, #0
A045DB7C  movt r3, #0
A045DB80  cmp  r3, #0
A045DB84  beq  A045DB98
A045DB88  ldr  r0, [r4, #0x14]   ; 当前构建不可达块
A045DB8C  nop
...
A045DBB8  bl   A045D7B8         ; 直接打开 source gate
```

该常量零分支实际执行已确认无条件跳过中间块；并非根据反编译器“unreachable”警告猜测。中间块形态可能是可选同步功能留下的代码，但本轮不恢复被省掉的原函数名、不声称其为可直接启用的同步开关。

因此 DSP event 0x13 到来时，某些音频 source gate 可能早已为 1。此前 `prerecord-capture-epoch.md` 已证明 gate 为 1 后即可接纳 PCM，后续再次写 1 不会自动回溯已接纳样本，也没有在本钩子中保存先前开门相对 DMA block 的偏移。

`A045FD38` 使用音频实例+0x14的 pipeline 标识查找；可能继续扫描多个同 pipeline 的实例，并非只取第一个。三个仿真用例只验证找到槽位 0、3以及查无的路径，并在第一个匹配处、调用 gate helper 前停止。

## 首个 FIFO 事件与 AppLib 回调的有界检查

复核已有视频 FrameDesc callback `A046CA94`：普通数据路径复制事件 PTS 到描述符，按流更新帧数／字节总量并写 FIFO，已审计窗口未保存与音频 gate 对应的共同 epoch。`A046E3E0` 的 bitstream FIFO handler 将消费事件转给 BitsMgr；没有新增音频起点字段。

AppLib `A021CB80` 对若干状态事件打印日志／投递上层消息，`A021C740` 的 VIN event callback 仅作事件范围判断和日志。这些已导出函数没有给出共同起点；未索引的 pipeline callback label `A021CC7C` 未据此作完整反编译结论。这里只说明审计边界，不能扩大为全部固件没有其他锚点。

## 验证与实现方向

复现：`.venv-reverse/bin/python scripts/prerecord-start-anchor.py`。结果 `artifacts/device/2026-11-10-prerecord/prerecord-start-anchor-audit.json` 保存 11 个来源函数 hash、关键指令窗口、每例输入与停止地址。

14 例为：6 个 pending计数／事件选择前缀、4 个 DSP callback 条件后缀、3 个音频实例 pipeline 查找后缀、1 个当前构建直接开门前的恒定分支。11 个字节断言覆盖注册、跨模块调用、常量分支、NOP、gate 调用和 pending的+3写入。所有测试均在依赖 RTOS、dispatcher 或 gate helper 前停止，没有替代函数桩或补丁。

镜像 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `A0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

预录实现应保留原厂完整录制会话与现有音视频时间线，再探索同会话内剪裁，而不能将 DSP event0x13或音频序号0直接当作共同硬件 epoch。下一条最有价值的证据是：视频启动命令提交、pending事件触发、音频 gate首次从0→1、首个被接纳DMA block及首个视频PTS的关联日志／状态；离线目前只找到关联钩子，没有保存这些时刻的现成结构。当前仍不足以编写或刷入同步补丁。
