#!/usr/bin/env python3
"""Gate a finite native EIS trace on baseline files and the stock API.

Uses existing RTOS startup Shell only; no /dev/mem, flashing or code patching.
The earlier native-eis-trace experiment and receipts remain reproducible.
"""
import argparse
import base64
import datetime
import hashlib
import json
from pathlib import Path
import struct
import uuid

from device_linux_capture import Telnet
from device_python_transport import run_python
from device_rtos_command_probe import preflight, EXPECTED_CODE

ROOT=Path(__file__).resolve().parents[1]
FIELDS={14:1,15:1,20:1,22:50}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def spec(identifier,condition_style='command'):
    assert len(identifier)==12 and all(c in '0123456789abcdef' for c in identifier)
    stem='yi4k_rec_'+identifier
    sd='/tmp/SD0/'
    paths={'script':sd+'autoexec.ash','worker':sd+stem+'.py','log_marker':sd+'save_log_enable.script'}
    for key,ext in (('before','bin'),('active','bin'),('after','bin'),('fingerprint','bin'),
                    ('gate','json'),('record','json'),('attempt','flag')):
        paths[key]=sd+stem+'_'+key+'.'+ext
    paths.update(begin='/tmp/'+stem+'_begin',done='/tmp/'+stem+'_done',negative='/tmp/'+stem+'_bad')
    if condition_style=='status':paths['positive']='/tmp/'+stem+'_good'
    ready=sd+stem+'_ready'
    worker_spec=dict(paths=paths,ready_dir=ready)
    worker='BOOT_SPEC = '+repr(worker_spec)+'\n'+(ROOT/'sdk/device-probe/native-eis-recording/worker.py').read_text()
    compile(worker,'<recording-worker>','exec')
    def rpc(command):
        assert len(command)<100
        return "t ipc rpc clnt exec1 '"+command+"'"
    def save(key,address,length):
        return 'savebin c:\\'+Path(paths[key]).name+' '+address+' l '+str(length)
    def guard(command,path=ready):
        if condition_style=='status':
            return 'cd c:\\'+Path(path).name+'\nif $?; then '+command+'; fi'
        return 'if cd c:\\'+Path(path).name+'; then '+command+'; fi'
    lines=[rpc('touch '+paths['begin'])]
    # Linux sleep uses known seconds; each call stays below the 5 s RPC timeout.
    lines += [rpc('sleep 3')]*6
    lines += [save('fingerprint','0xA0394BA0',8),save('before','0xA0757AF8',74),
              rpc('python -B '+paths['worker']+' prepare'),
              guard(rpc('touch '+paths['negative']),sd+stem+'_missing')]
    if condition_style=='status':lines.append(guard(rpc('touch '+paths['positive'])))
    for i in (22,14,15,20):lines.append(guard('t imgproc -eis 100 %d %d'%(i,FIELDS[i])))
    lines += [guard(save('active','0xA0757AF8',74)),
              guard(rpc('python -B '+paths['worker']+' record'))]
    for i in (20,15,14,22):lines.append(guard('t imgproc -eis 100 %d 0'%i))
    lines += [save('after','0xA0757AF8',74),'cd c:\\',rpc('touch '+paths['done'])]
    assert all(len(line)<256 for block in lines for line in block.splitlines())
    payloads={'worker':worker.encode(),'script':('\n'.join(lines)+'\n\n').encode(),'log_marker':b''}
    result=dict(identifier=identifier,paths=paths,ready_dir=ready,missing_dir=sd+stem+'_missing',
                fields=FIELDS,startup_delay_seconds=18,
                payloads={k:base64.b64encode(v).decode() for k,v in payloads.items()},
                payload_sha256={k:sha(v) for k,v in payloads.items()})
    if condition_style=='status':result['condition_style']='status'
    return result


def target_program(action,probe,expected=None):
    # Small literal lines for camera Python 2.7, additionally chunked by transport.
    encoded=base64.b64encode(json.dumps(probe).encode()).decode()
    header='import os,stat,json,base64,hashlib,subprocess\nprobe=json.loads(base64.b64decode((\n'
    header+='\n'.join(repr(encoded[i:i+120]) for i in range(0,len(encoded),120))+'\n)))\n'
    if action=='stage':
        body="""for path in list(probe['paths'].values())+[probe['ready_dir'],probe['missing_dir']]:
 assert not os.path.lexists(path), 'Refuse existing path: '+path
created=[]
try:
 for key in ('worker','log_marker','script'):
  path=probe['paths'][key];data=base64.b64decode(probe['payloads'][key])
  fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
  with os.fdopen(fd,'wb') as f:f.write(data)
  created.append((path,probe['payload_sha256'][key]))
  assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['payload_sha256'][key]
 subprocess.check_call(['sync'])
except:
 for path,digest in reversed(created):
  if stat.S_ISREG(os.lstat(path).st_mode) and hashlib.sha256(open(path,'rb').read()).hexdigest()==digest:os.unlink(path)
 raise
print('YI_RECORD_RESULT '+json.dumps({'created_exclusively':True}))
"""
    elif action=='collect':
        body="""missing=[]
for key,path in sorted(probe['paths'].items()):
 if not os.path.lexists(path):
  missing.append(key);continue
 st=os.lstat(path)
 assert stat.S_ISREG(st.st_mode) and st.st_size<=65536, 'Unexpected file: '+key
 data=open(path,'rb').read()
 print('YI_RECORD_FILE '+json.dumps({'key':key,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'base64':base64.b64encode(data)}))
ready=os.path.lexists(probe['ready_dir'])
if ready:assert stat.S_ISDIR(os.lstat(probe['ready_dir']).st_mode) and os.listdir(probe['ready_dir'])==[]
assert not os.path.lexists(probe['missing_dir'])
print('YI_RECORD_RESULT '+json.dumps({'missing':missing,'ready_directory':ready}))
"""
    elif action=='disarm':
        body="""for key in ('worker','log_marker','script'):
 path=probe['paths'][key]
 assert stat.S_ISREG(os.lstat(path).st_mode)
 assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['payload_sha256'][key]
for key in ('script','worker','log_marker'):os.unlink(probe['paths'][key])
subprocess.check_call(['sync'])
print('YI_RECORD_RESULT '+json.dumps({'configuration_removed':True,'runtime_flags_verified':False}))
"""
    else:
        header+='expected='+repr(expected)+'\n'
        body="""for key,path in probe['paths'].items():
 if key not in expected:
  assert not os.path.lexists(path);continue
 assert stat.S_ISREG(os.lstat(path).st_mode)
 assert hashlib.sha256(open(path,'rb').read()).hexdigest()==expected[key]
if os.path.lexists(probe['ready_dir']):
 assert stat.S_ISDIR(os.lstat(probe['ready_dir']).st_mode) and os.listdir(probe['ready_dir'])==[]
assert not os.path.lexists(probe['missing_dir'])
for key in expected:os.unlink(probe['paths'][key])
if os.path.isdir(probe['ready_dir']):os.rmdir(probe['ready_dir'])
subprocess.check_call(['sync'])
assert all(not os.path.lexists(p) for p in list(probe['paths'].values())+[probe['ready_dir']])
print('YI_RECORD_RESULT '+json.dumps({'owned_files_removed':True}))
"""
    return header+body


def verify(directory,probe,files,result):
    def data(key):return (directory/(key+'.dat')).read_bytes()
    for key in ('script','worker','log_marker'):
        assert files[key]['sha256']==probe['payload_sha256'][key]
    assert data('fingerprint').hex()==EXPECTED_CODE
    tables={key:list(struct.unpack('<37H',data(key))) for key in ('before','active','after')}
    assert tables['before']==tables['after'],'Full diagnostic table did not restore'
    wanted=list(tables['before'])
    for i,v in FIELDS.items():
        assert wanted[i]==0,'Unexpected baseline'
        wanted[i]=v
    assert tables['active']==wanted
    assert 'negative' not in files and result['missing']==['negative']
    if probe.get('condition_style')=='status':assert data('positive')==b''
    assert data('begin')==data('done')==b''
    assert result['ready_directory']
    gate=json.loads(data('gate'))
    worker=json.loads(data('record'))
    assert gate.get('ready_created') and gate.get('baseline_checked_before_enable') and not gate.get('error')
    assert worker.get('start_ack') and worker.get('stop_ack') and not worker.get('error'),worker.get('error')
    return dict(passed=True,tables=tables,gate=gate,worker=worker)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('stage','collect','cleanup','disarm'))
    parser.add_argument('--host',default='192.168.42.1')
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--receipt',type=Path)
    parser.add_argument('--collection',type=Path)
    args=parser.parse_args()
    if args.action=='stage':probe=spec(uuid.uuid4().hex[:12],'status')
    else:
        receipt=json.loads(args.receipt.read_text())
        assert receipt['action']=='stage' and receipt['host']==args.host and receipt['result']['created_exclusively']
        probe=receipt['probe']
        assert probe==json.loads(json.dumps(spec(probe['identifier'],probe.get('condition_style','command')))),'Staged source changed'
    expected=None
    if args.action=='cleanup':
        previous=json.loads(args.collection.read_text())
        assert previous['probe']==probe and previous['host']==args.host
        # Cleanup also supports a failed recording if native restoration is proven.
        for key,row in previous['files'].items():
            local=args.collection.parent/(key+'.dat')
            assert sha(local.read_bytes())==row['sha256']
        assert (args.collection.parent/'fingerprint.dat').read_bytes().hex()==EXPECTED_CODE
        before=(args.collection.parent/'before.dat').read_bytes()
        assert len(before)==74 and before==(args.collection.parent/'after.dat').read_bytes()
        for key in ('worker','script','log_marker'):
            assert previous['files'][key]['sha256']==probe['payload_sha256'][key]
        expected={k:r['sha256'] for k,r in previous['files'].items()}
        cleanup_restoration_verified=True
    args.output.mkdir(parents=True,exist_ok=False)
    session=dict(action=args.action,host=args.host,probe=probe,api_events=[],
                 started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),memory_probe=False,firmware_patch=False)
    if args.action=='cleanup':session['captured_restoration_verified']=cleanup_restoration_verified
    camera=None
    try:
        session['status_before']=preflight(args.host,session['api_events'])
        source=target_program(args.action,probe,expected)
        (args.output/'target-operation.py').write_text(source)
        if args.action=='stage':
            for key in ('script','worker'):
                (args.output/('autoexec.ash' if key=='script' else 'worker.py')).write_bytes(base64.b64decode(probe['payloads'][key]))
        camera=Telnet(args.host);camera.login()
        raw=run_python(camera,source,args.output,timeout=30)
        (args.output/'telnet-output.txt').write_text(raw)
        files={};results=[]
        for line in raw.splitlines():
            if line.startswith('YI_RECORD_FILE '):
                row=json.loads(line.split(' ',1)[1]);key=row['key']
                assert key in probe['paths'] and key not in files
                data=base64.b64decode(row.pop('base64'),validate=True)
                assert len(data)==row['bytes'] and sha(data)==row['sha256']
                (args.output/(key+'.dat')).write_bytes(data);files[key]=row
            elif line.startswith('YI_RECORD_RESULT '):results.append(json.loads(line.split(' ',1)[1]))
        session['files']=files
        assert len(results)==1,'No result confirmation'
        session['result']=results[0]
        if args.action=='collect':session['verification']=verify(args.output,probe,files,results[0])
        print(json.dumps({'action':args.action,'result':results[0],'verified':session.get('verification',{}).get('passed')}))
    except BaseException as error:
        session['error']=repr(error)
        raise
    finally:
        if camera:camera.close()
        (args.output/'session.json').write_text(json.dumps(session,indent=2)+'\n')


if __name__=='__main__':main()
