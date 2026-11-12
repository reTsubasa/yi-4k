# YI 4K 1.10.7：可复用任务启动路径

本报告补充原生执行关卡中“任务对象如何真正进入 ready 队列”的静态证据。分析基于
实体机 1.10.7 与公开 RTOS 样本的函数体比较；没有创建任务、写入任务控制块或执行
自定义 entry。

## 已确认的包装

`0xA0188944` 是一个比底层 `0xA03BC2BC` 更窄的启动包装，参数形态为：

```c
int start_test_task(
    void *task,
    const char *name,
    void (*entry)(uint32_t),
    void *stack
);
```

它实际执行：

```text
TaskCreate(task, name,
           priority=0x32,
           entry, arg=0,
           stack, stack_bytes=0x2000,
           auto_start=0)
TaskSmpCoreExclusionSet(task, 0xFFFFFFFD)
TaskResume(task)
```

任一步骤失败都会记录错误；核心排除或 resume 失败时调用 `0xA03C448C` 清理任务。
这与 EIS 两个任务采用的生命周期顺序一致，说明该顺序不是偶然的单个调用点。

## 调用范围

`0xA0188944` 的直接调用者只有 `0xA0189628`，其中两次调用分别创建：

| task object | name | entry | 用途 |
|---|---|---|---|
| `0xA10537C8` | `Audio_Encoder_UnitTest_Primary_M...` | `0xA0188E50` | 音频单元测试主 muxer |
| `0xA1053690` | `Audio_Encoder_UnitTest_Secondary...` | `0xA01884E8` | 音频单元测试次 muxer |

`0xA0189628` 由 `tcmd_audio_enc` 的 `init` 分支触发，但 entry、task object 和栈
指针均来自固件静态对象；Shell 参数只选择测试模式，不能替换函数指针。
1.10.7 对应函数体与分析样本逐字节相同。

映像中还有一个更完整的九参数包装 `0xA04B3B94`：

```c
int usb_start_task(task, name, priority, entry, arg,
                   stack, stack_bytes, auto_start, core_mask);
```

它把前七个参数原样传给 `0xA03BC2BC`，把底层 `auto_start` 强制设为 0，再调用
`TaskSmpCoreExclusionSet(task, ~core_mask & 3)`；只有包装层的 `auto_start == 1` 时
调用 `TaskResume`。这是 A32 栈参数复核后对旧报告“前八个参数原样传递”的修正。
它在检查 TaskCreate 返回码之前调用核心排除函数，且不检查核心排除或 resume 的
返回码；因此复用时应自行补齐错误处理。直接调用者是 USB/PictBridge 初始化函数
`0xA04B3C38`、`0xA04B5B04` 和 `0xA04B7F3C`，每个 entry 都是固件内固定符号，
没有从 USB 请求或 Shell 参数读取函数地址。

对全部保留伪代码中的 `0xA03BC2BC` 调用表达式做参数位扫描后，恢复出 85 个完整
调用；第 4 个参数（entry）均为固件内 `FUN_`、`LAB_` 或 `&DAT_` 符号，两个
通用包装 `0xA0188944`、`0xA04B3B94` 除外，它们分别接收调用者传入的 entry。
`0xA0188944` 的两个调用者又分别传入 `0xA0188E50` 和 `0xA01884E8` 固定 entry；
`0xA04B3B94` 的三个 USB 调用者也都传入固定固件 entry。原始调用索引还包含拆分或重复的
控制流记录，因此这里以完整表达式扫描作为 entry 分类依据；它不改变“没有直接从
Shell 数值获得 entry”的结论。

## 与自定义代码的关系

这条路径证明自定义任务需要的四个运行期条件：

1. 一个合法的 `0xD8` 任务控制块及不重叠栈；
2. 一个满足 ARM/Thumb 状态的 entry 指针；
3. `TaskCreate(auto_start=0)` 返回成功；
4. 核心排除和 `TaskResume` 必须在创建线程的合法上下文执行。

这些包装没有解决 entry 的首次来源。`0xA0188944` 和 `0xA04B3B94` 都没有从文件
读取代码，没有建立代码缓存同步协议，也没有检查代码段是否驻留。
因此它们只能作为未来 loader 的启动模板；仍需先找到能运行一段小型初始化函数的
入口，再把缓存维护、任务对象和回退策略接入。

## 下一条静态追踪

优先分析 `0xA0189628` 所属的 `tcmd_audio_enc init` 初始化保护和音频测试对象，确认
是否存在可复用的“由 Shell 触发、但 entry 固定”的任务创建时机。若没有可替换函数
指针的间接层，就继续搜索其他任务创建包装，直到找到一个由运行时描述符提供 entry
的原厂路径。

