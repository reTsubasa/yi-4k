#ifndef YI4K_PACKET_SPOOL_H
#define YI4K_PACKET_SPOOL_H

#include "yi4k_1107_owned_mux.h"

/* Append-only, one file/segment, serialized owner. The storage adapter owns
 * its handle and must provide synchronous positional I/O to a fresh exclusive
 * file. No filesystem, camera, allocator, encoder, eviction or RTOS binding.
 * sync must flush prior writes and their ordering to the adapter's declared
 * persistence domain. Host fsync is not proof of SD power-loss durability.
 * Every nonzero storage status or short I/O is ambiguous and freezes writer.
 */
typedef struct yi4k_spool_io {
    void *context;
    int32_t (*size)(void *, uint64_t *);
    int32_t (*write)(void *, uint64_t, const uint8_t *, uint32_t, uint32_t *);
    int32_t (*read)(void *, uint64_t, uint8_t *, uint32_t, uint32_t *);
    int32_t (*sync)(void *);
} yi4k_spool_io;

typedef struct yi4k_spool_identity {
    uint64_t session, segment, epoch;
    uint8_t config_digest[32]; /* caller's prevalidated immutable A/V config */
} yi4k_spool_identity;

typedef struct yi4k_spool_sample {
    yi4k_1107_mux_packet packet;
    uint64_t dts, pts;
    uint32_t scale, duration;
} yi4k_spool_sample;

typedef struct yi4k_spool_track {
    uint32_t seen, sequence, scale;
    uint64_t end;
} yi4k_spool_track;

typedef struct yi4k_packet_spool {
    uint32_t magic, state, capacity;
    uint8_t *readback;
    yi4k_spool_io io;
    yi4k_spool_identity identity;
    uint64_t offset, next_ordinal;
    yi4k_spool_track tracks[2];
} yi4k_packet_spool;

enum { YI4K_SPOOL_READY=1, YI4K_SPOOL_BUSY=2, YI4K_SPOOL_FROZEN=3 };
enum { YI4K_SPOOL_OK=0, YI4K_SPOOL_BAD_ARGUMENT=-1,
       YI4K_SPOOL_BAD_STATE=-2, YI4K_SPOOL_IO_FAILED=-3,
       YI4K_SPOOL_MISMATCH=-4, YI4K_SPOOL_INCOMPLETE=-5,
       YI4K_SPOOL_LIMIT=-6 };

/* Fresh zero-initialized controller. All objects/buffers/ops are accessible,
 * aligned and mutually disjoint; the scratch is exclusively owned. No live
 * re-init. io.size must report zero. Readback capacity bounds encoded packet
 * memory, independently of total file length. Identity values must be nonzero.
 * Configuration identity is external; this module cannot authenticate clocks
 * or parse AAC/H264. No callbacks may mutate input, scratch or controller.
 */
int32_t yi4k_spool_init(yi4k_packet_spool *, const yi4k_spool_io *,
    const yi4k_spool_identity *, uint8_t *readback, uint32_t capacity);

/* Header+payload -> sync -> commit marker -> sync -> independent readback.
 * Only OK confirms the entire record within the adapter's persistence domain.
 * Caller retains its source lease on every error. Frozen writers have no
 * append/reset/retry/discard API, including if a complete record reached disk
 * before a failed sync/readback. Recover using a NEW reader and fresh output.
 * Records preserve source PTS/DTS and descriptor; source addresses are opaque
 * provenance, never usable as readback mappings. Current contract accepts
 * caller-validated nonreordered video or AAC, DTS==PTS, and exact per-track
 * contiguous times. Video type fields alone do not parse slice semantics.
 * Preflight argument/continuity/capacity/overflow errors do no I/O and leave
 * the writer READY. Only rejected unchanged input may be corrected/retried.
 */
int32_t yi4k_spool_append(yi4k_packet_spool *, const yi4k_spool_sample *);

typedef struct yi4k_spool_scan_result {
    uint64_t file_bytes, committed_bytes, records;
    uint32_t trailing_bytes, corrupt;
} yi4k_spool_scan_result;

/* Read-only prefix recovery. Callback receives a temporary sample backed by
 * scratch and must copy before returning; source descriptor address stays
 * provenance only. Nonzero callback status stops scanning without mutation.
 * A torn final header/payload/marker returns INCOMPLETE with the independently
 * verified prefix; malformed complete records return MISMATCH, never skipped.
 * No result, including OK or empty input, proves whole-recording completeness:
 * a cut exactly at a record boundary is indistinguishable from a short valid
 * file. An independently sealed expected-count/coverage manifest is required.
 * No result authorizes deleting bytes or publishing a complete recording.
 * CRC detects accidental damage, not maliciously rewritten records.
 * File/handle must remain exclusively quiescent; size is checked at both ends.
 * Consumers must stage observations, not acknowledge final custody or publish
 * from a callback before validating the complete scan.
 */
int32_t yi4k_spool_scan(const yi4k_spool_io *, const yi4k_spool_identity *,
    uint8_t *scratch, uint32_t capacity,
    int32_t (*consume)(void *, uint64_t, const yi4k_spool_sample *), void *,
    yi4k_spool_scan_result *);

#endif
