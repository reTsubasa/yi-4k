#!/usr/bin/env python3
"""Audit the bounded caller gate around the vertical-warp ``done`` log.

This checks the fixed ORC words around the diagnostic string construction and
the idspdrv_dram2dram call.  It records the software log/bit gate but does not
interpret the guarded field as a hardware completion register and never runs
ORC or accesses a device.
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
CHECKS = {
    0x17F260: "l.addi r4,r10,256",
    0x17F264: "l.ori r3,r16,0x0",
    0x17F268: "l.addi r5,r0,3136",
    0x17F26C: "l.sfeqi r16,0",
    0x17F270: "l.bnf 0x17f29c",
    0x17F27C: "l.lwz r6,120(r18)",
    0x17F280: "l.movhi r3,0x8b",
    0x17F284: "l.ori r3,r3,0x7ba9",
    0x17F288: "l.andi r5,r6,0x3",
    0x17F28C: "l.sfeqi r5,0",
    0x17F290: "l.bf 0x17f2b0",
    0x17F294: "l.jal 0x19fe44",
    0x17F298: "l.j 0x17f2b0",
    0x17F29C: "l.lhz r8,11058(r18)",
    0x17F2A0: "l.ori r7,r8,0x3",
    0x17F2A4: "l.sh 11058(r18),r7",
    0x17F2A8: "l.jal 0x18cb2c",
    0x17F2AC: "l.j 0x17f27c",
}
COPY_CHECKS = {
    0x18CB64: "l.jal 0x18bd88",
    0x18CBC8: "l.jal 0x1a46a0",
    0x18CBDC: "l.jal 0x1a4a04",
    0x18CBE8: "l.bf 0x18cba0",
    0x18CC24: "l.jal 0x1a4a04",
    0x18CC28: "l.j 0x18cc48",
}


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-11-eis-vertical-done-log-gate/audit.json",
    )
    args = ap.parse_args()

    dsp = DSP.read_bytes()
    ref = REF.read_bytes()
    if sha(dsp) != DSP_SHA or sha(ref) != REF_SHA:
        raise SystemExit("pinned DSP/reference hash mismatch")
    member = next(m for m in inventory(dsp) if m["name"] == "orccode.bin")
    start = int(member["offset"], 16)
    binary = dsp[start : start + int(member["bytes"])]
    if sha(binary) != ORCCODE_SHA:
        raise SystemExit("pinned ORC member hash mismatch")
    decoder = CoreDecoder(ref.decode("utf-8"))

    def word(offset: int) -> int:
        return struct.unpack_from("<I", binary, offset)[0]

    checks = []
    for offset, expected in CHECKS.items():
        actual = decoder.decode(word(offset), offset)
        if actual != expected:
            raise SystemExit(f"check mismatch {offset:#x}: {actual!r} != {expected!r}")
        checks.append({"offset": hex(offset), "word_le": hex(word(offset)), "instruction": actual})
    copy_checks = []
    for offset, expected in COPY_CHECKS.items():
        actual = decoder.decode(word(offset), offset)
        if actual != expected:
            raise SystemExit(f"copy check mismatch {offset:#x}: {actual!r} != {expected!r}")
        copy_checks.append({"offset": hex(offset), "word_le": hex(word(offset)), "instruction": actual})

    string_offset = 0x2B7BA9
    text = binary[string_offset : binary.index(b"\0", string_offset)].decode("ascii")
    if text != "idspdrv_update_vertical_warp_field() done.\n":
        raise SystemExit("done string mismatch")

    report = {
        "evidence_type": "offline fixed-byte audit of the vertical warp done-log gate",
        "scope": "Caller and copy-helper windows only; software log-branch semantics recorded without assigning hardware completion meaning.",
        "inputs": {
            "container_sha256": sha(dsp),
            "reference_sha256": sha(ref),
            "orccode_sha256": sha(binary),
        },
        "diagnostic": {
            "string_member_offset": hex(string_offset),
            "text": text,
            "reference_pair": ["0x17f280", "0x17f284"],
            "logger_call": "0x17f294 -> 0x19fe44",
        },
        "caller_checks": checks,
        "copy_helper_checks": copy_checks,
        "software_gate": {
            "status_load": "0x17f27c: r6 = lwz(r18+120)",
            "gate": "0x17f288: r5 = r6 & 3; 0x17f28c/0x17f290 branch to 0x17f2b0 when zero",
            "copy_branch": "nonzero source pointer path at 0x17f270 branches to 0x17f29c, writes r18+0x2b32 |= 3, calls 0x18cb2c, then jumps to the log gate at 0x17f27c",
            "done_branch": "zero low-two-bit gate skips logging and exits; nonzero gate calls logger 0x19fe44 with the done string then exits",
            "copy_helper": "0x18cb2c chunks through 0x1a46a0 and 0x1a4a04; final remainder uses 0x1a4a04 before return",
        },
        "bounded_findings": [
            "The done diagnostic is emitted by a normal logger call only when r18+120 has nonzero low two bits; zero skips the log and exits. A nonzero source pointer performs one copy call before reaching this gate, while a null source pointer can reach the same gate without a copy.",
            "The same caller uses r18+120 only through a low two-bit mask; this static window does not identify the field as a hardware completion register, fence, or DMA status.",
            "The copy path calls idspdrv_dram2dram (0x18cb2c), which invokes the named dram_2_smem/smem_2_dram helpers before reaching the log gate; no caller loop or standard done-register poll is visible in the bounded caller/copy windows.",
            "The diagnostic string and its placement establish software control-flow ordering, not that the final hardware reader has stopped using the source table or that cache/atomic publication is complete.",
        ],
        "not_proven": [
            "Meaning and ownership of r18+120 and r18+0x2b32",
            "Proprietary transfer completion, DMA/MMIO, cache, atomic or latch semantics",
            "Whether 0x18cb2c returns only after hardware transfer completion",
            "Final hardware reader and safe source-table/state-slot release",
            "Runtime ORC identity, PC, timing and frame correspondence",
        ],
        "device_access": False,
        "firmware_executed": False,
        "writes_to_device": False,
    }
    output = args.output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(output), "instruction_checks": len(checks), "copy_checks": len(copy_checks), "device_access": False}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
