# YI 4K 真机 1.10.7：EIS 定位与只读观测

主机日期：2026-11-09。对象为 `YDXJ2_V13LW`，构建 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`。

**本轮把旧样本的 EIS 定位核对到了用户这台机器，并首次读取了 RTOS DRAM 中的相关状态。** EIS 核心函数的已知函数体相同；三个 warp 接口的差异全部落在相同字符串的地址装载上。SharePreview 的 RPC 查询实际失败，返回服务未找到。随后通过只读 `/dev/mem` 映射读取状态，先核对两段真实代码字节，再读取固定范围的数据。

这还不是替换防抖算法的验证：没有执行自定义 RTOS 代码、修改算法参数、启用共享预览或启动录像。DRAM 读取缺少跨核缓存同步，不能称为可靠的实时遥测。

## 1. 固件与分析边界

- 完整 SYS_SW 逻辑分区 SHA-256：`e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6`，32 MiB。
- 分析窗口：分区偏移 `[0, 0x725000)`，7,491,584 字节；SHA-256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- 映射基准 `0xA0100000`：reset 分支、向量 literal 指向同一镜像内地址，以及本机 MMU 初始化函数共同支持。不是只沿用旧固件的基址。
- `0xA0295CF8` 建立所选 RTOS DRAM 区间的 `PA = VA - 0xA0000000` 映射。其函数体与旧样本相同；它也把 `0xA0824F68` 用作后续映射区间起点，支持结构化映像在文件偏移 `0x724F68` 附近结束。分析窗口额外保留页尾，不把映射边界解释成升级包长度。
- reset 清零范围来自本机偏移 `0x22C/0x230`：`[0xA0FB3000, 0xA1A5117C)`，在独立工程里建立未初始化块。
- 尾部存在接近全 `FF`、夹有少数清零位的内容；本轮没有判定其成因，也没有把“最后一个非 FF 字节”当成可执行代码末尾。

对旧工程的 11,035 个已发现函数，按其原有 body ranges 比较：**9,940 个函数体字节相同，1,095 个不同**。这是跨版本字节比对的范围，不能当成本机完整函数数目；相同函数也可能引用变化的数据或调用变化的依赖。

证据：[比对清单](../artifacts/device/2026-11-09-linux/rtos-analysis/comparison-manifest.json)、[逐函数结果](../artifacts/device/2026-11-09-linux/rtos-analysis/function-comparison.json)、[重点结果](../artifacts/device/2026-11-09-linux/rtos-analysis/focus-comparison.json)。

## 2. 本机 EIS 入口

名称为分析标签，地址为本机镜像静态 VA。

| 入口 | 地址 | 本轮核对 |
|---|---|---|
| EIS 控制器 / 模式和 RowTime 初始化 | `A037D9E0` / `A037FE20` | 已知函数体逐字节相同 |
| gyro 采样处理 / 逐帧处理 | `A0385780` / `A03852F8` | 相同 |
| 旋转滤波 / XY 校正网格 | `A0384710` / `A038EA48` | 相同 |
| 按行补偿 / 旋转与网格协调 | `A0391CF0` / `A0392CB0` | 相同 |
| 主任务 / 第二算法任务 | `A0396F34` / `A0396EE8` | 相同 |
| EIS 调试分发 | `A0394CC0` | 相同 |
| SOF / EOF 接收 | `A037BA48` / `A037B998` | 相同 |
| warp calculate / set / get | `A03119A8` / `A0312460` / `A031282C` | 分别 74 / 4 / 3 处 A32 字变化，全部为相同字符串的地址变化 |
| gyro info / open | `A047F2A0` / `A047F0F8` | 相同 |
| gyro read 间接入口 | `A047EDE4` | `[A047EDE4,A047F0F8)` 的字节相同，本轮补建函数 |

三个 warp 函数的核对检查了每一个变化字：均为 `MOVW` 的低半地址变化，随后 `MOVT` 构成的旧/新指针指向内容相同的以 NUL 结尾字符串。没有在这三个旧函数体边界内发现其他变化；这不证明它们的全部依赖相同。详见 [逐处证据](../artifacts/device/2026-11-09-linux/rtos-analysis/warp-differences.json)。

`[A0757A00,A0757E00)` 参数数据窗口以及 `A078B0BC` 的 gyro 操作表也与旧样本相同。实际读到的 RTOS gyro 对象指针为 `A078B0BC`，与镜像中的操作表一致。原有 [EIS 链路说明](eis-reverse-engineering.md) 因而可以作为本机继续恢复方程与数据格式的依据，但仍不能按表直接写内存。

本机完整自动反编译在 `artifacts/device/2026-11-09-linux/rtos-analysis/full/`；重点函数及引用在 [focused/](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/)，不覆盖旧工程。

本轮自动分析识别 10,993 个函数，10,985 个完成反编译、8 个失败；另有 39 个重点函数全部完成导出，其中包括此前漏掉的 [gyro read 间接入口](../artifacts/device/2026-11-09-linux/rtos-analysis/focused/a047ede4.c) 和预览回调。完整工程的自动覆盖数与重点导出分开记录，不能相加后宣称完整源码已恢复。自动覆盖见 [coverage.json](../artifacts/device/2026-11-09-linux/rtos-analysis/full/coverage.json)。

## 3. 真机读取了什么

连接仍为 `192.168.42.1:23` 的既有 Telnet。读取程序使用相机自带 Python 2.7 和 Linux `/dev/mem`，以 `O_RDONLY` 打开、`PROT_READ` 映射固定 DRAM 范围，不写缓存控制寄存器、不调用 RTOS 驱动。

第一种 `lseek/read` 方法在首段代码读取时返回 `EFAULT`，没有读到数据；随后改用只读 `mmap`。正式读取状态前，强制比较 `A01000FC` 和 `A0391CF0` 各 64 字节，均与捕获镜像完全一致；不匹配便停止。

| 字段候选 | VA | 读到的值 | 解释范围 |
|---|---|---|---|
| RSC enable | `A0757A68` | 1 | 对应调试 case 3 使用的字段；不能独立证明当前每帧执行 RSC |
| ExtraGyroPhaseDelay | `A0757AB0` | -2 | int8；不在此擅自解释为毫秒 |
| ucode gyro delay | `A0757AB1` | 10 | 原代码以 `Set ucode gyro delay ... ms` 输出此值；未观测实际 DSP 生效相位 |
| RscScale | `A0757AC4` | 1 | 调试 case `0x52` 的存储字段；不是已完成比例单位标定 |
| TimeShift | `A0757B44` | 2 | case `0x51` 对应字段，单位待追踪 |
| ExtraRSCPhaseDelay | `A17045E8` | 0 | int8 |
| FrameRatePerSec | `A17040B4` | 30 | 原代码的整数帧率结果 |
| FrameLengthLines | `A1704134` | 4550 | sensor 模式结构内字段 |
| RowTime | `A1704140` | 约 `7.333333542e-6` 秒 | float；原代码乘 `1e9`，日志也明确输出 RowTime×1e9 |
| SharePreview status | `A1443D18` | 0 | 与 RPC 服务未找到一致 |
| gyro 操作表指针 | `A1A355A4` | `A078B0BC` | 与镜像中表位置一致 |

`4550 × RowTime ≈ 33.366668 ms`，对应约 `29.97003 fps`，与整数帧率 30 相容；这是结构解释的一项一致性检查，不是图像/IMU同步标定。

第二次读取还取得了 gyro 环形数组区域：长度字段为 132、next-write 为 0，当前驱动输出候选 `[32747,32790,32826]`。这些不是 dps，也不能把它们当成此次读取时刚采到的 IMU 样本。处理入口的早退 gate `A1702CBC` 读到 0；两次间隔约 97 秒的重叠内存窗口字节完全相同。**可能是该处理路径当时没有运行，也可能包含跨核缓存旧值，目前无法区分。**

该快照中的 gyro 描述结构 `A1702CC0+0x3C` 为 `32768`，与本机 getter 设置的 level shift 一致。减去它会得到 `[-21,22,58]`，这仅撤销数值平移；轴交换、极性和灵敏度仍须按数据契约处理，不能把结果标为物理角速度。

因此本轮证明的是：能读取本机相应物理 DRAM，代码指纹匹配；尚未证明可以可靠、连续、无丢样地观察运行中 EIS。没有对 RTOS 调用 clean/invalidate，也没有试图从 Linux 清缓存来制造“新鲜”数据。

证据：[首次成功快照](../artifacts/device/2026-11-09-linux/rtos-readonly-mmap-snapshot/session.json)、[包含环形区的第二次快照](../artifacts/device/2026-11-09-linux/rtos-readonly-mmap-snapshot-2/session.json)、[失败的 read 尝试](../artifacts/device/2026-11-09-linux/rtos-readonly-snapshot/session.json)。每次均保存实际目标程序与原始 Telnet 输出。

## 4. SharePreview：服务入口存在，当前未注册

实际运行了一个受库哈希约束的最小 RPC 客户端，使用本机 `libambaipc.so`，核对 ARM 调用 ABI 后只请求 proc 3（GetStatus）。返回：

```text
can not find svc for program 268435468
get_status_rc = -1
destroy_rc = 0
```

`268435468 = 0x1000000C`。接收变量保持预填的 `0xDEADBEEF`，不是服务返回的状态；没有继续发 GetMemInfo。应解释为**本次 client/binder 未找到该服务**，不能解释为 RTOS 回了 status=0。后来的直接 DRAM 读取才独立读到 status=0。

RPC 原型候选为：

```c
void *ambaipc_clnt_create(uint32_t host, uint32_t program, uint32_t version);
int ambaipc_clnt_call(void *client, uint32_t proc, const void *in,
                     uint32_t in_bytes, void *out, uint32_t out_bytes,
                     uint32_t timeout_ms);
int ambaipc_clnt_destroy(void *client);
```

程序 `0x1000000C`、host 1、version 1：proc 1 为 24 字节 MemInfo；proc 2 是 Enable，有状态修改；proc 3 为 4 字节 Status。Linux 示例与服务注册/状态/初始化/复制函数已在本机固件核对。

初始化会分配 `3×width×height + 0x38` 字节共享区，另加 8 字节 reader 区，并注册服务。默认构造器给 1024×752，约需 2.20 MiB 的 Y 图像缓冲。它要求 VideoAnal frame handler 和原厂内存池已就绪。

进一步恢复的配置布局：

| 偏移 | 类型 | 含义 |
|---|---|---|
| `0x00` | pointer | 内存池 |
| `0x04 / 0x08` | u32 | RPC 服务任务参数，默认 `0xB4 / 0x2000` |
| `0x0C` | u32 | 默认 2，语义尚未完整恢复 |
| `0x10` | u16 | frame-handler 选择参数 |
| `0x12` | u16 | UpdatePeriod，回调计数间隔 |
| `0x14 / 0x16` | u16 | 分配时 width / height，默认 1024 / 752 |

Shell 路径经过 `t app` 的 `test` 分支。静态恢复的形式为 **`t app test sharepv init [selector period]`**，不是 `t app sharepv init`。它的两个可选参数写到 `0x10/0x12`，**不是图像宽高**。无可选参数时写 selector=0、period=30。该命令尚未在设备执行；不能直接贴进 Linux Telnet Shell。

回调还要求图像宽高匹配配置，并在计数值**恰好等于** period 时复制、随后清零计数；默认 30 表示计数间隔，不是 30 fps。若到阈值那一帧尺寸不匹配，会错过此次 equality 条件，需要专门处理。这些限制使默认示例不能直接承担 EIS 的逐帧视觉输入。

共享头部有 active/reading 索引、三组 pitch/width/height/size 和三指针；尚未在其中找到可直接用于 IMU 对齐的帧时间戳。取图还须验证 pitch×height 与分配容量、索引所有权、缓存可见性和实际更新率。

证据：[实际 RPC 会话](../artifacts/device/2026-11-09-linux/sharepreview-read/session.json)、[实际 Linux ARM 反汇编](../artifacts/device/2026-11-09-linux/ipc-evidence/libambaipc.so.selected.asm)、[SharePreview 客户端反汇编](../artifacts/device/2026-11-09-linux/ipc-evidence/example_sharepreview.text.asm)。

## 5. 下一轮验证与二开顺序

后续已执行一轮连续观测，结果见 [真机 EIS 连续观测与 API 故障定位](device-live-eis-observation.md)：采集 340 个样本，帧回调持续推进而部分处理字段保持旧值；本次 API 录像未确认启动，尚不能做录像同步标定或 RSC 效果评价。

1. **先解决数据新鲜度。** 在确定的实际录像区间，重复只读采集，观察采样 gate、计数器、环形区和帧事件字段是否变化。若始终不变，沿本机 MMU cache 属性和共享内存协议解决可见性；不能拿静止 DRAM 快照做 gyro 标定或把 Linux 轮询延迟算作 RTOS 采样周期。
2. **恢复输入契约。** 当前数组按 X/Y/Z 三路、每路 132 槽及尾部控制字排列；采样函数会把驱动输出左移 8 位，另有 bias 数组。要核实写入过程、wrap、偏置、轴方向、灵敏度与时间戳，再做有界采集。只读快照可能撕裂，不应默认每个槽均属于同一帧。
3. **确认 RTOS 命令执行和日志回传。** Linux root 已就绪，但没有证明 Linux 可以任意执行 RTOS Shell。现有 SendToRTOS 是固定事件，util_svc 的执行方向相反。可准备一次性 SD autoexec 观测脚本，先做 IPC 标记和只读日志，再考虑初始化 SharePreview；原厂 `S99postboot` 钩子在本机不存在。
   目前已把本机 1.10.7 的 `loadbin/savebin/t` handler 和四张 `t` 子命令表从真实 RTOS 窗口重新解析，见 [1.10.7 命令表对齐](device-1107-command-tables.md)。这确认了静态入口地址与旧分析镜像一致，但仍没有证明任意 payload 可以执行。
4. **进行 RSC 消融。** 在可靠遥测及可恢复的控制入口建立后，比较相同模式/曝光下的 EIS off、原厂 EIS、EIS 保留但 RSC 关闭三个状态；记录角速度/帧号/相位/网格与提交超时。每个修改必须经原厂控制路径或已验证 hook，不能从此表生成裸地址写入脚本。
5. **再替换轨迹与网格。** 若问题集中于 RSC，相位与行模型优先；否则恢复轨迹滤波与网格几何。现代四元数方案仍须满足原厂 DSP 截止时间。曝光模糊不可能靠这次算法替换恢复细节。

本轮问题清单：

| 问题 | 状态 |
|---|---|
| 本机固件身份、映射与旧 EIS 定位关系 | 已核对，范围见逐函数/逐数据结果 |
| 本机 EIS 参数和模式字段是否可观察 | 部分回答：读到 DRAM 快照，缓存新鲜度未验证 |
| SharePreview 是否可直接取帧 | 本次不能：binder 未找到服务，初始化前提已进一步恢复 |
| 连续 gyro、准确图像时间戳、网格提交流 | 未验证 |
| 已找到果冻根因或改善效果 | 未验证 |
| 自定义 RTOS loader / 算法替换 | 未执行 |

## 6. 复现

离线比对：

```sh
.venv-reverse/bin/python scripts/device_rtos_compare.py
GHIDRA_DIR=/path/to/ghidra_12.2_PUBLIC JAVA_HOME=/path/to/jdk25 bash scripts/analyze_device_rtos.sh
```

真机只读探针（输出目录必须是新的，避免覆盖证据）：

```sh
python3 scripts/device_sharepreview_read.py --output /path/to/new-rpc-observation
python3 scripts/device_rtos_snapshot.py --output /path/to/new-rtos-observation
```

RPC 客户端会创建和释放短期 socket/线程；内存探针会建立和关闭只读映射。两者都会消耗少量运行资源，不是零扰动性能测量。两者都不启动录像或预览服务，不写相机文件。

Linux SquashFS 另外保留了 [真实文件与 ELF 清单](../artifacts/device/2026-11-09-linux/linux-inventory/summary.json)。主机解包只缺 `/dev/console` 与 `/dev/null` 两个设备节点，普通文件与符号链接已提取；未混用旧内核二进制来报告本机内核身份。
