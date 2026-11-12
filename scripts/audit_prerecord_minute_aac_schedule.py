#!/usr/bin/env python3
"""Offline AAC end-assignment through original minute event3 and Close0.

Optional derived ISO duration correction is explicitly a host metadata edit,
never a claim of original firmware output or a camera/deployment operation.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path
import time
import traceback
import audit_prerecord_minute_rollover as r

g,n,s=r.g,r.n,r.s
ROLLOVER_SHA='a531319dd42ea76fb60736122267f15ef4cf65f511697b87b0ce31f971080a88'


def fix_iso_durations(data):
    """Keep all samples/offsets/STTS; expose complete delayed tracks via ELST.

    Version0 fixture only; exactly one media_time=0 edit per track. Media edit
    duration must describe sample duration, not include/subtract the empty edit.
    """
    result=bytearray(data);changes=[]
    def children(box):
        return g.box_children(data,box['offset']+8,box['offset']+box['size'])
    def child(box,kind):
        return next(b for b in children(box) if b['kind']==kind)
    def set32(offset,value,label):
        old=int.from_bytes(result[offset:offset+4],'big')
        r.require(0<=value<=0xffffffff,'duration outside version0 bounds')
        if old!=value:
            result[offset:offset+4]=value.to_bytes(4,'big')
            changes.append(dict(field=label,offset=offset,before=old,after=value))
    moov=next(b for b in g.box_children(data,0,len(data)) if b['kind']=='moov')
    mvhd=child(moov,'mvhd');r.require(mvhd['payload'][0]==0,'mvhd version unsupported')
    movie_clock=int.from_bytes(mvhd['payload'][12:16],'big')
    durations=[]
    for number,trak in enumerate(b for b in children(moov) if b['kind']=='trak'):
        mdia=child(trak,'mdia');mdhd=child(mdia,'mdhd')
        r.require(mdhd['payload'][0]==0,'mdhd version unsupported')
        clock=int.from_bytes(mdhd['payload'][12:16],'big')
        media_duration=int.from_bytes(mdhd['payload'][16:20],'big')
        ticks=Fraction(media_duration*movie_clock,clock)
        r.require(ticks.denominator==1,'fixture media duration not exact movie tick')
        elst=child(child(trak,'edts'),'elst');payload=elst['payload']
        r.require(payload[0]==0,'elst version unsupported')
        entries=int.from_bytes(payload[4:8],'big');empty=0;media=0
        for i in range(entries):
            at=elst['offset']+16+i*12
            duration=int.from_bytes(data[at:at+4],'big')
            media_time=int.from_bytes(data[at+4:at+8],'big',signed=True)
            if media_time==-1:
                empty+=duration
            else:
                r.require(media_time==0,'nonzero media edit unsupported')
                media+=1;set32(at,int(ticks),f'track{number}.elst.media_duration')
        r.require(media==1,'expected one media edit')
        duration=empty+int(ticks);durations.append(duration)
        tkhd=child(trak,'tkhd');r.require(tkhd['payload'][0]==0,'tkhd version unsupported')
        set32(tkhd['offset']+8+20,duration,f'track{number}.tkhd.duration')
    set32(mvhd['offset']+8+16,max(durations),'mvhd.duration')
    return bytes(result),changes


def inspect(path,data,submitted,origin,source_frames,first_frame,frame_count,out,label):
    path.write_bytes(data)
    probe=g.probe(path);actual=g.packets(probe,data)
    decoded=g.frame_hashes(path)
    reference=out/f'{label}-all-submitted-audio.aac'
    audio=[p for p in submitted if p['stream']==1]
    reference.write_bytes(b''.join(g.adts(p['data']) for p in audio))
    expected_pcm=g.pcm(reference,True);actual_pcm=g.pcm(path)
    gate=r.comparison(actual,submitted,probe['streams'],origin)
    return dict(file=path.name,bytes=len(data),sha256=n.sha(data),source_epoch=g.rational(origin),
        packet_counts=dict(Counter(p['stream'] for p in actual)),strict_packet_time_gate=gate,
        container=g.container_timeline(data),video_frames=len(decoded),
        video_matches_source=decoded==source_frames[first_frame:first_frame+frame_count],
        all_submitted_audio_matches_pcm=actual_pcm==expected_pcm,
        actual_pcm_sha256=n.sha(actual_pcm),expected_pcm_sha256=n.sha(expected_pcm),
        actual_pcm_bytes=len(actual_pcm),expected_pcm_bytes=len(expected_pcm),
        packets=[g.public_packet(p) for p in actual])


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output',required=True,type=Path)
    out=ap.parse_args().output;out.mkdir(parents=True,exist_ok=False)
    started=time.monotonic();m=None
    report=dict(schema=1,status='running',offline_only=True,limit_ms=60000,
        script_sha256=n.sha(Path(__file__).read_bytes()),rollover_script_sha256=ROLLOVER_SHA,
        source_sha256=r.minute.SOURCE_SHA,firmware_sha256=s.life.arm.DIGEST,
        scheduling='Hold an AAC packet ending after video split for the next movie; no duplicate/drop or reencode',
        legal_close_mode=0,unknown_close1_used=False,
        derived_variant='Host ISO ELST/TKHD/MVHD duration correction only; native sample bytes, offsets and STTS untouched',
        limitations=['Offline archive replay with RAM/OS models; not live capture, ring, SD throughput or device deployment.',
            'End-assignment requires one caller-owned AAC lookahead slot and synchronized producer scheduling, not proven here.',
            'The next file source epoch may precede its first video; concatenation must retain source epochs, not append file durations.',
            'Host ISO correction is an export candidate, not stock firmware behavior or a native mux fix.'])
    try:
        r.require(n.sha(Path(r.__file__).read_bytes())==ROLLOVER_SHA,'rollover script changed')
        for name,digest in r.FROZEN.items():
            r.require(n.sha((r.ROOT/'scripts'/name).read_bytes())==digest,f'harness changed: {name}')
        image=s.life.arm.IMAGE.read_bytes();r.require(n.sha(image)==s.life.arm.DIGEST,'image changed')
        raw=r.minute.SOURCE.read_bytes();r.require(n.sha(raw)==r.minute.SOURCE_SHA,'source changed')
        source=g.probe(r.minute.SOURCE);packets=g.packets(source,raw)
        sps,pps=g.avcc(g.extradata(source['streams'][0]['extradata']))
        end=Fraction(1920*1001,30000);split=Fraction(1800*1001,30000)
        selected=g.select_window(packets,Fraction(),end)
        first=[p for p in selected if (p['stream']==0 and Fraction(p['pts'],30000)<split)
            or (p['stream']==1 and Fraction(p['pts']+p['duration'],48000)<=split)]
        first_keys={(p['stream'],p['index']) for p in first}
        second=[p for p in selected if (p['stream'],p['index']) not in first_keys]
        boundary=next(p for p in second if p['stream']==0 and p['index']==1800)
        held=[p for p in second if p['stream']==1 and Fraction(p['pts'],48000)<split]
        r.require(len(held)==1 and held[0]['index']==2815,'expected crossing AAC absent')
        epoch=min(Fraction(p['pts'],30000 if p['stream']==0 else 48000) for p in second)
        report.update(split=g.rational(split),final_endpoint=g.rational(end),second_source_epoch=g.rational(epoch),
            held_crossing_aac=g.public_packet(held[0]),submitted_counts=[dict(Counter(p['stream'] for p in ps)) for ps in (first,second)])
        m,track,mux=r.init(image)
        r.feed(m,s.MOVIE,mux,first,sps,pps,report)
        r.event.load_packet(m,boundary,sps,pps);report['before']=r.fifo(m,track)
        m.phase='boundary_limit';report['boundary_status']=r.process(m,s.MOVIE,mux,boundary)
        r.require(report['boundary_status']==3,'stock 60000ms boundary did not return3')
        r.configure_event(m,mux);m.phase='original_event3'
        report['event_status']=m.call(0xa0443720,r.event.PIPE,mux,3)
        r.require(report['event_status']==0,'event3 failed')
        movie=m.get(mux+4);report['after']=r.fifo(m,movie+0x78)
        r.require(all(report['before'][key]==report['after'][key] for key in ('cursor','fifo','descriptor')),'retained boundary changed')
        # Retain exact video descriptor across event3, consume once, then supply
        # held AAC. The two tracks maintain their own source-time order.
        m.phase='retained_video';report['retained_status']=r.process(m,movie,mux,boundary)
        r.require(report['retained_status']==0,'retained video failed')
        report['retained_cursor']=m.get(s.life.VIRTUAL+0x90,8)
        r.require(report['retained_cursor']==report['before']['cursor']+1,'video not consumed exactly once')
        m.phase='second_segment'
        r.feed(m,movie,mux,[p for p in second if not (p['stream']==0 and p['index']==1800)],sps,pps,report)
        m.phase='final_Close0';report['close_status']=m.call(0xa03fe300,mux,0)
        r.require(report['close_status']==0 and len(m.closed_files)==1,'Close0 failed')
        frames=g.frame_hashes(r.minute.SOURCE,1920);report['segments']=[]
        for number,(data,submitted,origin,start,count) in enumerate(zip([m.closed_files[0],bytes(m.output)],
                [first,second],[Fraction(),epoch],[0,1800],[1800,120]),1):
            native=inspect(out/f'native-segment-{number}.mp4',data,submitted,origin,frames,start,count,out,f'native-{number}')
            fixed,changes=fix_iso_durations(data)
            derived=inspect(out/f'iso-duration-segment-{number}.mp4',fixed,submitted,origin,frames,start,count,out,f'iso-{number}')
            # Same samples exported from both files, not merely bytes outside
            # modified MOOV ranges. Exact comparison still checks all durations.
            r.require([(p['stream'],p['sha256']) for p in native['packets']]==
                [(p['stream'],p['sha256']) for p in derived['packets']],'ISO edit changed sample payload')
            report['segments'].append(dict(native=native,iso_duration_variant=derived,iso_changes=changes))
        report['status']='offline_end_assigned_event3_executed'
        for key in ('native','iso_duration_variant'):
            report[key+'_gate']='pass' if all(seg[key]['strict_packet_time_gate']['status']=='pass'
                and seg[key]['video_matches_source'] and seg[key]['all_submitted_audio_matches_pcm']
                for seg in report['segments']) else 'reject'
        report['source_packet_coverage']={str(st):dict(submitted=sum(p['stream']==st for p in selected),
            exported=sum(seg['native']['packet_counts'].get(st,0) for seg in report['segments'])) for st in (0,1)}
    except Exception as error:
        report.update(status='execution_failed',error=str(error),traceback=traceback.format_exc())
        if m is not None:
            for number,data in enumerate(m.closed_files+[bytes(m.output)],1):
                (out/f'partial-{number}.mp4').write_bytes(data)
    finally:
        if m is not None:
            report.update(original_calls=m.transitions,external_events=m.external,diagnostics=m.logs,
                stream_events=m.stream_events,mock_index_events=m.index_events)
        report['elapsed_seconds']=time.monotonic()-started
        (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:report.get(k) for k in ('status','error','native_gate','iso_duration_variant_gate','elapsed_seconds')}),flush=True)
    return int(report['status']=='execution_failed')

if __name__=='__main__':raise SystemExit(main())
