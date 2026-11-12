# EIS 反馈标签、DSP 消费与表生命周期闭环

2026-11-10。本轮新增的是一个只读交叉审计，把已有 producer、CPU 发布、ORC 反馈、CPU 反馈解析和表生命周期 JSON 固定到同一份 ledger；没有重新执行固件/ORC，没有设备访问、`/dev/mem`、RAM/固件写入。

复现：

```sh
.venv-reverse/bin/python scripts/audit_eis_feedback_table_closure.py
```

输出 [audit.json](../artifacts/device/2026-11-10-eis-feedback-table-closure/audit.json)。它重新读取六份既有固定镜像审计，核对 CPU 槽布局、共享发布字、ORC 反馈偏移、CPU 哨兵解析和表复制边界，输出 7 个明确未闭合项。

## 现在可以当作身份线索的字段

CPU 侧先把输入状态 `+0x20` 复制到选中的状态槽 `+0x20`，再把转换后的状态槽地址发布到 `A0699160`。ORC 反馈候选从同一两槽布局选取 `0x40` 快照，读取快照 `+0x20`，最后以 `smem_2_dram(shared+0x3c, 4)` 回传。参数、相对槽步长和 CPU/ORC 偏移互相一致。

CPU 读回共享 `+0x3c` 后拒绝 `FFFFFFFF` 与 `DEADBEEF`。有效值的低 8 位进入历史索引，`0x100` 位被原厂字符串称作 `WarpReady`。消费后 CPU 写回 `DEADBEEF`。因此目前可保留的逐帧相关字段是：

- producer 的 mode/context、calc_info 版本/控制/geometry/theta，以及软件选中的 bank/index；
- CPU 状态槽 `+0x20` 的低字节和 `0x100` 位；
- ORC 反馈候选的共享地址 `A0699160+0x3c`、`FFFFFFFF/DEADBEEF` 哨兵和低字节/`0x100` 格式。

这些字段提供格式和关联线索。低字节是可重复、有限宽度的子索引，不是持久单调帧号；`0x100` 是 CPU 的 warp-ready 解释，不是 DSP 锁存确认。frame array 的 `0x65d/0x65e/0x65f/0x660` 分别出现在不同 producer/receiver/consumer 阶段，也不能直接合并成一个帧号。

## 反馈与表引用的顺序

ORC 的反馈函数在 `context+0x68 == 20` 且 `context+0x10d8 != 0` 时运行。它先把共享发布区搬入本地，按发布指针选取一个 `0x40` snapshot，读取 snapshot `+0x20`，调用 stock EIS command `0xd7454`，再把本地 tag 回传共享 `+0x3c`。另一路在相同模式和指针条件下预先准备 `0x40` 结构并把末字写成 `FFFFFFFF`，其 `smem_2_dram` 目标覆盖共享 `+0x3c`。三处直接调用窗口都呈现“预清除后、条件满足才进入标签函数”的布局。

`0xd7454` 处理命令后仍保留表引用：垂直描述符 `+0x0c` 写入逐帧对象 `frame+0x18`，同时保存两个元数据字节并给 `frame+0x20` 置 bit 11。后续 vertical consumer 以 `frame+0x18` 调用 filter/controlregs shadow 选择值 24，把 `0xc40` 字节准备到 shadow `+0x100`，随后清除 frame bit 11。这里的 24 是 shadow selector，不能称为硬件命令 opcode；`done` 日志也不能替代硬件完成。

水平描述符进入 `idspdrv_dram2dram` 的 `0xc00` 复制准备，分块经过 scratch 和两个专有 staging helper。代码没有可独立识别的 DMA done 轮询。另一条同类 frame object 浅复制只复制 `+0x18/+0x1c/+0x1d`，且 flags 掩码 `0x7f8` 排除 bit 11；它不复制表内容，也不自动证明表被启用。

frame receiver 的 `relFBuf` 只减少 packed framebuffer handle 使用计数。它不是垂直表、水平表、CPU bank 或 ORC snapshot 的释放屏障。producer 的 stock scratch、两槽状态和后续 SetWarp 发布都保留原厂状态机；反馈回传发生在命令处理代码附近，不能因此反推 DSP 已读完表。

## 仍未闭合的边界

交叉审计明确保留以下未知：

- 没有找到共享 `+0x3c` 非哨兵写入者，也没有运行期证明 ORC 真的回显了某次 CPU 发布；
- 没有证明 `+0x80` 状态槽发布和 `+0x3c` 反馈读写具备原子性、缓存可见性或版本重试；
- 没有 DSP PC/运行微码身份，不能把静态 ORC 路径绑定到某次编码帧；
- 没有硬件最终读表时刻、垂直 `0xc40`/水平 `0xc00` 复制完成或专有指令缓存语义；
- 没有 CPU 状态槽、frame `+0x18` 指针、水平目的区或 producer scratch bank 的安全复用/释放点；
- 没有发布→反馈→MP4 PTS 的共同单调序号。

因此反馈标签目前可用于设计未来的观测字段和相关性检查，不能作为释放旧表、覆盖 bank、声明 DSP ack 或替换算法已经安全的依据。
