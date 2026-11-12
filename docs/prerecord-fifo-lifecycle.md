# Virtual FIFO 生命周期与 native consumer 候选

本轮把 0x58-byte 创建配置和 Create/Peek/Remove/Delete 的关键失败状态恢复为可复现原码检查，并实现了可编译的单 owner consumer。**原厂 Delete 不能提供 callback 静止保障；真实稳定读取保护、callback 路由和静止屏障仍未接通，因此尚不能在相机上运行一分钟预录。**

原码脚本：[prerecord-fifo-lifecycle.py](../scripts/prerecord-fifo-lifecycle.py)，结果：[audit JSON](../artifacts/device/2026-11-10-prerecord/prerecord-fifo-lifecycle-audit.json) 与 [ARM 窗口](../artifacts/device/2026-11-10-prerecord/prerecord-fifo-lifecycle-audit.asm)。native 实现：[yi4k_1107_fifo_consumer.c](../sdk/yi4k_1107_fifo_consumer.c)、[ABI/合同头文件](../sdk/yi4k_1107_fifo_consumer.h)。验证：[validate_prerecord_fifo_consumer.py](../scripts/validate_prerecord_fifo_consumer.py)、[结果 JSON](../artifacts/device/2026-11-10-prerecord/prerecord-fifo-consumer-validation.json)。

全程固定原 RTOS 镜像 SHA-256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，没有访问设备或改变 Android、roadmap。

## 1. UVCd 的完整配置与资源来源

原厂默认初始化 `A04509B0` 先清零 0x58 bytes，再设置 `+4=128`、`+8=1`。UVCd 创建前缀 `A0233570..A02335C4` 再覆盖四项：

```text
+00 = [A13C82D8]   主编码 stream ID
+04 = 0x2000       8192 个 32-byte descriptor
+08 = 1            virtual 模式
+0C = A0233434     UVCd 自己的 callback
+10..+57 = 0       保持原厂默认值
```

脚本执行了该原始配置构造前缀，在 Create 调用前停止，逐字节比较全部 88 bytes。前面的 UVCd 缓冲查询未执行；其初始寄存器和主 stream 全局由测试构造。另完整执行了容量为 8 和继承 base 容量的原 Create，避免把测试 RAM 当成实际 256 KiB 的可用设备内存。

完整布局如下。字段名仅对已有用途给名，未知字段保留 opaque，未把 `+10` 擅自当作 callback userdata。

| 配置偏移 | 已恢复的读取/用途 | UVCd 值 |
| --- | --- | --- |
| `00 / u32` | stream ID；与 base handler `+8` 比较 | 主 stream 全局 |
| `04 / u32` | descriptor 数量；virtual 的 0 可继承 base `+88` | 8192 |
| `08 / u32` | 0 为 base，非零为 virtual 分支 | 1 |
| `0C / u32` | 必需 callback 地址，存到 handler `+A4` | `A0233434` |
| `10 / u32` | 原样存 handler `+A8`，具体业务含义未恢复 | 0 |
| `14 / u32` | 存 `+AC`；通知计算使用 `+AC+1` 为模数 | 0，即每项通知 |
| `18 / u32` | 此 Create 内未见读取 | 0 |
| `1C / u8` | 存 `+B0`；base remove-on-write 分支使用 | 0 |
| `1D..1F` | 未见读取的 padding/opaque | 0 |
| `20 / u32` | 存 `+B8`，base payload 区间起点参与回收计算 | 0 |
| `24 / u32` | 存 `+BC`，与 `+B8` 组合计算 payload 区间 | 0 |
| `28 / u64` | 低 word 存 handler `+C8`；历史模式按时间比例计算时读取双 word | 0 |
| `30 / u8` | 是否进入历史 descriptor 回填分支 | 0 |
| `31 / u8` | 历史分支 selector，明确有 1/2/3/4 分支 | 0 |
| `32..37` | 此 Create 内未见业务读取 | 0 |
| `38 / u64` | 历史模式参数；mode2 读取低 word 作为条目上限，其他分支有时间比例算术 | 0 |
| `40 / u8` | 回填后的 descriptor type 筛选值，存 handler `+C0` | 0，但零历史路径最终置 `C0=FF` |
| `41..47` | 未见业务读取的 padding/opaque | 0 |
| `48 / u64` | 部分历史模式回写选中 PTS，找不到时写全 1 | 0，零历史不改写 |
| `50 / u64` | 部分历史模式回写选中范围的换算值 | 0，零历史不改写 |

原码完整执行另核对了 `+10/+14/+1C/+20/+24/+28` 到 handler 的映射。历史模式只固定原始指令，未作为产品功能执行验证；本候选统一使用与 UVCd 一致的 **零历史 virtual** 配置，不尝试让 Create 自动回填一分钟。

每个 handler slot 为 0xF8 bytes。virtual slot 来自 `A1966194`，数量 `A19661DC`；base table 来自 `A1966190`，数量 `A19661E0`。创建器先占用 slot，再按 stream 查 base，之后从最多 64 项的 registry `A196608C` 分配 ID。descriptor pool 通过 `A029A7D8` 分配，字节数为 `capacity<<5`、对齐 32，输出指针和 pool 资源 token 分别存 handler `+80/+A0`。8192 项仅 descriptor 存储就需要 256 KiB，不包含额外 pool/handler 开销。

**stream 匹配本身不验证 base 的 in-use flag。** 构造 inactive base 但保留相同 stream ID，原 Create 仍可返回成功并绑定它。因此真实 backend 还必须先验证主 base FIFO 已启动且有效；仅有主 stream ID 不足以创建。

## 2. Create 的失败不是可靠回滚

下表来自完整原 Create 的执行，锁和分配器是明确测试替身：

| 分支 | 返回 | 输出 handle | 原码留下的状态 |
| --- | --- | --- | --- |
| callback 为零 | -1 | 不改写 | 在占 slot 前返回 |
| 无 virtual slot | -1 | 写零 | 未占 slot |
| 找不到同 stream 的 base | -1 | 不改写 | slot `+C` 已置 1；两锁释放，未清 slot |
| registry 已满 | -1 | 不改写 | slot 已占用；两锁释放 |
| descriptor 分配失败 | -1 | 写零 | slot 已占用且 registry 已写入；两锁释放，未移除 registry |
| 成功，零历史 | 0 | 返回本 virtual handler | 独立 descriptor 队列；读写索引均从 base 当前 write index 开始 |

没有给这些失败路径补造资源回滚。UVCd 原调用还忽略 Create 返回值，所以不能直接复制其错误处理。native 候选在失败后进入 `CREATE_UNCERTAIN`，保留任何返回 handle，禁止自动重试、Delete 或猜测 registry 修复。真实系统需要独立验证的资源预检和失败修复方案；新建一个 owner 对象并不能自动清理原残留。

## 3. Peek、Remove、Delete 的返回和副作用

| API | 已执行确认的结果 | 调用方必须处理的边界 |
| --- | --- | --- |
| Peek | 有项：0 + borrowed descriptor 指针；无指定条目：-8 + NULL；write-read 超容量：-9 + NULL | 指针仍指向 virtual descriptor queue，函数返回前已解锁，不能视为稳定 payload lease |
| Peek | `index>=capacity` 可返回 0 + NULL；invalid flag 为 -1 且输出不改写 | 先清输出指针，同时检查返回值和指针；本候选固定 index0 |
| Remove | 成功后清零被移除的 descriptor，推进 u64 read index；请求大于现有数会 clamp | 请求 1 不是保证一定移除 1；外层需保证单 owner 和稳定队首 |
| Remove | 后台回收消息发送失败时可返回非零，但 cursor 已推进 | 原码用例返回 71 时已 +1，禁止按“失败未发生”重试 |
| Remove | invalid flag 返回 -1，尚未推进 | 仍不能把所有非零返回归为该早退分支 |
| Delete | 正常释放 pool、清 handler `A0/80/C/8`、unlock、清 registry，返回 0 | 前提是活的唯一 handle，没有重复删除或 stale alias |
| Delete | pool free 失败返回 -1，保留 handle/registry，并释放两锁 | owner 保留 handle，进入失败状态，不自动重试 |
| Delete | registry 已为空或 in-use flag 为零时可返回 0，且该早退路径没有执行两次 unlock | 0 不是无条件成功/幂等保证；不能向原函数传重复删除或已失效的 handle |

Delete 还会在 ID 大于 63 时进入原厂 assert/永久自跳。原始 API 不验证任意空/野 handle；native 头文件只声明 opaque handle，不把它包装成可以接收任意指针的安全函数。早退缺少 unlock 是原指令路径及测试锁计数的观察，没有把测试替身当成真实 RTOS 死锁实验。

## 4. Callback 同步、事件与 Delete 交错反例

base producer 的 `WriteEntry` 通过消息发送把 descriptor 交给 FIFO worker；`A044F05C` 从队列接收，`A044F5B4` 调 `SyncWritten(A044E8D4)`。这里的 callback 是同一 worker 调用栈上的同步 `BLX`，不是自动派发到独立 app 任务。另一路 virtual `WriteEntry` 在 `A0452464` 直接进入 `SyncWritten`，外层 `+48` 锁到 `A045246C` 才释放，因此不能假设所有通知都处于相同线程或无锁上下文。

base→virtual 这一条已执行路径在调用 callback 前释放 virtual `+14` 数据锁：

- `0x04000002`：普通 descriptor 数据通知。
- `0x04000001`：descriptor 长度为 `0x00FFFFFF` **或 type 为 `0xFF`** 的结束/特殊结束通知，参数 word 为 `0x00FFFFFF`。它不是空队列通知。
- `0x04000005`：write-read 恰好等于容量的 full 通知，可能紧接一次 data 通知。

callback 参数为 `(handle, event, transient_argument_pointer)`。参数指针可指向 `SyncWritten` 的栈局部，必须当场复制所需 word，不能存下指针供 worker 以后解引用。`+10 → handler+A8` 在这里没有作为额外 userdata 参数传入。UVCd 自有 callback 还访问自己的全局网络/handle 状态，新 consumer 不能直接复用该 callback 地址。

脚本补了一个显式顺序交错反例：

1. 执行原 `SyncWritten` 到 `A044EE58`，刚完成 virtual unlock，尚未调 callback。
2. 保存 CPU 上下文，在另一块构造 stack 上执行原 Delete，返回 0，确认 in-use 和 registry 清零。
3. 恢复原上下文继续，旧 callback **仍被执行一次**。

此用例没有真实调度器，不能报告成真机并发实验；它直接说明原指令允许“成功 Delete 后仍调用先前路径的 callback”。Delete 没有清 callback 字段或等待这个已释放锁的路径，mutex 本身也不覆盖 callback 整个生命周期。

所以静止合同必须包含：禁止该 handle 的新 callback 进入、等待已在途 callback 和所有 owner 访问退出、验证 handle/registry 仍有效，并串行化全局 Create/Delete。现有原码没有被确认可直接注入满足这个合同的独立 API。候选把它设为必需 backend 服务，不用无操作函数掩盖缺口。

## 5. 可编译 native owner 的行为与兼容性

新增 C11 SDK 只增加接口，**原 `yi4k_1107_frame_desc` 和 payload-copy 函数/结果/返回码 ABI 保持不变**。没有自动绑定固件地址，也没有设备调用入口。stock Create/Peek/Remove/Delete/callback 函数指针声明只用于日后明确绑定和 wrapper；注入 ops 带一个调用方 context，由 wrapper 再转调原 stock ABI。

`init → start → step → stop → close` 的所有调用必须来自同一串行 owner，不能在原 stock callback 里直接做。`busy` 只拒绝同步重入，没有提供跨线程互斥。

`step` 顺序为 `begin_read → Peek0 → descriptor快照 → payload复制 → persist → Remove1 → end_read`。begin/end 是 backend 必须实现的稳定读取保护，覆盖 descriptor、读游标及 payload，持续到保存和移除完成；只调用原 Peek 并不能满足。persist 返回 0 代表字节已安全接收，非零必须没有提交或对同一 descriptor 可幂等重试。

- 空队列：返回 EMPTY，不移除。
- copy/persist/read-guard 失败：保留队首，返回 RETRY；copy 错误保存在 `last_copy_status`。
- EOS：返回 END，进入 STOPPED；没有 payload 读取/保存或隐式 ack。
- Peek 异常：进入 PEEK_FAILED，不继续 pump。
- Remove 非零：进入 CURSOR_UNCERTAIN，不再次保存或移除同一帧。
- 创建异常：CREATE_UNCERTAIN；禁止重新 start 和自动清理。
- close 只允许已 stop 或消费失败后的 handle；quiesce 失败不 Delete，可等待屏障后重试；Delete 失败保留 handle 并进入 DELETE_FAILED；候选自身的 CLOSED 再 close 是本地幂等，不再次调用原 Delete。

模块没有实现 RTOS worker、callback 桥、SD 持久化、主 base 存活验证、registry 验证、读保护或静止屏障。为了满足持续编码目标，最终屏障还须在不停止主编码器的条件下成立；当前没有把停止编码器当作已解决方案。

native 验证使用 test-only ops 驱动真实 C 状态机和真实 payload-copy C：**20 组 host + 20 组编译 ARM 离线执行全部通过**，包括创建失败三种返回形态、copy/保存重试、EOS、Remove 已推进后的失败、静止屏障失败、Delete 失败以及四次同步重入拒绝。测试桥/保存/保护均为明确夹具，不是 backend 实现。

clang 使用 `armv7-none-eabi / cortex-a9 / -marm / soft-float / freestanding / -O2 / -Wall -Wextra -Werror`；NDK `ld.lld` 链接后无未定义符号、无 relocation。consumer 的 config/init/start/step/stop/close 六个函数合计 **1264 bytes**，另链接原有 payload copy **496 bytes**；测试夹具单独标为禁止用于设备。编译命令、compiler 版本、所有源/头 hash 和函数大小保存在 validation JSON。

## 6. 与 stock EventRecord / mux 分段的关系

本轮固定了 EventRecord open `[A01F845C,A01F8E68)`、开始 callback `[A01F8E68,A01F8E80)` 和**完整** close `[A01F8F08,A01F91C0)` 窗口。open 使用预先存在的 EventRecord video/audio FIFO 全局，创建/打开自己的 stream、movie、format 和 mux pipe，最终 start/process mux。close 先等 mux，注销 handler，释放 mux/format/index/stream，并删除自己的六个 virtual FIFO。这些直接生命周期操作没有自动给新 owner 建立 encoder 保持运行的合同；完整上层 dispatcher、准备阶段和运行时并发仍未验证。

EventRecord 原应用入口还受“系统已经在 recording”状态 gate 限制，首次注册和 FIFO 准备来源仍有未闭合部分。已有资源全局也不能用来证明任意新增第二 writer 可以和普通 mux 并发。因此本候选没有调用 EventRecord open/close，也没有把其 close 当作普通切段入口。

连续分段更有证据的仍是[普通 mux 的 event3 内部 rollover](prerecord-session-rollover.md)：它在同一 mux 会话内 close/open format 和 stream，复制轨道 metadata 并保留 virtual handle；已有[所有权审计](prerecord-fifo-rollover-ownership.md)和[索引/vtable 展开](prerecord-index-stream-vtables.md)给出了限定范围的副作用证据。它支持“主编码持续、mux 换文件”的候选方向，仍需要实际首帧/参数集、FIFO cursor、A/V 连续性和存储错误恢复验证。当前不从 API 存在推出并发可用，也不从离线测试推出真机连续分段已经成功。

验证命令：

```sh
.venv-reverse/bin/python scripts/prerecord-fifo-lifecycle.py
.venv-reverse/bin/python scripts/validate_prerecord_fifo_consumer.py
```

第一项通过 **24 条指令断言、33 组原码执行/显式交错检查**；OS 锁、消息发送、pool 分配/释放、日志和通知 callback 是明确替身，memset 与 32/64-bit 除法执行原镜像。第二项是真正编译的候选 C 在 host 与 ARM 模拟器执行，验证候选状态机。两者都不是真机 backend 完成证明。

本轮同步修正 [旧 virtual-consumer 文档](prerecord-virtual-consumer.md)：`0x4000001` 的空队列误称改为结束/特殊结束；停止顺序补足 callback 禁入/等待及 handle 验证；Remove 非零不能直接重试也已补入。未修改旧所有权审计或共享 roadmap。
