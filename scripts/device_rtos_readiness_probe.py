#!/usr/bin/env python3
"""One-shot stock RTOS pool/task queries; stage, collect, hash-owned cleanup.

Uses the established autoexec path and native savebin (no Linux DRAM mapping).
Does not reboot, initialize SharePreview, record, or change EIS configuration.
"""
import argparse
import base64
import datetime
import hashlib
import json
from pathlib import Path
import re
import uuid

from device_linux_capture import Telnet
from device_python_transport import run_python
from device_rtos_command_probe import preflight, EXPECTED_CODE


def sha(data):
    return hashlib.sha256(data).hexdigest()


def spec(identifier):
    assert re.fullmatch('[0-9a-f]{12}', identifier)
    stem = 'yi4k_diag_' + identifier
    sd = '/tmp/SD0/'
    paths = {k: sd + stem + '_' + k + ext for k, ext in [
        ('fingerprint', '.bin'), ('pool1', '.bin'), ('pool2', '.bin'),
        ('va1', '.bin'), ('va2', '.bin'), ('mem', '.txt'),
        ('tsk1', '.txt'), ('tsk2', '.txt'), ('claim', '.json'), ('done', '.json')]}
    paths.update(autoexec=sd+'autoexec.ash', worker=sd+stem+'.py', ready=sd+stem+'_ready')
    def rpc(command):
        assert len(command) < 100
        return "t ipc rpc clnt exec1 '" + command + "'"
    def save(key, address, length):
        return 'savebin c:\\%s 0x%08X l %d' % (Path(paths[key]).name, address, length)
    def guard(command):
        # Stock parser's general condition form is not POSIX-compatible.
        # Separate cd + if $? is the on-device-validated form; see the earlier
        # recording trace stage-02 and docs/device-eis-recording-trace.md.
        return 'cd c:\\%s\nif $?; then %s; fi' % (Path(paths['ready']).name, command)
    commands = [save('pool1', 0xA0FD7114, 0x30),
                save('va1', 0xA14307B8, 0xDC),
                'ps mem > c:\\'+Path(paths['mem']).name,
                'ps tsk > c:\\'+Path(paths['tsk1']).name,
                't app mem', rpc('sleep 3'),
                save('pool2', 0xA0FD7114, 0x30),
                save('va2', 0xA14307B8, 0xDC),
                'ps tsk > c:\\'+Path(paths['tsk2']).name,
                rpc('python -B '+paths['worker']+' done')]
    lines = [rpc('sleep 3')]*6 + [save('fingerprint',0xA0394BA0,8),
             rpc('python -B '+paths['worker']+' claim')]
    lines += [guard(command) for command in commands]
    lines += ['cd c:\\']
    script = ('\n'.join(lines)+'\n\n').encode()
    assert all(len(line)<256 for line in script.splitlines())
    worker = '''import os,sys,stat,json,hashlib,time
paths=%r
expected=%r
def digest(p): return hashlib.sha256(open(p,'rb').read()).hexdigest()
def write_json(p, value):
 fd=os.open(p,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
 with os.fdopen(fd,'wb') as f:
  f.write(json.dumps(value)); f.flush(); os.fsync(f.fileno())
 os.system('sync')
phase=sys.argv[1]
if phase=='claim':
 if os.path.lexists(paths['ready']):
  assert os.path.isdir(paths['ready']) and os.listdir(paths['ready'])==[]
  os.rmdir(paths['ready']); os.system('sync')
 if os.path.lexists(paths['claim']): sys.exit(0)
 assert digest(paths['fingerprint'])==%r, 'Firmware fingerprint mismatch'
 assert stat.S_ISREG(os.lstat(paths['autoexec']).st_mode)
 assert digest(paths['autoexec'])==expected
 write_json(paths['claim'],{'phase':phase,'boot_id':open('/proc/sys/kernel/random/boot_id').read().strip(),'uptime':open('/proc/uptime').read().strip(),'wall_time':time.time()})
 os.mkdir(paths['ready']); os.system('sync')
elif phase=='done':
 assert os.path.isdir(paths['ready']) and os.path.isfile(paths['claim'])
 write_json(paths['done'],{'phase':phase,'uptime':open('/proc/uptime').read().strip(),'wall_time':time.time()})
else: raise ValueError('Unexpected phase')
''' % (paths, sha(script), sha(bytes.fromhex(EXPECTED_CODE)))
    payloads = {'autoexec':script,'worker':worker.encode()}
    return {'identifier':identifier,'paths':paths,'startup_delay_seconds':18,
            'payloads':{k:base64.b64encode(v).decode() for k,v in payloads.items()},
            'payload_sha256':{k:sha(v) for k,v in payloads.items()}}


def target_program(action, probe, expected=None):
    # Short literals stay below the camera's interactive canonical input limit.
    encoded=base64.b64encode(json.dumps(probe).encode()).decode()
    header='import os,stat,json,base64,hashlib,subprocess\nprobe=json.loads(base64.b64decode((\n'
    header+='\n'.join(repr(encoded[i:i+100]) for i in range(0,len(encoded),100))+'\n)))\n'
    header+='paths=probe["paths"]\ndef sha(data): return hashlib.sha256(data).hexdigest()\n'
    if action=='stage':
        body='''for p in paths.values():
 assert not os.path.lexists(p), 'Existing path: '+p
created=[]
try:
 for key in ('worker','autoexec'):
  p=paths[key];data=base64.b64decode(probe['payloads'][key])
  fd=os.open(p,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
  created.append((p,sha(data)))
  with os.fdopen(fd,'wb') as f:
   f.write(data);f.flush();os.fsync(f.fileno())
  assert sha(open(p,'rb').read())==probe['payload_sha256'][key]
  subprocess.check_call(['sync'])
except:
 for p,h in reversed(created):
  if os.path.isfile(p) and sha(open(p,'rb').read())==h: os.unlink(p)
 raise
print('YI_READINESS '+json.dumps({'staged':True,'autoexec_last':True}))
'''
    else:
        body='''result={}
for key,p in paths.items():
 if not os.path.lexists(p): result[key]={'present':False};continue
 st=os.lstat(p)
 if key=='ready':
  assert stat.S_ISDIR(st.st_mode)
  result[key]={'present':True,'directory':True,'entries':os.listdir(p)}
 else:
  assert stat.S_ISREG(st.st_mode) and st.st_size<=262144
  data=open(p,'rb').read()
  result[key]={'present':True,'bytes':len(data),'sha256':sha(data),'base64':base64.b64encode(data)}
'''
        if action=='cleanup':
            body += 'expected='+repr(expected)+'\n'
            body += '''assert result==expected, 'Target files changed since collection'
for key in ('autoexec','worker'):
 if result[key]['present']:
  assert result[key]['sha256']==probe['payload_sha256'][key]
if result['ready']['present']: assert result['ready']['entries']==[]
# All files verified before deleting any; uncollected/changed files are preserved.
for key,p in paths.items():
 if result[key]['present']:
  if key=='ready': os.rmdir(p)
  else: os.unlink(p)
subprocess.check_call(['sync'])
assert all(not os.path.lexists(p) for p in paths.values())
print('YI_READINESS '+json.dumps({'cleaned':True}))
'''
        else:
            body += "print('YI_READINESS '+json.dumps(result))\n"
    return header+body


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('action',choices=['stage','collect','cleanup'])
    p.add_argument('--host',default='192.168.42.1')
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--receipt',type=Path)
    args=p.parse_args()
    previous=None
    if args.action=='stage': probe=spec(uuid.uuid4().hex[:12])
    else:
        assert args.receipt
        previous=json.loads(args.receipt.read_text())
        assert previous['host']==args.host and previous['probe']==spec(previous['probe']['identifier'])
        assert previous['action']==('stage' if args.action=='collect' else 'collect')
        assert 'error' not in previous
        probe=previous['probe']
    args.output.mkdir(parents=True,exist_ok=False)
    session={'action':args.action,'host':args.host,'probe':probe,'api_events':[],
             'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
             'memory_mapping_run':False,'firmware_patched':False,'reboot_requested':False}
    camera=None
    try:
        if args.action=='stage': session['status_before']=preflight(args.host,session['api_events'])
        program=target_program(args.action,probe,previous['result'] if args.action=='cleanup' else None)
        (args.output/'target-operation.py').write_text(program)
        for key,value in probe['payloads'].items():
            (args.output/('autoexec.ash' if key=='autoexec' else 'worker.py')).write_bytes(base64.b64decode(value))
        camera=Telnet(args.host);camera.login()
        raw=run_python(camera,program,args.output,timeout=30)
        (args.output/'telnet-output.txt').write_text(raw)
        lines=[s for s in raw.splitlines() if s.startswith('YI_READINESS ')]
        assert len(lines)==1,'Target result missing'
        session['result']=json.loads(lines[0].split(' ',1)[1])
        if args.action=='collect':
            for key,item in session['result'].items():
                if 'base64' not in item: continue
                data=base64.b64decode(item['base64'],validate=True)
                assert len(data)==item['bytes'] and sha(data)==item['sha256']
                (args.output/Path(probe['paths'][key]).name).write_bytes(data)
        print(json.dumps({'action':args.action,'identifier':probe['identifier'],
                          'result':session['result'] if args.action!='collect' else
                          {k:{x:y for x,y in v.items() if x!='base64'} for k,v in session['result'].items()}}))
    except BaseException as error:
        session['error']=repr(error);raise
    finally:
        try:
            if camera is not None: camera.close()
        except Exception as error:
            session['close_error']=repr(error)
        finally:
            session['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
            (args.output/'session.json').write_text(json.dumps(session,indent=2)+'\n')


if __name__=='__main__': main()
