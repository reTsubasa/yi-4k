#!/usr/bin/env python3
"""Audit opaque ORC staging-helper call shapes around EIS shared memory.

The two helper entry points contain proprietary/unsupported words.  This
script records their raw bytes, decodes only standard instructions, and
extracts the bounded argument shapes at direct callers that touch the
recovered ``0x2a20`` shared region.  It does not assign copy direction or
completion semantics to opaque words and never executes ORC.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from audit_eis_dsp_reference import DSP, inventory
from audit_eis_orc_core import CoreDecoder, REF, REF_SHA, sha

ROOT = Path(__file__).resolve().parents[1]
DSP_SHA = "9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73"
MEMBER_START = 0xA000
HELPERS = {
    0x1A14C4: "staging_variant_0x222",
    0x1A14D8: "staging_variant_0x223",
}
HELPER_WINDOWS = {
    0x1A14C4: (0x1A14C4, 0x1A14D8),
    0x1A14D8: (0x1A14D8, 0x1A14EC),
}


def decode_target(word: int, offset: int) -> int | None:
    if word >> 26 != 1:
        return None
    displacement = ((word & 0x03FFFFFF) ^ 0x02000000) - 0x02000000
    return offset + displacement * 4


def decode_context(binary: bytes, decoder: CoreDecoder, offset: int) -> list[str]:
    """Decode since the previous direct call/return, capped at 25 words."""
    out: list[str] = []
    for pos in range(offset - 4, max(-4, offset - 25 * 4), -4):
        text = decoder.decode(struct.unpack_from("<I", binary, pos)[0], pos)
        if text and (text.startswith("l.jal ") or text.startswith("l.jr ")):
            break
        if text:
            out.append(text)
    out.reverse()
    return out


def argument_shape(context: list[str]) -> dict[str, object]:
    """Capture explicit constants/register expressions immediately before call."""
    # Keep only the final assignment-like text for each argument register.  A
    # branch may be in the context; that is retained as control-flow evidence,
    # but we do not attempt to model which side executed.
    last: dict[str, str] = {}
    for text in context:
        for reg in ("r3", "r4", "r5"):
            if text.startswith(f"l.addi {reg},") or text.startswith(f"l.ori {reg},"):
                last[reg] = text
    shape = {
        "r3": last.get("r3"),
        "r4": last.get("r4"),
        "r5": last.get("r5"),
        "shared_0x2a20_literal": any(x in (last.get("r3") or "") or x in (last.get("r4") or "") for x in ["10784"]),
    }
    return shape


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-11-eis-orc-staging-helper-scope/audit.json",
    )
    args = ap.parse_args()

    dsp = DSP.read_bytes()
    ref = REF.read_bytes()
    if sha(dsp) != DSP_SHA or sha(ref) != REF_SHA:
        raise SystemExit("pinned ORC/reference hash mismatch")
    member = inventory(dsp)[0]
    member_offset = int(member["offset"], 16)
    member_size = int(member["bytes"])
    binary = dsp[member_offset : member_offset + member_size]
    decoder = CoreDecoder(ref.decode("utf-8"))

    candidate_lists: dict[str, list[dict[str, object]]] = {name: [] for name in HELPERS.values()}
    for offset in range(0, member_size - member_size % 4, 4):
        target = decode_target(struct.unpack_from("<I", binary, offset)[0], offset)
        if target not in HELPERS:
            continue
        context = decode_context(binary, decoder, offset)
        candidate_lists[HELPERS[target]].append({
            "member_offset": hex(offset),
            "word_le": hex(struct.unpack_from("<I", binary, offset)[0]),
            "decoded": decoder.decode(struct.unpack_from("<I", binary, offset)[0], offset),
            "arguments": argument_shape(context),
            "context": context,
        })

    helper_body: dict[str, object] = {}
    for target, name in HELPERS.items():
        start, end = HELPER_WINDOWS[target]
        rows = []
        opaque = []
        visible_memory = []
        for offset in range(start, end, 4):
            word = struct.unpack_from("<I", binary, offset)[0]
            text = decoder.decode(word, offset)
            row = {"member_offset": hex(offset), "word_le": hex(word), "bytes": binary[offset:offset + 4].hex(), "decoded": text}
            rows.append(row)
            if text is None:
                opaque.append(row)
            if text and any(op in text for op in ("l.sw", "l.sb", "l.sh", "l.swa", "l.swz", "l.lwz", "l.lbz", "l.lhz", "l.mfspr", "l.mtspr")):
                visible_memory.append(row)
        helper_body[name] = {
            "entry": hex(target),
            "window": [hex(start), hex(end)],
            "rows": rows,
            "opaque_word_count": len(opaque),
            "visible_memory_or_spr_instructions": visible_memory,
        }

    shared_calls = []
    for name, rows in candidate_lists.items():
        for row in rows:
            if row["arguments"]["shared_0x2a20_literal"]:
                shared_calls.append({"helper": name, **row})

    report = {
        "evidence_type": "offline ORC opaque staging-helper parameter and write-set boundary",
        "scope": "direct relative caller inventory and raw helper windows; no ORC execution, runtime dispatch or device access",
        "inputs": {
            "container_sha256": sha(dsp),
            "reference_sha256": sha(ref),
            "orccode_member_offset": hex(member_offset),
            "orccode_member_bytes": member_size,
            "orccode_member_sha256": sha(binary),
        },
        "candidate_counts": {name: len(rows) for name, rows in candidate_lists.items()},
        "shared_0x2a20_calls": shared_calls,
        "helper_body": helper_body,
        "bounded_findings": [
            "Direct caller inventory finds exactly five staging-helper calls with an explicit 0x2a20 literal in the final r3/r4 argument assignments: 0x1a14d8 at 0xd78e4 and 0xd7a90; 0x1a14c4 at 0xd76b8, 0xd78b4 and 0xd7930.",
            "The five callers use different lengths/target expressions (4, 64, 80), so the 0x2a20 literal alone does not identify direction, feedback, or completion ownership.",
            "The 0x1a14c4 and 0x1a14d8 windows each contain two unsupported words between visible argument preconditioning and jr r9; no standard load/store, SPR access, branch, or call is decoded in either body window.",
            "The two helper variants differ in the raw opaque opcode word (0xf1e30222 versus 0xf1e30223); this is an observation, not a decoded direction or barrier meaning.",
            "No visible helper-body write set reaches shared+0x3c; determining the destination and completion semantics requires proprietary opcode/transport evidence outside this static decoder.",
        ],
        "not_proven": [
            "Copy direction, physical destination, DMA/MMIO side effects or completion ordering",
            "Cache flush/invalidate, atomic publication, hardware latch or old-slot release",
            "Whether each 0x2a20 caller is part of the EIS path at runtime",
            "Whether indirect dispatch invokes a helper variant not represented by direct l.jal encodings",
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
        "candidate_counts": report["candidate_counts"],
        "shared_0x2a20_call_count": len(shared_calls),
        "device_access": False,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
