#!/usr/bin/env python3
"""Reproduce audio PTS production from pinned RTOS instructions, host-only.

Run: .venv-reverse/bin/python scripts/audit_prerecord_audio_pts.py
Requires capstone and unicorn; no camera access, code patches, or helper stubs.
"""
import argparse
import hashlib
import json
from pathlib import Path

import capstone
from unicorn import UC_ARCH_ARM, UC_MODE_ARM, Uc
from unicorn.arm_const import (
    UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_R0, UC_ARM_REG_R1,
    UC_ARM_REG_R2, UC_ARM_REG_R4, UC_ARM_REG_SP,
)

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE = Path('artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin')
EXPORT = Path('artifacts/device/2026-11-09-linux/rtos-analysis/full')
DIGEST = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
U64 = (1 << 64) - 1
SP = 0x1001F000
HANDLE, STATE, CONFIG = 0x10000000, 0x10001000, 0x10002000


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(m, addr, n=4):
    return int.from_bytes(m.mem_read(addr, n), 'little')


def write(m, addr, val, n=4):
    m.mem_write(addr, (val % (1 << (8*n))).to_bytes(n, 'little'))


def machine(image):
    m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    m.mem_map(BASE, (len(image)+4095) & ~4095)
    m.mem_write(BASE, image)
    m.mem_map(0x10000000, 0x20000)
    m.mem_map(0xA1445000, 0x1000)
    m.reg_write(UC_ARM_REG_SP, SP)
    m.reg_write(UC_ARM_REG_LR, 0x10010000)
    return m


def run(m, entry, stop):
    m.emu_start(entry, stop, count=1000000)
    assert m.reg_read(UC_ARM_REG_PC) == stop, 'Did not reach declared stop'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', type=Path, default=ROOT/'artifacts/device/2026-11-10-prerecord/audio-producer-audit.json')
    args = p.parse_args()
    image = (ROOT/IMAGE).read_bytes()
    assert sha(image) == DIGEST, 'Wrong firmware image'
    functions = {x['entry']: x for x in json.loads((ROOT/EXPORT/'functions.json').read_text())}
    sources = []
    for address in [0xA045DA98, 0xA0290B60, 0xA029016C, 0xA0295800, 0xA045E7DC, 0xA045ECD0, 0xA02902B4, 0xA0506F38]:
        f = functions[hex(address)]
        body = b''
        for interval in f['body_ranges']:
            lo, hi = [int(s, 16) for s in interval.split('-')]
            body += image[lo-BASE:hi-BASE+1]
        path = EXPORT/f['decompiled_file']
        sources.append({'entry':hex(address), 'body_ranges_inclusive':f['body_ranges'], 'body_sha256':sha(body), 'pseudocode_path':str(path), 'pseudocode_sha256':sha((ROOT/path).read_bytes())})

    # Audit the actual caller-built setup; entry skips the mutex/state gate.
    m = machine(image)
    ctx, obj = 0x10003000, 0x10004000
    m.reg_write(UC_ARM_REG_R4, ctx)
    write(m, ctx+0xC, obj)
    write(m, obj+4, HANDLE)
    for off, val, n in [(0x4C,0x10,1),(0x5C,2,4),(0x60,48000,4),(0x64,16,2),(0x66,2,2)]:
        write(m, ctx+off, val, n)
    run(m, 0xA045DAF0, 0xA045DB5C)
    setup = m.reg_read(UC_ARM_REG_R1)
    assert setup == SP+0xC
    assert read(m, setup+0x10) == 90000
    assert read(m, setup+4) == 48000
    assert read(m, setup+0x1C) == 0xA045D690
    results = [{'name':'caller_setup_prefix', 'entry':'0xa045daf0','stop_before':'0xa045db5c','pts_clock':read(m,setup+0x10),'denominator':read(m,setup+4),'write_pointer_callback':hex(read(m,setup+0x1C)), 'passed':True}]

    # Setup writes/reset are run only through the nonzero-clock prefix.
    m = machine(image)
    task, graph, input_buf, output_buf = [0x10000000+x for x in (0x3000,0x4000,0x5000,0x6000)]
    write(m, HANDLE+0x188, STATE)
    write(m, HANDLE+0x180, task)
    write(m, task+8, graph)
    write(m, graph+0x5C, input_buf)
    write(m, graph+0x60, output_buf)
    write(m, CONFIG+4, 48000)
    write(m, CONFIG+0x10, 90000)
    write(m, CONFIG+0x1C, 0xA045D690)
    write(m, STATE+0x1C, 999)
    write(m, STATE+0x20, 123456)
    m.reg_write(UC_ARM_REG_R0, HANDLE)
    m.reg_write(UC_ARM_REG_R1, CONFIG)
    run(m, 0xA0290B60, 0xA0290BF8)
    assert [read(m,STATE+x) for x in (0x1C,0x20,0x24,0x2C,0x44)] == [0,0,90000,48000,0xA045D690]
    results.append({'name':'setup_reset_prefix','entry':'0xa0290b60','stop_before':'0xa0290bf8','frame_count_before':123456,'frame_count_after':0,'payload_size_after':0,'pts_clock':90000,'denominator':48000,'passed':True})

    # Original ARM -> Thumb divide helper -> original ARM; stops before RTOS dispatch.
    cases = [(n,1024,90000,48000,0) for n in (0,1,2,3,1000000,0xFFFFFFFE,0xFFFFFFFF)]
    cases += [(n,1024,90000,44100,0) for n in (1,2,3,0xFFFFFFFE)]
    cases += [(23,2048,90000,48000,1),(0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,48000,0)]
    for count,samples,clock,denom,eos in cases:
        m = machine(image)
        write(m, HANDLE+0x188, STATE)
        for off,val in [(0x10,samples),(0x20,count),(0x24,clock),(0x2C,denom),(0x1C,1717),(0x3C,0x10008000)]:
            write(m, STATE+off, val)
        m.reg_write(UC_ARM_REG_R0,HANDLE)
        m.reg_write(UC_ARM_REG_R1,eos)
        run(m, 0xA029016C, 0xA02901D8)
        event = m.reg_read(UC_ARM_REG_R2)
        expected = ((count*samples*clock)&U64)//denom
        pts = read(m,event+8,8)
        next_count = read(m,STATE+0x20)
        assert pts == expected
        assert next_count == ((count+1)&0xFFFFFFFF)
        assert read(m,event) == HANDLE
        assert read(m,event+0x10) == eos
        assert read(m,event+0x14) == 1717
        assert read(m,event+0x18) == 0x10008000
        assert m.reg_read(UC_ARM_REG_R0) == HANDLE and m.reg_read(UC_ARM_REG_R1) == 0
        results.append({'name':'audio_pts_event_prefix','entry':'0xa029016c','stop_before':'0xa02901d8','count':count,'samples_per_frame':samples,'clock':clock,'denominator':denom,'eos':eos,'pts':pts,'next_count':next_count,'passed':True})

    # Retain exact instructions on timestamp construction and descriptor handoff.
    decoder = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    windows = []
    for lo,hi in [(0xA029018C,0xA02901DC),(0xA045EA38,0xA045EA50),(0xA045DAFC,0xA045DB24)]:
        windows.append({'start':hex(lo),'stop_exclusive':hex(hi),'sha256':sha(image[lo-BASE:hi-BASE]),'instructions':[{'address':hex(i.address),'bytes':bytes(i.bytes).hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in decoder.disasm(image[lo-BASE:hi-BASE],lo)]})
    descriptor_window = windows[1]['instructions']
    assert [(i['mnemonic'],i['operands']) for i in descriptor_window] == [('ldrd','r0, r1, [r4, #8]'),('ldr','sl, [r4, #0x14]'),('ldr','lr, [r4, #0x18]'),('strd','r0, r1, [sp, #0x28]'),('str','sl, [sp, #0x38]'),('str','lr, [sp, #0x34]')]
    report = {'image_path':str(IMAGE),'image_sha256':DIGEST,'scope':'Offline instruction-prefix execution against synthetic RAM. No camera, RTOS task, codec, dispatcher, or FIFO execution. No instruction patches or helper stubs.','formula':'floor(low64(u32(frame_count) * u32(samples_per_frame) * u32(pts_clock)) / u32(denominator))','event_layout':{'0x00':'encoder handle','0x08':'PTS u64','0x10':'EOS u32','0x14':'payload size u32','0x18':'payload pointer u32'},'sources':sources,'instruction_windows':windows,'test_count':len(results),'results':results,'limitations':['Denominator name/sample-rate interpretation is inferred; test inputs do not prove camera live configuration.','Caller uses PTS clock 90000 and setup resets frame counter; this is not a proven shared capture epoch with video.','Ordinary audio mux scheduling can use sample counts instead of raw descriptor PTS.','Count wraps at 2^32; extreme overflow test is synthetic, not a supported camera configuration.','Prefix stops deliberately omit RTOS dispatch, FIFO writes, and complete encoder setup.']}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'output':str(args.output),'passed':len(results),'failed':0,'image_sha256':DIGEST}))

if __name__ == '__main__':
    main()
