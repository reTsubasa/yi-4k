#!/usr/bin/env python3
"""Bounded stock RTSP decode on the host; never records to camera SD.

Uses the session-advertised URL, TCP interleaving and the existing host FFmpeg.
If this probe starts VF, it sends normal STOP_VF in finally. It changes no
settings, files, memory, firmware or startup scripts on the camera.
"""
import argparse
import datetime
import hashlib
import json
import subprocess
import urllib.parse
from pathlib import Path

from device_eis_live_capture import CameraAPI, SETTINGS

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    report = {'started_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'api_events': [], 'target_files_written': False, 'recording_requested': False,
              'settings_changed': False, 'firmware_written': False,
              'evidence_kind': 'host FFmpeg decoding actual camera RTSP; not Android playback acceptance'}
    api = None
    owns_vf = False
    error = None
    try:
        api = CameraAPI(args.host, report['api_events'])
        api.open_session()
        replies = [e['message'] for e in report['api_events'] if e['direction'] == 'receive' and e['message'].get('msg_id') == 257]
        address = replies[-1].get('rtsp', '')
        uri = urllib.parse.urlsplit(address)
        if uri.scheme != 'rtsp' or uri.hostname != args.host or uri.username or uri.password:
            raise RuntimeError('Unsafe/non-camera advertised RTSP URL')
        report['rtsp_url'] = address
        before = api.call(1, type='app_status')
        report['status_before'] = before
        if before.get('rval') != 0 or before.get('param') not in ('idle', 'vf'):
            raise RuntimeError('Probe requires idle/VF camera')
        settings = api.call(3)
        report['settings_before'] = {k: v for row in settings['param'] for k, v in row.items() if k in SETTINGS}
        if not report['settings_before'].get('sw_version', '').startswith('Z16V13L_1.10.7_'):
            raise RuntimeError('Unexpected firmware identity')
        if before['param'] == 'idle':
            owns_vf = True
            report['vf_start'] = api.call(259)
            if report['vf_start'].get('rval') != 0:
                raise RuntimeError('START_VF rejected')
        # Request actual packets and decode a single frame. All outputs stay on host.
        command = [str(ROOT / '.tools/ffmpeg-host/ffmpeg'), '-nostdin', '-hide_banner',
                   '-loglevel', 'info', '-rtsp_transport', 'tcp', '-timeout', '8000000',
                   '-i', address, '-map', '0:v:0', '-frames:v', '1', '-an',
                   str(args.output / 'first-frame.png')]
        report['ffmpeg_command'] = command
        result = subprocess.run(command, capture_output=True, timeout=25)
        (args.output / 'decode-stdout.txt').write_bytes(result.stdout)
        (args.output / 'decode-stderr.txt').write_bytes(result.stderr)
        report['ffmpeg_returncode'] = result.returncode
        frame = args.output / 'first-frame.png'
        if result.returncode != 0 or not frame.is_file() or frame.stat().st_size == 0:
            raise RuntimeError('Camera RTSP did not produce a decoded first frame; inspect FFmpeg log')
        report['first_frame'] = {'file': frame.name, 'bytes': frame.stat().st_size,
                                  'sha256': hashlib.sha256(frame.read_bytes()).hexdigest()}
        probe = [str(ROOT / '.tools/ffmpeg-host/ffprobe'), '-v', 'error', '-rtsp_transport',
                 'tcp', '-timeout', '8000000', '-read_intervals', '%+3', '-show_streams',
                 '-show_packets', '-of', 'json', address]
        result = subprocess.run(probe, capture_output=True, timeout=25)
        (args.output / 'stream-packets.json').write_bytes(result.stdout)
        (args.output / 'probe-stderr.txt').write_bytes(result.stderr)
        if result.returncode != 0:
            raise RuntimeError('Bounded RTSP packet probe failed')
        packets = json.loads(result.stdout)
        report['streams'] = [{k: stream.get(k) for k in ('index', 'codec_type', 'codec_name',
                                  'width', 'height', 'sample_rate', 'channels', 'time_base', 'r_frame_rate')}
                             for stream in packets.get('streams', [])]
        report['packet_count'] = len(packets.get('packets', []))
    except BaseException as caught:
        report['error'] = repr(caught)
        error = caught
    finally:
        if api is not None:
            try:
                if owns_vf:
                    report['vf_stop'] = api.call(260)
                    if report['vf_stop'].get('rval') != 0:
                        raise RuntimeError('STOP_VF rejected')
                report['status_after'] = api.call(1, type='app_status')
                settings = api.call(3)
                report['settings_after'] = {k: v for row in settings['param'] for k, v in row.items() if k in SETTINGS}
                report['status_restored'] = report.get('status_before') == report['status_after']
                report['settings_equal'] = report.get('settings_before') == report['settings_after']
            except BaseException as cleanup:
                report['cleanup_error'] = repr(cleanup)
                if error is None:
                    error = cleanup
            finally:
                try:
                    api.close()
                except Exception as close_error:
                    report['close_error'] = repr(close_error)
        report['finished_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
        (args.output / 'session.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    if error is not None:
        raise error
    if not report.get('status_restored') or not report.get('settings_equal'):
        raise RuntimeError('Camera state not restored; inspect saved session')
    print(json.dumps({k: report[k] for k in ('first_frame', 'streams', 'packet_count', 'status_restored', 'settings_equal')}))


if __name__ == '__main__':
    main()
