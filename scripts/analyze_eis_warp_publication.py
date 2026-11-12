#!/usr/bin/env python3
"""Hash-pinned, offline evidence for the device 1.10.7 EIS warp publication path."""
import argparse
import hashlib
import json
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
SHA256 = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE = 0xA0100000
# These checks bind the staging/publication conclusions to device bytes, rather
# than relying only on inferred Ghidra variable names or C source order.
CHECKS = {
    0xA03126F4: ('bl', '#0xa029c680'),
    0xA0312704: ('bl', '#0xa029c680'),
    0xA0312734: ('bl', '#0xa04a22cc'),
    0xA0312740: ('bl', '#0xa04a22cc'),
    0xA031274C: ('and', 'r2, r0, #0xf'),
    0xA0312750: ('cmp', 'r2, #0xf'),
    0xA0312758: ('beq', '#0xa03125c0'),
    0xA0312764: ('bl', '#0xa02bd9f0'),
    0xA0312810: ('cmp', 'r3, #0xf'),
    0xA0312814: ('beq', '#0xa03125c0'),
    0xA0312820: ('bl', '#0xa02bd9f0'),
    0xA02DA514: ('b', '#0xa0312460'),
    0xA0394750: ('mov', 'r3, #0xf'),
    0xA0394760: ('bl', '#0xa02da514'),
    0xA0394970: ('mov', 'r3, #0xf'),
    0xA0394980: ('bl', '#0xa02da514'),
    0xA039499C: ('bl', '#0xa0312f74'),
    0xA038B2A8: ('bl', '#0xa02c5fd8'),
    0xA02C60DC: ('str', 'r0, [r7, #0x80]'),
    0xA02C60E8: ('cmp', 'r3, #1'),
    0xA02C60EC: ('movhi', 'r3, #0'),
    0xA0311D8C: ('bl', '#0xa032cf38'),
    0xA032CFF4: ('cmp', 'r3, #0x12c0'),
    0xA032D244: ('cmp', 'r3, #0x12c0'),
    0xA032D488: ('cmp', 'r3, #0x12c0'),
    # LiveviewEisConfig state publication: two 0x40-byte slots, publish the
    # translated descriptor pointer, then advance/wrap the slot index. These
    # checks bind the inferred recycle sequence to device bytes.
    0xA02C6060: ('str', 'r3, [r7, r5, lsl #6]'),
    0xA02C6068: ('add', 'r5, r7, r5, lsl #6'),
    0xA02C60DC: ('str', 'r0, [r7, #0x80]'),
    0xA02C60E0: ('add', 'r3, r3, #1'),
    0xA02C60E8: ('cmp', 'r3, #1'),
    0xA02C60EC: ('movhi', 'r3, #0'),
    0xA02C60F0: ('strb', 'r3, [r2]'),
    0xA02C618C: ('str', 'r0, [r5, #0x24]'),
    0xA02C6190: ('b', '#0xa02c60c8'),
}
RANGES = [
    (0xA0312658, 0xA031282C), (0xA0312FFC, 0xA0313080),
    (0xA0394740, 0xA0394794), (0xA0394960, 0xA0394A20),
    (0xA038B274, 0xA038B2E8), (0xA02C5FD8, 0xA02C61D0),
]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    data = IMAGE.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != SHA256:
        raise SystemExit('Device RTOS image hash changed; refusing stale-address interpretation')
    disassembler = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in CHECKS.items():
        insn = next(disassembler.disasm(data[address-BASE:address-BASE+4], address))
        actual = (insn.mnemonic, insn.op_str)
        if actual != expected:
            raise SystemExit(f'Instruction mismatch at {address:#x}: {actual} != {expected}')
        checks.append({'address': f'0x{address:08X}', 'instruction': ' '.join(actual), 'bytes': insn.bytes.hex()})
    snippets = []
    for start, end in RANGES:
        snippets.append({'start': f'0x{start:08X}', 'end_exclusive': f'0x{end:08X}',
                         'instructions': [f'{i.address:08x} {i.mnemonic} {i.op_str}'
                                          for i in disassembler.disasm(data[start-BASE:end-BASE],start)]})
    report = {
        'evidence_kind': 'offline device-byte disassembly plus existing Ghidra pseudocode; no runtime execution',
        'target': {'firmware':'YI 4K 1.10.7','image':str(IMAGE.relative_to(ROOT)), 'sha256':digest,'base':hex(BASE)},
        'checks':checks, 'snippets':snippets,
        'function_fingerprints': {
            'warp_calculate_a032cf38': hashlib.sha256(data[0xA032CF38-BASE:0xA032D8C0-BASE]).hexdigest(),
            'warp_calculate_caller_a03119a8': hashlib.sha256(data[0xA0311CC4-BASE:0xA0311DA0-BASE]).hexdigest(),
        },
        'contract': {
            'warp_calculate': {
                'function': '0xA032CF38',
                'caller': '0xA03119A8',
                'accepted_calibration_versions': ['0x20140701', '0x20130101'],
                'maximum_grid_points': 0x12c0,
                'grid_validation': 'horizontal_grid_num * vertical_grid_num <= 0x12c0',
                'calibration_warp_entry': 'signed 16-bit coordinate pairs, four bytes per grid point',
                'output_stages': ['pipe-0 FUN_a032b520', 'pipe-1 FUN_a032a6c4'],
                'status_outputs': 'param_3[0]=1 on successful generation; param_3[2] receives frame/status index when changed',
            },
            'set_warp': {'function':'0xA0312460','caller_selector_offset':'0x04',
                         'staging_selector':'0x0000000F',
                         'copy_per_plane_bytes':0x1800, 'planes':2,
                         'clean_helper':'0xA04A22CC',
                         'direct_command_suppressed_when':'selector low nibble equals 0xF',
                         'direct_command_function':'0xA02BD9F0',
                         'special_buffer_selection':'selector exactly 0xF selects relative slot from context counters; other selectors map through A03089AC'},
            'descriptor_get':'0xA0312F74',
            'eis_status': {'function':'0xA02C5FD8','name_evidence':'AmbaDSP_LiveviewEisConfig string',
                           'input_base':'0xA1704310', 'slot_count':2,'slot_stride_bytes':0x40,
                           'publication_pointer_offset':'0x80', 'warp_control_input_offset':'0x24',
                           'warp_table_input_offsets':['0x2C','0x30'],
                           'physical_translation_helper':'0xA04A3B24',
                           'publication_sequence':['copy input into slot[index]','translate descriptor','store published pointer at +0x80','increment index and wrap after 1']},
        },
        'pseudocode_evidence': [
            'artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0312460.c',
            'artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0312f74.c',
            'artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a0392cb0.c',
            'artifacts/device/2026-11-09-linux/rtos-analysis/focused/a0385780.c',
            'artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled/a02c5fd8.c'],
        'limitations': [
            'No custom warp was submitted and no new camera state was modified.',
            'Two status slots do not prove that two warp tables are sufficient or safe to recycle.',
            'No cache maintenance is visible in A02C5FD8 itself; coherency and consumer acknowledgement remain unresolved.',
            'Grid point Q format, table pitch and target-frame deadlines are not established by the fixed copy length.',
            'Frame phase/status index is not yet proven to equal an encoded-file frame number.'
        ]}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'verified_instructions':len(checks),'device_contacted':False,'output':str(args.output)}))

if __name__ == '__main__':
    main()
