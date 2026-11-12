#ifndef YI4K_1107_OWNED_MUX_H
#define YI4K_1107_OWNED_MUX_H

#include "yi4k_1107_early_copy.h"

/* Offline handoff only. No firmware binding, scheduler, file/index writer,
 * codec validation, timestamp rebasing or hook installer is provided here.
 * One exclusive consumer, one serialized producer, one stream per early queue.
 */
typedef struct yi4k_1107_owned_arena {
    uint8_t *bytes;
    uint32_t cpu_base, size;
} yi4k_1107_owned_arena;

typedef struct yi4k_1107_mux_packet {
    yi4k_1107_frame_desc descriptor; /* private copy; address relocated */
    uint32_t ring_base, ring_end; /* end exclusive; set BOTH stock track bounds */
    uint32_t source_kind, is_end;
    const uint8_t *payload; /* owned CPU mapping, NULL for normalized terminal */
} yi4k_1107_mux_packet;

typedef enum yi4k_1107_mux_status {
    YI4K_MUX_EMPTY = 0, YI4K_MUX_READY = 1, YI4K_MUX_END = 2,
    YI4K_MUX_POISONED = 3, YI4K_MUX_BAD_ARGUMENT = 4,
    YI4K_MUX_BAD_FRAME = 5, YI4K_MUX_NO_PENDING = 6,
    YI4K_MUX_RELEASED = 7
} yi4k_1107_mux_status;

typedef struct yi4k_1107_owned_mux {
    yi4k_1107_early_copy *queue;
    yi4k_1107_owned_arena arena;
    uint32_t source_kind, poisoned;
    const yi4k_1107_owned_slot *held;
    yi4k_1107_mux_packet packet;
    int32_t last_writer_status;
} yi4k_1107_owned_mux;

/* Quiescent init only, after early_init. All queue payload allocations must lie
 * completely in this single contiguous arena; the whole arena must be separate
 * from the source ring and all control objects. cpu_base describes the actual
 * CPU address corresponding to bytes[0], not a DSP address. Host tests can use
 * an explicit synthetic mapping; the mapping itself cannot be proved by C.
 * All pointers identify accessible aligned live objects. Queue metadata and
 * mappings stay immutable through the consumer's lifetime. No second consumer,
 * external release/reset, free, or buffer mutation while either side is active.
 * Invalid init leaves consumer unchanged. No automatic allocation or copying.
 */
int32_t yi4k_1107_owned_mux_init(yi4k_1107_owned_mux *,
    yi4k_1107_early_copy *, const yi4k_1107_owned_arena *, uint32_t source_kind);

/* Acquire a read-only packet in consumer->packet. Repeated prepare is idempotent
 * until finish: same head, same private descriptor and same owned payload lease.
 * Source event/descriptor are never rewritten. Ordinary packet address becomes
 * arena.cpu_base+(slot.payload-arena.bytes); source PTS/sequence are preserved.
 * END normalizes existing early-copy video type1/flags1/sentinel or audio
 * typeFF/flags1 terminal; copied span metadata must all be zero. Video EOS may
 * carry invalid source address/PTS and those values are ignored, never read as
 * payload. Other terminal metadata is rejected; 0xFFFFFE is not accepted here.
 * Do not submit END as an ordinary sample; close/terminal policy
 * belongs to the caller. Malformed input poisons without releasing the slot.
 * This validates mapping/metadata only, not H264/AAC or segment decodability.
 */
yi4k_1107_mux_status yi4k_1107_owned_mux_prepare(yi4k_1107_owned_mux *);

/* Call once after the held sample/terminal has been handled. status==0 AND
 * payload_use_complete==1 attest that the caller's writer/terminal operation
 * succeeded and no stream/DMA/index consumer retains any payload dependency.
 * The caller must establish that contract from the REAL writer; status==0 alone
 * is insufficient. A false success receipt cannot be detected here.
 * Only that pair releases the source staging slot. Any other outcome poisons
 * and holds it, preventing blind retry after partial media/index writes.
 * No rollback, discard, recovery or reset API: quiesce both sides and recover
 * the segment/storage outside this module before rebuilding the handoff.
 */
yi4k_1107_mux_status yi4k_1107_owned_mux_finish(yi4k_1107_owned_mux *,
    int32_t writer_status, uint32_t payload_use_complete);

#endif
