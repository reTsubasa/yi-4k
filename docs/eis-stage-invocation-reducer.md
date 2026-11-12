# EIS 同一次调用的三阶段关联验证器

2026-11-11。新增的 C 接缝把 [三阶段错误传播](eis-stage-failure-contract.md) 的发现变成可执行检查：**Calc 返回零、ready 字节为一，都不再被单独当成本次表准备成功。** 只有同一 invocation 的 Calc、SetWarp、GetWarp、候选状态四份回执按顺序到齐，返回值与表身份一致，才能得到 `PREPARED`。

源码是 [yi4k_1107_eis_stage_trace.h](../sdk/yi4k_1107_eis_stage_trace.h) 和 [C 实现](../sdk/yi4k_1107_eis_stage_trace.c)。它不安装 hook、不执行相机代码、不读固件地址，不是已经部署的记录器。原生入口、I-cache/SMP、撤销与恢复条件仍未闭合。本次没有访问相机或改写固件。

## 实际实现

调用方先以 context 建立唯一 token，再按四个阶段传入回执。四个独立有界槽允许交错；同一槽严格要求 `Calc → Set → Get → Candidate`，缺阶段保持不完整，越序或重复进入错误状态。失败和错误是粘性的，不会因后续 ready 或新回执转成成功。只有显式 finish 后槽才可复用，旧 token 失效；32 位 token 耗尽后停止分配，不回绕复用。重新初始化要求生产者静止，导出方必须另外绑定 capture epoch，以免把新旧 lifetime 混合。

表身份包含 bank、X/Y 地址以及两平面内容摘要。Calc 记录生成内容摘要；Set 必须有零返回、两平面 copy 和 clean 调用回执，以及与生成摘要匹配的实际 bank/X/Y；Get 和 Candidate 必须仍指向完全相同的表身份。bank 地址可能被下一 invocation 重用，因此每份表快照还有独立 `table_token` 来源字段，它必须与事件 token 相同。只改事件 token、继续携带上次表快照 token 的输入会被拒绝，即使地址和字节相同。

这些字段都是调用方提供的证据。**模块不能发现恶意或错误的调用方同时伪造事件 token、table_token、摘要或 copy/clean 标记。** 真实记录器必须在实际生成/Set/Get 调用现场关联并保留来源，不能在导出时根据地址推断 token。这轮用 fixture 构造回执，没有在原函数调用现场运行新的观察器。

`observations` 中的 clean 标记只表示观察到 clean 调用，不证明真实 cache 完成或远端可见性。`PREPARED` 只表示 CPU 三阶段回执一致，不证明 DSP latch、编码帧对应、实际发布、实时预算或 EIS 已可替换。当前 reducer 明确只支持必经 Get 的 `A17045DA==0` 分支；不把另一条 debug-gated 分支省略 Get 的正常行为强行判为相同合同。

## 验证

[validate_eis_stage_trace.py](../scripts/validate_eis_stage_trace.py) 编译同一份 C 为宿主动态库与 ARM Cortex-A9 ELF。验证器逐操作比较返回值和全部 244 字节状态；ARM 每次调用检查 R4–R11、SP 和返回点，检查链接后没有未定义符号或 relocation。

正式结果：[validation.json](../artifacts/device/2026-11-11-eis-stage-trace-run03/validation.json)。**33 例通过**，初始化从 A5 填充的内存开始，确认全部表字段清零：

| 输入 | 检查的结果 |
| --- | --- |
| 原 ARM 零分支的 18 例 | Calc `0/1/FFFFFFFF` × 无故障/Set lookup 失败/Get lookup 失败 × enable `0/1`；失败不能被原 coordinator 后续旧表和 ready 升格为成功 |
| 同地址、旧内容摘要 | Get 被拒绝为 stale |
| 相同 bank/地址/字节、跨 invocation table token | Get 被拒绝为 stale |
| 错 bank 地址、缺 clean 回执 | 被拒绝为 stale |
| 缺 Get、缺候选、重复阶段、context 不符 | 越序/重复错误或明确不完整 |
| 候选快照带非零 status，包括同时带旧 table token | 错误保持粘性，不接受为成功；候选快照不具有可忽略的函数返回值 |
| 两个 invocation 交错 | 各自独立完成，状态不串线 |
| 四槽容量满、finish 后复用、旧 token、token 耗尽 | 不覆盖活动槽，不接受旧 token，不回绕重用 |

18 例重新调用冻结的 `eis_stage_failure_contract.py` 原 ARM 仿真，并把其确切返回值、copy/clean 事件和新/旧表地址结果组装成 C 回执。生成 payload 是原 harness 的已知合成内容，两个摘要是 fixture 的 CRC32。**这不是读取真实 RAM 的 digest，也不是现场 producer 证据；CRC32 不提供抗碰撞或真实性保证。** 原 ARM harness 的生成返回、锁/context、逻辑 copy、cache 调用和地址转换模型边界原样保留。

复现需现有 Clang、ld.lld、Unicorn 和 pyelftools，不安装依赖或配置 MCP：

```sh
.venv-reverse/bin/python scripts/validate_eis_stage_trace.py \
  --output /tmp/yi4k-eis-stage-trace-independent
```

输出目录必须不存在。正式目录同时保留实际编译的 ARM ELF、对象文件、宿主库、链接脚本、编译命令、全部回执操作和源哈希。`/tmp/yi4k-eis-stage-trace-dev01` 是 ctypes 把最大无符号 token 当 signed int 的失败开发运行；改正函数返回类型后 `dev02` 通过。`run01` 保留早期 31 例结果，父线程 review 后补上候选非零 status 拒绝与初始化全部表字段，再产生 `run02`；`run03` 增加脏内存初始化断言和逐操作回执归档，不把旧结果追溯为新范围通过。

下一步真实 observer 仍需在安全原生入口、资源所有权和撤销/恢复闭合后，绑定实际 invocation/context、调用返回点、内容快照寿命及后续发布。这个 reducer 先防止主机验收错误地把“ready + 原生成成功”拼成一次成功，不为设备写入提供执行许可。
