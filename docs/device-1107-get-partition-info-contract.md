# 1.10.7 GetPartitionInfo：原厂记录复制合同与失败边界

离线审计确认 `A0483C20 → A0484F80 → A0492E18` 确实可以将 SYS/USER PTB 的**单条 64 字节记录**复制到调用方缓冲；它本身不读取 NAND、不初始化存储、不重算 CRC，也不触发 updater。35 个复制正例、15 个拒绝场景和 6 个风险模型均由原始 ARM 指令在构造 RAM 中执行，没有替代函数或服务。

这项结果没有提供新的外部读取命令、真机表副本或首次执行入口。实际 PTB 页的运行时映射、指针、所有权、缓存一致性和读取失败恢复仍未验证；正常独立输出路径无 PTB store，不能扩大成任意参数调用都只读或安全。

## 文件与复现

- `scripts/audit_get_partition_info_contract.py`：只读取固定本地镜像/分析索引，在 Unicorn 中构造 RAM，写独立证据目录；没有设备节点、网络、串口、USB 或目标命令接口。
- `artifacts/device/2026-11-11-get-partition-info-contract-run03/audit.json`：最终 56 个场景、原始字节 hash、16 个准确指令断言、读取/写入范围、返回状态、异常 PC、调用者索引和覆盖限制。
- 同目录 `audit.asm`：完整五个已执行函数窗口的原始字节及 Capstone 反汇编。

```sh
.venv-reverse/bin/python scripts/audit_get_partition_info_contract.py --output-dir /tmp/yi4k-get-partition-independent
```

输出目录必须不存在。`run01` 是开发期断言失败的空目录，`run02` 为添加两组非零 selector 控制前的结果；最终以 `run03` 为准，旧目录未覆盖。

输入为已有本机 1.10.7 `artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，VA 基址 `A0100000`，SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。最终脚本 SHA-256 `6215eb0ae2a3de95318fdf2cadd2b2e8e9008528801187c5b8366d93b5cb7911`。Ghidra 已保留导出、Capstone 和 Unicorn 提供本轮证据；没有 REA Evidence ID。会话没有 REA MCP，仅读诊断显示本地 REA 注册缺失与 Node 版本不受支持，未修改配置或升级依赖。

## 实际 ABI 和后端选择

从原始 ARM 参数搬移恢复的内部接口为：

```text
A0483C20(backend, table_selector, record_index, destination)
    target = *(A062AD54 + backend * 0x58)
    如果 target 非零且 backend<=2：
        跳到 target(table_selector, record_index, destination)
    否则返回 -1
```

| backend | 分发表槽 | 镜像中的目标 | 实际动作 |
| --- | --- | --- | --- |
| 0 | `A062AD54` | `A0484F80` | 单指令跳板到 `A0492E18` |
| 1 | `A062ADAC` | `A0488900` | 单指令跳板到另一个记录复制函数 `A0493058` |
| 2 | `A062AE04` | 0 | 返回 -1 |

`table_selector==0` 选择 SYS；**任意非零值都选 USER**，不只枚举值 1。在 `A0492E18` 中，SYS 先要求无符号 `record_index<=2`，源地址为 `*[A078B600] + 0xC + index*0x40`；USER 要求 `record_index<=12`，源地址为 `*[A078B604] + 8 + index*0x40`。

后端 1 使用 `A078B610` 和 `A078B60C`，但本镜像四个指针词的初始值是：

| 词地址 | 镜像值 | 用途 |
| --- | --- | --- |
| `A078B600` | `A0001400` | 后端 0 SYS |
| `A078B604` | `A0001800` | 后端 0 USER |
| `A078B610` | `A0001400` | 后端 1 SYS |
| `A078B60C` | `A0001800` | 后端 1 USER |

因此后端 1 不是已经找到的第二份 PTB 数据副本；只是另一个后端实现初始指向同一候选 VA。各词的实时值、后端选择和中途更新均未采集。

## 每次到底复制什么

记录复制函数从计算出的源地址读取 16 个小端 word，按 4 个一组写入 destination，总计恰好 64 字节。没有调用 memcpy 或其他服务；复制逻辑在本函数体内。所有成功返回场景都核对 SP 和 R4–R11 保持。

构造 RAM 使用覆盖整页的确定性字节模式，验证所有 3 条 SYS 和 13 条 USER，分别经后端 0 和后端 1 执行，共 32 例；再直接执行一次后端 0 跳板，及 selector=2/FFFFFFFF 两个 USER 控制，共 35 例。每例逐项断言：

- 恰好 16 次低页 word load，地址严格为选中记录的 `[start,start+64)`；
- 恰好 16 次输出 word store；
- 输出字节与对应源精确一致，前 16/后 48 字节 guard 不变；
- PTB 页没有 CPU store，整页字节不变；其余 store 只在合成栈和输出缓冲；
- 执行 PC 完全在五个固定原函数窗口内，没有 NAND、CRC、存储初始化、文件、updater 或打印调用。

这复制的是**分区记录**，不包括 SYS 的前 12 字节、USER 的前 8 字节、尾部 CRC 或未分类区。不能用三条记录就宣称拿到完整 464 字节 SYS 表，也不能据输出本身检验整表 CRC。

## 返回 -1 不涵盖所有错误

15 个显式拒绝场景包括：每个后端、每种表的越上界索引、FFFFFFFF 索引和 NULL destination，共 12 例；再加 backend=2/3/FFFFFFFF 三例。它们均返回 -1、不读取目标低页、不修改输出。

另外六组风险模型揭示了内部 API 的假设：

| 构造条件 | 原始指令行为 | 含义 |
| --- | --- | --- |
| 选中记录某字段被改为 `DE AD BE EF` | 返回 0，原样复制 | 不验证 magic、名称、CRC、actual/allocation 或内容语义 |
| destination 就是记录源地址 | 返回 0，向 PTB 页执行 16 次 store | 不检查输出别名/所有权；正常输出的无写入结论有参数前提 |
| SYS 基址词为 0 | 算得记录地址 `0xC`，在 `A0492E60` 原 load 处发生合成未映射异常 | 不是检查基址非零；不会正常返回 -1 |
| SYS 基址词为 `A0003000` | 从 `A000300C` 原 load 处发生合成未映射异常 | 不检查源映射/范围或捕捉读异常 |
| backend=`01000000` | `A0483C3C` 分发表 load 先发生合成未映射异常 | 后端范围判断发生在指针 load **之后** |
| SYS 基址词为 `FFFFFFF4` | 加偏移得到零，返回 -1 | 只检查最终计算出的记录地址是否为零，不是一般指针合法性检查 |

后三类异常是 Unicorn 的明确映射模型，不是目标 CPU 异常或看门狗的真实观测；没有推断真机必定产生相同返回、重启或恢复结果。backend FFFFFFFF 由于 32 位计算回绕，恰好访问镜像内另一槽后正常拒绝；这不能说明其他非法 backend 都安全。

接口没有 destination capacity 参数，调用方必须实际拥有至少 64 字节可写存储；也没有对齐、锁、原子快照、cache 维护、配置 generation 或身份校验。一次复制包括多次 load，不能证明并发改表时得到一致记录。ABI 正常返回也不证明表来自 NAND、BLD 还是 RTOS 重建。

## 可达性与 EIS 首次执行边界

已保留的直接调用索引仅给出 `A0483C20` 的两处 caller：`A02989F8` 和 `A0298B30`，都传 `(backend=0, USER, index=4, stack_output)`，位于 updater 的 DTB 备份/写回上下文。调用者整体还含 NAND program/erase 或写回分支，**不能为了获得这一内部查询而执行这些 caller**。

另有休眠、BOSS/FDT 构造路径直接调用后端 thunk；本轮保留其引用清单，没有执行那些调用者。21 项 `t drv` 表逐项核对，没有直接导出上述五个入口；这只覆盖已列出的表和直接引用索引，不排除未恢复间接调用、其他普通命令或私有协议。

已取得的具体进展是：如果以后找到合法、已经可达的 stock query caller，单记录读取所需参数和副作用范围已有原码合同可核对。当前不能从内部函数地址跳到部署方案，更不能通过改命令表/函数指针“临时调用一下”来绕开首次进入、独占 RAM、I-cache 发布和恢复条件。

这份结果接续 [隐藏 PTB RAM 候选](device-1107-hidden-ptb-ram-candidate.md) 与 [读取路径安全边界](device-1107-ptb-read-path-safety.md)。没有新增 SYS RAM 捕获、BST/BLD/FW_UP 内容、外部入口、原生执行、算法替换或独立恢复证据；既有首次进入和真机写入确认要求继续有效。

主线程在冻结脚本上[独立复跑](../artifacts/verification/2026-11-11-get-partition-info-independent-run01/audit.json)的35个复制、15个拒绝、6个风险模型及16处指令核对全部通过；独立结果绑定同一脚本SHA-256，没有设备访问。
