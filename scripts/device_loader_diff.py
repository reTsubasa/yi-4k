#!/usr/bin/env python3
"""Disassemble changed loader-related functions in old vs real 1.10.7 RTOS.

The old Ghidra function ranges are used only as comparison bounds.  This
script does not infer new function boundaries and never contacts the camera.
"""
from __future__ import annotations

import difflib
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM


ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
OLD = ROOT / "artifacts/firmware/v1.10.52/_part_lrtos.a9s"
NEW = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin"
OUT = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/loader-diff"
OLD_SHA = "c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141"
NEW_SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
RANGES = {
    "loadbin": (0xA02A2584, 0xA02A26F3),
    "savebin": (0xA02A3DB0, 0xA02A3F07),
    "t_dispatch": (0xA029E1A4, 0xA029E25F),
    "t_register": (0xA029E098, 0xA029E1A3),
}


def disasm(image: bytes, lo: int, hi: int):
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    raw = image[lo - BASE:hi - BASE + 1]
    rows = []
    for ins in md.disasm(raw, lo):
        rows.append(f"{ins.address:08x} {ins.bytes.hex():8s} {ins.mnemonic:8s} {ins.op_str}")
    return rows


def main() -> None:
    old, new = OLD.read_bytes(), NEW.read_bytes()
    if hashlib.sha256(old).hexdigest() != OLD_SHA:
        raise SystemExit("old image hash mismatch")
    if hashlib.sha256(new).hexdigest() != NEW_SHA:
        raise SystemExit("device image hash mismatch")
    OUT.mkdir(parents=True, exist_ok=True)
    report = {"old_sha256": OLD_SHA, "device_sha256": NEW_SHA, "functions": {}}
    for name, (lo, hi) in RANGES.items():
        old_rows, new_rows = disasm(old, lo, hi), disasm(new, lo, hi)
        diff = list(difflib.unified_diff(old_rows, new_rows, fromfile="old", tofile="device", lineterm=""))
        report["functions"][name] = {
            "entry": hex(lo), "end_inclusive": hex(hi),
            "old_instruction_lines": len(old_rows), "device_instruction_lines": len(new_rows),
            "changed_bytes": sum(a != b for a, b in zip(old[lo-BASE:hi-BASE+1], new[lo-BASE:hi-BASE+1])),
            "diff_lines": len(diff),
        }
        (OUT / f"{name}.old.asm").write_text("\n".join(old_rows) + "\n")
        (OUT / f"{name}.device.asm").write_text("\n".join(new_rows) + "\n")
        (OUT / f"{name}.diff").write_text("\n".join(diff) + "\n")
    (OUT / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
