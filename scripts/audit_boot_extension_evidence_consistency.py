#!/usr/bin/env python3
"""Independently audit the fixed offline boot-extension assessment.

This checker binds the assessment JSON to the captured inputs, assembled marker,
documented instruction spans, and an in-memory reversible patch reconstruction.
It never opens a device, writes firmware, or emits a modified image.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = Path(__file__).resolve()
ASSESS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/boot-patch-assessment'
REPORT = ASSESS / 'assessment.json'
PART = ROOT / 'artifacts/device/2026-11-09-linux/sys_sw_partition.bin'
WINDOW = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
PAYLOAD = ASSESS / 'boot-marker.bin'
SOURCE = ROOT / 'sdk/offline/yi4k_1107_boot_marker.S'
ASSESSMENT_SCRIPT = ROOT / 'scripts/device_boot_patch_assessment.py'
OUT = ROOT / 'artifacts/verification/2026-11-12-boot-extension-consistency-run01'

PART_SHA = 'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6'
WINDOW_SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
PAYLOAD_SHA = '96d06a9f22a5637067a1fb103f17873d1953b4c7ca0f356cdd0549f7b77aa097'
BASE = 0xA0100000
PAD_LO, PAD_HI, CAVE, SITE = 0xA064E214, 0xA064F000, 0xA064E220, 0xA0187BF4


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def check(items: list[dict], name: str, ok: bool, detail: str) -> None:
    items.append(dict(name=name, passed=bool(ok), detail=detail))
    if not ok:
        raise AssertionError(f'{name}: {detail}')


def main() -> None:
    checks: list[dict] = []
    assessment = json.loads(REPORT.read_text())
    partition, window, payload = PART.read_bytes(), WINDOW.read_bytes(), PAYLOAD.read_bytes()
    check(checks, 'assessment_scope', assessment['scope'] == 'offline static patch assessment; NOT a firmware image or executed extension', assessment['scope'])
    check(checks, 'offline_flags', assessment['device_contacted'] is False and assessment['device_modified'] is False and assessment['flashable_image_generated'] is False, 'device_contacted/device_modified/flashable_image_generated are all false')
    check(checks, 'partition_sha256', sha(partition) == PART_SHA == assessment['source']['partition_sha256'], sha(partition))
    check(checks, 'window_sha256', sha(window) == WINDOW_SHA == assessment['source']['window_sha256'], sha(window))
    check(checks, 'window_is_partition_prefix', partition[:len(window)] == window, f'{len(window)} byte prefix')
    check(checks, 'payload_sha256', sha(payload) == PAYLOAD_SHA == assessment['prototype']['payload_sha256'], sha(payload))
    check(checks, 'payload_size', len(payload) == assessment['prototype']['payload_bytes'] == 96, str(len(payload)))
    check(checks, 'source_exists', SOURCE.is_file(), str(SOURCE))
    pad = window[PAD_LO - BASE:PAD_HI - BASE]
    check(checks, 'candidate_padding_all_zero', pad == b'\0' * (PAD_HI - PAD_LO), f'{len(pad)} bytes')
    candidate = assessment['candidate_padding']
    check(checks, 'candidate_padding_receipt', candidate['start'] == hex(PAD_LO) and candidate['end_exclusive'] == hex(PAD_HI) and candidate['candidate_entry'] == hex(CAVE) and candidate['bytes'] == 3564 and candidate['aligned_capacity'] == 3552, json.dumps({k: candidate[k] for k in ('start', 'end_exclusive', 'candidate_entry', 'bytes', 'aligned_capacity')}))
    check(checks, 'candidate_ownership_boundary', candidate['ownership'] == 'linker/MMU padding candidate, NOT proven unused at runtime', candidate['ownership'])
    check(checks, 'runtime_permission_boundary', assessment['mmu']['runtime_permissions_verified'] is False, 'runtime_permissions_verified=false')
    spans = assessment['prototype']['patch_spans']
    check(checks, 'span_count', len(spans) == 2, str(len(spans)))
    expected = {'startup_bl': (SITE, 4), 'text_padding_wrapper': (CAVE, 96)}
    mutated = bytearray(partition)
    for row in spans:
        label = row['label']
        va, size = expected[label]
        before, after = bytes.fromhex(row['before_hex']), bytes.fromhex(row['after_hex'])
        off = int(row['file_offset'], 16)
        check(checks, f'{label}_coordinates', row['va'] == hex(va) and off == va - BASE and row['bytes'] == size and len(before) == len(after) == size, f'va={row["va"]} offset={row["file_offset"]} bytes={row["bytes"]}')
        check(checks, f'{label}_before_matches_partition', partition[off:off + size] == before, f'offset=0x{off:x}')
        if label == 'text_padding_wrapper':
            check(checks, 'wrapper_span_matches_payload', after == payload, sha(after))
        else:
            word, = struct.unpack('<I', after)
            imm = word & 0xffffff
            delta = (imm - (1 << 24) if imm & (1 << 23) else imm) << 2
            check(checks, 'patched_bl_targets_wrapper', word >> 24 == 0xeb and SITE + 8 + delta == CAVE, f'0x{SITE + 8 + delta:x}')
        mutated[off:off + size] = after
    check(checks, 'mutated_partition_sha256', sha(mutated) == assessment['prototype']['mutated_partition_sha256'], sha(mutated))
    check(checks, 'changed_bytes', sum(a != b for a, b in zip(mutated, partition)) == assessment['prototype']['changed_bytes'] == 93, str(sum(a != b for a, b in zip(mutated, partition))))
    reverted = bytearray(mutated)
    for row in reversed(spans):
        off, size = int(row['file_offset'], 16), row['bytes']
        reverted[off:off + size] = bytes.fromhex(row['before_hex'])
    check(checks, 'exact_in_memory_reversal', bytes(reverted) == partition and assessment['prototype']['in_memory_reversal_exact'] is True, 'partition restored byte-for-byte')
    check(checks, 'prototype_behavior_boundary', assessment['prototype']['behavior'] == 'Stock initialization exactly once, one log marker, return; no task creation', assessment['prototype']['behavior'])
    recovery = assessment['recovery']
    check(checks, 'recovery_still_unproven', all(value is False for value in recovery.values()), json.dumps(recovery, sort_keys=True))
    remaining = assessment['remaining']
    check(checks, 'remaining_recovery_item', any('recovery' in item.lower() for item in remaining), 'recovery remains listed')
    check(checks, 'remaining_cold_resume_item', any('cold boot' in item.lower() and 'resume' in item.lower() for item in remaining), 'cold/resume remains listed')
    for row in assessment['evidence']:
        start, end = int(row['start'], 16), int(row['end_exclusive'], 16)
        raw = window[start - BASE:end - BASE]
        check(checks, f'evidence_{start:x}_binary_hash', sha(raw) == row['sha256'], sha(raw))
        asm_path = ROOT / row['asm']
        lines = [line.split(maxsplit=2) for line in asm_path.read_text().splitlines()]
        check(checks, f'evidence_{start:x}_asm_bytes', all(window[int(address, 16) - BASE:int(address, 16) - BASE + len(bytes.fromhex(encoded))] == bytes.fromhex(encoded) for address, encoded, _ in lines), str(asm_path.relative_to(ROOT)))
    checker_digest = sha(SCRIPT.read_bytes())
    result = {
        'schema': 'boot-extension-evidence-consistency/v1',
        'status': 'pass_offline_consistency_only',
        'checks': checks,
        'passed_checks': len(checks),
        'assessment_sha256': sha(REPORT.read_bytes()),
        'checker_sha256': checker_digest,
        'inputs': {
            'partition_sha256': sha(partition),
            'window_sha256': sha(window),
            'payload_sha256': sha(payload),
            'source_path': str(SOURCE.relative_to(ROOT)),
            'source_sha256': sha(SOURCE.read_bytes()),
            'assessment_script_path': str(ASSESSMENT_SCRIPT.relative_to(ROOT)),
            'assessment_script_sha256': sha(ASSESSMENT_SCRIPT.read_bytes()),
        },
        'device_access': False,
        'target_write': False,
        'modified_image_emitted': False,
        'recovery_proven': False,
        'limits': [
            'Assessment and checker are static/offline artifacts; no native entry or hardware execution is established.',
            'Patch reconstruction proves byte identity and reversal in host memory only.',
            'P1 first entry, P5 publication/SMP completion, and P11 independent recovery/cold-start rollback remain unresolved.',
        ],
    }
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / 'audit.json').write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n')
    print(json.dumps({'schema': result['schema'], 'passed_checks': len(checks), 'report': str(OUT / 'audit.json'), 'checker_sha256': result['checker_sha256']}))


if __name__ == '__main__':
    main()
