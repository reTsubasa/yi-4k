#!/usr/bin/env python3
"""Correlate retained real camera EIS logs offline, without simulated feedback."""
from __future__ import annotations

import argparse
import collections
import csv
import hashlib
import json
import re
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from analyze_native_eis_trace import analyze
from analyze_eis_recording_window import analyze as phase_analyze

ROOT = Path(__file__).resolve().parents[1]
CAPTURE = ROOT / 'artifacts/device/2026-11-09-eis-recording'
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
LOG = CAPTURE / 'native-log-02/RtosActive.log'
BASE = 0xA0100000
EXPECTED = {
    0xA01F4A64: 'bl #0xa02a70ec',
    0xA01F4A70: 'ldr r0, [r4, #0x8c]',
    0xA01F4A78: 'rsb fp, fp, r0',
    0xA01F4A7C: 'str fp, [r4, #0x8c]',
    0xA01F4B58: 'bl #0xa02a70ec',
    0xA01F4B64: 'ldr r0, [r7, #0x8c]',
    0xA01F4B6C: 'rsb r8, r8, r0',
    0xA01F4B74: 'str r8, [r7, #0x8c]',
    0xA0387968: 'ldrh r3, [r3, #0x1e]',
    0xA038796C: 'and r3, r3, #1',
    0xA038799C: 'movw r0, #0x78',
    0xA03879A0: 'movt r0, #0xa060',
    0xA03879A4: 'bl #0xa02a70ec',
    0xA0387AB4: 'and r3, r3, #2',
    0xA0387ABC: 'beq #0xa0387b7c',
    0xA0387AD4: 'ldrb r3, [r3, r2]',
    0xA0387B24: 'mul r3, r3, r2',
    0xA0387B28: 'add r1, r1, r3',
    0xA0387B78: 'bl #0xa02a70ec',
    0xA0388370: 'and r3, r3, #2',
    0xA0388378: 'beq #0xa03883a8',
    0xA03883B0: 'ldr r2, [r3, #0x20]',
    0xA03883B4: 'movw r3, #0xb394',
    0xA03883B8: 'movt r3, #0xa170',
    0xA03883BC: 'str r2, [r3]',
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def histogram(values):
    return {str(k): v for k, v in sorted(collections.Counter(values).items(), key=lambda item: str(item[0]))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-directory', required=True, type=Path)
    args = parser.parse_args()
    observed = analyze(LOG)
    phases = phase_analyze(LOG)['phases']
    assert observed['sha256'] == '5529f3828fa987a5e3fefc0955b55a23a92fa3c1d2a7ed333fc386744136083c'
    assert observed['counts'] == {'exposure': 84, 'frame_update': 83, 'gyro': 59}
    old = json.loads((CAPTURE / 'native-log-02/gyro-events.json').read_text())
    assert observed['events'] == old['events'], 'Retained parser output mismatch'
    active = struct.unpack('<37H', (CAPTURE / 'collect-02/active.dat').read_bytes())
    before = struct.unpack('<37H', (CAPTURE / 'collect-02/before.dat').read_bytes())
    after = struct.unpack('<37H', (CAPTURE / 'collect-02/after.dat').read_bytes())
    assert before == after
    assert {i: v for i, v in enumerate(active) if v != before[i]} == {14: 1, 15: 1, 20: 1, 22: 50}
    image = (ANALYSIS / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(image).hexdigest() == 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in EXPECTED.items():
        ins = next(cs.disasm(image[address-BASE:address-BASE+4], address))
        actual = ins.mnemonic + ' ' + ins.op_str
        assert actual == expected, (hex(address), actual, expected)
        checks.append({'address': hex(address), 'bytes': bytes(ins.bytes).hex(), 'instruction': actual})
    source = re.sub(r'\x1b\[[0-9;]*m', '', LOG.read_bytes().decode('utf-8', 'replace')).replace('\x00', '')
    lines = source.splitlines()
    prefixes = ['Spf[ArmSysTim]', 'ucodeSampleTime=', 'WarpReady=', 'update_eis_status_do =',
                'Warp cmd in shared memory:', 'Do EisPerFrame:', 'current UpdateInfo.ArmSysTime:',
                'Warp content not ready last frame', 'Eis-Warp calculation not in-time']
    diagnostic_counts = {prefix: sum(prefix in line for line in lines) for prefix in prefixes}
    rows = []
    summaries = []
    for phase in phases:
        events = [e for e in observed['events'] if e['line'] >= phase['first_source_line']
                  and (phase['last_source_line'] is None or e['line'] <= phase['last_source_line'])]
        feedback = [e for e in events if e['kind'] == 'frame_update']
        exposures = [e for e in events if e['kind'] == 'exposure']
        gyros = [e for e in events if e['kind'] == 'gyro']
        for event in feedback:
            index = event['arm_sys_time_raw'] & 255
            preceding_exposure = next((e for e in reversed(exposures) if e['line'] < event['line']), None)
            preceding_gyro = next((e for e in reversed(gyros) if e['line'] < event['line']), None)
            row = dict(mode_index=phase['mode_index'], source_line=event['line'], log_tick=event['log_tick'],
                       cpu=event['cpu'], feedback_hex=hex(event['arm_sys_time_raw']),
                       index=index, warp_ready_mask=hex(event['arm_sys_time_raw'] & 0x100),
                       previous_hex=hex(event['previous_arm_sys_time_raw']), diff_time_raw=event['diff_time_raw'],
                       static_history_record_address=hex(0xA170B3A0 + index * 0x18),
                       static_spf_byte_address=hex(0xA170AF98 + index),
                       nearby_exposure_line=preceding_exposure['line'] if preceding_exposure else '',
                       nearby_exposure_tick_delta=event['log_tick']-preceding_exposure['log_tick'] if preceding_exposure else '',
                       nearby_gyro_line=preceding_gyro['line'] if preceding_gyro else '',
                       nearby_gyro_tick_delta=event['log_tick']-preceding_gyro['log_tick'] if preceding_gyro else '',
                       history_values_observed=False, spf_observed=False, video_frame_identified=False,
                       nearby_records_are_associations=False)
            rows.append(row)
        delta = [b['log_tick']-a['log_tick'] for a, b in zip(feedback, feedback[1:])]
        phase_rows = [r for r in rows if r['mode_index'] == phase['mode_index']]
        summaries.append(dict(mode_index=phase['mode_index'], geometry=phase['sensor_geometry'],
                              event_counts=histogram(e['kind'] for e in events),
                              feedback_tick_range=[feedback[0]['log_tick'], feedback[-1]['log_tick']] if feedback else [],
                              feedback_tag_counts=histogram(hex(e['arm_sys_time_raw']) for e in feedback),
                              feedback_tick_delta_histogram=histogram(delta),
                              previous_counts=histogram(hex(e['previous_arm_sys_time_raw']) for e in feedback),
                              feedback_tag_diff_counts=histogram(f"{hex(e['arm_sys_time_raw'])}/{e['diff_time_raw']}" for e in feedback),
                              nearby_exposure_tick_delta_histogram=histogram(r['nearby_exposure_tick_delta'] for r in phase_rows),
                              nearby_gyro_tick_delta_histogram=histogram(r['nearby_gyro_tick_delta'] for r in phase_rows)))
    assert len(rows) == 83 and all(r['index'] in (5, 6) and r['warp_ready_mask'] == '0x100' for r in rows)
    assert len([r for r in rows if r['mode_index'] == 1]) == 66
    video_path = CAPTURE / 'video/YDXJ0139.MP4'
    video_hash = digest(video_path)
    assert video_hash == json.loads((CAPTURE / 'video/download.json').read_text())['sha256']
    video_validation = json.loads((CAPTURE / 'video/video-validation.json').read_text())
    assert video_validation['completed'] and video_validation['decoded_video_frames'] == 48
    file_mentions = []
    timing_settings = []
    mux_summaries = []
    eos_markers = []
    for number, line in enumerate(lines, 1):
        tick = re.search(r'\[(\d+)\]\[CA9_(\d+)\]', line)
        if 'YDXJ0139.MP4' in line:
            file_mentions.append({'source_line': number, 'log_tick': int(tick[1]) if tick else None,
                                  'file': 'YDXJ0139.MP4'})
        if re.search(r'ADV time:|EisUpdateEndTime[12]=|EisWarpUpdateEndTime1=', line):
            timing_settings.append({'source_line': number, 'text': line.strip()})
        mux = re.search(r'(pri|sec) fps (\d+)/(\d+)\s+FrameCount (\d+) trim frame (\d+) min frame (\d+)', line)
        if mux:
            count, trim = int(mux[4]), int(mux[5])
            mux_summaries.append({'source_line': number, 'log_tick': int(tick[1]), 'stream_label': mux[1],
                                  'fps_numerator': int(mux[2]), 'fps_denominator': int(mux[3]),
                                  'frame_count_before_trim': count, 'trim_frame_count': trim,
                                  'minimum_frame_count': int(mux[6]), 'arithmetic_count_after_trim': count-trim})
        eos = re.search(r'\[Strm_(\d+)\] pts ([0-9a-f]+) AMP_FIFO_MARK_EOS', line)
        if eos:
            eos_markers.append({'source_line': number, 'log_tick': int(tick[1]), 'stream_index': int(eos[1]),
                                'pts_hex': eos[2], 'sentinel_not_timestamp': eos[2] == 'ffffffffffffffff'})
    assert len(mux_summaries) == 2
    assert all(m['arithmetic_count_after_trim'] == video_validation['decoded_video_frames'] for m in mux_summaries)
    sources = [LOG, CAPTURE / 'collect-02/active.dat', CAPTURE / 'collect-02/before.dat',
               CAPTURE / 'collect-02/after.dat', video_path, CAPTURE / 'video/video-validation.json',
               ANALYSIS / 'focused/a0385780.c', ANALYSIS / 'focused/a0385780.asm',
               ANALYSIS / 'full/decompiled/a037dc08.c', ANALYSIS / 'full/decompiled/a037c5a4.c',
               ANALYSIS / 'full/decompiled/a0392cb0.c', ANALYSIS / 'full/decompiled/a01f4994.c',
               ROOT / 'scripts/analyze_native_eis_trace.py',
               ROOT / 'scripts/analyze_eis_recording_window.py']
    report = dict(evidence_kind='retained real-device text logs correlated with pinned static CPU semantics',
                  device_contacted=False, synthetic_feedback_used=False, rows=len(rows), phases=summaries,
                  checks=checks, instruction_check_count=len(checks),
                  active_debug_fields={str(i): v for i, v in enumerate(active)},
                  diagnostic_prefix_counts=diagnostic_counts, mode_timing_setting_lines=timing_settings,
                  video={'sha256': video_hash, 'retained_decoder_result': video_validation,
                         'new_decode_performed': False, 'filename_log_mentions': file_mentions,
                         'mux_trim_summaries': mux_summaries, 'end_of_stream_markers': eos_markers,
                         'feedback_after_stream_0_eos': sum(r['mode_index'] == 1 and r['log_tick'] > 28098 for r in rows),
                         'feedback_within_filename_open_close_tick_span': sum(26031 <= r['log_tick'] <= 28211 for r in rows)},
                  excluded_historical_logs=[{'path': str(p.relative_to(ROOT)), 'sha256': digest(p)} for p in
                                            [CAPTURE / 'native-log-02/RtosOlder.log', CAPTURE / 'native-log-02/RtosOldest.log']],
                  sources=[{'path': str(p.relative_to(ROOT)), 'sha256': digest(p)} for p in sources],
                  boundaries={'real_valid_feedback_prints_observed': True, 'all_observed_warp_ready_bits_set': True,
                              'spf_values_observed': False, 'gyro_history_values_observed': False,
                              'specific_publication_matched': False, 'dsp_writer_identified': False,
                              'video_frame_mapping': False, 'slot_release_proven': False},
                  limitations=['Static history addresses are calculated from code, not captured memory contents.',
                               'Nearby exposure/gyro records are file-order vicinity only, not same-frame or same-sample associations.',
                               'No raw logs, prior JSON outputs, debug settings or video artifacts were modified.',
                               'Existing AVFoundation decoder result is hash-associated evidence; no new video decode was run.',
                               'No PTS origin is linked to the log clock and no missing/lost-frame inference is made.'])
    args.output_directory.mkdir(parents=True, exist_ok=True)
    (args.output_directory / 'audit.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
    with (args.output_directory / 'feedback.csv').open('w', newline='') as output:
        writer = csv.DictWriter(output, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    selected = [f'{r["source_line"]}: {lines[r["source_line"]-1]}' for r in rows]
    (args.output_directory / 'observed-feedback.txt').write_text('\n'.join(selected)+'\n')
    print(f'{len(rows)} real feedback records; 66 recording-phase records; {len(checks)} static checks; video SHA verified')


if __name__ == '__main__':
    main()
