#ifndef YI4K_SPOOL_SEAL_H
#define YI4K_SPOOL_SEAL_H
#include "yi4k_packet_spool.h"

/* Independent sidecar closure, not an MP4/session publication receipt.
 * A single serialized owner observes EVERY accepted source sample while its
 * payload is stable, independently of the stored-file reader. The stop owner
 * supplies an immutable expected request from its own accepted-source ledger,
 * after proving admission closed, callbacks drained and all held samples
 * accounted for. This module cannot establish that external stop proof.
 * Do not generate the request by scanning whatever prefix survived on disk.
 * A source sample absent before observation cannot be detected without the
 * independent expected coverage. Source clock/codec authenticity is external.
 */
typedef struct yi4k_seal_track {
    uint64_t records, first_pts, end_pts;
    uint32_t first_sequence, last_sequence, scale, reserved;
} yi4k_seal_track;

enum { YI4K_SEAL_SNAPSHOT_SET=1, YI4K_SEAL_AV_SEGMENT=2 };
typedef struct yi4k_seal_request {
    yi4k_spool_identity identity;
    uint64_t closure_id, records, payload_bytes;
    uint32_t scope, reserved;
    yi4k_seal_track tracks[2]; /* video, AAC; empty track is all zero */
} yi4k_seal_request;

typedef struct yi4k_seal_sha256 {
    uint32_t words[8], used;
    uint64_t bytes;
    uint8_t block[64];
} yi4k_seal_sha256;

typedef struct yi4k_source_coverage {
    uint32_t magic, state;
    yi4k_spool_identity identity;
    uint64_t records, payload_bytes;
    yi4k_seal_track tracks[2];
    yi4k_seal_sha256 transcript;
} yi4k_source_coverage;

enum { YI4K_SEAL_OPEN=1, YI4K_SEAL_CHECKING=2,
       YI4K_SEAL_FROZEN=3, YI4K_SEAL_COMMITTED=4 };
enum { YI4K_SEAL_OK=0, YI4K_SEAL_BAD_ARGUMENT=-1,
       YI4K_SEAL_BAD_STATE=-2, YI4K_SEAL_IO_FAILED=-3,
       YI4K_SEAL_MISMATCH=-4, YI4K_SEAL_INCOMPLETE=-5, YI4K_SEAL_LIMIT=-6 };

/* Fresh zeroed coverage; aligned, accessible, disjoint live objects. No live
 * reset. A transcript covers identity, ordered canonical descriptors/timing
 * and exact payload bytes using SHA-256. Sequence/time continuity is enforced
 * per track, accepting only nonreordered video/AAC, DTS==PTS. All arguments,
 * source bytes, scratch and I/O descriptors must remain immutable/disjoint
 * during a call. No callback may reenter or modify an argument. Not thread-safe.
 */
int32_t yi4k_coverage_init(yi4k_source_coverage *, const yi4k_spool_identity *);
int32_t yi4k_coverage_add(yi4k_source_coverage *, const yi4k_spool_sample *);

/* Spool and seal must have exclusive, quiescent handles throughout. Seal is a
 * fresh independently owned O_EXCL-equivalent file, initially zero bytes; its
 * namespace/parent-directory durability is the adapter's responsibility.
 * Expected request must come from an independently preserved source ledger.
 * Snapshot scope may describe a partial frozen set and never authorizes full
 * recording publication. AV_SEGMENT requires both tracks but still does not
 * prove codec, capture epoch, trigger, continuity across segments or MP4 timing.
 *
 * Preflight request/coverage mismatch does no I/O and leaves OPEN. Once I/O
 * begins the coverage cannot accept new samples, even on failure. Scan actual
 * spool -> compare independently observed source transcript and expected
 * ranges -> body write/sync -> commit marker write/sync -> actual readback ->
 * final size checks. Any I/O/short operation/mismatch freezes without reset,
 * append/retry/discard; retain every source/recovery file on failure. A complete
 * seal may have reached disk despite a failed call; only NEW verify may judge
 * that file, never retroactively turn the failed call into a success receipt.
 */
int32_t yi4k_spool_seal_commit(yi4k_source_coverage *,
    const yi4k_seal_request *, const yi4k_spool_io *spool,
    const yi4k_spool_io *seal, uint8_t *scratch, uint32_t capacity);

typedef struct yi4k_seal_receipt {
    uint32_t valid, scope;
    uint64_t closure_id, records, spool_bytes;
    uint8_t transcript_sha256[32];
} yi4k_seal_receipt;

/* Read-only NEW-reader verification. Caller supplies the original trusted
 * closure request, not one reconstructed from an untrusted seal/file prefix.
 * No callback publishes partial observations. Receipt.valid is set only after
 * the entire seal, spool, SHA/ranges and final seal readback/size checks pass.
 * Handles must remain quiescent: size/readback checks do not prevent same-size
 * concurrent replacement, transient mutation or maliciously forged seals.
 * SHA/CRC are integrity checks, NOT authentication or physical-SD durability.
 * Consume only when return==OK AND receipt.valid==1. Invalid pointer/alias
 * arguments leave output unspecified; no previous receipt authorizes a new
 * call. A valid storage receipt alone never permits MP4 publication/deletion.
 */
int32_t yi4k_spool_seal_verify(const yi4k_seal_request *,
    const yi4k_spool_io *spool, const yi4k_spool_io *seal,
    uint8_t *scratch, uint32_t capacity, yi4k_seal_receipt *);
#endif
