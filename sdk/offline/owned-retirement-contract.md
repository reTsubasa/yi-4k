# Owned retirement：离线资源停用与回收组件

[`yi4k_1107_owned_retirement.h`](../yi4k_1107_owned_retirement.h) 和对应 C 实现提供一个独立的停用流程：关闭新调用准入、撤销外部资源入口、请求停止、等待在途调用归零、验证任务实际停止、确认任务对象删除，最后单次释放自有资源。它不调用已知会吞掉错误并继续释放的原厂 RPC unregister。

现有 FIFO consumer 的 `quiesce` 是注入合同，early-copy 的 `ingress_busy` 是单 producer 的同步递归保护；两者都没有实现通用的并发调用准入与回收。本组件填补这一离线实现缺口。它尚未绑定相机端服务或接入现有 EIS hook。

## 使用合同

由一个对象所有者在发布前调用 `init`。每个资源用户用独占 ticket 调用 `enter`，只在获准时使用 `ticket.resource`，并在全部访问及链式回调结束后 `leave`。ticket 不可复制，不可在线程间并发共享；同一 ticket 的再次 enter 和重复 leave 会拒绝。复制 ticket 后重复 leave 属于调用方违反合同，不由本组件防护。

关闭和在途计数位于同一 32 位原子字中。`close` 不可逆；若 enter 先获准，它计入在途，回收会等待它退出；若 close 先发生，旧读取不能让 CAS 在关闭后获准。容量达到 `max_inflight` 拒绝新调用，避免计数溢出。准入 CAS 竞争可能拒绝，调用方决定跳过或稍后调度。

`finish` 使用原子 controller 锁拒绝并发或同步递归的第二个控制器。它按顺序调用缺失的证明服务：

1. `revoke_ingress`：外部资源入口已撤销；持旧指针的迟到 dispatcher 只能到达仍保留的关闭 gateway，不能绕过计数访问资源。
2. `request_stop`：停止请求被接受。它不代表任务已经退出。
3. 在途计数为零后才调用 `verify_stopped`：通过独立调度器或等价屏障证明任务实际退出，且没有未计数的消费者。entry 自己在返回前写出的 marker 不足以证明退出。
4. `delete_task`：停止已确认后删除任务对象。失败保留自有资源，成功后才允许继续。
5. `release_owned`：单次释放自有资源；此时任务删除已成功。它不再调用原厂 unregister、terminate 或其他可能在错误状态下释放的析构器。

服务返回非零时保留资源和此前已经取得的证明。请求已接受但调用未排空时返回 `PENDING`。调用方安排后续重试；服务不得在失败时偷偷释放资源。所有成功证明在这一对象生命周期中必须不可逆，外部不得重新启动或重绑定对象。不能确认某服务失败后是否可重试时，应继续保留资源并交给恢复流程。

guard、gateway 执行代码、ops 和 context 都必须存活到所有迟到调用结束；**本组件不回收它们**。`release_owned` 只能释放独立资源，如自有缓冲区和已确认停止且删除后的任务栈。它不能释放 guard、gateway、回调正在执行的代码或 context。因而本组件不能单独证明可卸载 EIS 自定义代码。

组件不分配、不等待、不循环轮询、不嵌入 firmware 地址；每次 finish 最多调用每个尚未完成服务一次。注入服务自身必须有界。C11 lock-free 原子在 ARM 上仍可能有编译器生成的 LDREX/STREX 重试，不承诺硬件 wait-free 最坏延迟。

## 已执行验证

```sh
.venv-reverse/bin/python scripts/validate_owned_retirement.py \
  --output artifacts/verification/2026-11-11-owned-retirement-review
```

验证器编译同一实现，在 host 和 Cortex-A9 A32 Unicorn 中分别执行 10 个场景并比较完整回执：正常顺序与单次释放、四阶段依赖失败后保留及重试、在途延迟、容量与两个调用排空、同步递归控制器、排空但停止证明失败，以及无效服务。重复 leave 和复用活动 ticket 均被拒绝。每次 ARM 正常返回检查 R4–R11 和 SP。

另有两个可控 ARM 指令交错：在准入 LDREX 前运行真实 close/finish，释放后恢复旧准入，CAS 拒绝且不读取资源；在成功 STREX 后、尚未发布 ticket 前运行 close/finish，在途计数阻止释放，恢复调用并 leave 后才释放。交错发生在 exclusive 区间之外，保存恢复普通寄存器，没有修补代码或伪造 exclusive monitor。

Host 运行 20 轮线程测试，每轮 6 个用户持有 ticket 跨越 close，finish 必须返回 PENDING；六个线程随后共发起 12,000 次被拒绝的迟到调用。外部控制器用 `pthread_join` 完成作为停止证据；在停止验证服务中停住第一个控制器时，第二个控制器必须被拒绝，释放只能发生一次。测试自己的 wait/yield 循环不属于 SDK 实现。

本轮已通过的最终证据为 [run02 validation.json](../../artifacts/verification/2026-11-11-owned-retirement-run02/validation.json)，SHA-256 `723e8e3f44b34b76d440d4de86910cc14c04acdb1c763691bfc7787e1443ed54`；编译后的准入汇编见 [retirement-enter.asm](../../artifacts/verification/2026-11-11-owned-retirement-run02/retirement-enter.asm)。证据包含完整源码哈希、编译命令和 ELF 哈希。

主线程审查实现与 ticket/常驻 guard 合同后，使用同一冻结源码独立编译并重跑全部场景：[parent-review validation.json](../../artifacts/verification/2026-11-11-owned-retirement-parent-review/validation.json)。10 个 host/ARM 场景、2 个 ARM 指令交错及 20 轮线程测试全部通过；没有设备访问。

这些结果证明的是本组件在声明合同下的行为。实际相机撤销入口、调度器停止证明、任务删除绑定、代码/cache 发布、首次执行以及恢复均尚未完成；本组件没有授权部署或解除 EIS 真机关卡。
