#!/usr/bin/env python3
"""Pin the CPU EIS command-buffer boundary without executing firmware.

The EIS update address is sent through an indirect VCAP command queue.  This
audit records the queue selection, readiness wait, slot clear/cursor update and
0x80-byte copy order from the fixed 1.10.7 RTOS image.  It deliberately keeps
the result below the DSP acknowledgement boundary: a successful queue copy is
not a DSP latch, table completion, cache protocol, or safe old-slot release.

No device is contacted, no firmware is executed, and no binary is generated.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin"
CALLS = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/calls.tsv"
BASE = 0xA0100000
IMAGE_SHA256 = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"

WINDOWS = {
    "dispatch": (0xA02BE4C8, 0xA02BE54C),
    "vcap_setup": (0xA02BE570, 0xA02BE61C),
    "ready_wait": (0xA02B45B4, 0xA02B4648),
    "queue_entry": (0xA02B4858, 0xA02B48C8),
}

EXPECTED = {
    0xA02BE574: ("mov", "r3, #0x8000001"),
    0xA02BE57C: ("str", "r3, [r1]"),
    0xA02BE584: ("ldr", "r0, [r1, #0x58]"),
    0xA02BE588: ("bl", "#0xa04a3b24"),
    0xA02BE5C4: ("mov", "r2, #0x80"),
    0xA02BE5CC: ("bl", "#0xa02be4c8"),
    0xA02BE5FC: ("pop", "{r3, r4, r5, pc}"),
    0xA02B45E4: ("mov", "r0, #0x100000"),
    0xA02B45F0: ("bl", "#0xa02c6a70"),
    0xA02B4604: ("mov", "r0, #0x80000"),
    0xA02B4610: ("bl", "#0xa02c6a70"),
    0xA02B4884: ("bl", "#0xa02b45b4"),
    0xA02B48A4: ("mov", "r2, #0x80"),
    0xA02B48AC: ("blx", "#0xa04f8dec"),
    0xA02B48B4: ("str", "r4, [r6, #8]"),
    0xA02B48C0: ("blx", "#0xa04f8d24"),
}


def make_decoder():
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    cs.detail = True
    return cs


def disassemble(data: bytes, start: int, end: int):
    cs = make_decoder()
    return list(cs.disasm(data[start - BASE:end - BASE], start))


def direct_target(ins) -> int | None:
    if ins.mnemonic not in ("bl", "b", "blx"):
        return None
    text = ins.op_str.strip()
    if not text.startswith("#"):
        return None
    try:
        return int(text[1:], 16)
    except ValueError:
        return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-10-eis-command-queue/audit.json",
    )
    args = parser.parse_args()

    data = IMAGE.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != IMAGE_SHA256:
        raise SystemExit("Pinned RTOS image hash mismatch; refusing address interpretation")

    def instruction(address: int):
        cs = make_decoder()
        result = list(cs.disasm(data[address - BASE:address - BASE + 4], address))
        if len(result) != 1:
            raise SystemExit(f"could not decode {address:#x}")
        return result[0]

    checks = []
    for address, expected in EXPECTED.items():
        ins = instruction(address)
        actual = (ins.mnemonic, ins.op_str)
        if actual != expected:
            raise SystemExit(f"{address:#x}: {actual!r} != {expected!r}")
        checks.append({
            "address": f"0x{address:08X}",
            "bytes": ins.bytes.hex(),
            "instruction": f"{ins.mnemonic} {ins.op_str}",
        })

    decoded_windows = {}
    for name, (start, end) in WINDOWS.items():
        instructions = disassemble(data, start, end)
        if sum(ins.size for ins in instructions) != end - start:
            raise SystemExit(f"window {name} has undecoded bytes")
        decoded_windows[name] = [
            {
                "address": f"0x{ins.address:08X}",
                "bytes": ins.bytes.hex(),
                "instruction": f"{ins.mnemonic} {ins.op_str}",
            }
            for ins in instructions
        ]

    # The initial command-table entry is fixed data, not a claim that the
    # indirect target is the only runtime mode.  It is the known mode-1 path.
    table_entry = struct.unpack_from("<I", data, 0xA06F30FC - BASE)[0]
    if table_entry != 0xA02B4858:
        raise SystemExit(f"unexpected mode-1 queue entry: {table_entry:#x}")

    # The queue windows contain no architectural barrier and no direct cache
    # helper call.  This is deliberately a bounded negative result.  Event
    # wait/lock helpers may have their own barriers, but their relationship to
    # DSP visibility is not established by this scan.
    barrier_mnemonics = {"dmb", "dsb", "isb"}
    cache_targets = {
        0xA04A22CC, 0xA0498728, 0xA049878C, 0xA04987F0, 0xA04A2038
    }
    barrier_sites = []
    cache_calls = []
    for name, instructions in decoded_windows.items():
        for row in instructions:
            # Recover the decoded instruction from the bytes for target parsing.
            ins = instruction(int(row["address"], 16))
            if ins.mnemonic in barrier_mnemonics:
                barrier_sites.append({"window": name, **row})
            target = direct_target(ins)
            if target in cache_targets:
                cache_calls.append({"window": name, "target": hex(target), **row})

    # Ensure the calls TSV still describes the direct queue edge that this
    # report relies on.  Indirect dispatch itself is intentionally retained as
    # an unresolved runtime boundary.
    call_edges = []
    if CALLS.is_file():
        for line in CALLS.read_text().splitlines():
            fields = line.split("\t")
            if len(fields) != 4:
                continue
            if fields[0] in {"0xa02b4858", "0xa02be570", "0xa02be4c8"}:
                call_edges.append(fields)

    report = {
        "evidence_kind": "offline pinned CPU command-buffer and event-wait contract",
        "image": {"path": str(IMAGE.relative_to(ROOT)), "base": hex(BASE), "sha256": digest},
        "instruction_check_count": len(checks),
        "checks": checks,
        "mode_1_dispatch": {
            "table_address": "0xA06F30F8",
            "entry_index": 1,
            "entry_address": "0xA06F30FC",
            "entry": hex(table_entry),
            "dispatch_function": "0xA02BE4C8",
            "dispatch_kind": "indirect table jump after mode gate",
        },
        "queue_contract": {
            "vcap_setup": {
                "command_code": "0x08000001",
                "command_bytes": 0x80,
                "enqueue_call": "0xA02BE5CC -> 0xA02BE4C8",
                "return_is": "queue dispatch result; not DSP completion",
            },
            "ready_wait": {
                "function": "0xA02B45B4",
                "type_0x0e_event_mask": "0x00100000",
                "type_0x0d_event_mask": "0x00080000",
                "timeout_ticks": 1000,
                "wait_helper": "0xA02C6A70",
                "meaning": "command-buffer readiness gate before slot mutation",
            },
            "slot_write_order": [
                "read queue base +0x54 and cursor +0x08",
                "select next slot at cursor * 0x80",
                "clear selected 0x80 bytes with 0x00",
                "store new cursor at queue base +0x08",
                "copy caller command into selected slot with 0x80 bytes",
                "return zero when capacity check passed; FFFFFFFF on full/invalid path",
            ],
            "clear_helper": "0xA04F8DEC",
            "copy_helper": "0xA04F8D24",
        },
        "bounded_visibility_scan": {
            "windows": {name: [hex(lo), hex(hi)] for name, (lo, hi) in WINDOWS.items()},
            "barrier_sites_in_windows": barrier_sites,
            "cache_helper_calls_in_windows": cache_calls,
            "result": "no direct dmb/dsb/isb or known D-cache helper in the four audited queue windows",
            "scope": "bounded ARM windows only; event/lock helper bodies and indirect DSP code are separate",
        },
        "call_graph_rows": call_edges,
        "not_proven": [
            "Indirect dispatch target selected at runtime for every mode",
            "queue copy visibility to DSP or hardware command fetch",
            "DSP latch, completion/ack, encoded-frame association or PTS identity",
            "safe reclamation or overwrite condition for prior queue/table slots",
            "cache/barrier behavior inside called event, lock, driver or DSP helpers",
        ],
        "device_access": False,
        "firmware_executed": False,
        "writes_to_device": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({
        "output": str(args.output),
        "instruction_checks": len(checks),
        "barrier_sites": len(barrier_sites),
        "cache_calls": len(cache_calls),
        "mode_1_entry": hex(table_entry),
        "device_access": False,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
