# 预录切段：索引与文件流间接调用的条件展开

本轮继续 [FIFO 所有权审计](prerecord-fifo-rollover-ownership.md)，只做离线分析。在**原厂 App MP4/file 创建路径、默认 MP4 callbacks、三种索引后端并集**这一条件下，上轮 close/open 已记录的间接调用均已恢复静态候选目标，新增展开的调用范围内也没有到达 FIFO API。完整设备合同仍未证明：范围外的 CFS、内核、原始存储、内存和数学叶没有展开，运行时对象身份、下一次 peek 和编码 payload 生命周期没有捕获。

复现：[prerecord-index-stream-vtables.py](../scripts/prerecord-index-stream-vtables.py)。结果：[prerecord-index-stream-vtables-audit.json](../artifacts/device/2026-11-10-prerecord/prerecord-index-stream-vtables-audit.json)。固定镜像及 SHA-256 与前报告相同。脚本记录 4 张原始 vtable、65 个调用位置的原始 load/call 窗口、12 条构造器指令断言、5 组原始指令执行、180 个来源代码 SHA。没有连接设备、替换 helper、执行 FIFO/文件 IO，也没有合成视频或复查 MP4 来推断生产者行为。

## 索引后端与文件流是两种不同接口

`A02042A8` 按 `A13C3F73` 选择 MemIdx/RawIdx/TempIdx。其 CreateImpl 分别在 `A0402610/A04039C0/A040669C` 将下列真实 table 写入对象首字。本轮并不知道设备当前选择哪一种，调用图取三者的并集，并没有把 union 当成当前 runtime 值。

| slot | MemIdx `A078A458` | RawIdx `A078A474` | TempIdx `A078A490` |
| --- | --- | --- | --- |
| `+00` open | `A04032FC` | `A04053B8` | `A0406F64` |
| `+04` close | `A0402ED8` | `A04055EC` | `A04068AC` |
| `+08` read | `A0402884` | `A04040B4` | `A0406384` |
| `+0C` write | `A0402750` | `A0403F18` | `A040614C` |
| `+10` sync | `A0402600` | `A04039B8` | `A0405FC8` |
| `+14` info | `A0402D34` | `A040506C` | `A0406628` |
| `+18` func | `A0402608` | `A0404F70` | `A0405E58` |

文件流由 `A0443CF0` 将 table `A078A4AC` 写入对象首字，各 slot 是 open `A0444ECC`、close `A0445234`、read `A0444D34`、write `A0444B78`、seek `A0445314`、tell `A0443FA8`、length `A0444A0C`、sync `A04455D0`、func `A0445438`。两种接口即使 slot 相同也不能混用：例如索引 `+14` 是输出尺寸 info，文件 `+14` 是 tell；索引 read/write 有 offset 参数，文件 read/write 使用当前位置。

脚本以构造器真实 MOVW/MOVT/STR 三条组合验证四张表的赋值，读取全部表项，并保留调用点前 32 字节的原始指令窗口。调用归类同时参考参数来源，不是只按 slot 数值猜目标。

## format、索引缓存与默认 callbacks 的来源

`IsoMux_Open(A0435A18)` 的主文件流来自 format `+8`，索引对象由其参数传入；`IsoIdx_Create(A040F710)` 将该索引对象存入自身 `+8`。因此 `A040C00C/A040C208/A040D100/A040F318` 等调用的是索引的 info/read/write，MOOV 写出、seek/tell/length 使用的是文件流。

`IsoIdx_InitIndexCfgS(A040EE8C)` 将索引对象和可用文件流放入缓存 config。`AmpIndexCache_CreateImpl(A04014E4)` 将 config `+4/+8` 存至 cache `+38/+48`。`A0401240` 的 fallback 分支在没有索引对象时对文件流 seek/read，有索引对象时按 index offset read；`A0401400` 向索引写缓存，`A0402034` 从索引读取并向文件流写出。脚本针对各具体 callsite 使用对应接口，没有给所有 `+8/+C` 都套相同目标。

`AmpMp4Mux_GetDefaultCfg(A03FECCC)` 真实设置 config `+10=A0433AF0`（MOOV writer）、`+14=A0433C1C`（MOOV size）。App 的 `A01F3338` 使用该默认配置，`CreateImpl(A03FDEC4)` 将它们存至 format `+F78/+F7C`，close wrapper 再传给 `IsoMux_Close` 和 PutTail/PutHead。open/close wrapper 直接传入 ftyp callback `A0435630`。这解析了原先的 callsite `A0433F1C/A0434C34/A0434A00/A0434B74/A0434C04/A0435BE0`。

本轮完整执行真实 default-config routine（含原 memset），确认两 callback 常量。没有捕获设备运行时 format 指针；这仍然是原厂默认创建路径的条件目标，不是任意修改配置下都成立。

## RawIdx 的回调和缺失导出

新展开会遇到 `AmpRawIdx_Access(A0403B04)` 的三个间接调用。read caller `A04040B4` 传入块读取 `A0404684`、部分读取 `A040447C`；write caller `A0403F18` 传入块写 `A0483B28`、部分写 `A0404208`。图保留读写候选并集；块写目标在当前范围外，仍明确作为外部叶。

旧 Ghidra 索引把 `A0404208` 当数据标签，没有独立函数，脚本按其真实代码起点至后继 `A040447C` 补入 `[A0404208,A040447C)`。另四个旧导出缺失入口 `A0402600/A0402608/A04039B8/A0405E58` 都是 `mov r0,#0; bx lr`，各 8 字节，已按原始指令补入并完整执行验证。它们不是未展开的任意函数指针。

TempIdx close 可调用 CFS remove 删除其临时索引文件，RawIdx close 可以做原始索引存储的结束操作。这些文件/存储对象与编码 FIFO 的 RemoveEntry/Delete 不同；本轮没有执行这些 IO，更没有据此授权设备删除或证明它们全部无副作用。

## 展开结果与解释边界

| root | 上轮展开函数 | 本轮展开函数 | 本轮条件解析位置 | 本轮范围内未解析间接位置 | 外部叶 | 到达 FIFO API |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| MP4 close `A03FE300` | 42 | 137 | 55 | 0 | 27 | 无 |
| MP4 open `A03FE468` | 25 | 73 | 18 | 0 | 38 | 无 |

图仍限定为已索引及上述手工补入函数的 `[A03E0000,A0446000)`。外部叶包含 CFS open/close/read/write/seek/tell/remove、mutex/queue/block pool、原始存储、memcpy/memset/字符串及整数运算等；它们在 JSON 中逐个保留路径。两根共享部分函数与调用位置，所以解析位置 55+18 大于唯一位置 65，不能相加解释为唯一目标总数。

“范围内未解析间接位置为 0”只意味着在写明的默认路径与候选后端条件下，该有界图不再留下匿名 BLX。它**不代表整个固件闭包安全，也不证明所有内存写均与 FIFO 状态分离**。内存对象别名、外部 CFS/存储动作、异步生产者仍需要分别验证。

下一项有意义的合同是实际对象间关系：boundary 前后 FIFO cursor 与同一 descriptor/payload、close/open 期间消费者与编码生产者的并发、主次流次序，以及下次 mux peek 是否获得保留的同步帧。首帧 SPS/PPS 重建、AAC 配置及输出文件连续可播放也仍未证明。一分钟预录和相机端语音/实体快门触发没有在本轮实现。

```sh
.venv-reverse/bin/python scripts/prerecord-index-stream-vtables.py
```
