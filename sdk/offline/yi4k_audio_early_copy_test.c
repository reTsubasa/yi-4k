/* Host/ARM fixture only. Never install as a camera callback. */
#include "../yi4k_1107_audio_early_copy.h"

#define CHECK(c) do { if (!(c)) return __LINE__; } while (0)
typedef struct audio_fixture {
    yi4k_1107_early_copy queue;
    yi4k_1107_audio_ingress ingress;
    yi4k_1107_audio_chain chain;
    yi4k_1107_owned_slot slots[3];
    yi4k_1107_ring_view ring;
    yi4k_1107_audio_event event;
    uint8_t source[64], storage[3][64];
    uint32_t calls, args_bad, mutate, recurse, depth, nested;
    const void *expected;
} audio_fixture;

uint32_t yi4k_audio_test_report[16];

static void zero(void *object, size_t size)
{
    uint8_t *p = object;
    size_t i;
    for (i = 0; i < size; ++i) p[i] = 0;
}

static int32_t original(void *context, const void *argument)
{
    audio_fixture *f = context;
    uint32_t i;
    ++f->calls;
    if (argument != f->expected) ++f->args_bad;
    if (f->recurse && f->depth == 0) {
        yi4k_1107_early_result result;
        f->depth = 1;
        result = yi4k_1107_audio_on_event(&f->chain, &f->ingress, argument);
        f->nested = result.capture_status;
        f->depth = 0;
    }
    if (f->mutate) {
        for (i = 0; i < 64; ++i) f->source[i] = 0xEE;
        f->event.synthetic_pts = 987654;
    }
    return -73;
}

static int setup(audio_fixture *f)
{
    uint32_t i;
    zero(f, sizeof(*f));
    f->chain.context = f;
    f->chain.original = original;
    f->ingress.owned = &f->queue;
    f->ingress.next_sequence = 123;
    f->ring = (yi4k_1107_ring_view){f->source, 0x22000000, 64};
    f->event.encoder_handle = 0x10005678;
    f->event.unwritten_04 = 0xBAD055AA;
    f->event.unwritten_1c = 0xBAD055AA;
    f->event.synthetic_pts = UINT64_C(0x100001234);
    f->event.payload_size = 16;
    f->event.cpu_payload_address = f->ring.cpu_base + 8;
    f->expected = &f->event;
    for (i = 0; i < 64; ++i) f->source[i] = (uint8_t)i;
    for (i = 0; i < 3; ++i) {
        f->slots[i].payload = f->storage[i];
        f->slots[i].capacity = 64;
    }
    return yi4k_1107_early_init(&f->queue, &f->ring, f->slots, 3);
}

static yi4k_1107_early_result invoke(audio_fixture *f)
{
    return yi4k_1107_audio_on_event(&f->chain, &f->ingress, f->expected);
}

int yi4k_audio_early_copy_test(uint32_t which)
{
    audio_fixture f;
    yi4k_1107_early_result result = {0, YI4K_EARLY_PASSTHROUGH};
    const yi4k_1107_owned_slot *slot;
    uint32_t expected_calls = 1, i;
    CHECK(setup(&f) == 0);
    zero(yi4k_audio_test_report, sizeof(yi4k_audio_test_report));
    switch (which) {
    case 0:
        f.mutate = 1;
        result = invoke(&f);
        slot = yi4k_1107_early_peek(&f.queue);
        CHECK(result.capture_status == YI4K_EARLY_COPIED && slot);
        CHECK(slot->source_kind == YI4K_EARLY_SOURCE_AUDIO && slot->event.channel == 0);
        CHECK(slot->audio_event.synthetic_pts == UINT64_C(0x100001234));
        CHECK(f.event.synthetic_pts == 987654);
        CHECK(slot->audio_event.encoder_handle == 0x10005678);
        CHECK(slot->audio_event.unwritten_04 == 0 && slot->audio_event.unwritten_1c == 0);
        CHECK(slot->descriptor.type == 8 && slot->descriptor.flags == 1);
        CHECK(slot->descriptor.sequence == 123 && f.ingress.next_sequence == 124);
        for (i = 0; i < 16; ++i) CHECK(slot->payload[i] == 8 + i);
        break;
    case 1:
        f.event.cpu_payload_address = f.ring.cpu_base + 57;
        result = invoke(&f);
        slot = yi4k_1107_early_peek(&f.queue);
        CHECK(slot && slot->copied.first_span_bytes == 7 && slot->copied.second_span_bytes == 9);
        for (i = 0; i < 16; ++i) CHECK(slot->payload[i] == (57 + i) % 64);
        break;
    case 2:
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        slot = yi4k_1107_early_peek(&f.queue);
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_FULL && slot->descriptor.sequence == 123);
        CHECK(f.ingress.next_sequence == 126);
        CHECK(yi4k_1107_early_release(&f.queue) == 1);
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        CHECK(yi4k_1107_early_release(&f.queue) == 1);
        CHECK(yi4k_1107_early_peek(&f.queue)->descriptor.sequence == 126);
        expected_calls = 4;
        break;
    case 3:
        f.event.eos = 1;
        f.event.cpu_payload_address = 0;
        f.event.payload_size = 0x98765432;
        f.queue.ring.bytes = NULL;
        f.storage[0][0] = 0xA5;
        result = invoke(&f);
        slot = yi4k_1107_early_peek(&f.queue);
        CHECK(result.capture_status == YI4K_EARLY_END && slot && slot->is_end);
        CHECK(slot->descriptor.type == 0xFF && slot->descriptor.payload_size == 0xFFFFFF);
        CHECK(slot->descriptor.corrected_pts == 0 && slot->descriptor.cpu_payload_address == 0);
        CHECK(slot->audio_event.synthetic_pts == UINT64_C(0x100001234));
        CHECK(slot->audio_event.payload_size == 0x98765432);
        CHECK(slot->payload[0] == 0xA5 && slot->copied.copied_bytes == 0);
        CHECK(f.ingress.next_sequence == 123);
        break;
    case 4: case 5: case 6: case 7:
        if (which == 4) f.event.eos = 2;
        if (which == 5) f.expected = NULL;
        if (which == 6) f.expected = (const uint8_t *)&f.event + 1;
        if (which == 7) f.event.encoder_handle = 0;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_EVENT && f.ingress.next_sequence == 123);
        break;
    case 8: case 9: case 10: case 11:
        if (which == 8) f.event.cpu_payload_address = f.ring.cpu_base - 1;
        if (which == 9) f.event.payload_size = 0;
        if (which == 10) f.event.payload_size = 65;
        if (which == 11) f.slots[0].capacity = 15;
        f.storage[0][0] = 0xA5;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPY_FAILED);
        CHECK(f.storage[0][0] == 0xA5 && f.ingress.next_sequence == 124);
        CHECK(yi4k_1107_early_peek(&f.queue) == NULL);
        break;
    case 12:
        result = yi4k_1107_audio_on_event(&f.chain, NULL, &f.event);
        CHECK(result.capture_status == YI4K_EARLY_BAD_ADAPTER);
        break;
    case 13:
        f.ingress.owned = NULL;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_ADAPTER);
        break;
    case 14:
        f.recurse = 1;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPIED && f.nested == YI4K_EARLY_REENTRY);
        CHECK(f.queue.accepted == 1 && f.queue.dropped == 1 && f.ingress.next_sequence == 124);
        expected_calls = 2;
        break;
    case 15:
        f.ingress.next_sequence = UINT32_MAX;
        result = invoke(&f);
        CHECK(yi4k_1107_early_peek(&f.queue)->descriptor.sequence == UINT32_MAX);
        CHECK(f.ingress.next_sequence == 0);
        CHECK(yi4k_1107_early_release(&f.queue) == 1);
        result = invoke(&f);
        CHECK(yi4k_1107_early_peek(&f.queue)->descriptor.sequence == 0);
        expected_calls = 2;
        break;
    case 16:
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPIED);
        f.event.eos = 1;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_FULL && f.queue.ended == 0);
        CHECK(f.ingress.next_sequence == 125);
        expected_calls = 3;
        break;
    case 17:
        result = invoke(&f);
        slot = yi4k_1107_early_peek(&f.queue);
        CHECK(slot && slot->payload != f.source);
        for (i = 0; i < 64; ++i) f.source[i] = 0;
        for (i = 0; i < 16; ++i) CHECK(slot->payload[i] == 8 + i);
        break;
    case 18:
        f.chain.original = NULL;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_CHAIN);
        expected_calls = 0;
        break;
    case 19: case 20:
        f.event.payload_size = which == 19 ? 0xFFFFFF : 0xFFFFFFFF;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_BAD_EVENT && f.queue.ended == 0);
        break;
    case 21:
        f.event.payload_size = 65;
        CHECK(invoke(&f).capture_status == YI4K_EARLY_COPY_FAILED);
        f.event.payload_size = 16;
        result = invoke(&f);
        CHECK(result.capture_status == YI4K_EARLY_COPIED && f.queue.failed == 1);
        CHECK(yi4k_1107_early_peek(&f.queue)->descriptor.sequence == 124);
        expected_calls = 2;
        break;
    default: return -1;
    }
    CHECK(f.calls == expected_calls && f.args_bad == 0 && f.queue.ingress_busy == 0);
    if (expected_calls) CHECK(result.original_status == -73);
    yi4k_audio_test_report[0] = result.capture_status;
    yi4k_audio_test_report[1] = (uint32_t)result.original_status;
    yi4k_audio_test_report[2] = f.calls;
    yi4k_audio_test_report[3] = f.queue.accepted;
    yi4k_audio_test_report[4] = f.queue.ended;
    yi4k_audio_test_report[5] = f.queue.dropped;
    yi4k_audio_test_report[6] = f.queue.failed;
    yi4k_audio_test_report[7] = f.queue.last_copy_status;
    yi4k_audio_test_report[8] = f.ingress.next_sequence;
    yi4k_audio_test_report[9] = atomic_load_explicit(&f.queue.head, memory_order_relaxed);
    yi4k_audio_test_report[10] = atomic_load_explicit(&f.queue.tail, memory_order_relaxed);
    yi4k_audio_test_report[11] = f.nested;
    return 0;
}
