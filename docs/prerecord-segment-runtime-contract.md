# 预录分段运行期合同（主机回放证据）

`scripts/validate_prerecord_segment_runtime.py` 对已有主机回放的每一个选中 MP4 分段执行文件级检查。它不会连接相机、读取 FIFO、写入固件或执行 RTOS 地址。

复现命令：

```sh
YI4K_FFPROBE=.tools/ffmpeg-host/ffprobe \
YI4K_FFMPEG=.tools/ffmpeg-host/ffmpeg \
.venv-reverse/bin/python scripts/validate_prerecord_segment_runtime.py \
  artifacts/host-prerecord/replay-run03/manifest.json
```

本次结果保存在
`artifacts/host-prerecord/replay-run03/segment-runtime-contract.json`：34 个分段全部通过哈希校验；每段首个视频包都带 keyframe/IDR（NAL5）；每段 MP4 的 AVC extradata 都包含 SPS/PPS（NAL7/NAL8）；AAC `AudioSpecificConfig` 存在且 34 段哈希一致；最终 `clip.mp4` 通过完整 H.264/AAC 解码。

这比仅检查 ffprobe 能否打开文件更强，但证据范围仍是主机 MP4 封装。MP4 的 AVC extradata 不证明相机 FIFO payload 本身按 NAL7/NAL8/NAL5 顺序交付；分段器还会重置每段时间戳，因此不能证明相机采集端的共同音视频 epoch。descriptor sequence、payload 地址生命周期、FIFO cursor、close/open 返回值和 writer ownership 仍需相机运行期只读采集。

输出中的 `validated` 字段只记录上述主机文件边界，`runtime_gaps` 明确列出不能由回放替代的相机证据，避免把可播放 host clip 误称为相机预录已经完成。
