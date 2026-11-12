#!/usr/bin/env python3
"""Audit the stored ORC tag-feedback preparation path, offline and statically.

No ORC execution or proprietary instruction semantics are assumed. Helper names
come from their own fixed diagnostic string references; actual DMA completion,
cache ordering, hardware latch, and old-buffer release remain unobserved.
"""
from __future__ import annotations
import argparse
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from audit_eis_orc_core import ROOT, DSP, REF, DSP_SHA, REF_SHA, CoreDecoder, sha
from audit_eis_dsp_reference import inventory, RTOS_SHA, RTOS, BASE

CORE = {
    0x238BC: 'l.ori r12,r3,0x0', 0x238C0: 'l.addi r16,r3,3456',
    0x2453C: 'l.lwz r3,88(r14)', 0x24540: 'l.sw 856(r16),r3',
    0xD7864: 'l.lwz r5,104(r3)', 0xD7870: 'l.sfnei r5,20',
    0xD7874: 'l.bf 0xd7950', 0xD7878: 'l.lwz r7,4312(r3)',
    0xD787C: 'l.addi r4,r0,10784', 0xD7880: 'l.addi r5,r0,128',
    0xD7884: 'l.ori r3,r7,0x0', 0xD7888: 'l.sfeqi r7,0',
    0xD788C: 'l.bf 0xd7950', 0xD7890: 'l.addi r6,r0,-1',
    0xD7898: 'l.sw -72(r2),r6', 0xD78A0: 'l.addi r16,r2,-64',
    0xD78A4: 'l.jal 0x1a4890', 0xD78A8: 'l.addi r4,r2,-68',
    0xD78AC: 'l.addi r5,r0,4', 0xD78B0: 'l.addi r3,r0,10784',
    0xD78B4: 'l.jal 0x1a14c4', 0xD78B8: 'l.lwz r8,-68(r2)',
    0xD78BC: 'l.movhi r6,0xfff', 0xD78C0: 'l.ori r6,r6,0xffff',
    0xD78C4: 'l.addi r4,r0,10784', 0xD78C8: 'l.addi r5,r0,128',
    0xD78CC: 'l.and r7,r8,r6', 0xD78D0: 'l.sfeqi r8,0',
    0xD78D4: 'l.bnf 0xd7900', 0xD78D8: 'l.addi r3,r0,10784',
    0xD78DC: 'l.addi r4,r2,-72', 0xD78E0: 'l.addi r5,r0,4',
    0xD78E4: 'l.jal 0x1a14d8', 0xD78E8: 'l.lwz r14,4312(r10)',
    0xD78EC: 'l.addi r4,r0,10784', 0xD78F0: 'l.addi r5,r0,4',
    0xD78F4: 'l.addi r3,r14,60', 0xD78F8: 'l.jal 0x1a4a04',
    0xD7900: 'l.lwz r19,4312(r10)', 0xD7904: 'l.addi r15,r0,2',
    0xD7908: 'l.and r17,r19,r6', 0xD790C: 'l.addi r3,r19,-128',
    0xD7910: 'l.sub r12,r17,r7', 0xD7914: 'l.srli r13,r12,6',
    0xD7918: 'l.sub r12,r15,r13', 0xD791C: 'l.jal 0x1a4890',
    0xD7920: 'l.slli r11,r12,6', 0xD7924: 'l.ori r4,r16,0x0',
    0xD7928: 'l.addi r5,r0,64', 0xD792C: 'l.addi r3,r11,10784',
    0xD7930: 'l.jal 0x1a14c4', 0xD7934: 'l.lwz r3,-32(r2)',
    0xD7938: 'l.ori r4,r16,0x0', 0xD793C: 'l.ori r5,r14,0x0',
    0xD7940: 'l.sw -72(r2),r3', 0xD7944: 'l.ori r3,r10,0x0',
    0xD7948: 'l.jal 0xd7454', 0xD794C: 'l.j 0xd78d8',
    0xD7A60: 'l.addi r19,r0,-1', 0xD7A68: 'l.addi r3,r0,10784',
    0xD7A70: 'l.addi r4,r2,-64', 0xD7A78: 'l.addi r5,r0,64',
    0xD7A84: 'l.sw -4(r2),r19', 0xD7A90: 'l.jal 0x1a14d8',
    0xD7A94: 'l.lwz r10,4312(r12)', 0xD7A98: 'l.addi r5,r0,32',
    0xD7A9C: 'l.addi r4,r0,10816', 0xD7AA0: 'l.add r3,r10,r5',
    0xD7AA4: 'l.jal 0x1a4a04',
    0xD7D1C: 'l.jal 0xd7970', 0xD7D20: 'l.lwz r4,4308(r12)',
    0xD7D28: 'l.bnf 0xd7ddc', 0xD7D34: 'l.jal 0xd7844',
    0xD8138: 'l.jal 0xd7970', 0xD813C: 'l.lwz r4,4308(r12)',
    0xD8144: 'l.bnf 0xd81f8', 0xD8150: 'l.jal 0xd7844',
    0xD8390: 'l.jal 0xd7970', 0xD8394: 'l.lwz r4,4308(r10)',
    0xD839C: 'l.bnf 0xd8448', 0xD83A8: 'l.jal 0xd7844',
}
STRINGS = {
    0x2C24D8: (0x1A490C, 0x1A4910, 'dram_2_smem(), size is not multiple of 128'),
    0x2C2509: (0x1A4924, 0x1A4928, 'code_dma.c'),
    0x2C2579: (0x1A4B80, 0x1A4B84, 'smem_2_dram(), size is not multiple of 4'),
    0x2C2469: (0x1A4BAC, 0x1A4BB0, 'code_dma.c'),
}
WINDOWS = [(0x238AC, 0x238C8), (0x24538, 0x24544),
           (0xD7844, 0xD796C), (0xD7970, 0xD7AC4),
           (0xD7D14, 0xD7D38), (0xD8130, 0xD8154), (0xD8388, 0xD83AC),
           (0x1A14C4, 0x1A14EC), (0x1A1528, 0x1A156C),
           (0x1A15A0, 0x1A1608), (0x1A4890, 0x1A4A04),
           (0x1A4A04, 0x1A4BE8)]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output-directory', type=Path,
                    default=ROOT / 'artifacts/device/2026-11-10-eis-orc-feedback')
    args = ap.parse_args()
    dsp, ref, rtos = DSP.read_bytes(), REF.read_bytes(), RTOS.read_bytes()
    assert sha(dsp) == DSP_SHA and sha(ref) == REF_SHA and sha(rtos) == RTOS_SHA
    member = inventory(dsp)[0]
    start = int(member['offset'], 16)
    binary = dsp[start:start + member['bytes']]
    decoder = CoreDecoder(ref.decode())
    def word(offset): return struct.unpack_from('<I', binary, offset)[0]
    def ins(offset): return decoder.decode(word(offset), offset)
    checks = []
    for offset, expected in CORE.items():
        actual = ins(offset)
        assert actual == expected, (hex(offset), actual, expected)
        checks.append({'member_offset': hex(offset), 'word_le': hex(word(offset)), 'instruction': actual})
    strings = []
    for offset, (hi, lo, required) in STRINGS.items():
        high, low = word(hi), word(lo)
        assert high & 0xFC1F0000 == 0x18000000 and low & 0xFC000000 == 0xA8000000
        assert high >> 21 & 31 == low >> 16 & 31 == low >> 21 & 31 == 3
        address = (high & 0xFFFF) << 16 | low & 0xFFFF
        assert address == offset + 0x600000
        value = binary[offset:binary.index(0, offset)].decode()
        assert required in value
        strings.append({'member_offset': hex(offset), 'text': value, 'movhi': hex(hi), 'ori': hex(lo),
                        'constructed_address': hex(address)})
    cpu_expected = {0xA02C6068: 'add r5, r7, r5, lsl #6',
                    0xA02C6080: 'ldr r2, [r4, #0x20]',
                    0xA02C6084: 'str r2, [r5, #0x20]',
                    0xA02C60DC: 'str r0, [r7, #0x80]'}
    cpu_checks = []
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    for address, expected in cpu_expected.items():
        x = next(cs.disasm(rtos[address-BASE:address-BASE+4], address))
        actual = x.mnemonic + ' ' + x.op_str
        assert actual == expected
        cpu_checks.append({'address': hex(address), 'bytes': x.bytes.hex(), 'instruction': actual})
    assert struct.unpack_from('<I', rtos, 0xA02C61D0-BASE)[0] == 0xA0699160
    assert 0xD80 + 0x358 == 0x10D8 and -32 - (-64) == 0x20
    # Independent layout arithmetic only; not emulation of any DSP instruction.
    relationships = []
    for slot_index in (0, 1):
        shared = 0x0699160  # declared illustrative alias, NOT measured physical mapping
        slot = shared - 0x80 + slot_index * 0x40
        selected_offset = (2 - (((shared & 0x0FFFFFFF) - (slot & 0x0FFFFFFF)) >> 6)) << 6
        assert selected_offset == slot_index * 0x40
        relationships.append({'cpu_slot_index': slot_index, 'expected_slot_offset_from_base': hex(slot_index*0x40),
                              'orc_selected_scratch_offset': hex(selected_offset)})
    assert 0x20 + (-4 - (-64) - 0x20) == 0x3C
    scans = {}
    for target in [0xD7844, 0xD7970]:
        candidates = []
        for offset in range(0, 0x226000, 4):
            w = word(offset)
            if w >> 26 == 1:
                disp = ((w & 0x3FFFFFF) ^ 0x2000000) - 0x2000000
                if offset + disp * 4 == target:
                    candidates.append(hex(offset))
        scans[hex(target)] = candidates
    assert scans == {'0xd7844': ['0xd7d34', '0xd8150', '0xd83a8'],
                     '0xd7970': ['0xd7d1c', '0xd8138', '0xd8390']}
    out = args.output_directory.resolve()
    out.mkdir(parents=True, exist_ok=True)
    lines, windows = [], []
    for begin, end in WINDOWS:
        unknown = []
        lines.append(f'\n; member [{begin:#x},{end:#x}); static core decoding only')
        for offset in range(begin, end, 4):
            decoded = ins(offset)
            if decoded is None: unknown.append(hex(offset))
            lines.append(f'{offset:08x}: {word(offset):08x}  {decoded or ".word (unsupported encoding)"}')
        windows.append({'begin': hex(begin), 'end_exclusive': hex(end), 'sha256': sha(binary[begin:end]),
                        'words': (end-begin)//4, 'unsupported_offsets': unknown})
    (out / 'feedback-windows.asm').write_text('\n'.join(lines)+'\n')
    report = {
        'evidence_type': 'static stored ORC code/data-flow and diagnostic identity; no ORC execution or device access',
        'dsp_sha256': sha(dsp), 'rtos_sha256': sha(rtos), 'orccode_sha256': sha(binary),
        'core_instruction_checks': checks, 'core_instruction_check_count': len(checks),
        'cpu_layout_instruction_checks': cpu_checks,
        'helper_diagnostic_string_references': strings,
        'setup_path': {'setup_offset_from_context': '0xd80', 'eis_update_addr_offset_in_setup': '0x358',
                       'eis_update_addr_offset_from_context': '0x10d8', 'raw_command_source_offset': '0x58'},
        'feedback_preparation': {
            'function_member_offset': '0xd7844', 'gates': ['context+0x68 equals 20', 'context+0x10d8 nonzero'],
            'publication_read': 'named dram_2_smem called with (shared, 0x2a20, 0x80), then opaque staging helper with (0x2a20, local pointer destination, 4)',
            'slot_read': 'named dram_2_smem called with (shared-0x80, 0x2a20, 0x80); arithmetic selects a 0x40 scratch region for opaque staging helper',
            'tag_source': 'selected snapshot +0x20; local stack -32 relative to snapshot base -64',
            'before_feedback_call': 'tag saved locally, then stock EIS command function 0xd7454 called with selected snapshot',
            'tag_submission': 'opaque staging helper called with (0x2a20, local tag address, 4); named smem_2_dram called with (shared+0x3c, 0x2a20, 4)',
            'intended_protocol_inference': 'consistent arguments, helper diagnostics and CPU layout support an original tag echo; proprietary staging/external-copy effects not independently decoded',
            'empty_publication_submission': 'same destination, local default 0xffffffff; EIS command function skipped',
            'hardware_copy_or_completion_observed': False,
        },
        'preclear_preparation': {
            'function_member_offset': '0xd7970',
            'gates': ['per-stream context+0xdc0 (stride 0x14) bit 8 clear', 'context+0x68 equals 20', 'context+0x10d8 nonzero'],
            'source': 'local 0x40 snapshot, last word at stack -4 explicitly 0xffffffff',
            'submission': 'opaque staging helper called with (0x2a20, local snapshot address, 0x40); named smem_2_dram(shared+0x20, 0x2a40, 0x20), whose destination range covers shared+0x3c',
            'same_direct_callers': 'all three checked caller windows call preclear before conditional tag-feedback function',
            'condition_between': 'context+0x10d4 must be zero to call tag-feedback function',
            'runtime_visibility_or_order_observed': False,
        },
        'direct_call_encoding_scan': {'range': '[member+0, member+0x226000)', 'sites': scans,
                                      'coverage': 'bounded aligned-word encoding scan; indirect callers and code/data separation not complete'},
        'cpu_orc_relative_layout_consistency': relationships,
        'relationship_checks_are_emulation': False,
        'windows': windows,
        'not_proven': ['Actual running DSP image/PC, ORC delay behavior, proprietary instruction semantics',
                       'Actual completed external copy, CPU/DSP cache visibility or atomic publication snapshot',
                       'Warp descriptor/table fully latched, no later hardware reads, or safe reuse of slots/tables',
                       'Exact per-frame correspondence between this static path and saved 0x105/0x106 feedback logs'],
        'device_access': False,
    }
    (out / 'audit.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({'output': str(out), 'core_instruction_checks': len(checks),
                      'cpu_instruction_checks': len(cpu_checks), 'helper_string_references': len(strings),
                      'direct_tag_function_call_sites': scans['0xd7844'], 'device_access': False}, ensure_ascii=False))

if __name__ == '__main__':
    main()
