#!/usr/bin/env python3
"""Bound the visible dependency surface of the ORC smem_2_dram path.

This is a storage-only audit.  It decodes the pinned ORC member with the
existing limited decoder, records direct calls and visible memory/SPR
operations in bounded windows, and keeps proprietary transfer words opaque.
It does not execute ORC, infer DMA/MMIO semantics, or access a device.
"""
from __future__ import annotations

import argparse
import json
import re
import struct
from pathlib import Path

from audit_eis_dsp_reference import DSP, inventory
from audit_eis_orc_core import CoreDecoder, REF, REF_SHA, sha

ROOT = Path(__file__).resolve().parents[1]
DSP_SHA = "9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73"
MEMBER_SHA = "9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6"
MEMBER_START = 0xA000

WINDOWS = {
    "smem_2_dram": (0x1A4A04, 0x1A4BEC),
    "spr_read_helper": (0x1A16D8, 0x1A16EC),
    "return_link_helper": (0x1A16E4, 0x1A16EC),
    "descriptor_prepare": (0x1A1528, 0x1A155C),
    "opaque_descriptor_transfer": (0x1A6EF4, 0x1A6F34),
    "opaque_copy_loop": (0x1A15D4, 0x1A1608),
    "error_staging": (0x1A0BFC, 0x1A0C34),
    "error_flag_write": (0x19FD94, 0x19FDB8),
    "error_flag_set": (0x19FCAC, 0x19FD38),
}

MEMORY_RE = re.compile(r"l\\.(?:lwz|lbz|lhz|l\\.sw|sb|sh|swa|swz) ")


def decode_target(word: int, offset: int) -> int | None:
    if word >> 26 != 1:
        return None
    displacement = ((word & 0x03FFFFFF) ^ 0x02000000) - 0x02000000
    return offset + displacement * 4


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-11-eis-orc-transfer-dependencies/audit.json",
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
    if sha(binary) != MEMBER_SHA:
        raise SystemExit("pinned ORC member hash mismatch")
    decoder = CoreDecoder(ref.decode("utf-8"))

    windows: dict[str, dict[str, object]] = {}
    for name, (start, end) in WINDOWS.items():
        rows = []
        unsupported = []
        direct_calls = []
        visible_memory = []
        spr_accesses = []
        non_stack_stores = []
        for offset in range(start, end, 4):
            word = struct.unpack_from("<I", binary, offset)[0]
            text = decoder.decode(word, offset)
            row = {
                "member_offset": hex(offset),
                "word_le": hex(word),
                "decoded": text,
            }
            rows.append(row)
            if text is None:
                unsupported.append({"member_offset": hex(offset), "word_le": hex(word)})
                continue
            if text.startswith("l.jal "):
                target = int(text.split("0x", 1)[1], 16)
                direct_calls.append({"member_offset": hex(offset), "target": hex(target)})
            if "mfspr" in text or "mtspr" in text:
                spr_accesses.append({"member_offset": hex(offset), "instruction": text})
            if text.startswith(("l.lwz ", "l.lbz ", "l.lhz ", "l.sw ", "l.sb ", "l.sh ", "l.swa ", "l.swz ")):
                visible_memory.append({"member_offset": hex(offset), "instruction": text})
                if "(r1)" not in text and "(r2)" not in text:
                    non_stack_stores.append({"member_offset": hex(offset), "instruction": text})
        windows[name] = {
            "range": [hex(start), hex(end)],
            "rows": rows,
            "unsupported": unsupported,
            "direct_calls": direct_calls,
            "visible_memory": visible_memory,
            "spr_accesses": spr_accesses,
            "non_stack_memory": non_stack_stores,
        }

    smem_calls = windows["smem_2_dram"]["direct_calls"]
    direct_targets = sorted({c["target"] for c in smem_calls})
    success_targets = ["0x1a16d8", "0x1a16e4", "0x1a1528", "0x1a6ef4", "0x1a15d4"]
    diagnostic_targets = [t for t in direct_targets if t not in success_targets]
    report = {
        "evidence_type": "offline bounded ORC smem_2_dram dependency and visible-side-effect audit",
        "scope": "Pinned ORC member windows only; unsupported transfer words remain opaque; no ORC execution or device access.",
        "inputs": {
            "container_sha256": sha(dsp),
            "reference_sha256": sha(ref),
            "orccode_member_offset": hex(member_offset),
            "orccode_member_bytes": member_size,
            "orccode_member_sha256": sha(binary),
        },
        "smem_2_dram_direct_targets": {
            "all": direct_targets,
            "success_path_candidates": success_targets,
            "diagnostic_or_error_candidates": diagnostic_targets,
        },
        "windows": windows,
        "bounded_findings": [
            "The visible smem_2_dram body has direct calls to fixed helpers; the success-loop set is 0x1a16d8, 0x1a16e4, 0x1a1528, 0x1a6ef4, and 0x1a15d4, while the remaining calls are on alignment/error/diagnostic branches.",
            "The only decoded SPR operation in the selected success dependency windows is l.mfspr in 0x1a16d8; no decoded mtspr appears. This identifies a SPR read dependency, not a DMA/MMIO or completion register.",
            "The descriptor and copy-loop windows contain unsupported proprietary words at the transfer points. Visible surrounding arithmetic establishes alignment/chunk preparation and loop control, but not transfer direction, hardware destination, completion, or ordering.",
            "No decoded success-path instruction in the bounded windows names a VCAP/shared address literal or a standard MMIO load/store. This is a bounded negative result; proprietary words and indirect hardware transports remain outside the decoder.",
            "The smem_2_dram body contains a visible non-stack store at r5+132 in the common prologue after r5 is formed as zero, before the alignment/zero-length gates; its runtime address and ownership are not assigned from this static window.",
        ],
        "not_proven": [
            "Proprietary opcode semantics, DMA/MMIO registers or physical destinations",
            "Whether each direct target is executed on the EIS path at runtime",
            "Transfer completion, cache visibility, atomic publication or old-slot/table release",
            "Indirect dispatch and any code outside the bounded windows",
            "Runtime ORC identity, PC, timing and correspondence to a particular frame",
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
        "smem_direct_targets": direct_targets,
        "success_target_count": len(success_targets),
        "device_access": False,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
