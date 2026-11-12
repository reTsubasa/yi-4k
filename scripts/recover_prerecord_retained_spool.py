#!/usr/bin/env python3
"""POSIX spool recovery from actual frozen native-failure C snapshots only.

No source MP4 access, mux replay, re-encode, or camera. A fresh child process C
scanner stages records; an external expected-snapshot manifest gates release.
Host fsync/process readback is not evidence of physical SD power-loss safety.
"""
from __future__ import annotations
import argparse
import ctypes as C
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import traceback

ROOT=Path(__file__).resolve().parents[1]
INPUT=ROOT/'artifacts/verification/2026-11-11-prerecord-aac-custody-native-integration-run03'
AUDIT_SHA='53d9d44471a71b35af4dd83049640310eaeae57b1edc4ce7665eea089c682471'
CORE_SHA='300196050a915e8bf2716044c3ddde718f45379d9d08c407a9326116ebfa9ebe'
HEADER_SHA='36758602a36841d8253daa57d069399387b74baaac0adee45945e14ce516ba80'
WRAPPER=r'''
#include "yi4k_packet_spool.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
static yi4k_packet_spool controller;
static unsigned char scratch[1048576];
static yi4k_spool_identity identity;
static int descriptor=-1;
static int32_t size_fn(void *c,uint64_t *n){struct stat s;(void)c;if(fstat(descriptor,&s))return -1;*n=(uint64_t)s.st_size;return 0;}
static int32_t write_fn(void *c,uint64_t at,const uint8_t *p,uint32_t n,uint32_t *got){ssize_t r;(void)c;r=pwrite(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;return r<0?-1:0;}
static int32_t read_fn(void *c,uint64_t at,uint8_t *p,uint32_t n,uint32_t *got){ssize_t r;(void)c;r=pread(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;return r<0?-1:0;}
static int32_t sync_fn(void *c){(void)c;return fsync(descriptor);}
static yi4k_spool_io io={0,size_fn,write_fn,read_fn,sync_fn};
static void set_id(uint64_t segment,const unsigned char *digest){memset(&identity,0,sizeof(identity));identity.session=1107;identity.segment=segment;identity.epoch=1;memcpy(identity.config_digest,digest,32);}
int create_file(const char *path,uint64_t segment,const unsigned char *digest){
 char parent[4096],*slash;int parent_fd;
 if(strlen(path)>=sizeof(parent))return -91;
 strcpy(parent,path);slash=strrchr(parent,'/');if(!slash)return -92;*slash=0;
 descriptor=open(path,O_RDWR|O_CREAT|O_EXCL,0600);if(descriptor<0)return -90;
 parent_fd=open(parent,O_RDONLY);if(parent_fd<0)return -93;
 if(fsync(parent_fd)){close(parent_fd);return -94;}close(parent_fd);
 memset(&controller,0,sizeof(controller));set_id(segment,digest);
 return yi4k_spool_init(&controller,&io,&identity,scratch,sizeof(scratch));
}
int close_file(void){int r=close(descriptor);descriptor=-1;return r;}
int append_record(uint32_t kind,uint32_t sequence,uint64_t pts,uint32_t scale,uint32_t duration,uint32_t type,uint32_t address,const unsigned char *p,uint32_t n){
 yi4k_spool_sample s;memset(&s,0,sizeof(s));s.packet.payload=p;s.packet.source_kind=kind;
 s.packet.descriptor.sequence=sequence;s.packet.descriptor.corrected_pts=pts;
 s.packet.descriptor.type=(uint8_t)type;s.packet.descriptor.flags=1;
 s.packet.descriptor.cpu_payload_address=address;s.packet.descriptor.payload_size=n;
 s.dts=s.pts=pts;s.scale=scale;s.duration=duration;return yi4k_spool_append(&controller,&s);
}
typedef int32_t (*emit_fn)(uint64_t,uint32_t,uint32_t,uint64_t,uint64_t,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t,const uint8_t *,uint32_t);
static emit_fn emit;
static int32_t collect(void *c,uint64_t ordinal,const yi4k_spool_sample *s){
 const yi4k_1107_frame_desc *d=&s->packet.descriptor;(void)c;
 return emit(ordinal,s->packet.source_kind,d->sequence,s->dts,s->pts,s->scale,s->duration,d->type,d->flags,d->cpu_payload_address,s->packet.payload,d->payload_size);
}
int scan_file(const char *path,uint64_t segment,const unsigned char *digest,emit_fn callback,uint64_t *words){
 yi4k_spool_scan_result r;int status;set_id(segment,digest);emit=callback;
 descriptor=open(path,O_RDONLY);if(descriptor<0)return -90;
 status=yi4k_spool_scan(&io,&identity,scratch,sizeof(scratch),collect,0,&r);
 words[0]=r.file_bytes;words[1]=r.committed_bytes;words[2]=r.records;words[3]=r.trailing_bytes;words[4]=r.corrupt;
 close_file();return status;
}
'''


def sha(path):
    with Path(path).open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()


def require(ok,message):
    if not ok:raise ValueError(message)


U32=C.c_uint32;U64=C.c_uint64;PTR=C.POINTER(C.c_ubyte)
EMIT=C.CFUNCTYPE(C.c_int32,U64,U32,U32,U64,U64,U32,U32,U32,U32,U32,PTR,U32)


def library(path):
    lib=C.CDLL(str(path))
    lib.create_file.argtypes=[C.c_char_p,U64,PTR];lib.create_file.restype=C.c_int32
    lib.close_file.restype=C.c_int32
    lib.append_record.argtypes=[U32,U32,U64,U32,U32,U32,U32,PTR,U32];lib.append_record.restype=C.c_int32
    lib.scan_file.argtypes=[C.c_char_p,U64,PTR,EMIT,C.POINTER(U64)];lib.scan_file.restype=C.c_int32
    return lib


def buffer(data):return (C.c_ubyte*len(data)).from_buffer_copy(data)


def read_worker(library_path,spool,manifest_path,destination):
    # Child starts without writer controller/payload RAM. All callback data is
    # copied to staging; nothing is released until scan AND manifest gate pass.
    destination.mkdir(parents=True,exist_ok=False)
    staging=destination/'staging';staging.mkdir()
    manifest=json.loads(manifest_path.read_text());rows=[];errors=[]
    lib=library(library_path)
    @EMIT
    def emit(ordinal,kind,sequence,dts,pts,scale,duration,type_,flags,address,payload,size):
        try:
            data=C.string_at(payload,size);name=f'{ordinal:04d}.bin';(staging/name).write_bytes(data)
            rows.append(dict(ordinal=ordinal,kind=kind,sequence=sequence,dts=dts,pts=pts,scale=scale,
                duration=duration,type=type_,flags=flags,address=address,bytes=size,
                sha256=hashlib.sha256(data).hexdigest(),staged_file=name))
            return 0
        except Exception as error:errors.append(str(error));return -1
    words=(U64*5)();status=lib.scan_file(os.fsencode(spool),manifest['segment'],
        buffer(bytes.fromhex(manifest['config_digest'])),emit,words)
    canonical=[{k:v for k,v in row.items() if k!='staged_file'} for row in rows]
    expected=[{k:v for k,v in row.items() if k!='snapshot'} for row in manifest['records']]
    gate=status==0 and canonical==expected and not errors
    if gate:staging.rename(destination/'verified-snapshot-set')
    result=dict(schema=1,status='pass_exact_snapshot_recovery' if gate else 'reject_incomplete_or_changed_snapshot_set',
        reader_pid=os.getpid(),writer_memory_used=False,scan_status=status,file_bytes=int(words[0]),
        committed_bytes=int(words[1]),records=int(words[2]),trailing_bytes=int(words[3]),corrupt=int(words[4]),
        expected_records=len(expected),recovered_records=canonical,expected_snapshot_manifest_sha256=sha(manifest_path),
        exact_metadata_payload_match=canonical==expected,complete_snapshot_set_released=gate,
        complete_original_recording=False,callback_observations_staged_until_full_gate=True,errors=errors)
    (destination/'readback.json').write_text(json.dumps(result,indent=2)+'\n')
    return 0


def snapshot_records(audit):
    normal=next(c for c in audit['scenarios'] if c['name']=='normal')
    failed=next(c for c in audit['scenarios'] if c['name']=='close_failure')
    require(failed['close_failure']['custody_state']==[[3,8,0],[3,12,0]],'failed C custody state changed')
    require(failed['close_failure']['held_bytes_preserved'],'failed boundary custody absent')
    require(audit['status']=='pass_composition_with_expected_publication_rejection','integration did not finish')
    records=[];hashes={}
    # Metadata from the frozen first CLOSED output table (zero epoch/no delay).
    # Bytes ONLY from failure C-custody bins; no original MP4 is opened here.
    first=normal['segments'][0]
    require(first['strict_consumer_gate']['status']=='pass','first closed mapping rejected')
    for st in (0,1):
        packets=[p for p in first['packets'] if p['stream']==st]
        require(len(packets)==(8 if st==0 else 12),'snapshot track count wrong')
        for slot,p in enumerate(packets):
            name=f'custody-seg1-track{st}-slot{slot}.bin';path=INPUT/'close_failure'/name
            require(sha(path)==failed['retained'][name]==p['sha256'],'failure snapshot identity mismatch')
            hashes[str(path.relative_to(ROOT))]=sha(path)
            records.append(dict(kind=1 if st==0 else 2,sequence=p['index'],dts=p['dts'],pts=p['pts'],
                scale=30000 if st==0 else 48000,duration=p['duration'],type=1 if st==0 and p['key'] else 3 if st==0 else 8,
                flags=1,address=0,bytes=p['bytes'],sha256=p['sha256'],snapshot=str(path.relative_to(ROOT))))
    held=failed['close_failure']['held_boundary'];path=INPUT/'close_failure/held-boundary-aac12.bin'
    require(sha(path)==held['sha256'] and held['index']==12,'held failureAAC12 mismatch')
    hashes[str(path.relative_to(ROOT))]=sha(path)
    records.append(dict(kind=2,sequence=held['index'],dts=held['dts'],pts=held['pts'],scale=48000,
        duration=held['duration'],type=8,flags=1,address=0,bytes=held['bytes'],sha256=held['sha256'],snapshot=str(path.relative_to(ROOT))))
    tail=normal['final_tail'];packet=tail['packet'];path=INPUT/'normal/final-held-aac25.bin'
    require(tail['owner_state']==2 and not tail['submitted_to_writer'] and not tail['released'],'finalAAC25 owner state changed')
    require(sha(path)==tail['owned_sha256']==packet['sha256'] and packet['index']==25,'finalAAC25 bin mismatch')
    hashes[str(path.relative_to(ROOT))]=sha(path)
    tailrecord=dict(kind=2,sequence=25,dts=packet['dts'],pts=packet['pts'],scale=48000,duration=packet['duration'],
        type=8,flags=1,address=0,bytes=packet['bytes'],sha256=packet['sha256'],snapshot=str(path.relative_to(ROOT)))
    # Serialized address0 explicitly means unavailable source provenance. Old
    # audit did not snapshot every descriptor reserved/address field; do NOT
    # invent them or claim bitwise descriptor reconstruction.
    return [('close-failure-and-held12',1,records),('final-held25',2,[tailrecord])],hashes


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',type=Path)
    ap.add_argument('--reader',nargs=4,metavar=('LIB','SPOOL','MANIFEST','DEST'))
    args=ap.parse_args()
    if args.reader:
        lib,spool,manifest,destination=args.reader
        return read_worker(Path(lib),Path(spool),Path(manifest),Path(destination))
    require(args.output is not None,'--output required')
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=False)
    report=dict(schema=1,status='running',device_access=False,source_oracle_used_for_payload=False,
        input_integration_audit_sha256=AUDIT_SHA,spool_core_sha256=CORE_SHA,spool_header_sha256=HEADER_SHA,
        script_sha256=sha(Path(__file__)),parent_pid=os.getpid(),cases=[],
        metadata_scope='Canonical sequence/PTS/DTS/type/flags/length from frozen audit mapping, source address/reserved fields unavailable and not reconstructed',
        persistence_domain='POSIX pwrite + file fsync + parent-directory fsync + fresh-process pread; host only, not physical SD power-loss proof')
    try:
        require(sha(INPUT/'audit.json')==AUDIT_SHA,'integration audit changed')
        require(sha(ROOT/'sdk/yi4k_packet_spool.c')==CORE_SHA,'frozen spool core changed')
        require(sha(ROOT/'sdk/yi4k_packet_spool.h')==HEADER_SHA,'frozen spool contract changed')
        audit=json.loads((INPUT/'audit.json').read_text())
        for path,digest in audit['source_hashes'].items():require(sha(ROOT/path)==digest,'integration implementation changed')
        cases,input_hashes=snapshot_records(audit);report['snapshot_hashes']=input_hashes
        wrapper=out/'snapshot-posix-wrapper.c';wrapper.write_text(WRAPPER)
        shared=out/'snapshot-spool.dylib';clang=shutil.which('clang');require(clang,'clang missing')
        command=[clang,'-std=c11','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC',
            '-I'+str(ROOT/'sdk'),str(wrapper),str(ROOT/'sdk/yi4k_packet_spool.c'),'-o',str(shared)]
        subprocess.run(command,check=True,capture_output=True);report['compile_command']=command
        lib=library(shared);report['wrapper_sha256']=sha(wrapper);report['library_sha256']=sha(shared)
        # Preserve the source fixture's actual config attestation. The frozen
        # integration wrapper binds config_digest to32 bytes of2; it is not a
        # hash inferred from AAC or proof of an authenticated hardware epoch.
        fixture=(ROOT/'scripts/integrate_prerecord_aac_custody_native.py').read_text()
        require('memset(config.config_digest,2,32)' in fixture,'archived config binding unavailable')
        binding='02'*32
        report['config_digest_provenance']='Frozen integration C wrapper config.config_digest=32 bytes of2; external caller attestation only'
        for label,segment,records in cases:
            manifest=dict(schema=1,segment=segment,config_digest=binding,records=[dict(p,ordinal=i+1) for i,p in enumerate(records)],
                complete_original_recording=False,expected_original_video_packets=16,expected_original_aac_packets=26)
            manifest_path=out/f'{label}.expected.json';manifest_path.write_text(json.dumps(manifest,indent=2)+'\n')
            spool=out/f'{label}.spool';require(lib.create_file(os.fsencode(spool),segment,buffer(bytes.fromhex(binding)))==0,'POSIX create/init failed')
            lengths=[]
            for row in records:
                data=(ROOT/row['snapshot']).read_bytes();require(hashlib.sha256(data).hexdigest()==row['sha256'],'snapshot changed')
                incoming=buffer(data)
                status=lib.append_record(row['kind'],row['sequence'],row['pts'],row['scale'],row['duration'],row['type'],0,incoming,len(data))
                require(status==0,'compiled spool append/readback/fsync failed')
                C.memset(incoming,0xee,len(data));lengths.append(184+len(data))
            require(lib.close_file()==0,'writer fd close failed')
            variants=[('positive',spool)]
            if len(records)>1:
                for suffix,cut in [('record-boundary-cut',sum(lengths[:-1])),('torn-final-marker',spool.stat().st_size-12)]:
                    path=out/f'{label}-{suffix}.spool';path.write_bytes(spool.read_bytes()[:cut])
                    with path.open('rb') as stream:os.fsync(stream.fileno())
                    variants.append((suffix,path))
            for suffix,path in variants:
                destination=out/f'{label}-{suffix}-readback'
                process=subprocess.run([sys.executable,str(Path(__file__).resolve()),'--reader',str(shared),str(path),
                    str(manifest_path),str(destination)],capture_output=True)
                require(process.returncode==0,'fresh reader process failed: '+process.stderr.decode(errors='replace'))
                recovered=json.loads((destination/'readback.json').read_text())
                require(recovered['reader_pid']!=os.getpid(),'reader was not new process')
                expected=suffix=='positive'
                require(recovered['complete_snapshot_set_released']==expected,'external snapshot gate wrong')
                if suffix=='record-boundary-cut':require(recovered['scan_status']==0 and recovered['records']==20,'complete-prefix cut classification wrong')
                if suffix=='torn-final-marker':require(recovered['scan_status']==-5 and recovered['records']==20,'torn-marker prefix classification wrong')
                if expected:
                    for row in manifest['records']:
                        payload=destination/'verified-snapshot-set'/f'{row["ordinal"]:04d}.bin'
                        require(sha(payload)==row['sha256'] and payload.read_bytes()==(ROOT/row['snapshot']).read_bytes(),'fresh output differs from original C snapshot')
                report['cases'].append(dict(name=label+'-'+suffix,spool_file=path.name,spool_sha256=sha(path),
                    readback=str((destination/'readback.json').relative_to(out)),scan_status=recovered['scan_status'],
                    records=recovered['records'],expected_records=len(records),reader_pid=recovered['reader_pid'],
                    snapshot_gate='pass' if expected else 'reject',complete_original_recording=False))
        require(all(sha(ROOT/path)==digest for path,digest in input_hashes.items()),'original snapshots mutated')
        require(sha(ROOT/'sdk/yi4k_packet_spool.c')==CORE_SHA and sha(ROOT/'sdk/yi4k_packet_spool.h')==HEADER_SHA,'frozen implementation changed during run')
        report.update(status='pass_actual_frozen_snapshot_spool_recovery',original_snapshots_unchanged=True,
            recovered_snapshot_counts=dict(close_failure_video=8,close_failure_audio=12,held_boundary_audio=1,final_held_audio=1),
            whole_recording_publication_gate='reject',limitations=[
                'Only22 actually retained packets are recovered; no source oracle fills remaining original42packet set.',
                'No full MP4 recovery, C frozen-state reset, callback/SD/RTOS binding or actual power-loss test.',
                'Original descriptor source addresses/reserved fields absent from archived snapshots; canonical mapped metadata only.',
                'External expected manifest detects record-boundary truncation; spool scan alone only proves a verified prefix.',
                'Identity/config digest preserve synthetic archived caller attestations, not authentication of a common hardware clock or codec epoch.'])
    except Exception as error:
        report.update(status='reject_snapshot_spool_recovery',error=str(error),traceback=traceback.format_exc(),whole_recording_publication_gate='reject')
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report.get(k) for k in ('status','error','recovered_snapshot_counts','whole_recording_publication_gate')},indent=2))
    return int(report['status'].startswith('reject'))

if __name__=='__main__':raise SystemExit(main())
