# 原厂陀螺仪输入：原码合同、名义单位与失败边界

2026-11-12。针对本机 1.10.7 固定 RTOS 映像，执行原始 `gyro_get_info`、`gyro_open`、`gyro_read(mode=1)` 和 `GyroParamInit` 指令，22 个场景、14 条指令定位全部通过。此结果补齐算法输入的**原始数值格式与原厂名义系数**，尚不能把历史采集数据认定为经过标定的角速度，也没有解锁相机部署。

证据：[运行回执](../artifacts/verification/2026-11-12-gyro-input-contract/audit.json)、[62 字节原厂 descriptor](../artifacts/verification/2026-11-12-gyro-input-contract/descriptor.bin)、[审计程序](../scripts/audit_gyro_input_contract.py)。复现：

```sh
.venv-reverse/bin/python scripts/audit_gyro_input_contract.py
```

映像 SHA256：`eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c`，基址 `0xA0100000`。函数范围及逐段摘要记录在回执中。SPI、sleep、日志及 memset 为显式主机模型；原函数与两个除法 helper 均执行未修改的映像指令。RAM 初值为合成零，不冒充实际设备内存；没有连接相机、写入设备或测量实际采样率。

## 初始化与器件资料

`gyro_open` (`0xA047F0F8`) 先以 SPI 命令 `80` 读取 CHIP_ID，并检查返回字节 `D1`，然后依次发出：

| 命令字节 | 按 Bosch BMI160 资料解释 |
| --- | --- |
| `7E 11` | 加速度计 normal mode 命令 |
| `7E 15` | 陀螺仪 normal mode 命令 |
| `40 2C`、`41 08` | 加速度计配置及量程 |
| `42 0D` | GYR_CONF：ODR code `0D`，gyr_bwp `00` |
| `43 03` | GYR_RANGE：名义 ±250°/s |

两条 power mode 命令后各调用一次 sleep，参数为 `5`；本审计没有证明该参数对应的实际等待时长。初始化没有读取配置回执、ERR_REG 或 PMU_STATUS，不能从“发出配置”升级为“硬件已按配置运行”。全部配置写入返回失败时，原函数仍返回 `0`。CHIP_ID 不符时返回 `0xFFFFFFFF` 并写入失败标志；读调用返回错误但 RX 中仍有 `D1` 时也可继续成功路径。

这组标识和寄存器序列与 BMI160 资料一致；实际器件封装、硅版本仍待设备侧证据。引用 [Bosch 原厂资料](https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bmi160-ds000.pdf)（本地 [PDF](../artifacts/verification/2026-11-12-gyro-input-contract/reference/bst-bmi160-ds000.pdf)、[来源回执](../artifacts/verification/2026-11-12-gyro-input-contract/reference/source.json)）：BST-BMI160-DS000-09，Revision 1.0，November 2020，晚于固件年代，不能据此宣称实际硅版本相同。

- 第 49–50、52 页：CHIP_ID `D1`、三轴数据、SENSORTIME、STATUS 寄存器。
- 第 60 页：GYR_CONF 的 ODR code `0D` 对应名义 3200 Hz；第 21 页说明带宽模式。这里只恢复写入位与资料含义，没有实测 3200 Hz、合法配置状态或独立样本节律。
- 第 61 页：量程 `03` 为 ±250°/s，典型灵敏度 131.2 LSB/(°/s)。
- 第 9 页：±250°/s 档在 25°C 的灵敏度 min/typ/max 为 127.2/131.2/135.2，存在偏置和温漂。
- 第 86 页：PMU 命令编码及执行时间；本审计没有测量硬件执行完成。

## 原始样本格式

`gyro_read(1, output)` (`0xA047EDE4`) 发起长度 `7`、命令首字节 `8C` 的 SPI 读取：一个 dummy 字节，随后为寄存器 `0C..11` 的三个 little-endian 16 位原始值。

descriptor `+4` 为 `0x0100` 时 X/Y 顺序不变，否则交换 X/Y；Z 不变。各输出加 descriptor `+0x3C` 的 `0x8000`，按 halfword 截断。模式 1 的有效输出为三个 **unsigned 16 位、以 32768 为中心**的值：

```text
u = (raw_signed + 32768) modulo 65536
raw_signed = int(u) - 32768
```

这一步不能把输出先读为 signed16 再减 32768。测试覆盖正负极值、零、±1、轴交换、旧样本及部分更新。此处 X/Y/Z 是驱动输出顺序，尚未恢复相机坐标方向或光轴关系。

模式 1 不读 SENSORTIME (`18..1A`)、STATUS (`1B`) 或 FIFO，也不检查 SPI 返回值。故障模型中：

1. SPI 返回失败且不修改 RX 时，仍返回 `0`，交出完整旧样本。
2. SPI 返回失败且只更新 X 的字节时，仍返回 `0`，交出新 X 与旧 Y/Z 的混合结果。

这些是**受控失败注入证明的驱动行为**，不表示已经观察到真实总线故障。模式 2/3 的额外字段和调用者行为不在本次运行范围内。相同数值也可能来自静止场景，不能仅靠“数值重复”判断陈旧。

## 原厂名义系数

原始 `gyro_get_info` (`0xA047F2A0`) 第一次构造并复制 62 字节 descriptor，后续受一次性 guard 控制，只复制已有值。关键字段：

| 偏移 | 原始值 | 本次用途 |
| --- | --- | --- |
| `+04` | `0100` | 模式 1 X/Y 分支 |
| `+0E/+0F` | `1/1` | offset 缩放分子/分母 |
| `+1A/+1C` | `8A3C/75C4` | unsigned offset 两端 |
| `+1E/+20` | `135/127` | 灵敏度整数两端 |
| `+22/+24` | `100/250`（十进制） | 原始 descriptor 字段；不据此推断实测采样率 |
| `+3C` | `8000` | 采样输出 level shift |

把实际生成的 descriptor 复制到 `0xA1702CC0` 后执行原始 `GyroParamInit` (`0xA037F55C`)，得到：

```text
offset_q8 = ((0x8A3C << 8) + (0x75C4 << 8)) / 2 = 8388608
offset = 8388608 / 256 = 32768
sensitivity_q8 = ((135 << 8) + (127 << 8)) >> 1 = 33536
stock_nominal_sensitivity = 33536 / 256 = 131 counts/(°/s)
```

三轴 offset 与 sensitivity 相同。原厂初始化使用的名义系数 **131** 与资料典型值 **131.2** 应保留区别；二者均不是本机实测标定结果。后续算法若使用 `raw/131`，必须标记为“原厂名义系数”，并保留原始 counts；不能静默把旧归档重标为真实角速度。

## 算法接入仍缺的条件

输入格式与原厂位移[坐标合同](eis-stock-coordinate-contract.md)现已各自固定，但中间仍缺真实配置读回、独立采样节律/新鲜度、温漂与偏置标定、相机三轴方向、视频帧与 gyro 的共同时间锚，以及 DSP 采样方向与裁切几何。下一次设备侧只读采集应保留原始 counts、调用前后时间和可验证的传感器状态；现有采集包装器尚未改动。本次不会据此宣称实际替换算法、真机画质改善或安全发布兼容。
