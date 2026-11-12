#!/usr/bin/env python3
"""Execute pinned stock MP4 sample writers against owned RAM; offline only.

Stream write/tell/length and index Add/Commit are explicit byte-capturing models.
The FIFO, track init/advance, PTS conversion, H264 parser/sample serializer,
raw audio writer and codec-config builder execute original firmware bytes.
Archived camera MP4 supplies already-muxed samples, never claimed FIFO evidence.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
import re
import struct
import subprocess
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("owned_mux_life", ROOT / "scripts/prerecord-fifo-lifecycle.py")
life = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(life)
OUTDIR = ROOT / "artifacts/device/2026-11-11-prerecord-owned-mux-writer"
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
MOVIE, CONFIG, INDEX = 0x10000000, 0x10001000, 0x10006000
PARAMS, STREAM, VTABLE, RESULT = MOVIE + 0x350, 0x1000C000, 0x1000C100, 0x1000D000
WRITE, TELL, LENGTH = 0x10011200, 0x10011400, 0x10011600
OWNED, ORIGINAL = 0x20000000, 0x20200000
CAPACITY = 0x100000
SAMPLE_MP4 = ROOT / "artifacts/device/2026-11-11-record-probe-01/session-media/YDXJ0161.MP4"
FFMPEG = ROOT / ".tools/ffmpeg-host/ffmpeg"
FFPROBE = ROOT / ".tools/ffmpeg-host/ffprobe"


def sha(b):
    return hashlib.sha256(b).hexdigest()


def nals(annexb):
    starts = list(re.finditer(b"\x00\x00\x00\x01|\x00\x00\x01", annexb))
    return [annexb[m.end():starts[i+1].start() if i+1 < len(starts) else len(annexb)]
        for i,m in enumerate(starts)]


def load_archived_samples():
    raw = SAMPLE_MP4.read_bytes()
    annexb = subprocess.check_output([str(FFMPEG), "-v", "error", "-i", str(SAMPLE_MP4),
        "-map", "0:v:0", "-frames:v", "1", "-c:v", "copy", "-bsf:v", "h264_mp4toannexb", "-f", "h264", "pipe:1"])
    video_nals = nals(annexb)
    video = b"".join(b"\0\0\0\1" + nal for nal in video_nals)
    probe = json.loads(subprocess.check_output([str(FFPROBE), "-v", "error", "-select_streams", "a:0",
        "-read_intervals", "%+0.1", "-show_packets", "-show_streams", "-show_data", "-of", "json", str(SAMPLE_MP4)]))
    packet = probe["packets"][0]
    position, length = int(packet["pos"]), int(packet["size"])
    audio = raw[position:position+length]
    stream = probe["streams"][0]
    return video, video_nals, audio, dict(path=str(SAMPLE_MP4.relative_to(ROOT)),
        sha256=sha(raw), source="archived ordinary recording MP4, not raw encoder/FIFO observation",
        video_extraction="ffmpeg stream copy first packet h264_mp4toannexb; each start prefix normalized to 4 bytes",
        source_annexb_sha256=sha(annexb), normalized_annexb_sha256=sha(video),
        nal_types=[n[0]&31 for n in video_nals], nal_sizes=[len(n) for n in video_nals],
        audio_packet_position=position, audio_packet_bytes=length, audio_packet_sha256=sha(audio),
        audio_codec=stream["codec_name"], audio_sample_rate=stream["sample_rate"], audio_channels=stream["channels"],
        audio_extradata=stream.get("extradata"), ffmpeg_version=subprocess.check_output([str(FFMPEG),"-version"],text=True).splitlines()[0])


class WriterMachine(life.Machine):
    def __init__(self, image):
        super().__init__(image)
        self.uc.mem_map(OWNED, 0x400000)
        # Real memcpy wrapper reads the per-core RTOS context through MPIDR;
        # use the same constructed core0 state as the existing AU audit.
        self.uc.mem_map(0xA1796000,0x2000)
        self.uc.mem_map(0xA1965000,0x1000)
        self.put(0xA17962E8,1)
        self.output = bytearray()
        self.writes, self.index_events = [], []
        self.short_write_at = None
        self.index_failure_kind = None
        self.commit_failure = 0
        self.trace = []
        self.put(STREAM, VTABLE)
        self.put(VTABLE + 0x0C, WRITE)
        self.put(VTABLE + 0x14, TELL)
        self.put(VTABLE + 0x18, LENGTH)
        self.existing(0, 0, 128)
        self.put(life.BASE_FIFO + 0xB0, 1, 1)
        self.put(life.VIRTUAL + 0xC0, 0xFF)

    def hook(self, uc, address, size, user):
        args = [uc.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
        status = None
        if address == WRITE:
            assert args[0] == STREAM
            data = bytes(uc.mem_read(args[2],args[1]))
            status = args[1] - 1 if len(self.writes) == self.short_write_at else args[1]
            self.output.extend(data[:status])
            self.writes.append(dict(source_address=hex(args[2]),requested_bytes=args[1],returned_bytes=status,
                sha256=sha(data), preview_hex=data[:32].hex()))
        elif address in (TELL,LENGTH):
            assert args[0] == STREAM
            status = len(self.output)
            uc.reg_write(UC_ARM_REG_R1,0)
        elif address == 0xA0411E88:
            # Explicit index model. The sample writer itself and timestamp
            # transforms run; index storage/open/close has not been exercised.
            record = dict(track=args[1],kind=args[2],data_hex=bytes(uc.mem_read(args[3],8)).hex())
            self.index_events.append(record)
            status = -12 if args[2] == self.index_failure_kind else 0
        elif address == 0xA04111AC:
            self.index_events.append(dict(commit=True,track=args[1]))
            status = self.commit_failure
        elif address in (0xA042CE28,0xA03EFE74,0xA03E627C,0xA03EF858,0xA0440948,0xA0451C94):
            self.trace.append(hex(address))
        if status is not None:
            uc.reg_write(UC_ARM_REG_R0,status&0xFFFFFFFF)
            uc.reg_write(UC_ARM_REG_PC,uc.reg_read(UC_ARM_REG_LR))
            return
        super().hook(uc,address,size,user)

    def call(self, entry, *args):
        self.uc.reg_write(UC_ARM_REG_CPSR,0x13)
        self.uc.reg_write(UC_ARM_REG_SP,life.arm.STACK)
        self.uc.reg_write(UC_ARM_REG_LR,life.arm.RETURN)
        for r,v in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),args):
            self.uc.reg_write(r,v)
        for i,v in enumerate(args[4:]):
            self.put(life.arm.STACK + i*4,v)
        self.uc.emu_start(entry,life.arm.RETURN,count=20000000)
        assert self.uc.reg_read(UC_ARM_REG_PC) == life.arm.RETURN
        assert self.uc.reg_read(UC_ARM_REG_SP) == life.arm.STACK
        assert not any(self.locks.values())
        return life.signed(self.uc.reg_read(UC_ARM_REG_R0))

    def payload(self,data,offset=0):
        assert len(data) < CAPACITY
        self.uc.mem_write(OWNED,bytes(CAPACITY))
        self.uc.mem_write(ORIGINAL,b"\xEE"*CAPACITY)
        first = min(len(data),CAPACITY-offset)
        self.uc.mem_write(OWNED+offset,data[:first])
        self.uc.mem_write(OWNED,data[first:])
        return OWNED+offset

    def movie(self, video=True, audio=True, audio_rate=48000, channels=2):
        self.put(MOVIE,1,1)
        count = int(video)+int(audio)
        self.put(CONFIG+0xD0,count,1)
        entries=[]
        if video:
            entries.append({0:2,4:30000,8:1001,0x10:life.VIRTUAL,0x14:OWNED,0x18:OWNED+CAPACITY,
                0x1C:1920|(1080<<16),0x20:30000,0x28:1|(8<<16),0x2C:1,0x30:1})
        if audio:
            entries.append({0:0x21,4:audio_rate,8:1024,0x10:life.VIRTUAL,0x14:OWNED,0x18:OWNED+CAPACITY,
                0x1C:audio_rate,0x20:0x1000000|(16<<16)|(channels<<8),0x2C:1,0x30:2})
        for index,values in enumerate(entries):
            for off,v in values.items():
                self.put(CONFIG+index*0x34+off,v)
        assert self.call(0xA0440CD4,MOVIE,CONFIG)==0
        return MOVIE+0x78+(0 if video else 0)*0x90

    def descriptor(self,data,pointer,kind=1,pts=0x123456789):
        # Construct owned descriptor directly in a valid synthetic virtual
        # queue, not a stock encoder base. Original Peek/Remove will execute.
        self.put(life.VIRTUAL+0x90,0,8)
        self.put(life.VIRTUAL+0x98,1,8)
        self.uc.mem_write(life.QUEUE,bytes(32))
        for off,v,n in [(0,123,4),(8,pts,8),(0x10,kind,1),(0x11,1,1),(0x14,pointer,4),(0x18,len(data),4)]:
            self.put(life.QUEUE+off,v,n)


def main():
    image=life.arm.IMAGE.read_bytes()
    assert sha(image)==life.arm.DIGEST
    video, video_nals, audio, sample_source = load_archived_samples()
    cases=[]
    OUTDIR.mkdir(parents=True,exist_ok=True)

    # Lowest stock audio writer proves own RAM works and stale encoder bounds
    # fail before any stream write. Both straight and two-span paths execute.
    for wrapped in (False,True):
        m=WriterMachine(image)
        pointer=m.payload(audio,CAPACITY-7 if wrapped else 32)
        status=m.call(0xA03E627C,STREAM,len(audio),pointer,OWNED,OWNED+CAPACITY)
        assert status==0 and bytes(m.output)==audio
        cases.append(dict(name="audio_raw_owned_write_"+str(wrapped),status=status,wrapped=wrapped,
            output_sha256=sha(m.output),output_bytes=len(m.output),writes=m.writes))
    m=WriterMachine(image)
    pointer=m.payload(audio)
    status=m.call(0xA03E627C,STREAM,len(audio),pointer,ORIGINAL,ORIGINAL+CAPACITY)
    assert status==-3 and not m.writes
    cases.append(dict(name="owned_pointer_with_stock_ring_bounds_rejected",status=status,stream_writes=0))

    # H264 sample writer converts Annex B to length-prefixed MP4 media samples.
    # This uses real archived bytes, relocated to own ring; no FIFO claim.
    for wrapped in (False,True):
        m=WriterMachine(image)
        pointer=m.payload(video,CAPACITY-3 if wrapped else 32)
        status=m.call(0xA03EFE74,STREAM,len(video),pointer,OWNED,OWNED+CAPACITY,RESULT,32)
        assert status==0,("h264",wrapped,status)
        expected = struct.pack(">I",len(video_nals[-1])) + video_nals[-1]
        assert bytes(m.output)==expected
        assert len(m.output)==m.get(RESULT) and len(m.output)%32==0
        (OUTDIR / ("h264-sample-wrap.bin" if wrapped else "h264-sample.bin")).write_bytes(m.output)
        cases.append(dict(name="h264_owned_sample_writer_"+str(wrapped),status=status,wrapped=wrapped,
            input_bytes=len(video),output_bytes=len(m.output),output_sha256=sha(m.output),writes=m.writes))

    # Actual ProcessAudio / ProcessVideo consume a relocated owned descriptor
    # through the original FIFO APIs and advance stock tracks. Index storage
    # and stream methods remain explicit models rather than fake file proof.
    for is_video,data in [(True,video),(False,audio)]:
        m=WriterMachine(image)
        track=m.movie(video=True,audio=not is_video)
        if not is_video:
            track += 0x90
        pointer=m.payload(data,32)
        m.descriptor(data,pointer,1 if is_video else 8)
        if is_video:
            status=m.call(0xA042D0F8,MOVIE,track,PARAMS,INDEX,STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)
        else:
            status=m.call(0xA043173C,MOVIE,track,INDEX,STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)
        assert status==0,("Process",is_video,status)
        assert m.get(life.VIRTUAL+0x90,8)==1
        assert m.get(track+0x10)==1
        if not is_video:
            assert bytes(m.output)==audio
        cases.append(dict(name="process_"+("video" if is_video else "audio")+"_owned_descriptor",
            status=status,output_bytes=len(m.output),output_sha256=sha(m.output),writes=m.writes,
            index_models=m.index_events,trace=m.trace,read_cursor_after=m.get(life.VIRTUAL+0x90,8),
            dts_after=m.get(track+0x20,8),period=m.get(track+0xC),scale=m.get(track+4),
            sps_length=m.get(PARAMS+0xB8,2) if is_video else None,
            pps_length=m.get(PARAMS+0xBA,2) if is_video else None))

    # A successful writer return is not proof that a new segment has codec
    # configuration. Original parser accepts a slice without cached SPS/PPS.
    m=WriterMachine(image)
    track=m.movie(video=True,audio=False)
    slice_only=b"\0\0\0\1"+video_nals[-1]
    pointer=m.payload(slice_only,32)
    m.descriptor(slice_only,pointer)
    status=m.call(0xA042D0F8,MOVIE,track,PARAMS,INDEX,STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)
    assert status==0 and m.get(PARAMS+0xB8,2)==0 and m.get(PARAMS+0xBA,2)==0
    assert bytes(m.output)==struct.pack(">I",len(video_nals[-1]))+video_nals[-1]
    cases.append(dict(name="slice_only_success_without_sps_pps",status=status,
        output_bytes=len(m.output),read_cursor_after=m.get(life.VIRTUAL+0x90,8),
        sps_length=0,pps_length=0,meaning="successful sample write does not prove a decodable fresh segment"))

    m=WriterMachine(image)
    synthetic=b"\0\0\0\1\x65abcd"
    pointer=m.payload(synthetic,32)
    status=m.call(0xA03EFE74,STREAM,len(synthetic),pointer,OWNED,OWNED+CAPACITY,RESULT,32)
    assert status==0 and bytes(m.output)==struct.pack(">I",28)+b"\x65abcd"+bytes(23)
    cases.append(dict(name="synthetic_h264_padding_serializer_only",status=status,
        output_bytes=len(m.output),output_hex=m.output.hex(),writes=m.writes,
        meaning="constructed nondecodable NAL checks stock 32-byte padding, not encoded video validity"))

    # Writer errors are not transactional. Capture each original consumer's
    # descriptor lifetime, media bytes and track state at three failure points.
    for is_video,data in [(True,video),(False,audio)]:
        for failure in ("short_write","post_payload_index","commit"):
            m=WriterMachine(image)
            track=m.movie(video=True,audio=not is_video)+(0 if is_video else 0x90)
            pointer=m.payload(data,32)
            m.descriptor(data,pointer,1 if is_video else 8)
            if failure=="short_write":
                m.short_write_at=1 if is_video else 0
            elif failure=="post_payload_index":
                m.index_failure_kind=2 if is_video else 8
            else:
                m.commit_failure=-12
            args=(MOVIE,track,PARAMS,INDEX,STREAM,60000,0xFFFFFFFF,0xFFFFFFFF) if is_video else (
                MOVIE,track,INDEX,STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)
            status=m.call(0xA042D0F8 if is_video else 0xA043173C,*args)
            cursor=m.get(life.VIRTUAL+0x90,8)
            assert status!=0 and len(m.output)>0
            assert cursor==(1 if failure=="commit" else 0)
            before_retry=len(m.output)
            dts_after_failure=m.get(track+0x20,8)
            count_after_failure=m.get(track+0x10)
            retry_status=None
            if failure=="post_payload_index":
                m.index_failure_kind=None
                retry_status=m.call(0xA042D0F8 if is_video else 0xA043173C,*args)
                assert retry_status==0 and len(m.output)==before_retry*2
            cases.append(dict(name=("video" if is_video else "audio")+"_failure_"+failure,
                status=status,bytes_after_failure=before_retry,read_cursor_after_failure=cursor,
                dts_after_failure=dts_after_failure,sample_count_after_failure=count_after_failure,
                retry_status=retry_status,bytes_after_retry=len(m.output) if retry_status is not None else None,
                writes=m.writes,index_models=m.index_events))

    # Stock AAC sample-description builder derives LC ASC from the track's
    # sample rate and channels, rather than reading transport config bytes.
    for rate,channels,expected in [(48000,2,0x1190),(48000,1,0x1188),(44100,2,0x1210),(12345,2,0x7F90)]:
        m=WriterMachine(image)
        track=m.movie(video=True,audio=True,audio_rate=rate,channels=channels)+0x90
        out=0x10012000
        status=m.call(0xA0432230,out,track,INDEX,2)
        asc=m.get(out+0xB8,2)
        assert status==0 and asc==expected,(rate,channels,status,hex(asc))
        assert m.get(out+0xA4)==0x6D703461 and m.get(out+0xAC)==0x65736473
        serialized_status=m.call(0xA042FAFC,out+0x90,STREAM,track)
        assert serialized_status==0 and len(m.output)==0x66
        expected_asc=bytes.fromhex("05808005")+asc.to_bytes(2,"big")+bytes(3)
        assert expected_asc in m.output
        assert b"mp4a" in m.output and b"esds" in m.output
        (OUTDIR/("aac-stsd-"+str(rate)+"-"+str(channels)+".bin")).write_bytes(m.output)
        cases.append(dict(name="aac_stsd_"+str(rate)+"_"+str(channels),status=status,
            sample_rate=rate,channels=channels,track_sample_rate=m.get(track+0x40),
            track_channels=m.get(track+0x45,1),track_bit_depth=m.get(track+0x46,1),
            asc_hex=asc.to_bytes(2,"big").hex(),unsupported_rate=rate==12345,
            original_serializer_status=serialized_status,serialized_bytes=len(m.output),
            serialized_sha256=sha(m.output),serialized_hex=m.output.hex(),
            interpretation="unsupported rate returns success with invalid sampling-frequency index" if rate==12345 else "AAC LC AudioSpecificConfig"))

    sources={name:sha((SRC/(name+".c")).read_bytes()) for name in (
        "a03e627c","a03efe74","a03ef858","a042ce28","a042d0f8","a043173c",
        "a0429290","a042fafc","a0432188","a0432230","a0433138","a0440948","a0440cd4","a0451c94")}
    windows={hex(entry):dict(bytes=length,sha256=sha(image[entry-life.arm.BASE:entry-life.arm.BASE+length]))
        for entry,length in [(0xA03E627C,0x100),(0xA03EFE74,0x100),(0xA042D0F8,0x100),
            (0xA043173C,0x100),(0xA0432188,0xA8),(0xA0432230,0x100)]}
    assert all(v["sha256"]!=sha(b"") for v in windows.values())
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    instruction_checks=[]
    for address,mnemonic,operands in [
        (0xA03E62B8,"cmp","r2, r3"),(0xA03E62C4,"cmp","r2, ip"),
        (0xA03E62F0,"blx","r3"),(0xA03E62F4,"cmp","r0, r6"),
        (0xA0432D14,"orr","r1, r1, #0x1000"),
        (0xA0432D18,"orr","r0, r1, r0, lsl #7"),
        (0xA0432D1C,"strh","r0, [r4, #0xb8]"),
        (0xA0429498,"ldrh","r1, [r5, #0x28]"),
        (0xA04294A0,"bl","#0xa03e256c")]:
        data=image[address-life.arm.BASE:address-life.arm.BASE+4]
        instruction=next(md.disasm(data,address))
        assert (instruction.mnemonic,instruction.op_str)==(mnemonic,operands)
        instruction_checks.append(dict(address=hex(address),bytes=data.hex(),
            mnemonic=mnemonic,operands=operands,passed=True))
    result=dict(audit="prerecord_owned_mux_writer",image_sha256=life.arm.DIGEST,
        original_arm_cases=len(cases),cases=cases,sample_source=sample_source,
        decompiled_source_sha256=sources,original_arm_window_sha256=windows,
        exact_arm_instruction_checks=instruction_checks,
        explicit_models=["inherited mutex bookkeeping/log/queue models", "byte-capturing file stream Write/Tell/Length",
            "IsoIdx_Add/Commit record supplied index data and selected errors; no index object/storage"],
        device_access=False,camera_prerecord_implemented=False)
    (OUTDIR/"audit.json").write_text(json.dumps(result,indent=2)+"\n")
    print(json.dumps(dict(output=str((OUTDIR/"audit.json").relative_to(ROOT)),cases=len(cases))))


if __name__=="__main__":
    main()
