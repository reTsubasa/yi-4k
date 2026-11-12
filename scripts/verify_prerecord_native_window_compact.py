#!/usr/bin/env python3
"""Independent compact native output/geometry/consumer/custody review; no media writer."""
import argparse
from collections import Counter
from fractions import Fraction
import hashlib,json,subprocess
from pathlib import Path
import audit_prerecord_minute_aac_schedule as schedule
r,g,n,s=schedule.r,schedule.g,schedule.n,schedule.s
ROOT=r.ROOT;RATES=(30000,48000)
def require(test,msg):
    if not test:raise RuntimeError(msg)
def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def rat(value):return Fraction(value['numerator'],value['denominator'])
def probe(path,tool):
    argv=[str(tool),'-v','error'];p=json.loads(g.run(argv+['-show_streams','-show_data','-of','json',path]))
    p['packets']=json.loads(g.run(argv+['-show_packets','-of','json',path]))['packets'];return p

def inspect_boxes(raw):
    def children(box):return g.box_children(raw,box['offset']+8,box['offset']+box['size'])
    def child(box,kind):return next(b for b in children(box) if b['kind']==kind)
    top=g.box_children(raw,0,len(raw));moov=next(b for b in top if b['kind']=='moov');mdat=next(b for b in top if b['kind']=='mdat')
    tracks=[];mvhd=child(moov,'mvhd')['payload'];clock=int.from_bytes(mvhd[12:16],'big')
    for trak in [b for b in children(moov) if b['kind']=='trak']:
        tkhd=child(trak,'tkhd')['payload'];stbl=child(child(child(trak,'mdia'),'minf'),'stbl');stsd=child(stbl,'stsd')
        item=dict(tkhd_duration=int.from_bytes(tkhd[20:24],'big'),tkhd_width=int.from_bytes(tkhd[-8:-4],'big')//65536,
            tkhd_height=int.from_bytes(tkhd[-4:],'big')//65536)
        if stsd['payload'][12:16]==b'avc1':item.update(avc1_width=int.from_bytes(stsd['payload'][40:42],'big'),avc1_height=int.from_bytes(stsd['payload'][42:44],'big'))
        item['sample_tables_except_stsd']={b['kind']:n.sha(raw[b['offset']:b['offset']+b['size']]) for b in children(stbl) if b['kind']!='stsd'}
        tracks.append(item)
    return dict(movie_clock=clock,movie_duration=int.from_bytes(mvhd[16:20],'big'),tracks=tracks,
        mdat_sha256=n.sha(raw[mdat['offset']:mdat['offset']+mdat['size']]),moov_offset=moov['offset'],moov_bytes=moov['size'])

def reconstruct(report):
    receipt=json.loads(Path(report['inputs'][0]['path']).read_text());expected=[];counts=[0,0]
    for segment,row in zip(receipt['segments'],report['inputs'][1:]):
        raw=Path(row['path']).read_bytes();p=g.probe(row['path'],True);box=g.container_timeline(raw);epoch=rat(segment['native']['source_epoch'])
        for packet in g.packets(p,raw):
            st=packet['stream'];ticks=(epoch+rat(box['tracks'][st]['delay']))*RATES[st]+packet['pts']
            require(ticks.denominator==1,'source tick not integral')
            expected.append(dict(packet,index=counts[st],pts=int(ticks),dts=int(ticks)));counts[st]+=1
    return expected

def expected_selection(packets,start,stop,pre):
    video=[p for p in packets if p['stream']==0];audio=[p for p in packets if p['stream']==1]
    first_video=max([p for p in video if p['key'] and Fraction(p['pts'],30000)<=start-pre],key=lambda p:p['pts'])
    vt=Fraction(first_video['pts'],30000)
    first_audio=next(p for p in audio if Fraction(p['pts'],48000)<=vt<Fraction(p['pts']+p['duration'],48000))
    expected=[p for p in packets if p['index']>=(first_video if p['stream']==0 else first_audio)['index'] and Fraction(p['pts'],RATES[p['stream']])<stop]
    return expected,min(vt,Fraction(first_audio['pts'],48000))

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ('positive','firstsecond','close-failure','recovery','missing','invalid-sps','output'):
        p.add_argument('--'+name,type=Path,required=True)
    a=p.parse_args();folders={k:getattr(a,k) for k in ('positive','firstsecond','close_failure','recovery','missing','invalid_sps')}
    reports={k:json.loads((folder/'audit.json').read_text()) for k,folder in folders.items()}
    for key,report in reports.items():
        require(report['script_sha256']==digest(ROOT/'scripts/export_prerecord_native_window_compact.py'),'executed source changed')
        require(all(digest(row['path'])==row['sha256'] for row in report['inputs']),'input mutation')
        require(report['input_hashes_unchanged'] and not report['device_access'],'custody/scope changed')
        require(all(digest(ROOT/path)==sha for path,sha in report['dependencies'].items()),'executed dependency changed')
    tool=ROOT/'.tools/ffmpeg8-host/ffprobe';acquisition=json.loads((tool.parent/'acquisition.json').read_text())
    require(digest(tool)==next(x['binary_sha256'] for x in acquisition['downloads'] if x['binary']=='ffprobe'),'FFprobe8 identity changed')
    all_packets=reconstruct(reports['positive']);results={}
    source=r.minute.SOURCE;source_raw=source.read_bytes();require(n.sha(source_raw)==r.minute.SOURCE_SHA,'source oracle changed')
    source_packets=g.packets(g.probe(source),source_raw)
    for key in ('positive','firstsecond','recovery'):
        report=reports[key];path=folders[key]/'compact.ffmpeg8-reviewed.mp4'
        require(report['published'] and path.exists() and not (folders[key]/'session.pending.mp4').exists(),'publication custody failed')
        require(digest(path)==report['output_sha256'],'output changed')
        selected,origin=expected_selection(all_packets,rat(report['selection']['start']),rat(report['selection']['stop']),rat(report['selection']['pretrigger_requested']))
        raw=path.read_bytes();observed=probe(path,tool);actual=g.packets(observed,raw)
        gate=r.comparison(actual,selected,observed['streams'],origin);require(gate['status']=='pass','FFprobe8 exact gate reject')
        wanted={(x['stream'],x['index']) for x in selected};oracle=[x for x in source_packets if (x['stream'],x['index']) in wanted]
        require(g.exact_gate(actual,oracle,observed['streams'],origin)['status']=='pass','original source exact gate reject')
        require([observed['streams'][0]['width'],observed['streams'][0]['height']]==[1920,1080],'decoder geometry differs from sealed SPS')
        meta=inspect_boxes(raw);timeline=g.container_timeline(raw)
        require(meta['tracks'][0]['avc1_width']==meta['tracks'][0]['tkhd_width']==1920 and meta['tracks'][0]['avc1_height']==meta['tracks'][0]['tkhd_height']==1080,'serialized geometry mismatch')
        ends=[]
        for st,rate in enumerate(RATES):
            ps=[x for x in selected if x['stream']==st];track=timeline['tracks'][st]
            phase=Fraction(ps[0]['pts'],rate)-origin;end=Fraction(ps[-1]['pts']+ps[-1]['duration'],rate)-origin;ends.append(end)
            require(rat(track['delay'])==phase and track['media_duration']==sum(x['duration'] for x in ps),'native common phase or media duration differs')
            require(track['stts_durations']==[x['duration'] for x in ps],'native STTS changed')
            require(Fraction(sum(x['duration'] for x in track['edit_list']),meta['movie_clock'])==end,'edit endpoint changed')
            require(Fraction(meta['tracks'][st]['tkhd_duration'],meta['movie_clock'])==end,'track endpoint inconsistent')
            require(rat(report['selection']['start'])-Fraction(ps[0]['pts'],rate)>=60,'less than60s pretrigger')
        require(Fraction(meta['movie_duration'],meta['movie_clock'])==max(ends),'movie endpoint inconsistent')
        require(min(rat(t['delay']) for t in timeline['tracks'])==0,'leading empty time introduced')
        require(not report['native_execution']['caller_metadata_adapter'],'origin adapter used')
        legacy=r.comparison(g.packets(g.probe(path),raw),selected,g.probe(path)['streams'],origin)
        require(legacy['status']=='reject' and report['ordinary_ffprobe61_gate']['status']=='reject','legacy rejection erased')
        require(report['ordinary_avfoundation_output_gate']['status']=='reject' and report['avfoundation_decode_control']['audio_frame_difference']==-2112,'AVFoundation compatibility control erased')
        require(report['decode']['ffmpeg8_video_matches_source'] and report['decode']['ffmpeg8_audio_matches_whole_aac'],'full decode receipt failed')
        if key!='recovery':
            ffmpeg=ROOT/'.tools/ffmpeg8-host/ffmpeg'
            first=next(x['index'] for x in selected if x['stream']==0);count=sum(x['stream']==0 for x in selected)
            def frames(target,limit=None):
                argv=[ffmpeg,'-v','error','-xerror','-i',target,'-map','0:v:0']
                if limit is not None:argv+=['-frames:v',str(limit)]
                return [line.split(',')[-1].strip() for line in g.run(argv+['-f','framemd5','pipe:1']).decode().splitlines() if not line.startswith('#')]
            require(frames(path)==frames(source,first+count)[first:first+count],'independent full video decode mismatch')
            reference=folders[key]/'expected-retained.aac'
            require(reference.read_bytes()==b''.join(g.adts(x['data']) for x in selected if x['stream']==1),'AAC reference differs from sealed selected packets')
            pcm=g.run([ffmpeg,'-v','error','-xerror','-i',path,'-map','0:a:0','-f','s16le','pipe:1'])
            expected_pcm=g.run([ffmpeg,'-v','error','-xerror','-i',reference,'-f','s16le','pipe:1'])
            require(pcm==expected_pcm and len(pcm)==sum(x['duration'] for x in selected if x['stream']==1)*4,'independent whole AAC decode mismatch')
        results[key]=dict(output=str(path),sha256=digest(path),bytes=len(raw),common_source_offset=g.rational(origin),
            counts=dict(Counter(x['stream'] for x in actual)),geometry=meta['tracks'][0],movie_duration=g.rational(max(ends)),
            native_input_gate=gate['status'],original_source_gate='pass',ffprobe61_gate=legacy['status'],avfoundation_gate='reject')
    # Full media bytes and original index/timing tables must agree with the old
    # compact native control. Only explicit track/sample-entry geometry changes.
    old=ROOT/'artifacts/verification/2026-11-12-prerecord-native-window-stock-control-run01/session.pending.mp4'
    old_raw=old.read_bytes();new_raw=(a.positive/'compact.ffmpeg8-reviewed.mp4').read_bytes()
    old_meta=inspect_boxes(old_raw);new_meta=inspect_boxes(new_raw)
    require(old_meta['mdat_sha256']==new_meta['mdat_sha256'],'media bytes changed')
    require([x['sample_tables_except_stsd'] for x in old_meta['tracks']]==[x['sample_tables_except_stsd'] for x in new_meta['tracks']],'index/timing tables changed')
    require(len(old_raw)==len(new_raw) and old_meta['moov_offset']==new_meta['moov_offset'],'geometry changed layout')
    start=old_meta['moov_offset'];diff=[dict(offset=start+i,before=x,after=y) for i,(x,y) in enumerate(zip(old_raw[start:],new_raw[start:])) if x!=y]
    require(len(diff)==8,'unexpected changes beyond geometry fields')
    require(results['recovery']['sha256']==results['positive']['sha256'],'retry not byte-identical')
    for key in ('missing','invalid_sps'):
        require(not reports[key]['published'] and 'native_execution' not in reports[key],'preflight negative opened native mux')
    require(reports['close_failure']['native_execution']['close_status']==-12 and not reports['close_failure']['published'] and (a.close_failure/'session.pending.mp4').exists(),'failed Close not retained')
    require(len(reports['close_failure']['submissions'])==4694,'failed Close did not consume full selected window')
    result=dict(status='pass_independent_compact_native_window_consumer_review',offline_only=True,device_access=False,
        verifier_sha256=digest(__file__),reports={k:dict(path=str(folder/'audit.json'),sha256=digest(folder/'audit.json')) for k,folder in folders.items()},
        consumers=dict(ffprobe8_sha256=digest(tool),ffprobe61_sha256=digest(s.FFPROBE)),results=results,
        old_zero_geometry_control=str(old),old_zero_geometry=old_meta['tracks'][0],geometry_only_byte_changes=diff,
        whole_media_area_unchanged=True,index_and_timing_tables_unchanged=True,independent_full_decode_two_windows=True,missing_and_invalid_SPS_reject_before_Open=True,
        close_failure_pending_retained=True,clean_retry_byte_identical=True,
        scope='Two selected nonzero archive windows; original ARM mux plus SPS geometry caller configuration. FFmpeg8 consumer acceptance;6.1 and AVFoundation rejection retained. No universal player, encoder or live-device acceptance.')
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k] for k in ('status','whole_media_area_unchanged','clean_retry_byte_identical')}))
if __name__=='__main__':main()
