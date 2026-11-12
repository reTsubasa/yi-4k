# YI 4K 真机 Linux 首轮采集

主机记录日期：2026-11-09。相机自身时间未校准，日志中的Jan 1/00:xx等时间不能当真实日历时间。本轮通过相机热点 `192.168.42.1` 的既有Telnet登录root，无密码；电脑Wi-Fi为 `192.168.42.2`。不是USB调试会话。

执行范围：读取Linux身份、proc/sysfs、进程/端口/挂载/日志，查询相机API设置，以及只读获取SYS_SW逻辑分区和Linux SquashFS内容窗口。未刷机、未写闪存/内存、未修改设置、未运行SharePreview/RTOS补丁、未主动启动录像或网络服务。API只创建会话、读取msg_id 3并关闭会话。

## 实测结论

| 项目 | 真机观察 |
|---|---|
| 产品/硬件 | `YI 4K Action Camera` / `YDXJ2_V13LW` |
| 软件构建 | **`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`** |
| Linux | `3.10.71 #1 PREEMPT Fri Feb 2 12:17:50 CST 2018 armv7l` |
| 用户空间 | Buildroot `2015.05-ga8f840c`，root登录成功 |
| CPU/时钟 | Linux可见1个Cortex-A9；`gclk_cortex=792000000 Hz`，仅代表采集时读值 |
| RAM | `/proc/iomem` 的Linux System RAM为 `0x3CA00000–0x3FFFFFFF`（54MiB）；`MemTotal=49096kB`（约47.95MiB），不等于整机RAM |
| 采集时内存 | `MemFree=9304kB`、Cached=13744kB、Buffers=7848kB，无swap；不能把Free当全部可回收空间，也不是运行新算法的性能保证 |
| 当前设置 | 1080p30、S.Fine、EIS on；`system_mode=record`为录像模式，不能解释为正在录制 |
| 实际根挂载 | `/dev/root / squashfs ro`，bootargs明确root=`/dev/mtdblock5` |
| SD/配置 | `/tmp/SD0`与`/tmp/fuse_d`均为`c:`的ambafs挂载，`/pref`为`a:`；这台机不是社区样本中fuse_d的bind写法 |
| 网络服务 | 7878→remoteapi_cmd_daemon；8787→remoteapi_data_daemon；554→AmbaRTSPServer；80→Cherokee；23→telnetd |
| 后台通信 | ipcbind/util_svc/NetFIFO/EventNotify/remoteapi三服务/XCServer均在进程表；9888→EventNotify，9898→NetFIFO |
| 蓝牙 | 本次进程表为BSA 43340服务和ble_remote，不能据此推广所有硬件版本 |
| Linux扩展 | Python、strace、gdbserver、SendToRTOS/RecvFromRTOS/SharePreview示例实际存在 |
| 社区钩子 | **没有 `/etc/init.d/S99postboot`**，不能照搬社区bootcmd启动方案 |
| 通用图像/传感器节点 | 本次未发现 `/dev/video*`、`/dev/iio*`；`/dev/amba_heapmem`、`/dev/amba_dspmem`存在 |

## 与此前样本的关系

此前社区1.10.52的RTOS底层构建为1.10.9/2018-06-22；本机为1.10.7/2018-02-02。**不能复用旧RTOS固定地址或把旧伪代码当作本机精确实现。** 已导出本机SYS_SW逻辑内容，下一步以其身份重新定位EIS/共享接口。

已读取的内核配置选项与此前样本逐项相同，但内核二进制构建不同。六个选定Linux程序/库中，SharePreview、SendToRTOS、RecvFromRTOS、Python入口和XCServer哈希相同，`libambaipc.so`哈希不同。这支持复用部分静态程序证据，但仍须考虑依赖和跨系统协议差异。

`kernel_log.txt` 实际包含休眠映像创建及设备restore记录，证明本次日志经历相关路径；未据此证明每一次开机都走完全相同流程。日志中也有驱动/路由报错，已原样保留；没有把它们直接判定为EIS根因。

## 文件与复核

- [session.json](session.json)：首轮采集固定命令与主机计时。
- `identity/boot_arguments/cpu_memory/memory_map/mounts/processes/network/modules/device_nodes/ambarella/sd_root/startup/tools/kernel_config/kernel_log.txt`：命令回显及输出，带提示符/随机结束标记，不是纯配置文件。
- [kernel.config](kernel.config)：从proc输出提取的配置选项，去除了回显/提示符，不保留原注释布局。
- [api-settings.json](api-settings.json)：API返回的固件/硬件/图像相关设置；只保存选定值及完整设置名清单，未保存密码等设置值。
- [sample-comparison.json](sample-comparison.json)：配置选项差异、选定Linux二进制哈希比较。
- [partition_headers.txt](partition_headers.txt)：SYS_SW前256字节、RFS前96字节；读命令为dd的if=方向。
- [binary_hashes.txt](binary_hashes.txt)、[clock_power.txt](clock_power.txt)：补充检查原始回显；命令保存在对应输出开头。
- [partition-capture.json](partition-capture.json)：导出的分区/窗口长度、主机与设备端匹配的SHA-256。

SYS_SW是完整32MiB**逻辑MTD块分区**；RFS仅取superblock声明bytes_used向4096字节对齐的窗口，并非整个60MiB分区。没有取得NAND OOB/坏块物理布局，这些文件不是可直接刷写的升级包或完整救砖备份。不会把分区长度当成RTOS可执行映像真实长度。

采集脚本：[Linux信息](../../../scripts/device_linux_capture.py)、[逻辑分区读取](../../../scripts/device_partition_capture.py)。传输使用已有Telnet上的base64，无需在相机落临时文件或新建监听服务；传输与读取仍会占用CPU/网络，采集期间不是算法性能基准。

## 尚未验证

后续进展见 [本机EIS核对与只读RTOS快照](../../../docs/device-1107-eis-validation.md)：本机核心EIS函数已逐项比对并建立独立反编译；SharePreview查询返回服务未找到；通过只读DRAM映射取得了代码指纹匹配的状态快照。RFS已解包并建立文件/ELF清单。以上属于后续补充，未改写首轮session中的执行范围。

本轮续查的 Linux/RTOS 通道证据见 [1.10.7 真机通道核对](../../../docs/device-linux-rpmsg-validation.md)，原始输出在 `continuation-linux/`，包括 `remoteproc0` 的 6 个 rpmsg 端点、`ipcinfo` 服务表、监听端口、启动脚本和只读 API 状态。敏感设置字段已脱敏。

连续且缓存一致的gyro遥测、共享预览取帧、DSP warp提交、EIS改动效果、实时预算、自定义RTOS代码执行仍未验证。
