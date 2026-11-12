#!/usr/bin/env python3
"""Run existing instrumentation on a project-owned headless Android AVD.

Never installs to physical devices. AVD state lives under .tools, and only the
emulator process launched here is stopped. The SDK image must already exist.
"""
import argparse
import datetime
import hashlib
import json
import os
import re
from pathlib import Path
import shutil
import socket
import subprocess
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sdk', type=Path, default=Path('/Users/hyc/Library/Android/sdk'))
    parser.add_argument('--java', type=Path, default=Path('/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home'))
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--apk', type=Path, default=ROOT / 'artifacts/android/yi4k-control-debug.apk')
    parser.add_argument('--test-apk', type=Path, default=ROOT / 'android/app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk',
                        help='Use an archived test APK without restoring Gradle build caches')
    parser.add_argument('--discard-avd-on-success', action='store_true',
                        help='After passing and stopping this owned AVD, archive its ini configuration and remove its regenerable runtime disks; failures retain the AVD')
    parser.add_argument('--expected-tests', type=int, default=7, help='Exact completed test count; in pending-process-death mode use 2 for prepare/verify phases (prepare is intentionally interrupted)')
    parser.add_argument('--large-original-export', action='store_true', help='Local-only >4 GiB HTTP/MediaStore export and >2 GiB cancellation on a separate 8 GiB AVD')
    parser.add_argument('--pending-process-death', action='store_true', help='Local-only two-stage interrupted MediaStore export recovery; force-stops only this app on the owned AVD')
    parser.add_argument('--pending-clean-staged-fixture', action='store_true', help='Explicit local-only preflight: archive and clean exact fixtures from a prior interrupted pending-process-death test')
    parser.add_argument('--test-class', default='dev.yi4k.control.CameraLogicInstrumentationTest,dev.yi4k.control.VideoEditDeviceTest,dev.yi4k.control.MediaStoreDeviceTest,dev.yi4k.control.VideoEditorWorkflowDeviceTest')
    parser.add_argument('--camera-media-host', help='Explicit real-camera media API/export test; no recording; VF only with --camera-main-preview')
    parser.add_argument('--camera-main-preview', action='store_true', help='Use MainActivity connection/preview/release UI with --camera-media-host; permits owned VF start/stop only')
    parser.add_argument('--camera-preview-orientation', choices=('portrait', 'landscape'), default='portrait', help='Initial real MainActivity preview orientation; requires --camera-main-preview for landscape')
    parser.add_argument('--camera-control-host', help='Explicit camera UI capture/config test; creates short recording/photo and restores settings')
    parser.add_argument('--capture-record-seconds', type=int, default=3, help='Explicit control workflow duration, 3..65 seconds')
    parser.add_argument('--capture-resolution', help='Explicit advertised video_resolution value for control workflow; restore original afterward')
    parser.add_argument('--expect-unsupported-eis', action='store_true', help='Assert actual unsupported EIS readback and capture UI; requires explicit control resolution')
    parser.add_argument('--camera-media-path', action='append', help='Existing /tmp/fuse_d/DCIM/<folder>/<file>.MP4 or .JPG; specify video and photo')
    parser.add_argument('--camera-host', help='Explicit ordinary camera VF/RTSP check; no recordings or target files')
    args = parser.parse_args()
    if args.large_original_export and (args.camera_host or args.camera_media_host or args.camera_control_host
            or args.pending_process_death or args.test_class != 'dev.yi4k.control.LargeOriginalExportDeviceTest'
            or args.expected_tests != 2):
        parser.error('Large original export requires local-only LargeOriginalExportDeviceTest and --expected-tests 2')
    if args.test_class.startswith('dev.yi4k.control.LargeOriginalExportDeviceTest') and not args.large_original_export:
        parser.error('Large original export requires explicit --large-original-export storage/workload mode')
    for artifact in (args.apk, args.test_apk):
        if not artifact.is_file():
            parser.error('APK does not exist: ' + str(artifact))
    if args.pending_clean_staged_fixture and not args.pending_process_death:
        parser.error('--pending-clean-staged-fixture requires --pending-process-death')
    if sum(bool(host) for host in (args.camera_host,args.camera_media_host,args.camera_control_host))>1:
        parser.error('Use preview, read-only media or control mode separately')
    if args.pending_process_death and (args.camera_host or args.camera_media_host or args.camera_control_host
            or args.test_class not in ('dev.yi4k.control.PendingOriginalExportsDeviceTest', 'dev.yi4k.control.PendingEditedExportsDeviceTest') or args.expected_tests != 2):
        parser.error('Pending process death requires a local-only pending-export test class and --expected-tests 2')
    if args.camera_media_path and not (args.camera_media_host or args.camera_control_host):
        parser.error('--camera-media-path requires --camera-media-host or --camera-control-host')
    if args.camera_main_preview and (not args.camera_media_host or args.test_class!='dev.yi4k.control.CameraMainPreviewWorkflowDeviceTest' or args.expected_tests!=1):
        parser.error('--camera-main-preview requires --camera-media-host, CameraMainPreviewWorkflowDeviceTest and --expected-tests 1')
    if args.test_class=='dev.yi4k.control.CameraMainPreviewWorkflowDeviceTest' and not args.camera_main_preview:
        parser.error('MainActivity preview requires explicit --camera-main-preview ownership/recovery mode')
    if args.camera_preview_orientation!='portrait' and not args.camera_main_preview:
        parser.error('--camera-preview-orientation landscape requires --camera-main-preview')
    if args.camera_control_host and args.test_class!='dev.yi4k.control.CameraCaptureWorkflowDeviceTest':
        parser.error('Control mode requires the explicit CameraCaptureWorkflowDeviceTest class')
    if not 3 <= args.capture_record_seconds <= 65:
        parser.error('Capture duration must be between 3 and 65 seconds')
    if not args.camera_control_host and (args.capture_resolution or args.capture_record_seconds!=3):
        parser.error('Capture duration/resolution require explicit --camera-control-host')
    if args.capture_resolution and not re.fullmatch(r'[0-9]{3,4}x[0-9]{3,4} [0-9]{2,3}P [0-9]+:[0-9]+(?: super)?',args.capture_resolution):
        parser.error('Expected a literal camera video_resolution scalar, no shell syntax')
    if args.expect_unsupported_eis and not (args.camera_control_host and args.capture_resolution):
        parser.error('--expect-unsupported-eis requires control workflow with explicit resolution')
    camera_target_host=args.camera_media_host or args.camera_control_host
    camera_evidence_key='camera_control' if args.camera_control_host else ('camera_preview' if args.camera_main_preview else 'camera_media')
    control_run_id=str(uuid.uuid4()) if args.camera_control_host else None
    preview_run_id=str(uuid.uuid4()) if args.camera_main_preview else None
    image = args.sdk / 'system-images/android-34/default/arm64-v8a'
    if not (image / 'system.img').is_file() or not (image / 'package.xml').is_file():
        raise RuntimeError('Complete AOSP Android 34 arm64 system image is required')
    args.output.mkdir(parents=True, exist_ok=False)
    args.output = args.output.resolve()
    avd_home = ROOT / '.tools/android-emulator'
    avd_home.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, JAVA_HOME=str(args.java), ANDROID_HOME=str(args.sdk),
               ANDROID_SDK_ROOT=str(args.sdk), ANDROID_AVD_HOME=str(avd_home))
    name = 'yi4k-large-export-api34' if args.large_original_export else 'yi4k-acceptance-api34'
    port = 5582
    serial = f'emulator-{port}'
    adb = str(args.sdk / 'platform-tools/adb')
    report = {'started_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'scope': ('headless Android AVD with real MainActivity connection/owned VF/RTSP and player release; no camera files/config writes or physical phone'
                        if args.camera_main_preview else ('headless Android AVD with explicit real camera VF/RTSP; no physical phone'
                        if args.camera_host else ('headless Android AVD with real camera read-only media API/HTTP; no physical phone'
                        if args.camera_media_host else ('headless Android AVD with real camera UI configuration/short recording/photo and recovery; no physical phone'
                        if args.camera_control_host else 'headless Android AVD only; no physical phone or camera access')))),
              'serial': serial, 'commands': [], 'emulator_stopped': False}
    process = None
    log = None
    camera = None
    owns_vf = False
    media_manifest = None
    camera_baseline = None

    def media_snapshot(label):
        from device_eis_live_capture import CameraAPI, SETTINGS
        from device_linux_capture import Telnet
        import shlex
        events=[]
        session=CameraAPI(camera_target_host,events)
        try:
            session.open_session()
            state=session.call(1,type='app_status')
            settings=session.call(3)
            if state.get('rval')!=0 or state.get('param') not in ('idle','vf'):
                raise RuntimeError('Camera must be idle/VF for media/control snapshot')
            if settings.get('rval')!=0:raise RuntimeError('Cannot read settings')
            selected={k:v for row in settings['param'] for k,v in row.items() if k in SETTINGS}
            stable={k:v for row in settings['param'] for k,v in row.items()
                    if k not in ('camera_clock','app_status','precise_self_remain_time')}
            if (args.camera_control_host or args.camera_main_preview) and label=='before' and (state.get('param')!='idle' or selected.get('system_mode')!='record'):
                raise RuntimeError('Control/MainActivity preview workflow requires initial idle/record; no automatic baseline changes')
            if not selected.get('sw_version','').startswith('Z16V13L_1.10.7_'):
                raise RuntimeError('Unexpected firmware identity')
            paths=args.camera_media_path or ['/tmp/fuse_d/DCIM/100MEDIA/YDXJ0140.MP4','/tmp/fuse_d/DCIM/100MEDIA/YDXJ0141.JPG']
            if len(paths)!=2 or not any(p.upper().endswith('.MP4') for p in paths) or not any(p.upper().endswith(('.JPG','.JPEG')) for p in paths):
                raise RuntimeError('Provide exactly one existing video and one photo')
            for path in paths:
                if not re.fullmatch(r'/tmp/fuse_d/DCIM/[A-Za-z0-9_-]+/[A-Za-z0-9_-]+[.](?:MP4|JPG|JPEG)',path,re.IGNORECASE):
                    raise RuntimeError('Unexpected media path')
            folders=sorted({'/tmp/fuse_d/DCIM/'}|{p.rsplit('/',1)[0]+'/' for p in paths})
            listings={}
            for folder in folders:
                reply=session.call(1282,param=folder)
                if reply.get('rval')!=0 or reply.get('total',0)>len(reply.get('listing',[])):
                    raise RuntimeError('Incomplete media listing')
                listings[folder]={k:v for row in reply['listing'] for k,v in row.items()}
                if args.camera_control_host and folder=='/tmp/fuse_d/DCIM/':
                    for name in listings[folder]:
                        if name.endswith('/'):
                            if not re.fullmatch(r'[A-Za-z0-9_-]+/',name):raise RuntimeError('Unexpected DCIM subdirectory')
                            nested=folder+name
                            if nested not in folders:folders.append(nested)
                    if len(folders)>33:raise RuntimeError('DCIM directory snapshot bound exceeded')
        finally:session.close()
        listed_bytes=0
        for path in paths:
            folder,name=path.rsplit('/',1)
            match=re.match(r'([0-9]+) bytes[|]',listings[folder+'/'].get(name,''))
            if not match:raise RuntimeError('Missing listed file size: '+path)
            listed_bytes+=int(match[1])
        client=Telnet(camera_target_host)
        try:
            client.login()
            raw=client.command('sha256sum '+ ' '.join(shlex.quote(p) for p in paths),
                               timeout=120 if listed_bytes>128*1024**2 else 40)
            (args.output/(label+'-target-sha256.txt')).write_text(raw)
            hashes={path:digest for digest,path in re.findall(r'^([a-f0-9]{64})  (/[A-Za-z0-9_./-]+)$',raw,re.MULTILINE)}
            boot=client.command('cat /proc/sys/kernel/random/boot_id')
            (args.output/(label+'-boot-id.txt')).write_text(boot)
            boot_id=re.findall(r'^[a-f0-9-]{36}$',boot,re.MULTILINE)
            if len(boot_id)!=1:raise RuntimeError('Missing camera boot identity')
            if args.camera_control_host and label=='before':
                # Query filesystem bytes directly; don't guess API msg5 units.
                free=client.command("python -c 'import os; s=os.statvfs(\"/tmp/fuse_d\"); print(s.f_bavail*s.f_frsize)'")
                (args.output/'before-free-space.txt').write_text(free)
                free_bytes=re.findall(r'^([0-9]+)\r?$',free,re.MULTILINE)
                if len(free_bytes)!=1:raise RuntimeError('Missing unambiguous SD filesystem free byte count')
                required=(2 if args.capture_record_seconds>=30 else 1)*1024**3
                report[camera_evidence_key]['free_bytes_before']=int(free_bytes[0])
                if int(free_bytes[0])<required:raise RuntimeError('Insufficient SD free space for bounded capture acceptance')
        finally:client.close()
        manifest=[]
        for path in paths:
            folder,name=path.rsplit('/',1);info=listings[folder+'/'].get(name,'')
            match=re.match(r'([0-9]+) bytes[|]',info)
            if not match or path not in hashes:raise RuntimeError('Missing file size/hash: '+path)
            manifest.append({'path':path,'name':name,'bytes':int(match[1]),'sha256':hashes[path]})
        snapshot={'status':state,'settings':selected,'stable_settings':stable,'listings':listings,'files':manifest,'boot_id':boot_id[0],'api_events':events}
        report.setdefault(camera_evidence_key,{})[label]=snapshot
        return snapshot

    def recover_control_viewfinder_and_owned_recording():
        from device_eis_live_capture import CameraAPI
        events=[];session=CameraAPI(camera_target_host,events)
        recovery={'api_events':events};report[camera_evidence_key]['recovery']=recovery
        try:
            session.open_session()
            state=session.call(1,type='app_status')
            log_path=args.output/'instrumentation.log'
            log_text=log_path.read_text(errors='replace') if log_path.exists() else ''
            started='INSTRUMENTATION_STATUS: capture_record_started='+control_run_id in log_text
            stop_requested='INSTRUMENTATION_STATUS: capture_record_stop_requested='+control_run_id in log_text
            stopped='INSTRUMENTATION_STATUS: capture_record_stopped='+control_run_id in log_text
            recovery.update({'status_before':state,'run_id':control_run_id,'confirmed_started':started,
                             'stop_already_requested':stop_requested,'confirmed_stopped':stopped})
            if state.get('param')=='record' and stop_requested and not stopped:
                recovery['stop_retry_skipped']='Prior STOP outcome uncertain; only read-only state checks permitted'
                deadline=time.monotonic()+15
                while time.monotonic()<deadline:
                    state=session.call(1,type='app_status')
                    if state.get('param') in ('idle','vf'):break
                    time.sleep(.25)
            if state.get('param')=='record' and started and not stop_requested and not stopped:
                recovery['stop_owned_recording']=session.call(514)
                if recovery['stop_owned_recording'].get('rval')!=0:raise RuntimeError('Owned recording cleanup rejected')
                deadline=time.monotonic()+15
                while time.monotonic()<deadline:
                    state=session.call(1,type='app_status')
                    if state.get('param') in ('idle','vf'):break
                    time.sleep(.25)
            if state.get('param')=='vf' and camera_baseline['status'].get('param')=='idle':
                recovery['stop_workflow_viewfinder']=session.call(260)
                if recovery['stop_workflow_viewfinder'].get('rval')!=0:raise RuntimeError('VF cleanup rejected')
            recovery['status_after']=session.call(1,type='app_status')
            if recovery['status_after'].get('param')!='idle':
                raise RuntimeError('Control workflow not idle; unknown recording ownership will not be guessed')
        finally:session.close()

    def recover_main_preview_viewfinder():
        from device_eis_live_capture import CameraAPI
        events=[];session=CameraAPI(camera_target_host,events)
        recovery={'api_events':events,'run_id':preview_run_id}
        report[camera_evidence_key]['recovery']=recovery
        log_path=args.output/'instrumentation.log'
        log_text=log_path.read_text(errors='replace') if log_path.exists() else ''
        owned='INSTRUMENTATION_STATUS: preview_owned_vf_started='+preview_run_id in log_text
        recovery['confirmed_owned_preview']=owned
        try:
            session.open_session()
            state=session.call(1,type='app_status');recovery['status_before']=state
            if state.get('param')=='vf' and camera_baseline['status'].get('param')=='idle' and owned:
                recovery['stop_owned_viewfinder']=session.call(260)
                if recovery['stop_owned_viewfinder'].get('rval')!=0:raise RuntimeError('Owned preview cleanup rejected')
            recovery['status_after']=session.call(1,type='app_status')
            if recovery['status_after'].get('rval')!=0 or recovery['status_after'].get('param')!='idle':
                raise RuntimeError('Preview workflow not idle; unconfirmed VF/recording ownership will not be guessed')
        finally:session.close()

    def command(argv, name, timeout=60, input=None, check=True):
        try:
            result = subprocess.run(argv, input=input, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                    env=env, timeout=timeout)
        except subprocess.TimeoutExpired as error:
            # Preserve already-confirmed capture ownership even if adb never completes.
            (args.output / name).write_bytes(error.stdout or b'')
            report['commands'].append({'argv': argv, 'returncode': None, 'output': name, 'timeout_seconds': timeout})
            raise
        (args.output / name).write_bytes(result.stdout)
        report['commands'].append({'argv': argv, 'returncode': result.returncode, 'output': name})
        if check and result.returncode != 0:
            raise RuntimeError(f'{name} failed: {result.stdout[-1500:].decode(errors="replace")}')
        return result

    try:
        # Reject an occupied console or ADB port instead of targeting another instance.
        for number in (port, port + 1):
            with socket.socket() as probe:
                # Closed ADB sockets may remain in TIME_WAIT between runs.
                # This still rejects a listener already occupying the same address.
                probe.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                probe.bind(('127.0.0.1', number))
        avd_ini = avd_home / (name + '.ini')
        if not avd_ini.exists():
            # Explicit AVD config avoids an old avdmanager rejecting new SDK XML.
            avd = avd_home / (name + '.avd')
            avd.mkdir(exist_ok=False)
            (avd / 'config.ini').write_text('\n'.join([
                f'AvdId={name}', f'avd.ini.displayname={name}', 'avd.ini.encoding=UTF-8',
                'abi.type=arm64-v8a', 'hw.cpu.arch=arm64',
                f'image.sysdir.1={image.resolve()}/', 'tag.id=default',
                'hw.lcd.width=1080', 'hw.lcd.height=1920', 'hw.lcd.density=420',
                'hw.gpu.enabled=yes', 'hw.gpu.mode=swiftshader', 'hw.ramSize=2048',
                'hw.keyboard=yes', 'hw.mainKeys=no',
                'disk.dataPartition.size=8G' if args.large_original_export else 'disk.dataPartition.size=2G',
                'showDeviceFrame=no', 'fastboot.forceColdBoot=yes', 'PlayStore.enabled=false', '']))
            avd_ini.write_text(f'avd.ini.encoding=UTF-8\npath={avd}\ntarget=android-34\n')
        log = (args.output / 'emulator.log').open('wb')
        argv = [str(args.sdk / 'emulator/emulator'), '-avd', name, '-port', str(port),
                '-no-window', '-no-audio', '-no-boot-anim', '-no-snapshot',
                '-gpu', 'swiftshader', '-memory', '2048', '-cores', '2']
        process = subprocess.Popen(argv, env=env, stdout=log, stderr=subprocess.STDOUT)
        report.update({'emulator_pid': process.pid, 'emulator_argv': argv})
        print(f'Launched own AVD pid={process.pid} serial={serial}', flush=True)
        deadline = time.monotonic() + 240
        while time.monotonic() < deadline:
            if process.poll() is not None:
                raise RuntimeError('Emulator exited before boot; inspect emulator.log')
            boot = subprocess.run([adb, '-s', serial, 'shell', 'getprop', 'sys.boot_completed'],
                                  env=env, capture_output=True, timeout=8)
            if boot.returncode == 0 and boot.stdout.strip() == b'1':
                break
            time.sleep(3)
        else:
            raise TimeoutError('Android boot did not complete within 240 seconds')
        print('Android boot complete', flush=True)
        command([adb, '-s', serial, 'shell', 'getprop'], 'android-properties.txt')
        apk = args.apk.resolve()
        test_apk = args.test_apk.resolve()
        report['apks'] = [{'path': str(p), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                          for p in (apk, test_apk)]
        command([adb, '-s', serial, 'install', '-r', str(apk)], 'install-app.log')
        command([adb, '-s', serial, 'install', '-r', str(test_apk)], 'install-tests.log')
        command([adb, '-s', serial, 'logcat', '-c'], 'logcat-clear.log')
        # The managed AVD persists between runs; don't attribute old screenshots to this run.
        command([adb, '-s', serial, 'shell', 'rm', '-rf',
                 '/sdcard/Android/data/dev.yi4k.control/files/acceptance-screens'],
                'workflow-screens-clear.log')
        extra_args=[]
        if camera_target_host:
            report[camera_evidence_key]={'target_files_written':None if args.camera_control_host else False,
                                         'recording_requested':None if args.camera_control_host else False,
                                         'settings_changed':None if args.camera_control_host else False,'memory_mapping_run':False}
            if args.camera_control_host:report[camera_evidence_key]['run_id']=control_run_id
            if args.camera_main_preview:
                report[camera_evidence_key].update({'run_id':preview_run_id,'owned_viewfinder_start_stop_permitted':True,
                                                  'requested_orientation':args.camera_preview_orientation})
            before=media_snapshot('before')
            camera_baseline=before
            media_manifest=before['files']
            extra_args=['-e','yi4k_camera_host',camera_target_host,'-e','yi4k_media_manifest',__import__('shlex').quote(json.dumps(media_manifest,separators=(',',':')))]
            if args.camera_control_host:
                extra_args+=['-e','yi4k_camera_control','true','-e','yi4k_control_run_id',control_run_id,
                             '-e','yi4k_record_seconds',str(args.capture_record_seconds)]
                if args.capture_resolution:extra_args+=['-e','yi4k_capture_resolution',__import__('shlex').quote(args.capture_resolution)]
                if args.expect_unsupported_eis:extra_args+=['-e','yi4k_expect_unsupported_eis','true']
            if args.camera_main_preview:
                extra_args+=['-e','yi4k_preview_run_id',preview_run_id,
                             '-e','yi4k_preview_orientation',args.camera_preview_orientation]
        if args.camera_host:
            from device_eis_live_capture import CameraAPI, SETTINGS
            camera_report={'api_events':[], 'target_files_written':False, 'recording_requested':False,
                           'settings_changed':False, 'memory_mapping_run':False}
            report['camera']=camera_report
            camera=CameraAPI(args.camera_host,camera_report['api_events']);camera.open_session()
            replies=[e['message'] for e in camera_report['api_events'] if e['direction']=='receive' and e['message'].get('msg_id')==257]
            url=replies[-1].get('rtsp','')
            from urllib.parse import urlsplit
            if urlsplit(url).scheme!='rtsp' or urlsplit(url).hostname!=args.camera_host:
                raise RuntimeError('Unexpected camera-advertised RTSP URL')
            camera_report['status_before']=camera.call(1,type='app_status')
            state=camera_report['status_before']
            if state.get('rval')!=0 or state.get('param') not in ('idle','vf'):
                raise RuntimeError('Camera must be idle/VF before explicit preview test')
            settings=camera.call(3)
            camera_report['settings_before']={k:v for row in settings['param'] for k,v in row.items() if k in SETTINGS}
            if not camera_report['settings_before'].get('sw_version','').startswith('Z16V13L_1.10.7_'):
                raise RuntimeError('Unexpected firmware identity')
            if state['param']=='idle':
                owns_vf=True;camera_report['vf_start']=camera.call(259)
                if camera_report['vf_start'].get('rval')!=0:raise RuntimeError('START_VF rejected')
            extra_args=['-e','yi4k_rtsp_url',url]
        # Large original exports also include Android SHA and decode work. Keep
        # a finite budget based on independently listed source bytes.
        instrumentation_timeout=240 if args.camera_control_host or args.camera_main_preview else 120
        if args.large_original_export:
            instrumentation_timeout=900
            report['large_original_export']={'scope':'generated local HTTP fixture only; actual MediaStore writes, readback and decode; no camera or physical phone',
                                            'avd_data_partition':'8G'}
        if args.camera_media_host and sum(item['bytes'] for item in media_manifest)>128*1024**2:
            instrumentation_timeout=360
        report['instrumentation_timeout_seconds']=instrumentation_timeout
        if args.pending_process_death:
            phases = []
            report['pending_process_death'] = {'scope': 'local HTTP/MediaStore only; exact package force-stop on owned emulator; no camera access', 'phases': phases}
            if args.pending_clean_staged_fixture:
                cleanup = command([adb, '-s', serial, 'shell', 'am', 'instrument', '-w', '-r',
                                   '-e', 'class', args.test_class + '#testCleanPriorStagedFixture',
                                   '-e', 'yi4k_pending_death_stage', 'cleanup',
                                   'dev.yi4k.control.test/android.test.InstrumentationTestRunner'],
                                  'instrumentation-preflight-cleanup.log', timeout=120, check=False)
                cleanup_text = cleanup.stdout.decode(errors='replace')
                cleanup_passed = cleanup.returncode == 0 and re.search(r'OK \(1 tests?\)', cleanup_text) is not None and 'FAILURES' not in cleanup_text
                report['pending_process_death']['prior_fixture_cleanup_passed'] = cleanup_passed
                if not cleanup_passed:
                    raise RuntimeError('Prior staged fixture cleanup failed; do not prepare another run')
            prepare_argv = [adb, '-s', serial, 'shell', 'am', 'instrument', '-w', '-r',
                            '-e', 'class', args.test_class + '#testPrepareInterruptedExport',
                            '-e', 'yi4k_pending_death_stage', 'prepare',
                            'dev.yi4k.control.test/android.test.InstrumentationTestRunner']
            prepare_path = args.output / 'instrumentation-prepare.log'
            with prepare_path.open('wb') as prepare_log:
                preparation = subprocess.Popen(prepare_argv, env=env, stdout=prepare_log, stderr=subprocess.STDOUT)
                try:
                    deadline = time.monotonic() + 120
                    while time.monotonic() < deadline:
                        phase_text = prepare_path.read_text(errors='replace')
                        if 'INSTRUMENTATION_STATUS: pending_process_death_ready=' in phase_text:
                            break
                        if preparation.poll() is not None:
                            raise RuntimeError('Preparation returned before exposing a blocked partial publisher')
                        time.sleep(.1)
                    else:
                        raise TimeoutError('No staged partial publication within 120 seconds')
                    before_stop = command([adb, '-s', serial, 'shell', 'pidof', 'dev.yi4k.control'], 'pending-process-before-stop.txt', check=False)
                    if not before_stop.stdout.strip() or preparation.poll() is not None:
                        raise RuntimeError('Staged publisher process already exited before host force-stop')
                    report['pending_process_death']['process_present_before_force_stop'] = True
                    report['pending_process_death']['prepare_instrumentation_still_running'] = True
                    phases.append({'stage': 'prepare', 'passed': True, 'tests': 0,
                                   'partial_export_ready': True, 'intentionally_interrupted': True})
                    command([adb, '-s', serial, 'shell', 'am', 'force-stop', 'dev.yi4k.control'], 'pending-process-force-stop.log')
                    pid = command([adb, '-s', serial, 'shell', 'pidof', 'dev.yi4k.control'], 'pending-process-after-stop.txt', check=False)
                    if pid.stdout.strip():
                        raise RuntimeError('Target process survived explicit force-stop')
                    report['pending_process_death']['process_absent_after_force_stop'] = True
                    preparation.wait(timeout=15)
                finally:
                    if preparation.poll() is None:
                        preparation.terminate()
                        try: preparation.wait(timeout=5)
                        except subprocess.TimeoutExpired:
                            preparation.kill(); preparation.wait(timeout=5)
                    report['commands'].append({'argv': prepare_argv, 'returncode': preparation.returncode,
                                               'output': prepare_path.name, 'intentionally_interrupted': True})
            result = command([adb, '-s', serial, 'shell', 'am', 'instrument', '-w', '-r',
                              '-e', 'class', args.test_class + '#testVerifyRecoveryAfterProcessDeath',
                              '-e', 'yi4k_pending_death_stage', 'verify',
                              'dev.yi4k.control.test/android.test.InstrumentationTestRunner'],
                             'instrumentation-verify.log', timeout=120, check=False)
            phase_text = result.stdout.decode(errors='replace')
            count = re.search(r'OK \((\d+) tests?\)', phase_text)
            passed = result.returncode == 0 and count is not None and int(count[1]) == 1 and 'FAILURES' not in phase_text
            phases.append({'stage': 'verify', 'passed': passed, 'tests': int(count[1]) if count else 0})
            report['instrumentation_test_count'] = sum(p['tests'] for p in phases)
            report['staged_checks_count'] = len(phases)
            report['instrumentation_passed'] = len(phases) == args.expected_tests and all(p['passed'] for p in phases) and report['instrumentation_test_count'] == 1
        else:
            result = command([adb, '-s', serial, 'shell', 'am', 'instrument', '-w', '-r',
                              '-e','class',args.test_class,*extra_args,
                              'dev.yi4k.control.test/android.test.InstrumentationTestRunner'],
                             'instrumentation.log', timeout=instrumentation_timeout, check=False)
            text = result.stdout.decode(errors='replace')
            count = re.search(r'OK \((\d+) tests?\)', text)
            report['instrumentation_test_count'] = int(count[1]) if count else 0
            report['instrumentation_passed'] = result.returncode == 0 and count is not None and int(count[1]) == args.expected_tests and 'FAILURES' not in text
        command([adb, '-s', serial, 'logcat', '-d', '-v', 'threadtime'], 'logcat.txt')
        command([adb, '-s', serial, 'pull',
                 '/sdcard/Android/data/dev.yi4k.control/files/acceptance-screens',
                 str(args.output / 'workflow-screens')], 'workflow-screens-pull.log', check=False)
        command([adb, '-s', serial, 'shell', 'am', 'start', '-n',
                 'dev.yi4k.control/.MainActivity'], 'launch-app.log')
        time.sleep(2)
        command([adb, '-s', serial, 'exec-out', 'screencap', '-p'], 'main-screen.png')
        command([adb, '-s', serial, 'shell', 'dumpsys', 'activity', 'activities'], 'activities.txt')
        print(json.dumps({'instrumentation_passed': report['instrumentation_passed'],
                          'reports': str(args.output)}), flush=True)
        if not report['instrumentation_passed']:
            raise RuntimeError('Actual Android instrumentation failed; inspect instrumentation.log and logcat.txt')
    except BaseException as error:
        report['error'] = repr(error)
        raise
    finally:
        if process is not None and process.poll() is None:
            # Signal the exact child instead of sending a broad adb/emulator shutdown.
            process.terminate()
            try:
                process.wait(timeout=12)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=5)
        if process is not None:
            report['emulator_returncode'] = process.returncode
            report['emulator_stopped'] = process.poll() is not None
        if log is not None:
            log.close()
        if camera is not None:
            try:
                if owns_vf:
                    report['camera']['vf_stop']=camera.call(260)
                    if report['camera']['vf_stop'].get('rval')!=0:raise RuntimeError('STOP_VF rejected')
                report['camera']['status_after']=camera.call(1,type='app_status')
                settings=camera.call(3)
                report['camera']['settings_after']={k:v for row in settings['param'] for k,v in row.items() if k in SETTINGS}
                report['camera']['status_restored']=report['camera']['status_before']==report['camera']['status_after']
                report['camera']['settings_equal']=report['camera']['settings_before']==report['camera']['settings_after']
                if not report['camera']['status_restored'] or not report['camera']['settings_equal']:
                    report['error']='Camera state was not restored; inspect API events'
            except Exception as cleanup_error:
                report['camera']['cleanup_error']=repr(cleanup_error)
                report['error']='Camera cleanup failed'
            finally:
                try:camera.close()
                except Exception as close_error:report['camera']['close_error']=repr(close_error)
        if camera_baseline is not None:
            try:
                if args.camera_control_host:recover_control_viewfinder_and_owned_recording()
                if args.camera_main_preview:recover_main_preview_viewfinder()
                after=media_snapshot('after')
                before=camera_baseline
                for key in ('status','settings','stable_settings','files','boot_id'):
                    report[camera_evidence_key][key+'_equal']=before[key]==after[key]
                    if before[key]!=after[key]:raise RuntimeError('Camera baseline not restored: '+key)
                if not args.camera_control_host:
                    report[camera_evidence_key]['listings_equal']=before['listings']==after['listings']
                    if before['listings']!=after['listings']:raise RuntimeError('Read-only media listing changed')
                    if args.camera_main_preview:
                        detail_path=args.output/'workflow-screens/camera-main-preview/camera-main-preview.json'
                        detail=json.loads(detail_path.read_text())
                        if detail.get('run_id')!=preview_run_id:raise RuntimeError('Preview evidence run identity mismatch')
                        report[camera_evidence_key]['workflow_complete']=detail.get('complete',False)
                        frames=detail.get('first_frames',[]);releases=detail.get('navigation_releases',[])
                        if report.get('instrumentation_passed'):
                            if not detail.get('complete') or not detail.get('camera_status_restored') or len(frames)!=2 or len(releases)!=2:
                                raise RuntimeError('Missing completed two-round preview/release evidence')
                            for number,(frame,release) in enumerate(zip(frames,releases),1):
                                if (frame.get('round')!=number or release.get('round')!=number
                                    or frame.get('rendered_output_buffers',0)<=0
                                    or frame.get('video_width',0)<=0 or frame.get('video_height',0)<=0
                                    or frame.get('player_identity')!=release.get('player_identity')
                                    or not all(release.get(key) is True for key in ('player_is_released','player_view_player_null','player_view_parent_null','surface_detached_from_window'))):
                                    raise RuntimeError('Actual preview frame/player-release identity mismatch')
                                if (frame.get('orientation')!=args.camera_preview_orientation
                                    or frame.get('window_width',0)<=0 or frame.get('window_height',0)<=0
                                    or (frame['window_width']>frame['window_height'])!=(args.camera_preview_orientation=='landscape')):
                                    raise RuntimeError('Actual preview orientation/window evidence mismatch')
                            if frames[0]['player_identity']==frames[1]['player_identity']:
                                raise RuntimeError('Reopened preview reused released player identity')
                        report[camera_evidence_key]['first_frames']=frames
                        report[camera_evidence_key]['navigation_releases']=releases
                else:
                    added={}
                    for folder,old in before['listings'].items():
                        current=after['listings'].get(folder,{})
                        for name,value in old.items():
                            if name.endswith('/'):
                                if name not in current:raise RuntimeError('Existing media directory removed')
                            elif current.get(name)!=value:raise RuntimeError('Existing media entry changed: '+folder+name)
                    for folder,current in after['listings'].items():
                        for name,value in current.items():
                            if not name.endswith('/') and name not in before['listings'].get(folder,{}):added[folder+name]=value
                    report[camera_evidence_key]['existing_entries_preserved']=True
                    report[camera_evidence_key]['new_entries']=added
                    report[camera_evidence_key]['target_files_written']=bool(added)
                    detail_path=args.output/'workflow-screens/camera-capture/camera-capture.json'
                    if not detail_path.is_file():raise RuntimeError('Missing actual Android camera capture evidence')
                    detail=json.loads(detail_path.read_text())
                    if detail.get('run_id')!=control_run_id:raise RuntimeError('Capture evidence run identity mismatch')
                    new_media=detail.get('new_media',[])
                    report[camera_evidence_key]['recording_requested']=any(e.get('event')=='ui_record_start_requested_once' for e in detail.get('events',[]))
                    report[camera_evidence_key]['settings_changed']=detail.get('quality_changed_readback') is not None
                    if report.get('instrumentation_passed') and (len(new_media)!=2 or not detail.get('complete')):
                        raise RuntimeError('Expected completed two-original capture evidence')
                    if not new_media:
                        report[camera_evidence_key]['capture_completed']=False
                        # Failed/preflight-only runs must still prove baseline recovery.
                        if report.get('instrumentation_passed'):raise RuntimeError('No new captures despite passed test')
                        new_media=[]
                    from device_linux_capture import Telnet
                    import shlex
                    paths=[]
                    for item in new_media:
                        path=item['path']
                        if not re.fullmatch(r'/tmp/fuse_d/DCIM/[A-Za-z0-9_-]+/[A-Za-z0-9_-]+[.](?:MP4|JPG|JPEG)',path,re.IGNORECASE) or path not in added:
                            raise RuntimeError('New capture path is not a new listed original')
                        paths.append(path)
                    if paths:
                        client=Telnet(camera_target_host)
                        try:
                            client.login();raw=client.command('sha256sum '+' '.join(shlex.quote(p) for p in paths),
                                    timeout=120 if sum(item['bytes'] for item in new_media)>128*1024**2 else 40)
                        finally:client.close()
                        (args.output/'new-target-sha256.txt').write_text(raw)
                        hashes={path:digest for digest,path in re.findall(r'^([a-f0-9]{64})  (/[A-Za-z0-9_./-]+)$',raw,re.MULTILINE)}
                        for item in new_media:
                            if item['sha256']!=hashes.get(item['path']):raise RuntimeError('New original differs from camera-side digest')
                        report[camera_evidence_key]['new_capture_hashes_equal']=True
                        report[camera_evidence_key]['capture_completed']=bool(detail.get('complete'))
            except Exception as cleanup_error:
                report[camera_evidence_key]['cleanup_error']=repr(cleanup_error)
                report.setdefault('error','Camera media/control after-state verification failed')
        if args.discard_avd_on_success:
            disposal = {'requested': True, 'removed': False}
            report['avd_disposal'] = disposal
            if report.get('instrumentation_passed') and report.get('emulator_stopped') and 'error' not in report:
                try:
                    avd = avd_home / (name + '.avd')
                    ini = avd_home / (name + '.ini')
                    # Only a known, directly owned project AVD may be removed.
                    if avd.is_symlink() or ini.is_symlink() or avd.resolve().parent != avd_home.resolve():
                        raise RuntimeError('Refusing to discard a redirected AVD path')
                    archive = args.output / 'avd-configurations'
                    archive.mkdir(exist_ok=False)
                    for config in avd.glob('*.ini'):
                        if not config.is_symlink():
                            shutil.copy2(config, archive / config.name)
                    shutil.copy2(ini, archive / ini.name)
                    disposal['allocated_bytes_before'] = sum(p.stat().st_blocks * 512 for p in avd.rglob('*')
                                                            if p.is_file() and not p.is_symlink())
                    shutil.rmtree(avd)
                    ini.unlink()
                    disposal['removed'] = not avd.exists() and not ini.exists()
                except Exception as disposal_error:
                    disposal['error'] = repr(disposal_error)
                    report.setdefault('error', 'AVD runtime disk disposal failed; inspect avd_disposal')
            else:
                disposal['retained_reason'] = 'Failed/incomplete acceptance or unconfirmed emulator exit; retained for diagnosis'
        report['finished_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
        (args.output / 'acceptance.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    if 'error' in report:
        raise RuntimeError(report['error'])


if __name__ == '__main__':
    main()
