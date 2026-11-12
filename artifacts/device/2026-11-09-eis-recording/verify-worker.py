"""Host integration checks for baseline/API gating; simulated API, no camera."""
import builtins
import io
import json
from pathlib import Path
import socket
import struct
import sys
import tempfile
import threading

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
SOURCE=(ROOT/'sdk/device-probe/native-eis-recording/worker.py').read_text()
real_connect=socket.create_connection
observed=[]
listener=socket.socket()
listener.bind(('127.0.0.1',0));listener.listen(4);listener.settimeout(10)
port=listener.getsockname()[1]
server_errors=[]


def serve():
    try:
        for _ in range(2):
            conn,_=listener.accept()
            with conn:
                buffer=''
                while True:
                    chunk=conn.recv(8192)
                    if not chunk:break
                    buffer+=chunk.decode()
                    request=json.loads(buffer);buffer=''
                    mid=request['msg_id'];observed.append(mid)
                    response=dict(msg_id=mid,rval=0)
                    if mid==257:response['param']=1
                    elif mid==1:response['param']='vf'
                    elif mid==13:response.update(type='battery',param='100')
                    elif mid==3:
                        response['param']=[dict(sw_version='Z16V13L_1.10.7_test',system_mode='record',
                                               sd_card_status='insert',iq_eis_enable='on')]
                    conn.sendall(json.dumps(response).encode())
                    if mid==258:break
    except BaseException as error:server_errors.append(repr(error))


def execute(spec,mode,connect):
    argv=sys.argv
    try:
        sys.argv=['worker.py',mode]
        socket.create_connection=connect
        def camera_open(path,*args,**kwargs):
            return io.StringIO('1234.00 123.00') if path=='/proc/uptime' else builtins.open(path,*args,**kwargs)
        exec(compile(SOURCE,'<camera-worker>','exec'),dict(BOOT_SPEC=spec,open=camera_open))
    finally:
        sys.argv=argv;socket.create_connection=real_connect


results={}
with tempfile.TemporaryDirectory(prefix='yi4k-worker-check-') as tmp:
    def prepare(name,bad=False):
        p=Path(tmp)/name;p.mkdir()
        paths={k:str(p/k) for k in ('fingerprint','before','active','gate','record','attempt')}
        Path(paths['fingerprint']).write_bytes(bytes.fromhex('0300a0e11eff2fe1'))
        table=[0]*37;table[35]=1
        if bad:table[14]=3
        Path(paths['before']).write_bytes(struct.pack('<37H',*table))
        table[14]=table[15]=table[20]=1;table[22]=50
        Path(paths['active']).write_bytes(struct.pack('<37H',*table))
        return dict(paths=paths,ready_dir=str(p/'ready'))
    def refused(*args,**kwargs):raise ConnectionRefusedError('Simulated unready camera API')
    s=prepare('not-ready');execute(s,'prepare',refused)
    assert not Path(s['ready_dir']).exists()
    assert not Path(s['paths']['attempt']).exists()
    results['api_unready_does_not_arm']=True
    s=prepare('bad-baseline',bad=True);execute(s,'prepare',refused)
    gate=json.loads(Path(s['paths']['gate']).read_text())
    assert 'Unexpected diagnostic baseline' in gate['error'] and not Path(s['ready_dir']).exists()
    results['nonzero_baseline_does_not_arm']=True
    s=prepare('happy')
    thread=threading.Thread(target=serve);thread.start()
    def redirect(address,*args,**kwargs):
        assert address==('127.0.0.1',7878)
        return real_connect(('127.0.0.1',port),*args,**kwargs)
    execute(s,'prepare',redirect)
    assert Path(s['ready_dir']).is_dir()
    gate=json.loads(Path(s['paths']['gate']).read_text());assert gate['ready_created']
    execute(s,'record',redirect)
    thread.join(timeout=4);assert not thread.is_alive() and not server_errors,server_errors
    record=json.loads(Path(s['paths']['record']).read_text())
    assert record['start_ack'] and record['stop_ack'] and not record.get('error')
    assert observed==[257,1,3,13,258,257,1,3,13,513,514,1,258],observed
    results['successful_gate_then_one_bounded_recording']=True
    try:execute(s,'record',redirect)
    except FileExistsError:pass
    else:raise AssertionError('Duplicate worker execution allowed')
    results['duplicate_record_output_prevents_second_run']=True
listener.close()
result=dict(passed=True,scope='Host simulated stock TCP API; not camera or native Shell validation',
            checks=results,observed_api_ids=observed)
(HERE/'worker-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
