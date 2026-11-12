/* Test-only injected services. Never link this file into a camera payload. */
#include "../yi4k_1107_fifo_consumer.h"

#define CHECK(condition) do { if (!(condition)) return __LINE__; } while (0)

typedef struct fixture {
    yi4k_1107_consumer consumer;
    yi4k_1107_frame_desc descriptor;
    uint8_t ring_bytes[64];
    uint8_t destination[64];
    uint32_t calls[9];
    uint32_t order[32];
    uint32_t order_count;
    int32_t create_status, peek_status, begin_status, persist_status;
    int32_t remove_status, quiesce_status, delete_status;
    uint32_t null_handle, null_peek, reenter, reentry_count, advanced;
    uint32_t config_bad, payload_bad;
} fixture;

uint32_t yi4k_fifo_test_report[16];

static void zero_bytes(void *p, size_t n)
{
    uint8_t *b = (uint8_t *)p;
    size_t i;
    for (i = 0; i < n; ++i) b[i] = 0;
}

static void called(fixture *f, uint32_t operation)
{
    ++f->calls[operation];
    if (f->order_count < 32) f->order[f->order_count++] = operation;
}

static int32_t create_fifo(void *context, yi4k_1107_fifo_config *config, void **handle)
{
    fixture *f = (fixture *)context;
    uint8_t *bytes = (uint8_t *)config;
    size_t i;
    called(f, 1);
    if (config->stream_id != 0x1234 || config->descriptor_capacity != 8192 ||
        config->is_virtual != 1 || config->callback_address != 0x100)
        f->config_bad = 1;
    for (i = 16; i < sizeof(*config); ++i)
        if (bytes[i] != 0) f->config_bad = 1;
    if (f->reenter && yi4k_1107_consumer_close(&f->consumer) == YI4K_CONSUMER_BUSY)
        ++f->reentry_count;
    *handle = f->null_handle ? NULL : (void *)&f->descriptor;
    return f->create_status;
}

static int32_t begin_read(void *context, void *handle)
{
    fixture *f = (fixture *)context;
    (void)handle;
    called(f, 2);
    return f->begin_status;
}

static int32_t peek_fifo(void *context, void *handle,
    const yi4k_1107_frame_desc **descriptor, uint32_t index)
{
    fixture *f = (fixture *)context;
    (void)handle;
    called(f, 3);
    if (index != 0) f->payload_bad = 1;
    *descriptor = f->null_peek ? NULL : &f->descriptor;
    return f->peek_status;
}

static int32_t persist(void *context, const yi4k_1107_frame_desc *descriptor,
    const uint8_t *bytes, uint32_t length)
{
    fixture *f = (fixture *)context;
    uint32_t i;
    called(f, 4);
    if (descriptor == &f->descriptor || descriptor->sequence != 123 ||
        bytes != f->destination || length != 16)
        f->payload_bad = 1;
    for (i = 0; i < length; ++i)
        if (bytes[i] != f->ring_bytes[(57+i)%64]) f->payload_bad = 1;
    if (f->reenter) {
        if (yi4k_1107_consumer_step(&f->consumer) == YI4K_CONSUMER_BUSY) ++f->reentry_count;
        if (yi4k_1107_consumer_stop(&f->consumer) == YI4K_CONSUMER_BUSY) ++f->reentry_count;
        if (yi4k_1107_consumer_close(&f->consumer) == YI4K_CONSUMER_BUSY) ++f->reentry_count;
    }
    return f->persist_status;
}

static int32_t remove_fifo(void *context, void *handle, uint32_t count)
{
    fixture *f = (fixture *)context;
    (void)handle;
    called(f, 5);
    if (count != 1) f->payload_bad = 1;
    ++f->advanced; /* Model the proved advance-before-message-failure case. */
    return f->remove_status;
}

static void end_read(void *context, void *handle)
{
    fixture *f = (fixture *)context;
    (void)handle;
    called(f, 6);
}

static int32_t quiesce(void *context, void *handle)
{
    fixture *f = (fixture *)context;
    (void)handle;
    called(f, 7);
    return f->quiesce_status;
}

static int32_t delete_fifo(void *context, void *handle)
{
    fixture *f = (fixture *)context;
    (void)handle;
    called(f, 8);
    if (!f->calls[7] || f->quiesce_status) f->payload_bad = 1;
    return f->delete_status;
}

int yi4k_fifo_consumer_test(uint32_t scenario)
{
    fixture f;
    yi4k_1107_ring_view ring;
    yi4k_1107_consumer_ops ops;
    yi4k_1107_consumer_result result;
    uint32_t i;
    zero_bytes(&f, sizeof(f));
    zero_bytes(yi4k_fifo_test_report, sizeof(yi4k_fifo_test_report));
    for (i = 0; i < 64; ++i) {
        f.ring_bytes[i] = (uint8_t)(i*37+11);
        f.destination[i] = 0xa5;
    }
    f.descriptor.sequence = 123;
    f.descriptor.corrected_pts = 1001;
    f.descriptor.type = 1;
    f.descriptor.cpu_payload_address = 0x20000039;
    f.descriptor.payload_size = 16;
    ring.bytes = f.ring_bytes;
    ring.cpu_base = 0x20000000;
    ring.size = 64;
    ops.context = &f;
    ops.create = create_fifo;
    ops.peek = peek_fifo;
    ops.remove = remove_fifo;
    ops.delete_fifo = delete_fifo;
    ops.begin_read = begin_read;
    ops.end_read = end_read;
    ops.persist = persist;
    ops.quiesce = quiesce;
    if (scenario == 19) {
        ops.quiesce = NULL;
        CHECK(yi4k_1107_consumer_init(&f.consumer, &ops, &ring, f.destination, 64) == YI4K_CONSUMER_BAD_ARGUMENT);
        return 0;
    }
    CHECK(yi4k_1107_consumer_init(&f.consumer, &ops, &ring, f.destination,
        scenario == 9 ? 2 : 64) == YI4K_CONSUMER_OK);
    CHECK(yi4k_1107_consumer_step(&f.consumer) == YI4K_CONSUMER_BAD_STATE);
    if (scenario == 18) {
        CHECK(yi4k_1107_consumer_start(&f.consumer, 0x1234, 0, 0x100) == YI4K_CONSUMER_BAD_ARGUMENT);
        CHECK(yi4k_1107_consumer_start(&f.consumer, 0x1234, 0x8000000, 0x100) == YI4K_CONSUMER_BAD_ARGUMENT);
        CHECK(yi4k_1107_consumer_start(&f.consumer, 0x1234, 8192, 0) == YI4K_CONSUMER_BAD_ARGUMENT);
        CHECK(f.calls[1] == 0);
        return 0;
    }
    if (scenario == 1 || scenario == 2) f.create_status = -1;
    if (scenario == 2 || scenario == 3) f.null_handle = 1;
    if (scenario == 17) f.reenter = 1;
    result = yi4k_1107_consumer_start(&f.consumer, 0x1234, 8192, 0x100);
    CHECK(f.config_bad == 0);
    if (scenario >= 1 && scenario <= 3) {
        CHECK(result == YI4K_CONSUMER_BACKEND_ERROR);
        CHECK(f.consumer.state == YI4K_CONSUMER_CREATE_UNCERTAIN);
        CHECK(yi4k_1107_consumer_start(&f.consumer, 0x1234, 8192, 0x100) == YI4K_CONSUMER_BAD_STATE);
        CHECK(yi4k_1107_consumer_close(&f.consumer) == YI4K_CONSUMER_BAD_STATE);
        CHECK(f.calls[1] == 1 && f.calls[8] == 0);
        goto report;
    }
    CHECK(result == YI4K_CONSUMER_OK);
    CHECK(yi4k_1107_consumer_close(&f.consumer) == YI4K_CONSUMER_BAD_STATE);
    if (scenario == 4) f.begin_status = 21;
    if (scenario == 5) f.peek_status = -8;
    if (scenario == 6) f.peek_status = -9;
    if (scenario == 7) f.null_peek = 1;
    if (scenario == 16) f.peek_status = -1;
    if (scenario == 8) f.persist_status = 37;
    if (scenario == 10) f.descriptor.cpu_payload_address = 0x1fffffff;
    if (scenario == 11) f.remove_status = 71;
    if (scenario == 12) f.descriptor.payload_size = 0xffffff;
    if (scenario == 13) f.descriptor.payload_size = 0xffffffff;
    result = yi4k_1107_consumer_step(&f.consumer);
    if (scenario == 4) {
        CHECK(result == YI4K_CONSUMER_RETRY && f.calls[3] == 0 && f.calls[6] == 0);
    } else if (scenario == 5) {
        CHECK(result == YI4K_CONSUMER_EMPTY && f.calls[4] == 0 && f.calls[5] == 0 && f.calls[6] == 1);
    } else if (scenario == 6 || scenario == 7 || scenario == 16) {
        CHECK(result == YI4K_CONSUMER_BACKEND_ERROR && f.consumer.state == YI4K_CONSUMER_PEEK_FAILED);
        CHECK(f.calls[4] == 0 && f.calls[5] == 0 && f.calls[6] == 1);
    } else if (scenario == 8 || scenario == 9 || scenario == 10) {
        CHECK(result == YI4K_CONSUMER_RETRY && f.calls[5] == 0 && f.calls[6] == 1);
        CHECK(f.consumer.state == YI4K_CONSUMER_RUNNING);
        if (scenario == 8) {
            f.persist_status = 0;
            CHECK(yi4k_1107_consumer_step(&f.consumer) == YI4K_CONSUMER_OK);
            CHECK(f.consumer.frames_persisted == 1 && f.calls[4] == 2 && f.calls[5] == 1);
        }
    } else if (scenario == 11) {
        CHECK(result == YI4K_CONSUMER_BACKEND_ERROR && f.consumer.state == YI4K_CONSUMER_CURSOR_UNCERTAIN);
        CHECK(yi4k_1107_consumer_step(&f.consumer) == YI4K_CONSUMER_BAD_STATE);
        CHECK(f.advanced == 1 && f.calls[4] == 1 && f.calls[5] == 1);
    } else if (scenario == 12 || scenario == 13) {
        CHECK(result == YI4K_CONSUMER_END && f.consumer.state == YI4K_CONSUMER_STOPPED);
        CHECK(f.calls[4] == 0 && f.calls[5] == 0 && f.calls[6] == 1);
        for (i = 0; i < 64; ++i) CHECK(f.destination[i] == 0xa5);
    } else {
        CHECK(result == YI4K_CONSUMER_OK && f.calls[4] == 1 && f.calls[5] == 1);
        CHECK(f.consumer.frames_persisted == 1 && f.calls[6] == 1);
        CHECK(f.order_count == 6 && f.order[0] == 1 && f.order[1] == 2 &&
              f.order[2] == 3 && f.order[3] == 4 && f.order[4] == 5 && f.order[5] == 6);
    }
    if (scenario == 17) CHECK(f.reentry_count == 4);
    if (f.consumer.state == YI4K_CONSUMER_RUNNING)
        CHECK(yi4k_1107_consumer_stop(&f.consumer) == YI4K_CONSUMER_OK);
    if (scenario == 14) f.quiesce_status = 48;
    if (scenario == 15) f.delete_status = -1;
    result = yi4k_1107_consumer_close(&f.consumer);
    if (scenario == 14) {
        CHECK(result == YI4K_CONSUMER_RETRY && f.calls[8] == 0 && f.consumer.handle != NULL);
        f.quiesce_status = 0;
        CHECK(yi4k_1107_consumer_close(&f.consumer) == YI4K_CONSUMER_OK);
    } else if (scenario == 15) {
        CHECK(result == YI4K_CONSUMER_BACKEND_ERROR && f.consumer.state == YI4K_CONSUMER_DELETE_FAILED);
        CHECK(f.consumer.handle != NULL && yi4k_1107_consumer_close(&f.consumer) == YI4K_CONSUMER_BAD_STATE);
        CHECK(f.calls[8] == 1);
        goto report;
    } else CHECK(result == YI4K_CONSUMER_OK);
    CHECK(f.consumer.state == YI4K_CONSUMER_CLOSED && f.consumer.handle == NULL);
    CHECK(yi4k_1107_consumer_close(&f.consumer) == YI4K_CONSUMER_OK);
    CHECK(f.calls[8] == 1);
report:
    CHECK(f.consumer.busy == 0 && f.payload_bad == 0);
    yi4k_fifo_test_report[0] = (uint32_t)f.consumer.state;
    yi4k_fifo_test_report[1] = (uint32_t)f.consumer.last_backend_status;
    yi4k_fifo_test_report[2] = f.consumer.frames_persisted;
    for (i = 1; i < 9; ++i) yi4k_fifo_test_report[2+i] = f.calls[i];
    yi4k_fifo_test_report[11] = f.advanced;
    yi4k_fifo_test_report[12] = f.reentry_count;
    yi4k_fifo_test_report[13] = f.consumer.handle == NULL;
    yi4k_fifo_test_report[14] = (uint32_t)f.consumer.last_copy_status;
    return 0;
}
