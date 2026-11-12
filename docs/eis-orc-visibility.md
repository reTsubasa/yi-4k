# ORC 可见性指令边界

2026-11-10。本轮对固定 `orccode.bin` 成员做了完整、按 4 字节对齐的静态扫描，目标是检查标准 OpenRISC `l.msync`、`l.psync` 和 `l.csync` 是否出现在 EIS 反馈/预清除/复制路径或整个成员中。扫描不执行 ORC，也不接触相机。

复现命令：

```sh
.venv-reverse/bin/python scripts/audit_eis_orc_visibility.py
```

结果见 [audit.json](../artifacts/device/2026-11-10-eis-orc-visibility/audit.json)。固定容器 SHA-256 为 `9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73`，选中的 `orccode.bin` 成员包含 759,102 个对齐字：

- `l.msync`：0 个
- `l.psync`：0 个
- `l.csync`：0 个
- `l.rfe` 编码模式匹配：566 个；这些字保留为不透明数据，没有把低位保留字段命名为完成或同步语义

反馈函数、`FFFFFFFF` 预清除函数和复制 helper 的窗口内都没有标准同步指令。这个结果比单独检查几个反编译窗口更宽，但只是有限的静态负向证据：原厂的 staging、`code_dma`、专有指令、缓存控制、硬件 latch 或队列驱动仍可能提供非标准语义。它不能证明不存在缓存协议，也不能证明 DSP 读表完成或旧槽可安全复用。

因此当前 EIS 的停止条件保持不变：不能把 ORC 的 `smem_2_dram` 调用、CPU 队列返回、`l.rfe` 模式字或反馈标签格式匹配升级为 DSP ack、表释放屏障或可部署的算法替换入口。
