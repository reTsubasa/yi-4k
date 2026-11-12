#!/usr/bin/env python3
"""Extract only exact numeric gyro/frame debug formats from native RTOS logs.

Axes remain printed raw values. The fourth slot is not a sensor timestamp.
No timing conversion, interpolation, units or unsigned-to-signed conversion.
"""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import re

FORMATS = (
    ('gyro', re.compile(r'GyroData=\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)'),
     ('axis_0_raw', 'axis_1_raw', 'axis_2_raw', 'extra_slot')),
    ('exposure', re.compile(r'GyroSampleOffset=(-?\d+) \((-?\d+)\), ExposureTime=(-?\d+)'),
     ('gyro_sample_offset_printed', 'offset_before_exposure_adjustment', 'exposure_time_raw')),
    ('frame_update', re.compile(r'---- update ArmSysTim = 0x([0-9a-fA-F]+)\s+prev_UpdateInfo.ArmSysTime = 0x([0-9a-fA-F]+); DiffTime = (-?\d+)'),
     ('arm_sys_time_raw', 'previous_arm_sys_time_raw', 'diff_time_raw')),
)


def analyze(path):
    data = path.read_bytes()
    source = re.sub(r'\x1b\[[0-9;]*m', '', data.decode('utf-8', 'replace')).replace('\x00', '')
    events = []
    for number, line in enumerate(source.splitlines(), 1):
        prefix = re.fullmatch(r'\[(\d+)\]\[CA9_(\d+)\]\s*(.*)', line)
        if prefix is None:
            continue
        for kind, pattern, names in FORMATS:
            match = pattern.fullmatch(prefix[3].strip())
            if match is None:
                continue
            values = [int(value, 16 if kind == 'frame_update' and i < 2 else 10)
                      for i, value in enumerate(match.groups())]
            events.append(dict(line=number, log_tick=int(prefix[1]), cpu=int(prefix[2]),
                               kind=kind, **dict(zip(names, values))))
            break
    counts = dict(collections.Counter(row['kind'] for row in events))
    ticks = [row['log_tick'] for row in events if row['kind'] == 'gyro']
    deltas = collections.Counter(b-a for a, b in zip(ticks, ticks[1:]))
    return dict(source=str(path), bytes=len(data), sha256=hashlib.sha256(data).hexdigest(),
                counts=counts, events=events,
                gyro_log_tick_delta_histogram={str(k):v for k,v in sorted(deltas.items())},
                limitations=[
                    'Exact numeric print formats only; unmatched lines are excluded.',
                    'Log tick is not an IMU hardware timestamp; tick units are not inferred.',
                    'Fourth gyro slot is not defined by the mode-1 three-axis read.',
                    'Frame ArmSysTim is retained as an opaque raw value; frame identity is uncalibrated.',
                    'Modulo-decimated buffered text is not lossless IMU telemetry.',
                    'No axis orientation, physical units or exposure-to-gyro synchronization established.'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('log', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result = analyze(args.log)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({key:result[key] for key in ('bytes', 'counts', 'gyro_log_tick_delta_histogram')}))


if __name__ == '__main__':
    main()
