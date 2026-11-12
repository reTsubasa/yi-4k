#!/usr/bin/env python3
"""Independent read-only audit of nonzero native mux export and fail-closed controls."""
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import audit_prerecord_minute_aac_schedule as schedule
r,g,n,s=schedule.r,schedule.g,schedule.n,schedule.s
RATES=(30000,48000)
def require(test,message):
    if not test:raise RuntimeError(message)
def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def rat(value):return Fraction(value['numerator'],value['denominator'])
def children(raw,box):return g.box_children(raw,box['offset']+8,box['offset']+box['size'])
def child(raw,box,kind):return next(b for b in children(raw,box) if b['kind']==kind)
def container_metadata(raw):
    moov=next(b for b in g.box_children(raw,0,len(raw)) if b['kind']=='moov')
    mvhd=child(raw,moov,'mvhd')['payload'];require(mvhd[0]==0,'movie version changed')
    tracks=[]
    for trak in [b for b in children(raw,moov) if b['kind']=='trak']:
        tkhd=child(raw,trak,'tkhd')['payload'];require(tkhd[0]==0,'track version changed')
        stbl=child(raw,child(raw,child(raw,trak,'mdia'),'minf'),'stbl')
        tracks.append(dict(tkhd_duration=int.from_bytes(tkhd[20:24],'big'),
            sample_table_sha256=n.sha(raw[stbl['offset']:stbl['offset']+stbl['size']])))
    mdat=next(b for b in g.box_children(raw,0,len(raw)) if b['kind']=='mdat')
    return dict(movie_clock=int.from_bytes(mvhd[12:16],'big'),movie_duration=int.from_bytes(mvhd[16:20],'big'),
        tracks=tracks,mdat_sha256=n.sha(raw[mdat['offset']:mdat['offset']+mdat['size']]))
def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ('positive','stock-control','mdhd-control','missing','close-failure','recovery','output'):
        p.add_argument('--'+name,type=Path,required=True)
    a=p.parse_args();paths={k:getattr(a,k) for k in ('positive','stock_control','mdhd_control','missing','close_failure','recovery')}
    reports={k:json.loads((folder/'audit.json').read_text()) for k,folder in paths.items()}
    for key,report in reports.items():
        require(all(digest(row['path'])==row['sha256'] for row in report['inputs']),'source custody changed: '+key)
        require(report['input_hashes_unchanged'] and report['device_access'] is False,'scope changed')
        expected_script=paths[key]/'source.py'
        require(report['script_sha256']==digest(expected_script),'executed exporter source changed')
    positive=reports['positive'];target=a.positive/'session.mp4'
    require(positive['published'] and target.exists() and not (a.positive/'session.pending.mp4').exists(),'publication missing')
    require(digest(target)==positive['output_sha256'],'published output changed')
    receipt=json.loads(Path(positive['inputs'][0]['path']).read_text());expected=[];counts=[0,0]
    for entry,row in zip(receipt['segments'],positive['inputs'][1:]):
        raw=Path(row['path']).read_bytes();probe=g.probe(row['path'],True);table=g.container_timeline(raw)
        epoch=rat(entry['native']['source_epoch'])
        for packet in g.packets(probe,raw):
            st=packet['stream'];rate=RATES[st];time=epoch+rat(table['tracks'][st]['delay'])+Fraction(packet['pts'],rate)
            ticks=time*rate;require(ticks.denominator==1,'source ticks not integral')
            expected.append(dict(packet,index=counts[st],pts=int(ticks),dts=int(ticks)));counts[st]+=1
    # Derive selection from START−60 and STOP, not the exporter-selected indices.
    start=rat(positive['selection']['start']);stop=rat(positive['selection']['stop']);pre=rat(positive['selection']['pretrigger_requested'])
    video=[p for p in expected if p['stream']==0];audio=[p for p in expected if p['stream']==1]
    first_video=max((p for p in video if p['key'] and Fraction(p['pts'],30000)<=start-pre),key=lambda p:p['pts'])
    video_time=Fraction(first_video['pts'],30000)
    first_audio=next(p for p in audio if Fraction(p['pts'],48000)<=video_time<Fraction(p['pts']+p['duration'],48000))
    expected=[p for p in expected if p['index']>=(first_video if p['stream']==0 else first_audio)['index'] and Fraction(p['pts'],RATES[p['stream']])<stop]
    origin=Fraction(min(video_time,Fraction(first_audio['pts'],48000)).__floor__())
    raw=target.read_bytes();probe=g.probe(target);actual=g.packets(probe,raw)
    gate=r.comparison(actual,expected,probe['streams'],origin);require(gate['status']=='pass','strict native-input gate rejected')
    source=r.minute.SOURCE;source_raw=source.read_bytes();require(n.sha(source_raw)==r.minute.SOURCE_SHA,'original source changed')
    wanted={(p['stream'],p['index']) for p in expected}
    oracle=[p for p in g.packets(g.probe(source),source_raw) if (p['stream'],p['index']) in wanted]
    oracle_gate=g.exact_gate(actual,oracle,probe['streams'],origin);require(oracle_gate['status']=='pass','strict original-source gate rejected')
    input_probe=g.probe(positive['inputs'][1]['path'],True)
    require([g.extradata(t['extradata']) for t in probe['streams']]==[g.extradata(t['extradata']) for t in input_probe['streams']],'codec configuration changed')
    table=g.container_timeline(raw);meta=container_metadata(raw);ends=[]
    for st,rate in enumerate(RATES):
        ps=[p for p in expected if p['stream']==st];track=table['tracks'][st]
        phase=Fraction(ps[0]['pts'],rate)-origin;duration=Fraction(sum(p['duration'] for p in ps),rate)
        end=phase+duration;ends.append(end)
        require(track['stts_durations']==[p['duration'] for p in ps],'retained STTS changed')
        require(track['media_duration']==sum(p['duration'] for p in ps),'MDHD changed from media sample duration')
        require(rat(track['delay'])==phase,'presentation phase changed')
        require(Fraction(sum(x['duration'] for x in track['edit_list']),meta['movie_clock'])==end,'ELST endpoint inconsistent')
        require(Fraction(meta['tracks'][st]['tkhd_duration'],meta['movie_clock'])==end,'TKHD endpoint inconsistent')
        require(start-Fraction(ps[0]['pts'],rate)>=60 and Fraction(ps[-1]['pts']+ps[-1]['duration'],rate)>=stop,'coverage insufficient')
    require(Fraction(meta['movie_duration'],meta['movie_clock'])==max(ends),'MVHD inconsistent')
    control=reports['stock_control'];control_path=a.stock_control/'session.pending.mp4'
    require(not control['published'] and control['strict_native_input_packet_time_gate']['status']=='reject','stock reject erased')
    control_meta=container_metadata(control_path.read_bytes())
    require(control_meta['mdat_sha256']==meta['mdat_sha256'],'media payload area differs from stock control')
    require([t['sample_table_sha256'] for t in control_meta['tracks']]==[t['sample_table_sha256'] for t in meta['tracks']],'sample tables differ from stock control')
    require(not reports['mdhd_control']['published'] and reports['mdhd_control']['strict_native_input_packet_time_gate']['status']=='reject','MDHD-only reject erased')
    missing=reports['missing'];failed=reports['close_failure'];recovery=reports['recovery']
    require(not missing['published'] and 'native_execution' not in missing and 'missing/discontinuous' in missing['error'],'gap not rejected before native Open')
    require(not failed['published'] and failed['native_execution']['close_status']==-12 and (a.close_failure/'session.pending.mp4').exists(),'Close failure not retained')
    require(len(failed['submissions'])==len(expected),'Close failure did not exercise complete window')
    require(recovery['published'] and digest(a.recovery/'session.mp4')==digest(target),'clean retry differs or failed')
    for key in ('stock_control','mdhd_control','missing','close_failure'):
        require(not (paths[key]/'session.mp4').exists(),'negative path published')
    require(positive['segments'][1]['native_consumer_gate']=='reject','native second-segment reject erased')
    # Independent full decode: exact source video subset; all whole retained AAC.
    count=sum(p['stream']==0 for p in expected);first=first_video['index']
    require(g.frame_hashes(target)==g.frame_hashes(source,first+count)[first:],'video source mismatch')
    aac=a.positive/'expected-retained.aac';require(aac.read_bytes()==b''.join(g.adts(p['data']) for p in expected if p['stream']==1),'AAC reference changed')
    pcm=g.pcm(target);require(pcm==g.pcm(aac,True),'AAC PCM mismatch')
    result=dict(status='pass_independent_nonzero_native_window_review',offline_only=True,device_access=False,
        verifier_sha256=digest(__file__),reports={k:dict(path=str(paths[k]/'audit.json'),sha256=digest(paths[k]/'audit.json')) for k in reports},
        output=dict(path=str(target),sha256=digest(target),bytes=len(raw)),packet_counts=dict(Counter(p['stream'] for p in actual)),
        common_source_offset=g.rational(origin),first_packet_pts={str(st):g.rational(Fraction(next(p['pts'] for p in actual if p['stream']==st),RATES[st])) for st in (0,1)},
        presentation_duration=g.rational(max(ends)),leading_empty_duration=g.rational(min(rat(t['delay']) for t in table['tracks'])),
        container_metadata=meta,ordinary_native_input_gate=gate['status'],ordinary_original_source_gate=oracle_gate['status'],
        original_media_area_and_all_sample_tables_equal_stock_control=True,mdhd_retained_sample_duration_unchanged=True,
        native_second_segment_reject_preserved=True,stock_and_mdhd_only_reject_controls_preserved=True,
        missing_rejected_before_Open=True,failed_Close0_retained=True,clean_retry_identical=True,
        video_frames=count,audio_pcm_bytes=len(pcm),audio_pcm_sha256=n.sha(pcm),
        consumer=dict(version=g.run([s.FFPROBE,'-version']).decode().splitlines()[0],sha256=digest(s.FFPROBE)),
        scope='Host-emulated original ARM final mux plus explicit common-origin/MVHD adapter. No stock-only arbitrary-window or camera acceptance claim.')
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k] for k in ('status','packet_counts','common_source_offset','presentation_duration')}))
if __name__=='__main__':main()
