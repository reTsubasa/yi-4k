#include "../yi4k_1107_owned_retirement.h"
#include <stddef.h>

#define CHECK(x) do { if (!(x)) return __LINE__; } while (0)
typedef struct fixture {
    yi4k_1107_retirement guard;
    uint32_t resource, fail_step, calls[5], bad, reentry;
} fixture;
static fixture f;
uint32_t yi4k_retirement_test_report[16];
yi4k_1107_retirement_ticket yi4k_retirement_race_ticket;

static int32_t service(void *context, void *resource, uint32_t step)
{
    fixture *p = context;
    yi4k_1107_retirement_ticket late = {0};
    ++p->calls[step];
    if (resource != &p->resource || p->resource != 0x12345678 ||
        !(atomic_load(&p->guard.admission) & YI4K_RETIRE_CLOSED_BIT)) p->bad = 1;
    if (step > 0 && !(p->guard.proofs & YI4K_RETIRE_REVOKED)) p->bad = 1;
    if (step > 1 && !(p->guard.proofs & YI4K_RETIRE_STOP_REQUESTED)) p->bad = 1;
    if (step > 1 && (atomic_load(&p->guard.admission) & YI4K_RETIRE_COUNT_MASK)) p->bad = 1;
    if (step > 2 && !(p->guard.proofs & YI4K_RETIRE_STOPPED)) p->bad = 1;
    if (step > 3 && !(p->guard.proofs & YI4K_RETIRE_TASK_DELETED)) p->bad = 1;
    if (yi4k_1107_retirement_enter(&p->guard, &late) != YI4K_RETIRE_CLOSED) p->bad = 1;
    if (p->reentry && yi4k_1107_retirement_finish(&p->guard) != YI4K_RETIRE_CONTENDED) p->bad = 1;
    return p->fail_step == step + 1 ? 91 + (int32_t)step : 0;
}
static int32_t revoke(void *c, void *r) { return service(c, r, 0); }
static int32_t stop(void *c, void *r) { return service(c, r, 1); }
static int32_t stopped(void *c, void *r) { return service(c, r, 2); }
static int32_t delete_task(void *c, void *r) { return service(c, r, 3); }
static void release(void *c, void *r)
{
    fixture *p = c;
    if (service(c, r, 4)) p->bad = 1;
    p->resource = 0;
}

int yi4k_retirement_race_setup(void)
{
    yi4k_1107_retirement_ops ops = {&f, revoke, stop, stopped, delete_task, release};
    volatile unsigned char *clear = (volatile unsigned char *)&f;
    uint32_t i;
    for (i = 0; i < sizeof(f); ++i) clear[i] = 0;
    f.resource = 0x12345678;
    yi4k_retirement_race_ticket.guard = NULL;
    yi4k_retirement_race_ticket.resource = NULL;
    return yi4k_1107_retirement_init(&f.guard, &f.resource, &ops, 2);
}
int yi4k_retirement_race_enter(void)
{
    return yi4k_1107_retirement_enter(&f.guard, &yi4k_retirement_race_ticket);
}
int yi4k_retirement_race_close_finish(void)
{
    yi4k_1107_retirement_close(&f.guard);
    return yi4k_1107_retirement_finish(&f.guard);
}
int yi4k_retirement_race_leave_finish(void)
{
    CHECK(yi4k_1107_retirement_leave(&yi4k_retirement_race_ticket) == YI4K_RETIRE_OK);
    CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_DONE);
    CHECK(f.calls[4] == 1 && f.bad == 0 && f.resource == 0);
    return 0;
}

int yi4k_owned_retirement_test(uint32_t scenario)
{
    yi4k_1107_retirement_ticket a = {0}, b = {0}, c = {0};
    yi4k_1107_retirement_ops ops = {&f, revoke, stop, stopped, delete_task, release};
    volatile unsigned char *clear = (volatile unsigned char *)&f;
    uint32_t i, fail = 0;
    for (i = 0; i < sizeof(f); ++i) clear[i] = 0;
    for (i = 0; i < 16; ++i) yi4k_retirement_test_report[i] = 0;
    CHECK(scenario < 10);
    f.resource = 0x12345678;
    CHECK(yi4k_1107_retirement_init(&f.guard, &f.resource, &ops, 2) == 0);
    CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_BAD_STATE);
    if (scenario == 9) {
        ops.verify_stopped = NULL;
        CHECK(yi4k_1107_retirement_init(&f.guard, &f.resource, &ops, 2) == -1);
        ops.verify_stopped = stopped;
        CHECK(yi4k_1107_retirement_init(&f.guard, &f.resource, &ops, 0) == -1);
        CHECK(yi4k_1107_retirement_init(NULL, &f.resource, &ops, 2) == -1);
        CHECK(yi4k_1107_retirement_enter(NULL, &a) == YI4K_RETIRE_BAD_ARGUMENT);
        CHECK(yi4k_1107_retirement_leave(&a) == YI4K_RETIRE_BAD_ARGUMENT);
        CHECK(yi4k_1107_retirement_finish(NULL) == YI4K_RETIRE_BAD_ARGUMENT);
    }
    if (scenario == 5 || scenario == 6 || scenario == 8) {
        CHECK(yi4k_1107_retirement_enter(&f.guard, &a) == YI4K_RETIRE_OK);
        CHECK(a.resource == &f.resource);
        CHECK(yi4k_1107_retirement_enter(&f.guard, &a) == YI4K_RETIRE_BAD_ARGUMENT);
    }
    if (scenario == 6) {
        CHECK(yi4k_1107_retirement_enter(&f.guard, &b) == YI4K_RETIRE_OK);
        CHECK(yi4k_1107_retirement_enter(&f.guard, &c) == YI4K_RETIRE_LIMIT);
    }
    if (scenario == 7) f.reentry = 1;
    yi4k_1107_retirement_close(&f.guard);
    yi4k_1107_retirement_close(&f.guard);
    CHECK(yi4k_1107_retirement_enter(&f.guard, &c) == YI4K_RETIRE_CLOSED);
    if (scenario >= 1 && scenario <= 4) {
        fail = scenario;
        f.fail_step = fail;
        CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_SERVICE_FAILED);
        CHECK(f.guard.resource == &f.resource && f.resource == 0x12345678);
        CHECK(f.guard.proofs == ((1u << (fail - 1)) - 1));
        CHECK(f.calls[fail - 1] == 1 && f.calls[fail] == 0);
        CHECK(f.guard.last_service_status == 90 + (int32_t)fail);
        f.fail_step = 0;
    }
    if (scenario == 5 || scenario == 6 || scenario == 8) {
        CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_PENDING);
        CHECK(f.guard.proofs == 3 && f.calls[2] == 0 && f.calls[4] == 0);
        CHECK(f.guard.resource == &f.resource && f.resource == 0x12345678);
        CHECK(yi4k_1107_retirement_leave(&a) == YI4K_RETIRE_OK);
        CHECK(a.resource == NULL && a.guard == NULL);
        CHECK(yi4k_1107_retirement_leave(&a) == YI4K_RETIRE_BAD_ARGUMENT);
        if (scenario == 6) {
            CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_PENDING);
            CHECK(yi4k_1107_retirement_leave(&b) == YI4K_RETIRE_OK);
        }
        if (scenario == 8) {
            f.fail_step = 3;
            CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_SERVICE_FAILED);
            CHECK(f.guard.resource == &f.resource && f.calls[3] == 0 && f.calls[4] == 0);
            f.fail_step = 0;
            fail = 3;
        }
    }
    CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_DONE);
    CHECK(yi4k_1107_retirement_finish(&f.guard) == YI4K_RETIRE_DONE);
    CHECK(f.guard.resource == NULL && f.resource == 0 && f.guard.proofs == 31);
    CHECK(atomic_load(&f.guard.admission) == YI4K_RETIRE_CLOSED_BIT);
    CHECK(atomic_load(&f.guard.controller) == 0 && f.bad == 0);
    for (i = 0; i < 5; ++i) CHECK(f.calls[i] == 1u + (fail == i + 1));
    yi4k_retirement_test_report[0] = f.guard.proofs;
    yi4k_retirement_test_report[1] = atomic_load(&f.guard.admission);
    for (i = 0; i < 5; ++i) yi4k_retirement_test_report[i + 2] = f.calls[i];
    yi4k_retirement_test_report[7] = f.guard.resource == NULL;
    yi4k_retirement_test_report[8] = f.bad;
    return 0;
}
