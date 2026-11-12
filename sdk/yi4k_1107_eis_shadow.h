#ifndef YI4K_1107_EIS_SHADOW_H
#define YI4K_1107_EIS_SHADOW_H
#include <stddef.h>
#include <stdint.h>

#define YI4K_EIS_SHADOW_MAGIC UINT32_C(0x59455331)
#define YI4K_EIS_SHADOW_VERSION UINT32_C(1)
#define YI4K_EIS_SHADOW_CAPACITY UINT32_C(128)
#define YI4K_EIS_SHADOW_DISARMED UINT32_C(0)
#define YI4K_EIS_SHADOW_ARMED UINT32_C(1)
#define YI4K_EIS_SHADOW_TICK_VALID UINT32_C(1)
#define YI4K_EIS_SHADOW_CONTENTION_SEEN UINT32_C(2)
#define YI4K_EIS_SHADOW_V2_VERSION UINT32_C(2)
#define YI4K_EIS_SHADOW_V2_RECORD_BYTES UINT32_C(88)
#define YI4K_EIS_SHADOW_V2_BUFFER_BYTES UINT32_C(11328)

/* All fields are native little-endian 32-bit words; no toolchain FILE/RTOS ABI. */
struct yi4k_eis_shadow_record {
    uint32_t sequence, site, mode;
    int32_t input;
    uint32_t previous_address;
    int32_t previous, output;
    uint32_t tick_before, tick_after;
    uint32_t count_before, count_after;
    int32_t limit, gain;
    uint32_t adaptive_enabled;
    int32_t small_motion_degrees, scale_shift;
    uint32_t small_count_limit;
    int32_t adaptive_feedback;
    uint32_t flags;
    volatile uint32_t commit; /* sequence+1, published last; zero = uncommitted */
};

/*
 * ABI design for the next recorder version; the v1 implementation below does
 * not emit this type.  The first 80 bytes retain the v1 field layout, but the
 * legacy v1 commit at offset 76 MUST stay zero.  Readers of a v2 buffer use
 * commit_v2 at offset 84 as the sole publication marker, after previous_after
 * has been read.  This prevents an old v1 reader from accepting a half-filled
 * v2 record merely because it sees the legacy offset.
 */
struct yi4k_eis_shadow_record_v2 {
    struct yi4k_eis_shadow_record core;
    int32_t previous_after;
    volatile uint32_t commit_v2;
};

_Static_assert(sizeof(struct yi4k_eis_shadow_record_v2) == YI4K_EIS_SHADOW_V2_RECORD_BYTES,
               "v2 record ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_record_v2, previous_after) == 80,
               "v2 previous_after ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_record_v2, commit_v2) == 84,
               "v2 commit ABI");

struct yi4k_eis_shadow_buffer {
    uint32_t magic, version, capacity, record_bytes;
    volatile uint32_t state, lock, committed, dropped_full;
    volatile uint32_t full_counter_saturated, busy_seen, invalid_sources_seen;
    uint32_t reserved[5];
    struct yi4k_eis_shadow_record records[YI4K_EIS_SHADOW_CAPACITY];
};

/* Caller-owned and immutable while any wrapper may run. NULL tick is allowed. */
struct yi4k_eis_shadow_sources {
    volatile const uint32_t *tick;
    volatile const uint8_t *small_count;
    volatile const int32_t *limit;
    volatile const int8_t *gain;
    volatile const uint8_t *adaptive_enabled;
    volatile const int32_t *small_motion_degrees;
    volatile const int8_t *scale_shift;
    volatile const uint8_t *small_count_limit;
    volatile const int32_t *adaptive_feedback;
};
struct yi4k_eis_shadow_control {
    struct yi4k_eis_shadow_buffer *buffer;
    const struct yi4k_eis_shadow_sources *sources;
};
extern struct yi4k_eis_shadow_control yi4k_eis_shadow_control;
extern const struct yi4k_eis_shadow_sources yi4k_eis_shadow_sources_1107;

/* Initialize/disarm/configure/read/export only after the producer is quiescent.
 * No allocation, file, RPC or printing is performed by this module. */
void yi4k_eis_shadow_initialize(struct yi4k_eis_shadow_buffer *buffer);
/* A32 veneers share the stock r0=mode,r1=input,r2=previous ABI. */
int32_t yi4k_eis_shadow_site1(uint32_t mode, int32_t input, const int32_t *previous);
int32_t yi4k_eis_shadow_site2(uint32_t mode, int32_t input, const int32_t *previous);
int32_t yi4k_eis_shadow_dispatch(uint32_t mode, int32_t input,
                                const int32_t *previous, uint32_t site);
/* Integration must bind this symbol to the verified stock entry. The offline
 * harness alone binds it to A0384710; this module does not install any hook. */
int32_t yi4k_eis_stock_filter(uint32_t mode, int32_t input, const int32_t *previous);
#endif
