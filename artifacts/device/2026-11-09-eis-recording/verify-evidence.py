"""Offline verification, including explicit pending/failed experiment states."""
import base64
import hashlib
import json
from pathlib import Path
import re
import struct
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
from device_eis_recording_trace import spec,target_program,verify
from analyze_eis_recording_window import analyze


def read(name):return json.loads((HERE/name).read_text())


def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()


for directory in ('stage','stage-02'):
    receipt=read(directory+'/session.json');probe=receipt['probe']
    assert receipt['result']['created_exclusively']
    assert probe==json.loads(json.dumps(spec(probe['identifier'],probe.get('condition_style','command'))))
    for key,payload in probe['payloads'].items():
        data=base64.b64decode(payload)
        assert hashlib.sha256(data).hexdigest()==probe['payload_sha256'][key]
        if key=='script':assert max(map(len,data.decode().splitlines()))<256
    transport=read(directory+'/transport.json');assert transport['verified'] and transport['removed']
    for action in ('stage','collect','cleanup','disarm'):
        compile(target_program(action,probe,{}),'<generated-'+action+'>','exec')
first=read('collect/session.json')
assert first.get('error','').startswith('FileNotFoundError(')
for key,row in first['files'].items():
    p=HERE/'collect'/(key+'.dat')
    assert p.stat().st_size==row['bytes'] and digest(p)==row['sha256']
assert (HERE/'collect/before.dat').read_bytes()==(HERE/'collect/after.dat').read_bytes()
assert len((HERE/'collect/before.dat').read_bytes())==74
assert (HERE/'collect/fingerprint.dat').read_bytes().hex()=='0300a0e11eff2fe1'
gate=read('collect/gate.dat')
assert gate['ready_created'] and gate['preflight_passed'] and gate['baseline_checked_before_enable']
assert not gate.get('error') and gate['close']['rval']==0
assert first['result']['missing']==['active','attempt','negative','record']
assert read('cleanup-first/session.json')['result']['owned_files_removed']
logs=read('native-log/session.json');assert logs['unmounted']
for row in logs['files']:
    p=HERE/'native-log'/row['name'];assert p.stat().st_size==row['bytes'] and digest(p)==row['sha256']
phase=analyze(HERE/'native-log/RtosActive.log');assert phase['total_printed_event_counts']=={}
old=read('previous-preview-phases.json')
assert old['phases'][0]['printed_event_counts']=={'gyro':31,'exposure':47,'frame_update':47}
assert read('worker-validation.json')['passed']
functions=read('focused/functions.json')+read('timing-focused/functions.json')+read('clock-focused/functions.json')
assert len(functions)==16 and all(f['decompile_completed'] for f in functions)
second=read('collect-02/session.json')
for key,row in second['files'].items():
    p=HERE/'collect-02'/(key+'.dat')
    assert p.stat().st_size==row['bytes'] and digest(p)==row['sha256']
assert verify(HERE/'collect-02',second['probe'],second['files'],second['result'])==second['verification']
assert second['verification']['tables']['before'][35]==1
worker=second['verification']['worker']
assert worker['status_after']['param']=='Unknown'
logs2=read('native-log-02/session.json');assert logs2['unmounted']
for row in logs2['files']:
    p=HERE/'native-log-02'/row['name']
    assert p.stat().st_size==row['bytes'] and digest(p)==row['sha256']
phase2=analyze(HERE/'native-log-02/RtosActive.log')
saved=read('native-log-02/phases.json');phase2['source']=saved['source']
assert phase2==saved
assert phase2['total_printed_event_counts']=={'gyro':59,'exposure':84,'frame_update':83}
assert len(phase2['phases'])==3 and phase2['unassigned_or_during_mode_init_events']==0
recording=phase2['phases'][1]
assert 'Width=3840, Height=2160' in recording['sensor_geometry']
assert recording['printed_event_counts']=={'gyro':48,'exposure':67,'frame_update':66}
assert recording['gyro_log_tick_delta_histogram']=={'50':47}
summary=read('timing-summary.json')
assert summary['nominal_tick_ms']==1
assert summary['phases'][1]['exposure_prints']==[dict(sample_offset=12,before_exposure_adjustment=20,exposure_raw=16,count=67)]
assert summary['phases'][1]['update_diff_raw_counts']=={'16':13,'17':53}
assert len(summary['file_mentions'])==3 and all(m['file']=='YDXJ0139.MP4' for m in summary['file_mentions'])
download=read('video/download.json');video=HERE/'video'/download['file']
assert video.stat().st_size==download['bytes']==16254590 and digest(video)==download['sha256']
validation=read('video/video-validation.json')
assert validation['completed'] and not validation['error'] and validation['decoded_video_frames']==48
assert (validation['width'],validation['height'])==(1920,1080)
assert 1.601<validation['duration_seconds']<1.602
assert read('recording-files/session.json')['status']['param']=='idle'
assert read('cleanup-02/session.json')['result']['owned_files_removed']
final=read('final-status/session.json')
assert final['status']['param']=='idle' and final['result']['all_probe_paths_absent']
assert final['result']['paths_checked']==16
assert all(final['result'][key]==0 for key in ('temporary_log_mounts','temporary_log_directories','other_transport_files'))
for name in ('collect-02','native-log-02','cleanup-02','final-status'):
    transport=read(name+'/transport.json');assert transport['verified'] and transport['removed']
for name in ('scripts/device_eis_recording_trace.py','scripts/analyze_eis_recording_window.py',
             'sdk/device-probe/native-eis-recording/worker.py'):
    compile((ROOT/name).read_bytes(),name,'exec')
count=0
for p in (ROOT/'README.md',ROOT/'docs/device-eis-recording-trace.md',HERE/'README.md'):
    for link in re.findall(r'\]\(([^)]+)\)',p.read_text()):
        if '://' in link or link.startswith('#'):continue
        assert (p.parent/link.split('#')[0]).exists(),(p,link)
        count+=1
result=dict(passed=True,scope='Retained files only; no camera access',
            first_gate_passed=True,first_recording=False,first_native_table_unchanged=True,
            first_probe_removed=True,second_runtime_verified=True,second_probe_removed=True,
            second_recording_mode_counts=recording['printed_event_counts'],decoded_video_frames=48,
            common_gyro_log_timer_static_chain_retained=True,
            simulated_worker_checks=True,focused_exports=16,local_links=count)
(HERE/'findings.json').write_text(json.dumps(dict(
    firmware='Z16V13L_1.10.7_a8f840ce_r2746',native_conditional_runtime_verified=True,
    api_ready_gate_verified=True,complete_debug_table_restored=True,
    recording_phase_counts=recording['printed_event_counts'],nominal_common_tick_ms=1,
    nominal_tick_scope='Static timer configuration; not oscillator/exposure/IMU timestamp calibration',
    video=download,decoded_video_frames=48,cleanup_verified=True,final_status='idle',
    arbitrary_arm_code_execution_verified=False,lossless_imu_stream_recovered=False,
    video_frame_gyro_alignment_recovered=False,algorithm_changed=False,
    jelly_improvement_measured=False),indent=2)+'\n')
(HERE/'offline-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
