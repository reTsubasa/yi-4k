# 待审阅：最小 stock autoexec 入口验收

2026-11-12。**这是尚未执行的方案。当前没有连接相机、stage、重启或修改任何目标文件。**
使用 nonce `5345a5ec7c52`，只验证已知原厂脚本通路能在一次正常启动窗口中产生两份固定诊断输出。
它不尝试执行自定义 ARM，不检验 EIS，也不补足 P5/P11。

## 已生成的确切文本

[autoexec.ash](../artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/autoexec.ash)
为 ASCII、105 字节、仅 LF、无 tab、两行，最长 58 字节：

```text
ps tsk > c:\yi4k_entry_5345a5ec7c52_tasks.txt
savebin c:\yi4k_entry_5345a5ec7c52_code.bin 0xA0394BA0 l 8
```

脚本 SHA-256：`ecc127f17cf1fd9d188112857da4e332eb3e3f20f9e9b2345cbd8a9827638dd4`。
第一行读取原厂任务概要并写 SD 文本；第二行仅读取固定 RTOS 代码 `A0394BA0..A0394BA7`，
期望 8 字节为 `0300a0e11eff2fe1`。这是原厂 `savebin` 的读取方向，不包含写 RTOS 内存命令。
脚本没有 RPC、sleep、Python worker、录制、EIS 修改或 logger 开关。

## 文件与操作范围

| 相机文件 | stage | 正常启动中的原厂命令 | 收尾 |
|---|---|---|---|
| `/tmp/SD0/autoexec.ash` | 最后以 `O_EXCL` 创建，fsync、回读 SHA | RTOS reader 打开固定 `c:\autoexec.ash` | 先 disarm，仅 SHA 匹配才移除 |
| `/tmp/SD0/yi4k_entry_5345a5ec7c52_claim.json` | 最先以 `O_EXCL` 创建，fsync、回读 SHA | 不读取、不执行 | 保留到归档、稳定性复核后按 SHA 清理 |
| `/tmp/SD0/yi4k_entry_5345a5ec7c52_tasks.txt` | 必须不存在 | `ps tsk` 创建输出 | 先归档后按采集 SHA 清理 |
| `/tmp/SD0/yi4k_entry_5345a5ec7c52_code.bin` | 必须不存在 | `savebin` 创建 8 字节输出 | 先归档后按采集 SHA 清理 |

其他目标读取仅是 `/proc/sys/kernel/random/boot_id`、`/proc/uptime` 和上述四个已知文件。
四个 review 操作通过现有已审阅传输方式运行 Python common-subset 文本，不上传 worker 或额外收据文件；
cleanup 的摘要输入通过进程环境 `YI4K_STOCK_ENTRY_COLLECT_JSON` 传入。
该环境值来自主机本次归档生成的 `cleanup-input.json`，不能拿旧轮回执替代。
不要直接向交互终端粘贴长行；本轮没有调用既有 transport。

claim 的作用是标记本次独占 namespace 及期望文本 SHA，**不是运行期 once gate**。
根据[存储事件门禁](device-1107-autoexec-storage-gate.md)，另一次合格 StorageIdle 可能重读脚本、截断并覆写同名输出。
本方案因此限定为一次受控正常启动窗口，不插拔/格式化 SD、不伪造 StorageIdle、不自动重试启动。
若现场要求严格 exactly-once 而无法排除第二次存储事件，应拒绝该方案，不能把 claim 当作已解决重入。

## 执行前需批准的完整流程

本节描述未来一次可批准的操作，当前不运行。

1. 只读预检：确认固件为本机固定 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`、
   硬件与基线一致、API 为 idle/vf 且未录制、SD 状态 insert；记录 boot ID/uptime、挂载身份、四个路径均不存在。
   校验本地 bundle 的 SHA 清单。版本、挂载或路径不符立即停止。
2. 将预检获得的 boot ID 绑定到 stage 进程环境 `YI4K_EXPECTED_STAGE_BOOT_ID`，审阅并运行
   [review-stage.py](../artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/review-stage.py)。
   缺少绑定或 boot ID 不符时在写入前拒绝；claim 先写，autoexec 最后写，均独占创建、fsync 和回读。
   stage 回执同时要求输出仍不存在、boot ID 未变化。保留完整回执；发生异常时保留部分文件，不猜测删除归属。
3. stage 确认后才进入用户控制的正常关机/开机窗口；不发送强制 reboot，不断电中断写入。
   正常启动应产生合格 StorageIdle；不是靠等待脚本文件被轮询。若 120 秒内 API/只读通路未恢复，
   停止自动操作并报告所处阶段，不连续发 reboot、重投消息或启动另一入口。
4. 运行 [review-collect.py](../artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/review-collect.py)，
   原样保留 `YI_STOCK_ENTRY` JSON（去掉固定行前缀后保存）。缺失文件记为 `present=false`；collect 不删除任何文件。
   检查新 boot ID、API 就绪与两份输出。不同于旧 command probe，失败/部分结果同样保留。
5. 用下面的主机归档器核对传输字节/SHA、claim、任务概要和固定指纹，生成本地证据与 cleanup 摘要。
   新 boot ID、有效任务概要、精确 8 字节指纹必须同时满足，才记为本次 stock 输出验收通过。
   只证明原厂命令到达输出，不宣称 reader 最终返回、调度安全或任意代码进入。
6. 输出已稳定且 API 仍正常后，运行 [review-disarm.py](../artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/review-disarm.py)
   仅删除匹配的 autoexec，保留 claim/输出。disarm 不终止已经打开的 reader；若仍在执行、操作迟迟无确认或文件变化，应停止并保留证据，
   不立即清理。两次稳定读取只是有限观测，不等于已证明 quiescence。
7. disarm 后再次 collect 并归档，确认剩余文件与前份采集摘要相同，且 API/设置基线正常；
   再将这次归档的 `cleanup-input.json` 内容绑定到环境变量，运行
   [review-cleanup.py](../artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/review-cleanup.py)。
   cleanup 要求 autoexec 已不存在，逐项预检 claim/输出的存在性、字节数、SHA 均与已归档收据相同后，才删除三个精确路径。
   任一变化或类型异常则整批拒绝；不使用 glob、不删同目录其他文件。最后只读复核四个路径消失及原设置保持。

主机归档命令（不连接相机）：

```sh
.venv-reverse/bin/python scripts/archive_stock_entry_acceptance.py \
  --plan artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/plan.json \
  --stage /absolute/path/to/stage.json \
  --collection /absolute/path/to/collection.json \
  --output /absolute/path/to/new-local-archive
```

归档器从调用者提供的传输回执建立摘要校验，不提供密码学设备认证；
它将校验失败的传输拒绝在创建归档目录之前，完整但验收未通过的部分证据则保留并标记 `accepted=false`。
cleanup 的 `archived_and_hash_verified=true` 仅指本地文件已归档和校验，不代表验收成功。

## 现有 launcher 为什么不直接使用

- `device_rtos_command_probe.py` 含 Linux RPC begin/done；collect 验证成功后立即删文件，无法独立归档和 disarm。
- `device_rtos_readiness_probe.py` 含 18 秒 sleep、pool/VA 快照、多轮任务读取及 worker；超出当前最小范围。
- `device_native_eis_trace.py` 含 EIS 字段修改和录制 worker；不能用于本次入口验收。

没有通过删掉等待就把旧 RPC claim 放到脚本最前端。早期 Linux RPC readiness 与返回上限未建立，
会给这次最小验收添加新的启动依赖。也没有引入未经实测的 stock mkdir/复合条件 once gate。

## 严格 dry-run 结果

[构建器](../scripts/build_stock_entry_acceptance_plan.py)仅支持必须显式指定的 `--dry-run`，无 host、transport、stage 或 reboot 模式。
它复用现有“独占 namespace、claim 先于脚本、部分采集保留、按 SHA 清理”的结构，
但没有导入或调用任何 live launcher。

```sh
.venv-reverse/bin/python scripts/build_stock_entry_acceptance_plan.py --dry-run \
  --identifier 5345a5ec7c52 --output /absolute/path/to/new-plan-directory
```

[最终 dry-run 回执](../artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/dry-run.json)记录：

- 原 1.10.7 ARM reader 将实际 105 字节文本准确提交两行到 parser mock，并正常关闭模拟文件。
- 11 个临时主机文件 lifecycle 场景通过：未绑定拒绝、独占 stage、重复 stage 拒绝、部分采集保留、
  新 boot fixture 归档、损坏传输拒绝、未 disarm 清理拒绝、脚本变更拒绝、仅删除脚本、输出变化整批拒绝、旁文件保留。
- 四份 generated review 操作在主机临时目录执行；未访问相机路径。实际目标 Python 2.7 未执行，兼容性仅按 common-subset 语法设计。
- host task/code fixture 明确标为合成，不作为任何本次真机通过证据。

| 材料 | SHA-256 |
|---|---|
| builder | `8142d02d507e2e9b3d51623ec57c0dc1248590322d3a3fd89d3075011796eb40` |
| archiver | `abfc0addb11cc6f3d5ba645522159bd20bd2a29ce3efd360ec4b4a0866910245` |
| plan.json | `ac6556f1d69aa7364c8c2f51ad2d6a3f576a3fafdf1e6d13a3400c59fd0fa83a` |
| dry-run.json | `3263f7802a44cc5a907d1af1ee54412a550f67a1dfb595eac5b2051069f2650c` |

最终 bundle 内逐文件 SHA 位于 dry-run 回执；旧 `run01/run02` 是已替代的本地主机迭代，不能作为待执行版本。
当前唯一待审阅版本为 `2026-11-12-stock-entry-acceptance-plan-final`。没有请求或假定真机执行授权。
