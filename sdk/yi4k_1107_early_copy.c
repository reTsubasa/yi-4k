#include "yi4k_1107_early_copy.h"

static int invalid_range(const void *p, size_t n)
{
    return p == NULL || n > UINTPTR_MAX - (uintptr_t)p;
}

static int overlap(const void *p, size_t n, const void *q, size_t m)
{
    return (uintptr_t)p < (uintptr_t)q + m &&
        (uintptr_t)q < (uintptr_t)p + n;
}

static uint32_t next_index(uint32_t index, uint32_t count)
{
    return index + 1 == count ? 0 : index + 1;
}

/* Keep freestanding builds independent of compiler runtime memclr helpers. */
static void clear_snapshot(void *snapshot, size_t size)
{
    volatile uint8_t *p = snapshot;
    size_t i;
    for (i = 0; i < size; ++i) p[i] = 0;
}

int32_t yi4k_1107_early_init(yi4k_1107_early_copy *adapter,
    const yi4k_1107_ring_view *ring, yi4k_1107_owned_slot *slots, uint32_t count)
{
    uint32_t i, j;
    size_t slot_bytes = (size_t)count * sizeof(*slots);
    if (invalid_range(adapter, sizeof(*adapter)) ||
        invalid_range(ring, sizeof(*ring)) || count < 2 ||
        slot_bytes / sizeof(*slots) != count ||
        (uintptr_t)adapter % _Alignof(yi4k_1107_early_copy) ||
        (uintptr_t)ring % _Alignof(yi4k_1107_ring_view) ||
        (uintptr_t)slots % _Alignof(yi4k_1107_owned_slot))
        return -1;
    if (invalid_range(slots, slot_bytes) || ring->size == 0 ||
        ring->cpu_base == 0 || ring->size > UINT32_MAX - ring->cpu_base ||
        invalid_range(ring->bytes, ring->size) ||
        overlap(adapter, sizeof(*adapter), slots, slot_bytes) ||
        overlap(adapter, sizeof(*adapter), ring, sizeof(*ring)) ||
        overlap(slots, slot_bytes, ring, sizeof(*ring)) ||
        overlap(adapter, sizeof(*adapter), ring->bytes, ring->size) ||
        overlap(slots, slot_bytes, ring->bytes, ring->size))
        return -1;
    for (i = 0; i < count; ++i) {
        const uint8_t *p = slots[i].payload;
        size_t n = slots[i].capacity;
        if (n == 0 || invalid_range(p, n) ||
            overlap(p, n, adapter, sizeof(*adapter)) ||
            overlap(p, n, slots, slot_bytes) ||
            overlap(p, n, ring, sizeof(*ring)) ||
            overlap(p, n, ring->bytes, ring->size))
            return -1;
        for (j = 0; j < i; ++j)
            if (overlap(p, n, slots[j].payload, slots[j].capacity))
                return -1;
    }
    adapter->ring = *ring;
    adapter->slots = slots;
    adapter->slot_count = count;
    atomic_init(&adapter->head, 0);
    atomic_init(&adapter->tail, 0);
    adapter->ingress_busy = 0;
    adapter->accepted = adapter->ended = adapter->dropped = adapter->failed = 0;
    adapter->last_copy_status = YI4K_COPY_OK;
    return 0;
}

yi4k_1107_early_status yi4k_1107_early_offer_frame(yi4k_1107_early_copy *adapter,
    const yi4k_1107_frame_desc *descriptor, uint32_t kind, const void *snapshot)
{
    yi4k_1107_owned_slot *slot;
    yi4k_1107_payload_copy_result copied = {0};
    yi4k_1107_payload_copy_status status;
    uint32_t tail, next;
    if (adapter == NULL) return YI4K_EARLY_BAD_ADAPTER;
    if (descriptor == NULL || snapshot == NULL ||
        (uintptr_t)descriptor % _Alignof(yi4k_1107_frame_desc) ||
        (kind != YI4K_EARLY_SOURCE_VIDEO && kind != YI4K_EARLY_SOURCE_AUDIO) ||
        (kind == YI4K_EARLY_SOURCE_VIDEO &&
            (uintptr_t)snapshot % _Alignof(yi4k_1107_video_event)) ||
        (kind == YI4K_EARLY_SOURCE_AUDIO &&
            (uintptr_t)snapshot % _Alignof(yi4k_1107_audio_event))) {
        ++adapter->failed;
        return YI4K_EARLY_BAD_EVENT;
    }
    tail = atomic_load_explicit(&adapter->tail, memory_order_relaxed);
    next = next_index(tail, adapter->slot_count);
    if (next == atomic_load_explicit(&adapter->head, memory_order_acquire)) {
        ++adapter->dropped;
        return YI4K_EARLY_FULL;
    }
    slot = &adapter->slots[tail];
    status = yi4k_1107_copy_payload(descriptor, &adapter->ring,
        slot->payload, slot->capacity, &copied);
    adapter->last_copy_status = status;
    if (status != YI4K_COPY_OK && status != YI4K_COPY_END) {
        ++adapter->failed;
        return YI4K_EARLY_COPY_FAILED;
    }
    if (kind == YI4K_EARLY_SOURCE_VIDEO) {
        slot->event = *(const yi4k_1107_video_event *)snapshot;
        clear_snapshot(&slot->audio_event, sizeof(slot->audio_event));
    } else {
        slot->audio_event = *(const yi4k_1107_audio_event *)snapshot;
        clear_snapshot(&slot->event, sizeof(slot->event));
    }
    slot->source_kind = kind;
    slot->descriptor = *descriptor;
    slot->copied = copied;
    slot->is_end = status == YI4K_COPY_END;
    ++adapter->accepted;
    if (slot->is_end) ++adapter->ended;
    atomic_store_explicit(&adapter->tail, next, memory_order_release);
    return slot->is_end ? YI4K_EARLY_END : YI4K_EARLY_COPIED;
}

static yi4k_1107_early_status capture(yi4k_1107_early_copy *adapter,
    uint32_t event_code, const void *argument)
{
    const yi4k_1107_video_event *event = argument;
    yi4k_1107_frame_desc descriptor = {0};
    if (event_code != YI4K_EARLY_VIDEO_EVENT)
        return YI4K_EARLY_PASSTHROUGH;
    if (event == NULL || (uintptr_t)event % _Alignof(yi4k_1107_video_event) ||
        event->stream > 2 || event->type > UINT8_MAX) {
        ++adapter->failed;
        return YI4K_EARLY_BAD_EVENT;
    }
    descriptor.sequence = event->sequence;
    descriptor.corrected_pts = event->corrected_pts;
    descriptor.type = (uint8_t)event->type;
    descriptor.flags = 1; /* pinned stock video callback mapping */
    descriptor.cpu_payload_address = event->cpu_payload_address;
    descriptor.payload_size = event->payload_size;
    return yi4k_1107_early_offer_frame(adapter, &descriptor, YI4K_EARLY_SOURCE_VIDEO, event);
}

yi4k_1107_early_result yi4k_1107_early_on_event(
    const yi4k_1107_early_chain *chain, yi4k_1107_early_copy *adapter,
    uint32_t handle, uint32_t event_code, const void *argument)
{
    yi4k_1107_early_result result;
    uint32_t entered = 0;
    result.original_status = 0;
    if (chain == NULL || chain->original == NULL) {
        result.capture_status = YI4K_EARLY_BAD_CHAIN;
        return result;
    }
    if (adapter == NULL) {
        result.capture_status = YI4K_EARLY_BAD_ADAPTER;
    } else if (adapter->ingress_busy) {
        ++adapter->dropped;
        result.capture_status = YI4K_EARLY_REENTRY;
    } else {
        entered = 1;
        adapter->ingress_busy = 1;
        result.capture_status = capture(adapter, event_code, argument);
    }
    result.original_status = chain->original(chain->context, handle, event_code, argument);
    if (entered) adapter->ingress_busy = 0;
    return result;
}

const yi4k_1107_owned_slot *yi4k_1107_early_peek(yi4k_1107_early_copy *adapter)
{
    uint32_t head = atomic_load_explicit(&adapter->head, memory_order_relaxed);
    if (head == atomic_load_explicit(&adapter->tail, memory_order_acquire))
        return NULL;
    return &adapter->slots[head];
}

int32_t yi4k_1107_early_release(yi4k_1107_early_copy *adapter)
{
    uint32_t head = atomic_load_explicit(&adapter->head, memory_order_relaxed);
    if (head == atomic_load_explicit(&adapter->tail, memory_order_acquire))
        return 0;
    atomic_store_explicit(&adapter->head, next_index(head, adapter->slot_count), memory_order_release);
    return 1;
}
