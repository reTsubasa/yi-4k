#!/usr/bin/env python3
"""Offline static IDR-selector/header-gate invariant and producer transport.

Interprets only named core words under two explicit branch models. No calls,
unknown extension opcodes, queue execution, bitstream capture or camera IO.
"""
import hashlib
import importlib.util
import itertools
import json
import re
import struct
from pathlib import Path
from audit_eis_orc_core import DSP, REF, DSP_SHA, REF_SHA, CoreDecoder
from audit_eis_dsp_reference import inventory

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-10-prerecord/prerecord-orc-idr-header-invariant-audit.json'
spec = importlib.util.spec_from_file_location('parameter_gate', ROOT / 'scripts/prerecord-orc-parameter-set-output.py')
gate_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gate_module)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def interpret_core(ins, start, stops, registers, memory, delayed):
    """Small bounded host interpreter, not an ORC machine execution model."""
    regs = [0] * 32
    for index, value in registers.items():
        regs[index] = value
    flag, pc, path = False, start, []

    def ordinary(text):
        nonlocal flag
        if m := re.fullmatch(r'l.(lwz|lhz) r(\d+),(\d+)\(r(\d+)\)', text):
            op, rd, offset, ra = m.groups()
            value = memory[regs[int(ra)] + int(offset)]
            regs[int(rd)] = value & (0xffff if op == 'lhz' else 0xffffffff)
        elif m := re.fullmatch(r'l.(andi|ori|addi) r(\d+),r(\d+),(-?\d+|0x[0-9a-f]+)', text):
            op, rd, ra, value = m.groups()
            a, value = regs[int(ra)], int(value, 0)
            regs[int(rd)] = {'andi': lambda: a & value, 'ori': lambda: a | value,
                              'addi': lambda: (a + value) & 0xffffffff}[op]()
        elif m := re.fullmatch(r'l.sf(eq|ne)i r(\d+),(\d+)', text):
            op, ra, value = m.groups()
            flag = (regs[int(ra)] == int(value)) == (op == 'eq')
        else:
            raise AssertionError(('out of bounded core vocabulary', text))

    for _ in range(24):
        if pc in stops:
            return pc, regs, path
        text = ins(pc)
        path.append(hex(pc))
        m = re.fullmatch(r'l.b(f|nf) (0x[0-9a-f]+)', text)
        jump = re.fullmatch(r'l.j (0x[0-9a-f]+)', text)
        if m or jump:
            if m:
                kind, target = m.groups()
                taken = flag if kind == 'f' else not flag
            else:
                target, taken = jump.group(1), True
            if delayed:
                path.append(hex(pc + 4))
                ordinary(ins(pc + 4))
            pc = int(target, 16) if taken else pc + (8 if delayed else 4)
        else:
            ordinary(text)
            pc += 4
    raise AssertionError('bounded core window failed to terminate')


def main():
    dsp, reference = DSP.read_bytes(), REF.read_bytes()
    assert sha(dsp) == DSP_SHA and sha(reference) == REF_SHA
    member = inventory(dsp)[0]
    begin = int(member['offset'], 16)
    binary = dsp[begin:begin + member['bytes']]
    decoder = CoreDecoder(reference.decode())

    def word(address):
        return struct.unpack_from('<I', binary, address)[0]

    def ins(address):
        return decoder.decode(word(address), address)

    expected = {
        # Producer: message payload selected from encoder state.
        0xA0B2C: 'l.andi r14,r5,0xff', 0xA0B30: 'l.ori r16,r4,0x0',
        0xA0B3C: 'l.sfnei r14,0', 0xA0B40: 'l.bf 0xa0bf8',
        0xA0B44: 'l.lwz r4,72(r3)', 0xA0B48: 'l.addi r10,r0,5',
        0xA0B54: 'l.addi r12,r4,1308',
        0xA0B78: 'l.slli r6,r5,2', 0xA0B80: 'l.add r8,r6,r12',
        0xA0B88: 'l.lwz r3,0(r8)', 0xA0B8C: 'l.add r7,r6,r16',
        0xA0B94: 'l.sw 4(r7),r3',
        0xA0BF8: 'l.sfnei r14,1', 0xA0BFC: 'l.bf 0xa0c18',
        0xA0C00: 'l.lwz r4,72(r3)', 0xA0C04: 'l.addi r10,r0,7',
        0xA0C10: 'l.addi r12,r4,1328',
        # Message code1: same value passed to packer and queue-header setter.
        0xAB3BC: 'l.addi r5,r0,1', 0xAB3C0: 'l.jal 0xa0b08',
        0xAB3C4: 'l.ori r3,r14,0x0', 0xAB3C8: 'l.addi r4,r0,1',
        0xAB3CC: 'l.jal 0x164bfc',
        0x164C1C: 'l.andi r5,r4,0xff', 0x164C2C: 'l.jal 0x1b2ee8',
        0x1B2EF8: 'l.sb 2(r3),r5',
        # Consumer: message type0->picture+12; type1->picture+32.
        0x16583C: 'l.ori r9,r4,0x0', 0x165840: 'l.ori r14,r3,0x0',
        0x165844: 'l.lbz r4,2(r4)', 0x165848: 'l.sfnei r4,0',
        0x16584C: 'l.bf 0x165938', 0x165854: 'l.addi r12,r3,12',
        0x165868: 'l.add r8,r6,r9', 0x165870: 'l.lwz r3,4(r8)',
        0x165874: 'l.add r4,r6,r12', 0x165878: 'l.sfltui r7,5',
        0x16587C: 'l.sw 0(r4),r3',
        0x165938: 'l.sfnei r4,1', 0x16593C: 'l.bf 0x165aa0',
        0x165948: 'l.addi r10,r3,32', 0x16595C: 'l.add r11,r13,r9',
        0x165964: 'l.lwz r3,4(r11)', 0x165968: 'l.add r4,r13,r10',
        0x16596C: 'l.sfltui r7,7', 0x165970: 'l.sw 0(r4),r3',
        0x165A18: 'l.ori r3,r14,0x0', 0x165A1C: 'l.jal 0x164cc0',
        # Per-picture entry and first-slice index reset/calls.
        0x164CEC: 'l.ori r10,r3,0x0', 0x164D78: 'l.lwz r4,16(r10)',
        0x164D84: 'l.sfnei r3,1', 0x164D8C: 'l.lwz r31,28(r10)',
        0x164D98: 'l.bf 0x164ed8', 0x164D9C: 'l.addi r4,r0,0',
        0x164DA4: 'l.sh 266(r10),r4',
        0x164ECC: 'l.ori r3,r10,0x0', 0x164ED0: 'l.jal 0x1630b8',
        0x164F00: 'l.addi r12,r0,0', 0x164F2C: 'l.addi r18,r0,0',
        0x164F60: 'l.sh 266(r10),r12',
        0x164FD8: 'l.ori r3,r10,0x0', 0x164FDC: 'l.jal 0x1630b8',
        # Early first-slice gate and same-object IDR NAL selector.
        0x163110: 'l.lhz r5,266(r12)', 0x163114: 'l.sfnei r5,0',
        0x163118: 'l.bf 0x16348c', 0x16311C: 'l.lwz r4,16(r12)',
        0x1633B8: 'l.lwz r19,32(r12)', 0x1633BC: 'l.ori r5,r11,0x0',
        0x1633C0: 'l.andi r16,r19,0xb0', 0x1633C4: 'l.sfnei r16,160',
        0x1633C8: 'l.bf 0x163434', 0x1633CC: 'l.addi r6,r0,5',
        0x163434: 'l.addi r6,r0,1', 0x163438: 'l.j 0x1633d0',
        0x16343C: 'l.ori r3,r12,0x0',
        0x163400: 'l.jal 0x172d24', 0x16340C: 'l.jal 0x177004',
        # Exact official H264/JPEG distinction for M=1/3.
        0x16356C: 'l.lwz r5,16(r10)', 0x163570: 'l.srli r4,r5,28',
        0x163574: 'l.andi r3,r4,0x3', 0x163578: 'l.sfnei r3,1',
        0x16357C: 'l.bf 0x1635e8',
        0x1635D8: 'l.movhi r3,0x8b', 0x1635DC: 'l.ori r3,r3,0x2160',
        0x1635E0: 'l.jal 0x19fe44', 0x1635E8: 'l.sfnei r3,3',
        0x163614: 'l.movhi r3,0x8b', 0x163618: 'l.ori r3,r3,0x21ac',
        0x16361C: 'l.jal 0x19fe44',
    }
    assertions = []
    for address, expected_text in expected.items():
        assert ins(address) == expected_text, (hex(address), ins(address), expected_text)
        assertions.append(dict(offset=hex(address), word=hex(word(address)), instruction=expected_text))
    diagnostics = []
    for offset, high, low, fragment in (
        (0x2B2160, 0x1635D8, 0x1635DC, 'h.264 bitstream coding'),
        (0x2B21AC, 0x163614, 0x163618, 'jpeg bitstream coding')):
        text = binary[offset:binary.index(0,offset)].decode()
        assert fragment in text
        assert (word(high)&65535)<<16 | word(low)&65535 == offset+0x600000
        diagnostics.append(dict(offset=hex(offset), text=text, movhi=hex(high), ori=hex(low)))

    selector_cases, invariant_cases = [], []
    for raw in range(256):
        for delayed in (False, True):
            _, regs, path = interpret_core(ins, 0x1633B8, {0x1633D0},
                                           {12:0x1000,11:123}, {0x1020:raw}, delayed)
            nal_type = regs[6]
            assert nal_type == (5 if raw & 0xB0 == 0xA0 else 1)
            selector_cases.append(dict(constructed_picture_0x20_low_byte=raw,
                                       assumed_branch_delay=delayed, selected_nal_type=nal_type))
            for force in (0,1):
                selected, _ = gate_module.interpret_gate(ins, 1, raw>>4&3, raw>>7&1, force, delayed)
                assert selected == bool(force or nal_type==5)
                assert nal_type != 5 or selected
                invariant_cases.append(dict(constructed_picture_0x20_low_byte=raw,
                                           constructed_picture_0x28_bit11=force,
                                           assumed_branch_delay=delayed,
                                           selected_slice_nal_type=nal_type,
                                           selects_sps_pps_path=selected))
    first_slice_cases = []
    for index, delayed in itertools.product((0,1,7,65535),(False,True)):
        pc, _, path = interpret_core(ins, 0x163110, {0x16311C,0x163120,0x16348C},
                                     {12:0x1000}, {0x110A:index,0x1010:1<<28}, delayed)
        bypass = pc == 0x16348C
        assert bypass == (index != 0)
        first_slice_cases.append(dict(constructed_picture_slice_index=index,
                                      assumed_branch_delay=delayed, bypasses_parameter_gate=bypass))

    layout = [dict(field='H264/JPEG discriminator M', state_offset='0x520', state_bits='28..29',
                   message_code=0, message_offset='0x8', picture_offset='0x10', picture_bits='28..29'),
              dict(field='slice-class pair C/R', state_offset='0x530', state_bits='4..5,7',
                   message_code=1, message_offset='0x4', picture_offset='0x20', picture_bits='4..5,7'),
              dict(field='additional-header condition F', state_offset='0x538', state_bits='11',
                   message_code=1, message_offset='0xc', picture_offset='0x28', picture_bits='11')]
    for state_offset, source_base, picture_base, picture_offset in (
        (0x520,0x51c,0xc,0x10),(0x530,0x530,0x20,0x20),(0x538,0x530,0x20,0x28)):
        assert picture_base + state_offset-source_base == picture_offset
    windows = [(0xA0B08,0xA0BA0),(0xA0BF8,0xA0C18),(0xAB3B4,0xAB3D0),
               (0x164BFC,0x164C38),(0x1B2EE8,0x1B2F10),
               (0x16581C,0x165884),(0x165938,0x16597C),(0x165A18,0x165A24),
               (0x164CC0,0x164DB8),(0x164ECC,0x164ED8),(0x164EF8,0x164F80),
               (0x164FD0,0x164FE8),(0x163110,0x16318C),(0x16318C,0x1631E4),
               (0x1633B8,0x163440),(0x16356C,0x163624)]
    regions = []
    for lo,hi in windows:
        rows = [dict(offset=hex(a),word=hex(word(a)),instruction=ins(a)) for a in range(lo,hi,4)]
        regions.append(dict(begin=hex(lo),end_exclusive=hex(hi),sha256=sha(binary[lo:hi]),instructions=rows))
    assert all(row['instruction'] is not None for r in regions for row in r['instructions'])
    result = dict(evidence_type='Pinned static ORC core words, diagnostic references and bounded host interpretation; no actual ORC or camera execution',
                  dsp_sha256=DSP_SHA,orccode_sha256=sha(binary),decoder_reference_sha256=REF_SHA,
                  assertions=assertions,assertion_count=len(assertions),diagnostics=diagnostics,
                  transport_layout=layout,
                  selector_interpretations=selector_cases,selector_interpretation_count=len(selector_cases),
                  header_invariant_interpretations=invariant_cases,header_invariant_interpretation_count=len(invariant_cases),
                  idr_selector_cases=sum(c['selected_nal_type']==5 for c in selector_cases),
                  first_slice_gate_interpretations=first_slice_cases,
                  regions=regions,
                  static_invariant='For M=1/H264 and first slice index0, the raw predicate selecting slice NAL5 (picture+0x20 & 0xb0 == 0xa0) also selects the SPS/PPS production path, regardless of F.',
                  interpretation_premises=['Both ordinary non-delayed branches and one-delay-instruction branches are tested only in the named short gates; a whole-ORC execution model is not claimed.',
                                           'The invariant compares the same constructed picture-field snapshot. Complete helper side effects, exceptions and runtime scheduling are outside scope.',
                                           'The separate indexed copy loops statically map encoder state into message payload and consumer picture storage; actual queue delivery is not executed.'],
                  limitations=['No CPU header_mode0/1 or state+0x50c bit21 mapping was established; this result uses the independent NAL5 selector.',
                               'The extra header condition F has a concrete state+0x538 bit11 source; its assignment/meaning remains unresolved.',
                               'Mux type1 and real FIFO descriptors are not yet proven equal to this NAL5 producer classification.',
                               'No final proprietary output op, NAL byte stream/ring boundary, DSP runtime identity or playable prerecord was verified.'],
                  device_access=False,actual_orc_execution=False)
    OUT.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),core_assertions=len(assertions),
                          selector_interpretations=len(selector_cases),header_invariant_interpretations=len(invariant_cases),
                          first_slice_interpretations=len(first_slice_cases),regions=len(regions))))


if __name__ == '__main__':
    main()
