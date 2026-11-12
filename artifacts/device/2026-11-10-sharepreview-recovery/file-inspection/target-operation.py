paths={'marker': '/tmp/SD0/autoexec.ash', 'rpc_script': '/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc.py', 'rpc_result': '/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc_result.json', 'begin': '/tmp/yi4k_sharepv_bf1a02b30203_begin', 'init_after': '/tmp/yi4k_sharepv_bf1a02b30203_init_after', 'enable_after': '/tmp/yi4k_sharepv_bf1a02b30203_enable_after', 'disable_after': '/tmp/yi4k_sharepv_bf1a02b30203_disable_after', 'done': '/tmp/yi4k_sharepv_bf1a02b30203_done'}
import os,stat,json,hashlib,base64
out={}
for key,path in sorted(paths.items()):
 if not os.path.lexists(path):
  out[key]={'path':path,'exists':False}; continue
 st=os.lstat(path)
 assert stat.S_ISREG(st.st_mode) and st.st_size<=65536,(key,'unexpected type or size')
 data=open(path,'rb').read()
 out[key]={'path':path,'exists':True,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'base64':base64.b64encode(data)}
print('YI_RECOVERY_FILES '+json.dumps(out,sort_keys=True))
