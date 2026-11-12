# 预录 native spool ring 到原厂 MP4 的离线闭环

更新时间：2026-11-12。

本轮把已归档的原厂分段包逐包写入项目内 C `yi4k_packet_spool`，用独立 source ledger 封口，再由新的 C reader 扫描、校验并交给原始 ARM MP4 mux。voice 和 shutter 只是在 typed trigger 路由层使用两种来源；两路必须得到同一段选择和同一份成片。整个实验没有连接相机、没有安装 encoder callback、没有写实体 SD、没有修改固件/RAM，也没有执行真实麦克风或 GPIO。

## run03 结果

- voice 与 shutter 均消费 4,919 个归档包；触发后固定保留 60 秒窗口及尾部，淘汰旧的 segment 1，并把触发锁定的闭段保留到发布完成。run02 仍作为历史回执保留。
- 两路新进程导出均通过 C spool reader、独立包/时序门禁、FFmpeg 8 完整解码和原厂 ARM mux；输出都是 343,127,606 bytes，SHA-256 为 `cffc226da6e496cd6df8d4294c1d295c4bdefe7ece4efe289f597b7b85e3ee5a`，包含 1,831 个视频包和 2,863 个 AAC 包。
- interrupted 在原厂 mux close 后以退出码 73 保留 `session.pending.mp4`，没有发布 `clip.mp4`；Close failure 注入返回 `-12`，同样保留 pending 和所有输入。恢复后的 pending 与成功 voice 成片字节一致。
- 独立复核 [run03 review](../artifacts/verification/2026-11-12-native-spool-ring-parent-review-run03/review.json) 检查了 378 个保留文件；未固定 ring、截断 spool、修复 CRC 后的三个负例均在原厂 Open 前拒绝，未生成可见成片，原始输入哈希保持不变。

## 失败可恢复边界

每个闭段同时保存 source ledger、spool 和 seal；新 reader 必须验证完整覆盖、记录身份、CRC、payload SHA 和配置 digest。发布使用 pending → final 的持久化门；重命名后的目录同步失败会把状态标为 publication uncertain 并保留可见 final。进程退出或原厂 Close 短写时只保留 pending/原始 spool，后续恢复进程从保留材料开始，绝不从已发布文件反推缺失包。

ring 的字节预算是 host 逻辑预算，包含 manifest、ledger 和 seal 的临时共存开销；它不是实体 SD 容量、掉电原子性或坏块保证。C close 的“完成”来自 host 接受的 source ledger，不等于真实 camera callback 已停止。

## 与三条主线的关系

这轮证明了“归档编码包 → C spool/seal → 新 reader → 原厂 ARM mux → 可播放 MP4”的可审阅接缝，并证明 typed voice/shutter 路由的幂等和失败保管。仍缺实时 encoder/FIFO callback、真实 session epoch、实体 SD 吞吐/掉电/满卡恢复、原厂语音事件及物理快门绑定；因此不能把它记为真机一分钟预录完成。

脚本与证据：

- [scripts/prerecord_native_spool_ring.py](../scripts/prerecord_native_spool_ring.py)
- [scripts/verify_prerecord_native_spool_ring.py](../scripts/verify_prerecord_native_spool_ring.py)
- [run03 independent review](../artifacts/verification/2026-11-12-native-spool-ring-parent-review-run03/review.json)

