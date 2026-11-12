# 候选姿态到原厂双平面：限定 1080p 仿射接缝

2026-11-12。本轮把候选 v2 的姿态残差转换为有界校准网格，再交给**未修改的原厂 ARM `A032CF38`**，得到原厂布局的 X/Y 两平面。验证仅使用合成几何及带单位的合成 gyro，不连接相机，不产生部署器，不修改固件/RAM。它推进了候选算法与原厂生成器的 CPU 数据接缝，但不是通用 stock ABI、DSP 锁存或实际算法替换验收。

实现：[候选仿射校准适配](../scripts/eis_candidate_stock_affine.py)、[原码执行审计](../scripts/audit_eis_candidate_stock_affine.py)、[边界测试](../scripts/tests/test_eis_candidate_stock_affine.py)。[最终 run03 回执](../artifacts/verification/2026-11-12-eis-candidate-stock-affine-run03/audit.json)绑定完整 1.10.7 映像 SHA256 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c` 和各实现源码摘要。

## 修正了一个实际接缝错误

最初把等几何条件下的 `A032C940` 当作恒等 remap，原码执行立即拒绝了“remapped grid 等于 rotated grid”的断言。该[失败说明](../artifacts/verification/2026-11-12-eis-candidate-stock-affine-run01/failure.json)保留；初始源码未独立快照，不能把现有源码 SHA 归属给失败版本。

原厂函数实际保持 Y 位移，按每列的**已位移 Y 坐标**反求原行位置，再重新插值 X 位移。它还在列首尾构造一个外推 knot。因而 X 平面不是与 Y 平面同坐标的普通位移图：把候选 `Δx(x,y)`、`Δy(x,y)`直接逐点塞进去会破坏两阶段组合。

当前实现独立恢复此逆 Y 线性插值，与实际 ARM remap 的 9 个校准节点逐字节一致，再核对原厂插值器生成的 **全部 2201 个有效平面元素**。每个案例的旋转网格、remap 网格、最终平面和 descriptor 都单独留存。原厂 sin/cos、复制实现、垂直 remap、插值及算术 helper 均执行原始映像指令，无函数返回替身。

在 combined 案例中，按声明的主机两阶段组合复原坐标，最大误差约 **0.117 px**；若错误地以相同 Y 坐标读取 X 平面，X 误差约 **1.261 px**。这些是合成坐标数学误差，不是相机画质测量，也不能证明实际 DSP 先后顺序或插值滤波与主机模型相同。

## 限定几何、转换与保护

本次仅接受输入/输出均为 **1920×1080、1:1 几何**的合成 profile。校准是 `3×3` 个 signed16 Q4 位移对，水平/垂直节点间距均为 `2^10=1024 px`；它覆盖原厂的 X `31×35`、Y `31×36` 查询，物理 pitch 均为 32。原厂查询位置为 `x=64×col`、`y=32×row`。Y 最后一行包含 1120 的 guard 坐标，不把它等同可见图像中的一行。

候选先在像素空间绕 `(960,540)` 旋转裁切后的坐标，再加 pitch/yaw 平移；原厂先把校准位移加到位置，再旋转。适配器先对平移应用逆 roll，再交给原厂 `theta=-candidate_roll`，保留其内部对 theta 取负、Q16 cos/sin 截断、signed32 运算与 ASR16 量化。独立整数参考逐项等于实际输出。

此前坐标合同中的 `4×4 exp11` 是恢复单位和固定指令的合成输入，不是通用可用校准：远离可见图像的节点会使原厂旋转的 32 位乘积发生回绕。本实现使用更近的 `3×3 exp10` 控制节点，并在进入原码前检查所有相关乘积、加减、signed16 存储及 guard 查询源支持；不会以 wrap 后“仍有结果”当作可用表。

对输入 correction、crop、几何和外推的限制是本组件的主机保护策略，不声称等于相机实际运行参数。测试中的 crop 为 0.12，不改相机裁切设置；缺少 guard 支持的 crop、非有限值、范围外角度和未知 4K profile 均拒绝。不对运行时真实 lens calibration 做替换或推断。

## 验证结果与复现

[run03](../artifacts/verification/2026-11-12-eis-candidate-stock-affine-run03/audit.json)包含 9 个原码案例：静止裁切、pitch、yaw、正负 roll、三轴组合，以及候选 v2 合成 gyro 路径中第 0/3/6 个姿态。合计：

- **19,809** 个原厂有效平面元素与独立 signed-truncation 整数参考完全一致，所有非有效点/行 pitch padding 保持 `A5`。
- 候选原有 Q16.16 mesh 中 **7,812** 个点与本适配器的连续像素仿射参考一致到候选本身的 Q16.16 量化界限。
- 实际平面与连续两阶段仿射公式逐元素比较，所测最大误差 **0.177909 px**，逐案例要求不超过 0.25 px。
- 使用声明的主机 bilinear 模型组合 Y 与重参数化 X，在 **9,765** 个可见查询点重建候选坐标，所测最大误差 **0.177400 px**，逐案例要求不超过 0.5 px。
- 5 个原码入口前负例均拒绝；另有 6 个组件边界测试，与原有 candidate/layout 测试一起 **16 项**通过。

这些误差界限是**所测案例的验收门**，不是对所有角度、crop、镜头和 DSP 的定理。原码成功返回只证明本次合成 CPU 输入/输出；完整映像身份、函数原字节、输入内容及允许写范围分别核验。

```sh
.venv-reverse/bin/python scripts/audit_eis_candidate_stock_affine.py \
  --output artifacts/verification/new-eis-candidate-stock-affine
.venv-reverse/bin/python -m unittest \
  scripts.tests.test_eis_candidate_stock_affine \
  scripts.tests.test_eis_candidate_mesh \
  scripts.tests.test_eis_stock_mesh_layout -q
```

## 尚未完成

这里固定的是候选仿射→原厂校准输入→原厂两阶段表的限定 CPU 接缝，不会把候选主机 Q16.16 表直接写入相机。`stock_abi_compatible=false`、`replacement_deployment_ready=false` 继续保留：尚无真实 gyro 标定、三轴相机方向、共同帧锚、实际镜头校准/裁切/行时序、原生执行/缓存/SMP恢复、DSP 实际采样方向与滤波、表发布/安全回收或编码视频质量对照。历史 48 条文本 gyro 仍不满足回放资格，不能通过本组件补造缺失时间和传感器状态。
