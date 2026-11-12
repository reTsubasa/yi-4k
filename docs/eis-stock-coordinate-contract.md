# 原厂 warp 坐标：限定 profile 的原码验证

2026-11-12。这轮把“`int16` 但单位未知”收紧为一项可复跑的局部合同：**原厂旋转把校准格点坐标乘以 16，加上已有位移，绕几何中心旋转后减回坐标。校准输入是位移对，精度为每个校准坐标 16 单位。** 在本轮合成的 1920×1080、1:1 几何下，常量位移原值进入两个输出平面，包括 `+1/-1` 亚像素单位。

这不等于候选 normalized 采样坐标已经兼容原厂 ABI。DSP 采样方向、实际校准到输出的几何比例及实机窗口原点没有闭合，因此没有新增凭假设转换单位的 candidate→stock 适配器，`stock_abi_compatible` 和 `replacement_deployment_ready` 均保持 `false`。

复跑入口：[audit_eis_stock_coordinate_contract.py](../scripts/audit_eis_stock_coordinate_contract.py)。结果：[audit.json](../artifacts/verification/2026-11-12-eis-stock-coordinate-contract/audit.json)。仅使用既有归档，无设备连接、固件写入或部署。

```sh
.venv-reverse/bin/python scripts/audit_eis_stock_coordinate_contract.py
```

## 原厂执行范围

固定镜像 SHA-256 为 `eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，基址 `A0100000`。脚本核对 15 条精确指令及 `A032D8B8` 的 double 常量 `65536.0`，执行原始 ARM/Thumb 字节：

- `A032CF38`：校准输入复制、旋转、重映射和阶段状态；
- `A032C940`：垂直重映射；
- `A032B520/A032A4B8`：视频双平面生成和校准插值；
- 原厂 cos、sin、memcpy 包装与底层实现、memset、除法及可达阶段助手。

没有替换任何被调用函数。函数表被设置为原始 copy/memset 地址；日志指向陷阱，17 个场景均未进入日志。原厂 copy 的线程上下文检查所读 `A17962E8` 所在页由主机映射为零，这只是合成环境中的“无当前 RTOS 线程”条件；不代表运行完整 RTOS。VFP 由 Unicorn 启用，指令计数不代表 CPU 时间。

输出地址、函数参数和全局环境均是主机自有合成内存。原厂 producer mutex、context lookup、table ring、cache clean、状态发布及 DSP 消费没有执行，不能把这轮结果表述为设备所有权或硬件渲染验证。

## 格点、原点、方向与量化

本轮校准输入固定为 4×4、水平/垂直 tile exponent 均为 11、版本 `20140701`，几何各窗口均为 1920×1080，比例字节均为 1。control 为零，校准 remap 标志启用。

原厂 `A032CF38` 读取 `calc_info+B8` 的 double 并取负，调用原厂三角函数。6 个正负 theta 场景的系数均满足：

```text
c = trunc(cos(-theta) * 65536)
s = trunc(sin(-theta) * 65536)
x = (column << (tile_x_exponent + 4)) - center_x_q4 + dx
y = (row    << (tile_y_exponent + 4)) - center_y_q4 + dy
dx_new = signed16((signed32(x*c - y*s) ASR 16) - x + dx)
dy_new = signed16((signed32(y*c + x*s) ASR 16) - y + dy)
```

本轮原点是 `(960*16, 540*16)`。`theta` 的使用与弧度三角函数一致。乘积按原 ARM 32 位运算回绕，随后是**带符号算术右移**，负值向负无穷量化；这与系数转换的向零截断是两种不同规则。最后半字存储会回绕为 signed16。参考模型故意包含这些行为，6×16 个旋转后、重映射前的格点逐点相等。

符号只在这个 CPU 坐标运算中得到证明：正 theta 经过取负进入旋转；正输入 `dx/dy` 加到坐标中。**尚未证明 DSP 最后把表解释为 destination→source 还是 source→destination，因此没有把符号命名为最终图像向左/右移动。**

## 输入到双平面的局部合同

5 个零旋转场景覆盖零、`(16,32)`、`(-16,-32)`、`(1,-1)` 常量和仿射格点。常量场景的有效 X/Y 元素分别与输入分量逐值相等。仿射场景与旋转场景保留原厂全部生成链并归档输出，不把垂直重映射当成简单逐元素复制。

原厂插值入口的全部查询已记录并断言：

| 平面 | 有效点 | 插值查询坐标 | 内存行 pitch | descriptor spacing |
|---|---|---|---|---|
| X | 31×35 | `(64*col,32*row)` | 32 个 int16 | `[2,1]` |
| Y | 31×36 | `(64*col,32*row)` | 32 个 int16 | `[2,1]` |

每次完整调用共 2201 次插值。descriptor 的宽高字节仍是索引上界；这里的 spacing 字节与查询步长满足 `1 << (byte+4)`。本轮只验证这一 profile，不能直接推广到宽屏实际 pitch 或其他控制位。

scratch 初始填 `A5`。每个有效矩形的逐字节写集与预期相等，未写 padding 保持原值，源 calc_info 和校准 grid 均未改。归档还保存旋转前后重映射边界、描述符及完整 `3000` 字节平面，便于后续独立复查。

另有 6 个 control8/raw-vertical 场景，固定非负 `calc_info+78` 为 Q16 整数 `0,4095,4096,65535,65536,524288`，原始 `A032B520` 输出 Y 分别为 `0,0,1,15,16,128`，X 清零。这独立支持该分支从 Q16 窗口偏移到 1/16 单位的转换；它没有证明负偏移或其他 control 分支。

## 接入候选算法还差什么

现有候选输出是 normalized Q16.16 的绝对采样坐标；本轮原厂输入是校准坐标域的 signed16 位移。把二者直接乘 16 不成立。需要先恢复实际采样域、几何缩放、裁切和镜像，再确认 DSP 方向，并在匹配的格点坐标上计算位移。

仍需补齐实际 runtime calc_info、gyro 轴/单位与曝光/逐行时间、consumer 帧身份和截止时间。原 scratch 成功返回边界与原厂 ring 的复用原则仍见 [producer 合同](eis-stock-producer-contract.md)，本轮没有改变它们。原生 loader、代码缓存发布、恢复与撤销由独立执行线继续处理。
