#!/usr/bin/env python3
"""Offline real SDK pipeline, host/compiled ARM and original stock sample writers.

The C bridge below is a temporary test fixture, not an installed target adapter.
All existing SDK and firmware/harness sources are read and hash-checked only.
"""
from __future__ import annotations
import argparse
import ctypes as ct
import hashlib
import io
import json
from pathlib import Path
import platform
import shutil
import struct
import subprocess
import tempfile

from elftools.elf.elffile import ELFFile
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from unicorn.arm_const import *
import audit_prerecord_owned_mux_writer as stock
import audit_prerecord_native_mp4 as native
import validate_prerecord_codec_epoch as codec

ROOT=Path(__file__).resolve().parents[1]
SOURCES=[ROOT/'sdk'/f'yi4k_1107_{name}.c' for name in
    ('early_copy','audio_early_copy','payload_copy','owned_mux','codec_epoch')]
INPUTS=[*SOURCES,*sorted((ROOT/'sdk').glob('yi4k_1107_*.h')),
    ROOT/'scripts/audit_prerecord_owned_mux_writer.py',
    ROOT/'scripts/prerecord-fifo-lifecycle.py',ROOT/'scripts/audit_prerecord_video_pts.py',
    ROOT/'scripts/validate_prerecord_codec_epoch.py']
INPUTS.append(ROOT/'scripts/audit_prerecord_native_mp4.py')
RINGSIZE=0x80000
OUTPUT=0x20400000
COMMANDS=[]
BRIDGE=r'''
#include "yi4k_1107_owned_mux.h"
#include "yi4k_1107_audio_early_copy.h"
#include "yi4k_1107_codec_epoch.h"
typedef struct setup {
 uint8_t *source; uint32_t source_base,ring_size;
 uint8_t *arena; uint32_t arena_base,slot_capacity;
 uint8_t *output; uint32_t output_base,output_capacity,kind;
 const yi4k_1107_codec_config *config;
} setup;
static setup parameters;
static yi4k_1107_early_copy queue;
static yi4k_1107_owned_slot slots[2];
static yi4k_1107_owned_mux mux;
static yi4k_1107_codec_epoch epoch;
static yi4k_1107_audio_ingress audio;
yi4k_1107_frame_desc pipeline_writer_descriptor;
uint32_t pipeline_report[16];
static void zero(void *p,uint32_t n){volatile uint8_t*b=p;while(n--)*b++=0;}
static void update(void){
 pipeline_report[2]=atomic_load(&queue.head);pipeline_report[3]=atomic_load(&queue.tail);
 pipeline_report[4]=mux.held!=0;pipeline_report[5]=mux.poisoned;
 pipeline_report[8]=mux.packet.ring_base;pipeline_report[9]=mux.packet.ring_end;
 pipeline_report[10]=parameters.output_base;pipeline_report[11]=parameters.output_base+parameters.output_capacity;
 pipeline_report[12]=queue.accepted;pipeline_report[13]=queue.dropped;pipeline_report[14]=queue.failed;
}
static int32_t original_video(void*context,uint32_t handle,uint32_t code,const void*arg){
 uint32_t i;(void)context;(void)handle;(void)code;(void)arg;
 pipeline_report[1]++;
 for(i=0;i<parameters.ring_size;i++)parameters.source[i]=0xee;
 return -19;
}
static int32_t original_audio(void*c,const void*a){return original_video(c,0,0,a);}
int32_t pipeline_begin(const setup *p){
 yi4k_1107_ring_view ring;yi4k_1107_owned_arena arena;int32_t s;uint32_t i;
 parameters=*p;zero(&queue,sizeof(queue));zero(slots,sizeof(slots));zero(&mux,sizeof(mux));
 zero(&epoch,sizeof(epoch));zero(&audio,sizeof(audio));zero(pipeline_report,sizeof(pipeline_report));
 zero(&pipeline_writer_descriptor,sizeof(pipeline_writer_descriptor));
 ring=(yi4k_1107_ring_view){p->source,p->source_base,p->ring_size};
 arena=(yi4k_1107_owned_arena){p->arena,p->arena_base,2*p->slot_capacity};
 for(i=0;i<2;i++){slots[i].payload=p->arena+i*p->slot_capacity;slots[i].capacity=p->slot_capacity;}
 s=yi4k_1107_early_init(&queue,&ring,slots,2);if(s)return -101;
 s=yi4k_1107_owned_mux_init(&mux,&queue,&arena,p->kind);if(s)return -102;
 s=yi4k_1107_codec_init(&epoch,p->config);if(s)return s;
 audio.owned=&queue;update();return 0;
}
int32_t pipeline_offer(uint32_t n,uint32_t offset,uint32_t type){
 yi4k_1107_early_result r;
 if(parameters.kind==1){
  yi4k_1107_video_event e;yi4k_1107_early_chain chain={0,original_video};zero(&e,sizeof(e));
  e.sequence=123;e.corrected_pts=0x123456789ULL;e.cpu_payload_address=parameters.source_base+offset;
  e.type=type;e.payload_size=n;
  r=yi4k_1107_early_on_event(&chain,&queue,0,YI4K_EARLY_VIDEO_EVENT,&e);
 }else{
  yi4k_1107_audio_event e;yi4k_1107_audio_chain chain={0,original_audio};zero(&e,sizeof(e));
  e.encoder_handle=0x123;e.synthetic_pts=0x123456789ULL;
  e.cpu_payload_address=parameters.source_base+offset;e.payload_size=n;
  r=yi4k_1107_audio_on_event(&chain,&audio,&e);
 }
 pipeline_report[0]=r.capture_status;pipeline_report[15]=(uint32_t)r.original_status;
 update();return r.capture_status;
}
int32_t pipeline_adapt(const uint8_t identity[32],uint32_t new_segment,uint32_t capacity){
 int32_t s;uint32_t n=0;yi4k_1107_mux_status ready=yi4k_1107_owned_mux_prepare(&mux);
 if(ready!=YI4K_MUX_READY){update();return -200-(int32_t)ready;}
 if(parameters.kind==1)s=yi4k_1107_codec_video(&epoch,identity,new_segment,0,
    mux.packet.payload,mux.packet.descriptor.payload_size,parameters.output,capacity,&n);
 else s=yi4k_1107_codec_audio(&epoch,identity,0,mux.packet.payload,
    mux.packet.descriptor.payload_size,parameters.output,capacity,&n);
 pipeline_report[6]=(uint32_t)s;pipeline_report[7]=n;
 if(s){yi4k_1107_owned_mux_finish(&mux,s,0);update();return s;}
 pipeline_writer_descriptor=mux.packet.descriptor;
 pipeline_writer_descriptor.cpu_payload_address=parameters.output_base;
 pipeline_writer_descriptor.payload_size=n;update();return 0;
}
int32_t pipeline_finish(int32_t writer_status,uint32_t complete){
 yi4k_1107_mux_status s=yi4k_1107_owned_mux_finish(&mux,writer_status,complete);update();return s;
}
int32_t pipeline_rebind(const yi4k_1107_codec_config *p){return yi4k_1107_codec_init(&epoch,p);}
int32_t pipeline_prepare(void){yi4k_1107_mux_status s=yi4k_1107_owned_mux_prepare(&mux);update();return s;}
'''

class Setup(ct.Structure):
    _fields_=[('source',ct.c_void_p),('source_base',ct.c_uint32),('ring_size',ct.c_uint32),
        ('arena',ct.c_void_p),('arena_base',ct.c_uint32),('slot_capacity',ct.c_uint32),
        ('output',ct.c_void_p),('output_base',ct.c_uint32),('output_capacity',ct.c_uint32),
        ('kind',ct.c_uint32),('config',ct.c_void_p)]

def sha(raw):return hashlib.sha256(raw).hexdigest()
def command(argv):
    COMMANDS.append(list(map(str,argv)))
    result=subprocess.run(list(map(str,argv)),capture_output=True)
    if result.returncode:raise RuntimeError(result.stderr.decode(errors='replace'))
    return result.stdout

def load(uc,elf):
    uc.mem_map(0x10030000,0x20000)
    for s in elf.iter_sections():
        if s['sh_flags']&2 and s['sh_size']:
            assert 0x10030000<=s['sh_addr']<s['sh_addr']+s['sh_size']<=0x10050000
            uc.mem_write(s['sh_addr'],s.data() if s['sh_type']!='SHT_NOBITS' else bytes(s['sh_size']))

class Machine(stock.WriterMachine):
    def __init__(self,image):
        super().__init__(image)
        # The retained harness installs one all-address code hook. Keep the
        # exact same service handler, but restrict its dispatch to firmware and
        # synthetic service PCs; compiled SDK executes without Python callbacks.
        # This offline fixture pins/guards the installed Unicorn bookkeeping.
        callbacks=list(self.uc._callbacks)
        assert len(callbacks)==1
        self.uc.hook_del(callbacks[0])
        self.uc.hook_add(UC_HOOK_CODE,self.hook,begin=stock.life.arm.BASE,
                        end=stock.life.arm.BASE+len(image)-1)
        self.uc.hook_add(UC_HOOK_CODE,self.hook,begin=0x10011000,end=0x10011700)
    def hook(self,uc,address,size,user):
        if 0x10030000<=address<0x10050000:return
        super().hook(uc,address,size,user)
    def call(self,entry,*args):
        self.uc.reg_write(UC_ARM_REG_CPSR,0x13)
        self.uc.reg_write(UC_ARM_REG_SP,stock.life.arm.STACK)
        self.uc.reg_write(UC_ARM_REG_LR,stock.life.arm.RETURN)
        saved={r:self.uc.reg_read(r) for r in (UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,
            UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11)}
        for r,v in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),args):self.uc.reg_write(r,v)
        for i,v in enumerate(args[4:]):self.put(stock.life.arm.STACK+i*4,v)
        self.uc.emu_start(entry,stock.life.arm.RETURN,count=100000000)
        assert self.uc.reg_read(UC_ARM_REG_PC)==stock.life.arm.RETURN
        assert self.uc.reg_read(UC_ARM_REG_SP)==stock.life.arm.STACK
        if 0x10030000<=entry<0x10050000:assert all(self.uc.reg_read(r)==v for r,v in saved.items())
        assert not any(self.locks.values())
        return stock.life.signed(self.uc.reg_read(UC_ARM_REG_R0))

class FullMachine(native.NativeMachine):
    call=Machine.call
    def __init__(self,image):
        super().__init__(image)
        callbacks=list(self.uc._callbacks)
        assert len(callbacks)==2  # retained code + invalid-memory hooks
        self.uc.hook_del(callbacks[0])
        self.uc.hook_add(UC_HOOK_CODE,self.hook,begin=stock.life.arm.BASE,
                        end=stock.life.arm.BASE+len(image)-1)
        self.uc.hook_add(UC_HOOK_CODE,self.hook,begin=0x10011000,end=0x10011fff)
    def hook(self,uc,address,size,user):
        if 0x10030000<=address<0x10050000:return
        super().hook(uc,address,size,user)

def binding(source,nals):
    streams=json.loads(command([stock.FFPROBE,'-v','error','-show_streams','-show_data','-of','json',stock.SAMPLE_MP4]))['streams']
    vs=next(s for s in streams if s['codec_type']=='video');aus=next(s for s in streams if s['codec_type']=='audio')
    avcc=codec.extradata(vs['extradata']);asc=codec.extradata(aus['extradata']);sps,pps=codec.avcc_parameters(avcc)
    assert [sps,pps]==nals[:2] and asc[:2]==bytes.fromhex('1190')
    digest=hashlib.sha256(b'avcC'+struct.pack('>I',len(avcc))+avcc+b'ASC'+struct.pack('>I',len(asc))+asc).digest()
    identity=hashlib.sha256(b'archived-source-codec-binding-v1'+bytes.fromhex(source['sha256'])+digest).digest()
    cfg=codec.Config();cfg.identity[:]=identity;cfg.config_digest[:]=digest
    cfg.sps_size=len(sps);cfg.pps_size=len(pps);cfg.sps[:len(sps)]=sps;cfg.pps[:len(pps)]=pps
    cfg.sample_rate=48000;cfg.channels=2;cfg.samples_per_aac=1024;cfg.asc[:]=asc[:2]
    return cfg,identity,dict(source=source,identity=identity.hex(),config_digest=digest.hex(),
        avcc=avcc.hex(),asc=asc.hex(),live_encoder_binding_proven=False)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir',type=Path,default=ROOT/'artifacts/device/2026-11-11-prerecord-sdk-pipeline')
    out=parser.parse_args().output_dir.resolve();out.mkdir(parents=True,exist_ok=False)
    frozen={p:sha(p.read_bytes()) for p in INPUTS}
    image=stock.life.arm.IMAGE.read_bytes();assert sha(image)==stock.life.arm.DIGEST
    video,nals,audio,source=stock.load_archived_samples();cfg,identity,provenance=binding(source,nals)
    slice_only=b'\0\0\0\1'+nals[-1]
    clang=shutil.which('clang');linkers=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker=shutil.which('ld.lld') or str(linkers[-1]);assert clang and linker
    common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin','-I'+str(ROOT/'sdk')]
    flags=['--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none',
        '-ffreestanding','-fno-stack-protector','-fno-pic','-fno-unwind-tables','-fno-asynchronous-unwind-tables',*common]
    rows=[]
    with tempfile.TemporaryDirectory(prefix='yi4k-sdk-pipeline-') as tmp:
        temp=Path(tmp);bridge=temp/'bridge.c';bridge.write_text(BRIDGE)
        libpath=temp/'pipeline.dylib'
        hostarch=['-arch',platform.machine()] if platform.system()=='Darwin' else []
        command([clang,*hostarch,'-shared','-fPIC',*common,*SOURCES,bridge,'-o',libpath])
        objects=[]
        for p in [*SOURCES,bridge]:
            obj=temp/(p.name+'.o');command([clang,*flags,'-c',p,'-o',obj]);objects.append(obj)
        ld=temp/'pipeline.ld';ld.write_text((ROOT/'sdk/offline/yi4k_payload_copy_emulation.ld').read_text().replace('ENTRY(yi4k_1107_copy_payload)','ENTRY(pipeline_begin)'))
        elfpath=temp/'pipeline.elf';command([linker,'-T',ld,*objects,'-o',elfpath])
        blob=elfpath.read_bytes();elf=ELFFile(io.BytesIO(blob));symbols=list(elf.get_section_by_name('.symtab').iter_symbols())
        assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        sym={s.name:s['st_value'] for s in symbols}
        library=ct.CDLL(str(libpath));library.pipeline_begin.argtypes=[ct.POINTER(Setup)]
        library.pipeline_offer.argtypes=[ct.c_uint32]*3
        library.pipeline_adapt.argtypes=[ct.c_void_p,ct.c_uint32,ct.c_uint32]
        library.pipeline_finish.argtypes=[ct.c_int32,ct.c_uint32]
        library.pipeline_rebind.argtypes=[ct.c_void_p]
        host_report=(ct.c_uint32*16).in_dll(library,'pipeline_report')
        cases=[('video_slice_injection',1,slice_only,'ok'),('video_source_wrap',1,slice_only,'wrap'),
            ('video_inband_same',1,video,'inband'),('video_identity_change',1,slice_only,'identity'),
            ('video_parameter_change',1,video,'params'),('video_output_capacity',1,slice_only,'capacity'),
            ('video_staging_capacity',1,slice_only,'stagecap'),('video_queue_full_held',1,slice_only,'full'),
            ('video_rebind_changed_config',1,slice_only,'rebind'),('video_writer_short',1,slice_only,'short'),
            ('video_writer_index_after_payload',1,slice_only,'index'),
            ('video_writer_no_complete',1,slice_only,'receipt'),
            ('audio_copy',2,audio,'ok'),('audio_source_wrap',2,audio,'wrap'),
            ('audio_identity_change',2,audio,'identity'),('audio_output_capacity',2,audio,'capacity'),
            ('audio_writer_short',2,audio,'short'),('audio_writer_index_after_payload',2,audio,'index')]
        for name,kind,original,mode in cases:
            data=bytearray(original)
            if mode=='params':data[7]^=1  # exact same SPS identity, changed byte
            data=bytes(data);offset=RINGSIZE-7 if mode=='wrap' else 32
            stagecap=len(data)-1 if mode=='stagecap' else RINGSIZE
            cap=(len(video) if kind==1 else len(audio))-1 if mode=='capacity' else stock.CAPACITY
            frame_id=bytearray(identity)
            if mode=='identity':frame_id[0]^=1
            fid=(ct.c_uint8*32).from_buffer_copy(frame_id)
            src=ct.create_string_buffer(RINGSIZE);arena=ct.create_string_buffer(stagecap*2)
            output=ct.create_string_buffer(b'\xcc'*stock.CAPACITY)
            setup=Setup(ct.addressof(src),stock.ORIGINAL,RINGSIZE,ct.addressof(arena),stock.OWNED,stagecap,
                ct.addressof(output),OUTPUT,stock.CAPACITY,kind,ct.addressof(cfg))
            assert library.pipeline_begin(ct.byref(setup))==0
            first=min(len(data),RINGSIZE-offset)
            ct.memmove(ct.addressof(src)+offset,data[:first],first);ct.memmove(src,data[first:],len(data)-first)
            hs=library.pipeline_offer(len(data),offset,1)
            assert hs==(4 if mode=='stagecap' else 0)
            assert src.raw[:RINGSIZE]==b'\xee'*RINGSIZE
            if mode=='rebind':
                changed=codec.Config.from_buffer_copy(bytes(cfg));changed.sps[3]^=1
                assert library.pipeline_rebind(ct.byref(changed))==-3
            if mode=='stagecap':ha=None
            else:ha=library.pipeline_adapt(fid,1 if kind==1 else 0,cap)
            rejected=mode in ('identity','params','capacity')
            if rejected:assert ha==(-5 if mode=='capacity' else -3) and output.raw[:stock.CAPACITY]==b'\xcc'*stock.CAPACITY
            elif ha is not None:assert ha==0
            if mode=='full':
                heldbytes=arena.raw[:len(data)];assert library.pipeline_offer(len(data),offset,1)==3
                assert arena.raw[:len(data)]==heldbytes
            host_before=list(host_report)
            expected=video if kind==1 else audio
            if not rejected and ha is not None:assert output.raw[:host_before[7]]==expected

            m=Machine(image);load(m.uc,elf);m.uc.mem_map(OUTPUT,stock.CAPACITY)
            m.uc.mem_map(0x21000000,0x10000)
            cfgaddr,idaddr,setaddr=0x21000000,0x21001000,0x21002000
            m.uc.mem_write(cfgaddr,bytes(cfg));m.uc.mem_write(idaddr,bytes(frame_id))
            m.uc.mem_write(OUTPUT,b'\xcc'*stock.CAPACITY)
            m.uc.mem_write(setaddr,struct.pack('<11I',stock.ORIGINAL,stock.ORIGINAL,RINGSIZE,
                stock.OWNED,stock.OWNED,stagecap,OUTPUT,OUTPUT,stock.CAPACITY,kind,cfgaddr))
            assert m.call(sym['pipeline_begin'],setaddr)==0
            m.uc.mem_write(stock.ORIGINAL+offset,data[:first]);m.uc.mem_write(stock.ORIGINAL,data[first:])
            assert m.call(sym['pipeline_offer'],len(data),offset,1)==hs
            assert bytes(m.uc.mem_read(stock.ORIGINAL,RINGSIZE))==b'\xee'*RINGSIZE
            if mode=='rebind':
                m.uc.mem_write(cfgaddr,bytes(changed));assert m.call(sym['pipeline_rebind'],cfgaddr)==-3
            armadapt=None if mode=='stagecap' else m.call(sym['pipeline_adapt'],idaddr,1 if kind==1 else 0,cap)
            assert armadapt==ha
            if mode=='full':assert m.call(sym['pipeline_offer'],len(data),offset,1)==3
            report=lambda:list(struct.unpack('<16I',m.uc.mem_read(sym['pipeline_report'],64)))
            assert report()==host_before
            writerstatus=None;streambytes=0;source_reads=0;desc=None
            if ha==0:
                transformed=bytes(m.uc.mem_read(OUTPUT,host_before[7]));assert transformed==expected
                track=m.movie(video=True,audio=kind==2)+(0x90 if kind==2 else 0)
                desc=bytes(m.uc.mem_read(sym['pipeline_writer_descriptor'],32))
                assert struct.unpack_from('<II',desc,0x14)==(OUTPUT,len(expected))
                m.put(stock.life.VIRTUAL+0x90,0,8);m.put(stock.life.VIRTUAL+0x98,1,8)
                m.uc.mem_write(stock.life.QUEUE,desc);m.put(track+0x34,OUTPUT);m.put(track+0x38,OUTPUT+stock.CAPACITY)
                if mode=='short':m.short_write_at=1 if kind==1 else 0
                if mode=='index':m.index_failure_kind=2 if kind==1 else 8
                accesses=[]
                def read(uc,access,address,size,value,user):
                    if stock.ORIGINAL<=address<stock.ORIGINAL+RINGSIZE:accesses.append((address,size))
                hook=m.uc.hook_add(UC_HOOK_MEM_READ,read)
                if kind==1:writerstatus=m.call(0xa042d0f8,stock.MOVIE,track,stock.PARAMS,stock.INDEX,stock.STREAM,60000,0xffffffff,0xffffffff)
                else:writerstatus=m.call(0xa043173c,stock.MOVIE,track,stock.INDEX,stock.STREAM,0,60000,0xffffffff,0xffffffff)
                m.uc.hook_del(hook);source_reads=len(accesses);assert source_reads==0
                streambytes=sum(w['returned_bytes'] for w in m.writes if OUTPUT<=int(w['source_address'],16)<OUTPUT+len(expected))
                assert streambytes>0
                assert (writerstatus==0)==(mode not in ('short','index'))
                complete=0 if mode=='receipt' else int(writerstatus==0)
                finish=m.call(sym['pipeline_finish'],writerstatus&0xffffffff,complete)
                assert library.pipeline_finish(writerstatus,complete)==finish
                assert finish==(7 if writerstatus==0 and complete==1 else 3)
                if finish==3:
                    assert report()[2]==0 and report()[4:6]==[1,1]
                    assert m.call(sym['pipeline_prepare'])==3 and library.pipeline_prepare()==3
                else:assert report()[2]==1 and report()[4:6]==[0,0]
                if kind==1 and writerstatus==0:
                    assert m.get(stock.PARAMS+0xb8,2)==len(nals[0]) and m.get(stock.PARAMS+0xba,2)==len(nals[1])
            elif rejected:
                assert report()[2]==0 and report()[4:6]==[1,1]
                assert m.call(sym['pipeline_prepare'])==3 and library.pipeline_prepare()==3
                assert bytes(m.uc.mem_read(OUTPUT,stock.CAPACITY))==b'\xcc'*stock.CAPACITY
            else:assert report()[2:6]==[0,0,0,0] and report()[14]==1
            assert report()==list(host_report)
            if mode!='stagecap':
                assert bytes(m.uc.mem_read(stock.OWNED,len(data)))==data
                assert arena.raw[:len(data)]==data
            rows.append(dict(name=name,kind=kind,mode=mode,input_bytes=len(data),input_sha256=sha(data),
                capture_status=hs,codec_status=ha,writer_status=writerstatus,report=report(),
                prepared_report=host_before,writer_descriptor_hex=desc.hex() if desc else None,
                host_compiled_arm_reports_equal=True,compiled_c_abi_preserved=True,
                original_callback_overwrote_source_before_prepare=True,writer_source_ring_cpu_reads=source_reads,
                writer_output_arena_bytes=streambytes,expected_output_sha256=sha(expected) if ha==0 else None,
                stream_writes=m.writes,index_events=m.index_events,
                staging_payload_sha256=sha(bytes(m.uc.mem_read(stock.OWNED,len(data)))) if mode!='stagecap' else None))
            print(json.dumps(dict(case=name,host_and_arm_passed=True)),flush=True)
        (out/'compiled-offline-pipeline.elf').write_bytes(blob)
        # A distinct success-only full path: same COMPILED SDK chain, then real
        # original index/Open/Close. File seek/read/write and OS remain RAM models.
        m=FullMachine(image);load(m.uc,elf);m.uc.mem_map(OUTPUT,stock.CAPACITY)
        m.uc.mem_map(0x21000000,0x10000)
        track,mem=m.setup_index(audio=True)
        assert native.open_mux(m,mem,128)==0
        cfgaddr,idaddr,setaddr=0x21000000,0x21001000,0x21002000
        m.uc.mem_write(cfgaddr,bytes(cfg));m.uc.mem_write(idaddr,identity)
        steps=[]
        for kind,data in ((1,slice_only),(2,audio)):
            # Each stream uses its independently initialized, quiescent fixture
            # queue. Prior stream's source lease is released before re-init.
            m.uc.mem_write(setaddr,struct.pack('<11I',stock.ORIGINAL,stock.ORIGINAL,RINGSIZE,
                stock.OWNED,stock.OWNED,RINGSIZE,OUTPUT,OUTPUT,stock.CAPACITY,kind,cfgaddr))
            assert m.call(sym['pipeline_begin'],setaddr)==0
            m.uc.mem_write(stock.ORIGINAL+32,data)
            assert m.call(sym['pipeline_offer'],len(data),32,1)==0
            assert bytes(m.uc.mem_read(stock.ORIGINAL,RINGSIZE))==b'\xee'*RINGSIZE
            assert m.call(sym['pipeline_adapt'],idaddr,int(kind==1),stock.CAPACITY)==0
            report=list(struct.unpack('<16I',m.uc.mem_read(sym['pipeline_report'],64)))
            desc=bytes(m.uc.mem_read(sym['pipeline_writer_descriptor'],32))
            adapted=bytes(m.uc.mem_read(OUTPUT,report[7]))
            assert adapted==(video if kind==1 else audio)
            m.put(stock.life.VIRTUAL+0x90,0,8);m.put(stock.life.VIRTUAL+0x98,1,8)
            m.uc.mem_write(stock.life.QUEUE,desc)
            targettrack=track+(0x90 if kind==2 else 0)
            m.put(targettrack+0x34,OUTPUT);m.put(targettrack+0x38,OUTPUT+stock.CAPACITY)
            if kind==1:status=m.call(0xa042d0f8,stock.MOVIE,targettrack,stock.PARAMS,stock.INDEX,stock.STREAM,60000,0xffffffff,0xffffffff)
            else:status=m.call(0xa043173c,stock.MOVIE,targettrack,stock.INDEX,stock.STREAM,0,60000,0xffffffff,0xffffffff)
            assert status==0 and m.call(sym['pipeline_finish'],0,1)==7
            done=list(struct.unpack('<16I',m.uc.mem_read(sym['pipeline_report'],64)))
            assert done[2]==1 and done[4:6]==[0,0]
            steps.append(dict(kind=kind,compiled_sdk_report=done,adapted_sha256=sha(adapted),
                original_writer_status=status,source_overwritten=True,slot_released_after_writer=True))
        assert native.close_mux(m,mem,128)==0
        assert not m.index_events and m.index_reads and m.index_writes
        path=out/'sdk-pipeline-native.mp4';path.write_bytes(m.output)
        probe=json.loads(command([stock.FFPROBE,'-v','error','-show_streams','-show_packets','-show_data','-of','json',path]))
        command([stock.FFMPEG,'-v','error','-xerror','-err_detect','explode','-i',path,'-map','0:v:0','-map','0:a:0','-f','null','-'])
        decoded=lambda p:command([stock.FFMPEG,'-v','error','-xerror','-i',p,'-map','0:v:0','-frames:v','1','-pix_fmt','yuv420p','-f','rawvideo','pipe:1'])
        sourcepixels,outputpixels=decoded(stock.SAMPLE_MP4),decoded(path)
        assert sourcepixels==outputpixels
        pcm=lambda p:command([stock.FFMPEG,'-v','error','-xerror','-i',p,'-map','0:a:0','-frames:a','1','-f','s16le','pipe:1'])
        sourcepcm,outputpcm=pcm(stock.SAMPLE_MP4),pcm(path)
        assert sourcepcm==outputpcm
        vs=next(s for s in probe['streams'] if s['codec_type']=='video')
        aus=next(s for s in probe['streams'] if s['codec_type']=='audio')
        assert codec.avcc_parameters(codec.extradata(vs['extradata']))==(nals[0],nals[1])
        assert codec.extradata(aus['extradata'])==bytes.fromhex(provenance['asc'])
        (out/'sdk-pipeline-native-probe.json').write_text(json.dumps(probe,indent=2)+'\n')
        full=dict(file=path.name,bytes=len(m.output),sha256=sha(m.output),steps=steps,
            complete_original_index_open_close=True,mocked_index_add_commit_calls=len(m.index_events),
            native_calls=m.native_calls,index_backend_reads=len(m.index_reads),index_backend_writes=len(m.index_writes),
            full_av_decode_passed=True,source_first_video_pixels_equal=True,
            decoded_video_sha256=sha(outputpixels),source_first_aac_pcm_equal=True,
            decoded_audio_pcm_sha256=sha(outputpcm),decoded_audio_pcm_bytes=len(outputpcm),
            codec_config_in_mp4_matches_binding=True,
            boundary='File operations/OS allocation are RAM models; one archived video and one AAC sample only')
        print(json.dumps(dict(native_complete_mp4=True,full_av_decode_passed=True)),flush=True)
    assert all(sha(p.read_bytes())==value for p,value in frozen.items())
    result=dict(scope='Actual unchanged C SDK modules chained by generated test fixture; host and compiled ARM; original stock ProcessVideo/ProcessAudio',
        case_count=len(rows),cases=rows,configuration_provenance=provenance,complete_native_mp4=full,
        image_sha256=stock.life.arm.DIGEST,
        frozen_source_sha256={str(p.relative_to(ROOT)):v for p,v in frozen.items()},
        frozen_inputs_unchanged=True,bridge_c_sha256=sha(BRIDGE.encode()),arm_elf_sha256=sha(blob),
        no_undefined_symbols=True,no_linked_relocations=True,
        validation_script_sha256=sha(Path(__file__).read_bytes()),
        build_commands=[argv for argv in COMMANDS if argv[0] in (clang,linker)],
        compiler_version=command([clang,'--version']).decode().splitlines()[0],
        linker_version=command([linker,'--version']).decode().strip(),
        compiled_sdk_has_no_instruction_or_helper_stubs=True,
        report_fields=['capture_status','original_calls','queue_head','queue_tail','held','poisoned',
            'codec_status_u32','adapted_bytes','staging_ring_base','staging_ring_end','writer_ring_base',
            'writer_ring_end','accepted','dropped','failed','original_status_u32'],
        models=['Generated original callback immediately overwrites source ring; this is synthetic reuse',
            'Stock WriterMachine stream Write/Tell/Length, index Add/Commit, OS/allocator/FIFO harness external services',
            'Separate NativeMachine success path executes original index and MP4 Open/Close; file Read/Write/Seek and OS allocation remain RAM models',
            'Caller supplies codec identity from archived exact configuration, not a real producer config event',
            'Caller use-complete receipt; SDK cannot prove absence of real DMA/file retained dependencies'],
        limitations=['No device/RTOS/callback installation or source stability/cache proof',
            'Sample framing from archived finalized MP4, not live raw encoder FIFO',
            '18 failure/boundary scenarios use sample writers with index Add/Commit models; separate single success path uses original complete index/Open/Close',
            'One stream per independently initialized queue; cases serialize audio/video, not concurrent dual producer test',
            'No common A/V epoch, one-minute spool, SD or camera voice/shutter integration'],target_access=False)
    (out/'fixture-bridge.c').write_text(BRIDGE)
    (out/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(output=str(out),cases=len(rows),host_and_arm_passed=True,frozen_inputs_unchanged=True)))

if __name__=='__main__':main()
