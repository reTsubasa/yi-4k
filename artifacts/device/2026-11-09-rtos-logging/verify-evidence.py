"""Offline checks against retained native-log, binary and video evidence."""
from pathlib import Path
import hashlib
import json
import re
import struct
import sys

ROOT = Path(__file__).resolve().parents[3]
EVIDENCE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'scripts'))
from analyze_rtos_log import analyze
from device_rtos_log_capture import TARGET


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(name, value):
    (EVIDENCE / name).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n')


scripts = ['device_rtos_log_marker.py', 'device_rtos_log_capture.py',
           'device_api_record.py', 'analyze_rtos_log.py']
for name in scripts:
    path = ROOT / 'scripts' / name
    compile(path.read_text(), str(path), 'exec')
compile(TARGET, '<target-log-capture>', 'exec')

inputs = {
    'artifacts/device/2026-11-09-linux/sys_sw_partition.bin':
        'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6',
    'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin':
        'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c',
}
for name, digest in inputs.items():
    assert sha(ROOT / name) == digest, name
window_manifest = json.loads((EVIDENCE / 'kernel-window-capture.json').read_text())
for row in window_manifest['windows']:
    path = EVIDENCE / row['file']
    assert path.stat().st_size == row['bytes'] and sha(path) == row['sha256']
    inputs[str(path.relative_to(ROOT))] = row['sha256']

reports = []
for directory, expected_bytes, expected_blocks in [
        ('native-baseline-03', 134134, 1), ('native-after-recording', 274306, 4)]:
    path = EVIDENCE / directory / 'RtosActive.log'
    report = analyze(path)
    saved = json.loads((path.parent / 'eis-events.json').read_text())
    assert (ROOT / saved['source']).resolve() == path.resolve()
    report['source'] = saved['source']
    assert report == saved
    assert report['bytes'] == expected_bytes
    assert len(report['mode_init_blocks']) == expected_blocks
    meta = json.loads((path.parent / 'session.json').read_text())
    assert meta['unmounted'] is True
    assert len(meta['files']) == 1
    assert meta['files'][0]['sha256'] == report['sha256']
    assert meta['files'][0]['bytes'] == report['bytes']
    for event in report['events']:
        assert '{' not in event['text']
        assert not re.search('password|passwd|serial|ssid|token|secret',event['text'],re.I)
    reports.append(report)
report = reports[-1]
blocks = report['mode_init_blocks']
for key, expected in {
    'EisSensorStatus.ModeInfo.OutputInfo.OutputHeight':[1098,1098,2182,1098],
    'EisSensorStatus.ModeInfo.OutputInfo.RecordingPixels.Height':[1080,1080,2160,1080],
    'DlyMs':[23,23,16,23], 'VerticalBlankTime':[25,25,18,25],
    'row_time_rounded_ns':[7333]*4,
    'EisSensorStatus.ModeInfo.FrameLengthLines':[4550]*4,
}.items():
    assert [b['fields'][key] for b in blocks] == expected, key
for key, expected in {'EisUpdateEndTime1':[17,17,10,17],
                      'EisUpdateEndTime2':[23,23,16,23],
                      'EisWarpUpdateEndTime1':[20,20,13,20]}.items():
    values=[int(e['text'].split('=')[1]) for e in report['events'] if e['text'].startswith(key+'=')]
    assert values==expected, key
assert all(value == 0 for value in report['bounded_error_counts'].values())
assert 'Width=3840, Height=2160' in blocks[2]['sensor_geometry']
assert all('Width=1920, Height=1080' in blocks[i]['sensor_geometry'] for i in (0,1,3))

functions = json.loads((EVIDENCE / 'focused/functions.json').read_text())
assert len(functions) == 40 and all(row['decompile_completed'] for row in functions)
image = (ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin').read_bytes()
offset=0xa0394ba0-0xa0100000
assert struct.unpack('<II', image[offset:offset+8]) == (0xe1a00003,0xe12fff1e)

video_dir = EVIDENCE / 'logged-recording'
video = video_dir / 'YDXJ0136.MP4'
assert video.stat().st_size == 31400038
validation = json.loads((video_dir/'video-validation.json').read_text())
assert validation['completed'] is True and not validation['error']
assert validation['decoded_video_frames'] == 109
assert (validation['width'], validation['height']) == (1920,1080)
assert 3.63 < validation['duration_seconds'] < 3.64
session = json.loads((video_dir/'session.json').read_text())
assert session['record_start_reply']['rval'] == session['record_stop_reply']['rval'] == 0
assert session['memory_probe_run'] is False and session['settings_changed'] is False
final = json.loads((EVIDENCE/'final-status/session.json').read_text())
assert final['app_status']['param'] == 'idle'
assert not final['linux']['log_marker_exists'] and not final['linux']['autoexec_exists']
assert not final['linux']['temporary_log_mounts'] and not final['linux']['temporary_log_dirs']
assert final['api_events'][-1]['message']['msg_id'] == 258
assert final['api_events'][-1]['message']['rval'] == 0

link_count = 0
for path in [ROOT/'README.md', ROOT/'docs/device-native-rtos-logging.md',
             ROOT/'docs/device-live-eis-observation.md', ROOT/'docs/device-validation.md',
             EVIDENCE/'README.md']:
    for target in re.findall(r'\]\(([^)]+)\)', path.read_text()):
        if '://' in target or target.startswith('#'):
            continue
        assert (path.parent / target.split('#')[0]).exists(), (path, target)
        link_count += 1

mode_summaries=[]
for i,block in enumerate(blocks):
    mode_summaries.append(dict(index=i, start_tick=block['start_tick'],
         sensor_geometry=block['sensor_geometry'], fields=block['fields']))
save('findings.json', dict(
    firmware='Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746',
    input_sha256=inputs, focused_export_count=40,
    native_logging_runtime_verified=True, logged_short_recording_decoded=True,
    video=dict(file=str(video.relative_to(ROOT)), bytes=video.stat().st_size,
               sha256=sha(video), validation=validation),
    modes=mode_summaries, pending_preference_fields=['0xa170404e','0xa170404f'],
    active_enable_fields=['0xa1704044','0xa1704045','0xa1704046'],
    gyro_log_init=dict(address='0xa0394ba0', instructions=['mov r0,r3','bx lr'],
                       scope='This initialization hook is a stub; other gyro export paths not excluded.'),
    bounded_error_counts=report['bounded_error_counts'],
    memory_probe_run_this_experiment=False, rsc_patched=False,
    final_status=final['linux'], final_api_status=final['app_status'],
    limitations=report['limitations']+[
        'Internal sensor geometry is not encoded video resolution.',
        'No measured stabilization or jelly improvement.',
        'Native logger can remain active in this boot after marker removal.',
        'Previous hang cause remains unconfirmed.',
        'No arbitrary RTOS code execution established.']))
save('offline-validation.json', dict(
    passed=True, scope='Retained evidence; no new camera commands',
    python_scripts_compiled=scripts, target_log_program_syntax_checked=True,
    input_and_transfer_sha256_verified=True, mode_blocks_verified=4,
    submission_timing_sequences_verified=True,
    selected_events_exclude_network_json_and_identifier_keywords=True,
    gyro_log_stub_instructions_verified=True, video_length_and_decoder_result_verified=True,
    final_cleanup_and_api_close_verified=True, local_markdown_links_verified=link_count,
    note='The original video decode was performed separately with AVFoundation; not repeated here.'))
print(json.dumps({'passed':True,'mode_blocks':4,'focused_exports':40,'links':link_count,'video_bytes':video.stat().st_size}))
