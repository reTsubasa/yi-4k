#ifndef YI4K_1107_OWNED_RETIREMENT_H
#define YI4K_1107_OWNED_RETIREMENT_H

#include <stdint.h>
#include <stdatomic.h>

/* Offline lifecycle primitive, with no firmware addresses or device binding.
 * Guard/gateway code, storage, ops and context outlive every attempted entrant
 * and finish, including rejected late calls after owned allocation release.
 * resource is a distinct owned allocation; release_owned MUST NOT free guard,
 * ops or context. Init once before publication; no re-open or live re-init.
 * Every resource user must hold its own noncopyable ticket for its ENTIRE use,
 * including chained callbacks. A rejected entrant must not touch resource.
 * No other owner may restart/rebind/mutate the retired object. Successful
 * service proofs are irreversible for this one lifetime, including on retries.
 */
typedef struct yi4k_1107_retirement_ops {
    void *context;
    /* Zero proves external resource paths have been revoked: old/future
     * dispatches can only reach this retained closed gateway, never bypass it.
     * Includes dispatchers that fetched old pointers before revocation. It is
     * NOT a guard/code reclamation proof: rejected calls may still arrive.
     * May NOT free resource or disrupt currently admitted users. */
    int32_t (*revoke_ingress)(void *, void *);
    /* Zero is request acceptance only, never a stopped proof. */
    int32_t (*request_stop)(void *, void *);
    /* Zero must prove actual scheduler/task exit and no uncounted consumer.
     * An entry's own pre-return marker or stock unregister=0 is insufficient.
     * Never report success from the worker being retired. */
    int32_t (*verify_stopped)(void *, void *);
    /* Called only after stopped proof and inflight drain. Zero proves task
     * object deleted. Nonzero preserves allocation and must be safely retryable
     * or remain failed; do not bind a destructor that frees on error. */
    int32_t (*delete_task)(void *, void *);
    /* Release only the owned allocation, exactly once, after ALL proofs.
     * Does not unregister/stop/delete a task; those steps are already done.
     * Callback must return normally; C faults/nonreturn are outside contract. */
    void (*release_owned)(void *, void *);
} yi4k_1107_retirement_ops;

typedef struct yi4k_1107_retirement {
    atomic_uint admission; /* closed bit + inflight count in one RMW word */
    atomic_uint controller;
    uint32_t limit;
    yi4k_1107_retirement_ops ops;
    void *resource;
    uint32_t proofs; /* controller-owned; inspect only when controller idle */
    int32_t last_service_status;
} yi4k_1107_retirement;

typedef struct yi4k_1107_retirement_ticket {
    yi4k_1107_retirement *guard; /* Initialize to NULL; one thread owns ticket. */
    void *resource;
} yi4k_1107_retirement_ticket;

typedef enum yi4k_1107_retirement_result {
    YI4K_RETIRE_OK, YI4K_RETIRE_CLOSED, YI4K_RETIRE_CONTENDED,
    YI4K_RETIRE_LIMIT, YI4K_RETIRE_PENDING, YI4K_RETIRE_BAD_ARGUMENT,
    YI4K_RETIRE_BAD_STATE, YI4K_RETIRE_SERVICE_FAILED, YI4K_RETIRE_DONE
} yi4k_1107_retirement_result;

#define YI4K_RETIRE_CLOSED_BIT UINT32_C(0x80000000)
#define YI4K_RETIRE_COUNT_MASK UINT32_C(0x7fffffff)
#define YI4K_RETIRE_REVOKED UINT32_C(1)
#define YI4K_RETIRE_STOP_REQUESTED UINT32_C(2)
#define YI4K_RETIRE_STOPPED UINT32_C(4)
#define YI4K_RETIRE_TASK_DELETED UINT32_C(8)
#define YI4K_RETIRE_RELEASED UINT32_C(16)

int32_t yi4k_1107_retirement_init(yi4k_1107_retirement *, void *,
    const yi4k_1107_retirement_ops *, uint32_t max_inflight);
/* Single CAS admission attempt: contention may reject without waiting.
 * Retained gateway remains valid for late calls even after resource release. */
yi4k_1107_retirement_result yi4k_1107_retirement_enter(
    yi4k_1107_retirement *, yi4k_1107_retirement_ticket *);
yi4k_1107_retirement_result yi4k_1107_retirement_leave(
    yi4k_1107_retirement_ticket *);
/* Close is irreversible. It may race admitted users and other controllers. */
void yi4k_1107_retirement_close(yi4k_1107_retirement *);
/* Bounded work: one controller attempt, at most one call per missing service
 * phase, no allocation/wait/retry loop. Services MUST themselves be bounded.
 * PENDING or any failure retains resource; caller supplies later scheduling.
 * Lock-free C atomics do not provide a hardware wait-free latency guarantee.
 * This does not authorize binding the known-unsafe RPC unregister function.
 */
yi4k_1107_retirement_result yi4k_1107_retirement_finish(
    yi4k_1107_retirement *);

_Static_assert(ATOMIC_INT_LOCK_FREE == 2, "retirement needs lock-free atomics");
_Static_assert(sizeof(unsigned int) == 4, "retirement admission word width");
#endif
