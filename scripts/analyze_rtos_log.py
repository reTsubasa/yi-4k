#!/usr/bin/env python3
"""Extract EIS diagnostics from retained native logs without printing raw logs.

Allows selected numerical/status lines only; raw network JSON and identifiers
are excluded. Native logs are observations, not lossless per-frame telemetry.
"""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import re

NUMERIC = re.compile(
    r'^(?:FrameRatePerSec|CurrFrameTime|DlyMs|VerticalBlankTime|CapStartY|'
    r'GyroParam\.Offset[XYZ]|GyroCalibInfo\.Sense[XYZ]|GyroInfo\.VolDivDen|'
    r'EisSensorStatus\.ModeInfo\.[A-Za-z.]+|EisUpdateEndTime[12]|'
    r'EisWarpUpdateEndTime1|EisObj\.[A-Za-z]+)\s*=\s*(-?\d+)$')
ROW_TIME = 'EisSensorStatus.ModeInfo.RowTime*1000000000 + 0.5='


def analyze(path):
    data = path.read_bytes()
    text = re.sub(r'\x1b\[[0-9;]*m', '', data.decode('utf-8', 'replace')).replace('\x00', '')
    events = []
    mode_blocks = []
    current_mode = None
    for number, line in enumerate(text.splitlines(), 1):
        match = re.match(r'^\[(\d+)\]\[CA9_(\d+)\]\s*(.*)$', line)
        if not match:
            continue
        tick, cpu, body = int(match[1]), int(match[2]), match[3].strip()
        # Network log messages can contain authentication, settings and IDs.
        if '{' in body or re.search(r'password|passwd|serial|ssid|token|secret', body, re.I):
            continue
        category = None
        numeric = NUMERIC.fullmatch(body)
        rowtime = body.startswith(ROW_TIME) and body[len(ROW_TIME):].isdigit()
        if numeric or rowtime:
            category = 'parameter'
        elif body.startswith(('====AmbaImgEisCtrl_', '====AmbaImageMainEis_',
                              'eis init...', 'eis stop...', 'Eis rev.',
                              'set EIS processing mode:', 'eis timer',
                              'AmbaImgEisCtrl_SetFocalLength:', 'EisZoomRatio:',
                              'SamplingScale =', 'VinSensorGeo:', 'ADV time:',
                              'Eis-Warp calculation not in-time',
                              'Warp content not ready last frame')):
            category = 'eis'
        elif body == 'AppLibVideoEnc_VinSwitchCallback: EIS start' or (
                body.startswith('[Applib - VideoEnc]') and body.endswith('Stop Eis')):
            category = 'eis_lifecycle'
        if category:
            events.append(dict(line=number, tick=tick, cpu=cpu, category=category, text=body))
        if body == '====AmbaImgEisCtrl_ModeInit starts====':
            current_mode = dict(start_tick=tick, start_line=number, fields={})
        elif body == '====AmbaImgEisCtrl_ModeInit finish====' and current_mode is not None:
            current_mode.update(end_tick=tick, end_line=number)
            mode_blocks.append(current_mode)
            current_mode = None
        elif current_mode is not None:
            if numeric:
                key = body.split('=', 1)[0].strip()
                current_mode['fields'][key] = int(numeric[1])
            elif rowtime:
                current_mode['fields']['row_time_rounded_ns'] = int(body[len(ROW_TIME):])
            elif body.startswith('VinSensorGeo:'):
                current_mode['sensor_geometry'] = body
    return dict(source=str(path), sha256=hashlib.sha256(data).hexdigest(), bytes=len(data),
                events=events, mode_init_blocks=mode_blocks,
                selected_event_counts=dict(collections.Counter(e['category'] for e in events)),
                bounded_error_counts={pattern:text.count(pattern) for pattern in (
                    'Eis-Warp calculation not in-time', 'Warp content not ready last frame')},
                limitations=['Only selected printed events are extracted.',
                             'Native log buffering can lose, truncate or reorder messages.',
                             'Mode initialization and enable requests do not prove every-frame execution.',
                             'EnablePref/RscEnablePref are pending requests, not active enable flags.',
                             'No individual gyro samples or exposure-aligned frame timestamps recovered.'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('log', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result = analyze(args.log)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({key:result[key] for key in (
        'bytes', 'selected_event_counts', 'bounded_error_counts', 'mode_init_blocks')}, indent=2))


if __name__ == '__main__':
    main()
