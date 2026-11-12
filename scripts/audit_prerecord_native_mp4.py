#!/usr/bin/env python3
"""Offline original ARM index/MP4 execution; file/OS are explicit RAM models."""
from __future__ import annotations
import argparse
import hashlib
import json
import struct
import subprocess
from collections import Counter
from pathlib import Path
from unicorn.arm_const import *
from unicorn import UC_HOOK_MEM_INVALID
import audit_prerecord_owned_mux_writer as stock

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'artifacts/device/2026-11-11-prerecord-native-mp4'
MEMOBJ,MEMMETA,MEMDATA=0x11000000,0x11001000,0x12000000
HEAP=0x13000000
FORMAT,MOOV=0x10002000,0x11010000
SEEK,READ,SYNC,FUNC=0x10011800,0x10011A00,0x10011C00,0x10011E00

def sha(b):return hashlib.sha256(b).hexdigest()

class NativeMachine(stock.WriterMachine):
    def __init__(self,image):
        super().__init__(image)
        self.uc.mem_map(0x11000000,0x20000)
        self.uc.mem_map(MEMDATA,0x1000000)
        self.uc.mem_map(HEAP,0x1000000)
        self.heap=HEAP
        self.position=0
        self.native_calls=[]
        self.allocations=[]
        self.frees=[]
        self.logs=[]
        self.index_reads=[]
        self.index_writes=[]
        self.added=[]
        self.stream_events=[]
        self.pool_allocate_fail_at=None
        self.block_allocate_fail_at=None
        self.byte_allocate_count=0
        self.block_allocate_count=0
        self.seek_fail_at=None
        self.seek_count=0
        self.put(stock.VTABLE+8,READ)
        self.put(stock.VTABLE+0x10,SEEK)
        self.put(stock.VTABLE+0x1C,SYNC)
        self.put(stock.VTABLE+0x20,FUNC)
        self.put(0xA1965A6C,MEMOBJ)
        self.put(0xA1965A70,MEMMETA)
        self.put(0xA1965A74,MEMDATA)
        self.put(0xA1965A7C,0x8000)
        self.put(0xA1965A80,0x8000)
        self.put(0xA1965A85,1,1)
        # Explicit constructed Amba metadata version state, not firmware patch.
        self.put(0xA19653F9,2,1)
        self.put(0xA19653FA,0,1)
        self.uc.hook_add(UC_HOOK_MEM_INVALID,self.invalid_memory)

    def invalid_memory(self,uc,access,address,size,value,user):
        raise RuntimeError(f'invalid memory {address:x}+{size:x} pc={uc.reg_read(UC_ARM_REG_PC):x}')

    def hook(self,uc,address,size,user):
        if 0x11000000<=address<0x14000000: raise RuntimeError(f'executing RAM {address:x}')
        args=[uc.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
        status=None
        if address==stock.WRITE:
            assert args[0]==stock.STREAM
            data=bytes(uc.mem_read(args[2],args[1]))
            returned=args[1]-1 if len(self.writes)==self.short_write_at else args[1]
            needed=self.position+returned
            if needed>len(self.output):self.output.extend(bytes(needed-len(self.output)))
            self.output[self.position:needed]=data[:returned]
            self.writes.append(dict(offset=self.position,source_address=hex(args[2]),requested_bytes=args[1],returned_bytes=returned,sha256=sha(data)))
            self.position=needed
            status=returned
        elif address==stock.TELL:
            status=self.position;uc.reg_write(UC_ARM_REG_R1,0)
        elif address==stock.LENGTH:
            status=len(self.output);uc.reg_write(UC_ARM_REG_R1,0)
        elif address==SEEK:
            # AAPCS 64-bit offset starts at even register pair r2/r3;
            # r1 is padding, whence lives at the entry stack word.
            origin=self.get(uc.reg_read(UC_ARM_REG_SP))
            offset=(args[3]<<32)|args[2]
            if offset&(1<<63):offset-=1<<64
            assert origin in (0,1,2),origin
            base=0 if origin==0 else self.position if origin==1 else len(self.output)
            target=base+offset
            assert 0<=target<0x10000000,(args,target)
            status=-12 if self.seek_count==self.seek_fail_at else 0
            self.seek_count+=1
            self.stream_events.append(dict(kind='seek',old_position=self.position,offset=offset,origin=origin,target=target,status=status))
            if status==0:self.position=target
        elif address==READ:
            data=bytes(self.output[self.position:self.position+args[1]])
            uc.mem_write(args[2],data);self.position+=len(data);status=len(data)
        elif address==SYNC:status=0
        elif address==FUNC:
            assert args[1]==2,args
            self.put(args[2],0);status=0
        elif address in (0xA03BC458,):status=0
        elif address==0xA03C3C5C:
            self.locks[args[0]]=self.locks.get(args[0],0)-1;status=0
        elif address==0xA029A7D8:
            n=args[3]
            status=7 if self.byte_allocate_count==self.pool_allocate_fail_at else 0
            self.byte_allocate_count+=1
            if status==0:
                ptr=(self.heap+31)&~31;self.heap=ptr+n
                assert self.heap<HEAP+0x1000000
                self.put(args[1],ptr);self.put(args[2],ptr)
                self.allocations.append(dict(kind='byte_pool',address=hex(ptr),bytes=n))
        elif address==0xA03BC74C:
            status=7 if self.block_allocate_count==self.block_allocate_fail_at else 0
            self.block_allocate_count+=1
            if status==0:
                ptr=(self.heap+31)&~31;self.heap=ptr+0x1000
                self.put(args[1],ptr)
                self.allocations.append(dict(kind='block_pool',address=hex(ptr),bytes=0x1000))
        elif address in (0xA03C3414,0xA03BC714):self.frees.append(args);status=0
        elif address==0xA04894FC:
            self.put(args[1],0x60000000);status=0
        elif address==0xA02A7524:
            raise RuntimeError(f'firmware assertion lr={uc.reg_read(UC_ARM_REG_LR):x}, logs={self.logs[-3:]}')
        elif address==0xA02A70EC:
            def cstr(p):
                try:return bytes(uc.mem_read(p,160)).split(b'\0')[0].decode(errors='replace')
                except Exception:return hex(p)
            entry=dict(format=cstr(args[0]),arguments=args[1:])
            if 'Error' in entry['format']:
                entry.update(function=cstr(args[2]),line=args[3],message=cstr(self.get(uc.reg_read(UC_ARM_REG_SP))))
            self.logs.append(entry)
            status=0
        if address==0xA0411E88:
            width=8 if args[2] in (4,6,10) else 4
            self.added.append(dict(track=args[1],kind=args[2],data_hex=bytes(uc.mem_read(args[3],width)).hex()))
        if address in (0xA0402884,0xA0402750):
            entry=dict(offset=args[1],bytes=args[2],buffer=hex(args[3]))
            (self.index_reads if address==0xA0402884 else self.index_writes).append(entry)
        if address in (0xA040F710,0xA0411E88,0xA04111AC,0xA0411048,0xA040FC04,
            0xA04032FC,0xA0402750,0xA0402884,0xA0402ED8,0xA0401AE4,0xA0435A18,0xA0436004,0xA0433AF0):
            self.native_calls.append(dict(entry=hex(address),args=args))
        if status is not None:
            uc.reg_write(UC_ARM_REG_R0,status&0xFFFFFFFF)
            uc.reg_write(UC_ARM_REG_PC,uc.reg_read(UC_ARM_REG_LR));return
        if address in (0xA0411E88,0xA04111AC):
            return stock.life.Machine.hook(self,uc,address,size,user)
        super().hook(uc,address,size,user)

    def setup_index(self,audio=True):
        track=self.movie(video=True,audio=audio)
        mem=self.call(0xA0402610,stock.CONFIG)
        assert mem==MEMOBJ,hex(mem)
        self.uc.mem_write(stock.MOVIE+0x10,b'offline.mp4\0')
        self.put(FORMAT+4,stock.MOVIE)
        self.put(FORMAT+8,stock.STREAM)
        self.put(FORMAT+0x10,60000)
        return track,mem

def open_mux(m,mem,cache):
    return m.call(0xA0435A18,FORMAT,mem,stock.INDEX,cache,0,1,0xA0435630)

def close_mux(m,mem,cache):
    return m.call(0xA0436004,FORMAT,mem,stock.INDEX,cache,0,0xA0433AF0,0xA0433C1C,MOOV,0)

def sample(m,track,data,video,number=0):
    ptr=m.payload(data,32)
    m.descriptor(data,ptr,1 if video else 8,pts=number*(1001 if video else 1024))
    if video:return m.call(0xA042D0F8,stock.MOVIE,track,stock.PARAMS,stock.INDEX,stock.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)
    return m.call(0xA043173C,stock.MOVIE,track+0x90,stock.INDEX,stock.STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)

def command(argv):
    result=subprocess.run([str(a) for a in argv],capture_output=True)
    assert result.returncode==0,(argv,result.stderr.decode(errors='replace'))
    return result.stdout

def decode(path):
    probe=json.loads(command([stock.FFPROBE,'-v','error','-count_packets','-show_streams','-of','json',path]))
    frames=command([stock.FFMPEG,'-v','error','-i',path,'-map','0:v:0','-f','framemd5','-'])
    pcm=command([stock.FFMPEG,'-v','error','-i',path,'-map','0:a:0','-f','s16le','-'])
    video=[line.split(',')[-1].strip() for line in frames.decode().splitlines() if not line.startswith('#')]
    return dict(streams=[{k:s[k] for k in ('codec_name','profile','width','height','sample_rate','channels','time_base','duration_ts','nb_read_packets','extradata_size') if k in s} for s in probe['streams']],
        video_frame_md5=video,audio_pcm_bytes=len(pcm),audio_pcm_sha256=sha(pcm))

def snapshot(m):
    return dict(output_bytes=len(m.output),fifo_read_cursor=m.get(stock.life.VIRTUAL+0x90,8),
        memidx_data_pointer=hex(m.get(MEMOBJ+0x38)),index_zeroed=bytes(m.uc.mem_read(stock.INDEX,0x138))==bytes(0x138),
        index_backend_reads=len(m.index_reads),index_backend_writes=len(m.index_writes),frees=len(m.frees),
        native_call_counts=dict(Counter(c['entry'] for c in m.native_calls)),mock_index_events=len(m.index_events))

def read_back(m,start):
    # Observe Add inputs; execute actual cache read and actual MemIdx backend.
    mapping={2:0,3:1,4:2,5:3,6:4,8:0,9:1,10:2}
    entries={}
    for entry in m.added[start:]:entries.setdefault((entry['track'],entry['kind']),[]).append(entry['data_hex'])
    before=len(m.index_reads);out=[]
    for (track,kind),values in entries.items():
        for i,expected in enumerate(values):
            width=len(bytes.fromhex(expected));m.uc.mem_write(stock.RESULT,bytes(16))
            status=m.call(0xA0401AE4,m.get(stock.INDEX+0x68),track,mapping[kind],i,0,width,stock.RESULT)
            actual=bytes(m.uc.mem_read(stock.RESULT,width)).hex()
            assert status==0 and actual==expected,(track,kind,i,status,actual,expected)
            out.append(dict(track=track,kind=kind,index=i,bytes=width,value_hex=actual))
    assert len(m.index_reads)>before
    return dict(entries=out,backend_reads_during_readback=len(m.index_reads)-before)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output','--output-dir',dest='output_dir',type=Path,default=OUT)
    args=parser.parse_args();out=args.output_dir;out.mkdir(parents=True,exist_ok=True)
    image=stock.life.arm.IMAGE.read_bytes();assert sha(image)==stock.life.arm.DIGEST
    video,nals,audio,source=stock.load_archived_samples()
    source_video=command([stock.FFMPEG,'-v','error','-i',stock.SAMPLE_MP4,'-map','0:v:0','-frames:v','1','-f','framemd5','-'])
    source_video_md5=[x.split(',')[-1].strip() for x in source_video.decode().splitlines() if not x.startswith('#')]
    source_audio=command([stock.FFMPEG,'-v','error','-i',stock.SAMPLE_MP4,'-map','0:a:0','-frames:a','1','-f','s16le','-'])
    cases=[]
    def save(m,name,nvideo,naudio):
        assert not m.index_events,'mock Add/Commit must never execute'
        path=out/(name+'.mp4');path.write_bytes(m.output);decoded=decode(path)
        assert decoded['video_frame_md5']==source_video_md5*nvideo
        assert int(decoded['streams'][0]['nb_read_packets'])==nvideo
        assert int(decoded['streams'][1]['nb_read_packets'])==naudio
        # Repeated compressed AAC packets retain decoder overlap state; compare
        # the single-packet fixture exactly, and packet/output counts for repeats.
        assert decoded['audio_pcm_bytes']==len(source_audio)*naudio
        if naudio==1:assert decoded['audio_pcm_sha256']==sha(source_audio)
        return dict(file=path.name,bytes=len(m.output),sha256=sha(m.output),decoded=decoded)
    def fresh(cache=128):
        m=NativeMachine(image);track,mem=m.setup_index();assert open_mux(m,mem,cache)==0
        return m,track,mem
    def fill(m,track,nvideo,naudio):
        for i in range(nvideo):assert sample(m,track,video,True,i)==0
        for i in range(naudio):assert sample(m,track,audio,False,i)==0

    m,track,mem=fresh();fill(m,track,1,1);assert close_mux(m,mem,128)==0
    cases.append(dict(name='native_single',status=0,**save(m,'native-output',1,1),state=snapshot(m)))
    baseline=bytes(m.output)
    m,track,mem=fresh(2)
    for segment,nvideo,naudio in [(1,3,4),(2,2,3)]:
        if segment==2:
            assert m.get(MEMOBJ+0x38)==0
            m.output=bytearray();m.position=0;m.writes=[]
            m.uc.mem_write(stock.MOVIE,bytes(0x1000));track=m.movie();assert open_mux(m,mem,2)==0
        start=len(m.added);fill(m,track,nvideo,naudio)
        for t in (0,1):assert m.call(0xA0411048,stock.INDEX,t)==0
        readback=read_back(m,start)
        assert close_mux(m,mem,2)==0
        cases.append(dict(name='native_segment_'+str(segment),status=0,same_memidx_object=hex(mem),
            **save(m,'native-segment-'+str(segment),nvideo,naudio),readback=readback,state=snapshot(m)))
    # Preserve the real counterexample: init alone does not reset a movie epoch.
    m,track,mem=fresh(2);fill(m,track,3,4);assert close_mux(m,mem,2)==0
    prior_counts=[m.get(track+0x10),m.get(track+0x90+0x10)]
    m.output=bytearray();m.position=0;m.writes=[];track=m.movie()
    counts_after_init=[m.get(track+0x10),m.get(track+0x90+0x10)]
    assert counts_after_init==prior_counts and prior_counts==[3,4]
    assert open_mux(m,mem,2)==0
    start=len(m.added);fill(m,track,2,3)
    for t in (0,1):assert m.call(0xA0411048,stock.INDEX,t)==0
    audio_offsets=[e['data_hex'] for e in m.added[start:] if e['track']==1 and e['kind']==9]
    assert m.call(0xA0401AE4,m.get(stock.INDEX+0x68),1,1,0,0,4,stock.RESULT)==0
    stale_offset=bytes(m.uc.mem_read(stock.RESULT,4)).hex()
    assert stale_offset!=audio_offsets[0]
    (out/'no-movie-reset-media.bin').write_bytes(m.output)
    (out/'no-movie-reset-index.bin').write_bytes(m.uc.mem_read(stock.INDEX,0x138))
    try:close_mux(m,mem,2)
    except RuntimeError as error:close_error=str(error)
    else:raise AssertionError('expected stock assertion after stale epoch counts')
    cases.append(dict(name='negative_reinit_without_fresh_movie',sample_counts_before=prior_counts,
        sample_counts_after_track_init=counts_after_init,new_added=m.added[start:],
        expected_first_audio_offset=audio_offsets[0],actual_first_audio_index_read=stale_offset,
        close_error=close_error,logs=m.logs,partial_media='no-movie-reset-media.bin',
        index_snapshot='no-movie-reset-index.bin',
        boundary='original track init is not a reset; original camera reopen/reset lifecycle remains unverified'))
    # Close trims audio whose final packet extends beyond the video end.
    m,track,mem=fresh(2);fill(m,track,3,5);assert close_mux(m,mem,2)==0
    cases.append(dict(name='native_close_audio_trim',submitted_audio=5,saved_audio=4,
        **save(m,'native-trim',3,4),state=snapshot(m)))

    for kind in ('byte','block'):
        m=NativeMachine(image);track,mem=m.setup_index()
        if kind=='byte':m.pool_allocate_fail_at=0
        else:m.block_allocate_fail_at=0
        status=open_mux(m,mem,2);assert status!=0
        failed=snapshot(m);assert m.get(MEMOBJ+0x38)==0
        m.pool_allocate_fail_at=None;m.block_allocate_fail_at=None
        m.output=bytearray();m.position=0;m.writes=[];m.uc.mem_write(stock.MOVIE,bytes(0x1000));track=m.movie()
        assert open_mux(m,mem,2)==0;fill(m,track,1,1);assert close_mux(m,mem,2)==0
        cases.append(dict(name=kind+'_allocation_failure_then_new_open',failure_status=status,failed=failed,
            recovery='clear injected allocator fault and perform a new open',**save(m,'reopen-'+kind,1,1)))
    m,track,mem=fresh();m.short_write_at=len(m.writes)
    status=sample(m,track,video,True);assert status!=0
    failed=snapshot(m);assert failed['fifo_read_cursor']==0
    (out/'short-payload.bin').write_bytes(m.output)
    cases.append(dict(name='payload_short_write',status=status,failed=failed,writes=m.writes,
        boundary='partial payload retained; do not replay this frame into the same output'))

    m,track,mem=fresh(1);m.lock_failure=MEMOBJ+4
    status=sample(m,track,video,True);assert status==-1
    failed=snapshot(m);assert failed['fifo_read_cursor']==1
    m.lock_failure=None
    assert sample(m,track,audio,False)==0
    for t in (0,1):assert m.call(0xA0411048,stock.INDEX,t)==0
    assert close_mux(m,mem,1)==0
    cases.append(dict(name='real_commit_memidx_lock_failure_recovery',failure_status=status,failed=failed,
        recovery='clear transient MemIdx lock failure; flush retained cache and close without replaying consumed frame',
        identical_to_baseline=bytes(m.output)==baseline,**save(m,'commit-recovered',1,1),logs=m.logs))
    for kind in ('moov_short_write','tail_seek_failure'):
        m,track,mem=fresh();fill(m,track,1,1)
        if kind=='moov_short_write':m.short_write_at=len(m.writes)
        else:m.seek_fail_at=m.seek_count
        status=close_mux(m,mem,128);assert status!=0
        failed=snapshot(m);assert m.get(MEMOBJ+0x38)==0 and failed['index_zeroed']
        path=out/(kind+'.bin');path.write_bytes(m.output)
        m.short_write_at=None;m.seek_fail_at=None
        m.output=bytearray();m.position=0;m.writes=[];m.uc.mem_write(stock.MOVIE,bytes(0x1000));track=m.movie()
        assert open_mux(m,mem,128)==0;fill(m,track,1,1);assert close_mux(m,mem,128)==0
        cases.append(dict(name=kind,failure_status=status,failed=failed,partial_file=path.name,
            recovery='abandon partial output and open a new segment; index was deleted so do not retry close',
            **save(m,'reopen-'+kind,1,1)))
    roots={0xA0402610,0xA04032FC,0xA0402750,0xA0402884,0xA0402ED8,0xA040F710,0xA0411E88,
        0xA04111AC,0xA0411048,0xA040FC04,0xA0401AE4,0xA0435A18,0xA0436004,0xA0433AF0,
        0xA042D0F8,0xA043173C,0xA03E3C48,0xA03E4D1C,0xA03EAF94}
    functions=json.loads((stock.SRC.parent/'functions.json').read_text())
    pins=[]
    for f in functions:
        if int(f['entry'],16) not in roots:continue
        chunks=[]
        for extent in f['body_ranges']:
            lo,hi=[int(x,16) for x in extent.split('-')]
            chunks.append(image[lo-0xA0100000:hi-0xA0100000+1])
        source_path=stock.SRC.parent/f['decompiled_file']
        pins.append(dict(entry=f['entry'],body_ranges=f['body_ranges'],arm_sha256=sha(b''.join(chunks)),
            decompiled_path=str(source_path.relative_to(ROOT)),decompiled_sha256=sha(source_path.read_bytes())))
    assert len(pins)==len(roots)
    report=dict(schema=1,offline_only=True,firmware=dict(path=str(stock.life.arm.IMAGE.relative_to(ROOT)),sha256=sha(image)),
        function_pins=pins,sample_source=source,fixture='Repeated archived IDR and AAC packets with synthetic monotonic PTS; not continuous raw camera capture',
        original_arm=['MemIdx Create/Open/Write/Read/Close','IsoIdx Create/Add/Commit/Flush/Delete','AmpIndexCache_Read',
            'MP4 Open/ProcessVideo/ProcessAudio/Close including MOOV serializer and mdat header patch'],
        explicit_models=['positional RAM file Write/Read/Seek/Tell/Length/Sync/Func','allocator/mutex/RTC OS boundaries',
            'constructed movie/FIFO/registry RAM including Amba metadata version 2.0 and a fresh zeroed movie structure per new segment'],
        source_decode=dict(video_frame_md5=source_video_md5,audio_pcm_bytes=len(source_audio),audio_pcm_sha256=sha(source_audio)),
        cases=cases,case_count=len(cases),status='pass',
        limits=['No physical SD/CFS, power loss, DMA/cache coherence, real FIFO producer, camera trigger or microphone tested',
            'No one-minute retention, unique P/B-frame timeline, long-run memory pressure, or live firmware injection proved',
            'Transient modeled RAM-index mutex recovery is not SD corruption or storage crash recovery'])
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status='pass',cases=len(cases),output=str(out),report=str(out/'audit.json'))))

if __name__=='__main__':main()
