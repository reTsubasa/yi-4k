# YI 4K RTOS 基础实现：Shell、文件、任务、内存和缓存

本记录来自公开社区 v1.10.52 的 `_part_lrtos.a9s`，SHA-256 为 `c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141`，分析基址 `0xA0100000`。使用 Capstone 5.0.7 对具体入口反汇编；所有行为结论是离线静态结论，未在相机执行。`scripts/rtos_core.py` 可重建主要汇编证据。

## 已经可以复用的基础实现

| 实现 | 入口 | 从指令确认的调用方式 | 证据与边界 |
|---|---|---|---|
| `t` 子命令注册 | `0xA029E098`，ARM | `int(name, handler)` | 检查指针非空、名字不长于 19 字节；分配 12 字节节点和名字副本，挂入链表；需初始化后的 mutex 和 byte-pool |
| Shell handler ABI | 各命令入口 | `r0=argc, r1=argv, r2=printf-like callback` | 命令解析函数在此 ABI 下比较 argc、取 argv、调用回调；回调返回类型没有被消费，不能确认 |
| 文件打开 | `0xA032E0C8`，ARM | `file*(path, mode)` | `loadbin` 传 `"r"`、`savebin` 传 `"w"`，返回零检查；thunk 到 `0xA033A210` |
| 文件关闭 | `0xA032E0D0`，ARM | `int(file*)` | 两者返回小于零时报错；thunk 到 `0xA033A1E0` |
| 文件读取 | `0xA032E0D4`，ARM | `uint32_t(buf,size,count,file*)` | 四个输入寄存器；thunk 到 `0xA033A2AC`；内部把第 5 个参数设置成栈上输出计数指针，调用 `0xA034FA9C`，再返回计数 |
| 文件写入 | `0xA032E0D8`，ARM | `uint32_t(buf,size,count,file*)` | thunk 到 `0xA033A3C0`，后者同类转调 `0xA034FDE4` 后返回计数 |
| 文件信息 | `0xA032E194`，ARM | `int(path,stat_buffer)` | 成功返回零；输出缓冲区 +8 处放 64 位长度，其余布局只部分恢复；不应直接使用主机 `struct stat` |
| 任务创建 | `0xA03BC2BC`，ARM | 8 参数 AmbaKAL 风格，见下文 | 直接转排参数到 ThreadX 检查层，控制块大小 `0xD8`，抢占阈值=priority，time-slice=0；未真机创建任务 |
| 任务睡眠 | `0xA03BC320`，ARM | `uint32_t(raw_ticks)` | 直接 branch 到 `0xA03C0B20`，其修改当前线程状态并挂起；Shell 帮助写 `[ms]`，但 wrapper 未做时基换算，实际 tick 频率需测量 |
| 当前任务 | `0xA03BC384`，ARM | `void*(void)` | branch 到 `0xA03C016C`，在临界区读取当前任务 |
| 池分配 | `0xA03BC6DC`，ARM | `(pool,void**out,bytes,timeout)` | ThreadX byte-pool 风格，超时值 -1 特判，其余有换算；必须提供已初始化池对象 |
| 池释放 | `0xA03BC714`，ARM | `status(original_ptr)` | direct branch 到 byte-release 风格检查入口 `0xA03C3700` |
| 对齐分配 | `0xA029A7D8`，ARM | `(pool,&aligned,&original,bytes,alignment)` | 分配 bytes +2×max(alignment,32)，固定 timeout=500，再向上对齐；释放必须用 original 指针 |
| D-cache clean | `0xA0498728`，ARM | `(address,bytes)` | 日志标识 `AmbaCache_Clean`，低层 `0xA04A22CC` 使用 CP15 c7,c10,1 |
| D-cache invalidate | `0xA049878C`，ARM | `(address,bytes)` | 日志标识 `AmbaCache_Invalidate`，低层 `0xA04A2038` 使用 CP15 c7,c6,1 |
| D-cache flush | `0xA04987F0`，ARM | `(address,bytes)` | 日志标识 `AmbaCache_Flush`，低层 `0xA04A2568` 含 clean 与 clean/invalidate 路径 |
| `strcmp` | `0xA04F9744`，Thumb | `(s1,s2)` | 逐字节/字宽比较并以字节差返回；作为 C 函数指针用 `0xA04F9745` |
| `strlen` | `0xA04F99F0`，Thumb | `(s)` | 四字节零检测后恢复长度；函数指针低位需置 1 |
| `strtoul` 风格 | `0xA04FB328`，Thumb | `(s,endptr,base)` | 转到重入型核心，Shell 以 endptr=0/base=0 调用；整数范围和 errno 行为未完整验证 |

这组接口足以支持“SD 卡加载代码—文件日志—任务与同步—缓冲区管理”的原型研究，不等同于已经能执行任意 payload。所有地址须固定到上述 RTOS 哈希，且不能从 Linux 直接调用。

## 重要的代码结论

### 1. Shell 的扩展入口不必先覆盖原函数

`0xA029E098` 是注册新 `t` 子命令的实现，而非仅有硬编码表：

1. 拒绝空名字/空回调以及长度超过 19 的名字。
2. 使用 mutex `0xA1446708`，分配池 `0xA144A73C`。
3. 节点是 `name pointer / handler pointer / next pointer`，12 字节。
4. 根节点 `0xA06F3070` 作为链表头哨兵；从其 +8 遍历到末尾后追加。
5. `0xA029E1A4` 根据 `argv[1]` 查询名字并尾跳转回调，同时将 `argc` 减 1、`argv` 加 4；回调的 argv[0] 就是子命令名。

需要注意生命周期：函数复制名字，却保存原始 handler 指针，因此原生扩展代码不能在命令仍注册时被释放。尚未找到 unregister 实现。初始化完成前调用、重名处理、并发遍历和注册失败时的锁恢复均应先验证。

### 2. 文件接口不是普通 libc `FILE`

`loadbin` 使用文件信息结构的 64 位长度，并传给读取函数时使用其低 32 位计数；读取结果以 32 位值与长度比较。因此不能因为 DJI 的旧 IDC 给出 uint64_t 型 `fread` 声明，就照搬到本固件。YI 的实际调用是 r0=buffer、r1=size、r2=count、r3=file 四寄存器形式。

已恢复的 loadbin 语义相当于：

```c
// 说明性重建，省略错误日志；不是原始源码。
// handler argc == 3；argv[1] 必须含盘符。
stat(argv[1], info);
parse_address(argv[2], &destination);
f = internal_fopen(argv[1], "r");
read_count = internal_fread(destination, 1, info.size_low32, f);
if (info.size_high32 != 0 || read_count != info.size_low32) error;
internal_fclose(f);
```

它没有表现出自动刷新指令缓存、分配目的内存或跳转执行的行为。`loadbin` 只负责把文件字节写到给定地址。

### 3. TaskCreate 的 ABI 比完整 ThreadX API 更适合先复用

从 `0xA03BC2BC` 的栈重排可恢复：

```c
uint32_t candidate_TaskCreate(
    void *task, const char *name, uint32_t priority,
    void (*entry)(uint32_t), uint32_t entry_arg,
    void *stack_base, uint32_t stack_bytes, uint32_t auto_start);
```

转入 ThreadX error-check create `0xA03C4240` 后，其参数相当于：task、name、entry、entry_arg、stack_base、stack_bytes、priority、priority、0、auto_start、0xD8。

检查层明确拒绝空对象/空 entry、重复对象、与已登记栈重叠、栈长小于等于 `0xC7`、priority>255、threshold>priority、auto_start>1、错误调用上下文。不要仅按最小长度分配栈；实际扩展应另测栈水位和对齐。

线程控制对象验证使用 `0x54485244` (`THRD`) 魔数。`0xD8` 是本固件传给创建检查层的控制块大小，不应把其他 ThreadX 头文件的 `TX_THREAD` 结构直接套进来。

`0xA03BC30C`/`310`/`314`/`31C` 分别为 delete/terminate/resume/suspend 的高置信候选，但线程生命周期和取消清理没有真机验证。Header 将这些参数保持为 opaque 指针。

### 4. 对齐内存必须同时保留两个地址

`0xA029A7D8` 的第二个输出是对齐地址，第三个输出是原始分配地址。它不是标准 malloc(size)。下游释放 `0xA03BC714` 应接收原始地址；对齐地址可能位于分配内部。该函数也没有证明返回区可执行，不应自动把字节池当作代码堆。

### 5. D-cache 与 I-cache 必须分别处理

三个 AmbaCache wrapper 的检查、日志和 CP15 指令相符，观测的 cache-line 步长为 32 字节。它们是数据缓存操作。新写入的 ARM/Thumb 程序除了 D-cache clean，还要合适的 I-cache invalidate、屏障及（可能）其他 CPU 核同步。

低层 `0xA04A2880`、`0xA04A42D4` 等处可见 I-cache invalidate 指令，但它们处在更大的底层流程里。**本次没有把这些内部指令位置当作可直接调用的 I-cache API**，也没有在 header 暴露它们。

## 输出文件与验证

- `interfaces.json`：地址、置信度、原型、证据位置与限制。
- `seeds.tsv`：供反汇编工程导入的 analyst 前缀名；Thumb 地址低位已置 1。
- `*.asm`：选定范围的 Capstone 反汇编，不保证每个范围正好对应函数边界。
- `sdk/yi4k_11052_internal.h`：只做 ABI 研究记录，不是通过真机测试的 SDK。
- `scripts/rtos_core.py`：检查 RTOS SHA-256 后重建核心汇编证据。

代码分析未执行相机固件、未连接相机、未修改原二进制。下一步应先对这些函数进行更完整的 CFG/反编译检查，再实施只打印/写日志并可返回的原生代码实验。
