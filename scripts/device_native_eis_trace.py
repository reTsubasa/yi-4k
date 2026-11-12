#!/usr/bin/env python3
"""Stage/collect/clean one finite stock RTOS EIS diagnostic experiment.

Changes only four native diagnostic fields during a short stock API clip.
Captures the debug table before/during/after, retains all receipts, and never
maps device memory, patches executable bytes, or flashes firmware.
"""
import argparse
import base64
import datetime
import hashlib
import json
from pathlib import Path
import uuid

from device_linux_capture import Telnet
from device_rtos_command_probe import preflight, EXPECTED_CODE
from device_python_transport import run_python

ROOT=Path(__file__).resolve().parents[1]
FIELDS={14:1,15:1,20:1,22:50}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def make_spec(identifier):
    assert len(identifier)==12 and all(c in '0123456789abcdef' for c in identifier)
    stem='yi4k_trace_'+identifier
    sd='/tmp/SD0/'
    paths={'script':sd+'autoexec.ash','worker':sd+stem+'.py',
           'log_marker':sd+'save_log_enable.script',
           'before':sd+stem+'_before.bin','active':sd+stem+'_active.bin',
           'after':sd+stem+'_after.bin','fingerprint':sd+stem+'_code.bin',
           'record':sd+stem+'_record.json','attempt':sd+stem+'_attempt',
           'begin':'/tmp/'+stem+'_begin','done':'/tmp/'+stem+'_done'}
    worker='TRACE_STEM = '+repr(stem)+'\n'+(ROOT/'sdk/device-probe/native-eis-trace/worker.py').read_text()
    compile(worker,'<trace-worker>','exec')
    def rpc(command):
        assert len(command)<100
        return "t ipc rpc clnt exec1 '"+command+"'"
    def save(key,address,length):
        return 'savebin c:\\'+Path(paths[key]).name+' '+address+' l '+str(length)
    lines=[rpc('touch '+paths['begin']),save('fingerprint','0xA0394BA0',8),
           save('before','0xA0757AF8',74)]
    for i in (22,14,15,20):lines.append('t imgproc -eis 100 %d %d'%(i,FIELDS[i]))
    lines.extend([save('active','0xA0757AF8',74),rpc('python -B '+paths['worker'])])
    for i in (20,15,14,22):lines.append('t imgproc -eis 100 %d 0'%i)
    lines.extend([save('after','0xA0757AF8',74),rpc('touch '+paths['done'])])
    assert all(len(line)<256 for line in lines)
    script='\n'.join(lines)+'\n\n'
    contents={'script':script.encode(),'worker':worker.encode(),'log_marker':b''}
    return {'identifier':identifier,'paths':paths,'fields':FIELDS,
            'payloads':{key:base64.b64encode(value).decode() for key,value in contents.items()},
            'payload_sha256':{key:digest(value) for key,value in contents.items()}}


def program(action, probe, collected=None):
    def assignment(name, value):
        encoded=base64.b64encode(json.dumps(value).encode()).decode()
        chunks='\n'.join('    '+repr(encoded[i:i+128]) for i in range(0,len(encoded),128))
        return name+' = json.loads(base64.b64decode((\n'+chunks+'\n)))\n'
    target_probe=dict(probe)
    if action!='stage':target_probe.pop('payloads')
    header='import os,stat,hashlib,json,base64,subprocess\n'+assignment('probe',target_probe)
    if action=='stage':
        body="""for name in probe['paths'].values():
    assert not os.path.lexists(name), 'Refuse existing path: '+name
created=[]
try:
    for key in ('worker','log_marker','script'):
        path=probe['paths'][key]
        data=base64.b64decode(probe['payloads'][key])
        fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
        created.append((path,probe['payload_sha256'][key]))
        with os.fdopen(fd,'wb') as file:file.write(data)
        assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['payload_sha256'][key]
    subprocess.check_call(['sync'])
except:
    for path,expected in reversed(created):
        if os.path.isfile(path) and hashlib.sha256(open(path,'rb').read()).hexdigest()==expected:os.unlink(path)
    raise
print('YI_TRACE_RESULT '+json.dumps({'created_exclusively':True,'payload_sha256':probe['payload_sha256']}))
""".replace('\n+','\n')
    elif action=='collect':
        body="""for key,path in sorted(probe['paths'].items()):
    st=os.lstat(path)
    assert stat.S_ISREG(st.st_mode) and st.st_size<=65536, 'Unexpected evidence size/type: '+key
    data=open(path,'rb').read()
    print('YI_TRACE_FILE '+json.dumps({'key':key,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'base64':base64.b64encode(data)}))
print('YI_TRACE_RESULT '+json.dumps({'collected':True}))
""".replace('\n+','\n')
    elif action=='disarm':
        body="""keys=('script','worker','log_marker')
for key in keys:
    path=probe['paths'][key]
    st=os.lstat(path)
    assert stat.S_ISREG(st.st_mode), 'Modified configuration type: '+key
    assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['payload_sha256'][key], 'Modified configuration: '+key
for key in keys:os.unlink(probe['paths'][key])
subprocess.check_call(['sync'])
assert all(not os.path.lexists(probe['paths'][key]) for key in keys)
print('YI_TRACE_RESULT '+json.dumps({'owned_configuration_removed':True,'runtime_flags_verified':False,'evidence_retained':True}))
"""
    else:
        header+=assignment('expected',collected)
        body="""for key,path in probe['paths'].items():
    st=os.lstat(path)
    assert stat.S_ISREG(st.st_mode), 'Modified evidence type: '+key
    assert hashlib.sha256(open(path,'rb').read()).hexdigest()==expected[key], 'Modified evidence: '+key
for path in probe['paths'].values():os.unlink(path)
subprocess.check_call(['sync'])
assert all(not os.path.lexists(path) for path in probe['paths'].values())
print('YI_TRACE_RESULT '+json.dumps({'owned_files_removed':True}))
""".replace('\n+','\n')
    return header+body


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('stage','collect','cleanup','disarm'))
    parser.add_argument('--host',default='192.168.42.1')
    parser.add_argument('--output',required=True,type=Path)
    parser.add_argument('--receipt',type=Path)
    parser.add_argument('--collection',type=Path)
    args=parser.parse_args()
    if args.action=='stage':probe=make_spec(uuid.uuid4().hex[:12])
    else:
        assert args.receipt is not None,'Staging receipt required'
        receipt=json.loads(args.receipt.read_text())
        assert receipt['host']==args.host and receipt['action']=='stage'
        assert receipt['result']['created_exclusively'] is True
        probe=receipt['probe']
        rebuilt=make_spec(probe['identifier'])
        # JSON object keys are strings after storage.
        assert probe==json.loads(json.dumps(rebuilt)), 'Probe source changed since staging'
    expected=None
    if args.action=='cleanup':
        assert args.collection is not None,'Verified collection required'
        collection=json.loads(args.collection.read_text())
        assert collection['host']==args.host and collection['probe']==probe
        assert collection['verification']['passed'] is True
        expected={key:row['sha256'] for key,row in collection['files'].items()}
    args.output.mkdir(parents=True,exist_ok=False)
    session=dict(action=args.action,host=args.host,probe=probe,api_events=[],
                 started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                 memory_mapping_run=False,firmware_patched=False,fields_modified=[14,15,20,22])
    camera=None
    try:
        session['status_before']=preflight(args.host,session['api_events'])
        target=program(args.action,probe,expected)
        (args.output/'target-operation.py').write_text(target)
        if args.action=='stage':
            (args.output/'autoexec.ash').write_bytes(base64.b64decode(probe['payloads']['script']))
            (args.output/'worker.py').write_bytes(base64.b64decode(probe['payloads']['worker']))
        camera=Telnet(args.host);camera.login()
        raw=run_python(camera,target,args.output,timeout=25)
        (args.output/'telnet-output.txt').write_text(raw)
        files={}
        results=[]
        for line in raw.splitlines():
            if line.startswith('YI_TRACE_FILE '):
                row=json.loads(line.split(' ',1)[1]);key=row['key']
                assert key in probe['paths'] and key not in files
                data=base64.b64decode(row.pop('base64'),validate=True)
                assert len(data)==row['bytes'] and digest(data)==row['sha256']
                (args.output/(key+'.dat')).write_bytes(data)
                files[key]=row
            elif line.startswith('YI_TRACE_RESULT '):results.append(json.loads(line.split(' ',1)[1]))
        assert len(results)==1,'Operation not confirmed; inspect retained output'
        session['result']=results[0]
        if args.action=='collect':
            import struct
            session['files']=files
            assert set(files)==set(probe['paths'])
            assert (args.output/'fingerprint.dat').read_bytes().hex()==EXPECTED_CODE
            tables={key:list(struct.unpack('<37H',(args.output/(key+'.dat')).read_bytes())) for key in ('before','active','after')}
            assert tables['before']==tables['after'],'Diagnostic table did not restore'
            wanted=list(tables['before'])
            for i,value in FIELDS.items():
                assert tables['before'][i]==0,'Unexpected diagnostic baseline'
                wanted[i]=value
            assert wanted==tables['active'],'Native debug command effect not confirmed'
            worker=json.loads((args.output/'record.dat').read_text())
            assert worker.get('start_ack') and worker.get('stop_ack') and not worker.get('error'),worker.get('error')
            session['verification']={'passed':True,'tables':tables,'worker':worker}
            (args.output/'recording.json').write_text(json.dumps(worker,indent=2)+'\n')
        print(json.dumps({'action':args.action,'result':session['result'],'verified':session.get('verification',{}).get('passed')}))
    except BaseException as error:
        session['error']=repr(error)
        raise
    finally:
        if camera is not None:camera.close()
        (args.output/'session.json').write_text(json.dumps(session,indent=2)+'\n')


if __name__=='__main__':main()
