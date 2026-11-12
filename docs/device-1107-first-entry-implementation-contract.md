# 首次原生执行：外部入口与 volatile RAM 两条实现合同

2026-11-10。本轮新增结果是：**原厂有核间 callback 通知机制，但其已知目标只做 TLB 维护，而且发送函数不提供远端完成回执；它不能填补 I-cache 发布缺口。** 同时恢复了 `ps mem`、`ps mem detail`、`ps tsk`、`ver -e` 的精确分发，并重用此前成功设备采集，明确下一份小型只读观测可补什么。

本轮未访问设备、写设备 RAM/固件/SD、生成可执行探针或写入器，未改 Android/roadmap。固定 CPU SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。使用已有文件、Capstone、Unicorn，没有可用 REA MCP；没有 REA Evidence ID。

复现 [audit_native_first_entry_contract.py](../scripts/audit_native_first_entry_contract.py)：

```sh
.venv-reverse/bin/python scripts/audit_native_first_entry_contract.py
```

输出 [audit.json](../artifacts/device/2026-11-10-native-first-entry-contract/audit.json) 及九份原始反汇编。26 条固定指令检查、4 个真实 dispatcher 场景通过；场景明确替代 strcmp、被选查询 helper、构建信息 getter、打印回调，验证参数和返回，不模拟真实 cache 或多核。历史原件的池概要及应用池头也重新解析核对。

## A：原厂外部入口目前闭合到哪里

本轮不重复已有 [NC 分配合同](device-1107-nc-pool-allocation-contract.md) 和 [注册合同](device-1107-shell-memory-and-registration.md)。把仍像 loader 的三个具体线索收窄如下：

| 线索 | 新核对的原始行为 | 对首次执行的含义 |
|---|---|---|
| `ver -e` / `Show elf info` | `A02A40F8` 比较 `-e` 后，在 `A02A42A4` 调 `A02A40BC`；后者只让 `A029B79C` 从 `A0821624/28/2C` 取构建字符串并打印 | 没有读 ELF 文件、解析段/重定位、分配代码或调用 ELF entry |
| `autoexec.ash` 与 `.ash` | `A029D4D8` 选择原厂脚本 reader `A029D3B4`；后者逐字节读文本、遇行尾交 `A029CCB8`，最终由 `A029CB84/A029C974` 按命令注册链查 handler | 外部文件提供命令字符串及 argv，没有在这条正常路径中提供 entry 函数指针；不能用脚本文件名推导 ARM loader |
| BOSS SMP callback | `A03CFBFC` 取 `A17E143C`，然后 `BX r3`；已保留引用索引中只有两次写该 slot，都写固定 `A03CFBD8` | 是真实内部 callback 来源，但当前没有外部参数入口，也没有新代码发布合同 |

固定普通 Shell 表38项、`t drv` 21项、`t ants` 69项及先前注册/任务调用者审计中，没有恢复出“外部请求指定大小 → 受检查临时 NC 分配 → 返回独占 original/aligned → 发布新指令 → 注册/进入 → 解除注册并释放”的完整链。现成压力测试、音频/USB 工作区都不提供这一资源句柄合同。

这是上述表、已恢复分支与固定直接引用范围内的结论，不是全固件不存在动态模块的证明。`elf update finish` 属于固件升级/分区百分比表构建上下文，不能把其中的 ELF 字样当成可返回插件接口。未捕获区域、未知间接调用及未恢复的私有协议仍是未知。

因此 A 的具体推进条件是找到一个**已经能被外部触发的 stock handler**，其正常参数流确实控制独占分配及 callback/entry；仅继续列举固定 callback 或任务数量不会缩小缺口。

## 原厂核间维护顺序：新增精确边界

`A03CFBD8` 的完整原码只有以下操作：

```text
DSB SY
r3 = 0
MCR p15,0,r3,c8,c7,0
MCR p15,0,r3,c8,c6,0
MCR p15,0,r3,c8,c5,0
MCR p15,0,r3,c8,c3,0
DSB SY
ISB SY
BX LR
```

它没有 `c7,c1` / `c7,c5` 的 I-cache 失效操作。slot 两次写入为 `A03CFFDC`、`A03D08E0`，分别位于 BOSS start/restore；均注册该固定 TLB helper，随后调 `A0482F3C(0x54,1,0)`。

`A0482F3C` 获取发送锁、从 `A04A2990` 读当前 core ID，mode=1 时把目标设为当前核心位的反码，然后调用 `A0497454` 配置目标、`A0497628` 触发中断，解锁并返回。**这个函数内没有等待远端 handler 完成、读回 generation 或接收 acknowledgement。** 这不排除更大 BOSS 状态机另有握手，却不能把该函数返回当成代码发布完成。

restore 的实际顺序为：恢复固定向量/映射数据 → `A03CFBD8` → `A04A1F54`（全局 D-cache/L2 维护上下文）→ `DSB` → 恢复中断状态 → 注册/通知远端 TLB helper → 恢复 TCB/context → 本地 `ICIALLUIS`。`A03D0548` 还改写 TTBR1、辅助控制、Context ID 和映射寄存器。`A04A1F54` 涉及固定 L2 控制地址及函数表锁，不是只依赖 `(addr,len)` 的小 helper。

这说明原厂在完整系统恢复中会组合本地/远端维护，**没有**得到一个可以对任意新 RAM 代码调用的“同顺序”普通 API。不能截取内部 ICIALLUIS、替换 BOSS slot、复用恢复上下文或省略完成确认来宣称安全发布；对应 [既有代码发布边界](device-1107-code-publication.md) 仍有效。

## B：最小 volatile RAM 进入/返回候选的精确资源合同

本轮没有选定可写代码地址。将未来候选拆成下列可审阅对象，才能避免把“NC 池存在”误当“有一块无人使用的 RAM”。

| 对象 | 必须成立的所有权/生存期 |
|---|---|
| 代码及常量 | 原厂分配成功并持有的 original/aligned pair，记录申请大小、有效范围、对齐、pool；不借音频/USB/DSP 已分配区，不使用当前 free-list 地址作为预留 |
| 有界结果 | 独立持有的结果区，固定长度、进入/返回状态及错误码；不能把“日志没出现”作为没有进入的证明 |
| 栈与任务对象 | 若采用新任务，独立 `0xD8` TCB 和原厂要求栈；TaskCreate suspended → 核心排除 → resume，每个返回码有明确分支；不能借主控/VideoAnal/EIS 栈 |
| 临时命令入口 | 若采用同步 handler，需唯一表项所有者、原 handler 指针快照、无并发调用、代码及结果持续存活；返回后读回原指针并撤销所有新指针，再考虑释放 |
| original 释放 | 只能传 original；必须证明任务已停、命令已返回且其他核心无旧 pointer/取指消费者。一次入口返回不自动证明所有消费者结束 |

同步 handler 依 [已验证 dispatcher ABI](device-1107-ram-first-entry-boundary.md) 可以省掉新建任务对象和新任务栈，但首次表指针写入、代码区所有权、单一调用者及发布机制仍未解决。普通注册器缺少 unregister，因而“注册一下，探针返回后立即释放代码”不满足生存期。

发布合同还须具体给出：写入者和执行者各是哪一核心/地址别名；活动页表属性；写完字节到所有可能执行核心完成 I-cache/分支状态同步的先后及完成回执；最终 pointer 发布和撤销次序。固定在一个执行核心只能减少参与者，不能证明该核心没有旧取指内容。Normal NC/XN=0 和分配器的 DMB/DSB 都不替代这个首次取指证明。

冷复位合同至少应包含：移除/禁用再次触发文件的独立方法；真实 RTOS 冷启动而非仅 Linux reboot、BOSS resume 或休眠恢复；重启后固件指纹、原表指针、池对象重新建立及探针停止的回执。启动函数确实重建池，但不能据此断言探针数据字节被擦零，或所有热/恢复启动都执行该函数。若未返回，不能承诺还能由同一个 Shell 恢复指针；这一路线仍承担失联/崩溃和物理恢复风险。

2026-11-12 [原厂看门狗恢复边界审计](device-1107-native-watchdog-recovery-boundary.md) 又排除了一条顺序预置假设：`t drv wdt` 启动后在同一 handler 等待 UART，读返回即停止 WDT，不能在同一 autoexec 流中后台预置再执行下一行。应用另有 timer ID7 喂狗且共用同一个硬件；启动/读取/停止错误也不由该命令的返回码体现。该离线结果未建立探针独立期限、真实复位或冷回滚，P11 仍未闭合。

## 现成只读命令可补齐的值

此前 [控制台诊断](device-1107-console-and-readiness-validation.md) 已真实执行并回收 `ps mem`、`ps tsk`、原厂 savebin。成功 capture `e30da2b76aa5`：8 个 byte pools、3 个 block pools；应用池头 `A0FD7114` 的 Available=234,597,172、fragment=522，与概要第0行一致。第1行是 Available=16,643,568、fragment=9，**仅凭概要不能把该行确定命名为 NC pool**。本轮重新读取这些旧原件，未新采集。

| 精确命令形态 | 输出与边界 | 可证明/不可证明 |
|---|---|---|
| `ps mem` | 每个 byte/block pool 一行；旧采集为8+3行，参数没有指定某个 pool 的形式 | 有当时总量/碎片数；无地址、区域、最大连续块或独占分配 |
| `ps mem detail` | 每个 byte pool 先打印 Size/Start，再遍历其全部 fragment；没有 pool 筛选或行数上限，旧概要合计590个 fragment | 可把 NC 区域 `A2100000`/大小`01000000`对应到具体池，得到当时块链；遍历中未持整段池锁，不是原子快照，不能据 free 行占用该块 |
| `ps tsk` | 全部任务一行，包含状态、调度计数、栈/SP和SMP core mask；不能参数筛选某个 TCB | 已有运行状态/任务名证据；不能证明以后不会调度、Shell 唯一运行核心或自定义 entry 可进入 |
| `ver -e` | 一条构建信息输出 | 版本辅助；不是 ELF 入口或当前 MMU/cache 状态 |

若父任务安排下一次最小采集，优先沿已验证持久重定向路径取一次 `ps mem`，加一份**仅48字节**的 NC 池头；例如原厂命令参数形态：

```text
ps mem > c:\<unique>_mem.txt
savebin c:\<unique>_nc_head.bin 0xA0FE7220 l 48
```

这是文档中的待审阅命令形态，不是本轮部署。savebin 对 RTOS RAM 只读，但会创建 SD 输出文件。NC 池头检查字段为 `+00=42595445`、`+08=available`、`+0C=fragments`、`+18=A2100000`、`+1C=01000000`、`+2C=next pool`。它足以核对 NC 对象身份及与概要关联，比先打印所有 fragment 更有界；仍不是分配句柄。`readl 0xA0FE7220 1`、`readl 0xA0FE7228 2`、`readl 0xA0FE7238 2` 也可限定到这些已知控制字段，但必须沿已建立的 RTOS 命令/输出路径，不恢复 `/dev/mem` 或高频轮询。

`ps mem detail` 若以后确有连续空间问题再单次使用；输出随全局 fragment 数增长，不能承诺固定几KB或硬超时。Shell 命令未返回时主机超时也不会自动停止 RTOS 遍历。摘要和48字节头已能先回答当前最重要的 NC 对象身份问题，无需为首次进入而全池扫描。

这些只读观测**不能**建立独占分配、修改 callback、创建任务、发布新指令或证明冷复位恢复。没有现成普通查询读出并证明“当前活动 TTBR/SCTLR/I-cache 状态和所有核心同步完成”；读取某张静态页表也不等于证明它是当前 TTBR。到此之后若选择 B，就必须明确审阅实际 RAM/指针写入与首次进入风险；本轮没有将这些风险包装成可部署方案。
