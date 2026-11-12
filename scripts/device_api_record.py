#!/usr/bin/env python3
"""Record one bounded stock clip using only the camera's normal TCP API.

No DRAM access, settings changes or service startup. A clip is created on SD.
"""
import argparse
import datetime
import json
from pathlib import Path
import time

from device_eis_live_capture import CameraAPI, SETTINGS


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--seconds', type=float, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if not 2 <= args.seconds <= 15:
        parser.error('Record 2..15 seconds')
    args.output.mkdir(parents=True, exist_ok=False)
    session = dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   host=args.host, api_events=[], memory_probe_run=False,
                   settings_changed=False, requested_record_seconds=args.seconds)
    api = None
    may_be_recording = False
    try:
        api = CameraAPI(args.host, session['api_events'])
        api.open_session()
        status = api.call(1, type='app_status')
        session['status_before'] = status
        if status.get('rval') != 0 or status.get('param') not in ('idle', 'vf'):
            raise RuntimeError('Not confirmed idle or in live view')
        result = api.call(3)
        if result.get('rval') != 0:
            raise RuntimeError('Settings query failed')
        settings = {key:value for row in result['param'] for key,value in row.items()
                    if key in SETTINGS}
        session['settings_before'] = settings
        if not str(settings.get('sw_version', '')).startswith('Z16V13L_1.10.7_'):
            raise RuntimeError('Unexpected firmware')
        if settings.get('system_mode') != 'record' or settings.get('sd_card_status') != 'insert':
            raise RuntimeError('Video mode and inserted SD required')
        battery = api.call(13)
        session['power'] = battery
        if (battery.get('rval') != 0 or battery.get('type') not in ('battery', 'adapter')
                or int(battery.get('param', 0)) < 20):
            raise RuntimeError('Power not confirmed >=20%')
        may_be_recording = True
        started = api.call(513, timeout=8)
        session['record_start_reply'] = started
        if started.get('rval') != 0:
            may_be_recording = False
            raise RuntimeError('Recording start refused')
        session['record_start_ack_host_monotonic'] = time.monotonic()
        print('Recording acknowledged', flush=True)
        time.sleep(args.seconds)
        stopped = api.call(514, timeout=8)
        session['record_stop_reply'] = stopped
        if stopped.get('rval') != 0:
            raise RuntimeError('Recording stop refused')
        may_be_recording = False
        session['record_stop_ack_host_monotonic'] = time.monotonic()
        session['status_after'] = []
        for attempt in range(4):
            status = api.call(1, type='app_status')
            session['status_after'].append(status)
            if status.get('rval') == 0 and status.get('param') in ('idle', 'vf'):
                break
            time.sleep(1)
        print('Stop acknowledged; final status:', status.get('param'), flush=True)
    except BaseException as error:
        session['error'] = repr(error)
        raise
    finally:
        if api is not None:
            if may_be_recording:
                try:
                    session['cleanup_stop'] = api.call(514, timeout=5)
                except Exception as error:
                    session['cleanup_stop_error'] = repr(error)
            try:
                api.close()
            except Exception as error:
                session['api_close_error'] = repr(error)
        session['finished_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
        (args.output / 'session.json').write_text(json.dumps(session, indent=2)+'\n')


if __name__ == '__main__':
    main()
