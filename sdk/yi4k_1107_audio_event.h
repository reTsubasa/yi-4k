#ifndef YI4K_1107_AUDIO_EVENT_H
#define YI4K_1107_AUDIO_EVENT_H

#include <stddef.h>
#include <stdint.h>

/* Pinned A029016C event-0 layout. The stock producer DOES NOT initialize +4
 * or +0x1c. Do not read those fields; sanitized snapshots always zero them.
 * Callback ABI is int32 callback(const event*), unlike the video callback.
 */
typedef struct yi4k_1107_audio_event {
    uint32_t encoder_handle, unwritten_04;
    uint64_t synthetic_pts;
    uint32_t eos, payload_size, cpu_payload_address, unwritten_1c;
} yi4k_1107_audio_event;

_Static_assert(sizeof(yi4k_1107_audio_event) == 0x20, "audio event size");
_Static_assert(offsetof(yi4k_1107_audio_event, synthetic_pts) == 8, "audio PTS");
_Static_assert(offsetof(yi4k_1107_audio_event, eos) == 0x10, "audio EOS");
_Static_assert(offsetof(yi4k_1107_audio_event, payload_size) == 0x14, "audio length");
_Static_assert(offsetof(yi4k_1107_audio_event, cpu_payload_address) == 0x18, "audio address");
#endif
