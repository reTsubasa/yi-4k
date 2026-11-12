# 候选仿射接缝：三轴离线扫测

2026-11-12。本次扩展验证只在主机上运行，未连接相机、未写固件、未写 RAM，也未执行设备命令。输入是固定 1.10.7 原厂代码映像；每一组接受的候选姿态都调用未修改的 ARM `A032CF38`，再核对原厂的旋转、垂直重参数化、X/Y 两平面和布局写入。

## 扫测范围

`1920x1080`、`crop_margin=0.12`、3x3 signed16 Q4 控制网格、1024 px 节点间距。`pitch`、`yaw`、`roll` 各取 `-0.01`、`0`、`+0.01` rad，共 27 组，全部进入原厂生成器并完成检查。每组 31x35 X 平面和 31x36 Y 平面的有效元素都与独立 signed-truncation 整数参考一致；非有效区的 `A5` 填充保持不变。

最大连续仿射误差为 `0.177909 px`，主机声明的两阶段 Y 后取 X 重建误差最大为 `0.177399 px`。这两个数只描述本次离线几何和采样模型，不是镜头画质、DSP 滤波或真机输出的测量。

## 保护性负例

边界探针保留在回执中：`roll=0.04` 和 `pitch=0.04` 因 guard 查询超出 source support 被拒绝；`roll=0.126` 因超出 bounded affine profile 被拒绝。`yaw=0.04` 在当前合成 support 检查下被接受，但没有把这一点外推为通用运行范围。

## 证据与复现

回执：[sweep.json](../artifacts/verification/2026-11-12-eis-candidate-stock-affine-sweep06/sweep.json)。脚本：[audit_eis_candidate_stock_affine_sweep.py](../scripts/audit_eis_candidate_stock_affine_sweep.py)。固定原厂映像 SHA256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`。

```sh
PYTHONPATH=scripts .venv-reverse/bin/python \
  scripts/audit_eis_candidate_stock_affine_sweep.py \
  --output artifacts/verification/2026-11-12-eis-candidate-stock-affine-sweep06
PYTHONPATH=scripts .venv-reverse/bin/python -m unittest \
  scripts.tests.test_eis_candidate_stock_affine \
  scripts.tests.test_eis_candidate_mesh \
  scripts.tests.test_eis_stock_mesh_layout -q
```

## 尚未闭合

这仍然是候选算法到原厂 CPU 表生成器的离线接缝，不是算法替换完成。尚缺真实 gyro 标定、相机三轴方向和帧时钟、镜头/滚动快门校准、原生 RTOS/DSP 执行与缓存可见性、表发布/回收、安全恢复，以及真机视频对照验收。扫测结果不能替代这些门槛。
