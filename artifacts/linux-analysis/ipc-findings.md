# Linux ↔ RTOS、远程控制与媒体服务：静态证据

分析日期：2026-11-05。目标是从社区 v1.10.52 实际 SquashFS 拆出的 `artifacts/linux-analysis/rootfs/`，不是实体机状态。所有路径以下以该 rootfs 为根。只读主机上的字节、ELF 符号、脚本和既有 RTOS 伪代码；没有执行 ARM 程序、启动服务或连接相机。

## 结论

Linux 是网络、文件与进程承载侧，RTOS 通过 AmbaLink RPC 向 Linux 启动进程、接收网络消息和共享媒体。不是“Linux 只是文件服务器”，也不能把 Linux root 等同于可以调用 RTOS 任意函数。

本轮新增一个与视觉二开相关的实际线索：**固件带有共享预览亮度帧样例 `example_sharepreview`，并在同一 RTOS 中找到匹配的 RPC 注册和 Y 数据复制代码**。因此下一步应先核实已有 SharePreview 服务，而不必直接假定取图必须新写 hook。它仍不能证明能读取原始 Bayer、完整录像分辨率或在 EIS 所需时限内回送网格。

## 1. 基础传输与文件共享

- `/etc/init.d/S50service:15–27` 加载 `ambafs.ko`，挂载 RTOS `a:` 到 `/tmp/FL0`，`c:` 到 `/tmp/SD0`，`c:/dcim` 到 `/tmp/DCIM`，再 bind 到 `/tmp/fuse_d` 和 Web DCIM 目录。Linux 看到的相机卡路径是通过该文件系统接入。
- `ambafs.ko` ELF 符号包含 `rpmsg_vfs_probe/recv`、`ambafs_rpmsg_exec/send`、`register_rpmsg_driver`、`rpmsg_send_offchannel_raw`，支持其 RPMsg 远端文件系统性质。仅有 `generic_file_mmap` 符号不能解释成 RTOS 任意内存映射。
- `S50service:33–39` 启动 `ipcbind -b` 和 `util_svc -b`；`41–61` 在 rpcbind 存在时启动 `rpcbind`、`AmbaNetFifoDaemon`、`AmbaEventNotifyDaemon`。
- `libambaipc.so` 导出 `ambaipc_clnt_create/call/destroy`、`ambaipc_svc_register/unregister/sendreply` 等；`nl_open_socket` VA `0x2A54` 中实际 `socket(AF_NETLINK=16, SOCK_RAW=3, protocol=25)`，然后 bind，支持用户态经内核 IPC 层传递 RPC。不是普通 TCP socket 就能直接访问 RTOS 服务。
- `libambamem.so.1` 的 `AmbaMem_mmap` VA `0x8C8` 根据 type 0/1 选择 `/dev/amba_heapmem` 或 `/dev/amba_dspmem`，通过 ioctl 取得信息再 mmap。`AmbaMem_convert` 使用初始化时保存的地址差值转换指针。接口存在不等于所有物理地址都可安全读写。

## 2. RTOS → Linux 执行命令：util_svc

证据不是仅函数名：

| 导出函数 | ELF 虚拟地址 | 实际指令行为 |
|---|---|---|
| `AmbaRpcProg_Util_Exec1_Svc` | `0x10CBC` | `popen`、`fgets` 读取命令输出，复制到 RPC 返回缓冲，`pclose` |
| `AmbaRpcProg_Util_Exec2_Svc` | `0x10E0C` | 调用 libc `system`，根据执行结果设置 RPC 返回状态 |

同版本 RTOS `a0479708.c` 为 `AmpNetUtility_luExecNoResponse` 路径：创建 Linux host 0 的 RPC client `program=0x20000001, version=1`，调用 procedure 2，发送字符串。它与 Linux `util_svc` 的 Exec2 构成方向明确的静态链路。

这是 **RTOS 调 Linux Shell 命令**。不能倒置成 Linux 可以向它发送 `t app ...`，更不能据此宣称已有 RTOS 本机 loader。原有 `t ipc rpc clnt exec1` 探针的用途仍只是证明该方向通道。

## 3. Linux → RTOS 事件：SendToRTOS / RecvFromRTOS

`SendToRTOS` 是一个 6108 字节 ARM EABI5 动态链接 ELF，导入 `AmbaEventNotify_Init/Send/Release`。其 ARM 主控制流从 VA `0x10740` 开始，`strcmp` 逐项匹配参数，再以固定事件号和可选 payload 调用 `AmbaEventNotify_Send`（共同调用点 `0x1083C`）。

已有命令字符串包括：`boot_done`、`module`、`sta_step`、`net_ready`、`sta_connected`、`test_station`、`net_off`、`photo`、`record`、`iperf`、`dec_complite`、`dec_failed`、`burnin`、`bt_info`、`rtmp`。拼写保留固件原样，不能随意改正后当成有效命令。

两个可交叉验证的映射：

- `boot_done` → 事件 `0x10000001`；`S99bootdone:9–10` 实际在 Linux 启动末尾使用它。
- `photo` / `record` → `0x10000004` / `0x10000005`；`usr/local/share/script/hidraw0.sh:2–5` 将蓝牙/HID 按键匹配到这两项。

`libambaeventnotifier.so.1` 中的 `AmbaEventNotify_Send` VA `0xCA0` 限制 payload 不超过 `0x200` 字节，懒创建 `host=1, program=0x10000009, version=1` 客户端，procedure 1 将 event、length 和数据封入 `0x208` 大小的输入。匹配的 RTOS 注册见 `a0478580.c`，program `0x10000009`、回程 client `0x20000009`。

`RecvFromRTOS` 主流程 VA `0x10768` 调用 `AmbaEventNotifier_Reg_cbEvent` 和 `AmbaEventNotifier_ExecEventProcess`。回调文本包含 Card Inserted/Removed/Formatted、File Created/Deleted、unknown event 和数据长度。**它是事件观察样例，不是 gyro 高频记录器，也不是 RTOS 控制台。**

`AmbaEventNotify_Init` 还建立到 loopback 的 socket；EventNotifyDaemon 负责本地请求/广播和 RPC。具体事件回调 ABI 及多客户端广播语义仍需继续恢复。

## 4. 相机网络 API 的启动由两侧共同控制

`S60postservice:4–22` 里 RTSP、remoteapi cmd/data/syssvc 的直接启动语句被注释，不能由此推导它们不运行。**RTOS 有动态启动它们的代码：**

| Linux 进程 | 同版本 RTOS 证据 | 说明 |
|---|---|---|
| `/usr/bin/remoteapi_cmd_daemon` | `a0476bb4.c:86` | `AmpNetCtrl_CreateInstance` 分支注册 `0x10000005` 后调用 Linux exec 启动命令 daemon；接着创建 `0x20000005` 回程 client |
| `/usr/bin/remoteapi_data_daemon` | `a04771d0.c:59` | 注册 DataNotify `0x10000006`，连接 Linux `0x20000007` 并启动数据 daemon |
| `/usr/bin/remoteapi_syssvc_daemon` | `a0476380.c` | 注册 LnxCmdHndlr `0x1000000B` 后动态启动 syssvc，创建 `0x20000006` client |
| `/usr/bin/AmbaRTSPServer` | `a0244b54.c` | 根据音频配置启动普通或 `--en_audio` 形式，使用 `a0479708.c` 的 Linux exec 通道 |

上游 RTOS `a023e230.c` 可串出网络控制初始化：注册应用回调→创建命令端→创建数据端→创建 RTOS `AppLib Net Control Manager` 任务→初始化 Linux 命令处理器。说明至少一部分相机控制状态与 JSON 处理在 RTOS，Linux 承担 socket 和共享数据收发。

Linux ELF 证据：

- `remoteapi_cmd_daemon` 导入 libremoteapicmddaemon 的 `cmd_server_init/start/create_hndlr`，并包含 `socket`、`bind`、`listen`、`accept` 的真实调用。
- 监听回调 VA `0x10D44` 的入参 r0 是端口；`0x10D68–0x10D78` 做 htons 等效字节交换，`0x10EA4` bind，`0x10F24` listen。该段不是固定 7878 常量。
- `libremoteapicmddaemon.so.1` 导出 `RT_NetCtrl_Send_Clnt`、`LU_NetCtrl_Reply_Svc`、`netctrl_send_command`；依赖 libambaipc 和 libambamem，文字说明它 mmap HEAP 共享区。
- `libremoteapidatadaemon.so.1` 导出 `LU_DataReq_Svc`、`data_server_send_file`、`data_server_send_file_async`、`data_server_read_file_from_SD`、取消传输和状态查询；它是数据/文件传输实现，不能直接视为编码前像素回调。
- 样本中 `/usr/local/share/script/start_vf.py:10–11` 明确连接 `127.0.0.1:7878`，用 JSON `msg_id/token/type/param` 请求，说明该样本对本地 YI API 的预期端口。脚本还会设置时间、发 vf_start，不应作为无副作用探针运行。

因此可以将 remoteapi cmd/data 与 YI 控制链关联，但 **7878/8787 最终监听归属、真实端口和运行生命周期仍需要沿配置 RPC 或真机 socket 表确认**。本轮不把字符串端口等同于已经观测到监听。

### XCServer 是另一条连接桥

`/usr/local/share/script/XCServer` 实际是约 140 KiB 的 ARM C++ ELF，不是 Shell 脚本。它导入 socket/connect/htons、AmbaEventNotify 家族和 system，但本轮动态导入表未发现 bind/listen/accept。

字符串包含 `TCPClient[CONN]`、`RTOS need TCP connect/reconnect/disconnect`、`SERVER::onNetMessage`、`onIPCMessage`、JSON `msg_id`、`start_video_record` 和 `vf_start`。证据支持它处理 RTOS 指示的外连 TCP 与消息桥接；不能因为叫 XCServer 就断言它监听 7878。完整消息协议未反编译。

## 5. 编码媒体：NetFifo 与 RTSP

`AmbaNetFifoDaemon`、`libambanetfifo.so.1`、`AmbaRTSPServer`、`example_framer` 构成明确的媒体接口家族。

- libambanetfifo 导出 StreamIDList、GetMediaInfo、Create/Delete、Peek/RemoveEntry、FIFO/Control callback、ReportStatus 和 PlayBack_OP；依赖 libambaipc、libambamem、libambasocksvc，并使用共享 HEAP 映射。
- `example_framer` 文本明确 `RTOS Encode Started/Stopped`、没有有效 stream 时可能录像尚未开始、video/audio frame、PTS、EOS。
- RTSP ELF 的导出/导入链进入 NetFifo，字符串含 SPS/PPS、`H264/90000`、AAC/MPEG4-GENERIC、RTSP OPTIONS/DESCRIBE/SETUP/PLAY/PAUSE/TEARDOWN，以及 bitrate/report/status 等控制。

这些证据支持 **读取/分发已有编码帧、预览流及播放控制**。不能把“能拿到 H.264 packet”当成“能在硬件编码前修改全分辨率视频像素”。若走解码→CPU稳像→重编码，需要独立的性能与编码器接口证据，当前没有。

## 6. 新发现：SharePreview 亮度帧共享

### Linux 控制流与协议

`example_sharepreview` 的 ARM 指令已经核对，而非仅搜索到字符串：

| 位置 | 静态行为 |
|---|---|
| `0x110C4` | 创建 host=1、program=`0x1000000C`、version=1 的 RPC client |
| `0x10BC4–0x10BE4` | procedure 3，读取 4 字节状态；状态 0 则提示 RTOS 未启用并退出 |
| `0x10C3C–0x10C64` | procedure 1，读取 `0x18` 字节 meminfo |
| `0x10CA0–0x10DA8` | 对两组 ShareInfo/ReaderInfo 的物理地址和大小做 4 KiB 对齐及地址换算 |
| `0x110D4` helper | 打开 `/dev/mem`，mmap 对应物理共享区 |
| `0x111A4` helper | procedure 2，输入一个 4 字节 enable 值，返回 4 字节状态 |
| `0x10DA4–0x10EAC` | enable=1，循环计数设10，读取 active/reading、pitch/width/height/size，fwrite数据到 `/tmp/SD0/PreviewY_%06d.y`；循环结束 enable=0 |

它会更改远端服务状态、更新 ReaderInfo 并写 SD，所以当前不把原样运行它当作首轮只读验证。

### 与 RTOS 的匹配证据

- `a0247e54.c` 注册 `0x1000000C, v1, APPLIB_RPC_SVC_SHAREPREVIEW`，procedure 1→`a0247a20.c` GetMemInfo、2→`a024840c.c` Enable、3→`a02478f4.c` GetStatus，与 Linux 侧一致。
- GetMemInfo 返回 6 个 32 位字段：ShareInfo 虚拟地址、物理地址、大小；ReaderInfo 虚拟地址、物理地址、大小。
- `a0248530.c` init 要求 VideoAnal frame handler 已初始化、MemoryPool有效、宽高非零，分配 `width*height*3 + 0x38` 的共享区和 8 字节 ReaderInfo，组织三个缓冲后注册 RPC。
- `a0247b8c.c` UpdateBuffer 读取源 Y 地址和尺寸，选择避开 reader 的槽位，复制 Y 数据，更新 metadata/active 并调用 cache 相关函数。缓存函数名称仍由已有逆向推断，应进一步核对维护方向。
- `a02484e8.c` 默认配置里宽高是 `0x400 × 0x2F0`（1024×752）。这只代表该默认构造器，不代表用户当前模式实际预览分辨率。
- `a01a18f8.c` RTOS `t app` 处理器约797行含 `sharepv` 分支，约1375–1414行包含 init/enable/disable 调用；init可使用默认构造器与参数覆盖。命令仍需核实 argv 和前置条件，不在此直接给可执行操作串。

**二开意义**：有希望用 Linux C/C++ 做低分辨率亮度图像分析、调试和残差估计，再通过协议与 RTOS 配合。当前仍未知实际每帧延迟、帧号/时间戳、drop策略、缓存一致性、模式覆盖与开录像时能否同时使用；也没有从这一接口回送逐帧 EIS 网格的已验证入口。它不是 Bayer RAW 输出证据。

## 7. Shell、gyro 与 EIS 能力边界

| 问题 | 当前结论 |
|---|---|
| 能否执行 Linux 自定义程序？ | ARM hard-float ELF、动态库与启动脚本存在，具有标准用户态集成基础；实体机 ABI/资源要核实 |
| 能否从 Linux 调用 RTOS 已注册服务？ | 有 libambaipc 与双向 RPC 多个实际服务，可开发匹配协议客户端；不是任意函数调用 |
| 已有任意 RTOS Shell 控制台？ | 所查程序中尚未找到；SendToRTOS 是固定事件分发，util_svc方向相反；kernel config明确 RPMSG_RSH 未启用。不能排除其他未恢复私有服务 |
| 有现成 Linux gyro 物理传感器API？ | 在所查 IPC/媒体接口未找到；不能把 RecvFromRTOS 的事件数据当gyro，当前需RTOS采集/新增可控遥测 |
| 能在 Linux 控制 EIS？ | 高层设置开关可能经相机API透传，但本轮未恢复具体参数；未找到可直接更换逐帧算法的 Linux API |
| 能获取图像？ | 编码媒体有 NetFifo 家族；未编码亮度预览有 SharePreview 明确双侧静态证据，运行条件待测 |
| Linux 能单独实现目标机内 EIS？ | 当前没有完整链路证据。较可行分工仍是Linux做控制/日志/视觉辅助，RTOS生成并按时提交DSP warp |

负面结论仅限定本轮服务/符号/脚本检查范围，不声称证明整个 Linux 或 RTOS 中绝不存在其他接口。

## 8. 留存证据与复核

- `ipc-evidence/elf-symbols.json`：选定27个ELF的哈希、依赖、符号（定义/未定义分开）；更完整清单见主线程 `elf-inventory.json`。
- `ipc-evidence/*.strings.json`：ASCII 字符串和文件偏移，字符串存在仅是线索。
- `ipc-evidence/*.selected.asm`：选定带动态符号函数的 Capstone 指令；函数尾部 literal pool 可能显示为指令，不当作实际执行。
- `ipc-evidence/*.text.asm`：完整 `.text` 的 A32 线性视图；样本混有 Thumb 启动代码、literal pools，非整体可靠反编译。本文使用的关键片段为已人工核对的 A32 函数与直接调用。
- `ipc-evidence/*.plt.json`：按 ARM PLT stub 实际 GOT 目标映射的导入调用名，支持 Thumb veneer 存在时的不同长度，未用固定 stride 强行套表。
- `ipc-evidence/disassemble.py`：主机离线重导出脚本，运行：`.venv-reverse/bin/python artifacts/linux-analysis/ipc-evidence/disassemble.py`。没有目标执行。
- 既有 RTOS 伪代码都在 `artifacts/rtos-reverse/full/decompiled/`，对应 SHA-256 `c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141`，是推断类型的反编译，不是恢复的原厂源码。
