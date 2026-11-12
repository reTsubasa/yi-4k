#!/usr/bin/env python3
"""Bounded EIS DRAM observation; no camera API calls or recording commands.

Uses the captured 1.10.7 code fingerprints. All mappings are read-only.
Values are not cache synchronized and must not be treated as coherent telemetry.
Device use is suspended after a confirmed camera hang during the investigation;
see docs/device-live-eis-observation.md section 6.
"""
import argparse
import datetime
import hashlib
import json
from pathlib import Path

import device_eis_live_capture as live
from device_linux_capture import Telnet
from device_rtos_snapshot import PARTITION, EXPECTED


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--seconds', type=float, default=4)
    parser.add_argument('--interval', type=float, default=0.1)
    args = parser.parse_args()
    if not 1 <= args.seconds <= 60 or not 0.05 <= args.interval <= 0.5:
        parser.error('Observe 1..60 seconds at intervals of 0.05..0.5 seconds')
    image = PARTITION.read_bytes()
    if hashlib.sha256(image).hexdigest() != EXPECTED:
        raise RuntimeError('Captured firmware SHA mismatch')
    args.output.mkdir(parents=True, exist_ok=False)
    # Stack bounds are established by this image's EIS task creation routine.
    # Event/mutex and tick ranges are from this image's gyro and time routines.
    windows = live.WINDOWS + [(0xA0ACAD00, 0x500),
                              (0xA1A38EC0, 0x180), (0xA1A3A500, 0x80)]
    program = live.target_program(image, args.seconds, args.interval, windows=windows)
    (args.output / 'target-probe.py').write_text(program)
    session = dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   host=args.host, image_sha256=EXPECTED, duration=args.seconds,
                   interval=args.interval, memory_read_only=True,
                   settings_changed=False, api_events=[], api_commands_sent=False,
                   limitation='DRAM reads are not atomic or cache synchronized.')
    camera = None
    try:
        camera = Telnet(args.host)
        camera.login()
        raw = camera.command("python -B -u <<'YI_OBSERVE_PY'\n" + program +
                             '\nYI_OBSERVE_PY', timeout=args.seconds+20)
        (args.output / 'telnet-output.txt').write_text(raw)
        samples = [json.loads(s.split(' ', 1)[1]) for s in raw.splitlines()
                   if s.startswith('YI_LIVE_SAMPLE ')]
        done = [json.loads(s.split(' ', 1)[1]) for s in raw.splitlines()
                if s.startswith('YI_LIVE_DONE ')]
        if not done or len(samples) != done[0]['samples']:
            raise RuntimeError('Sampler completion or sample count mismatch')
        session['sample_count'] = len(samples)
        session['sampler_done'] = done[0]
        (args.output / 'samples.jsonl').write_text(''.join(
            json.dumps(s, separators=(',', ':'))+'\n' for s in samples))
        print('Saved', len(samples), 'read-only observations')
    except BaseException as error:
        session['error'] = repr(error)
        if camera is not None:
            (args.output / 'partial-telnet-output.txt').write_bytes(bytes(camera.buffer))
        raise
    finally:
        (args.output / 'session.json').write_text(json.dumps(session, indent=2)+'\n')
        if camera is not None:
            camera.close()


if __name__ == '__main__':
    main()
