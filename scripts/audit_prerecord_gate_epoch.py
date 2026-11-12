#!/usr/bin/env python3
"""Offline original ARM video-event -> audio gate audit, synthetic RAM only.

Only RTOS mutex take/give return-success stubs are used. No device, MMIO, codec,
DMA, target command generation, or shared SDK changes.
"""
from pathlib import Path
import argparse
import hashlib
import json
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
SOURCE = IMAGE.parent/'full/decompiled'
OUT = ROOT/'artifacts/device/2026-11-11-prerecord-gate-epoch'
PIN = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE, STACK, STOP = 0xa0100000, 0x1001f000, 0x10010000
EVENT, ARRAY, NODE, IONODE, ENC, ENCSTATE = (0x10000000+i*0x1000 for i in range(6))
VIDEO, AUDIO, GUARD = 0xa19c9ed0, 0xa19c7250, 0xa19c71a8
PIPELINE = 0x12345678

def sha(raw):
    return hashlib.sha256(raw).hexdigest()

def put(cpu, address, value, size=4):
    cpu.mem_write(address, value.to_bytes(size, 'little'))

def get(cpu, address, size=4):
    return int.from_bytes(cpu.mem_read(address, size), 'little')

def case(raw, name, flags, event_word=0, guard=1, match=True, encoder_count=12345,
         event_tail=(0xdeadbeef, 0x13579bdf), repetitions=1):
    cpu = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    for address, size in [(BASE, (len(raw)+4095)&~4095), (0x10000000, 0x20000),
                          (0xa1445000, 0x1000), (0xa19c7000, 0x4000)]:
        cpu.mem_map(address, size)
    cpu.mem_write(BASE, raw)
    # The code reads these literal bases. Pin rather than overwrite them.
    for literal, expected in [(0xa046e784, VIDEO), (0xa045d608, AUDIO+0x18),
                               (0xa045d68c, AUDIO), (0xa045fdd4, AUDIO+0x78a)]:
        assert get(cpu, literal) == expected
    put(cpu, GUARD, guard)
    put(cpu, VIDEO-4, PIPELINE)
    for index in range(3):
        put(cpu, VIDEO+index*0x150+0x34, 0 if index == 0 else 1, 1)
    put(cpu, AUDIO+8, 1, 1)  # matcher checks instance+8, two bytes before count
    put(cpu, AUDIO+0xa, len(flags), 1)
    put(cpu, AUDIO+0xc, ARRAY)
    put(cpu, AUDIO+0x14, PIPELINE if match else PIPELINE+1)
    put(cpu, ENC+0x188, ENCSTATE)
    cpu.mem_write(ENCSTATE, bytes((i*13+9)&255 for i in range(0x80)))
    put(cpu, ENCSTATE+0x20, encoder_count)
    put(cpu, ENCSTATE+0x24, 90000)
    put(cpu, ENCSTATE+0x2c, 48000)
    encoded_before = bytes(cpu.mem_read(ENCSTATE, 0x80))
    for index, flag in enumerate(flags):
        buffer_node, io = NODE+index*0x100, IONODE+index*0x100
        put(cpu, ARRAY+index*12+4, ENC)
        put(cpu, ARRAY+index*12+8, buffer_node)
        put(cpu, buffer_node+0x40, io)
        cpu.mem_write(io, bytes((i+index*5)&255 for i in range(0x40)))
        put(cpu, io+4, flag, 1)
        put(cpu, io+0x10, 0x87654320+index*4)
    before = {IONODE+index*0x100: bytes(cpu.mem_read(IONODE+index*0x100, 0x40))
              for index in range(len(flags))}
    put(cpu, EVENT+4, event_word)
    put(cpu, EVENT+8, event_tail[0])
    put(cpu, EVENT+12, event_tail[1])
    writes, event_reads, calls, pcs = [], [], [], set()
    mutexes = {0xa03bc46c: 'take', 0xa03bc498: 'give'}

    def code(uc, address, size, _):
        pcs.add(address)
        if address in mutexes:
            calls.append(dict(kind=mutexes[address], object=hex(uc.reg_read(UC_ARM_REG_R0))))
            uc.reg_write(UC_ARM_REG_R0, 0)
            uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))
        assert address not in (0xa0290b60, 0xa029016c, 0xa048e3f8, 0xa02a70ec), hex(address)

    def write(uc, access, address, size, value, _):
        if not STACK-0x1000 <= address < STACK:
            writes.append(dict(address=hex(address), bytes=size, value=value))

    def event_read(uc, access, address, size, value, _):
        event_reads.append(dict(offset=address-EVENT, bytes=size))

    cpu.hook_add(UC_HOOK_CODE, code)
    cpu.hook_add(UC_HOOK_MEM_WRITE, write)
    cpu.hook_add(UC_HOOK_MEM_READ, event_read, begin=EVENT, end=EVENT+0x2f)
    for _ in range(repetitions):
        cpu.reg_write(UC_ARM_REG_SP, STACK)
        cpu.reg_write(UC_ARM_REG_LR, STOP)
        cpu.reg_write(UC_ARM_REG_R0, EVENT)
        cpu.emu_start(0xa046e6fc, STOP, count=10000)
        assert cpu.reg_read(UC_ARM_REG_PC) == STOP and cpu.reg_read(UC_ARM_REG_R0) == 0
    expected_open = event_word == 0 and guard != 0 and match
    expected_writes = [dict(address=hex(io+4), bytes=1, value=1)
                       for _ in range(repetitions) for io in before] if expected_open else []
    assert writes == expected_writes, (name, writes, expected_writes)
    assert event_reads == [dict(offset=4, bytes=4)]*(3*repetitions)
    for io, original in before.items():
        expected = bytearray(original)
        if expected_open:
            expected[4] = 1
        assert bytes(cpu.mem_read(io, 0x40)) == expected
    assert bytes(cpu.mem_read(ENCSTATE, 0x80)) == encoded_before
    return dict(name=name, initial_gate_flags=flags, event_word4=event_word,
        guard=guard, pipeline_match=match, encoder_frame_count=encoder_count,
        event_tail=event_tail, repetitions=repetitions, nonstack_stores=writes,
        event_reads=event_reads, encoder_state_unchanged=True, mutex_stub_calls=calls,
        visited_real_functions=[hex(address) for address in (0xa046e6fc, 0xa045fd38,
            0xa045d570, 0xa045d60c, 0xa045d7b8, 0xa029351c) if address in pcs], passed=True)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=OUT,
        help='new output directory, or JSON pathname (ASM uses the same stem)')
    args = parser.parse_args()
    raw = IMAGE.read_bytes()
    assert sha(raw) == PIN
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    pins = {
        0xa046e744: ('ldr', 'r3, [sb, #4]'),
        0xa046e77c: ('bl', '#0xa045fd38'),
        0xa045fd84: ('ldr', 'r3, [r4, #0xa]'),
        0xa045fdb8: ('bl', '#0xa045d7b8'),
        0xa045d7fc: ('ldr', 'r0, [r3, #8]'),
        0xa045d800: ('bl', '#0xa029351c'),
        0xa0293538: ('ldr', 'r5, [r0, #0x40]'),
        0xa0293560: ('strb', 'r3, [r5, #4]'),
    }
    for address, expected in pins.items():
        ins = next(md.disasm(raw[address-BASE:address-BASE+4], address))
        assert (ins.mnemonic, ins.op_str) == expected
    cases = [
        case(raw, 'closed_gate_opens_counter_nonzero', [0]),
        case(raw, 'already_open_repeated_event_no_rebase', [1], repetitions=3),
        case(raw, 'two_nodes_only_flag_stores', [0, 2]),
        case(raw, 'no_nodes_no_store', []),
        case(raw, 'other_event_selector_no_store', [0], event_word=1),
        case(raw, 'audio_guard_off_no_store', [0], guard=0),
        case(raw, 'pipeline_mismatch_no_store', [0], match=False),
        case(raw, 'different_counter_and_event_tail_same_gate', [0], encoder_count=0xffffffff,
             event_tail=(0x76543210, 0x2468ace0)),
    ]
    sources = []
    asm = []
    bounds = [(0xa046e6fc, 0xa046e784), (0xa045fd38, 0xa045fdd4),
              (0xa045d570, 0xa045d608), (0xa045d60c, 0xa045d68c),
              (0xa045d7b8, 0xa045d85c), (0xa029351c, 0xa02935fc)]
    for start, end in bounds:
        path = SOURCE/f'{start:08x}.c'
        fragment = raw[start-BASE:end-BASE]
        sources.append(dict(entry=hex(start), end_exclusive=hex(end),
            raw_sha256=sha(fragment), pseudocode=str(path.relative_to(ROOT)),
            pseudocode_sha256=sha(path.read_bytes())))
        asm.append('\nFUNCTION '+hex(start)+'\n')
        for ins in md.disasm(fragment, start):
            asm.append(f'{ins.address:08x} {ins.mnemonic:8} {ins.op_str}\n')
    json_path = args.output if args.output.suffix.lower() == '.json' else args.output/'audit.json'
    asm_path = json_path.with_suffix('.asm')
    json_path.parent.mkdir(parents=True, exist_ok=True)
    report = dict(scope='offline original complete event/gate functions, synthetic RAM',
        image=dict(path=str(IMAGE.relative_to(ROOT)), sha256=PIN), sources=sources,
        instruction_pins=len(pins), cases=cases,
        stubs='RTOS mutex take/give successful return only; no mutex side effects modeled',
        new_conclusion='event 0x13 successful gate reopening does not rebase audio producer PTS',
        limitations=['No real capture time or common hardware clock established',
            'No RTOS scheduling/mutex/DMA/codec or callback concurrency executed',
            'Successful and selected-filter paths only; failures/debug printing excluded',
            'Audio start setup is established by prior audit, not rerun here'],
        target_access=False, target_written=False)
    json_path.write_text(json.dumps(report, indent=2)+'\n')
    asm_path.write_text(''.join(asm))
    print(json.dumps(dict(output=str(json_path), assembly=str(asm_path), cases=len(cases), instruction_pins=len(pins),
        target_access=False)))

if __name__ == '__main__':
    main()
