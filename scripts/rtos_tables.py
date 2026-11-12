#!/usr/bin/env python3
"""Reproduce YI 4K command table extraction and selected A32 inspection.

Offline only. Does not execute target firmware, emit patches, or connect a camera.
Requires capstone==5.0.7; all semantic names below are analyst-assigned labels.
"""
from pathlib import Path
import hashlib
import json
import re
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/firmware/v1.10.52/_part_lrtos.a9s'
OUT = ROOT / 'artifacts/rtos-reverse/tables'
BASE = 0xA0100000
EXPECTED_SHA = 'c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141'
TABLES = [
    ('antscmd', 0x46B404, 69, 8, 0xA01AB8BC),
    ('imgcmd', 0x4978E0, 17, 12, 0xA02265B0),
    ('ipccmd', 0x4A6C18, 6, 8, 0xA0245AF8),
    ('drvcmd', 0x537334, 21, 12, 0xA04AF7E0),
]


def main():
    b = IMAGE.read_bytes()
    assert hashlib.sha256(b).hexdigest() == EXPECTED_SHA, 'Unexpected firmware; addresses do not apply'
    OUT.mkdir(parents=True, exist_ok=True)

    def cstr(addr, limit=300):
        off = addr - BASE
        if not 0 <= off < len(b):
            return None
        end = b.find(b'\0', off, off + limit)
        if end < 0:
            return None
        raw = b[off:end]
        if raw and all(x in (9, 10, 13) or 32 <= x < 127 for x in raw):
            return raw.decode('ascii')
        return None

    def immediate_mov(word):
        op = word & 0x0FF00000
        if op not in (0x03000000, 0x03400000):
            return None
        return ('movw' if op == 0x03000000 else 'movt', (word >> 12) & 15,
                ((word >> 4) & 0xF000) | (word & 0xFFF))

    def branch_target(off):
        word = struct.unpack_from('<I', b, off)[0]
        if word & 0x0E000000 != 0x0A000000 or word >> 28 == 15:
            return None
        imm = word & 0xFFFFFF
        if imm & 0x800000:
            imm -= 0x1000000
        return BASE + off + 8 + (imm << 2)

    records, seeds = [], []
    labels = {0xA029E098: 'analyst_t_command_register', 0xA04F9744: 'analyst_thumb_strcmp',
              0xA02A70EC: 'analyst_printf_like'}
    for prefix, off, count, stride, dispatcher in TABLES:
        rows = []
        labels[dispatcher] = prefix + '_dispatcher'
        for idx in range(count):
            entry = off + idx * stride
            np, fp = struct.unpack_from('<II', b, entry)
            name = cstr(np)
            assert name and re.fullmatch('[A-Za-z0-9_.-]+', name)
            safe = prefix + '_' + re.sub('[^A-Za-z0-9_]', '_', name).strip('_')
            row = {'index': idx, 'name': name, 'name_pointer': hex(np),
                   'handler': hex(fp), 'entry_file_offset': hex(entry),
                   'handler_mode': 'ARM/A32', 'label': safe}
            if stride == 12:
                third = struct.unpack_from('<I', b, entry + 8)[0]
                row['third_word'] = hex(third)
                row['third_word_string'] = cstr(third)
            rows.append(row)
            seeds.append(f'{fp:#x}\t{safe}\t{entry:#x}')
            labels[fp] = safe
        records.append({'table': prefix, 'file_offset': hex(off), 'virtual_address': hex(BASE + off),
                        'count': count, 'stride': stride, 'dispatcher': hex(dispatcher), 'records': rows})
    (OUT / 'command-tables.json').write_text(json.dumps({'image_sha256': EXPECTED_SHA, 'base': hex(BASE),
        'evidence': 'raw table data plus Capstone inspection of matching table dispatcher loops',
        'tables': records}, indent=2) + '\n')

    roots = []
    for off in range(32, 0x42F000, 4):
        if branch_target(off) != 0xA029E098:
            continue
        lows, values = {}, {}
        # Only accept nearby directly constructed movw/movt constants. No claim of complete dataflow.
        for pos in range(off - 32, off, 4):
            mov = immediate_mov(struct.unpack_from('<I', b, pos)[0])
            if not mov:
                continue
            kind, reg, val = mov
            if kind == 'movw':
                lows[reg] = val
            elif reg in lows:
                values[reg] = lows[reg] | (val << 16)
        name, handler = cstr(values.get(0, 0)), values.get(1)
        if name and len(name) <= 19 and handler and BASE <= handler < BASE + 0x42F000:
            row = {'name': name, 'handler': hex(handler), 'registration_callsite': hex(BASE + off),
                   'evidence': 'nearby movw/movt construction of r0=name,r1=handler followed by b/bl to 0xA029E098'}
            roots.append(row)
            label = 'tcmd_' + re.sub('[^A-Za-z0-9_]', '_', name)
            seeds.append(f'{handler:#x}\t{label}\tregistration@{BASE+off:#x}')
            labels[handler] = label
    (OUT / 'root-registrations.json').write_text(json.dumps({'image_sha256': EXPECTED_SHA,
        'register_function': '0xa029e098', 'method_limit': 'A32 direct b/bl and nearby movw/movt only; runtime registration reachability not proved',
        'records': roots}, indent=2) + '\n')
    for prefix, off, count, stride, dispatcher in TABLES:
        seeds.append(f'{dispatcher:#x}\t{prefix}_dispatcher\ttable@{off:#x}')
    seeds.append('0xa029e098\tanalyst_t_command_register\tcode')
    (OUT / 'seeds.tsv').write_text('\n'.join(seeds) + '\n')

    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    md.detail = True
    windows = [
        (0xA01A4F34, 0x10FC), (0xA029E098, 0x10C), (0xA01AB8BC, 0xB0), (0xA0245AF8, 0xB0),
        (0xA02265B0, 0x8C), (0xA04AF7E0, 0x9C), (0xA01ACE50, 0x94),
        (0xA01AAC38, 0x118), (0xA01AB96C, 0x90), (0xA01ABB44, 0x74),
        (0xA01AC08C, 0x60), (0xA01ACD10, 0x140), (0xA0245CF4, 0x100),
        (0xA01A7508, 0x25C), (0xA01A9990, 0x154), (0xA01A63D4, 0x100),
    ]
    for start, size in windows:
        lines = [f'; image sha256 {EXPECTED_SHA}', f'; A32 disassembly window {start:#x}+{size:#x}; boundaries are analyst-selected',
                 '; This is offline disassembly, not original source or runtime evidence.']
        lows = {}
        for ins in md.disasm(b[start - BASE:start - BASE + size], start):
            notes = []
            word = struct.unpack('<I', ins.bytes)[0]
            mov = immediate_mov(word)
            if mov:
                kind, reg, val = mov
                if kind == 'movw':
                    lows[reg] = (val, ins.address)
                elif reg in lows and ins.address - lows[reg][1] <= 24:
                    addr = lows[reg][0] | (val << 16)
                    s = cstr(addr)
                    if s:
                        notes.append(f'constant {addr:#x}: {s!r}')
            target = branch_target(ins.address - BASE)
            if target in labels:
                notes.append(labels[target])
            note = ' ; ' + '; '.join(notes) if notes else ''
            lines.append(f'{ins.address:08x}  {ins.bytes.hex():8s}  {ins.mnemonic:8s} {ins.op_str}{note}')
        (OUT / f'{start:08x}.asm').write_text('\n'.join(lines) + '\n')
    print(f'{len(records)} tables, {sum(len(t["records"]) for t in records)} entries; {len(roots)} direct registration callsites')


if __name__ == '__main__':
    main()
