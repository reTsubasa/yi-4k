#!/usr/bin/env python3
"""Offline original ARM checks for split sync-frame retention and codec-cache reset.

No target connection, device IO, helper stubs, file muxing or simulated FIFO producer.
RAM inputs are constructed; passing does not establish real cross-file continuity.
"""
import hashlib
import json
import platform
import struct
from pathlib import Path
import capstone
import unicorn
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE = Path('artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin')
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
EXPORT = Path('artifacts/device/2026-11-09-linux/rtos-analysis/full')
OUTPUT = Path('artifacts/device/2026-11-10-prerecord/prerecord-sync-boundary-audit.json')
SP, END = 0x1001F000, 0x1001FF00


def sha(data): return hashlib.sha256(data).hexdigest()
def put(m, addr, value, size=4): m.mem_write(addr, value.to_bytes(size, 'little'))
def get(m, addr, size=4): return int.from_bytes(m.mem_read(addr, size), 'little')
def reg(m, which, value): m.reg_write(which, value)


def machine(image):
    m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    m.mem_map(BASE, (len(image) + 4095) & ~4095)
    m.mem_write(BASE, image)
    m.mem_map(0x10000000, 0x20000)
    reg(m, UC_ARM_REG_SP, SP)
    reg(m, UC_ARM_REG_LR, END)
    return m


def run(m, start, stop=END):
    m.emu_start(start, stop, count=100000)
    assert m.reg_read(UC_ARM_REG_PC) == stop


def track(m, addr, rate=90000, origin=12345, dts=12345):
    put(m, addr + 4, rate)
    put(m, addr + 0x18, origin, 8)
    put(m, addr + 0x20, dts, 8)
    put(m, addr + 0x7c, 1, 1)
    put(m, addr + 0x89, 1, 1)


def main():
    image = (ROOT / IMAGE).read_bytes()
    assert sha(image) == EXPECTED
    cases = []
    # Complete helper, including real default-track selection and Thumb u64 divide.
    # A null output stream deliberately excludes size-limit IO from these tests.
    for rate in (90000, 30000, 48000, 44100):
        for duration in (1, 1001, 60000):
            for delta in (-1, 0, 1):
                m = machine(image)
                addr, origin = 0x10000000, 0x100000123
                boundary = origin + (rate * duration + 999) // 1000
                track(m, addr, rate, origin, boundary + delta)
                for r, v in [(UC_ARM_REG_R0, 1), (UC_ARM_REG_R1, addr),
                             (UC_ARM_REG_R2, 1), (UC_ARM_REG_R3, 0)]: reg(m, r, v)
                for i, v in enumerate((0, duration, 0xffffffff, 0xffffffff)): put(m, SP+i*4, v)
                run(m, 0xA03E835C)
                result = m.reg_read(UC_ARM_REG_R0)
                assert result == (3 if delta >= 0 else 0)
                cases.append(dict(case='complete_time_limit_helper', rate=rate,
                    duration_ms=duration, origin=origin, dts=boundary+delta,
                    delta_ticks=delta, result=result, passed=True))
    # Secondary track stops at the saved default-track boundary only after the
    # default track has entered its u64-all-ones marker state.
    for secondary_type in (1, 2):
        for default_ended in (False, True):
            for delta in (-1, 0, 1):
                m = machine(image)
                addr = 0x10000000
                track(m, addr, dts=0xffffffffffffffff if default_ended else 90000)
                put(m, addr+0x28, 100000, 8)
                track(m, addr+0x90, dts=100000+delta)
                put(m, addr+0x90+0x7c, 0, 1)
                put(m, addr+0x90+0x89, secondary_type, 1)
                for r, v in [(UC_ARM_REG_R0, 1), (UC_ARM_REG_R1, addr),
                             (UC_ARM_REG_R2, 2), (UC_ARM_REG_R3, 1)]: reg(m, r, v)
                for i, v in enumerate((0, 60000, 0xffffffff, 0xffffffff)): put(m, SP+i*4, v)
                run(m, 0xA03E835C)
                result = m.reg_read(UC_ARM_REG_R0)
                assert result == (3 if default_ended and delta >= 0 else 0)
                cases.append(dict(case='secondary_track_boundary', secondary_raw_track_type=secondary_type,
                                  default_ended=default_ended,
                                  delta_ticks=delta, result=result, passed=True))
    # Gate immediately after the real peek/preflight region. Non-type-1 entries
    # go to the sample writer without asking CheckLimit. No frame type invented.
    for kind in (0, 1, 2, 3, 4, 8, 0xfe, 0xff):
        m = machine(image)
        entry = 0x10001000
        put(m, entry+0x10, kind, 1)
        reg(m, UC_ARM_REG_R1, entry)
        stop = 0xA042D3D4 if kind == 1 else 0xA042D3A4
        run(m, 0xA042D398, stop)
        cases.append(dict(case='video_sync_type_gate', raw_type=kind,
                          goes_to_limit_check=kind == 1, stop=hex(stop), passed=True))
    # Execute gate + actual CheckLimit + return-decision instructions. Stop
    # before writer or epilogue, so no FIFO or file helper is substituted.
    for rate in (90000, 30000):
        for delta in (-1, 0, 1):
            m = machine(image)
            movie, entry = 0x10000000, 0x10001000
            t = movie+0x78
            origin, duration = 0x100000123, 60000
            dts = origin + rate * 60 + delta
            track(m, t, rate, origin, dts)
            put(m, movie+0x6f4, 1, 1)
            put(m, t+0x88, 0, 1)
            put(m, entry+0x10, 1, 1)
            put(m, SP+0x24, entry)
            put(m, SP+0x100, 0)  # no stream-length IO
            put(m, SP+0x108, 0xffffffffffffffff, 8)
            for r,v in [(UC_ARM_REG_R1,entry), (UC_ARM_REG_R4,duration),
                        (UC_ARM_REG_R5,t), (UC_ARM_REG_R9,movie)]: reg(m,r,v)
            before = bytes(m.mem_read(entry, 0x20))
            stop = 0xA042D420 if delta < 0 else 0xA042D6B8
            run(m, 0xA042D398, stop)
            assert bytes(m.mem_read(entry,0x20)) == before
            assert get(m,t+0x20,8) == (dts if delta < 0 else 0xffffffffffffffff)
            if delta >= 0: assert m.reg_read(UC_ARM_REG_R4) == 3
            cases.append(dict(case='video_gate_actual_helper_return', rate=rate,
                delta_ticks=delta, stop=hex(stop), descriptor_unchanged=True,
                track_dts_marked_ended=delta >= 0, passed=True))
    # Actual IsoMux_Open prefix, including default-track helper and real Thumb
    # memset; stop before RTC/stream/index IO. Cache bytes are deliberately dirty.
    m = machine(image)
    movie, fmt = 0x10000000, 0x10001000
    m.mem_write(movie, bytes([0x55])*0x800)
    put(m, movie, 1, 1)
    put(m, movie+0x6f4, 1, 1)
    track(m, movie+0x78)
    put(m, fmt+4, movie)
    for r,v in [(UC_ARM_REG_R0,fmt),(UC_ARM_REG_R1,0x10003000),
                (UC_ARM_REG_R2,0x10004000),(UC_ARM_REG_R3,0)]: reg(m,r,v)
    before = bytes(m.mem_read(movie,0x800))
    run(m,0xA0435A18,0xA0435AA4)
    after = bytes(m.mem_read(movie,0x800))
    expected = bytearray(before); expected[0x338:0x670] = bytes(0x338)
    assert after == bytes(expected)
    cases.append(dict(case='iso_open_actual_prefix_codec_cache_clear',
                      cleared_movie_range=['0x338','0x670'],
                      other_movie_bytes_preserved=True, passed=True))

    # A nonnegative ParseFrame result does not itself prove that both codec
    # parameter sets were found. The real helper returns on a slice NAL without
    # testing the initially zero SPS/PPS lengths. No sample is claimed decodable.
    for nal_header in (0x61, 0x65):
        for wrapped in (False, True):
            m = machine(image)
            ring, size, params = 0x10001000, 64, 0x10002000
            data = b'\x00\x00\x00\x01' + bytes([nal_header]) + b'hello'
            offset = size - 3 if wrapped else 0
            for i, byte in enumerate(data):
                put(m, ring + (offset+i) % size, byte, 1)
            for r,v in [(UC_ARM_REG_R0,len(data)),(UC_ARM_REG_R1,ring+offset),
                        (UC_ARM_REG_R2,ring),(UC_ARM_REG_R3,ring+size)]: reg(m,r,v)
            for i,v in enumerate((params+0xb8,params,params+0xba,params+0x40)):
                put(m,SP+i*4,v)
            run(m,0xA03EF858)
            assert m.reg_read(UC_ARM_REG_R0) == len(data)
            assert get(m,params+0xb8,2) == get(m,params+0xba,2) == 0
            cases.append(dict(case='complete_parser_slice_without_parameter_sets',
                synthetic_nal_type=nal_header & 31,ring_wrapped=wrapped,
                result=len(data),sps_length=0,pps_length=0,passed=True))

    c = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    windows=[]
    for lo,hi in [(0xA042D378,0xA042D420),(0xA042D454,0xA042D4D4),
                  (0xA03E84AC,0xA03E8544),(0xA0435A18,0xA0435AA4),
                  (0xA04404D8,0xA0440560)]:
        data=image[lo-BASE:hi-BASE]
        windows.append(dict(start=hex(lo),stop_exclusive=hex(hi),sha256=sha(data),
            instructions=[dict(address=hex(x.address),bytes=bytes(x.bytes).hex(),
                               mnemonic=x.mnemonic,operands=x.op_str) for x in c.disasm(data,lo)]))
    # Pin the linkage bytes, not merely symbol names from pseudocode.
    assertions=[]
    for addr,mnem,op in [(0xA042D39C,'cmp','r0, #1'),
        (0xA042D3F4,'bl','#0xa03e835c'),(0xA042D418,'strdls','r2, r3, [r5, #0x20]'),
        (0xA042D4C0,'bl','#0xa03ef858'),(0xA0435A94,'mov','r2, #0x338'),
        (0xA0435AA0,'blx','#0xa04f8dec')]:
        ins=next(c.disasm(image[addr-BASE:addr-BASE+4],addr))
        assert (ins.mnemonic,ins.op_str)==(mnem,op)
        assertions.append(dict(address=hex(addr),mnemonic=mnem,operands=op,passed=True))
    table=struct.unpack('<3I',image[0xA078A404-BASE:0xA078A410-BASE])
    assert table==(0xA03FE468,0xA03FE300,0xA03FE1E4)
    fs={f['entry']:f for f in json.loads((ROOT/EXPORT/'functions.json').read_text())}
    sources=[]
    for addr in (0xA042D0F8,0xA03E835C,0xA03E7070,0xA043173C,
        0xA04356A4,0xA0442674,0xA0441FE0,0xA04404D8,0xA0435A18,
        0xA03FE468,0xA03FE300,0xA03FE1E4,0xA0436004,0xA03EF858,
        0xA03EE71C,0xA03E6158,0xA03E6010,0xA0506F38,0xA04F8DEC):
        f=fs[hex(addr)]; data=b''
        for r in f['body_ranges']:
            lo,hi=[int(x,16) for x in r.split('-')]; data+=image[lo-BASE:hi-BASE+1]
        p=EXPORT/f['decompiled_file']
        sources.append(dict(entry=hex(addr),body_ranges=f['body_ranges'],
            firmware_bytes_sha256=sha(data),pseudocode=str(p),
            pseudocode_sha256=sha((ROOT/p).read_bytes())))
    result=dict(evidence_type='offline original ARM execution with constructed RAM; static linkage; no device runtime',
        image=str(IMAGE),image_sha256=EXPECTED,python=platform.python_version(),
        unicorn=unicorn.__version__,capstone=capstone.__version__,cases=cases,
        passed_cases=len(cases),instruction_assertions=assertions,windows=windows,
        mp4_mux_vtable=dict(address='0xa078a404',open=hex(table[0]),close=hex(table[1]),process=hex(table[2])),
        sources=sources,limitations=[
            'No live FIFO peek/removal, producer, codec, filesystem, stream-length IO or master-limit callback was executed.',
            'type=1 is the stock mux sync-frame classification; no actual NAL payload establishes producer IDR correspondence.',
            'Return-before-consume is proven within ProcessVideo; complete indirect close/open ownership remains unverified.',
            'Codec cache is cleared at open; four constructed slice-only parser cases show positive return with missing SPS/PPS, not successful real split.',
            'No cross-file playable output, exact sixty-second retention, trigger path or A/V continuity is established.'])
    (ROOT/OUTPUT).write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUTPUT),passed_cases=len(cases),instruction_assertions=len(assertions))))

if __name__=='__main__': main()
