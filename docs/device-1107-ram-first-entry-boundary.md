# RAM 临时命令入口与首次取指边界

2026-11-10。**通过普通命令表临时指向 RAM 的思路，在固定 CPU 分发 ABI 上成立，但还没有可执行的真机探针。** 新增两个证据：实际 `t ants` dispatcher 已在 Unicorn 下确认 handler 参数和返回 ABI；补查整份镜像的半字对齐 T32 指令缓存编码后，没有发现新增可复用的 Thumb 缓存 helper。首次取指和缓冲所有权仍未建立，不能据此进行 RAM 补丁写入。

本轮仅离线读取固定 1.10.7 镜像，在合成 RAM 中替换虚拟表项。没有连接相机，没有写设备RAM/分区/SD，也没有生成可执行 payload、设备写入器或补丁升级包。

## 真实 dispatcher 的调用和返回

`t ants` 表为 `A056B404`，69项，每项name/handler两个32位字。`A01AB8BC` 按名字比较，匹配后执行：

```text
r0 = original_argc - 2
r1 = original_argv + 8
r2 = original_print_callback
r3 = table[index].handler
restore r4..r10/LR
bx r3
```

因此一项表内 handler 确实可以承接标准命令参数并直接返回原dispatcher调用者。它不是把用户输入的地址当作函数指针；若要改变entry，必须先修改表项，这本身就是尚未获准实施的设备写入。

[离线审计](../artifacts/device/2026-11-10-native-ram-entry-audit/audit.json) 使用镜像中原始dispatcher，在Unicorn中任取一项合成替换为固定测试stub，验证 `argc=1`、`argv`指向第三参数、print callback保留、r4..r11/SP保持和r0返回值。随后仅在合成RAM内恢复原指针。没有执行被选中的原厂handler，也没有将它推荐为真机牺牲项。

这补齐“表指针在执行器侧何时被读取、如何转交控制流”的 CPU ABI，但没有证明：运行期表确实可写、目标页当前权限、是否有另一任务同时调用、热更指针的生存期、缓存可见性或真机恢复。

## T32 缓存候选补查

此前 [代码发布报告](device-1107-code-publication.md) 扫描全部4字节对齐A32字。现在增加对整份捕获窗口每2字节的T32候选解码，筛选 `MCR p15` 的 `c7,c1`/`c7,c5` 组，得到7处字节匹配：

| T32候选地址 | 解码 | 实际判断 |
|---|---|---|
| `A04A42D6` | `MCR p15,0,r7,c7,c5,0` | 跨实际A32 ICIALLU/TLB指令边界 |
| `A04A43CE` | 同组、r4 | 同上 |
| `A04A442E` | 同组、r5 | 同上 |
| `A04A4492` | 同组、r6 | 同上 |
| `A04D05E2` | `c7,c5,5`，Rt=PC | 不是目标缓存操作、没有可调用函数证明 |
| `A04DC632` | `c7,c1,7`，Rt=PC | 同上 |
| `A04DF232` | `c7,c1,6`，Rt=PC | 同上 |

前四项是同一原码被错位重新解释：真实A32从候选前2字节开始，为 `MCR ... c7,c5,0` 后接 `MCR ... c8,c5,0`，位于已经确定的MMU初始化函数。没有入边或函数上下文证明这些位置会按Thumb执行；将其强行作为entry会破坏后续解码和返回。

原A32的10处指令缓存失效仍位于BOSS恢复、MMU初始化或低功耗锁定路径。没有新增普通、独立、可返回的invalidate helper。此结果只限定捕获镜像内的所选编码，不排除未捕获或动态代码。

## 为什么“先跳进payload，再清指令缓存”仍缺第一步

已有 `loadbin` 和 `write*` 不会维护I-cache；`t drv cache` 只覆盖D-cache。若新payload一开始就包含invalidate指令，CPU仍必须先正确取到这几条新指令。当前未证明目标行不存在旧I-cache副本，也未证明写入者和执行者的核心、别名、D/I-cache发布顺序。

代码页尾 `[A064E214,A064F000)` 在存储镜像中全零，只说明捕获时的静态填充。它不证明运行期无人借用、未被取指、未被DMA写入，也不证明被复制的RAM与储存镜像始终相同。[启动扩展原型](device-1107-static-boot-extension.md) 的96字节包装走启动装载和映射时序，不能直接推导热加载到同一区域也安全。

即使把第一段payload控制在单cache line，也没有解决首次取指是否新鲜、共享核心执行同步和pointer发布顺序。把BOSS/MMU函数内的失效指令截成“gadget”同样缺原栈/寄存器/返回合同；本轮没有建议跳入其内部。

## 下一步需要的具体证据

动态RAM路线进入真机实验前仍需同时确定：

1. 分配或明确预留的代码/结果缓冲，包含运行期所有权和生命周期。
2. 写入代码之前已存在、无需先执行新代码的发布入口，或已验证的冷启动加载路径。
3. 写入者、执行者、内存属性、D-cache clean、I-cache失效及DSB/ISB顺序。
4. 临时handler表项的单一所有者、原值快照、无并发调用、返回后恢复和重启清除的实际证明。
5. 入口只写有界结果，不依赖未知logger锁、文件系统或EIS；崩溃/未返回时存在独立恢复。

当前还不具备可供用户批准的真机写入方案。可以继续纯离线准备ABI包装和撤销清单，但不能把合成pointer恢复描述为真机恢复闭环。

## 复现

```sh
.venv-reverse/bin/python scripts/audit_native_ram_entry.py
```

输出 [audit.json](../artifacts/device/2026-11-10-native-ram-entry-audit/audit.json)，固定RTOS SHA `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，含完整69项表、7处T32候选、A32重叠解释和合成dispatcher参数/返回检查。Unicorn不模拟真实缓存与多核一致性，不能把CPU控制流通过等同为设备可执行。
