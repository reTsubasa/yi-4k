# 配套RTOS跨系统证据

这些 `.c` 文件是既有 Ghidra 静态分析伪代码的逐字节副本，不是原厂源码。类型、符号与参数可能是推断；无真机验证。

源映像：`artifacts/firmware/v1.10.52/_part_lrtos.a9s`，SHA-256 `c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141`，映射 `0xA0100000`。原始导出在 `artifacts/rtos-reverse/full/decompiled/`。

- `a019449c/a019ce8c/a0197424/a0197644`：文件标记、Dmesg/SaveLog状态、Linux就绪时启动Telnet。
- `a0479708`：RTOS向Linux utility RPC发送命令，procedure 2。
- `a0476bb4/a04771d0/a0476380/a023e230/a0244b54`：remoteapi与RTSP的动态启动/网络控制初始化。
- `a01b6f08`：启动xcserver包装器及CCServer IPC循环。
- `a0478580`：EventNotify程序注册。
- `a0247e54/a0247a20/a024840c/a02478f4`：SharePreview RPC注册、meminfo/enable/status。
- `a0248530/a0247b8c/a02484e8`：SharePreview初始化、Y缓冲复制与默认配置。
- `a01a18f8`：RTOS `t app`处理器，含sharepv分支；未给出可直接执行的测试命令。

其中涉及相机状态、共享内存或硬件的命令均需恢复参数和生命周期；副本的存在不是ABI验证。
