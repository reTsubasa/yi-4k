#!/usr/bin/env python3
"""Emit the statically recovered YI 4K EIS gyro ring contract.

This is an offline report generator.  It reads the retained RTOS image and
does not contact or modify a camera.  The offsets come from the 1.10.52
analysis image and are cross checked against the decompiled producer.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path


BASE = 0xA0100000
RING_BASE = 0xA1702D00
RING_RATE = 0xA0757A90
MAX_SLOTS = 0x84
ARRAY_STRIDE_WORDS = 0x89
EXPECTED_SHA256 = "c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141"


def u32(image: bytes, address: int) -> int:
    off = address - BASE
    if off < 0 or off + 4 > len(image):
        raise ValueError(f"address outside image: {address:#x}")
    return struct.unpack_from("<I", image, off)[0]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", type=Path,
                        nargs="?",
                        default=Path("artifacts/firmware/v1.10.52/_part_lrtos.a9s"))
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    image = args.image.read_bytes()
    digest = hashlib.sha256(image).hexdigest()
    if digest != EXPECTED_SHA256:
        raise SystemExit(f"unexpected RTOS image sha256: {digest}")
    rate = u32(image, RING_RATE)
    # A0506690 is signed integer division toward zero; both operands are
    # positive here.  The producer then multiplies the slot count by four.
    slots = (1000 // rate) * 4
    arrays = []
    names = [
        ("raw_x", 0x000), ("raw_y", 0x089), ("raw_z", 0x112),
        ("bias_x_or_integral_x", 0x19B),
        ("bias_y_or_integral_y", 0x224),
        ("bias_z_or_integral_z", 0x2AD),
        ("rsc_x_or_aux_x", 0x336), ("rsc_y_or_aux_y", 0x3BF),
        ("filtered_z", 0x448),
    ]
    for name, word_offset in names:
        start = RING_BASE + word_offset * 4
        arrays.append({"name": name, "word_offset": hex(word_offset),
                       "start": hex(start),
                       "end_exclusive": hex(start + MAX_SLOTS * 4),
                       "slots": MAX_SLOTS})
    report = {
        "image": str(args.image),
        "sha256": digest,
        "load_base": hex(BASE),
        "producer": {
            "sample_function": "0xA0385780",
            "timer_getter": "0xA048E3F8",
            "sample_tick_field": "0xA1702C40",
            "processed_tick_field": "0xA170AB60",
            "current_index_field": "0xA170AB38",
            "next_write_field": "0xA1702F14",
            "ring_length_field": "0xA1702F10",
            "raw_driver_xyz": ["0xA1702C30", "0xA1702C32", "0xA1702C34"],
        },
        "allocation": {
            "configured_rate_value": rate,
            "formula": "(1000 / configured_rate) * 4",
            "ring_slots_from_image": slots,
            "observed_live_ring_slots": 132,
            "max_slots_from_initialization_loop": MAX_SLOTS,
        },
        "arrays": arrays,
        "write_sequence": [
            "current_index = next_write",
            "store raw X/Y/Z into arrays 0/0x89/0x112",
            "processed_tick = sample_tick",
            "next_write = (next_write + 1) mod ring_length",
            "left_shift raw X/Y/Z by 8 in place",
            "update bias/integral arrays 0x19B/0x224/0x2AD",
        ],
        "frame_events": {
            "sof_callback": {"event_bit": "0x4", "callback": "0xA03974D4",
                              "timestamp": "0xA170BC90", "command": "0x100E"},
            "eof_callback": {"event_bit": "0x8", "callback": "0xA0397500",
                              "timestamp": "0xA170BA84", "command": "0x100D"},
            "sample_timer_event_bit": "0x1",
            "sample_command": "0x100F",
            "per_frame_command": "0x1010",
        },
        "interpretation": [
            "Ring snapshots are not a lossless stream; producer-side copying is required.",
            "The stored values are shifted after the raw write, so a consumer must define the capture point.",
            "The common tick is a software counter; it is not yet an IMU hardware timestamp.",
            "The 1.10.52 image and 1.10.7 device addresses must not be mixed for writes.",
        ],
    }
    output = json.dumps(report, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.write_text(output)
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
