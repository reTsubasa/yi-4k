# 四条主线完成度审计

更新时间：2026-11-12。该审计只接受与目标同范围的证据：主机、静态 ARM、模拟器和 typed 事件不能替代相机运行期验收。用户本轮新增的顶部遮挡、液态玻璃层次、参数只读展示、快门即时反馈、飞入动画和保存连接诉求已映射到[任务清单 A1–A8](tasklist-2026-11-12.md)；对应实体设备证据仍单独列在 Android 缺口中。

## 已经可以直接复核的部分

- Android 0.5.1：216 项单测、Lint 0 errors、APK 构建通过；沉浸全屏、浅色毛玻璃、中心等比 fit、可调参数分组、无 App 咔擦声、PixelCopy 飞入和保存连接逻辑已落盘。真实 RTSP 只读复核 04 已证明取景流可解码，但实体手机的 HyperOS4 横屏/刘海、触感、飞入动画和冷启动连接现场验收仍缺。
- EIS 算法离线门禁：固定固件输入 hash、stock layout、候选 v2 行为和发布所有权均可复跑；`custom_eis_replacement_ready=false`，因为没有运行期 DSP latch/ack、旧槽复用、真实 gyro/帧锚或编码画质 A/B。
- 预录离线门禁：ring/SD POSIX 模拟 5 场景/15 断言通过；媒体 custody 进程退出 12 项通过；原厂 mux 生成可播放归档成片。它们没有接入实时 encoder/FIFO、实体 SD、相机语音或物理快门。
- 相机只读基线：readiness probe 03/04 前后均为 `idle`，固件 `Z16V13L_1.10.7`、EIS `on`、SD `insert` 和设置快照一致；RTSP 04 收到 73 个 H.264 包并解码首帧后恢复 `idle`；语音设置只读探针 01/02 均确认普通设置列表没有 `voice_*`/`keyword_*` 字段，`buzzer_ring=off`。这些回执没有执行拍摄、设置写入、RTC 写入、RTOS shell 或启动脚本。

## 仍然缺少、且不能由离线结果替代的验收

| 主线 | 缺口 | 需要的证据 |
| --- | --- | --- |
| EIS 原生执行 | 受控入口、I-cache/ISB、SMP 完成、DSP 发布/反馈、停止和独立恢复 | 真机运行期 trace、原厂视频、失败保留和回滚复核；任何 hook/代码加载前需单独批准 |
| EIS 算法替换 | 真实 gyro/镜头轴向/曝光帧锚、warp ABI 发布、画质 A/B | 同一运动条件下原厂与候选编码视频、逐帧参数、失败恢复材料 |
| 一分钟预录 | 实时 FIFO/callback、60 秒实体 SD ring、满卡/掉电恢复、原厂 mux 成片 | 触发前后完整 H.264/AAC 文件、播放/解码证据、物理故障注入和状态恢复 |
| 语音/快门触发 | 原厂“开始录像”/`start recording` 实际识别、事件送达、实体快门去重 | 相机现场语音和快门各自触发的同一预录状态机及成片 SHA |
| Android | 真实手机刘海/横屏/触感/飞入动画、热点冷启动自动连接 | 实体手机安装包、截图/录屏、连接和拍摄回执 |
| RTC | 相机时钟写入和读回 | 显式授权后的前后时间快照与恢复检查 |

## 可直接执行的安全检查

```sh
cd /Users/hyc/Documents/yi4k
.venv-reverse/bin/python scripts/audit_eis_replacement_readiness.py \
  --output artifacts/verification/2026-11-12-eis-replacement-readiness-run03
.venv-reverse/bin/python scripts/validate_prerecord_ring_sd_backend.py \
  --output artifacts/verification/2026-11-12-ring-sd-run15
.venv-reverse/bin/python scripts/validate_prerecord_media_store_recovery.py \
  --output artifacts/verification/2026-11-12-media-store-recovery-run02
.venv-reverse/bin/python scripts/audit_eis_native_evidence_consistency.py \
  --output artifacts/verification/2026-11-12-eis-native-consistency-run03
.venv-reverse/bin/python scripts/audit_eis_candidate_quality.py \
  --output artifacts/verification/2026-11-12-eis-candidate-quality-run03.json
```

这些检查均声明 `device_access=false`；本轮新增的 EIS 一致性检查为 49 项，候选行为检查覆盖 6604 个合成网格帧。真机阶段需要先形成具体的停止、清理和回滚方案，再取得对应授权；在此之前不能把目标状态升级为完成。
