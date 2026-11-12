# YI 4K 1.10.7：Linux 运行时桥接核对

采集时间：2026-11-09。对象是用户相机 `YDXJ2_V13LW`，Linux uptime 约 5 小时。采集仅读取 `/proc`、`/sys` 和 sysfs，不启动、停止或修改任何服务。

## 已观测的运行态

实际进程包括：

- `ipcbind -b`、`util_svc -b`、`AmbaNetFifoDaemon`、`AmbaEventNotifyDaemon`；
- `remoteapi_disc_daemon`、`remoteapi_cmd_daemon`、`remoteapi_data_daemon`、`remoteapi_syssvc_daemon`；
- `XCServer` 和 `AmbaRTSPServer`。

这些进程的命令行来自各自 `/proc/<pid>/cmdline`，不是从文件名推断。监听表同时出现 7878、8787、9888、9898、554、80、23 等端口；完整原始表见 [proc_net.txt](../artifacts/device/2026-11-09-linux/linux-runtime-followup-01/proc_net.txt)。端口的业务归属与现有静态结果一致：7878/8787 是 remoteapi 命令/数据面，9888 是 EventNotify，9898 是 NetFIFO，554 是 RTSP，80 是 Cherokee，23 是 Telnet。该归属结合进程、静态字符串和之前的 API 记录；单凭端口号不能证明协议兼容性。

所有被检查的服务都把标准输入/输出/错误接到 `/dev/console`，IPC 服务另持有 socket 文件描述符。`remoteapi_cmd_daemon`、`remoteapi_data_daemon`、`remoteapi_syssvc_daemon` 和 `AmbaRTSPServer` 均映射 `/dev/amba_heapmem` 的同一大段共享设备区域，单个映射约 432 MiB；这说明 Linux 媒体/控制进程确实使用 Ambarella 专用共享内存。它不等于 Linux 可以安全写入任意 RTOS 缓冲区，也没有给出缓冲区所有权、帧时戳或缓存维护协议。

实际挂载状态为：根文件系统是只读 SquashFS；`/tmp` 是 tmpfs；`/tmp/FL0`、`/tmp/SD0`、`/tmp/DCIM`、`/var/www/DCIM` 和 `/pref` 通过 ambafs 映射到 RTOS 文件服务，其中 `/pref` 当前来自 `a:/pref`。因此 Linux 侧可以做控制、日志、文件传输和低频处理，但写 SD/配置仍会经过 RTOS 文件服务，不能当成本地块设备独占。

在普通取景、未录像的 5 秒资源采样中，Linux 报告 `MemTotal=49096 kB`、`MemFree=1584 kB`、`Cached=21896 kB`、无 swap；被检查的服务大多没有增加调度 tick，`XCServer` 在 5 秒内增加 2 个原始 tick。该结果只描述空闲/预览窗口，不能外推录像或高负载状态，但说明 Linux 用户空间的可用匿名内存很紧。大规模光流、神经网络或多帧高分辨率缓存不适合直接塞进 Linux；若做视觉辅助，应采用小分辨率、固定容量、丢帧可检测的记录器。

## RPMsg 端点

`/sys/bus/rpmsg/devices` 当前枚举 6 个端点，全部位于 `c0_and_c1.7/remoteproc0/virtio0`：

| 端点 | name | 当前含义边界 |
|---|---|---|
| `rpmsg0` | `AmbaRpdev_CLK` | 时钟/链路基础设施候选 |
| `rpmsg1` | `aipc_rpc` | AmbaLink RPC 传输 |
| `rpmsg2` | `aipc_vfs` | 虚拟文件服务 |
| `rpmsg3` | `aipc_rfs` | RTOS 文件服务 |
| `rpmsg4` | `AmbaRpdev_LinkCtrl` | 链路控制 |
| `rpmsg5` | `echo_cortex` | 测试/回显端点候选 |

这些名称和 `modalias` 是 sysfs 实测值。当前 remoteproc 的 firmware 属性仍是 `dummy` 且大小为 0；它表示 Linux 正在连接已经运行的跨核侧，不能据此加载或替换 RTOS 镜像。`echo_cortex` 的存在也不能推断它是可用的任意代码执行入口。

## 对下一步二开的影响

1. Linux 层已经有可用的观测和传输骨架：remoteapi、EventNotify、NetFIFO、RTSP、ambafs 和专用 heapmem 都在工作。优先恢复 SharePreview/现有共享帧接口，比改启动分区风险小。
2. `remoteapi_*` 与 RTSP 共享大块 heapmem，但当前证据没有把它关联到 EIS 的输入或 warp 网格；不能从映射地址直接写入或替换算法。
3. Linux API 是控制面。要做机内实时 EIS，仍需取得 RTOS 侧高频 gyro、帧/曝光时间戳和 DSP warp 提交的可靠契约；Linux 进程只适合低频记录、视觉辅助和结果传输。
4. 目前没有必要修改 Linux 根文件系统。若后续加入自建记录器，应先使用 SD 上一次性文件和独立进程，在启动、录像和停止后检查进程/端口/视频完整性，再考虑持久化 RFS 改动。

## 证据和限制

原始采集目录：[linux-runtime-followup-01](../artifacts/device/2026-11-09-linux/linux-runtime-followup-01/)。结构化摘要：[analysis.json](../artifacts/device/2026-11-09-linux/linux-runtime-followup-01/analysis.json)。资源摘要：[linux-resource-followup-01/analysis.json](../artifacts/device/2026-11-09-linux/linux-resource-followup-01/analysis.json)。采集脚本为临时只读探针，未向相机写入文件。

这是一个运行时快照。PID、共享映射和 socket inode 会在重启或服务重启后变化；`/proc/net` 的 socket 不能单独恢复 RPC program ID。共享内存映射证明“有使用”，不能证明“可安全接管”。
