# YI 4K 1.10.7：EIS 滤波边界影子记录器（离线集成候选）

日期：2026-11-10。本记录器只提供可编译、可审查的主机侧 C/A32 集成候选，不修改 RTOS 镜像、不安装 hook、不连接相机。真实部署还需要完成自定义代码入口、代码/数据缓存发布、缓冲区所有权和回滚闭环。

## 已恢复的两个调用点

真实 1.10.7 `A0392CB0` 指令显示两个调用点都使用相同 AAPCS 形态：

```text
r0 = 2                 // mode，两个调用点均为常量 2
r1 = 当前窗口累计量     // 有符号 32 位
r2 = &环形区上一状态槽   // A0384710 解引用 [r2]
BL  A0384710
r0 = 原厂返回值
```

- `0xA03937F0` 返回后把 `r0` 写回对应环形状态槽，并继续做角度换算。
- `0xA0393C00` 返回后把 `r0` 写入 `A170AF38`，随后继续做角度换算。
- 两处都要求包装器保留 `r0`，保持 8 字节栈对齐，不能在原函数返回后释放或覆盖 `r2` 指向的状态。

对应原始窗口在 [a0392cb0.asm](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0392cb0.asm)，两个调用点分别位于 `0xA03937F0` 和 `0xA0393C00`。

## 记录协议

[头文件](../sdk/yi4k_1107_eis_shadow.h)定义固定协议：

- 128 条容量，单条 80 字节，64 字节头，总大小 10,304 字节；
- 每条包含序号、调用点标识、mode、input、previous 地址和值、原厂 output、调用前后 tick、adaptive count、limit/gain 和自适应参数；
- `commit` 字段最后写入 `sequence+1`，零表示未发布；
- 固定容量写满后不覆盖旧记录，`dropped_full` 计数并在达到 `UINT32_MAX` 时设置饱和标志；
- 单次 `LDREX/STREX` 竞争失败只设置 `busy_seen`，不伪造精确丢调用计数；
- 记录器不使用文件、RPC、printf、动态分配或等待循环；
- 原厂滤波调用始终执行一次，返回值直接返回给调用者；
- `tick` 允许为空，存在时以 `YI4K_EIS_SHADOW_TICK_VALID` 标记；记录器不解释 tick 单位。

缓冲区和来源表由调用者拥有，在生产者可能运行时必须保持常驻。初始化函数只应在生产者静止时执行；读取端需先停止/确认生产者，再按 `commit` 和 `committed` 做一致性校验。当前没有实现导出、停止或回收路径。

## 集成边界

[C 核心](../sdk/yi4k_1107_eis_shadow.c)中的 `yi4k_eis_shadow_dispatch` 是可调用包装；[A32 veneer](../sdk/yi4k_1107_eis_shadow_veneer.S)分别传入 site=1/2。它假定一个由最终集成层绑定的 `yi4k_eis_stock_filter` 符号；本仓库没有把该符号重定位到设备地址，也没有生成可刷写文件。

默认来源表中的地址仅是当前 1.10.7 的观测候选：

| 来源 | 地址 | 用途 |
|---|---:|---|
| tick | `0xA1A3A528` | 记录前后计时值 |
| adaptive count | `0xA170AF89` | 共享 8 位小运动计数 |
| limit | `0xA170AFEC` | 原厂输出限幅，BSS 运行态值 |
| gain | `0xA0757B54` | signed8 滤波 gain |
| adaptive enabled | `0xA170AF88` | 自适应分支开关 |

这些地址会随固件变化，来源表不能跨版本复用。任一来源对象的地址和所有权未验证前，应保持记录器 disarmed；包装器遇到来源表指针为空、协议头不匹配、未 armed 或竞争失败时直接调用原厂函数。

## 离线验证

[验证器](../scripts/validate_eis_shadow.py)使用本机真实 `A0384710` 函数、Clang ARMv7 编译产物和 Unicorn：

- 512 组单次调用覆盖两个 site、普通/自适应参数、正负输入、限幅、边界和随机值，原厂 output 与主机参考一致；
- 检查 stock 函数每次调用一次、previous 指针未被写入、SP 和 r4-r11/d8-d15 恢复；
- 填满 128 条后额外 7 次调用全部保留原厂 output，`dropped_full=7`，不覆盖最后一条；
- 预占 lock 时只旁路记录器，原厂函数仍执行一次；
- 测试专用嵌套 stock stub 在锁持有时递归进入另一个 site，验证 `busy_seen`、原厂两次调用和输出保持；
- 运行时只使用临时 synthetic 地址 ELF，验证后删除；没有生成设备补丁。

复现：

```sh
.venv-reverse/bin/python scripts/validate_eis_shadow.py \
  --output artifacts/device/2026-11-10-eis-shadow/validation.json
```

结果保存在 [validation.json](../artifacts/device/2026-11-10-eis-shadow/validation.json)，本轮 `wrapper_cases=512`、`mismatches=0`、`dropped_full=7`、嵌套竞争检查通过，设备访问为 false。

## 尚未证明的事项

- 记录器入口尚未通过真实 loader 或启动包装执行；
- `LDREX/STREX` 只提供有界尝试，未在真实 SMP/IRQ 竞争下校准；
- 任何 C 调用或来源读取的实时成本、1 ms 截止时间、任务栈和 cache/barrier 行为仍未知；
- `A170AFEC` 的实际 limit、tick 单位和所有来源地址未通过本记录器确认；
- 记录器没有解决两个调用点的原厂调用拓扑、双核所有权、停止/导出和卸载生命周期；
- 影子记录验证成功不等于可以替换算法，也不等于真机稳定。

## v1 到 v2 的边界记录扩展

当前实现固定为 v1：记录 80 字节、头 64 字节、总缓冲区 10,304 字节。v1 的 `commit` 位于记录偏移 76，记录中没有调用后的 `previous_after`；因此 v1 导出不能直接满足最终替换 gate 的 previous canary 要求。仅在主机 JSON 中补一个同名字段也不能把现有 80B 记录变成 v2 证据。

后续 v2 采用 88 字节记录、128 条容量和总缓冲区 11,328 字节。前 76 字节保持 v1 的数据字段布局；偏移 76 的 legacy commit 始终写零；偏移 80 新增 `previous_after`，偏移 84 使用 `commit_v2` 作为唯一发布标记。生产者先写完 v1 数据和 `previous_after`，再以 release 顺序写 `commit_v2=sequence+1`。v2 头部声明 `version=2`、`record_bytes=88`；旧 v1 读者因头部不匹配而拒绝整个缓冲区，不能误读 legacy commit。

该布局已在 [头文件](../sdk/yi4k_1107_eis_shadow_v2.h) 中做静态大小和偏移断言，并有离线 v2 wrapper 和验证器；设备入口、导出器和 producer-quiescent 真机采集仍未实现。`verify_eis_boundary_trace_export.py` 和边界 gate 要求 `record_bytes=88`；任何 80B v1 导出都会被明确阻断。只有 v2 wrapper 经过原生执行关卡并取得 producer-quiescent 导出后，才可讨论真机采集。

离线 v2 C/A32 候选位于 [v2 SDK](../sdk/yi4k_1107_eis_shadow_v2.c)，由 [验证器](../scripts/validate_eis_shadow_v2.py) 编译并把真实 A0384710 字节载入 Unicorn。报告 [validation.json](../artifacts/device/2026-11-10-eis-shadow-v2/validation.json) 覆盖 512 组 wrapper 调用、legacy commit 保持零、`previous_after`、`commit_v2`、满缓冲和旁路原厂调用；它仍不证明 loader、cache、SMP、实时预算或真机执行。

