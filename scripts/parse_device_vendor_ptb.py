#!/usr/bin/env python3
"""Parse the Ambarella/YI VENDOR_DATA PTB captured from one device.

The format is recovered from the public YI A9 bootloader and checked against
the device bytes.  This is a read-only offline parser; it never writes a
device image and deliberately keeps fields whose meaning is not established
as ``unknown``.
"""
from __future__ import annotations

import argparse
import binascii
import hashlib
import json
import struct
from pathlib import Path

RECORD_BASE = 0x08
RECORD_SIZE = 0x40
RECORD_COUNT = 13
PTB_SIZE = 0x350
CRC_OFFSET = 0x350
ERASE_BLOCK = 0x20000

# The first string in each 32-byte name window is the partition represented by
# that record.  The remaining bytes contain adjacent names and may be clipped;
# they are retained as evidence rather than treated as fields.
EXPECTED_NAMES = [
    "VENDOR_DATA", "SYS_SW", "DSP_uCode", "SYS_DATA", "LINUX_Kernel",
    "LINUX_RFS", "LINUX_HIBER_IMG", "VIDEO_REC_IDX", "CALIB",
    "USER_SETTING", "DRIVE_A", "DRIVE_B", "RESERVED",
]

MTD_SIZES = {
    "VENDOR_DATA": 0x00020000,
    "SYS_SW": 0x02000000,
    "DSP_uCode": 0x00500000,
    "SYS_DATA": 0x01400000,
    "LINUX_Kernel": 0x00A00000,
    "LINUX_RFS": 0x03C00000,
    "LINUX_HIBER_IMG": 0x01E00000,
    "VIDEO_REC_IDX": 0x01980000,
    "CALIB": 0x00280000,
    "USER_SETTING": 0x001C0000,
    "DRIVE_A": 0x00680000,
    "DRIVE_B": 0x00680000,
    "RESERVED": 0x03580000,
}

# Linux's /proc/mtd values are logical exported spans.  The Ambarella NAND
# parser leaves a fixed hidden gap between most physical PTB spans, and some
# user-data entries are rounded to a larger exposed region.  Keep these values
# only for comparison; do not silently equate them with PTB partition_size.
LINUX_MTD_SIZES = {
    "VENDOR_DATA": 0x00020000, "SYS_SW": 0x02000000,
    "DSP_uCode": 0x00500000, "SYS_DATA": 0x01400000,
    "LINUX_Kernel": 0x00A00000, "LINUX_RFS": 0x03C00000,
    "LINUX_HIBER_IMG": 0x01E00000, "VIDEO_REC_IDX": 0x01980000,
    "CALIB": 0x00280000, "USER_SETTING": 0x001C0000,
    "DRIVE_A": 0x00680000, "DRIVE_B": 0x00680000,
    "RESERVED": 0x03580000,
}


def strings_in_window(window: bytes) -> list[str]:
    out: list[str] = []
    for raw in window.split(b"\0"):
        if raw:
            out.append(raw.decode("ascii", "replace"))
    return out


def parse(path: Path) -> dict:
    data = path.read_bytes()
    if len(data) < CRC_OFFSET + 4:
        raise ValueError(f"capture is too short: {len(data)}")
    digest = hashlib.sha256(data).hexdigest()
    stored_crc = struct.unpack_from("<I", data, CRC_OFFSET)[0]
    computed_crc = binascii.crc32(data[:PTB_SIZE]) & 0xFFFFFFFF
    records = []
    previous_end = None
    for index in range(RECORD_COUNT):
        off = RECORD_BASE + index * RECORD_SIZE
        window = data[off:off + 0x20]
        vals = struct.unpack_from("<8I", data, off + 0x20)
        name_list = strings_in_window(window)
        name = name_list[0] if name_list else ""
        attr, alloc_size, block_count, start_block, mem_addr, actual_size, unknown38, crc = vals
        physical_offset = start_block * ERASE_BLOCK
        expected_size = MTD_SIZES.get(name)
        linux_mtd_size = LINUX_MTD_SIZES.get(name)
        record = {
            "index": index,
            "offset": f"0x{off:04x}",
            "name": name,
            "name_window_strings": name_list,
            "name_window_hex": window.hex(),
            "attribute": f"0x{attr:08x}",
            "partition_size": alloc_size,
            "block_count": block_count,
            "start_block": start_block,
            "physical_offset": physical_offset,
            "mem_addr": f"0x{mem_addr:08x}",
            "actual_size": actual_size,
            "unknown_0x38": f"0x{unknown38:08x}",
            "data_crc32": f"0x{crc:08x}",
            "mtd_size_matches": expected_size is None or expected_size == alloc_size,
            "partition_span_end": physical_offset + alloc_size,
            "linux_mtd_reported_size": linux_mtd_size,
            "linux_mtd_size_relation": (
                "same" if linux_mtd_size == alloc_size else
                "logical_export_differs" if linux_mtd_size is not None else "unknown"
            ),
        }
        if previous_end is not None:
            record["follows_previous_without_gap"] = physical_offset == previous_end
        previous_end = physical_offset + alloc_size
        records.append(record)

    post = struct.unpack_from("<I", data, 0x354)[0] if len(data) >= 0x358 else None
    return {
        "source": str(path),
        "bytes": len(data),
        "sha256": digest,
        "format": {
            "record_base": "0x00000008",
            "record_size": "0x40",
            "record_count": RECORD_COUNT,
            "ptb_bytes_before_crc": PTB_SIZE,
            "crc_offset": "0x350",
            "erase_block": ERASE_BLOCK,
            "crc_algorithm": "zlib/IEEE CRC32 over bytes [0, 0x350)",
        },
        "ptb_crc": {
            "stored": f"0x{stored_crc:08x}",
            "computed": f"0x{computed_crc:08x}",
            "matches": stored_crc == computed_crc,
        },
        "records": records,
        "expected_record_names": EXPECTED_NAMES,
        "record_names_match": [r["name"] for r in records] == EXPECTED_NAMES,
        "after_ptb": {
            "word_at_0x354": None if post is None else f"0x{post:08x}",
            "interpretation": "outside PTB CRC coverage; not assigned a bootloader meaning",
        },
        "unknowns": [
            "The two BOOTSTRAP/BOOTLOADER name strings occur in clipped name windows but have no separate numeric record in this 0x350 PTB.",
            "unknown_0x38 is preserved verbatim; this pass does not assign it a semantic name.",
            "Linux MTD exposes logical data partitions; hidden bootstrap/bootloader NAND regions and OOB remain unobserved.",
        ],
    }


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path)
    ap.add_argument("--output", type=Path, required=True)
    args = ap.parse_args()
    result = parse(args.input)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"ptb_crc_matches": result["ptb_crc"]["matches"], "records": len(result["records"]), "sha256": result["sha256"]}))


if __name__ == "__main__":
    main()
