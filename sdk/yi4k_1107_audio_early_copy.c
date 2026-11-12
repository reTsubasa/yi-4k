#include "yi4k_1107_audio_early_copy.h"

static yi4k_1107_early_status capture_audio(yi4k_1107_audio_ingress *ingress,
    const void *argument)
{
    const yi4k_1107_audio_event *event = argument;
    yi4k_1107_audio_event snapshot = {0};
    yi4k_1107_frame_desc descriptor = {0};
    yi4k_1107_early_copy *queue = ingress->owned;
    if (event == NULL || (uintptr_t)event % _Alignof(yi4k_1107_audio_event) ||
        event->encoder_handle == 0 || event->eos > 1 ||
        (event->eos == 0 && (event->payload_size == YI4K_1107_FRAME_EOS_LENGTH ||
            event->payload_size == YI4K_1107_DSP_VIDEO_EOS_LENGTH))) {
        ++queue->failed;
        return YI4K_EARLY_BAD_EVENT;
    }
    snapshot.encoder_handle = event->encoder_handle;
    snapshot.synthetic_pts = event->synthetic_pts;
    snapshot.eos = event->eos;
    snapshot.payload_size = event->payload_size;
    snapshot.cpu_payload_address = event->cpu_payload_address;
    descriptor.sequence = ingress->next_sequence;
    descriptor.flags = 1;
    if (event->eos) {
        descriptor.type = 0xFF;
        descriptor.payload_size = YI4K_1107_FRAME_EOS_LENGTH;
    } else {
        ++ingress->next_sequence;
        descriptor.type = 8;
        descriptor.corrected_pts = event->synthetic_pts;
        descriptor.cpu_payload_address = event->cpu_payload_address;
        descriptor.payload_size = event->payload_size;
    }
    return yi4k_1107_early_offer_frame(queue, &descriptor, YI4K_EARLY_SOURCE_AUDIO, &snapshot);
}

yi4k_1107_early_result yi4k_1107_audio_on_event(
    const yi4k_1107_audio_chain *chain, yi4k_1107_audio_ingress *ingress, const void *argument)
{
    yi4k_1107_early_result result;
    yi4k_1107_early_copy *queue = ingress ? ingress->owned : NULL;
    uint32_t entered = 0;
    result.original_status = 0;
    if (chain == NULL || chain->original == NULL) {
        result.capture_status = YI4K_EARLY_BAD_CHAIN;
        return result;
    }
    if (queue == NULL) {
        result.capture_status = YI4K_EARLY_BAD_ADAPTER;
    } else if (queue->ingress_busy) {
        ++queue->dropped;
        result.capture_status = YI4K_EARLY_REENTRY;
    } else {
        entered = 1;
        queue->ingress_busy = 1;
        result.capture_status = capture_audio(ingress, argument);
    }
    result.original_status = chain->original(chain->context, argument);
    if (entered) queue->ingress_busy = 0;
    return result;
}
