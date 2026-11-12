import os,sys,stat,json,hashlib,time
paths={'fingerprint': '/tmp/SD0/yi4k_diag_e30da2b76aa5_fingerprint.bin', 'pool1': '/tmp/SD0/yi4k_diag_e30da2b76aa5_pool1.bin', 'pool2': '/tmp/SD0/yi4k_diag_e30da2b76aa5_pool2.bin', 'va1': '/tmp/SD0/yi4k_diag_e30da2b76aa5_va1.bin', 'va2': '/tmp/SD0/yi4k_diag_e30da2b76aa5_va2.bin', 'mem': '/tmp/SD0/yi4k_diag_e30da2b76aa5_mem.txt', 'tsk1': '/tmp/SD0/yi4k_diag_e30da2b76aa5_tsk1.txt', 'tsk2': '/tmp/SD0/yi4k_diag_e30da2b76aa5_tsk2.txt', 'claim': '/tmp/SD0/yi4k_diag_e30da2b76aa5_claim.json', 'done': '/tmp/SD0/yi4k_diag_e30da2b76aa5_done.json', 'autoexec': '/tmp/SD0/autoexec.ash', 'worker': '/tmp/SD0/yi4k_diag_e30da2b76aa5.py', 'ready': '/tmp/SD0/yi4k_diag_e30da2b76aa5_ready'}
expected='0adebc0534c30ce1f19e2774bc9e063f9e5e97e3fbab8532f40eaba45401b1dc'
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
 assert digest(paths['fingerprint'])=='5e64b91b57eaf124341a5f84484d853cfe5e97bae40e8d7c8bf60c7ed4c6969d', 'Firmware fingerprint mismatch'
 assert stat.S_ISREG(os.lstat(paths['autoexec']).st_mode)
 assert digest(paths['autoexec'])==expected
 write_json(paths['claim'],{'phase':phase,'boot_id':open('/proc/sys/kernel/random/boot_id').read().strip(),'uptime':open('/proc/uptime').read().strip(),'wall_time':time.time()})
 os.mkdir(paths['ready']); os.system('sync')
elif phase=='done':
 assert os.path.isdir(paths['ready']) and os.path.isfile(paths['claim'])
 write_json(paths['done'],{'phase':phase,'uptime':open('/proc/uptime').read().strip(),'wall_time':time.time()})
else: raise ValueError('Unexpected phase')
