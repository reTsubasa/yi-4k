/* Host-only SPSC stress. Scheduling/yield loops belong to this test, not ingress. */
#include <pthread.h>
#include <sched.h>
#include "../yi4k_1107_early_copy.h"

typedef struct stress_fixture {
    yi4k_1107_early_copy adapter;
    yi4k_1107_owned_slot slots[8];
    uint8_t source[64], storage[8][32];
    yi4k_1107_early_chain chain;
    atomic_uint done;
    uint32_t target, calls, consumed, bad, attempts;
} stress_fixture;

uint32_t yi4k_early_thread_report[6];

static int32_t original(void *context, uint32_t handle, uint32_t event, const void *argument)
{
    stress_fixture *f = context;
    (void)handle;
    (void)event;
    (void)argument;
    ++f->calls;
    return -77;
}

static void *produce(void *context)
{
    stress_fixture *f = context;
    yi4k_1107_video_event event = {0};
    uint32_t i;
    event.cpu_payload_address = 0x20000000 + 57;
    event.type = 1;
    event.payload_size = 16;
    while (f->adapter.accepted < f->target && f->attempts < 1000000) {
        yi4k_1107_early_result result;
        event.sequence = ++f->attempts;
        for (i = 0; i < 16; ++i) f->source[(57+i)%64] = (uint8_t)(event.sequence+i);
        result = yi4k_1107_early_on_event(&f->chain, &f->adapter, 0, 0x1f, &event);
        if (result.original_status != -77 ||
            (result.capture_status != YI4K_EARLY_COPIED && result.capture_status != YI4K_EARLY_FULL)) {
            atomic_store_explicit(&f->done, 2, memory_order_release);
            return NULL;
        }
        if (result.capture_status == YI4K_EARLY_FULL) sched_yield();
    }
    atomic_store_explicit(&f->done, 1, memory_order_release);
    return NULL;
}

static void *consume(void *context)
{
    stress_fixture *f = context;
    uint32_t previous = 0, i;
    for (;;) {
        const yi4k_1107_owned_slot *slot = yi4k_1107_early_peek(&f->adapter);
        if (!slot) {
            if (atomic_load_explicit(&f->done, memory_order_acquire)) {
                /* Recheck after acquire: a final publication may precede done. */
                if (!yi4k_1107_early_peek(&f->adapter)) break;
            }
            sched_yield();
            continue;
        }
        if (slot->event.sequence <= previous || slot->copied.copied_bytes != 16) ++f->bad;
        for (i = 0; i < 16; ++i)
            if (slot->payload[i] != (uint8_t)(slot->event.sequence+i)) ++f->bad;
        previous = slot->event.sequence;
        ++f->consumed;
        if (yi4k_1107_early_release(&f->adapter) != 1) ++f->bad;
    }
    return NULL;
}

int yi4k_early_thread_stress(uint32_t target)
{
    stress_fixture f = {0};
    yi4k_1107_ring_view ring = {f.source, 0x20000000, 64};
    pthread_t producer, consumer;
    uint32_t i;
    if (target == 0 || target > 100000) return -1;
    for (i = 0; i < 8; ++i) {
        f.slots[i].payload = f.storage[i];
        f.slots[i].capacity = 32;
    }
    f.chain.context = &f;
    f.chain.original = original;
    f.target = target;
    atomic_init(&f.done, 0);
    if (yi4k_1107_early_init(&f.adapter, &ring, f.slots, 8)) return -2;
    if (pthread_create(&consumer, NULL, consume, &f)) return -3;
    if (pthread_create(&producer, NULL, produce, &f)) {
        atomic_store(&f.done, 2);
        pthread_join(consumer, NULL);
        return -4;
    }
    pthread_join(producer, NULL);
    pthread_join(consumer, NULL);
    yi4k_early_thread_report[0] = f.calls;
    yi4k_early_thread_report[1] = f.adapter.accepted;
    yi4k_early_thread_report[2] = f.adapter.dropped;
    yi4k_early_thread_report[3] = f.consumed;
    yi4k_early_thread_report[4] = f.bad;
    yi4k_early_thread_report[5] = f.attempts;
    return f.adapter.accepted == target && f.consumed == target && f.bad == 0 &&
        f.calls == f.attempts && f.calls == f.adapter.accepted+f.adapter.dropped &&
        atomic_load(&f.done) == 1 ? 0 : -5;
}
