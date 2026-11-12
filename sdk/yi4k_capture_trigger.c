#include "yi4k_capture_trigger.h"

static uint32_t valid(const struct yi4k_capture_router *r)
{
    return r && r->magic == YI4K_CAPTURE_MAGIC &&
           r->version == YI4K_CAPTURE_VERSION && r->state <= YI4K_CAPTURE_FINALIZING;
}

void yi4k_capture_init(struct yi4k_capture_router *r)
{
    if (!r) return;
    r->magic = YI4K_CAPTURE_MAGIC;
    r->version = YI4K_CAPTURE_VERSION;
    r->state = YI4K_CAPTURE_OFF;
    r->counter = 0;
    r->pending_token = 0;
    r->source = YI4K_CAPTURE_EXTERNAL;
    r->stop_pending = 0;
    r->stop_source = YI4K_CAPTURE_EXTERNAL;
    r->last_error = 0;
    r->reserved = 0;
    r->trigger_us = 0;
    r->stop_us = 0;
}

uint32_t yi4k_capture_arm(struct yi4k_capture_router *r)
{
    if (!valid(r)) return YI4K_CAPTURE_INVALID;
    if (r->state == YI4K_CAPTURE_PREBUFFERING) return YI4K_CAPTURE_IGNORED;
    if (r->state != YI4K_CAPTURE_OFF) return YI4K_CAPTURE_BUSY;
    r->state = YI4K_CAPTURE_PREBUFFERING;
    return YI4K_CAPTURE_ACCEPTED;
}

uint32_t yi4k_capture_decode_voice(uint32_t domain, uint32_t value)
{
    if (domain == YI4K_CAPTURE_ENGINE_RESULT) {
        if (value == 1003) return YI4K_CAPTURE_START;
        if (value == 1004) return YI4K_CAPTURE_STOP;
    } else if (domain == YI4K_CAPTURE_VOICE_MESSAGE) {
        if (value == UINT32_C(0xF0010338)) return YI4K_CAPTURE_START;
        if (value == UINT32_C(0xF0010339)) return YI4K_CAPTURE_STOP;
    }
    return YI4K_CAPTURE_UNKNOWN;
}

static uint32_t finish(struct yi4k_capture_output *o, uint32_t result)
{
    o->result = result;
    return result;
}

/* State ownership is established before the caller can publish this intent. */
static uint32_t emit(struct yi4k_capture_router *r, struct yi4k_capture_output *o,
                     uint32_t action, uint32_t source, uint64_t at_us)
{
    /* Keep one final token available for STOP after the last legal COMMIT. */
    if (r->counter == UINT32_MAX ||
        (action == YI4K_CAPTURE_COMMIT && r->counter == UINT32_MAX - 1))
        return finish(o, YI4K_CAPTURE_TOKEN_EXHAUSTED);
    r->counter += 1;
    r->pending_token = r->counter;
    r->state = action == YI4K_CAPTURE_COMMIT ? YI4K_CAPTURE_COMMITTING : YI4K_CAPTURE_FINALIZING;
    o->action = action;
    o->token = r->pending_token;
    o->source = source;
    o->at_us = at_us;
    o->window_us = action == YI4K_CAPTURE_COMMIT ? YI4K_CAPTURE_WINDOW_US : 0;
    return finish(o, YI4K_CAPTURE_ACCEPTED);
}

uint32_t yi4k_capture_route(struct yi4k_capture_router *r,
                          const struct yi4k_capture_event *e,
                          struct yi4k_capture_output *o)
{
    uint32_t result, source;
    if (!o) return YI4K_CAPTURE_INVALID;
    o->result = YI4K_CAPTURE_INVALID;
    o->action = YI4K_CAPTURE_NO_ACTION;
    o->token = 0;
    o->source = YI4K_CAPTURE_EXTERNAL;
    o->at_us = 0;
    o->window_us = 0;
    if (!valid(r) || !e || e->source > YI4K_CAPTURE_SHUTTER)
        return YI4K_CAPTURE_INVALID;
    source = e->type == YI4K_CAPTURE_SHUTTER_SHORT ? YI4K_CAPTURE_SHUTTER : e->source;

    /* Callbacks are internal events: they must never be forwarded to stock. */
    if ((e->type >= YI4K_CAPTURE_COMMIT_OK && e->type <= YI4K_CAPTURE_STOP_FAILED) ||
        e->type == YI4K_CAPTURE_COMMIT_UNKNOWN || e->type == YI4K_CAPTURE_STOP_UNKNOWN) {
        if (!e->token || e->token != r->pending_token)
            return finish(o, YI4K_CAPTURE_IGNORED);
        if ((r->state == YI4K_CAPTURE_COMMITTING && e->type == YI4K_CAPTURE_COMMIT_UNKNOWN) ||
            (r->state == YI4K_CAPTURE_FINALIZING && e->type == YI4K_CAPTURE_STOP_UNKNOWN)) {
            r->last_error = e->error;
            return finish(o, YI4K_CAPTURE_DEFERRED);
        }
        if (r->state == YI4K_CAPTURE_COMMITTING &&
            (e->type == YI4K_CAPTURE_COMMIT_OK || e->type == YI4K_CAPTURE_COMMIT_FAILED)) {
            if (e->type == YI4K_CAPTURE_COMMIT_FAILED) {
                r->state = YI4K_CAPTURE_PREBUFFERING;
                r->pending_token = 0;
                r->stop_pending = 0;
                r->last_error = e->error;
                return finish(o, YI4K_CAPTURE_RECOVERED);
            }
            r->state = YI4K_CAPTURE_RECORDING;
            r->pending_token = 0;
            if (r->stop_pending) {
                result = emit(r, o, YI4K_CAPTURE_FINALIZE, r->stop_source, r->stop_us);
                if (result == YI4K_CAPTURE_ACCEPTED) r->stop_pending = 0;
                return result;
            }
            return finish(o, YI4K_CAPTURE_ACCEPTED);
        }
        if (r->state == YI4K_CAPTURE_FINALIZING &&
            (e->type == YI4K_CAPTURE_STOP_OK || e->type == YI4K_CAPTURE_STOP_FAILED)) {
            r->pending_token = 0;
            r->state = e->type == YI4K_CAPTURE_STOP_OK ? YI4K_CAPTURE_PREBUFFERING : YI4K_CAPTURE_RECORDING;
            if (e->type == YI4K_CAPTURE_STOP_FAILED) r->last_error = e->error;
            return finish(o, e->type == YI4K_CAPTURE_STOP_OK ? YI4K_CAPTURE_ACCEPTED : YI4K_CAPTURE_RECOVERED);
        }
        return finish(o, YI4K_CAPTURE_IGNORED);
    }
    if (e->type == YI4K_CAPTURE_DISARM) {
        if (r->state != YI4K_CAPTURE_OFF && r->state != YI4K_CAPTURE_PREBUFFERING)
            return finish(o, YI4K_CAPTURE_BUSY);
        r->state = YI4K_CAPTURE_OFF;
        r->stop_pending = 0;
        return finish(o, YI4K_CAPTURE_ACCEPTED);
    }
    if (r->state == YI4K_CAPTURE_OFF || e->type == YI4K_CAPTURE_UNKNOWN ||
        e->type == YI4K_CAPTURE_SHUTTER_LONG || e->type > YI4K_CAPTURE_DISARM) {
        o->action = YI4K_CAPTURE_PASS_STOCK;
        o->source = e->source;
        o->at_us = e->at_us;
        return finish(o, YI4K_CAPTURE_PASSTHROUGH);
    }
    if (e->type == YI4K_CAPTURE_START ||
        (e->type == YI4K_CAPTURE_SHUTTER_SHORT && r->state != YI4K_CAPTURE_RECORDING)) {
        if (r->state != YI4K_CAPTURE_PREBUFFERING)
            return finish(o, YI4K_CAPTURE_IGNORED);
        result = emit(r, o, YI4K_CAPTURE_COMMIT, source, e->at_us);
        if (result == YI4K_CAPTURE_ACCEPTED) {
            r->source = o->source;
            r->trigger_us = e->at_us;
            r->stop_pending = 0;
            r->last_error = 0;
        }
        return result;
    }
    if (e->type == YI4K_CAPTURE_STOP || e->type == YI4K_CAPTURE_SHUTTER_SHORT) {
        if (r->state == YI4K_CAPTURE_PREBUFFERING || r->state == YI4K_CAPTURE_FINALIZING)
            return finish(o, YI4K_CAPTURE_IGNORED);
        if (e->at_us < r->trigger_us) return finish(o, YI4K_CAPTURE_INVALID);
        if (r->state == YI4K_CAPTURE_COMMITTING) {
            if (r->stop_pending) return finish(o, YI4K_CAPTURE_IGNORED);
            r->stop_pending = 1;
            r->stop_source = source;
            r->stop_us = e->at_us;
            return finish(o, YI4K_CAPTURE_DEFERRED);
        }
        result = emit(r, o, YI4K_CAPTURE_FINALIZE, source, e->at_us);
        if (result == YI4K_CAPTURE_ACCEPTED) {
            r->stop_us = e->at_us;
            r->stop_pending = 0;
        }
        return result;
    }
    return finish(o, YI4K_CAPTURE_IGNORED);
}
