#include "yi4k_1107_packet_custody.h"

static int invalid(const void *p, size_t n) {
    return p == NULL || n > UINTPTR_MAX - (uintptr_t)p;
}
static int overlap(const void *p, size_t n, const void *q, size_t m) {
    return (uintptr_t)p < (uintptr_t)q + m && (uintptr_t)q < (uintptr_t)p + n;
}
static void bytes_copy(void *to, const void *from, size_t n) {
    uint8_t *d = to; const uint8_t *s = from;
    while (n--) *d++ = *s++;
}
static int frozen(yi4k_1107_packet_custody *c, int32_t status) {
    c->state = YI4K_CUSTODY_FROZEN; return status;
}
static int aliases(const yi4k_1107_packet_custody *c, const void *p, size_t n) {
    uint32_t i;
    if (overlap(p, n, c, sizeof(*c)) ||
        overlap(p, n, c->slots, (size_t)c->slot_count * sizeof(*c->slots))) return 1;
    for (i = 0; i < c->slot_count; ++i)
        if (overlap(p, n, c->slots[i].payload, c->slots[i].capacity)) return 1;
    return 0;
}
int32_t yi4k_1107_custody_init(yi4k_1107_packet_custody *c,
    yi4k_1107_custody_slot *slots, uint32_t count, uint32_t kind) {
    uint32_t i, j; size_t n = (size_t)count * sizeof(*slots);
    if (invalid(c, sizeof(*c)) || invalid(slots, n) || count == 0 ||
        n / sizeof(*slots) != count ||
        (uintptr_t)c % _Alignof(yi4k_1107_packet_custody) ||
        (uintptr_t)slots % _Alignof(yi4k_1107_custody_slot) ||
        (kind != YI4K_EARLY_SOURCE_VIDEO && kind != YI4K_EARLY_SOURCE_AUDIO) ||
        overlap(c, sizeof(*c), slots, n)) return YI4K_CUSTODY_BAD_ARGUMENT;
    for (i = 0; i < count; ++i) {
        if (slots[i].capacity == 0 || invalid(slots[i].payload, slots[i].capacity) ||
            overlap(slots[i].payload, slots[i].capacity, c, sizeof(*c)) ||
            overlap(slots[i].payload, slots[i].capacity, slots, n))
            return YI4K_CUSTODY_BAD_ARGUMENT;
        for (j = 0; j < i; ++j)
            if (overlap(slots[i].payload, slots[i].capacity,
                        slots[j].payload, slots[j].capacity))
                return YI4K_CUSTODY_BAD_ARGUMENT;
    }
    c->slots = slots; c->slot_count = count; c->source_kind = kind;
    c->count = 0; c->checked = 0; c->segment_id = 0; c->state = YI4K_CUSTODY_IDLE;
    return YI4K_CUSTODY_OK;
}
int32_t yi4k_1107_custody_begin(yi4k_1107_packet_custody *c, uint64_t id) {
    if (c == NULL || id == 0) return YI4K_CUSTODY_BAD_ARGUMENT;
    if (c->state != YI4K_CUSTODY_IDLE || c->count != 0)
        return YI4K_CUSTODY_BAD_STATE;
    /* IDs never repeat within an instance, including after successful commit. */
    if (id <= c->segment_id) return YI4K_CUSTODY_BAD_ARGUMENT;
    c->segment_id = id; c->checked = 0; c->state = YI4K_CUSTODY_COLLECT;
    return YI4K_CUSTODY_OK;
}
int32_t yi4k_1107_custody_store(yi4k_1107_packet_custody *c,
    const yi4k_1107_mux_packet *p) {
    yi4k_1107_custody_slot *s; const yi4k_1107_frame_desc *d;
    if (c == NULL || invalid(p, sizeof(*p))) return YI4K_CUSTODY_BAD_ARGUMENT;
    if (c->state != YI4K_CUSTODY_COLLECT) return YI4K_CUSTODY_BAD_STATE;
    d = &p->descriptor;
    if (aliases(c, p, sizeof(*p)) || p->is_end || p->source_kind != c->source_kind ||
        d->flags != 1 || d->payload_size == 0 || d->payload_size >= UINT32_C(0xfffffe) ||
        (c->source_kind == YI4K_EARLY_SOURCE_AUDIO ? d->type != 8 : (d->type < 1 || d->type > 4)) ||
        invalid(p->payload, d->payload_size) || aliases(c, p->payload, d->payload_size))
        return YI4K_CUSTODY_BAD_ARGUMENT;
    if (c->count) {
        const yi4k_1107_frame_desc *last = &c->slots[c->count - 1].descriptor;
        if (d->sequence <= last->sequence || d->corrected_pts <= last->corrected_pts)
            return frozen(c, YI4K_CUSTODY_MISMATCH);
    }
    if (c->count == c->slot_count) return YI4K_CUSTODY_FULL;
    s = &c->slots[c->count];
    if (d->payload_size > s->capacity) return YI4K_CUSTODY_FULL;
    bytes_copy(s->payload, p->payload, d->payload_size);
    bytes_copy(&s->descriptor, d, sizeof(*d));
    ++c->count;
    return YI4K_CUSTODY_OK;
}
int32_t yi4k_1107_custody_closed(yi4k_1107_packet_custody *c, int32_t status) {
    if (c == NULL) return YI4K_CUSTODY_BAD_ARGUMENT;
    if (c->state != YI4K_CUSTODY_COLLECT) return YI4K_CUSTODY_BAD_STATE;
    if (status != 0) return frozen(c, YI4K_CUSTODY_CLOSE_FAILED);
    if (c->count == 0) return frozen(c, YI4K_CUSTODY_INCOMPLETE);
    c->state = YI4K_CUSTODY_VERIFY; return YI4K_CUSTODY_OK;
}
int32_t yi4k_1107_custody_check(yi4k_1107_packet_custody *c, uint64_t id,
    const yi4k_1107_frame_desc *d, const uint8_t *actual) {
    const yi4k_1107_custody_slot *s; uint32_t i;
    if (c == NULL || invalid(d, sizeof(*d))) return YI4K_CUSTODY_BAD_ARGUMENT;
    if (c->state != YI4K_CUSTODY_VERIFY) return YI4K_CUSTODY_BAD_STATE;
    if (id != c->segment_id || c->checked >= c->count)
        return frozen(c, YI4K_CUSTODY_MISMATCH);
    s = &c->slots[c->checked];
    if (d->sequence != s->descriptor.sequence || d->corrected_pts != s->descriptor.corrected_pts ||
        d->payload_size != s->descriptor.payload_size || d->type != s->descriptor.type ||
        d->flags != s->descriptor.flags || invalid(actual, d->payload_size) ||
        aliases(c, actual, d->payload_size) || aliases(c, d, sizeof(*d)))
        return frozen(c, YI4K_CUSTODY_MISMATCH);
    for (i = 0; i < d->payload_size; ++i)
        if (s->payload[i] != actual[i]) return frozen(c, YI4K_CUSTODY_MISMATCH);
    ++c->checked;
    return YI4K_CUSTODY_OK;
}
int32_t yi4k_1107_custody_commit(yi4k_1107_packet_custody *c,
    uint64_t id, uint32_t complete) {
    if (c == NULL) return YI4K_CUSTODY_BAD_ARGUMENT;
    if (c->state != YI4K_CUSTODY_VERIFY) return YI4K_CUSTODY_BAD_STATE;
    if (id != c->segment_id || c->checked != c->count || complete != 1)
        return frozen(c, YI4K_CUSTODY_INCOMPLETE);
    c->count = 0; c->checked = 0; c->state = YI4K_CUSTODY_IDLE;
    return YI4K_CUSTODY_OK;
}
