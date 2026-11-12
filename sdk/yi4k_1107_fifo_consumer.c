#include "yi4k_1107_fifo_consumer.h"

void yi4k_1107_fifo_config_virtual(yi4k_1107_fifo_config *config,
    uint32_t stream, uint32_t capacity, uint32_t callback_address)
{
    size_t i;
    uint8_t *bytes = (uint8_t *)config;
    for (i = 0; i < sizeof(*config); ++i)
        bytes[i] = 0;
    config->stream_id = stream;
    config->descriptor_capacity = capacity;
    config->is_virtual = 1;
    config->callback_address = callback_address;
}

yi4k_1107_consumer_result yi4k_1107_consumer_init(yi4k_1107_consumer *consumer,
    const yi4k_1107_consumer_ops *ops, const yi4k_1107_ring_view *ring,
    uint8_t *buffer, size_t capacity)
{
    if (consumer == NULL || ops == NULL || ring == NULL || buffer == NULL ||
        capacity == 0 || ops->create == NULL || ops->peek == NULL ||
        ops->remove == NULL || ops->delete_fifo == NULL ||
        ops->begin_read == NULL || ops->end_read == NULL ||
        ops->persist == NULL || ops->quiesce == NULL)
        return YI4K_CONSUMER_BAD_ARGUMENT;
    consumer->ops = *ops;
    consumer->ring = *ring;
    consumer->owned_buffer = buffer;
    consumer->owned_capacity = capacity;
    consumer->handle = NULL;
    consumer->state = YI4K_CONSUMER_IDLE;
    consumer->last_backend_status = 0;
    consumer->last_copy_status = YI4K_COPY_OK;
    consumer->busy = 0;
    consumer->frames_persisted = 0;
    return YI4K_CONSUMER_OK;
}

yi4k_1107_consumer_result yi4k_1107_consumer_start(yi4k_1107_consumer *consumer,
    uint32_t stream, uint32_t capacity, uint32_t callback_address)
{
    yi4k_1107_fifo_config config;
    int32_t status;
    if (consumer == NULL || capacity == 0 || capacity > UINT32_MAX / 32 ||
        callback_address == 0)
        return YI4K_CONSUMER_BAD_ARGUMENT;
    if (consumer->busy)
        return YI4K_CONSUMER_BUSY;
    if (consumer->state != YI4K_CONSUMER_IDLE)
        return YI4K_CONSUMER_BAD_STATE;
    consumer->busy = 1;
    consumer->state = YI4K_CONSUMER_STARTING;
    yi4k_1107_fifo_config_virtual(&config, stream, capacity, callback_address);
    status = consumer->ops.create(consumer->ops.context, &config, &consumer->handle);
    consumer->last_backend_status = status;
    if (status != 0 || consumer->handle == NULL) {
        /* Stock Create failures can reserve a slot with no returned handle.
         * No automatic retry, Delete or guessed registry repair is valid. */
        consumer->state = YI4K_CONSUMER_CREATE_UNCERTAIN;
        consumer->busy = 0;
        return YI4K_CONSUMER_BACKEND_ERROR;
    }
    consumer->state = YI4K_CONSUMER_RUNNING;
    consumer->busy = 0;
    return YI4K_CONSUMER_OK;
}

yi4k_1107_consumer_result yi4k_1107_consumer_step(yi4k_1107_consumer *consumer)
{
    const yi4k_1107_frame_desc *borrowed = NULL;
    yi4k_1107_frame_desc snapshot;
    yi4k_1107_payload_copy_result copied;
    yi4k_1107_payload_copy_status copy_status;
    yi4k_1107_consumer_result answer = YI4K_CONSUMER_RETRY;
    int32_t status;
    if (consumer == NULL)
        return YI4K_CONSUMER_BAD_ARGUMENT;
    if (consumer->busy)
        return YI4K_CONSUMER_BUSY;
    if (consumer->state != YI4K_CONSUMER_RUNNING)
        return YI4K_CONSUMER_BAD_STATE;
    consumer->busy = 1;
    status = consumer->ops.begin_read(consumer->ops.context, consumer->handle);
    consumer->last_backend_status = status;
    if (status != 0)
        goto done;
    status = consumer->ops.peek(consumer->ops.context, consumer->handle, &borrowed, 0);
    consumer->last_backend_status = status;
    if (status == YI4K_FIFO_PEEK_EMPTY) {
        answer = YI4K_CONSUMER_EMPTY;
        goto release;
    }
    if (status != 0 || borrowed == NULL) {
        consumer->state = YI4K_CONSUMER_PEEK_FAILED;
        answer = YI4K_CONSUMER_BACKEND_ERROR;
        goto release;
    }
    snapshot = *borrowed;
    copy_status = yi4k_1107_copy_payload(&snapshot, &consumer->ring,
        consumer->owned_buffer, consumer->owned_capacity, &copied);
    consumer->last_copy_status = copy_status;
    if (copy_status == YI4K_COPY_END) {
        /* EOS stays at queue head. Owner closes after quiescence; no implicit ack. */
        consumer->state = YI4K_CONSUMER_STOPPED;
        answer = YI4K_CONSUMER_END;
        goto release;
    }
    if (copy_status != YI4K_COPY_OK)
        goto release;
    status = consumer->ops.persist(consumer->ops.context, &snapshot,
        consumer->owned_buffer, copied.copied_bytes);
    consumer->last_backend_status = status;
    if (status != 0)
        goto release;
    ++consumer->frames_persisted;
    status = consumer->ops.remove(consumer->ops.context, consumer->handle, 1);
    consumer->last_backend_status = status;
    if (status != 0) {
        /* Remove may already have advanced before a message-send error. */
        consumer->state = YI4K_CONSUMER_CURSOR_UNCERTAIN;
        answer = YI4K_CONSUMER_BACKEND_ERROR;
        goto release;
    }
    answer = YI4K_CONSUMER_OK;
release:
    consumer->ops.end_read(consumer->ops.context, consumer->handle);
done:
    consumer->busy = 0;
    return answer;
}

yi4k_1107_consumer_result yi4k_1107_consumer_stop(yi4k_1107_consumer *consumer)
{
    if (consumer == NULL)
        return YI4K_CONSUMER_BAD_ARGUMENT;
    if (consumer->busy)
        return YI4K_CONSUMER_BUSY;
    if (consumer->state != YI4K_CONSUMER_RUNNING)
        return YI4K_CONSUMER_BAD_STATE;
    consumer->state = YI4K_CONSUMER_STOPPED;
    return YI4K_CONSUMER_OK;
}

yi4k_1107_consumer_result yi4k_1107_consumer_close(yi4k_1107_consumer *consumer)
{
    int32_t status;
    if (consumer == NULL)
        return YI4K_CONSUMER_BAD_ARGUMENT;
    if (consumer->busy)
        return YI4K_CONSUMER_BUSY;
    if (consumer->state == YI4K_CONSUMER_CLOSED)
        return YI4K_CONSUMER_OK;
    if (consumer->state != YI4K_CONSUMER_STOPPED &&
        consumer->state != YI4K_CONSUMER_PEEK_FAILED &&
        consumer->state != YI4K_CONSUMER_CURSOR_UNCERTAIN)
        return YI4K_CONSUMER_BAD_STATE;
    consumer->busy = 1;
    status = consumer->ops.quiesce(consumer->ops.context, consumer->handle);
    consumer->last_backend_status = status;
    if (status != 0) {
        consumer->busy = 0;
        return YI4K_CONSUMER_RETRY;
    }
    status = consumer->ops.delete_fifo(consumer->ops.context, consumer->handle);
    consumer->last_backend_status = status;
    if (status != 0) {
        consumer->state = YI4K_CONSUMER_DELETE_FAILED;
        consumer->busy = 0;
        return YI4K_CONSUMER_BACKEND_ERROR;
    }
    consumer->handle = NULL;
    consumer->state = YI4K_CONSUMER_CLOSED;
    consumer->busy = 0;
    return YI4K_CONSUMER_OK;
}
