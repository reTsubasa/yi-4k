# 相机物理快门、语音与预录路由的接入合同

日期：2026-11-10。只分析已保存的 1.10.7 RTOS 镜像，未访问相机、改设置、执行真实 GPIO/编码/文件调用或生成补丁。

已找到真实物理按键源、长短按分类、消息复制和录像 toggle 路线。它们可以约束未来适配器，但**当前不能把原厂短按回调直接当作已经可靠去抖、一次按压一次的 `SHUTTER_SHORT`**：离线执行暴露了一个长按释放后的重复 low 边界。预录后端与固件接入仍未实现。

## 复现与证据范围

```sh
.venv-reverse/bin/python scripts/audit_shutter_trigger_route.py
```

- 脚本：[audit_shutter_trigger_route.py](../scripts/audit_shutter_trigger_route.py)。
- 结果：[audit.json](../artifacts/device/2026-11-10-shutter-route/audit.json)。
- 来源：`artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin`，基址 `A0100000`，SHA256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。
- 执行真实 ARM 指令，使用合成 RAM 和输入，GPIO、定时器、调度器、UI、日志及录像操作都替换为无外部作用的记录桩；未知执行地址立即失败。
- PASS：8 组物理输入序列、5 组消息队列、15 组 recorder 分派、10 组录像状态 gate。共 57 次调用、3654 条指令、213 个 8 字节栈对齐调用边界；R4–R11 和 SP 保持。记录 17 段镜像指纹和 19 条静态指令断言。

这不是实际按键、硬件抖动、IRQ/定时器并发、真实音频或预录视频效果的验证。实际定时单位未独立证明，本文保持 `1500 tick` 表述。

## 物理源及长短按

启动函数 `A018756C` 在 `A0187BAC / A0187BB8 / A0187BBC` 依次注册长按、短按回调并初始化 GPIO。

| 对象/入口 | 已恢复的行为 |
| --- | --- |
| `A0296B7C` | 将长按回调 `A019D10C` 保存到 `A1445470`。 |
| `A0296B8C` | 将短按回调 `A019CF48` 保存到 `A14454A4`。 |
| `A0296B9C` | GPIO13，IRQ 注册参数 mode=4，回调 `A0296A10`；初始化并启用。 |
| `A0296B08` | 定时器对象 `A1445474`，回调 `A02969D8`，初始延时 1500、重装周期 0。 |
| `A06F23A0` | 按下 latch。high 写 1；普通 low 在投递短按之前清为 0。 |
| `A144546C` | 长按释放抑制标志。长按回调结束之后写 1；首次 low 清 0 并返回。 |

`A0296A10(r0=pin)` 只接受 pin13。它通过 `A0482820(pin, out)` 读取 5 字节 GPIO 信息，使用 `out[1]` 的电平。high 设置 press latch，并调用 `A03BC64C(timer,1500,0,1)` 重启定时器。low 先停定时器，优先处理长按释放抑制，否则只有 latch=1 才清 latch 并调用短按回调 `(0,0)`。

`A02969D8` 调用长按回调 `(0,0)`，随后设置长按释放抑制。该键同时承担原厂 F0/快门短按及电源长按；主处理器日志明确写有 “Current shutter button long press, handle power off”。未来接入必须保留长按、电源和普通拍照路径。

离线序列结果：

| 合成调用序列 | 输出 |
| --- | --- |
| low → low，无此前 high | 无事件 |
| high → low → low | 一个 SHORT |
| high → high → low → low | 一个 SHORT；high 会重启定时器 |
| high → low → high → low | 两个 SHORT |
| high → timer → low | 一个 LONG，无 SHORT |
| high → timer → low → low | 一个 LONG，随后一个 SHORT |

最后一行是明确边界：长按释放分支清了 `A144546C`，却没有清 `A06F23A0`，第二个 low 能走普通短按路径。它不证明实际硬件必然产生第二个 low IRQ，但足以否定“此回调在任何抖动输入下严格一次一按”的断言。同样，high/low 抖动形成两个完整周期时会产生两个短按；此路径没有独立的最小稳定时长判断。

GPIO mode4 底层 `A04918A0` 清寄存器 +8 的对应位、置 +0xC 的对应位；当前没有硬件手册或额外寄存器证据证明硬件滤波/去抖效果。定时器回调先投递 LONG 再写抑制标志，IRQ 与定时器之间的并发顺序也未证实。因此真实适配器必须自己满足稳定按压周期和重复事件约束，不能只把该函数地址当成已完成所有去抖工作。

## 事件 ABI、复制与来源

| 来源 | 调用 ABI | 实际物理回调 `(0,0)` 的输出 |
| --- | --- | --- |
| 短按 wrapper `A019CF48` | `r0=a, r1=b` → `A01E659C(E001001E,a,a)`；忽略 b | `E001001E,0,0` |
| 长按 wrapper `A019D10C` | `r0=a, r1=b` → `A01E659C(F0010332,a,b)` | `F0010332,0,0` |
| 原厂通用消息入口 `A01E659C` | ARM tail branch → `A01E656C(r0=id,r1=p1,r2=p2)` | 构造下列 16 字节消息 |

消息是 4 个 little-endian u32：`{id, payload1, payload2, enqueue_tick}`。`A01E656C` 在自己的栈上构造，第四字初置 0；`A01E5DA4` 调用 `A03BC6A0`，把 `A1796810` 中的 32 位 tick 写到第四字。

`A01E5DA4` 使用全局 manager `A13A21C0` 的 +0x40 队列，即 `A13A2200`，等待参数 0。初始化 `A01E627C` 为该队列指定消息大小 16 字节、128 个槽；`A03BC534` 将字节数右移 2 后传给底层，所以每条复制 4 个字。

真实 `A03C3F68 → A03BF3D4` 的成功路径逐字复制到队列环形缓冲区，或直接复制到已等待接收者的缓冲区，然后返回；此零等待发送路径不会把 wrapper 的栈消息指针留到返回以后。脚本实际执行了两种复制路径，验证四个字全部匹配。这只是容器字的复制：对于其他消息中可能存在的指针 payload，不构成所指对象的深复制或所有权转移证据；物理按键 payload 均为 0。

队列满时返回 11，增加失败计数并调用诊断/日志；物理 wrapper 没有重试逻辑。因此已恢复的路线也没有证明 exactly-once delivery，未来适配器必须处理明确拒绝、拥塞和事件丢失，不能将“入队尝试”当成“动作完成”。

**`E001001E` 本身不含物理来源身份。** `antscmd_shutter A01A7CAC`、语音切换 app 的路线及其他软件路径也会生成同一 ID。`F001033B → E001000C` 又合并了语音 START、STOP 和其他录像动作。不得把所有 `E001001E` 都标为物理短按，也不得把共享 `E001000C` 都标为 START。

## 同一 owner 与原厂 gate

真实大主循环 `A019D1E0` 的一轮处理在：

1. `A019DA28 → A01881F4`：取当前 app 对象。
2. `A019DA34 → A01E5F08`：从 manager 接收消息到主循环的栈缓冲区。
3. `A019DA54 → A019CA44`：事件跟踪。
4. `A019DA5C → A0199A14`：锁屏、LCD 唤醒等预过滤；负返回值分支在 `A019DA64`。
5. 主循环按事件分派；app 消息回调取自 `current_app + 0x28`，ABI 为 `r0=id,r1=p1,r2=p2`。

`A01E5F08` 对普通队列的接收地址为 `A13A2200`；还处理其他优先级队列及 pending 子消息。所以该 owner 是可用的串行化边界，不能仅依赖来自不同上下文的两个 callback 的表面先后关系。

短按 `E001001E` 在 `A019E390` 转到 `A019F4E0`。在 app 收到之前还过滤固件更新/恢复 app、固件上传、录音/语音采样、低电启动及其他活动状态；常规透传最终在 `A01A0F70..A01A0F84` 调用 `app+0x28`。锁屏/唤醒与这些 gate 必须继续有效。单独绕到 recorder toggle 会跳过它们。

长按 `F0010332` 在 `A019E8F0` 转到 `A019EFD4`，进入长按/关机分支。在任何预录状态都应走原厂长按路线。关机前如何安全停止生产者、固定的历史和 MP4 收尾，是未来后端的独立退出合同；本报告未实现关机延迟或改写关机行为。

## recorder 模式与真正的 start/stop

recorder app handler 是 `A0113808`，初始化时 `A0FB336C = A069CBD8`。表的第 0 槽是 `A012C220`（video record toggle），第 3 槽 `A012BA98` 是 photo shutter；不能按 `shutter` 名字误选 photo 入口。

真实 app 的 `E001001E` 分支先要求 `A069B3C4 & 4`，再处理 `A1055D7E / A1055D7F` 特殊 UI、RTMP 状态及 `A0113664(1)` gate。常规路径：

- `A1055CFA < 4`：转成 `E001000E` 拍照，原样保留两个 payload。
- `A1055CFA >= 4`：转成 `E001000C` 录像，原样保留两个 payload。
- `E001000C` 在 app 中调用 table[0]，即无参数 `A012C220()`。

脚本实际执行 workmode 0..8 和 UI/RTMP/readiness 阻挡分支。该范围说明短按不能在所有相机模式都被接管为预录 START；初期应明确约束受支持的视频模式，其他模式原样交回原厂。

`A012C220()` 根据 `A0FB334C` 及标志调用 `A0FB3364` 指向的操作 dispatcher。dispatcher ABI 是 `r0=op,r1=0,r2=0`：

| 状态 | 实际派发/限制 |
| --- | --- |
| status0 idle，正常视频组 | 先 op0x3A 检查，成功后 op0x12 START。 |
| status1，尚无实际开始标志 | 不派发 STOP，日志 “Record not actually start, block record stop”。 |
| status1，`A069B3C8 & 4` 且 `A069B3CC & 0x80` | op0x13 STOP。 |
| status1，mode5 且 `A069B3C8` 符号位为 1，或偏好对象 +0x77 为 3 | 原厂其他允许 STOP 的条件。 |
| status5，VF ready | 先 op0x3A，成功后 op0x58 VF→REC。 |
| 格式化、录像 busy、其他保护标志 | 阻止或走原厂错误处理。 |

因此 `status==1` 不能单独作为 C router 的 `COMMIT_OK` 或“可以 finalize”的凭据。适配器需要后端对真实开始、选中历史资源固定及正式录制的完整确认；op 派发或 toggle 返回 0 都不代表 MP4 已开始/完成。

## 与语音 START/STOP 合流的具体边界

语音映射仍以 [voice-class-semantics.md](voice-class-semantics.md) 为准：START=`1003/F0010338`，STOP=`1004/F0010339`。早期 handler 分别在 `A019EF90 → A01B22E0`、`A019E60C → A01B25E4`；应在命令身份尚未丢失时接入。原厂语音 STOP 的 status1 检查也不是整个实际停录完成合同。

未来适配器必须同时兑现：

1. **来源与周期**：在 BSP 源仍可区分物理/软件的时候记录来源及按压周期；完成稳定释放判断，长按后不再产生同一周期 SHORT。不改造来源运输时，后面的普通消息没有足够信息恢复这些身份。
2. **同一 owner**：GPIO/定时器/识别回调只投递类型化输入；C router 的输入、arm/disarm、commit/stop 回执都交回主循环同一 owner 顺序处理。不得在 ISR 直接修改 router。
3. **先 gate 后接管**：保持原厂锁屏、唤醒、上传、采样、app/mode 等 gate；只对后端已 arm 且支持的视频上下文接管短按/语音。若 gate 消耗原始输入，本轮不能再触发预录。
4. **保留原始消息**：原厂 `{id,p1,p2,tick}` 与新增类型/来源/周期元数据独立保存；不能覆盖 payload 或把 software-generated `E001001E` 误当物理。PASS_STOCK 时按原载荷交回一次，CONSUMED 时停止该条原厂路径，不能同时 commit 和原厂 toggle。
5. **独立语义**：语音 START 保持幂等；明确 STOP 保留为 STOP；物理短按在已确认 RECORDING 时为 STOP；LONG 总是透传。禁止在合并后的 `E001000C` 处反推方向。
6. **时间与所有权**：原厂 32 位 enqueue_tick 不能直接声称是 C 接口的 64 位微秒采集时间。适配器需要与视频同源的单调时钟，并管理异步 token、资源固定、收尾、确认失败和 UNKNOWN；超时不能冒充失败。

可继续使用 [camera-capture-trigger-router.md](camera-capture-trigger-router.md) 中纯 C reducer 和现有 13068 项宿主/ARM 语义断言。本文没有给出安全可直接写入真机的地址补丁：来源运输、稳定按压分类、完整 gate 接续、后端确认和 shutdown 协作还需实现并独立验证。所有真实写入与风险评估仍由主任务统一处理。
