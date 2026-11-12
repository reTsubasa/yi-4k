/* Same deterministic tests run natively and as freestanding ARM code. */
#include "../yi4k_capture_trigger.h"
#ifdef YI4K_HOST_TEST
#include <stdio.h>
#endif

uint32_t yi4k_capture_test_checks;
#define CHECK(condition) do { ++yi4k_capture_test_checks; if (!(condition)) return __LINE__; } while (0)

static uint32_t send(struct yi4k_capture_router *r, struct yi4k_capture_output *o,
                     uint32_t type, uint32_t source, uint32_t token, uint64_t time)
{
    struct yi4k_capture_event e;
    e.type = type; e.source = source; e.token = token; e.error = 17; e.at_us = time;
    return yi4k_capture_route(r, &e, o);
}

uint32_t yi4k_capture_router_selftest(void)
{
    struct yi4k_capture_router r;
    struct yi4k_capture_output o;
    uint32_t commit, stop, old, iteration;
    uint64_t trigger = UINT64_C(0x12345678ABCDEF00);
    yi4k_capture_test_checks = 0;
    yi4k_capture_init(&r);
    CHECK(r.state == YI4K_CAPTURE_OFF);
    CHECK(yi4k_capture_decode_voice(YI4K_CAPTURE_ENGINE_RESULT, 1003) == YI4K_CAPTURE_START);
    CHECK(yi4k_capture_decode_voice(YI4K_CAPTURE_ENGINE_RESULT, 1004) == YI4K_CAPTURE_STOP);
    CHECK(yi4k_capture_decode_voice(YI4K_CAPTURE_VOICE_MESSAGE, 0xF0010338) == YI4K_CAPTURE_START);
    CHECK(yi4k_capture_decode_voice(YI4K_CAPTURE_VOICE_MESSAGE, 0xF0010339) == YI4K_CAPTURE_STOP);
    CHECK(yi4k_capture_decode_voice(YI4K_CAPTURE_ENGINE_RESULT, 1001) == YI4K_CAPTURE_UNKNOWN);
    CHECK(yi4k_capture_decode_voice(YI4K_CAPTURE_VOICE_MESSAGE, 1003) == YI4K_CAPTURE_UNKNOWN);
    CHECK(yi4k_capture_decode_voice(999, 1003) == YI4K_CAPTURE_UNKNOWN);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger) == YI4K_CAPTURE_PASSTHROUGH);
    CHECK(o.action == YI4K_CAPTURE_PASS_STOCK && r.state == YI4K_CAPTURE_OFF);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 1, 0, trigger) == YI4K_CAPTURE_PASSTHROUGH);
    CHECK(send(&r, &o, YI4K_CAPTURE_SHUTTER_SHORT, 2, 0, trigger) == YI4K_CAPTURE_PASSTHROUGH);
    CHECK(send(&r, &o, YI4K_CAPTURE_SHUTTER_LONG, 2, 0, trigger) == YI4K_CAPTURE_PASSTHROUGH);
    CHECK(yi4k_capture_arm(&r) == YI4K_CAPTURE_ACCEPTED);
    CHECK(yi4k_capture_arm(&r) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 1, 0, trigger) == YI4K_CAPTURE_IGNORED);
    CHECK(r.state == YI4K_CAPTURE_PREBUFFERING);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger) == YI4K_CAPTURE_ACCEPTED);
    commit = o.token;
    CHECK(o.action == YI4K_CAPTURE_COMMIT && o.window_us == UINT64_C(60000000));
    CHECK(o.at_us == trigger && o.source == 1 && r.state == YI4K_CAPTURE_COMMITTING);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger+1) == YI4K_CAPTURE_IGNORED);
    CHECK(o.action == YI4K_CAPTURE_NO_ACTION && r.pending_token == commit);
    CHECK(send(&r, &o, YI4K_CAPTURE_SHUTTER_SHORT, 2, 0, trigger+2) == YI4K_CAPTURE_IGNORED);
    CHECK(yi4k_capture_arm(&r) == YI4K_CAPTURE_BUSY);
    CHECK(send(&r, &o, YI4K_CAPTURE_DISARM, 0, 0, 0) == YI4K_CAPTURE_BUSY);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, commit+1, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_OK, 0, commit, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_UNKNOWN, 0, commit, 0) == YI4K_CAPTURE_DEFERRED);
    CHECK(r.state == YI4K_CAPTURE_COMMITTING && r.pending_token == commit);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_UNKNOWN, 0, commit+1, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger+3) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, commit, 0) == YI4K_CAPTURE_ACCEPTED);
    CHECK(r.state == YI4K_CAPTURE_RECORDING && o.action == YI4K_CAPTURE_NO_ACTION);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger+3) == YI4K_CAPTURE_IGNORED);
    CHECK(r.state == YI4K_CAPTURE_RECORDING);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 1, 0, trigger-1) == YI4K_CAPTURE_INVALID);
    CHECK(send(&r, &o, YI4K_CAPTURE_SHUTTER_SHORT, 0, 0, trigger+4) == YI4K_CAPTURE_ACCEPTED);
    stop = o.token;
    CHECK(stop != commit && o.action == YI4K_CAPTURE_FINALIZE && o.at_us == trigger+4 && o.source == YI4K_CAPTURE_SHUTTER);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_UNKNOWN, 0, stop, 0) == YI4K_CAPTURE_DEFERRED);
    CHECK(r.state == YI4K_CAPTURE_FINALIZING && r.pending_token == stop);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_FAILED, 0, commit, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 1, 0, trigger+5) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_FAILED, 0, commit, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_FAILED, 0, stop, 0) == YI4K_CAPTURE_RECOVERED);
    CHECK(r.state == YI4K_CAPTURE_RECORDING && r.last_error == 17);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 0, 0, trigger+6) == YI4K_CAPTURE_ACCEPTED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_OK, 0, stop, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_OK, 0, r.pending_token, 0) == YI4K_CAPTURE_ACCEPTED);
    CHECK(r.state == YI4K_CAPTURE_PREBUFFERING);

    /* Repeated voice/button races plus commit rollback and deferred STOP. */
    old = commit;
    for (iteration = 0; iteration < 1000; ++iteration) {
        CHECK(send(&r, &o, YI4K_CAPTURE_SHUTTER_SHORT, 0, 0, trigger) == YI4K_CAPTURE_ACCEPTED);
        commit = o.token;
        CHECK(o.source == YI4K_CAPTURE_SHUTTER && commit != old);
        CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger+1) == YI4K_CAPTURE_IGNORED);
        CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, old, 0) == YI4K_CAPTURE_IGNORED);
        CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 1, 0, trigger+10) == YI4K_CAPTURE_DEFERRED);
        CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 0, 0, trigger+20) == YI4K_CAPTURE_IGNORED);
        CHECK(r.stop_us == trigger+10 && r.stop_source == 1);
        CHECK(send(&r, &o, YI4K_CAPTURE_SHUTTER_LONG, 2, 0, trigger+30) == YI4K_CAPTURE_PASSTHROUGH);
        CHECK(r.pending_token == commit && r.state == YI4K_CAPTURE_COMMITTING);
        if (iteration & 1) {
            CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_FAILED, 0, commit, 0) == YI4K_CAPTURE_RECOVERED);
            CHECK(r.state == YI4K_CAPTURE_PREBUFFERING && !r.stop_pending && !r.pending_token);
            CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, commit, 0) == YI4K_CAPTURE_IGNORED);
        } else {
            CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, commit, 0) == YI4K_CAPTURE_ACCEPTED);
            stop = o.token;
            CHECK(o.action == YI4K_CAPTURE_FINALIZE && o.at_us == trigger+10 && o.source == 1);
            CHECK(r.state == YI4K_CAPTURE_FINALIZING && !r.stop_pending && stop != commit);
            CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, commit, 0) == YI4K_CAPTURE_IGNORED);
            CHECK(send(&r, &o, YI4K_CAPTURE_STOP_OK, 0, stop, 0) == YI4K_CAPTURE_ACCEPTED);
        }
        old = commit;
    }
    CHECK(send(&r, &o, YI4K_CAPTURE_DISARM, 0, 0, 0) == YI4K_CAPTURE_ACCEPTED);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, old, 0) == YI4K_CAPTURE_IGNORED);
    CHECK(send(&r, &o, YI4K_CAPTURE_UNKNOWN, 0, 0, 10) == YI4K_CAPTURE_PASSTHROUGH);
    CHECK(yi4k_capture_arm(&r) == YI4K_CAPTURE_ACCEPTED);
    CHECK(send(&r, &o, 999, 0, 0, 10) == YI4K_CAPTURE_PASSTHROUGH);
    CHECK(r.state == YI4K_CAPTURE_PREBUFFERING);
    r.counter = UINT32_MAX - 2;
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger) == YI4K_CAPTURE_ACCEPTED);
    CHECK(o.token == UINT32_MAX - 1);
    CHECK(send(&r, &o, YI4K_CAPTURE_COMMIT_OK, 0, o.token, 0) == YI4K_CAPTURE_ACCEPTED);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP, 1, 0, trigger+1) == YI4K_CAPTURE_ACCEPTED);
    CHECK(o.token == UINT32_MAX);
    CHECK(send(&r, &o, YI4K_CAPTURE_STOP_OK, 0, o.token, 0) == YI4K_CAPTURE_ACCEPTED);
    r.counter = UINT32_MAX;
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger) == YI4K_CAPTURE_TOKEN_EXHAUSTED);
    CHECK(r.state == YI4K_CAPTURE_PREBUFFERING && !r.pending_token && o.action == YI4K_CAPTURE_NO_ACTION);
    CHECK(yi4k_capture_route(&r, 0, &o) == YI4K_CAPTURE_INVALID);
    CHECK(yi4k_capture_route(&r, 0, 0) == YI4K_CAPTURE_INVALID);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 99, 0, trigger) == YI4K_CAPTURE_INVALID);
    r.magic = 0;
    CHECK(yi4k_capture_arm(&r) == YI4K_CAPTURE_INVALID);
    CHECK(send(&r, &o, YI4K_CAPTURE_START, 1, 0, trigger) == YI4K_CAPTURE_INVALID);
    return 0;
}

#ifdef YI4K_HOST_TEST
int main(void)
{
    uint32_t line = yi4k_capture_router_selftest();
    if (line) { printf("FAIL: line %u\n", line); return 1; }
    printf("PASS: %u capture-router checks\n", yi4k_capture_test_checks);
    return 0;
}
#endif
