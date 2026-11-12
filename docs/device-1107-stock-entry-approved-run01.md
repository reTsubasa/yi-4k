# 最小 stock 入口验收：真机输出通过并已清理

2026-11-12。用户在获知“低但非零风险、无法保证绝对不变砖”后，明确批准[已审阅的最小方案](device-1107-stock-entry-acceptance-plan.md)。授权只覆盖该两行原厂只读诊断、SD归属文件、一次用户正常关机/开机、结果采集和匹配归属后的清理，不包含自定义ARM、固件/分区/RAM写入、EIS调试开关或录像。

当前状态：**用户确认正常关机再开机、回连Wi-Fi后，取得原厂任务概要和正确8字节指纹；两次采集稳定，脚本已移除，剩余三个诊断文件已归档清理，最终只读预检确认四个路径全部不存在。** API idle和所选设置在所有成功操作前后保持一致。没有发送软件reboot或执行自定义ARM。

## 已执行的设备操作

- [只读预检](../artifacts/device/2026-11-12-stock-entry-approved-preflight/session.json)：完整1.10.7构建、硬件YDXJ2_V13LW、API idle、SD insert；`c: /tmp/SD0 ambafs rw`，不是symlink；四个目标路径均不存在。
- [暂存回执](../artifacts/device/2026-11-12-stock-entry-approved-stage/session.json)：绑定预检boot ID `b90163f5-7881-4229-85fe-6348f1eec930`，独占先写564字节claim、再写105字节两行autoexec；两个文件fsync并回读摘要匹配。两个预期输出均不存在，boot ID未变，API前后相同。
- [传输回执](../artifacts/device/2026-11-12-stock-entry-approved-stage/transport.json)：执行的review-stage源码SHA为 `11ea415993bd1d8d7e9db12794db3526b41c13a928775d10771d5802c017149b`，等于原dry-run固定版本。没有额外上传目标Python文件或worker。

autoexec SHA256 `ecc127f17cf1fd9d188112857da4e332eb3e3f20f9e9b2345cbd8a9827638dd4`：

```text
ps tsk > c:\yi4k_entry_5345a5ec7c52_tasks.txt
savebin c:\yi4k_entry_5345a5ec7c52_code.bin 0xA0394BA0 l 8
```

claim SHA256 `5b6e8167ec9830e7421def5a649c397f12ff087f2e4cbf7b9a62ff5c741619c4`。四个精确路径和清理条件仍以原方案为准。

## 重启、输出与清理结果

用户明确回复“已正常关机再开机，且已连回相机Wi-Fi”。重启前boot ID为 `b90163f5-7881-4229-85fe-6348f1eec930`，采集后为 `a96eb3f9-9fc5-4adb-b062-a2fe8ebb53c2`，后续采集与最终预检保持该值。

- [首次采集](../artifacts/device/2026-11-12-stock-entry-approved-collect01/session.json)和[重复采集](../artifacts/device/2026-11-12-stock-entry-approved-collect02/session.json)的四文件内容逐字节相同。任务概要8181字节，SHA256 `469b2af31b5ca46e10a3bc91f7f2bbb93953e63178d2cfe3c400b6ead8543b7f`，包含 `AmbaShell_ExecTask`、`AmbaImageMainEisTask`、`AmbaImageMainEisAlgo2Task`、`VoiceCmd_Task`；任务存在不证明算法更新或语音触发已接入。
- 固定指纹严格为 `0300a0e11eff2fe1`，8字节，SHA256 `5e64b91b57eaf124341a5f84484d853cfe5e97bae40e8d7c8bf60c7ed4c6969d`，与审阅方案一致。[首次本地归档](../artifacts/device/2026-11-12-stock-entry-approved-archive01/verification.json)的三项检查通过。
- [disarm](../artifacts/device/2026-11-12-stock-entry-approved-disarm/session.json)只移除摘要匹配的autoexec；[移除后采集](../artifacts/device/2026-11-12-stock-entry-approved-collect03/session.json)确认脚本不存在、其余三文件字节不变。依据[新的本地归档](../artifacts/device/2026-11-12-stock-entry-approved-archive03/verification.json)绑定快照执行[cleanup](../artifacts/device/2026-11-12-stock-entry-approved-cleanup/session.json)，只删除三个归属文件。
- 清理后误用collect动作，被其“必须存在归属文件”检查拒绝，未再执行删除；[失败回执](../artifacts/device/2026-11-12-stock-entry-approved-final/session.json)和原始错误保留。随后[最终只读preflight](../artifacts/device/2026-11-12-stock-entry-approved-final-preflight/session.json)确认相同boot ID、四路径不存在、SD仍正常挂载、所选API基线未变。没有放宽collect的归属检查或重新创建claim。

[本地主机生命周期复核](../artifacts/device/2026-11-12-stock-entry-approved-lifecycle-review.json)重新核对8个成功session、失败采集、传输源码摘要、两次归档文件字节、输出指纹与最终状态；可运行 `python3 scripts/verify_stock_entry_completed_run.py` 复现，不连接设备。

首次采集 `/proc/uptime` 原样为 `271952704.26 45.42`，明显不能据此解释本次正常启动的实际运行秒数；完整原值保留在回执中，原因未定位。这里只依据用户正常开关机确认及boot ID变化记录新启动，不宣称已证明SoC冷复位。重复文件稳定也不证明所有异步reader已静止。

## 主机管理器

[device_stock_entry_acceptance.py](../scripts/device_stock_entry_acceptance.py)固定bundle摘要和每份review源码身份。它逐块把base64源码放入本次Telnet shell进程环境，每块384字符、每行低于900字节并逐块核对长度；目标Python在执行前核对解码后完整SHA。最后清除本次环境变量。源码不保存为相机文件，不修改审阅的stage操作。

本地主机实际 `/bin/sh` 子进程已验证多块传输后执行精确源码、错误摘要在执行前拒绝；实际设备运行进一步确认Python2 common-subset、环境传输、fsync和独占文件写入通过。传输没有密码学设备认证，也不保证未来总线/存储或启动不会异常。

本次已完成暂存→用户正常启动→采集→本地归档→重复稳定观察→disarm→再采集/摘要一致→重新归档→cleanup→最终路径与API复核。它证明本次原厂脚本产生了预期只读输出，并完成归属清理；API基线只覆盖app_status和固定8项设置，不代表完整设备健康。清理后的路径不存在没有再经第二次重启耐久验收。不能当成自定义机器码进入/返回、cache同步、独立恢复或正常录像功能验收。P1/P5/P11仍未闭合，后续影响相机运行的实验不在本次授权内。
