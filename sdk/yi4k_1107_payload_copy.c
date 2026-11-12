#include "yi4k_1107_payload_copy.h"

static int wraps_address(const void *pointer, size_t bytes)
{
    return bytes > UINTPTR_MAX - (uintptr_t)pointer;
}

static int overlaps(const void *a, size_t a_bytes, const void *b, size_t b_bytes)
{
    uintptr_t x = (uintptr_t)a;
    uintptr_t y = (uintptr_t)b;
    return x < y + b_bytes && y < x + a_bytes;
}

yi4k_1107_payload_copy_status yi4k_1107_copy_payload(
    const yi4k_1107_frame_desc *descriptor,
    const yi4k_1107_ring_view *ring,
    uint8_t *destination,
    size_t destination_capacity,
    yi4k_1107_payload_copy_result *result)
{
    uint32_t length, offset, first, second, i;
    if (descriptor == NULL ||
        (uintptr_t)descriptor % _Alignof(yi4k_1107_frame_desc) != 0 ||
        wraps_address(descriptor, sizeof(*descriptor)))
        return YI4K_COPY_BAD_ARGUMENT;

    length = descriptor->payload_size;
    if (length == YI4K_1107_FRAME_EOS_LENGTH ||
        length == YI4K_1107_DSP_VIDEO_EOS_LENGTH)
        return YI4K_COPY_END;

    if (ring == NULL || destination == NULL || result == NULL ||
        (uintptr_t)ring % _Alignof(yi4k_1107_ring_view) != 0 ||
        (uintptr_t)result % _Alignof(yi4k_1107_payload_copy_result) != 0 ||
        wraps_address(ring, sizeof(*ring)) ||
        wraps_address(result, sizeof(*result)))
        return YI4K_COPY_BAD_ARGUMENT;

    if (ring->bytes == NULL || ring->cpu_base == 0 || ring->size == 0 ||
        ring->size > UINT32_MAX - ring->cpu_base ||
        wraps_address(ring->bytes, ring->size))
        return YI4K_COPY_BAD_RING;

    if (length == 0 || length > ring->size ||
        descriptor->cpu_payload_address < ring->cpu_base)
        return YI4K_COPY_BAD_PAYLOAD;
    offset = descriptor->cpu_payload_address - ring->cpu_base;
    if (offset >= ring->size)
        return YI4K_COPY_BAD_PAYLOAD;
    if (length > destination_capacity)
        return YI4K_COPY_NO_SPACE;
    if (wraps_address(destination, length))
        return YI4K_COPY_BAD_ARGUMENT;

    if (overlaps(destination, length, ring->bytes, ring->size) ||
        overlaps(result, sizeof(*result), ring->bytes, ring->size) ||
        overlaps(destination, length, result, sizeof(*result)) ||
        overlaps(destination, length, descriptor, sizeof(*descriptor)) ||
        overlaps(result, sizeof(*result), descriptor, sizeof(*descriptor)) ||
        overlaps(destination, length, ring, sizeof(*ring)) ||
        overlaps(result, sizeof(*result), ring, sizeof(*ring)))
        return YI4K_COPY_OVERLAP;

    first = ring->size - offset;
    if (first > length)
        first = length;
    second = length - first;
    for (i = 0; i < first; ++i)
        destination[i] = ring->bytes[offset + i];
    for (i = 0; i < second; ++i)
        destination[first + i] = ring->bytes[i];

    result->copied_bytes = length;
    result->first_span_bytes = first;
    result->second_span_bytes = second;
    result->descriptor_sync_hint =
        descriptor->type == YI4K_1107_NORMAL_H264_IDR_TYPE;
    return YI4K_COPY_OK;
}
