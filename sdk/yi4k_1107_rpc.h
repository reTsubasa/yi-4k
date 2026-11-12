#ifndef YI4K_1107_RPC_H
#define YI4K_1107_RPC_H

/* Static ABI reconstruction for captured 1.10.7 only. No runtime validation.
 * These are RTOS addresses, not Linux entry points. Registration requires an
 * already executing RTOS caller, an initialized pool/IPC stack, resident code,
 * and an owned stack. This header does not provide a loader. */
#include "yi4k_1107_internal.h"

typedef struct yi4k_1107_rpc_reply_candidate {
    uint32_t response_bytes;
    void *response_buffer;
    uint32_t mode_raw;
    uint32_t status_raw;
} yi4k_1107_rpc_reply_candidate_t;

typedef void (*yi4k_1107_rpc_handler_candidate_t)(
    void *request, yi4k_1107_rpc_reply_candidate_t *reply);

/* Mode is preserved as raw evidence; do not infer timeout/async semantics
 * or response sizes from it without checking the specific service. */
typedef struct yi4k_1107_rpc_proc_candidate {
    yi4k_1107_rpc_handler_candidate_t handler;
    uint32_t mode_raw;
} yi4k_1107_rpc_proc_candidate_t;

typedef struct yi4k_1107_rpc_program_candidate {
    uint32_t procedure_count;
    const yi4k_1107_rpc_proc_candidate_t *procedures;
} yi4k_1107_rpc_program_candidate_t;

typedef uint32_t (*yi4k_1107_rpc_register_candidate_t)(
    uint32_t program, uint32_t version, const char *name, uint32_t priority,
    void *stack, uint32_t stack_bytes,
    const yi4k_1107_rpc_program_candidate_t *info, uint32_t dedicated_thread);
typedef uint32_t (*yi4k_1107_rpc_unregister_candidate_t)(
    uint32_t program, uint32_t version);

#define YI4K_1107_ADDR_RPC_REGISTER UINT32_C(0xA03CAAB4)
#define YI4K_1107_ADDR_RPC_UNREGISTER UINT32_C(0xA03CAC1C)
#define YI4K_1107_ADDR_RPC_REQUEST_CALLBACK UINT32_C(0xA03CA870)
#define YI4K_1107_ADDR_RPC_SERVICE_WORKER UINT32_C(0xA03CAE84)
#define YI4K_1107_ADDR_RPC_THREADPOOL_WORKER UINT32_C(0xA03CA6E8)
#define YI4K_1107_OBSERVED_RPC_PROCEDURE_STRIDE UINT32_C(8)

/* Procedure IDs are 1-based. The descriptor/table are copied by registration;
 * the name string, handler code and supplied dedicated-task stack must remain resident.
 * Stock registration can return zero after an unchecked TaskCreate failure.
 * Unregister does not prove it frees the externally supplied stack. */
#if UINTPTR_MAX == UINT32_MAX && !defined(__cplusplus)
_Static_assert(sizeof(yi4k_1107_rpc_reply_candidate_t) == 16, "RPC reply layout");
_Static_assert(sizeof(yi4k_1107_rpc_proc_candidate_t) == 8, "RPC procedure layout");
_Static_assert(sizeof(yi4k_1107_rpc_program_candidate_t) == 8, "RPC program layout");
#endif

#endif
