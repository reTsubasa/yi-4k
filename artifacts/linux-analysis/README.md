# Linux 静态分析证据索引

对象：社区 YI 4K/Z16 v1.10.52；实体机未连接，目标程序未执行。总报告见 [Linux 系统分析](../../docs/linux-system-analysis.md)。

## 主要文件

| 文件 | 内容 |
|---|---|
| [summary.json](summary.json) | 数量、内核版本、输入哈希和提取限制 |
| [filesystem-inventory.json](filesystem-inventory.json) | 全部提取路径的类型、模式、普通文件哈希、链接目标 |
| [elf-inventory.json](elf-inventory.json) | 245个ELF的架构、解释器、依赖、动态导入/导出、模块信息 |
| [kernel.config](kernel.config) | 从Linux映像的gzip IKCONFIG恢复的编译配置 |
| [device-tree.dts](device-tree.dts) | dtc转换的设备树；不是运行时设备树快照 |
| [squashfs-superblock.txt](squashfs-superblock.txt) | 原始RFS的格式、压缩与inode信息 |
| [squashfs-listing.txt](squashfs-listing.txt) | 原始SquashFS权限、属主、设备节点和路径 |
| [extract.log](extract.log) | 实际提取日志；只缺两个设备节点，宿主不创建它们 |
| [boot-findings.md](boot-findings.md) | init/挂载/网络/USB/SD扩展的脚本证据和行号 |
| [ipc-findings.md](ipc-findings.md) | IPC、网络API、媒体与SharePreview的重点指令与双侧证据 |
| [baseline-comparison.json](baseline-comparison.json) | 与仓库初始1.10.9导入的内容比较；不是认证原厂包比较 |
| [rtos-bridge-evidence/README.md](rtos-bridge-evidence/README.md) | 从既有RTOS成果选取的跨系统调用伪代码副本 |

`rootfs/` 是实际提取文件树，作为生成产物忽略Git。未在宿主运行其中的脚本或ELF。`elf-inventory.json` 的数值是文件ELF地址，不是Linux运行时重定位后的地址。

`ipc-evidence/` 保存重点二进制的字符串偏移、动态符号、PLT映射和Capstone视图。线性A32反汇编可能把Thumb或literal pool误译为指令；报告使用的是已核对片段，不能把整份视图当完整控制流。

## 离线重现

需要本地 unsquashfs（支持LZO）、dtc，以及Python pyelftools==0.32；IPC导出另需capstone==5.0.7。已有输入分区的哈希见 [partition-inventory.json](../firmware/partition-inventory.json)。这些命令只分析本地固件，不连接设备。

首次向新目录提取：

```sh
unsquashfs -d artifacts/linux-analysis/rootfs artifacts/firmware/v1.10.52/_part_rfs.a9s
unsquashfs -s artifacts/firmware/v1.10.52/_part_rfs.a9s
unsquashfs -ll artifacts/firmware/v1.10.52/_part_rfs.a9s
dtc -I dtb -O dts -o artifacts/linux-analysis/device-tree.dts artifacts/firmware/v1.10.52/_part_fdt.a9s
```

宿主不能创建设备节点时，unsquashfs可能返回2；必须检查日志确认错误确实仅为dev/console和dev/null，不能把所有返回2都当成功。不要用root权限运行固件脚本来“补环境”。

生成清单和恢复内核配置：

```sh
.venv-reverse/bin/python scripts/linux_inventory.py --baseline-tree artifacts/linux-analysis/provenance/initial-import-tree.json
.venv-reverse/bin/python artifacts/linux-analysis/ipc-evidence/disassemble.py
```

## 来源与边界

社区RFS来自 [v1.10.52 release](https://github.com/psolyca/Yi_4k_ROOTFS/releases/tag/v1.10.52)，下载与全包身份已在 [verification.json](../firmware/verification.json) 记录。

基线来源是GitHub API的初始导入commit `7a5e134d8078f5ca0fad40539cd3954ff290d7f1` recursive tree；[tree响应](provenance/initial-import-tree.json) 中 `truncated=false`。比较使用Git blob SHA-1，仅用作内容匹配，不是安全认证；未比较属主/设备节点/运行状态。

`provenance/` 还保存 [release说明](provenance/releases.json)、bootcmd/Python/service提交历史和三个初始导入文件副本，完整URL及哈希见 [sources.json](provenance/sources.json)。GitHub提交说明是社区作者的来源声明，未独立认证为官方镜像。

没有进行RFS修改/重打包/启动测试。早期 `artifacts/rtos-reverse/yi4k-rtos-analysis.tar.gz` 不包含本次Linux增量。
