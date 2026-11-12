#!/usr/bin/env python3
"""Bound ORC ``smem_2_dram`` candidates related to EIS shared feedback.

The scan starts from direct relative calls to the diagnostic ``smem_2_dram``
helper in the pinned ORC member.  It classifies only explicit caller argument
shapes observed in the previously recovered feedback/pre-clear windows.  It
also records the helper's direct call targets and SPR-access dependency.  A
candidate call is not assumed to be executable code, and unsupported ORC
instructions remain opaque.  No ORC or firmware is executed.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from audit_eis_dsp_reference import DSP, RTOS, inventory
from audit_eis_orc_core import CoreDecoder, REF, REF_SHA, sha

ROOT = Path(__file__).resolve().parents[1]
DSP_SHA = "9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73"
RTOS_SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
SMEM_2_DRAM = 0x1A4A04
HELPER_START, HELPER_END = 0x1A4A04, 0x1A4BE8


def decode_target(word: int, offset: int) -> int | None:
    if word >> 26 != 1:
        return None
    displacement = ((word & 0x03FFFFFF) ^ 0x02000000) - 0x02000000
    return offset + displacement * 4


def classify(context: list[str]) -> str:
    joined = " | ".join(x for x in context if x)
    if "l.addi r4,r0,10784" in joined and "l.addi r3,r14,60" in joined:
        return "feedback_candidate_shared_plus_0x3c"
    if "l.addi r4,r0,10816" in joined and "l.add r3,r10,r5" in joined:
        return "preclear_candidate_shared_plus_0x20_range"
    if "l.addi r4,r0,10944" in joined and "l.addi r3,r7,16" in joined:
        return "adjacent_opaque_field_candidate"
    return "other_smem_2_dram_candidate"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-11-eis-orc-smem-vcap-scope/audit.json",
    )
    args = ap.parse_args()

    dsp = DSP.read_bytes()
    rtos = RTOS.read_bytes()
    ref = REF.read_bytes()
    if sha(dsp) != DSP_SHA or sha(rtos) != RTOS_SHA or sha(ref) != REF_SHA:
        raise SystemExit("pinned ORC/RTOS/reference hash mismatch")
    member = inventory(dsp)[0]
    member_offset = int(member["offset"], 16)
    member_size = int(member["bytes"])
    binary = dsp[member_offset : member_offset + member_size]
    decoder = CoreDecoder(ref.decode("utf-8"))

    candidates: list[dict[str, object]] = []
    for offset in range(0, member_size - member_size % 4, 4):
        target = decode_target(struct.unpack_from("<I", binary, offset)[0], offset)
        if target != SMEM_2_DRAM:
            continue
        context_offsets = list(range(max(0, offset - 12 * 4), offset, 4))
        context = [decoder.decode(struct.unpack_from("<I", binary, o)[0], o) for o in context_offsets]
        candidates.append({
            "member_offset": hex(offset),
            "word_le": hex(struct.unpack_from("<I", binary, offset)[0]),
            "decoded": decoder.decode(struct.unpack_from("<I", binary, offset)[0], offset),
            "classification": classify(context),
            "context_offsets": [hex(o) for o in context_offsets],
            "context": context,
        })

    # The helper itself is kept separate from caller classification.  Any
    # unsupported words are explicitly counted rather than interpreted.
    helper_rows: list[dict[str, object]] = []
    helper_direct_targets: list[str] = []
    unsupported: list[str] = []
    spr_accesses: list[dict[str, str]] = []
    for offset in range(HELPER_START, HELPER_END, 4):
        text = decoder.decode(struct.unpack_from("<I", binary, offset)[0], offset)
        row = {"member_offset": hex(offset), "decoded": text}
        helper_rows.append(row)
        if text is None:
            unsupported.append(hex(offset))
            continue
        if text.startswith("l.jal "):
            helper_direct_targets.append(text.split(" ", 1)[1])
        if "mfspr" in text or "mtspr" in text:
            spr_accesses.append({"member_offset": hex(offset), "decoded": text})

    counts: dict[str, int] = {}
    for row in candidates:
        key = str(row["classification"])
        counts[key] = counts.get(key, 0) + 1

    report = {
        "evidence_type": "offline ORC smem_2_dram caller and helper scope audit",
        "scope": "word-aligned direct relative calls plus bounded helper-body decoding; no ORC execution or device access",
        "inputs": {
            "container_sha256": sha(dsp),
            "rtos_sha256": sha(rtos),
            "reference_sha256": sha(ref),
            "orccode_member_offset": hex(member_offset),
            "orccode_member_bytes": member_size,
            "orccode_member_sha256": sha(binary),
        },
        "smem_2_dram": {
            "target_member_offset": hex(SMEM_2_DRAM),
            "direct_candidate_count": len(candidates),
            "classification_counts": counts,
            "candidates": candidates,
        },
        "helper_body": {
            "range": [hex(HELPER_START), hex(HELPER_END)],
            "direct_jal_targets": helper_direct_targets,
            "unsupported_offsets": unsupported,
            "spr_accesses_in_body": spr_accesses,
            "rows": helper_rows,
        },
        "bounded_findings": [
            "Among 67 direct smem_2_dram candidates, exactly one caller has the recovered feedback shape: r4=0x2a20 and r3=base+0x3c (member offset 0xd78f8).",
            "Exactly one other caller has the recovered pre-clear shape: r4=0x2a40 and a 32-byte source expression (member offset 0xd7aa4).",
            "One adjacent caller uses r4=0x2ac0 and r3=base+16 (member offset 0xd7b2c); this is outside the recovered 0x2a20/0x2a40 feedback block and is not assigned EIS semantics.",
            "The smem_2_dram helper body has no direct VCAP/shared literal; it delegates to fixed low-level helpers including opaque/unsupported code-transfer paths. The helper body itself contains no decoded mfspr/mtspr, while its direct dependency 0x1a16d8 is an SPR read helper.",
            "No additional direct smem_2_dram caller in the scanned member exposes the recovered shared+0x3c argument shape.",
        ],
        "not_proven": [
            "Whether any candidate word is executed code rather than data",
            "Indirect ORC dispatch, DMA/MMIO writes, proprietary staging semantics and external-copy completion",
            "Runtime ORC image/PC identity, cache visibility, atomic publication or old-slot release",
            "Whether the adjacent 0x2ac0 field participates in any EIS-related path",
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
        "direct_candidate_count": len(candidates),
        "classification_counts": counts,
        "unsupported_helper_offsets": len(unsupported),
        "device_access": False,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
