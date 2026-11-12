# RTOS 静态逆向工程

先读 [二次开发手册](../../docs/rtos-reverse-engineering.md)。对象、工具、阶段和校验信息见 [analysis-manifest.json](analysis-manifest.json)。

| 路径 | 用途 |
|---|---|
| `full/functions.json` | 全映像11,035个函数候选的地址、名字、范围、签名、反编译状态 |
| `full/decompiled/` | 11,031份逐函数伪代码，文件名是入口地址 |
| `full/listing.asm` | 整份映像中已识别的指令 |
| `full/references.tsv` | 已恢复的静态交叉引用 |
| `full/calls.tsv` | 调用与分支记录，含函数内部跳转 |
| `full/decompile-failures.json` | 4个保留失败及原因 |
| `full/coverage.json` | 自动分析覆盖统计与限制 |
| `ghidra-project/yi4k.gpr` | 可继续分析的Ghidra工程；需与同目录`.rep`一起保留 |
| [core/findings.md](core/findings.md) | 基础服务、候选ABI和指令证据 |
| [tables/findings.md](tables/findings.md) | 命令表、动态注册、应用/GUI入口与调试陷阱 |
| [image-ipc/findings.md](image-ipc/findings.md) | warp/MCTF/DSP控制与跨核RPC |
| [EIS 专项说明](../../docs/eis-reverse-engineering.md) | 专门任务、gyro 采样、旋转/按行网格算法与替换边界 |
| [eis/evidence.json](eis/evidence.json) | EIS 选定汇编窗口、gyro 操作表原始指针及已有静态调用记录 |
| `all-strings.json` | 原始ASCII字符串地址索引，可能含误识别 |
| `source-path-leads.json` | 固件保留的少量源路径线索，不是源代码 |

示例查询：

```sh
python3 scripts/rtos_query.py function 0xA029E098
python3 scripts/rtos_query.py strings WarpCompensation
python3 scripts/rtos_query.py callers 0xA032E0D4
```

以上命令从工作区根目录运行。所有地址绑定报告中的RTOS SHA-256；没有执行目标代码或进行刷机验证。完整自动静态扫描不等于完整语义恢复。
