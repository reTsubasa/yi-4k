#!/usr/bin/env python3
"""Copy stock RTOS log files through ambafs, with a temporary read-only b: mount.

No /dev/mem, raw flash, RTOS shell, settings changes or recording commands.
Logs may contain device identifiers. A live file copy is not an atomic snapshot.
"""
import argparse
import base64
import datetime
import hashlib
import json
from pathlib import Path

from device_linux_capture import Telnet
from device_python_transport import run_python

TARGET = r'''import os, stat, subprocess, tempfile, signal, hashlib, json, base64
def deadline(signum, frame):
    raise RuntimeError('Log capture deadline')
signal.signal(signal.SIGALRM, deadline)
signal.alarm(25)
path = tempfile.mkdtemp(prefix='yi4k-rtos-logs-', dir='/tmp')
mounted = False
try:
    rc = subprocess.call(['mount','-t','ambafs','-o','ro','b:',path])
    assert rc == 0, 'b: mount failed'
    mounted = True
    print('YI_RTOS_LOG_MOUNT ' + path)
    for name in ('RtosActive.log', 'RtosOlder.log', 'RtosOldest.log'):
        source = path + '/' + name
        if not os.path.exists(source):
            print('YI_RTOS_LOG_MISSING ' + name)
            continue
        before = os.stat(source)
        assert stat.S_ISREG(before.st_mode), 'Not a regular file'
        assert 0 <= before.st_size <= 8388608, 'Log exceeds 8 MiB limit'
        digest = hashlib.sha256()
        copied = 0
        with open(source, 'rb') as file:
            while copied < before.st_size:
                data = file.read(min(32768, before.st_size - copied))
                assert data, 'File truncated during capture'
                digest.update(data)
                copied += len(data)
                print('YI_RTOS_LOG_DATA ' + name + ' ' + base64.b64encode(data))
        after = os.stat(source)
        print('YI_RTOS_LOG_META ' + json.dumps({'name':name, 'source':'b:/'+name,
            'bytes':copied, 'size_before':before.st_size, 'size_after':after.st_size,
            'mtime_before':before.st_mtime, 'mtime_after':after.st_mtime,
            'sha256':digest.hexdigest()}))
finally:
    signal.alarm(0)
    if mounted:
        rc = subprocess.call(['umount',path])
        print('YI_RTOS_LOG_UNMOUNT ' + str(rc))
        if rc == 0:
            os.rmdir(path)
    else:
        os.rmdir(path)
print('YI_RTOS_LOG_DONE')
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    compile(TARGET, '<target-log-capture>', 'exec')
    args.output.mkdir(parents=True, exist_ok=False)
    (args.output / 'target-capture.py').write_text(TARGET)
    session = dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   host=args.host, memory_probe_run=False, recording_commands_sent=False,
                   limitations=['Live files can grow or change during reads.',
                                'Initial file size limits the copied prefix.',
                                'Read-only mount still uses RTOS filesystem service.'])
    camera = None
    try:
        camera = Telnet(args.host)
        camera.login()
        raw = run_python(camera, TARGET, args.output, timeout=35)
        (args.output / 'telnet-output.txt').write_text(raw)
        files = {}
        metadata = []
        for line in raw.replace('\r', '').splitlines():
            if line.startswith('YI_RTOS_LOG_DATA '):
                _, name, payload = line.split(' ', 2)
                if name not in ('RtosActive.log', 'RtosOlder.log', 'RtosOldest.log'):
                    raise RuntimeError('Unexpected output filename')
                files.setdefault(name, bytearray()).extend(base64.b64decode(payload, validate=True))
            elif line.startswith('YI_RTOS_LOG_META '):
                metadata.append(json.loads(line.split(' ', 1)[1]))
        for row in metadata:
            data = files.get(row['name'], b'')
            if len(data) != row['bytes'] or hashlib.sha256(data).hexdigest() != row['sha256']:
                raise RuntimeError('File transfer length or SHA mismatch')
            (args.output / row['name']).write_bytes(data)
        session['files'] = metadata
        lines = raw.replace('\r', '').splitlines()
        session['unmounted'] = 'YI_RTOS_LOG_UNMOUNT 0' in lines
        if 'YI_RTOS_LOG_DONE' not in lines or not session['unmounted']:
            raise RuntimeError('Capture or temporary mount cleanup not confirmed')
        print('Copied', len(metadata), 'RTOS log files; temporary mount removed')
    except BaseException as error:
        session['error'] = repr(error)
        if camera is not None:
            (args.output / 'partial-telnet-output.txt').write_bytes(bytes(camera.buffer))
        raise
    finally:
        if camera is not None:
            camera.close()
        (args.output / 'session.json').write_text(json.dumps(session, indent=2)+'\n')


if __name__ == '__main__':
    main()
