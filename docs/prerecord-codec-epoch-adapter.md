# 预录参数集缓存与 codec epoch 适配层

已完成独立的纯 C 离线配置缓存，补上 owned mux 研究中“slice-only IDR 写入成功，但新段没有 SPS/PPS”的缺口。验证包括 **49 组主机 + 49 组编译后 ARM 测试，以及两条原厂 ARM 完整 MP4 封装路径**；仅含 slice 的真实 IDR 补入同配置 SPS/PPS 后，原 `ProcessVideo` 实际读出参数集，原索引和封装代码生成的 MP4 可独立完整解码。

本模块没有访问相机，没有安装到真实 callback、early-copy 或 owned mux 队列。配置来源为已有归档普通 MP4；它证明的是明确配置绑定下的离线接缝，不是实时编码器配置事件、共同 A/V 硬件 epoch 或相机一分钟预录。

## 文件与复现

- `sdk/yi4k_1107_codec_epoch.h`、`.c`：配置绑定、缓存、视频参数集注入与 raw AAC 字节复制；没有修改既有 early-copy、owned mux、回放或 Android。
- `sdk/offline/yi4k_codec_epoch_test.c`：49 组结构、状态与边界测试，使用明确标注的合成码流，不把它们称为可解码媒体。
- `scripts/validate_prerecord_codec_epoch.py`：主机/ARM 编译、ABI 检查、真实配置提取、原 ARM 完整 MP4 集成和 FFmpeg 解码验证。
- `artifacts/device/2026-11-11-prerecord-codec-epoch-run02/validation.json`：最终结果、编译命令、源码/头文件/ELF/hash、精确输入来源和模型边界。`configuration-provenance.json` 与 `bound-config.bin` 保留实际绑定快照；两个 MP4 和 probe JSON 保留在同目录。

```sh
.venv-reverse/bin/python scripts/validate_prerecord_codec_epoch.py --output-dir /tmp/yi4k-codec-independent
```

输出目录必须不存在。`dev01`、`dev02` 和首个链接失败的 `run01` 仍保留，不复用、不冒充最终代码结果。

## 绑定来自实际配置，不从样本猜 epoch

本次输入为已归档 `YDXJ0161.MP4`，SHA-256 `862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d`。验证器从该文件实际 `avcC` 读取一组 SPS/PPS，从 `mp4a/esds` 读取 AAC ASC；提取出的 SPS/PPS 与该文件首个视频包经格式转换得到的参数集逐字节相同。

配置摘要为：

`SHA256("avcC" || BE32(avcC长度) || 精确avcC || "ASC" || BE32(ASC长度) || 精确ASC)`

绑定身份为：

`SHA256("archived-source-codec-binding-v1" || 源文件SHA256字节 || 配置摘要)`

同一配置的每个输入包必须由调用方提供该身份。C 层检查身份精确相等、拒绝缺失摘要，以及重新绑定已初始化对象；没有从 PTS、序号、IDR 标记、文件名或 AAC 字节猜一个 epoch。摘要由调用方提供，C 层不实现 SHA-256，也不能证明调用方提供的摘要与真实生产者的配置事件相符。验证器保留了可复核的实际配置字节和推导方式；未来真机集成仍须从真实编码器配置/session 事件建立绑定，不能把这个归档源身份当作设备运行期身份。

实际 AAC 配置为 AAC-LC、48000 Hz、2 声道、ASC `11 90`；归档文件的五字节 extradata 为 `11 90 00 00 00`，后三字节为零并在配置摘要中完整保留。C 只接收显式 rate/channels/ASC，并检查三者一致、LC object type、固定 1024 samples 和 GA 配置 flags。**raw AAC payload 不提供足够信息推断采样率或声道数**；适配层不尝试这样做，也不合成 ADTS。

## 视频和新段合同

缓存初始化必须在所有使用方静止时对一个清零的新对象执行；已经绑定的对象拒绝再次 init，配置变化不能在活动段中替换缓存。重建配置之前，需要外层终止/恢复旧段并静止队列。模块没有提供能在 live producer 上安全切换 epoch 的机制。

当前有意限定：一组 SPS/PPS，各不超过 64 字节；四字节 Annex B start code；每 AU 最多 64 个 NAL、输入最多 1 MiB。64 字节是本适配器的保守支持范围，不是宣称原 parser 已有容量检查。视频输出可能比输入多 `8+SPS长度+PPS长度` 字节，调用方必须预留独立缓冲。

- 新段首 AU 必须全部为 IDR VCL，初始 slice header 的 PPS ID 必须引用缓存 PPS；非 IDR、混合 VCL、错误 PPS 引用均拒绝。
- 输入完全没有 SPS/PPS 时，按 `SPS → PPS → 原AU` 补入缓存。输出为新缓冲，不改原 owned 槽位字节。
- 输入已有一对完整 SPS/PPS 时，必须位于 VCL 前并与缓存逐字节相同；保留原包，不重复注入。单独一份参数集、重复、VCL 后参数集或变化全部拒绝。
- 普通 AU 可包含 VCL1/5、SEI、AUD，所有 slice 仍须引用同一 PPS；不凭参数 ID 相同就接受参数内容变化。
- 真实归档 IDR 含零字节对齐填充。C 只在结构检查时排除 VCL 尾部 `trailing_zero_8bits`，输出完整保留原字节，不重新编码或去除原厂 padding。

C 只检查 framing、forbidden bit、部分 RBSP/emulation-prevention 结构、最初 Exp-Golomb 字段与参数 ID 关系，不实现完整 SPS、PPS、slice、参考图像或 decoder 语义验证。通过这些检查不能证明任意输入可解码或 IDR 真正独立；调用方必须使用实际 parser/decoder 验证完整配置和码流。真实正对照另执行原 parser 和完整解码，不用合成边界测试冒充 codec 合法性。

## EOS、内存及错误

视频和音频各自独立 EOS：必须显式 `eos=1`、NULL payload、长度零、NULL output、容量零；视频新段标记必须为零。END 不读取 payload，标记本轨结束，随后该轨的包与重复 EOS 都拒绝，另一轨仍可完成。没有将 EOS 当成普通 sample 或把 END 当作真实文件已关闭。

普通视频/音频输出必须与源、控制对象、identity、written 分离；identity 也是独立快照，不能指向缓存内部或 payload。written 不能 alias 任何对象；无效/别名 written 指针不会被写入。初始化对象和 config 也不得重叠。对象必须是存活、可访问且正确对齐的普通 C 对象；模块不会捕获野指针或硬件异常。

先完成验证和容量检查，再复制。失败不改输出字节、已绑定配置或 EOS 状态；有效独立 written 置零。错误不会自动丢帧、替换 epoch 或重试文件写入；外层必须把这个拒绝送进 segment 停止/恢复策略，不能跳过变化继续拼出看似成功的文件。

音频仅复制显式配置下的 raw AAC，最多 32 KiB；codec 变化必须体现为调用方的配置身份变化并被拒绝。模块无法从 arbitrary raw AAC 中判断某个 payload 是否偷偷使用了另一采样率，无法识别调用方错标身份。

## 原厂 parser 到完整 MP4 的结果

先做未使用适配层的对照：同一真实 slice-only IDR 直接交原 `A042D0F8 ProcessVideo`，返回 0、写出媒体，但新参数区 SPS/PPS 长度仍为 0。这重现了“writer 成功并不代表新段有解码配置”。

正对照分别运行两个独立新文件状态：

| 输入 | C 输出 | 原 ProcessVideo | 原 close 与解码 |
| --- | --- | --- | --- |
| slice-only `[5]` | 同绑定补入 `[7,8,5]` | 实际读出 SPS 54/PPS 4 字节，缓存字节匹配 | 完整 MP4、A/V 解码通过 |
| 已有同绑定 `[7,8,5]` | 原样 `[7,8,5]` | 同上，不重复注入 | 同上 |

两种输入经宿主 C 与编译后 ARM 生成的输出逐字节相同，SHA-256 `4436bc07994695b5b30552492184ed6573973d8ad3f7c17833a2e855866e4783`。在 ARM 测试中覆盖来源 ring 后，才把新输出地址构造成独立 synthetic virtual FIFO 描述符送给原 consumer。

随后调用原 `MemIdx/IsoIdx` 创建、Add/Commit/Flush/读取与 `A0435A18` open、`A0436004` close/MOOV serializer；这些入口在此轮完整路径中执行原 ARM 字节，没有用 index Add/Commit 假实现代替。file Write/Seek/Tell/Read、OS 锁/分配等仍为明确 RAM 模型，不是真实 SD/文件系统。完整路径复用 `audit_prerecord_native_mp4.py` 的 `NativeMachine`；原 writer 负对照复用另一个已有 harness。模型和实现的区别保留在验证 JSON 中。

两份成片均为 469881 字节，SHA-256 `1135af2049def089228c4c84f059bb8b563f9ef0e0bbf11344b2fa126460ec05`。ffprobe 读取的 avcC 参数集、AAC extradata 与绑定配置完全一致，完整音视频 decode 通过；首帧 YUV420P 原始像素与归档源首帧逐字节相同，SHA-256 `354babd94f134fb641ff5d6a6abe4ee664449f234ee62e93693576b740113c00`。

此轮每个文件只有一份视频/AAC sample，不证明长时间、多配置变化后恢复或真实预录切段。多帧/index 生命周期属于独立 native MP4 验证，不将彼此证据扩大归属。

## 版本与测试覆盖

最终 49 项覆盖：缺失身份/配置；SPS/PPS 过大、截短、错误 ID 与 emulation-prevention；ASC rate/channels/AOT/flags/1024 配置不符；未配置先来 slice；参数注入/已有参数保持/普通帧；部分、重复、变化参数；错误 slice PPS、伪 IDR/P-slice；破损 start code/RBSP、forbidden bit、无 VCL；EOS 和轨道独立结束；精确/超限 1 MiB 视频、32 KiB 音频、64 NAL、64 字节参数；精确容量与少一字节；source/output/identity/written alias；已有 epoch 重绑定拒绝。宿主/ARM report 逐字相同，R4–R11/SP 保持，无未解析符号或链接后 relocation。

`run02` 源码 hash：

- codec C：`3b95cc2a50936feeb1083bdbe10d46e16b4e9f923dbbb7fef782401cbc211d7d`
- 头文件：`b03ed142b36aac874c7e154df1a00b5a707958bc902898fe1b86e316fe08c9e0`
- C 测试：`fd86b5aa754251485077fb5eb3ff669a9cd91caf9ca30b1f1915870721696eb6`
- validator：`d97e77b17312b812b80b971aff14ada806b4c274803284fb662266405800161c`

导入时绑定的 native MP4 harness 为 `41b1e7fca5d832a9610af5ca13b17f92d83907cf260377dd6a2fa675f41b946d`，owned writer harness 为 `ba606abc1440844c44dff5424744fd7769e22d226d1f2c0c9cbe652d75acb83b`；两个文件在该次运行结束时均与导入快照一致。harness 后续若改变，须以新目录独立重跑，不把 run02 视为后续源码证据。原固件镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

仍缺真实 producer 配置绑定、source FIFO ABI/缓存一致性、适配器之间的实际队列接缝、共同采集时间线、真实文件存储失败恢复、分钟历史保留和相机语音/实体快门触发；本层没有安装器或设备写入能力。

主线程在 native MP4 脚本最终冻结为 `3dc7b00032803b6440124e8e6ce7316701a595333365253da935494bf208da99` 后[再次独立复跑](../artifacts/verification/2026-11-11-codec-epoch-independent-final-run02/validation.json)，49+49+2 均通过，导入脚本在该次运行结束时保持一致。此前独立结果仍保留，分别绑定各自实际导入版本，未追溯改写。
