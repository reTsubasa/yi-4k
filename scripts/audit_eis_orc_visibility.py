#!/usr/bin/env python3
"""Scan the pinned ORC member for architectural visibility instructions.

This is a bounded static negative audit.  It checks the complete selected ORC
member for the OpenRISC ``l.msync``, ``l.psync`` and ``l.csync`` encodings and
records the opaque ``l.rfe``-pattern words in the EIS feedback windows.  A
missing architectural sync opcode does not rule out proprietary staging,
DMA, cache or hardware-latch semantics, and the scan does not execute ORC.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from audit_eis_dsp_reference import DSP, DSP_SHA, inventory

ROOT = Path(__file__).resolve().parents[1]
WINDOWS = {
    "feedback": (0xD7844, 0xD796C),
    "preclear": (0xD7970, 0xD7AC4),
    "copy_helpers": (0x1A14C4, 0x1A1608),
}
SYNC_PATTERNS = {
    "l.msync": (0xFFFF0000, 0x22000000),
    "l.psync": (0xFFFF0000, 0x22800000),
    "l.csync": (0xFFFF0000, 0x23000000),
}
RFE_PATTERN = (0xFFFF0000, 0xF0000000)


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def words(data: bytes):
    for offset in range(0, len(data) - 3, 4):
        yield offset, struct.unpack_from("<I", data, offset)[0]


def matching(data: bytes, mask: int, value: int, base: int = 0) -> list[dict[str, str]]:
    return [
        {"member_offset": hex(base + offset), "word_le": hex(word)}
        for offset, word in words(data)
        if word & mask == value
    ]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-10-eis-orc-visibility/audit.json",
    )
    args = parser.parse_args()

    container = DSP.read_bytes()
    if digest(container) != DSP_SHA:
        raise SystemExit("pinned DSP container hash mismatch")
    members = inventory(container)
    if not members:
        raise SystemExit("no ORC member found")
    member = members[0]
    start = int(member["offset"], 16)
    size = int(member["bytes"])
    binary = container[start : start + size]
    if digest(binary) != member["sha256"]:
        raise SystemExit("selected ORC member hash mismatch")

    sync_hits = {
        name: matching(binary, mask, value)
        for name, (mask, value) in SYNC_PATTERNS.items()
    }
    rfe_hits = matching(binary, *RFE_PATTERN)
    window_rows = {}
    for name, (begin, end) in WINDOWS.items():
        window = binary[begin:end]
        window_rows[name] = {
            "range": [hex(begin), hex(end)],
            "words": (end - begin) // 4,
            "sync_hits": {
                key: matching(window, mask, value, begin)
                for key, (mask, value) in SYNC_PATTERNS.items()
            },
            "rfe_pattern_hits": matching(window, *RFE_PATTERN, begin),
            "sha256": digest(window),
        }

    report = {
        "evidence_type": "offline full-member ORC architectural visibility opcode scan",
        "container_sha256": digest(container),
        "member": {
            "name": member.get("name"),
            "offset": hex(start),
            "bytes": size,
            "sha256": digest(binary),
        },
        "scan": {
            "word_alignment": 4,
            "member_words": len(binary) // 4,
            "architectural_sync_patterns": sync_hits,
            "architectural_sync_total": sum(len(items) for items in sync_hits.values()),
            "rfe_pattern_total": len(rfe_hits),
            "rfe_pattern_note": "l.rfe encoding-pattern matches are retained as opaque words; reserved lower bits are not assigned a completion meaning",
        },
        "windows": window_rows,
        "conclusion": {
            "no_architectural_sync_in_member": sum(len(items) for items in sync_hits.values()) == 0,
            "scope": "complete selected member, aligned word scan",
            "does_not_prove": [
                "proprietary staging or code_dma completion",
                "cache visibility, atomic publication or hardware latch",
                "DSP runtime PC or exact loaded microcode identity",
                "safe reuse of state slots, warp tables or scratch banks",
            ],
        },
        "device_access": False,
        "orc_executed": False,
        "writes_to_device": False,
    }
    output = args.output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "output": str(output),
        "member_words": report["scan"]["member_words"],
        "architectural_sync_total": report["scan"]["architectural_sync_total"],
        "rfe_pattern_total": report["scan"]["rfe_pattern_total"],
        "device_access": False,
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
