# YI 4K 1.10.7：Linux ↔ RTOS 通道真机核对

日期：2026-11-09。对象是实体机 `YDXJ2_V13LW`，固件
`Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。本轮只读，
通过已有 Telnet root 连接执行 Linux 诊断；没有写 `/dev`、启动服务、修改配置或
重启相机。原始输出保存在
`artifacts/device/2026-11-09-linux/continuation-linux/`。

本轮结束时 API 只读状态为 `idle`，电量 100%，录像模式 `1920x1080 30P`，
`iq_eis_enable=on`、`warp_enable=on`；结果另存为
`artifacts/device/2026-11-09-linux/continuation-api-status.json`（敏感设置字段已脱敏）。

## 运行时拓扑

Linux 启动参数为：

```
root=/dev/mtdblock5 rootfstype=squashfs console=ttyS2 nr_cpus=1 maxcpus=0 boss=0xdc950000
```

系统是 Linux 3.10.71、Buildroot 2015.05，单 Linux CPU；`c0_and_c1.7` 的远端处理器
设备由内核 `remoteproc0` 暴露，下面有 6 个 virtio/rpmsg 端点：

| Linux 端点 | rpmsg 名称 | 驱动 | src/dst |
|---|---|---|---:|
| rpmsg0 | `AmbaRpdev_CLK` | `rpmsg_clk` | `0x400/0x400` |
| rpmsg1 | `aipc_rpc` | `rpmsg_rpc` | `0x401/0x401` |
| rpmsg2 | `aipc_vfs` | `ambafs` | `0x402/0x402` |
| rpmsg3 | `aipc_rfs` | `rpmsg_rfs` | `0x403/0x403` |
| rpmsg4 | `AmbaRpdev_LinkCtrl` | `rpmsg_linkctrl` | `0x404/0x404` |
| rpmsg5 | `echo_cortex` | `rpmsg_echo` | `0x405/0x405` |

所有端点的 `announce=false`，当前均已绑定驱动。`aipc_rpc` 与 `aipc_vfs/rfs` 分别
对应 RTOS 侧 RPC 和 ambafs 文件服务方向；这与静态发现的 RTOS `0xA03C4E94` RPC
创建链及 `c:\`/`b:` 文件路径一致。

实体机 Linux 只看到 1 个 ARMv7 CPU，`MemTotal` 约 49 MiB；根文件系统只读
SquashFS，`a:`、`c:`、`c:/dcim` 和 `/pref` 均通过 ambafs 挂载。Linux 侧没有
`/dev/video*` 或 `/dev/iio*`，所以高频 IMU/编码前图像仍不能从标准 Linux 媒体接口
取得；新增 Linux 观测程序必须把 CPU、共享内存和 ambafs 写卡开销算进预算。

## 用户空间服务对齐

实体机 `ipcinfo` 返回：

| program | version | Linux port | name |
|---:|---:|---:|---|
| `0x20000005` | 1 | 266 | `netctrl_svc` |
| `0x20000006` | 1 | 275 | `cmdhndlr_svc` |
| `0x20000007` | 1 | 271 | `datareq_svc` |
| `0x20000009` | 1 | -4098 | `AmbaEventNotifier_LUSVC` |
| `0x20000004` | 1 | 108 | `AMBANETFIFO_LUSVC` |
| `0x20000001` | 1 | 104 | `linux_util_svc` |

静态 RTOS 代码里，调试 RPC 使用 host=0、program=`0x20000001`、version=1，
同步命令包装调用 procedure 1，异步包装调用 procedure 2。真机 `ipcinfo` 的
`linux_util_svc` 实例与这一 program ID 完全对齐，因此 RTOS `t ipc rpc clnt exec1`
使用的是实际运行中的 Linux utility 服务，而不是孤立的测试代码。已有探针也已用
该路径成功在 Linux `/tmp` 创建标记并由 RTOS `savebin` 导出 8 字节代码指纹。

同一时刻的监听端口还显示 `remoteapi_cmd_daemon:7878`、`remoteapi_data_daemon:8787`、
`AmbaRTSPServer:554`、`AmbaNetFifoDaemon:9898`、事件通知 `9888`、HTTP `80`、
Telnet `23`。这说明 `S60postservice` 中被注释的启动片段确实可能由 RTOS 按需启动；
判断运行时能力应以进程/端口和 RTOS 触发链为准，不能只读 init 脚本。

## 启动顺序与二开边界

实体机 `/etc/init.d/S50service` 先加载 `ambafs.ko`，挂载 `a:`、`c:` 和 `c:/dcim`，
然后启动 `ipcbind -b`、`util_svc -b`、`rpcbind`、`AmbaNetFifoDaemon` 和
`AmbaEventNotifyDaemon`。`S60postservice` 启动 remoteapi/HTTP 相关服务；
`S99bootdone` 通过 `SendToRTOS boot_done` 通知 RTOS。运行进程与这些脚本一致。

这条链支持的最小扩展方向是：在 Linux 侧添加有边界的观测/控制服务，或在 RTOS
侧复用现有 RPC、ambafs 和启动脚本。它没有证明 Linux 能直接调用任意 RTOS 地址，
也没有证明向 `rpmsg` 写入自定义消息会被 RTOS 接受。`echo_cortex` 端点存在只能
说明内核带有 echo 驱动，不能把它当作任意代码执行通道。

## 当前可执行的下一步

1. 离线对齐 `aipc_rpc` 的消息头、program/procedure 和超时字段；优先复用
   `linux_util_svc` 的只读 procedure，禁止把用户输入直接拼进 `exec1`。
2. 在 RTOS 侧继续恢复启动阶段的命令注册调用点，寻找能够在 RTOS 自身上下文
   创建一次性任务的入口；`loadbin` 只读文件到地址，不跳转执行。
3. 原生 payload 尚未验证前，继续使用原厂日志和 `savebin` 做指纹/时序观测，
   不恢复 `/dev/mem` 高频轮询。

