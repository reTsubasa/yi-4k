# YI 4K 1.10.7：主控制任务描述符与生命周期

## 结论与证据范围

`0xA01E5BD4` 是 Host Control Manager 的主任务入口。它通过一个静态描述符进入
正常相机控制循环或固件更新控制循环；这不是一个独立的插件任务启动器。
修改描述符的第一个字段会替换整个控制循环，不适合作为最初的可返回探针。

本报告根据已捕获的实体机 1.10.7 RTOS 字节、旧 Ghidra 导出和函数体哈希比较重建。
没有读取当前运行期对象，没有修改指针或重启任务。
可复现命令：

```sh
.venv-reverse/bin/python scripts/device_execution_context.py
```

映像 SHA-256 为
`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
脚本核对 13 个同体函数，另导出 5 段人工划界指令区域。结构化结果见
[task-trampoline-1107.json](../artifacts/device/2026-11-09-linux/rtos-analysis/task-trampoline-1107.json)，
原始指令见 [execution-context-evidence](../artifacts/device/2026-11-09-linux/rtos-analysis/execution-context-evidence/)。
人工范围不是 Ghidra 新发现的函数，旧样本同体也不代表运行期状态相同。

## 描述符与调用约定

在已核对的前 8 字节中，布局是两个函数指针：

```c
struct hcmgr_descriptor_prefix {
    void (*entry)(uint32_t task_arg); /* r0 原样传递；原厂 entry 未使用该参数 */
    void (*request_exit)(void);
};
```

完整描述符大小、后续字段未恢复。**第二个字段是回调，不是元数据。**

| 描述符 | entry | request_exit | 观察到的用途 |
|---|---|---|---|
| `0xA06CD13C` | `0xA019D1E0` | `0xA019C3A8` | 正常相机主控制循环 |
| `0xA06D1810` | `0xA01BD5A4` | `0xA01BD570` | 带 FW_HANDLER 日志的更新控制循环 |

入口跳板从 literal `0xA01E5C04` 取得管理对象地址 `0xA13A21C0`，然后执行：

```text
r3 = *(0xA13A21C0 + 0x1AC)   // 指针槽 0xA13A236C
if r3 != 0:
    r3 = *(r3 + 0)
    bx r3                      // 尾调用，保留原 task 的 LR 和 r0
else:
    tail-call stock log
```

`0xA01E5CE8` 在 mutex `0xA13A22F0` 保护下写入描述符指针；传入 NULL 会进入
断言/中断关闭死循环。它既不复制描述符，也不验证两个函数指针。
入口跳板不获取这个 mutex，因而不能把 setter 的锁解释为热替换执行的完整同步协议。

## 启动时序与任务资源

`0xA018756C` 的启动尾部按以下顺序执行：

1. `0xA01E6258` 清零从 `0xA13901C0` 开始的 `0x12220` 字节。
2. `0xA0187BC8` 比较保留的启动条件；小于等于 0 选择 `0xA06CD13C`，大于 0
   选择 `0xA06D1810`。
3. `0xA0187BDC` 调用 attach/setter `0xA01E5CE8`。
4. `0xA0187BE0` 调用初始化函数 `0xA01E627C`。

原 Ghidra PARAM 引用把其中一个候选写成 `0xA06DD13C`，与原始 `movwle/movtle`
指令不符；真实字节物化的是 **`0xA06CD13C`**。旧文档把 `0xA0187BD8` 称为
selector 入口也不精确：它是条件 `movtgt`，实际 attach 调用位于 `0xA0187BDC`。

初始化建立队列、同步对象后，创建以下任务：

| 项目 | 原厂值 |
|---|---|
| task object | `0xA13A20EC` |
| name | `AppLib Host Control Manager` |
| priority | `0x6E` / 110 |
| entry / arg | `0xA01E5BD4` / 0 |
| stack / bytes | `0xA13901C0` / `0x10000` |
| auto_start | 1 |

`TaskCreate` 调用位于 `0xA01E638C`；随后 `0xA01E63A0` 才调用
`TaskSmpCoreExclusionSet(task, 1)`，没有额外 Resume。这条顺序不能作为“运行前已设置
核心限制”的保证。创建失败会打印并继续后续路径，最终仍把管理对象的初始化字节设为 1。

上述清零区域包含原厂栈和状态；不能重复调用清零/初始化来触发自定义 entry，也不能
把这段区域或两份描述符占用为扩展内存。

## detach 实际是发退出消息

`0xA01E5D44` 获取同一 mutex，取 `descriptor+4` 并 `blx`，返回后释放 mutex。
它不把描述符指针清零，不直接 terminate/delete 任务，也不创建替代任务。

两个 request_exit 回调字节行为相同：调用 `0xA01E6598`，发送
`(message=0xF0010001, param1=0, param2=0)`。该别名转入 `0xA01E653C`，构造
16 字节消息，使用 `0xFFFFFFFF` 等待值交给 `0xA01E5DA4` 入队。后者补时间戳并
设置通知；因此 request_exit 返回不能证明主循环已经退出。

正常和更新循环均在收到 `0xF0010002` 的分支调用 detach；处理 `0xF0010001`
的分支执行退出路径。这里存在完整的原厂状态和消息约定，不能把 detach 当作
“暂停任务、换函数、继续”的 API。函数名依据断言字符串和代码行为恢复，未做真机时序观测。

## 对二开的实际约束

- 这条路径可用于解释主应用和更新模式如何启动；它没有提供新的外部任意 entry 来源。
- 改 descriptor+0 会接管主控制任务；探针直接返回也会让原厂主循环缺席。
- 修改 descriptor+4 会影响退出过程，并在持锁状态执行自定义回调；它也不是合适的首次探针。
- 若以后制作启动补丁，应在保留原控制循环的前提下单独创建扩展任务；资源必须独立分配，
  创建成功后设置核心排除，再 Resume。
- 首次执行入口、动态代码发布和内存所有权依然是独立未完成项；本报告不交付可运行 hook。
