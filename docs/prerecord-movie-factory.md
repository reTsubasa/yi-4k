# 原厂 movie factory 释放、重建与 MP4 重开

## 本轮结果

已通过原始 ARM 的 `FormatInit → NewMovieInfo → InitMovieInfo → Mp4Mux_Create → Open → 写入 → Close → RelMovieInfo → NewMovieInfo → InitMovieInfo → Open → 写入 → Close`，在同一个 movie 地址、同一个 MemIdx 和同一个 MP4 mux 对象上保存两段可独立解码的视频。第二段没有使用 Python 清零 movie 替代原厂重置。

这闭合了前一轮“新构造 movie 才能正确第二段”的缺口。其语义是释放并重建同一个池槽位；不代表仍保持锁定的 live movie 可以直接重复 track init。

复跑：

```sh
.venv-reverse/bin/python scripts/audit_prerecord_movie_factory.py --output /tmp/yi4k-movie-factory-independent
```

固定固件镜像与前轮相同（SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`）。新脚本还断言导入的冻结 native MP4 harness SHA-256 为 `3dc7b00032803b6440124e8e6ce7316701a595333365253da935494bf208da99`。未修改前轮脚本、文档、SDK 或 Android。

## 原始入口与调用链

| 作用 | 入口与关键行为 |
| --- | --- |
| Format 初始化 | `A03E3C48`，清 pool RAM、创建 mutex、计算 pool/flag 指针、设置 Amba version、执行 FIFO pool init |
| NewMovieInfo | `A03E3F00 → A03E30AC`，查找同名或空闲 movie 槽位，拒绝仍被锁定的槽位 |
| movie 真正初始化 | `A03E2E90`，原始 memset(movie, 0, 0x708)，设置 type=1、magic=0x12345678、复制 0x40 字节名字 |
| Track 配置 | `A0440CD4`，InitMovieInfo；它本身不清 sample count，不能代替 factory 生命周期 |
| Release | `A03E40C8 → A03E29DC`；mode=1 将已锁定 pool flag `0x81` 置为 0；movie 内容此时尚未清零 |
| MP4 对象创建 | `A03FECCC` 默认配置，`A03FED44 → A03FDEC4` 原始 block 分配、清零对象、创建 mutex 与 vtable 初始化 |
| 公开 Open/Close | `A03FE468 / A03FE300`，维护对象 open flag，内部调用前轮验证过的 `A0435A18 / A0436004` |

已有固件静态调用者支持这个生命周期：`AppLibFormatMuxMp4_Open`（`A01F3338`）在 movie 指针为空时调用 `NewMovieInfo`，随后调用 `InitMovieInfo`；`AppLibFormatMuxMp4_Close`（`A01F6088`）调用 `RelMovieInfo(movie,1)`，再将全局 movie 指针清零。新报告保留这些函数的 body 哈希、反编译哈希和 21 条相关静态调用边。AppLib 整个录制调度函数未执行，不能把静态调用边称为真机运行轨迹。

关键指令固定在报告 `reset_disassembly` 中：

```text
A03E2E94  movw r2, #0x708
A03E2E9C  mov  r1, #0
A03E2EA4  blx  A04F8DEC       ; 原始 memset
A03E2EB4  strb r2, [r4]      ; type=1
A03E2EB8  str  r3, [r4,#4]   ; magic=0x12345678
A03E2EC8  blx  A04F9B38       ; 原始 memcpy 名称
```

## 两段执行证据

初始化配置为一个 movie 池槽位，pool 地址 `0x10000000`、flag 地址 `0x10000708`，MemIdx 为 `0x11000000`。原始 MP4 Create 从显式 OS allocator 模型获得对象 `0x13000000`，其原始 index 位于对象 `+0x58`。

| 段 | 重建前 sample counts | 原始 New 后 counts | 视频／音频包 | MP4 大小 | 逐项索引读回 |
| --- | --- | --- | --- | --- | --- |
| 1 | `[0,0]` | `[0,0]` | 3 / 4 | 1,407,336 B | 19 项相等、12 次真实 MemIdx Read |
| 2 | `[3,4]` | `[0,0]` | 2 / 3 | 938,783 B | 14 项相等、9 次真实 MemIdx Read |

原始 New 每段产生 511 次被观察的 movie 内存写事件，覆盖完整 `0x708` 字节范围。报告按执行指令 PC 统计写入，包括原始 memset 的 `A04F8E2C/A04F8E32/A04F8E36/A04F8E3E/A04F8E60`；不是仅凭初始化后字段为零推测 reset 已执行。

同一 MemIdx 和 mux 对象保持复用，原始 Close 清空 index 且 MemIdx data pointer 变为 0。原始 Rel 后 movie 的旧 counts 仍为 `[3,4]`，直到下一次原始 New 才变成 `[0,0]`。SPS/PPS cache 也被原始 New 清为 0，随后通过真实样本重新建立。

两段均经独立 ffprobe 检查包数，并用 ffmpeg 完整解码。每个视频帧 MD5 为 `6f54030da59d51a0d2ff03198b18cc4b`，与固定归档源首帧相同；AAC 输出分别为 16,384 / 12,288 字节 PCM。视频和音频都是重复归档包组成的合成时间线，未宣称实际持续编码或时间戳重基已验证。

## 保留的负例与接口边界

前轮 `negative_reinit_without_fresh_movie` 的报告路径、哈希、具体字段和 Close assertion 原样引用在新报告 `old_negative` 中，不重新运行旧 11 场景，也不覆盖其文件。

本轮另外验证三个真实拒绝条件：

- 对已经打开的 MP4 对象再 Open 返回 -1，文件字节数与状态不变。
- Close 后 movie 槽位仍被锁定；未先 Rel 就 New 返回 -1，movie 内容不变。
- Rel(mode=1) 后再次 Rel 返回 -1，不能把重复释放当作幂等成功。

## 模型与剩余缺口

原始 FormatInit、movie factory、release、track init、MP4 Create/Open/Close、索引读写均执行固件字节。沿用前轮 RAM 文件、allocator、mutex、RTC 和合成 FIFO 模型；新增的唯一 OS 钩子为 FIFO pool init 所需的 event flag create，显式返回成功。pool 大小、名字、配置、stream/media 绑定与录像时限仍由调用方构造。

尚未执行 AppLib 整个任务调度、编码器/DMA、物理 CFS/SD、断电恢复、相机端语音/快门和一分钟缓冲。没有访问或写入真机。该 factory 路径证明可以用原厂生命周期完成同一内存槽位的下一段封装，不等同于完整设备预录功能交付。

主线程在冻结脚本上[独立复跑两段](../artifacts/verification/2026-11-11-movie-factory-independent-run01/audit.json)通过，同一对象地址、第二段原厂清零、索引逐项读回与完整音视频解码均再次成立；旧错误初始化负例仍单独保留。
