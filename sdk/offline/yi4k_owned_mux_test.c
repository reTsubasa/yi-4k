/* Host/compiled-ARM fixture. Synthetic mappings, never a device installer. */
#include "../yi4k_1107_owned_mux.h"
#include "../yi4k_1107_audio_early_copy.h"

#define CHECK(x) do { if (!(x)) return __LINE__; } while (0)
typedef struct fixture {
    yi4k_1107_owned_mux mux;
    yi4k_1107_early_copy queue;
    yi4k_1107_owned_slot slots[3];
    yi4k_1107_ring_view source_ring;
    yi4k_1107_owned_arena arena;
    yi4k_1107_video_event video;
    yi4k_1107_audio_event audio;
    yi4k_1107_audio_ingress ingress;
    uint8_t source[128], owned[192];
    uint32_t mutate, calls;
} fixture;

uint32_t yi4k_owned_mux_test_report[16];

static void zero(void *p, size_t n)
{
    volatile uint8_t *b = p;
    size_t i;
    for (i = 0; i < n; ++i) b[i] = 0;
}

static int32_t original_video(void *context, uint32_t handle, uint32_t code, const void *arg)
{
    fixture *f = context;
    uint32_t i;
    (void)handle; (void)code; (void)arg;
    ++f->calls;
    if (f->mutate) for (i = 0; i < 128; ++i) f->source[i] = 0xEE;
    return -19;
}

static int32_t original_audio(void *context, const void *arg)
{
    return original_video(context, 0, 0, arg);
}

static int setup(fixture *f, uint32_t kind)
{
    uint32_t i;
    zero(f, sizeof(*f));
    f->source_ring = (yi4k_1107_ring_view){f->source, 0x22000000, 128};
    f->arena = (yi4k_1107_owned_arena){f->owned, 0x20000000, 192};
    for (i = 0; i < 128; ++i) f->source[i] = (uint8_t)i;
    for (i = 0; i < 3; ++i) {
        f->slots[i].payload = f->owned + 64*i;
        f->slots[i].capacity = 64;
    }
    f->video.sequence = 123;
    f->video.corrected_pts = UINT64_C(0x100002345);
    f->video.cpu_payload_address = f->source_ring.cpu_base + 8;
    f->video.payload_size = 16;
    f->video.type = 1;
    f->audio.encoder_handle = 0x1234;
    f->audio.synthetic_pts = UINT64_C(0x200003456);
    f->audio.cpu_payload_address = f->source_ring.cpu_base + 8;
    f->audio.payload_size = 16;
    f->ingress.owned = &f->queue;
    f->ingress.next_sequence = 456;
    if (yi4k_1107_early_init(&f->queue, &f->source_ring, f->slots, 3)) return -1;
    return yi4k_1107_owned_mux_init(&f->mux, &f->queue, &f->arena, kind);
}

static yi4k_1107_early_status offer(fixture *f, uint32_t kind)
{
    yi4k_1107_early_result r;
    if (kind == YI4K_EARLY_SOURCE_VIDEO) {
        yi4k_1107_early_chain chain = {f, original_video};
        r = yi4k_1107_early_on_event(&chain, &f->queue, 0x1234, 0x1F, &f->video);
    } else {
        yi4k_1107_audio_chain chain = {f, original_audio};
        r = yi4k_1107_audio_on_event(&chain, &f->ingress, &f->audio);
    }
    return r.original_status == -19 ? r.capture_status : YI4K_EARLY_BAD_CHAIN;
}

int yi4k_owned_mux_test(uint32_t which)
{
    fixture f;
    uint32_t i, kind = which == 1 || which == 11 ? 2 : 1;
    yi4k_1107_mux_status status = YI4K_MUX_EMPTY;
    const yi4k_1107_owned_slot *slot;
    CHECK(setup(&f, kind) == 0);
    zero(yi4k_owned_mux_test_report, sizeof(yi4k_owned_mux_test_report));
    switch (which) {
    case 0: case 1: /* Actual callback -> early copy -> relocation; source reused. */
        f.mutate = 1;
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        slot = yi4k_1107_early_peek(&f.queue);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_READY && f.mux.packet.payload == f.owned);
        CHECK(f.mux.packet.descriptor.cpu_payload_address == 0x20000000);
        CHECK(slot->descriptor.cpu_payload_address == 0x22000008);
        CHECK(f.mux.packet.descriptor.sequence == (kind == 1 ? 123 : 456));
        CHECK(f.mux.packet.descriptor.corrected_pts ==
            (kind == 1 ? UINT64_C(0x100002345) : UINT64_C(0x200003456)));
        CHECK(f.mux.packet.descriptor.reserved_04 == 0 &&
            f.mux.packet.descriptor.reserved_12 == 0 && f.mux.packet.descriptor.opaque_1c == 0);
        CHECK(f.mux.packet.ring_base == 0x20000000 && f.mux.packet.ring_end == 0x200000C0);
        CHECK(f.mux.packet.descriptor.type == (kind == 1 ? 1 : 8));
        for (i = 0; i < 16; ++i) CHECK(f.mux.packet.payload[i] == 8+i);
        CHECK(f.source[8] == 0xEE && f.calls == 1);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_READY);
        CHECK(f.mux.held == slot && atomic_load(&f.queue.head) == 0);
        break;
    case 2: /* Wrapping source becomes contiguous owned bytes. */
        f.video.cpu_payload_address = 0x22000079;
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_READY);
        for (i = 0; i < 16; ++i) CHECK(f.mux.packet.payload[i] == (121+i)%128);
        CHECK(f.slots[0].copied.first_span_bytes == 7 && f.slots[0].copied.second_span_bytes == 9);
        break;
    case 3: /* Exact arena end, nonzero slot offset, FIFO wrap. */
        for (i = 0; i < 2; ++i) {
            CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
            CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_READY);
            CHECK(yi4k_1107_owned_mux_finish(&f.mux, 0, 1) == YI4K_MUX_RELEASED);
        }
        f.video.payload_size = 64;
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_READY);
        CHECK(f.mux.packet.descriptor.cpu_payload_address == 0x20000080);
        CHECK(f.mux.packet.descriptor.cpu_payload_address + 64 == f.mux.packet.ring_end);
        CHECK(yi4k_1107_owned_mux_finish(&f.mux, 0, 1) == YI4K_MUX_RELEASED);
        CHECK(atomic_load(&f.queue.head) == 0 && yi4k_1107_early_peek(&f.queue) == NULL);
        break;
    case 4: /* Holding a packet must retain queue backpressure and bytes. */
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_READY);
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        f.source[8] = 0xAA;
        CHECK(offer(&f, kind) == YI4K_EARLY_FULL);
        CHECK(f.mux.packet.payload[0] == 8 && atomic_load(&f.queue.head) == 0);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_READY);
        break;
    case 5: /* Success releases exactly once and advances to the next owned slot. */
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_READY);
        CHECK(yi4k_1107_owned_mux_finish(&f.mux, 0, 1) == YI4K_MUX_RELEASED);
        CHECK(yi4k_1107_owned_mux_finish(&f.mux, 0, 1) == YI4K_MUX_NO_PENDING);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_READY && f.mux.packet.descriptor.cpu_payload_address == 0x20000040);
        CHECK(atomic_load(&f.queue.head) == 1);
        break;
    case 6: case 7: case 8: /* Partial/error, missing read completion, invalid receipt. */
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_READY);
        status = yi4k_1107_owned_mux_finish(&f.mux, which == 6 ? -1 : 0, which == 7 ? 0 : which == 8 ? 2 : 1);
        CHECK(status == YI4K_MUX_POISONED && atomic_load(&f.queue.head) == 0);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_POISONED);
        CHECK(yi4k_1107_owned_mux_finish(&f.mux, 0, 1) == YI4K_MUX_POISONED);
        CHECK(f.mux.packet.payload[0] == 8 && f.mux.held == &f.slots[0]);
        break;
    case 9:
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_EMPTY);
        status = yi4k_1107_owned_mux_finish(&f.mux, 0, 1);
        CHECK(status == YI4K_MUX_NO_PENDING && !f.mux.poisoned);
        break;
    case 10: case 11: /* Existing video raw EOS and normalized audio EOS. */
        if (kind == 1) {
            f.video.payload_size = UINT32_MAX;
            f.video.cpu_payload_address = UINT32_MAX;
        } else {
            f.audio.eos = 1;
            f.audio.cpu_payload_address = 0;
        }
        CHECK(offer(&f, kind) == YI4K_EARLY_END);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_END && f.mux.packet.is_end == 1);
        CHECK(f.mux.packet.descriptor.type == 0xFF && f.mux.packet.descriptor.payload_size == 0xFFFFFF);
        CHECK(f.mux.packet.payload == NULL && f.mux.packet.descriptor.cpu_payload_address == 0);
        CHECK(f.mux.packet.descriptor.corrected_pts == 0 && atomic_load(&f.queue.head) == 0);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_END);
        CHECK(yi4k_1107_owned_mux_finish(&f.mux, 0, 1) == YI4K_MUX_RELEASED);
        break;
    case 12: /* One stream per queue: audio cannot silently enter a video track. */
        CHECK(offer(&f, 2) == YI4K_EARLY_COPIED);
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_BAD_FRAME && f.mux.poisoned && atomic_load(&f.queue.head) == 0);
        break;
    case 13: case 14: case 15: case 16: case 17: /* Corrupted owned metadata cannot reach the writer. */
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        if (which == 13) f.slots[0].descriptor.payload_size = 65;
        if (which == 14) f.slots[0].copied.copied_bytes = 15;
        if (which == 15) f.slots[0].descriptor.type = 8;
        if (which == 16) f.slots[0].descriptor.flags = 0;
        if (which == 17) f.slots[0].is_end = 1;
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_BAD_FRAME && atomic_load(&f.queue.head) == 0);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_POISONED);
        break;
    case 18: /* Arena must cover complete allocations, not just current short payload. */
        f.arena.size = 191;
        CHECK(yi4k_1107_owned_mux_init(&f.mux, &f.queue, &f.arena, kind) == -1);
        CHECK(f.mux.arena.size == 192); /* failed init is atomic */
        break;
    case 19: /* End-exclusive CPU bounds may not overflow u32. */
        f.arena.cpu_base = UINT32_MAX - 100;
        CHECK(yi4k_1107_owned_mux_init(&f.mux, &f.queue, &f.arena, kind) == -1);
        CHECK(f.mux.arena.cpu_base == 0x20000000);
        break;
    case 20: /* Distinct host buffers cannot claim aliasing source CPU ranges. */
        f.arena.cpu_base = 0x22000010;
        CHECK(yi4k_1107_owned_mux_init(&f.mux, &f.queue, &f.arena, kind) == -1);
        break;
    case 21: /* No numeric enclosing arena can legitimize overlapping slots. */
        f.slots[1].payload = f.slots[0].payload + 32;
        CHECK(yi4k_1107_owned_mux_init(&f.mux, &f.queue, &f.arena, kind) == -1);
        break;
    case 22: /* Violation of exclusive consumer ownership is detected at finish. */
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        CHECK(offer(&f, kind) == YI4K_EARLY_COPIED);
        CHECK(yi4k_1107_owned_mux_prepare(&f.mux) == YI4K_MUX_READY);
        CHECK(yi4k_1107_early_release(&f.queue) == 1); /* deliberate forbidden action */
        status = yi4k_1107_owned_mux_finish(&f.mux, 0, 1);
        CHECK(status == YI4K_MUX_POISONED && atomic_load(&f.queue.head) == 1);
        break;
    case 23:
        CHECK(yi4k_1107_owned_mux_init(NULL, &f.queue, &f.arena, kind) == -1);
        CHECK(yi4k_1107_owned_mux_prepare(NULL) == YI4K_MUX_BAD_ARGUMENT);
        CHECK(yi4k_1107_owned_mux_finish(NULL, 0, 1) == YI4K_MUX_BAD_ARGUMENT);
        break;
    case 24: case 25: case 26:
        f.video.payload_size = UINT32_MAX;
        CHECK(offer(&f, kind) == YI4K_EARLY_END);
        if (which == 24) f.slots[0].descriptor.type = 2;
        if (which == 25) f.slots[0].descriptor.flags = 0;
        if (which == 26) f.slots[0].copied.first_span_bytes = 1;
        status = yi4k_1107_owned_mux_prepare(&f.mux);
        CHECK(status == YI4K_MUX_BAD_FRAME && atomic_load(&f.queue.head) == 0);
        break;
    default: return -1;
    }
    yi4k_owned_mux_test_report[0] = status;
    yi4k_owned_mux_test_report[1] = atomic_load(&f.queue.head);
    yi4k_owned_mux_test_report[2] = atomic_load(&f.queue.tail);
    yi4k_owned_mux_test_report[3] = f.mux.poisoned;
    yi4k_owned_mux_test_report[4] = f.mux.packet.descriptor.cpu_payload_address;
    yi4k_owned_mux_test_report[5] = f.mux.packet.descriptor.payload_size;
    yi4k_owned_mux_test_report[6] = f.mux.packet.ring_base;
    yi4k_owned_mux_test_report[7] = f.mux.packet.ring_end;
    yi4k_owned_mux_test_report[8] = (uint32_t)f.mux.last_writer_status;
    yi4k_owned_mux_test_report[9] = f.queue.accepted;
    yi4k_owned_mux_test_report[10] = f.queue.dropped;
    yi4k_owned_mux_test_report[11] = f.calls;
    return 0;
}

/* These globals support the offline validator's compiled-C -> original ARM
 * integration. The addresses are synthetic emulator RAM, not camera addresses.
 * Only seed/complete are called under ARM Unicorn, never in host tests. */
yi4k_1107_owned_mux yi4k_mux_bridge_consumer;
yi4k_1107_early_copy yi4k_mux_bridge_queue;
yi4k_1107_owned_slot yi4k_mux_bridge_slots[2];
uint32_t yi4k_mux_bridge_result[8];

int yi4k_owned_mux_bridge_seed(uint32_t kind, uint32_t bytes, uint32_t offset)
{
    yi4k_1107_owned_arena arena = {(uint8_t *)0x20000000, 0x20000000, 0x100000};
    yi4k_1107_ring_view source = {(const uint8_t *)0x20200000, 0x20200000, 0x100000};
    yi4k_1107_frame_desc descriptor;
    yi4k_1107_video_event video;
    yi4k_1107_audio_event audio;
    yi4k_1107_mux_status status;
    uint32_t i;
    zero(&descriptor, sizeof(descriptor));
    zero(&video, sizeof(video));
    zero(&audio, sizeof(audio));
    zero(yi4k_mux_bridge_slots, sizeof(yi4k_mux_bridge_slots));
    for (i = 0; i < 2; ++i) {
        yi4k_mux_bridge_slots[i].payload = arena.bytes + 128 + i*0x80000;
        yi4k_mux_bridge_slots[i].capacity = 0x80000 - 128;
    }
    if (yi4k_1107_early_init(&yi4k_mux_bridge_queue, &source, yi4k_mux_bridge_slots, 2)) return -1;
    if (yi4k_1107_owned_mux_init(&yi4k_mux_bridge_consumer, &yi4k_mux_bridge_queue, &arena, kind)) return -2;
    descriptor.sequence = 123;
    descriptor.corrected_pts = UINT64_C(0x123456789);
    descriptor.type = kind == 1 ? 1 : 8;
    descriptor.flags = 1;
    descriptor.cpu_payload_address = source.cpu_base + offset;
    descriptor.payload_size = bytes;
    if (yi4k_1107_early_offer_frame(&yi4k_mux_bridge_queue, &descriptor, kind,
        kind == 1 ? (const void *)&video : (const void *)&audio) != YI4K_EARLY_COPIED) return -3;
    status = yi4k_1107_owned_mux_prepare(&yi4k_mux_bridge_consumer);
    yi4k_mux_bridge_result[0] = (uint32_t)(uintptr_t)&yi4k_mux_bridge_consumer.packet.descriptor;
    yi4k_mux_bridge_result[1] = yi4k_mux_bridge_consumer.packet.ring_base;
    yi4k_mux_bridge_result[2] = yi4k_mux_bridge_consumer.packet.ring_end;
    yi4k_mux_bridge_result[3] = yi4k_mux_bridge_slots[0].descriptor.cpu_payload_address;
    yi4k_mux_bridge_result[4] = atomic_load(&yi4k_mux_bridge_queue.head);
    yi4k_mux_bridge_result[5] = atomic_load(&yi4k_mux_bridge_queue.tail);
    return status;
}

int yi4k_owned_mux_bridge_complete(int32_t writer_status, uint32_t use_complete)
{
    yi4k_1107_mux_status status = yi4k_1107_owned_mux_finish(
        &yi4k_mux_bridge_consumer, writer_status, use_complete);
    yi4k_mux_bridge_result[4] = atomic_load(&yi4k_mux_bridge_queue.head);
    yi4k_mux_bridge_result[5] = atomic_load(&yi4k_mux_bridge_queue.tail);
    yi4k_mux_bridge_result[6] = yi4k_mux_bridge_consumer.poisoned;
    return status;
}
