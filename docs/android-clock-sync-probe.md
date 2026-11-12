# Android 相机时钟同步入口审计

本页只记录主机源码入口，不把它当成真实相机已经同步。审计回执见
[clock-probe-contract.json](../artifacts/verification/2026-11-12-android-clock-probe-contract/clock-probe-contract.json)。

`liveCameraProbe` 的时钟写入默认关闭。只有显式传入
`-PsyncClock=true` 才会调用 `CameraConfiguration.syncClock()`；探针把手机请求时间、相机读回值和二秒内校验结果写入 evidence。默认的只读命令保持：

```sh
./gradlew liveCameraProbe \
  -PcameraHost=192.168.42.1 \
  -PrecordSeconds=0 \
  -PcapturePhoto=false \
  -PchangeSetting=false \
  -PsyncClock=false \
  -PprobeOutput=/absolute/path/evidence.json
```

真实同步命令必须单独确认相机状态、电量、SD 和恢复条件后再运行：

```sh
./gradlew liveCameraProbe \
  -PcameraHost=192.168.42.1 \
  -PrecordSeconds=0 \
  -PcapturePhoto=false \
  -PchangeSetting=false \
  -PsyncClock=true \
  -PprobeOutput=/absolute/path/clock-sync-evidence.json
```

本轮只执行源码审计和已有 loopback 单测，没有连接相机、写入 RTC 或生成新的真机回执。因此“相机系统时间已和 App 同步”仍需一次单独的真机验收；验收后应保留 evidence 中 `clock_sync.requested_at`、`readback`、`readback_verified` 和前后设置快照。
