# YI 4K v1.10.52：图像、DSP 与 Linux IPC 静态逆向

本文是整体 RTOS 报告的子系统证据。分析对象仅为普通 YI 4K v1.10.52 的 `_part_lrtos.a9s`，SHA-256 `c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141`，分析映射基址 `0xA0100000`。所有地址均绑定该字节版本，不能直接移植到 YI 4K+、其他固件或同 SoC 产品。

证据来自 Capstone A32 指令与 Ghidra 伪代码交叉核查，没有运行相机、下载补丁、修改闪存或观测实时画面。Ghidra 的类型、函数边界、返回值和名称可能推断错误；原型是二开调查索引，不是可直接链接的 SDK 头文件。以下“确认”指静态指令和参数流确认，不代表真机验证。固件整体为 ARM/Thumb 混合；本目录只导出选定 A32 窗口。

## 可以复用到什么程度

1. 已定位一个实际的 RTOS 图像控制层，提供图像 context、互斥锁、warp 参数读取/计算/下发、MCTF 参数读取/更新以及缓存维护。它不是只能改 UI 或 Linux 脚本的黑箱。
2. warp 路径最终把两张各 `0x1800` 字节的表交给现有 DSP 提交函数。这是用自定义几何计算结果驱动原有 DSP 的候选实现基础；它不等于恢复 DSP 微码或已实现现代防抖算法。
3. AmbaLink RPC 客户端和服务注册路径可以复用，适合在 RTOS 保留帧时序敏感部分，在 Linux 放配置、存储、网络等控制逻辑。Linux 执行服务的具体实现仍需 Linux 侧继续核对。
4. 尚未确认每帧回调的最佳挂接点、实时预算、warp 坐标定点单位、跨帧缓冲生命周期、完整调用 ABI、与录像状态机的互锁。因此本阶段可以指导探针与 SDK 包装层开发，不能宣称已经具备可量产自定义固件。

## 图像 context 与锁

图像调试 handler 用第一字 `0x100`、其余清零来初始化局部 context；日志按 `Pipe / Algo / Func / Ctx / Id / Hdr` 打印。可识别布局为 byte0 Pipe、byte1 Algo、byte2 Func、byte3 Ctx、+4 的 32 位帧/配置 ID、byte8 Hdr。**完整结构长度、+9 之后布局仍未恢复**，不要把局部初始化大小等同于公共结构 ABI。

`0xA0308880` 根据 Pipe 和 Ctx 找互斥锁，`0xA03BC46C` 获取锁，`0xA0308754` 取得 context backing store，`thunk_FUN_a03c3c5c` 释放锁。Pipe=0 对应 video，Pipe=1 对应 still。warp 明确分别处理 video/still；部分 MCTF still 分支的伪代码留下 NULL 源指针，故 MCTF 二开只应先调查 video 路径，不能依据接受 Pipe=1 就认定 still 支持安全。

## Warp：从参数到 DSP 的完整候选链

入口 `t img -warp` handler：[`0xA022D820`](../full/decompiled/a022d820.c)，指令窗口 [`a022d820.asm`](a022d820.asm)。其中多个数值模式为工程调试案例，存在硬编码尺寸和缺乏充分 argc 检查的问题，不是稳定、通用的产品 API。

| 地址 | 依据自身日志恢复的名称 | 静态确认的行为 |
|---|---|---|
| `0xA031282C` | `AmbaDSP_ImgGetWarpCompensation` | `(ctx, out)`，拒绝 NULL out；加锁后拷贝 `0xC0` 字节；video 源为 context+`0x2F18`，still 为 +`0x52A90`；返回 0 或错误 |
| `0xA03119A8` | `AmbaDSP_ImgCalcWarpCompensation` | `(ctx, info)`，验证几何与表指针，调用 `0xA032CF38(ctx, intermediate, result)`，成功后保存参数和内部计算结果；可能附加 `0x10000000` warning 标志 |
| `0xA0312460` | `AmbaDSP_ImgSetWarpCompensation` | `(ctx)`，锁内复制生成的水平/垂直表，清 D-cache，并按帧 ID 提交给 `0xA02BD9F0`，部分状态还调用 `0xA02BC3F8`；设置 dirty 标志掩码 `0x04` |

证据：[Get](../full/decompiled/a031282c.c)、[Calc](../full/decompiled/a03119a8.c)、[Set](../full/decompiled/a0312460.c)、[三者指令窗口](a03119a8.asm)。

### `0xC0` warp 信息布局

名称来自 Calc 的字段打印和验证路径；以下偏移是字节。没有列出的字节保持未知，不能清零重建再盲传。

| 偏移 | 字段/访问宽度 | 已见约束或含义 |
|---|---|---|
| `+0x00` | WarpEnb，32 位 | 非零才启用校准 warp 检查 |
| `+0x04` | Control，32 位 | bit `0x100` 参与 VIN 几何验证分支；其余语义未解完 |
| `+0x08` | Version，32 位 | 启用时接受 `0x20140701` 或 `0x20130101` |
| `+0x0C`, `+0x10` | HorGridNum / VerGridNum，32 位 | 与 tile exponent 决定网格覆盖范围 |
| `+0x14`, `+0x18` | TileWidthExp / TileHeightExp，32 位存储 | 检查 `(gridnum - 1) << exponent` 至少覆盖校准宽/高；计算使用低 byte |
| `+0x1C`..`+0x28` | 校准 VIN StartX / StartY / Width / Height，4×32 位 | 参与当前 VIN 被校准范围包含的检查 |
| `+0x2C`..`+0x2F` | HNum / HDen / VNum / VDen，4×8 位 | 在对应验证分支必须非零 |
| `+0x3C` | pWarp，32 位指针 | 启用时不能 NULL；日志按每点 signed16 X、signed16 Y 访问，每点 4 字节；坐标单位尚未确定 |
| `+0x40`..`+0x4C` | 当前 VIN StartX / StartY / Width / Height | 4×32 位 |
| `+0x50`..`+0x53` | 当前 VIN 四个采样因子 | 4×8 位；对应验证分支检查非零 |
| `+0x54`, `+0x58` | R2rOutWinDim Width / Height | 32 位；零时部分计算使用 VIN 宽/高 |
| `+0x5C`..`+0x68` | Dummy window X / Y / Width / Height | 4×32 位；验证窗口边界 |
| `+0x6C`, `+0x70` | CfaWinDim Width / Height | 不可为零 |
| `+0x74`..`+0x80` | ActWinCrop X / Y / Width / Height | 4×32 位；日志以缩放后小数打印；定点比例尚未独立确认 |
| `+0x84`, `+0x88` | Main output Width / Height | 需非零 |
| `+0x8C`, `+0x90` | Prev0 output Width / Height | 32 位 |
| `+0x94`, `+0x98` | Prev1 output Width / Height | 32 位 |
| `+0x9C`, `+0xA0` | Screen output Width / Height | 32 位 |
| `+0xA4`, `+0xA8` | Thumb output Width / Height | 32 位 |
| `+0xAC` | HorSkewPhaseInc | 32 位；数值含义未恢复 |
| `+0xB8` | theta，64 位 double | still 非零时被清为零并产生 warning；单位/方向需验证 |

Calc 实际计算器 `0xA032CF38` 与 DSP 提交层仍需继续逆向。Set 在锁内把生成表各复制 `0x1800` 字节到运行缓冲，然后调用低层 D-cache 清理 `0xA04A22CC`。`(ctx.Id & 0xF) != 0xF` 时会提交 `0xA02BD9F0(ctx.Id, 0, config)`；低四位为 F 的 ID 具有特殊的延迟/上下文路径，不能把 Id 固定设为 0 就假定适用于全部视频模式。

二开探针应遵循已有顺序，概念伪代码如下，**不是可以刷入的补丁**：

```c
status = GetWarp(existing_video_ctx, info_0xc0);
// 保留 mode、尺寸、指针和保留字段，只改变已验证字段。
status = CalcWarp(existing_video_ctx, info_0xc0);
// 解释错误与 warning 标志；成功后才进入 Set。
status = SetWarp(existing_video_ctx);
```

从只读 Get 和日志开始，再测一次不改变参数的 Calc/Set 是否维持录像；随后才是小幅可逆的几何变化。直接填写 pWarp 还需要确认网格尺寸上限、坐标单位、buffer 对齐/生存期和分配器，不能依据每点 4 字节就随意分配。

## MCTF：有现成调参层，但结构和应用时序尚未完全恢复

入口 `t img -mctf`：[`0xA0227DFC`](../full/decompiled/a0227dfc.c)，日志名 `AppLibTune_Mctf`。

| 地址 | 名称/候选含义 | 已确认行为 |
|---|---|---|
| `0xA030E810` | `AmbaDSP_ImgGetVideoMctfInfo` | `(ctx,out)`；video context+`0x2FE0` 复制 `0x3C` 字节 |
| `0xA030DF5C` | `DSP_ImgGetVideoMctfAddr` | `(ctx,void **out)`；只接受 video，读取 context+`0x40C50` 字段保存的指针 |
| `0xA030E2F8` | MCTF 综合信息 setter，名称未完全确认 | handler 将强度/配置传入；配套读取与 DSP 更新路径可继续跟踪 |
| `0xA030F1E4` | `AmbaDSP_ImgSetVideoMctfEnable` | `(ctx,uint8)`；通过 checker `0xA032984C`；值 >1 产生 warning；可能经 `0xA030E014` 更新 DSP |
| `0xA030F3DC` | compression enable 候选 | handler `cmpr_en` 调用 |
| `0xA030F820` | ZMV enable 候选 | handler `zmv_en` 调用 |
| `0xA030F030` | ghost Y/Cb/Cr setter 候选 | handler 打包三个 uint8；内部 context+`0x3024`、checker `0xA032978C`、DSP 更新 `0xA030E014` |
| `0xA030F9F4` | ZMV getter 候选 | handler 的 info 路径调用 |

证据：[get info](../full/decompiled/a030e810.c)、[get addr](../full/decompiled/a030df5c.c)、[enable](../full/decompiled/a030f1e4.c)、[ghost](../full/decompiled/a030f030.c)、[handler 指令](a0227dfc.asm)。

info 打印包括 Enable、YCombinedStrength，以及 Y/Cb/Cr 的 TemporalAlpha0..3、T0..3、MaxChange、Radius、ThreeD/Spatial strength、LevelAdjust；通道 stride 为 `0x12`。这支持复用现成降噪参数层，但不足以声称已得到完整公共结构头文件。

load/save 路径直接操作固定 **`0x6BD0` 字节** MCTF blob：save 取运行指针后写文件；load 先读临时地址 `0xA13C9800`，再用 memcpy `0xA029C680` 覆盖现有运行 buffer，并调用 D-cache clean `0xA0498728(dest,0x6BD0)`。未见足够的文件长度校验、完整事务同步或明确的重新提交保证。此调试功能是结构恢复线索，不能作为任意配置上传器交付。

## IDSP 与缓存调试

入口 [`0xA022B96C`](../full/decompiled/a022b96c.c) 包含 dump / multi / debug / dbgthd / flush / clean。已看到以下实际调用：

- `0xA02CB808(out_capture_info)`：取 capture state；dump 路径检查首字为 `0x330`。
- `0xA02C629C(module_u8, mask_u32, 0)`：设置调试输出。
- `0xA02C6314(mask_u8)`：调试线程掩码。
- clean 调用 `0xA0498728(addr, bytes_u16)`，flush 调用 `0xA04987F0(addr, bytes_u16)`。

地址、长度、共享 DMA buffer 需来自已验证 context；任意地址 cache 操作不应暴露给用户配置。该入口为研究 DSP 状态提供线索，并不证明支持任意 DSP 算法替换。

## AmbaLink RPC：RTOS ↔ Linux 的可复用控制面

入口 `t ipc rpc` handler：[`0xA0245CF4`](../full/decompiled/a0245cf4.c)，支持 list / svc / clnt / profile。该路径包含真正的客户端构建、RPC 编组、发送、事件等待和返回拷贝，并非仅字符串命中。

| 地址 | 候选原型 | 静态行为/限制 |
|---|---|---|
| `0xA03C4E94` | `client_create(host, program, version)` | 分配 `configured_payload_size + 0x110`；host 写 +`0x71`、program +`0xB0`、version +`0xB4`；绑定失败仍可能返回已分配句柄 |
| `0xA03C4F40` | `rpc_call(client, proc, in, inlen, out, outcap, timeout)` | 加 client 锁，必要时绑定，发送后按 timeout/过程元数据决定等待；返回 transport/service status |
| `0xA03C4C1C` | `client_destroy(client)` | handler 清理客户端所用 |
| `0xA03CD2D8` | `alloc(bytes)` | 此 RPC 区域的分配调用 |
| `0xA03CD264` | `free(ptr)` 候选 | 与 handler 释放路径关联；完整分配器契约未恢复 |
| `0xA03CAAB4` | `service_register(...)` | 测试服务注册调用，完整参数类型待恢复 |
| `0xA03CAC1C` | `service_unregister(program, version)` | 测试服务注销 |
| `0xA03CAA4C` | `service_list(print_cb)` | 列举服务 |

证据：[create](../full/decompiled/a03c4e94.c)、[call](../full/decompiled/a03c4f40.c)、[handler](../full/decompiled/a0245cf4.c)。

`rpc_call` 的过程号从 **1** 开始，元数据以 `proc-1` 索引；将输入拷贝到 client+`0x110` 后发送 `0xA03C88F8`。函数体中未见明显的 inlen 容量和 proc 上界检查。因此包装层必须验证已绑定的句柄、过程号范围与已分配 payload 容量，不能只检查 client 非 NULL。timeout=0 或过程元数据表示 one-way 时，不等待而返回 0；等待事件通过 `0xA03BC4AC`，超时返回状态 4；成功时输出拷贝 `min(server_result_len,outcap)` 字节。

### 固件内置 Linux 执行服务

handler 创建的客户端为 `host=0, program=0x20000001, version=1`。

- [`0xA03C9188`](../full/decompiled/a03c9188.c)：输入 `(cmd,out,client)`，调用 proc1，输入长度 `strlen(cmd)+2`，输出上限 `0x800`，timeout `5000`。Ghidra 推断为 void，但调用处使用状态，需按真实 r0/ABI 再确认；不能照抄 void 原型。
- [`0xA03C91D0`](../full/decompiled/a03c91d0.c)：调用 proc2，输入同样来自字符串，out=NULL、outcap=0、timeout=0，属于单向操作。

proc1 的返回状态不能直接解释为 Linux shell 的退出码；Linux 端服务、编码和响应终止方式尚未检查。`strlen+2` 也意味着封装代码要提供并初始化额外字节，不可只分配 `strlen+1`。

调试 handler 的命令缓冲仅分配 `0x65` 字节，随后反复 strcpy/strlen 拼接，缺少明显边界保护。因此后续二开应自己做有界 RPC 包装，而不是把该 shell handler 直接作为产品远程控制接口。

`rpc svc test +` 使用 program=`0x10000001`、version=1、name=`test_rpc_svc`，priority=`0x41`，传入 `0x1000` stack 和两个过程入口 `0xA0245620` / `0xA024566C`。这为创建独立 RTOS 服务提供调用范例，不能在恢复完整参数之前直接复刻注册原型。profile start=`0xA03C8988`，stop=`0xA03C8AB0`。

## Linux 生命周期命令与 RPC 区分

[`ambalink handler 0xA03CD3F0`](../full/decompiled/a03cd3f0.c) 要求 argc=2：`load` 调 `0xA03CD3B4()`，`boot` 调 `0xA03CF31C(5000)`；初始化注册 shell 命令时调用 `0xA029E098`。这是 Linux 装载/启动路径，不是普通消息发送。常规二开可优先调查已有 RPC 服务，避免把反复启动 Linux 当作通用数据接口。

## 建议下一步实施顺序

1. **只读观测**：在原录像状态中记录 context/帧 ID、warp `0xC0` 快照与 MCTF `0x3C` 快照，核实结构和模式对应关系；禁止从调试 handler 的默认局部 context 推断生产 context。
2. **接口包装**：恢复真实调用约定、Thumb bit、栈对齐、VFP/NEON 使用与锁上下文；为该 SHA 生成版本门禁和有界 RPC 包装；所有内存分配、缓存操作跟随原调用链。
3. **最小行为实验**：先不改变参数执行 get→calc→set，测录像连续性、掉帧和错误；再单参数小幅变化，并保留回退路径。不要在回调中做文件、网络或阻塞 RPC。
4. **恢复调度点**：继续跟踪图像帧回调、DSP 消息消费与录像状态机，确定调用线程、帧表时限和 buffer 复用规则；这是逐帧自定义处理能否稳定的核心未知项。
5. **更深 DSP 层**：独立分析 `0xA032CF38`、`0xA02BD9F0`、DSP 命令结构和微码资源。优先复用 DSP 已有变换能力，再评估需要自行实现的计算。其他 Ambarella 产品只能辅助命名与结构比对，不能证明这里 ABI 相同。

## 交付和复现

- [`api-inventory.json`](api-inventory.json)：带版本哈希、证据路径、候选原型和置信级别的索引。
- [`export-provenance.json`](export-provenance.json)：Capstone 版本和窗口范围。
- `scripts/rtos_image_ipc.py`：从工作区执行 `.venv-reverse/bin/python scripts/rtos_image_ipc.py`，先校验 SHA 再重建 10 个选定 A32 窗口。不执行固件、不修改镜像。
- `../full/decompiled/*.c` 为 Ghidra 生成伪代码，并非原厂源码；绝对地址只对上述 SHA 有效。
