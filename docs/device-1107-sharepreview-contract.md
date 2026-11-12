# YI 4K 1.10.7：SharePreview 注册条件和帧缓冲契约

这轮把之前“服务未找到”的结果继续向 RTOS 内部追了一层。结论来自真机 1.10.7 映像的反编译和此前只读状态快照，没有在本轮执行 `sharepv` 命令。

## 为什么 Linux 查询不到服务

服务程序号是 `0x1000000C`、版本 1，注册名为 `APPLIB_RPC_SVC_SHAREPREVIEW`。RTOS 的 `sharepreview_init` 只有在以下条件都满足时才注册它：

1. `videoanal_is_initialized()` 已成功；
2. 配置中的 memory pool、宽度和高度都非零；
3. `width × height × 3 + 0x38` 字节共享区和 8 字节 reader 区都分配成功。

上述是尝试注册的必要条件。后续审计发现内部注册结果被丢弃，外层仍可写入状态 1，因此状态 1 不能单独证明服务可用；只有随后调用 enable 且回调注册成功才变为 2。真机快照中的 `A1443D18` 为 0，Linux 客户端 proc 3 也返回“找不到服务”，说明采集时处于未初始化、服务不可查的状态，不能据此还原此前全部生命周期。失败调用的预填输出也不是有效状态。

2026-11-10进一步恢复了同池来源、等待方式与注册失败路径，见[初始化依赖审计](device-1107-sharepreview-init-dependencies.md)。

证据和字段汇总见 [sharepreview-contract-1107.json](../artifacts/device/2026-11-09-linux/rtos-analysis/sharepreview-contract-1107.json)。

## 配置和命令

默认配置函数 `0xA02484E8` 写入：

| 偏移 | 默认值 | 含义 |
|---|---:|---|
| `+0x00` | 0 | memory pool，由调用者补充 |
| `+0x04` | `0xB4` | 服务参数 |
| `+0x08` | `0x2000` | 服务参数 |
| `+0x0C` | 2 | 尚未完全命名的配置字 |
| `+0x10` | 2 | VideoAnal 回调 selector |
| `+0x12` | 0 | UpdatePeriod；enable 时不能为 0 |
| `+0x14` | 1024 | pitch/宽度字段 |
| `+0x16` | 752 | 高度 |

`t app test` 的静态处理器把命令写成：

```text
t app test sharepv init
t app test sharepv en
t app test sharepv dis
```

初始化不带两个可选参数时，会把 selector 改为 0、UpdatePeriod 改为 30；带参数时，前两个可选值分别覆盖 selector 和 UpdatePeriod，宽高仍使用默认值。这个入口只在 RTOS `t app test` 分支中存在，不能当作 Linux Telnet Shell 命令。

## 共享帧格式

启用后，VideoAnal 回调收到一个图像描述结构：

- `+0x04`：源 Y 缓冲指针；
- `+0x10`：pitch；
- `+0x12`：width；
- `+0x14`：height。

回调每次递增计数器，只有当 width/height 与初始化配置相同，且计数器恰好等于 UpdatePeriod 时才复制。复制长度是 `pitch × height`，因此它是亮度平面，不是完整 YUV 帧。

RTOS 先 invalidate 源缓存，再复制到三个共享 Y 缓冲之一，clean 目标缓存，更新 active 索引并 clean 0x38 字节头部。共享头部包含三个缓冲的 pitch、width、height、size；指针表位于头部 `+0x2C/+0x30/+0x34`。reader 区为 8 字节，`+0x04` 被用作读取索引。

VideoAnal 回调注册器 `0xA02382F8` 不是按任意整数创建独立队列：selector 1 映射事件 `0x02000004`，selector 2 映射 `0x02000008`，其他值（包括 shell 初始化默认的 0）映射 `0x02000009`。它在 16 个固定槽中登记回调指针和事件码；注销时必须同时匹配两者。selector 的确切业务名称仍需结合当前视频模式日志确认，但它解释了为什么初始化参数会影响 SharePreview 是否收到帧。

当前恢复的头部没有帧序号或时间戳字段。即使成功启用，也还需要把回调时序与 EIS 的 gyro/曝光时间轴另行关联，不能直接用 SharePreview 帧替代高频 IMU 输入。

## 对下一步的影响

SharePreview 不是“Linux 直接打开就能取帧”的设备节点，而是一个依赖 VideoAnal 生命周期的 RTOS 服务。下一步应先在可恢复的真机实验中验证：

1. 初始化是否能在当前取景模式成功；
2. enable 后状态是否从 1 变为 2；
3. proc 1 返回的虚拟/物理地址和三缓冲头部是否稳定；
4. 选择器、UpdatePeriod 和实际回调频率是否匹配当前模式；
5. disable 撤销帧回调后原厂取景和录像是否完整恢复；该路径不释放缓冲或注销 RPC 服务，需要另行建立恢复方案。

在这些条件闭合前，不应把服务初始化写入持久固件，也不应直接修改共享头部或把它作为 EIS warp 输入。
