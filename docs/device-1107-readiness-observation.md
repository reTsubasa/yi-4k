# YI 4K 1.10.7：原厂内存池查询与运行基线

日期：2026-11-10。目标：在再次初始化 SharePreview 前，找到原生内存/任务查询，区分 Linux 健康状态与 RTOS 就绪条件。

后续真机诊断已经完成：应用池 Available **234,597,172 bytes**；VideoAnal initialized=1、两次均 `QUEUE_SUSP`、调度计数 1→1，而两条 EIS 任务计数增长。命令输出、池头和任务 TCB 已互相核对，实验文件已清理，见[控制台与诊断验证](device-1107-console-and-readiness-validation.md)。下文保留此前找到查询与建立基线时的记录。

**本轮确认 `t app mem` 可直接读取 SharePreview 所用应用池的剩余字节数，并恢复了 `ps mem`、`ps mem detail`、`ps tsk` 的分派和实现。真机 Linux/API 基线已取得；尚未执行这些 RTOS 查询，也未取得当前 RTOS 池容量。**

没有重启、刷机、录像、改设置、初始化 SharePreview、上传探针或映射 `/dev/mem`。

## 可用的原厂查询

| RTOS 命令 | 静态确认的行为 | 使用边界 |
|---|---|---|
| `t app mem` | 读取 `0xA0FD7114+8` 和 `0xA0FE7220+8`，打印 HEAP / NON-HEAP 剩余字节数与右移 20 位的 MiB 整数 | 最直接识别 SharePreview 所用池；只有合计剩余量，没有最大连续空闲块 |
| `ps mem` | 调用 `0xA048FB7C` 枚举 byte pools，再调用 `0xA048FE2C` 枚举 block pools | byte pool 输出 ID、Available、Fragement、Name；未命名池仅凭行号不易定位 |
| `ps mem detail` | 调用 `0xA048FCA0`，打印 byte pool 的区域起点/长度，再逐块输出 Start、End、Size、Free | 直接遍历块链，输出量随碎片增长；不作为首轮必要查询 |
| `ps tsk` | 调用 `0xA048F43C`，经任务信息接口读取状态、优先级、调度计数、栈字段等 | 单次列表不能证明任务持续工作或 VideoAnal 正在处理帧 |

这些是 RTOS 命令，不能直接输入 Linux Telnet Shell。查询本身仍会使用同步机制、写临时输出区和打印；不能把它们称为完全无副作用或绝不会阻塞的接口。

`t app mem` 的关键证据：

```text
0xA01A6030：注册名字 app，handler = 0xA01A4F34
0xA01A4FB4..0xA01A4FC8：比较 argv[1] 与 mem，匹配后转入 0xA01A5374
0xA01A5394：从 0xA0FD7114 + 8 读 available
0xA01A539C：通过 0xA02A70EC 打印 HEAP
0xA01A53B0：从 0xA0FE7220 + 8 读 available
0xA01A53B8：通过 0xA02A70EC 打印 NON-HEAP
```

输出格式分别是：

```text
HEAP    : Available size  = %10d bytes = %4d Mbyte
NON-HEAP: Available size  = %10d bytes = %4d Mbyte
```

`t app mem` 使用全局打印函数；`ps` 使用调用者传入的输出回调。必须先核对输出是否进入可回收的日志，不能仅凭命令返回就认定已经取得统计值。

## 如何判断内存是否足够

池结构中的 `+0x08` 是 Available，`+0x0C` 是 fragment count；`+0x18/+0x1C` 是区域起点/大小。原厂 checked info 接口 `0xA03C36C4` 检查 `BYTE` 魔数，再在临界区读取概要字段。

SharePreview 前两项下层申请分别为 **2,310,264** 和 **72** 字节，还需要 RPC 栈、对象和回复区。Available 是池合计剩余量，不能保证大块图像分配成功。

详细遍历中，块头为两个 32 位字：next 指针，以及 `0xFFFFEEEE` 空闲标记或所属池指针。分配器 `0xA03BD130` 对有效向前连接的空闲块按 `next-current-8` 计算 payload 容量，说明 detail 打印的原始 Size 还包含块头。分配器也会尝试合并相邻空闲块。

因此，后续若使用 detail 输出估算最大可分配块，必须检查地址顺序、空闲标记、尾部回绕和头部开销；它仍只是当时快照。概要查询与完整块链遍历不在同一个总临界区内，其他任务仍可能分配/释放；不能把这个估算当成后续分配的保证。

首轮优先取得 `t app mem` 和 `ps mem`，结合 `ps tsk` 查找 `VA_frame_hdlr`。是否需要 detail，取决于概要值及输出通路验证结果。不要用 `ps all` 代替有范围的查询；同一个 ps handler 还含 IRQ/profile reset 等其他分支。

## 真机基线结果

使用[只读基线脚本](../scripts/device_readiness_baseline.py)，采集 12 组现有 Linux 信息，并在前后分别查询原厂 API：

| 观测 | 实际结果 |
|---|---|
| API 前后状态 | `idle` / `idle` |
| 固件 | `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746` |
| 设置子集 | 前后相同；1080p30 NTSC，EIS on |
| Linux uptime | 1423.09 → 1423.51 秒 |
| Linux 内存 | MemTotal 49,096 kB，MemFree 6,000 kB，Cached 15,548 kB |
| SD 启动文件 | `autoexec.ash`、`save_log_enable.script` 均不存在 |
| RPMsg 端点 | CLK、aipc_rpc、aipc_vfs、aipc_rfs、LinkCtrl、echo_cortex |
| `/proc/ambarella/uport` | 当前不存在 |
| Linux 串口节点 | 观察到 `/dev/ttyS1`、`/dev/ttyS2`；未列出 ttyUSB/ttyGS/rpmsg 字符设备 |
| ttyS1 现有使用者 | `bsa_server_43340 -d /dev/ttyS1 -p`，为蓝牙服务 |

Linux MemFree 不能代替 RTOS 应用池 Available。`echo_cortex` 端点名也不证明有远程 Shell。没有向 UART、proc 控制节点或 RPMsg 写入测试数据。

以上节点列表不能确定物理 UART 引脚、接线或板级可访问性；也不意味着通过 USB 就能接入 RTOS UART0。此前已恢复的 RTOS Shell 输入路径仍指向 UART0，当前没有建立 Linux→RTOS 任意 Shell 通路。

证据：[原始采集回执](../artifacts/device/2026-11-10-readiness-baseline/session.json)、[主机派生摘要](../artifacts/device/2026-11-10-readiness-baseline/analysis.json)。此基线没有调用新的 RTOS 查询。

## 下一步验证顺序

1. 先验证原生命令的执行入口与输出通路。已有启动 autoexec 能执行命令，但会把“开机恢复”和“查询执行”混在一起；暂不重放 SharePreview 初始化，也不重放 boot_done 等启动事件来假装普通 Shell 输入。
2. 只执行内存/任务诊断，取得带实验身份的持久回执和可解析输出。优先 `t app mem`、`ps mem`、`ps tsk`，不附带 init/en。
3. 把 `VA_frame_hdlr` 的列表状态、VideoAnal 初始化日志和实际事件进展分别核对。任务存在、日志曾打印、当前可取帧是三种不同证据。
4. 输出通路与内存前提闭合后，再决定是否部署[init-only 探针](device-1107-sharepreview-init-dependencies.md)。独立于 Linux 网络的执行观测仍未建立；现有 SD/RPC 回执不构成 RTOS watchdog。

当前已完成“找到原生查询”和“刷新真机健康基线”；“取得当前 RTOS 池统计”和“建立独立观测”仍未完成。没有证据表明 EIS 效果已发生变化。

## 复现与证据范围

[离线审计脚本](../scripts/analyze_rtos_readiness_commands.py)验证本机 RTOS 窗口 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，复核 shell 表中的 ps 指针，重新反汇编 7 个函数与 3 个有限片段，核对 7 处关键指令。

```sh
.venv-reverse/bin/python scripts/analyze_rtos_readiness_commands.py \
  --output artifacts/device/2026-11-10-readiness-commands
```

输出：[机器可读审计](../artifacts/device/2026-11-10-readiness-commands/audit.json)。两个命令 handler 不在既有全函数索引内，所以明确保留为有限片段，没有声称恢复其完整控制流。既有 Ghidra 伪代码用于解释，新反汇编用于核对指令。本轮使用文件系统证据，没有新的 REA 会话或 Evidence ID。
