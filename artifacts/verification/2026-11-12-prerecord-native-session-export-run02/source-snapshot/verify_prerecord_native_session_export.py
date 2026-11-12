#!/usr/bin/env python3
"""Read-only independent ordinary-consumer verification of original ARM export."""
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import audit_prerecord_minute_aac_schedule as schedule

g,r,s,n=schedule.g,schedule.r,schedule.s,schedule.n
ROOT=r.ROOT

def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def require(test,message):
    if not test: raise RuntimeError(message)

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--positive',required=True,type=Path)
    p.add_argument('--missing',required=True,type=Path)
    p.add_argument('--close-failure',required=True,type=Path)
    p.add_argument('--output',required=True,type=Path)
    args=p.parse_args();reports={}
    for key,folder in [('positive',args.positive),('missing',args.missing),('close_failure',args.close_failure)]:
        report=json.loads((folder/'audit.json').read_text());reports[key]=report
        require(report['script_sha256']==digest(ROOT/'scripts/export_prerecord_native_session.py'),'executed script digest changed')
        require(all(digest(row['path'])==row['sha256'] for row in report['inputs']),'native source mutated')
        require(report['input_hashes_unchanged'] and report['device_access'] is False,'scope/custody changed')
    positive=reports['positive'];target=args.positive/'session.mp4'
    require(positive['published'] and target.is_file() and not (args.positive/'session.pending.mp4').exists(),'positive atomic publication missing')
    require(digest(target)==positive['output_sha256'],'positive output hash changed')
    # Independently derive expected payload list and source chronology from
    # original segment files/table epoch receipts. Do not import exporter.
    receipt=json.loads(Path(positive['inputs'][0]['path']).read_text());expected=[]
    for entry,pathrow in zip(receipt['segments'],positive['inputs'][1:]):
        raw=Path(pathrow['path']).read_bytes();probe=g.probe(pathrow['path'],True)
        table=g.container_timeline(raw);ep=entry['native']['source_epoch'];epoch=Fraction(ep['numerator'],ep['denominator'])
        for packet in g.packets(probe,raw):
            st=packet['stream'];rate=(30000,48000)[st];delta=table['tracks'][st]['delay']
            start=epoch+Fraction(delta['numerator'],delta['denominator'])+Fraction(packet['pts'],rate)
            ticks=start*rate;require(ticks.denominator==1,'source chronology not integral')
            expected.append(dict(packet,pts=int(ticks),dts=int(ticks)))
    expected.sort(key=lambda row:(Fraction(row['dts'],(30000,48000)[row['stream']]),row['stream']))
    raw=target.read_bytes();probe=g.probe(target);actual=g.packets(probe,raw)
    input_probe=g.probe(positive['inputs'][1]['path'],True)
    require([g.extradata(st['extradata']) for st in probe['streams']]==[g.extradata(st['extradata']) for st in input_probe['streams']], 'native codec configuration changed')
    native_gate=r.comparison(actual,expected,probe['streams'],Fraction())
    require(native_gate['status']=='pass','ordinary consumer rejects native retained sequence')
    source=r.minute.SOURCE;source_raw=source.read_bytes();require(n.sha(source_raw)==r.minute.SOURCE_SHA,'oracle hash changed')
    oracle=g.select_window(g.packets(g.probe(source),source_raw),Fraction(),Fraction(8008,125))
    oracle_gate=g.exact_gate(actual,oracle,probe['streams'],Fraction())
    require(oracle_gate['status']=='pass','oracle strict packet/time rejected')
    require(Counter(p['stream'] for p in actual)=={0:1920,1:3003},'packet count changed')
    for st,rate,delta in [(0,30000,1001),(1,48000,1024)]:
        rows=[p for p in actual if p['stream']==st]
        require(all(p['pts']==p['dts']==i*delta and p['duration']==delta for i,p in enumerate(rows)), 'ordinary consumer timestamp changed')
    box=g.container_timeline(raw)
    require([t['stts_durations'] for t in box['tracks']]==[[1001]*1920,[1024]*3003],'STTS changed')
    require(all(t['delay']['numerator']==0 for t in box['tracks']),'unexpected empty edit')
    require(g.frame_hashes(target)==g.frame_hashes(source,1920),'decoded source frames differ')
    require(n.sha(g.pcm(target))=='fd7def7d1214705f61861e6120fccc28df28fbb490d1b636575438ae9dc54523','decoded continuous audio differs')
    missing=reports['missing'];close=reports['close_failure']
    require(not missing['published'] and not (args.missing/'session.mp4').exists(),'missing packet published')
    require('publication preflight rejects missing/discontinuous' in missing['error'],'missing packet not rejected by chronology gate')
    require('native_execution' not in missing,'missing preflight unexpectedly opened native mux')
    require(not close['published'] and not (args.close_failure/'session.mp4').exists(),'failed close published')
    require((args.close_failure/'session.pending.mp4').is_file(),'failed close bytes not retained')
    require(close['error']=='native final Close0 failed' and close['native_execution']['close_status']!=0, 'Close short-write expected error absent')
    require(any(e['entry']=='0xa03fe300' and e['phase']=='final_export_Close0'
                for e in close['native_execution']['original_calls']),'original Close0 not reached')
    result=dict(status='pass_independent_native_export_and_rejection_review',offline_only=True,device_access=False,
        verifier_sha256=digest(__file__),reviewed_reports={key:digest(folder/'audit.json') for key,folder in
        [('positive',args.positive),('missing',args.missing),('close_failure',args.close_failure)]},
        output=dict(path=str(target),bytes=len(raw),sha256=n.sha(raw)),packet_counts=dict(Counter(p['stream'] for p in actual)),
        ordinary_consumer_native_input_gate=native_gate['status'],ordinary_consumer_source_gate=oracle_gate['status'],
        codec_configuration_matches_native_inputs=True,source_video_frames=1920,audio_pcm_bytes=12300288,audio_pcm_sha256=n.sha(g.pcm(target)),
        native_second_segment_consumer_gate=positive['segments'][1]['native_consumer_gate'],
        native_second_segment_rejection_preserved=True,missing_aac_rejected_before_native_Open=True,
        native_Close0_short_write_rejected_pending_retained=True,
        consumer=dict(version=g.run([s.FFPROBE,'-version']).decode().splitlines()[0],sha256=digest(s.FFPROBE)),
        firmware_sha256=positive['firmware_sha256'],final_export_limit_ms=positive['native_execution']['final_export_limit_ms'],
        recording_limit_ms=60000,scope='Separate host-emulated original ARM final export; no direct event3/native recording compatibility claim')
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
if __name__=='__main__':main()
