#!/usr/bin/env python3
"""Offline compiled AAC owner + C custody + original ARM event3/Close0.

Real archived I/P video and AAC. File, OS and naming are explicit RAM models.
Custody success attests byte copies surviving native Close, never durable SD.
Final AAC beyond video end remains owned; strict consumer/coverage gates remain.
"""
from __future__ import annotations
import argparse
from collections import Counter
import ctypes as C
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import traceback
import audit_prerecord_event3_rollover as event
import audit_prerecord_minute_rollover as minute

g,n,s=event.g,event.n,event.s
ROOT=g.ROOT
SPLIT=Fraction(8008,30000);END=Fraction(16016,30000)
C_WRAPPER=r'''
#include "yi4k_1107_aac_boundary.h"
#include "yi4k_1107_packet_custody.h"
#include <string.h>
#define CAP 1048576
static yi4k_1107_aac_boundary owner;
static unsigned char lookahead[32768];
static yi4k_1107_codec_config config;
static yi4k_1107_packet_custody custody[4];
static yi4k_1107_custody_slot slots[4][16];
static unsigned char video[2][16][CAP],audio[2][16][2048];
static uint32_t track_index(uint32_t segment,uint32_t track){return (segment-1)*2+track;}
int fresh(uint32_t audio_slots){
 memset(&owner,0,sizeof(owner));memset(&config,0,sizeof(config));
 config.sample_rate=48000;config.samples_per_aac=1024;config.channels=2;
 memset(config.identity,1,32);memset(config.config_digest,2,32);
 yi4k_1107_aac_time split={8008,30000};
 int r=yi4k_1107_aac_boundary_init(&owner,lookahead,sizeof(lookahead),&config,1,1,0,split);
 if(r)return r;
 for(uint32_t seg=1;seg<=2;seg++)for(uint32_t track=0;track<2;track++){
  uint32_t ix=track_index(seg,track);memset(&custody[ix],0,sizeof(custody[ix]));
  memset(slots[ix],0,sizeof(slots[ix]));
  for(uint32_t i=0;i<16;i++){slots[ix][i].payload=track?audio[seg-1][i]:video[seg-1][i];slots[ix][i].capacity=track?2048:CAP;}
  r=yi4k_1107_custody_init(&custody[ix],slots[ix],track?audio_slots:16,track?2:1);if(r)return r;
  r=yi4k_1107_custody_begin(&custody[ix],seg);if(r)return r;
 }
 return 0;
}
int offer(const unsigned char *data,uint32_t size,uint32_t seq,uint64_t pts){
 yi4k_1107_aac_input in;memset(&in,0,sizeof(in));
 in.packet.payload=data;in.packet.source_kind=2;in.packet.descriptor.sequence=seq;
 in.packet.descriptor.corrected_pts=pts;in.packet.descriptor.type=8;in.packet.descriptor.flags=1;
 in.packet.descriptor.payload_size=size;in.packet.descriptor.cpu_payload_address=0x20100000;
 memcpy(in.identity,config.identity,32);memcpy(in.config_digest,config.config_digest,32);
 in.epoch_id=1;in.dts=in.pts=pts;in.scale=48000;in.duration=1024;
 return yi4k_1107_aac_boundary_offer(&owner,&in);
}
int advance(void){yi4k_1107_aac_time split={16016,30000};return yi4k_1107_aac_boundary_advance(&owner,2,owner.held.pts,split);}
int store_audio(void){
 if(owner.state!=YI4K_AAC_READY)return -98;
 return yi4k_1107_custody_store(&custody[track_index((uint32_t)owner.segment_id,1)],&owner.held.packet);
}
int owner_receipt(uint32_t outcome){return yi4k_1107_aac_boundary_receipt(&owner,owner.ticket,outcome);}
uint32_t owner_read(unsigned char *out){memcpy(out,lookahead,owner.held.packet.descriptor.payload_size);return owner.held.packet.descriptor.payload_size;}
uint64_t owner_field(uint32_t field){switch(field){case 0:return owner.state;case 1:return owner.ticket;case 2:return owner.held.pts;case 3:return owner.held.packet.descriptor.sequence;case 4:return owner.segment_id;case 5:return owner.source_epoch;default:return 0;}}
int store_video(uint32_t seg,const unsigned char *data,uint32_t size,uint32_t seq,uint64_t pts,uint32_t type){
 yi4k_1107_mux_packet p;memset(&p,0,sizeof(p));p.payload=data;p.source_kind=1;
 p.descriptor.sequence=seq;p.descriptor.corrected_pts=pts;p.descriptor.type=(uint8_t)type;
 p.descriptor.flags=1;p.descriptor.payload_size=size;
 return yi4k_1107_custody_store(&custody[track_index(seg,0)],&p);
}
int closed(uint32_t seg,uint32_t track,int32_t status){return yi4k_1107_custody_closed(&custody[track_index(seg,track)],status);}
int check(uint32_t seg,uint32_t track,uint32_t seq,uint64_t pts,uint32_t type,const unsigned char *data,uint32_t size){
 yi4k_1107_frame_desc d;memset(&d,0,sizeof(d));d.sequence=seq;d.corrected_pts=pts;d.type=(uint8_t)type;d.flags=1;d.payload_size=size;
 return yi4k_1107_custody_check(&custody[track_index(seg,track)],seg,&d,data);
}
int commit(uint32_t seg,uint32_t track){return yi4k_1107_custody_commit(&custody[track_index(seg,track)],seg,1);}
uint32_t custody_field(uint32_t seg,uint32_t track,uint32_t field){
 yi4k_1107_packet_custody *c=&custody[track_index(seg,track)];
 return field==0?c->state:field==1?c->count:c->checked;
}
uint32_t retained(uint32_t seg,uint32_t track,uint32_t slot,unsigned char *out){
 yi4k_1107_custody_slot *s=&slots[track_index(seg,track)][slot];memcpy(out,s->payload,s->descriptor.payload_size);return s->descriptor.payload_size;
}
'''


def require(ok,message):
    if not ok:raise RuntimeError(message)


def digest(path):
    with path.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()


class Compiled:
    def __init__(self,out):
        wrapper=out/'integration-wrapper.c';wrapper.write_text(C_WRAPPER)
        target=out/'integration.dylib';clang=shutil.which('clang');require(clang,'clang missing')
        self.command=[clang,'-std=c11','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC',
            '-I'+str(ROOT/'sdk'),str(wrapper),str(ROOT/'sdk/yi4k_1107_aac_boundary.c'),
            str(ROOT/'sdk/yi4k_1107_packet_custody.c'),'-o',str(target)]
        subprocess.run(self.command,check=True,capture_output=True)
        self.lib=C.CDLL(str(target));u32=C.c_uint32;u64=C.c_uint64;pointer=C.POINTER(C.c_ubyte)
        for name,args in [('fresh',[u32]),('offer',[pointer,u32,u32,u64]),('advance',[]),
            ('store_audio',[]),('owner_receipt',[u32]),('store_video',[u32,pointer,u32,u32,u64,u32]),
            ('closed',[u32,u32,C.c_int32]),('check',[u32,u32,u32,u64,u32,pointer,u32]),
            ('commit',[u32,u32]),('custody_field',[u32,u32,u32]),('retained',[u32,u32,u32,pointer]),
            ('owner_read',[pointer])]:
            fn=getattr(self.lib,name);fn.argtypes=args;fn.restype=C.c_int32
        self.lib.owner_field.argtypes=[u32];self.lib.owner_field.restype=u64
    def buffer(self,data):return (C.c_ubyte*len(data)).from_buffer_copy(data)
    def owner_bytes(self):
        out=(C.c_ubyte*32768)();size=self.lib.owner_read(out);return bytes(out[:size])
    def retained(self,seg,track,slot):
        out=(C.c_ubyte*1048576)();size=self.lib.retained(seg,track,slot,out);return bytes(out[:size])
    def state(self,seg):
        return [[int(self.lib.custody_field(seg,st,k)) for k in range(3)] for st in (0,1)]


def initialize(image):
    # Same native two-slot factory as the frozen event3 audit, with one new
    # subclass filtering only unrelated hook register reads; 200ms fixture limit.
    m=minute.Machine(image);track,mem=m.setup_index()
    for i,value in enumerate([2,0,0,s.MOVIE,2*0x709,2]):m.put(event.f.CFG+i*4,value)
    m.uc.mem_write(event.f.NAME,b'integration-first.mp4\0'+bytes(40))
    require(m.call(0xa03e3c48,event.f.CFG)==0,'factory init')
    require(m.call(0xa03e3f00,event.f.NAME,s.RESULT)==0,'factory new')
    require(m.call(0xa0440cd4,s.MOVIE,s.CONFIG)==0,'config')
    require(m.call(0xa03feccc,event.f.MUXCFG)==0,'mux config')
    for off,value in [(0,s.STREAM),(4,mem),(8,2)]:m.put(event.f.MUXCFG+off,value)
    require(m.call(0xa03fed44,event.f.MUXCFG,s.RESULT)==0,'mux new')
    mux=m.get(s.RESULT);m.put(mux+4,s.MOVIE);m.put(mux+0x10,200)
    m.phase='first_segment';require(m.call(0xa03fe468,mux)==0,'first Open')
    return m,track,mux


def configure(m,mux):
    minute.configure_event(m,mux)
    # Explicit synthetic200ms matches frozen short event3 fixture, not minute.
    m.put(0xa06d42c8,200);m.put(event.PIPE+0x60,200)


def actual_closed_check(c,seg,path,data,submitted,epoch,strict_expected):
    path.write_bytes(data)
    expected_file_sha=n.sha(data);data=path.read_bytes()
    require(n.sha(data)==expected_file_sha,'closed file readback differs')
    normal=g.probe(path);packets=g.packets(normal,data)
    original=g.probe(path,True);raw_packets=g.packets(original,data);box=g.container_timeline(data)
    status=[]
    for st in (0,1):
        require(c.lib.closed(seg,st,0)==0,'custody Close success')
        emitted=[p for p in raw_packets if p['stream']==st]
        expected=[p for p in submitted if p['stream']==st]
        require(len(emitted)==len(expected),'native Close lost submitted sample')
        rate=30000 if st==0 else 48000;delay=box['tracks'][st]['delay']
        delay=Fraction(delay['numerator'],delay['denominator'])
        # Identity is recovered only after exact timestamp inversion from native
        # tables. No rounded PTS or source oracle payload is supplied to C check.
        for p in emitted:
            ticks=(epoch+delay+Fraction(p['pts'],rate))*rate
            require(ticks.denominator==1,'closed timestamp cannot invert exactly')
            sequence=next((q['index'] for q in expected if q['pts']==int(ticks)),None)
            require(sequence is not None,'closed original identity unavailable')
            kind=8 if st else 1 if p['key'] else 3
            # Read actual closed MP4 extent into a fresh buffer distinct from C
            # custody; never use expected/source bytes for the C payload check.
            payload=data[p['offset']:p['offset']+p['bytes']]
            status.append(c.lib.check(seg,st,sequence,int(ticks),kind,c.buffer(payload),len(payload)))
        require(all(v==0 for v in status),'C closed-output byte/identity check failed')
        require(c.lib.commit(seg,st)==0,'C commit failed after independent checks')
    gate=minute.comparison(packets,strict_expected,normal['streams'],epoch)
    return dict(file=path.name,sha256=n.sha(data),bytes=len(data),epoch=g.rational(epoch),
        submitted_counts=dict(Counter(p['stream'] for p in submitted)),
        output_counts=dict(Counter(p['stream'] for p in packets)),
        closed_file_readback_verified=True,custody_check_statuses=status,custody_after_commit=c.state(seg),
        strict_consumer_gate=gate,container=box,
        packets=[g.public_packet(p) for p in packets])


def scenario(c,image,selected,sps,pps,out,mode):
    require(c.lib.fresh(11 if mode=='capacity' else 16)==0,'compiled composition init')
    m,track,mux=initialize(image);movie=s.MOVIE;segment=1
    submissions={1:[],2:[]};report=dict(name=mode,events=[],segments=[])
    boundary=next(p for p in selected if p['stream']==0 and p['index']==8)
    crossing=None;closed=False
    def submit_audio(p):
        status=c.lib.store_audio();report['events'].append(dict(kind='C_custody_store_audio',index=p['index'],status=status,segment=segment))
        if status==1:
            # Nothing has been submitted to original ProcessAudio and no
            # owner receipt has occurred; every prior slot remains owned.
            report.update(backpressure=dict(index=p['index'],owner_state=int(c.lib.owner_field(0)),
                owner_ticket=int(c.lib.owner_field(1)),owner_sha256=n.sha(c.owner_bytes()),
                custody_state=c.state(segment),native_audio_submissions=sum(q['stream']==1 for q in submissions[segment])))
            require(c.owner_bytes()==p['data'],'FULL lost owner bytes')
            require(c.lib.owner_field(0)==1,'FULL released/changed owner')
            return False
        require(status==0,'C custody store failed')
        stored=c.retained(segment,1,int(c.lib.custody_field(segment,1,1))-1)
        require(stored==p['data'],'C custody copy differs')
        require(c.lib.owner_receipt(1)==0,'owner custody-confirmed receipt')
        packet=dict(p,data=stored)
        event.load_packet(m,packet,sps,pps)
        status=event.process(m,movie,mux,packet)
        require(status==0,'native ProcessAudio failed')
        # C custody remains COLLECT with positive count after writer success.
        require(c.lib.custody_field(segment,1,0)==1,'writer success released custody')
        submissions[segment].append(p)
        return True
    for p in selected:
        if p['stream']==1:
            upstream=c.buffer(p['data']);decision=c.lib.offer(upstream,p['bytes'],p['index'],p['pts'])
            report['events'].append(dict(kind='C_owner_offer',index=p['index'],decision=decision,segment=segment))
            require(decision in (1,2),'C owner refused valid archive AAC')
            for i in range(len(upstream)):upstream[i]=0xdd
            require(c.owner_bytes()==p['data'],'upstream overwrite corrupted owner')
            if decision==2:
                require(crossing is None or p['index']==25,'second held packet unexpected')
                if segment==1:crossing=p
                else:
                    report['final_tail']=dict(packet=g.public_packet(p),owner_state=int(c.lib.owner_field(0)),
                        owner_ticket=int(c.lib.owner_field(1)),owned_sha256=n.sha(c.owner_bytes()),
                        submitted_to_writer=False,released=False)
                continue
            if not submit_audio(p):return m,submissions,report
        else:
            if p['index']==8:
                require(crossing is not None and crossing['index']==12,'C owner must hold AAC12 before rollover')
                event.load_packet(m,p,sps,pps);before=minute.fifo(m,track)
                m.phase='boundary_limit';require(event.process(m,movie,mux,p)==3,'boundary status3')
                configure(m,mux)
                if mode=='close_failure':m.short_write_at=len(m.writes)
                m.phase='original_event3'
                try:status=m.call(0xa0443720,event.PIPE,mux,3)
                except RuntimeError as error:
                    require(mode=='close_failure' and 'firmware assertion' in str(error),'unexpected native failure')
                    frozen=[]
                    for st in (0,1):frozen.append(c.lib.closed(1,st,-12))
                    require(frozen==[-4,-4],'Close failure did not freeze custody')
                    require(c.lib.owner_field(0)==2 and c.owner_bytes()==crossing['data'],'Close failure lost held AAC12')
                    report.update(close_failure=dict(error=str(error),custody_status=frozen,custody_state=c.state(1),
                        held_boundary=g.public_packet(crossing),held_bytes_preserved=True,
                        new_movie_allocated=any(x['entry']=='0xa03e3f00' and x['phase']=='original_event3' for x in m.transitions)))
                    require(not report['close_failure']['new_movie_allocated'],'failed Close opened new movie')
                    return m,submissions,report
                require(status==0 and len(m.closed_files)==1,'event3 callback failed')
                # Independently verify file1 while second movie already open;
                # upstream heldAAC12 remains NEXT until successful old checks.
                first_expected=[q for q in selected if (q['stream']==0 and q['index']<8) or (q['stream']==1 and q['index']<12)]
                report['segments'].append(actual_closed_check(c,1,out/'segment-1.mp4',m.closed_files[0],
                    submissions[1],Fraction(),first_expected))
                require(c.lib.advance()==1,'C owner advance failed')
                segment=2;movie=m.get(mux+4)
                after=minute.fifo(m,movie+0x78)
                require(all(before[k]==after[k] for k in ('cursor','fifo','descriptor')),'event3 changed retained video')
                dts=after['dts'];epoch=min(Fraction(boundary['pts'],30000),Fraction(crossing['pts'],48000))
                report['rollover']=dict(before=before,after=after,event_status=status,new_movie=hex(movie),
                    source_epoch=g.rational(epoch),C_owner_epoch=int(c.lib.owner_field(5)),native_reset_dts=dts)
                require(dts==[2624,0],'native Reset did not align C heldAAC12 epoch')
                # Copy video8 to C custody, write retained descriptor without
                # loading again, then submit heldAAC12 out of caller lookahead.
                data=p['data'];require(c.lib.store_video(segment,c.buffer(data),len(data),p['index'],p['pts'],1)==0,'video8 custody')
                m.phase='retained_boundary';require(event.process(m,movie,mux,p)==0,'retained video8')
                submissions[segment].append(p)
                require(submit_audio(crossing),'new-segment custody full unexpectedly')
                crossing=None;closed=True
                continue
            data=p['data'];kind=1 if p['key'] else 3
            require(c.lib.store_video(segment,c.buffer(data),len(data),p['index'],p['pts'],kind)==0,'video custody store')
            event.load_packet(m,p,sps,pps);require(event.process(m,movie,mux,p)==0,'native video Process')
            submissions[segment].append(p)
    require(closed and mode=='normal','normal scenario did not rollover')
    m.phase='final_Close0';require(m.call(0xa03fe300,mux,0)==0,'final native Close0')
    # Final tail AAC25 was never admitted by the C exact end<=split rule. It
    # remains in owner NEXT; no unknown next split/Close1 is invented.
    second_expected=[q for q in selected if (q['stream']==0 and q['index']>=8) or (q['stream']==1 and q['index']>=12)]
    report['segments'].append(actual_closed_check(c,2,out/'segment-2.mp4',bytes(m.output),
        submissions[2],Fraction(12*1024,48000),second_expected))
    require(report.get('final_tail',{}).get('packet',{}).get('index')==25,'final tail not held')
    report['custody_release_scope']='Submitted samples only; exact closed-output identities/bytes verified by C. Consumer timeline/publication gate is separate.'
    report['strict_publication_gate']='reject' # final tail missing from current closed window, plus consumer timing
    return m,submissions,report


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',required=True,type=Path)
    out=ap.parse_args().output;out.mkdir(parents=True,exist_ok=False)
    hashes={str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__).resolve(),
        ROOT/'sdk/yi4k_1107_aac_boundary.c',ROOT/'sdk/yi4k_1107_packet_custody.c',
        Path(event.__file__).resolve(),Path(minute.__file__).resolve(),
        *[ROOT/'scripts'/name for name in event.FROZEN],
        *sorted((ROOT/'sdk').glob('yi4k_1107_*.h'))]}
    report=dict(schema=1,status='running',offline_only=True,device_access=False,source_hashes=hashes,
        synthetic_limit_ms=200,split=g.rational(SPLIT),video_end=g.rational(END),
        limitations=['Host compiled controllers + original ARM mux in Unicorn/RAM file/OS models; no live producer, hooks or SD.',
            'Short16video/26AAC archived fixture, not minute throughput or a live prerecord buffer.',
            'C identity checks use exact caller source epoch mapping; MP4 does not authenticate original FIFO sequences.',
            'RAM custody survives modeled close only; no durability/power-loss or production scheduler proof.'])
    try:
        for name,sha in event.FROZEN.items():require(digest(ROOT/'scripts'/name)==sha,'frozen harness changed')
        raw=s.SAMPLE_MP4.read_bytes();require(n.sha(raw)==g.SOURCE_SHA,'source archive changed')
        image=s.life.arm.IMAGE.read_bytes();require(n.sha(image)==s.life.arm.DIGEST,'firmware changed')
        source=g.probe(s.SAMPLE_MP4);packets=g.packets(source,raw)
        selected=[p for p in packets if Fraction(p['pts'],30000 if p['stream']==0 else 48000)<END]
        require([sum(p['stream']==st for p in selected) for st in (0,1)]==[16,26],'fixture counts changed')
        sps,pps=g.avcc(g.extradata(source['streams'][0]['extradata']))
        compiled=Compiled(out);report['compile_command']=compiled.command
        report['scenarios']=[];source_frames=g.frame_hashes(s.SAMPLE_MP4,16)
        for mode in ('normal','capacity','close_failure'):
            folder=out/mode;folder.mkdir()
            m,submissions,case=scenario(compiled,image,selected,sps,pps,folder,mode)
            case['submitted_counts']={str(seg):dict(Counter(p['stream'] for p in ps)) for seg,ps in submissions.items()}
            # Preserve all retained C bytes including failed/transitional state.
            case['retained']={}
            for seg in (1,2):
                for st in (0,1):
                    count=int(compiled.lib.custody_field(seg,st,1))
                    expected=[p for p in submissions[seg] if p['stream']==st]
                    if compiled.lib.custody_field(seg,st,0)==0:
                        require(count==0,'committed custody still active')
                        continue
                    require(count==len(expected),'unexpected retained custody count')
                    for slot in range(count):
                        data=compiled.retained(seg,st,slot);name=f'custody-seg{seg}-track{st}-slot{slot}.bin'
                        require(data==expected[slot]['data'],'native operations changed retained C custody bytes')
                        (folder/name).write_bytes(data);case['retained'][name]=n.sha(data)
            case['all_uncommitted_custody_bytes_match_original_submissions']=True
            if mode=='normal':
                for number,seg in enumerate(case['segments']):
                    path=folder/seg['file'];decoded=g.frame_hashes(path)
                    require(decoded==source_frames[number*8:(number+1)*8],'video decode differs')
                    audio=[p for p in submissions[number+1] if p['stream']==1]
                    ref=folder/f'exported-audio-{number+1}.aac';ref.write_bytes(b''.join(g.adts(p['data']) for p in audio))
                    pcm=g.pcm(path);require(pcm==g.pcm(ref,True),'native exported AAC PCM differs')
                    seg['decode']=dict(video_frames=len(decoded),matches_source_video=True,
                        pcm_bytes=len(pcm),matches_all_submitted_AAC=True,pcm_sha256=n.sha(pcm))
                (folder/'final-held-aac25.bin').write_bytes(compiled.owner_bytes())
                require(case['segments'][0]['strict_consumer_gate']['status']=='pass','segment1 strict gate should pass')
            elif mode=='capacity':
                require(case['backpressure']['index']==11,'wrong capacity stop')
                require(case['backpressure']['native_audio_submissions']==11,'unretained AAC submitted')
                (folder/'held-aac11.bin').write_bytes(compiled.owner_bytes())
            else:
                require(case['close_failure']['custody_state'][0][0]==3 and case['close_failure']['custody_state'][1][0]==3,'not frozen')
                (folder/'held-boundary-aac12.bin').write_bytes(compiled.owner_bytes())
                (folder/'partial-native.mp4').write_bytes(m.output)
            case.update(native_calls=m.transitions,modeled_external_events=m.external,diagnostics=m.logs)
            report['scenarios'].append(case)
        require(all(digest(ROOT/p)==h for p,h in hashes.items()),'implementation changed during run')
        report['status']='pass_composition_with_expected_publication_rejection'
        report['strict_publication_gate']='reject'
    except Exception as error:
        report.update(status='execution_failed',error=str(error),traceback=traceback.format_exc(),strict_publication_gate='reject')
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report.get(k) for k in ('status','error','strict_publication_gate')},indent=2))
    return int(report['status']=='execution_failed')

if __name__=='__main__':raise SystemExit(main())
