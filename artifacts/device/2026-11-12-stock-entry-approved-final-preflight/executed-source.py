import os,json,stat
paths={'script': '/tmp/SD0/autoexec.ash', 'claim': '/tmp/SD0/yi4k_entry_5345a5ec7c52_claim.json', 'tasks': '/tmp/SD0/yi4k_entry_5345a5ec7c52_tasks.txt', 'fingerprint': '/tmp/SD0/yi4k_entry_5345a5ec7c52_code.bin'}
r={}
for k,p in paths.items():
 r[k]={'present':os.path.lexists(p)}
 if r[k]['present']: r[k]['mode']=os.lstat(p).st_mode
mounts=open('/proc/mounts').read().splitlines()
sd=[x for x in mounts if len(x.split())>=4 and x.split()[1]=='/tmp/SD0']
assert len(sd)==1 and sd[0].split()[:3]==['c:','/tmp/SD0','ambafs'] and 'rw' in sd[0].split()[3].split(',')
assert not os.path.islink('/tmp/SD0') and os.path.isdir('/tmp/SD0')
assert all(not x['present'] for x in r.values()),'Refuse existing plan namespace'
print('YI_STOCK_PREFLIGHT '+json.dumps({'boot_id':open('/proc/sys/kernel/random/boot_id').read().strip(),'uptime':open('/proc/uptime').read().strip(),'mount':sd[0],'paths':r}))
