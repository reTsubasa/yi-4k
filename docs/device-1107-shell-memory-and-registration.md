# YI 4K 1.10.7：Shell 内存访问与 `t` 注册边界

本报告针对实体机 1.10.7 对应的 `SYS_SW` 静态映像，补齐普通 Shell 的
`read*/write*` 参数解析和普通 `t` 动态注册器。它只描述代码行为；没有向相机
写入地址、注册命令或执行自定义 payload。

## 结论

1. `writeb`、`writew`、`writel` 会把第二、第三个参数直接解析成整数，然后分别
   执行 1、2、4 字节存储。解析函数没有 RTOS 地址范围检查、外设白名单、对齐检查
   或 cache 维护。写入无效地址、只读代码、设备寄存器或共享缓冲区都可能造成异常，
   因此这些命令不能作为安全 patch 或代码加载器。
2. `readb`、`readw`、`readl` 的 count 同样没有固定上限。它们会逐项读取并通过
   Shell 输出回调打印，过大的 count 可能越界、阻塞 Shell 或触发看门狗。
3. 地址解析接受十进制、`0x` 十六进制和带符号形式，结果是 32 位整数语义；写入
   handler 没有检查解析是否消费完整 token。多余参数不会改变写值，但不会被拒绝。
4. `t` 注册器 `0xA029E098` 的 ABI 是 `(const char *name, void *handler)`。它把
   名字复制到 RTOS 池，节点大小为 12 字节，并把 handler 原值保存到节点；分发器
   `0xA029E1A4` 最终执行 `bx handler`。因此 Thumb handler 必须带 bit 0，A32
   handler 则应保持 bit 0 清零。
5. 注册器只检查名字非空、handler 非空和名字长度不超过 19 字节；没有检查 handler
   是否位于固件映像、是否常驻、是否与已有命令重名，也没有找到 unregister 路径。
6. 注册器的两类池分配失败分支都直接返回错误，未调用 `0xA03C3C5C` 解锁
   `0xA1446708`。这属于原厂错误路径缺陷，不能在内存不足时反复尝试注册。
7. 1.10.7 的 22 个直接调用点分布在应用、图像、Wi-Fi、IPC、驱动和链路初始化函数
   中，调用者本身都是固件代码。当前没有证据表明 `autoexec.ash`、Linux API 或
   `loadbin` 可以直接调用 `0xA029E098`。

固件还暴露了 `t drv cache clean|invalid|flush <addr> <size>`。它们分别调用
`0xA0498728`、`0xA049878C`、`0xA04987F0`，可以用于研究数据缓存一致性；没有看到
这些 Shell handler 自身调用指令缓存 invalidate、分支预测同步或一个把 `loadbin`
目标转成可执行任务的完整协议。

## `t drv dma`：可研究的内存搬运路径

`t drv` 表中的 `dma` handler 是 `0xA04A8384`。普通参数分支在
`param_1 > 4` 时解析四个数值，并调用 `0xA04A8298(channel, src, dst, size)`：

```text
t drv dma <channel> <src> <dst> <size>
```

这是静态恢复的参数形态；命令行层没有看到地址范围白名单，底层通道包装只明确检查
`channel < 8` 且描述符非空。`0xA04A8298` 在提交 DMA 前调用
`0xA04A22CC(src, size)` 做源区 D-cache clean，在提交后调用
`0xA04A2038(dst, size)` 做目标区 D-cache invalidate，并通过 DMA 驱动等待完成。
因此它比 `write*` 更接近一个带数据缓存维护的内存搬运器。

它仍然不能证明自定义代码可执行：

- channel、地址、长度的硬件合法性和访问权限由更底层 DMA 驱动决定，尚未在真机上
  用自定义地址验证；
- DMA 路径本身只观察到 D-cache clean/invalidate 和 DSB，没有 I-cache invalidate、
  分支预测同步或 ARM/Thumb 状态设置；
- handler 没有把目标地址转为函数指针，也没有创建任务、保存寄存器或提供返回 ABI。

所以可以把 DMA 作为后续“已知 RAM 到已知 RAM”的低风险静态研究对象，但不能把它
和 `loadbin` 拼接后直接跳转到目标地址。任何真机 DMA 实验都应先使用原厂分配的、
非影像和非任务栈缓冲区，并且只做很小长度的同值拷贝；当前阶段尚未执行此实验。

## 内部 I-cache 例程：纠正为锁定/预取候选

进一步核对 CP15 指令后，先前“更完整缓存同步候选”的表述需要收窄。
`0xA04A283C(address, size)` 会检查 `size - 1 < 0xFE0`，并要求
`MRC p15,0,r2,c9,c0,1` 的低四位为零；这个条件不是检查 cache 是否启用。
随后保存 CPSR、关闭 IRQ/FIQ，清空整个 I-cache，再把 CP15 `c9,c0,1` 写成
`0xFFFFFFFE`，按 32 字节执行 `MCR p15,0,r0,c7,c13,1`，最后把同一控制寄存器
写成 `0xFFFFFFF1`，恢复 CPSR 并返回 0。失败路径返回 -1。末尾没有 ISB。

这些是本机字节中的实际操作；结合调用者在 DRAM 低功耗切换前调用、醒来后调用
`0xA04A28D0` 把 `c9,c0,1` 写成 `0xFFFFFFF0`，更符合指令 cache 锁定/预取用途。
精确位定义仍需对应处理器手册核对。它会留下寄存器状态变化，不能作为普通
`clear_cache(begin,end)` 或多核代码发布协议直接复用。

直接调用点是 `0xA04A5128` 和 `0xA04A5410` 两个低功耗路径；旧伪代码还会在
`0xA049A3C8` 跳板的展开中重复显示一次调用，不应重复计数。未找到 Shell 导出。
实体机 1.10.7 与分析样本的函数体比较中，`0xA04A283C`、`0xA04A5128` 和
`0xA04A5410` 均为逐字节相同，因而这里的地址和控制流可以作为本机静态参考。
实际反汇编见 `artifacts/device/2026-11-09-linux/rtos-analysis/rpc-contract-evidence/a04a283c.asm`。

## `read*/write*` 控制流

| 地址 | 作用 | 关键行为 |
|---|---|---|
| `0xA02A2CA4` | 地址和值解析 | `argc < 3` 失败；解析 `argv[1]` 和 `argv[2]`，不做范围/对齐检查 |
| `0xA02A2CFC` | 地址/count 解析 | `argc < 2` 失败；省略 count 时默认为 1，否则解析 `argv[2]` |
| `0xA04FB328` | 数值解析 | 接受 base 0 形式；返回解析值或溢出错误语义 |
| `0xA02A2D68` | `writeb` | `*(uint8_t *)addr = value` |
| `0xA02A2DB8` | `writew` | `*(uint16_t *)addr = value` |
| `0xA02A2E08` | `writel` | `*(uint32_t *)addr = value` |
| `0xA02A2E58` | `readb` | 循环 `count` 次，每次读取 1 字节并打印 |
| `0xA02A2F2C` | `readw` | 循环 `count` 次，每次读取 2 字节并打印 |
| `0xA02A3000` | `readl` | 循环 `count` 次，每次读取 4 字节并打印 |

`write*` 的反汇编在解析成功后只有一次普通存储指令，例如：

```asm
bl  0xa02a2ca4
cmp r0,#0
bne error
ldr r3,[sp,#0]
ldr r2,[sp,#4]
str r2,[r3,#0]       ; writel；writeb/writew 分别为 strb/strh
```

该路径没有调用 `0xA0498728`、`0xA049878C` 或 `0xA04987F0`，也没有屏障指令。
即使目标落在可写 RAM，另一个 CPU、DSP 或 DMA 看到的内容也不能据此保证一致。

`read*` 的循环条件直接比较用户提供的 count；每 16/8/4 项只影响输出换行，不是
边界保护。因此只读验证也必须使用已知映射、很小的 count，并限制总输出时间。

## `t` 注册器的实际 ABI

初始化函数 `0xA029E06C` 为池 `0xA144A73C` 建立 0x4000 字节池，为锁对象
`0xA1446708` 初始化互斥量。注册器随后执行：

```c
int t_register(const char *name, void *handler) {
    if (!name || !handler || strlen(name) > 19) return -1;
    if (mutex_take(0xA1446708, 0xffffffff) != 0) return -1;
    node = pool_alloc(0xA144A73C, 12, 0);
    if (node == NULL) return -1;             // 原厂路径未 unlock
    node->name = pool_alloc(0xA144A73C, strlen(name) + 1, 0);
    if (node->name == NULL) {
        pool_free(node);
        return -1;                           // 原厂路径未 unlock
    }
    memcpy(node->name, name, strlen(name) + 1);
    node->handler = handler;
    node->next = NULL;
    append_to_0xA06F3070(node);
    mutex_give(0xA1446708);
    return 0;
}
```

这是对 `0xA029E098`、`0xA029E06C` 和 `0xA029E1A4` 的控制流归纳；结构字段和
返回值已经由 A32 反汇编核对，函数名仍是分析者命名。分发器在匹配后把参数改成
`argc - 1`、`argv + 1`，再 `bx` 到节点中的 handler。`handler` 的低位因此是
ARM/Thumb 状态的一部分，不能在外部 ABI 中丢弃。

注册链没有删除操作。即使将来找到一次性执行入口，也必须让 handler、名字和节点
在整个运行期保持有效；entry 返回后不能释放承载 handler 的代码或数据。

## 对二开的直接影响

- 现阶段可以把 `readl` 当作极低频、已知地址的静态指纹工具；不能用它做大范围
  内存扫描，也不要恢复此前导致死机的 `/dev/mem` 高频轮询。
- `write*` 不应再用于探索 EIS 状态。下一次任何写入实验都必须先有版本匹配的
  地址、原值快照、单字节回退方案和冷启动验证；当前阶段仍不需要写入。
- 真正的原生扩展仍缺一个安全的首次执行入口。需要继续寻找“启动时已有函数指针
  或任务描述符如何被触发”的路径，再验证缓存同步、任务对象和异常恢复；不能把
  `loadbin`、`t` 注册器或 `echo_cortex` 单独当作 loader。

