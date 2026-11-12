#!/usr/bin/env python3
"""Retain focused EIS static evidence from the pinned RTOS; never execute it."""
from pathlib import Path
import hashlib
import json
import struct
import capstone

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/firmware/v1.10.52/_part_lrtos.a9s'
OUT = ROOT / 'artifacts/rtos-reverse/eis'
BASE = 0xA0100000
SHA = 'c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141'
WINDOWS = [
    (0xA037D9E0, 0xA037DC08, 'controller_init'),
    (0xA037F55C, 0xA03811B0, 'gyro_and_mode_init'),
    (0xA0384710, 0xA0384A10, 'rotation_filter'),
    (0xA03852F8, 0xA038E038, 'per_frame_and_sample_processing'),
    (0xA038EA48, 0xA0394BA0, 'warp_generation'),
    (0xA0396EE8, 0xA03977E8, 'tasks_and_callbacks'),
    (0xA047EDE4, 0xA047F2A0, 'gyro_read_and_open'),
]


def main():
    data = SOURCE.read_bytes()
    if hashlib.sha256(data).hexdigest() != SHA:
        raise SystemExit('RTOS SHA mismatch; fixed addresses are not applicable')
    OUT.mkdir(parents=True, exist_ok=True)
    md = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    windows = []
    for start, end, label in WINDOWS:
        lines = [f'; RTOS SHA256 {SHA}',
                 '; Selected A32 window; may include literal pools and adjacent functions.']
        for insn in md.disasm(data[start - BASE:end - BASE], start):
            lines.append(f'{insn.address:08x} {insn.bytes.hex()} {insn.mnemonic:8} {insn.op_str}')
        name = f'{start:08x}.asm'
        (OUT / name).write_text('\n'.join(lines) + '\n')
        windows.append(dict(start=hex(start), end_exclusive=hex(end), label=label, file=name))
    table = []
    labels = ['get_info', 'open', 'read', 'read_register', 'write_register', 'unknown_5', 'unknown_6', 'null']
    for index, label in enumerate(labels):
        slot = 0xA078B0BC + 4 * index
        target = struct.unpack_from('<I', data, slot - BASE)[0]
        table.append(dict(offset=hex(index * 4), slot=hex(slot), target=hex(target), candidate_role=label))
    selected = {
        0xA037D9E0, 0xA037FE20, 0xA0385780, 0xA03852F8,
        0xA038EA48, 0xA0391CF0, 0xA0392CB0, 0xA0396EE8,
        0xA0396F34, 0xA03975BC, 0xA0397688, 0xA03B0CE0,
    }
    edges = []
    for line in (ROOT / 'artifacts/rtos-reverse/full/calls.tsv').read_text().splitlines()[1:]:
        caller, site, target, kind = line.split('\t')
        if int(caller, 16) in selected and ('CALL' in kind or int(target, 16) in selected):
            edges.append(dict(caller=caller, site=site, target=target, kind=kind))
    (OUT / 'evidence.json').write_text(json.dumps(dict(
        source=str(SOURCE.relative_to(ROOT)), sha256=SHA, base=hex(BASE),
        capstone_version=capstone.__version__, windows=windows,
        gyro_ops_table=table, direct_edges_from_existing_ghidra_export=edges,
        limitations=[
            'Static analysis only; no target execution, patching or ABI validation.',
            'Role names are analyst reconstructions; table pointer initialization is in a018756c.c.',
            'Linear A32 windows can decode literal data as instructions; they are not coverage proofs.',
            'a047ede4 is an indirect driver entry absent from the prior Ghidra function index.',
        ],
    ), indent=2) + '\n')
    print(f'Exported {len(windows)} EIS windows and verified gyro operations table from {SHA}')


if __name__ == '__main__':
    main()
