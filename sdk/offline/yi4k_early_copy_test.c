/* Test fixture only. Never install/link as a camera callback. */
#include "../yi4k_1107_early_copy.h"

#define CHECK(c) do { if (!(c)) return __LINE__; } while (0)
typedef struct early_fixture {
    yi4k_1107_early_copy adapter;
    yi4k_1107_early_chain chain;
    yi4k_1107_ring_view ring;
    yi4k_1107_owned_slot slots[3];
    uint8_t source[64], storage[3][64];
    yi4k_1107_video_event event;
    uint32_t calls, args_bad, mutate, reenter, depth, nested_status;
    uint32_t expected_handle, expected_event;
    const void *expected_argument;
} early_fixture;

uint32_t yi4k_early_test_report[16];

static void zero(void *pointer, size_t n)
{
    uint8_t *p = pointer;
    size_t i;
    for (i = 0; i < n; ++i) p[i] = 0;
}

static int32_t original(void *context, uint32_t handle, uint32_t event, const void *argument)
{
    early_fixture *f = context;
    uint32_t i;
    ++f->calls;
    if (handle != f->expected_handle || event != f->expected_event ||
        argument != f->expected_argument) ++f->args_bad;
    if (f->reenter && f->depth == 0) {
        yi4k_1107_early_result nested;
        f->depth = 1;
        nested = yi4k_1107_early_on_event(&f->chain, &f->adapter, handle, event, argument);
        f->nested_status = nested.capture_status;
        f->depth = 0;
    }
    if (f->mutate) {
        for (i = 0; i < 64; ++i) f->source[i] = 0xee;
        f->event.sequence = 9999;
    }
    return -77;
}

static int setup(early_fixture *f)
{
    uint32_t i;
    zero(f, sizeof(*f));
    for (i = 0; i < 64; ++i) f->source[i] = (uint8_t)i;
    for (i = 0; i < 3; ++i) {
        f->slots[i].payload = f->storage[i];
        f->slots[i].capacity = 64;
    }
    f->ring.bytes = f->source;
    f->ring.cpu_base = 0x20000000;
    f->ring.size = 64;
    f->chain.context = f;
    f->chain.original = original;
    f->event.sequence = 123;
    f->event.corrected_pts = UINT64_C(0x100001234);
    f->event.cpu_payload_address = f->ring.cpu_base + 8;
    f->event.type = 1;
    f->event.flags = 0x1122;
    f->event.payload_size = 16;
    f->expected_handle = 0x12345678;
    f->expected_event = YI4K_EARLY_VIDEO_EVENT;
    f->expected_argument = &f->event;
    return yi4k_1107_early_init(&f->adapter, &f->ring, f->slots, 3);
}

static yi4k_1107_early_result invoke(early_fixture *f)
{
    return yi4k_1107_early_on_event(&f->chain, &f->adapter,
        f->expected_handle, f->expected_event, f->expected_argument);
}

int yi4k_early_copy_test(uint32_t which)
{
    early_fixture f;
    yi4k_1107_early_result result = {0, YI4K_EARLY_PASSTHROUGH};
    const yi4k_1107_owned_slot *slot;
    uint32_t i, expected_calls = 1;
    CHECK(setup(&f) == 0);
    zero(yi4k_early_test_report, sizeof(yi4k_early_test_report));
    switch (which) {
    case 0: /* capture precedes mutation by original; owned bytes survive */
        f.mutate = 1;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPIED);
        slot = yi4k_1107_early_peek(&f.adapter);
        CHECK(slot && slot->event.sequence == 123 && f.event.sequence == 9999);
        CHECK(slot->event.flags == 0x1122 && slot->descriptor.flags == 1);
        CHECK(slot->descriptor.corrected_pts == UINT64_C(0x100001234));
        for (i = 0; i < 16; ++i) CHECK(slot->payload[i] == i + 8);
        break;
    case 1: /* exact two-span payload, metadata, and ownership */
        f.event.cpu_payload_address = f.ring.cpu_base + 57;
        result = invoke(&f);
        slot = yi4k_1107_early_peek(&f.adapter);
        CHECK(slot && slot->copied.first_span_bytes == 7 && slot->copied.second_span_bytes == 9);
        for (i = 0; i < 16; ++i) CHECK(slot->payload[i] == (57+i)%64);
        CHECK(slot != (void *)&f.event && slot->payload != f.source);
        break;
    case 2: /* full queue preserves borrowed head until explicit release */
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        f.event.sequence = 124;
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        slot = yi4k_1107_early_peek(&f.adapter);
        CHECK(slot && slot->event.sequence == 123);
        f.event.sequence = 125;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_FULL && f.adapter.dropped == 1);
        CHECK(slot == yi4k_1107_early_peek(&f.adapter) && slot->event.sequence == 123);
        expected_calls = 3;
        break;
    case 3: /* repeated publish/release crosses index wrap without stale reuse */
        for (i = 0; i < 17; ++i) {
            f.event.sequence = i;
            result = invoke(&f);
            slot = yi4k_1107_early_peek(&f.adapter);
            CHECK(slot && slot->event.sequence == i);
            CHECK(yi4k_1107_early_release(&f.adapter) == 1);
            CHECK(yi4k_1107_early_peek(&f.adapter) == NULL);
        }
        CHECK(yi4k_1107_early_release(&f.adapter) == 0);
        expected_calls = 17;
        break;
    case 4: case 5: /* EOS must not read invalid payload or change output bytes */
        f.event.payload_size = which == 4 ? 0xffffff : 0xffffffff;
        f.event.cpu_payload_address = 0;
        f.adapter.ring.bytes = NULL; /* EOS bypasses ring dereference */
        f.storage[0][0] = 0xa5;
        result = invoke(&f);
        slot = yi4k_1107_early_peek(&f.adapter);
        CHECK(result.capture_status == YI4K_EARLY_END && slot && slot->is_end);
        CHECK(slot->copied.copied_bytes == 0 && slot->payload[0] == 0xa5);
        break;
    case 6: /* EOS cannot overwrite a full queue */
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        f.event.payload_size = 0xffffff;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_FULL && f.adapter.ended == 0);
        expected_calls = 3;
        break;
    case 7:
        f.expected_event = 0x17;
        f.expected_argument = NULL;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_PASSTHROUGH);
        break;
    case 8: case 9:
        f.expected_argument = which == 8 ? NULL : (const uint8_t *)&f.event + 1;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_EVENT);
        break;
    case 10: case 11: case 12: case 13:
        if (which == 10) f.event.cpu_payload_address = f.ring.cpu_base - 1;
        if (which == 11) f.event.payload_size = 0;
        if (which == 12) f.event.payload_size = 65;
        if (which == 13) f.slots[0].capacity = 15;
        f.storage[0][0] = 0xa5;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPY_FAILED);
        CHECK(f.storage[0][0] == 0xa5 && yi4k_1107_early_peek(&f.adapter) == NULL);
        break;
    case 14: case 15:
        if (which == 14) f.event.type = 256;
        else f.event.stream = 3;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_EVENT);
        break;
    case 16:
        f.reenter = 1;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPIED);
        CHECK(f.nested_status == YI4K_EARLY_REENTRY && f.adapter.accepted == 1);
        CHECK(f.adapter.ingress_busy == 0 && f.adapter.dropped == 1);
        expected_calls = 2; /* one original per outer and nested invocation */
        break;
    case 17:
        result = yi4k_1107_early_on_event(&f.chain, NULL,
            f.expected_handle, f.expected_event, f.expected_argument);
        CHECK(result.capture_status == YI4K_EARLY_BAD_ADAPTER);
        break;
    case 18: /* failed capture leaves queue available for the next event */
        f.event.payload_size = 65;
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPY_FAILED);
        f.event.payload_size = 16;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPIED && f.adapter.failed == 1);
        expected_calls = 2;
        break;
    case 19:
        f.chain.original = NULL;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_CHAIN);
        expected_calls = 0;
        break;
    case 20: /* reject slot overlap and source alias at init, before publication */
        f.slots[1].payload = f.slots[0].payload;
        CHECK(yi4k_1107_early_init(&f.adapter, &f.ring, f.slots, 3) == -1);
        f.slots[1].payload = f.storage[1];
        f.slots[0].payload = f.source;
        CHECK(yi4k_1107_early_init(&f.adapter, &f.ring, f.slots, 3) == -1);
        f.slots[0].payload = f.storage[0];
        CHECK(yi4k_1107_early_init(&f.adapter, &f.ring, f.slots, 1) == -1);
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPIED);
        break;
    case 21: /* source bytes are owned after capture even before consumer peeks */
        result = invoke(&f);
        for (i = 0; i < 64; ++i) f.source[i] = 0xff;
        slot = yi4k_1107_early_peek(&f.adapter);
        CHECK(slot);
        for (i = 0; i < 16; ++i) CHECK(slot->payload[i] == i + 8);
        break;
    default:
        return -1;
    }
    CHECK(f.calls == expected_calls && f.args_bad == 0);
    if (which != 19) CHECK(result.original_status == -77);
    yi4k_early_test_report[0] = result.capture_status;
    yi4k_early_test_report[1] = (uint32_t)result.original_status;
    yi4k_early_test_report[2] = f.calls;
    yi4k_early_test_report[3] = f.adapter.accepted;
    yi4k_early_test_report[4] = f.adapter.ended;
    yi4k_early_test_report[5] = f.adapter.dropped;
    yi4k_early_test_report[6] = f.adapter.failed;
    yi4k_early_test_report[7] = f.adapter.last_copy_status;
    yi4k_early_test_report[8] = atomic_load(&f.adapter.head);
    yi4k_early_test_report[9] = atomic_load(&f.adapter.tail);
    yi4k_early_test_report[10] = f.adapter.ingress_busy;
    yi4k_early_test_report[11] = f.nested_status;
    return 0;
}
