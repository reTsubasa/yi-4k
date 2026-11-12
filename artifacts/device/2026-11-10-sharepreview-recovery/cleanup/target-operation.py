expected={'begin': {'exists': False, 'path': '/tmp/yi4k_sharepv_bf1a02b30203_begin'}, 'disable_after': {'exists': False, 'path': '/tmp/yi4k_sharepv_bf1a02b30203_disable_after'}, 'done': {'exists': False, 'path': '/tmp/yi4k_sharepv_bf1a02b30203_done'}, 'enable_after': {'exists': False, 'path': '/tmp/yi4k_sharepv_bf1a02b30203_enable_after'}, 'init_after': {'exists': False, 'path': '/tmp/yi4k_sharepv_bf1a02b30203_init_after'}, 'marker': {'exists': False, 'path': '/tmp/SD0/autoexec.ash'}, 'rpc_result': {'exists': False, 'path': '/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc_result.json'}, 'rpc_script': {'bytes': 1304, 'exists': True, 'path': '/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc.py', 'sha256': 'babc8811ea985563707209748645029f74001c449c13336e56ca1e06fe6114a9'}}
import os,stat,hashlib,json,subprocess
for key,row in expected.items():
 path=row['path']
 if not row['exists']:
  assert not os.path.lexists(path),('unexpected new file',path);continue
 st=os.lstat(path)
 assert stat.S_ISREG(st.st_mode) and st.st_size==row['bytes'],path
 assert hashlib.sha256(open(path,'rb').read()).hexdigest()==row['sha256'],path
removed=[]
for key in ('marker','rpc_script','rpc_result','begin','init_after','enable_after','disable_after','done'):
 row=expected[key]
 if row['exists']:
  os.unlink(row['path']);removed.append(row['path'])
subprocess.check_call(['sync'])
assert all(not os.path.lexists(row['path']) for row in expected.values())
print('YI_RECOVERY_CLEAN '+json.dumps({'removed':removed,'all_eight_paths_absent':True}))
