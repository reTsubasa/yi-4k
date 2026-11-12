# YI 4K 1.10.7：原厂任务创建模板

本报告从实体机 1.10.7 的 RTOS listing 中恢复一个完整的原厂任务创建调用点，作为
未来最小 payload 任务的 ABI 参考。它只做静态分析，没有调用任务创建函数。

## 已恢复的调用点

函数 `0xA01E627C` 初始化 `AppLib_Host_Control_Manager`，在
`0xA01E638C` 调用 `AmbaKAL_TaskCreate` 包装层 `0xA03BC2BC`。对应参数为：

| 参数 | 实际值 | 解释 |
|---|---|---|
| `r0` | `*[0xA01E6508]` → `0xA13A20EC` | 静态任务对象/控制块指针 |
| `r1` | `0xA057E628` | 字符串 `AppLib_Host_Control_Manager` |
| `r2` | `0x6E` | priority |
| `r3` | `0xA01E5BD4` | entry 函数 |
| 栈参数 0 | `0` | entry argument |
| 栈参数 1 | `0xA13901C0` | 静态栈区域 |
| 栈参数 2 | `0x10000` | 栈大小 |
| 栈参数 3 | `1` | auto-start |

`0xA01E627C` 和 `0xA01E5CE8` 在实体机与旧样本中逐字节相同，调用点不是旧版本
伪代码拼接出来的假设。`0xA01E5BD4` 的入口会从宿主控制对象的 `+0x1AC` 取出
回调并跳转；它是该子系统的真实任务入口，不能直接作为通用 loader。

## 对二开的意义

当前可把任务 ABI 写成候选形式：

```c
uint32_t kal_task_create(
    void *task, const char *name, uint32_t priority,
    void (*entry)(uint32_t), uint32_t arg,
    void *stack, uint32_t stack_bytes, uint32_t auto_start);
```

ThreadX 检查层会拒绝空 task/entry、重复对象、重叠栈、栈大小不大于 `0xC7`、
priority 大于 `255`、threshold 小于 priority 或 auto-start 大于 `1`。这些检查在
`0xA03C4240` 的 1.10.7 listing 中可见；控制块大小常量为 `0xD8`。

这个模板尚不能直接拿来运行自定义代码，原因是：

1. 静态任务对象和栈的所有权属于原厂模块；不能覆盖 `0xA13A20EC` 或
   `0xA13901C0`。
2. 自定义 task 的 entry 必须已经位于可执行、常驻、缓存一致的区域，并满足 A32/
   Thumb 状态和栈对齐约束。
3. `loadbin` 没有创建任务或跳转逻辑；还缺少“如何安全获得新的 task 对象、栈和
   entry”的触发入口。
4. 删除/终止/异常清理、录像期间的优先级和实时预算都尚未在真机验证。

## EIS 任务创建后的实际顺序

本机 EIS 两个创建函数给出了一条比通用模板更完整的生命周期：

```text
TaskCreate(..., auto_start=0)
  -> TaskSmpCoreExclusionSet(task, ~3)
  -> TaskResume(task)
```

这里的 `0xA03BC7D8` 已由同一固件中的错误字符串交叉确认是
`AmbaKAL_TaskSmpCoreExclusionSet`。它把任务控制块 `+0x98` 的低两位更新为传入掩码，
EIS 调用的 `~3` 使最终低两位为 `0`。这一步是调度核的核心排除掩码设置，不能简单称为
CPU affinity 数字，也不能把 `0` 解释成“固定在某个核”。

`0xA03BC31C` 跳到 `0xA03C4644`。创建底层在 `auto_start=0` 时把控制块状态设为 3
但不插入 ready 队列；该入口在状态 3 时调用 `0xA03C17C4`，把任务放入对应核心的
ready 结构。因此 EIS 创建路径的第三步是启动/恢复，而不是挂起。原厂代码不检查这两个
调用的返回值，最小扩展任务应记录并处理错误码。

这也解释了为什么 EIS 两个任务都先以 `auto_start=0` 创建：先完成静态栈、核心排除掩码
和控制块初始化，再进入调度。自定义任务应复制这个顺序，但必须使用自己的控制块和栈。

因此，下一步的最小闭环应复用这个 ABI 的**参数布局**，但使用新分配且有明确所有权
的 task/control block、栈和只记录一次的 entry；在此之前不写入上述原厂静态对象。

对应的静态声明记录在 [yi4k_1107_internal.h](../sdk/yi4k_1107_internal.h)，仅用于
编译期类型检查和后续 loader 设计。

