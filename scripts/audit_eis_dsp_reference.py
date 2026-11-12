#!/usr/bin/env python3
"""Inventory the existing DSP reference and its device identity boundary.

Offline only: never opens a camera or changes firmware. ORC payloads are opaque
bytes, not ARM code. An optional complete capture proves stored bytes only.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import zlib
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
RTOS = ANALYSIS / 'rtos-window.bin'
DSP = ROOT / 'artifacts/firmware/v1.10.52/_part_dsp.a9s'
DEVICE = ROOT / 'artifacts/device/2026-11-09-linux/boot-metadata'
BASE = 0xA0100000
RTOS_SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
DSP_SHA = '9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73'
NAMES = ['orccode.bin', 'orcme.bin', 'orcmdxf.bin', 'default_binary.bin']
LOAD_ADDRESSES = [0xA1B00000, 0xA1F80000, 0xA2000000, 0xA2080000]

# These are the loader's file-list and destination assignments, distinct from
# the previous audit's VCAP command-copy assertions.
INSTRUCTIONS = {
    0xA029A828: ('movw', 'r1, #0xdc20'),
    0xA029A830: ('movt', 'r1, #0xa05a'),
    0xA029A834: ('mov', 'r2, #0xa0'),
    0xA029A83C: ('bl', '#0xa029c680'),
    0xA029A878: ('bl', '#0xa02c6c5c'),
    0xA029A898: ('str', 'r0, [sp, #0x64]'),
    0xA029A89C: ('str', 'r1, [sp, #0x8c]'),
    0xA029A8A0: ('str', 'r2, [sp, #0xb4]'),
    0xA029A8A4: ('str', 'r3, [sp, #0xdc]'),
    0xA029A8B4: ('bl', '#0xa04839c0'),
    0xA029A8D0: ('ldr', 'ip, [r4, #0x24]'),
    0xA029A8E0: ('bl', '#0xa0483a10'),
    0xA029A8F8: ('add', 'r4, r4, #0x28'),
    0xA02C6C70: ('movt', 'r5, #0xa1b0'),
    0xA02C6C74: ('movt', 'r4, #0xa1f8'),
    0xA02C6C78: ('movt', 'lr, #0xa200'),
    0xA02C6C7C: ('movt', 'ip, #0xa208'),
    0xA02C6C80: ('str', 'r5, [r0]'),
    0xA02C6C84: ('str', 'r4, [r1]'),
    0xA02C6C88: ('str', 'lr, [r2]'),
    0xA02C6C8C: ('str', 'ip, [r3]'),
}


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def inventory(data: bytes) -> list[dict]:
    if len(data) < 8 or struct.unpack_from('<II', data) != (0x66FC328A, 4):
        raise ValueError('Unexpected reference ROM-directory header')
    entries = []
    last_end = 8 + 4 * 0x4C
    for index, expected_name in enumerate(NAMES):
        position = 8 + index * 0x4C
        name = data[position:position + 0x40].split(b'\0', 1)[0].decode('ascii')
        size, offset, crc = struct.unpack_from('<III', data, position + 0x40)
        if name != expected_name or size <= 0 or offset < last_end or offset + size > len(data):
            raise ValueError(f'Invalid/nonmonotonic DSP member {index}')
        payload = data[offset:offset + size]
        if zlib.crc32(payload) & 0xFFFFFFFF != crc:
            raise ValueError(f'DSP member CRC mismatch: {name}')
        entries.append({'name': name, 'directory_offset': hex(position),
                        'offset': hex(offset), 'bytes': size, 'crc32': hex(crc),
                        'sha256': sha(payload), 'rtos_cpu_load_address': hex(LOAD_ADDRESSES[index]),
                        'architecture': 'opaque Ambarella ORC payload; not decoded as ARM'
                        if index < 3 else 'default binary data; no code architecture asserted'})
        last_end = offset + size
    return entries


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-directory', type=Path, required=True)
    parser.add_argument('--device-capture', type=Path,
                        help='Existing device_dsp_capture output directory; read offline only')
    args = parser.parse_args()
    rtos, dsp = RTOS.read_bytes(), DSP.read_bytes()
    if sha(rtos) != RTOS_SHA or sha(dsp) != DSP_SHA:
        raise SystemExit('Pinned input identity changed; refusing address interpretation')
    ptb, prefix = (DEVICE / 'vendor_data.bin').read_bytes(), (DEVICE / 'dsp_prefix.bin').read_bytes()
    if zlib.crc32(ptb[:0x350]) & 0xFFFFFFFF != struct.unpack_from('<I', ptb, 0x350)[0]:
        raise SystemExit('Device PTB CRC mismatch')
    # DSP is record index 2, validated independently of the JSON interpretation.
    position = 8 + 2 * 0x40
    name = ptb[position:position + 0x20].split(b'\0', 1)[0]
    fields = struct.unpack_from('<8I', ptb, position + 0x20)
    if name != b'DSP_uCode' or len(dsp) != fields[5] or zlib.crc32(dsp) & 0xFFFFFFFF != fields[7]:
        raise SystemExit('Public reference no longer matches device PTB size/CRC')
    if len(prefix) != 0x10000 or prefix != dsp[:len(prefix)]:
        raise SystemExit('Device-captured DSP prefix does not match this reference')
    full_capture = None
    if args.device_capture is not None:
        capture_path = args.device_capture.resolve()
        captured = (capture_path / 'dsp-partition-image.bin').read_bytes()
        capture_report = json.loads((capture_path / 'capture.json').read_text())
        remote_hashes = re.findall(r'(?m)^([0-9a-f]{64})\s+-\s*$',
                                  (capture_path / 'remote-sha256.txt').read_text())
        if (captured != dsp or remote_hashes != [sha(captured)] or
                capture_report.get('sha256') != sha(captured) or
                capture_report.get('source') != '/dev/mtdblock2' or
                not capture_report.get('camera_state_equal') or
                not capture_report.get('boot_id_unchanged') or 'error' in capture_report):
            raise SystemExit('Complete stored DSP capture failed independent verification')
        full_capture = {'directory': str(capture_path), 'bytes': len(captured),
                        'sha256': sha(captured), 'reference_byte_equal': True,
                        'remote_sha256_equal': True, 'running_dsp_identity_proven': False}
    entries = inventory(dsp)
    names = [rtos[0xA05ADC20 - BASE + i * 0x28:0xA05ADC20 - BASE + i * 0x28 + 0x24].split(b'\0', 1)[0].decode()
             for i in range(4)]
    if names != NAMES:
        raise SystemExit('RTOS loader file list differs from DSP directory')
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in INSTRUCTIONS.items():
        ins = next(cs.disasm(rtos[address - BASE:address - BASE + 4], address))
        if (ins.mnemonic, ins.op_str) != expected:
            raise SystemExit(f'Loader instruction mismatch at {address:#x}')
        checks.append({'address': hex(address), 'bytes': ins.bytes.hex(),
                       'instruction': f'{ins.mnemonic} {ins.op_str}'})
    output = args.output_directory.resolve()
    output.mkdir(parents=True, exist_ok=True)
    for entry in entries:
        start = int(entry['offset'], 16)
        (output / entry['name']).write_bytes(dsp[start:start + entry['bytes']])
    orc = (output / 'orccode.bin').read_bytes()
    selected = []
    patterns = [b'eis_update_addr', b'EIS_DEBUG:', b'gyro delay sleep', b'cap info hw pts', b'vcap_update_warp_ctrl_command']
    for match in re.finditer(rb'[ -~]{8,}', orc):
        if any(pattern in match.group() for pattern in patterns):
            selected.append({'member_offset': hex(match.start()),
                             'partition_offset': hex(int(entries[0]['offset'], 16) + match.start()),
                             'text': match.group().decode('ascii')})
    # Detect corruption and malformed directories without interpreting opaque code.
    negative_checks = []
    for label, index, value in [('payload CRC', int(entries[0]['offset'], 16), None),
                                ('member size bounds', 8 + 0x40, 0xFFFFFFFF),
                                ('member overlap', 8 + 0x44, 0)]:
        corrupted = bytearray(dsp)
        if value is None:
            corrupted[index] ^= 1
        else:
            struct.pack_into('<I', corrupted, index, value)
        try:
            inventory(bytes(corrupted))
        except ValueError:
            negative_checks.append({'case': label, 'rejected': True})
        else:
            raise AssertionError(f'Corrupt directory accepted: {label}')
    sources = []
    for function in ['a029a824', 'a02c6c5c', 'a04839c0', 'a0483a10', 'a02c61d4']:
        path = ANALYSIS / 'full/decompiled' / (function + '.c')
        sources.append({'path': str(path.relative_to(ROOT)), 'sha256': sha(path.read_bytes())})
    report = {
        'evidence_kind': 'offline component inventory and ARM loader verification; ORC strings are localization only',
        'rtos_sha256': sha(rtos), 'public_dsp': {'path': str(DSP.relative_to(ROOT)), 'sha256': sha(dsp), 'bytes': len(dsp), 'crc32': hex(zlib.crc32(dsp) & 0xFFFFFFFF)},
        'device_identity_boundary': {'vendor_data_sha256': sha(ptb), 'device_dsp_prefix_sha256': sha(prefix),
                                     'captured_bytes': len(prefix), 'prefix_byte_equal': True, 'ptb_actual_size_equal': True, 'ptb_crc32_equal': True,
                                     'full_device_dsp_sha256_available': full_capture is not None,
                                     'full_device_capture': full_capture,
                                     'classification': 'exact stored DSP image; running image not observed' if full_capture else
                                     'compatible offline reference; not a full-device DSP dump identity claim'},
        'loader_instruction_checks': checks, 'instruction_check_count': len(checks),
        'members': entries, 'directory_negative_checks': negative_checks, 'selected_orccode_strings': selected,
        'reviewed_sources': sources,
        'readback_helper_boundary': 'The subsequent CPU completion-state audit recovered direct read/reset callers A03877A0 and A0387CAC in the focused export of A0385780. Full/decompiled omission was a decompiler timeout, not absence of callers. DSP non-sentinel write/latch/release remain unproven.',
        'readback_helper_followup': 'docs/eis-completion-state-boundary.md',
        'next_evidence': (['Acquire full DSP_uCode as a read-only dump and compare SHA-256 before treating the reference as the exact device artifact'] if full_capture is None else []) + [
                          'Use a correctly identified ORC ISA/provider to recover references to the eis_update_addr and EIS_DEBUG strings; do not run ARM disassembly on them',
                          'Recover the per-frame shared-word/state-slot/warp-descriptor load order and writes to shared tail fields',
                          'Observe stock-only lock/latch/ack and old-slot release before any custom warp submission'],
        'not_proven': ['DSP instruction semantics, code base mapping or a consumer call graph', 'Shared tail fields are acknowledgement counters',
                       'Read/latch ordering, cache ownership or safe two-slot reuse', 'Any custom algorithm execution or image-quality effect'],
        'device_access': False, 'new_REA_evidence': False,
    }
    (output / 'audit.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'output': str(output), 'loader_instruction_checks': len(checks), 'validated_members': len(entries),
                      'negative_checks': len(negative_checks), 'selected_strings': len(selected),
                      'prefix_equal': True, 'stored_device_dsp_identity_proven': full_capture is not None,
                      'running_dsp_identity_proven': False}, ensure_ascii=False))


if __name__ == '__main__':
    main()
