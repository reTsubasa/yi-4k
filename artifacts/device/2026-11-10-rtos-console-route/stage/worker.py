import os,sys,stat,json,hashlib,time
paths={'fingerprint': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_fingerprint.bin', 'pool1': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_pool1.bin', 'pool2': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_pool2.bin', 'va1': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_va1.bin', 'va2': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_va2.bin', 'mem': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_mem.txt', 'tsk1': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_tsk1.txt', 'tsk2': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_tsk2.txt', 'claim': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_claim.json', 'done': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_done.json', 'autoexec': '/tmp/SD0/autoexec.ash', 'worker': '/tmp/SD0/yi4k_diag_0fc5406a4c7f.py', 'ready': '/tmp/SD0/yi4k_diag_0fc5406a4c7f_ready'}
expected='2c1dd31aa7227db29c9aa8154cf170ec0ac4125df1e18781010cc37e70197f76'
def digest(p): return hashlib.sha256(open(p,'rb').read()).hexdigest()
def write_json(p, value):
 fd=os.open(p,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
 with os.fdopen(fd,'wb') as f:
  f.write(json.dumps(value)); f.flush(); os.fsync(f.fileno())
 os.system('sync')
phase=sys.argv[1]
if phase=='claim':
 assert not os.path.lexists(paths['claim'])
 assert not os.path.lexists(paths['ready'])
 assert digest(paths['fingerprint'])=='5e64b91b57eaf124341a5f84484d853cfe5e97bae40e8d7c8bf60c7ed4c6969d', 'Firmware fingerprint mismatch'
 assert stat.S_ISREG(os.lstat(paths['autoexec']).st_mode)
 assert digest(paths['autoexec'])==expected
 write_json(paths['claim'],{'phase':phase,'boot_id':open('/proc/sys/kernel/random/boot_id').read().strip(),'uptime':open('/proc/uptime').read().strip(),'wall_time':time.time()})
 os.unlink(paths['autoexec']); os.system('sync')
 os.mkdir(paths['ready']); os.system('sync')
elif phase=='done':
 assert os.path.isdir(paths['ready']) and os.path.isfile(paths['claim'])
 write_json(paths['done'],{'phase':phase,'uptime':open('/proc/uptime').read().strip(),'wall_time':time.time()})
else: raise ValueError('Unexpected phase')
