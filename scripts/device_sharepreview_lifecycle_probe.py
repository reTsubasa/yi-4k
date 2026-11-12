#!/usr/bin/env python3
"""Prepare an init-only SharePreview probe; collect and clean separately.

The target only calls stock RTOS shell handlers. It does not patch code, map
/dev/mem, copy frames, start recording, or write persistent firmware.
Init may fault or block RTOS; Linux timeouts do not provide an RTOS watchdog.
The generated experiment has NOT been validated on the device.
"""
import argparse, base64, datetime, hashlib, json, pathlib, re, uuid
from device_eis_live_capture import CameraAPI
from device_linux_capture import Telnet
from device_python_transport import run_python

MARKER='/tmp/SD0/autoexec.ash'

def spec(identifier):
    if not re.fullmatch(r'[0-9a-f]{12}', identifier): raise ValueError('bad identifier')
    stem='yi4k_sharepv_'+identifier
    sd='/tmp/SD0/'+stem
    base=sd
    return {
      'identifier':identifier, 'stem':stem, 'marker':MARKER, 'mode':'init-only',
      'begin':base+'_begin','init_after':base+'_init_after','enable_after':base+'_enable_after',
      'disable_after':base+'_disable_after','done':base+'_done',
      'rpc_script':sd+'_rpc.py','rpc_result':sd+'_rpc_result.json',
      'autoexec': '\n'.join([
        "t ipc rpc clnt exec1 'python %s begin'" % (sd+'_rpc.py'),
        't app test sharepv init',
        "t ipc rpc clnt exec1 'python %s init'" % (sd+'_rpc.py'),
        "t ipc rpc clnt exec1 'python %s done'" % (sd+'_rpc.py'),
        ''
      ]),
    }

def rpc_script(probe):
    # Python 2.7-compatible target script. It uses only GetStatus/GetMemInfo.
    result=probe['rpc_result']
    return '''import ctypes as C, json, os, sys, hashlib, signal
phase=sys.argv[1]
markers=%r
assert phase in markers
fd=os.open(markers[phase],os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
os.fsync(fd)
os.close(fd)
os.system('sync')
if phase in ('begin','done'): sys.exit(0)
signal.alarm(8)
libpath='/usr/lib/libambaipc.so'
assert C.sizeof(C.c_void_p)==4
assert hashlib.sha256(open(libpath,'rb').read()).hexdigest()=='8764243695f59a5d5f6974cdea67998d125a220679bdce4acd59367813f80ae6'
lib=C.CDLL(libpath)
lib.ambaipc_clnt_create.argtypes=[C.c_uint32,C.c_uint32,C.c_uint32]; lib.ambaipc_clnt_create.restype=C.c_void_p
lib.ambaipc_clnt_call.argtypes=[C.c_void_p,C.c_uint32,C.c_void_p,C.c_uint32,C.c_void_p,C.c_uint32,C.c_uint32]; lib.ambaipc_clnt_call.restype=C.c_int
lib.ambaipc_clnt_destroy.argtypes=[C.c_void_p]; lib.ambaipc_clnt_destroy.restype=C.c_int
c=lib.ambaipc_clnt_create(1,0x1000000c,1)
r={'phase':phase,'library_sha256':hashlib.sha256(open(libpath,'rb').read()).hexdigest()}
if not c:
 r['client']='null'
else:
 s=C.c_uint32(0xdeadbeef); r['status_rc']=lib.ambaipc_clnt_call(c,3,None,0,C.byref(s),4,1000); r['status_raw']=s.value
 if r['status_rc']==0: r['status']=s.value
 if r['status_rc']==0:
  info=(C.c_uint32*6)(*[0xdeadbeef]*6); r['meminfo_rc']=lib.ambaipc_clnt_call(c,1,None,0,C.byref(info),24,1000); r['meminfo_u32']=list(info)
 r['destroy_rc']=lib.ambaipc_clnt_destroy(c)
try:
 old=json.load(open(%r))
except:
 old=[]
old.append(r)
with open(%r,'wb') as f:
 f.write(json.dumps(old,sort_keys=True).encode('ascii'))
 f.flush()
 os.fsync(f.fileno())
os.system('sync')
print('YI_SHAREPV_RPC '+json.dumps(r,sort_keys=True))
''' % ({'begin':probe['begin'],'init':probe['init_after'],'done':probe['done']},result,result)

def preflight(host, events):
    api=CameraAPI(host,events)
    try:
        api.open_session(); s=api.call(1,type='app_status'); assert s.get('rval')==0 and s.get('param') in ('idle','vf'),s
        settings=api.call(3); assert settings.get('rval')==0,settings
        version=next(x['sw_version'] for x in settings['param'] if 'sw_version' in x); assert version.startswith('Z16V13L_1.10.7_'),version
        return s
    finally: api.close()

def target_program(action,probe,collected=None):
    """Build a Python 2.7 target program with bounded source lines.

    The camera's telnet/PTY path truncates very long input lines.  The first
    version embedded the complete probe dictionary in one repr() line, which
    made the target see an unterminated string.  Keep the target assignment
    base64 encoded and split into 80-byte literals, as the other device
    probes do.
    """
    target_probe=dict(probe)
    if collected is not None: target_probe['collected_files']=collected
    target_probe['payloads']={
        'autoexec':base64.b64encode(probe['autoexec'].encode()).decode(),
        'rpc_source':base64.b64encode(probe['rpc_source'].encode()).decode(),
    }
    target_probe.pop('autoexec',None)
    target_probe.pop('rpc_source',None)
    encoded=base64.b64encode(json.dumps(target_probe,sort_keys=True).encode()).decode()
    # Keep indentation plus quotes below the camera shell's ~128-byte input
    # line limit (the PTY echoes/wraps long lines before Python sees them).
    chunks='\n'.join('    '+repr(encoded[i:i+80]) for i in range(0,len(encoded),80))
    header=('import os,stat,hashlib,json,subprocess,base64\n'
            'probe=json.loads(base64.b64decode((\n'+chunks+'\n)))\n')
    if action=='stage':
      body='''names=(probe['marker'],probe['rpc_script'],probe['rpc_result'],
 probe['begin'],probe['init_after'],probe['enable_after'],
 probe['disable_after'],probe['done'])
for n in names:
 assert not os.path.lexists(n),'refuse existing '+n
for key,path in [('rpc_source',probe['rpc_script']),('autoexec',probe['marker'])]:
 data=base64.b64decode(probe['payloads'][key])
 fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
 with os.fdopen(fd,'wb') as f:
  f.write(data)
  f.flush()
  os.fsync(f.fileno())
 expected=probe['autoexec_sha256'] if key=='autoexec' else probe['rpc_script_sha256']
 assert hashlib.sha256(open(path,'rb').read()).hexdigest()==expected
 subprocess.check_call(['sync'])
print('YI_SHAREPV_STAGE '+json.dumps({'created_exclusively':True}))
'''
    elif action=='collect':
      body='''out={}
names=(probe['marker'],probe['rpc_script'],probe['rpc_result'],
 probe['begin'],probe['init_after'],probe['enable_after'],
 probe['disable_after'],probe['done'])
for n in names:
 if not os.path.lexists(n):
  out[n]={'exists':False}
  continue
 st=os.lstat(n)
 assert stat.S_ISREG(st.st_mode) and st.st_size<=65536,n
 data=open(n,'rb').read()
 assert len(data)<=65536,n
 out[n]={'exists':True,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),
         'base64':base64.b64encode(data).decode('ascii')}
print('YI_SHAREPV_COLLECT '+json.dumps({'files':out,'owned_files_removed':False},sort_keys=True))
'''
    elif action=='cleanup':
      body='''names=(probe['marker'],probe['rpc_script'],probe['rpc_result'],
 probe['begin'],probe['init_after'],probe['enable_after'],
 probe['disable_after'],probe['done'])
saved=probe['collected_files']
assert set(saved)==set(names)
owned=[]
# Validate every file before deleting any. Refuse changes since collection.
for n in names:
 info=saved[n]
 assert os.path.lexists(n)==info['exists'],n
 if not info['exists']:continue
 st=os.lstat(n)
 assert stat.S_ISREG(st.st_mode) and st.st_size==info['bytes'],n
 assert hashlib.sha256(open(n,'rb').read()).hexdigest()==info['sha256'],n
 if n in (probe['marker'],probe['rpc_script']):
  key='autoexec_sha256' if n==probe['marker'] else 'rpc_script_sha256'
  assert info['sha256']==probe[key],n
 elif n!=probe['rpc_result']:assert info['bytes']==0,n
 owned.append(n)
for n in owned:os.unlink(n)
subprocess.check_call(['sync'])
assert all(not os.path.lexists(n) for n in names)
print('YI_SHAREPV_CLEAN '+json.dumps({'owned_files_removed':True,'removed':owned},sort_keys=True))
'''
    else:raise ValueError(action)
    return header+body

def main():
 ap=argparse.ArgumentParser(); ap.add_argument('action',choices=['stage','collect','cleanup']); ap.add_argument('--host',default='192.168.42.1'); ap.add_argument('--output',type=pathlib.Path,required=True); ap.add_argument('--receipt',type=pathlib.Path); ap.add_argument('--collected',type=pathlib.Path); a=ap.parse_args()
 collected=None
 if a.action in ('collect','cleanup'):
  if not a.receipt:ap.error('--receipt is required')
  rec=json.loads(a.receipt.read_text()); p=rec['probe']; assert rec['host']==a.host
  if a.action=='cleanup':
   if not a.collected:ap.error('--collected is required for cleanup')
   saved=json.loads(a.collected.read_text())
   assert saved['action']=='collect' and saved['host']==a.host and saved['probe']==p
   collected=saved['result']['files']
   for n,info in collected.items():
    if info['exists']:
     data=base64.b64decode(info['base64'])
     assert len(data)==info['bytes'] and hashlib.sha256(data).hexdigest()==info['sha256'],n
 else:
  p=spec(uuid.uuid4().hex[:12]); p['rpc_source']=rpc_script(p)
 p['autoexec_sha256']=hashlib.sha256(p['autoexec'].encode()).hexdigest()
 p['rpc_script_sha256']=hashlib.sha256(p['rpc_source'].encode()).hexdigest()
 a.output.mkdir(parents=True,exist_ok=False)
 ev=[]; sess={'action':a.action,'host':a.host,'probe':p,'api_events':ev,'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'firmware_patched':False,'memory_mapping_run':False,'recording_requested':False,'reboot_requested':False}
 cam=None
 try:
  if a.action=='stage':
   sess['status_before']=preflight(a.host,ev)
  else:
   # Recovery must remain possible when the camera API is unavailable but
   # Telnet works. Collection/cleanup do not invoke SharePreview or reboot.
   try:sess['status_before']=preflight(a.host,ev)
   except Exception as error:sess['api_preflight_error']=repr(error)
  program=target_program(a.action,p,collected); (a.output/'target-operation.py').write_text(program)
  (a.output/'autoexec.ash').write_text(p['autoexec']); (a.output/'rpc.py').write_text(p['rpc_source'])
  cam=Telnet(a.host); cam.login()
  # Upload with acknowledged Base64 chunks.  Sending the complete heredoc in
  # one PTY write loses bytes on this camera even when individual source lines
  # are short; run_python bounds each transport command and verifies a SHA-256.
  raw=run_python(cam,program,a.output,timeout=30)
  (a.output/'telnet-output.txt').write_text(raw)
  lines=[l for l in raw.splitlines() if l.startswith('YI_SHAREPV_')]
  if a.action=='stage': assert len(lines)==1 and lines[0].startswith('YI_SHAREPV_STAGE '),lines; sess['result']=json.loads(lines[0].split(' ',1)[1])
  else:
   prefix='YI_SHAREPV_COLLECT ' if a.action=='collect' else 'YI_SHAREPV_CLEAN '
   line=[l for l in lines if l.startswith(prefix)]; assert len(line)==1,line; sess['result']=json.loads(line[0].split(' ',1)[1])
  print(json.dumps(sess['result'],ensure_ascii=False))
 except BaseException as error:
  sess['error']=repr(error)
  raise
 finally:
  if cam: cam.close()
  (a.output/'session.json').write_text(json.dumps(sess,ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__': main()
