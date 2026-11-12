#ifndef YI4K_CAPTURE_TRIGGER_H
#define YI4K_CAPTURE_TRIGGER_H

#include <stddef.h>
#include <stdint.h>

/* Pure, offline-tested reducer: no camera calls, hook, allocator or backend.
 * All entry points and completions for a router MUST run on one owner thread
 * (or under the same external lock). Publish an output only after route()
 * returns; do not issue callbacks/re-enter while holding an adapter lock.
 */
#define YI4K_CAPTURE_MAGIC UINT32_C(0x59544352)
#define YI4K_CAPTURE_VERSION UINT32_C(1)
#define YI4K_CAPTURE_WINDOW_US UINT64_C(60000000)

enum yi4k_capture_state {
    YI4K_CAPTURE_OFF = 0,
    YI4K_CAPTURE_PREBUFFERING = 1,
    YI4K_CAPTURE_COMMITTING = 2,
    YI4K_CAPTURE_RECORDING = 3,
    YI4K_CAPTURE_FINALIZING = 4
};
enum yi4k_capture_input {
    YI4K_CAPTURE_UNKNOWN = 0,
    YI4K_CAPTURE_START = 1,
    YI4K_CAPTURE_STOP = 2,
    YI4K_CAPTURE_SHUTTER_SHORT = 3,
    YI4K_CAPTURE_SHUTTER_LONG = 4,
    YI4K_CAPTURE_COMMIT_OK = 5,
    YI4K_CAPTURE_COMMIT_FAILED = 6,
    YI4K_CAPTURE_STOP_OK = 7,
    YI4K_CAPTURE_STOP_FAILED = 8,
    YI4K_CAPTURE_DISARM = 9,
    YI4K_CAPTURE_COMMIT_UNKNOWN = 10,
    YI4K_CAPTURE_STOP_UNKNOWN = 11
};
enum yi4k_capture_source {
    YI4K_CAPTURE_EXTERNAL = 0,
    YI4K_CAPTURE_CAMERA_VOICE = 1,
    YI4K_CAPTURE_SHUTTER = 2
};
enum yi4k_capture_action {
    YI4K_CAPTURE_NO_ACTION = 0,
    YI4K_CAPTURE_PASS_STOCK = 1,
    YI4K_CAPTURE_COMMIT = 2,
    YI4K_CAPTURE_FINALIZE = 3
};
enum yi4k_capture_result {
    YI4K_CAPTURE_IGNORED = 0,
    YI4K_CAPTURE_ACCEPTED = 1,
    YI4K_CAPTURE_PASSTHROUGH = 2,
    YI4K_CAPTURE_DEFERRED = 3,
    YI4K_CAPTURE_RECOVERED = 4,
    YI4K_CAPTURE_BUSY = 5,
    YI4K_CAPTURE_INVALID = 6,
    YI4K_CAPTURE_TOKEN_EXHAUSTED = 7
};
enum yi4k_capture_voice_domain {
    YI4K_CAPTURE_ENGINE_RESULT = 0,
    YI4K_CAPTURE_VOICE_MESSAGE = 1
};

/* ABI fields are fixed-width integers, never compiler-sized enum fields.
 * Initialize once per lifetime after all earlier completions are drained.
 * Do not edit fields directly or copy an active router into another owner.
 */
struct yi4k_capture_router {
    uint32_t magic, version, state, counter;
    uint32_t pending_token, source, stop_pending, stop_source;
    uint32_t last_error, reserved;
    uint64_t trigger_us, stop_us;
};
struct yi4k_capture_event {
    uint32_t type, source, token, error;
    uint64_t at_us;
};
struct yi4k_capture_output {
    uint32_t result, action, token, source;
    uint64_t at_us, window_us;
};

void yi4k_capture_init(struct yi4k_capture_router *router);
/* Caller attests the real prebuffer backend is ready. This function does not
 * start a producer. Returns ACCEPTED / IGNORED / BUSY / INVALID.
 */
uint32_t yi4k_capture_arm(struct yi4k_capture_router *router);
/* Output is an intent, not proof of backend success. Nonzero completion tokens
 * must match the outstanding operation and kind; stale completions are ignored.
 * COMMIT_FAILED requires confirmed no effect/rollback to a usable prebuffer.
 * STOP_FAILED requires confirmed no effect/rollback so recording can continue.
 * Timeout or uncertain outcome MUST use COMMIT_UNKNOWN/STOP_UNKNOWN, which
 * preserve ownership/state/token until a later matching definitive completion.
 * STOP during COMMITTING is deferred once; commit failure clears that request.
 * SHUTTER_SHORT must be a classified/debounced press, not a raw GPIO level.
 * It commits in PREBUFFERING, is ignored in COMMITTING, and requests independent
 * STOP in RECORDING. Voice/external START stays idempotent in RECORDING.
 * Tokens never wrap. TOKEN_EXHAUSTED is an explicit terminal capacity error;
 * a reserved last token permits STOP after the final legal COMMIT. Reinitialize
 * only after backend shutdown and all old completions have been drained.
 * The three pointer arguments must refer to nonoverlapping objects.
 */
uint32_t yi4k_capture_route(struct yi4k_capture_router *router,
                          const struct yi4k_capture_event *event,
                          struct yi4k_capture_output *output);
/* Decode only independently established stock numeric semantics. UNKNOWN must
 * continue through the original path; this is not a phrase recognizer.
 */
uint32_t yi4k_capture_decode_voice(uint32_t domain, uint32_t value);

_Static_assert(sizeof(struct yi4k_capture_router) == 56, "router ABI");
_Static_assert(offsetof(struct yi4k_capture_router, trigger_us) == 40, "router timestamp ABI");
_Static_assert(sizeof(struct yi4k_capture_event) == 24, "event ABI");
_Static_assert(offsetof(struct yi4k_capture_event, at_us) == 16, "event timestamp ABI");
_Static_assert(sizeof(struct yi4k_capture_output) == 32, "output ABI");
_Static_assert(offsetof(struct yi4k_capture_output, at_us) == 16, "output timestamp ABI");

#endif
