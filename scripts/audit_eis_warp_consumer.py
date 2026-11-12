#!/usr/bin/env python3
"""Audit the static cache/publication boundary after A0312460.

This is a negative-evidence audit: it can prove calls and stores present in
the pinned image, but it cannot prove a DSP latch, acknowledgement, or safe
slot reuse without runtime execution.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
BASE = 0xA0100000
SHA256 = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
CONTRACT = ROOT / 'artifacts/device/2026-11-10-eis-warp-publication/contract.json'
REFERENCES = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/full/references.tsv'
PUBLISHED_POINTER = 0xA0699160
STATUS_BLOCK_START = 0xA06990E0
STATUS_BLOCK_END = 0xA0699160


def disasm(data: bytes, start: int, end: int):
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    return list(cs.disasm(data[start - BASE:end - BASE], start))


def instruction(data: bytes, address: int) -> dict:
    ins = next(Cs(CS_ARCH_ARM, CS_MODE_ARM).disasm(data[address - BASE:address - BASE + 4], address))
    return {'address': f'0x{address:08X}', 'instruction': f'{ins.mnemonic} {ins.op_str}',
            'bytes': ins.bytes.hex()}


def reference_index_evidence() -> dict:
    """Cross-check the full static reference index for the published pointer.

    The focused function body proves what the producer writes.  The full
    Ghidra reference export lets us distinguish "no consumer found in the
    body" from "no other fixed-code reference to the published pointer in the
    indexed image".  This remains static evidence: an indirect DSP consumer
    or a runtime MMIO path can still be invisible to the index.
    """
    result = {
        'path': str(REFERENCES.relative_to(ROOT)),
        'published_pointer': f'0x{PUBLISHED_POINTER:08X}',
        'status_block': [f'0x{STATUS_BLOCK_START:08X}', f'0x{STATUS_BLOCK_END:08X}'],
        'available': REFERENCES.is_file(),
        'pointer_references': [],
        'status_block_reference_count': 0,
        'external_pointer_reference_count': 0,
    }
    if not REFERENCES.is_file():
        result['reason'] = 'full reference index is unavailable; no repository-wide static claim made'
        return result
    for raw in REFERENCES.read_text().splitlines():
        parts = raw.split('\t')
        if len(parts) < 2:
            continue
        try:
            source, target = int(parts[0], 16), int(parts[1], 16)
        except ValueError:
            continue
        if STATUS_BLOCK_START <= target <= STATUS_BLOCK_END:
            result['status_block_reference_count'] += 1
        if target == PUBLISHED_POINTER:
            row = {'from': f'0x{source:08X}', 'to': f'0x{target:08X}',
                   'type': parts[2] if len(parts) > 2 else ''}
            result['pointer_references'].append(row)
            if not (0xA02C5FD8 <= source < 0xA02C61D0):
                result['external_pointer_reference_count'] += 1
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    data = IMAGE.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != SHA256:
        raise SystemExit('Device RTOS image hash changed; refusing stale-address interpretation')
    contract = json.loads(CONTRACT.read_text())
    contract_count = len(contract.get('checks', []))
    if contract_count != 31 or contract.get('target', {}).get('sha256') != digest:
        raise SystemExit('existing 31-check publication contract is stale or inconsistent')

    setwarp = disasm(data, 0xA0312460, 0xA0312830)
    status = disasm(data, 0xA02C5FD8, 0xA02C61D0)
    clean_calls = [
        {'address': f'0x{ins.address:08X}', 'target': ins.op_str}
        for ins in setwarp if ins.mnemonic == 'bl' and ins.op_str == '#0xa04a22cc'
    ]
    status_clean_calls = [
        {'address': f'0x{ins.address:08X}', 'target': ins.op_str}
        for ins in status if ins.mnemonic == 'bl' and ins.op_str == '#0xa04a22cc'
    ]
    reference_evidence = reference_index_evidence()
    expected = {
        0xA0312734: ('bl', '#0xa04a22cc'),
        0xA0312740: ('bl', '#0xa04a22cc'),
        0xA03127F8: ('bl', '#0xa04a22cc'),
        0xA0312804: ('bl', '#0xa04a22cc'),
        0xA02C60DC: ('str', 'r0, [r7, #0x80]'),
        0xA02C60E0: ('add', 'r3, r3, #1'),
        0xA02C60E8: ('cmp', 'r3, #1'),
        0xA02C60EC: ('movhi', 'r3, #0'),
        0xA02C60F0: ('strb', 'r3, [r2]'),
    }
    checks = []
    for address, wanted in expected.items():
        ins = next(Cs(CS_ARCH_ARM, CS_MODE_ARM).disasm(data[address - BASE:address - BASE + 4], address))
        actual = (ins.mnemonic, ins.op_str)
        if actual != wanted:
            raise SystemExit(f'instruction mismatch at {address:#x}: {actual} != {wanted}')
        checks.append(instruction(data, address))

    report = {
        'evidence_kind': 'offline device-byte cache/publication audit; no runtime execution',
        'target': {'firmware': 'YI 4K 1.10.7', 'image': str(IMAGE.relative_to(ROOT)),
                   'sha256': digest, 'base': hex(BASE)},
        'checks': checks,
        'publication_contract_check_count': contract_count,
        'cache_boundary': {
            'setwarp_function': '0xA0312460',
            'plane_bytes_each': 0x1800,
            'clean_helper': '0xA04A22CC',
            'setwarp_clean_calls': clean_calls,
            'setwarp_clean_call_count': len(clean_calls),
            'planes_cleaned_per_executed_branch': 2,
            'static_sites_covering_branches': 3,
            'status_function': '0xA02C5FD8',
            'status_clean_calls_visible': status_clean_calls,
            'status_clean_call_count': len(status_clean_calls),
            'interpretation': 'A0312460 visibly cleans two 0x1800 planes on each branch; A02C5FD8 has no visible call to the same helper in the audited range. This does not prove the status slots are coherent or incoherent.'
        },
        'publication_boundary': {
            'slot_stride_bytes': 0x40,
            'slot_count_observed': 2,
            'published_pointer_offset': 0x80,
            'sequence': ['store translated descriptor at selected slot +0x24',
                         'store translated descriptor at status +0x80',
                         'increment index', 'wrap index when greater than 1'],
            'consumer_acknowledgement_found': False,
            'old_slot_reclamation_found': False,
            'barrier_or_ack_semantics': 'unresolved from fixed bytes',
            'full_reference_index': reference_evidence,
        },
        'known_callers': [
            {'caller': '0xA038B2A8', 'callee': '0xA02C5FD8', 'evidence': 'fixed BL in focused A0385780 disassembly'},
            {'caller': '0xA037E218', 'callee': '0xA02C5FD8', 'evidence': 'Ghidra pseudocode and fixed call reference'},
            {'caller': '0xA02C61D4', 'callee': '0xA04A3BD4', 'evidence': 'address translation helper; reads shared state via translated base'},
        ],
        'negative_evidence': [
            'No fixed-byte reference in the audited A02C5FD8 body identifies a DSP consumer acknowledgement or old-slot release.',
            'The full indexed image has no external fixed-code reference to the published +0x80 pointer when the reference index is available; an indirect DSP/MMIO consumer may still be absent from this index.',
            'A02C61D4 reads/writes translated shared state fields but is not proven to read the two LiveviewEisConfig slots or acknowledge their lifetime.',
            'The +0x80 publication pointer and one-byte index wrap do not establish frame identity, DSP latch timing, or safe two-slot reuse.',
            'The absence of a visible clean call in A02C5FD8 is not proof that no cache/barrier exists elsewhere in the caller or DSP path.',
        ],
        'next_static_contract': {
            'name': 'cache/publication boundary',
            'proven': ['four A04A22CC calls in A0312460, each on a 0x1800 plane branch',
                       'A02C5FD8 pointer publication and index wrap stores'],
            'blocked_until': ['DSP consumer/latch reference', 'old-slot reuse condition',
                              'cache/barrier ownership and timing', 'frame/status index mapping'],
        },
        'limitations': [
            'No custom table was submitted and no camera state was modified.',
            'Static call and store evidence is not an execution trace.',
            'Do not design a replacement hook or assume two slots are safe to recycle from this audit.',
        ],
        'device_contacted': False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'setwarp_clean_calls': len(clean_calls),
                      'status_clean_calls': len(status_clean_calls),
                      'consumer_acknowledgement_found': False,
                      'device_contacted': False, 'output': str(args.output)}, ensure_ascii=False))


if __name__ == '__main__':
    main()
