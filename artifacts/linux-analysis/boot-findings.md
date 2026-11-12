# Linux 启动、挂载、外围服务与 SD 扩展调查

分析日期：2026-11-05。对象是从社区 `firmware_1.10.52.bin` 中拆出的实际 SquashFS：`artifacts/linux-analysis/rootfs`，不是用户相机的运行快照，也不等于未修改的原厂固件。本文只静态阅读脚本和配置，没有运行 ARM 程序或相机脚本。

下文路径均相对于上述 rootfs；行号为原文件行号。挂载和启动动作描述的是**脚本请求的行为**，不代表真机已经成功执行。绝对符号链接按目标文件系统解释，未跟随至宿主系统。

## 1. 启动主干

`/sbin/init -> ../bin/busybox`，`/bin/sh -> busybox`。`/etc/inittab:17-23` 依次请求挂 `/proc`、创建 `/dev/pts` 和 `/dev/shm`、`mount -a`、设置主机名，然后运行 `/etc/init.d/rcS`。`inittab:26` 配置控制台 `respawn:-/bin/sh`；USB serial console 两项仍为注释（29、32）。这不是 systemd 系统。

`rcS:7-30` 按 `S??*` 文件名顺序逐项运行：`.sh` 扩展名在子 shell 中 source，其余执行 `$i start`；非可执行文件会触发 `halt`，不存在的链接会跳过。`S51hibernation` 虽是绝对链接，在相机里指向真实存在的 `/usr/local/share/script/ambernation.sh`，不能因在宿主直接 `cat` 链接失败就误判它缺失。

| 顺序 | 实际脚本 | 动作与条件 |
|---|---|---|
| 10 | `S10mdev:8-9` | 把 `/sbin/mdev` 注册为 kernel hotplug handler，并扫描设备 |
| 20 | `S20urandom` | 保存/恢复随机种子，具体写入受根目录可写性等影响 |
| 30 | `S30dbus:14,23-30` | 有可执行 `dbus-daemon` 时启动 system bus |
| 30 | `S30rpcbind:6-10` | `start-stop-daemon` 启动 RPC binder |
| 40 | `S40network:8-10` | `ifup -a`；`/etc/network/interfaces:3-4` 只自动启 loopback，不在这里直接启动 Wi-Fi |
| 50 | `S50service` | RTC、目录、ambafs、IPC/RPC/NetFIFO/EventNotify、Wi-Fi/BT预加载，详见下节 |
| 51 | `S51hibernation -> /usr/local/share/script/ambernation.sh` | `ambernation.sh:3-9` 等1秒，sync/drop caches，向 `/sys/power/state` 写 `disk`；返回后再次同步 RTC（11） |
| 51 | `S51pref` | 挂载配置目录，复制 Wi-Fi/蓝牙配置 |
| 60 | `S60postservice` | 启动发现、HTTP、cron；RTSP和remoteapi的多个服务启动片段被注释 |
| 99 | `S99bootdone:6,9-10` | 后台运行 Wi-Fi 芯片探测脚本；若 `SendToRTOS` 可执行则发 `boot_done` |
| 99 | `S99postboot:3-7` | SD 根有 `bootcmd.sh` 时复制到 `/tmp`、dos2unix/chmod、`sh /tmp/bootcmd.sh` |

休眠是重要启动边界：这个 rootfs 明确含休眠脚本，但冷启动、保存镜像、恢复启动到底经过哪些阶段，以及启动器是否修改这一行为，仍需 boot log 验证。不能把各脚本简单当成每次按电源都会完整重跑。

关机的 `inittab:38-40` 配置执行 `rcK`、卸载文件系统和关闭 swap，但这个样本 `rcK:7-26` 的逆序停止循环全部被注释。不能将通用 SysV 关机习惯套到这里。

## 2. 文件系统与持久化边界

`/etc/fstab:5-11` 里 `/dev/root / ext2 rw,noauto` 是模板式静态条目；**不能由此声称实际根文件系统为可写 ext2**。输入 `_part_rfs.a9s` 实际是 SquashFS/LZO，且 `noauto` 表明 `mount -a` 不负责挂这个 root 项。真实 bootargs/root mount 必须另行核实。

fstab 还请求 tmpfs `/tmp`、tmpfs `/dev/shm`，以及 proc/devpts/sysfs。`S50service:5-8` 准备 `/tmp/lib`、`run`、`disk`、`log`、`ppp`、`fuse`、`FL0`、`SD0`、`fuse_d`、`DCIM` 等运行目录。

`S50service:15-27` 动态按 `uname -r` 加载 ambafs 模块；3.8.0 plat-ambarella 分支是兼容检测，样本实际模块树为 `3.10.71/kernel/arch/arm/mach-ambarella/ambalink/ambafs/ambafs.ko`。然后请求：

| Linux 挂载点 | 来源 | 含义 |
|---|---|---|
| `/tmp/FL0` | `ambafs a:` | RTOS 暴露的 A 盘视图 |
| `/tmp/SD0` | `ambafs c:` | RTOS 暴露的 C 盘/SD 视图 |
| `/tmp/DCIM` | `ambafs c:/dcim` | 媒体目录视图 |
| `/tmp/fuse_d` | bind `/tmp/SD0` | 兼容旧路径；名称含 fuse 不代表此处实际挂 FUSE |
| `/var/www/DCIM` | bind `/tmp/DCIM` | HTTP 可见媒体目录 |
| `/pref` | bind `/tmp/FL0/pref` | `S51pref:4-7` 测试 A盘可写后启用的配置目录 |

A盘测试失败时，`S51pref:21-24` 退回 `/tmp/pref`。因此存在“配置能写但重启不保留”的可能，不能仅看到 `/pref` 目录就断言持久化有效。`S51pref:8-26` 复制缺省 Wi-Fi 配置、已保存蓝牙XML和遥控设备XML到 `/tmp`。

`S50service:78-83` 的“等待SD挂载”循环把 `mount | grep SD0` 的文本输出直接用于 `-ne` 整数比较，静态可见实现可疑，不能保证它真的等待了10秒。

## 3. 常驻/条件服务的区分

实际文件存在性通过不跟随绝对符号链接的元数据检查确认：`ipcbind`、`util_svc`、`rpcbind`、`AmbaNetFifoDaemon`、`AmbaEventNotifyDaemon`、`remoteapi_disc_daemon`、`cherokee-worker` 均存在且有执行位。`crond` 是指向 BusyBox 的相对链接。

| 服务 | 静态启动证据 | 不能据此推定的事 |
|---|---|---|
| ipcbind/util_svc | `S50service:34-38`，均传 `-b` | 每个RPC方法的参数、权限、可否执行任意RTOS函数 |
| rpcbind | `S30rpcbind:9` 和 `S50service:42-43` 都尝试启动 | 不能把两次启动视为必然两个进程；第二次可能失败 |
| NetFIFO/EventNotify | `S50service:46-54` | 进程存在不等于任意原始图像/gyro已经开放 |
| remoteapi_disc_daemon | `S60postservice:24-27` | cmd/data/syssvc daemon（9-22）启动片段被注释 |
| Cherokee HTTP | `S60postservice:29-32` | 配置有效不等于所有动态控制接口已恢复 |
| cron | `S60postservice:34-39` | 初始crontab未必有工作；STA信号检查会另改root表 |
| RTSP | `S60postservice:4-7` 为注释 | 二进制可存在，不能说默认自启 |
| Telnet | `S50service:75-76` 为注释；`start_telnet.sh:5-6` 可重启telnetd | 该 shell 脚本自身没有检查 `console_enable.script`，标记的调用者需要另查二进制/RTOS |
| XCServer | `xcserver.sh:3-12` 有SD/系统/本地三层回退；配套RTOS `a01b6f08.c` 经utility RPC调用该包装器 | 动态启动条件/实体机运行状态待验证 |

`/etc/cherokee.conf:3` 配置 HTTP 80，document root `/var/www`（16）；`/cgi-bin` 映射 `/usr/lib/cgi-bin` 并用 CGI（33-36）。DCIM 已在上节挂入。CGI实际业务和调用应结合对应文件另查。

## 4. Wi-Fi 由脚本动态启停

常规 `/etc/network/interfaces` 仅 loopback。Wi-Fi 控制入口是 `/usr/local/share/script/wifi_start.sh` 等；它们可能由RTOS请求/其他服务触发，不能仅从文件存在声称开机自动开热点。

`wifi_start.sh:8-52` 的配置顺序是已有 `/tmp/wifi.conf`（否则复制系统模板）→ `/tmp/FL0/wifi.conf` → SD 根 `/tmp/SD0/wifi.conf`，后者覆盖前者非空项目，再转 LF 并导出。该社区模板 `wifi.conf:44,48,50` 默认 AP IP 是 **192.168.50.1**，池 .50.2–.50.6；不能把其他文档中的192.168.42.1当成该样本的固定地址。实际值可被运行配置覆盖，应读运行配置/电脑网关。

主路径 `wifi_start.sh:129-156`：启用 GPIO/SDIO→`load.sh`→等待 wlan0→选择 STA/AP。`load.sh:24-26,33-49` 加载 `bcmdhd`、43340固件/NVRAM、不同 op_mode；`preload.sh:3-9` 预载 cfg80211并准备MAC。Wi-Fi芯片探测另含43455分支，不代表该实体机一定装有这两种芯片之一的特定版本。

- AP：`ap_start.sh:59-99` 设置IP/netmask、dnsmasq DHCP，动态生成 wpa_supplicant AP配置并以 `-B` 启动，然后 `SendToRTOS net_ready`。存在hostapd模板不等于主AP路径使用hostapd。
- STA：`sta_start.sh:256-269` 启动 wpa_supplicant，以固定IP或udhcpc取地址并反馈RTOS。扫描失败有专门RTMP错误/FAKE网络状态分支（181-189），不能把 `net_ready` 消息无条件当成真实联通。
- 停止：`wifi_stop.sh:22-51` 关闭wlan、杀相关进程、卸载模块/SDIO并发 `net_off`；另外停止事件管理与检查任务。
- 可选检查：`wifi_start.sh:149-152` 仅STA且 `WIFI_CHECK=yes` 启动 `wifi_check.sh`；后者 `30-36` 会重建root cron，每分钟检查，低信号/无IP时重启Wi-Fi（13-26）。模板 `wifi.conf:81` 为 no。
- 热插拔：`/etc/mdev.conf:2` 调用 `wifi_mdev_action.sh`；后者 `19-22` 只对USB来源新增 wlan0 启动Wi-Fi，且有避免重入条件（10-17）。

## 5. 蓝牙与 USB 的实际边界

`S50service:68-69` 只是调用 `bt_preload.sh`，后者 `3-14` 复制蓝牙配置、准备MAC和hidraw脚本，并不在这里启动完整蓝牙服务。

样本同时有 BSA 与 BlueZ 两套脚本/工具：`bsa_start.sh:13-32` 切GPIO，按模块加载 `bsa_server_43455` 或 `bsa_server_43340`、用 `/dev/ttyS1` 加载蓝牙固件，再起 `ble_remote`；`bt_start.sh:16-48,67-81,268-291` 同步SD/持久配置并启动BlueZ。哪套在用户相机实际使用，应看调用和运行进程，不能把两套都说成常驻。

USB模板准备了多种能力，均需要显式调用/模式条件：

- `insert_usb_modules.sh:14-37` 依模块存在情况加载USB core/host/gadget/configfs/libcomposite。
- `usb_console.sh:7-18` 切 USB PHY 为 device，加载 `g_serial use_acm=1`，起 `/dev/ttyGS0` getty，将syslog转向该口。它会杀syslogd和改变USB角色，不是被动读取日志。
- `usb_ether.sh:40-56` 切 device、加载g_ether、配usb0、DHCP或固定IP；`wifi_start.sh:119-126` 受 `ETHER_MODE`/`ETHER_KEEP_WIFI` 条件控制。模板默认 `ETHER_MODE=no`。
- 名为 `usb_mass_storage.sh` 的脚本 `14-26` 实际切host并加载USB-storage/SCSI，是访问外部U盘的host路径，不能仅按文件名说成“把SD卡模拟给电脑”。其第16行还调用单数 `insert_usb_module.sh`，与实际复数脚本名不一致。
- 样本 `lib/modules/3.10.71/.../gadget/` 实际包含g_serial/g_ether/g_mass_storage/g_acm_ms等模块，但文件存在仍不等于接口已接通或默认开启。

## 6. SD 二开入口与日志

| SD路径 | 消费者/证据 | 条件与用途 |
|---|---|---|
| `/bootcmd.sh` | `S99postboot:3-7` | Linux晚期启动脚本，无需新建RTOS loader；初始1.10.9导入无该项，社区v1.10.50新增 |
| `/wifi.conf` | `wifi_start.sh:34-48` | 覆盖网络配置 |
| `/events/` | `wifi_start.sh:96-102,158` | 网络启动后起cmdyi Python进程；不是独立于网络的无条件开机事件系统 |
| `/events/events_boot.py`与事件名.py | `cmdyi.py:8,95-106,129-156` | 动态import回调；录像/照片/电池/插拔/设置变化等事件，真实事件由Yi4kAPI/socket提供 |
| `/events/debug`或`info` | `cmdyi.py:160-166` | 写 `/tmp/fuse_d/cmdyi.log`；无这两个文件不保证有文件日志 |
| `/XCServer` | `xcserver.sh:3-12` | 调用包装器时优先执行SD版本；调用者未在本轮恢复 |
| `/AP.DEBUG/Wifi.sh` | `wifi_xy_restart.sh:6-14` | AP重启时覆盖脚本，大小写准确 |
| `/STA.DEBUG/WiFi.sh` | `wifi_xc_restart.sh:6-14` | STA重启时覆盖脚本，大小写准确 |
| `/MISC/tcp_tuner.sh` | `tcp_script.sh:3-4` | 调用TCP调优包装器时执行 |
| `/MISC/bt.conf`、`MISC/bluetooth/` | `bt_start.sh:16-48,274-282` | 蓝牙配置导入/持久化 |
| `/factory/btr_mac` | `bsa_start.sh:28-32` | BLE遥控多设备地址配置 |
| `/save_log_enable.script` | `load.sh:10,29-37,43-46` | 本脚本仅增加Wi-Fi加载日志；全局标记处理不能由此完整解释 |

`cmdyi.py:168` 连接127.0.0.1；`start_vf.py:10-22` 显式连接127.0.0.1:7878并登录token，之后发送设置/预览控制消息。因此事件管理属于控制面扩展，不是EIS高频帧回调。

日志有多个层次：`save_wifi_log.sh:8,15-20` 包装命令写SD wifi.log，`save_bt_log.sh` 同型；`rtmp.sh:6` 写SD rtmp.log；cmdyi按标记写日志；syslog可能被USB或其他模式重定向。存在日志脚本不保证所有时刻都在持续记录。上述两个save包装器 `10` 的 `[ $# -eq 0]` 也有空格问题，不能当经过验证的通用采集器。

## 7. 对后续验证的影响与未知项

1. 在**确认相机使用本社区样本或同等钩子**后，Linux观测可以直接从SD `bootcmd.sh` 起步，不必先走RTOS `autoexec.ash -> IPC`。两者必须分别验证。
2. 首轮连接地址应以实际网关为准，避免把192.168.42.1写死。该样本默认AP是192.168.50.1。
3. 不应先去掉休眠脚本、跑USB角色切换或替换网络脚本来“方便调试”；先核对冷启动/恢复路径与当前服务，因为这些会改变待观察系统。
4. 本报告已恢复脚本配置层的主干；未观察进程、挂载成功、监听端口、真实资源占用、hibernation恢复行为、RTOS触发脚本的全部调用者，未将测试工具视为已公开稳定ABI。

跨系统补充：主报告已在配套RTOS `a019ce8c.c` 找到 `console_enable.script`/日志标记处理与就绪条件下启动Telnet；`a01b6f08.c` 找到XCServer包装器调用；`a0476bb4/a04771d0/a0476380/a0244b54` 找到remoteapi/RTSP动态启动。因此不能把init片段注释等同于服务不存在。具体双侧证据见 [IPC报告](ipc-findings.md)。

来源补充：逐内容对比仓库标注的原厂1.10.9初始导入，确认bootcmd/events为社区增量，多数基础工具/脚本与导入相同；这不是独立认证的官方包比较，见 [baseline-comparison.json](baseline-comparison.json)。剩余重点是冷启动/休眠恢复的启动器条件、运行进程/挂载/端口、Wi-Fi/BSA全部触发链及接口ABI的实体机核实。
