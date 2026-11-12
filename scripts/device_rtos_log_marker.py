#!/usr/bin/env python3
"""Stage/remove the stock RTOS log marker on this 1.10.7 camera.

Stages one empty file with exclusive creation; does not execute RTOS commands,
access /dev/mem, change preferences, or restart the camera. Requires a normal
restart for the next boot check. Remove uses the retained ownership receipt.
"""
import argparse
import datetime
import json
from pathlib import Path

from device_eis_live_capture import CameraAPI
from device_linux_capture import Telnet

MARKER = '/tmp/SD0/save_log_enable.script'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('stage', 'remove'))
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--receipt', type=Path)
    args = parser.parse_args()
    if args.action == 'remove':
        if args.receipt is None:
            parser.error('remove requires --receipt from the staging operation')
        receipt = json.loads(args.receipt.read_text())
        if not (receipt.get('created_exclusively') is True and
                receipt.get('marker') == MARKER and receipt.get('host') == args.host):
            raise RuntimeError('Receipt does not establish ownership of this marker')
    args.output.mkdir(parents=True, exist_ok=False)
    session = dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   host=args.host, action=args.action, marker=MARKER,
                   api_events=[], memory_probe_run=False, preferences_changed=False)
    api = None
    camera = None
    try:
        api = CameraAPI(args.host, session['api_events'])
        api.open_session()
        status = api.call(1, type='app_status')
        if status.get('rval') != 0 or status.get('param') not in ('idle', 'vf'):
            raise RuntimeError('Camera is not confirmed idle or in live view')
        settings = api.call(3)
        if settings.get('rval') != 0:
            raise RuntimeError('Settings query failed')
        version = next((row['sw_version'] for row in settings.get('param', [])
                        if 'sw_version' in row), '')
        if not version.startswith('Z16V13L_1.10.7_'):
            raise RuntimeError('Unexpected firmware version')
        api.close()
        api = None
        camera = Telnet(args.host)
        camera.login()
        if args.action == 'stage':
            operation = """fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0600)
os.close(fd)
st = os.lstat(path)
assert stat.S_ISREG(st.st_mode) and st.st_size == 0
print('YI_LOG_MARKER_CREATED ' + json.dumps({'size': st.st_size, 'inode': st.st_ino, 'mtime': st.st_mtime}))
"""
        else:
            operation = """st = os.lstat(path)
assert stat.S_ISREG(st.st_mode) and st.st_size == 0, 'Refuse removal of modified marker'
os.unlink(path)
assert not os.path.lexists(path)
print('YI_LOG_MARKER_REMOVED')
"""
        program = 'import os, stat, json\npath = ' + repr(MARKER) + '\n' + operation
        (args.output / 'target-operation.py').write_text(program)
        command = "python -B -u <<'YI_LOG_MARKER_PY'\n" + program + '\nYI_LOG_MARKER_PY'
        (args.output / 'target-command.txt').write_text(command + '\n')
        raw = camera.command(command, timeout=12)
        (args.output / 'telnet-output.txt').write_text(raw)
        expected = ('YI_LOG_MARKER_CREATED ' if args.action == 'stage'
                    else 'YI_LOG_MARKER_REMOVED')
        lines = raw.replace('\r', '').splitlines()
        matches = [line for line in lines if line.startswith(expected)]
        if len(matches) != 1:
            raise RuntimeError('Operation not confirmed; inspect retained output')
        session['operation_confirmed'] = True
        if args.action == 'stage':
            session['created_exclusively'] = True
            session['marker_stat'] = json.loads(matches[0].split(' ', 1)[1])
            session['activation_verified'] = False
        print(matches[0])
    except BaseException as error:
        session['error'] = repr(error)
        raise
    finally:
        if api is not None:
            try:
                api.close()
            except Exception as error:
                session['api_close_error'] = repr(error)
        if camera is not None:
            camera.close()
        (args.output / 'session.json').write_text(json.dumps(session, indent=2)+'\n')


if __name__ == '__main__':
    main()
