TRACE_STEM = 'yi4k_trace_f1f114115096'
"""Camera Python 2.7/3 worker for a single bounded stock API recording.

TRACE_STEM is supplied by the staging tool. The RTOS script owns diagnostic
flag enable/disable; this worker accesses no device memory or image controls.
"""
import datetime
import json
import os
import signal
import socket
import time

SETTINGS = ('sw_version', 'hw_version', 'system_mode', 'sd_card_status',
            'video_resolution', 'video_standard', 'iq_eis_enable', 'video_quality')
RESULT = '/tmp/SD0/' + TRACE_STEM + '_record.json'
ATTEMPT = '/tmp/SD0/' + TRACE_STEM + '_attempt'
events = []
result = {'events': events, 'requested_record_seconds': 2, 'memory_access': False,
          'started_uptime': open('/proc/uptime').read().split()[0]}


class API(object):
    def __init__(self):
        self.sock = socket.create_connection(('127.0.0.1', 7878), 2)
        self.sock.settimeout(0.25)
        self.buffer = ''
        self.decoder = json.JSONDecoder()
        self.token = 0

    def event(self, direction, message):
        safe = dict(message)
        safe.pop('token', None)
        if safe.get('msg_id') == 257:
            safe.pop('param', None)
        if safe.get('msg_id') == 3 and isinstance(safe.get('param'), list):
            safe['param'] = {k:v for row in safe['param'] for k,v in row.items() if k in SETTINGS}
        events.append({'direction':direction,'uptime':open('/proc/uptime').read().split()[0],
                       'message':safe})

    def call(self, msg_id, timeout=1.5, **args):
        message = dict(msg_id=msg_id, token=self.token, **args)
        self.event('send', message)
        self.sock.sendall(json.dumps(message).encode('utf-8'))
        deadline = time.time()+timeout
        while time.time()<deadline:
            self.buffer = self.buffer.lstrip()
            if self.buffer:
                try:
                    row,end = self.decoder.raw_decode(self.buffer)
                except ValueError:
                    pass
                else:
                    self.buffer = self.buffer[end:]
                    self.event('receive',row)
                    if row.get('msg_id')==msg_id and 'rval' in row:
                        return row
                    continue
            try:
                data=self.sock.recv(65536)
            except socket.timeout:
                continue
            if not data:
                raise RuntimeError('Camera API disconnected')
            self.buffer += data.decode('utf-8')
        raise RuntimeError('Camera API response deadline: '+str(msg_id))


def deadline(signum, frame):
    raise RuntimeError('Recording worker deadline')


fd=os.open(ATTEMPT,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
os.close(fd)
api=None
may_record=False
try:
    signal.signal(signal.SIGALRM,deadline)
    signal.alarm(12)
    api=API()
    reply=api.call(257)
    assert reply.get('rval')==0
    api.token=int(reply['param'])
    status=api.call(1,type='app_status')
    assert status.get('rval')==0 and status.get('param') in ('idle','vf'),status
    reply=api.call(3)
    assert reply.get('rval')==0
    settings={k:v for row in reply['param'] for k,v in row.items() if k in SETTINGS}
    result['settings']=settings
    assert settings['sw_version'].startswith('Z16V13L_1.10.7_')
    assert settings['system_mode']=='record' and settings['sd_card_status']=='insert'
    assert settings['iq_eis_enable']=='on'
    power=api.call(13)
    assert power.get('rval')==0 and power.get('type') in ('battery','adapter') and int(power['param'])>=20
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
                result['close']=api.call(258,timeout=1)
        except Exception as error:
            result['close_error']=repr(error)
        api.sock.close()
    result['finished_uptime']=open('/proc/uptime').read().split()[0]
    with open(RESULT,'w') as file:
        json.dump(result,file,indent=2)
    print('YI_TRACE_WORKER_FINISHED')
