#!/usr/bin/env python3
"""Pinned offline ORC SPS/PPS-to-output and bounded gate interpretation audit.

No actual ORC/device execution; unknown encodings remain raw words. Gate truth
tables are host interpretations under two explicit branch models, not captures.
"""
import hashlib
import itertools
import json
import re
import struct
from pathlib import Path
from audit_eis_orc_core import DSP, REF, DSP_SHA, REF_SHA, CoreDecoder
from audit_eis_dsp_reference import inventory

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-10-prerecord/prerecord-orc-parameter-set-output-audit.json'
ASM = OUT.with_suffix('.asm')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def interpret_gate(ins, mode, frame_class, repeat_bit, force_bit, delayed):
    """Only these 21 decoded core positions; no calls or unsupported words."""
    regs = [0] * 32
    regs[6], regs[12] = mode, 0x1000
    memory = {0x1014: 0, 0x1020: frame_class << 4 | repeat_bit << 7,
              0x1028: force_bit << 11}
    flag, pc, path = False, 0x16318C, []

    def ordinary(text):
        nonlocal flag
        if m := re.fullmatch(r'l.lwz r(\d+),(\d+)\(r(\d+)\)', text):
            rd, offset, ra = map(int, m.groups())
            regs[rd] = memory[regs[ra] + offset]
        elif m := re.fullmatch(r'l.srli r(\d+),r(\d+),(\d+)', text):
            rd, ra, shift = map(int, m.groups())
            regs[rd] = regs[ra] >> shift
        elif m := re.fullmatch(r'l.andi r(\d+),r(\d+),(0x[0-9a-f]+)', text):
            rd, ra, mask = m.groups()
            regs[int(rd)] = regs[int(ra)] & int(mask, 16)
        elif m := re.fullmatch(r'l.sf(eq|ne)i r(\d+),(\d+)', text):
            op, ra, value = m.groups()
            flag = (regs[int(ra)] == int(value)) == (op == 'eq')
        else:
            raise AssertionError(('out of bounded interpreter vocabulary', text))

    for _ in range(40):
        if pc in (0x1631E0, 0x163320):
            return pc == 0x1631E0, path
        path.append(hex(pc))
        text = ins(pc)
        if m := re.fullmatch(r'l.b(f|nf) (0x[0-9a-f]+)', text):
            kind, target = m.groups()
            taken = flag if kind == 'f' else not flag
            if delayed:
                path.append(hex(pc + 4))
                ordinary(ins(pc + 4))
                if not taken and pc + 4 == 0x1631E0:
                    return True, path
            pc = int(target, 16) if taken else pc + (8 if delayed else 4)
        else:
            ordinary(text)
            pc += 4
    raise AssertionError('bounded gate did not terminate')


def main():
    dsp, reference = DSP.read_bytes(), REF.read_bytes()
    assert sha(dsp) == DSP_SHA and sha(reference) == REF_SHA
    member = inventory(dsp)[0]
    start = int(member['offset'], 16)
    binary = dsp[start:start + member['bytes']]
    decoder = CoreDecoder(reference.decode())

    def word(address):
        return struct.unpack_from('<I', binary, address)[0]

    def ins(address):
        return decoder.decode(word(address), address)

    expected = {
        0x1730F0: 'l.ori r10,r3,0x0', 0x1730F8: 'l.ori r12,r4,0x0',
        0x173114: 'l.sfnei r10,0', 0x173118: 'l.bnf 0x1734d8',
        0x1734E4: 'l.movhi r3,0x8b', 0x1734E8: 'l.ori r3,r3,0x499c',
        0x1734EC: 'l.jal 0x19fe44',
        0x163150: 'l.srli r19,r4,28', 0x163154: 'l.andi r6,r19,0x3',
        0x16318C: 'l.lwz r5,32(r12)', 0x163190: 'l.srli r8,r5,4',
        0x163194: 'l.andi r7,r8,0x3', 0x163198: 'l.sfeqi r7,2',
        0x16319C: 'l.bf 0x1631b4', 0x1631A0: 'l.lwz r11,40(r12)',
        0x1631A4: 'l.srli r10,r11,11', 0x1631A8: 'l.andi r9,r10,0x1',
        0x1631AC: 'l.sfnei r9,0', 0x1631B0: 'l.bnf 0x163320',
        0x1631B4: 'l.sfnei r6,1', 0x1631B8: 'l.bf 0x163320',
        0x1631BC: 'l.srli r13,r5,7', 0x1631C0: 'l.andi r6,r13,0x1',
        0x1631C4: 'l.sfnei r6,0', 0x1631C8: 'l.bf 0x1631e0',
        0x1631CC: 'l.lwz r15,40(r12)', 0x1631D0: 'l.srli r14,r15,11',
        0x1631D4: 'l.andi r5,r14,0x1', 0x1631D8: 'l.sfnei r5,0',
        0x1631DC: 'l.bnf 0x163320',
        0x1631E0: 'l.lwz r21,20(r12)',
        0x1631EC: 'l.addi r18,r12,12', 0x1631F8: 'l.addi r22,r20,8',
        0x163220: 'l.addi r10,r27,172', 0x163228: 'l.ori r3,r10,0x0',
        0x163230: 'l.jal 0x1730d0', 0x163238: 'l.ori r4,r10,0x0',
        0x163244: 'l.ori r7,r22,0x0', 0x163248: 'l.jal 0x173ed4',
        0x163250: 'l.ori r5,r11,0x0', 0x163258: 'l.addi r6,r0,7',
        0x163268: 'l.ori r4,r20,0x0', 0x16326C: 'l.jal 0x172d24',
        0x163278: 'l.jal 0x177004', 0x1632A4: 'l.addi r24,r9,188',
        0x1632B4: 'l.ori r3,r24,0x0', 0x1632C0: 'l.jal 0x173544',
        0x1632C8: 'l.ori r5,r24,0x0', 0x1632DC: 'l.jal 0x1744a4',
        0x1632E4: 'l.ori r5,r11,0x0', 0x1632F0: 'l.addi r6,r0,8',
        0x1632FC: 'l.ori r4,r20,0x0', 0x163304: 'l.jal 0x172d24',
        0x163310: 'l.jal 0x177004',
        0x172D54: 'l.slli r20,r6,24', 0x172D58: 'l.srai r20,r20,24',
        0x172E20: 'l.andi r18,r20,0xf', 0x172E2C: 'l.slli r10,r18,11',
        0x172E38: 'l.or r4,r9,r10', 0x172E3C: 'l.sw 0(r12),r4',
        0x172F98: 'l.sw 4(r12),r14',
        0x177018: 'l.lwz r5,0(r4)', 0x17701C: 'l.addi r3,r4,8',
        0x177024: 'l.srli r13,r5,11', 0x177030: 'l.andi r9,r13,0xf',
        0x177038: 'l.lwz r10,4(r4)', 0x177040: 'l.ori r5,r10,0x0',
        0x177048: 'l.jal 0x176efc', 0x176F10: 'l.andi r7,r4,0xff',
        0x176FF0: 'l.jal 0x1a1794',
        0x1A17A0: 'l.ori r8,r8,0x1f', 0x1A17B0: 'l.ori r8,r8,0x7',
        0x1A17D4: 'l.lwz r11,0(r3)', 0x1A17F8: 'l.lwz r11,0(r3)',
    }
    assertions = []
    for address, text in expected.items():
        assert ins(address) == text, (hex(address), ins(address), text)
        assertions.append(dict(offset=hex(address), word=hex(word(address)), instruction=text))
    string_offset = 0x2B499C
    text = binary[string_offset:binary.index(0, string_offset)].decode()
    assert text == 'ENG0: === eng0_GenerateSequenceParameterSet() (sps != NULL)\n'
    assert ((word(0x1734E4) & 65535) << 16 | word(0x1734E8) & 65535) == string_offset + 0x600000

    cases = []
    for mode, frame, repeat_bit, force_bit in itertools.product(range(4), range(4), range(2), range(2)):
        formula = mode == 1 and (force_bit == 1 or (frame == 2 and repeat_bit == 1))
        results = []
        for delayed in (False, True):
            result, path = interpret_gate(ins, mode, frame, repeat_bit, force_bit, delayed)
            assert result == formula
            results.append(dict(assumed_branch_delay=delayed, selects_generator_path=result, interpreted_path=path))
        cases.append(dict(constructed_mode_field=mode, constructed_frame_class=frame,
                          constructed_picture_0x20_bit7=repeat_bit, constructed_picture_0x28_bit11=force_bit,
                          both_branch_models_agree=True, models=results))

    special_words = {0x1A17A4: 0xF0083012, 0x1A17A8: 0xF0000089,
                     0x1A17B4: 0xF0083812, 0x1A17B8: 0xF0000089,
                     0x1A17D8: 0xF0085832, 0x1A17DC: 0xF0000089,
                     0x1A1800: 0xF0055832, 0x1A1804: 0xF0000089}
    for address, value in special_words.items():
        assert word(address) == value and ins(address) is None
    windows = [(0x1630B8, 0x163320), (0x172D24, 0x172E60), (0x172F98, 0x172FD0),
               (0x1730D0, 0x173124), (0x1734D8, 0x173544),
               (0x173ED4, 0x173F50), (0x1744A4, 0x17451C),
               (0x176EFC, 0x177064), (0x1A1794, 0x1A1814)]
    regions, assembly = [], []
    for lo, hi in windows:
        unknown = []
        assembly.append(f'\n; member [{lo:#x},{hi:#x}); static encoding only')
        for address in range(lo, hi, 4):
            decoded = ins(address)
            if decoded is None:
                unknown.append(hex(address))
            assembly.append(f'{address:08x}: {word(address):08x}  {decoded or ".word (unsupported encoding)"}')
        regions.append(dict(begin=hex(lo), end_exclusive=hex(hi), sha256=sha(binary[lo:hi]),
                            words=(hi-lo)//4, unsupported_offsets=unknown))
    call_inventory = []
    targets = {0x1730D0, 0x173544, 0x1630B8}
    for address in range(0, len(binary)-3, 4):
        value = word(address)
        if value >> 26 == 1:
            displacement = value & 0x3FFFFFF
            if displacement & 0x2000000:
                displacement -= 0x4000000
            target = address + displacement * 4
            if target in targets:
                call_inventory.append(dict(offset=hex(address), target=hex(target), instruction=ins(address)))
    assert {(v['offset'], v['target']) for v in call_inventory} == {
        ('0x163230', '0x1730d0'), ('0x1632c0', '0x173544'),
        ('0x164ed0', '0x1630b8'), ('0x164fdc', '0x1630b8')}
    ASM.write_text('\n'.join(assembly) + '\n')
    report = dict(evidence_type='Pinned static ORC core decode and bounded host interpretation under two branch models; no device or actual ORC execution',
                  dsp_sha256=DSP_SHA, orccode_sha256=sha(binary), decoder_reference_sha256=REF_SHA,
                  assertions=assertions, assertion_count=len(assertions),
                  sps_diagnostic=dict(offset=hex(string_offset), text=text, address_alias_delta='0x600000'),
                  gate_interpretations=cases, gate_input_combinations=len(cases), gate_interpretation_count=2*len(cases),
                  gate_formula='mode_field==1 && (picture_0x28_bit11 || (frame_class==2 && picture_0x20_bit7))',
                  gate_entry='0x16318c', generator_block='0x1631e0', bypass_block='0x163320',
                  aligned_direct_call_encoding_inventory=call_inventory,
                  output_chain=['0x163230 -> SPS struct builder 0x1730d0; serializer 0x173ed4',
                                '0x16326c -> NAL builder 0x172d24 with r6=7; 0x163278 -> 0x177004',
                                '0x1632c0 -> second parameter struct builder 0x173544; serializer 0x1744a4',
                                '0x163304 -> NAL builder 0x172d24 with r6=8; 0x163310 -> 0x177004',
                                '0x177004 -> header extraction and payload length -> 0x176efc -> 0x1a1794'],
                  unsupported_output_words=[dict(offset=hex(a), raw_word=hex(w)) for a,w in special_words.items()],
                  regions=regions,
                  limitations=['Branch execution model is not established; bounded gate results agree under both explicit tested models only.',
                               'No proven mapping of CPU header mode or state+0x50c bit21 to these picture fields; frame class2 is not declared identical to mux type1 or IDR.',
                               'Unsupported output words block a proven final start-code/NAL-byte, hardware FIFO, DRAM-ring or cache publication contract.',
                               'Aligned direct-call encoding inventory does not resolve indirect calls or prove a complete runtime call graph.',
                               'No current camera settings, captured encoder command, real NAL stream, frame continuity or playable minute prerecord was verified.'],
                  next_verifiable_path='Trace writers/copy provenance of picture+0x20 bit7 and picture+0x28 bit11 at callers 0x164ed0/0x164fdc; their gate is core-decodable without interpreting output extension words.',
                  device_access=False, actual_orc_execution=False)
    OUT.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)), core_assertions=len(assertions),
                          gate_inputs=len(cases), gate_interpretations=len(cases)*2,
                          unsupported_output_words=len(special_words), regions=len(regions))))


if __name__ == '__main__':
    main()
