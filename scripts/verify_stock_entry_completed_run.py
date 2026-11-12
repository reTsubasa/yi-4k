#!/usr/bin/env python3
"""Verify the approved stock-only lifecycle from local receipts, without device I/O."""
import base64
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PREFIX = 'artifacts/device/2026-11-12-stock-entry-approved-'
BUNDLE = 'artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/'
ACTIONS = ('preflight', 'stage', 'collect01', 'collect02', 'disarm',
           'collect03', 'cleanup', 'final-preflight')


def read(relative):
    return json.loads((ROOT / relative).read_text())


def digest(data):
    return hashlib.sha256(data).hexdigest()


def verify():
    sessions = {name: read(PREFIX + name + '/session.json') for name in ACTIONS}
    plan_bytes = (ROOT / (BUNDLE + 'plan.json')).read_bytes()
    assert digest(plan_bytes) == 'ac6556f1d69aa7364c8c2f51ad2d6a3f576a3fafdf1e6d13a3400c59fd0fa83a'
    for name, expected in read(BUNDLE + 'dry-run.json')['bundle_file_sha256'].items():
        assert digest((ROOT / (BUNDLE + name)).read_bytes()) == expected, name
    baseline = sessions['preflight']['before']
    for name, session in sessions.items():
        assert session['confirmed'], name
        assert session['before'] == session['after'] == baseline, name
        assert session['reboot_requested'] is False
        assert session['firmware_or_RAM_write'] is False
        assert session['extra_target_script_file_uploaded'] is False
        assert session['plan_sha256'] == digest(plan_bytes)
        assert session['script_sha256'] == digest((ROOT / 'scripts/device_stock_entry_acceptance.py').read_bytes())
        transport = read(PREFIX + name + '/transport.json')
        assert transport['environment_cleared'] is True, name
        assert transport['target_script_file_uploaded'] is False
        source = (ROOT / (PREFIX + name + '/executed-source.py')).read_bytes()
        assert digest(source) == transport['source_sha256'], name
        assert len(source) == transport['source_bytes']
        raw = (ROOT / (PREFIX + name + '/raw-output.txt')).read_text()
        marker = 'YI_STOCK_PREFLIGHT ' if session['action'] == 'preflight' else 'YI_STOCK_ENTRY '
        rows = [json.loads(line[len(marker):]) for line in raw.splitlines() if line.startswith(marker)]
        assert rows == [session['result']], name
        if session['action'] not in ('preflight', 'cleanup'):
            assert source == (ROOT / (BUNDLE + 'review-' + session['action'] + '.py')).read_bytes(), name
        if session['action'] != 'preflight':
            assert read(PREFIX + name + '/result.json') == session['result']
    result = {name: session['result'] for name, session in sessions.items()}
    assert all(not x['present'] for x in result['preflight']['paths'].values())
    assert result['stage']['boot_id'] == result['preflight']['boot_id']
    assert result['stage']['created_exclusively'] is True
    assert sessions['stage']['preflight_sha256'] == digest((ROOT / sessions['stage']['preflight_source']).read_bytes())
    cleanup_input = (ROOT / (PREFIX + 'archive03/cleanup-input.json')).read_text()
    wrapper = "import os,base64\nos.environ['YI4K_STOCK_ENTRY_COLLECT_JSON']=base64.b64decode(" + repr(base64.b64encode(cleanup_input.encode()).decode()) + ").decode('ascii')\n"
    assert (ROOT / (PREFIX + 'cleanup/executed-source.py')).read_text() == wrapper + (ROOT / (BUNDLE + 'review-cleanup.py')).read_text()
    assert result['stage']['boot_id'] != result['collect01']['boot_id']
    new_boot = result['collect01']['boot_id']
    for name in ('collect02', 'collect03', 'final-preflight'):
        assert result[name]['boot_id'] == new_boot
    assert result['collect01']['snapshot'] == result['collect02']['snapshot']
    assert result['disarm']['script_removed'] is True
    assert result['disarm']['evidence_retained'] is True
    assert result['collect03']['snapshot']['script'] == {'present': False}
    for key in ('claim', 'tasks', 'fingerprint'):
        assert result['collect03']['snapshot'][key] == result['collect02']['snapshot'][key]
    plan = read('artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final/plan.json')
    assert result['cleanup']['owned_files_removed'] is True
    assert set(result['final-preflight']['paths']) == set(plan['paths'])
    assert all(row == {'present': False} for row in result['final-preflight']['paths'].values())
    rejected = read(PREFIX + 'final/session.json')
    assert rejected['confirmed'] is False
    assert 'Ownership claim missing' in (ROOT / (PREFIX + 'final/raw-output.txt')).read_text()
    for name, collection in (('archive01', 'collect01'), ('archive03', 'collect03')):
        archive = PREFIX + name + '/'
        receipt = read(archive + 'verification.json')
        assert receipt['accepted'] is True and all(receipt['checks'].values())
        assert read(archive + 'stage.json') == result['stage']
        assert read(archive + 'collection.json') == result[collection]
        for key, row in result[collection]['snapshot'].items():
            if not row['present']:
                continue
            data = base64.b64decode(row['base64'], validate=True)
            assert len(data) == row['bytes'] and digest(data) == row['sha256']
            assert (ROOT / (archive + key + '.dat')).read_bytes() == data
        assert digest((ROOT / (archive + 'cleanup-input.json')).read_bytes()) == receipt['cleanup_input_sha256']
    fingerprint = base64.b64decode(result['collect01']['snapshot']['fingerprint']['base64'])
    assert fingerprint.hex() == plan['expected_code_hex']
    files = []
    for name in ACTIONS + ('final',):
        for label in ('session.json', 'transport.json', 'executed-source.py', 'raw-output.txt'):
            relative = PREFIX + name + '/' + label
            data = (ROOT / relative).read_bytes()
            files.append(dict(path=relative, bytes=len(data), sha256=digest(data)))
    return dict(
        status='pass_local_stock_entry_lifecycle_review',
        scope='Stock task summary and fixed eight-byte read after user-reported power cycle; exact-file cleanup and API baseline only',
        previous_boot_id=result['stage']['boot_id'], new_boot_id=new_boot,
        all_four_paths_absent=True, api_baseline_equal_across_all_operations=True,
        collected_fingerprint_hex=fingerprint.hex(),
        post_cleanup_collection='Rejected as designed because cleanup removed ownership claim; separate read-only preflight confirms all four paths absent',
        output_files={key: {k: v for k, v in row.items() if k != 'base64'}
                      for key, row in result['collect01']['snapshot'].items()},
        raw_uptime={name: row['uptime'] for name, row in result.items() if 'uptime' in row},
        limits=['Caller-supplied transport evidence, not cryptographic device attestation',
                'Anomalous uptime retained; no cold-reset or elapsed-uptime inference',
                'Repeated stable files do not prove all active readers quiescent',
                'API baseline covers selected eight settings and app_status only; no reboot-persistence or whole-device health acceptance',
                'No custom ARM entry, instruction-cache visibility, independent recovery, recording or EIS replacement acceptance'],
        verifier_sha256=digest(Path(__file__).read_bytes()), files=files)


if __name__ == '__main__':
    print(json.dumps(verify(), ensure_ascii=False, indent=2))
