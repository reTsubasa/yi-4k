#!/usr/bin/env python3
"""Query only SharePreview GetStatus and GetMemInfo via the existing RPC stack.

No Enable/Init, /dev/mem mapping, frame copy, or target file writes. Creating
and destroying the client does allocate transient transport resources. ABI was
checked against this device's client/library and its SYS_SW service handlers.
"""
import argparse
import datetime
import json
from pathlib import Path

from device_linux_capture import Telnet

TARGET_SCRIPT = r'''
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
'''.strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    command = "python -B -u <<'YI_RPC_PY'\n" + TARGET_SCRIPT + '\nYI_RPC_PY'
    (args.output / 'target-probe.py').write_text(TARGET_SCRIPT + '\n')
    session = dict(host=args.host, started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   command=command, scope='RPC proc 3 and 1 only; no preview state change requested')
    client = Telnet(args.host)
    try:
        client.login()
        output = client.command(command, timeout=20)
        (args.output / 'telnet-output.txt').write_text(output)
        print(output)
        for line in output.splitlines():
            if line.startswith('YI_SHAREPREVIEW_RESULT '):
                session['result'] = json.loads(line.split(' ', 1)[1])
            if line.startswith('YI_SHAREPREVIEW_DESTROY '):
                session['destroy_rc'] = int(line.split(' ', 1)[1])
        if 'result' not in session:
            raise RuntimeError('No structured RPC result; inspect retained Telnet output')
    finally:
        client.close()
        (args.output / 'session.json').write_text(json.dumps(session, indent=2) + '\n')


if __name__ == '__main__':
    main()
