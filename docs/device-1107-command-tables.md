# YI 4K 1.10.7：本机 RTOS 命令表对齐

本报告针对真机固件 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。输入是从本机 `/dev/mtdblock1` 只读取得的 RTOS 窗口，SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

离线解析确认，1.10.7 的原生命令处理入口与前一份 1.10.52 分析镜像保持一致：

| 入口 | 1.10.7 地址 | 含义 |
|---|---:|---|
| `loadbin` | `A02A2584` | 将文件内容读入给定地址并返回 |
| `savebin` | `A02A3DB0` | 将内存范围写入文件 |
| `t` 分发 | `A029E1A4` | 查找并调用 `t` 子命令 |
| 动态注册 | `A029E098` | 向 `t` 注册链追加命令节点 |

同样的表位置在本机镜像中可解析出：`t ants` 69 项、`t img` 17 项、`t ipc` 6 项、`t drv` 21 项，以及 38 项普通 Shell 命令表。`loadbin`、`savebin`、`t` 的 handler 地址没有发生变化；命令名指针因字符串布局变化而移动，不能只比较名字指针。

进一步按旧函数边界对 1.10.7 做 A32 差分：`loadbin` 有 6 个、`savebin` 有 4 个、`t` 分发有 1 个 32 位字变化，全部是 `movw r0, #...` 的字符串低 16 位偏移；分支、调用目标和寄存器流程没有变化。也就是说，旧伪代码对这三个入口的控制流仍可作为本机的静态参考，但字符串地址必须使用 1.10.7 的值。差分原文见 [loader-diff](../artifacts/device/2026-11-09-linux/rtos-analysis/loader-diff/summary.json)。

这一结果把下一步风险缩小了：可以在 1.10.7 上继续恢复“加载后如何调用”的路径，暂时无需重新寻找 EIS 主函数和 gyro 入口。它仍不等于已经获得执行权限：`loadbin` 没有跳转、缓存维护或任务创建逻辑，动态注册函数的 ABI、执行上下文和返回约束仍要通过静态调用链与最小真机实验确认。

启动顺序也已在本机伪代码中确认：`A01BD5A4` 初始化流程先调用 `A01A6030`、`A01ACE50` 等注册函数，再进入固件事件主循环；这些函数批量注册 `app`、`ants`、`wifi` 等命令。当前没有发现一个由 Linux API 直接调用 `A029E098` 的入口，所以“启动时注册链存在”不能扩大解释为运行中可远程注册任意 payload。

复核工具：

```sh
.venv-reverse/bin/python scripts/device_rtos_tables.py
.venv-reverse/bin/python scripts/device_loader_diff.py
```

机器可读结果在 [command-tables-1107.json](../artifacts/device/2026-11-09-linux/rtos-analysis/command-tables-1107.json)。脚本只读取本地镜像，不连接相机、不写内存、不调用 RTOS 命令。
