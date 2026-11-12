/* Host scheduling stress only. Wait/yield loops are not in the SDK helper. */
#include <pthread.h>
#include <sched.h>
#include "../yi4k_1107_owned_retirement.h"

typedef struct stress {
    yi4k_1107_retirement guard;
    atomic_uint ready, go, joined, verifier_entered, verifier_go, bad;
    atomic_uint admitted, rejected, released;
    uint32_t resource;
    uint32_t calls[4];
    yi4k_1107_retirement_result result;
} stress;

uint32_t yi4k_retirement_thread_report[8];

static int32_t revoke(void *context, void *resource)
{
    stress *f = context;
    ++f->calls[0];
    if (resource != &f->resource) atomic_fetch_add(&f->bad, 1);
    /* Fixture owns all invocation sources and issues no further resource use
     * after closed rejection. Guard remains alive through all pthread joins. */
    return 0;
}
static int32_t request(void *context, void *resource)
{
    stress *f = context;
    ++f->calls[1];
    if (resource != &f->resource) atomic_fetch_add(&f->bad, 1);
    return 0;
}
static int32_t stopped(void *context, void *resource)
{
    stress *f = context;
    ++f->calls[2];
    if (resource != &f->resource) atomic_fetch_add(&f->bad, 1);
    atomic_store(&f->verifier_entered, 1);
    while (!atomic_load(&f->verifier_go)) sched_yield();
    /* The real proof in this fixture is completion of pthread_join, rather
     * than an in-worker marker pretending the worker has already returned. */
    return atomic_load(&f->joined) == 6 ? 0 : -1;
}
static int32_t delete_task(void *context, void *resource)
{
    stress *f = context;
    ++f->calls[3];
    if (resource != &f->resource || atomic_load(&f->joined) != 6)
        atomic_fetch_add(&f->bad, 1);
    return 0;
}
static void release(void *context, void *resource)
{
    stress *f = context;
    if (resource != &f->resource || atomic_load(&f->joined) != 6 ||
        (atomic_load(&f->guard.admission) & YI4K_RETIRE_COUNT_MASK) ||
        f->guard.proofs != 15 || f->resource != 0x87654321)
        atomic_fetch_add(&f->bad, 1);
    f->resource = 0;
    atomic_fetch_add(&f->released, 1);
}

static void *user(void *context)
{
    stress *f = context;
    yi4k_1107_retirement_ticket ticket = {0};
    yi4k_1107_retirement_result r;
    uint32_t i;
    do {
        r = yi4k_1107_retirement_enter(&f->guard, &ticket);
        if (r == YI4K_RETIRE_CONTENDED) sched_yield();
    } while (r == YI4K_RETIRE_CONTENDED);
    if (r != YI4K_RETIRE_OK) {
        atomic_fetch_add(&f->bad, 1);
        return NULL;
    }
    atomic_fetch_add(&f->admitted, 1);
    atomic_fetch_add(&f->ready, 1);
    while (!atomic_load(&f->go)) sched_yield();
    if (ticket.resource != &f->resource || f->resource != 0x87654321 ||
        atomic_load(&f->released)) atomic_fetch_add(&f->bad, 1);
    if (yi4k_1107_retirement_leave(&ticket) != YI4K_RETIRE_OK)
        atomic_fetch_add(&f->bad, 1);
    for (i = 0; i < 2000; ++i) {
        if (yi4k_1107_retirement_enter(&f->guard, &ticket) != YI4K_RETIRE_CLOSED)
            atomic_fetch_add(&f->bad, 1);
        else atomic_fetch_add(&f->rejected, 1);
    }
    return NULL;
}
static void *finish(void *context)
{
    stress *f = context;
    f->result = yi4k_1107_retirement_finish(&f->guard);
    return NULL;
}

int yi4k_owned_retirement_thread_test(void)
{
    stress f = {0};
    yi4k_1107_retirement_ops ops = {&f, revoke, request, stopped, delete_task, release};
    pthread_t users[6], controller;
    uint32_t i, created = 0;
    int result = 0;
    f.resource = 0x87654321;
    if (yi4k_1107_retirement_init(&f.guard, &f.resource, &ops, 6)) return -1;
    for (i = 0; i < 6; ++i) {
        if (pthread_create(&users[i], NULL, user, &f)) {
            yi4k_1107_retirement_close(&f.guard);
            atomic_store(&f.go, 1);
            while (created) pthread_join(users[--created], NULL);
            return -2;
        }
        ++created;
    }
    while (atomic_load(&f.ready) != 6) sched_yield();
    yi4k_1107_retirement_close(&f.guard);
    if (yi4k_1107_retirement_finish(&f.guard) != YI4K_RETIRE_PENDING ||
        atomic_load(&f.released) || f.calls[2]) result = -3;
    atomic_store(&f.go, 1);
    for (i = 0; i < 6; ++i) {
        pthread_join(users[i], NULL);
        atomic_fetch_add(&f.joined, 1);
    }
    if (result) return result;
    if (pthread_create(&controller, NULL, finish, &f)) return -4;
    while (!atomic_load(&f.verifier_entered)) sched_yield();
    if (yi4k_1107_retirement_finish(&f.guard) != YI4K_RETIRE_CONTENDED ||
        atomic_load(&f.released)) result = -5;
    atomic_store(&f.verifier_go, 1);
    pthread_join(controller, NULL);
    if (result) return result;
    if (f.result != YI4K_RETIRE_DONE ||
        yi4k_1107_retirement_finish(&f.guard) != YI4K_RETIRE_DONE ||
        atomic_load(&f.bad) || atomic_load(&f.released) != 1 ||
        atomic_load(&f.admitted) != 6 || atomic_load(&f.rejected) != 12000)
        return -6;
    for (i = 0; i < 4; ++i) if (f.calls[i] != 1) return -7;
    yi4k_retirement_thread_report[0] = atomic_load(&f.admitted);
    yi4k_retirement_thread_report[1] = atomic_load(&f.rejected);
    yi4k_retirement_thread_report[2] = atomic_load(&f.released);
    yi4k_retirement_thread_report[3] = atomic_load(&f.bad);
    for (i = 0; i < 4; ++i) yi4k_retirement_thread_report[i + 4] = f.calls[i];
    return 0;
}
