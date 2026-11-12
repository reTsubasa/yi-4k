import ctypes as C
import hashlib, json, signal
signal.alarm(12)
assert C.sizeof(C.c_void_p) == 4
libpath = '/usr/lib/libambaipc.so'
expected = '8764243695f59a5d5f6974cdea67998d125a220679bdce4acd59367813f80ae6'
assert hashlib.sha256(open(libpath, 'rb').read()).hexdigest() == expected
lib = C.CDLL(libpath)
lib.ambaipc_clnt_create.argtypes = [C.c_uint32, C.c_uint32, C.c_uint32]
lib.ambaipc_clnt_create.restype = C.c_void_p
lib.ambaipc_clnt_call.argtypes = [C.c_void_p, C.c_uint32, C.c_void_p,
                                C.c_uint32, C.c_void_p, C.c_uint32, C.c_uint32]
lib.ambaipc_clnt_call.restype = C.c_int
lib.ambaipc_clnt_destroy.argtypes = [C.c_void_p]
lib.ambaipc_clnt_destroy.restype = C.c_int
client = lib.ambaipc_clnt_create(1, 0x1000000c, 1)
if not client:
    raise RuntimeError('SharePreview RPC client creation failed')
try:
    status = C.c_uint32(0xdeadbeef)
    rc = lib.ambaipc_clnt_call(client, 3, None, 0, C.byref(status), 4, 1000)
    result = {'program': '0x1000000c', 'version': 1,
              'get_status_rc': rc, 'status': status.value}
    if rc == 0:
        info = (C.c_uint32 * 6)(*[0xdeadbeef] * 6)
        rc2 = lib.ambaipc_clnt_call(client, 1, None, 0, C.byref(info), 24, 1000)
        result['get_meminfo_rc'] = rc2
        result['meminfo_u32'] = list(info)
    print('YI_SHAREPREVIEW_RESULT ' + json.dumps(result, sort_keys=True))
finally:
    print('YI_SHAREPREVIEW_DESTROY ' + str(lib.ambaipc_clnt_destroy(client)))
    signal.alarm(0)
