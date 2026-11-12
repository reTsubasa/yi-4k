#!/usr/bin/env python3
"""Offline bounded execution of native MP4 split decisions and track resets."""
import hashlib
import json
import struct
from pathlib import Path
import capstone
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE = Path('artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin')
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
SP, END = 0x1001F000, 0x1001FF00


def digest(b):
    return hashlib.sha256(b).hexdigest()


def put(m, a, v, n=4):
    m.mem_write(a, v.to_bytes(n, 'little'))


def get(m, a, n=4):
    return int.from_bytes(m.mem_read(a, n), 'little')


def machine(b):
    m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    m.mem_map(BASE, (len(b) + 4095) & ~4095)
    m.mem_write(BASE, b)
    m.mem_map(0x10000000, 0x20000)
    m.mem_map(0xA13C0000, 0x9000)
    m.reg_write(UC_ARM_REG_SP, SP)
    m.reg_write(UC_ARM_REG_LR, END)
    return m


def run(m, start, stop=END):
    m.emu_start(start, stop, count=100000)
    assert m.reg_read(UC_ARM_REG_PC) == stop


def main():
    b = (ROOT / IMAGE).read_bytes()
    assert digest(b) == EXPECTED
    cases = []
    # Original getter suffix: skip its logging call; no firmware helper mocked.
    for selector, expected in [(0, 0), (0x100, 60000), (0x200, 300000),
                               (0x300, 1800000), (0x400, 600000),
                               (0x500, 30000), (0x600, 10000), (0x700, 300000)]:
        m = machine(b)
        put(m, 0xA13C82BC, selector, 2)
        m.reg_write(UC_ARM_REG_R4, 0xA13C82B4)
        m.reg_write(UC_ARM_REG_R5, 0x10000008)
        m.reg_write(UC_ARM_REG_R6, 0x10000000)
        put(m, SP + 12, END)
        run(m, 0xA021F8D8)
        assert get(m, 0x10000000) == expected
        size = get(m, 0x10000008, 8)
        assert size == (0 if selector == 0 else 0x780000000)
        cases.append(dict(case='split_getter_suffix', selector=hex(selector),
                          milliseconds=expected, size=hex(size), passed=True))
    # Original callback event-3 decision stops before any close / notification.
    for time, size, mode, rollover in [(0, 0, 2, False), (10000, 0, 2, True),
            (0, 1, 2, True), (0, 0xEA600000, 2, True),
            (60000, 0xEA600001, 2, False), (60000, 0x780000000, 2, False),
            (60000, 0x780000000, 4, True), (0, 0, 4, False)]:
        m = machine(b)
        put(m, 0xA06D42C8, time)
        put(m, 0xA06D42C0, size, 8)
        put(m, 0xA13C2A40, mode)
        stop = 0xA01F5888 if rollover else 0xA01F57A4
        run(m, 0xA01F5750, stop)
        cases.append(dict(case='event3_split_decision', milliseconds=time,
                          size=hex(size), mode=mode, rollover=rollover,
                          stop_before=hex(stop), passed=True))
    # Complete original metadata-counter reset, with distinct canaries elsewhere.
    for count in (0, 1, 3):
        m = machine(b)
        movie = 0x10000000
        m.mem_write(movie, bytes([0x55]) * 0x800)
        put(m, movie, 1, 1)
        put(m, movie + 0x6F4, count, 1)
        before = bytes(m.mem_read(movie, 0x800))
        m.reg_write(UC_ARM_REG_R0, movie)
        run(m, 0xA01F68B8)
        after = bytes(m.mem_read(movie, 0x800))
        expected = bytearray(before)
        for i in range(count):
            expected[0x88 + i * 0x90:0x90 + i * 0x90] = bytes(8)
        assert after == bytes(expected)
        cases.append(dict(case='reset_movie_counters_complete', tracks=count, passed=True))
    # Arithmetic suffix after mutex-protected helper/shortest-track selection.
    # Runs true ResetPTS helper for video; does not run logging, mutex or FIFO.
    for dts in [(90000, 95000), (0x100000000, 0x100000123)]:
        m = machine(b)
        movie = 0x10000000
        put(m, movie, 1, 1)
        put(m, movie + 0x6F4, 2, 1)
        for i, value in enumerate(dts):
            track = movie + 0x78 + i * 0x90
            put(m, track + 0x89, i + 1, 1)
            put(m, track + 0x20, value, 8)
            put(m, track + 0xC, 1001)
            put(m, track + 0x78, 1, 2)
            put(m, track + 0x58, 0x123456789, 8)
            put(m, track + 0x48, 12)
        m.reg_write(UC_ARM_REG_R4, movie)
        m.reg_write(UC_ARM_REG_R0, movie + 0x78)
        put(m, SP + 0x34, END)
        run(m, 0xA01F3198)
        for i, value in enumerate(dts):
            track = movie + 0x78 + i * 0x90
            assert get(m, track + 0x20, 8) == value - min(dts)
            assert get(m, track + 0x28, 8) == value - min(dts)
            assert get(m, track + 0x18, 8) == value - min(dts)
        assert get(m, movie + 0x78 + 0x58, 8) == 0
        assert get(m, movie + 0x78 + 0x48) == 0
        assert get(m, movie + 0x108 + 0x58, 8) == 0x123456789
        cases.append(dict(case='reset_movie_time_suffix', dts=list(dts), passed=True))
    c = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    windows = []
    for lo, hi in [(0xA01F5750, 0xA01F57B8), (0xA01F5888, 0xA01F58D8),
                   (0xA01F5970, 0xA01F5A3C), (0xA01F5AEC, 0xA01F5B2C),
                   (0xA01F5B2C, 0xA01F5C84), (0xA01F31D8, 0xA01F3268),
                   (0xA01F68B8, 0xA01F69B0), (0xA021F918, 0xA021F970),
                   (0xA01A7508, 0xA01A7764)]:
        payload = b[lo-BASE:hi-BASE]
        windows.append(dict(start=hex(lo), stop_exclusive=hex(hi), sha256=digest(payload),
            instructions=[dict(address=hex(i.address), bytes=bytes(i.bytes).hex(),
                               mnemonic=i.mnemonic, operands=i.op_str)
                          for i in c.disasm(payload, lo)]))
    table = struct.unpack('<27H', b[0xA055E7AC-BASE:0xA055E7AC-BASE+54])
    export = Path('artifacts/device/2026-11-09-linux/rtos-analysis/full')
    functions = {f['entry']: f for f in json.loads((ROOT/export/'functions.json').read_text())}
    sources = []
    for address in (0xA021F8A8, 0xA021F7AC, 0xA01923C8, 0xA019A18C,
                    0xA01A18F8, 0xA0124470, 0xA01F3338, 0xA01F4BC8,
                    0xA01F51D0, 0xA01F2CE0, 0xA03E41A0, 0xA03E40C8,
                    0xA01F68B8, 0xA01F3124, 0xA01F721C, 0xA0442674):
        f = functions[hex(address)]
        body = b''
        for interval in f['body_ranges']:
            lo, hi = [int(x, 16) for x in interval.split('-')]
            body += b[lo-BASE:hi-BASE+1]
        path = export/f['decompiled_file']
        sources.append(dict(entry=hex(address), body_ranges=f['body_ranges'],
            body_sha256=digest(body), pseudocode_path=str(path),
            pseudocode_sha256=digest((ROOT/path).read_bytes())))
    report = dict(image=str(IMAGE), image_sha256=EXPECTED,
        scope='Original instruction suffixes in synthetic RAM; no camera, RTOS, hardware encoder, filesystem or callbacks run. No helper stubs.',
        snippet_cases_passed=len(cases), results=cases, instruction_windows=windows,
        sources=sources, split_callback=dict(start='0xa01f569c', stop_exclusive='0xa01f5ff0',
            sha256=digest(b[0xA01F569C-BASE:0xA01F5FF0-BASE]),
            note='Unindexed code label, no corresponding decompiled C file claimed.'),
        storage_enum_map=[dict(input=i+4, split=hex(v)) for i,v in enumerate(table)],
        limits=['Time getter selectors return a size beyond 4GB cap; connected-camera setup overwrites both time and size.',
                'No IDR/SPS/PPS, audio configuration continuation, producer PTS continuity or playable MP4 assertion.',
                'Split callback has fatal assertion loops on close/allocation/reset failures; not a safe standalone entry.'])
    output = ROOT / 'artifacts/device/2026-11-10-prerecord/prerecord-session-rollover-audit.json'
    output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(output=str(output), snippet_cases_passed=len(cases))))


if __name__ == '__main__':
    main()
