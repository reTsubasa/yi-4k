#!/usr/bin/env python3
"""Run the explicitly approved two-line stock-entry plan; no reboot command.

Review source travels through an acknowledged shell environment, never an extra
target script file. Only the pinned review operation creates/removes target files.
"""
import argparse
import base64
import datetime
import hashlib
import json
from pathlib import Path
import re
import shlex

from device_linux_capture import Telnet
from device_readiness_baseline import api_snapshot

ROOT=Path(__file__).resolve().parents[1]
BUNDLE=ROOT/'artifacts/verification/2026-11-12-stock-entry-acceptance-plan-final'
ENV='YI4K_STOCK_REVIEW_SOURCE_B64'
PLAN_SHA='ac6556f1d69aa7364c8c2f51ad2d6a3f576a3fafdf1e6d13a3400c59fd0fa83a'


def sha(data):return hashlib.sha256(data).hexdigest()


def transfer_commands(source):
    data=source.encode('utf-8');encoded=base64.b64encode(data).decode('ascii')
    commands=[('export '+ENV+"=''",None)]
    for offset in range(0,len(encoded),384):
        chunk=encoded[offset:offset+384]
        command='export '+ENV+'="${'+ENV+'}'+chunk+'"'
        command+='\npython -c '+shlex.quote("import os;print('YI_STOCK_CHUNK '+str(len(os.environ['"+ENV+"'])))")
        commands.append((command,'YI_STOCK_CHUNK '+str(min(offset+384,len(encoded)))))
    code="import os,base64,hashlib;s=base64.b64decode(os.environ['"+ENV+"']);assert hashlib.sha256(s).hexdigest()=='"+sha(data)+"';exec(compile(s,'<approved-stock-review>','exec'))"
    commands.append(('python -B -u -c '+shlex.quote(code),None))
    assert all(max(map(len,c.splitlines()))<900 for c,_ in commands)
    return commands


def in_memory(camera,source,output):
    receipt={'source_bytes':len(source.encode()),'source_sha256':sha(source.encode()),
             'target_script_file_uploaded':False,'chunk_acknowledgements':[]}
    raw=''
    try:
        commands=transfer_commands(source)
        for index,(command,ack) in enumerate(commands):
            raw=camera.command(command,timeout=25 if index==len(commands)-1 else 8)
            if ack:
                assert ack in raw.splitlines(),'source transfer acknowledgement missing'
                receipt['chunk_acknowledgements'].append(ack)
        return raw
    finally:
        try:
            receipt['environment_cleared']='YI_STOCK_ENV_CLEARED' in camera.command(
                'unset '+ENV+' YI4K_EXPECTED_STAGE_BOOT_ID YI4K_STOCK_ENTRY_COLLECT_JSON\nprintf "YI_STOCK_ENV_CLEARED\\n"',timeout=8).splitlines()
        except Exception as e:receipt['clear_error']=repr(e)
        (output/'transport.json').write_text(json.dumps(receipt,indent=2)+'\n')


def parse(raw,prefix):
    rows=[line[len(prefix):] for line in raw.splitlines() if line.startswith(prefix)]
    assert len(rows)==1,'operation did not produce one confirmed result'
    return json.loads(rows[0])


def check_api(value):
    assert value['status'].get('param') in ('idle','vf'),'camera not idle/vf'
    settings=value['settings']
    assert settings['sw_version']=='Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746',settings
    assert settings['hw_version']=='YDXJ2_V13LW',settings
    assert settings['sd_card_status']=='insert',settings


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('action',choices=['preflight','stage','collect','disarm','cleanup'])
    p.add_argument('--host',default='192.168.42.1');p.add_argument('--output',type=Path,required=True)
    p.add_argument('--preflight',type=Path);p.add_argument('--cleanup-input',type=Path)
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    plan=json.loads((BUNDLE/'plan.json').read_text())
    assert sha((BUNDLE/'plan.json').read_bytes())==PLAN_SHA
    dry=json.loads((BUNDLE/'dry-run.json').read_text())
    for name,digest in dry['bundle_file_sha256'].items():assert sha((BUNDLE/name).read_bytes())==digest,name
    session={'action':a.action,'host':a.host,'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
             'api_events':[],'plan_sha256':PLAN_SHA,'reboot_requested':False,'firmware_or_RAM_write':False,
             'extra_target_script_file_uploaded':False,'script_sha256':sha(Path(__file__).read_bytes())}
    camera=None
    try:
        session['before']=api_snapshot(a.host,session['api_events']);check_api(session['before'])
        camera=Telnet(a.host);camera.login()
        if a.action=='preflight':
            source="import os,json,stat\npaths="+repr(plan['paths'])+"\nr={}\nfor k,p in paths.items():\n r[k]={'present':os.path.lexists(p)}\n if r[k]['present']: r[k]['mode']=os.lstat(p).st_mode\nmounts=open('/proc/mounts').read().splitlines()\nsd=[x for x in mounts if len(x.split())>=4 and x.split()[1]=='/tmp/SD0']\nassert len(sd)==1 and sd[0].split()[:3]==['c:','/tmp/SD0','ambafs'] and 'rw' in sd[0].split()[3].split(',')\nassert not os.path.islink('/tmp/SD0') and os.path.isdir('/tmp/SD0')\nassert all(not x['present'] for x in r.values()),'Refuse existing plan namespace'\nprint('YI_STOCK_PREFLIGHT '+json.dumps({'boot_id':open('/proc/sys/kernel/random/boot_id').read().strip(),'uptime':open('/proc/uptime').read().strip(),'mount':sd[0],'paths':r}))\n"
        else:
            source=(BUNDLE/('review-'+a.action+'.py')).read_text()
            if a.action=='stage':
                assert a.preflight,'stage requires exact preflight session'
                previous=json.loads(a.preflight.read_text());assert previous['action']=='preflight' and previous['host']==a.host
                assert previous['confirmed'] and previous['before']==previous['after']
                boot=previous['result']['boot_id'];assert re.fullmatch('[0-9a-f-]{36}',boot)
                assert previous['after']['settings']==session['before']['settings'],'settings changed since preflight'
                camera.command('export YI4K_EXPECTED_STAGE_BOOT_ID='+shlex.quote(boot),timeout=8)
                session['preflight_source']=str(a.preflight);session['preflight_sha256']=sha(a.preflight.read_bytes())
            elif a.action=='cleanup':
                assert a.cleanup_input,'cleanup requires locally archived input'
                data=a.cleanup_input.read_text();binding=json.loads(data)
                assert binding['archived_and_hash_verified'] and binding['identifier']==plan['identifier']
                # Carry the approved cleanup binding inside the already hashed source.
                source="import os,base64\nos.environ['YI4K_STOCK_ENTRY_COLLECT_JSON']=base64.b64decode("+repr(base64.b64encode(data.encode()).decode())+").decode('ascii')\n"+source
        (a.output/'executed-source.py').write_text(source)
        raw=in_memory(camera,source,a.output)
        (a.output/'raw-output.txt').write_text(raw)
        session['result']=parse(raw,'YI_STOCK_PREFLIGHT ' if a.action=='preflight' else 'YI_STOCK_ENTRY ')
        if a.action!='preflight':assert session['result']['action']==a.action
        if a.action=='stage':assert session['result'].get('created_exclusively') and not session['result'].get('error')
        (a.output/'result.json').write_text(json.dumps(session['result'],indent=2)+'\n')
        camera.close();camera=None
        session['after']=api_snapshot(a.host,session['api_events']);check_api(session['after'])
        assert session['after']==session['before'],'API baseline changed during operation'
        session['confirmed']=True
        print(json.dumps({'action':a.action,'confirmed':True,'result':session['result']},ensure_ascii=False))
    except BaseException as e:
        session['confirmed']=False;session['error']=repr(e)
        if camera is not None:(a.output/'partial-output.txt').write_bytes(bytes(camera.buffer))
        raise
    finally:
        if camera is not None:camera.close()
        session['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
        (a.output/'session.json').write_text(json.dumps(session,ensure_ascii=False,indent=2)+'\n')


if __name__=='__main__':main()
