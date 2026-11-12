# 原厂 EIS producer 接入合同与现有缓冲寿命

本轮找到一个可以**保留原厂表地址和缓冲复用机制**的窄接入候选：`A03119A8` 在原厂 context mutex 内调用 `A032CF38`，视频分支将生成结果放入 context 的原有 scratch；随后原厂 `A0312460` 选 table bank、复制两平面、clean，再由既有 EIS 状态机发布。接入这个生产边界，可以避免另建 warp 源表和回收协议。它不证明新内容格式正确、实时预算满足或设备可部署。

另一个重要纠正：前轮 `17F1B8 → 18B448(0,24)` 的 `24` 是 **filter/controlregs shadow 选择值**，尚未恢复成硬件命令 opcode。原厂 `idspdrv_config` 字符串明确称其为 `controlregs image`；不能把 shadow helper 返回当硬件提交或源表释放屏障。

本轮无设备访问、固件修改、payload 或写入器。脚本 [audit_eis_stock_producer_contract.py](../scripts/audit_eis_stock_producer_contract.py) 固定 CPU/DSP 镜像及 ORC decoder 参考 SHA，结果见 [audit.json](../artifacts/device/2026-11-10-eis-stock-producer-contract/audit.json)。

```sh
.venv-reverse/bin/python scripts/audit_eis_stock_producer_contract.py
```

通过 48 条 CPU 指令检查、10 条 ORC 指令检查、2 条原厂字符串引用、9 个保留调用图边的实际 BL 核对。Unicorn 执行真实 CPU 包装函数的 6 个 producer 场景及 36 个 ring 场景；替身与局限在后文明确列出。

## 原厂 producer 的实参和同步边界

`A03119A8(mode, calc_info)` 验证输入后，以 `mode` 的 pipe/context 字节查 mutex，在 `A0311CF8` 获取 mutex，然后查 context。**`A0311D8C` 的调用及返回点 `A0311D90` 都位于同一次持锁区间内**；释放在 `A0311D9C`。

此处 AAPCS 参数为：

| 参数 | 视频 pipe 0 | still pipe 1 |
|---|---|---|
| `r0` | 原 `mode` 对象指针 | 原 `mode` 对象指针 |
| `r1+00` | `calc_info` 指针 | 同左 |
| `r1+04` | `C+47600` scratch | `0` |
| `r1+08` | `0` | `C+68560` scratch |
| `r1+0C` | `0` | 原厂 work buffer helper 的返回值 |
| `r1+10` | `C+2F04` 几何/阶段对象 | `C+52A7C` |
| `r2+00` | 初始零，生成状态输出 | 同左 |
| `r2+04` | `C+41104` descriptor | `C+60884` |
| `r2+08` | 初始零，阶段索引输出 | 同左 |
| `r2+0C` | `C+41154` 辅助 descriptor | `C+608D4` |

`C` 是原厂 context lookup 返回值，不是固定全局地址。`r1/r2` 向量均在调用者栈上，不能延长其寿命，也不能从包装器异步保留它们。

`A032CF38` 的视频分支调用 `A032B520(0, effective_calc_info, video_scratch, descriptor)`，still 分支调用 `A032A6C4`。视频生成器可见写入 scratch 两平面的 16 位元素，第二平面从 `+1800` 开始；部分分支分别清零 `1800` 字节。不同 profile 使用实际宽度或 `20` 元素的行步长，本轮没有把所有 profile 的完整写集建模为“必定覆盖整 `3000` 字节”。

`A032CF38` 还会处理校准、假网格/旋转、descriptor 几何及阶段状态；它不是一个仅返回两个数组的纯函数。它在下层生成路径后置 `r2[0]=1`，并可能通过 `A0316174` 更新 `r2[2]`，最终仍返回下层返回码。包装器必须保持这些副作用和返回码，不能用“表已填好”替换整个函数的全部职责。

在调用者中，只有 **返回码等于零** 才执行：

1. 把当前 `calc_info` 的 `C0` 字节复制至视频 `C+2F18` 或 still `C+52A90`；
2. 把两个状态输出保存到视频 `C+56378/+5637C` 或 still `C+772D8/+772DC`；
3. 回到解锁路径。

非零返回跳过这些提交。即便下层已写 scratch，失败不能被包装器强制改成成功。

## 真正的 warp table ring 不是两个状态槽

`A0312460` 再次独立获取同一个 context mutex。它和生成函数是**两次分别加锁**，不能假定中间存在跨函数锁，也不能忽略其他调用者可能造成的原厂 interleaving。

对于视频且 selector **恰好等于 `F`** 的原厂 EIS 路径，令：

```text
current = byte(C+56392)
lag     = byte(C+4088A)
count   = word(C+38) & FF
slot    = current - lag + (current < lag ? count : 0)
bank    = word(C+D764C + 4*slot)
X       = bank+D060
Y       = bank+E860
```

这是固定字节 `A0312788..A03127D4` 的有条件回绕，只有索引本身在合法 ring 范围内时才等价于模运算。普通 selector 则通过 `A03089AC` 映射并更新 current；`selector==F` 与 `selector低四位==F` 是两个不同条件。

初始化 `A0308B9C` 将所要求的 bank 数限制到**至少 6**，保存于 `C+38`，逐 bank 分配 `12D20` 字节。这里没有将实际运行 bank 数宣称为固定 6。两槽 `40` 字节状态记录、共享 warp 描述、视频 table bank ring 是三个不同对象层次，不能共用“两个槽”的寿命推断。

选 bank 后，原厂可见顺序为：

```text
copy(X, C+47600,      1800)
copy(Y, C+47600+1800, 1800)
descriptor+08 = X
descriptor+0C = Y
clean(X,1800)
clean(Y,1800)
```

另一个模式分支先复制 descriptor 到栈，再 clean 其中 X/Y 地址；固定字节已覆盖，动态场景将 `A0308B8C` 固定为零，只执行上述直接 clean 路径。selector 低四位为 `F` 时，保持跳过独立 `SET_WARP_CONTROL_CMD` 和辅助命令的原厂行为。后续状态发布仍属于 `A0392CB0/A0385780 → A02C5FD8` 链，不能由包装器单独重复发送。

因此，**在原 producer 内改变一个 invocation-local 输入标量，或在原 producer 成功返回后、原调用者解锁前改变原 scratch 的有界内容**，可以保持后续 X/Y 地址、bank 数、ring 选择、复制、cache clean 与发布机制。这里的含义是“不引入新的外部表生命周期”；它不把原厂未知的 DSP 延迟变成已证明的完成协议，也不授权越过原生执行/恢复关卡。

## 调用者与 profile 限定

保留 `calls.tsv` 中指向 `A032CF38` 的直接调用只有 `A0311D8C`。但 `A03119A8` 有 **8 个** 已核对的直接站点：

| 所属函数 | 调用站点 | 已知上下文 |
|---|---|---|
| `A02DA164` | `A02DA3FC` | 根据原参数 context 组装 `C0` 字节 calc_info；EIS 协调器通过它调用 |
| `A022D820` | `A022E65C/E70C/E7A8/E814/EC14` | 原厂 `imgcmd_warp` 测试命令，含校准文件、1x/2x dzoom 等分支 |
| `A039C140` | `A039C4B8/CC70` | 保留调用图及原 BL 已核对；无完整函数伪代码，本轮未赋予具体 profile 名称 |

这不是完整的间接可达性证明。全局替换 `A032CF38` 会覆盖多个入口；“看见视频 pipe 0”也不足以区分录像 EIS 与测试/其他图像流程。候选 wrapper 合同应同时限定已验证的 EIS 调用链、实际 mode/context 和成功返回条件，不以函数地址单独识别 EIS。

still 分支读取 `mode+1`：值 1 对应 work helper 参数 2，值 2 对应参数 3；`mode+2==2` 选择 `A02CED58`，否则 `A02CECE4`。still 还会拒绝/归零不被支持的非零 theta，并把警告状态 OR 入返回值。本轮两个 still 场景用于检查 mode 分流和 ABI，**不是将视频候选推广到 still**。

## 可审查的离线 wrapper 合同

没有新增 SDK wrapper 或设备补丁；当前合同可用于审查后续实现：

- 调原厂 `A032CF38` 恰好一次，保持 r0-r2 参数向量、callee-saved 寄存器、栈对齐及原返回值。
- 默认透明旁路；仅在已识别 EIS 视频调用和原返回零时，讨论有界内容实验。
- 第一种单变量候选是 invocation-local `calc_info` 的一个数值，例如 `+B8` 的 double theta；保持其原有单位和有效范围，不能只因“标量”就随意设值。它继续使用原厂网格生成、descriptor 和 ring。
- 第二种候选是在成功生成后的原视频 scratch `C+47600` 或 `C+48E00` 中修改一个已验证格式的 16 位项；写入限定于相应 `1800` 平面，且不改指针、布局、尺寸、返回状态或阶段索引。`1800` 是容纳/复制范围，不等于全部有效点数。
- 不替换为持有新地址的异步 source，不新分配/回收表，不覆盖共享描述或 ring 元数据。保留原厂 copy/clean/发布完整调用顺序。
- 新增运算必须有明确预算和失败旁路；真实 loader、代码缓存发布、SMP/IRQ 行为、恢复与停止能力仍独立验证。

`+B8` 之所以是具体候选，是 `A02DA164` 把参数 context 的 `+110/+114` 复制进局部 calc_info，EIS 上游先把其计算的 theta 传给参数更新函数。`A02D9B88` 的 Ghidra 对 VFP double/AAPCS 参数恢复明显不完整，本轮只把其伪代码当线索，不将错误的零 context 伪变量当真实地址或可调用 ABI。

## 与 filter shadow_v2 的关系

现有 [filter shadow_v2](eis-1107-shadow-recorder.md) 观察 `A0392CB0` 内两个 `A0384710` 调用；它处理累计运动量/上一状态，输出还要继续角度换算、X/Y 网格、逐行校正、theta 和窗口参数更新，然后才进入本轮生成边界：

```text
A03937F0 / A0393C00: filter A0384710（shadow_v2）
  → 原厂运动/角度/网格与窗口参数流程
  → A02DA164 组装 calc_info
  → A03119A8 持 context mutex
  → A032CF38（本轮候选边界）
  → 原厂 scratch
  → A0312460 selector F → stock bank copy/clean
  → 既有 EIS 状态发布 → DSP 帧字段 → vertical shadow copy prepare
```

两者是不同算法阶段。shadow_v2 的 input/output、previous canary 或其 88 字节记录，不能直接解释为两平面表，也不能直接拿 filter 的整数返回值写一个 warp 项。若已有 filter 替换满足需求，应继续让原厂生成器消费其结果，避免同时修改两个阶段；本轮 producer 合同提供的是另一个可独立评估的插入层。

## 最小待观测不变量

这些字段用于区分“内容变化”和“所有权/帧错配”，不是设备采集脚本或新部署许可。

| 边界 | 最小字段 | 要确认的不变量 |
|---|---|---|
| CPU producer 入/出 | 原调用链、mode 前 4 字节、resolved context、返回值、r1/r2 向量、原状态/阶段输出；两平面内容指纹 | 同一个 EIS context；输入/输出缓冲与状态地址稳定；原厂只调用一次 |
| CPU SetWarp | selector、current/lag/count/slot、bank、X/Y、descriptor 几何、copy/clean顺序；两平面内容指纹 | 发布内容来自本次成功 scratch；地址仍属于原厂 ring；失败不假发布 |
| CPU 状态发布 | 完整状态槽地址、descriptor 地址、X/Y、tag、发布先后序 | 避免只凭可重复的低 8 位标签关联 generation |
| DSP 帧接收/消费 | context、`654/658` 数组基址与 `65D/65E/65F/660` 游标；帧 `+4/+18/+1C/+1D/+20` 原值 | CPU 地址转换后的表源、帧字段和 generation 确实匹配 |
| DSP shadow 准备 | shadow 基址 `lwz[2A20]`、filter24 地址、源表地址、读入前后内容身份及后续 shadow 使用阶段 | 找到每代最后源读相对下一次 stock bank 覆盖的真实顺序 |

若只沿原厂 producer→原厂 ring 复用，最后一行不必被新 wrapper 发明成一个回收 API；但它仍是验证原厂覆盖间隔、诊断原有内容撕裂和证明自定义时序预算的关键。独立表源或延迟生产若脱离该流程，现有未知 DMA 语义就重新成为必须解决的寿命缺口。

## 验证范围

原码执行场景包括：视频成功、同一 ABI 下改变 theta、两个非零返回、两种 still mode/work helper；36 个 `current×lag` 组合覆盖 6-bank ring 的全部选择。执行真实 `A03119A8/A0312460` 指令，但下列依赖明确替换：context/mutex lookup、mutex、完整生成器、memcpy、cache clean、still work helper、诊断；`A0308B8C` 固定为零。完整生成算法、cache、并发锁、DSP 和 MMIO 均未执行，不能把合成 scratch 数据当原厂算法输出。

ORC 侧继续不解释专有传送指令。普通 helper 已证明：filter24 映射 class2；其 shadow 相对地址为 `lwz[2A20]+21A00+lwz[2A24+24*4]`。这提供更精确的观测地址公式，仍不证明 shadow 提交/复用顺序或最后硬件读者。
