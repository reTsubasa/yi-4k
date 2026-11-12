# YI 4K 1.10.7：RTOS 控制台与内存/任务诊断

日期：2026-11-10。对象：普通 YI 4K / YDXJ2_V13LW / 1.10.7 build a8f840ce_r2746。

本页记录原厂诊断执行与回传路线，属于再次初始化 SharePreview 前的准备关卡。未修改 EIS 算法、刷写 NAND/PTB、运行自定义 ARM 代码、映射 `/dev/mem` 或重新初始化 SharePreview。

**阶段目标已完成：原生诊断命令执行、持久输出回收与固件指纹均通过；实际取得应用池余量及 VideoAnal 任务状态。** 第三轮实验完成标记已回收，全部实验文件已按哈希清理；收尾 API 前后均为 idle，设置子集相同。

## 实际结果及下一步判断

成功实验为 `e30da2b76aa5`，boot ID `aebf2642-5878-4a05-b139-bca05590f528`。claim/done 对应 Linux uptime 23.90 / 27.26 秒；两次任务列表之间含 `sleep 3`，不把整个 3.36 秒窗口当作精确采样间隔。

| 观测 | 结果 | 能支持的判断 |
|---|---|---|
| 应用池 `A0FD7114` | BYTE 魔数正确；两次 Available 均为 **234,597,172 bytes，约 223.7 MiB**；fragment count 522 → 523 | `ps mem` 第 0 行与池头首份快照一致，合计剩余量明显超过前两项 2,310,336 bytes 申请 |
| 应用池区域 | 起点 `C1100000`，大小 451,936,256 bytes（431 MiB） | 与原厂启动分配公式一致；不是 Linux MemFree |
| 其他内存池 | 共 8 个 byte pools、3 个 block pools；后者各剩 8/8 blocks | 原厂概要输出已完整回传；byte pools 名称均为空 |
| VideoAnal initialized | `A14307B8=1` | 创建初始化完成标志存在 |
| VideoAnal TCB | THRD 魔数正确；priority/preempt=136；两次 state=5，即 `QUEUE_SUSP` | 与原厂 `ps tsk` 同名行一致，任务在等消息队列 |
| VideoAnal 等待对象 | `A14308C8` | 与创建函数中的队列对象地址一致 |
| VideoAnal 调度计数 | 1 → 1，二进制 TCB 与文本列表一致 | 本观测窗口未见任务重新调度；尚未观察到分析帧处理 |
| EIS 主任务调度计数 | 46,933 → 53,240（+6,307） | 同一窗口 EIS 主任务确有调度进展 |
| EIS Algo2 调度计数 | 1,116 → 1,248（+132） | 不能将 VideoAnal 等待解释为整个 RTOS 或 EIS 都停止 |

两份 VideoAnal 快照（各 220 bytes）内容相同；栈起点 `A1430A14`、原厂任务接口所列栈尾 `A1438A0F`、保存 SP `A14388A8`，文本和二进制一致。原厂请求栈长是 `0x8000`，任务列表显示可用栈长 32,764 bytes；这里保留各接口原值，不把差 4 bytes 当成越界。

**下一步优先恢复分析帧的启用/投递条件与实际视频模式事件，暂不因 Available 很大就认定 SharePreview init 可以安全重试。** 合计空闲不保证 2.31 MB 连续分配；本轮没有执行 `ps mem detail`，也没有测量最大连续块。VideoAnal 初始化完成同样不等于它正在接收帧；它的阻塞点与创建的消息队列一致，不能据此宣称死锁。下一阶段应把帧事件源、回调注册、selector 与当前模式的关系闭合，再决定 init-only 实验；不需要再猜“是否根本没建任务”或把 Linux 余量当成 RTOS 池容量。

证据：[成功采集](../artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-03/session.json)、[解析结果](../artifacts/device/2026-11-10-rtos-console-route/analysis.json)、[清理回执](../artifacts/device/2026-11-10-rtos-console-route/cleanup-03/session.json)、[收尾基线](../artifacts/device/2026-11-10-rtos-console-route/final-baseline/session.json)。本轮 `t app mem` 排在已执行的连续脚本中，done 说明后续已返回；未启用全局 logger，因此不声称回收了它的 HEAP 打印。可解析的池余量来自 `ps mem` 与原生池头双重核对。

## USB 中的 Shell 字符串意味着什么

不能通过字符串 `Broken Shell starts` / `uvc shell initialized` 推断已经取得通用 RTOS Shell。

| 路线 | 恢复出的实现 | 对当前诊断的意义 |
|---|---|---|
| RTOS USB mode 2 | `A0192474` → `A0231FC8` → `A023166C`；创建 CDC 收发任务，以及 NetCar CLI/Exec 任务 | 当前这条链解析 NetCar 二进制包，不接入普通命令表 |
| NetCar 输入 | `A01B7994` 收集至 NUL；`A01B8710` 检查长度、消息字段和校验；`A01B83FC` 分派服务 | 不是把输入文本交给 AmbaShell |
| NetCar JSON | `A01B8134` 解析 VehicleID、WifiInfo、SSID、密码等车辆/网络字段 | 不是通用执行命令的 JSON 接口 |
| RTOS USB mode 3 | `A0233608` 创建 UVC 视频缓冲、消息队列和发送任务；`A0233340` 处理主机编码请求 | `uvc shell` 是这里的视频服务用语 |
| `console_enable.script` | `A019CE8C` → `A0197424` → `A029DE40`，安装 UART0 读写回调 | 不能据此得到 USB 或 Wi-Fi RTOS Shell |
| Linux `usb_console.sh` | Linux gadget serial + `/dev/ttyGS0` getty | 提供 Linux 登录，方向与 RTOS 命令执行不同 |
| Linux `SendToRTOS` | 固定事件，经 `A023C164` 转为应用消息 | boot_done/module/echo 未恢复出任意命令解释通路 |

这里的负面结论限定于恢复的调用链，没有声称穷尽固件所有隐藏入口。调查期间没有切换 USB 模式或向原始 USB/UART/RPMsg 端点写探测数据。

主机只读枚举时，IOUSB 树中没有相机数据设备；列出的 `/dev/cu.Xiaomi` 本身不能证明它是这台相机的 USB CDC 接口。相机 API/Telnet 则正常可连接，前后 `idle`、固件身份和设置子集一致。证据：[本轮基线](../artifacts/device/2026-11-10-rtos-console-route/baseline/session.json)。USB 物理连接是用户此前报告，枚举结果只描述本次主机观测。

## 原厂命令如何写入 SD 文件

恢复 `A029CB84` 后，可确认普通命令的 `>` 重定向：先按 `>` 分割，解析路径，以 `w` 打开；将命令的输出回调换为 `A029C6DC`，执行后关闭文件并恢复原回调。`A029C6DC` 格式化到原厂缓冲后调用文件写入。

这支持 `ps mem > c:\文件名`、`ps tsk > c:\文件名`。重定向只接管命令传入的打印回调；`t app mem` 的全局 logger 是另一条路，不能承诺也出现在同一个文本文件。原厂 writer 本身不是新开发的有边界格式化器，本实验只使用固定的原厂摘要输出，不向它传入任意格式或无界用户字符串。

二进制辅助快照使用此前真机已验证的原厂 `savebin`，在 RTOS 自身上下文读取：

| 地址与长度 | 内容 | 用途 |
|---|---|---|
| `A0394BA0`，8 bytes | 固件代码指纹 | 与本机保留映像核对 |
| `A0FD7114`，48 bytes | 应用 byte-pool 控制头 | 精确对应 SharePreview 的分配来源；读取 BYTE 魔数、Available、碎片数和区域字段 |
| `A14307B8`，220 bytes | VideoAnal initialized 字节及其后任务 TCB | 确认 flag=1、THRD 魔数、调度计数、等待状态等 |

这不是恢复 Linux `/dev/mem` 采样。两份 pool/VA 快照之间插入一次 Linux `sleep 3` RPC；实际间隔还包括命令和存储时间，不能当作精确 3 秒采样器。二进制读数也不是跨对象原子快照。

VideoAnal 创建函数 `A0238170` 把 initialized 设在 `A14307B8`，任务对象位于 `A14307BC`，原始名字为 `VA frame hdlr`（反编译标签中的空格被替换为下划线）、优先级 136、栈起点 `A1430A14`、长度 `0x8000`。运行循环 `A023809C` 等待消息队列，再持锁分派已注册帧回调。存在该任务或调度计数增长，仍不能代替成功取得帧的证据。

## 一次性诊断与首轮修正

[诊断工具](../scripts/device_rtos_readiness_probe.py)支持 stage、collect、cleanup：worker 先写并校验，autoexec 最后写入；采集保留缺失和部分结果；清理要求逐项匹配已采集内容，并再次验证脚本归属。没有把“采集成功”与“删除结果”绑成一个步骤。

首轮实验 `0fc5406a4c7f` 在物理重启后取得正确 8 字节指纹与 claim JSON，Linux claim uptime 为 23.92 秒；没有 ready、内存/任务输出或 done。首版 worker 在 claim 后尝试删除仍被 RTOS 读取的 autoexec，未走到创建 ready。本轮没有取得异常文本，故只将这条删除路径列为失败候选，不能把文件锁机制写成已证实的根因。所有存在文件均先备份再按类型/哈希清理。

修正版保留打开中的脚本；claim 持久存在时不创建 ready，重复启动先移除本实验空 ready 目录以关闭后续诊断条件。正常完成后由主机采集并清理全部归属文件。相机 Python 2 的临时目录检查已验证首次 claim、持久 done、脚本保留、第二次 claim 关闭 ready；临时目录和传输脚本均已删除。这一检查不代替 RTOS 启动执行。

证据：[首轮采集](../artifacts/device/2026-11-10-rtos-console-route/collect-first-boot/session.json)、[首轮清理输出](../artifacts/device/2026-11-10-rtos-console-route/cleanup-first-boot/telnet-output.txt)、[相机 Python 2 检查](../artifacts/device/2026-11-10-rtos-console-route/target-worker-check/telnet-output.txt)、[修正版部署](../artifacts/device/2026-11-10-rtos-console-route/stage-02/session.json)。在用户开始重启时，另一次 worker 更新传输未完成；其失败回执保留，未当作部署成功，原 worker 哈希仍一致。

第二轮 `5c12b7b27033` 取得新 boot ID、claim、ready 与正确指纹，证明删除路径已避开，但诊断条件未执行。工具误用了 `if cd ...`；项目此前[录像实验](device-eis-recording-trace.md)已经确认这版解析器必须独立 `cd` 再 `if $?`。这是本轮实现遗漏，不是新发现的固件行为。全部第二轮文件已备份、按哈希清理。第三版 `e30da2b76aa5` 使用此前已在真机验证的返回值条件形式，额外检查每个条件前都有独立 `cd`；主机语法检查仍不代替本轮启动验证。

证据：[第二轮采集](../artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-02/session.json)、[第二轮清理](../artifacts/device/2026-11-10-rtos-console-route/cleanup-02/session.json)、[第三版条件核对](../artifacts/device/2026-11-10-rtos-console-route/status-guard-verification.json)、[第三版部署](../artifacts/device/2026-11-10-rtos-console-route/stage-03/session.json)。

## 静态证据复现

[控制台审计脚本](../scripts/analyze_rtos_console_routes.py)固定 RTOS SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，重新反汇编 20 个函数及一个明确有界的 writer 片段，核对 7 处关键指令，同时导出原生任务状态名表。补充 Ghidra 反编译覆盖 15 个入口。证据来自本地 Ghidra/Capstone，未生成 REA Evidence ID。

```sh
.venv-reverse/bin/python scripts/analyze_rtos_console_routes.py
python3 scripts/analyze_rtos_readiness_probe.py path/to/collect/session.json --output analysis.json
```

原件：[静态审计](../artifacts/device/2026-11-10-rtos-console-route/static-audit/audit.json)、[Ghidra 补充导出](../artifacts/device/2026-11-10-rtos-console-route/focused/functions.json)。
