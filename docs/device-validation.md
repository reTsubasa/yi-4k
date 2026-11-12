# YI 4K 首轮真机验证操作

范围：验证原厂系统的 Linux 连接和 RTOS 启动脚本/IPC，不刷固件、不写固定内存地址。下方步骤主要来自早期社区样本；已执行部分与本机差异见更新。

2026-11-09状态更新：Telnet root登录和Linux读取已在用户1.10.7真机完成，见 [采集结果](../artifacts/device/2026-11-09-linux/README.md)。随后完成 [本机EIS核对与RTOS只读快照](device-1107-eis-validation.md)：SharePreview的只读RPC查询返回服务未找到；没有初始化/启用预览。第二阶段autoexec/IPC标记和自定义RTOS代码未执行。下文保留早期步骤供复核。

后续更新：[原厂 RTOS 文件日志路线](device-native-rtos-logging.md)已在本机验证，可通过 SD 日志标记和临时只读 ambafs 挂载取得 EIS 模式日志；启用日志后短录像正常。标记已移除。此前出现死机后，直接私有 DRAM 探针暂停，不能把其只读属性当作运行稳定性的保证。任意 RTOS Shell/原生程序执行、逐帧 IMU 和算法消融仍待验证。

## 1. 准备

准备普通 YI 4K、可用 microSD、读卡器和有 Wi-Fi 的电脑。记录相机“设置→关于/设备信息”的固件版本。保留原视频和已有启动脚本；如卡根目录已有 `autoexec.ash`，先复制到电脑备份并从卡上移走，避免旧补丁干扰测试。不要为了对齐分析样本先升级/降级。

## 2. 先验证 Linux 连接

1. 相机关机，使用读卡器把 [console_enable.script](../sdk/device-probe/stage1/console_enable.script) 放到 SD 卡根目录。它是空文件，与参考项目中的文件一致；文件名必须完整，不能变成 `.script.txt`。
2. 弹出卡、插回相机，开机并打开相机 Wi-Fi。电脑连接相机热点。
3. 先查看电脑连接相机热点后获得的网关地址。社区通用说明/初始1.10.9导入模板使用 `192.168.42.1`，本工作区实际社区1.10.52模板为 `192.168.50.1`，均可能被配置覆盖。以下命令只是在网关确认为 `.42.1` 时的例子：

   ```sh
   telnet 192.168.42.1
   ```

   社区文档中的登录名为 `root`，密码为空。若提示密码，先尝试直接回车；若仍拒绝，记录原始提示，不据此假定当前固件使用相同认证。

4. 登录后执行以下**相机 Linux 命令**，保存输出：

   ```sh
   uname -a
   cat /proc/version
   cat /proc/mounts
   ls -ld /tmp/SD0 /tmp/fuse_d
   ls -l /usr/bin/ipcbind /usr/bin/ipcinfo /usr/bin/SendToRTOS /usr/bin/RecvFromRTOS
   ```

   路径不存在的报错也保留；这些程序已在分析样本中找到，实体机仍需核实。`uname` 只显示 Linux 信息，不能替代 RTOS 哈希。Telnet 登录得到的是 Linux Shell。

电脑若提示 `telnet: command not found`，这是电脑缺少客户端，可使用已有 Telnet 客户端（如 PuTTY 选择 Telnet）。`nc` 可检查端口，但不是完整交互客户端（同样替换为实际网关）：

```sh
nc -vz -w 3 192.168.42.1 23
```

连接超时先检查电脑是否仍连接相机热点、相机 Wi-Fi 是否开启及热点网关地址；连接拒绝则检查文件名/位置、是否完整重启以及固件支持情况。不要以反复改内存作为排查手段。

通过条件：能登录并读出系统信息。这一阶段无需拆机或 USB 串口。

## 3. 再验证 RTOS 启动脚本和 IPC

1. 确认第一阶段可用，然后关机取卡。保留 `console_enable.script`。
2. 把 [stage2/autoexec.ash](../sdk/device-probe/stage2/autoexec.ash) 放到卡根目录，不覆盖未备份的脚本。文件为 LF 换行，末尾有空行，内容只有：

   ```text
   t ipc rpc clnt exec1 'touch /tmp/yi4k_rtos_probe.ok'
   ```

3. 插卡开机，等界面启动完成，再开 Wi-Fi、Telnet 登录。
4. 在相机 **Linux Shell** 执行：

   ```sh
   ls -l /tmp/yi4k_rtos_probe.ok
   ```

标记存在，说明这次 RTOS 启动脚本中的命令经 IPC 在 Linux 执行成功；不代表新的 ARM 程序已经被加载。不要将 `t ipc ...` 直接粘到 Telnet 的 Linux Shell：它属于 RTOS Shell 命令。

标记不存在时，可能是脚本未执行、IPC 尚未就绪、当前固件命令不同或服务不可用。保存固件版本、第一阶段输出和现象，再按对应固件检查启动时序；本探针不自动加循环或反复执行。

通过后，用相机按键录制并回放一段普通视频，检查探针存在时录像、停止和关机是否正常。首轮无需运行任何内存读写或算法补丁。

## 4. 第一轮回传与恢复

提供以下结果即可进入下一轮：固件版本号、Telnet 是否登录成功、上述 Linux 命令输出、标记文件是否存在、普通录像是否正常。无需提供 Wi-Fi 密码。

测试结束，关机取卡，删除本次新增的 `autoexec.ash` 和 `console_enable.script`，恢复原有文件，再重启。若启动异常，关机后先移除本次新增脚本再测试；这只是本轮探针的回退办法，不是通用刷机救砖方法。

## 5. 此后如何验证原生程序和 EIS

Linux系统专项分析发现：**社区1.10.50及以后的样本增加了SD根目录 `bootcmd.sh` Linux启动钩子**，它不是已确认的原厂1.10.9入口。确认实体机具备它后，可以直接从SD运行Linux采集器，前述RTOS→IPC标记只是另一个通道验证。还发现已有SharePreview共享亮度帧服务，需要先恢复其条件和ABI；不要直接运行会启停服务和写卡的示例。完整依据见 [Linux系统分析](linux-system-analysis.md)。

下一轮由研究侧根据实际固件制作探针，仍需恢复并核实以下条件，当前没有现成可运行文件：

| 关卡 | 真机动作 | 通过条件 |
|---|---|---|
| 原生执行 | 使用已核实的内存分配、装载、缓存与调用通道，运行只打印版本标记并返回的 ARM 探针 | 真实执行标记、返回正常、原厂录像正常；只有装载成功不算通过 |
| 只读采集 | 在已核实入口记录 gyro、帧时戳、曝光、warp 与漏期计数 | 数据可关联到同一帧，记录开/关对比无新增超时 |
| 消融 | 保留整体稳像，只改变已确认的按行增量或一个时序参数 | 同条件重复样片能支持或否定果冻假设，恢复原路径有效 |
| 新算法 | 逐层替换姿态、轨迹和网格生成，继续交原 DSP 处理 | 相机直出、画面改善、满足提交时限，录像与音画同步正常 |

串口是后续无法获取 RTOS 控制台、需要早期启动日志时的备选。接线前必须确认该板子的测试点、电平与波特率，现有证据不支持给出通用接线图。USB 线连接电脑也不自动等于 RTOS 调试口。

完整算法实验路线见 [EIS 执行计划](eis-execution-plan.md)。

来源：[社区 Telnet 说明](../references/Xiaomi_Yi_4k_Camera/telnet/README.md)、[社区 autoexec/IPC 说明](../references/Xiaomi_Yi_4k_Camera/autoexec.ash/Readme.md)。
