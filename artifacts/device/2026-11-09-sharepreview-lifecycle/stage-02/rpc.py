import ctypes as C, json, os, sys, hashlib, signal
signal.alarm(8)
phase=sys.argv[1]
libpath='/usr/lib/libambaipc.so'
lib=C.CDLL(libpath)
lib.ambaipc_clnt_create.argtypes=[C.c_uint32,C.c_uint32,C.c_uint32]; lib.ambaipc_clnt_create.restype=C.c_void_p
lib.ambaipc_clnt_call.argtypes=[C.c_void_p,C.c_uint32,C.c_void_p,C.c_uint32,C.c_void_p,C.c_uint32,C.c_uint32]; lib.ambaipc_clnt_call.restype=C.c_int
lib.ambaipc_clnt_destroy.argtypes=[C.c_void_p]; lib.ambaipc_clnt_destroy.restype=C.c_int
c=lib.ambaipc_clnt_create(1,0x1000000c,1)
r={'phase':phase,'library_sha256':hashlib.sha256(open(libpath,'rb').read()).hexdigest()}
if not c:
 r['client']='null'
else:
 s=C.c_uint32(0xdeadbeef); r['status_rc']=lib.ambaipc_clnt_call(c,3,None,0,C.byref(s),4,1000); r['status']=s.value
 if r['status_rc']==0:
  info=(C.c_uint32*6)(*[0xdeadbeef]*6); r['meminfo_rc']=lib.ambaipc_clnt_call(c,1,None,0,C.byref(info),24,1000); r['meminfo_u32']=list(info)
 r['destroy_rc']=lib.ambaipc_clnt_destroy(c)
try:
 old=json.load(open('/tmp/SD0/yi4k_sharepv_d68941edd253_rpc_result.json'))
except:
 old=[]
old.append(r)
fd=os.open('/tmp/SD0/yi4k_sharepv_d68941edd253_rpc_result.json',os.O_WRONLY|os.O_CREAT|os.O_TRUNC,0600)
os.write(fd,json.dumps(old,sort_keys=True))
os.close(fd)
print('YI_SHAREPV_RPC '+json.dumps(r,sort_keys=True))
