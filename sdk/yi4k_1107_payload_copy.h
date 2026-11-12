#ifndef YI4K_1107_PAYLOAD_COPY_H
#define YI4K_1107_PAYLOAD_COPY_H

#include <stddef.h>
#include <stdint.h>
#include "yi4k_1107_video_descriptor.h"

/* Offline integration candidate only. Caller must already own a stable readable
 * CPU mapping, a descriptor snapshot and coherent payload bytes. This module
 * cannot stop the producer, invalidate caches, translate DSP addresses or acquire
 * a virtual FIFO. No device address is hardcoded or accessed automatically. */
typedef struct yi4k_1107_ring_view {
    const uint8_t *bytes;
    uint32_t cpu_base;
    uint32_t size;
} yi4k_1107_ring_view;

typedef struct yi4k_1107_payload_copy_result {
    uint32_t copied_bytes;
    uint32_t first_span_bytes;
    uint32_t second_span_bytes;
    /* Descriptor hint only. Requires independent NAL7/8/5 validation. */
    uint32_t descriptor_sync_hint;
} yi4k_1107_payload_copy_result;

typedef enum yi4k_1107_payload_copy_status {
    YI4K_COPY_OK = 0,
    YI4K_COPY_END = 1,
    YI4K_COPY_BAD_ARGUMENT = 2,
    YI4K_COPY_BAD_RING = 3,
    YI4K_COPY_BAD_PAYLOAD = 4,
    YI4K_COPY_NO_SPACE = 5,
    YI4K_COPY_OVERLAP = 6
} yi4k_1107_payload_copy_status;

/* Validates all detectable preconditions before writing. On a returned error or
 * END, destination/result are unchanged. Hardware faults or concurrent producer
 * mutations are outside this contract. At most one ring wrap is accepted.
 * Success only means bytes were copied; outer code must then validate/store the
 * copy before advancing its OWN virtual cursor. This function never advances it.
 * Destination/result must not overlap source ring, descriptor, ring view or each
 * other. The returned owned bytes do not prove valid or playable H.264. */
yi4k_1107_payload_copy_status yi4k_1107_copy_payload(
    const yi4k_1107_frame_desc *descriptor,
    const yi4k_1107_ring_view *ring,
    uint8_t *destination,
    size_t destination_capacity,
    yi4k_1107_payload_copy_result *result);

#endif
