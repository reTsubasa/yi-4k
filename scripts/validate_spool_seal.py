#!/usr/bin/env python3
"""Compile source-coverage/seal C for host+ARM; exercise real POSIX closure.

Uses actual retained snapshot bins, not source MP4 bytes. No device operations.
The trusted request is a host fixture ledger, NOT a proven RTOS stop receipt.
"""
from __future__ import annotations
import argparse
import ctypes as C
import hashlib
import importlib.util
import io
import json
import os
from pathlib import Path
import platform
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib
from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
WRAPPER=r'''
#include "yi4k_spool_seal.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
typedef struct file {int fd,is_seal;} file;
static file p={-1,0},s={-1,1};
static yi4k_packet_spool spool;
static yi4k_source_coverage source;
static yi4k_seal_request request;
static unsigned char scratch[1048576];
static int cut=0,phase=0,active=0;
static void tick(file *f){if(active&&f->is_seal&&++phase==cut)_exit(73);}
static int32_t size_fn(void *context,uint64_t *n){file *f=context;struct stat st;int r=fstat(f->fd,&st);if(!r)*n=(uint64_t)st.st_size;tick(f);return r;}
static int32_t read_fn(void *context,uint64_t at,uint8_t *b,uint32_t n,uint32_t *got){file *f=context;ssize_t r=pread(f->fd,b,n,(off_t)at);*got=r<0?0:(uint32_t)r;tick(f);return r<0?-1:0;}
static int32_t write_fn(void *context,uint64_t at,const uint8_t *b,uint32_t n,uint32_t *got){file *f=context;ssize_t r=pwrite(f->fd,b,n,(off_t)at);*got=r<0?0:(uint32_t)r;tick(f);return r<0?-1:0;}
static int32_t sync_fn(void *context){file *f=context;int r=fsync(f->fd);tick(f);return r;}
static yi4k_spool_io pio={&p,size_fn,write_fn,read_fn,sync_fn},sio={&s,size_fn,write_fn,read_fn,sync_fn};
void configure(uint64_t session,uint64_t segment,uint64_t epoch,const uint8_t *digest,uint64_t closure,uint32_t scope,uint64_t count,uint64_t bytes){
 memset(&request,0,sizeof(request));request.identity.session=session;request.identity.segment=segment;request.identity.epoch=epoch;
 memcpy(request.identity.config_digest,digest,32);request.closure_id=closure;request.scope=scope;request.records=count;request.payload_bytes=bytes;
}
void track(uint32_t index,uint64_t count,uint64_t first,uint64_t end,uint32_t first_seq,uint32_t last_seq,uint32_t scale){
 yi4k_seal_track *t=&request.tracks[index];t->records=count;t->first_pts=first;t->end_pts=end;t->first_sequence=first_seq;t->last_sequence=last_seq;t->scale=scale;
}
static int open_new(file *f,const char *path){
 char parent[4096],*slash;int dir;
 if(strlen(path)>=sizeof(parent))return -91;strcpy(parent,path);slash=strrchr(parent,'/');if(!slash)return -92;*slash=0;
 f->fd=open(path,O_RDWR|O_CREAT|O_EXCL,0600);if(f->fd<0)return -90;
 dir=open(parent,O_RDONLY);if(dir<0)return -93;if(fsync(dir)){close(dir);return -94;}close(dir);return 0;
}
int create(const char *a,const char *b){int r;active=0;phase=0;memset(&spool,0,sizeof(spool));memset(&source,0,sizeof(source));
 if((r=open_new(&p,a))||(r=open_new(&s,b)))return r;
 if((r=yi4k_spool_init(&spool,&pio,&request.identity,scratch,sizeof(scratch))))return r;
 return yi4k_coverage_init(&source,&request.identity);
}
int add(uint32_t kind,uint32_t seq,uint64_t pts,uint32_t scale,uint32_t duration,uint32_t type,const uint8_t *data,uint32_t n){
 yi4k_spool_sample v;int r;memset(&v,0,sizeof(v));v.packet.source_kind=kind;v.packet.payload=data;
 v.packet.descriptor.sequence=seq;v.packet.descriptor.corrected_pts=pts;v.packet.descriptor.type=(uint8_t)type;v.packet.descriptor.flags=1;v.packet.descriptor.payload_size=n;
 v.dts=v.pts=pts;v.scale=scale;v.duration=duration;
 if((r=yi4k_coverage_add(&source,&v)))return r;
 return yi4k_spool_append(&spool,&v);
}
int finish(int crash){int r;cut=crash;phase=0;active=1;r=yi4k_spool_seal_commit(&source,&request,&pio,&sio,scratch,sizeof(scratch));active=0;return r;}
int close_files(void){int a=0,b=0;active=0;if(p.fd>=0)a=close(p.fd);if(s.fd>=0)b=close(s.fd);p.fd=s.fd=-1;return a?a:b;}
int verify(const char *a,const char *b,uint64_t *words,uint8_t *digest){
 yi4k_seal_receipt receipt;int r;active=0;p.fd=open(a,O_RDONLY);s.fd=open(b,O_RDONLY);
 if(p.fd<0||s.fd<0){close_files();return -90;}
 memset(&receipt,0,sizeof(receipt));r=yi4k_spool_seal_verify(&request,&pio,&sio,scratch,sizeof(scratch),&receipt);
 words[0]=receipt.valid;words[1]=receipt.scope;words[2]=receipt.closure_id;words[3]=receipt.records;words[4]=receipt.spool_bytes;
 memcpy(digest,receipt.transcript_sha256,32);close_files();return r;
}
'''
U32=C.c_uint32;U64=C.c_uint64;PTR=C.POINTER(C.c_ubyte)

def sha(p):
    with Path(p).open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()

def command(args):
    p=subprocess.run(list(map(str,args)),capture_output=True)
    if p.returncode:raise RuntimeError(p.stderr.decode()+p.stdout.decode())
    return p.stdout

def buf(data):return (C.c_ubyte*len(data)).from_buffer_copy(data)

def library(path):
    l=C.CDLL(str(path));l.configure.argtypes=[U64,U64,U64,PTR,U64,U32,U64,U64]
    l.track.argtypes=[U32,U64,U64,U64,U32,U32,U32]
    l.create.argtypes=[C.c_char_p,C.c_char_p];l.create.restype=C.c_int
    l.add.argtypes=[U32,U32,U64,U32,U32,U32,PTR,U32];l.add.restype=C.c_int
    l.finish.argtypes=[C.c_int];l.finish.restype=C.c_int
    l.verify.argtypes=[C.c_char_p,C.c_char_p,C.POINTER(U64),PTR];l.verify.restype=C.c_int
    return l

def configure(l,ledger):
    l.configure(ledger['session'],ledger['segment'],ledger['epoch'],buf(bytes.fromhex(ledger['config_digest'])),ledger['closure_id'],ledger['scope'],len(ledger['records']),sum(r['bytes'] for r in ledger['records']))
    for kind in (1,2):
        rows=[r for r in ledger['records'] if r['kind']==kind]
        if rows:l.track(kind-1,len(rows),rows[0]['pts'],rows[-1]['pts']+rows[-1]['duration'],rows[0]['sequence'],rows[-1]['sequence'],rows[0]['scale'])

def write(l,ledger,spool,seal,cut=0):
    configure(l,ledger);assert l.create(os.fsencode(spool),os.fsencode(seal))==0
    for row in ledger['records']:
        data=(ROOT/row['snapshot']).read_bytes();assert hashlib.sha256(data).hexdigest()==row['sha256']
        memory=buf(data)
        assert l.add(row['kind'],row['sequence'],row['pts'],row['scale'],row['duration'],row['type'],memory,len(data))==0
        C.memset(memory,0xcc,len(data))
    status=l.finish(cut);assert status==0,status;assert l.close_files()==0

def verify_worker(lib,ledger,spool,seal,out):
    l=library(lib);configure(l,ledger);words=(U64*5)();digest=(C.c_ubyte*32)()
    status=l.verify(os.fsencode(spool),os.fsencode(seal),words,digest)
    result=dict(status=status,valid=int(words[0]),scope=int(words[1]),closure_id=int(words[2]),records=int(words[3]),spool_bytes=int(words[4]),transcript_sha256=bytes(digest).hex(),reader_pid=os.getpid(),complete_original_recording=False)
    out.write_text(json.dumps(result,indent=2)+'\n');return result

def transcript(ledger):
    b=b'YI4KCOV1'+struct.pack('<QQQ',ledger['session'],ledger['segment'],ledger['epoch'])+bytes.fromhex(ledger['config_digest'])
    h=hashlib.sha256(b)
    for ordinal,r in enumerate(ledger['records'],1):
        fields=bytearray(72);struct.pack_into('<QIIQQIIQI',fields,0,ordinal,r['kind'],r['scale'],r['dts'],r['pts'],r['duration'],r['sequence'],r['pts'],0)
        struct.pack_into('<BBHIII',fields,52,r['type'],1,0,0,r['bytes'],0)
        h.update(fields);h.update((ROOT/r['snapshot']).read_bytes())
    return h.hexdigest()

def fixture_digest(which):
    n=47 if which==42 else 48;base=0x100000000 if which==46 else 0
    ledger=dict(session=1,segment=2,epoch=3,config_digest=('04'+'00'*31),records=[])
    for seq in range(1 if which in (42,43) else 3):
        def entry(seq,kind):
            pts=base+(seq*1024 if kind==2 else (seq-10)*1001)
            fields=bytearray(72);struct.pack_into('<QIIQQIIQI',fields,0,len(ledger['records'])+1,kind,48000 if kind==2 else 30000,pts,pts,1024 if kind==2 else 1001,seq,pts,0)
            struct.pack_into('<BBHIII',fields,52,8 if kind==2 else 1 if seq==10 else 3,1,0,0x22000000,n,0)
            ledger['records'].append((fields,bytes((17+i+seq*7)&255 for i in range(n))))
        entry(seq,2)
        if which in (35,47) and seq<2:entry(seq+10,1)
    h=hashlib.sha256(b'YI4KCOV1'+struct.pack('<QQQ',1,2,3)+bytes.fromhex(ledger['config_digest']))
    for a,b in ledger['records']:h.update(a);h.update(b)
    return h.hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',type=Path);ap.add_argument('--worker',choices=['write','verify']);ap.add_argument('--lib',type=Path);ap.add_argument('--ledger',type=Path);ap.add_argument('--spool',type=Path);ap.add_argument('--seal',type=Path);ap.add_argument('--cut',type=int,default=0)
    a=ap.parse_args()
    if a.worker:
        ledger=json.loads(a.ledger.read_text())
        if a.worker=='write':write(library(a.lib),ledger,a.spool,a.seal,a.cut)
        else:verify_worker(a.lib,ledger,a.spool,a.seal,a.output)
        return
    assert a.output;out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    sources=[ROOT/'sdk/yi4k_packet_spool.c',ROOT/'sdk/yi4k_spool_seal.c',ROOT/'sdk/offline/yi4k_spool_seal_test.c']
    tracked=[*sources,ROOT/'sdk/yi4k_spool_seal.h',ROOT/'sdk/yi4k_packet_spool.h',Path(__file__).resolve()]
    before={str(p.relative_to(ROOT)):sha(p) for p in tracked};commands=[]
    def run(args):commands.append(list(map(str,args)));return command(args)
    clang=shutil.which('clang');linkers=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'));linker=shutil.which('ld.lld') or str(linkers[-1])
    common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin','-I'+str(ROOT/'sdk')]
    rows=[]
    with tempfile.TemporaryDirectory(prefix='yi4k-seal-') as tmp:
        tmp=Path(tmp);host=tmp/'seal.dylib';run([clang,'-arch',platform.machine(),'-shared','-fPIC',*common,*sources,'-o',host]);l=C.CDLL(str(host))
        l.yi4k_spool_seal_test.argtypes=[U32];l.yi4k_spool_seal_test.restype=C.c_int
        objects=[]
        for p in sources:
            obj=tmp/(p.name+'.o');run([clang,'--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none','-ffreestanding','-fno-stack-protector','-fno-pic',*common,'-c',p,'-o',obj]);objects.append(obj)
        ld=tmp/'seal.ld';ld.write_text('ENTRY(yi4k_spool_seal_test)\nSECTIONS { . = 0x10030000; .text : { *(.text*) } .rodata : { *(.rodata*) } .data : { *(.data*) } .bss (NOLOAD) : { *(.bss*) *(COMMON) } /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) *(.comment) } }')
        elfpath=out/'seal-offline.elf';run([linker,'-T',ld,*objects,'-o',elfpath]);elf=ELFFile(io.BytesIO(elfpath.read_bytes()))
        symbols=list(elf.get_section_by_name('.symtab').iter_symbols());assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        sym={s.name:s['st_value'] for s in symbols};arm=Uc(UC_ARCH_ARM,UC_MODE_ARM);arm.mem_map(0x10000000,0x100000)
        for seg in elf.iter_segments():
            if seg['p_type']=='PT_LOAD' and seg['p_filesz']:arm.mem_write(seg['p_vaddr'],seg.data())
        report=(U32*24).in_dll(l,'yi4k_spool_seal_report');saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
        for i in range(48):
            assert l.yi4k_spool_seal_test(i)==0,('host',i)
            arm.reg_write(UC_ARM_REG_CPSR,0x13);arm.reg_write(UC_ARM_REG_R0,i);arm.reg_write(UC_ARM_REG_SP,0x100fe000);arm.reg_write(UC_ARM_REG_LR,0x100ff000)
            for n,r in enumerate(saved):arm.reg_write(r,0xaabb0000+n)
            arm.emu_start(sym['yi4k_spool_seal_test'],0x100ff000,count=10000000)
            assert arm.reg_read(UC_ARM_REG_PC)==0x100ff000 and arm.reg_read(UC_ARM_REG_R0)==0,('arm',i,arm.reg_read(UC_ARM_REG_R0))
            assert arm.reg_read(UC_ARM_REG_SP)==0x100fe000 and all(arm.reg_read(r)==0xaabb0000+n for n,r in enumerate(saved))
            words=list(struct.unpack('<24I',arm.mem_read(sym['yi4k_spool_seal_report'],96)));assert words==list(report),(i,words,list(report))
            if words[7] and i not in (20,21,27):assert bytes(report)[32:64].hex()==fixture_digest(i),('hashlib',i)
            rows.append(dict(case=i,host_arm_match=True,report=words,sha256_hashlib_checked=bool(words[7] and i not in (20,21,27))))
    wrapper=out/'seal-posix-wrapper.c';wrapper.write_text(WRAPPER);lib=out/'seal-posix.dylib';run([clang,'-arch',platform.machine(),'-shared','-fPIC',*common,wrapper,*sources[:2],'-o',lib])
    spec=importlib.util.spec_from_file_location('retained',ROOT/'scripts/recover_prerecord_retained_spool.py');old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
    assert old.sha(old.INPUT/'audit.json')==old.AUDIT_SHA
    snapshots,hashes=old.snapshot_records(json.loads((old.INPUT/'audit.json').read_text()));cases=[]
    def worker(mode,ledger_path,spool,seal,result=None,cut=0):
        args=[sys.executable,str(Path(__file__).resolve()),'--worker',mode,'--lib',str(lib),'--ledger',str(ledger_path),'--spool',str(spool),'--seal',str(seal),'--cut',str(cut)]
        if result:args+=['--output',str(result)]
        proc=subprocess.run(args,capture_output=True);return proc
    for name,segment,records in snapshots:
        ledger=dict(session=1107,segment=segment,epoch=1,config_digest='02'*32,closure_id=segment+100,scope=1,records=records)
        lp=out/(name+'-source-ledger.json');lp.write_text(json.dumps(ledger,indent=2)+'\n');spool=out/(name+'.spool');seal=out/(name+'.seal')
        w=worker('write',lp,spool,seal);assert w.returncode==0,w.stderr.decode()
        rp=out/(name+'-reader.json');v=worker('verify',lp,spool,seal,rp);assert v.returncode==0,v.stderr.decode();result=json.loads(rp.read_text());assert result['status']==0 and result['valid']==1 and result['records']==len(records)
        assert result['transcript_sha256']==transcript(ledger) and result['reader_pid']!=os.getpid()
        data=seal.read_bytes();assert len(data)==280 and data[:8]==b'YI4KSE01' and data[256:264]==b'Y4KSFIN1'
        body=bytearray(data[:256]);stored=struct.unpack_from('<I',body,248)[0];struct.pack_into('<I',body,248,0);assert zlib.crc32(body)==stored and zlib.crc32(data[256:276])==struct.unpack_from('<I',data,276)[0]
        cases.append(dict(name=name,records=len(records),spool_sha256=sha(spool),seal_sha256=sha(seal),ledger_sha256=sha(lp),fresh_reader=result))
        if segment==1:
            original_spool,original_seal=spool.read_bytes(),seal.read_bytes()
            # Boundary cut, repaired-CRC byte mutation, wrong closure/scope,
            # absent marker, and forged digest with repaired seal CRCs.
            variants=[]
            n=struct.unpack_from('<I',original_spool,76)[0];first_size=184+n
            variants.append(('record-boundary-cut',original_spool[:first_size],original_seal,ledger))
            variants.append(('torn-last-marker',original_spool[:-1],original_seal,ledger))
            changed=bytearray(original_spool);changed[160]^=1;struct.pack_into('<I',changed,144,zlib.crc32(changed[160:160+n]));struct.pack_into('<I',changed,148,0);hc=zlib.crc32(changed[:160]);struct.pack_into('<I',changed,148,hc);struct.pack_into('<I',changed,160+n+16,hc);struct.pack_into('<I',changed,160+n+20,zlib.crc32(changed[160+n:160+n+20]));variants.append(('payload-repaired-crc',changed,original_seal,ledger))
            wrong=dict(ledger,closure_id=999);variants.append(('wrong-closure',original_spool,original_seal,wrong))
            wrong=dict(ledger,scope=2);variants.append(('scope-upgrade',original_spool,original_seal,wrong))
            variants.append(('body-without-marker',original_spool,original_seal[:256],ledger))
            forged=bytearray(original_seal);forged[192]^=1;struct.pack_into('<I',forged,248,0);hc=zlib.crc32(forged[:256]);struct.pack_into('<I',forged,248,hc);struct.pack_into('<I',forged,272,hc);struct.pack_into('<I',forged,276,zlib.crc32(forged[256:276]));variants.append(('digest-repaired-crc',original_spool,forged,ledger))
            for label,pb,sb,expected in variants:
                pp=out/(label+'.spool');ss=out/(label+'.seal');ll=out/(label+'-ledger.json');rr=out/(label+'-reader.json');pp.write_bytes(pb);ss.write_bytes(sb);ll.write_text(json.dumps(expected))
                v=worker('verify',ll,pp,ss,rr);assert v.returncode==0,v.stderr.decode();got=json.loads(rr.read_text());assert got['status']!=0 and got['valid']==0
                cases.append(dict(name=label,expected_rejection=True,fresh_reader=got))
            for phase in range(1,9):
                pp=out/f'cut-{phase}.spool';ss=out/f'cut-{phase}.seal';rr=out/f'cut-{phase}-reader.json'
                w=worker('write',lp,pp,ss,cut=phase);assert w.returncode==73,(phase,w.returncode,w.stderr)
                v=worker('verify',lp,pp,ss,rr);assert v.returncode==0,v.stderr.decode();got=json.loads(rr.read_text())
                assert (got['status']==0 and got['valid']==1) if phase>=4 else (got['status']!=0 and got['valid']==0)
                cases.append(dict(name=f'process-exit-seal-phase-{phase}',writer_exit=73,seal_bytes=ss.stat().st_size,fresh_reader=got,no_writer_ack_claimed=True))
    assert before=={str(p.relative_to(ROOT)):sha(p) for p in tracked}
    result=dict(schema=1,status='pass_source_coverage_seal_host_arm_posix',device_access=False,source_sha256=before,commands=commands,host_arm_cases=rows,arm_elf_sha256=sha(elfpath),snapshot_hashes=hashes,actual_file_cases=cases,
        limitations=['Source-stop ledger is host fixture metadata; no actual RTOS admission/quiescence/clock attestation.','Snapshot-set seals describe21+1 actual retained packets in separate scenarios, never a complete recording.','No MP4 publication, one-minute live ring/eviction, device hook or trigger binding.','Host fsync/process exit does not prove physical SD power-loss durability.','SHA/CRC are not authentication. Quiescent exclusive handles and independently trusted expected closure request are external prerequisites.'])
    (out/'validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(dict(status=result['status'],host_arm_cases=len(rows),actual_file_cases=len(cases))))

if __name__=='__main__':main()
