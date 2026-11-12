/*
 * YI 4K 1.10.7 minimal task ABI probe template.
 *
 * This is deliberately freestanding: it performs two bounded stores through
 * the caller supplied context and returns. It does not call RTOS, file,
 * logging, GUI, EIS, DMA, or Linux-facing functions. The source is for ABI
 * and code-generation checks only; no loader or camera address is embedded.
 */
#include <stdint.h>

#define YI4K_MIN_ENTERED UINT32_C(0x59494D31) /* "YIM1" */
#define YI4K_MIN_RETURNED UINT32_C(0x59494D32) /* "YIM2" */

struct yi4k_1107_minimal_context {
    volatile uint32_t entered;
    volatile uint32_t argument;
    volatile uint32_t returned;
};

/* Candidate AmbaKAL task entry ABI: void entry(uint32_t arg). */
__attribute__((noinline))
void yi4k_1107_minimal_entry(uint32_t arg)
{
    struct yi4k_1107_minimal_context *ctx =
        (struct yi4k_1107_minimal_context *)(uintptr_t)arg;

    if (ctx == (struct yi4k_1107_minimal_context *)0) {
        return;
    }
    ctx->entered = YI4K_MIN_ENTERED;
    ctx->argument = arg;
    ctx->returned = YI4K_MIN_RETURNED;
}
