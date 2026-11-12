#!/usr/bin/env python3
"""Export selected, statically confirmed A32 windows; never executes firmware.

Run: .venv-reverse/bin/python scripts/rtos_image_ipc.py
Focused evidence exporter, not a function finder or ARM/Thumb detector.
MOVW/MOVT annotations are proximity heuristics, not full data-flow analysis.
"""
from pathlib import Path
import hashlib
import json
import struct
import capstone
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/firmware/v1.10.52/_part_lrtos.a9s'
OUTPUT = ROOT / 'artifacts/rtos-reverse/image-ipc'
SHA256 = 'c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141'
BASE = 0xA0100000
WINDOWS = [
    (0xA03119A8, 0xA0312AA0), (0xA030DF5C, 0xA030E334),
    (0xA030F030, 0xA030FA30), (0xA03C9188, 0xA03C9220),
    (0xA03C4E94, 0xA03C51F0), (0xA022D820, 0xA022EE00),
    (0xA022B96C, 0xA022C8BC), (0xA0227DFC, 0xA0228300),
    (0xA0245CF4, 0xA02464C0), (0xA03CD3F0, 0xA03CD500),
]


def main():
    data = SOURCE.read_bytes()
    actual = hashlib.sha256(data).hexdigest()
    if actual != SHA256:
        raise SystemExit(f'Refusing version-specific addresses: expected {SHA256}, got {actual}')
    OUTPUT.mkdir(parents=True, exist_ok=True)
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)

    def cstr(address):
        offset = address - BASE
        if not 0 <= offset < len(data):
            return None
        end = data.find(b'\0', offset, offset + 400)
        if end < 0:
            return None
        raw = data[offset:end]
        return raw.decode('ascii') if raw and all(x in (9, 10, 13) or 32 <= x < 127 for x in raw) else None

    exports = []
    for start, end in WINDOWS:
        if not 0 <= start - BASE < end - BASE <= len(data):
            raise SystemExit(f'Window outside source: {start:#x}..{end:#x}')
        lines = [f'; source SHA256 {SHA256}', f'; VA base {BASE:#x}; A32 selected window, not function boundary proof',
                 '; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions']
        low = {}
        count = 0
        for insn in md.disasm(data[start - BASE:end - BASE], start):
            count += 1
            note = ''
            word = struct.unpack('<I', insn.bytes)[0]
            opcode, reg = word & 0x0FF00000, (word >> 12) & 15
            if opcode == 0x03000000:
                low[reg] = (((word >> 4) & 0xF000) | (word & 0xFFF), insn.address)
            if opcode == 0x03400000 and reg in low and insn.address - low[reg][1] <= 32:
                address = low[reg][0] | ((((word >> 4) & 0xF000) | (word & 0xFFF)) << 16)
                string = cstr(address)
                if string:
                    note = f' ; heuristic {address:#x} {string!r}'
            lines.append(f'{insn.address:08x} {insn.bytes.hex()} {insn.mnemonic:8} {insn.op_str}{note}')
        name = f'{start:08x}.asm'
        (OUTPUT / name).write_text('\n'.join(lines) + '\n')
        exports.append({'start': hex(start), 'end_exclusive': hex(end), 'instructions': count, 'file': name})
    (OUTPUT / 'export-provenance.json').write_text(json.dumps({
        'source': str(SOURCE.relative_to(ROOT)), 'sha256': SHA256,
        'base': hex(BASE), 'capstone_version': capstone.__version__, 'mode': 'ARM A32 little-endian',
        'limitations': ['Selected windows only; may include literal data or adjacent functions.',
                       'No ARM/Thumb discovery, execution, ABI validation or firmware modification.',
                       'MOVW/MOVT string comments are heuristic and may contain false associations.'],
        'windows': exports,
    }, indent=2) + '\n')
    print(f'Exported {len(exports)} A32 windows from verified {SHA256}')


if __name__ == '__main__':
    main()
