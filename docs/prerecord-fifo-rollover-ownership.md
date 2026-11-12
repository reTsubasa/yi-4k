# 预录普通切段：FIFO 所有权的有界离线审计

本轮接续 [同步帧切段边界](prerecord-sync-boundary.md)，追踪已经保留在 FIFO 的同步帧，是否会在 event 3 的 close/open 流程中被删除。结论是：**已经展开的直接调用没有到达 FIFO 修改 API，原生重开复用 FIFO handle，且普通切段尾通知不会进入 loop 删除分支；完整间接调用闭包和下一次真实 peek 的身份仍未证明。** 这为普通切段作为预录基础提供进一步证据，不代表已实现相机预录或产出连续可播放视频。

全程离线，未连接相机、写入设备、开启 loop 或删除素材。分析固定镜像 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `A0100000`，SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。Ghidra 文件为推断伪代码，不是原始源码。

复现脚本：[prerecord-fifo-rollover-ownership.py](../scripts/prerecord-fifo-rollover-ownership.py)。机器结果：[prerecord-fifo-rollover-ownership-audit.json](../artifacts/device/2026-11-10-prerecord/prerecord-fifo-rollover-ownership-audit.json)。脚本复用上一轮的镜像、原始指令执行器，输出 6 组执行检查、8 条指令链接断言、87 个来源函数代码及可用伪代码的 SHA，并记录全部展开边、外部叶和未解析的间接跳转。

## 新 movie 保留原 FIFO handle，但 ResetMovie 会真正 peek 当前项

每轨结构为 `movie+0x78+i*0x90`，FIFO handle 在轨道 `+0x30`，即 `movie+0xA8+i*0x90`。

`AmpFormat_CopyMovieInfo(A03E41A0)` 复制开头 `0x10` 字节及 `[+0x50,+0x708)`。后者包含 FIFO handle；原始 `A03E41D8/A03E41E0/A03E41E8/A03E4200` 固定了源偏移、长度 `0x6B8`、目标偏移和 memcpy wrapper 调用。event 3 回调在 `A01F59CC` 将新 movie 保存至全局，并在 `A01F59D0` 保存至 format `+4`。本轮未完整执行带 mutex 的 CopyMovieInfo，不把静态复制范围当作完整运行验证。

`ResetMovie(A01F3124)` 的第一项操作是 `AdjustDTS(A01F705C)`，并非只有时间戳减法。它按视频轨备份轨道 metadata，再于 `A01F70E8` 调用 `AmpFifo_PeekEntry(A0451960)`，参数是原 `track+0x30`、描述符输出和序号 0；随后 `ConvertPTS(A01F6BE8)` 读取当前描述符，调整转换状态及 DTS。原先只执行 reset 后半段的证据不能覆盖这个真实 peek。

此路径展开后只直达 PeekEntry，没有直达 RemoveEntry、EraseAll、Delete、Create。它说明重开会参考保留帧的时间基，不能说 reset 对 FIFO 没有任何访问。完整 ResetMovie 带真实 FIFO 的执行、peek 结果及前后 cursor 身份仍未捕获。

四组原始指令执行分别覆盖完整 `RestoreDTS(A04404D8)`、完整计数 reset `A01F68B8`、视频 PTS reset `A01F721C`（含真实 tail helper），以及 `IsoMux_Open(A0435A18)` 到 `A0435AA4` 的前缀。各构造两轨，handle 字段及其指向的 opaque canary 字节保持。**canary 不是 FIFO 模拟器，也不能证明生产者 payload ring 的生命周期。** Open 前缀在 RTC、文件和索引 IO 之前停止。

## close/open 的主流对象已解析到真实 vtable

主格式 vtable `A078A404` 的 open/close/process 分别为 `A03FE468/A03FE300/A03FE1E4`。主文件流由 `AmpFileStream_Create(A0445AB4)` 经 `A0443CF0` 创建，后者将 `A078A4AC` 写入对象 `+0`；表的前两项确认为 open `A0444ECC`、close `A0445234`。

| event 3 回调位置 | 操作 | 已解析目标 |
| --- | --- | --- |
| `A01F58AC` | 主格式 close | `A03FE300` → `IsoMux_Close(A0436004)` |
| `A01F58CC` | 主文件 close | `A0445234` |
| `A01F5A18` | 主文件 open | `A0444ECC` |
| `A01F5A2C` | 主格式 open | `A03FE468` → `IsoMux_Open(A0435A18)` |

文件 close 调用 CFS close `A03D5B54` 并清空文件对象 `+0x38`。文件 open 进行 CFS 参数、文件名、打开及同步操作。两段没有直接 FIFO API，CFS 外部调用尚未展开，因此不能由此推出完整文件子系统没有间接副作用。

`IsoMux_Close` 可见 CheckEnd、索引 flush、HasEmptyTrack、MOOV/stream/index close；flag 0 时还调用 `Trim(A0435F64)` → `A042D6C4`，按已写索引裁旧尾。在本轮展开的直接调用内没有 FIFO mutation，但索引和流的函数指针仍有未知边。`A02042A8` 根据全局 `A13C3F73` 选择 MemIdx `A04037E0`、RawIdx `A0405C80` 或 TempIdx `A0407474`；当前运行时选择未获取。

普通 event 3 回调限定为 `[A01F569C,A01F5FF0)`，旧导出没有此入口，脚本按真实后继函数边界补入。该回调的直接调用没有全关闭 `A01F6088`、虚拟 FIFO 创建 `A01F6340` 或 FIFO mutation。作为正向对照，`A01F6088` 确实含 **6 处 `AmpFifo_Delete(A04514E4)` 调用**，脚本逐项确认；不能把它混入普通切文件回调。

## 普通切段尾通知与 loop 删除已区分

普通模式 `mode!=4` 的回调尾部在 `A01F5E1C` 准备 `r0=0x48010003,r1=3,r2=0`，于 `A01F5E2C` 发送消息 `A01E659C` → `A01E5DA4`。静态注册和分派链为：

```text
A0113594 注册 DAT_A0FB3364=A01282E0
消息接收 A0113808：0x48010003，feature flag & 4 → action 0x1C
A01282E0：action 0x1C → A011A208(param1=3)
```

`A011A208` 的 param 1 可以转发 stop action `0x13`；param 2 且 camera mode 全局 `A1055CFA==6` 才进入 `A01F51D0` 的 loop 删除；**本次 param 3 在 mode!=6 时只记录日志并返回，在 mode=6 时直接返回**。两组原始指令检查分别构造 mode 2/6，前者执行到原 logger 之前，后者完整返回；均未进入 loop 删除。没有执行实际消息队列和设备模式切换。

其它回调也不能从“没有直接 FIFO API”升级为完整副作用保证。默认命名回调由 `A01F4BC8` 设置，主 `A13C1774=A01F2BE4`、次 `A13C1778=A01F2B70`；命名可进入数据库 `A0224D58` 和偏好更新。`A01F5A64` 的通知可经静态 setter 注册追到 `A0119670`，更新 split 编号/计数并调用 `A018C6D8`。用户数据路径 `A01F538C` → `A043FFFC` → `A043CFDC` → `A04431F4` 的 format vtable `+0x14` 对 MP4 为 `A03FE6AC`，可见数据复制/大小操作，上层 JSON、分配器等叶仍未全部展开。注册值是默认静态来源，不是运行时指针捕获。

## 调用图范围与仍未闭合的合同

脚本只递归展开 `[A03E0000,A0446000)` 及显式列出的 App metadata helpers，跟踪立即数 call 和到已索引函数入口的跨函数立即数 branch。kernel、CFS、分配器、logger、memory/math 等范围外叶明确停止，间接 call/branch 只记录。Capstone 使用 CALL/JUMP 指令组识别，避免把 ARM 条件 `bls` 误判为 BL 调用。

| 图根 | 已展开函数 | 范围外/缺失叶 | 未解析间接位置 | 直达 FIFO API |
| --- | ---: | ---: | ---: | --- |
| MP4 close `A03FE300` | 42 | 12 | 35 | 无 |
| MP4 open `A03FE468` | 25 | 12 | 15 | 无 |
| 文件 open `A0444ECC` | 1 | 10 | 0 | 无 |
| 文件 close `A0445234` | 1 | 5 | 0 | 无 |
| ResetMovie `A01F3124` | 5 | 8 | 0 | PeekEntry |

表内“无”仅描述已展开范围内没有直达 API，不是整个调用闭包不存在 FIFO 修改的证明。不同根可以共享函数，不能相加作为独立函数总数。

继续处理入口也有静态连接：`AmpMuxer_Process(A043D1C0)` → `A0443900` → format vtable `+8` → `A03FE1E4` → `IsoMux_Process(A04356A4)`；limit 经 `A0443720` → `A0442674` 到 event 3，回调成功且不是 EOS 4/PAUSE 6 时可返回 0 到 task。普通切段未直接把状态置为 ended 6/8。但没有真实 task 调度、队列、运行时 FIFO cursor 和下一次描述符身份，不能声称已经看到同一保留帧成为新段首帧。

剩余关键证据是：未解的 index/stream 函数指针与 CFS 外部叶；回调前后真实 FIFO cursor、descriptor/payload 生命周期；次流顺序、错误/assert 路径和生产者背压；首帧参数集及 AAC 配置重建；最终 MP4 可播放性、音视频连续性、丢帧/重帧及长时回收。相机端语音/实体快门触发和一分钟预录均未在真机实现，本轮也未触及它们。

```sh
.venv-reverse/bin/python scripts/prerecord-fifo-rollover-ownership.py
```

后续：[索引与文件流间接调用的条件展开](prerecord-index-stream-vtables.md) 恢复四张 vtable 和默认 MP4 callbacks，将同一 close/open 图扩至 137/73 个函数；其条件范围内没有匿名间接调用，CFS/内核/存储等外部叶及运行时保帧合同仍未闭合。

再后续：[完整 event 3 回调离线执行](prerecord-event3-rollover.md)在原始 ARM 回调与双槽 movie factory 中执行 Close0/Copy/Rel/Reset/Open，合成 FIFO/descriptor 前后逐字节保持且下一段写入原同步帧。它补充本报告未执行的回调链，仍以 RAM 文件及命名/通知模型为前提；完整实时 mux scheduler、双轨 producer/payload 和真实 SD 所有权没有升级为已验证。
