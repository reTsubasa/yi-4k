#!/usr/bin/env python3
"""Bound the ARM ownership of the VCAP EIS update-address field.

This audit scans the pinned Ghidra decompilation for the exact
``DAT_a06f3380 + 0x58`` access and checks the ARM call-site arguments that
reach the two relevant helpers.  It is intentionally an ownership boundary,
not an emulation of the DSP or a claim about cache visibility.  It never
executes firmware or contacts a camera.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis"
IMAGE = ANALYSIS / "rtos-window.bin"
DECOMPILED = ANALYSIS / "full/decompiled"
CALLS = ANALYSIS / "full/calls.tsv"
BASE = 0xA0100000
IMAGE_SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"

# The fixed call sites whose argument registers determine the helper mode.
CALL_SITE_RANGES = {
    "A02C5FD8": (0xA0382EE0, 0xA0382EEC),
    "A02C61D4_read": (0xA0387794, 0xA03877A4),
    "A02C61D4_reset": (0xA0387C94, 0xA0387CB0),
}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def disassemble(data: bytes, start: int, end: int) -> list[dict[str, str]]:
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    rows = []
    for ins in cs.disasm(data[start - BASE:end - BASE], start):
        rows.append({
            "address": f"0x{ins.address:08X}",
            "bytes": ins.bytes.hex(),
            "instruction": f"{ins.mnemonic} {ins.op_str}",
        })
    return rows


def parse_callers(target: int) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for raw in CALLS.read_text(encoding="utf-8").splitlines():
        fields = raw.split("\t")
        if len(fields) < 4 or fields[3] != "UNCONDITIONAL_CALL":
            continue
        try:
            source, site, callee = (int(fields[i], 16) for i in range(3))
        except ValueError:
            continue
        if callee == target:
            rows.append({
                "from": f"0x{source:08X}",
                "site": f"0x{site:08X}",
                "to": f"0x{callee:08X}",
                "type": fields[3],
            })
    return rows


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-11-eis-vcap-update-addr/audit.json",
    )
    args = ap.parse_args()

    image = IMAGE.read_bytes()
    digest = hashlib.sha256(image).hexdigest()
    if digest != IMAGE_SHA:
        raise SystemExit("pinned RTOS image hash mismatch")

    # Exact token scan: this avoids treating unrelated structure offsets named
    # 0x58 as the VCAP field.
    token = re.compile(r"DAT_a06f3380\s*\+\s*0x58")
    source_hits: list[dict[str, object]] = []
    for path in sorted(DECOMPILED.glob("*.c")):
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        for number, line in enumerate(lines, 1):
            if token.search(line):
                source_hits.append({
                    "file": str(path.relative_to(ROOT)),
                    "line": number,
                    "text": line.strip(),
                })

    expected_hits = [
        {
            "file": "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02c5fd8.c",
            "line": 27,
            "role": "reset VCAP +0x58 to zero when param_2 == 0",
        },
        {
            "file": "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02c61d4.c",
            "line": 12,
            "role": "read VCAP +0x58 as translated shared base",
        },
    ]
    actual_keys = {(row["file"], row["line"]) for row in source_hits}
    expected_keys = {(row["file"], row["line"]) for row in expected_hits}
    if actual_keys != expected_keys:
        raise SystemExit(f"unexpected exact VCAP +0x58 source hits: {source_hits}")

    call_sites = {
        "A02C5FD8_shutdown_reset": disassemble(image, 0xA0382EDC, 0xA0382EEC),
        "A02C5FD8_publish": disassemble(image, 0xA038B298, 0xA038B2AC),
        "A02C5FD8_clear_slot": disassemble(image, 0xA038B2CC, 0xA038B2E0),
        "A02C61D4_read": disassemble(image, 0xA0387794, 0xA03877A4),
        "A02C61D4_reset": disassemble(image, 0xA0387C94, 0xA0387CB0),
    }

    # These checks are the argument facts needed for the ownership conclusion.
    required = {
        "A02C5FD8_shutdown_reset": ["mov r0, #0", "mov r1, #0"],
        "A02C5FD8_publish": ["mov r1, #1", "bl #0xa02c5fd8"],
        "A02C5FD8_clear_slot": ["mov r0, #0", "mov r1, #1", "bl #0xa02c5fd8"],
        "A02C61D4_read": ["mov r1, #0", "bl #0xa02c61d4"],
        "A02C61D4_reset": ["movw r3, #0xbeef", "movt r3, #0xdead", "str r3, [r2, #0x20]", "mov r1, #1", "bl #0xa02c61d4"],
    }
    for name, wanted in required.items():
        text = [row["instruction"] for row in call_sites[name]]
        for ins in wanted:
            if ins not in text:
                raise SystemExit(f"missing {ins!r} in {name}: {text}")

    callers = {
        "A02C5FD8": parse_callers(0xA02C5FD8),
        "A02C61D4": parse_callers(0xA02C61D4),
    }
    report = {
        "evidence_type": "offline ARM VCAP EIS update-address ownership audit",
        "scope": "exact DAT_a06f3380+0x58 decompilation references plus pinned call-site argument checks",
        "inputs": {
            "image": str(IMAGE.relative_to(ROOT)),
            "image_sha256": digest,
            "decompiled_directory": str(DECOMPILED.relative_to(ROOT)),
            "calls_tsv_sha256": sha(CALLS),
        },
        "exact_source_references": [*expected_hits],
        "call_sites": call_sites,
        "call_graph": callers,
        "bounded_findings": [
            "The full decompiled ARM set contains exactly two direct references to DAT_a06f3380 + 0x58.",
            "A02C5FD8 writes zero to that field only on its param_2 == 0 reset branch; the checked shutdown call supplies r0=0,r1=0.",
            "The checked A02C5FD8 publish and clear-slot calls supply param_2=1, so they do not write the VCAP +0x58 field.",
            "A02C61D4 reads the field as the translated shared base. Its param_2=1 call writes CPU cache +0x20 to translated base +0x3c; the caller first stores DEADBEEF, so this is the CPU consume/reset sentinel path.",
            "No fixed ARM non-sentinel writer of shared +0x3c is exposed by this exact-reference scan; ORC smem_2_dram remains outside the ARM reference index.",
        ],
        "not_proven": [
            "ORC runtime identity or execution of the smem_2_dram candidate",
            "external-copy completion, cache visibility, atomic publication or old-slot release",
            "a non-literal MMIO/DMA/indirect writer not represented by these decompiled ARM references",
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
        "exact_source_reference_count": len(source_hits),
        "a02c5fd8_callers": len(callers["A02C5FD8"]),
        "a02c61d4_callers": len(callers["A02C61D4"]),
        "device_access": False,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
