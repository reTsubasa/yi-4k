#!/usr/bin/env python3
"""Enumerate direct ORC call encodings around feedback copy helpers.

This is a bounded static inventory of relative ``l.jal`` encodings in the
pinned ORC member.  It records every candidate call to the known diagnostic
``smem_2_dram`` helper and the opaque staging helper, then identifies the
already audited feedback/pre-clear windows.  A word-level match is not proof
that the surrounding bytes are executable code; proprietary indirect calls,
DMA/MMIO and runtime dispatch remain outside this inventory.

No ORC is executed and no device is contacted.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from audit_eis_dsp_reference import inventory, DSP, RTOS_SHA, RTOS
from audit_eis_orc_core import CoreDecoder, REF, REF_SHA, sha

ROOT = Path(__file__).resolve().parents[1]
DSP_SHA = "9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73"
MEMBER_OFFSET = 0xA000
TARGETS = {
    0x1A4A04: "smem_2_dram diagnostic helper candidate",
    0x1A14D8: "opaque 4-byte staging helper candidate",
    0x1A14C4: "opaque 128-byte staging helper candidate",
    0xD7454: "stock EIS command function",
}
KNOWN_WINDOWS = {
    "feedback": (0xD7844, 0xD796C),
    "preclear": (0xD7970, 0xD7AC4),
}


def decode_target(word: int, offset: int) -> int | None:
    if word >> 26 != 1:
        return None
    displacement = ((word & 0x03FFFFFF) ^ 0x02000000) - 0x02000000
    return offset + displacement * 4


def in_window(offset: int, window: tuple[int, int]) -> bool:
    return window[0] <= offset < window[1]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-10-eis-orc-feedback-call-sites/audit.json",
    )
    args = parser.parse_args()
    dsp = DSP.read_bytes()
    rtos = RTOS.read_bytes()
    if hashlib.sha256(dsp).hexdigest() != DSP_SHA:
        raise SystemExit("ORC container hash mismatch")
    if hashlib.sha256(rtos).hexdigest() != RTOS_SHA:
        raise SystemExit("RTOS image hash mismatch")
    if hashlib.sha256(REF.read_bytes()).hexdigest() != REF_SHA:
        raise SystemExit("ORC reference hash mismatch")
    member = inventory(dsp)[0]
    member_offset = int(member["offset"], 16)
    size = int(member["bytes"])
    binary = dsp[member_offset:member_offset + size]
    decoder = CoreDecoder(REF.read_text(encoding="utf-8"))

    candidates: list[dict[str, object]] = []
    # The container member is byte-sized and may end with a partial word.
    # Restrict decoding to complete little-endian words so the inventory is
    # deterministic and does not read past the member boundary.
    for offset in range(0, size - (size % 4), 4):
        word = struct.unpack_from("<I", binary, offset)[0]
        target = decode_target(word, offset)
        if target not in TARGETS:
            continue
        candidates.append({
            "member_offset": hex(offset),
            "word_le": hex(word),
            "decoded": decoder.decode(word, offset),
            "target_member_offset": hex(target),
            "target_role": TARGETS[target],
            "window": next((name for name, window in KNOWN_WINDOWS.items()
                             if in_window(offset, window)), None),
        })

    by_target = {name: [] for name in TARGETS.values()}
    for row in candidates:
        by_target[row["target_role"]].append(row["member_offset"])
    feedback_sites = [row for row in candidates if row["window"] in ("feedback", "preclear")]
    report = {
        "evidence_type": "offline full-member ORC relative-call encoding inventory",
        "scope": "word-aligned candidate scan; no ORC execution, runtime dispatch or device access",
        "inputs": {
            "container_sha256": hashlib.sha256(dsp).hexdigest(),
            "orccode_member_offset": hex(member_offset),
            "orccode_member_bytes": size,
            "orccode_member_sha256": sha(binary),
            "rtos_sha256": hashlib.sha256(rtos).hexdigest(),
            "reference_sha256": hashlib.sha256(REF.read_bytes()).hexdigest(),
        },
        "targets": {hex(address): role for address, role in TARGETS.items()},
        "candidate_count": len(candidates),
        "candidate_calls_by_target": by_target,
        "known_feedback_window_candidates": feedback_sites,
        "all_candidates": candidates,
        "interpretation": [
            "Only direct relative l.jal encodings to the selected helper offsets are enumerated.",
            "The feedback and pre-clear windows contain the previously audited smem_2_dram destinations; this does not prove helper completion or the physical destination bytes.",
            "Other candidate calls may be data words or unrelated helper uses; indirect dispatch, proprietary staging and DMA/MMIO are not represented by this scan.",
        ],
        "not_proven": [
            "Non-sentinel shared +0x3c writer identity or runtime execution",
            "ORC program counter/image identity and instruction semantics",
            "External copy completion, cache visibility, atomic publication or safe old-slot reuse",
        ],
        "device_access": False,
        "firmware_executed": False,
        "writes_to_device": False,
    }
    output = args.output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "output": str(output),
        "candidate_count": len(candidates),
        "feedback_window_candidates": len(feedback_sites),
        "device_access": False,
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
