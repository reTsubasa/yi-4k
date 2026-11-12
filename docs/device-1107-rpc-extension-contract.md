# YI 4K 1.10.7：RPC 扩展接口与执行边界

恢复了 RPC 的服务注册、描述符复制、请求分发和注销链。本轮得到 7 处服务构造器、
26 个 procedure 回调的本机地址表，以及可编译的候选 ABI 头文件。它们可用于已有
RTOS 扩展的控制和回传，但尚不能使 Linux 或 SD 文件中的机器码首次运行。

证据均来自本机 SHA-256 为
`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c` 的离线映像。
本轮没有调用设备 RPC、创建服务、改写内存或加载代码。服务构造器存在不等于当前
开机已注册；此前 SharePreview 查询返回服务未找到的真机结果仍然成立。

## 可复用的 ABI

`0xA03CAAB4` 的参数形态为：

```c
uint32_t svc_register(uint32_t program, uint32_t version,
    const char *name, uint32_t priority,
    void *stack, uint32_t stack_bytes,
    const struct program_info *info, uint32_t dedicated_thread);

struct procedure { void (*handler)(void *request, struct reply *out); uint32_t mode_raw; };
struct program_info { uint32_t procedure_count; const struct procedure *procedures; };
struct reply { uint32_t bytes; void *buffer; uint32_t mode_raw; uint32_t status_raw; };
```

这是 32 位 ABI，procedure 为 8 字节，program_info 为 8 字节，reply 为 16 字节。
reply 的 buffer 由服务工作层预置；不能把 Linux 地址作为 RTOS 输出指针。
完整声明见 [yi4k_1107_rpc.h](../sdk/yi4k_1107_rpc.h)。mode 字段保留原始值，
尚未对每个服务证明其同步/异步语义。

注册器会分配 `0x39C + 全局配置长度` 的服务对象，并另行分配 `count * 8` 字节，
复制整个 procedure 表。也就是说临时描述符可以在注册返回后释放，原厂构造器正是
这样做的；name 仅保存指针，没有复制字符串，name、handler 代码和外部传入的
task 栈仍必须常驻。

主要对象字段由本机 A32 存储指令确认：

| 偏移 | 静态用途 |
|---|---|
| `+0x00/+0x04` | program / version |
| `+0x08` | 传输端口对象 |
| `+0x78/+0x7C` | 服务链表节点 |
| `+0x80` | 服务名指针 |
| `+0x84` | 内嵌 ThreadX task 对象 |
| `+0x33C/+0x340` | 收到的数据地址 / 接收长度值 |
| `+0x344` | 是否使用专用 task |
| `+0x348/+0x34C` | procedure 数量 / 已复制表地址 |
| `+0x350` | 工作请求副本开始 |
| `+0x398` | procedure 编号 |
| `+0x39C` | 传给 handler 的请求数据开始 |

## 请求如何到达函数

```text
RPMsg / aipc_rpc 传输层
  → 已注册端口回调 A03CA870(service, packet, length)
  → 置服务事件，并等待 packet 已复制的确认
  → 专用任务 A03CAE84(service)
       或线程池 A03CA6E8 → 固定 A03CAE84(service)
  → 使用 procedure 编号选取 copied_table[procedure - 1]
  → handler(request_data, reply)
  → A03CADCC 组织回复
```

工作线程在实际调用 handler 前检查 `1 <= procedure <= count`；函数地址来自注册时
复制的表，网络请求提供的是编号和数据。线程池中虽然也有 `{function,arg}` 队列，
`0xA03CA870` 放进去的 function 固定为 `0xA03CAE84`，不能把该队列当成网络任意
函数调用器。

另一个边界：handler 范围检查前存在一次按 procedure 读取表中 mode 的操作，再调用
统计函数。是否还有更早的输入校验尚未完整恢复。因此不能仅凭最终检查就断言整条
路径对任意 procedure 都安全；本轮没有发送异常编号进行验证。

## 已恢复的服务构造器

| program / version | 构造器 | procedure 数量 | 表中的 handler 来源 |
|---|---|---:|---|
| `0x10000001 / 1` | `0xA0245CF4` | 2 | Shell test 服务的固定回调 |
| `0x1000000C / 1` | `0xA0247E54` | 3 | SharePreview 固定回调 |
| `0x1000000B / 1` | `0xA0476380` | 1 | Linux command handler 固定回调 |
| `0x10000005 / 1` | `0xA0476BB4` | 2 | Net control 固定回调 |
| `0x10000006 / 1` | `0xA04771D0` | 2 | Data notify 固定回调 |
| `0x10000009 / 1` | `0xA0478580` | 1 | Event notifier 固定回调 |
| `0x10000004 / 1` | `0xA04793A0` | 15 | Net FIFO 固定回调 |

其中 SharePreview 的三个 procedure：

| 编号 | handler | 静态用途 |
|---:|---|---|
| 1 | `0xA0247A20` | GetShareMemInfo |
| 2 | `0xA024840C` | Enable |
| 3 | `0xA02478F4` | GetStatus |

`t ipc rpc svc test +` 创建的服务也只是固定注册 test 表；它没有接收 handler 地址。
这里的 7 处是本轮检查范围，并非全部 firmware RPC 服务清单。

## 注册/注销的限制

- `dedicated_thread != 0` 时调用原厂 TaskCreate，entry 固定为 `0xA03CAE84`，arg
  为服务对象，auto_start 为 1；这个 TaskCreate 返回值没有被检查，注册器随后返回 0。
- 服务对象分配、procedure 表分配之后也没有完整的空指针检查，不能把这层当成健壮
  的生产 SDK。
- `0xA03CAC1C(program,version)` 会发结束事件、等待 worker、必要时 terminate/delete
  专用任务，再移除端口和服务链、释放已复制表与服务对象。
- 未观察到注销器释放构造器传入的 task 栈；不能假定注销会自动回收外部栈，也不能在
  worker 还运行时释放栈或 handler。

## 对下一步二开的作用

一旦最小 RTOS entry 的运行已验证，可把这个 RPC ABI 用作扩展的低频控制面：读状态、
设置有边界的参数、回传日志。第一版服务只需固定的状态查询 procedure；逐帧 EIS
网格和高频 IMU 处理继续留在 RTOS 内部，不能等待 Linux RPC 往返。

当前需要继续查的是已有回调注册函数的上层调用者，以及是否能在启动时安全接入一个
独立扩展。现有证据不足以把 RPC 注册器当成首次执行入口，也不足以选择任意空白 RAM。

## 重现与验证

```sh
.venv-reverse/bin/python scripts/device_rpc_contract.py
```

脚本先验证整份本机映像哈希，再对 15 个相关函数按已保留边界重新反汇编和核对函数
体哈希，检查 7 处注册调用目标、26 处 handler 存储偏移及 handler 常量出现位置。
procedure 表的语义仍是人工重建，脚本没有执行完整的数据流证明。

输出为 `artifacts/device/2026-11-09-linux/rtos-analysis/rpc-contract-1107.json`，逐函数
本机汇编保存在同目录 `rpc-contract-evidence/`。这次 ARM clang 语法检查还覆盖了
三个结构的 32 位大小；这些离线检查都不能代替真机 ABI 验证。

本轮也纠正了两项旧结论：`0xA04A283C` 更符合低功耗路径的 I-cache 锁定/预取用途，
不能当作通用代码缓存同步接口；USB 任务包装 `0xA04B3B94` 会把底层 auto_start
强制为 0，然后按包装参数决定是否 resume。相关报告已同步修正。
