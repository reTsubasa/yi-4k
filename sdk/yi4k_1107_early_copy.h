#ifndef YI4K_1107_EARLY_COPY_H
#define YI4K_1107_EARLY_COPY_H

#include <stdatomic.h>
#include "yi4k_1107_payload_copy.h"
#include "yi4k_1107_audio_event.h"

/* Offline seam only: no loader, registration, firmware addresses, RTOS or I/O.
 * The caller MUST establish readable/coherent payload stability for the entire
 * copy. Being called before stock WriteEntry does NOT establish a hardware lease.
 * Event layout is the pinned BitsMgr 0x1f event, after CPU address translation.
 */
#define YI4K_EARLY_VIDEO_EVENT UINT32_C(0x1f)
typedef struct yi4k_1107_video_event {
    uint32_t channel, stream, sequence, reserved_0c;
    uint64_t corrected_pts;
    uint32_t cpu_payload_address, type, flags, payload_size;
    uint32_t opaque_28, opaque_2c;
} yi4k_1107_video_event;

typedef struct yi4k_1107_owned_slot {
    uint8_t *payload;
    uint32_t capacity;
    yi4k_1107_video_event event;
    yi4k_1107_frame_desc descriptor;
    yi4k_1107_payload_copy_result copied;
    uint32_t is_end;
    uint32_t source_kind;
    yi4k_1107_audio_event audio_event; /* sanitized; meaningful for AUDIO only */
} yi4k_1107_owned_slot;

#define YI4K_EARLY_SOURCE_VIDEO UINT32_C(1)
#define YI4K_EARLY_SOURCE_AUDIO UINT32_C(2)

typedef enum yi4k_1107_early_status {
    YI4K_EARLY_COPIED, YI4K_EARLY_END, YI4K_EARLY_PASSTHROUGH,
    YI4K_EARLY_FULL, YI4K_EARLY_COPY_FAILED, YI4K_EARLY_BAD_EVENT,
    YI4K_EARLY_REENTRY, YI4K_EARLY_BAD_ADAPTER, YI4K_EARLY_BAD_CHAIN
} yi4k_1107_early_status;

/* Injected host-style context is NOT a recovered extra stock ABI argument.
 * A future stock wrapper must preserve the real three original arguments.
 * Chain storage/function/context remain valid and immutable through all calls.
 */
typedef struct yi4k_1107_early_chain {
    void *context;
    int32_t (*original)(void *, uint32_t, uint32_t, const void *);
} yi4k_1107_early_chain;

typedef struct yi4k_1107_early_result {
    int32_t original_status;
    yi4k_1107_early_status capture_status;
} yi4k_1107_early_result;

typedef struct yi4k_1107_early_copy {
    yi4k_1107_ring_view ring;
    yi4k_1107_owned_slot *slots;
    uint32_t slot_count; /* usable queue capacity is slot_count-1 */
    atomic_uint head, tail;
    uint32_t ingress_busy; /* producer-only synchronous recursion guard */
    uint32_t accepted, ended, dropped, failed;
    yi4k_1107_payload_copy_status last_copy_status;
} yi4k_1107_early_copy;

/* Init/quiescent lifecycle only. All objects/mappings must be real accessible C
 * objects, correctly aligned and disjoint. Each payload buffer must be distinct
 * from the source ring, controller, slots and every other payload allocation.
 * Init performs bounded overlap checks but is not an arbitrary pointer checker.
 * Queue needs >=2 slots; it never allocates, waits, retries or performs I/O.
 */
int32_t yi4k_1107_early_init(yi4k_1107_early_copy *,
    const yi4k_1107_ring_view *, yi4k_1107_owned_slot *, uint32_t);

/* Shared queue ingress for typed callback adapters. Same serialized producer
 * and readable/coherent source preconditions as on_event; caller owns its
 * ingress_busy guard. The descriptor and source snapshot must remain stable,
 * accessible, aligned and disjoint from the queue/buffers through this call.
 * snapshot is video_event or SANITIZED audio_event according to source_kind.
 * One adapter/queue belongs to one serialized producer stream; separate audio
 * and video callbacks must use separate queues. This is not an MPSC queue.
 * This function does not forward callbacks or install any device hook.
 */
yi4k_1107_early_status yi4k_1107_early_offer_frame(yi4k_1107_early_copy *,
    const yi4k_1107_frame_desc *, uint32_t source_kind, const void *snapshot);

/* One serialized callback producer; synchronous recursion skips capture but
 * chains its own original callback once. Concurrent producers are unsupported.
 * Non-null adapter must be successfully initialized and remain live. Non-null
 * event arguments must be accessible, aligned event objects, stable during
 * capture and disjoint from the adapter, queue and destination buffers.
 * For every valid chain, original is invoked exactly once even with NULL
 * adapter/argument, unknown events, EOS, bad payload, full queue or reentry.
 * Invalid chain cannot be forwarded and returns BAD_CHAIN. Original callback
 * exceptions/faults/non-return are outside C's contract. Arguments are unchanged.
 * Publishing occurs before chaining original. Last counters are producer-owned;
 * read them only after ingress is quiescent. This is not an installable hook.
 */
yi4k_1107_early_result yi4k_1107_early_on_event(
    const yi4k_1107_early_chain *, yi4k_1107_early_copy *,
    uint32_t, uint32_t, const void *);

/* One consumer. peek returns the same immutable owned slot until release; do
 * not release until storage has accepted/copied it. release on empty is a no-op.
 * SPSC acquire/release atomics protect slot reuse; caller supplies scheduling.
 * No re-init, free, queue reset or buffer mutation while either side is active.
 */
const yi4k_1107_owned_slot *yi4k_1107_early_peek(yi4k_1107_early_copy *);
int32_t yi4k_1107_early_release(yi4k_1107_early_copy *);

_Static_assert(ATOMIC_INT_LOCK_FREE == 2, "queue requires lock-free unsigned atomics");
_Static_assert(sizeof(unsigned int) == 4, "queue index width");
_Static_assert(sizeof(yi4k_1107_video_event) == 0x30, "BitsMgr event size");
_Static_assert(offsetof(yi4k_1107_video_event, corrected_pts) == 0x10, "event PTS");
_Static_assert(offsetof(yi4k_1107_video_event, cpu_payload_address) == 0x18, "event address");
_Static_assert(offsetof(yi4k_1107_video_event, type) == 0x1c, "event type");
_Static_assert(offsetof(yi4k_1107_video_event, payload_size) == 0x24, "event length");
#endif
