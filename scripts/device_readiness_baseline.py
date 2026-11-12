#!/usr/bin/env python3
"""Capture API/Linux readiness without rebooting or executing RTOS commands.

Reads existing proc/sysfs information and known device paths over Telnet.
No memory mapping, target script upload, settings change, recording or mounts.
API sessions allocate transient control resources. SD path metadata uses ambafs.
"""
import argparse
import datetime
import json
from pathlib import Path

from device_eis_live_capture import CameraAPI, SETTINGS
from device_linux_capture import Telnet


COMMANDS = [
    ('uptime_before', 'cat /proc/uptime'),
    ('boot_id', 'cat /proc/sys/kernel/random/boot_id'),
    ('linux_memory', 'cat /proc/meminfo'),
    ('processes', 'ps'),
    ('ambarella_nodes', 'ls -l /proc/ambarella'),
    ('uport', 'cat /proc/ambarella/uport'),
    ('rpmsg', 'ls -l /sys/bus/rpmsg/devices'),
    ('rpmsg_names', 'cat /sys/bus/rpmsg/devices/*/name'),
    ('serial_nodes', 'ls -l /dev/ttyS* /dev/ttyUSB* /dev/ttyGS* /dev/rpmsg*'),
    ('mounts', 'cat /proc/mounts'),
    ('startup_probe_paths', 'ls -l /tmp/SD0/autoexec.ash /tmp/SD0/save_log_enable.script'),
    ('uptime_after', 'cat /proc/uptime'),
]


def api_snapshot(host, events):
    camera = CameraAPI(host, events)
    try:
        camera.open_session()
        status = camera.call(1, type='app_status')
        assert status.get('rval') == 0, status
        settings = camera.call(3)
        assert settings.get('rval') == 0, 'Settings query failed'
        selected = {key: value for row in settings['param']
                    for key, value in row.items() if key in SETTINGS}
        assert selected.get('sw_version', '').startswith('Z16V13L_1.10.7_'), selected
        return {'status': status, 'settings': selected}
    finally:
        camera.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    events = []
    session = {'host': args.host,
               'started_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
               'api_events': events, 'commands': [],
               'rtos_shell_invoked': False, 'memory_mapping_run': False,
               'reboot_requested': False, 'recording_requested': False,
               'settings_changed': False, 'target_files_written': False,
               'limitations': ['API and Linux readiness are not RTOS task/pool readiness.',
                               'Read-only SD metadata passes through RTOS filesystem service.',
                               'Snapshots are sequential, not simultaneous.']}
    camera = None
    try:
        session['before'] = api_snapshot(args.host, events)
        camera = Telnet(args.host)
        camera.login()
        for name, command in COMMANDS:
            raw = camera.command(command, timeout=8)
            (args.output / (name + '.txt')).write_text(raw)
            session['commands'].append({'name': name, 'command': command,
                                        'output': name + '.txt'})
        camera.close()
        camera = None
        session['after'] = api_snapshot(args.host, events)
        print(json.dumps({'before': session['before'], 'after': session['after'],
                          'inspection_commands': len(session['commands'])}, ensure_ascii=False))
    except BaseException as error:
        session['error'] = repr(error)
        if camera is not None:
            (args.output / 'partial-output.txt').write_bytes(bytes(camera.buffer))
        raise
    finally:
        try:
            if camera is not None:
                camera.close()
        finally:
            session['finished_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
            (args.output / 'session.json').write_text(json.dumps(session, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    main()
