#!/usr/bin/env python3
"""Offline selected nonzero trigger window through original ARM mux with explicit common-origin adapter.

Stock control keeps the known ordinary-reader rejection. The optional caller
adapter sets the common export origin and movie duration before original ARM serialization.
No camera, device, encoder, FFmpeg mux, ISO byte rewrite or instruction patch.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path
import time
import traceback
from unicorn import UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R2, UC_ARM_REG_R3
import export_prerecord_native_session as base

r,g,n,s=base.r,base.g,base.n,base.s
RATES=base.RATES
require=base.require

def pts(p): return Fraction(p['pts'],RATES[p['stream']])
def endpoint(p): return pts(p)+Fraction(p['duration'],RATES[p['stream']])
def whole_ticks(value,rate,label):
    result=value*rate
    require(result.denominator==1,label+' is not exactly representable')
    require(0<=result<=0xffffffff,label+' overflows version0/u32')
    return int(result)

def select_window(packets,start,stop,pre,report):
    require(pre>0 and start>=pre and stop>start,'invalid trigger bounds')
    desired=start-pre
    video=[p for p in packets if p['stream']==0]
    audio=[p for p in packets if p['stream']==1]
    candidates=[p for p in video if p['key'] and pts(p)<=desired]
    require(bool(candidates),'no preceding decodable IDR')
    first_video=candidates[-1]
    crossing=[p for p in audio if pts(p)<=pts(first_video)<endpoint(p)]
    require(len(crossing)==1,'no whole AAC packet spanning first IDR')
    first_audio=crossing[0]
    selected=[p for p in packets if p['index']>=(first_video if p['stream']==0 else first_audio)['index'] and pts(p)<stop]
    origin=min(pts(first_video),pts(first_audio))
    tracks=[]
    for st,rate in enumerate(RATES):
        ps=[p for p in selected if p['stream']==st]
        require(bool(ps),'empty selected track')
        require(all(b['index']==a['index']+1 and pts(b)==endpoint(a) for a,b in zip(ps,ps[1:])),
                'selected packet continuity gap')
        require(endpoint(ps[-1])>=stop,'sealed input does not cover STOP')
        require(start-pts(ps[0])>=pre,'less than requested pretrigger duration')
        tracks.append(dict(stream=st,first_index=ps[0]['index'],last_index=ps[-1]['index'],count=len(ps),
            source_start=g.rational(pts(ps[0])),source_end=g.rational(endpoint(ps[-1])),
            phase=g.rational(pts(ps[0])-origin),pretrigger=g.rational(start-pts(ps[0])),
            posttrigger=g.rational(endpoint(ps[-1])-start),stop_overshoot=g.rational(endpoint(ps[-1])-stop)))
    report['selection']=dict(start=g.rational(start),stop=g.rational(stop),pretrigger_requested=g.rational(pre),
        requested_lower_bound=g.rational(desired),source_origin=g.rational(origin),tracks=tracks,
        preceding_idr_overshoot=g.rational(desired-pts(first_video)),
        original_segments=sorted({p['native_segment'] for p in selected}),
        policy='preceding IDR; whole AAC spanning IDR; retain whole packets starting before STOP; one common source offset')
    report['selected_packets']=[g.public_packet(p) for p in selected]
    return selected,origin

def native_export(packets,configuration,origin,output,report,adapt=True,fail_close=False):
    image=s.life.arm.IMAGE.read_bytes()
    require(n.sha(image)==s.life.arm.DIGEST,'firmware identity changed')
    require(base.digest(Path(r.__file__))==base.schedule.ROLLOVER_SHA,'frozen rollover harness changed')
    for name,sha in r.FROZEN.items(): require(base.digest(base.ROOT/'scripts'/name)==sha,'frozen dependency changed: '+name)
    m,track,mux=r.init(image)
    # Seed the original ResetMovie with source-time DTS snapshots in its common
    # internal clock. The original routine subtracts ONE origin and retains phase.
    first=[next(p for p in packets if p['stream']==st) for st in (0,1)]
    clocks=[m.get(track+st*0x90+4) for st in (0,1)]
    require(clocks[0]==clocks[1],'ResetMovie requires common internal clock')
    sps,pps=g.avcc(configuration[0])
    r.event.load_packet(m,first[0],sps,pps)
    for st,p in enumerate(first): m.put(track+st*0x90+0x28,whole_ticks(pts(p),clocks[st],'source DTS'),8)
    natural_origin=min(pts(p) for p in first)
    require(origin==natural_origin or origin>0, "zero native preset is a sentinel; unsupported fractional first-second window")
    m.put(0xa13c1758,whole_ticks(origin,clocks[0],"common source origin") if adapt else 0,8)
    m.phase='final_window_original_ResetMovie'
    for entry in (0xa04404d8,0xa01f68b8,0xa01f3124):
        require(m.call(entry,s.MOVIE)==0,'original ResetMovie setup failed')
    for st,p in enumerate(first):
        want=whole_ticks(pts(p)-origin,clocks[st],'track phase')
        require(all(m.get(track+st*0x90+off,8)==want for off in (0x18,0x20,0x28)), 'common origin lost')
    require(Fraction(m.get(0xa13c1758,8),clocks[0])==origin,'native common source origin differs')
    duration=max(endpoint(p) for p in packets)-origin
    export_ms=(duration*1000).__ceil__()+1000  # capacity, not sample selection
    require(export_ms<=0xffffffff,'export session limit overflow')
    m.put(mux+0x10,export_ms)
    metadata=[]
    def edit_origin_adapter(uc,address,size,user):
        st=len([x for x in metadata if x['kind']=='edit_origin'])
        require(st<2,'unexpected edit constructor')
        before=uc.reg_read(UC_ARM_REG_R2)|(uc.reg_read(UC_ARM_REG_R3)<<32)
        require(before==whole_ticks(natural_origin-origin,clocks[0],'natural initial padding'), 'native edit origin changed')
        if adapt:
            uc.reg_write(UC_ARM_REG_R2,0);uc.reg_write(UC_ARM_REG_R3,0)
        metadata.append(dict(kind='edit_origin',stream=st,constructor='0xa0425e18',
            before_common_origin_ticks=before,after_common_origin_ticks=0 if adapt else before,
            unchanged_track_start_ticks=m.get(track+st*0x90+0x18,8)))
    def movie_duration_adapter(uc,address,size,user):
        obj=uc.reg_read(UC_ARM_REG_R0)
        clock=m.get(obj+0x28);before=m.get(obj+0x30,8)
        delta=whole_ticks(natural_origin-origin,clock,'movie initial padding')
        after=before+delta
        require(after<=0xffffffff,'movie duration overflows version0')
        snapshot=bytes(uc.mem_read(obj,0x38))
        if adapt:m.put(obj+0x30,after,8)
        updated=bytes(uc.mem_read(obj,0x38))
        require(snapshot[:0x30]==updated[:0x30],'changed another MVHD field')
        metadata.append(dict(kind='movie_duration',writer='0xa04312e4',field_offset='0x30',
            before=before,after=after if adapt else before,initial_padding_ticks=delta,
            before_object_hex=snapshot.hex(),after_object_hex=updated.hex()))
    m.uc.hook_add(UC_HOOK_CODE,edit_origin_adapter,begin=0xa0425e18,end=0xa0425e18)
    m.uc.hook_add(UC_HOOK_CODE,movie_duration_adapter,begin=0xa04312e4,end=0xa04312e4)
    report['native_execution']=dict(recording_limit_ms=60000,export_capacity_limit_ms=export_ms,
        native_reset_origin=g.rational(origin),native_track_phase_ticks=[m.get(track+i*0x90+0x18,8) for i in (0,1)],
        internal_clock=clocks[0],original_instruction_bytes_unchanged=True,caller_metadata_adapter=adapt,
        metadata_changes=metadata,ffmpeg_mux_used=False,host_iso_byte_rewrite_used=False,
        model='RAM file, RTOS service models and one caller-owned synthetic FIFO')
    report['submissions']=[];started=time.monotonic()
    try:
        for ordinal,p in enumerate(packets):
            r.event.load_packet(m,p,sps,pps);m.phase='final_window_samples'
            if p['stream']==0:
                status=m.call(0xa042d0f8,s.MOVIE,track,s.MOVIE+0x350,mux+0x58,s.STREAM,export_ms,0xffffffff,0xffffffff)
            else:
                status=m.call(0xa043173c,s.MOVIE,track+0x90,mux+0x58,s.STREAM,0,export_ms,0xffffffff,0xffffffff)
            report['submissions'].append(dict(stream=p['stream'],source_index=p['index'],status=status))
            require(status==0,'native Process rejected selected packet')
            if (ordinal+1)%500==0: print(json.dumps(dict(phase=m.phase,packets=ordinal+1,total=len(packets))),flush=True)
        require([m.get(track+0x10),m.get(track+0xa0)]==[sum(p['stream']==st for p in packets) for st in (0,1)],'native sample counts changed')
        m.phase='final_window_Close0'
        if fail_close:m.short_write_at=len(m.writes)
        close_status=m.call(0xa03fe300,mux,0)
        report['native_execution']['close_status']=close_status
        require(close_status==0,'native final Close0 failed')
        require(len(metadata)==3 and not m.index_events,'metadata count/mock index mismatch')
    finally:
        (output/'session.pending.mp4').write_bytes(m.output)
        report['native_execution'].update(original_calls=m.transitions,native_calls=dict(Counter(c['entry'] for c in m.native_calls)),
            diagnostics=m.logs,index_mock_events=m.index_events,file_writes=len(m.writes),elapsed_seconds=time.monotonic()-started)

def validate_candidate(pending,expected,origin,configuration,report,output):
    raw=pending.read_bytes();probe=g.probe(pending);actual=g.packets(probe,raw)
    report['output_container']=g.container_timeline(raw)
    report['strict_native_input_packet_time_gate']=r.comparison(actual,expected,probe['streams'],origin)
    failures=[p for p in report['strict_native_input_packet_time_gate']['compared_packets'] if not p['same_payload'] or any(
        p[k]['numerator'] for k in ('pts_error','dts_error','duration_error'))]
    report['strict_gate_failures']=failures
    require(report['strict_native_input_packet_time_gate']['status']=='pass','ordinary consumer rejects final window')
    require(tuple(g.extradata(st['extradata']) for st in probe['streams'])==configuration,'codec configuration changed')
    source=r.minute.SOURCE;source_raw=source.read_bytes();require(n.sha(source_raw)==r.minute.SOURCE_SHA,'oracle identity changed')
    wanted={(p['stream'],p['index']) for p in expected}
    oracle=[p for p in g.packets(g.probe(source),source_raw) if (p['stream'],p['index']) in wanted]
    report['source_used_as_mux_input']=False
    report['strict_original_source_gate']=g.exact_gate(actual,oracle,probe['streams'],origin)
    require(report['strict_original_source_gate']['status']=='pass','original-source strict gate failed')
    first=next(p['index'] for p in expected if p['stream']==0);count=sum(p['stream']==0 for p in expected)
    frames=g.frame_hashes(pending);source_frames=g.frame_hashes(source,first+count)[first:]
    aac=output/'expected-retained.aac';aac.write_bytes(b''.join(g.adts(p['data']) for p in expected if p['stream']==1))
    pcm=g.pcm(pending);reference=g.pcm(aac,True)
    report['decode']=dict(video_frames=len(frames),video_matches_source=frames==source_frames,
        audio_pcm_bytes=len(pcm),audio_pcm_sha256=n.sha(pcm),audio_matches_all_retained_packets=pcm==reference)
    require(frames==source_frames and pcm==reference,'decoded retained window mismatch')
    report['output_sha256']=n.sha(raw);report['output_bytes']=len(raw)
    report['output_packets']=[g.public_packet(p) for p in actual]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,default=base.DEFAULT_INPUT)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--start',type=Fraction,default=Fraction(63))
    parser.add_argument('--stop',type=Fraction,default=Fraction(64))
    parser.add_argument('--pretrigger',type=Fraction,default=Fraction(60))
    parser.add_argument('--stock-control',action='store_true')
    parser.add_argument('--drop-boundary-aac',action='store_true')
    parser.add_argument('--fail-close',action='store_true')
    args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    report=dict(schema=1,status='running',offline_only=True,device_access=False,script_sha256=base.digest(__file__),
        firmware_sha256=s.life.arm.DIGEST,base_exporter_sha256=base.digest(base.__file__),
        injection=dict(stock_control=args.stock_control,drop_boundary_aac=args.drop_boundary_aac,fail_close=args.fail_close),
        limitations=['Native event3 second-segment ordinary-consumer rejection remains unchanged.',
            'Caller metadata adapter is a proposed final-export adaptation, not unmodified stock output.',
            'Only START63 STOP64 is validated here; other bounds remain strict fail-closed candidates.',
            'Whole-second normalization retains explicit leading empty presentation time; first real packets need not start at zero.',
            'A zero native global preset is a sentinel; fractional natural origins within the first second are unsupported.',
            'Archived 1080p29.97 I/P + 48kHz AAC only; no live capture, DMA, concurrent queues, device install or SD durability proof.',
            'Input source epochs are caller receipts, not authenticated by MP4 bytes alone.'])
    try:
        packets,configuration=base.load_segments(args.input,report,args.drop_boundary_aac)
        selected,origin=select_window(packets,args.start,args.stop,args.pretrigger,report)
        if not args.stock_control:
            origin=Fraction(origin.__floor__())
            report['selection']['output_common_source_offset']=g.rational(origin)
        native_export(selected,configuration,origin,args.output,report,not args.stock_control,args.fail_close)
        validate_candidate(args.output/'session.pending.mp4',selected,origin,configuration,report,args.output)
        (args.output/'session.pending.mp4').rename(args.output/'session.mp4')
        report.update(status='pass_original_arm_window_export_with_common_origin_adapter',published=True)
    except Exception as error:
        report.update(status='rejected_inputs_and_pending_retained',error=str(error),traceback=traceback.format_exc(),published=False)
    finally:
        report['input_hashes_unchanged']=all(base.digest(x['path'])==x['sha256'] for x in report.get('inputs',[]))
        (args.output/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:report.get(k) for k in ('status','error','published','input_hashes_unchanged')}),flush=True)
    return 0 if report['published'] else 2

if __name__=='__main__':raise SystemExit(main())
