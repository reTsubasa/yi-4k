# Packet custody 主机恢复

2026-11-11：修复首次容器重建的时间偏移，固定样本通过严格发布校验。`recover_prerecord_custody.py` 仅使用失败封装后的两个 MP4 extent 和 custody 保留的 AAC12/25，重建完整 16 帧视频及 26 包音频。完整原片只在输出构造后作为独立 oracle，没有提供恢复字节、配置或时间戳。

## 实现与证据

首次裸 H.264 + FFmpeg 推断时间戳的失败结果完整保留：`artifacts/verification/2026-11-11-prerecord-custody-recovery-run01/audit.json`。该方式引入四帧时间偏移，并在首 IDR 加入参数集，已被替换。

新路径复制失败 MP4 的原 stsd 编码配置和每个媒体包，直接重建 ISO BMFF 时间、样本大小、chunk 偏移、sync sample 与 duration 表；使用已审计的归档零起点、30000/1001 视频和 48000/1024 音频时基。重建时不经过编码器或裸码流解析器，不沿用失败切段 edit list。拒绝 B 帧/重排、不同 track clock 和未固定配置。

- 正例：`artifacts/verification/2026-11-11-prerecord-custody-recovery-final-run03/audit.json`，`pass_host_recovery_only`。16 视频 + 26 AAC 的每包 payload、PTS、DTS、duration 精确相同；16 个解码帧和 106496 字节连续 PCM 与 oracle 匹配。输出 `recovered.mp4` SHA256：`76fd3a2c1bf9a3f561aab81ac5418557b4fa93241661911c6f3b5c09c76adf7a`。
- 缺少 custody：`...-final-omit-run02/audit.json`，16/24 包，拒绝，保留 pending，不发布。
- custody 字节篡改：`...-final-corrupt-run02/audit.json`，16/26 包仍被 payload 门禁拒绝，保留 pending，不发布。
- 主线程独立检查：[可复跑验证器](../scripts/verify_prerecord_custody_recovery.py)及[独立检查回执](../artifacts/verification/2026-11-11-prerecord-custody-recovery-independent-review.json)。重新读取 42 包全部时间与字节、正负例最终文件存在性和成片 SHA，并独立比较 16 个解码帧和连续 PCM。此前的 `2026-11-11-prerecord-custody-recovery-review.json` 保留为早期检查记录。

```sh
.venv-reverse/bin/python scripts/recover_prerecord_custody.py --output artifacts/verification/new-custody-recovery
```

## 与最终目标的距离

这项证明失败封装后仍可用保留包无损恢复固定归档窗口，不是相机内一分钟预录后端。恢复时间依据来自已知零起点、无重排的归档映射；实际 callback/session/硬件共同 A/V epoch 必须另行保存并验证。未实现 RTOS/SD 落盘、实时一分钟缓冲、一般损坏媒体修复或真实语音/快门接入。未连接或写入相机。
