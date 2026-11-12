# 真机 stock-only EIS 边界采集方案（待确认）

日期：2026-11-10。本文是未来一次真机实验的执行方案，当前只写文档，**没有写入 SD 卡、重启相机或运行任何设备命令**。执行前需要用户单独确认，因为即使只写入 SD 文件和启动脚本，也可能造成启动异常或录像中断。

## 当前状态和不能执行的原因

现有 [影子记录器](eis-1107-shadow-recorder.md) 是 v1、80B 记录格式。它记录 `input`、`previous`、原厂 `output` 和参数，但没有 `previous_after`。替换门槛要求调用后 canary，因此现有 v1 导出不能直接通过 [边界 gate](eis-boundary-trace-gate.md)。下一版设计为 88B 记录：v1 字段区保持兼容，新增 `previous_after`，使用 offset 84 的 `commit_v2` 最后发布；旧 offset 76 的 v1 `commit` 保持为零。头部应声明 `version=2`、`record_bytes=88`、容量 128，总缓冲区 11,328B。

离线 v2 C/A32 wrapper 已在 Unicorn 中验证 512 组调用、`previous_after`、`commit_v2`、满缓冲旁路和寄存器/栈保持；但它还没有经过 [原生执行关卡](device-1107-native-execution-gate.md)，也没有任务创建协议、代码/数据 cache 发布闭环或卸载路径。因此不能把 `loadbin`、`savebin`、`t ipc` 或 Linux root 权限当成 v2 wrapper 的执行通道，也不能开始下面的真机步骤。

## 用户确认前的离线准备

只有以下材料齐全，才会提交一次具体的真机确认请求：

1. v2 C/A32 wrapper 的源文件、ELF、符号表、链接图、SHA-256 和目标固件哈希；`previous_after`、`commit_v2`、栈/寄存器保存和 `stock_invocations=1` 均有 Unicorn/静态证据。
2. 原生入口已通过一次性任务或已核实的注册路径验证：能进入、返回、报告固定标记，且有明确 A32/Thumb、栈、D-cache clean、I-cache 发布、多核可见性和异常回收证据。
3. wrapper 仍执行原厂 A0384710 一次，未修改 r0/r1/r2 和返回值；缓冲区固定为 v2 88B，不等待、不写文件、不访问 DMA/GUI。
4. 主机已准备唯一 session id、证据目录、采集脚本 hash 和恢复脚本 hash。当前 [device_eis_recording_trace.py](../scripts/device_eis_recording_trace.py) 的 stage/collect/cleanup 流程只能作为 SD 文件和原厂 API 录像的安全模板，不能代替 v2 wrapper 的执行入口。

若任一项缺失，实验状态保持“不可执行”，不请求用户批准真机写入。

## 需要用户确认的真机动作

确认范围只包括 SD 卡文件暂存、重启、一次短 stock-only 录像和清理。方案不包含 RTOS 分区、启动区、PTB、持久化配置或固件刷写。用户确认时应看到具体文件列表、每个文件的 SHA-256、目标相机地址、预计录像时长和回滚命令。

### 1. 备份和预检

- 相机关机，取出 SD 卡；将根目录原有 `autoexec.ash`、`console_enable.script`、日志标记和同名脚本复制到主机备份目录，保留权限、大小和 SHA-256。已有脚本不能覆盖，新的文件使用唯一 session 前缀和独占创建。
- 在主机保存固件/设备版本、RTOS 窗口哈希、当前 API 状态、SD 剩余空间、电量和最近一次正常录像信息。不要为对齐地址升级或降级固件。
- 预检报告必须证明相机空闲、未录像、EIS 模式可用、存储卡可写且有足够空间；预检失败时不创建 ready 标记。

### 2. 暂存文件

在获得确认后，才通过现有 Telnet/LINUX 文件通道写入 SD 文件：

- 唯一的 `autoexec.ash` 启动脚本；
- 预检/停止 worker；
- v2 wrapper 的只读 stock-only payload 和版本清单；
- 空的 ready/stop 标记目录或文件；
- 不写入 RTOS 分区、`/dev/mem`、私有 DRAM 或持久化设置。

每个文件都用独占创建，写完立即回读并比较 hash；失败时只删除本次已创建且 hash 相同的文件。启动脚本采用已有实验的 18 秒缓冲（六次不超过 RPC 等待上限的 sleep）和独立 `cd` 返回值判断，避免把普通 shell 条件误当作 RTOS 条件。

### 3. 重启和启动

关机后插卡启动。worker 先等待系统稳定，再读取只读固件指纹和预检状态；只有预检成功才创建 ready 标记。启动阶段只验证 wrapper 的进入/返回标记和原厂录像状态，不立即替换算法，也不开始长录。

若没有看到进入和返回标记、RTOS 日志异常、API 状态不再是 idle/viewfinder，或启动时间超过预设上限，立即停止实验，关机取卡，执行清理；不得继续录像。

### 4. 短 stock-only 录像和观测

确认启动探针返回后，使用原厂 API 开始一段约 2–5 秒的支持 EIS 模式录像。wrapper 在两个真实调用点只做以下动作：

1. 读取 `r0/r1/r2`、`[r2]`、运行态参数和 tick；
2. 调用原厂 A0384710 一次；
3. 再读取 `[r2]` 形成 `previous_after`，写入 v2 记录；
4. 以 `commit_v2` 最后发布，保持原厂返回值不变。

实时路径只写固定缓冲区；满缓冲、LDREX/STREX 竞争、来源地址无效、记录提交不连续或任一异常都旁路到原厂函数并设置停止标记。出现这些情况时不扩大录像时长。观测命令只读取已停止生产者的 v2 缓冲导出，不轮询私有内存。

### 5. 停止条件

出现以下任一项就停止录像并进入清理：

- wrapper 进入/返回标记缺失，任务未返回或任一 RTOS/API 超时；
- `dropped_full` 非零、`busy_seen` 为真、`commit_v2` 不连续、记录 hash 不一致或 `previous_after != previous`；
- 相机重启、界面失去响应、录像未进入/未退出 idle、出现错误日志或存储异常；
- 电量、温升、SD 空间或录像文件状态超出预设限制。

停止 API 返回后等待状态稳定到 idle，再读取一次只读状态和文件清单。停止后不再重新 arm wrapper。

## 清理、回滚和证据

清理顺序如下：

1. 通过已核对 hash 的 disarm worker 删除本次 `autoexec.ash`、worker、wrapper payload、标记和 ready 目录；不删除原有文件。
2. 回读 SD 根目录，证明所有原有文件字节、大小、权限和 hash 与备份一致；证明本次文件全部不存在。
3. 主机保存 session、stage、collect、cleanup、API 状态、日志和 v2 export；关机取卡，再以无实验文件的 SD 卡启动一次，确认 idle 和普通原厂录像。
4. 若启动异常，优先在断电后取卡移除本次新增文件，再启动原厂路径；不尝试写分区或执行未知恢复命令。若无法恢复，停止操作并等待用户决定是否进行更高风险的恢复流程。

成功证据必须包括：

- 文件暂存/回读/清理的 hash 回执，原有文件恢复证明；
- v2 导出头（固件哈希、`version=2`、`record_bytes=88`、容量、生产者静止证明、连续 `commit_v2`）；
- `verify_eis_boundary_trace_export.py` 报告 `real-stock-only-declared` 且 envelope 通过；
- `eis_boundary_trace_gate.py --strict` 报告两 site、tick、previous canary、参数覆盖、0 mismatch、无丢记录/竞争；
- wrapper 进入/返回、原厂录像状态、短视频完整解码和清理后的 idle 状态。

这些证据只支持“stock-only 边界记录成功”。它们不支持直接替换 A0384710，也不证明 EIS 画质改善；替换还需要单独的 native execution、回滚和视频验收批准。

## 当前结论

本方案目前停在用户确认之前。由于 v2 88B wrapper 尚未具备经过原生执行关卡的设备入口和缓存/回收闭环，**本轮不执行任何真机写入、重启或采集**。待离线关卡完成后，再向用户提交包含具体文件 hash、命令、停止条件和回滚路径的最终确认项。
