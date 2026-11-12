#ifndef YI4K_1107_EIS_SHADOW_V2_H
#define YI4K_1107_EIS_SHADOW_V2_H

#include "yi4k_1107_eis_shadow.h"

/* Offline v2 candidate. The implementation is intentionally separate from
 * the deployed v1 object; no loader or hook is provided by this header. */
struct yi4k_eis_shadow_buffer_v2 {
    uint32_t magic, version, capacity, record_bytes;
    volatile uint32_t state, lock, committed, dropped_full;
    volatile uint32_t full_counter_saturated, busy_seen, invalid_sources_seen;
    uint32_t reserved[5];
    struct yi4k_eis_shadow_record_v2 records[YI4K_EIS_SHADOW_CAPACITY];
};

struct yi4k_eis_shadow_control_v2 {
    struct yi4k_eis_shadow_buffer_v2 *buffer;
    const struct yi4k_eis_shadow_sources *sources;
};

extern struct yi4k_eis_shadow_control_v2 yi4k_eis_shadow_control_v2;
extern const struct yi4k_eis_shadow_sources yi4k_eis_shadow_sources_1107_v2;

void yi4k_eis_shadow_v2_initialize(struct yi4k_eis_shadow_buffer_v2 *buffer);
int32_t yi4k_eis_shadow_v2_dispatch(uint32_t mode, int32_t input,
                                    const int32_t *previous, uint32_t site);
int32_t yi4k_eis_shadow_v2_site1(uint32_t mode, int32_t input,
                                 const int32_t *previous);
int32_t yi4k_eis_shadow_v2_site2(uint32_t mode, int32_t input,
                                 const int32_t *previous);

/* Final integration must bind this to the verified stock A0384710 entry. */
int32_t yi4k_eis_stock_filter(uint32_t mode, int32_t input,
                              const int32_t *previous);

_Static_assert(sizeof(struct yi4k_eis_shadow_buffer_v2) == 11328,
               "v2 buffer ABI");
_Static_assert(offsetof(struct yi4k_eis_shadow_buffer_v2, records) == 64,
               "v2 header ABI");

#endif
