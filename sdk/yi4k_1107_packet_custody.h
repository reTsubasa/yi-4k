#ifndef YI4K_1107_PACKET_CUSTODY_H
#define YI4K_1107_PACKET_CUSTODY_H
#include "yi4k_1107_owned_mux.h"

/* Offline RAM custody, one serialized owner and one track per instance.
 * No storage, rollback, resubmission, target allocator or hook is implemented.
 * A packet copied successfully here may outlive/release its early-copy lease,
 * but it MUST remain here until the CLOSED output is independently checked.
 * Merely returning zero from ProcessAudio/Video or Close is insufficient.
 */
typedef struct yi4k_1107_custody_slot {
    uint8_t *payload;
    uint32_t capacity;
    yi4k_1107_frame_desc descriptor;
} yi4k_1107_custody_slot;

enum { YI4K_CUSTODY_IDLE, YI4K_CUSTODY_COLLECT,
       YI4K_CUSTODY_VERIFY, YI4K_CUSTODY_FROZEN };
enum { YI4K_CUSTODY_OK = 0, YI4K_CUSTODY_FULL = 1,
       YI4K_CUSTODY_BAD_ARGUMENT = -1, YI4K_CUSTODY_BAD_STATE = -2,
       YI4K_CUSTODY_MISMATCH = -3, YI4K_CUSTODY_CLOSE_FAILED = -4,
       YI4K_CUSTODY_INCOMPLETE = -5 };

typedef struct yi4k_1107_packet_custody {
    yi4k_1107_custody_slot *slots;
    uint32_t slot_count, source_kind, count, checked, state;
    uint64_t segment_id;
} yi4k_1107_packet_custody;

/* Accessible/aligned/disjoint live objects; payload buffers are exclusively
 * owned, mutually disjoint and immutable to other actors. Init only once or
 * after externally proved quiescence/recovery. All metadata/mappings remain
 * immutable. Invalid init leaves the controller unchanged. Not thread-safe.
 */
int32_t yi4k_1107_custody_init(yi4k_1107_packet_custody *,
    yi4k_1107_custody_slot *, uint32_t count, uint32_t source_kind);
int32_t yi4k_1107_custody_begin(yi4k_1107_packet_custody *, uint64_t segment_id);

/* Copy an ordinary held mux packet BEFORE releasing it. FULL changes nothing:
 * caller must retain upstream lease and stop consumer progress, never overwrite
 * an unverified slot or submit an unretained sample. Sequence and PTS must both
 * strictly increase in this segment; sequence wrap requires a new segment.
 * Nonzero errors do not give permission to release the upstream queue.
 * EOS is handled by caller and is never stored as an ordinary sample.
 */
int32_t yi4k_1107_custody_store(yi4k_1107_packet_custody *,
    const yi4k_1107_mux_packet *);

/* On Close failure freeze all bytes. Success enters VERIFY, still releases
 * nothing. Inspect final output packets IN TRACK ORDER, with independently
 * recovered original sequence/PTS/type/flags/length in canonical source units.
 * Container rebase/edits must be inverted exactly by the caller; rounded PTS
 * must be rejected. Actual bytes must come from separate readable storage,
 * never an alias of custody. Descriptor address/reserved fields are ignored.
 * Missing/extra/duplicate/changed/out-of-order packets freeze the transaction.
 * Packet identities supplied dishonestly cannot be detected by this module.
 */
int32_t yi4k_1107_custody_closed(yi4k_1107_packet_custody *, int32_t close_status);
int32_t yi4k_1107_custody_check(yi4k_1107_packet_custody *, uint64_t segment_id,
    const yi4k_1107_frame_desc *, const uint8_t *actual_payload);

/* Release only after exactly count independent packet checks AND caller's
 * payload_use_complete==1 (no outstanding readers). No partial release.
 * Readback/this attestation does NOT prove filesystem durability or SD flush.
 * Frozen state has NO reset/retry/discard API: original material stays readable
 * in slots[0..count), requiring external recovery/new output and lifecycle.
 */
int32_t yi4k_1107_custody_commit(yi4k_1107_packet_custody *,
    uint64_t segment_id, uint32_t payload_use_complete);
#endif
