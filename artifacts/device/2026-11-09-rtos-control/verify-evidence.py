"""Verify retained native command/debug evidence; no camera access."""
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
from analyze_native_eis_trace import analyze
from device_native_eis_trace import make_spec, program


def read(name):
    return json.loads((HERE/name).read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


scripts=['device_rtos_command_probe.py','device_native_eis_trace.py',
         'device_python_transport.py','device_rtos_log_capture.py','analyze_native_eis_trace.py']
for name in scripts:
    compile((ROOT/'scripts'/name).read_bytes(),name,'exec')
probe=read('native-trace-stage-03/session.json')['probe']
assert json.loads(json.dumps(make_spec(probe['identifier'])))==probe
for action in ('stage','collect','disarm','cleanup'):
    compile(program(action,probe,{}),'<target-'+action+'>','exec')
for key,encoded in probe['payloads'].items():
    assert hashlib.sha256(base64.b64decode(encoded)).hexdigest()==probe['payload_sha256'][key]
command=read('command-probe-collect/session.json')['result']
assert command['owned_files_removed'] and command['begin'] and command['done']
assert command['output_hex']=='0300a0e11eff2fe1'
assert command['output_sha256']=='5e64b91b57eaf124341a5f84484d853cfe5e97bae40e8d7c8bf60c7ed4c6969d'
collected=read('native-trace-collect/session.json')
assert 'Connection refused' in collected['error']
for key,row in collected['files'].items():
    p=HERE/'native-trace-collect'/(key+'.dat')
    assert p.stat().st_size==row['bytes'] and sha(p)==row['sha256']
tables={k:list(struct.unpack('<37H',(HERE/'native-trace-collect'/(k+'.dat')).read_bytes()))
        for k in ('before','active','after')}
assert tables['before']==tables['after'] and tables['before'][35]==1
expected=list(tables['before'])
for i,value in ((14,1),(15,1),(20,1),(22,50)):
    assert expected[i]==0
    expected[i]=value
assert expected==tables['active']
worker=read('native-trace-collect/record.dat')
assert 'Connection refused' in worker['error'] and not worker.get('start_ack')
assert worker['events']==[]
log_session=read('native-trace-log/session.json')
assert log_session['unmounted']
for row in log_session['files']:
    p=HERE/'native-trace-log'/row['name']
    assert p.stat().st_size==row['bytes'] and sha(p)==row['sha256']
trace=analyze(HERE/'native-trace-log/RtosActive.log')
saved=read('native-trace-log/gyro-events.json')
trace['source']=saved['source']
assert trace==saved
assert trace['counts']=={'gyro':31,'exposure':47,'frame_update':47}
assert trace['gyro_log_tick_delta_histogram']=={'50':30}
assert read('previous-log-trace-baseline.json')['counts']=={}
for name,frames,size in (('post-probe-recording',79,23817714),('post-trace-recording',50,16661328)):
    download=read(name+'/download.json')
    video=read(name+'/video-validation.json')
    p=HERE/name/video['file']
    assert p.stat().st_size==download['bytes']==size and sha(p)==download['sha256']
    assert video['completed'] and not video['error'] and video['decoded_video_frames']==frames
    assert (video['width'],video['height'])==(1920,1080)
    session=read(name+'/session.json')
    assert session['record_start_reply']['rval']==session['record_stop_reply']['rval']==0
assert read('native-trace-disarm/session.json')['result']['owned_configuration_removed']
assert read('native-trace-evidence-cleanup/session.json')['owned_files_removed']
final=read('final-status/session.json')
assert final['status']['param'] in ('idle','vf')
assert final['result']['all_11_probe_paths_absent'] and final['result']['temporary_log_mounts']==0
for folder in ('native-trace-stage-03','native-trace-collect','native-trace-disarm',
               'native-trace-log','native-trace-evidence-cleanup','final-status'):
    transport=read(folder+'/transport.json')
    assert transport['verified'] and transport['removed']
functions=sum((read(p+'/functions.json') for p in ('focused','focused-extra')),[])
assert len(functions)==16 and all(row['decompile_completed'] for row in functions)
links=0
for path in (ROOT/'README.md',ROOT/'docs/device-rtos-command-and-gyro-debug.md',HERE/'README.md'):
    for target in re.findall(r'\]\(([^)]+)\)',path.read_text()):
        if '://' in target or target.startswith('#'):continue
        assert (path.parent/target.split('#')[0]).exists(),(path,target)
        links+=1
findings=dict(native_commands_verified=True, debug_table_restored=True,
              trace_counts=trace['counts'],trace_mode='startup preview',
              boot_worker_recording=False,boot_worker_failure='API not listening at uptime 5.54',
              configuration_and_probe_files_removed=True,post_cleanup_video_frames=50,
              arbitrary_arm_execution_verified=False,algorithm_modified=False,
              jelly_improvement_measured=False,software_reboot_scope_proven=False)
(HERE/'findings.json').write_text(json.dumps(findings,ensure_ascii=False,indent=2)+'\n')
result=dict(passed=True,scope='Retained evidence only; video decode result verified, not rerun',
            native_command_probe=True,complete_37_word_restoration=True,
            worker_failure_preserved=True,log_and_video_hashes_verified=True,
            focused_exports=16,local_links=links,python_scripts_compiled=scripts)
(HERE/'offline-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
