#!/usr/bin/env python3
"""Offline original movie factory release/recreate and public MP4 reopen audit."""
from __future__ import annotations
import argparse
from collections import Counter
import json
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import UC_HOOK_MEM_WRITE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_PC, UC_ARM_REG_LR
import audit_prerecord_native_mp4 as native

s=native.stock
ROOT=native.ROOT
OUT=ROOT/'artifacts/device/2026-11-11-prerecord-movie-factory'
CFG,NAME,MUXCFG=0x11018000,0x11018100,0x11018200
ROOTS={0xA03E3C48,0xA03F0EE8,0xA03E3F00,0xA03E30AC,0xA03E2D3C,0xA03E2FCC,0xA03E2E90,
       0xA03E40C8,0xA03E29DC,0xA0440CD4,0xA03FECCC,0xA03FED44,0xA03FDEC4,0xA0442F20,
       0xA03FE468,0xA03FE300,0xA0435A18,0xA0436004,0xA01F3338,0xA01F6088}
FROZEN_NATIVE_SHA='3dc7b00032803b6440124e8e6ce7316701a595333365253da935494bf208da99'

class FactoryMachine(native.NativeMachine):
    def __init__(self,image):
        super().__init__(image)
        self.factory_calls=[]
        self.phase=None
        self.movie_write_events=[]
        self.os_events=[]
        self.uc.hook_add(UC_HOOK_MEM_WRITE,self.movie_write)

    def movie_write(self,uc,access,address,size,value,user):
        if self.phase and address<s.MOVIE+0x708 and address+size>s.MOVIE:
            self.movie_write_events.append(dict(phase=self.phase,pc=hex(uc.reg_read(UC_ARM_REG_PC)),
                offset=address-s.MOVIE,bytes=size,value=hex(value)))

    def hook(self,uc,address,size,user):
        if address in ROOTS or address==0xA04F8DEC:
            args=[uc.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
            if address!=0xA04F8DEC or args[:3]==[s.MOVIE,0,0x708]:
                self.factory_calls.append(dict(entry=hex(address),args=args,phase=self.phase,
                    caller_return=hex(uc.reg_read(UC_ARM_REG_LR))))
        if address==0xA03BC49C:
            self.os_events.append(dict(kind='event_flag_create_model',object=hex(uc.reg_read(UC_ARM_REG_R0))))
            uc.reg_write(UC_ARM_REG_R0,0)
            uc.reg_write(UC_ARM_REG_PC,uc.reg_read(UC_ARM_REG_LR))
            return
        super().hook(uc,address,size,user)

def state(m,track,mux=None):
    return dict(movie=hex(s.MOVIE),memidx=hex(native.MEMOBJ),factory_flag=m.get(s.MOVIE+0x708,1),
        sample_counts=[m.get(track+0x10),m.get(track+0xA0)],
        dts=[m.get(track+0x20,8),m.get(track+0xB0,8)],
        magic=hex(m.get(s.MOVIE+4)),sps_bytes=m.get(s.PARAMS+0xB8,2),pps_bytes=m.get(s.PARAMS+0xBA,2),
        memidx_data_pointer=hex(m.get(native.MEMOBJ+0x38)),
        public_mux_open=m.get(mux+0xF80,1) if mux else None)

def sample(m,track,index,data,video,number):
    ptr=m.payload(data,32)
    m.descriptor(data,ptr,1 if video else 8,pts=number*(1001 if video else 1024))
    if video:return m.call(0xA042D0F8,s.MOVIE,track,s.PARAMS,index,s.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)
    return m.call(0xA043173C,s.MOVIE,track+0x90,index,s.STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)

def read_back(m,index,start):
    mapping={2:0,3:1,4:2,5:3,6:4,8:0,9:1,10:2}
    entries={}
    for entry in m.added[start:]:entries.setdefault((entry['track'],entry['kind']),[]).append(entry['data_hex'])
    before=len(m.index_reads);records=[]
    for (track,kind),values in entries.items():
        for i,expected in enumerate(values):
            width=len(bytes.fromhex(expected))
            assert m.call(0xA0401AE4,m.get(index+0x68),track,mapping[kind],i,0,width,s.RESULT)==0
            actual=bytes(m.uc.mem_read(s.RESULT,width)).hex()
            assert actual==expected,(track,kind,i,actual,expected)
            records.append(dict(track=track,kind=kind,index=i,value_hex=actual))
    assert len(m.index_reads)>before
    return dict(entries=records,actual_memidx_reads=len(m.index_reads)-before)

def pins(image):
    result=[]
    for f in json.loads((s.SRC.parent/'functions.json').read_text()):
        if int(f['entry'],16) not in ROOTS:continue
        body=b''
        for span in f['body_ranges']:
            low,high=[int(x,16) for x in span.split('-')]
            body+=image[low-0xA0100000:high-0xA0100000+1]
        source=s.SRC.parent/f['decompiled_file']
        result.append(dict(entry=f['entry'],body_ranges=f['body_ranges'],arm_sha256=native.sha(body),
            decompiled_file=str(source.relative_to(ROOT)),decompiled_sha256=native.sha(source.read_bytes())))
    assert len(result)==len(ROOTS)
    return result

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output','--output-dir',dest='output',type=Path,default=OUT)
    out=parser.parse_args().output;out.mkdir(parents=True,exist_ok=True)
    image=s.life.arm.IMAGE.read_bytes();assert native.sha(image)==s.life.arm.DIGEST
    native_path=Path(native.__file__);assert native.sha(native_path.read_bytes())==FROZEN_NATIVE_SHA
    video,nals,audio,source=s.load_archived_samples()
    m=FactoryMachine(image)
    # Retain the existing source/config fixture; the actual FormatInit and
    # factory below clear/recreate movie RAM through firmware instructions.
    track,mem=m.setup_index()
    for i,value in enumerate([1,0,0,s.MOVIE,0x709,2]):m.put(CFG+i*4,value)
    m.uc.mem_write(NAME,b'offline.mp4\0'+bytes(52))
    m.phase='format_init'
    assert m.call(0xA03E3C48,CFG)==0
    assert m.get(0xA19653E0)==s.MOVIE and m.get(0xA19653EC)==s.MOVIE+0x708
    assert m.get(0xA19653F9,1)==2 and m.get(0xA19653FA,1)==0
    pool=dict(movie_count=m.get(0xA19653D4),pool=hex(m.get(0xA19653E0)),flags=hex(m.get(0xA19653EC)),
        version=[m.get(0xA19653F9,1),m.get(0xA19653FA,1)])
    segments=[];boundary=[];mux=None
    for number,nvideo,naudio in [(1,3,4),(2,2,3)]:
        m.phase='new_movie_'+str(number)
        before=state(m,track,mux)
        write_start=len(m.movie_write_events)
        assert m.call(0xA03E3F00,NAME,s.RESULT)==0
        movie=m.get(s.RESULT);assert movie==s.MOVIE
        recreated=state(m,track,mux)
        assert recreated['factory_flag']==0x81 and recreated['sample_counts']==[0,0]
        assert recreated['sps_bytes']==recreated['pps_bytes']==0
        writes=m.movie_write_events[write_start:]
        touched=set()
        for event in writes:touched.update(range(event['offset'],event['offset']+event['bytes']))
        assert set(range(0x708))<=touched
        assert any(c['entry']=='0xa04f8dec' and c['phase']==m.phase for c in m.factory_calls)
        assert m.call(0xA0440CD4,movie,s.CONFIG)==0
        if mux is None:
            assert m.call(0xA03FECCC,MUXCFG)==0
            for off,value in [(0,s.STREAM),(4,mem),(8,2)]:m.put(MUXCFG+off,value)
            assert m.call(0xA03FED44,MUXCFG,s.RESULT)==0
            mux=m.get(s.RESULT)
            # Construct caller's media binding and requested duration only;
            # object memory and index state were initialized by original Create.
            m.put(mux+4,movie);m.put(mux+0x10,60000)
        index=mux+0x58
        m.phase='record_'+str(number)
        m.output=bytearray();m.position=0;m.writes=[]
        assert m.call(0xA03FE468,mux)==0
        assert m.get(mux+0xF80,1)==1
        # Public wrapper refuses repeated Open; no file bytes or state change.
        length_before=len(m.output);opened=state(m,track,mux)
        assert m.call(0xA03FE468,mux)==-1
        assert state(m,track,mux)==opened and len(m.output)==length_before
        add_start=len(m.added)
        for i in range(nvideo):assert sample(m,track,index,video,True,i)==0
        for i in range(naudio):assert sample(m,track,index,audio,False,i)==0
        for t in (0,1):assert m.call(0xA0411048,index,t)==0
        readback=read_back(m,index,add_start)
        recorded=state(m,track,mux)
        assert recorded['sample_counts']==[nvideo,naudio]
        assert m.call(0xA03FE300,mux,0)==0
        closed=state(m,track,mux)
        assert closed['public_mux_open']==0 and closed['memidx_data_pointer']=='0x0'
        assert bytes(m.uc.mem_read(index,0x138))==bytes(0x138)
        assert not m.index_events
        path=out/('factory-segment-'+str(number)+'.mp4');path.write_bytes(m.output)
        decoded=native.decode(path)
        assert decoded['video_frame_md5']==['6f54030da59d51a0d2ff03198b18cc4b']*nvideo
        assert [int(t['nb_read_packets']) for t in decoded['streams']]==[nvideo,naudio]
        assert decoded['audio_pcm_bytes']==naudio*4096
        segments.append(dict(number=number,before_new=before,after_original_factory=recreated,
            actual_factory_writes=len(writes),factory_writer_pcs=dict(Counter(w['pc'] for w in writes)),
            recorded=recorded,closed=closed,index=hex(index),readback=readback,
            file=path.name,bytes=len(m.output),sha256=native.sha(m.output),decoded=decoded))
        m.phase='release_'+str(number)
        retained=bytes(m.uc.mem_read(movie,0x708))
        # Close does not release the movie pool slot; New while locked fails.
        assert m.call(0xA03E3F00,NAME,s.RESULT)==-1
        assert bytes(m.uc.mem_read(movie,0x708))==retained
        assert m.call(0xA03E40C8,movie,1)==0
        released=state(m,track,mux)
        assert released['factory_flag']==0 and released['sample_counts']==[nvideo,naudio]
        # Releasing a free slot also fails rather than silently succeeding.
        assert m.call(0xA03E40C8,movie,1)==-1
        boundary.append(dict(segment=number,new_while_locked_status=-1,release_status=0,
            second_release_status=-1,after_release=released))
    m.phase=None
    function_pins=pins(image)
    cs=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    reset_disassembly=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str)
        for i in cs.disasm(image[0xA03E2E90-0xA0100000:0xA03E2E90-0xA0100000+0x44],0xA03E2E90)]
    calls_path=s.SRC.parent/'calls.tsv'
    selected_calls=[]
    for line in calls_path.read_text().splitlines():
        cols=line.split('\t')
        if len(cols)>=4 and cols[0].startswith('0x') and int(cols[0],16) in ROOTS and int(cols[2],16) in ROOTS:
            selected_calls.append(dict(caller=cols[0],site=cols[1],callee=cols[2],kind=cols[3]))
    old=ROOT/'artifacts/device/2026-11-11-prerecord-native-mp4/audit.json'
    old_report=json.loads(old.read_text())
    negative=next(c for c in old_report['cases'] if c['name']=='negative_reinit_without_fresh_movie')
    report=dict(schema=1,status='pass',offline_only=True,case='same_movie_memidx_and_public_mux_two_segments',
        firmware_sha256=native.sha(image),frozen_native_harness_sha256=FROZEN_NATIVE_SHA,
        factory_pool=pool,same_movie=hex(s.MOVIE),same_memidx=hex(mem),same_mux=hex(mux),
        source=source,segments=segments,boundaries=boundary,function_pins=function_pins,
        reset_disassembly=reset_disassembly,static_calls=selected_calls,factory_calls=m.factory_calls,
        old_negative=dict(report=str(old.relative_to(ROOT)),sha256=native.sha(old.read_bytes()),case=negative),
        explicit_models=['original native MP4 harness file/allocator/mutex/RTC and synthetic FIFO models',
            'event flag creation OS model added for original FormatInit/FifoPoolInit',
            'single-slot movie pool and caller config/name, stream binding and duration are constructed RAM'],
        limits=['AppLib full open/close orchestration, tasks, encoder/DMA, CFS/SD, voice and shutter are not executed',
            'same physical pool slot is released and recreated through original factory, not a live movie reused without release',
            'synthetic repeated IDR/AAC timeline; no one-minute, long-run, P/B-frame, or timestamp rebase proof'])
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status='pass',segments=2,output=str(out),movie=hex(s.MOVIE),memidx=hex(mem),mux=hex(mux))))

if __name__=='__main__':main()
