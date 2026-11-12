/* Offline v2 integration candidate. No loader, hook, or device payload. */
#include "yi4k_1107_eis_shadow_v2.h"
#include <stddef.h>

_Static_assert(sizeof(struct yi4k_eis_shadow_record_v2) == 88, "record ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_record_v2, core) +
               offsetof(struct yi4k_eis_shadow_record, commit) == 76,
               "legacy commit ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_record_v2, previous_after) == 80,
               "previous_after ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_record_v2, commit_v2) == 84,
               "commit_v2 ABI");

struct yi4k_eis_shadow_control_v2 yi4k_eis_shadow_control_v2;
const struct yi4k_eis_shadow_sources yi4k_eis_shadow_sources_1107_v2 = {
    (volatile const uint32_t *)(uintptr_t)0xA1A3A528,
    (volatile const uint8_t *)(uintptr_t)0xA170AF89,
    (volatile const int32_t *)(uintptr_t)0xA170AFEC,
    (volatile const int8_t *)(uintptr_t)0xA0757B54,
    (volatile const uint8_t *)(uintptr_t)0xA170AF88,
    (volatile const int32_t *)(uintptr_t)0xA0757AD4,
    (volatile const int8_t *)(uintptr_t)0xA0757AA1,
    (volatile const uint8_t *)(uintptr_t)0xA0757AD8,
    (volatile const int32_t *)(uintptr_t)0xA0757ADC
};

static inline void barrier(void) { __asm__ volatile("dmb ish" ::: "memory"); }

static inline uint32_t try_claim(volatile uint32_t *lock)
{
    uint32_t value, failed;
    __asm__ volatile(
        "ldrex %0, [%2]\n"
        "cmp %0, #0\n"
        "bne 1f\n"
        "mov %0, #1\n"
        "strex %1, %0, [%2]\n"
        "b 2f\n"
        "1: clrex\n"
        "mov %1, #1\n"
        "2:\n"
        : "=&r" (value), "=&r" (failed) : "r" (lock) : "cc", "memory");
    if (failed == 0) barrier();
    return failed == 0;
}

static inline void release(volatile uint32_t *lock)
{
    barrier();
    *lock = 0;
}

void yi4k_eis_shadow_v2_initialize(struct yi4k_eis_shadow_buffer_v2 *buffer)
{
    uint32_t i;
    if (buffer == 0) return;
    buffer->state = YI4K_EIS_SHADOW_DISARMED;
    buffer->magic = YI4K_EIS_SHADOW_MAGIC;
    buffer->version = YI4K_EIS_SHADOW_V2_VERSION;
    buffer->capacity = YI4K_EIS_SHADOW_CAPACITY;
    buffer->record_bytes = YI4K_EIS_SHADOW_V2_RECORD_BYTES;
    buffer->lock = 0;
    buffer->committed = 0;
    buffer->dropped_full = 0;
    buffer->full_counter_saturated = 0;
    buffer->busy_seen = 0;
    buffer->invalid_sources_seen = 0;
    for (i = 0; i < 5; ++i) buffer->reserved[i] = 0;
    for (i = 0; i < YI4K_EIS_SHADOW_CAPACITY; ++i) {
        buffer->records[i].core.commit = 0;
        buffer->records[i].previous_after = 0;
        buffer->records[i].commit_v2 = 0;
    }
    barrier();
}

__attribute__((noinline))
int32_t yi4k_eis_shadow_v2_dispatch(uint32_t mode, int32_t input,
                                    const int32_t *previous, uint32_t site)
{
    struct yi4k_eis_shadow_buffer_v2 *buffer = yi4k_eis_shadow_control_v2.buffer;
    const struct yi4k_eis_shadow_sources *sources = yi4k_eis_shadow_control_v2.sources;
    struct yi4k_eis_shadow_record_v2 *record;
    uint32_t sequence;
    int32_t output;
    if (buffer == 0 || sources == 0 ||
        buffer->magic != YI4K_EIS_SHADOW_MAGIC ||
        buffer->version != YI4K_EIS_SHADOW_V2_VERSION ||
        buffer->capacity != YI4K_EIS_SHADOW_CAPACITY ||
        buffer->record_bytes != YI4K_EIS_SHADOW_V2_RECORD_BYTES ||
        buffer->state != YI4K_EIS_SHADOW_ARMED)
        return yi4k_eis_stock_filter(mode, input, previous);
    if (!try_claim(&buffer->lock)) {
        buffer->busy_seen = 1;
        return yi4k_eis_stock_filter(mode, input, previous);
    }
    if (sources->small_count == 0 || sources->limit == 0 || sources->gain == 0 ||
        sources->adaptive_enabled == 0 || sources->small_motion_degrees == 0 ||
        sources->scale_shift == 0 || sources->small_count_limit == 0 ||
        sources->adaptive_feedback == 0) {
        buffer->invalid_sources_seen = 1;
        release(&buffer->lock);
        return yi4k_eis_stock_filter(mode, input, previous);
    }
    sequence = buffer->committed;
    if (sequence >= YI4K_EIS_SHADOW_CAPACITY) {
        if (buffer->dropped_full == UINT32_MAX) buffer->full_counter_saturated = 1;
        else buffer->dropped_full += 1;
        release(&buffer->lock);
        return yi4k_eis_stock_filter(mode, input, previous);
    }
    record = &buffer->records[sequence];
    record->core.commit = 0; /* legacy v1 readers must never publish v2 rows */
    record->commit_v2 = 0;
    record->core.sequence = sequence;
    record->core.site = site;
    record->core.mode = mode;
    record->core.input = input;
    record->core.previous_address = (uint32_t)(uintptr_t)previous;
    record->core.previous = *previous;
    record->core.count_before = *sources->small_count;
    record->core.limit = *sources->limit;
    record->core.gain = *sources->gain;
    record->core.adaptive_enabled = *sources->adaptive_enabled;
    record->core.small_motion_degrees = *sources->small_motion_degrees;
    record->core.scale_shift = *sources->scale_shift;
    record->core.small_count_limit = *sources->small_count_limit;
    record->core.adaptive_feedback = *sources->adaptive_feedback;
    record->core.flags = sources->tick != 0 ? YI4K_EIS_SHADOW_TICK_VALID : 0;
    record->core.tick_before = sources->tick != 0 ? *sources->tick : 0;
    output = yi4k_eis_stock_filter(mode, input, previous);
    record->core.tick_after = sources->tick != 0 ? *sources->tick : 0;
    record->core.count_after = *sources->small_count;
    record->core.output = output;
    record->previous_after = *previous;
    if (buffer->busy_seen != 0) record->core.flags |= YI4K_EIS_SHADOW_CONTENTION_SEEN;
    barrier();
    record->commit_v2 = sequence + 1;
    barrier();
    buffer->committed = sequence + 1;
    release(&buffer->lock);
    return output;
}
