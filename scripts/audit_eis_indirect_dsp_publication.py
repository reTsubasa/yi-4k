#!/usr/bin/env python3
"""Verify the EIS update-address path into VCAP_SETUP, using pinned bytes only.

This does not execute firmware or contact a device. It deliberately does not
repeat the earlier fixed-reference scan of the publication word.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
IMAGE = ANALYSIS / 'rtos-window.bin'
BASE = 0xA0100000
SHA256 = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'

# These checks establish argument identity as well as stores/calls. In
# particular, the argument at 60C8 is the slot, not the warp descriptor.
EXPECTED = {
    0xA02C6060: ('str', 'r3, [r7, r5, lsl #6]'),
    0xA02C6068: ('add', 'r5, r7, r5, lsl #6'),
    0xA02C60C8: ('mov', 'r0, r5'),
    0xA02C60CC: ('bl', '#0xa04a3b24'),
    0xA02C60DC: ('str', 'r0, [r7, #0x80]'),
    0xA02C6178: ('mov', 'r0, r3'),
    0xA02C6188: ('bl', '#0xa04a3b24'),
    0xA02C618C: ('str', 'r0, [r5, #0x24]'),
    0xA02C6190: ('b', '#0xa02c60c8'),
    0xA02C6194: ('ldr', 'r0, [pc, #0x34]'),
    0xA02C61A4: ('sub', 'r7, r0, #0x80'),
    0xA02C61A8: ('bl', '#0xa04a3b24'),
    0xA02C61BC: ('str', 'r0, [sl, #0x58]'),
    0xA02C61C4: ('str', 'r8, [r1, #0x28]'),
    0xA02C61C8: ('str', 'r2, [r7, #0x80]'),
    0xA02C4EE8: ('movw', 'r6, #0x3380'),
    0xA02C4EEC: ('movt', 'r6, #0xa06f'),
    0xA02C4F6C: ('mov', 'r0, #1'),
    0xA02C4F70: ('ldr', 'r1, [r6]'),
    0xA02C4F74: ('bl', '#0xa02be570'),
    0xA02BE574: ('mov', 'r3, #0x8000001'),
    0xA02BE57C: ('str', 'r3, [r1]'),
    0xA02BE584: ('ldr', 'r0, [r1, #0x58]'),
    0xA02BE588: ('bl', '#0xa04a3b24'),
    0xA02BE58C: ('str', 'r0, [r4, #0x58]'),
    0xA02BE5C4: ('mov', 'r2, #0x80'),
    0xA02BE5C8: ('mov', 'r1, r4'),
    0xA02BE5CC: ('bl', '#0xa02be4c8'),
    0xA02BE504: ('ldr', 'r3, [r3, r4, lsl #2]'),
    0xA02BE510: ('bx', 'r3'),
    0xA02BE53C: ('ldr', 'r3, [r3, r4, lsl #2]'),
    0xA02BE548: ('bx', 'r3'),
    0xA02B4874: ('ldr', 'r6, [r0, #0x54]'),
    0xA02B4888: ('ldr', 'r4, [r6, #8]'),
    0xA02B489C: ('add', 'r5, r6, r4, lsl #7'),
    0xA02B48AC: ('blx', '#0xa04f8dec'),
    0xA02B48B4: ('str', 'r4, [r6, #8]'),
    0xA02B48B8: ('mov', 'r1, r8'),
    0xA02B48BC: ('mov', 'r2, r7'),
    0xA02B48C0: ('blx', '#0xa04f8d24'),
    0xA02C61EC: ('ldr', 'r0, [r3, #0x58]'),
    0xA02C6204: ('bl', '#0xa04a3bd4'),
    0xA02C6214: ('str', 'r3, [r0, #0x3c]'),
}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    data = IMAGE.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != SHA256:
        raise SystemExit('Pinned image hash mismatch; refusing address interpretation')
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in EXPECTED.items():
        ins = next(cs.disasm(data[address - BASE:address - BASE + 4], address))
        if (ins.mnemonic, ins.op_str) != expected:
            raise SystemExit(f'{address:#x}: {(ins.mnemonic, ins.op_str)} != {expected}')
        checks.append({'address': f'0x{address:08X}', 'bytes': ins.bytes.hex(),
                       'instruction': f'{ins.mnemonic} {ins.op_str}'})

    def word(address: int) -> int:
        return struct.unpack_from('<I', data, address - BASE)[0]

    assert word(0xA02C61D0) == 0xA0699160
    assert word(0xA06F3380) == 0xA064F3C0
    assert word(0xA064F3C0) == 0x08000001
    assert word(0xA06F30FC) == 0xA02B4858
    assert data[0xA05C21C0 - BASE:].split(b'\0', 1)[0] == b' eis_update_addr          = 0x%x'
    funcs = ['a02c5fd8', 'a02c4dbc', 'a02be570', 'a02be4c8', 'a02b4858',
             'a02b464c', 'a02c61d4', 'a04a3b24']
    sources = []
    for function in funcs:
        path = ANALYSIS / 'full/decompiled' / (function + '.c')
        sources.append({'path': str(path.relative_to(ROOT)),
                        'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
    files = list((ANALYSIS / 'full/decompiled').glob('*.c'))
    context_files = [p for p in files if 'DAT_a06f3380' in p.read_text()]
    windows = [(0xA02C5FD8, 0xA02C61D0), (0xA02C4EE8, 0xA02C4F80),
               (0xA02BE4C8, 0xA02BE54C), (0xA02BE570, 0xA02BE61C),
               (0xA02B4858, 0xA02B48E4), (0xA02C61D4, 0xA02C6268)]
    report = {
        'evidence_kind': 'offline pinned instruction and retained Ghidra pseudocode audit',
        'target': {'image': str(IMAGE.relative_to(ROOT)), 'base': hex(BASE), 'sha256': digest},
        'checks': checks,
        'instruction_check_count': len(checks),
        'data_checks': {
            'enable_literal': '0xA0699160', 'initial_vcap_object': '0xA064F3C0',
            'initial_object_command': '0x08000001', 'initial_dispatch_index_1': '0xA02B4858',
            'vcap_field_label': 'eis_update_addr',
        },
        'observed_chain': [
            'A02C5FD8 converts shared publication-word address A0699160 and stores it in VCAP +0x58 on enable transition',
            'selected slot = A06990E0 + index*0x40; slot +0x24 holds the converted warp descriptor pointer',
            'A02C60C8 converts selected SLOT address; A02C60DC publishes it at A0699160',
            'A02C4DBC passes the same global VCAP object to A02BE570 with dispatch index 1',
            'A02BE570 converts VCAP +0x58, labels it eis_update_addr, and sends 0x80 bytes with command 0x08000001',
            'A02BE4C8 chooses a command-buffer context and indirect dispatch entry',
            'initial dispatch entry 1 points to A02B4858, which copies the command into a 0x80-byte queue slot',
        ],
        'interpretation': {
            'publication_value_is': 'translated state-slot pointer, NOT translated warp-descriptor pointer',
            'slot_warp_pointer_is': 'translated descriptor pointer at selected state slot +0x24',
            'setup_update_field_is': 'translated address of the publication word; this is one level of indirection above the state-slot pointer',
            'indirect_cpu_command_path_found': True,
            'dsp_load_or_latch_observed': False,
            'consumer_acknowledgement_found': False,
            'old_slot_reclamation_found': False,
        },
        'negative_evidence_scope': {
            'decompiled_file_count': len(files), 'global_vcap_context_file_count': len(context_files),
            'reviewed_sources': sources,
            'not_repeated': 'prior five-reference scan of A0699160',
            'readback_helper': 'A02C61D4 translates VCAP +0x58 back and reads +0x10 and +0x20..+0x3C, or writes +0x3C; no slot-pointer dereference, completion acknowledgement, or release proven',
            'transport_boundary': 'CPU command buffering; initial table entry is not proof the runtime table is unchanged, and buffer copy success is not DSP acceptance',
        },
        'unknowns': [
            'DSP microcode read/poll/latch of eis_update_addr and order relative to encoded frames',
            'runtime virtual/physical translation table and whether repeated conversion is idempotent for these addresses',
            'cache attributes, barrier owner, descriptor lifetime, old-slot reclamation and worst-case consumer delay',
            'whether enable precedes the VCAP setup send on every real execution path',
        ],
        'tooling': {'new_REA_evidence': False, 'method': 'Capstone plus existing Ghidra export',
                    'rea_mcp_available_in_session': False,
                    'read_only_doctor_observation': 'CLI 6.8.0 reports missing Codex registration, unsupported Node 25.8.1 and no configured analysis engine; no configuration changed'},
        'device_contacted': False, 'firmware_executed': False, 'writes_to_device': False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
    lines = []
    for start, end in windows:
        lines.append(f'\n; {start:#010x}..{end:#010x}')
        for ins in cs.disasm(data[start - BASE:end - BASE], start):
            lines.append(f'{ins.address:08X}  {ins.bytes.hex():8s}  {ins.mnemonic:8s} {ins.op_str}')
    args.output.with_suffix('.asm').write_text('\n'.join(lines) + '\n')
    print(f'{len(checks)} pinned instruction checks passed; command path found; DSP latch/ack unresolved')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
