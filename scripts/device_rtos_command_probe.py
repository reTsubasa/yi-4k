#!/usr/bin/env python3
"""Stage/collect a bounded stock RTOS startup-command probe on device 1.10.7.

Three commands: Linux begin marker via RTOS RPC, RTOS savebin of 8 immutable
code bytes to a unique SD file, Linux end marker via RTOS RPC. No code patch,
DRAM mapping, settings change, reboot, or firmware flash. Collection verifies
the result and removes only files whose content matches this probe's receipt.
"""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import uuid

from device_eis_live_capture import CameraAPI
from device_linux_capture import Telnet

MARKER = '/tmp/SD0/autoexec.ash'
EXPECTED_CODE = '0300a0e11eff2fe1'  # A0394BA0: mov r0,r3; bx lr


def spec(identifier):
    if len(identifier) != 12 or any(c not in '0123456789abcdef' for c in identifier):
        raise ValueError('Invalid probe identifier')
    stem = 'yi4k_probe_' + identifier
    begin, done = '/tmp/' + stem + '_begin', '/tmp/' + stem + '_done'
    output = '/tmp/SD0/' + stem + '.bin'
    script = ("t ipc rpc clnt exec1 'touch " + begin + "'\n" +
              'savebin c:\\' + stem + '.bin 0xA0394BA0 l 8\n' +
              "t ipc rpc clnt exec1 'touch " + done + "'\n\n")
    assert all(len(line) < 100 for line in script.splitlines())
    return dict(identifier=identifier, begin=begin, done=done, output=output,
                script=script, script_sha256=hashlib.sha256(script.encode()).hexdigest())


def preflight(host, events):
    api = CameraAPI(host, events)
    try:
        api.open_session()
        status = api.call(1, type='app_status')
        assert status.get('rval') == 0 and status.get('param') in ('idle', 'vf'), status
        settings = api.call(3)
        assert settings.get('rval') == 0
        version = next(row['sw_version'] for row in settings['param'] if 'sw_version' in row)
        assert version.startswith('Z16V13L_1.10.7_'), 'Unexpected firmware'
        return status
    finally:
        api.close()


def target_program(action, probe):
    header = 'import os,stat,hashlib,json,binascii,subprocess\n'
    header += 'probe = ' + repr(probe) + '\npath = ' + repr(MARKER) + '\n'
    header += 'expected_code = ' + repr(EXPECTED_CODE) + '\n'
    if action == 'stage':
        body = """for name in (probe['begin'],probe['done'],probe['output'],path):
    assert not os.path.lexists(name), 'Refuse existing probe path: '+name
fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0600)
with os.fdopen(fd,'wb') as file:
    file.write(probe['script'])
assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['script_sha256']
subprocess.check_call(['sync'])
print('YI_COMMAND_PROBE '+json.dumps({'created_exclusively':True,'script_sha256':probe['script_sha256']}))
"""
    else:
        body = """result={}
for key in ('begin','done'):
    name=probe[key]
    assert os.path.lexists(name), 'Execution marker missing: '+key
    st=os.lstat(name)
    assert stat.S_ISREG(st.st_mode) and st.st_size==0, 'Modified marker: '+key
    result[key]=True
st=os.lstat(path)
assert stat.S_ISREG(st.st_mode), 'Modified autoexec type'
assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['script_sha256'], 'Modified autoexec content'
st=os.lstat(probe['output'])
assert stat.S_ISREG(st.st_mode) and st.st_size==8, 'Unexpected RTOS output'
data=open(probe['output'],'rb').read()
assert binascii.hexlify(data)==expected_code, 'RTOS output fingerprint mismatch'
result.update({'output_hex':binascii.hexlify(data),'output_sha256':hashlib.sha256(data).hexdigest(),'output_bytes':len(data)})
# Verify every artifact before any removal; leave mismatches for review.
for name in (path,probe['output'],probe['begin'],probe['done']):
    os.unlink(name)
assert all(not os.path.lexists(name) for name in (path,probe['output'],probe['begin'],probe['done']))
subprocess.check_call(['sync'])
result['owned_files_removed']=True
print('YI_COMMAND_PROBE '+json.dumps(result))
"""
    return header + body


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('stage', 'collect'))
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--receipt', type=Path)
    args = parser.parse_args()
    if args.action == 'collect':
        if args.receipt is None:
            parser.error('collect requires --receipt from stage')
        receipt = json.loads(args.receipt.read_text())
        assert receipt['host'] == args.host and receipt['action'] == 'stage'
        assert receipt['result']['created_exclusively'] is True
        probe = spec(receipt['probe']['identifier'])
        assert receipt['probe'] == probe
    else:
        probe = spec(uuid.uuid4().hex[:12])
    args.output.mkdir(parents=True, exist_ok=False)
    session = dict(action=args.action, host=args.host, probe=probe, api_events=[],
                   started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   memory_mapping_run=False, firmware_patched=False,
                   reboot_requested=False)
    camera = None
    try:
        session['status_before'] = preflight(args.host, session['api_events'])
        program = target_program(args.action, probe)
        (args.output / 'target-operation.py').write_text(program)
        (args.output / 'autoexec.ash').write_text(probe['script'])
        camera = Telnet(args.host)
        camera.login()
        raw = camera.command("python -B -u <<'YI_COMMAND_PROBE_PY'\n" + program +
                             '\nYI_COMMAND_PROBE_PY', timeout=20)
        (args.output / 'telnet-output.txt').write_text(raw)
        lines = [line for line in raw.splitlines() if line.startswith('YI_COMMAND_PROBE ')]
        assert len(lines) == 1, 'Operation not confirmed; inspect retained output'
        session['result'] = json.loads(lines[0].split(' ', 1)[1])
        if args.action == 'collect':
            (args.output / 'rtos-code-fingerprint.bin').write_bytes(bytes.fromhex(session['result']['output_hex']))
        print(json.dumps(session['result']))
    except BaseException as error:
        session['error'] = repr(error)
        raise
    finally:
        if camera is not None:
            camera.close()
        (args.output / 'session.json').write_text(json.dumps(session, indent=2)+'\n')


if __name__ == '__main__':
    main()
