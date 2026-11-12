# 原厂 RPC 外部入口负向审计

更新时间：2026-11-12。

审计脚本在 Unicorn 中执行本机 1.10.7 原始 ARM 控制流，外部 allocator、port 和 task service 为合成桩；没有连接相机、没有访问 SD、没有写 RAM/固件，也没有发送真实 RPC。回执为 [audit.json](../artifacts/verification/2026-11-12-native-rpc-external-entry-run01/audit.json)，状态 `pass_bounded_negative_entry_audit`。

首次 `rpc svc test +` 会分配 0x1000 字节任务栈、临时 0x10 字节表、0x39c service 对象和额外 0x10 字节对象，注册固定 handler 与固定任务入口 `0xA03CAE84`，随后创建原厂任务。重复注册只再分配任务栈和临时表，命中 “Prog already registered” 分支并释放临时表，不创建任务；在该原始控制流模型中，新增栈没有归属。这是离线控制流的负向发现，不是物理内存泄漏测量。

外部参数不能控制 handler 或 function pointer；`exec1/exec2` 只把命令转发到 Linux，未发现 ARM loader 语义。审计没有证明 I-cache/SMP 发布、完成回执、撤销、回收、独立恢复或自定义 EIS 执行。因此该路径从 EIS 原生 loader 候选降级，不能用于真机部署。

