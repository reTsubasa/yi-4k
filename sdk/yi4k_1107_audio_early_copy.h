#ifndef YI4K_1107_AUDIO_EARLY_COPY_H
#define YI4K_1107_AUDIO_EARLY_COPY_H

#include "yi4k_1107_early_copy.h"

/* Offline seam for event 0 only. No device address binding, registration,
 * installer, lease, codec or SD writer. One audio stream/queue, serialized
 * producer; do not share that queue with a video producer.
 */
typedef struct yi4k_1107_audio_chain {
    void *context;
    int32_t (*original)(void *, const void *);
} yi4k_1107_audio_chain;

typedef struct yi4k_1107_audio_ingress {
    yi4k_1107_early_copy *owned;
    /* Own observation ordinal modulo 2^32, NOT the stock FIFO sequence.
     * Advance for every valid ordinary event, including explicit copy drops.
     * Initialize only while producer is quiescent; EOS does not reset it.
     */
    uint32_t next_sequence;
} yi4k_1107_audio_ingress;

/* Reads only the defined fields; two unwritten words are zeroed in the
 * owned snapshot. Ordinary type8/flags1 map to the common FrameDesc. EOS maps
 * to an owned normalized typeFF/length00FFFFFF, with no source bytes read.
 * This owned terminal is NOT the stock state-dependent 00FFFFFE marker.
 * Original receives its untouched one-argument event exactly once on every
 * path with valid immutable chain, including NULL adapter/event, bad EOS,
 * invalid ring, queue full and synchronous recursion. No retry or I/O.
 * All non-null pointers must identify accessible aligned live C objects.
 * The source payload must be stable/coherent during bounded copy, established
 * externally; synchronous call order alone does not prove a hardware lease.
 */
yi4k_1107_early_result yi4k_1107_audio_on_event(
    const yi4k_1107_audio_chain *, yi4k_1107_audio_ingress *, const void *);
#endif
