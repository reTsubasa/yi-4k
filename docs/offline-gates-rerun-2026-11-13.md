# 离线主线门禁复跑（2026-11-13）

本轮仅使用工作区中的固定固件镜像、既有分析回执和本机生成的 host 输入。没有连接相机、执行 RTOS/ORC、写入固件/RAM/分区/RTC/SD，也没有触发语音或物理快门；因此这些结果不能替代 G2-G5 真机验收。

## EIS 原生与算法替换

| 门禁 | 结果 | 证据 |
| --- | --- | --- |
| 替换 readiness 静态哈希与负向边界 | 8 checks passed；`custom_eis_replacement_ready=false` | `artifacts/verification/2026-11-13-eis-replacement-readiness-run01/audit.json`，SHA-256 `6fc0fdb7e65ed7acaa4a25ff1c3a22e0b6d7fc83e281b2aa25672418f8a5ee19` |
| native provenance 一致性 | 49 checks passed；`device_access=false` | `artifacts/verification/2026-11-13-eis-native-consistency-run06/audit.json`，SHA-256 `429ce7b14bd29229f50874c19c99f41e83520ea3f44d8cf79b633dde87c9f0c8` |
| 候选角度/mesh 行为 | 6,604 帧；合成输入；未做编码画质 | `artifacts/verification/2026-11-13-eis-candidate-quality-run02.json`，SHA-256 `35de27ac6750009dc9e7cbdf2fadb84a2aca498df7de341f7d844611560ad77a` |
| 原厂 ARM mesh 兼容性 | 9 cases、19,809 active points；最大连续 affine 误差 0.1779 px | `artifacts/verification/2026-11-13-eis-candidate-stock-affine-run02/audit.json` |
| 三轴 sweep | 27/27 accepted；最大 affine 误差 0.1779 px；无设备访问 | `artifacts/verification/2026-11-13-eis-candidate-stock-affine-sweep-run02/sweep.json` |
| 归档候选输入资格 | 9 stock cases；`real_candidate_replay_eligible=false` | `artifacts/verification/2026-11-13-eis-candidate-archive-run02.json`，SHA-256 `08ea2dc09cb293cacd8294867d559c67e39e396990d570deb79cada9b13f9516` |

结论仍是：真实 gyro/镜头轴向/曝光锚定、编码视频 A/B、DSP 身份与 latch、原生替换入口和旧槽位安全复用均未证明，不能发布候选算法或宣称原生 EIS 已完成。

## 一分钟预录

| 门禁 | 结果 | 证据 |
| --- | --- | --- |
| POSIX ring/SD 语义模拟 | 5 cases、15 assertions；`device_access=false` | `artifacts/verification/2026-11-13-prerecord-ring-sd-run02/validation.json`，SHA-256 `bc003646e9ca209dc71bde26e0614e1b051a7f3eb6c08cbc67171b4919c8c0be` |
| 进程退出 custody 恢复 | 12 tests，0 failures/0 errors | `artifacts/verification/2026-11-13-prerecord-media-store-recovery-run03/validation.json`，SHA-256 `1796530aa5a44432447ba3bd156955cf68d3ffbb558511b98acfeefdfc41fb8b` |
| 原厂 mux 发布正/负对照 | 正例发布；+100 ms 音频偏移负例拒绝并保留材料 | `artifacts/verification/2026-11-13-prerecord-publication-gate-run01/audit.json`，SHA-256 `50713a65471bd95bbe4a88b277f14f09c5801359113fceca099a93191fdeabdc` |
| voice/shutter 到 START 的语义边界 | 8 checks passed；`device_access=false` | `artifacts/verification/2026-11-13-voice-prerecord-binding-run01.json`，SHA-256 `366e388a769498b355ef407e0c7c69be621f7a7d6284fc713e87c1d7c3c9aabe` |

这些门禁只证明主机 ring、封装、失败保留和语义绑定。实时 encoder/FIFO、共同 A/V epoch、实体 SD 满卡/掉电恢复、相机原厂语音事件、物理快门和可播放真机成片仍待 G4-G5，并且需要单独批准。

## 回归测试

使用 `.venv-reverse/bin/python -m unittest` 串行执行 EIS candidate mesh/affine 与 prerecord buffer、media store、native spool ring、trigger 测试，共 21 项通过。未使用已导致相机死机的 `/dev/mem` 探针。
