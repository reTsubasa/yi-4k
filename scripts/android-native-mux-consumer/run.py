#!/usr/bin/env python3
"""Owned cold Android AVD, standalone local-MP4 platform consumer; no camera IO."""
import argparse,datetime,hashlib,json,os,socket,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
SDK=Path('/Users/hyc/Library/Android/sdk')
JAVA=Path('/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home')
SOURCE=ROOT/'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--candidate',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 a.candidate=a.candidate.resolve();a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
 src=Path(__file__).with_name('NativeMuxConsumer.java');avd_home=ROOT/'.tools/android-emulator';avd_home.mkdir(exist_ok=True)
 env=dict(os.environ,JAVA_HOME=str(JAVA),ANDROID_HOME=str(SDK),ANDROID_SDK_ROOT=str(SDK),ANDROID_AVD_HOME=str(avd_home))
 port=5590;serial=f'emulator-{port}';name='yi4k-native-mux-api34';avd=avd_home/(name+'.avd');adb=str(SDK/'platform-tools/adb')
 report=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),scope='owned new cold AVD; standalone local files only; no camera App/physical device/camera/network requests',
  serial=serial,commands=[],inputs=[dict(path=str(q),bytes=q.stat().st_size,sha256=sha(q)) for q in (SOURCE,a.candidate)],
  sources=[dict(path=str(q),sha256=sha(q)) for q in (Path(__file__),src)],emulator_stopped=False)
 process=None
 def command(argv,name,timeout=120):
  run=subprocess.run(list(map(str,argv)),env=env,capture_output=True,timeout=timeout)
  (a.output/name).write_bytes(run.stdout+run.stderr);report['commands'].append(dict(argv=list(map(str,argv)),returncode=run.returncode,log=name))
  if run.returncode:raise RuntimeError(f'{name}: '+run.stderr[-1500:].decode(errors='replace'))
  return run
 try:
  for number in (port,port+1):
   with socket.socket() as probe:probe.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1);probe.bind(('127.0.0.1',number))
  classes=a.output/'classes';classes.mkdir();dex=a.output/'dex';dex.mkdir()
  command([JAVA/'bin/javac','-source','11','-target','11','-cp',SDK/'platforms/android-34/android.jar','-d',classes,src],'javac.log')
  command([SDK/'build-tools/35.0.0/d8','--lib',SDK/'platforms/android-34/android.jar','--min-api','34','--output',dex,*classes.glob('*.class')],'d8.log')
  if avd.exists():raise RuntimeError('Owned AVD path already exists; preserve it and choose a fresh named run explicitly')
  avd.mkdir();image=SDK/'system-images/android-34/default/arm64-v8a'
  (avd/'config.ini').write_text('\n'.join([f'AvdId={name}',f'avd.ini.displayname={name}','avd.ini.encoding=UTF-8','abi.type=arm64-v8a','hw.cpu.arch=arm64',f'image.sysdir.1={image}/','tag.id=default','hw.lcd.width=1080','hw.lcd.height=1920','hw.lcd.density=420','hw.gpu.enabled=yes','hw.gpu.mode=swiftshader','hw.ramSize=2048','hw.keyboard=yes','hw.mainKeys=no','disk.dataPartition.size=2G','showDeviceFrame=no','fastboot.forceColdBoot=yes','PlayStore.enabled=false','']))
  (avd_home/(name+'.ini')).write_text(f'avd.ini.encoding=UTF-8\npath={avd}\ntarget=android-34\n')
  log=(a.output/'emulator.log').open('wb');argv=[str(SDK/'emulator/emulator'),'-avd',name,'-port',str(port),'-no-window','-no-audio','-no-boot-anim','-no-snapshot','-gpu','swiftshader','-memory','2048','-cores','2']
  process=subprocess.Popen(argv,env=env,stdout=log,stderr=subprocess.STDOUT);report.update(emulator_pid=process.pid,emulator_argv=argv)
  print('launched owned cold AVD '+serial+' pid='+str(process.pid),flush=True)
  deadline=time.monotonic()+240
  while time.monotonic()<deadline:
   if process.poll() is not None:raise RuntimeError('emulator exited before boot')
   boot=subprocess.run([adb,'-s',serial,'shell','getprop','sys.boot_completed'],env=env,capture_output=True,timeout=8)
   if boot.returncode==0 and boot.stdout.strip()==b'1':break
   time.sleep(3)
  else:raise TimeoutError('AVD boot timeout')
  command([adb,'-s',serial,'shell','svc','wifi','disable'],'disable-wifi.log');command([adb,'-s',serial,'shell','svc','data','disable'],'disable-data.log')
  command([adb,'-s',serial,'shell','getprop'],'android-properties.txt')
  device='/data/local/tmp/yi4k_native_mux_20261112';command([adb,'-s',serial,'shell','mkdir',device],'device-mkdir.log')
  for q,name in ((dex/'classes.dex','classes.dex'),(SOURCE,'source.mp4'),(a.candidate,'candidate.mp4')):command([adb,'-s',serial,'push',q,device+'/'+name],'push-'+name+'.log')
  command([adb,'-s',serial,'shell','sha256sum',device+'/source.mp4',device+'/candidate.mp4'],'device-input-sha256.txt')
  for kind in ('source','candidate'):
   print('reading / decoding '+kind,flush=True)
   cmd=f'CLASSPATH={device}/classes.dex app_process /system/bin NativeMuxConsumer {device}/{kind}.mp4 {device}/{kind}.json {kind}'
   command([adb,'-s',serial,'shell',cmd],kind+'-consumer.log',timeout=600)
   command([adb,'-s',serial,'pull',device+'/'+kind+'.json',a.output/(kind+'.json')],'pull-'+kind+'.log')
  report['status']='completed_owned_android_consumer_runs'
 except Exception as error:report.update(status='failed_android_consumer_run',error=str(error));raise
 finally:
  if process is not None:
   if process.poll() is None:
    subprocess.run([adb,'-s',serial,'emu','kill'],env=env,capture_output=True,timeout=15)
    try:process.wait(timeout=25)
    except subprocess.TimeoutExpired:process.terminate();process.wait(timeout=10)
   report['emulator_stopped']=process.poll() is not None
  report['inputs_unchanged']=all(sha(x['path'])==x['sha256'] for x in report['inputs'])
  (a.output/'session.json').write_text(json.dumps(report,indent=2)+'\n')
  print(json.dumps({k:report.get(k) for k in ('status','error','emulator_stopped','inputs_unchanged')}),flush=True)
if __name__=='__main__':main()
