#!/usr/bin/env python3
"""Emit a bounded, reproducible control-flow summary for the public YI BLD.

This is static ARM decoding of the pinned community 1.10.52 component.  It is
used to explain the PTB ABI observed on the device; it is not a claim that the
device's hidden BLD bytes are identical to this sample.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path

from capstone import CS_ARCH_ARM, CS_MODE_ARM, Cs

BASE = 0x10000000
EXPECTED_SHA256 = "259ed36093252298186c7e39c5f3400ba307f44224aba467ab885da8e1e5cbd7"

WINDOWS = {
    "reset_and_mode_setup": (0x10000000, 0x10000200),
    "ptb_record_selector": (0x10002308, 0x10002358),
    "partition_loader": (0x10002358, 0x100025d0),
    "boot_counter_state": (0x10002780, 0x10002800),
    "shell_command_dispatch": (0x10005a30, 0x10006020),
    "ptb_validation_and_show": (0x10006250, 0x10006460),
    "startup_mode_and_kernel_jump": (0x10006834, 0x10006a08),
}


def listing(data: bytes, start: int, end: int) -> list[dict]:
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    md.detail = False
    out = []
    for ins in md.disasm(data[start - BASE:end - BASE], start):
        out.append({"address": f"0x{ins.address:08x}", "bytes": ins.bytes.hex(), "mnemonic": ins.mnemonic, "operands": ins.op_str})
    return out


def string_hits(data: bytes) -> list[dict]:
    out = []
    for needle in [b"BootTimes is %d", b"Normal updater boot", b"Fwupdater err 3 times", b"sys boot err 3 times", b"Normal sys boot", b"sys boot err > 3 times", b"# Load Kernel", b"# Enter Kernel", b"# Boot-Up Success", b"show ptb", b"erase [bst"]:
        off = data.find(needle)
        if off >= 0:
            out.append({"text": needle.decode(), "file_offset": f"0x{off:05x}", "runtime_address": f"0x{BASE + off:08x}"})
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path)
    ap.add_argument("--output", type=Path, required=True)
    args = ap.parse_args()
    data = args.input.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != EXPECTED_SHA256:
        raise SystemExit(f"unexpected BLD SHA-256: {digest}")
    result = {
        "source": str(args.input),
        "bytes": len(data),
        "sha256": digest,
        "load_base": f"0x{BASE:08x}",
        "instruction_set": "ARM state",
        "static_windows": {name: {"start": f"0x{lo:08x}", "end": f"0x{hi:08x}", "instructions": listing(data, lo, hi)} for name, (lo, hi) in WINDOWS.items()},
        "string_hits": string_hits(data),
        "recovered_facts": [
            {"address": "0x10002308", "fact": "Returns a PTB record pointer using base + index * 0x40 + 0x08 for SYS records, or +0x0c for the other table."},
            {"address": "0x10002358", "fact": "Loads a partition using descriptor offsets +0x28 (block count), +0x2c (start block), and +0x34 (actual byte length); reads in NAND page/block units."},
            {"address": "0x1000270c", "fact": "On a failed/invalid partition scan, clears descriptor +0x34 and writes 0xffffffff to +0x38 and +0x3c; +0x38 is therefore observed as a reserved or failure-state word, not assigned a normal image field meaning."},
            {"address": "0x10006250", "fact": "Validates a table CRC over 0x1cc bytes and then a user PTB CRC over 0x350 bytes against the word at +0x350."},
            {"address": "0x10006834", "fact": "Reads/updates boot state, prints the updater/system fallback decisions, selects a record, loads it, and reaches the indirect kernel jump path."},
            {"address": "0x10006994", "fact": "Loads the computed entry address from the temporary load context and branches through it with MOV PC, confirming the final handoff is indirect."},
            {"address": "0x10005a64", "fact": "Interactive bootloader shell parses boot/show/erase/read/write/memtest/dmesg/blkread/blkmark commands; this is a bootloader console, not RTOS Shell."},
        ],
        "limitations": [
            "The public component is 1.10.52; it is a structural reference for the 1.10.7 device, not a byte identity claim.",
            "Indirect calls, hardware status meanings, hidden NAND bootstrap/bootloader offsets, OOB and signature policy remain outside this bounded decode.",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"windows": len(WINDOWS), "strings": len(result["string_hits"]), "sha256": digest}))


if __name__ == "__main__":
    main()
