#include "yi4k_1107_owned_mux.h"

static int invalid(const void *p, size_t n)
{
    return p == NULL || n > UINTPTR_MAX - (uintptr_t)p;
}

static int overlaps(const void *p, size_t n, const void *q, size_t m)
{
    return (uintptr_t)p < (uintptr_t)q + m &&
        (uintptr_t)q < (uintptr_t)p + n;
}

static void clear(void *p, size_t n)
{
    volatile uint8_t *b = p;
    size_t i;
    for (i = 0; i < n; ++i) b[i] = 0;
}

static int in_arena(const yi4k_1107_owned_arena *a,
    const uint8_t *payload, uint32_t capacity)
{
    uintptr_t offset;
    if (payload == NULL || capacity == 0 || (uintptr_t)payload < (uintptr_t)a->bytes)
        return 0;
    offset = (uintptr_t)payload - (uintptr_t)a->bytes;
    return offset < a->size && capacity <= a->size - offset;
}

int32_t yi4k_1107_owned_mux_init(yi4k_1107_owned_mux *c,
    yi4k_1107_early_copy *q, const yi4k_1107_owned_arena *a, uint32_t kind)
{
    uint32_t i, j;
    size_t metadata_bytes;
    if (invalid(c, sizeof(*c)) || invalid(q, sizeof(*q)) || invalid(a, sizeof(*a)) ||
        (uintptr_t)c % _Alignof(yi4k_1107_owned_mux) ||
        (uintptr_t)q % _Alignof(yi4k_1107_early_copy) ||
        (uintptr_t)a % _Alignof(yi4k_1107_owned_arena) ||
        (kind != YI4K_EARLY_SOURCE_VIDEO && kind != YI4K_EARLY_SOURCE_AUDIO))
        return -1;
    metadata_bytes = (size_t)q->slot_count * sizeof(*q->slots);
    if (q->slot_count < 2 || metadata_bytes / sizeof(*q->slots) != q->slot_count ||
        invalid(q->slots, metadata_bytes) ||
        (uintptr_t)q->slots % _Alignof(yi4k_1107_owned_slot) ||
        a->size == 0 || a->cpu_base == 0 || a->size > UINT32_MAX - a->cpu_base ||
        invalid(a->bytes, a->size) || invalid(q->ring.bytes, q->ring.size) ||
        q->ring.size == 0 || q->ring.cpu_base == 0 ||
        q->ring.size > UINT32_MAX - q->ring.cpu_base ||
        atomic_load_explicit(&q->head, memory_order_relaxed) >= q->slot_count ||
        atomic_load_explicit(&q->tail, memory_order_relaxed) >= q->slot_count)
        return -1;
    if (overlaps(c, sizeof(*c), q, sizeof(*q)) ||
        overlaps(c, sizeof(*c), a, sizeof(*a)) ||
        overlaps(c, sizeof(*c), q->slots, metadata_bytes) ||
        overlaps(c, sizeof(*c), q->ring.bytes, q->ring.size) ||
        overlaps(c, sizeof(*c), a->bytes, a->size) ||
        overlaps(a->bytes, a->size, q, sizeof(*q)) ||
        overlaps(a->bytes, a->size, a, sizeof(*a)) ||
        overlaps(a->bytes, a->size, q->slots, metadata_bytes) ||
        overlaps(a->bytes, a->size, q->ring.bytes, q->ring.size) ||
        (a->cpu_base < q->ring.cpu_base + q->ring.size &&
         q->ring.cpu_base < a->cpu_base + a->size))
        return -1;
    for (i = 0; i < q->slot_count; ++i) {
        if (!in_arena(a, q->slots[i].payload, q->slots[i].capacity)) return -1;
        for (j = 0; j < i; ++j)
            if (overlaps(q->slots[i].payload, q->slots[i].capacity,
                q->slots[j].payload, q->slots[j].capacity)) return -1;
    }
    c->queue = q;
    c->arena = *a;
    c->source_kind = kind;
    c->poisoned = 0;
    c->held = NULL;
    clear(&c->packet, sizeof(c->packet));
    c->last_writer_status = 0;
    return 0;
}

static yi4k_1107_mux_status bad_frame(yi4k_1107_owned_mux *c)
{
    c->poisoned = 1;
    return YI4K_MUX_BAD_FRAME;
}

yi4k_1107_mux_status yi4k_1107_owned_mux_prepare(yi4k_1107_owned_mux *c)
{
    const yi4k_1107_owned_slot *slot;
    const yi4k_1107_frame_desc *d;
    yi4k_1107_mux_packet packet;
    uint32_t length;
    if (c == NULL) return YI4K_MUX_BAD_ARGUMENT;
    if (c->poisoned) return YI4K_MUX_POISONED;
    if (c->held != NULL)
        return c->packet.is_end ? YI4K_MUX_END : YI4K_MUX_READY;
    slot = yi4k_1107_early_peek(c->queue);
    if (slot == NULL) return YI4K_MUX_EMPTY;
    c->held = slot;
    d = &slot->descriptor;
    length = d->payload_size;
    clear(&packet, sizeof(packet));
    if (slot->source_kind != c->source_kind || slot->is_end > 1)
        return bad_frame(c);
    packet.source_kind = c->source_kind;
    packet.ring_base = c->arena.cpu_base;
    packet.ring_end = c->arena.cpu_base + c->arena.size;
    if (slot->is_end) {
        if ((length != YI4K_1107_FRAME_EOS_LENGTH &&
             length != YI4K_1107_DSP_VIDEO_EOS_LENGTH) ||
            slot->copied.copied_bytes != 0 || slot->copied.first_span_bytes != 0 ||
            slot->copied.second_span_bytes != 0 || slot->copied.descriptor_sync_hint != 0 ||
            d->flags != 1 ||
            (c->source_kind == YI4K_EARLY_SOURCE_VIDEO && d->type != 1) ||
            (c->source_kind == YI4K_EARLY_SOURCE_AUDIO &&
             (d->type != 0xFF || d->cpu_payload_address != 0 || d->corrected_pts != 0 ||
              length != YI4K_1107_FRAME_EOS_LENGTH)))
            return bad_frame(c);
        packet.is_end = 1;
        packet.descriptor.type = 0xFF;
        packet.descriptor.payload_size = YI4K_1107_FRAME_EOS_LENGTH;
    } else {
        if (!in_arena(&c->arena, slot->payload, slot->capacity) ||
            length == 0 || length == UINT32_C(0xFFFFFE) ||
            length == YI4K_1107_FRAME_EOS_LENGTH ||
            length == YI4K_1107_DSP_VIDEO_EOS_LENGTH || length > slot->capacity ||
            length != slot->copied.copied_bytes ||
            (uint64_t)slot->copied.first_span_bytes + slot->copied.second_span_bytes != length ||
            d->flags != 1 ||
            (c->source_kind == YI4K_EARLY_SOURCE_VIDEO && (d->type < 1 || d->type > 4)) ||
            (c->source_kind == YI4K_EARLY_SOURCE_AUDIO && d->type != 8))
            return bad_frame(c);
        packet.payload = slot->payload;
        packet.descriptor.sequence = d->sequence;
        packet.descriptor.corrected_pts = d->corrected_pts;
        packet.descriptor.type = d->type;
        packet.descriptor.flags = d->flags;
        packet.descriptor.cpu_payload_address = c->arena.cpu_base +
            (uint32_t)((uintptr_t)slot->payload - (uintptr_t)c->arena.bytes);
        packet.descriptor.payload_size = length;
    }
    c->packet = packet;
    return packet.is_end ? YI4K_MUX_END : YI4K_MUX_READY;
}

yi4k_1107_mux_status yi4k_1107_owned_mux_finish(yi4k_1107_owned_mux *c,
    int32_t status, uint32_t use_complete)
{
    if (c == NULL) return YI4K_MUX_BAD_ARGUMENT;
    if (c->poisoned) return YI4K_MUX_POISONED;
    if (c->held == NULL) return YI4K_MUX_NO_PENDING;
    c->last_writer_status = status;
    if (status != 0 || use_complete != 1 || yi4k_1107_early_peek(c->queue) != c->held) {
        c->poisoned = 1;
        return YI4K_MUX_POISONED;
    }
    if (yi4k_1107_early_release(c->queue) != 1) {
        c->poisoned = 1;
        return YI4K_MUX_POISONED;
    }
    c->held = NULL;
    clear(&c->packet, sizeof(c->packet));
    return YI4K_MUX_RELEASED;
}
