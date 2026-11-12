#!/usr/bin/env python3
"""Record one bounded stock-EIS clip and observe RTOS DRAM before/during/after.

Explicit --record-seconds is required. Only starts from API app_status=idle.
Never writes RTOS memory or changes camera settings. Creates one normal video
on the camera's SD card. DRAM observations remain non-atomic/cache-unverified.
Device use is suspended after a confirmed camera hang during the investigation;
see docs/device-live-eis-observation.md section 6.
"""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import socket
import threading
import time
import uuid

from device_linux_capture import Telnet
from device_rtos_snapshot import PARTITION, EXPECTED, ANCHORS

SETTINGS = ('sw_version', 'hw_version', 'system_mode', 'sd_card_status',
            'video_resolution', 'video_standard', 'iq_eis_enable', 'video_quality')
# All are DRAM ranges covered by the image's MMU mapping initializer.
WINDOWS = [(0xA0757A40, 0x110), (0xA1702C30, 0xD0),
           (0xA1702D00, 0xCD8), (0xA170AB10, 0x100),
           (0xA1704050, 0x320), (0xA17045A0, 0x60),
           (0xA170BA80, 0x2B0)]


class CameraAPI:
    def __init__(self, host, events):
        self.sock = socket.create_connection((host, 7878), timeout=5)
        self.sock.settimeout(0.5)
        self.buffer = ''
        self.decoder = json.JSONDecoder()
        self.events = events
        self.token = 0

    def log(self, direction, message):
        safe = dict(message)
        safe.pop('token', None)
        if safe.get('msg_id') == 257:
            safe.pop('param', None)
        if safe.get('msg_id') == 3 and isinstance(safe.get('param'), list):
            safe['param'] = {k: v for item in safe['param'] for k, v in item.items() if k in SETTINGS}
        if 'password' in str(safe.get('type', '')).lower():
            safe['param'] = '[omitted]'
        self.events.append(dict(host_monotonic=time.monotonic(),
                                utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                                direction=direction, message=safe))

    def receive(self, deadline):
        while time.monotonic() < deadline:
            self.buffer = self.buffer.lstrip()
            if self.buffer:
                try:
                    result, end = self.decoder.raw_decode(self.buffer)
                except ValueError:
                    pass
                else:
                    self.buffer = self.buffer[end:]
                    self.log('receive', result)
                    return result
            try:
                chunk = self.sock.recv(65536)
            except socket.timeout:
                continue
            if not chunk:
                raise ConnectionError('Camera API connection closed')
            self.buffer += chunk.decode('utf-8')
        raise TimeoutError('Camera API response timeout')

    def call(self, msg_id, timeout=6, **args):
        request = dict(msg_id=msg_id, token=self.token, **args)
        self.log('send', request)
        self.sock.sendall(json.dumps(request).encode())
        deadline = time.monotonic() + timeout
        while True:
            result = self.receive(deadline)
            if result.get('msg_id') == msg_id and 'rval' in result:
                return result

    def open_session(self):
        result = self.call(257)
        if result.get('rval') != 0:
            raise RuntimeError('API session refused: ' + str(result.get('rval')))
        self.token = int(result['param'])

    def close(self):
        try:
            if self.token:
                self.call(258, timeout=3)
        finally:
            self.sock.close()


def target_program(image, duration, interval, windows=None):
    anchors = [(va, image[va-0xA0100000:va-0xA0100000+n].hex()) for va, n in ANCHORS]
    prefix = 'anchors = ' + repr(anchors) + '\nwindows = ' + repr(WINDOWS if windows is None else windows) + '\n'
    prefix += 'duration = ' + repr(duration) + '\ninterval = ' + repr(interval) + '\n'
    return prefix + '''import os, mmap, binascii, json, signal, time
signal.alarm(int(duration) + 12)
fd = os.open('/dev/mem', os.O_RDONLY)
pages = {}
def read_va(va, count):
    pa = va - 0xa0000000
    start = pa & ~4095
    offset = pa - start
    length = (offset + count + 4095) & ~4095
    key = (start, length)
    if key not in pages:
        pages[key] = mmap.mmap(fd, length, flags=mmap.MAP_SHARED,
                              prot=mmap.PROT_READ, offset=start)
    return pages[key][offset:offset+count]
try:
    for va, expected in anchors:
        assert binascii.hexlify(read_va(va, len(expected)//2)) == expected, 'Code fingerprint mismatch'
    for va, count in windows:
        read_va(va, count)
    start = time.time()
    print('YI_LIVE_READY ' + json.dumps({'start_wall': start, 'duration': duration, 'interval': interval}))
    number = 0
    while time.time() - start < duration:
        before = time.time()
        data = [{'va': hex(va).rstrip('L'), 'hex': binascii.hexlify(read_va(va, count))}
                for va, count in windows]
        after = time.time()
        print('YI_LIVE_SAMPLE ' + json.dumps({'n': number, 't_start': before-start,
              't_end': after-start, 'windows': data}, separators=(',', ':')))
        number += 1
        remaining = start + number*interval - time.time()
        if remaining > 0:
            time.sleep(remaining)
    print('YI_LIVE_DONE ' + json.dumps({'samples': number, 'elapsed': time.time()-start}))
finally:
    for mem in pages.values():
        mem.close()
    os.close(fd)
    signal.alarm(0)
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--record-seconds', type=float, required=True)
    parser.add_argument('--interval', type=float, default=0.05)
    args = parser.parse_args()
    if not 2 <= args.record_seconds <= 15 or not 0.025 <= args.interval <= 0.5:
        parser.error('Record 2..15 seconds; interval 0.025..0.5 seconds')
    image = PARTITION.read_bytes()
    if hashlib.sha256(image).hexdigest() != EXPECTED:
        raise RuntimeError('Captured image SHA mismatch')
    args.output.mkdir(parents=True, exist_ok=False)
    events = []
    session = dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   host=args.host, image_sha256=EXPECTED, record_seconds=args.record_seconds,
                   interval=args.interval, api_events=events,
                   memory_read_only=True, settings_changed=False,
                   limitations=['DRAM reads are not atomic or cache synchronized.',
                                'Host/API timestamps and target sample timestamps are separate clocks.',
                                'Normal recording creates a video on SD; no existing file is removed.'])
    api = None
    telnet = None
    worker = None
    recording_owned = False
    start_unconfirmed = False
    sampler = {}
    try:
        api = CameraAPI(args.host, events)
        api.open_session()
        status = api.call(1, type='app_status')
        if status.get('rval') != 0 or status.get('param') != 'idle':
            raise RuntimeError('Camera is not confirmed idle; no recording started')
        result = api.call(3)
        if result.get('rval') != 0:
            raise RuntimeError('Settings query failed')
        settings = {k: v for item in result['param'] for k, v in item.items() if k in SETTINGS}
        session['settings_before'] = settings
        if not str(settings.get('sw_version', '')).startswith('Z16V13L_1.10.7_'):
            raise RuntimeError('Camera firmware identity changed')
        if settings.get('iq_eis_enable') != 'on' or settings.get('system_mode') != 'record':
            raise RuntimeError('Expected stock EIS on and video mode; settings not changed')
        battery = api.call(13)
        session['battery'] = battery
        if battery.get('rval') != 0 or battery.get('type') != 'battery' or int(battery.get('param', 0)) < 20:
            raise RuntimeError('Battery not confirmed >=20%')
        # Include baseline, both bounded API waits and a post-stop interval.
        duration = args.record_seconds + 23
        target = target_program(image, duration, args.interval)
        (args.output / 'target-probe.py').write_text(target)
        command = "python -B -u <<'YI_LIVE_PY'\n" + target + '\nYI_LIVE_PY'
        marker = '__YI_LIVE_END_' + uuid.uuid4().hex + '__'
        telnet = Telnet(args.host)
        telnet.login()
        telnet.sock.sendall((command + '\necho ' + marker + '\n').encode())
        prefix = telnet.until(rb'\nYI_LIVE_READY [^\r\n]+\r*\n', timeout=12)
        session['sampler_ready_host_monotonic'] = time.monotonic()
        def consume():
            try:
                rest = telnet.until(rb'\n' + marker.encode() + rb'\r*\n', timeout=duration+15)
                sampler['raw'] = prefix + rest
            except Exception as e:
                sampler['error'] = repr(e)
                sampler['raw'] = prefix + bytes(telnet.buffer)
        worker = threading.Thread(target=consume)
        worker.start()
        print('Sampler ready; observing baseline', flush=True)
        time.sleep(2)
        start_unconfirmed = True
        started = api.call(513, timeout=8)
        start_unconfirmed = False
        if started.get('rval') != 0:
            raise RuntimeError('Camera refused start: ' + str(started))
        recording_owned = True
        session['record_start_ack_host_monotonic'] = time.monotonic()
        print('Recording started; observing ' + str(args.record_seconds) + ' seconds', flush=True)
        time.sleep(args.record_seconds)
        stopped = api.call(514, timeout=8)
        if stopped.get('rval') != 0:
            raise RuntimeError('Camera refused stop: ' + str(stopped))
        recording_owned = False
        session['record_stop_ack_host_monotonic'] = time.monotonic()
        print('Recording stopped; observing post-record state', flush=True)
        session['status_after'] = api.call(1, type='app_status')
        worker.join(timeout=duration+15)
        if worker.is_alive() or sampler.get('error'):
            raise RuntimeError('Sampler incomplete: ' + str(sampler.get('error')))
        raw = sampler['raw'].decode('utf-8', 'replace').replace('\r', '')
        (args.output / 'telnet-output.txt').write_text(raw)
        samples = [json.loads(line.split(' ', 1)[1]) for line in raw.splitlines()
                   if line.startswith('YI_LIVE_SAMPLE ')]
        done = [json.loads(line.split(' ', 1)[1]) for line in raw.splitlines()
                if line.startswith('YI_LIVE_DONE ')]
        if not done or len(samples) != done[0]['samples'] or len(samples) < 10:
            raise RuntimeError('Missing sample records or completion marker')
        (args.output / 'samples.jsonl').write_text(''.join(json.dumps(x, separators=(',', ':'))+'\n' for x in samples))
        session['sample_count'] = len(samples)
        session['sampler_done'] = done[0]
        print('Saved ' + str(len(samples)) + ' samples', flush=True)
    except BaseException as e:
        session['error'] = repr(e)
        raise
    finally:
        if api is not None:
            if recording_owned or start_unconfirmed:
                try:
                    session['cleanup_stop'] = api.call(514, timeout=5)
                except Exception as e:
                    session['cleanup_stop_error'] = repr(e)
            try:
                api.close()
            except Exception as e:
                session['api_close_error'] = repr(e)
        if worker is not None and worker.is_alive():
            worker.join(timeout=20)
        if telnet is not None:
            if 'raw' in sampler:
                (args.output / 'telnet-output.txt').write_bytes(sampler['raw'])
            telnet.close()
        session['finished_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
        (args.output / 'session.json').write_text(json.dumps(session, ensure_ascii=False, indent=2)+'\n')


if __name__ == '__main__':
    main()
