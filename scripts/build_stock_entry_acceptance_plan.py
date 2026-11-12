#!/usr/bin/env python3
"""Build and verify an inert, host-only stock-entry acceptance bundle.

No network imports, live action, reboot mode or camera transport is provided.
Generated target operations are review material; stage additionally requires a
separately observed expected boot ID in YI4K_EXPECTED_STAGE_BOOT_ID.
"""
from __future__ import annotations
import argparse
import base64
import copy
import hashlib
import io
import json
import os
from pathlib import Path
import re
import tempfile
import uuid
from contextlib import redirect_stdout

from audit_autoexec_storage_gate import IMAGE, SHA, reader_case
from archive_stock_entry_acceptance import archive

CODE = bytes.fromhex('0300a0e11eff2fe1')
ROOT = Path(__file__).resolve().parents[1]


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def make_spec(identifier):
    if not re.fullmatch('[0-9a-f]{12}', identifier):
        raise ValueError('identifier must be exactly 12 lowercase hexadecimal characters')
    stem = 'yi4k_entry_' + identifier
    paths = {'script': '/tmp/SD0/autoexec.ash',
             'claim': '/tmp/SD0/' + stem + '_claim.json',
             'tasks': '/tmp/SD0/' + stem + '_tasks.txt',
             'fingerprint': '/tmp/SD0/' + stem + '_code.bin'}
    lines = ['ps tsk > c:\\' + Path(paths['tasks']).name,
             'savebin c:\\' + Path(paths['fingerprint']).name + ' 0xA0394BA0 l 8']
    script = ('\n'.join(lines) + '\n').encode('ascii')
    claim = dict(schema='stock-entry-stage-claim/v1', identifier=identifier, paths=paths,
                 script_sha256=sha(script), image_sha256=SHA,
                 ownership='exclusive namespace claim only; not a runtime once token')
    claim_bytes = (json.dumps(claim, sort_keys=True, indent=2) + '\n').encode('ascii')
    return dict(schema='stock-entry-acceptance-plan/v1', identifier=identifier, paths=paths,
                script_base64=base64.b64encode(script).decode(), script_sha256=sha(script),
                claim_base64=base64.b64encode(claim_bytes).decode(), claim_sha256=sha(claim_bytes),
                expected_code_hex=CODE.hex(), boot_id_path='/proc/sys/kernel/random/boot_id',
                uptime_path='/proc/uptime', max_file_bytes=65536)


def operation(action, spec):
    """Generate Python 2.7/3 common-subset operation, never run a transport."""
    encoded = base64.b64encode(json.dumps(spec).encode()).decode()
    header = '''import os,stat,json,hashlib,base64
spec=json.loads(base64.b64decode(%r))
paths=spec['paths']
def digest(data): return hashlib.sha256(data).hexdigest()
def snapshot():
 result={}
 for key,path in sorted(paths.items()):
  if not os.path.lexists(path): result[key]={'present':False};continue
  st=os.lstat(path)
  assert stat.S_ISREG(st.st_mode) and st.st_size<=spec['max_file_bytes'], 'Unexpected type/size: '+key
  with open(path,'rb') as f: data=f.read(spec['max_file_bytes']+1)
  assert len(data)==st.st_size, 'File changed during read: '+key
  result[key]={'present':True,'bytes':len(data),'sha256':digest(data),'base64':base64.b64encode(data).decode('ascii')}
 return result
def validate_owned(result):
 for key in ('claim','script'):
  if result[key]['present']:
   assert result[key]['sha256']==spec[key+'_sha256'], 'Ownership mismatch: '+key
def emit(value): print('YI_STOCK_ENTRY '+json.dumps(value,sort_keys=True))
''' % encoded
    if action == 'stage':
        body = '''expected_boot=os.environ.get('YI4K_EXPECTED_STAGE_BOOT_ID')
assert expected_boot and len(expected_boot)==36, 'Read-only preflight boot ID must be bound before stage'
assert open(spec['boot_id_path']).read().strip()==expected_boot, 'Boot identity changed since preflight'
before=snapshot()
assert all(not row['present'] for row in before.values()), 'Refuse existing script/claim/output paths'
try:
 for key in ('claim','script'):
  path=paths[key];data=base64.b64decode(spec[key+'_base64'])
  fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
  with os.fdopen(fd,'wb') as f:
   f.write(data);f.flush();os.fsync(f.fileno())
  assert digest(open(path,'rb').read())==spec[key+'_sha256'], 'Readback mismatch: '+key
 after=snapshot();validate_owned(after)
 assert not after['tasks']['present'] and not after['fingerprint']['present'], 'Unexpected execution during stage'
 assert open(spec['boot_id_path']).read().strip()==expected_boot, 'Boot changed during stage'
except BaseException as error:
 # Preserve partial files and the ownership claim; no deletion on uncertainty.
 emit({'action':'stage','confirmed':False,'error':repr(error),'partial_snapshot':snapshot(),'files_retained':True})
 raise
emit({'action':'stage','identifier':spec['identifier'],'created_exclusively':True,'script_last':True,'boot_id':expected_boot,'uptime':open(spec['uptime_path']).read().strip(),'snapshot':after})
'''
    elif action == 'collect':
        body = '''result=snapshot();validate_owned(result)
assert result['claim']['present'], 'Ownership claim missing'
emit({'action':'collect','identifier':spec['identifier'],'boot_id':open(spec['boot_id_path']).read().strip(),'uptime':open(spec['uptime_path']).read().strip(),'snapshot':result,'removed_files':False})
'''
    elif action == 'disarm':
        body = '''result=snapshot();validate_owned(result)
assert result['claim']['present'], 'Ownership claim missing'
if result['script']['present']: os.unlink(paths['script'])
assert not os.path.lexists(paths['script'])
emit({'action':'disarm','script_removed':True,'evidence_retained':True,'active_reader_quiescence_proven':False})
'''
    elif action == 'cleanup':
        body = '''receipt_text=os.environ.get('YI4K_STOCK_ENTRY_COLLECT_JSON')
assert receipt_text, 'Archived collection receipt is required'
receipt=json.loads(receipt_text)
assert receipt['action']=='collect' and receipt['identifier']==spec['identifier']
assert receipt['archived_and_hash_verified'] is True
expected=receipt['files'];result=snapshot();validate_owned(result)
assert not result['script']['present'], 'Disarm before cleanup'
assert result['claim']['present'], 'Ownership claim missing'
assert all({k:v for k,v in result[key].items() if k!='base64'}==expected[key] for key in ('claim','tasks','fingerprint')), 'Files changed since archived collection'
# Preflight all entries before the first delete. Never glob or delete siblings.
for key in ('tasks','fingerprint','claim'):
 if result[key]['present']: os.unlink(paths[key])
assert all(not os.path.lexists(path) for path in paths.values())
emit({'action':'cleanup','owned_files_removed':True})
'''
    else:
        raise ValueError(action)
    return header + body


def run_host(action, spec, environ=None):
    buffer = io.StringIO()
    previous = dict(os.environ)
    try:
        for key, value in (environ or {}).items():
            if value is None: os.environ.pop(key, None)
            else: os.environ[key] = value
        with redirect_stdout(buffer):
            exec(compile(operation(action, spec), '<host-only-' + action + '>', 'exec'), {})
    finally:
        os.environ.clear(); os.environ.update(previous)
    lines = [line for line in buffer.getvalue().splitlines() if line.startswith('YI_STOCK_ENTRY ')]
    assert len(lines) == 1
    return json.loads(lines[0].split(' ', 1)[1])


def validate_bundle(spec):
    script = base64.b64decode(spec['script_base64'])
    assert script.isascii() and script.endswith(b'\n') and b'\r' not in script and b'\t' not in script
    assert len(script.splitlines()) == 2 and max(map(len, script.splitlines())) < 256
    assert script.decode().splitlines() == [
        'ps tsk > c:\\' + Path(spec['paths']['tasks']).name,
        'savebin c:\\' + Path(spec['paths']['fingerprint']).name + ' 0xA0394BA0 l 8']
    image = IMAGE.read_bytes(); assert sha(image) == SHA
    arm = reader_case(image, 'proposed_two_line_stock_entry_plan', script)
    assert arm['command_strings'] == script.decode().splitlines() and arm['result'] == 0
    for action in ('stage', 'collect', 'disarm', 'cleanup'):
        compile(operation(action, spec), '<review-' + action + '>', 'exec')
    results = []
    with tempfile.TemporaryDirectory(prefix='yi4k-stock-entry-plan-') as tmp:
        root = Path(tmp)
        simulated = copy.deepcopy(spec)
        simulated['paths'] = {key: str(root / Path(path).name) for key, path in spec['paths'].items()}
        boot_id = '11111111-2222-4333-8444-555555555555'
        boot = root / 'boot-id'; boot.write_text(boot_id + '\n')
        uptime = root / 'uptime'; uptime.write_text('100.00 80.00\n')
        simulated.update(boot_id_path=str(boot), uptime_path=str(uptime))
        env = {'YI4K_EXPECTED_STAGE_BOOT_ID': boot_id}
        # Missing activation binding rejects before writes.
        try:
            run_host('stage', simulated, {'YI4K_EXPECTED_STAGE_BOOT_ID': None})
        except AssertionError:
            assert all(not Path(path).exists() for path in simulated['paths'].values())
            results.append('unbound_stage_rejected_before_writes')
        else: raise AssertionError('unbound stage accepted')
        stage = run_host('stage', simulated, env)
        assert stage['created_exclusively'] and stage['script_last']
        results.append('stage_exclusive_claim_then_script')
        try: run_host('stage', simulated, env)
        except AssertionError: results.append('second_stage_existing_paths_rejected')
        else: raise AssertionError('second stage accepted')
        partial = run_host('collect', simulated)
        assert not partial['snapshot']['tasks']['present'] and not partial['snapshot']['fingerprint']['present']
        assert partial['removed_files'] is False
        results.append('partial_collect_preserves_missing_and_existing_files')
        # Host fixtures only; no stock handler/hardware output is manufactured.
        boot.write_text('22222222-3333-4444-8555-666666666666\n')
        Path(simulated['paths']['tasks']).write_bytes(b'ID PRI STAT NAME\n14 249 READY AmbaShell_ExecTask\n')
        Path(simulated['paths']['fingerprint']).write_bytes(CODE)
        collection = run_host('collect', simulated)
        archive_path = root / 'archive'
        verified = archive(simulated, stage, collection, archive_path)
        assert verified['accepted'] is True
        archived = json.loads((archive_path / 'cleanup-input.json').read_text())
        results.append('host_archive_hashes_and_new_boot_fixture_verified')
        corrupt = copy.deepcopy(collection)
        corrupt['snapshot']['fingerprint']['base64'] = base64.b64encode(b'corrupt!').decode()
        try: archive(simulated, stage, corrupt, root / 'rejected-archive')
        except AssertionError:
            assert not (root / 'rejected-archive').exists()
            results.append('corrupt_transport_bytes_rejected_before_archive_creation')
        else: raise AssertionError('corrupt archive accepted')
        clean_env = {'YI4K_STOCK_ENTRY_COLLECT_JSON': json.dumps(archived)}
        try: run_host('cleanup', simulated, clean_env)
        except AssertionError: results.append('armed_cleanup_rejected')
        else: raise AssertionError('armed cleanup accepted')
        script_path = Path(simulated['paths']['script'])
        original = script_path.read_bytes(); script_path.write_bytes(original + b'changed\n')
        try: run_host('disarm', simulated)
        except AssertionError:
            assert script_path.exists(); results.append('changed_script_disarm_rejected')
        else: raise AssertionError('changed script removed')
        script_path.write_bytes(original)
        run_host('disarm', simulated)
        results.append('disarm_removes_only_owned_script')
        fingerprint = Path(simulated['paths']['fingerprint']); fingerprint.write_bytes(b'changed')
        try: run_host('cleanup', simulated, clean_env)
        except AssertionError:
            assert Path(simulated['paths']['claim']).exists() and Path(simulated['paths']['tasks']).exists()
            results.append('changed_output_cleanup_rejected_before_any_delete')
        else: raise AssertionError('changed output removed')
        fingerprint.write_bytes(CODE)
        sibling = root / 'unowned.txt'; sibling.write_text('retain')
        run_host('cleanup', simulated, clean_env)
        assert sibling.read_text() == 'retain'
        results.append('cleanup_exact_snapshot_only_unowned_sibling_retained')
    return dict(schema='stock-entry-plan-dry-run/v1', status='pass_host_only',
                script_sha256=sha(script), script_bytes=len(script), line_count=2,
                max_line_bytes=max(map(len, script.splitlines())), ascii_lf_only=True, has_tabs=False,
                arm_reader=arm, host_lifecycle_cases=results,
                device_access=False, target_write=False, device_stage_executed=False,
                host_temporary_stage_executed=True, reboot_executed=False,
                synthetic_host_outputs_are_device_evidence=False,
                archiver_sha256=sha((ROOT / 'scripts/archive_stock_entry_acceptance.py').read_bytes()),
                limitations=['Host temporary files validate ownership and lifecycle logic only.',
                             'Original ARM reader uses mocked filesystem/parser, no command handler execution.',
                             'Python 2.7 compatibility is a common-syntax design; no local camera Python 2 runtime was executed.',
                             'Stage claim is not a runtime once gate; another storage event may overwrite outputs.',
                             'Disarm does not stop an already-open reader; require stable collection before cleanup.'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dry-run', action='store_true', required=True)
    parser.add_argument('--identifier', default=None)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    spec = make_spec(args.identifier or uuid.uuid4().hex[:12])
    validation = validate_bundle(spec)
    args.output.mkdir(parents=True, exist_ok=False)
    (args.output / 'autoexec.ash').write_bytes(base64.b64decode(spec['script_base64']))
    (args.output / 'stage-claim.json').write_bytes(base64.b64decode(spec['claim_base64']))
    for action in ('stage', 'collect', 'disarm', 'cleanup'):
        (args.output / ('review-' + action + '.py')).write_text(operation(action, spec))
    (args.output / 'plan.json').write_text(json.dumps(spec, indent=2) + '\n')
    validation['builder_sha256'] = sha(Path(__file__).read_bytes())
    validation['bundle_file_sha256'] = {p.name: sha(p.read_bytes()) for p in sorted(args.output.iterdir())}
    (args.output / 'dry-run.json').write_text(json.dumps(validation, indent=2) + '\n')
    print(json.dumps({'identifier': spec['identifier'], 'output': str(args.output),
                      'reader_lines': len(validation['arm_reader']['command_strings']),
                      'host_lifecycle_cases': len(validation['host_lifecycle_cases']),
                      'device_access': False, 'stage_executed': False}))


if __name__ == '__main__':
    main()
