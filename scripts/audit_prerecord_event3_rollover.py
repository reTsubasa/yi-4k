#!/usr/bin/env python3
"""Offline stock event-3 rollover with original format/factory/reset instructions.

Archived packets and explicit RAM files, naming, OS and optional-userdata models.
Never accesses a camera. Expected packet/timestamp rejections remain evidence.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
from capstone import Cs,CS_ARCH_ARM,CS_MODE_ARM
from unicorn.arm_const import UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3,UC_ARM_REG_LR,UC_ARM_REG_PC
import audit_prerecord_real_gop as g

n,f,s=g.native,g.factory,g.s
ROOT=g.ROOT
PIPE=0x1101c000
FILE_OPEN,FILE_CLOSE,NAME_CALLBACK=0x10012000,0x10012100,0x10012200
WATCH={0xa0443720,0xa0442674,0xa04404d8,0xa0441fe0,0xa0441d60,0xa01f569c,
       0xa03fe300,0xa03e3f00,0xa03e41a0,0xa03e40c8,0xa01f68b8,0xa01f3124,
       0xa03fe468,0xa0451960,0xa0451c94}
FROZEN={'audit_prerecord_real_gop.py':'a2b0835d771a1775bf8a60f8ee96c2d110fe7c16e899a855f793f7939ae7f12f',**g.FROZEN}

def sha(data):return hashlib.sha256(data).hexdigest()

class EventMachine(g.GopMachine):
    def __init__(self,image):
        super().__init__(image)
        self.uc.mem_map(0xa13c2000,0x1000)
        self.transitions=[];self.external=[];self.closed_files=[]
        self.put(s.VTABLE,FILE_OPEN);self.put(s.VTABLE+4,FILE_CLOSE)
    def hook(self,uc,address,size,user):
        args=[uc.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
        if address in WATCH:
            self.transitions.append(dict(entry=hex(address),args=[hex(x) for x in args],
                lr=hex(uc.reg_read(UC_ARM_REG_LR)),phase=self.phase))
        result=None;kind=None
        if address==FILE_CLOSE:
            assert args[0]==s.STREAM
            self.closed_files.append(bytes(self.output));kind='ram_file_close';result=0
        elif address==FILE_OPEN:
            assert args[0]==s.STREAM and args[2]==2
            self.output=bytearray();self.position=0;kind='ram_file_open';result=0
        elif address==NAME_CALLBACK:
            self.uc.mem_write(0xa13c29f8,b'event3-second.mp4\0');kind='unique_name_callback';result=0
        elif address==0xa021f894:
            kind='secondary_stream_disabled_query';result=0
        elif address==0xa01f538c:
            kind='optional_userdata_omitted';result=0
        elif address==0xa01e659c:
            kind='app_message';result=0
        elif address==0xa0440998:
            kind='diagnostic_pipe_formatting_omitted';result=0
        elif address==0xa04f9450:
            # OnPipeLimit builds only a diagnostic prefix before PrintPipeInfo.
            self.uc.mem_write(args[0],b'offline-limit\0');kind='diagnostic_sprintf_model';result=0
        if result is not None:
            self.external.append(dict(kind=kind,address=hex(address),args=[hex(x) for x in args],phase=self.phase))
            uc.reg_write(UC_ARM_REG_R0,result);uc.reg_write(UC_ARM_REG_PC,uc.reg_read(UC_ARM_REG_LR));return
        super().hook(uc,address,size,user)

def adapted(packet,sps,pps):
    data=packet['data']
    if packet['stream']==0:
        data=b''.join(b'\0\0\0\1'+nal for nal in g.split_nals(data))
        if packet['key']:data=b'\0\0\0\1'+sps+b'\0\0\0\1'+pps+data
    return data

def load_packet(m,packet,sps,pps):
    data=adapted(packet,sps,pps)
    m.descriptor(data,m.payload(data,32),1 if packet['stream']==0 and packet['key'] else 3 if packet['stream']==0 else 8,packet['pts'])
    return data

def process(m,movie,mux,packet):
    track=movie+0x78
    if packet['stream']==0:
        return m.call(0xa042d0f8,movie,track,movie+0x350,mux+0x58,s.STREAM,200,0xffffffff,0xffffffff)
    return m.call(0xa043173c,movie,track+0x90,mux+0x58,s.STREAM,0,200,0xffffffff,0xffffffff)

def compare_segment(actual,submitted,streams,origin):
    rows=[];missing=[]
    for stream in (0,1):
        expected=[p for p in submitted if p['stream']==stream]
        observed=[p for p in actual if p['stream']==stream]
        assert len(observed)<=len(expected)
        rate=30000 if stream==0 else 48000;time_base=Fraction(streams[stream]['time_base'])
        for old,new in zip(expected,observed):
            pts_error=new['pts']*time_base-(Fraction(old['pts'],rate)-origin)
            dts_error=new['dts']*time_base-(Fraction(old['dts'],rate)-origin)
            duration_error=new['duration']*time_base-Fraction(old['duration'],rate)
            rows.append(dict(stream=stream,source_index=old['index'],same_payload=old['sha256']==new['sha256'],
                pts_error=g.rational(pts_error),dts_error=g.rational(dts_error),duration_error=g.rational(duration_error)))
        missing.extend(g.public_packet(p) for p in expected[len(observed):])
    payload=all(p['same_payload'] for p in rows)
    timing=all(all(p[k]['numerator']==0 for k in ('pts_error','dts_error','duration_error')) for p in rows)
    return dict(status='pass' if payload and timing and not missing else 'reject',same_retained_payload=payload,
        exact_retained_timing=timing,missing_submitted_packets=missing,compared_packets=rows)

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--fail-old-close',action='store_true',help='Inject one RAM-file short write during original old-segment Close0.')
    args=ap.parse_args();out=args.output;out.mkdir(parents=True,exist_ok=False)
    for name,digest in FROZEN.items():assert sha((ROOT/'scripts'/name).read_bytes())==digest
    image=s.life.arm.IMAGE.read_bytes();assert sha(image)==s.life.arm.DIGEST
    cs=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    convention={0xa043d320:('mov','sl, r0'),0xa043d32c:('mov','r1, r4'),
        0xa043d330:('mov','r2, sl'),0xa043d334:('mov','r0, r6'),
        0xa043d338:('bl','#0xa0443720')}
    calling_convention=[]
    for address,expected in convention.items():
        ins=next(cs.disasm(image[address-0xa0100000:address-0xa0100000+4],address))
        assert (ins.mnemonic,ins.op_str)==expected
        calling_convention.append(dict(site=hex(address),instruction=ins.mnemonic+' '+ins.op_str,bytes=ins.bytes.hex()))
    raw=s.SAMPLE_MP4.read_bytes();assert sha(raw)==g.SOURCE_SHA
    source=g.probe(s.SAMPLE_MP4);packets=g.packets(source,raw)
    sps,pps=g.avcc(g.extradata(source['streams'][0]['extradata']))
    m=EventMachine(image);track,mem=m.setup_index()
    for i,value in enumerate([2,0,0,s.MOVIE,2*0x709,2]):m.put(f.CFG+i*4,value)
    m.uc.mem_write(f.NAME,b'event3-first.mp4\0'+bytes(48))
    assert m.call(0xa03e3c48,f.CFG)==0
    assert m.call(0xa03e3f00,f.NAME,s.RESULT)==0 and m.get(s.RESULT)==s.MOVIE
    assert m.call(0xa0440cd4,s.MOVIE,s.CONFIG)==0
    assert m.call(0xa03feccc,f.MUXCFG)==0
    for off,value in [(0,s.STREAM),(4,mem),(8,2)]:m.put(f.MUXCFG+off,value)
    assert m.call(0xa03fed44,f.MUXCFG,s.RESULT)==0;mux=m.get(s.RESULT)
    m.put(mux+4,s.MOVIE);m.put(mux+0x10,200)
    m.phase='first_segment';assert m.call(0xa03fe468,mux)==0
    first=[p for p in packets if Fraction(p['pts'],30000 if p['stream']==0 else 48000)<Fraction(8008,30000)]
    first_status=[]
    for p in first:
        load_packet(m,p,sps,pps);status=process(m,s.MOVIE,mux,p);assert status==0
        first_status.append(dict(source=g.public_packet(p),status=status))
    boundary=next(p for p in packets if p['stream']==0 and p['index']==8)
    assert boundary['key']
    load_packet(m,boundary,sps,pps)
    before=dict(cursor=m.get(s.life.VIRTUAL+0x90,8),fifo=bytes(m.uc.mem_read(s.life.VIRTUAL,0xd0)).hex(),
        descriptor=bytes(m.uc.mem_read(s.life.QUEUE,32)).hex(),dts=[m.get(track+off,8) for off in (0x20,0xb0)])
    m.phase='boundary_limit';assert process(m,s.MOVIE,mux,boundary)==3
    assert m.get(s.life.VIRTUAL+0x90,8)==before['cursor']
    limit_dts=[m.get(track+off,8) for off in (0x20,0xb0)]
    for address,value in [(0xa13c2a44,mux),(0xa13c1768,s.MOVIE),(0xa13c2a54,s.STREAM),
            (0xa13c29f4,1),(0xa13c1774,NAME_CALLBACK),(0xa13c2a50,0),
            (0xa13c2a40,2),(0xa13c2a5c,0),(0xa06d42c8,200)]:m.put(address,value)
    m.put(0xa06d42c0,0,8)
    m.put(PIPE,mux);m.put(PIPE+0x10,1,1);m.put(PIPE+0x14,0xa01f569c)
    m.put(PIPE+0x60,200);m.put(PIPE+0x68,0xffffffffffffffff,8);m.put(PIPE+0x72,2,1)
    if args.fail_old_close:m.short_write_at=len(m.writes)
    m.phase='original_event3'
    try:event_status=m.call(0xa0443720,PIPE,mux,3)
    except RuntimeError as error:
        if not args.fail_old_close:raise
        assert 'firmware assertion' in str(error),str(error)
        assert m.get(mux+4)==s.MOVIE and not m.closed_files
        assert not any(c['entry']=='0xa03e3f00' and c['phase']=='original_event3' for c in m.transitions)
        report=dict(schema=1,status='reject_original_callback_asserts_on_close_failure',offline_only=True,
            firmware_sha256=sha(image),script_sha256=sha(Path(__file__).read_bytes()),
            frozen_harness_sha256=FROZEN,source_sha256=sha(raw),error=str(error),
            original_event_calling_convention=calling_convention,
            injection='One explicit modeled RAM-file short write at the first Close0 write; original error propagation and assertion execute.',
            original_calls=m.transitions,modeled_external_events=m.external,diagnostics=m.logs,
            modeled_writes=m.writes[-8:],old_movie_retained=True,new_movie_not_allocated=True,
            file_stream_not_closed=True,safe_device_rollover_ready=False,
            limitations=['No camera/SD/error recovery executed. Unicorn stops at original assertion helper rather than executing firmware disable-interrupts/infinite-loop suffix.',
                'This is a demonstrated recovery gap, not a graceful rollback implementation.'])
        (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(dict(output=str(out),status=report['status'],error=str(error))))
        return
    assert not args.fail_old_close,'Injected short write must not be ignored'
    assert event_status==0
    new_movie=m.get(mux+4);new_track=new_movie+0x78
    assert new_movie==s.MOVIE+0x708
    after=dict(cursor=m.get(s.life.VIRTUAL+0x90,8),fifo=bytes(m.uc.mem_read(s.life.VIRTUAL,0xd0)).hex(),
        descriptor=bytes(m.uc.mem_read(s.life.QUEUE,32)).hex(),movie=hex(new_movie),
        dts=[m.get(new_track+off,8) for off in (0x20,0xb0)],pipe_state=m.get(PIPE+0x72,1),
        split_counter=m.get(0xa13c29f4),format_open=m.get(mux+0xf80,1))
    assert after['fifo']==before['fifo'] and after['descriptor']==before['descriptor']
    assert after['cursor']==before['cursor'] and after['split_counter']==2 and after['format_open']==1
    m.phase='retained_first_sample';assert process(m,new_movie,mux,boundary)==0
    assert m.get(s.life.VIRTUAL+0x90,8)==before['cursor']+1
    # Feed the remaining seven video packets and subsequent AAC packets. This
    # is a caller-owned queue model, not the entire stock mux scheduler.
    second=[p for p in packets if Fraction(8008,30000)<=Fraction(p['pts'],30000 if p['stream']==0 else 48000)<Fraction(16016,30000)]
    for p in second:
        if p['stream']==0 and p['index']==8:continue
        load_packet(m,p,sps,pps);assert process(m,new_movie,mux,p)==0
    m.phase='final_close';assert m.call(0xa03fe300,mux,0)==0
    assert len(m.closed_files)==1
    reports=[]
    source_frames=g.frame_hashes(s.SAMPLE_MP4,16)
    for number,data in enumerate([m.closed_files[0],bytes(m.output)],1):
        path=out/f'event3-segment-{number}.mp4';path.write_bytes(data)
        probe=g.probe(path);actual=g.packets(probe,data)
        decoded_video=g.frame_hashes(path);decoded_audio=g.pcm(path)
        assert decoded_video==source_frames[(number-1)*8:number*8]
        strict_gate=compare_segment(actual,first if number==1 else second,probe['streams'],
            Fraction(0) if number==1 else Fraction(8008,30000))
        reports.append(dict(file=path.name,bytes=len(data),sha256=sha(data),
            packet_counts=dict(Counter(p['stream'] for p in actual)),
            packets=[g.public_packet(p) for p in actual],container=g.container_timeline(data),
            video_frames=len(decoded_video),video_frame_md5=decoded_video,
            video_matches_archived_window=True,strict_packet_time_gate=strict_gate,
            audio_pcm_bytes=len(decoded_audio),audio_pcm_sha256=sha(decoded_audio)))
    assert all(r['strict_packet_time_gate']['status']=='reject' for r in reports)
    assert [p['index'] for r in reports for p in r['strict_packet_time_gate']['missing_submitted_packets']]==[12,25]
    assert reports[0]['strict_packet_time_gate']['exact_retained_timing']
    assert not reports[1]['strict_packet_time_gate']['exact_retained_timing']
    fs={int(x['entry'],16):x for x in json.loads((s.SRC.parent/'functions.json').read_text())}
    pins=[]
    for entry in sorted(WATCH):
        spans=[f'{entry:x}-a01f5fef'] if entry==0xa01f569c else fs[entry]['body_ranges']
        code=b''.join(image[int(span.split('-')[0],16)-0xa0100000:int(span.split('-')[1],16)-0xa0100000+1] for span in spans)
        pins.append(dict(entry=hex(entry),inclusive_ranges=spans,arm_sha256=sha(code)))
    report=dict(schema=1,status='offline_event3_executed',offline_only=True,firmware_sha256=sha(image),
        script_sha256=sha(Path(__file__).read_bytes()),source_sha256=sha(raw),
        frozen_harness_sha256=FROZEN,function_pins=pins,
        original_event_calling_convention=calling_convention,
        scope='Complete original OnMovieEvent/OnPipeLimit/event3 callback with original Close0/New/Copy/Rel/Reset/Open; explicit file/name/OS/notification models',
        synthetic_limit_ms=200,boundary_source=g.public_packet(boundary),first_submissions=first_status,
        before=before,limit_dts=limit_dts,after=after,event_status=event_status,
        original_calls=m.transitions,modeled_external_events=m.external,diagnostics=m.logs,segments=reports,
        publication_gate='reject_missing_AAC_12_and_25_and_segment_2_consumer_time_mismatch',
        proven=['Retained synchronous source video frame 8 survives complete modeled event3 callback and is written once to new MP4.',
            'Original Close0/New/Copy/Rel/count reset/ResetMovie/Open run in order, with same FIFO state before and after callback.',
            'Both resulting MP4s decode their eight distinct source video frames exactly.',
            'Normal event3 does not repair the AAC12/25 trimming loss or the segment2 1/240000 second consumer offset in this fixture.'],
        not_proven=['No camera/encoder/DMA/callback installation/SD writes or real-time scheduler.',
            'Short synthetic duration; not a one-minute ring/spool or complete pre-record feature.',
            'One constructed FIFO reused by caller, not simultaneous real audio/video producer queues.',
            'Packet/timestamp continuity requires separate strict comparison; successful Close and decoding are insufficient.'])
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(output=str(out),event_status=event_status,movie=hex(new_movie),segments=[r['packet_counts'] for r in reports])))

if __name__=='__main__':main()
