# 1.10.7 Thumb 缓存候选排除

2026-11-11。本轮对[代码发布边界](device-1107-code-publication.md)明确未覆盖的 Thumb-2 编码范围制作了独立严格编码扫描。**后续交叉核对发现 `audit_native_ram_entry.py` 已经扫描过 Thumb，且排除了同四个 MMU 半字误候选，因此不能将本轮描述为首次补齐 Thumb 覆盖。** 新产物主要增加明确的六种编码正控制、BPIALL/BPIALLIS 分类与具体 VMLA/BNE 字节反例。结果是：固定 7,491,584 字节 RTOS 镜像的全部 2-byte 对齐起点中，选定 I-cache/分支预测维护编码命中 5 次；它们均从既有 A32 指令的内部半字开始，没有新增独立 Thumb 缓存发布入口。

本轮没有访问相机、执行固件指令、模拟硬件缓存或写入 RAM/固件。这里的反汇编与函数归属是本地静态证据，不能当作运行期指令状态证明。

## 可验证结果

```sh
.venv-reverse/bin/python scripts/audit_native_thumb_cache_candidates.py \
  --output artifacts/verification/2026-11-11-native-thumb-cache-candidates-run02
```

[审计 JSON](../artifacts/verification/2026-11-11-native-thumb-cache-candidates-run02/audit.json)固定固件、脚本与 Ghidra 函数索引的 SHA-256，记录全部 3,745,791 个 T32 起点、6 个正解码控制、5 个命中及对应 A32 原始字节。范围包含 op1=0 的 `ICIALLUIS`、`ICIALLU`、`ICIMVAU`、旧式预取刷新、`BPIALL` 和 `BPIALLIS`。函数索引含 10,224 个 A32 和 769 个 Thumb 函数。

| T32 误候选起点 | 表面解码 | 固定字节的原始 A32 归属 |
| --- | --- | --- |
| `A04A42D6` | `MCR p15,0,r7,c7,c5,0` | `A04A42D4` 的 ICIALLU 内部半字，位于 primary MMU 初始化 |
| `A04A43CE` | `MCR p15,0,r4,c7,c5,0` | `A04A43CC` 的 ICIALLU 内部半字，位于同一 primary MMU 函数 |
| `A04A442E` | `MCR p15,0,r5,c7,c5,0` | `A04A442C` 的 ICIALLU 内部半字，位于 secondary MMU 初始化 |
| `A04A4492` | `MCR p15,0,r6,c7,c5,0` | `A04A4490` 的 ICIALLU 内部半字，位于同一 secondary MMU 函数 |
| `A04DF232` | `MCR p15,0,pc,c7,c1,6` | 跨越 `A04DF230 VMLA.F32 s10,s15,s9` 和 `A04DF234 BNE A04DF180`，归属 A32 函数 `A04DED3C` |

最后一个命中具有可核对的反例字节：

```text
A04DF230  A4 5A 07 EE    VMLA.F32 s10,s15,s9
A04DF234  D1 FF FF 1A    BNE A04DF180
                 07 EE D1 FF  ← 从中间半字误作 T32 MCR
```

这说明即使 Capstone 能从某个半字解出带体系结构名称的缓存/预测指令，也必须核对正常指令状态和入边；单个 opcode 命中不能作为首次执行或缓存刷新入口。本轮独立 A32 对照仍为 11 个所选编码（含 1 个旧式同步），没有新增 BPIALL/BPIALLIS 对齐 A32 命中。

## 对最小执行门槛的影响

[前置条件矩阵](device-1107-native-execution-prereq-matrix.md)的 P5 仍为缺失：没有得到保留当前映射、可正常调用返回、适用于目标缓冲/核心的代码发布 API；P1 首次入口、P6 跨核完成、P10 撤销静止和 P11 独立恢复同样不因此关闭。四个 MMU 半字命中不能绕开原始 A32 初始化上下文，`A04DF232` 也不能被当作合法分支预测刷新函数。

扫描不排除未捕获区、动态生成代码、op1 非零编码或未索引的间接跳转。假设某个未知调用者故意以 Thumb 状态进入 A32 指令内部，也不构成安全、外部可达且可返回的入口合同。因此这是对具体不安全候选的排除，不是“整个固件绝无代码发布能力”的证明。
