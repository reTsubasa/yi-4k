#ifndef YI4K_1107_AAC_BOUNDARY_H
#define YI4K_1107_AAC_BOUNDARY_H
#include "yi4k_1107_owned_mux.h"
#include "yi4k_1107_codec_epoch.h"

/* Offline, caller-owned ONE packet lookahead; serialized calls, no allocation,
 * callbacks, writer, queue release, clock recovery, or camera/RTOS binding.
 * Raw AAC-LC and codec_config must already pass caller's codec validation. identity/config_digest
 * are the existing codec binding attestations, not values inferred from AAC.
 * All times are unsigned source times. Only contiguous AAC with DTS==PTS and
 * fixed samples_per_aac ticks in sample_rate units is supported; no reorder,
 * gaps, wrap, priming inference, rebase or implicit epoch/config replacement.
 */
typedef struct yi4k_1107_aac_time { uint64_t ticks; uint32_t scale; } yi4k_1107_aac_time;
typedef struct yi4k_1107_aac_input {
    yi4k_1107_mux_packet packet;
    uint8_t identity[32], config_digest[32];
    uint64_t epoch_id, dts, pts;
    uint32_t duration, scale;
} yi4k_1107_aac_input;
typedef struct yi4k_1107_aac_boundary {
    uint32_t magic, state, capacity, have_previous, previous_sequence;
    uint8_t *bytes;
    uint8_t identity[32], config_digest[32];
    uint32_t scale, duration;
    uint64_t epoch_id, segment_id, source_epoch, previous_end, ticket;
    yi4k_1107_aac_time split;
    yi4k_1107_aac_input held;
} yi4k_1107_aac_boundary;
enum { YI4K_AAC_EMPTY=0, YI4K_AAC_READY=1, YI4K_AAC_NEXT=2, YI4K_AAC_FROZEN=3 };
enum { YI4K_AAC_OK=0, YI4K_AAC_BUSY=4, YI4K_AAC_BAD_ARGUMENT=-1,
       YI4K_AAC_BAD_STATE=-2, YI4K_AAC_DISCONTINUITY=-3, YI4K_AAC_LIMIT=-4 };
enum { YI4K_AAC_RETRY_UNTOUCHED=0, YI4K_AAC_CUSTODY_CONFIRMED=1,
       YI4K_AAC_AMBIGUOUS=2 };

/* Fresh zero initialized controller; live aligned and mutually disjoint objects,
 * buffer exclusively owned and immutable to others. No re-init while active.
 * source_epoch is caller's CURRENT segment source origin in audio ticks; split
 * is caller's exact video split rational (not rounded to milliseconds).
 * epoch_id identifies the externally established source timeline; no claim that
 * this authenticates a shared hardware capture clock. Nonzero IDs/tokens.
 * Invalid init is transactional. C cannot validate arbitrary pointer mappings.
 */
int32_t yi4k_1107_aac_boundary_init(yi4k_1107_aac_boundary *, uint8_t *buffer,
    uint32_t capacity, const yi4k_1107_codec_config *, uint64_t epoch_id,
    uint64_t segment_id, uint64_t source_epoch, yi4k_1107_aac_time split);

/* Copy whole owned AUDIO packet. READY(1) iff packet end <= split, else NEXT(2).
 * Both positive results mean successful copy ownership transfer; OK(0) belongs
 * to init/confirmed receipt, never a successful offer.
 * The copy owns its bytes; only success permits caller to finish its upstream
 * lease, and only after accounting for any other readers. Buffer FULL/BUSY or
 * error never licenses upstream release. No copy/metadata mutation on error,
 * except detected continuity/config/epoch mismatch freezes existing custody.
 * No packet can be offered again after successful handoff: sequence must grow
 * exactly by one and DTS must equal previous packet end (including boundaries).
 */
int32_t yi4k_1107_aac_boundary_offer(yi4k_1107_aac_boundary *, const yi4k_1107_aac_input *);

/* NEXT only, after caller completed/recovered previous movie. Caller supplies
 * increasing next segment ID, next source origin and exact next video split.
 * Next source origin may precede its first video, must be >= old origin and
 * <= held AAC PTS. No rebasing: held descriptor, DTS/PTS and payload unchanged.
 * New split must increase and admit this whole packet; otherwise unchanged.
 */
int32_t yi4k_1107_aac_boundary_advance(yi4k_1107_aac_boundary *, uint64_t segment_id,
    uint64_t source_epoch, yi4k_1107_aac_time split);

/* Only READY may be handed downstream; caller reads held/bytes, segment_id,
 * source_epoch and ticket without mutating them. Receipt is NOT a mux status:
 * CUSTODY_CONFIRMED attests separate downstream byte custody that survives
 * ProcessAudio AND Close until independent CLOSED-output packet verification
 * (or an independently verified durable file), with no remaining slot readers.
 * Stock writer success/owned_mux_finish/Close success alone are insufficient.
 * RETRY_UNTOUCHED attests no downstream bytes/index/cursor/transaction changed;
 * retains same ticket, bytes and metadata. AMBIGUOUS freezes and retains them;
 * no automatic writer replay, discard or recovery. Wrong/stale tickets cannot
 * release; a successful receipt releases once. Receipt honesty is external.
 */
int32_t yi4k_1107_aac_boundary_receipt(yi4k_1107_aac_boundary *, uint64_t ticket,
    uint32_t outcome);
#endif
