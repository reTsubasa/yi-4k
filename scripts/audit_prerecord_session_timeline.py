#!/usr/bin/env python3
"""Offline full stock ResetMovie -> real FIFO Peek -> ConvertPTS timeline audit.

No MP4 open/close, device access, capture-clock claim, or shared SDK mutation.
Existing FIFO harness models external RTOS services; actual timeline, FIFO,
memcpy and math instructions execute from the pinned 1.10.7 image.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from unicorn.arm_const import UC_ARM_REG_PC, UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R5, UC_ARM_REG_SP

ROOT = Path(__file__).resolve().parents[1]
HARNESS = ROOT/'scripts/prerecord-fifo-lifecycle.py'
SPEC = importlib.util.spec_from_file_location('timeline_fifo_harness', HARNESS)
life = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(life)
OUT = ROOT/'artifacts/device/2026-11-11-prerecord-session-timeline'
MOVIE, AUDIO_FIFO, AUDIO_QUEUE, ORIGIN = 0x10000000, 0x1000a000, 0x1000b000, 0x123456789
GLOBAL = 0xa13c1758
MASK = (1 << 64)-1

def sha(data):
    return hashlib.sha256(data).hexdigest()

class Machine(life.Machine):
    def __init__(self, image):
        super().__init__(image)
        for address, size in [(0xa13c1000, 4096), (0xa1796000, 8192), (0xa1965000, 4096)]:
            self.uc.mem_map(address, size)
        self.put(0xa17962e8, 1)  # synthetic core0 context for original memcpy wrapper
        self.logs, self.calls, self.audio_fifo_reads, self.audio_descriptor_reads = [], [], [], []
        self.watch = {0xa01f3124, 0xa01f705c, 0xa0451960, 0xa01f6be8,
                      0xa01f69b0, 0xa01f721c, 0xa03e5b5c, 0xa04404d8, 0xa01f68b8}
        self.uc.hook_add(UC_HOOK_MEM_READ, self.audio_read, begin=AUDIO_FIFO, end=AUDIO_FIFO+0xff)
        self.uc.hook_add(UC_HOOK_MEM_READ, self.audio_descriptor_read, begin=AUDIO_QUEUE, end=AUDIO_QUEUE+0xff)

    def hook(self, uc, address, size, user):
        if hasattr(self, 'watch') and address in self.watch:
            self.calls.append(dict(entry=hex(address), r0=hex(uc.reg_read(UC_ARM_REG_R0)),
                                   r1=hex(uc.reg_read(UC_ARM_REG_R1))))
        if hasattr(self, 'logs') and address == 0xa02a70ec:
            self.logs.append(dict(format_pointer=hex(uc.reg_read(UC_ARM_REG_R0))))
        super().hook(uc, address, size, user)

    def audio_read(self, uc, access, address, size, value, user):
        self.audio_fifo_reads.append(dict(address=hex(address), bytes=size))

    def audio_descriptor_read(self, uc, access, address, size, value, user):
        self.audio_descriptor_reads.append(dict(address=hex(address), bytes=size))

def setup(image, video_dts, audio_dts, preset=0, empty=False, audio_noise=0x1122334455667788):
    m = Machine(image)
    m.existing(5, 5 if empty else 9, 8)
    m.put(MOVIE, 1, 1)
    m.put(MOVIE+0x6f4, 2, 1)
    m.put(GLOBAL, preset, 8)
    m.uc.mem_write(AUDIO_FIFO, bytes((i*19+7)&255 for i in range(0x100)))
    # Separate structurally populated audio handler/descriptor. This audit does
    # not call an audio FIFO API; the access hooks must show neither is read.
    for off, value, size in [(0,0,4), (4,AUDIO_FIFO,4), (8,life.STREAM+1,4),
        (12,1,4), (16,life.BASE_FIFO,4), (0x80,AUDIO_QUEUE,4), (0x84,256,4),
        (0x88,8,4), (0x90,5,8), (0x98,9,8)]:
        m.put(AUDIO_FIFO+off,value,size)
    m.uc.mem_write(AUDIO_QUEUE,bytes(256))
    m.put(AUDIO_QUEUE+5*32+8, audio_noise, 8)
    m.put(AUDIO_QUEUE+5*32+0x10,8,1)
    m.put(AUDIO_QUEUE+5*32+0x11,1,1)
    for index, (kind, dts) in enumerate(((1, video_dts), (2, audio_dts))):
        t = MOVIE+0x78+index*0x90
        for off, value, size in [(4, 90000, 4), (0xc, 3000 if kind==1 else 1920, 4),
            (0x10, 123+index, 4), (0x14, 456+index, 4), (0x18, 0, 8),
            (0x20, MASK, 8), (0x28, dts, 8), (0x30, life.VIRTUAL if index==0 else AUDIO_FIFO, 4),
            (0x40, 90000, 4), (0x48, 77+index, 4), (0x50, 0, 8), (0x58, ORIGIN, 8),
            (0x60, 333, 8), (0x68, 0, 8), (0x78, 1, 2), (0x7c, 1 if index==0 else 0, 1),
            (0x7d, 0, 1), (0x7e, 1, 1), (0x7f, 1, 1), (0x89, kind, 1)]:
            m.put(t+off, value, size)
    desc = life.QUEUE+5*32
    m.uc.mem_write(desc, bytes(32))
    m.put(desc+8, ORIGIN+video_dts, 8)
    m.put(desc+0x10, 1, 1)
    m.put(desc+0x11, 1, 1)
    m.put(desc+0x14, 0x20000000)
    m.put(desc+0x18, 4096)
    return m, desc

def execute(image, name, video_dts, audio_dts, preset=0, empty=False,
            audio_noise=0x1122334455667788):
    assert video_dts%3000 == 0
    m, descriptor = setup(image, video_dts, audio_dts, preset, empty, audio_noise)
    assert m.run(0xa04404d8, MOVIE) == 0  # restore actual DTS from pre-limit snapshot
    assert m.run(0xa01f68b8, MOVIE) == 0  # caller's real sample-count reset
    tracks = [MOVIE+0x78+i*0x90 for i in range(2)]
    assert [m.get(t+0x20,8) for t in tracks] == [video_dts, audio_dts]
    assert all(m.get(t+0x10)==0 and m.get(t+0x14)==0 for t in tracks)
    before = dict(cursor=m.get(life.VIRTUAL+0x90,8), write=m.get(life.VIRTUAL+0x98,8),
        fifo_bytes=bytes(m.uc.mem_read(life.VIRTUAL,0xd0)),
        queue_bytes=bytes(m.uc.mem_read(life.QUEUE,256)),
        audio_fifo_bytes=bytes(m.uc.mem_read(AUDIO_FIFO,256)),
        audio_queue_bytes=bytes(m.uc.mem_read(AUDIO_QUEUE,256)),
        movie_bytes=bytes(m.uc.mem_read(MOVIE,0x708)))
    status = m.run(0xa01f3124, MOVIE)
    assert m.get(life.VIRTUAL+0x90,8) == before['cursor']
    assert m.get(life.VIRTUAL+0x98,8) == before['write']
    assert bytes(m.uc.mem_read(life.VIRTUAL,0xd0)) == before['fifo_bytes']
    assert bytes(m.uc.mem_read(life.QUEUE,256)) == before['queue_bytes']
    assert bytes(m.uc.mem_read(AUDIO_FIFO,256)) == before['audio_fifo_bytes']
    assert bytes(m.uc.mem_read(AUDIO_QUEUE,256)) == before['audio_queue_bytes']
    assert not m.audio_fifo_reads and not m.audio_descriptor_reads
    assert not any(m.locks.values())
    observed = [m.get(t+0x20,8) for t in tracks]
    peeks = [row for row in m.calls if row['entry']=='0xa0451960']
    assert len(peeks)==1 and peeks[0]['r0']==hex(life.VIRTUAL)
    if empty:
        assert status == -1 and observed == [video_dts,audio_dts]
        assert bytes(m.uc.mem_read(MOVIE,0x708)) == before['movie_bytes']
        assert m.get(GLOBAL,8) == preset
        assert len(m.logs)==2  # inner AdjustDTS diagnostic, outer ResetMovie diagnostic
        selected, first_converted = None, None
    else:
        assert status == 0 and not m.logs
        shortest = min(video_dts,audio_dts)
        selected = min(preset, shortest) if preset else shortest
        assert m.get(GLOBAL,8) == (preset if preset else shortest)
        assert observed == [video_dts-selected,audio_dts-selected]
        assert observed[1]-observed[0] == audio_dts-video_dts
        for t,dts in zip(tracks,observed):
            assert all(m.get(t+off,8)==dts for off in (0x18,0x20,0x28))
        video, audio = tracks
        assert m.get(video+0x50,8)==observed[0]
        assert all(m.get(video+off,8)==0 for off in (0x58,0x60,0x68))
        assert m.get(video+0x48)==0 and m.get(video+0x7e,1)==0
        assert m.get(audio+0x58,8)==ORIGIN and m.get(audio+0x48)==78
        # The exact retained descriptor is selected as the next video origin.
        m.put(life.arm.STACK+0x24,descriptor)
        m.uc.reg_write(UC_ARM_REG_R5,video)
        life.arm.run(m.uc,0xa042d378,0xa042d398)
        assert m.get(video+0x58,8)==ORIGIN+video_dts
        assert m.run(0xa03e5b5c,video,descriptor)==0
        first_converted = m.get(video+0x60,8)
        assert first_converted == 0 and not m.logs
    return dict(name=name, input_dts=[video_dts,audio_dts], preset_global=preset,
        source_video_pts=ORIGIN+video_dts, audio_descriptor_noise=audio_noise,
        empty_video_fifo=empty, reset_status=status, selected_common_subtrahend=selected,
        output_dts=observed, delta_before=audio_dts-video_dts, delta_after=observed[1]-observed[0],
        global_after=m.get(GLOBAL,8), retained_descriptor=hex(descriptor),
        real_fifo_peeks=peeks, fifo_cursor_and_queue_preserved=True,
        audio_fifo_reads=m.audio_fifo_reads, audio_descriptor_reads=m.audio_descriptor_reads,
        first_video_converted_pts=first_converted,
        real_function_calls=m.calls, diagnostics=m.logs, external_models=m.events, passed=True)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=OUT,
        help='output directory or JSON pathname')
    args = parser.parse_args()
    image = life.arm.IMAGE.read_bytes()
    assert sha(image)==life.arm.DIGEST
    cases = [
        execute(image,'audio_trails_by_one_synthetic_audio_period',900000,901920),
        execute(image,'audio_leads_video',903000,900000),
        execute(image,'equal_track_boundaries',900000,900000),
        execute(image,'u64_dts_with_low_word_carry',4294968000,4294969920),
        execute(image,'existing_global_smaller_than_shortest',900000,901920,preset=600000),
        execute(image,'existing_global_larger_than_shortest',900000,901920,preset=1200000),
        execute(image,'audio_raw_pts_noise_irrelevant_to_this_reset',900000,901920,
                audio_noise=0xffffffffffffffff),
        execute(image,'empty_video_fifo_is_error_not_zero_origin',900000,901920,empty=True),
    ]
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    expected = {
        0xa01f59d8: ('bl','#0xa01f68b8'),
        0xa01f59f0: ('strd','r2, r3, [r1]'),
        0xa01f59f4: ('bl','#0xa01f3124'),
        0xa01f3130: ('bl','#0xa01f705c'),
        0xa01f70e8: ('bl','#0xa0451960'),
        0xa01f70fc: ('bl','#0xa01f6be8'),
        0xa01f3168: ('bl','#0xa01f69b0'),
        0xa01f31b4: ('strdeq','r2, r3, [fp]'),
        0xa01f3220: ('subs','r0, r0, r6'),
        0xa01f3224: ('sbc','r1, r1, r7'),
        0xa01f3260: ('bl','#0xa01f721c'),
    }
    for address,pair in expected.items():
        ins=next(md.disasm(image[address-life.arm.BASE:address-life.arm.BASE+4],address))
        assert (ins.mnemonic,ins.op_str)==pair
    functions={int(f['entry'],16):f for f in json.loads((life.arm.EXPORT/'functions.json').read_text())}
    sources,assembly=[],[]
    for address in (0xa01f3124,0xa01f705c,0xa0451960,0xa01f6be8,0xa01f69b0,
                    0xa01f721c,0xa04404d8,0xa01f68b8,0xa03e5b5c,0xa029c680):
        function=functions[address]
        body=b''
        assembly.append('\nFUNCTION '+hex(address)+'\n')
        for span in function['body_ranges']:
            low,high=(int(v,16) for v in span.split('-'))
            chunk=image[low-life.arm.BASE:high-life.arm.BASE+1]
            body+=chunk
            for ins in md.disasm(chunk,low):
                assembly.append(f'{ins.address:08x} {ins.mnemonic:8} {ins.op_str}\n')
        source=life.arm.EXPORT/function['decompiled_file']
        sources.append(dict(entry=hex(address), body_ranges_inclusive=function['body_ranges'],
            raw_sha256=sha(body), pseudocode=str(source.relative_to(ROOT)),
            pseudocode_sha256=sha(source.read_bytes())))
    report=dict(scope='original complete RestoreDTS/count reset/ResetMovie and real Peek/ConvertPTS; synthetic RAM',
        image=dict(path=str(life.arm.IMAGE.relative_to(ROOT)),sha256=life.arm.DIGEST),
        harness=dict(path=str(HARNESS.relative_to(ROOT)),sha256=sha(HARNESS.read_bytes())),
        sources=sources,instruction_pins=len(expected),cases=cases,
        stub_scope='Inherited FIFO harness RTOS mutex, allocator, queue, diagnostics, callback models; only mutex and error diagnostics reached here. Original memcpy, division, FIFO Peek and PTS helpers are not stubbed.',
        reached_model_kinds=sorted({e['kind'] for c in cases for e in c['external_models']}),
        proven=['Successful unadjusted synthetic video boundary uses one common DTS subtrahend for both tracks',
            'Post-AdjustDTS A/V mux-state difference retained by ResetMovie',
            'Video FIFO cursor/descriptor retained through the complete reset',
            'First retained video descriptor becomes new origin and converts to zero',
            'This reset does not read an audio raw descriptor PTS'],
        not_proven=['Common ADC/sensor hardware epoch',
            'Arbitrary AdjustDTS correction paths, reordering or invalid configuration',
            'Real scheduler/cache/DMA/payload lifetime or cross-file playable continuity',
            'Actual file/index Open/Close and producer continuity',
            'Camera-side one-minute prerecord'],
        target_access=False,target_written=False)
    output=args.output if args.output.suffix.lower()=='.json' else args.output/'audit.json'
    output.parent.mkdir(parents=True,exist_ok=True)
    output.write_text(json.dumps(report,indent=2)+'\n')
    output.with_suffix('.asm').write_text(''.join(assembly))
    print(json.dumps(dict(output=str(output),cases=len(cases),instruction_pins=len(expected),target_access=False)))

if __name__=='__main__':
    main()
