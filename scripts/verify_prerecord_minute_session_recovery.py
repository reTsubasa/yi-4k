#!/usr/bin/env python3
"""Independently validate fixed minute session recovery and negative publication.

Read actual native inputs, recovered output and oracle; do not invoke recovery
or rebuild any file. No camera/device access. This does not authenticate capture
epochs or prove a live prerecord buffer.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess
import traceback
import audit_prerecord_real_gop as g

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'
SOURCE_SHA='7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c'
INPUT=ROOT/'artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01'


def require(ok,message):
    if not ok:raise ValueError(message)


def digest(path):
    with path.open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()


def identity(packets,st):return [p['sha256'] for p in packets if p['stream']==st]


def table_inventory(raw):
    kinds=[];stts=[]
    def walk(start,end):
        for b in g.box_children(raw,start,end):
            kinds.append(b['kind'])
            if b['kind'] in ('moov','trak','mdia','minf','stbl'):
                walk(b['offset']+8,b['offset']+b['size'])
            if b['kind']=='stts':
                p=b['payload'];require(p[0]==0,'version0 STTS required')
                rows=[]
                for i in range(int.from_bytes(p[4:8],'big')):
                    at=8+i*8;rows.append([int.from_bytes(p[at:at+4],'big'),int.from_bytes(p[at+4:at+8],'big')])
                stts.append(rows)
    walk(0,len(raw));return dict(kinds=dict(Counter(kinds)),stts=stts)


def validate(positive,negative):
    script=ROOT/'scripts/recover_prerecord_minute_session.py'
    rebuilder=ROOT/'scripts/recover_prerecord_custody.py'
    record=json.loads((INPUT/'audit.json').read_text());native_packets={0:[],1:[]};config=None
    for item in record['segments']:
        entry=item['native'];path=INPUT/entry['file'];require(digest(path)==entry['sha256'],'native input changed')
        probed=g.probe(path,True);packets=g.packets(probed,path.read_bytes())
        current=[g.extradata(st['extradata']) for st in probed['streams']]
        require(config is None or config==current,'native codec epoch differs');config=current
        for st in (0,1):native_packets[st].extend(p for p in packets if p['stream']==st)
    require([len(native_packets[st]) for st in (0,1)]==[1920,3003],'native input coverage differs')
    require(digest(SOURCE)==SOURCE_SHA,'oracle archive changed')
    selected=g.select_window(g.packets(g.probe(SOURCE),SOURCE.read_bytes()),Fraction(),Fraction(1920*1001,30000))
    require([identity(native_packets[st],st) for st in (0,1)]==[identity(selected,st) for st in (0,1)],'native payload sequence differs from oracle')
    result=[]
    for folder,expected in ((positive,True),(negative,False)):
        if folder is None:continue
        audit=folder/'audit.json';report=json.loads(audit.read_text())
        require(report['script_sha256']==digest(script),'recovery script changed since execution')
        require(report['iso_rebuilder_sha256']==digest(rebuilder),'ISO rebuild code changed since execution')
        require(report['device_access'] is False and report['source_used_for_output'] is False,'unexpected scope flags')
        require(report['injection']['drop_boundary_aac'] is (not expected),'incorrect injection')
        for path,sha in report['input_hashes'].items():require(digest(ROOT/path)==sha,'recorded input hash differs')
        require((folder/'session.mp4').exists()==expected,'release state wrong')
        require((folder/'session.pending.mp4').exists() is (not expected),'pending retention wrong')
        path=folder/('session.mp4' if expected else 'session.pending.mp4')
        require(digest(path)==report['pending_sha256'],'pending/output hash differs')
        raw=path.read_bytes();probe=g.probe(path);actual=g.packets(probe,raw)
        require([g.extradata(st['extradata']) for st in probe['streams']]==config,'codec config changed')
        require([st['time_base'] for st in probe['streams']]==['1/30000','1/48000'],'output clocks wrong')
        expected_audio=list(native_packets[1])
        if not expected:del expected_audio[2815]
        require(identity(actual,0)==identity(native_packets[0],0),'video provenance differs')
        require(identity(actual,1)==identity(expected_audio,1),'audio provenance differs')
        counts={str(st):sum(p['stream']==st for p in actual) for st in (0,1)}
        require(counts=={'0':1920,'1':3003 if expected else 3002},'actual counts wrong')
        tables=table_inventory(raw)
        require(not any(tables['kinds'].get(k,0) for k in ('edts','elst','ctts')),'unexpected edit/reorder metadata')
        require(tables['stts']==[[[1920,1001]],[[3003 if expected else 3002,1024]]],'sample duration table differs')
        if expected:
            require(report['status']=='pass_host_minute_session_recovery_only','positive did not finish')
            strict=g.exact_gate(actual,selected,probe['streams'],Fraction())
            require(strict['status']=='pass','independent strict packet/time gate failed')
            require(report['strict_packet_time_gate']['status']=='pass','recorded positive gate failed')
            frames=g.frame_hashes(path);reference_frames=g.frame_hashes(SOURCE,1920)
            require(frames==reference_frames and len(frames)==1920,'independent video decode differs')
            reference=folder/'oracle-reference.aac'
            require(reference.read_bytes()==b''.join(g.adts(p['data']) for p in selected if p['stream']==1),'reference AAC differs')
            pcm=g.pcm(path);reference_pcm=g.pcm(reference,True)
            require(pcm==reference_pcm and len(pcm)==3003*1024*4,'independent complete AAC PCM differs')
            require(hashlib.sha256(pcm).hexdigest()==report['decode']['pcm_sha256'],'reported PCM hash differs')
            subprocess.run([str(g.s.FFMPEG),'-v','error','-xerror','-i',str(path),'-f','null','-'],check=True,capture_output=True)
            checks=dict(strict_packet_time_gate='pass',video_frames=len(frames),video_frame_md5_sha256=hashlib.sha256('\n'.join(frames).encode()).hexdigest(),
                pcm_bytes=len(pcm),pcm_sha256=hashlib.sha256(pcm).hexdigest(),ffmpeg_xerror_decode='pass')
        else:
            require(report['status']=='rejected_retained_for_recovery','negative not rejected')
            require(report['strict_packet_time_gate']['status']=='reject','negative gate released')
            missing=native_packets[1][2815]
            # Exactly the boundary AAC is omitted; later audio remains shifted
            # on the rebuilt CFR timeline, and publication must be denied.
            require(identity(actual,1)==identity(native_packets[1][:2815]+native_packets[1][2816:],1),'negative omission not exact')
            checks=dict(strict_packet_time_gate='reject',reason='packet count mismatch',released=False,
                missing_native_audio_index=2815,missing_sha256=missing['sha256'],retained_pending=True)
        result.append(dict(audit=str(audit.relative_to(ROOT)),audit_sha256=digest(audit),
            output_file=path.name,output_sha256=digest(path),counts=counts,expected_publication=expected,checks=checks))
    return dict(schema=1,status='pass_independent_minute_recovery_review',device_access=False,
        positive_reviewed=positive is not None,negative_reviewed=negative is not None,
        verifier_sha256=digest(Path(__file__)),recovery_script_sha256=digest(script),iso_rebuilder_sha256=digest(rebuilder),
        native_input_audit_sha256=digest(INPUT/'audit.json'),source_sha256=SOURCE_SHA,cases=result,
        scope='Actual native->output packet provenance, 4923 exact source packets/times, complete frame/PCM decode, and AAC2815 omission refuses release',
        limitations=['Pinned archived zero-origin CFR I/P and AAC fixture only; source epochs are archived caller mappings, not authenticated MP4 capture epochs.',
            'Host container reconstruction only; no live minute ring, physical SD durability, callback installation or deployable prerecord proven.'])


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--positive',type=Path);ap.add_argument('--negative',type=Path)
    ap.add_argument('--output',required=True,type=Path);args=ap.parse_args()
    require(not args.output.exists(),'review output already exists')
    require(args.positive is not None or args.negative is not None,'provide a positive or negative run')
    try:result=validate(args.positive.resolve() if args.positive else None,
        args.negative.resolve() if args.negative else None)
    except Exception as error:
        result=dict(status='reject_independent_review',error=str(error),traceback=traceback.format_exc())
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(status=result['status'],error=result.get('error'))))
    return int(result['status']=='reject_independent_review')

if __name__=='__main__':raise SystemExit(main())
