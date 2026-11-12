"""Bounded API gate/record worker; BOOT_SPEC is prepended by the host tool.

Reads files exported by RTOS; never reads device memory or writes image settings.
The native script alone changes/restores diagnostic fields.
"""
import json
import os
import signal
import socket
import struct
import sys
import time

SETTINGS = ('sw_version', 'hw_version', 'system_mode', 'sd_card_status',
            'video_resolution', 'video_standard', 'iq_eis_enable', 'video_quality')
events = []


class API(object):
    def __init__(self):
        self.sock = socket.create_connection(('127.0.0.1', 7878), 1)
        self.sock.settimeout(0.15)
        self.buffer = ''
        self.decoder = json.JSONDecoder()
        self.token = 0

    def call(self, msg_id, timeout=1.25, **args):
        message = dict(msg_id=msg_id, token=self.token, **args)
        self.event('send', message)
        self.sock.sendall(json.dumps(message).encode('utf-8'))
        end = time.time()+timeout
        while time.time()<end:
            self.buffer = self.buffer.lstrip()
            if self.buffer:
                try:
                    row, pos = self.decoder.raw_decode(self.buffer)
                except ValueError:
                    pass
                else:
                    self.buffer = self.buffer[pos:]
                    self.event('receive', row)
                    if row.get('msg_id')==msg_id and 'rval' in row:
                        return row
                    continue
            try:
                data = self.sock.recv(65536)
            except socket.timeout:
                continue
            if not data:
                raise RuntimeError('API disconnected')
            self.buffer += data.decode('utf-8')
        raise RuntimeError('API response deadline: '+str(msg_id))

    def event(self, direction, message):
        safe = dict(message)
        safe.pop('token', None)
        if safe.get('msg_id')==257:
            safe.pop('param', None)
        if safe.get('msg_id')==3 and isinstance(safe.get('param'), list):
            safe['param']={k:v for row in safe['param'] for k,v in row.items() if k in SETTINGS}
        events.append(dict(direction=direction, uptime=uptime(), message=safe))


def uptime():
    return open('/proc/uptime').read().split()[0]


def table(key):
    with open(BOOT_SPEC['paths'][key], 'rb') as file:
        return list(struct.unpack('<37H', file.read()))


def deadline(signum, frame):
    raise RuntimeError('Worker deadline')


mode=sys.argv[1]
assert mode in ('prepare', 'record')
result=dict(mode=mode, started_uptime=uptime(), events=events,
            memory_access=False, requested_record_seconds=2 if mode=='record' else 0)
output=BOOT_SPEC['paths']['gate' if mode=='prepare' else 'record']
api=None
may_record=False
fd=os.open(output,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
try:
    signal.signal(signal.SIGALRM,deadline)
    signal.alarm(4 if mode=='prepare' else 10)
    with open(BOOT_SPEC['paths']['fingerprint'],'rb') as file:
        assert file.read()==b'\x03\x00\xa0\xe1\x1e\xff\x2f\xe1'
    baseline=table('before')
    for i in (14,15,20,22):
        assert baseline[i]==0,'Unexpected diagnostic baseline'
    result['baseline_checked_before_enable']=True
    if mode=='record':
        assert os.path.isdir(BOOT_SPEC['ready_dir'])
        expected=list(baseline)
        for i,v in ((14,1),(15,1),(20,1),(22,50)):
            expected[i]=v
        assert table('active')==expected,'Native diagnostic activation mismatch'
    api=API()
    reply=api.call(257)
    assert reply.get('rval')==0
    api.token=int(reply['param'])
    status=api.call(1,type='app_status')
    assert status.get('rval')==0 and status.get('param') in ('idle','vf'),status
    settings_reply=api.call(3)
    assert settings_reply.get('rval')==0
    settings={k:v for row in settings_reply['param'] for k,v in row.items() if k in SETTINGS}
    result['settings']=settings
    assert settings['sw_version'].startswith('Z16V13L_1.10.7_')
    assert settings['system_mode']=='record' and settings['sd_card_status']=='insert'
    assert settings['iq_eis_enable']=='on'
    power=api.call(13)
    assert power.get('rval')==0 and power.get('type') in ('battery','adapter') and int(power['param'])>=20
    result['preflight_passed']=True
    if mode=='record':
        attempt=os.open(BOOT_SPEC['paths']['attempt'],os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
        os.close(attempt)
        may_record=True
        reply=api.call(513,timeout=2)
        assert reply.get('rval')==0,reply
        result['start_ack']=True
        time.sleep(2)
        reply=api.call(514,timeout=2)
        assert reply.get('rval')==0,reply
        may_record=False
        result['stop_ack']=True
        result['status_after']=api.call(1,type='app_status')
except BaseException as error:
    result['error']=repr(error)
finally:
    signal.alarm(0)
    if api is not None:
        if may_record:
            try:
                result['cleanup_stop']=api.call(514,timeout=2)
            except Exception as error:
                result['cleanup_stop_error']=repr(error)
        try:
            if api.token:
                result['close']=api.call(258,timeout=0.5)
        except Exception as error:
            result['close_error']=repr(error)
        api.sock.close()
    # Create the directory only after successful preflight AND session close.
    if mode=='prepare' and result.get('preflight_passed') and not result.get('error') and not result.get('close_error'):
        try:
            assert result['close'].get('rval')==0
            os.mkdir(BOOT_SPEC['ready_dir'],0o700)
            result['ready_created']=True
        except BaseException as error:
            result['error']=repr(error)
    result['finished_uptime']=uptime()
    with os.fdopen(fd,'w') as file:
        json.dump(result,file,indent=2)
        file.flush()
        os.fsync(file.fileno())
    print('YI_BOOT_WORKER_FINISHED '+mode)
