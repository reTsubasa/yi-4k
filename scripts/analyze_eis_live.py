#!/usr/bin/env python3
"""Analyze retained DRAM observations, including failed recording attempts.

Does not contact the camera. Changing DRAM bytes are observations, not a claim
of coherent snapshots, continuous IMU samples, or successful recording.
"""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import statistics
import struct

FIELDS = {
    'rsc_enable': (0xA0757A68, '<B'),
    'extra_gyro_phase': (0xA0757AB0, '<b'),
    'ucode_gyro_delay': (0xA0757AB1, '<B'),
    'rsc_scale': (0xA0757AC4, '<i'),
    'sample_gate': (0xA1702CBC, '<B'),
    'sample_tick': (0xA1702C40, '<I'),
    'ring_length': (0xA1702F10, '<I'),
    'ring_next_write': (0xA1702F14, '<I'),
    'ring_current_index': (0xA170AB38, '<I'),
    'processed_sample_tick': (0xA170AB60, '<I'),
    'frame_rate_integer': (0xA17040B4, '<I'),
    'row_time_seconds': (0xA1704140, '<f'),
    'frame_length_lines': (0xA1704134, '<I'),
    'eof_time': (0xA17042FC, '<I'),
    'sof_time': (0xA1704300, '<I'),
    'previous_eof_time': (0xA1704304, '<I'),
    'previous_sof_time': (0xA1704308, '<I'),
    'task_eof_time': (0xA170BA84, '<I'),
    'task_sof_time': (0xA170BC90, '<I'),
    'task_consumed_sof_time': (0xA170BC88, '<I'),
    'task_state': (0xA170BCFC, '<I'),
    'eis_task_magic': (0xA170BBB0, '<I'),
    'eis_task_run_count': (0xA170BBB4, '<I'),
    'eis_task_saved_sp': (0xA170BBB8, '<I'),
    'eis_task_wait_state': (0xA170BBE0, '<I'),
    'eis_task_wait_ticks': (0xA170BBFC, '<I'),
    'eis_task_wait_object': (0xA170BC20, '<I'),
    'eis_task_wait_mask': (0xA170BC2C, '<I'),
    'system_tick': (0xA1A3A528, '<I'),
    'driver_x': (0xA1702C30, '<H'),
    'driver_y': (0xA1702C32, '<H'),
    'driver_z': (0xA1702C34, '<H'),
}


def read(windows, address, size):
    for start, data in windows:
        offset = address - start
        if 0 <= offset and offset + size <= len(data):
            return data[offset:offset+size]
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    args = parser.parse_args()
    root = args.directory
    source = root / 'samples.jsonl'
    if source.exists():
        samples = [json.loads(x) for x in source.read_text().splitlines() if x.strip()]
    else:
        raw = (root / 'telnet-output.txt').read_text()
        samples = [json.loads(x.split(' ', 1)[1]) for x in raw.splitlines()
                   if x.startswith('YI_LIVE_SAMPLE ')]
        source.write_text(''.join(json.dumps(x, separators=(',', ':'))+'\n' for x in samples))
    if not samples:
        raise SystemExit('No retained samples')
    fields, window_hashes = [], {}
    ring_analysis = []
    for sample in samples:
        windows = [(int(x['va'], 16), bytes.fromhex(x['hex'])) for x in sample['windows']]
        row = {k: sample[k] for k in ('n', 't_start', 't_end')}
        for name, (address, fmt) in FIELDS.items():
            raw = read(windows, address, struct.calcsize(fmt))
            if raw is not None:
                row[name] = struct.unpack(fmt, raw)[0]
        for start, data in windows:
            window_hashes.setdefault(hex(start), []).append(hashlib.sha256(data).hexdigest())
        count = row.get('ring_length', 0)
        if 0 < count <= 132:
            axes = {}
            for axis, offset in [('x', 0), ('y', 0x89), ('z', 0x112)]:
                data = read(windows, 0xA1702D00 + 4*offset, 4*count)
                if data is None:
                    continue
                values = list(struct.unpack('<' + 'I'*count, data))
                axes[axis] = dict(min_u32=min(values), max_u32=max(values),
                                  slots_low8_zero=sum(v & 255 == 0 for v in values),
                                  slots=count, sha256=hashlib.sha256(data).hexdigest())
            ring_analysis.append(dict(n=sample['n'], axes=axes))
        fields.append(row)
    with (root / 'fields.csv').open('w', newline='') as output:
        writer = csv.DictWriter(output, fieldnames=list(fields[0]))
        writer.writeheader()
        writer.writerows(fields)
    summary = dict(samples=len(samples), first_t=samples[0]['t_start'], last_t=samples[-1]['t_end'],
                   samples_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                   median_interval=statistics.median(b['t_start']-a['t_start'] for a,b in zip(samples,samples[1:])),
                   max_interval=max(b['t_start']-a['t_start'] for a,b in zip(samples,samples[1:])),
                   max_window_copy_seconds=max(s['t_end']-s['t_start'] for s in samples),
                   fields={}, window_distinct_counts={a:len(set(v)) for a,v in window_hashes.items()},
                   limitations=['Changing bytes do not prove cross-core cache coherence or simultaneous fields.',
                                'Repeated ring snapshots are not a reconstructed lossless IMU stream.',
                                'Sample copy duration excludes JSON formatting and transport overhead.'])
    for name in fields[0]:
        if name in ('n', 't_start', 't_end'):
            continue
        values = [row[name] for row in fields]
        changes = [dict(t=fields[i]['t_start'], value=v) for i,v in enumerate(values)
                   if i and v != values[i-1]]
        summary['fields'][name] = dict(first=values[0], last=values[-1],
                                        distinct=len(set(values)), changes=len(changes),
                                        first_change=changes[0] if changes else None,
                                        last_change=changes[-1] if changes else None)
    session = json.loads((root / 'session.json').read_text())
    summary['record_start_ack_observed'] = 'record_start_ack_host_monotonic' in session
    summary['record_stop_ack_observed'] = 'record_stop_ack_host_monotonic' in session
    ready = session.get('sampler_ready_host_monotonic')
    summary['api_events_relative_to_ready'] = [dict(t=e['host_monotonic']-ready,
                                                   direction=e['direction'], message=e['message'])
                                             for e in session.get('api_events', [])] if ready else []
    (root / 'analysis.json').write_text(json.dumps(summary, indent=2)+'\n')
    (root / 'ring-analysis.json').write_text(json.dumps(ring_analysis, indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k not in ('fields','api_events_relative_to_ready')}, indent=2))
    for name in ('sample_gate','sample_tick','ring_next_write','sof_time','eof_time',
                 'task_sof_time','task_consumed_sof_time','eis_task_run_count','system_tick'):
        print(name, json.dumps(summary['fields'].get(name)))


if __name__ == '__main__':
    main()
