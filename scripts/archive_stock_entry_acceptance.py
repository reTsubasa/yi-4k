#!/usr/bin/env python3
"""Archive a future stock-entry collection locally; never contact a camera."""
import argparse
import base64
import hashlib
import json
from pathlib import Path


def digest(data):
    return hashlib.sha256(data).hexdigest()


def archive(plan, stage, collection, output):
    assert plan['schema'] == 'stock-entry-acceptance-plan/v1'
    assert stage['action'] == 'stage' and stage['created_exclusively'] is True
    assert stage['identifier'] == collection['identifier'] == plan['identifier']
    assert collection['action'] == 'collect' and collection['removed_files'] is False
    assert set(stage['snapshot']) == set(collection['snapshot']) == set(plan['paths'])
    for key in ('script', 'claim'):
        assert stage['snapshot'][key]['present'] and stage['snapshot'][key]['sha256'] == plan[key + '_sha256']
    assert not stage['snapshot']['tasks']['present'] and not stage['snapshot']['fingerprint']['present']
    decoded = {}
    for key, row in collection['snapshot'].items():
        if not row['present']:
            assert row == {'present': False}
            continue
        data = base64.b64decode(row['base64'], validate=True)
        assert len(data) == row['bytes'] <= plan['max_file_bytes']
        assert digest(data) == row['sha256'], 'Collection hash mismatch: ' + key
        if key in ('script', 'claim'):
            assert row['sha256'] == plan[key + '_sha256'], 'Ownership mismatch: ' + key
        decoded[key] = data
    assert 'claim' in decoded, 'Stage ownership claim missing'
    tasks = decoded.get('tasks', b'')
    checks = {
        'new_boot_id': len(collection['boot_id']) == 36 and collection['boot_id'] != stage['boot_id'],
        'task_summary': len(tasks) <= 65536 and all(word in tasks for word in (b'ID', b'PRI', b'STAT', b'NAME', b'AmbaShell_ExecTask')),
        'fixed_eight_byte_fingerprint': decoded.get('fingerprint') == bytes.fromhex(plan['expected_code_hex']),
    }
    files = {key: {k: v for k, v in row.items() if k != 'base64'} for key, row in collection['snapshot'].items()}
    cleanup = dict(action='collect', identifier=plan['identifier'], archived_and_hash_verified=True, files=files)
    verification = dict(schema='stock-entry-archive/v1', identifier=plan['identifier'],
                        accepted=all(checks.values()), checks=checks,
                        scope='stock command output only; native extension entry and return are unproven',
                        source='caller supplied transport receipts; not cryptographically authenticated device data',
                        cleanup_input_sha256=digest((json.dumps(cleanup, sort_keys=True) + '\n').encode()))
    output.mkdir(parents=True, exist_ok=False)
    for key, data in decoded.items():
        # Fixed local labels avoid reusing any remotely supplied file path.
        (output / (key + '.dat')).write_bytes(data)
    for name, value in [('stage.json', stage), ('collection.json', collection),
                        ('cleanup-input.json', cleanup), ('verification.json', verification)]:
        (output / name).write_text(json.dumps(value, sort_keys=True) + '\n')
    for key, data in decoded.items():
        assert digest((output / (key + '.dat')).read_bytes()) == digest(data)
    return verification


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--plan', type=Path, required=True)
    parser.add_argument('--stage', type=Path, required=True)
    parser.add_argument('--collection', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result = archive(json.loads(args.plan.read_text()), json.loads(args.stage.read_text()),
                     json.loads(args.collection.read_text()), args.output)
    print(json.dumps(result, sort_keys=True))


if __name__ == '__main__':
    main()
