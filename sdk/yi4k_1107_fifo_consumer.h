#ifndef YI4K_1107_FIFO_CONSUMER_H
#define YI4K_1107_FIFO_CONSUMER_H

#include "yi4k_1107_payload_copy.h"

/* Pinned 1.10.7 32-bit stock configuration layout, not a device binding.
 * Only zero-history virtual mode is exercised by this candidate. */
typedef struct yi4k_1107_fifo_config {
    uint32_t stream_id;                    /* +00 */
    uint32_t descriptor_capacity;          /* +04: 0 inherits base capacity */
    uint32_t is_virtual;                   /* +08 */
    uint32_t callback_address;             /* +0c: required, ARM address/token */
    uint32_t opaque_10;                    /* copied to handler+A8 */
    uint32_t notify_interval_minus_one;    /* +14 -> handler+AC */
    uint32_t opaque_18;                    /* no read in pinned Create */
    uint8_t base_remove_on_write;          /* +1c -> handler+B0 */
    uint8_t reserved_1d[3];
    uint32_t payload_base;                 /* +20 -> handler+B8 */
    uint32_t payload_limit;                /* +24 -> handler+BC */
    uint64_t history_time_scale;           /* +28; history arithmetic only */
    uint8_t history_enable;                /* +30 */
    uint8_t history_mode;                  /* +31: branches 1,2,3,4 observed */
    uint8_t reserved_32[6];
    uint64_t history_limit;                /* +38 */
    uint8_t history_type_filter;           /* +40 */
    uint8_t reserved_41[7];
    uint64_t selected_pts;                 /* +48: output in history modes */
    uint64_t selected_duration;            /* +50: output in history modes */
} yi4k_1107_fifo_config;

typedef int32_t (*yi4k_1107_stock_fifo_create_fn)(yi4k_1107_fifo_config *, void **);
typedef int32_t (*yi4k_1107_stock_fifo_peek_fn)(void *, const yi4k_1107_frame_desc **, uint32_t);
typedef int32_t (*yi4k_1107_stock_fifo_remove_fn)(void *, uint32_t);
typedef int32_t (*yi4k_1107_stock_fifo_delete_fn)(void *);
typedef int32_t (*yi4k_1107_stock_fifo_callback_fn)(void *, uint32_t, const void *);

/* Stock ABI event meaning is source-path-specific; +1 is NOT queue-empty. */
#define YI4K_FIFO_EVENT_END UINT32_C(0x04000001)
#define YI4K_FIFO_EVENT_DATA UINT32_C(0x04000002)
#define YI4K_FIFO_EVENT_FULL UINT32_C(0x04000005)
#define YI4K_FIFO_PEEK_EMPTY (-8)
#define YI4K_FIFO_PEEK_OVERLAP (-9)

/* Injected services are an OFFLINE integration boundary, not implemented stock
 * barriers. Every consumer method is called by one serialized owner, never from
 * a stock callback. The callback bridge may only copy its transient event data
 * to a separate queue and wake that owner. Its lifetime must outlive deletion.
 * create must first establish the target base FIFO is active: stock Create's
 * stream lookup alone does not check that base's in-use flag.
 *
 * begin_read/end_read MUST keep the borrowed descriptor, its cursor and payload
 * stable through copy, persist and Remove. This is stronger than stock Peek's
 * short mutex hold and is not established by finding these APIs.
 *
 * quiesce success MUST prove no callback using this handle is in flight or can
 * start, all other accesses have stopped, and the handle is still live in its
 * stock registry slot. Serialize global Create/Delete against other lifecycle
 * users. No such stock barrier or registry verifier is bound here.
 *
 * persist is synchronous: zero means owned bytes were safely accepted; nonzero
 * must leave no commit or be idempotent for the same descriptor on retry.
 */
typedef struct yi4k_1107_consumer_ops {
    void *context;
    int32_t (*create)(void *, yi4k_1107_fifo_config *, void **);
    int32_t (*peek)(void *, void *, const yi4k_1107_frame_desc **, uint32_t);
    int32_t (*remove)(void *, void *, uint32_t);
    int32_t (*delete_fifo)(void *, void *);
    int32_t (*begin_read)(void *, void *);
    void (*end_read)(void *, void *);
    int32_t (*persist)(void *, const yi4k_1107_frame_desc *, const uint8_t *, uint32_t);
    int32_t (*quiesce)(void *, void *);
} yi4k_1107_consumer_ops;

typedef enum yi4k_1107_consumer_state {
    YI4K_CONSUMER_IDLE, YI4K_CONSUMER_STARTING, YI4K_CONSUMER_RUNNING,
    YI4K_CONSUMER_STOPPED, YI4K_CONSUMER_CLOSED,
    YI4K_CONSUMER_CREATE_UNCERTAIN, YI4K_CONSUMER_PEEK_FAILED,
    YI4K_CONSUMER_CURSOR_UNCERTAIN, YI4K_CONSUMER_DELETE_FAILED
} yi4k_1107_consumer_state;

typedef enum yi4k_1107_consumer_result {
    YI4K_CONSUMER_OK, YI4K_CONSUMER_EMPTY, YI4K_CONSUMER_END,
    YI4K_CONSUMER_RETRY, YI4K_CONSUMER_BAD_ARGUMENT, YI4K_CONSUMER_BAD_STATE,
    YI4K_CONSUMER_BUSY, YI4K_CONSUMER_BACKEND_ERROR
} yi4k_1107_consumer_result;

typedef struct yi4k_1107_consumer {
    yi4k_1107_consumer_ops ops;
    yi4k_1107_ring_view ring;
    uint8_t *owned_buffer;
    size_t owned_capacity;
    void *handle;
    yi4k_1107_consumer_state state;
    int32_t last_backend_status;
    yi4k_1107_payload_copy_status last_copy_status;
    uint32_t busy;
    uint32_t frames_persisted;
} yi4k_1107_consumer;

/* init requires valid, disjoint caller-owned objects/buffer and fresh consumer
 * storage; do not re-init a live/failed object. This is a C API, not a validator
 * for arbitrary pointers. Ring mapping/bounds are a caller-established contract.
 * Config helper mirrors stock defaults then UVCd's four overrides. */
void yi4k_1107_fifo_config_virtual(yi4k_1107_fifo_config *, uint32_t stream,
                                uint32_t capacity, uint32_t callback_address);
yi4k_1107_consumer_result yi4k_1107_consumer_init(yi4k_1107_consumer *,
    const yi4k_1107_consumer_ops *, const yi4k_1107_ring_view *, uint8_t *, size_t);
yi4k_1107_consumer_result yi4k_1107_consumer_start(yi4k_1107_consumer *,
    uint32_t stream, uint32_t capacity, uint32_t callback_address);
yi4k_1107_consumer_result yi4k_1107_consumer_step(yi4k_1107_consumer *);
yi4k_1107_consumer_result yi4k_1107_consumer_stop(yi4k_1107_consumer *);
yi4k_1107_consumer_result yi4k_1107_consumer_close(yi4k_1107_consumer *);

#if defined(__cplusplus)
#define YI4K_FIFO_ASSERT static_assert
#else
#define YI4K_FIFO_ASSERT _Static_assert
#endif
YI4K_FIFO_ASSERT(sizeof(yi4k_1107_fifo_config)==0x58,"stock config bytes");
YI4K_FIFO_ASSERT(offsetof(yi4k_1107_fifo_config,callback_address)==0x0c,"callback offset");
YI4K_FIFO_ASSERT(offsetof(yi4k_1107_fifo_config,history_enable)==0x30,"history enable offset");
YI4K_FIFO_ASSERT(offsetof(yi4k_1107_fifo_config,history_limit)==0x38,"history limit offset");
YI4K_FIFO_ASSERT(offsetof(yi4k_1107_fifo_config,selected_pts)==0x48,"history output offset");
#undef YI4K_FIFO_ASSERT
#endif
