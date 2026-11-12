#!/usr/bin/env python3
"""Audit stock CPU EIS feedback using pinned bytes; never contacts a device.

Unicorn uses a declared address-conversion stub and synthetic shared memory.
It validates CPU semantics only, not DSP execution or memory coherency.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
IMAGE = ANALYSIS / 'rtos-window.bin'
BASE = 0xA0100000
DIGEST = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
SHARED, LOCAL, VCAP = 0xA0699160, 0xA170AFC8, 0xA064F3C0
EXPECTED = {
    0xA02C6080: 'ldr r2, [r4, #0x20]',
    0xA02C6084: 'str r2, [r5, #0x20]',
    0xA02C60DC: 'str r0, [r7, #0x80]',
    0xA02C61EC: 'ldr r0, [r3, #0x58]',
    0xA02C6204: 'bl #0xa04a3bd4',
    0xA02C6210: 'ldr r3, [r4, #0x20]',
    0xA02C6214: 'str r3, [r0, #0x3c]',
    0xA02C6220: 'ldr r3, [r0, #0x10]',
    0xA02C6260: 'ldr r3, [r0, #0x3c]',
    0xA02C6268: 'str r3, [r4, #0x20]',
    0xA0387794: 'movw r0, #0xafc8',
    0xA0387798: 'movt r0, #0xa170',
    0xA038779C: 'mov r1, #0',
    0xA03877A0: 'bl #0xa02c61d4',
    0xA03877AC: 'ldr r3, [r3, #0x20]',
    0xA03877B0: 'cmn r3, #1',
    0xA03877B4: 'beq #0xa0388364',
    0xA03877C4: 'movw r3, #0xbeef',
    0xA03877C8: 'movt r3, #0xdead',
    0xA03877CC: 'cmp r2, r3',
    0xA03877D0: 'beq #0xa0388364',
    0xA038792C: 'uxtb r2, r3',
    0xA0387938: 'str r2, [r3]',
    0xA038794C: 'and r3, r3, #0x100',
    0xA038795C: 'strh r2, [r3]',
    0xA0388818: 'mov r2, #0',
    0xA038881C: 'strb r2, [r3]',
    0xA038883C: 'cmp r3, #0x3f',
    0xA038884C: 'mov r2, #0x40',
    0xA0388850: 'strb r2, [r3]',
    0xA0387A0C: 'cmp r3, #0',
    0xA0387A10: 'bne #0xa0387aa8',
    0xA0387C94: 'movw r3, #0xbeef',
    0xA0387C98: 'movt r3, #0xdead',
    0xA0387C9C: 'str r3, [r2, #0x20]',
    0xA0387CA0: 'movw r0, #0xafc8',
    0xA0387CA4: 'movt r0, #0xa170',
    0xA0387CA8: 'mov r1, #1',
    0xA0387CAC: 'bl #0xa02c61d4',
    0xA0389FB0: 'ldrb r3, [r3]',
    0xA0389FB4: 'sub r3, r3, #1',
    0xA0389FC4: 'str r2, [r3, #0x20]',
    0xA038A62C: 'ldrb r3, [r3]',
    0xA038A644: 'orr r2, r3, #0x100',
    0xA038A650: 'str r2, [r3, #0x20]',
    0xA038B298: 'movw r0, #0x4310',
    0xA038B29C: 'movt r0, #0xa170',
    0xA038B2A0: 'mov r1, #1',
    0xA038B2A8: 'bl #0xa02c5fd8',
    0xA03970B0: 'mov r0, #0x1a',
    0xA03970BC: 'bl #0xa02c11b0',
    0xA03970C4: 'mov r0, #0x1c',
    0xA03970D0: 'bl #0xa02c11b0',
    0xA0397100: 'bl #0xa048e4bc',
    0xA03972CC: 'tst r3, #1',
    0xA03972D0: 'bne #0xa0397460',
    0xA0397464: 'movw r0, #0x100f',
    0xA0397470: 'bl #0xa03b0ce0',
    0xA03974C8: 'mov r1, #1',
    0xA03974D0: 'b #0xa03bc4e8',
    0xA02C13F0: 'blx r3',
    0xA03B1ECC: 'b #0xa03af31c',
    0xA03AF320: 'bl #0xa0385780',
}
WINDOWS = [(0xA02C61D4, 0xA02C6270), (0xA0387794, 0xA03877D4),
           (0xA0387920, 0xA0387960), (0xA0387C8C, 0xA0387CB0),
           (0xA0389FA8, 0xA038A104), (0xA038A624, 0xA038A68C),
           (0xA038B264, 0xA038B2AC), (0xA02C605C, 0xA02C60E8),
           (0xA03970AC, 0xA0397104), (0xA0397460, 0xA0397474),
           (0xA03974C4, 0xA0397594), (0xA02C13D4, 0xA02C13F8),
           (0xA03B1EC0, 0xA03B1ED0), (0xA03AF31C, 0xA03AF32C),
           (0xA03887F0, 0xA038887C), (0xA03972CC, 0xA03972D4)]


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def emulate(data: bytes) -> dict:
    uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    uc.mem_map(BASE, (len(data) + 4095) & ~4095)
    uc.mem_write(BASE, data)
    uc.mem_map(0xA1700000, 0x10000)
    uc.mem_map(0xA1450000, 0x10000)
    uc.mem_map(0x70000000, 0x2000)
    conversions = []

    def conversion_stub(machine, address, size, user):
        if address == 0xA04A3BD4:
            conversions.append(machine.reg_read(UC_ARM_REG_R0))
            machine.reg_write(UC_ARM_REG_R0, SHARED)
            machine.reg_write(UC_ARM_REG_PC, machine.reg_read(UC_ARM_REG_LR))
        elif address == 0xA04A3B24:
            # Identity conversion only in synthetic CPU publication test.
            machine.reg_write(UC_ARM_REG_PC, machine.reg_read(UC_ARM_REG_LR))

    uc.hook_add(UC_HOOK_CODE, conversion_stub)

    def put(address, value):
        uc.mem_write(address, struct.pack('<I', value))

    def get(address):
        return struct.unpack('<I', uc.mem_read(address, 4))[0]

    def run(start, end=0x70001000):
        uc.reg_write(UC_ARM_REG_SP, 0x70000F00)
        uc.reg_write(UC_ARM_REG_LR, 0x70001000)
        uc.emu_start(start, end, count=500)
        assert uc.reg_read(UC_ARM_REG_PC) == end

    def helper(pointer, mode):
        uc.reg_write(UC_ARM_REG_R0, pointer)
        uc.reg_write(UC_ARM_REG_R1, mode)
        run(0xA02C61D4)
        assert uc.reg_read(UC_ARM_REG_R0) == 0

    initial = bytes((n * 29 + 7) & 255 for n in range(0x40))
    uc.mem_write(SHARED, initial)
    put(VCAP + 0x58, 0x12345000)
    uc.mem_write(0xA1458328, b'\x01')
    helper(LOCAL, 0)
    offsets = [0x10, 0x20, 0x24, 0x28, 0x2C, 0x30, 0x34, 0x38, 0x3C]
    assert bytes(uc.mem_read(LOCAL, 36)) == b''.join(initial[n:n+4] for n in offsets)
    assert bytes(uc.mem_read(SHARED, 0x40)) == initial
    put(LOCAL + 0x20, 0xDEADBEEF)
    helper(LOCAL, 1)
    assert bytes(uc.mem_read(SHARED, 0x40)) == initial[:0x3C] + struct.pack('<I', 0xDEADBEEF)
    for pointer, enabled in [(0, True), (LOCAL, False)]:
        put(VCAP + 0x58, 0x12345000 if enabled else 0)
        before = bytes(uc.mem_read(SHARED, 0x40))
        call_count = len(conversions)
        helper(pointer, 0)
        assert bytes(uc.mem_read(SHARED, 0x40)) == before
        assert len(conversions) == call_count
    put(VCAP + 0x58, 0x12345000)
    cases = []
    for phase in range(1, 65):
        for ready in (0, 1):
            uc.mem_write(0xA170AB1B, bytes([phase]))
            uc.mem_write(0xA170AFB8, bytes([ready]))
            run(0xA0389FA8, 0xA0389FC8)
            run(0xA038A624, 0xA038A68C)
            tag = get(0xA1704330)
            assert tag == phase - 1 | ready << 8
            slot_index = uc.mem_read(0xA1457FD8, 1)[0]
            slot = 0xA06990E0 + slot_index * 0x40
            put(0xA1704334, 0)
            uc.reg_write(UC_ARM_REG_R0, 0xA1704310)
            uc.reg_write(UC_ARM_REG_R1, 1)
            uc.reg_write(UC_ARM_REG_R2, 0)
            run(0xA02C5FD8)
            assert get(slot + 0x20) == tag
            assert get(SHARED) == slot
            # Synthetic feedback injection. This is NOT an emulated DSP echo.
            put(SHARED + 0x3C, tag)
            helper(LOCAL, 0)
            run(0xA0387920, 0xA0387960)
            assert get(0xA170AFC0) == phase - 1
            assert struct.unpack('<H', uc.mem_read(0xA170AFC4, 2))[0] == ready << 8
            uc.reg_write(UC_ARM_REG_R1, 1)
            run(0xA0387C8C, 0xA0387CB0)
            assert get(SHARED + 0x3C) == 0xDEADBEEF
            cases.append({'phase': phase, 'ready': ready, 'tag': hex(tag), 'published_slot': hex(slot)})
    sentinel_results = []
    # Execute the actual guard and stop before the valid path or invalid target.
    for value in (0xFFFFFFFF, 0xDEADBEEF, 0, 0x13F):
        put(SHARED + 0x3C, value)
        reached = []

        def guard_stop(machine, address, size, user):
            if address in (0xA03877D4, 0xA0388364):
                reached.append(address)
                machine.emu_stop()

        handle = uc.hook_add(UC_HOOK_CODE, guard_stop)
        run_end = 0x70001000
        uc.reg_write(UC_ARM_REG_SP, 0x70000F00)
        uc.emu_start(0xA0387794, run_end, count=500)
        uc.hook_del(handle)
        expected = 0xA0388364 if value in (0xFFFFFFFF, 0xDEADBEEF) else 0xA03877D4
        assert reached == [expected]
        sentinel_results.append({'value': hex(value), 'destination': hex(expected)})
    # No synthetic feedback producer runs here: CPU slots still wrap 0,1,0.
    put(SHARED + 0x3C, 0xDEADBEEF)
    uc.mem_write(0xA1457FD8, b'\x00')
    without_feedback = []
    for tag in (0, 1, 2):
        put(0xA1704330, tag)
        uc.reg_write(UC_ARM_REG_R0, 0xA1704310)
        uc.reg_write(UC_ARM_REG_R1, 1)
        uc.reg_write(UC_ARM_REG_R2, 0)
        run(0xA02C5FD8)
        without_feedback.append(hex(get(SHARED)))
        assert get(SHARED + 0x3C) == 0xDEADBEEF
    assert without_feedback == ['0xa06990e0', '0xa0699120', '0xa06990e0']
    return {'helper_cases': 4, 'tag_roundtrip_cases': len(cases), 'tags': cases,
            'sentinel_guard_cases': sentinel_results,
            'publications_without_feedback': without_feedback,
            'conversion_stub_inputs': sorted(set(hex(v) for v in conversions)),
            'stub_contract': 'A04A3BD4 returns synthetic SHARED; A04A3B24 is synthetic identity conversion; actual mappings not executed',
            'dsp_executed': False, 'synthetic_feedback_injected': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-directory', required=True, type=Path)
    args = parser.parse_args()
    data = IMAGE.read_bytes()
    assert hashlib.sha256(data).hexdigest() == DIGEST, 'Pinned image mismatch'
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in EXPECTED.items():
        ins = next(cs.disasm(data[address-BASE:address-BASE+4], address))
        actual = ins.mnemonic + ' ' + ins.op_str
        assert actual == expected, (hex(address), actual, expected)
        checks.append({'address': hex(address), 'bytes': bytes(ins.bytes).hex(), 'instruction': actual})
    sources = [ANALYSIS / 'focused/a0385780.c', ANALYSIS / 'focused/a03b0ce0.c',
               ANALYSIS / 'full/decompile-failures.json', ANALYSIS / 'full/calls.tsv',
               ANALYSIS / 'full/references.tsv']
    sources += [ANALYSIS / f'full/decompiled/{name}.c' for name in
                ['a02c61d4', 'a02c5fd8', 'a0396f34', 'a0397500', 'a03974d4',
                 'a02c11b0', 'a02c1298', 'a02c1358', 'a0392cb0', 'a037c5a4']]
    refs = (ANALYSIS / 'full/references.tsv').read_text().splitlines()
    helper_calls = [line for line in refs if '\t0xa02c61d4\t' in line]
    assert len(helper_calls) == 2
    full_missing = not (ANALYSIS / 'full/decompiled/a0385780.c').exists()
    assert full_missing and sources[0].exists()
    strings = []
    for addr in [0xA0600014, 0xA0600044, 0xA0600078, 0xA06000CC, 0xA0600130, 0xA0600228, 0xA0600270]:
        value = data[addr-BASE:].split(b'\0', 1)[0].decode('ascii')
        strings.append({'address': hex(addr), 'text': value})
    report = {'evidence_kind': 'offline pinned ARM audit and bounded synthetic Unicorn execution',
              'target_sha256': DIGEST, 'device_contacted': False, 'checks': checks,
              'instruction_check_count': len(checks), 'emulation': emulate(data),
              'helper_call_sites': helper_calls, 'full_decompiled_caller_missing': full_missing,
              'caller_retained_in_focused_export': True, 'stock_strings': strings,
              'sources': [{'path': str(p.relative_to(ROOT)), 'sha256': sha(p)} for p in sources],
              'boundaries': {'cpu_feedback_read_reset_proven': True,
                             'publication_tag_and_feedback_format_match': True,
                             'non_sentinel_feedback_writer_identified': False,
                             'dsp_echo_proven': False, 'dsp_latch_proven': False,
                             'slot_release_proven': False, 'video_frame_id_mapping_proven': False}}
    args.output_directory.mkdir(parents=True, exist_ok=True)
    (args.output_directory / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    lines = []
    for start, end in WINDOWS:
        lines.append(f'\n; 0x{start:08X}..0x{end:08X} (end exclusive)')
        lines.extend(f'{i.address:08X}: {bytes(i.bytes).hex()}  {i.mnemonic} {i.op_str}'
                     for i in cs.disasm(data[start-BASE:end-BASE], start))
    (args.output_directory / 'audit.asm').write_text('\n'.join(lines) + '\n')
    print(f'{len(checks)} instruction checks; 4 helper cases; 128 tag/publication/read/reset cases; 4 sentinel guards; 3 publications without feedback')


if __name__ == '__main__':
    main()
