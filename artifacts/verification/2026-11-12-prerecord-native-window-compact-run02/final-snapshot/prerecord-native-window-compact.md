# Compact nonzero native mux export and consumer boundaries

The compact archived START63/STOP64 export removes the earlier 0.923-second common leading empty time while retaining every selected compressed packet and the exact 13.6ms A/V source phase. Original ARM mux code builds the stock edit lists and writes the final MP4. The caller supplies the missing track dimensions from the sealed SPS. There is no instruction patch, FFmpeg mux, host ISO byte rewrite, invented packet, MDHD fix or independent track normalization.

The unchanged exact packet/payload/PTS/DTS/duration comparison passes with ordinary **ffprobe 8.0-tessus**. Complete FFmpeg8 decoding matches all selected source video frame hashes and independently decoded whole selected AAC packets. The fixed **ffprobe 6.1-tessus** rejection remains. AVFoundation identifies the corrected video track, but its AAC presentation/decode behavior fails the complete-AAC contract. Acceptance is consumer-specific; changing consumers does not change the old results.

## Geometry was missing from the caller configuration

The previous native test harness left `video_track+0x74/+0x76` at zero. Original ARM `0xA0432230` reads those fields into AVC1 sample-entry width/height; `0xA04331F4` uses them for TKHD display geometry. Earlier ordinary FFmpeg probes inferred 1920×1080 from H.264 SPS, so packet/decode checks did not expose the zero container dimensions. AVFoundation enumerated only the audio track in those files.

`prerecord_native_window_sps.py` now parses the exact SPS from the hash-verified sealed native AVCDecoderConfigurationRecord: Main profile77, level51, coded1920×1088, bottom crop4 in units2, resulting1920×1080. The bounded parser rejects truncated/unknown geometry and unsupported interlacing. Sealed codec configuration must stay constant; encountered keyframe SPS/PPS must match it. This configuration is applied before samples and original final metadata construction. Serialized AVC1/TKHD geometry and independent decoder dimensions are checked again.

The compact positive and the historical zero-geometry stock control have identical file size, MDAT and all index/timing sample-table bytes. Exactly eight byte values differ: the two AVC1 u16 and two TKHD 16.16 geometry fields. No compressed sample, offset, STTS entry or time edit changes to make the new consumer pass.

## Two actual nonzero windows

| Quantity | START63 / STOP64 | START60.266933333 / STOP60.5 |
|---|---:|---:|
| Desired START−60 | 3s | 0.266933333s, exact IDR |
| Selected video indices | 88–1918, 1,831 packets | 8–1813, 1,806 packets |
| Selected AAC indices | 137–2999, 2,863 packets | 12–2835, 2,824 packets |
| Common source origin | 2.922666667s | 0.256s |
| First output video PTS/DTS | 13.6ms | 10.933333ms |
| First output AAC PTS/DTS | 0 | 0 |
| Video before START | 60.063733333s | exactly60s |
| AAC before START | 60.077333333s | 60.010933333s |
| Video after START | 1.030633333s | 0.2602s |
| AAC after START | 1s | 0.2344s |
| Common leading empty duration | 0 | 0 |

Both cross the original 60s native split. Selection uses the preceding IDR, the whole AAC packet spanning that IDR and whole packets starting before STOP. STOP overshoot is explicit; no AAC is split or dropped. The second actual native export exercises the earlier whole-second adapter's unsupported first-second origin and an exact GOP boundary. Original ResetMovie chooses one common minimum source origin with its normal zero-preset sentinel; it preserves both tracks' relative phase. The prior whole-second edit-origin/MVHD adapter is disabled.

The first movie presentation lasts61.107966667s from audio0 through the last video endpoint. Video begins13.6ms after audio because of the retained source phase. This intrinsic difference is distinct from the removed0.923-second common leading empty interval.

## Actual consumers

| Consumer | Compact result | What remains explicit |
|---|---|---|
| ffprobe/FFmpeg8.0-tessus | Exact native-input/source packet gates and full selected decode pass | Versioned host candidate, not every reader |
| ffprobe6.1-tessus | Reject | Last video duration593 vs1001 ticks in START63/STOP64 |
| AVFoundation | Video now recognized; full compressed sample payloads present | Output AAC duration/complete decode trims2112 samples; strict whole-AAC control rejects |
| Android platform consumer | Independent emulator evidence maintained separately | Same SHA as final compact artifact; no physical-camera acceptance |

Upstream n8.0 `mov_finalize_packet` assigns packet duration from the sample's retained STTS timing data. The retained n6.1 source uses nextDTS or stream duration for the last packet, after stream duration has been capped, explaining this compatibility difference. These are pinned upstream source observations, not a certification of the tessus binary's private build source. Acceptance uses the actual separately hashed binaries under `.tools/ffmpeg8-host/`, with unchanged ordinary edit-aware options. Acquisition URLs/archive/binary hashes are in its `acquisition.json`; the broken system ffprobe7 installation was not repaired.

AVFoundation's `CMSampleBufferGetPresentationTimeStamp` reports media time; its `GetOutputPresentationTimeStamp`/`GetOutputDecodeTimeStamp` retain the13.6ms presentation phase. Both are recorded. No source-derived per-track shift is applied. For AAC, AVFoundation exposes a segment source start of2112, even though retained container ELST media_time is0. It decodes2,929,600 of2,931,712 retained AAC frames for the compact movie. The original full source similarly yields3,122,112 of3,124,224 frames. No `iTunSMPB`, `sgpd` or `sbgp` priming metadata was found in the retained source box scan. This is a concrete consumer behavior; it does not establish that the camera encoder had zero priming or that all priming interpretation is erroneous. It fails this export's whole-selected-AAC contract, so no AVFoundation acceptance is claimed.

Android's independent AAC oracle starts a fresh decoder at source AAC137 and feeds only the selected samples. This checks the independently decoded selected packets; it does not claim equality with a PCM subrange cropped from uninterrupted source0 decoding. Its packet/time, geometry and decoder evidence is maintained under `artifacts/android/2026-11-12-native-mux-consumer-run02/` and the parent task's Android review.

## Source-pinned receipts and failure custody

- `2026-11-12-prerecord-native-window-compact-run02/`: final positive. Output343,127,606 bytes, SHA256 `cffc226da6e496cd6df8d4294c1d295c4bdefe7ece4efe289f597b7b85e3ee5a`.
- `2026-11-12-prerecord-native-window-compact-firstsecond-run01/`: actual first-second/exact-IDR native export, SHA256 `28caa8e2237566e600f18280d968c6bdb0e423415e007f680f767a68d65a22af`.
- `2026-11-12-prerecord-native-window-compact-close-failure-run01/`: all4,694 selected packets submitted; original Close0 returns−12 after modeled short write. Pending retained, no publication.
- `2026-11-12-prerecord-native-window-compact-recovery-run01/`: subsequent clean retry from unchanged sealed native input; output byte-identical to final positive.
- `2026-11-12-prerecord-native-window-compact-missing-aac-run01/` and `...-invalid-sps-run01/`: continuity/geometry negatives reject before native Open.
- `2026-11-12-prerecord-native-window-compact-review.json`: independent window reconstruction, actual ordinary8.0 gates, source oracle, geometry/header endpoints, old-control media/index identity and rejection/recovery checks.
- `2026-11-12-prerecord-native-window-avfoundation-explore/consumer-controls.json`: zero-geometry rejection, media/output API distinction, complete original/compact decode counts, priming source observations and retained source/binary hashes.

The initial compact run01 retained a rejected prototype receipt that compared AVFoundation media PTS instead of output PTS. Its pending native MP4 is byte-identical to the final run02 file. Correct output-time inspection preserves the video phase, but still reveals the independent AAC trimming limitation. That historical rejection is not overwritten.

Scripts: `export_prerecord_native_window_compact.py`, `prerecord_native_window_sps.py`, `audit_prerecord_native_window_avfoundation.swift` and `verify_prerecord_native_window_compact.py`. Existing exporter, verifier and historical JSON receipts remain unchanged. Older source/document pin receipts are historical; this round appends the newly discovered consumer limits to their documents and creates a new pin receipt.

This validates two selected windows from the pinned progressive H.264 I/P,48kHz stereo AAC archive. Other codecs, source epochs, trigger bounds and players require their own strict checks. No encoder execution, encoder/DMA/callback installation, real concurrent FIFO/SD throughput, physical durability, camera access or device firmware writes were performed by this exporter work.
