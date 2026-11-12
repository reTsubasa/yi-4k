# RTOS 原生命令表与二开入口（独立静态分析）

分析对象：`artifacts/firmware/v1.10.52/_part_lrtos.a9s`，SHA-256 `c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141`，分析运行地址基准 `0xA0100000`。结论来自离线原始字节、Capstone 5.0.7 A32 反汇编，并对命令注册和录像分段函数交叉核对 Ghidra 伪代码，无真机执行；函数名均为分析者标签，不是恢复出的完整原厂符号。

## 最重要的结果

1. RTOS 已经内建一个**动态注册 `t` 子命令的原生函数**，可以作为自定义原生扩展的集成入口：`0xA029E098`。
2. 除此前 38 项普通 Shell 表，已恢复 **4 张额外命令表、113 个处理函数映射**：`t ants` 69 项、`t img` 17 项、`t ipc` 6 项、`t drv` 21 项。
3. 恢复 **22 处直接 `t` 命令注册**，明确区分真正的 `t app` 与 `t ants`。前者是相机应用消息/按键分支树，后者是产品调试和工厂命令数组。
4. 这些接口能复用原厂的消息路由、UI 文字显示、位图处理、录像参数修改、I/O 和 Linux IPC。但内建调试代码可能允许破坏性操作，且有的路径参数检查不完整；目前应把它们当逆向和扩展的实现素材，不是全部可直接面向最终用户公开的稳定 API。
5. 已确认部分命令是**只打印成功的空壳分支**。例如 `set_video_split_size` 的 13 种参数中，12 种只打印并返回 0；只有 `30G` 分支写入一个配置字段。命令名、帮助、日志和返回成功不能证明功能真实生效。

## 证据文件

- `command-tables.json`：113 个名字、处理函数、表偏移、第三字数据。
- `root-registrations.json`：22 处直接注册名、handler 和调用点。
- `seeds.tsv`：入口供 Ghidra 建函数使用；`antscmd_*` 是 `t ants`，不能误称 `t app`。
- `a029e098.asm`：注册函数。
- `a01ab8bc.asm` / `a0245af8.asm` / `a02265b0.asm` / `a04af7e0.asm`：4 个父级分发器。
- `a01a4f34.asm`：`t app` 的整个约 `0x10FC` 字节分支树窗口。
- 其他 ASM 是下面示例接口的局部指令证据。
- 可复现脚本：`scripts/rtos_tables.py`，运行 `.venv-reverse/bin/python scripts/rtos_tables.py`。脚本断言固件哈希后才导出地址。

## `t` 动态命令注册

地址：`0xA029E098`，A32。

根据寄存器使用和调用点，候选原型为：

```c
typedef int (*t_handler)(int argc, char **argv, void *print_callback);
int t_register_command(const char *name, t_handler handler);
```

已确认的指令行为：

- `r0=name`，`r1=handler`；拒绝 NULL。
- `strlen(name) <= 0x13`，即名称最多 19 字节（不含结尾 NUL）。
- 使用 `0xA1446708` 处的 mutex 经 `0xA03BC46C` 加锁、`0xA03BC498` 解锁。
- 使用 `0xA144A73C` 处的池经 `0xA03BC6DC` 分配 12 字节节点，再分配 `strlen(name)+1` 字符串并复制。
- 节点为 `name_ptr+0 / handler+4 / next+8`，末尾 next=0。
- 追加到 `0xA06F3070` 的 next 链。
- 成功返回 0，失败返回 -1。

这条路径**不要求覆盖现有 `t` 命令**。最小二开 payload 可在原厂 Shell/池/锁初始化之后，注册自己的唯一命令名，再通过既有脚本调用。

已确认一个失败路径缺陷：加锁成功后，节点分配失败从 `0xA029E0F8` 跳至 `0xA029E184` 直接返回 -1；字符串分配失败从 `0xA029E120` 跳至 `0xA029E194`，只释放节点，再经 `0xA029E178` 返回 -1。两条路径均未调用唯一的 unlock 调用点 `0xA029E174`。这由完整函数 ASM 和 Ghidra 伪代码交叉确认，可能使后续其他任务的注册阻塞；具体 mutex 递归与任务行为仍需真机验证。包装层应限制注册次数、预留内存，并处理这一原厂错误路径，不能当无条件可靠的通用库 API。

还需确认：初始化完成的精确时机；handler 和 print callback 的最终原型/返回类型；任务上下文；同名命令是否允许及查找规则。不能从静态注册机制直接推导加载器已能在 YI 实机执行。

## 22 个根命令

| 命令 | Handler | 注册调用点 |
|---|---|---|
| sd_shmoo | 0xA04AD6F0 | 0xA0186F30 |
| app | 0xA01A4F34 | 0xA01A6044 |
| fifo | 0xA04501A4 | 0xA01A6058 |
| ants | 0xA01AB8BC | 0xA01ACE64 |
| wi-fi | 0xA01AB7F0 | 0xA01ACE78 |
| pref | 0xA01AB704 | 0xA01ACE8C |
| zl | 0xA01A7ED0 | 0xA01ACEA0 |
| stawpa | 0xA01A7CCC | 0xA01ACEB4 |
| audio-enc | 0xA018B218 | 0xA01ACEC8 |
| audio-dec | 0xA018C4C8 | 0xA01ACEE0（尾跳） |
| imgproc | 0xA01C8E20 | 0xA01C98E0 |
| cal | 0xA01E14FC | 0xA01E168C |
| img | 0xA02265B0 | 0xA022EE28 |
| wifi | 0xA023E8B4 | 0xA023EC18 |
| netevent | 0xA023EC9C | 0xA023EDA8 |
| ipc | 0xA0245AF8 | 0xA0245AD0 |
| hiber | 0xA024769C | 0xA02478E8 |
| dsp | 0xA02DAD40 | 0xA02DCE9C |
| syslog | 0xA02DA9B0 | 0xA02DCEB4（尾跳） |
| ambalink | 0xA03CD3F0 | 0xA03CD4F0（尾跳） |
| boss | 0xA03D16B0 | 0xA03D1AE4 |
| drv | 0xA04AF7E0 | 0xA04AF890 |

这些是本次扫描 A32 直接 B/BL 加附近 MOVW/MOVT 常量恢复出的子集；不是完整根命令集合，也没有证明每条注册路径在用户配置下都执行。

## 四张命令表的真实布局和 ABI

| 父命令 | 表运行地址 / 文件偏移 | 项数 / 步长 | 分发行为 |
|---|---|---|---|
| `t ants` | 0xA056B404 / 0x46B404 | 69 / 8 | 字段 `name,handler`；匹配父函数 argv[1]；处理函数传入 `argc-2, argv+2, print_callback` |
| `t img` | 0xA05978E0 / 0x4978E0 | 17 / 12 | 字段 `name,handler,help_ptr`；第三字均指向空字符串 0xA05A6C90；匹配 argv[1] 后保留原 argc/argv 调用处理函数 |
| `t ipc` | 0xA05A6C18 / 0x4A6C18 | 6 / 8 | 字段 `name,handler`；匹配 argv[1]；处理函数传入 `argc-1,argv+1,print_callback` |
| `t drv` | 0xA0637334 / 0x537334 | 21 / 12 | 字段 `name,handler,0`；匹配 argv[1]；处理函数传入 `argc-1,argv+1,print_callback` |

函数序言/尾调用、比较的计数常量、索引的 lsl #3 或加 12 与原始表内容相互吻合。`t img` 第三字不能沿用普通 Shell 的 next 解释。所有表内目标当前均为 A32；被调用的 libc 目标包含 Thumb，如 strcmp 的 `BLX 0xA04F9744`。

## 可复用的具体实现

| 实现 | 已定位入口与行为 | 二开价值与边界 |
|---|---|---|
| 动态命令注册 | 0xA029E098，如上 | 最小插件与调试入口；需要 loader 和初始化阶段 |
| 应用消息注入 | `t app` 0xA01A4F34；`msg` 分支 0xA01A53C0 起把 argv[2..4] 经数值转换后传 `0xA01E6598(msg,p1,p2)` | 可以复用原厂状态机/消息路由；消息 ID 语义及同步/异步仍需追踪 |
| GUI 事件切换 | `t ants chg_gui` 0xA01AAC5C：`setting` 匹配时 `0xA01321C0(0x1D,0,0)`，其他非 `preview` 字符串进入 `0x1B` 路径，`preview` 返回 -1 | 原厂 GUI 事件队列入口素材；代码行为与直觉命名不一致，不能只按名字写调用 |
| GUI 文本行显示 | `t ants show_str` 0xA01AC08C：数字解析 argv[0]，截断为 uint8，调用 `0xA01996C8(line,argv[1],1)` | 可用于原生状态/调试覆盖显示；该handler仅检查 argc>0却读取argv[1]，包装时必须补参数检查 |
| 位图/字体子系统 | `t ants bitmaps` 0xA01ACD10，分支含 `0xA04866D4`、`0xA04868E4`、`0xA01AC8F8` | 已有原生位图资源查询/显示/枚举实现，适合复用而不是重写显示驱动；布局和调用时序待恢复 |
| 视频参数设置 | `set_video_res` 0xA01AAD28 取第一个参数，转调 `0xA01A63D4(str,print)`；标准 `0xA01A61A4`；照片大小 `0xA01A62BC` | 可以复用原厂配置路径，避免直接硬写模式表；模式枚举/结构及能力校验仍需确认 |
| 文件分段调试命令 | `set_video_split_size` 0xA01A7508 匹配 13 种参数，只有 `30G` 在 `0xA01A76D4` 执行 `strh 0x1e,[pref+0x132]`；其余匹配分支仅打印后返回 0 | **不能据此声称支持多种大小/时长策略**。30G 字段的消费端、单位、持久化与 mux 限制也未确认 |
| 预览控制 | `vf_switch` 0xA01ABB44 识别 on/off 类型字符串后调 `0xA01E659C(0xD8090008,p1,p2)` | 原厂消息路径控制取景，不是直接DMA接口 |
| RTMP 入口 | `rtmp_start` 0xA01AAC4C -> `0xA012FBEC()`；`rtmp_stop` 0xA01AAC38 -> `0xA012F324();0xA012FD20()` | 复用既有 RTOS/网络协调链；返回 0 包装不传递底层错误，不应据此认定运行成功 |
| Gyro 对象访问 | `gyro` 0xA01AB96C 只接受 chip_id；全局 0xA1A355A4 中对象的 vtable/ops+0xC 被调用 | 给出真实驱动对象入口，当前只证明读 chip_id 路径；**没有**证明原始gyro数据导出或IMU型号 |
| 跨核 IPC | `t ipc rpc/rpmsg/rfs` 与 `t ambalink/boss` | 有消息、共享锁和跨核文件接口实现；具体RPC程序号和payload需再解析 |
| 低层硬件和缓存 | `t drv` 下 gpio/i2c/spi/uart/pwm/dma/gdma/cache 等21项 | 可沿handler恢复底层调用与参数结构；不能把存在调试命令等同于所有驱动在当前板上可用 |

## 真正的 `t app`

它与 `t ants` 是两套独立实现。`t app` 采用 `strcmp` 分支树，首级支持：

- `msg`：显式消息号和两个参数送入应用消息路径。
- `key`：up/down/left/right 及释放事件、zoom、set、focus、shutter、shutter_precise、shutter_precise_selftimer、shutter_pes、shutter_burst、record、mode、power、del、start_wifi、stop_wifi、pc 等。
- `jack`：HDMI/CS 插入拔出事件。
- `test`：转入 0xA01A18F8。
- `mem`：打印原厂 heap / non-heap 内存池余量。
- `sensor`：转入 0xA01A46D0。
- `aucodec`：setoutput/setinput/write/read，复用音频 codec 接口。
- `powersaving`：省电控制入口。

Shell 命令不是一个稳定的第三方 SDK，但原厂已经把不少 UI、拍摄、驱动功能组织成可调用的内部服务；二开应先建立受版本哈希约束的 wrapper，补齐参数校验和线程上下文，再逐步提供自己的高层API。
