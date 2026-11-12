#!/usr/bin/env python3
"""Compile packet spool host/ARM faults and verify real positional-file custody.

Host files + fsync/process-kill evidence only; not physical SD durability.
"""
from __future__ import annotations
import argparse
import ctypes as C
import hashlib
import io
import json
import os
from pathlib import Path
import platform
import shutil
import struct
import subprocess
import tempfile
import zlib

from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
WRAPPER=r'''
#include "yi4k_packet_spool.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
static yi4k_packet_spool controller;
static unsigned char scratch[1048576];
static yi4k_spool_identity identity;
static int descriptor=-1, crash_phase=0, phase=0;
static unsigned long long recovered=0;
static int32_t size_fn(void *c,uint64_t *n) { struct stat s;(void)c;if(fstat(descriptor,&s))return -1;*n=(uint64_t)s.st_size;return 0; }
static void crash(void) { if(++phase==crash_phase)_exit(73); }
static int32_t write_fn(void *c,uint64_t at,const uint8_t *p,uint32_t n,uint32_t *got) {
 ssize_t r;(void)c;r=pwrite(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;crash();return r<0?-1:0;
}
static int32_t read_fn(void *c,uint64_t at,uint8_t *p,uint32_t n,uint32_t *got) {
 ssize_t r;(void)c;r=pread(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;crash();return r<0?-1:0;
}
static int32_t sync_fn(void *c){int r;(void)c;r=fsync(descriptor);crash();return r;}
static yi4k_spool_io backend={0,size_fn,write_fn,read_fn,sync_fn};
static void id(void){memset(&identity,0,sizeof(identity));identity.session=1;identity.segment=2;identity.epoch=3;memset(identity.config_digest,0x44,32);}
int create_file(const char *path,int cut){
 char parent[4096],*slash;int parent_fd;
 memset(&controller,0,sizeof(controller));id();phase=0;crash_phase=cut;
 descriptor=open(path,O_RDWR|O_CREAT|O_EXCL,0600);if(descriptor<0)return -90;
 if(strlen(path)>=sizeof(parent))return -91;
 strcpy(parent,path);slash=strrchr(parent,'/');if(!slash)return -92;
 *slash=0;parent_fd=open(parent,O_RDONLY);if(parent_fd<0)return -93;
 if(fsync(parent_fd)){close(parent_fd);return -94;}close(parent_fd);
 return yi4k_spool_init(&controller,&backend,&identity,scratch,sizeof(scratch));
}
int close_file(void){int r=close(descriptor);descriptor=-1;return r;}
int append_audio(const unsigned char *p,uint32_t n,uint32_t sequence,uint64_t pts){
 yi4k_spool_sample s;memset(&s,0,sizeof(s));s.packet.payload=p;s.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;
 s.packet.descriptor.type=8;s.packet.descriptor.flags=1;s.packet.descriptor.sequence=sequence;
 s.packet.descriptor.corrected_pts=pts;s.packet.descriptor.payload_size=n;s.packet.descriptor.cpu_payload_address=0x22000000;
 s.dts=s.pts=pts;s.scale=48000;s.duration=1024;return yi4k_spool_append(&controller,&s);
}
static int32_t collect(void *c,uint64_t ordinal,const yi4k_spool_sample *s){
 (void)c;if(ordinal!=recovered+1||s->packet.descriptor.sequence!=recovered||s->pts!=recovered*1024)return -1;
 ++recovered;return 0;
}
int scan_file(const char *path,uint64_t *words){
 yi4k_spool_scan_result r;int status;id();phase=0;crash_phase=0;recovered=0;
 descriptor=open(path,O_RDONLY);if(descriptor<0)return -90;
 status=yi4k_spool_scan(&backend,&identity,scratch,sizeof(scratch),collect,0,&r);
 words[0]=r.file_bytes;words[1]=r.committed_bytes;words[2]=r.records;words[3]=r.trailing_bytes;words[4]=r.corrupt;words[5]=recovered;
 close_file();return status;
}
'''

def sha(p):
    with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()

def command(args):
    p=subprocess.run(list(map(str,args)),capture_output=True)
    if p.returncode:raise RuntimeError(p.stderr.decode()+p.stdout.decode())
    return p.stdout

def parse(path):
    """Independent format/CRC reader, no C spool calls."""
    data=path.read_bytes();at=0;rows=[]
    while at<len(data):
        h=bytearray(data[at:at+160])
        if len(h)<160:return rows,at,'incomplete'
        stored=struct.unpack_from('<I',h,148)[0];struct.pack_into('<I',h,148,0)
        assert zlib.crc32(h)==stored and h[:8]==b'YI4KPS01'
        assert struct.unpack_from('<II',h,8)==(1,160)
        assert struct.unpack_from('<QQQQ',h,16)==(1,2,3,len(rows)+1)
        assert h[112:144]==b'\x44'*32 and h[152:160]==bytes(8)
        kind,scale=struct.unpack_from('<II',h,48);dts,pts=struct.unpack_from('<QQ',h,56)
        duration,length=struct.unpack_from('<II',h,72);sequence=struct.unpack_from('<I',h,80)[0]
        if len(data)-at<184+length:return rows,at,'incomplete'
        payload=data[at+160:at+160+length];m=data[at+160+length:at+184+length]
        assert zlib.crc32(payload)==struct.unpack_from('<I',h,144)[0]
        assert m[:8]==b'Y4KCOM01' and struct.unpack_from('<QI',m,8)==(len(rows)+1,stored)
        assert zlib.crc32(m[:20])==struct.unpack_from('<I',m,20)[0]
        assert kind==2 and scale==48000 and duration==1024 and dts==pts==sequence*1024
        rows.append(dict(sequence=sequence,pts=pts,payload=payload));at+=184+length
    return rows,at,'complete_prefix'

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    sources=[ROOT/'sdk/yi4k_packet_spool.c',ROOT/'sdk/offline/yi4k_packet_spool_test.c']
    tracked=[*sources,ROOT/'sdk/yi4k_packet_spool.h',*sorted((ROOT/'sdk').glob('yi4k_1107_*.h')),Path(__file__).resolve()]
    before={str(p.relative_to(ROOT)):sha(p) for p in tracked};commands=[]
    clang=shutil.which('clang');linkers=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker=shutil.which('ld.lld') or str(linkers[-1]);assert clang
    common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin','-I'+str(ROOT/'sdk')]
    def run(args):commands.append(list(map(str,args)));return command(args)
    with tempfile.TemporaryDirectory(prefix='yi4k-spool-') as tmp:
        tmp=Path(tmp);host=tmp/'tests.dylib'
        run([clang,'-arch',platform.machine(),'-shared','-fPIC',*common,*sources,'-o',host])
        lib=C.CDLL(str(host));lib.yi4k_packet_spool_test.argtypes=[C.c_uint32];lib.yi4k_packet_spool_test.restype=C.c_int32
        objs=[]
        for p in sources:
            obj=tmp/(p.name+'.o');run([clang,'--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none','-ffreestanding','-fno-stack-protector','-fno-pic',*common,'-c',p,'-o',obj]);objs.append(obj)
        ld=tmp/'spool.ld';ld.write_text('ENTRY(yi4k_packet_spool_test)\nSECTIONS { . = 0x10030000; .text : { *(.text*) } .rodata : { *(.rodata*) } .data : { *(.data*) } .bss (NOLOAD) : { *(.bss*) *(COMMON) } /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) *(.comment) } }')
        elfpath=out/'spool-offline.elf';run([linker,'-T',ld,*objs,'-o',elfpath]);blob=elfpath.read_bytes();elf=ELFFile(io.BytesIO(blob))
        symbols=list(elf.get_section_by_name('.symtab').iter_symbols());assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        sym={s.name:s['st_value'] for s in symbols};arm=Uc(UC_ARCH_ARM,UC_MODE_ARM);arm.mem_map(0x10000000,0x100000)
        for seg in elf.iter_segments():
            if seg['p_type']=='PT_LOAD' and seg['p_filesz']:arm.mem_write(seg['p_vaddr'],seg.data())
        rows=[];saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
        report=(C.c_uint32*12).in_dll(lib,'yi4k_packet_spool_report')
        for i in range(31):
            assert lib.yi4k_packet_spool_test(i)==0,('host',i)
            arm.reg_write(UC_ARM_REG_CPSR,0x13);arm.reg_write(UC_ARM_REG_R0,i);arm.reg_write(UC_ARM_REG_SP,0x100fe000);arm.reg_write(UC_ARM_REG_LR,0x100ff000)
            for n,r in enumerate(saved):arm.reg_write(r,0xaabb0000+n)
            arm.emu_start(sym['yi4k_packet_spool_test'],0x100ff000,count=3000000)
            assert arm.reg_read(UC_ARM_REG_PC)==0x100ff000 and arm.reg_read(UC_ARM_REG_R0)==0,('arm',i,arm.reg_read(UC_ARM_REG_R0))
            assert arm.reg_read(UC_ARM_REG_SP)==0x100fe000 and all(arm.reg_read(r)==0xaabb0000+n for n,r in enumerate(saved))
            words=list(struct.unpack('<12I',arm.mem_read(sym['yi4k_packet_spool_report'],48)));assert words==list(report),(i,words,list(report))
            rows.append(dict(case=i,host_arm_match=True,report=words))
    wrapper=out/'posix-wrapper.c';wrapper.write_text(WRAPPER);library=out/'posix-spool.dylib'
    run([clang,'-arch',platform.machine(),'-shared','-fPIC',*common,wrapper,sources[0],'-o',library])
    fs=C.CDLL(str(library));fs.create_file.argtypes=[C.c_char_p,C.c_int];fs.create_file.restype=C.c_int
    fs.append_audio.argtypes=[C.POINTER(C.c_ubyte),C.c_uint32,C.c_uint32,C.c_uint64];fs.append_audio.restype=C.c_int
    fs.scan_file.argtypes=[C.c_char_p,C.POINTER(C.c_uint64)];fs.scan_file.restype=C.c_int
    source=ROOT/'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'
    assert sha(source)=='7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c'
    packets=json.loads(run([ROOT/'.tools/ffmpeg-host/ffprobe','-v','error','-select_streams','a:0','-show_packets','-show_entries','packet=pts,dts,duration,pos,size','-of','json',source]))['packets']
    packets=[p for p in packets if int(p['pts'])<3075072];assert len(packets)==3003
    path=out/'archived-aac.spool';assert fs.create_file(os.fsencode(path),0)==0
    expected=[]
    with source.open('rb') as stream:
        for i,p in enumerate(packets):
            assert int(p['pts'])==int(p['dts'])==i*1024 and int(p['duration'])==1024
            stream.seek(int(p['pos']));b=stream.read(int(p['size']));data=(C.c_ubyte*len(b)).from_buffer_copy(b)
            assert fs.append_audio(data,len(b),i,i*1024)==0
            C.memset(data,0xcc,len(b));expected.append(hashlib.sha256(b).hexdigest())
    assert fs.close_file()==0
    # A fresh reader and independent byte-level format parser recover actual disk bytes.
    words=(C.c_uint64*6)();assert fs.scan_file(os.fsencode(path),words)==0 and words[2]==3003
    parsed,committed,status=parse(path);assert status=='complete_prefix' and len(parsed)==3003
    assert [hashlib.sha256(p['payload']).hexdigest() for p in parsed]==expected
    cuts=[]
    worker=out/'crash-worker.py';worker.write_text('''import ctypes as C,sys
l=C.CDLL(sys.argv[1]);l.create_file.argtypes=[C.c_char_p,C.c_int];l.append_audio.argtypes=[C.POINTER(C.c_ubyte),C.c_uint32,C.c_uint32,C.c_uint64]
assert l.create_file(sys.argv[2].encode(),int(sys.argv[3]))==0
p=(C.c_ubyte*64)(*range(64));l.append_audio(p,64,0,0)
''')
    import sys
    for phase in range(1,9):
        p=out/f'crash-phase-{phase}.spool';proc=subprocess.run([sys.executable,str(worker),str(library),str(p),str(phase)],capture_output=True)
        assert proc.returncode==73,(phase,proc.returncode,proc.stderr)
        w=(C.c_uint64*6)();result=fs.scan_file(os.fsencode(p),w)
        independent,extent,kind=parse(p)
        if phase<=3:assert result==-5 and w[2]==0 and not independent
        else:assert result==0 and w[2]==1 and len(independent)==1
        cuts.append(dict(phase=phase,exit_code=73,scan_status=result,records=int(w[2]),committed_bytes=int(w[1]),file_bytes=p.stat().st_size,sha256=sha(p)))
    after={str(p.relative_to(ROOT)):sha(p) for p in tracked};assert before==after
    result=dict(schema=1,status='pass_host_arm_and_posix_spool',device_access=False,
        host_arm_cases=rows,source_sha256=before,commands=commands,arm_elf_sha256=sha(elfpath),
        wrapper_sha256=sha(wrapper),posix_library_sha256=sha(library),
        archived_audio=dict(packets=3003,file=path.name,sha256=sha(path),bytes=path.stat().st_size,committed_bytes=committed,
            exact_payload_sequence=True,upstream_overwrites=3003,fresh_c_reader_records=int(words[2]),independent_parser=True),
        process_exit_cuts=cuts,
        limitations=['No real SD power loss/durability or RTOS binding. fsync and _exit exercise host persistence/process boundaries only.',
            'CRC is accidental corruption detection, not authentication.',
            'A complete-prefix scan does not prove all expected packets were ever appended. External sealed manifest and independent coverage/publication gate required.',
            'Storage is append-only; no minute ring, eviction, final-seal record, H264/AAC parsing or actual hardware epoch authentication.'])
    (out/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(status=result['status'],host_arm_cases=len(rows),real_aac_packets=3003,process_exit_cuts=len(cuts))))

if __name__=='__main__':main()
