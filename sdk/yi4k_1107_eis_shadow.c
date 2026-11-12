/* Offline integration candidate, NOT a loader or deployment-ready hook.
 * Fixed append buffer; nonblocking exclusive claim; stock result preserved.
 */
#include "yi4k_1107_eis_shadow.h"
#include <stddef.h>

_Static_assert(sizeof(struct yi4k_eis_shadow_record) == 80, "record ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_record, commit) == 76, "commit ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_buffer, records) == 64, "header ABI");
_Static_assert(sizeof(struct yi4k_eis_shadow_buffer) == 10304, "buffer ABI");

struct yi4k_eis_shadow_control yi4k_eis_shadow_control;
const struct yi4k_eis_shadow_sources yi4k_eis_shadow_sources_1107 = {
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

/* One LDREX/STREX attempt, never a retry loop. An interrupt or competing core
 * may cause a false busy result; this is acceptable for a bounded observer. */
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

void yi4k_eis_shadow_initialize(struct yi4k_eis_shadow_buffer *buffer)
{
    uint32_t i;
    if (buffer == 0) return;
    buffer->state = YI4K_EIS_SHADOW_DISARMED;
    buffer->magic = YI4K_EIS_SHADOW_MAGIC;
    buffer->version = YI4K_EIS_SHADOW_VERSION;
    buffer->capacity = YI4K_EIS_SHADOW_CAPACITY;
    buffer->record_bytes = sizeof(struct yi4k_eis_shadow_record);
    buffer->lock = 0;
    buffer->committed = 0;
    buffer->dropped_full = 0;
    buffer->full_counter_saturated = 0;
    buffer->busy_seen = 0;
    buffer->invalid_sources_seen = 0;
    for (i = 0; i < 5; ++i) buffer->reserved[i] = 0;
    for (i = 0; i < YI4K_EIS_SHADOW_CAPACITY; ++i) buffer->records[i].commit = 0;
    barrier();
}

__attribute__((noinline))
int32_t yi4k_eis_shadow_dispatch(uint32_t mode, int32_t input,
                                const int32_t *previous, uint32_t site)
{
    struct yi4k_eis_shadow_buffer *buffer = yi4k_eis_shadow_control.buffer;
    const struct yi4k_eis_shadow_sources *sources = yi4k_eis_shadow_control.sources;
    struct yi4k_eis_shadow_record *record;
    uint32_t sequence;
    int32_t output;
    if (buffer == 0 || sources == 0 ||
        buffer->magic != YI4K_EIS_SHADOW_MAGIC ||
        buffer->version != YI4K_EIS_SHADOW_VERSION ||
        buffer->capacity != YI4K_EIS_SHADOW_CAPACITY ||
        buffer->record_bytes != sizeof(struct yi4k_eis_shadow_record) ||
        buffer->state != YI4K_EIS_SHADOW_ARMED)
        return yi4k_eis_stock_filter(mode, input, previous);
    if (!try_claim(&buffer->lock)) {
        /* Idempotent latch, deliberately NOT an exact contention counter. */
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
    record->commit = 0;
    record->sequence = sequence;
    record->site = site;
    record->mode = mode;
    record->input = input;
    record->previous_address = (uint32_t)(uintptr_t)previous;
    record->previous = *previous;
    record->count_before = *sources->small_count;
    record->limit = *sources->limit;
    record->gain = *sources->gain;
    record->adaptive_enabled = *sources->adaptive_enabled;
    record->small_motion_degrees = *sources->small_motion_degrees;
    record->scale_shift = *sources->scale_shift;
    record->small_count_limit = *sources->small_count_limit;
    record->adaptive_feedback = *sources->adaptive_feedback;
    record->flags = sources->tick != 0 ? YI4K_EIS_SHADOW_TICK_VALID : 0;
    record->tick_before = sources->tick != 0 ? *sources->tick : 0;
    output = yi4k_eis_stock_filter(mode, input, previous);
    record->tick_after = sources->tick != 0 ? *sources->tick : 0;
    record->count_after = *sources->small_count;
    record->output = output;
    if (buffer->busy_seen != 0) record->flags |= YI4K_EIS_SHADOW_CONTENTION_SEEN;
    barrier();
    record->commit = sequence + 1;
    barrier();
    buffer->committed = sequence + 1;
    release(&buffer->lock);
    return output;
}
