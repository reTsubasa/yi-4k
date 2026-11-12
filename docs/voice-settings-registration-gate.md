# 本机 1.10.7 语音设置注册与启用入口

本报告只分析已保存的普通 YI 4K 固件 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`，不连接相机、不写设备、不启用任何偏好。RTOS SHA-256 固定为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`；不同固件不能直接复用地址。使用本地 Ghidra 导出、Capstone 和 Unicorn，没有 REA MCP Evidence ID。

## 结论

当前 API 不暴露 `voice_control` 的直接原因已经收窄为**本构建的固定注册表没有该项**。不是 msg3 在输出时根据机型隐藏了一个已注册的语音项。内部 voice preference ID 是十进制 84，而该表恰好从 ID 83 跳至 85。msg1、msg2、msg3、msg9 的设置路径共用这张表，因此改请求格式、传内部 ID、改变 `dev_functions` 或重试普通设置请求，均没有在本次已恢复路径中得到启用入口。

这里的“本构建遗漏注册”描述镜像的事实；**没有恢复源工程的 `#if`、产品配置或型号生成规则**，不能声称已找出厂商为什么省略它，也不能把补回表项视为已验证方案。

原生启用函数、GUI 调用者和 `t ants vc_test` 调试 handler 仍存在。GUI 具有静态调用路径，但物理界面的可见性和可操作性未验证；调试 handler 会持久化设置、绕过正常状态检查且忽略动作失败，没有形成可推荐的安全远程启用命令。准确口令“开始录像”/“start recording”、有效音频、识别结果和并行预录仍全部未验证。

## 固定设置注册表

`A016326C` 的全部函数是 `mov r0,#0x60; bx lr`，返回固定 96。表起点 `A06A5FA4`、每项 100 字节：

| 偏移 | 内容 |
| --- | --- |
| `+0` | 内部 preference ID |
| `+4` | 权限/元数据 |
| `+8` | 内联 API key |
| `+0x58` | getter |
| `+0x5C` | options handler |
| `+0x60` | setter |

96 项中没有 `voice_control`，也没有 ID `0x54`。相邻记录为 `A06A79D0: ID83, screen_auto_lock` 和 `A06A7A34: ID85, dewarp_support_status`。表的完整 key、ID、handler 指针及 SHA-256 已输出到 audit JSON。`A014EECC` 在成功修改 voice 偏好后传 `0x54` 给通知函数 `A0155800`，因此 ID84 的对应关系不是根据缺号猜测。

初始化 `A01549FC` 第一段会从菜单描述符派生权限等字段；本段写表项 `+4/+0x48`，随后构造分辨率/画质等选项缓存。它不把缺失的 voice key 或 handler 插进这张固定表，也不改变固定计数。缺少注册与权限禁止应分别判断。

`dev_functions` 的 getter `A0156718` 调 `A019317C`，后者直接返回 `0x2307`（8967）。本次设置表枚举/查找不以该值作为动态 voice gate。没有据此推断每一位的产品含义。

## msg3 枚举和 msg9 无应答

`A0166274` 是 msg3 全设置响应构造器。它从 `A06A5FAC`（表项 key）开始，取 `key+0x50` 的 getter，成功后以该 key 添加值，步进 100 字节，共 96 次。这个循环没有按机型、权限或 `dev_functions` 跳过已注册 key；getter 缺失时仍添加占位值，getter 报错则终止整条响应。**前述是循环本身的行为，不排除 getter 对值的模式依赖，也不推广到其它独立协议入口。**

`A01647FC` 是 msg9 选项查询。正确请求字段是 `param`。查找成功后调记录 `+0x5C` 的 options handler；查找失败走 `A01648EC..A0164920`：打印 `No preference matched`、释放解析 JSON 和请求缓冲，然后返回 `-1`，**没有调用应答发送器 `A023FA94`**。JSON 解析失败或缺少 param 则会发 `msg9/rval=-7`，两者不能混为一谈。

Unicorn 执行原始 ARM 控制流，保留固定计数和真实表，声明替换 JSON、字符串、日志、分配和 handler 等依赖：

| 请求/路径 | 合成运行结果 |
| --- | --- |
| msg9 `param=voice_control` | 查满表，返回 -1，不发送 reply，不调 handler |
| msg9 `param=not_a_setting` | 同样无应答，证明这是通用未匹配分支 |
| msg9 `param=video_quality` | 到达真实表登记的 `A015B08C`（handler 本身用 stub） |
| msg9 JSON 解析失败、缺少字段 | 各发一条 `msg9/rval=-7` |
| msg2 `type=voice_control` | 返回 `msg2/rval=-1`，没有 setter |
| msg1 `type=voice_control` | 返回 `msg1/rval=-13`，没有 getter |
| msg3 | 顺序生成全部 96 个 key，没有 voice 项 |

这也解释既有保存记录的静默超时：[events.json](../artifacts/device/2026-11-10-feature-api/events.json) 于 `2026-11-10T01:53:10.810881+00:00` 发正确 msg9/param 请求，约六秒后发送关闭会话，期间无 msg9 收包，关闭正常应答；[readonly.json](../artifacts/device/2026-11-10-feature-api/readonly.json) 保存了 timeout 与语音项缺失。采集器保存的 events/msg3 是摘要，不能把它当完整 wire 全键清单。更早错误使用 `type` 的 msg9 试验未用作这里的语音超时证据。离线控制流与既有观察相容，尚不是新的设备调用验证。

## 原生 enable 的真正边界

正常设置链是 `A016AD30 → A014EECC → A0148AAC`，其中前者以 GUI 选项表生成 `on/off`。原生叶函数 `A0148AAC`：

1. 仅接受字符串 `on/off`；相同偏好时直接成功，带输出指针则设置 same=1。
2. 改变前调用 `A011F758`，非零返回 -36；调用 `A011F21C`，零返回 -21。
3. 修改 `(*A1055CD4)+0x136`，调 `A018C6D8` 保存偏好。
4. 通过 `A0FB3364` 动作函数发送 on=`0x93`、off=`0x94`。本叶忽略动作函数返回值。

该叶没有型号、feature bit 或是否登记 API 的检查。上层对 -36 还可能安装延后 apply hook，因此不能把叶的立即失败直接等同完整 GUI 行为。12 组原始叶执行覆盖原偏好/目标偏好和 vf/ready 状态；callback 故意返回 -123，仍证明叶会返回成功，故**偏好读回成功不能证明语音任务真正启动**。

应用动作表 `A01282FC` 的 `0x93/0x94` 确实分别到 `A0129640/A012A100`，调用 `A01184C8/A0118564` 排队 `F0010334/F0010335`。该证据比仅发现任务存在更接近 enable，但没有执行事件任务、音频初始化或模型推理。

## 现成入口逐项判断

| 入口 | 已恢复事实 | 仍缺什么 |
| --- | --- | --- |
| 普通 API msg1/2/3/9 | 只有固定表，voice key/ID84 缺失 | 没有在该入口发现可启用命令；不代表全部协议或固件任何入口都不存在 |
| 本机触屏 quick setup | `A0138F84` 的 group `0x1A`、object `0x15E` 调 `A016AD30` 切换；`A01321C0` 对相同对象画 on/off/disabled 状态 | 物理界面是否显示对象、点击是否送达；未操作设备 |
| 旧式 setup 菜单 | `A06A339C` 的 `MENU_SETUP_VOICE_CONTROL_SWITCHER`、末槽 `A06A33FC=A012D5BC`；后者调 `A016AD30` 并在失败时恢复 GUI 字节 | 当前 UI 是否仍使用/能到达该记录，不能因表存在宣称菜单可用 |
| RTOS `t ants vc_test` | 69 项 ants 表中确有登记 `A056B5CC`，handler `A01ABD80` | 可用的安全 RTOS shell 传输与实际语音效果；不是 Linux shell 的普通可执行文件 |

quick setup 更新/点击的局部阻塞来自 `A011F084/A011F0C8` 的应用运行状态，涉及 `A0FB334C`、`A069B3C8`、`A1055CFA`，没有找到这两个函数按产品型号禁止语音的判断。这个有界结论不排除 GUI 资源装载/布局创建阶段隐藏对象，因此不能由它推导当前屏幕一定有语音按钮。

`vc_test` 解析数字，只把数值 1 视为开启，所有其它数值走关闭；它直接写偏好并持久化、发送 `0x93/0x94`，绕过正常 vf/ready 检查。三个合成执行在 vf=1、ready=0 且 callback 返回失败时仍保存并返回 0。没有运行该真机命令，没有生成设备执行脚本或以任意内存写替代它。

## 下一入口和复现范围

进一步离线工作应优先追 group `0x1A` 的 GUI 资源对象 `0x15E` 创建/隐藏位置，以及新旧 setup 表的实际装载者；它们能回答普通本机界面是否可达，而不是继续猜 `dev_functions` 位。若找到可达界面，后续也仍需按原厂状态机确认 enable 完成、麦克风有效和实际内置词表。当前没有得到可安全远程启用原厂语音的普通命令，也没有给出任何可烧录补丁。

```sh
.venv-reverse/bin/python scripts/audit_voice_settings_gate.py
```

脚本通过固定镜像校验、96 项表解析、28 条指令断言、两条应用动作表断言、7 个 API 合成用例、96 项 msg3 枚举、12 个 native leaf 用例和3个调试 bypass 用例；输出 [audit.json](../artifacts/device/2026-11-10-voice-settings-gate/audit.json) 与 [audit.asm](../artifacts/device/2026-11-10-voice-settings-gate/audit.asm)。JSON 声明全部 stub 和边界，记录20个选定函数的原码/反编译 hash；函数体反汇编附录也含 Ghidra body 范围内的嵌入数据，不把线性解码每一行都当可达指令。它不模拟真实缓存、多核、IO、语音模型或音频。

本报告不更改 [原可行性说明](voice-trigger-feasibility.md) 中关于准确口令、音频有效性和预录统一动作的未完成状态，也未修改共享 roadmap。
