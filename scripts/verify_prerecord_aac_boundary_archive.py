#!/usr/bin/env python3
"""Independent compiled AAC-owner replay; source AAC only, no video decode/device.

The downstream custody receipt in this test attests a separate Python byte copy,
not a mux success. It is not evidence of durable SD custody or target binding.
"""
from __future__ import annotations
import argparse
import ctypes as C
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import random
import shutil
import subprocess
import traceback

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'
SOURCE_SHA='7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c'
FFPROBE=ROOT/'.tools/ffmpeg-host/ffprobe'
WRAPPER=r'''
#include "yi4k_1107_aac_boundary.h"
#include <string.h>
static yi4k_1107_aac_boundary c;
static unsigned char bytes[YI4K_CODEC_AUDIO_MAX];
static yi4k_1107_codec_config config;
int fresh(uint32_t scale,uint64_t split,uint32_t split_scale) {
 memset(&c,0,sizeof(c));memset(bytes,0xa5,sizeof(bytes));memset(&config,0,sizeof(config));
 config.sample_rate=scale;config.samples_per_aac=1024;config.channels=2;
 memset(config.identity,1,32);memset(config.config_digest,2,32);
 yi4k_1107_aac_time time={split,split_scale};
 return yi4k_1107_aac_boundary_init(&c,bytes,sizeof(bytes),&config,1,1,0,time);
}
int offer(const unsigned char *data,uint32_t size,uint32_t sequence,uint64_t pts) {
 yi4k_1107_aac_input in;memset(&in,0,sizeof(in));
 in.packet.payload=data;in.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;
 in.packet.descriptor.sequence=sequence;in.packet.descriptor.corrected_pts=pts;
 in.packet.descriptor.type=8;in.packet.descriptor.flags=1;
 in.packet.descriptor.payload_size=size;in.packet.descriptor.cpu_payload_address=0x20000000;
 memcpy(in.identity,config.identity,32);memcpy(in.config_digest,config.config_digest,32);
 in.epoch_id=1;in.dts=pts;in.pts=pts;in.duration=1024;in.scale=config.sample_rate;
 return yi4k_1107_aac_boundary_offer(&c,&in);
}
int advance(uint64_t segment,uint64_t epoch,uint64_t split,uint32_t scale) {
 yi4k_1107_aac_time t={split,scale};
 return yi4k_1107_aac_boundary_advance(&c,segment,epoch,t);
}
int receipt(uint64_t ticket,uint32_t outcome){return yi4k_1107_aac_boundary_receipt(&c,ticket,outcome);}
uint64_t field(uint32_t key) {
 switch(key){case 0:return c.state;case 1:return c.ticket;case 2:return c.segment_id;
 case 3:return c.source_epoch;case 4:return c.held.pts;case 5:return c.held.dts;
 case 6:return c.held.packet.descriptor.sequence;case 7:return c.held.packet.descriptor.payload_size;
 case 8:return c.previous_end;default:return 0;}
}
uint32_t read_bytes(unsigned char *out){memcpy(out,bytes,c.held.packet.descriptor.payload_size);return c.held.packet.descriptor.payload_size;}
void snapshot(unsigned char *out){memcpy(out,&c,sizeof(c));memcpy(out+sizeof(c),bytes,sizeof(bytes));}
uint32_t snapshot_size(void){return sizeof(c)+sizeof(bytes);}
'''


def sha(path):
    with path.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()


def require(ok,message):
    if not ok:raise ValueError(message)


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',required=True,type=Path)
    out=ap.parse_args().output;out.mkdir(parents=True,exist_ok=False)
    report=dict(schema=1,status='running',offline_only=True,device_access=False,
        verifier_sha256=sha(Path(__file__)),source_sha256=SOURCE_SHA,
        owner_source_sha256=sha(ROOT/'sdk/yi4k_1107_aac_boundary.c'),
        owner_header_sha256=sha(ROOT/'sdk/yi4k_1107_aac_boundary.h'),
        custody='Separate downstream Python byte copy, not mux/Close success or durable SD proof')
    # Conservative complete header snapshot includes every transitive local
    # contract, not just the new owner's public header.
    report['sdk_header_sha256']={str(p.relative_to(ROOT)):sha(p)
        for p in sorted((ROOT/'sdk').glob('yi4k_1107_*.h'))}
    try:
        require(sha(SOURCE)==SOURCE_SHA,'archive identity changed')
        wrapper=out/'independent-wrapper.c';wrapper.write_text(WRAPPER)
        library=out/'independent-owner.dylib';compiler=shutil.which('clang');require(compiler,'clang missing')
        cmd=[compiler,'-std=c11','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC',
             '-I',str(ROOT/'sdk'),str(wrapper),str(ROOT/'sdk/yi4k_1107_aac_boundary.c'),'-o',str(library)]
        subprocess.run(cmd,check=True,capture_output=True)
        report['compile_command']=cmd;report['compiled_library_sha256']=sha(library)
        lib=C.CDLL(str(library));u32=C.c_uint32;u64=C.c_uint64;ptr=C.POINTER(C.c_ubyte)
        for name,types in [('fresh',[u32,u64,u32]),('offer',[ptr,u32,u32,u64]),
                           ('advance',[u64,u64,u64,u32]),('receipt',[u64,u32])]:
            fn=getattr(lib,name);fn.argtypes=types;fn.restype=C.c_int32
        lib.field.argtypes=[u32];lib.field.restype=u64
        lib.read_bytes.argtypes=[ptr];lib.read_bytes.restype=u32
        lib.snapshot_size.restype=u32;lib.snapshot.argtypes=[ptr]
        def state():return [int(lib.field(i)) for i in range(9)]
        def copied():
            b=(C.c_ubyte*32768)();size=lib.read_bytes(b);return bytes(b[:size])
        def snapshot():
            b=(C.c_ubyte*lib.snapshot_size())();lib.snapshot(b);return bytes(b)
        argv=[str(FFPROBE),'-v','error','-select_streams','a:0','-show_packets',
            '-show_entries','packet=pts,dts,duration,pos,size','-of','json',str(SOURCE)]
        packets=json.loads(subprocess.run(argv,check=True,capture_output=True).stdout)['packets']
        packets=[p for p in packets if int(p['pts'])<3075072] # 64.064 * 48000
        require(len(packets)==3003,'AAC source window count changed')
        require(lib.fresh(48000,1801800,30000)==0,'init failed')
        segments={1:[],2:[]};crossing=None;upstream_overwrites=0;retry_checks=0
        with SOURCE.open('rb') as stream:
            for sequence,p in enumerate(packets):
                pts=int(p['pts']);duration=int(p['duration']);size=int(p['size'])
                require(int(p['dts'])==pts and duration==1024,'archive AAC timeline changed')
                stream.seek(int(p['pos']));data=stream.read(size);require(len(data)==size,'payload extent short')
                upstream=(C.c_ubyte*size).from_buffer_copy(data)
                result=lib.offer(upstream,size,sequence,pts)
                expected=1 if Fraction(pts+1024,48000)<=Fraction(1801800 if sequence<=2815 else 1921920,30000) else 2
                # The state machine split changes only after held AAC2815.
                require(result==expected,f'whole-packet decision differs at AAC{sequence}')
                for i in range(size):upstream[i]=0xcc
                upstream_overwrites+=1;require(copied()==data,'upstream overwrite changed owned copy')
                ticket=int(lib.field(1))
                if result==2:
                    require(sequence==2815 and crossing is None,'unexpected held packet')
                    before=snapshot();require(lib.receipt(ticket,1)==-2,'NEXT released before advance')
                    require(snapshot()==before,'denied NEXT receipt mutated custody')
                    require(lib.offer(upstream,size,sequence+1,pts+1024)==4,'NEXT accepted overwrite')
                    require(snapshot()==before,'busy offer mutated held packet')
                    require(lib.advance(2,pts+1,1921920,30000)==-1,'origin after held PTS accepted')
                    require(snapshot()==before,'invalid advance mutated custody')
                    require(lib.advance(2,pts,1921920,30000)==1,'valid next-segment advance failed')
                    require(copied()==data and state()[4:7]==[pts,pts,sequence],'advance changed held payload/times/sequence')
                    crossing=dict(source_index=sequence,pts=pts,bytes=size,sha256=hashlib.sha256(data).hexdigest(),
                                  new_source_epoch=int(lib.field(3)),ticket=ticket)
                # Retry is admissible only when the test's downstream operation
                # did NOTHING. No writer or speculative index/cursor mutation.
                if sequence in (0,2815,3002):
                    before=snapshot();require(lib.receipt(ticket,0)==1,'untouched retry failed')
                    require(snapshot()==before,'untouched retry changed ticket/bytes/metadata');retry_checks+=1
                    require(lib.receipt(ticket+1,1)==-2,'stale/wrong ticket released')
                    require(snapshot()==before,'wrong receipt mutated held packet')
                downstream=bytes(copied());require(downstream==data,'downstream custody copy differs')
                segment=int(lib.field(2));segments[segment].append(hashlib.sha256(downstream).hexdigest())
                require(lib.receipt(ticket,1)==0,'custody receipt failed')
                after=snapshot();require(lib.receipt(ticket,1)==-2,'duplicate receipt released twice')
                require(snapshot()==after,'duplicate receipt changed owner')
        require([len(segments[i]) for i in (1,2)]==[2815,188],'real minute AAC assignment wrong')
        report['archived_replay']=dict(aac_packets=3003,segment_counts={str(k):len(v) for k,v in segments.items()},
            ordered_payload_sha256_digest=hashlib.sha256(''.join(segments[1]+segments[2]).encode()).hexdigest(),
            crossing=crossing,upstream_overwrites_preserved=upstream_overwrites,
            retry_untouched_snapshot_checks=retry_checks,once_only_receipt_checks=3003)
        # Full-width rational classification through the public compiled API,
        # independently evaluated with Python's arbitrary-precision integers.
        rng=random.Random(0x41414342);random_cases=4096;maximum_product=0
        payload=(C.c_ubyte*1)(0x55)
        for case in range(random_cases):
            rate=rng.randint(1,0xffffffff);split_scale=rng.randint(1,0xffffffff)
            end=rng.randint(1024,(1<<64)-1);split=rng.randint(1,(1<<64)-1)
            if case<8:
                end=(1<<64)-1-case;split=(1<<64)-1-case
                rate=0xffffffff;split_scale=0xffffffff-case
            require(lib.fresh(rate,split,split_scale)==0,'full-width rational init failed')
            result=lib.offer(payload,1,0,end-1024)
            left=end*split_scale;right=split*rate;maximum_product=max(maximum_product,left,right)
            require(result==(1 if left<=right else 2),f'96bit rational mismatch case{case}')
        # Overflow rejection is transactional; ambiguous result freezes custody.
        require(lib.fresh(48000,1801800,30000)==0,'failure fixture init')
        before=snapshot();require(lib.offer(payload,1,0,(1<<64)-1024)==-4,'end overflow accepted')
        require(snapshot()==before,'overflow rejection mutated state')
        require(lib.offer(payload,1,0,0)==1,'failure fixture offer')
        before=snapshot();require(lib.receipt(int(lib.field(1)),2)==-2,'ambiguous receipt not rejected')
        require(lib.field(0)==3 and copied()==b'\x55','ambiguous outcome lost custody')
        frozen=snapshot();require(lib.offer(payload,1,1,1024)==-2,'frozen controller accepted replay')
        require(snapshot()==frozen,'frozen rejection mutated custody')
        report.update(status='pass_independent_compiled_archive_replay',
            rational_oracle=dict(cases=random_cases,maximum_cross_product_bits=maximum_product.bit_length(),
                result='all exact classifications match arbitrary-precision cross multiplication'),
            negative_checks=['NEXT cannot receipt or overwrite before advance','invalid advance transactional',
                'wrong/stale/duplicate receipt cannot release','RETRY_UNTOUCHED retains exact bytes/metadata/ticket',
                'AAC end overflow rejects without mutation','AMBIGUOUS freezes and retains bytes; replay denied'],
            limits=['Host compiled controller and synthetic caller receipts only; no actual downstream writer custody/Close integration.',
                'Attestation identity/config and source epoch are fixture bindings, not proof of a hardware shared clock.',
                'No native mux replay or device/SD operations; one packet owner does not constitute a live minute ring.'])
        require(sha(ROOT/'sdk/yi4k_1107_aac_boundary.c')==report['owner_source_sha256'],
            'owner source changed during validation')
        require(all(sha(ROOT/p)==digest for p,digest in report['sdk_header_sha256'].items()),
            'SDK header contract changed during validation')
    except Exception as error:
        report.update(status='reject_independent_compiled_archive_replay',error=str(error),traceback=traceback.format_exc())
    (out/'review.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report.get(k) for k in ('status','error','archived_replay','rational_oracle')},indent=2))
    return int(report['status'].startswith('reject'))

if __name__=='__main__':raise SystemExit(main())
