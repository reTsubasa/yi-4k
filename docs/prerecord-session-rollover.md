# 原生 MP4 会话分段与预录复用边界

2026-11-10，镜像 1.10.7。结论：原厂存在同一 mux pipe 内关闭旧 MP4、重建媒体信息、打开新 MP4 的分段生命周期。这比反复停止/启动录像更接近连续预录所需的路径。但目前没有证明生产者跨段 PTS、IDR 边界、SPS/PPS/AAC 配置延续和实际文件可播放；原回调包含多处断言死循环，也不是可以在任意线程直接调用的安全入口。

本轮完全离线，只读取已有镜像、Ghidra 导出并在合成 RAM 中执行原始指令片段。没有相机连接、设备写入、固件修改或真实文件删除。复现：

```sh
.venv-reverse/bin/python scripts/prerecord-session-rollover.py
```

输出 `artifacts/device/2026-11-10-prerecord/prerecord-session-rollover-audit.json`。21 组片段执行全部通过，包含 8 组 split getter、8 组 event-3 分支、3 组完整计数重置和 2 组带真实视频 ResetPTS helper 的 DTS 重基准后缀。镜像 SHA-256 固定为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。JSON 固定 16 个导出函数的字节/伪代码 hash，另固定未索引回调字节范围，未虚构其反编译文件。

## 短时间枚举存在，但不是已可启用的选项

`AppLibVideoEnc_GetSplitTimeSize(A021F8A8)` 读取 `u16 A13C82BC`，setter 为 `A021F7AC`。短时间枚举真实存在：

| 枚举 | 返回毫秒 | 返回 size |
|---|---:|---:|
| `0x100` | 60000 | `0x780000000` |
| `0x200/0x700` | 300000 | `0x780000000` |
| `0x300` | 1800000 | `0x780000000` |
| `0x400` | 600000 | `0x780000000` |
| `0x500` | 30000 | `0x780000000` |
| `0x600` | 10000 | `0x780000000` |

不要把它们说成普通录像或 loop API 的现成能力：

- 初始化 `A019A18C` 设置 `0xFFFF`。存储配置通过 `A01923C8` 的 27 项表转换，只产生 `0x4..0xB` 等大小枚举或 `0xFF`，没有短时间枚举。
- 真实 `ants set_video_split_size` shell handler `A01A7508..A01A7764` 是另一个未索引标签，本轮直接核对原始指令并固定 hash。它按字符串比较 `64M/1G/2G/4G/30G/.../5m/10m/30m/off/auto`，所检查范围内仅 `30G` 分支明确写 `u16(pref+0x132)=30`；其它匹配分支只打印提示并返回 0，没有调用 split setter、转换 helper 或通用整数解析。不能用 shell 返回“成功”证明其设置生效。30G 偏好未来可经 `A01923C8(30)` 转成大小枚举 `0xB`；本轮没有执行该配置刷新。
- `app_test` 调试命令 `A01A18F8` 有 split 参数入口；按其比较条件，`0x100/0x200/0x300` 可接受，`0x500/0x600` 被拒绝。调试帮助字符串的部分数值命名与 getter 不一致，不能将帮助文字当作执行证据。
- 已检查实际调用者 `rec_connected_cam_set_mp4_muxer(A0124470)` 的普通分支取得上述 size 后，发现大于 `0xEA600000`，会把 **time 和 size 一起覆盖**：size 设为上限，time 改为按码率估算的上限文件时间再加 600000ms。因此这些短时间返回值在这条普通录像路径不能直接保留。
- mode 6 的 loop 路径绕过 getter，读取偏好 `pref+0xA8`：值 5 时每段 60000ms，其它值每段 300000ms。`A01F4BC8(mode=4,duration)` 再把 5 分钟保留窗口设成 5 个一分钟段，其它有限窗口设为 `duration/5` 个五分钟段；`0xFFFFFFFF` 表示无固定保留段数。API 的 5/20/60/120 分钟等窗口与这里的分段长度不是同一枚举。

`A01F4908` 最终将 time 写 `A06D42C8`、u64 size 写 `A06D42C0`。修改这些变量仅是离线候选设计，并非本轮提出直接写真机。

## 原生普通会话的切文件路径

`AppLibFormatMuxMp4_Open(A01F3338)` 建立 format `A13C2A44`、pipe `A13C1784`，将 time/size limit 及回调 `A01F569C` 交给 pipe。该回调是原始未索引代码标签，导出目录没有对应 `.c`。

底层 `AmpMuxer_OnPipeLimit(A0442674)` 只接受 master format 触发的 limit，先处理其它 format 到相应界限、恢复 DTS，再通过 `pipe+0x14` 发 event 3。这意味着候选入口依赖 mux 线程、状态和轨道界限，不能从应用线程直接调用回调绕过这些条件。

event 3 在 `A01F5750..A01F57A4` 检查：time/size 全零则通知停止；否则 size 不大于 `0xEA600000` 时进入实际分段；超出上限只有 loop mux mode 4 可继续分段。8 组原始分支片段覆盖零值、上限、超限及普通/loop 模式。

实际主路径 `A01F5888`：

1. 调用旧 main-format vtable `+4(format,0)` 关闭 MP4，随后 stream vtable `+4(stream)` 关闭文件流。
2. 按会话 split counter 和命名回调生成新文件名，申请新 movie 对象。
3. `AmpFormat_CopyMovieInfo(A03E41A0)` 将旧 movie 的 `[0,0x10)` 和 `[0x50,0x708)` 复制到新对象，释放旧 movie，替换 format 的 movie 指针。
4. `A01F68B8` 仅清零 movie 每轨 `+0x88/+0x8C`，即 track `+0x10/+0x14` 计数；本轮完整 helper 执行及 canary 验证其余字段保持。
5. 清零 `A13C1758` 后执行 `AppLibFormatMuxMp4_ResetMovie(A01F3124)`，重新建立文件内时间线。
6. stream vtable `+0(stream,newName,2)`、format vtable `+0(format)` 打开新文件；如果次码流启用，还会完成对应 close/copy/reset/open；最后增加 split counter 并通知。

这段已检查的主调用序列没有显式停止/启动音视频硬件编码器，也没有调用此前定位的音频生产者 reset/start。它支持“保留会话、切换文件”的假设；间接 vtable、命名回调及底层完整调用闭包尚未全部排除硬件副作用，因此不能升格为连续性证明。

## 文件时间归零不等于生产者重启

`ResetMovie` 先以最短轨道 DTS 作为基准，从各轨 `DTS+0x20` 相减，结果同时写回 `+0x20/+0x28/+0x18`；主路径先清零全局基准，所以本轮所测即减去当前最短 DTS。视频轨额外把结果复制到 `track+0x50`，调用 `ResetPTS(A01F721C)`。

`ResetPTS` 将 control `+0x7E` 清零，重算 bias `+0x68`，并清零 origin `+0x58`、frameCount `+0x48`、convertedPTS `+0x60`。下一文件因而可以从新的首个消费描述符重选视频原点。它重置的是 mux 对象字段，不是已经证明过的音频生产者 frame counter 或视频 DSP rollover 状态。

两组真实后缀执行覆盖普通值和超过 u32 的 DTS，验证跨轨差额保留及只对视频重置 PTS 字段。测试从 helper/最短轨查找之后开始，未执行 mutex、FIFO 消费、真实编码器或文件 IO；没有把合成输入当作真机运行证据。

媒体结构复制保留了大段轨道元数据，但本轮尚未定位 SPS/PPS、AAC config 在该结构中的全部字段；不能由 memcpy 推导下一文件参数集完整，也没有证明 limit 必然落在可独立解码的 IDR/GOP 切点。

## 失败合同与旧素材边界

原厂 callback 的 main/secondary format-close、stream-close、命名、movie allocation/copy/release/reset 等多个错误分支会打印 `K_ASSERT`，调用 `A02A7524`，执行 `cpsid if`，随后永久自跳。例如主 format-close 失败指向 `A01F5AEC..A01F5B28`，stream-close 失败指向 `A01F5DD8..A01F5E18`。open 返回值在当前直接调用序列中未立即检查。原厂不提供可直接照搬的完整回滚/清理合同。

因此可复用对象应是 **普通会话下由 mux 自身触发的切文件生命周期**，不是 loop 模式或裸回调调用。候选适配层还需明确单一 writer 所有权、关闭成功后对象状态、下一文件打开失败如何停止消费、已消费帧能否恢复、次码流部分成功如何收尾。以上是待建立合同，不是已实现的安全包装。

原 loop 删除函数 `DelLoopEncFile(A01F51D0)` 以全局 `A13C2A38` 为删除游标，在 `deletedCount < splitCounter` 时调用 `A01F2CE0(cursor)`，经 `A0224F4C(type=2,id,0)` 删除数据库标识对应素材，并按 `A0224BF4` 更新到下一 ID；到特定编号还尝试删 `C:\\DCIM\\%dMEDIA` 目录。初次非恢复 loop open 会把游标设为会话首文件 ID，但恢复标志非零时会沿用状态，后续“下一个 ID”的完整过滤语义尚未恢复。

已知调用者包含 loop 模式分段保留超限通知、空间不足路径和启动时空间回收。由此只能确认有会话游标意图，**不能保证每个分支、恢复状态和 ID 枚举都只删除本次新文件**。预录方案不应直接打开原 loop 删除逻辑，应在独立目录/明确会话清单内保存临时片段，并仅对该清单拥有的文件执行回收；实现和真机写入均不在本轮范围。

后续优先验证普通分段的 master-limit → IDR/轨道界限合同、format-open 对 FIFO/参数集的处理，以及原始生产者跨文件状态保持。EventRecord 和 virtual FIFO 的所有权沿用现有专项报告，本轮没有证明其可与普通 mux 同时订阅或切换。

后续 [同步帧保留与参数集重建审计](prerecord-sync-boundary.md) 已将其中两点细化：普通视频只在 `type=1` 同步帧前检查上限，达到时在写出/移除该帧前返回；但新文件 `IsoMux_Open` 会清空 SPS/PPS 缓存，须从下一段首个同步帧重新提取。67 组原始指令检查通过，包括 parser 正返回但参数集仍为空的反例。此处仍不声称硬件逐段带齐参数集、完整 close/open 保留 FIFO 或连续可播放分段已被证明。
