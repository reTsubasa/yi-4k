# 1.10.7 只读设备可达性复核（2026-11-12）

本次只读探测确认相机热点 `192.168.42.1` 可达，并重新核对固件身份、Linux/RTOS 相关节点和 API 状态。回执为 [`session.json`](../artifacts/device/2026-11-12-readiness-probe-01/session.json)。

```sh
python3 scripts/device_readiness_baseline.py \
  --output artifacts/device/2026-11-12-readiness-probe-01
```

读回固件为 `Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746`，硬件为 `YDXJ2_V13LW`，EIS 设置为 `on`，SD 状态为 `insert`。12 条 Linux/设备节点检查完成；API 前后设置一致。探测没有录像、拍照、RTOS shell、内存映射、重启、设置修改或目标文件写入。

API 状态快照从 `vf` 变为 `idle`，这是两个顺序只读查询之间的设备状态变化，不能解释为执行成功或任何自定义代码进入。探测只证明当前只读通道可达，不补齐 EIS 原生入口、I-cache/SMP 发布、停止回滚或算法替换门槛；后续真机写入/执行仍需按 [前置条件矩阵](device-1107-native-execution-prereq-matrix.md) 单独审阅和确认。
