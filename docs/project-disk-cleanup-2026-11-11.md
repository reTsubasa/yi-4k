# 2026-11-11 项目磁盘清理

按用户要求，删除项目内可重新生成的 Android 模拟器运行磁盘、Android 构建缓存和 Python bytecode。清理前核对没有 emulator/qemu/Gradle 活动进程，保留配置快照与删除清单。

- 项目 `du -sk` 从 15,624,956 KiB 降至 7,220,880 KiB，约 14.90 → 6.89 GiB。
- 按删除文件实际已分配块合计释放 8,632,983,552 bytes，约 **8.04 GiB**；包括两套 AVD、`android/app/build`、`android/.gradle` 、bytecode 缓存及已验证重复的Ghidra下载压缩包。
- 保留全部固件原件、逆向导出、历史成功与失败记录、归档 APK、源码、Python 环境、Ghidra、FFmpeg 和参考资料。
- Ghidra压缩包中的5,324个文件与保留的完整安装目录逐项比较完全一致后，才删除543 MiB下载包；[比较记录](../artifacts/verification/2026-11-11-disk-cleanup-run01/ghidra-archive-comparison.json)保留归档SHA-256和比较范围。
- 产品 APK 0.3.14 清理前后 SHA-256 均为 `1503d3bd73d39cd9985c69c2aea04e81b1d863c31e2486cad943a2aa77f6ebe6`。
- [清理记录与逐文件清单](../artifacts/verification/2026-11-11-disk-cleanup-run01/cleanup.json)及其同目录 `avd-configurations/` 保留已删除 AVD 的 ini 配置。运行数据可由 `scripts/android_emulator_acceptance.py` 重建。

## 后续验收不积累模拟器磁盘

runner 增加 `--test-apk`，允许直接安装已归档测试 APK，无须先恢复构建缓存。`--discard-avd-on-success` 仅在本次 instrumentation 通过、当前模拟器退出已确认、相机清理也未报告错误后，备份 ini 并删除这个项目直接拥有的 AVD；失败/不确定退出时保留运行数据供诊断。重定向为 symlink 的 AVD 路径拒绝删除，记录 `avd_disposal`。

这两项通过实际重建验证：使用未修改的 0.3.14 产品 APK 和归档 `tests-largev1`，本地默认媒体/编辑7项、pending筛选1项及设置几何1项，共9项通过；模拟器确认退出后清理 505,745,408 bytes 的运行磁盘。构建目录仍不存在，证明没有靠重新构建绕过归档 APK 路径。

[实际9项与清理结果](../artifacts/android/0.3.14-device-reports/archived-apk-local-suite-discard-run01/acceptance.json)。本轮没有新相机访问或任何相机写入。

```sh
python3 scripts/android_emulator_acceptance.py \
  --output /tmp/yi4k-archived-local-check \
  --apk artifacts/android/yi4k-control-0.3.14-debug.apk \
  --test-apk artifacts/android/yi4k-control-0.3.14-tests-largev1.apk \
  --discard-avd-on-success
```

上例使用默认7项本地套件；实际归档记录使用明确的9项类列表，不将两种执行范围混称。
