# 1.10.7 原厂看门狗：首次原生执行的恢复边界

2026-11-12。原厂 `t drv wdt` 不能作为同一条 Shell/autoexec 执行流中“后台预置恢复期限，然后执行探针”的步骤：启动调用之后，它立即等待 UART 输入；读调用返回后又停止看门狗，才返回 Shell。应用还有独立的定时喂狗路径，并与测试命令共用同一个硬件对象。因此，目前不能把原厂看门狗算作首次自定义 ARM 进入失败后的独立恢复能力，P11 仍未闭合。

本轮只运行主机上的原始 ARM 指令和明确标注的 mock，没有连接相机、执行设备命令、修改设备 RAM/SD/固件、触发真实复位或生成执行探针。固定 RTOS 镜像为 [rtos-window.bin](../artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin)，基址 `0xA0100000`，SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。使用 Capstone/Unicorn；REA MCP 不可用，没有 REA Evidence ID。

## Shell 命令的实际顺序

`A04AF634` 是 `t drv wdt` 对应的测试 handler。其正常参数路径将秒数乘以 1000，构造 12 字节配置：mode=1、pulse=10、duration=毫秒数、extra=0。关键调用顺序为：

| 固定地址 | 原始行为 | 对预置恢复期限的含义 |
|---|---|---|
| `A04AF6D8` | 调 `A048EC20(config)` | 请求配置看门狗；handler 不检查返回值 |
| `A04AF6E4` / `A04AF6EC` | `r3=FFFFFFFF`，调 `A048EAB8(channel=0, bytes=1, ..., timeout=FFFFFFFF)` | 同一个 handler 等待 UART read；尚未返回 dispatcher，后续 autoexec 行不能经这条顺序路径进入 |
| `A04AF6F0` | UART read 返回后调 `A048EC7C()` | 先请求停止看门狗，handler 同样不检查返回值 |
| `A04AF700` | 返回 0 | 命令成功返回值不能证明启动、读取或停止成功 |

主机模型分别令 start/read/stop 返回 `-1/-1/-1`，原始 handler 仍返回 0。令 start 返回 `-1` 而 UART 尚未返回时，handler 仍到达同一个 UART 等待点。这两个反例排除了以 Shell 返回码或提示文本作为已建立恢复期限的凭据。

模型中的等待场景在 UART mock 入口主动停止仿真；它验证控制流到达该调用且尚未返回，不模拟真实 UART 的无限等待、调度行为或硬件到期复位。也没有据此排除其他并发任务进入探针的可能；这样的路线仍须独立证明入口、所有权和恢复合同。

秒到毫秒的乘法没有溢出检查。参数 `4294968` 在原始指令中得到 `704` 毫秒，而不是所显示秒数对应的期限。这是整数回绕的离线反例，未向设备提交该参数。

## 应用已有喂狗路径

应用启动 `A019D9C8` 调 `A019D198`。后者先调用 `A0195388`，其谓词为：

```text
*(uint8_t *)(*(uint32_t *)0xA078B608 + 8) != 0
```

固定镜像中该指针为 `A1A39C80`，故谓词读取 `A1A39C88` 的一个字节；该字节的设备运行时值未知。主机测试分别提供合成值 0 和 1，没有把镜像初值当作设备当前状态。

谓词非零时，原码初始化 WDT，再由 `A019D13C` 从 `A0561478` 复制配置 `010a00003075000000000000`：mode=1、pulse=10、duration=30000 毫秒、extra=0。之后 `A019D1BC` 调 `A01E6ACC(timer_id=7, callback=A019C3BC)`。即使 start mock 返回 `-1`，该注册仍发生，函数仍返回原来的启用谓词值 1。

`A019C3BC` 对 callback 参数 3 直接返回；其余参数经 `A048EC78` 跳到 `A0497910`，向 `E800C008` 写入 restart key `0x4755`。本轮分别执行参数 0 和 3 的原始指令，在合成寄存器页上核对一次写入和零次写入。

这是一条应用定时喂狗来源，而不是与某次探针进入/返回绑定的期限。如果 Shell 卡住但这条 callback 仍被调度，它可能继续喂狗；尚不能保证 Shell 失效会使看门狗到期。注册函数在本轮是 mock，没有恢复定时器周期，也没有证明其真实调度频率、运行核心或在特定卡死条件下是否继续执行。

## 硬件状态共用且没有恢复快照

固定指针 `A062ACE4` 指向 `E800C000`。Shell wrapper 和应用配置走同一个 `A0497818`；喂狗 `A0497910` 和停止 `A0497928` 也使用该指针。wrapper 的互斥锁并不提供“按调用者保存并恢复原配置”的合同。

`A0497818` 在检查 mode 前就清除 control `+0xC` 的 bit0。合成初始 control=3 的两种场景均先写入 2：mode=0 随后返回；mode=1 继续写 reload `+4`、restart `+8`、pulse `+0x18`，并调 reset-route helper `A0481C8C(1)`。后者在本轮被 mock，因此不能将最终 control=2 当作实际硬件启用后的状态。

`A0497928` 的原码不读取旧状态，直接向 control `+0xC` 写零。测试命令的停止路径因而不恢复应用之前的期限、模式或使能状态；共享硬件本身也不能作为与被测 RTOS 独立的恢复控制器。

这两种 setup 场景只在合成 MMIO 页运行原码，时钟服务固定 mock 为 24MHz，IRQ 和 reset-route 服务也为 mock。没有真实时钟、倒计时、复位域、掉电或多核行为模型。

## 复现与证据

运行 [audit_native_watchdog_recovery_boundary.py](../scripts/audit_native_watchdog_recovery_boundary.py)：

```sh
.venv-reverse/bin/python scripts/audit_native_watchdog_recovery_boundary.py
```

产物目录为 [2026-11-12-native-watchdog-recovery-boundary-run01](../artifacts/verification/2026-11-12-native-watchdog-recovery-boundary-run01/)，其中 [audit.json](../artifacts/verification/2026-11-12-native-watchdog-recovery-boundary-run01/audit.json) 记录 15 条固定指令检查及 12 个场景：5 个命令场景、3 个应用初始化场景、2 个 callback 场景、2 个 setup 场景。另附六份固定地址原始反汇编。

命令场景 mock 字符串比较/转换、打印和 UART/WDT wrapper；应用初始化场景 mock WDT 初始化、启动 wrapper、timer 注册和打印；应用谓词、配置复制和 callback 控制流执行原始指令。feed/setup 执行原始底层指令，硬件寄存器页为合成 RAM，setup 的时钟/IRQ/reset-route 为 mock。

| 文件 | SHA-256 |
|---|---|
| 审计脚本 | `8ac0bfc2fc19608460ac7884d80a8661b610155042e8c66b588c18760ab8ba69` |
| `audit.json` | `d9a0705b50973881a48f2116aea250da2a5779d25432447fa1bafaaadbcec23e` |

本结果收窄的是恢复候选：原厂 WDT 命令缺少后台预置语义，错误不能由返回码确认，共享应用喂狗可能使局部故障不触发期限。还未证明真实复位覆盖哪些域、是否冷启动 RTOS、SD 上的触发文件是否再次执行、失联后能否独立禁用触发以及恢复原状态。首次外部 entry、代码发布和冷回滚仍分别受 P1/P5/P11 限制，参见 [首次执行实现合同](device-1107-first-entry-implementation-contract.md) 和 [RAM 首次进入边界](device-1107-ram-first-entry-boundary.md)。
