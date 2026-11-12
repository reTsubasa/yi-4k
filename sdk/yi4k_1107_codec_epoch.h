#ifndef YI4K_1107_CODEC_EPOCH_H
#define YI4K_1107_CODEC_EPOCH_H
#include <stdint.h>

#define YI4K_CODEC_PARAM_MAX 64u
#define YI4K_CODEC_VIDEO_MAX 1048576u
#define YI4K_CODEC_AUDIO_MAX 32768u

/* Offline, single serialized consumer only. No encoder binding, hooks, FIFOs,
 * file IO, hashing, timing, allocation or device address discovery is provided.
 * Caller binds these exact configuration bytes to the REAL producer's stable
 * configuration event/session, and tags EVERY packet with that same identity.
 * identity/config_digest are nonzero 32-byte caller attestations, NOT inferred
 * from a slice, PTS, sequence, raw AAC or a numerical epoch guess. Host validator
 * derives both from the archived source plus its exact avcC/ASC bytes; this is
 * not evidence of a real encoder configuration callback or hardware epoch.
 */
typedef struct yi4k_1107_codec_config {
    uint8_t identity[32], config_digest[32];
    uint32_t sps_size, pps_size, sample_rate, channels, samples_per_aac;
    uint8_t sps[YI4K_CODEC_PARAM_MAX], pps[YI4K_CODEC_PARAM_MAX], asc[2];
    uint8_t reserved[2];
} yi4k_1107_codec_config;

typedef struct yi4k_1107_codec_epoch {
    uint32_t magic, video_end, audio_end, sps_id, pps_id;
    yi4k_1107_codec_config config;
} yi4k_1107_codec_epoch;

typedef enum yi4k_1107_codec_status {
    YI4K_CODEC_OK = 0, YI4K_CODEC_END = 1,
    YI4K_CODEC_BAD_ARGUMENT = -1, YI4K_CODEC_NO_CONFIG = -2,
    YI4K_CODEC_CHANGED = -3, YI4K_CODEC_MALFORMED = -4,
    YI4K_CODEC_LIMIT = -5, YI4K_CODEC_NEED_IDR = -6,
    YI4K_CODEC_ENDED = -7
} yi4k_1107_codec_status;

/* Quiescent ZERO-INITIALIZED fresh object only. A bound object rejects init;
 * no automatic epoch replacement. Caller must close
 * or recover prior segments and quiesce queues before constructing a new epoch.
 * Narrow supported contract: exactly one SPS/PPS, four-byte Annex B prefixes,
 * parameter NALs <=64 bytes, AAC-LC ASC2, mono/stereo, frameLengthFlag=0 and
 * supported explicit rate. Only framing/initial syntax/ID relationships are
 * checked here, NOT complete SPS/PPS/slice semantics or decoder validity.
 * Caller must validate configuration through its actual parser/decoder before
 * binding; malformed suffixes beyond parsed fields cannot be detected here.
 * Invalid init leaves destination unchanged. Objects are live, accessible,
 * correctly aligned and initialized; C does not catch arbitrary pointer faults.
 */
int32_t yi4k_1107_codec_init(yi4k_1107_codec_epoch *, const yi4k_1107_codec_config *);

/* Copy a complete contiguous owned AU into a separate caller-owned buffer.
 * Reject mismatched identity or in-band parameter changes (byte equality, not
 * just parameter IDs). New-segment AU must contain ONLY IDR VCL slices whose
 * PPS ID matches the bound PPS. If both SPS/PPS absent, prepend cached pair;
 * if both present before VCL and byte-identical, keep input unchanged. Partial,
 * duplicate or post-VCL parameter sets are rejected. Normal AUs may use VCL1/5,
 * SEI and AUD; all slices must reference the bound PPS, no unsupported NALs.
 * This does not prove IDR closure/whole-bitstream validity or common A/V epoch.
 * Trailing zero padding on VCL NALs is retained byte-for-byte (archived stock
 * aligned AUs contain it); it is excluded from structural RBSP checks only.
 * Maximum input is 1MiB and 64 NALs; output may need +8+SPS+PPS bytes. No alias
 * among source/output/control/size/identity. Output unchanged on any failure;
 * *written=0 on failure when its pointer satisfies the separate live-object
 * contract; invalid/aliased size pointers are not written. Output and size are
 * retained only until caller reuses them. Identity must be a separate snapshot,
 * not a pointer into this epoch's config or source/output storage.
 * EOS is explicit: eos=1, new_segment=0, data=NULL,size=0, output=NULL,capacity=0;
 * it returns END without reading payload and blocks subsequent track packets.
 */
int32_t yi4k_1107_codec_video(yi4k_1107_codec_epoch *, const uint8_t identity[32],
    uint32_t new_segment, uint32_t eos, const uint8_t *data, uint32_t size,
    uint8_t *output, uint32_t capacity, uint32_t *written);

/* Raw AAC bytes are copied, never inspected to infer sample rate/channels.
 * Configured transport must be raw AAC-LC, max32KiB. ASC is in cache for caller
 * to populate fresh track STSD; raw payload itself cannot establish that config.
 * Same binding/alias/EOS/failure rules; no timestamp changes or ADTS synthesis.
 */
int32_t yi4k_1107_codec_audio(yi4k_1107_codec_epoch *, const uint8_t identity[32],
    uint32_t eos, const uint8_t *data, uint32_t size, uint8_t *output,
    uint32_t capacity, uint32_t *written);
#endif
