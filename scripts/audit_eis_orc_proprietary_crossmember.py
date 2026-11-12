#!/usr/bin/env python3
"""Cross-compare opaque ORC transfer words across all DSP members.

The audit is intentionally conservative: it counts exact words and bounded
adjacent pairs, decodes only the already pinned orccode member with the
existing limited decoder, and never assigns semantics to proprietary words.
No ORC execution or device access is performed.
"""
from __future__ import annotations

import argparse
import json
import struct
from pathlib import Path

from audit_eis_dsp_reference import DSP, inventory
from audit_eis_orc_core import CoreDecoder, REF, REF_SHA, sha

ROOT = Path(__file__).resolve().parents[1]
DSP_SHA = "9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73"
ORCCODE_SHA = "9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6"
FENCE = 0xF0000049
FAMILY_MASK = 0xFFFF0000
FC60_BASE = 0xFC600000
F1E3_BASE = 0xF1E30000
LOCAL_START, LOCAL_END = 0x1A14C4, 0x1A1688


def words(data: bytes) -> list[int]:
    return [struct.unpack_from("<I", data, p)[0] for p in range(0, len(data) - len(data) % 4, 4)]


def family(word: int) -> str | None:
    if word & FAMILY_MASK == FC60_BASE:
        return "fc60"
    if word & FAMILY_MASK == F1E3_BASE:
        return "f1e3"
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-11-eis-orc-proprietary-crossmember/audit.json",
    )
    args = ap.parse_args()

    dsp = DSP.read_bytes()
    ref = REF.read_bytes()
    if sha(dsp) != DSP_SHA or sha(ref) != REF_SHA:
        raise SystemExit("pinned DSP/reference hash mismatch")
    entries = inventory(dsp)
    summary = {}
    all_pairs = []
    for entry in entries:
        start = int(entry["offset"], 16)
        payload = dsp[start : start + int(entry["bytes"])]
        ws = words(payload)
        fence_offsets = [i * 4 for i, w in enumerate(ws) if w == FENCE]
        fc_offsets = [i * 4 for i, w in enumerate(ws) if family(w) == "fc60"]
        f1_offsets = [i * 4 for i, w in enumerate(ws) if family(w) == "f1e3"]
        pairs = []
        for i in range(1, len(ws)):
            if ws[i] == FENCE and family(ws[i - 1]):
                pairs.append({
                    "offset": hex((i - 1) * 4),
                    "preceding_word": hex(ws[i - 1]),
                    "fence_word": hex(ws[i]),
                })
        summary[entry["name"]] = {
            "sha256": entry["sha256"],
            "bytes": entry["bytes"],
            "f0000049_count": len(fence_offsets),
            "fc60_family_count": len(fc_offsets),
            "f1e3_family_count": len(f1_offsets),
            "fc60_or_f1e3_then_fence_pairs": len(pairs),
            "pair_examples": pairs[:80],
        }
        all_pairs.extend({"member": entry["name"], **p} for p in pairs)

    orc = next(e for e in entries if e["name"] == "orccode.bin")
    start = int(orc["offset"], 16)
    payload = dsp[start : start + int(orc["bytes"])]
    decoder = CoreDecoder(ref.decode("utf-8"))
    local = []
    for offset in range(LOCAL_START, LOCAL_END, 4):
        word = struct.unpack_from("<I", payload, offset)[0]
        if family(word) or word == FENCE:
            context = []
            for c in range(max(0, offset - 8 * 4), min(len(payload), offset + 12 * 4), 4):
                cw = struct.unpack_from("<I", payload, c)[0]
                context.append({"offset": hex(c), "word_le": hex(cw), "decoded": decoder.decode(cw, c)})
            local.append({"offset": hex(offset), "word_le": hex(word), "family": family(word) or "fence", "context": context})

    local_pairs = [p for p in all_pairs if p["member"] == "orccode.bin" and LOCAL_START <= int(p["offset"], 16) < LOCAL_END]
    local_word_counts = {}
    for item in local:
        local_word_counts[item["word_le"]] = local_word_counts.get(item["word_le"], 0) + 1

    report = {
        "evidence_type": "offline cross-member comparison of opaque ORC transfer-word patterns",
        "scope": "Exact word/fence counts across all four DSP members and bounded decoding of the local orccode transfer cluster; no ORC execution or device access.",
        "inputs": {
            "container_sha256": sha(dsp),
            "reference_sha256": sha(ref),
            "orccode_sha256": sha(payload),
            "fence_word": hex(FENCE),
            "family_masks": {"fc60": hex(FC60_BASE), "f1e3": hex(F1E3_BASE), "mask": hex(FAMILY_MASK)},
        },
        "member_summary": summary,
        "local_transfer_cluster": {
            "range": [hex(LOCAL_START), hex(LOCAL_END)],
            "word_counts": local_word_counts,
            "family_or_fence_records": local,
            "family_then_fence_pairs": local_pairs,
        },
        "bounded_findings": [
            "F0000049, FC60xxxx, and F1E3xxxx patterns occur in orccode.bin only; the other three DSP members have zero exact fence words and zero words in both selected families.",
            "Within the local transfer cluster, F0000049 follows several distinct FC60 and F1E3 words, including F1E30222, F1E30223, F1E32222, FC60001C, FC600008, FC606E06, and FC606F87. Repetition establishes a shared encoding/fence pattern, not a decoded operation.",
            "Some local FC60 words are followed by a return, while loop variants are followed by branch/count instructions. This excludes treating F0000049 as a universally visible function return; it does not identify whether it is a completion, issue, or serialization instruction.",
            "The local cluster also contains F1E30223 at 0x1a14f4 without an immediately following F0000049, so the presence of the fence word is not invariant across all staging-like variants.",
            "Cross-member repetition provides no independent semantic anchor for direction, DMA/MMIO target, cache maintenance, or completion; those meanings remain hidden in proprietary words or runtime hardware state.",
        ],
        "not_proven": [
            "Meaning or operand format of F0000049, FC60xxxx, and F1E3xxxx",
            "Whether any word is executable code versus data outside the bounded orccode cluster",
            "DMA/MMIO register targets, transfer direction, error, completion, cache or atomic semantics",
            "Runtime ORC identity, PC, dispatch and timing",
            "Whether F0000049 is a fence, issue, wait, return-adjacent marker, or another operation",
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
        "members": len(entries),
        "all_pairs": len(all_pairs),
        "local_records": len(local),
        "device_access": False,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
