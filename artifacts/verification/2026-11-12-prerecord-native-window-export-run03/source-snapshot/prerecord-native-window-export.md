# Nonzero native mux final-export candidate

The selected archived START=63s, STOP=64s window passes the unchanged ordinary-consumer packet/payload/PTS/DTS/duration gate and complete video/audio decode comparisons. This is a host-emulated final-export candidate using original ARM mux instructions plus an explicit caller adapter for the common presentation origin and movie duration. It is not a stock-only arbitrary-window solution or live camera acceptance.

Implementation: `scripts/export_prerecord_native_window.py`. Independent read-only review: `scripts/verify_prerecord_native_window.py`. The fixed zero-origin exporter, historical native segments and their second-segment rejection are retained. No camera access, device writes, firmware instruction patches, encoder execution, FFmpeg mux or host ISO byte rewrite occurs.

## Actual selection and presentation

The requested source interval is START−60=3s through STOP=64s. Selection starts at the preceding source IDR (video88 at 2.936266667s), retains the whole AAC137 spanning that IDR (2.922666667s), and includes whole packets whose start precedes STOP. It retains video88–1918 (1,831 packets) and AAC137–2999 (2,863 packets), crossing the original native event3 split.

| Quantity | Video | Audio |
|---|---:|---:|
| First source PTS | 2.936266667s | 2.922666667s |
| Last source endpoint | 64.030633333s | 64s |
| Before START | 60.063733333s | 60.077333333s |
| After START | 1.030633333s | 1s |
| STOP overshoot | 30.633333ms | 0 |
| First output PTS/DTS, common source offset −2s | 0.936266667s | 0.922666667s |

The A/V phase stays exactly 13.6ms. The common source offset is 2s, not each track's own first PTS. Presentation begins with 0.922666667s of empty time. The movie presentation duration is 62.030633333s; the real video source interval is 61.094366667s and the real AAC source interval is 61.077333333s. No samples fill the empty presentation time. This candidate does not claim tight zero-origin presentation.

## Explicit caller adaptation

The original factory/index/Open/ProcessVideo/ProcessAudio/Close0 execute against sealed native segment bytes. Source epochs and native edit delays reconstruct the common source timeline; the intact recording is opened only after the candidate is written, as an independent oracle. Missing input continuity rejects before native Open.

The common internal clock is 240,000 ticks/s. Before original RestoreDTS/count-reset/ResetMovie, the caller seeds each track's source DTS snapshot and the native global preset at 2s. Original ResetMovie subtracts that same preset from both tracks, leaving video start 224,704 ticks and audio start 221,440 ticks. Video raw timestamps still pass through original conversion; AAC packets remain whole.

The original MOOV initializer normally chooses the minimum track start as the edit origin, which would erase the common leading time. At original edit constructor `0xA0425E18`, the adapter supplies common origin zero instead of 221,440 internal ticks, identically for both tracks. Original ARM code builds and serializes both empty edits and their media edits. At original MOOV writer `0xA04312E4`, the adapter adds the same leading duration to MVHD's in-memory duration field at object offset `0x30` before original serialization. The formula is:

```
output_common_source_offset = floor(min(first_video_source_pts, first_aac_source_pts))
initial_padding = min(first_video_source_pts, first_aac_source_pts) - output_common_source_offset
MVHD_adapted_duration = MVHD_native_duration + initial_padding * movie_clock
```

Every conversion must be exact in the relevant clock; version0/u32 overflow rejects. The report records original/adapted arguments and MVHD object bytes. Original ARM TKHD values already include each track's start relative to the preset. MDHD stays equal to retained media sample duration; ELST media duration stays equal to retained media duration. Empty+media ELST endpoints match TKHD and the maximum equals MVHD. Original media bytes and every STBL sample table match the rejected stock control exactly.

## Preserved rejects and fixed-reader behavior

The stock control runs the same nonzero packet selection with the native minimum origin and no caller adaptation. Its payload/PTS/DTS remain correct, but the ordinary reader reports the last video duration as 593 instead of 1,001 ticks; publication rejects. The MDHD-only duration experiment also rejects and retains its source snapshot. Neither becomes an accepted export.

The pinned ordinary reader is `ffprobe 6.1-tessus`. Its behavior must be tested, not inferred from decode success. Upstream n6.1 source evidence shows a STTS-duration cap as well as edit-list duration processing, so changing MDHD alone is insufficient. The common whole-second offset preserves a substantial positive first PTS in this fixture and the actual ordinary reader reports all retained durations exactly. This is a demonstrated consumer contract for the selected fixture, not a claim that every reader or arbitrary trigger phase accepts it. No consumer option, packet filter, tolerance, source substitution or gate relaxation is used for acceptance.

## Receipts and recovery

All receipts are under `artifacts/verification/`:

- `2026-11-12-prerecord-native-window-export-run03/`: final source-pinned positive receipt and MP4.
- `2026-11-12-prerecord-native-window-stock-control-run01/`: stock strict rejection.
- `2026-11-12-prerecord-native-window-export-run01/`: rejected MDHD-only experiment, pending bytes and executed source snapshot.
- `2026-11-12-prerecord-native-window-missing-aac-run01/`: AAC2815 removed; rejects before native Open.
- `2026-11-12-prerecord-native-window-close-failure-run01/`: all 4,694 packets submitted, original Close0 returns −12 on a modeled short write; no publication, pending retained.
- `2026-11-12-prerecord-native-window-recovery-run01/`: clean retry from unchanged sealed inputs; output must match the accepted export byte for byte.
- `2026-11-12-prerecord-native-window-export-review.json`: independent selection, complete ordinary-reader/oracle checks, decoded frames/PCM, container duration consistency, original sample-table/media-area identity, and negative/retry custody checks.

The final MP4 is 343,127,618 bytes, SHA256 `351bdba510ffec1d93da80e6fd9b2bc5b0c275a25a103a2575707b148c2df7d4`. All 1,831 decoded frame hashes match the source subset. All 2,863 AAC packets decode to 11,726,848 PCM bytes, SHA256 `2a6cbb796db16f4b68e781a98707a24042b248ce637f6fff21b39cbc684a454d`.

Only START63/STOP64 is accepted by this evidence. Other requested bounds remain candidates subject to strict rejection. A zero native global preset is a sentinel: fractional natural origins within the first second are explicitly unsupported in this adapter. No live ring, real concurrent producer queues, encoder/DMA, camera callback installation, SD throughput, physical durability or hardware acceptance is established. Input epochs remain caller receipts, not authentication supplied by MP4 alone.
