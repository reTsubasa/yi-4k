#include "yi4k_1107_owned_retirement.h"
#include <stddef.h>

int32_t yi4k_1107_retirement_init(yi4k_1107_retirement *g, void *resource,
    const yi4k_1107_retirement_ops *ops, uint32_t limit)
{
    if (g == NULL || resource == NULL || ops == NULL || limit == 0 ||
        limit > YI4K_RETIRE_COUNT_MASK || ops->revoke_ingress == NULL ||
        ops->request_stop == NULL || ops->verify_stopped == NULL ||
        ops->delete_task == NULL || ops->release_owned == NULL)
        return -1;
    atomic_init(&g->admission, 0);
    atomic_init(&g->controller, 0);
    g->limit = limit;
    g->ops = *ops;
    g->resource = resource;
    g->proofs = 0;
    g->last_service_status = 0;
    return 0;
}

yi4k_1107_retirement_result yi4k_1107_retirement_enter(
    yi4k_1107_retirement *g, yi4k_1107_retirement_ticket *ticket)
{
    unsigned int value;
    if (g == NULL || ticket == NULL || ticket->guard != NULL)
        return YI4K_RETIRE_BAD_ARGUMENT;
    value = atomic_load_explicit(&g->admission, memory_order_relaxed);
    if (value & YI4K_RETIRE_CLOSED_BIT) return YI4K_RETIRE_CLOSED;
    if (value >= g->limit) return YI4K_RETIRE_LIMIT;
    if (!atomic_compare_exchange_strong_explicit(&g->admission, &value,
            value + 1, memory_order_acquire, memory_order_relaxed))
        return YI4K_RETIRE_CONTENDED;
    ticket->resource = g->resource;
    ticket->guard = g;
    return YI4K_RETIRE_OK;
}

yi4k_1107_retirement_result yi4k_1107_retirement_leave(
    yi4k_1107_retirement_ticket *ticket)
{
    yi4k_1107_retirement *g;
    if (ticket == NULL || ticket->guard == NULL)
        return YI4K_RETIRE_BAD_ARGUMENT;
    g = ticket->guard;
    ticket->guard = NULL;
    ticket->resource = NULL;
    atomic_fetch_sub_explicit(&g->admission, 1, memory_order_release);
    return YI4K_RETIRE_OK;
}

void yi4k_1107_retirement_close(yi4k_1107_retirement *g)
{
    if (g != NULL)
        atomic_fetch_or_explicit(&g->admission, YI4K_RETIRE_CLOSED_BIT,
                                 memory_order_acq_rel);
}

static int32_t prove(yi4k_1107_retirement *g, uint32_t bit,
                    int32_t (*service)(void *, void *))
{
    if (g->proofs & bit) return 0;
    g->last_service_status = service(g->ops.context, g->resource);
    if (g->last_service_status != 0) return -1;
    g->proofs |= bit;
    return 0;
}

yi4k_1107_retirement_result yi4k_1107_retirement_finish(yi4k_1107_retirement *g)
{
    unsigned int expected = 0;
    yi4k_1107_retirement_result result;
    if (g == NULL) return YI4K_RETIRE_BAD_ARGUMENT;
    if (!(atomic_load_explicit(&g->admission, memory_order_acquire) &
          YI4K_RETIRE_CLOSED_BIT))
        return YI4K_RETIRE_BAD_STATE;
    if (!atomic_compare_exchange_strong_explicit(&g->controller, &expected, 1,
            memory_order_acquire, memory_order_relaxed))
        return YI4K_RETIRE_CONTENDED;
    result = YI4K_RETIRE_SERVICE_FAILED;
    if (g->proofs & YI4K_RETIRE_RELEASED) {
        result = YI4K_RETIRE_DONE;
    } else if (prove(g, YI4K_RETIRE_REVOKED, g->ops.revoke_ingress) == 0 &&
               prove(g, YI4K_RETIRE_STOP_REQUESTED, g->ops.request_stop) == 0) {
        if (atomic_load_explicit(&g->admission, memory_order_acquire) &
            YI4K_RETIRE_COUNT_MASK) {
            result = YI4K_RETIRE_PENDING;
        } else if (prove(g, YI4K_RETIRE_STOPPED, g->ops.verify_stopped) == 0 &&
                   prove(g, YI4K_RETIRE_TASK_DELETED, g->ops.delete_task) == 0) {
            g->ops.release_owned(g->ops.context, g->resource);
            g->resource = NULL;
            g->proofs |= YI4K_RETIRE_RELEASED;
            result = YI4K_RETIRE_DONE;
        }
    }
    atomic_store_explicit(&g->controller, 0, memory_order_release);
    return result;
}
