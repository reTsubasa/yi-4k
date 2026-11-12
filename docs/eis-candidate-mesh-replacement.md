# EIS 候选 mesh 算法与替换边界

日期：2026-11-12。

本阶段加入一个可重复运行的主机候选算法，用于把带单位的陀螺仪轨迹转换成二维 warp mesh。它是算法替换的接口和验证起点，不是相机固件补丁，也不代表真机 DSP 已经执行。

## 输入与算法

输入 schema 为 `yi4k.eis-candidate-trace/v1`。`gyro_dps` 明确是 `[pitch, yaw, roll]`，单位为 degrees/sec；`tick_us` 是严格递增的 microseconds。当前算法版本为 `causal_gyro_residual_affine/v2`，用零阶保持的角速度积分姿态，再跟踪一阶平滑虚拟姿态。`smoothing_alpha` 对应显式 `smoothing_reference_interval_us`（默认 10000 us），由此计算时间常数；每区间执行线性姿态轨迹的一阶系统精确响应，改变采样点拆分不会改变恒定角速度下的时间常数。校正角是 **平滑姿态减原始姿态**，持续转向时保持有界残差，停止后趋于零。

输出 schema 为 `yi4k.eis-candidate-mesh/v1`，每个点使用 signed `normalized_q16.16`（Q16.16）坐标，语义为从输出网格到源图像的采样坐标。以 `1-crop_margin` 缩小基准网格，保留实际裁切空间。roll 在像素空间旋转，pitch/yaw 使用 `2*focal_length_px/width` 或 `/height` 的小角度平移；这是自定义的主机坐标约定。所有输出点必须留在归一化源图像 `[-1,1]` 内，否则拒绝。仿射网格内部点是顶点凸组合，因而在该数学模型内也不越界；这不证明真实镜头畸变、插值核或滚动快门质量。

v2 修正了首版的两项问题：首版使用负的累计平滑角度，持续转向会耗尽裁切余量；首版只检查相对位移，仍可能输出图像边界外的坐标。旧 `2026-11-12-eis-candidate-mesh/validation.json` 是首版历史回执，不能作为当前 v2 源码的验证。

运行主机验证：

```sh
.venv-reverse/bin/python scripts/validate_eis_candidate_mesh.py \
  --output artifacts/verification/2026-11-12-eis-candidate-mesh-v2/validation.json
```

当前基础验证包含 4 帧正例、确定性输出、非零运动改变 mesh、Q16.16/裁切边界检查，以及单位、序号、tick、采样间隔、速率、非有限值和裁切超限拒绝，共 7 项拒绝场景。新报告保存算法版本和源码哈希。

独立的 [行为审计](../scripts/audit_eis_candidate_quality.py) 还检查 20 秒持续转向的有界残差、5/10 ms 节律等价、停止后残差收敛，以及已知 5 Hz 轨迹的角度域平滑。合计 6604 个网格处于源图像范围，结果见 [回执](../artifacts/verification/2026-11-12-eis-candidate-quality/audit.json)。这些数学性质只评价自定义姿态模型，不是编码图像画质或真实防抖改善。

## 与原厂 ABI 的关系

候选格式明确标记 `stock_abi_compatible=false` 和 `replacement_deployment_ready=false`。它尚未适配原厂 `A032CF38` 生成器、warp table 的布局/定点解释、`A02DA164 → A0312460` 发布链、双槽同步或 DSP 锁存。主机 Q16.16 坐标不能直接写入相机内存，也不能替代原厂入口。

原厂标量 `A0384710` 的回放和边界 gate 仍按 [eis-boundary-trace-gate.md](eis-boundary-trace-gate.md) 单独执行。候选 mesh 只能在获得真实 stock-only 边界、原生执行、回退和实时预算证据后进入替换实验；实验必须保留原厂调用和可回退路径。

## 证据限制

候选回放使用解析轨迹。归档中已有真实 gyro/曝光日志与同次视频；新的 [归档与 ABI 审计](eis-candidate-archive-abi.md) 已重新解析并解码，但它们缺少连续标定 IMU 和逐帧共同时间锚，仍不适合候选回放或画质对照。当前没有证明 DSP latch、RTOS 入口/截止期、I-cache/D-cache 发布、SMP/IRQ 所有权、实体设备写入或画质改善。
