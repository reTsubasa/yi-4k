#ifndef YI4K_1107_VIDEO_DESCRIPTOR_H
#define YI4K_1107_VIDEO_DESCRIPTOR_H

/* Offline, pinned 1.10.7 layout observations. This is not a device-access API.
 * Reference: docs/prerecord-dsp-framedesc-contract.md.
 * Raw DSP addresses require the stock translation before CPU dereference.
 * A raw descriptor's PTS is corrected by the stock adapter before FrameDesc.
 * Ownership, cache visibility and cursor release are not defined here. */
#include <stddef.h>
#include <stdint.h>

#define YI4K_1107_DSP_VIDEO_INFO_STRIDE UINT32_C(0x40)
#define YI4K_1107_FRAME_DESC_STRIDE UINT32_C(0x20)
#define YI4K_1107_DSP_VIDEO_EOS_LENGTH UINT32_C(0xffffffff)
#define YI4K_1107_FRAME_EOS_LENGTH UINT32_C(0x00ffffff)
#define YI4K_1107_DSP_VIDEO_TYPE_MASK UINT32_C(7)
/* Normal H.264 state only: type1 uses the stock NAL5/IDR predicate.
 * EOS can also have type1, so type alone never validates a payload. */
#define YI4K_1107_NORMAL_H264_IDR_TYPE UINT8_C(1)

typedef struct yi4k_1107_dsp_video_info {
    uint8_t channel_id;
    uint8_t raw_stream_type;
    uint8_t reserved_02[2];
    uint32_t sequence;
    uint64_t raw_pts;
    uint32_t dsp_payload_address;
    uint32_t type_and_flags;
    uint32_t payload_size;
    uint8_t opaque_1c[0x24];
} yi4k_1107_dsp_video_info;

typedef struct yi4k_1107_frame_desc {
    uint32_t sequence;
    uint32_t reserved_04;
    uint64_t corrected_pts;
    uint8_t type;
    uint8_t flags;
    uint16_t reserved_12;
    uint32_t cpu_payload_address;
    uint32_t payload_size;
    uint32_t opaque_1c;
} yi4k_1107_frame_desc;

#if defined(__cplusplus)
#define YI4K_VIDEO_LAYOUT_ASSERT static_assert
#else
#define YI4K_VIDEO_LAYOUT_ASSERT _Static_assert
#endif
YI4K_VIDEO_LAYOUT_ASSERT(sizeof(yi4k_1107_dsp_video_info)==0x40,"DSP descriptor size");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_dsp_video_info,raw_pts)==8,"raw PTS offset");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_dsp_video_info,dsp_payload_address)==0x10,"raw address offset");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_dsp_video_info,type_and_flags)==0x14,"raw type offset");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_dsp_video_info,payload_size)==0x18,"raw length offset");
YI4K_VIDEO_LAYOUT_ASSERT(sizeof(yi4k_1107_frame_desc)==0x20,"FrameDesc size");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_frame_desc,corrected_pts)==8,"FrameDesc PTS offset");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_frame_desc,type)==0x10,"FrameDesc type offset");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_frame_desc,cpu_payload_address)==0x14,"FrameDesc address offset");
YI4K_VIDEO_LAYOUT_ASSERT(offsetof(yi4k_1107_frame_desc,payload_size)==0x18,"FrameDesc size offset");
#undef YI4K_VIDEO_LAYOUT_ASSERT

#endif
