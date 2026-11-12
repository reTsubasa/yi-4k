# 离线 SDK 完整接缝：复制、自有队列、codec epoch 和 mux

新集成已通过 **18 组主机 C + 18 组编译 ARM 场景，以及 1 条原厂完整索引/MP4 Open–Close/解码路径**。early-copy 在测试 original callback 覆盖源环之前完成复制；codec 从自有槽位读取并输出到另一份自有缓冲；writer 不再使用源环。配置变化、输出容量不足或写入失败时，原槽位保留，consumer 进入 poison，不能直接重试。

这是 2026-11-11 的离线验证，没有访问设备。没有修改任何既有 SDK、冻结验证器或历史结果。新增脚本：[validate_prerecord_sdk_pipeline.py](../scripts/validate_prerecord_sdk_pipeline.py)。最终结果：[run01/validation.json](../artifacts/device/2026-11-11-prerecord-sdk-pipeline-run01/validation.json)。

## 实际串联的模块

脚本把五份现有 C 实现与一份临时测试桥一起编译为宿主动态库和 ARM Cortex-A9 ELF：

```text
early_on_event / audio_on_event
  → copy_payload
  → early_copy 自有 SPSC 队列发布
  → 测试 original callback：立即把整份源环改为 EE
  → owned_mux_prepare：持有原复制槽位，生成私有描述符
  → codec_video / codec_audio：绑定检查、SPS/PPS 注入或 AAC 复制
  → 独立 codec 输出缓冲及其私有 writer 描述符
  → 原厂 ProcessVideo / ProcessAudio
  → owned_mux_finish(status, payload_use_complete)
```

这里的所有 SDK 函数实际运行现有 C，没有用 Python 重写其结果。host 与编译 ARM 的 16-word 状态报告逐项相等；编译 ARM 的 R4–R11/SP 保持；ELF 没有未定义符号或链接后 relocation。脚本保存五份实现、相关头文件和导入 harness 的 SHA-256，并在结束时确认全部保持不变。

**临时桥是离线 fixture，不是可部署的常驻 callback。** 它没有注册/安装/卸载、目标地址发现、调度、缓存管理、真实配置事件绑定或常驻生命周期。生成的 ELF 同样不能视为可直接加载相机的插件。脚本只把模拟内存地址用于宿主 ARM 执行，没有进行设备写入。

## 两份自有缓冲与释放顺序

原 early-copy 槽位保存未经 codec 处理的完整字节和原描述符。`owned_mux_prepare` 后继续持有该槽，codec 对其只读，将输出写到独立缓冲。slice-only 首 IDR 会增加 `8+SPS长度+PPS长度` 字节，因此不能沿用原槽的 payload 长度、地址或 ring bounds。

fixture 从 owned-mux 私有描述符复制序号、PTS、type/flags，再把 payload 地址/长度改为 codec 输出的位置/长度；writer 的 **base 和 end 两个边界都设为 codec 输出 arena**。这是测试桥明确完成的接线，不是原 SDK 自动提供的转换。

只有原 writer 成功，且 caller 给出 `payload_use_complete=1`，才调用 finish 释放原队列槽位。codec 拒绝时，将其错误送入 finish；writer 失败或缺少 use-complete 也会 poison 并保留 held slot。槽位保留不代表已经回滚部分媒体或索引；它只阻止无依据地释放、丢弃或重试。

use-complete 是调用方承诺。离线文件模型同步复制输入字节，可以作出这个承诺；在相机上真实 DMA、文件系统或索引若仍保留输出缓冲，必须继续持有。现有 SDK 无法检测一张虚假的成功回执。

## 18 组组合用例

| 场景 | 组合结果 |
|---|---|
| 视频 slice-only 首 IDR | 自有槽位→缓存 SPS/PPS 注入→原 writer 读出完整参数 |
| 视频已有同配置 SPS/PPS | 保持完整 AU，不重复注入 |
| 视频、音频源环跨尾回绕 | early-copy 合并为连续自有字节，源环随后覆盖不影响输出 |
| 视频、音频逐包 identity 变化 | codec 拒绝，输出 canary 不变，原槽保留且 poison |
| 视频 SPS 字节变化 | 即使 ID 相同也拒绝，不替换活动配置 |
| 视频、音频输出容量少 1 byte | codec 拒绝，written=0，输出不变，原槽保留 |
| staging 槽容量少 1 byte | early-copy 明确失败，队列不发布，不产生假 held slot |
| 队列只有 1 个可用槽且该槽正被持有 | 下一 offer 返回 FULL，不覆盖借用槽的字节 |
| 已绑定 epoch 请求重新绑定配置 | 返回 CHANGED；旧绑定仍可处理其原配置 |
| 视频、音频 writer short write | 原 writer 失败，finish poison，原槽不释放 |
| 视频、音频 payload 后 index Add 失败 | 保留失败及部分写出证据，原槽不释放 |
| writer 返回成功但 use-complete=0 | 仍 poison 并保留，不把 status=0 单独当作回收许可 |

表中合并展示了平行场景，机器结果保留 18 个独立 case。每例 original callback 都实际执行并覆写完整源环；held 槽位的字节在成功和拒绝路径上均仍等于原输入，不能以只比较 descriptor 冒充 payload 保留。队列 full 的第二次 offer 也正常调用 original，但不改已持有的自有字节。

writer 执行阶段的 CPU 访存 hook 未见源环读取；stream 模型记录的 payload 来源处于 codec 输出 arena。视频 writer 会实际扫描自有输出，AAC writer 把自有地址交给同步 stream 模型读取，因此不能要求 AAC writer 自身必须产生 CPU load 才算读取输出。

这些 18 例使用 `stock.WriterMachine`：**原 ProcessVideo/ProcessAudio、FIFO、parser、时间换算等运行原 ARM，但 index Add/Commit 与 stream Write/Tell/Length 是显式模型。它们不是完整 MP4 封装验证。** 失败后原 stock 状态可能已部分变化；本轮只保证 SDK staging slot 的保留与 poison，不保证 stock writer/索引/文件可原地重试。

## 独立的一条完整原厂封装路径

为补足上述模型边界，另建一个全新 `NativeMachine` 成功实例。视频、音频各自重新初始化、按顺序串行使用测试队列；上一 stream 的 writer 完成并释放后才重建 fixture，不把两个 producer 接入同一活动 SPSC 实例。

此路径再次执行编译 ARM 的全部 SDK 链，随后将桥生成的描述符送入原厂 FIFO/consumer，执行真实 `MemIdx/IsoIdx` 创建、Add/Commit/Flush/读取和 MP4 Open、ProcessVideo、ProcessAudio、Close/MOOV serializer。**mock index Add/Commit 次数为 0**；实际后端读写和原调用记录保存在 JSON。

文件 Read/Write/Seek/Tell、OS 锁和分配仍是 RAM 模型，不是真实 SD/文件系统。这里每轨只有一个来自归档原片的 sample，没有运行连续编码器或做分钟级压力测试。

最终文件：[sdk-pipeline-native.mp4](../artifacts/device/2026-11-11-prerecord-sdk-pipeline-run01/sdk-pipeline-native.mp4)，469881 bytes，SHA-256：

`1135af2049def089228c4c84f059bb8b563f9ef0e0bbf11344b2fa126460ec05`

原厂完整输出经 FFmpeg `-xerror -err_detect explode` 音视频解码通过；首视频帧 YUV420P 与归档源首帧逐字节相同，首 AAC 的 PCM 也逐字节相同；输出 avcC SPS/PPS 与 AAC ASC 和绑定配置一致。[probe JSON](../artifacts/device/2026-11-11-prerecord-sdk-pipeline-run01/sdk-pipeline-native-probe.json) 保留流、packet 和配置字节。

码流输入来自已有普通录像 `YDXJ0161.MP4`，SHA-256 `862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d`。视频从归档 MP4 转成四字节 Annex B，AAC 使用原 raw sample；这些不是实时 encoder FIFO 观测。identity 与摘要按 [codec epoch 规则](prerecord-codec-epoch-adapter.md) 从精确源 SHA/avcC/ASC 推导，不是共同硬件采集 epoch，也不能替代真实配置事件的可信绑定。

## 复现与冻结

```sh
.venv-reverse/bin/python scripts/validate_prerecord_sdk_pipeline.py \
  --output-dir /tmp/yi4k-sdk-pipeline-independent
```

输出目录必须不存在。除 validation JSON 外，还保存编译 ARM ELF、完整临时 `fixture-bridge.c`、成功 MP4 与 probe；编译参数、工具版本、源 hash 和桥 hash 可在 JSON 中核对。

最终脚本 SHA-256：`f735d14d9c15914bf0259a8299b8bec6200432b243648e8ebf0a5141a7988612`。本轮证据由编译 C、Unicorn、保留固件字节和 FFmpeg 组成，没有新增 REA Evidence ID。

开发目录未覆盖：`/tmp/yi4k-sdk-pipeline-dev01` 是临时 fixture 零初始化产生 `__aeabi_memclr8` 的链接失败；改为 fixture 自身清零后，`dev02` 被主动中止以优化测试调度 hook，不计通过；`dev03` 仅覆盖 18 场景且通过；`dev04` 在添加完整 MP4 路径后通过。最终 run01 增加构建/hash/私有描述符证据并完整重跑通过，不把旧中止或较小范围结果追溯改成最终通过。

现阶段已补上模块间的实际内存与失败持有接缝；仍缺真实 producer 配置绑定、callback 安全安装/静止/卸载、源复制稳定期与 cache、独立音视频队列的并发吞吐、共同采集时钟、常驻 spool 和真实存储恢复。**单 sample 的可解码文件不证明连续录制、跨段无丢帧或一分钟吞吐，更不代表相机端一分钟预录完成。**

主线程[独立复跑](../artifacts/verification/2026-11-11-sdk-pipeline-independent-run01/validation.json)确认18组host/ARM报告一致、全部冻结源码hash保持，以及1条完整原厂MP4路径通过；完整路径mock index Add/Commit=0，视频像素、AAC PCM与配置再次比对相同。
