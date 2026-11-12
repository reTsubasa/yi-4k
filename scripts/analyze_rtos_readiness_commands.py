#!/usr/bin/env python3
"""Recover native readiness queries from the retained device 1.10.7 bytes.

Offline only. Function boundaries/pseudocode reuse retained Ghidra exports;
two unindexed handlers are covered by explicitly bounded A32 excerpts.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, __version__
from analyze_sharepreview_init_dependencies import SOURCE, ROOT, BASE, SHA256

FUNCTIONS = {
    0xA01A6030: 'register_app_command',
    0xA048F43C: 'task_query',
    0xA048FB7C: 'byte_pool_summary',
    0xA048FCA0: 'byte_pool_block_walk',
    0xA048FE2C: 'block_pool_summary',
    0xA03C36C4: 'checked_byte_pool_info',
    0xA03BD130: 'byte_pool_allocator_search_and_split',
}
EXCERPTS = {
    'ps-handler': (0xA02A3864, 0xA02A3B14),
    'app-handler-dispatch': (0xA01A4F34, 0xA01A5024),
    'app-mem-print': (0xA01A5374, 0xA01A53C0),
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    data = (SOURCE / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(data).hexdigest() == SHA256
    args.output.mkdir(parents=True, exist_ok=True)
    dis = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    decoded = {}
    evidence = []

    def export(label, ranges, origin):
        chunks, listing = [], []
        for start, end in ranges:
            chunk = data[start - BASE:end - BASE]
            instructions = list(dis.disasm(chunk, start))
            assert sum(x.size for x in instructions) == end - start
            chunks.append(chunk)
            for ins in instructions:
                decoded[ins.address] = (ins.mnemonic, ins.op_str)
                listing.append('0x%08x  %s %s' % (ins.address, ins.mnemonic, ins.op_str))
        (args.output / (label + '.asm')).write_text('\n'.join(listing) + '\n')
        evidence.append({'label': label, 'boundary_source': origin,
                         'ranges_end_exclusive': [[hex(a), hex(z)] for a, z in ranges],
                         'sha256': hashlib.sha256(b''.join(chunks)).hexdigest()})

    rows = {int(r['entry'], 16): r for r in
            json.loads((SOURCE / 'full/functions.json').read_text())}
    for address, role in FUNCTIONS.items():
        ranges = []
        for span in rows[address]['body_ranges']:
            start, last = (int(s, 16) for s in span.split('-'))
            ranges.append((start, last + 1))
        label = '%08x' % address
        export(label, ranges, 'retained full/functions.json; role inferred: ' + role)
        source = SOURCE / ('full/decompiled/' + label + '.c')
        if source.exists():
            shutil.copyfile(source, args.output / (label + '.c'))
    for label, bounds in EXCERPTS.items():
        export(label, [bounds], 'analyst-bounded excerpt; not a recovered complete function')

    expected = {
        0xA02A3934: ('bl', '#0xa048fb7c'),
        0xA02A393C: ('bl', '#0xa048fe2c'),
        0xA02A39F4: ('bl', '#0xa048f43c'),
        0xA02A3A94: ('bl', '#0xa048fca0'),
        0xA01A4FC8: ('beq', '#0xa01a5374'),
        0xA01A5394: ('ldr', 'r1, [r3, #8]'),
        0xA01A53B0: ('ldr', 'r1, [r3, #8]'),
    }
    for address, value in expected.items():
        assert decoded[address] == value, (hex(address), decoded[address], value)

    def string(address):
        off = address - BASE
        return data[off:data.index(0, off)].decode('ascii')

    ps_entry = struct.unpack_from('<III', data, 0x5F2EA0 + 17 * 12)
    assert string(ps_entry[0]) == 'ps' and ps_entry[1] == 0xA02A3864
    strings = {hex(a): string(a) for a in [
        0xA05648C8, 0xA0566E4C, 0xA0566E7C, 0xA0566EB8,
        0xA05B01D4, 0xA0566290, 0xA062CDD8, 0xA062CE30, 0xA062CE7C,
    ]}
    assert strings['0xa05648c8'] == 'app' and strings['0xa0566e4c'] == 'mem'
    report = {
        'image_sha256': SHA256, 'base': hex(BASE),
        'producer_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'capstone_version': __version__, 'evidence': evidence,
        'instruction_checks': {hex(k): list(v) for k, v in expected.items()},
        'strings': strings,
        'commands': {
            't app mem': {'application_pool': '0xa0fd7114', 'secondary_pool': '0xa0fe7220',
                          'field_read': '+0x08 available bytes', 'output': 'global logging function 0xa02a70ec'},
            'ps mem': {'queries': ['byte pools', 'block pools'], 'byte_columns': ['ID', 'Available', 'Fragement', 'Name']},
            'ps mem detail': {'queries': ['byte pools and linked block headers'],
                              'risk': 'Raw traversal outside one whole-list critical section; no explicit cycle/corruption guard. Output scales with fragmentation.'},
            'ps tsk': {'queries': ['task state', 'priority', 'scheduling count', 'stack fields', 'core-related query'],
                       'caveat': 'Output via caller-supplied print callback; not proof of live task progress.'},
        },
        'byte_pool_layout_inferred': {'0x00': 'BYTE magic', '0x04': 'name pointer',
                                     '0x08': 'available bytes', '0x0c': 'fragment count',
                                     '0x10': 'block chain start', '0x14': 'search pointer',
                                     '0x18': 'region start', '0x1c': 'region size',
                                     '0x2c': 'next created pool'},
        'block_layout_inferred': {'0x00': 'next block pointer', '0x04': 'free marker 0xffffeeee or owner pool',
                                  'payload_offset': 8, 'free_payload_bytes': 'next-current-8 for a valid forward free block'},
        'scope': {'new_device_rtos_commands': False, 'live_pool_capacity_obtained': False},
        'limitations': [
            'Static filesystem evidence, not REA Evidence IDs or execution tracing.',
            'Two handlers were missing from the retained full function index; only explicit excerpts were used.',
            'Queries write transient scratch output and use synchronization; they are not zero-effect operations.',
            'Available byte total does not establish a sufficiently large allocatable contiguous block.',
            'No Linux-to-RTOS shell transport was established by finding these command handlers.',
        ],
    }
    (args.output / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'functions': len(FUNCTIONS), 'bounded_excerpts': len(EXCERPTS),
                      'instruction_checks': len(expected), 'output': str(args.output)}))


if __name__ == '__main__':
    main()
