#ifndef YI4K_1107_INTERNAL_H
#define YI4K_1107_INTERNAL_H

/* Static ABI notebook for the real-device 1.10.7 RTOS image.
 * It is not a loader or a tested SDK. Do not call these addresses from Linux,
 * or apply them to another firmware hash. */
#include <stdint.h>

#define YI4K_1107_RTOS_SHA256 \
    "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
#define YI4K_1107_ANALYSIS_BASE UINT32_C(0xA0100000)

typedef int (*yi4k_1107_shell_print_candidate_t)(const char *format, ...);
typedef int (*yi4k_1107_shell_handler_candidate_t)(
    int argc, char **argv, yi4k_1107_shell_print_candidate_t print);
typedef int (*yi4k_1107_t_register_candidate_t)(
    const char *name, yi4k_1107_shell_handler_candidate_t handler);

#define YI4K_1107_ADDR_T_REGISTER UINT32_C(0xA029E098)
#define YI4K_1107_ADDR_T_DISPATCH UINT32_C(0xA029E1A4)

typedef void (*yi4k_1107_task_entry_candidate_t)(uint32_t arg);
typedef uint32_t (*yi4k_1107_task_create_candidate_t)(
    void *task, const char *name, uint32_t priority,
    yi4k_1107_task_entry_candidate_t entry, uint32_t entry_arg,
    void *stack_base, uint32_t stack_bytes, uint32_t auto_start);

#define YI4K_1107_ADDR_TASK_CREATE UINT32_C(0xA03BC2BC)
#define YI4K_1107_ADDR_TASK_DELETE UINT32_C(0xA03BC30C)
#define YI4K_1107_ADDR_TASK_TERMINATE UINT32_C(0xA03BC310)
#define YI4K_1107_ADDR_TASK_WAIT_CONTROL UINT32_C(0xA03BC314)
#define YI4K_1107_ADDR_TASK_RESUME UINT32_C(0xA03BC31C)
#define YI4K_1107_ADDR_TASK_SUSPEND UINT32_C(0xA03BC318)
#define YI4K_1107_ADDR_TASK_SMP_CORE_EXCLUSION_SET UINT32_C(0xA03BC7D8)
#define YI4K_1107_ADDR_TASK_SMP_CORE_EXCLUSION_GET UINT32_C(0xA03BC7DC)
#define YI4K_1107_ADDR_TASK_ENTRY_TRAMPOLINE UINT32_C(0xA03C0A74)
#define YI4K_1107_OBSERVED_THREAD_CONTROL_BYTES UINT32_C(0xD8)
#define YI4K_1107_ADDR_DCACHE_CLEAN UINT32_C(0xA0498728)
#define YI4K_1107_ADDR_DCACHE_INVALIDATE UINT32_C(0xA049878C)
#define YI4K_1107_ADDR_DCACHE_FLUSH UINT32_C(0xA04987F0)

/* The following are static hook candidates, not safe patch targets. */
#define YI4K_1107_ADDR_TASK_TRAMPOLINE UINT32_C(0xA01E5BD4)
#define YI4K_1107_ADDR_TASK_DESCRIPTOR_SETTER UINT32_C(0xA01E5CE8)
#define YI4K_1107_DESCRIPTOR_ENC UINT32_C(0xA06D1810)
#define YI4K_1107_DESCRIPTOR_FIRMWARE_FORCE UINT32_C(0xA06CD13C)

#endif
