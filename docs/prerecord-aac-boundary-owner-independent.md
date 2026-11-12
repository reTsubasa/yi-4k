# AAC 边界包 owner 独立审查与真实归档回放

本轮审查 `sdk/yi4k_1107_aac_boundary.{h,c}` 及其 host/ARM 测试合同；未修改实现。没有发现当前串行、调用者持有有效对象与诚实 custody 回执合同范围内的阻断缺陷。独立编译回放使用真实归档 AAC 的 3003 个包，得到第一段 **2815** 包、第二段 **188** 包，与原厂 Close0 的完整包归属实验一致。

这是一个调用者提供缓冲区的单包 lookahead owner，不是活体一分钟缓存或 mux/SD 集成。receipt 的真实性仍是外部合同；ProcessAudio、owned_mux_finish 或 Close 成功均不能替代 custody 回执。

## 独立证据

脚本 `scripts/verify_prerecord_aac_boundary_archive.py` 自行生成独立 C wrapper，将 owner C 编译为宿主动态库，通过公共 API 回放。只用 FFprobe 选取 AAC 元数据并按实际文件 offset 读取 AAC payload，没有解析/恢复整段视频，也没有重新执行原厂 mux。

```sh
.venv-reverse/bin/python scripts/verify_prerecord_aac_boundary_archive.py \
  --output artifacts/verification/2026-11-11-prerecord-aac-boundary-archive-new-review
```

最终证据：`artifacts/verification/2026-11-11-prerecord-aac-boundary-archive-review-run02/review.json`。同目录保存 wrapper C 和实际编译库。报告包括脚本、owner C、owner H、全部本地 `yi4k_1107_*.h` 的保守依赖摘要及编译命令；执行结束再次核对 owner 源和头文件均未变化。

本次 owner C SHA256：`b58c229882fb128a13f5352eda538ff28489b1e25b5e071b6c8d2088271c5ac7`。owner H SHA256：`3cc9dc09a605f08564f8fca1b2f7fc0ea6561af2a5832cedc20fe8c2e509f364`。

## 已核对的行为

- 使用精确 `end<=split` 判断完整包属于当前段。60.06 秒 split 为 `1801800/30000`，未先四舍五入成毫秒或 AAC ticks。AAC2814 完整归前段；AAC2815 结束越界，进入 NEXT。
- AAC2815 是真实 346 字节包，PTS/DTS 为 2882560、duration 为 1024、时基 48000；SHA256 为 `ef96aaeaa91e39baf9abaf7a6edcf1b129482b5522cfb130d86b83413bf4ba5a`。advance 设置下一段 source epoch=2882560，保留它的 payload、descriptor 源身份、PTS/DTS、sequence 和 ticket。
- 对全部 3003 包，成功 offer 后立即覆写上游内存，owner copy 均逐字节等于原包。另复制为独立下游 bytes 后才发送 CUSTODY_CONFIRMED；这只证明本测试的独立内存 custody，没有冒充 SD 或 writer 的保留保证。
- NEXT 状态不能 receipt 释放或被新 offer 覆写；非法 source origin 的 advance 返回错误且控制器和缓冲区完整 snapshot 不变。
- 无副作用的 RETRY_UNTOUCHED 保持相同 ticket、所有元数据和缓冲区。错误 ticket 不释放；每个成功回执后再提交相同 ticket 均拒绝，3003 次仅释放一次检查通过。
- 输入 end 溢出返回 LIMIT，未改变控制器或缓冲区。AMBIGUOUS 冻结并保留 bytes，后续 offer 不自动重放。
- 4096 个独立全宽随机/边界案例通过公共 offer API 与 Python 任意精度交叉乘积比较，包含最大 96 位乘积；没有以浮点或溢出的 64 位交叉乘法代替精确判断。

3003 包按源序输出 SHA 序列的摘要为 `34c8e32487ad1e6a4139c9f09ba3dcb45f3d4f63eeb6046ad4ee944ca0d08f7b`。每个包在覆写上游后和下游 custody 复制时均逐字节比较，没有只检查总包数。

## 实现与测试合同审查

`mul` 将 uint64×uint32 分拆成精确低 64 位及高 32 位，compare 按高/低字排序；本次随机 oracle 和实现测试的 ARM32 oracle分别覆盖该逻辑。offer 在写缓冲区前先检查容量、时间加法、ticket 上界、identity/config/epoch、连续 sequence 及前包结束时间；状态/容量错误不许可上游释放。advance 仅适用 NEXT，并验证下一段 ID、source origin、split 增长以及整个 held 包可落入下一段。receipt 不接收 writer 返回值，而接收明确的 custody outcome，重复或过期 ticket 不能触发第二次释放。

同时阅读了 `sdk/offline/yi4k_aac_boundary_test.c` 和 `scripts/validate_prerecord_aac_boundary.py` 的32个 host/ARM 案例与517个 Fraction oracle设计，覆盖配置/epoch/时间/序列变化、alias、EOS、reinit、overflow、capacity、retry及冻结。其运行结果应引用实现线程自身的最终 validation JSON；本报告的真实 payload 回放独立于这些合成自测。

重要的接口边界是 `held.packet.payload` 指向 owner copy，但原 descriptor 的 `cpu_payload_address` 仍是来源 provenance，不能据此访问上游旧内存，也不能把整份 held descriptor 直接当已重定位 stock writer descriptor。实际 downstream 需按自身 arena 合同重新映射，且直到关闭输出逐包验证或独立耐久 custody 完成，才可以诚实确认释放。

本轮没有证明真实 codec 配置回调或共享硬件时钟；identity/config digest 为测试中外部绑定的非零 attestation。也未验证 producer 并发、实际 writer 索引/游标副作用、SD 持久化、超时恢复、回调安装或完整预录功能。单包控制器只在声明的串行有效对象合同内接受调用。
