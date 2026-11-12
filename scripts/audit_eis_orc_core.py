#!/usr/bin/env python3
"""Decode only encoding-verified OR1K-compatible core windows in stored ORC.

Offline static evidence. No execution, delay-slot emulation, device access,
whole-ISA claim, or inference of DSP runtime identity/ownership.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import re
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DSP = ROOT / 'artifacts/firmware/v1.10.52/_part_dsp.a9s'
REF = ROOT / 'artifacts/device/2026-11-10-eis-orc-core/reference/or1k-opc.c'
DSP_SHA = '9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73'
REF_SHA = '4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c'
# Only explicit operand formats below are emitted as instructions.
FORMATS = {'ifmt_l_j', 'ifmt_l_jr', 'ifmt_l_nop_imm', 'ifmt_l_movhi',
           'ifmt_l_lwz', 'ifmt_l_sw', 'ifmt_l_sll', 'ifmt_l_slli',
           'ifmt_l_and', 'ifmt_l_mfspr', 'ifmt_l_sfgts', 'ifmt_l_sfgtsi'}
STRINGS = {
    0x22E4BA: (0x258EC, 0x258F0),
    0x260B98: (0x9174C, 0x91750),
    0x260C57: (0x917B4, 0x917B8),
    0x288191: (0xD7728, 0xD772C),
    0x288257: (0xD7784, 0xD7788),
    0x28CCCE: (0xE2FFC, 0xE3000),
    0x28CCFB: (0xE3014, 0xE3018),
}
WINDOWS = [(0, 0x40), (0x24538, 0x24558), (0x258E8, 0x25914),
           (0x916F0, 0x917CC), (0xD7454, 0xD781C), (0xE2FCC, 0xE306C),
           (0x1A14C4, 0x1A1510), (0x1A16B8, 0x1A16D0)]
CHECKS = {
    0: 'l.j 0x98', 4: 'l.nop 0x0',
    0x2453C: 'l.lwz r3,88(r14)',
    0x24540: 'l.sw 856(r16),r3',
    0x25904: 'l.lwz r7,856(r16)',
    0x2590C: 'l.jal 0x19fe44',
    0x91718: 'l.lwz r3,5164(r10)',
    0x91740: 'l.jal 0x1a16b8',
    0x91754: 'l.jal 0x19fe44',
    0xD7690: 'l.lwz r3,36(r10)',
    0xD769C: 'l.addi r10,r2,-80',
    0xD76A0: 'l.jal 0x1a4890',
    0xD76C0: 'l.lwz r23,-80(r2)',
    0xD76D4: 'l.sfeq r23,r12',
    0xD7730: 'l.jal 0x19fe44',
    0xE2FF0: 'l.ori r12,r3,0x0',
    0xE2FF8: 'l.ori r10,r4,0x0',
    0xE3010: 'l.lwz r9,0(r12)',
    0xE301C: 'l.sw 24(r10),r9',
    0xE3020: 'l.lbz r8,4(r12)',
    0xE3024: 'l.sb 28(r10),r8',
    0xE3028: 'l.lbz r4,5(r12)',
    0xE302C: 'l.sb 29(r10),r4',
    0xE3068: 'l.jr r9',
}


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sign(value: int, bits: int) -> int:
    return (value ^ (1 << (bits - 1))) - (1 << (bits - 1))


class CoreDecoder:
    def __init__(self, reference: str):
        masks = {name: int(mask, 16) for name, mask in re.findall(
            r'static const CGEN_IFMT (\w+) ATTRIBUTE_UNUSED = \{\s*32, 32, (0x[0-9a-f]+)', reference)}
        self.table = [(syntax, fmt, int(value, 16), masks[fmt]) for syntax, fmt, value in re.findall(
            r'/\* (l\.[^\n]+) \*/\s*\{.*?& (ifmt_\w+), \{ (0x[0-9a-f]+) \}', reference, re.S)
            if fmt in FORMATS]

    def decode(self, word: int, offset: int) -> str | None:
        found = next(((s, f) for s, f, value, mask in self.table if word & mask == value), None)
        if found is None:
            return None
        syntax, _ = found
        values = {
            '${disp26}': hex(offset + sign(word & 0x3FFFFFF, 26) * 4),
            '${simm16-split}': str(sign((word >> 10 & 0xF800) | (word & 0x7FF), 16)),
            '${simm16}': str(sign(word & 0xFFFF, 16)),
            '$simm16': str(sign(word & 0xFFFF, 16)),
            '${uimm16}': hex(word & 0xFFFF), '$uimm16': hex(word & 0xFFFF),
            '${uimm6}': str(word & 63), '$rD': f'r{word >> 21 & 31}',
            '$rA': f'r{word >> 16 & 31}', '$rB': f'r{word >> 11 & 31}',
        }
        for token, value in values.items():
            syntax = syntax.replace(token, value)
        return None if '$' in syntax else syntax


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output-directory', type=Path,
                    default=ROOT / 'artifacts/device/2026-11-10-eis-orc-core')
    args = ap.parse_args()
    dsp, ref = DSP.read_bytes(), REF.read_bytes()
    assert sha(dsp) == DSP_SHA and sha(ref) == REF_SHA, 'Pinned input changed'
    # Parse the directory and CRCs using the existing strict inventory parser.
    from audit_eis_dsp_reference import inventory
    member = inventory(dsp)[0]
    start, size = int(member['offset'], 16), member['bytes']
    binary = dsp[start:start + size]
    decoder = CoreDecoder(ref.decode())

    def word(offset: int) -> int:
        return struct.unpack_from('<I', binary, offset)[0]

    def ins(offset: int) -> str | None:
        return decoder.decode(word(offset), offset)

    checks = []
    for offset, expected in CHECKS.items():
        actual = ins(offset)
        assert actual == expected, (hex(offset), actual, expected)
        checks.append({'member_offset': hex(offset), 'word_le': hex(word(offset)), 'instruction': actual})
    xrefs = []
    for string_offset, (hi_site, lo_site) in STRINGS.items():
        high, low = word(hi_site), word(lo_site)
        assert high & 0xFC1F0000 == 0x18000000  # l.movhi
        assert low & 0xFC000000 == 0xA8000000  # l.ori
        assert high >> 21 & 31 == low >> 16 & 31 == low >> 21 & 31 == 3
        address = (high & 0xFFFF) << 16 | low & 0xFFFF
        assert address - string_offset == 0x600000
        text = binary[string_offset:binary.index(0, string_offset)].decode('ascii')
        # Independently locate the next common diagnostic-call encoding.
        calls = [p for p in range(lo_site + 4, lo_site + 32, 4)
                 if word(p) >> 26 == 1 and ins(p) == 'l.jal 0x19fe44']
        # before/after warp strings branch to common calls a little farther away.
        if string_offset not in (0x28CCCE, 0x28CCFB):
            assert len(calls) == 1
        xrefs.append({'string_member_offset': hex(string_offset), 'text': text,
                      'movhi_site': hex(hi_site), 'ori_site': hex(lo_site),
                      'constructed_address': hex(address), 'constant_string_alias_delta': '0x600000',
                      'nearby_print_calls': [hex(x) for x in calls]})
    assembly, regions = [], []
    for begin, end in WINDOWS:
        unknown = []
        assembly.append(f'\n; member [{begin:#x},{end:#x}); relative branch targets only')
        for offset in range(begin, end, 4):
            decoded = ins(offset)
            if decoded is None:
                unknown.append(hex(offset))
            assembly.append(f'{offset:08x}: {word(offset):08x}  {decoded or ".word (unsupported encoding)"}')
        regions.append({'begin': hex(begin), 'end_exclusive': hex(end),
                        'sha256': sha(binary[begin:end]), 'instructions': (end-begin)//4,
                        'unsupported_encoding_offsets': unknown})
    out = args.output_directory.resolve()
    out.mkdir(parents=True, exist_ok=True)
    (out / 'core-windows.asm').write_text('\n'.join(assembly) + '\n')
    report = {
        'evidence_type': 'static little-endian OR1K-compatible core encoding and linked string-reference audit; no execution',
        'dsp_sha256': sha(dsp), 'orccode_sha256': sha(binary),
        'reference': json.loads(REF.with_name('source.json').read_text()),
        'instruction_checks': checks, 'instruction_check_count': len(checks),
        'string_references': xrefs, 'string_reference_count': len(xrefs),
        'windows': regions,
        'supported_encoding_patterns': len(decoder.table),
        'observations': [
            'Seven selected DSP diagnostic addresses are constructed by matched movhi/ori pairs; each equals its orccode file offset plus 0x600000.',
            'Five diagnostics directly call the same relative target 0x19fe44; two warp-control diagnostics reach it through branches.',
            'The setup eis_update_addr print argument comes from setup_params+0x358, previously stored from raw command+0x58.',
            'Warp-control helper at member+0xe2fcc copies input u32/byte/byte to destination+0x18/+0x1c/+0x1d.',
            'Generic OR1K delay-slot semantics must not be assumed: adjacent calls and function prologues after jr require a separately verified execution model.',
        ],
        'not_proven': ['Complete ORC ISA, special instruction semantics, delay behavior, actual execution or running image identity',
                       'The 0x600000 string alias is an ARM physical address or DSP code PC base',
                       'DSP shared+0x3c non-sentinel writer, echo/latch/cache protocol, or safe old-slot/table release'],
        'next_scope': ['Recover raw VCAP command-to-setup conversion and consumer of setup+0x358; verify DRAM access helpers before assigning ordinary load/store semantics to external memory',
                       'Trace the member+0xd7454 EIS command path and data fetched via helpers 0x1a4890/0x1a14c4; do not treat the diagnostic warp helper as a completion signal'],
        'device_access': False, 'emulation': False,
    }
    (out / 'audit.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'output': str(out), 'instruction_checks': len(checks), 'string_references': len(xrefs),
                      'window_words': sum(r['instructions'] for r in regions),
                      'decoded_core_words': sum(r['instructions'] - len(r['unsupported_encoding_offsets']) for r in regions),
                      'unsupported_words': sum(len(r['unsupported_encoding_offsets']) for r in regions),
                      'device_access': False}, ensure_ascii=False))


if __name__ == '__main__':
    main()
