#!/usr/bin/env python3
"""Cross-check fixed ARM references around the EIS shared feedback block.

This audit is deliberately bounded.  It combines the pinned ARM bytes with
the full Ghidra reference/call exports to enumerate direct references to the
two-slot publication block, callers of the CPU shared-state helper and the
explicit CPU ``+0x3c`` store/load.  It cannot see an indirect DSP/MMIO writer
or assign runtime ownership to a translated address.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis"
IMAGE = ANALYSIS / "rtos-window.bin"
REFERENCES = ANALYSIS / "full/references.tsv"
CALLS = ANALYSIS / "full/calls.tsv"
BASE = 0xA0100000
IMAGE_SHA256 = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
PUBLICATION = 0xA0699160
FEEDBACK_ALIAS = PUBLICATION + 0x3C
STATUS_START = 0xA06990E0
STATUS_END = PUBLICATION
CPU_HELPER = 0xA02C61D4

EXPECTED = {
    0xA02C61EC: ("ldr", "r0, [r3, #0x58]"),
    0xA02C6204: ("bl", "#0xa04a3bd4"),
    0xA02C6214: ("str", "r3, [r0, #0x3c]"),
    0xA02C6260: ("ldr", "r3, [r0, #0x3c]"),
    0xA02C60DC: ("str", "r0, [r7, #0x80]"),
}


def parse_edges(path: Path, target_index: int) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    if not path.is_file():
        return rows
    for raw in path.read_text(encoding="utf-8").splitlines():
        fields = raw.split("\t")
        if len(fields) <= target_index:
            continue
        try:
            values = [int(fields[index], 16) for index in range(min(3, len(fields)))]
        except ValueError:
            continue
        if values[target_index] == CPU_HELPER:
            rows.append({
                "from": f"0x{values[0]:08X}",
                "site": f"0x{values[1]:08X}" if len(values) > 1 else "",
                "to": f"0x{values[target_index]:08X}",
                "type": fields[3] if len(fields) > 3 else (fields[2] if len(fields) > 2 else ""),
            })
    return rows


def parse_references() -> dict[str, object]:
    result = {
        "available": REFERENCES.is_file(),
        "publication_refs": [],
        "feedback_alias_refs": [],
        "status_block_refs": [],
    }
    if not REFERENCES.is_file():
        return result
    for raw in REFERENCES.read_text(encoding="utf-8").splitlines():
        fields = raw.split("\t")
        if len(fields) < 2:
            continue
        try:
            source, target = int(fields[0], 16), int(fields[1], 16)
        except ValueError:
            continue
        row = {
            "from": f"0x{source:08X}",
            "to": f"0x{target:08X}",
            "type": fields[2] if len(fields) > 2 else "",
        }
        if target == PUBLICATION:
            result["publication_refs"].append(row)
        if target == FEEDBACK_ALIAS:
            result["feedback_alias_refs"].append(row)
        if STATUS_START <= target <= STATUS_END:
            result["status_block_refs"].append(row)
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-10-eis-shared-feedback-refs/audit.json",
    )
    args = parser.parse_args()
    image = IMAGE.read_bytes()
    digest = hashlib.sha256(image).hexdigest()
    if digest != IMAGE_SHA256:
        raise SystemExit("pinned RTOS image hash mismatch")

    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in EXPECTED.items():
        decoded = list(cs.disasm(image[address - BASE : address - BASE + 4], address))
        if len(decoded) != 1:
            raise SystemExit(f"unable to decode {address:#x}")
        ins = decoded[0]
        actual = (ins.mnemonic, ins.op_str)
        if actual != expected:
            raise SystemExit(f"{address:#x}: {actual!r} != {expected!r}")
        checks.append({
            "address": f"0x{address:08X}",
            "bytes": ins.bytes.hex(),
            "instruction": f"{ins.mnemonic} {ins.op_str}",
        })

    references = parse_references()
    callers = parse_edges(CALLS, 2)
    # The full call export contains two calls from the large focused function;
    # retain every matching row rather than assuming a fixed caller count.
    report = {
        "evidence_type": "offline fixed ARM/shared-feedback reference and call-graph audit",
        "image": {"path": str(IMAGE.relative_to(ROOT)), "base": hex(BASE), "sha256": digest},
        "addresses": {
            "publication_word": hex(PUBLICATION),
            "feedback_alias_plus_0x3c": hex(FEEDBACK_ALIAS),
            "status_block": [hex(STATUS_START), hex(STATUS_END)],
            "cpu_shared_state_helper": hex(CPU_HELPER),
        },
        "instruction_checks": checks,
        "reference_index": references,
        "call_graph": {
            "helper_call_rows": callers,
            "helper_call_count": len(callers),
        },
        "bounded_findings": {
            "publication_reference_count": len(references["publication_refs"]),
            "feedback_alias_reference_count": len(references["feedback_alias_refs"]),
            "status_block_reference_count": len(references["status_block_refs"]),
            "external_publication_reference_count": sum(
                1 for row in references["publication_refs"]
                if not (0xA02C5FD8 <= int(row["from"], 16) < 0xA02C61D0)
            ),
            "explicit_cpu_feedback_store": "0xA02C6214 -> translated shared base +0x3c",
            "explicit_cpu_feedback_load": "0xA02C6260 -> translated shared base +0x3c",
            "direct_literal_feedback_alias_found": bool(references["feedback_alias_refs"]),
        },
        "interpretation": [
            "The reference index contains five direct references to the publication word, all within A02C5FD8's publication helper range.",
            "The call export lists the known A0385780 call sites into A02C61D4; this is CPU read/reset traffic, not a DSP writer.",
            "No indexed fixed-data reference names the translated publication word plus 0x3c alias; the CPU helper reaches it through a runtime translated base.",
        ],
        "not_proven": [
            "An indirect ORC/DSP/MMIO writer of shared +0x3c",
            "Whether smem_2_dram completes before CPU reads the alias",
            "Cache visibility, atomic publication or version retry",
            "DSP runtime identity, frame association or safe table/slot reuse",
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
        "publication_refs": report["bounded_findings"]["publication_reference_count"],
        "feedback_alias_refs": report["bounded_findings"]["feedback_alias_reference_count"],
        "helper_call_count": report["call_graph"]["helper_call_count"],
        "device_access": False,
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
