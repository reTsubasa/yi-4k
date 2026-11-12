# YI 4K 机内实时 EIS：商用方案、论文与移植选择

调查日期：2026-11-05。目标为普通 YI 4K/Z16，录制后视频已经稳定、无需后期。固件依据见 [EIS 专项逆向](eis-reverse-engineering.md)，仍限定其 RTOS SHA。本次进行了公开资料与源码核查，没有在 YI 上运行候选算法，没有厂商内部源码或 DJI/GoPro/Insta360 固件的新增逆向结果。

## 1. 选型结论

用户补充了关键现象：**关闭 EIS 后基本没有果冻纹，但画面抖且模糊；最希望消除的是开 EIS 后让人恶心的局部扭动。** 这是用户观察，不是本次已做的开关对照测试。它使“降低非刚性失真、减少补偿错误”的优先级高于更强的整体锁定。

**首选：先做保守、保持几何一致性的三轴旋转稳像，再加入经过时间标定的逐行三维滚快门校正、模糊感知和有界裁切。** 基础是 gyro 四元数姿态 + 自适应因果平滑 + 畸变感知 warp，复用原厂 DSP 重采样与编码。随后才考虑有限前瞻或低分辨率视觉辅助。

### 1.1 针对这台相机的果冻现象

“EIS 关掉后基本消失”会提高对补偿链的怀疑，但不能独立证明传感器完全没有滚动快门或振动问题：原本的大幅整体运动/模糊可能掩盖局部误差，EIS 稳住中心后反而更显眼。

| 需要区分的原因 | 为什么会产生类似果冻的观感 | 应做的可证伪对照 |
|---|---|---|
| gyro 与图像时戳/相位不匹配 | 对错误时刻的旋转做反向补偿，可能过补或反向拉扯 | 记录实际 gyro、曝光与帧事件，主机回放校准时差；不能盲扫实时寄存器 |
| 原 RSC 的方向、比例、行时间或近似有误 | 不同图像行获得不合适的补偿，直线变弯、边缘摆动 | 保留整体稳像，单独旁路按行补偿作对照；再用正确行时刻模型替代 |
| 鱼眼投影与旋转/透视模型不匹配 | 中心看似稳定，周边像橡皮一样伸缩 | 同一轨迹比较固定镜头模型、原校准表与统一 ray-space 映射，测直线/边缘形变 |
| 网格限幅、表切换或帧绑定不连续 | 某些行/节点被截断，或当前帧读到不同代的表 | 捕获每帧表和提交状态，检查空间连续性、帧间跳变与缓冲所有权 |
| 曝光期间的运动模糊被强稳像显露 | 稳定位置里纹理沿不同方向糊动，出现令人不适的清晰度/拖影变化 | 在可控条件下比较快/慢曝光；保持适量整体运动或使用 blur-aware 平滑，判断症状是否变化 |

逆向中有直接可检查的位置：

- [0xA0391CF0](../artifacts/rtos-reverse/full/decompiled/a0391cf0.c) 根据 X/Y gyro 构造逐行补偿、限幅并叠加到网格；其中 `0xA0757AC4` 乘在行补偿上，调试分发器把它命名为 `RscScale`。
- [0xA0394CC0](../artifacts/rtos-reverse/full/decompiled/a0394cc0.c) 的 case `0x11` 写 `ExtraGyroPhaseDelay` / `ExtraRSCPhaseDelay`；case `0x52` 写 `RscScale`。这些是内部调试子编号，不是可直接执行的 Shell 命令。
- [0xA0392CB0](../artifacts/rtos-reverse/full/decompiled/a0392cb0.c) 在一个分支中由 `0xA0757B3C` 控制是否调用上述行补偿；仍需跟踪它和其他 RSC/DSP 路径的关系，不能把它当完整、稳定的 RSC 开关。

公开样本静态初值中 `RscScale=1`，上述调用控制字节为 0，`ExtraGyroPhaseDelay` 字节为有符号 -2。**运行期间会写入这些状态；这既不代表用户相机当前值，也不说明 -2 就是错误设置。** YI 还有 skew/窗口和 DSP 侧处理，不能由一个函数就断言原系统“完全没有三维滚快门校正”。

针对用户目标，第一轮最有价值的消融是：**原厂 EIS → 保留整体稳像但旁路可疑行补偿 → 三维整体旋转/正确镜头投影 → 标定后的逐行三维校正**。先在主机回放做，再在可靠 hook 下做机内实验。该顺序可以定位果冻来自哪个环节，也可能发现无需完整重写即可明显改善。

主观验收允许保留一点自然摇动，优先要求直线和边缘不弹性变形、没有周期性扭动。Gyroflow 可作为标定/RS/投影的开放参考，Google 的 blur-aware 策略可作为减少模糊不适感的参考；两者都不保证未经适配就解决当前症状。

优先级依次为：

1. 校准 IMU、镜头和图像时间轴，恢复现有参数单位与缓冲区协议；优先定位并消融 EIS 引入的果冻。
2. 在保留原厂调度和输出链的情况下，建立统一三轴姿态与有裁切约束的自适应平滑。
3. 把镜头畸变、姿态投影和滚动快门校正合成为一次 DSP warp，限制不必要的非刚性形变。
4. 实测原厂缓冲余量后，评估增加几帧的有限前瞻；不能只增加 gyro 历史就获得未来图像。
5. 需要改善近景平移/视差时，再探索低分辨率特征点与 gyro 融合。

这里的“首选”是算法和接口匹配判断，并非已测出比原厂提升多少。必须在同一输入、同一有效视角、同一分辨率/曝光下比较，不能用更大裁切掩盖算法差异。

## 2. DJI、GoPro、Insta360 能确认到哪一层

这些商标不是公开的单一数学算法。商用效果通常涉及采样与标定、姿态/运动估计、平滑与构图、畸变/滚动快门、裁切和曝光策略。公开产品说明可以确认功能目标，不能证明使用了某一种滤波器、优化器或神经网络。

| 对象 | 直接读到的公开证据 | 对 YI 有价值的目标 | 不能据此声称的内容 |
|---|---|---|---|
| DJI Osmo Action，RockSteady / HorizonSteady | [Action 6 FAQ][D1]：RockSteady 配合提高感光参数、加快快门和图像补偿；HorizonSteady 支持旋转时保持水平；另有规格限制 | 曝光与稳定协同、普通平滑/水平保持分模式、利用边缘余量 | 未公开其轨迹优化、gyro 融合、预测器或固件实现；不能说就是 Kalman、Gyroflow 或某篇论文 |
| GoPro HyperSmooth / AutoBoost | [HERO12 官方页][G1]：机内 HyperSmooth 6.0；AutoBoost 随速度与运动尽量保留宽视角；支持特定模式下 360° Horizon Lock。[Labs][G2] 有 Off/On/High/Boost/Auto 控制 | 有裁切约束的稳定度调节，避免固定“大裁切”或固定滤波；水平保持 | AutoBoost 的内部评分、前瞻长度、优化目标未知；Labs 控制不是算法源码 |
| Insta360 Ace Pro 2，FlowState | [官方产品页][I1]：FlowState、360° 水平矫正、六轴传感器，页面展示防抖开关对比 | 三轴姿态与水平参考、区分普通防抖和水平锁定 | 未公开 FlowState 的平滑方程、滤波窗口和完整机内/应用分工；不同模式不能一概而论 |
| Insta360 X 系列全景相机 | [X5 官方页][I2]：FlowState、360° 水平矫正、双镜头全景与 INSV 等模式 | 用真实姿态与虚拟相机视角分离的思路理解构图 | 全景拍摄可重新选择观看方向，单镜头 YI 没有同等球面覆盖；不能直接复制其视角余量和效果 |
| DJI Osmo Pocket | [Pocket 3 FAQ][D2] 明确为机械云台相机 | 对比物理稳像能在曝光期间减少运动的优势 | Pocket 的机械防抖收益不能通过给 YI 换 EIS 软件完整复现 |

本表采用实际取得正文的机型作例证，不宣称 HERO12/Ace Pro 2 是调查日最新机型。厂商后期软件、全景重构和机内直接输出应分别比较。[GoPro GPMF][G3] 是公开的遥测格式解析器，也不是 HyperSmooth 源码。Gyroflow 中名字带 GoPro/Insta360 的镜头模型，同样不能当作厂商防抖实现。

## 3. 可参考的论文和公开实现

| 工作 | 核心内容与证据 | 对 YI 的适配判断 |
|---|---|---|
| Karpenko 等，2011，*Digital Video Stabilization and Rolling Shutter Correction using Gyroscopes* | [Stanford 项目页][P1]：gyro 旋转建模、相机/gyro 自动标定、稳像与滚快门统一模型，已有手机实时实现 | **高度适合做几何基础**。论文用 GPU 变换像素，YI 可研究将采样映射送现有 DSP；仍需验证网格与行时序 |
| Grundmann 等，CVPR 2011，*Auto-Directed Video Stabilization with Robust L1 Optimal Camera Paths* | [Google 论文页][P2]：最小化路径一、二、三阶变化，得到静止/匀速/平滑加速段，加入构图约束；原方法为后处理 | 借鉴“轨迹+构图约束”的目标；**不能原样视为零前瞻在线算法**。可以设计较小滑窗优化，但需另行验证 |
| Liu 等，ECCV 2016，*MeshFlow: Minimum Latency Online Video Stabilization* | [Microsoft 原论文页][P3]：特征点到稀疏网格、两次中值滤波、PAPS 仅用过去运动，系统一帧延迟 | **有条件可行**。过去运动自适应平滑值得借鉴；完整视觉输入需低分辨率帧、特征跟踪和额外 CPU，现有 ABI 未恢复 |
| Google Pixel 2，2017，Fused Video Stabilization | [Google 工程说明][P4]：200 Hz gyro、严格时间对齐、前瞻、意图识别、多变换网格及运动模糊感知；有 OIS | **最有用的量产工程参考之一**。校准、mesh、曝光与裁切策略可借鉴；OIS、焦距呼吸和完整学习模块不直接适用 |
| Shi 等，WACV 2022，*Deep Online Fused Video Stabilization* | [CVF 原论文页][P5]：gyro + 光流 + 历史真实/虚拟姿态，经 LSTM 得到新虚拟姿态，生成 warp 网格 | 结构与 YI 接口有相似处，但**完整网络和光流不作为第一版**。小型运动预测器可后续单独评估；“online”不等于 A9 可实时 |
| VQF，Information Fusion 2023 | [作者文档][A2]：在线 IMU 姿态与偏置估计；支持无磁力计的 6D 融合；C++/MIT | **适合作为姿态估计候选**。它不是完整 EIS；还需轨迹平滑与投影。加速度计接口/频率仍需恢复，高动态下需抑制错误重力修正 |
| Gyroflow，检查至本次固定提交 | [默认平滑源码][A1]：速度驱动的自适应四元数平滑、姿态误差调节，另有镜头、RS、动态变焦与水平保持 | **最直接的开放参考**。默认/plain 均含反向遍历；2026 的 Optimal path 明确优化整段视频。适合主机参照与方法借鉴，实时版需重新设计 |
| RStab，CVPR 2024，*3D Multi-frame Fusion for Video Stabilization* | [原论文页][P6]：3D 多帧投影、深度先验、体渲染、光流辅助颜色校正，追求完整画幅 | **不适合当前机内目标**。可在主机做画质上限对照，无法用现有 warp 命令直接实现神经渲染 |
| MetaStab，CVPR 2024，*Harnessing Meta-Learning for Improving Full-Frame Video Stabilization* | [原论文页][P7]：针对像素生成模型做测试时适配和元学习 | **不适合当前环境**。即使一次适配，也仍依赖生成模型和相应资源 |
| GaVS，SIGGRAPH 2025 | [作者公开仓库][P8]：3D 重建与渲染；公开环境为 Python、CUDA 12.6，包含 Gaussian rasterizer | **不适合当前机内环境**。主要价值是理解完整画幅、视差与重建的研究上限 |
| LightStab，CVPR 2026，*No Labels, No Look-Ahead…* | [CVF][P9] 与 [arXiv 全文/补充][P10]：因果光流、运动传播网络、动态平滑和异步缓冲；表 7 报告 Jetson AGX Orin 78.94 ms/帧，即 12.67 fps，且不含可选补边 | **完整方法不适合第一版**。动态平滑、可控的三段管线和缓冲方法值得借鉴。该数字只代表作者基准，不是与 YI 的等条件测量 |

前沿研究中“无未来帧”“online”“轻量”回答的是不同问题，不能由这些词推导 YI 能达到 1080p60/4K30。训练时不需要标签，也不表示推理时不需要 GPU。

## 4. Gyroflow 和 VQF：具体值得取什么

Gyroflow 固定提交：`7c50b6370ffdacf38389e676b6008d8895206c51`。本次实际检查：

- `src/core/smoothing/default_algo.rs`：先根据相邻姿态算速度，对速度平滑，再让平滑系数随速度和姿态误差变化。快速主动转向时减小滞后，安静时提高稳定度。
- `smoothing/plain.rs` 和 default：都有正向/反向遍历，不能整段复制为实时因果滤波。
- `smoothing/optimal/mod.rs`：注明“over the whole clip”，并带裁切约束；当前是整段求解的参考。
- `smoothing/horizon.rs`：水平参考与姿态处理。
- `stabilization/frame_transform.rs`：逐行旋转、readout 时间/方向、sensor 行与输出行的映射。
- `zooming/zoom_dynamic.rs`：自适应视角与时间平滑。即使只使用姿态曲线，实时未来数据的可用性仍需单独处理。

因此建议借鉴它的**数据契约、三维几何、适应性与约束设计**，在 RTOS 上实现有明确内存和时间界限的版本。无需搬 Qt、视频解码器、整个 Rust 框架或逐像素 CPU/GPU 渲染器。

VQF 固定提交：`86ba56bdd3158b9b05f9f9fe5596866ba326438c`。`BasicVQF::updateGyr` 做四元数积分；`updateAcc` 利用重力方向修正倾斜；完整 VQF 还有在线 bias 估计。候选可以是完整 VQF、BasicVQF 加外部 bias，或更简化的互补滤波，须用 YI 的真实振动数据比较。**无磁力计时不具备绝对航向参考，yaw 漂移仍需处理；跑跳产生的线性加速度不能直接当重力。**

Gyroflow 相关文件为 GPL-3.0-or-later，VQF 对应文件为 MIT。研究和直接集成分发应区分；当前方案不要求把 GPL 实现链接进闭源 RTOS。

## 5. 和已逆向 YI 链路如何对应

| 建议模块 | 可利用的固件入口 | 优先保留/待恢复事项 |
|---|---|---|
| IMU 输入、偏置与传感器描述 | gyro read `0xA047EDE4`，描述 `0xA047F2A0`，采样主体 `0xA0385780` | 量程、轴向、level shift、ODR、滤波延迟、每样本时间；不能把输出直接当 dps |
| 图像时间轴与曝光 | 主任务 `0xA0396F34`，模式初始化 `0xA037FE20`，SOF/EOF 相关 `0xA037BA48` / `0xA037B998` | 事件对应曝光开始/读出还是其他时刻；RowTime、模式裁切、曝光中点 |
| 三轴姿态/轨迹控制 | 原运动处理和 `0xA0392CB0`，旋转滤波候选 `0xA0384710` | 先恢复原输出单位与状态所有权，避免同时存在两套互相覆盖的轨迹 |
| 畸变和逐行补偿网格 | `0xA038EA48`，按行补偿 `0xA0391CF0` | 原校准表、网格坐标与精度、正向/反向映射、翻转与采样缩放 |
| 硬件变换 | calc `0xA03119A8`，set `0xA0312460` | 有效管线 context、表尺寸和所有权、cache clean、帧绑定、提交时限 |
| 水平保持 | gyro + 可能可用的加速度计 read mode；统一姿态层 | accel 完整 ABI 未恢复；源画面余量限制倾角与可保留视角 |
| 视觉辅助 | 后续Linux专项已找到 `example_sharepreview` 与RTOS共享Y帧RPC的双侧静态证据，见 [Linux系统分析](linux-system-analysis.md) | 优先恢复已有接口；实际模式、帧率、时间戳、缓存与录像兼容性未验证，不能把它当已可用的原始帧回调 |

不能用算法更换跳过通用报告中的首次原生执行、可执行内存和完整缓存协议验证。新算法要在恢复可靠 hook 后才有真机集成条件。

## 6. 建议第一版的数学与实时边界

下列为独立的候选设计，不声称是 DJI/GoPro/Insta360 方程，也不声称已重建 YI 全部原方程。

设 `q_c` 为相机到世界的实测姿态，`q_v` 为平滑后的虚拟相机姿态。gyro 校正并转到相机坐标系后，可做：

```text
q_c[k+1] = normalize(q_c[k] ⊗ Exp((omega[k] - bias[k]) * dt))
alpha = 1 - exp(-dt / tau)
q_candidate = slerp(q_v_previous, q_c, alpha)
q_v = crop_and_motion_constrained(q_candidate, q_c, previous_state)
```

这里 `Exp(v)` 定义为旋转向量到单位四元数的映射，其 sin/cos 使用半角。需处理四元数正负等价、归一化、轴系与乘法约定，不能直接套用任一库而混用坐标。

`tau` 不固定：静止时大，主动摇镜时小；接近画面边界时减小平滑强度或增加允许的裁切。建议加入滞回和速率限制，避免变焦呼吸及“锁住—突然弹回”。第一版可以只用因果速度、方向持续性、姿态偏差、剩余余量和模糊估计制定规则，无需训练网络。

对输出像素射线 `ray_v`，反向采样的基本几何为：

```text
ray_source = R_c(t_source_row)^T * R_v(t_reference) * ray_v
pixel_source = lens_project(ray_source)
```

输出先通过虚拟镜头反投影，源图像使用真实镜头畸变模型投影。`t_source_row` 来自**源图像的曝光/读出行**，不应简单用输出 y 代替。大变换时可能需要迭代估计源行；时刻定义和符号必须通过实测校准。若已有校准表，则研究与之合成，避免重复畸变校正。

这一模型在纯旋转/远景下较合适，**不能消除近景平移视差，也不能恢复曝光期间已经丢失的清晰细节**。使用加速度计做姿态修正，不等于可稳定积分出准确的位置轨迹。

## 7. 资源与延迟：哪些真的轻，哪些只是名字轻

现有证据支持 ARM/ThreadX 控制侧和 DSP warp；尚未建立可供第三方调用的通用 GPU/CUDA/NPU 执行接口。不要把新手机或 Jetson 的推理吞吐量套到 YI，也不预设可占用全部 ARM 核心、全部 RAM 或 DSP 内部代码。

| 操作 | 工作量如何增长 | 资源判断 |
|---|---|---|
| gyro 积分、在线融合与因果平滑 | 随 IMU 频率，状态为少量向量/四元数和滤波状态 | 相对轻；实际 ODR 和 CPU 占用待测 |
| 每行/网格行姿态插值、网格投影 | 随网格节点数与帧率 | 与现有接口最匹配；应预计算镜头射线、按行复用旋转，避免每点重复三角函数 |
| 自适应裁切 | 对变换后有效边界做有界几何检查 | 可从保守边界检查起步；鱼眼/RS/非线性 warp 下仅检查四角可能漏掉边缘越界 |
| 有限前瞻/滑窗轨迹优化 | 曲线状态通常小，图像等待资源可能大 | 主要障碍可能是帧缓冲和管线延迟，而非姿态曲线内存 |
| 稀疏视觉辅助 | 随输入缩小尺寸、点数、金字塔层数与搜索范围 | 有条件；优先低频校正漂移/残差，不一开始承担全部像素运动 |
| 光流网络/神经渲染/补边 | 随像素、特征图、模型和多帧窗口 | 当前没有支持其机内实时运行的证据 |

节点计算的量级示例：33×19 网格在 60 fps 为 37,620 节点/秒；65×37 为 144,300 节点/秒。它们只是说明“生成稀疏表”和“逐像素重采样”的差别，**不是已确认 YI 支持这些网格，也不是性能测试**。3840×2160@30 对应约 2.49 亿输出像素/秒，应该交现有硬件处理。

帧缓存示例，假设未经压缩的 YUV420、没有 stride/padding 和额外工作区：

| 内容 | 单帧 | 三帧 | 六帧 |
|---|---:|---:|---:|
| 1920×1080 | 2.97 MiB | 8.90 MiB | 17.80 MiB |
| 3840×2160 | 11.87 MiB | 35.60 MiB | 71.19 MiB |

三帧前瞻在 30 fps 是约 100 ms，在 60 fps 是约 50 ms；六帧分别约 200/100 ms。这只是新增前瞻量，不含原有流水线延迟。实际缓冲可能是 Bayer、YUV422、tiled、压缩格式或由 DSP 私有管理，表中数字不能直接用作分配依据。

gyro 环形历史即使多存几秒也可以很小，但**要利用未来 gyro 来修正较早一帧，就必须能让那帧延迟输出/编码，或证明原有管线已经保留足够时间**。写出可直接播放文件允许有限录制处理延迟，仍须维持 A/V 同步、末帧排空、录制启停与预览行为。

## 8. 哪些场景最可能变好

| 场景/问题 | 候选改善 | 效果限制与验证方法 |
|---|---|---|
| 白天骑行，细碎高频抖动 | 先修时间同步、bias、逐行模型，再调平滑 | IMU 饱和/机械共振/混叠可能是根因，不能仅提高平滑强度 |
| 主动转头时拖拽、回弹 | 因果意图检测、自适应 tau、边界限制 | 减少拖拽与更强锁定存在取舍；需专门测试快速转向和突然停止 |
| 地平线晃动 | 可靠的重力参考、三轴统一姿态、有限水平保持 | 振动和长时间线性加速会干扰重力；360° 锁定需足够视角余量，不能保证所有模式 |
| 画面扭动、果冻 | lens-aware、源行时刻正确的 RS 网格 | 传感器读出参数与 gyro 相位必须先校准，错误补偿可能更差 |
| 大幅运动时突然切换、黑边、变焦泵动 | 裁切约束、视角/稳定联合调节、快速收紧/缓慢释放 | 输出分辨率和可用源裁切决定上限，不能“免费”获得更稳且不裁切 |
| 夜间走路，清晰/模糊交替 | 曝光限制、blur-aware 减弱过强锁定 | EIS 不恢复已模糊纹理；快门变快会增加噪声/ISO，与降噪有取舍 |
| 近处物体走动，前后景错位 | 低分辨率视觉辅助或局部网格 | 纯 gyro 不测平移/深度；非刚性网格过度校正会拉扯直线与人物 |

Google 的工程文档展示仅 3 ms 时间误差就能出现可见抖动，因此“先标定再换算法”是性能工作的一部分，不是可有可无的准备。[P4]

## 9. 二开实验次序与验收

| 阶段 | 实施内容 | 必须观察到的结果 |
|---|---|---|
| A：建立基线 | 确认实体机版本与安全执行路径；旁路记录 gyro、图像时间戳、曝光、原补偿、帧号和提交耗时；避免在实时任务同步写卡 | 数据无采样丢失/时间跳变，有完整模式信息；原厂录像行为基线可重复 |
| B：主机回放 | 相同原始输入下比较原厂输出、标定后的原模型、因果三轴方案、Gyroflow 离线参照 | 固定视角下改善可见；先区分时间/标定收益与轨迹策略收益；离线参照不当作实时成绩 |
| C：最小实时版本 | gyro/可选 accel → 有界因果姿态与平滑 → 原网格/原 DSP 提交；先选原本支持 EIS 的低负载模式 | 无黑边、网格异常、掉帧、提交超时和明显 A/V 变化；p99/最坏时长满足真实 DSP 截止时间 |
| D：几何和场景改进 | 逐行 RS、镜头合成、裁切约束、水平保持、模糊感知分别单独启用比较 | 每一项都有同输入对照，改善不是仅由额外裁切、快门或降分辨率造成 |
| E：前瞻 | 恢复 DSP/编码缓冲协议后，测试例如 2–6 帧的有限窗口 | 明确额外 RAM/延迟，开始/停止/末帧排空和音视频同步均稳定 |
| F：视觉辅助 | 获取可用低分辨率帧，再加有界稀疏跟踪/融合；质量不足时自动退回 gyro | 动态前景不带偏相机轨迹；低纹理、夜间、遮挡和高速场景退化可控 |

指标至少包括：静止与步行残余角抖动、主动摇镜滞后/回弹、有效 FOV、直线/人物畸变、黑边率、清晰度变化、提交时限、掉帧、CPU/RAM、温度和连续录制稳定性。单一“稳定度分数”可能奖励把所有主动运动锁死的方案，应同时记录用户预期的摇镜响应。

**当前最建议投入的是 A–D；E 取决于管线恢复；F 为第二阶段；神经渲染、生成补边和完整大模型不作为这台机的实时开发目标。**

## 10. 来源与复核

正文所用来源索引见 [curated-sources.json](../artifacts/eis-research/curated-sources.json)；抓取 URL、UTC 日期、原文 SHA-256 和失败记录见 [sources.json](../artifacts/eis-research/sources.json)。HTTP 200 但只有加载壳/错误页的来源没有作为正文证据；研究过程中的错误候选 URL 或无关 arXiv 页面也未采用。商用资料只用于确认公开功能，不推断内部实现。

抓取脚本：`python3 scripts/eis_research_fetch.py 'https://公开来源URL'`。网页可随时间变化；GitHub 主参考实现使用上文固定提交。新专项位于工作区，先前 `yi4k-rtos-analysis.tar.gz` 是更早的逆向快照，不包含本调查。

[D1]: https://www.dji.com/osmo-action-6/faq
[D2]: https://www.dji.com/osmo-pocket-3/faq
[G1]: https://gopro.com/en/in/shop/cameras/hero12-black/CHDHX-121-master.html
[G2]: https://gopro.github.io/labs/control/settings/
[G3]: https://github.com/gopro/gpmf-parser
[I1]: https://www.insta360.com/product/insta360-ace-pro2
[I2]: https://www.insta360.com/product/insta360-x5
[P1]: https://graphics.stanford.edu/papers/stabilization/
[P2]: https://research.google/pubs/auto-directed-video-stabilization-with-robust-l1-optimal-camera-paths/
[P3]: https://www.microsoft.com/en-us/research/publication/meshflow-minimum-latency-online-video-stabilization/
[P4]: https://research.google/blog/fused-video-stabilization-on-the-pixel-2-and-pixel-2-xl/
[P5]: https://openaccess.thecvf.com/content/WACV2022/html/Shi_Deep_Online_Fused_Video_Stabilization_WACV_2022_paper.html
[P6]: https://openaccess.thecvf.com/content/CVPR2024/html/Peng_3D_Multi-frame_Fusion_for_Video_Stabilization_CVPR_2024_paper.html
[P7]: https://openaccess.thecvf.com/content/CVPR2024/html/Ali_Harnessing_Meta-Learning_for_Improving_Full-Frame_Video_Stabilization_CVPR_2024_paper.html
[P8]: https://github.com/huawei-bayerlab/GaVS
[P9]: https://openaccess.thecvf.com/content/CVPR2026/html/Liu_No_Labels_No_Look-Ahead_Unsupervised_Online_Video_Stabilization_with_Classical_CVPR_2026_paper.html
[P10]: https://arxiv.org/html/2602.23141v1
[A1]: https://github.com/gyroflow/gyroflow/blob/7c50b6370ffdacf38389e676b6008d8895206c51/src/core/smoothing/default_algo.rs
[A2]: https://vqf.readthedocs.io/en/latest/
