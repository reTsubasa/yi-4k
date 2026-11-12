# YI 4K 1.10.7：SharePreview 初始化依赖与下一次验证

日期：2026-11-10。范围：真机提取的 RTOS 1.10.7 映像，追查 SharePreview 的内存、任务、注册和取帧前提。

后续已找到[原厂内存池查询并刷新真机运行基线](device-1107-readiness-observation.md)：`t app mem` 直接读取此应用池的 Available，`ps mem` 提供池概要；命令尚未在本轮真机执行。

**结论：已恢复的原厂路径中，SharePreview 图像缓冲与 AmbaLink/RPC 最终使用同一个应用内存池。图像分配有有限等待，但后续 RPC 分配存在未检查的失败路径；状态 1 也不能单独证明 RPC 注册成功。`dis` 仅撤销帧回调，没有完整反初始化。此前网络失联的原因仍未知。**

本轮仅做离线分析和主机临时目录验证，没有对相机执行 init/en/dis、重启、录像、内存映射或固件写入。

## 证据身份与复现

输入来自本机此前采集的 `SYS_SW` 分区，不是社区其他版本的地址表：

| 输入 | 字节数 | SHA-256 |
|---|---:|---|
| `sys_sw_partition.bin` | 33,554,432 | `e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6` |
| `rtos-window.bin` | 7,491,584 | `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c` |

窗口基址 `0xA0100000`。脚本重新验证两份哈希及窗口与分区前缀一致，使用 Capstone 从原始字节重新反汇编 26 个函数，并核对 18 处关键指令。既有 Ghidra 伪代码用于辅助解释；函数名和类型是推断，不是原厂源代码。完整函数索引缺失的帧回调，使用后续 focused 索引与连续 80 字节汇编互相核对后确定边界。

- [审计脚本](../scripts/analyze_sharepreview_init_dependencies.py)
- [审计 JSON、函数范围、指令检查和限制](../artifacts/device/2026-11-10-sharepreview-init-audit/audit.json)
- [原厂 RTMP 调用点的有限汇编片段](../artifacts/device/2026-11-10-sharepreview-init-audit/stock-rtmp-caller-excerpt.asm)

```sh
.venv-reverse/bin/python scripts/analyze_sharepreview_init_dependencies.py \
  --output artifacts/device/2026-11-10-sharepreview-init-audit
```

本轮没有可调用的 REA 会话；以上是文件系统证据，不是 REA Evidence ID，也不代表运行时执行追踪。

## 初始化真正依赖什么

| 环节 | 静态恢复结果 | 尚缺运行时证据 |
|---|---|---|
| VideoAnal | `0xA0238170` 创建队列、互斥锁、优先级 `0x88` / 栈 `0x8000` 的帧任务；全部成功后才设置 `0xA14307B8` | 当前启动周期是否已完成、任务是否正常处理事件 |
| 应用内存池 | `0xA018756C` 在 `0xA0187650` 创建控制块 `0xA0FD7114` 对应的 ThreadX byte pool | 当前剩余空间、碎片和最大可分配块 |
| Shell 配置 | 默认 selector=0、period=30、1024×752，使用上述应用池 | 当前视频模式实际产生哪种事件、帧 pitch/宽高 |
| AmbaLink | 两条原厂调用路径把同一应用池传给 NetBase，再交给 AmbaLink 分配器 | 当前池对象状态与其他业务占用 |
| RPC 工作任务 | SharePreview 申请栈、过程表，注册器申请服务对象与过程表，worker 申请回复缓冲 | 任务实际创建、服务可查询、请求可返回 |

应用池到 RPC 的值流已闭合：

```text
0xA018756C：r5 = 0xA0FD7114
  -> 0xA0187698 调用 0xA01E66F4
  -> 保存到全局 0xA13A23E4
  -> 两处调用点 0xA019D964 / 0xA01BD630 从该全局取出 arg0
  -> NetBase InitAmbaLink 0xA023CECC 写入 0xA1445324
  -> AmbaLink Init 0xA03CD46C 写入 0xA17E014C
  -> AmbaLink malloc 0xA03CD2D8 使用该池
```

这证明已恢复路径上的池来源相同；没有读取当前控制块，也没有穷尽未知间接写入。图像分配成功不能代替检查后续 RPC 分配是否成功。

## 内存需求和等待方式

1024×752 的单个亮度槽是 770,048 字节：

| 分配 | 上层申请字节数 | 下层申请字节数 | 等待参数 |
|---|---:|---:|---|
| 三槽图像与头部 | `1024×752×3+0x38` = 2,310,200 | 加对齐余量 64，合计 2,310,264 | 500 |
| reader 区 | 8 | 加对齐余量 64，合计 72 | 500 |
| RPC 栈 | `0x2000` = 8,192 | 对齐封装另加 `0x20` | 0 |
| 临时过程表 | 24 | 同上 | 0 |
| RPC 服务对象 | `0x39C+0x770` = 2,828，采用默认 payload 大小 | 同上 | 0 |
| RPC 内部过程表 | 24 | 同上 | 0 |
| worker 回复区 | 默认 `0x770` = 1,904 | 同上 | 0 |

仅前两项下层申请合计 **2,310,336 字节**，不含分配器元数据。RPC 的默认大小来自静态配置，不表示当前可用容量。

图像分配器 `0xA029A7D8` 传入 500，经 `0xA03BC6DC` 的整数换算后仍为 500 ticks；`-1` 才是该封装保留的无限等待哨兵。因此不能再把正常图像分配解释为直接传入无限等待。有限等待只约束这次分配，不是整个 init 的截止时间，也不能捕获异常或保证所有下层路径终止。

RPC 的分配器 `0xA03BC77C` 传入 0，表示不挂起等待空闲内存。内存不足可能立即返回错误；这要求调用者正确处理失败。

## 已定位的错误处理缺口

1. `sharepreview_register`（`0xA0247E54`）申请 24 字节过程表后，没有检查返回指针便写入；例如 `0xA0247F4C` 的 `str r4, [r1, #4]`。栈指针也未经有效性检查即继续传递。
2. `svc_register`（`0xA03CAAB4`）未检查服务对象和内部过程表的分配结果就清零/复制；创建工作任务的结果被丢弃。
3. `sharepreview_register` 丢弃服务注册的返回值并返回 0；外层 init 在调用后直接把 `0xA1443D18` 写为 1。

因此验收必须区分三件事：**命令已返回、服务可正常 RPC、收到有效帧**。仅看到状态内存为 1，不足以断言服务正常；状态 2 也不能证明图像已经更新。

这些是可由静态指令支持的潜在失败机制，**没有证据表明它们导致此前失联**。此前没有获得 init 前后回执，甚至不能确认 init 执行过，详见[生命周期实验与恢复记录](device-1107-sharepreview-lifecycle-validation.md)。

## 原厂使用场景与帧契约中的限制

原厂 `0xA02489DC` 初始化包装器使用 selector=2、period=12、1024×752；其上游有限片段包含 `###Rtmp Live Mode`，在 `0xA0138984` 调用该包装器。这与 Shell 无参数时的 0/30 不同。它只能证明 RTMP 路径采用此配置，不能证明普通取景模式应该照搬；本轮没有切换 RTMP 模式。

帧回调 `0xA0247E04` 先增加计数器，再检查宽高，最后要求计数器**等于** period。只有复制包装器才将计数清零。如果恰好到 period 的帧几何不符，之后计数继续增长，可能要等显式重置或计数回绕才能再命中。这是静态可见的取帧停滞条件，尚未在真机重现。

复制器 `0xA0247B8C` 使用输入 `pitch×height` 作为复制长度；分配槽容量按配置 `width×height` 计算，所检查函数内没有显式容量检查。不能在未知 pitch 下直接启用，也不能把这一点写成已发生越界。

共享内容仍只有亮度平面，没有已确认的逐帧时间戳。这条接口即使打通，也只是图像观测候选通路；尚不足以支持 IMU/曝光同步、逐行滚动快门补偿或直接替换 EIS warp。

## disable 与恢复边界

`0xA0248314 -> 0xA0248030` 仅从 VideoAnal 撤销匹配的帧回调，成功后状态回到 1。所检查路径没有释放图像/reader/RPC 栈，也没有注销 RPC 服务。

重复 init 在状态非零时只重置 active/reader 索引、刷新共享头，不重新建立服务，不能作为反初始化或故障恢复方法。在已经启用时重复调用，也没有建立并发安全性证据。

所以旧脚本的“bounded, reversible”说明不成立，已删除；清除 SD 探针文件只是阻止后续启动再次执行，不能撤销已创建的 RTOS 对象。

## 探针修订与验证状态

[生命周期探针](../scripts/device_sharepreview_lifecycle_probe.py) 已在主机修订，**尚未 stage 到相机或进行真机验证**：

- 新生成的 autoexec 只执行 `sharepv init`，不自动 en/dis，不主动重启。
- worker 先写入并校验、sync，最后才创建 autoexec，降低不完整部署被启动执行的机会。
- begin/init_after/done 标记改到 SD 卡并请求 fsync/sync；init_after 在状态 RPC 之前落盘，避免查询失败掩盖命令已返回。持久化能力及启动时序仍待实测。
- `collect` 只备份现存文件，允许阶段标记缺失和结果 JSON 不完整；文件内容以 Base64、长度、哈希随主机 session 保存。
- `cleanup` 必须提供已经保存的 collect session，再次检查路径集合与目标哈希完全一致，全部验证后才删除。支持读取旧 stage 回执中的 tmpfs 路径。
- 失败的 RPC 输出记录为 raw 值，仅 rc=0 时提供 status；ABI 和本机 `libambaipc.so` 哈希先校验。

[主机验证回执](../artifacts/device/2026-11-10-sharepreview-init-audit/probe-host-verification.json)覆盖：不完整实验可采集且不删除；目标文件变化时拒绝全部清理；还原采集内容后可按归属清理；新旧回执兼容；生成的 Python 可解析；新 autoexec 没有 en/dis。此验证使用主机 Python，**不验证相机 Python/文件系统/启动执行或 RTOS 行为**。

以下是将来备份与清理的接口说明，不是本轮已执行命令：

```sh
python3 scripts/device_sharepreview_lifecycle_probe.py collect \
  --receipt <stage目录>/session.json --output <新的collect目录>
python3 scripts/device_sharepreview_lifecycle_probe.py cleanup \
  --receipt <stage目录>/session.json \
  --collected <collect目录>/session.json --output <新的cleanup目录>
```

## 下一次真机实验的顺序

当前不重放旧的整段生命周期。下一次应先补齐以下观测，再部署 init-only：

1. 在不重新启动的情况下建立基线：API idle、版本、Linux uptime、现有原厂日志；确认没有旧 autoexec。用原生查询查找池信息和 VideoAnal 就绪证据，避免再次用 `/dev/mem` 连续探测。
2. 先验证“RTOS Shell -> 持久阶段回执 -> 主机读回”的空操作往返，包含启动阶段的 SD/Linux RPC 可用性。begin 只能证明前置 IPC 往返，不能证明后面的 init 已进入。
3. 建立可区分 Linux 重启、网络掉线和 RTOS 执行的额外观测。SD 标记依赖 Linux RPC，不能独立证明 RTOS 存活；当前还没有确认可用的独立 watchdog。若只能观测网络，故障归因仍无法闭合。
4. 条件齐备后只执行一次 init，保留初始化前后原厂日志和 SD 回执；不追加 enable，不重复 init。先保存到主机，再清理启动脚本。
5. 只有确认命令返回且 proc 3/proc 1 成功、返回状态及地址/长度满足契约，才设计单独的取帧实验。地址回读不需要立即映射，先核对几何、槽容量、事件源和停止/恢复策略。

Linux `alarm` 和 RPC 超时只能约束 Linux 客户端，不能打断 RTOS 中已经卡住的调用。后置的 dis/清理脚本也不构成独立 watchdog。后续优先补齐上述缺口，再评估为 EIS 接入图像、gyro 与曝光时间轴。
