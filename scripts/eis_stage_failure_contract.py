#!/usr/bin/env python3
"""Execute pinned EIS coordinator tails and stock Set/GetWarp with stage faults.

Offline synthetic RAM only. No target connection, patch, deployment, or hardware
model. This checks failure propagation, not whether such failures occur live.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *
from analyze_eis_warp_publication import ROOT, IMAGE, SHA256, BASE

CHECKS = {
    0xA0394740: 'bl #0xa02da164',
    0xA0394748: 'cmp r3, #0',
    0xA039474C: 'bne #0xa0394b98',
    0xA0394760: 'bl #0xa02da514',
    0xA0394764: 'movw r3, #0x7af8',
    0xA0394790: 'bl #0xa0312f74',
    0xA0394794: 'movw r3, #0x45ec',
    0xA0394960: 'bl #0xa02da164',
    0xA0394968: 'cmp r3, #0',
    0xA039496C: 'bne #0xa0394b98',
    0xA0394980: 'bl #0xa02da514',
    0xA0394984: 'mov r3, #0',
    0xA039499C: 'bl #0xa0312f74',
    0xA03949A0: 'movw r3, #0x45ec',
    0xA03949B4: 'str r2, [r3, #0x24]',
    0xA0394A9C: 'cmp r3, #0',
    0xA0394AAC: 'mov r2, #1',
    0xA02DA514: 'b #0xa0312460',
    0xA03124A8: 'bl #0xa0308880',
    0xA03124AC: 'subs r5, r0, #0',
    0xA03124B0: 'blt #0xa03127d8',
    0xA03127E4: 'mov r0, r5',
}
WINDOWS = {
    'coordinator-branch-nonzero': (0xA0394734, 0xA039479C),
    'coordinator-branch-zero': (0xA0394958, 0xA0394AB4),
    'setwarp-lookup': (0xA0312490, 0xA03124C0),
    'setwarp-lookup-failure': (0xA03127D8, 0xA03127F0),
    'getwarp': (0xA0312F74, 0xA03131EC),
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def scenario(image, branch, generator_return, fault, enabled):
    u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    u.mem_map(BASE, (len(image) + 4095) & ~4095)
    u.mem_write(BASE, image)
    u.mem_map(0xA1400000, 0x400000)
    u.mem_map(0x30000000, 0x200000)
    u.mem_map(0x70000000, 0x10000)
    context, mutex, stack = 0x30000000, 0x301F0000, 0x7000F000
    mode, descriptor = stack + 0x2C, context + 0x41104
    result, staged = 0xA17045EC, 0xA1704334
    old_x, old_y = context + 0x180000, context + 0x182000
    new_x, new_y = context + 0x100000 + 0xD060, context + 0x100000 + 0xE860

    def put(address, value):
        u.mem_write(address, struct.pack('<I', value & 0xFFFFFFFF))

    def get(address):
        return struct.unpack('<I', u.mem_read(address, 4))[0]

    # Existing descriptor/result contents intentionally survive a failed stage.
    # All addresses and data are synthetic and owned by this host emulator.
    u.mem_write(mode, bytes(16))
    put(descriptor + 4, enabled)
    u.mem_write(descriptor + 0x30, bytes([30, 34, 6, 5, 1, 30, 35, 6, 5]))
    put(descriptor + 8, old_x)
    put(descriptor + 12, old_y)
    put(result, enabled)
    u.mem_write(result + 4, bytes([30, 34, 6, 5]))
    put(result + 0x10, old_x)
    put(result + 0x14, old_y)
    u.mem_write(staged, b'\xCC' * 0x22)
    u.mem_write(0xA170AFB8, b'\0')
    put(context + 0x38, 6)
    put(context + 0xD764C, context + 0x100000)
    payload = bytes((n * 17 + 3) & 255 for n in range(0x3000))
    u.mem_write(context + 0x47600, payload)
    before_staged = bytes(u.mem_read(staged, 0x22))
    events, stage = [], {'name': None}

    def hook(machine, pc, size, user):
        regs = [machine.reg_read(r) for r in (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2)]
        ret = None
        if pc in (0xA0394764, 0xA0394984):
            events.append({'stage_return': 'set', 'return': hex(regs[0])})
        elif pc in (0xA0394794, 0xA03949A0):
            events.append({'stage_return': 'get', 'return': hex(regs[0])})
        if pc == 0xA02DA164:
            assert regs[0] == mode and regs[1] == 0
            events.append({'stage': 'generate', 'return': hex(generator_return)})
            ret = generator_return
        elif pc in (0xA0312460, 0xA0312F74):
            stage['name'] = 'set' if pc == 0xA0312460 else 'get'
            events.append({'stage': stage['name'], 'selector': get(mode + 4)})
            if stage['name'] == 'set':
                assert get(mode + 4) == 15
            else:
                assert get(mode + 4) == 0
        elif pc == 0xA0308880:
            assert stage['name'] in ('set', 'get')
            ret = 0xFFFFFFFF if fault == stage['name'] + '-lookup' else 0
            if ret == 0:
                put(regs[1], mutex)
            events.append({'dependency': 'mutex_lookup', 'stage': stage['name'], 'return': hex(ret)})
        elif pc == 0xA0308754:
            put(regs[1], context)
            ret = 0
        elif pc in (0xA03BC46C, 0xA03BC498):
            events.append({'dependency': 'lock' if pc == 0xA03BC46C else 'unlock', 'stage': stage['name']})
            ret = 0
        elif pc == 0xA029C680:
            u.mem_write(regs[0], bytes(u.mem_read(regs[1], regs[2])))
            events.append({'dependency': 'copy', 'bytes': regs[2]})
            ret = regs[0]
        elif pc == 0xA04A22CC:
            events.append({'dependency': 'clean', 'address': hex(regs[0]), 'bytes': regs[1]})
            ret = 0
        elif pc == 0xA0308B8C:
            ret = 0
        elif pc == 0xA04A3B24:
            events.append({'dependency': 'address_conversion', 'address': hex(regs[0])})
            ret = regs[0]
        elif pc == 0xA02A70EC:
            events.append({'dependency': 'log', 'stage': stage['name']})
            ret = 0
        elif pc in (0xA02BD9F0, 0xA02BC3F8):
            raise AssertionError('selector F must not submit a standalone warp command')
        if ret is not None:
            machine.reg_write(UC_ARM_REG_R0, ret & 0xFFFFFFFF)
            machine.reg_write(UC_ARM_REG_PC, machine.reg_read(UC_ARM_REG_LR))

    u.hook_add(UC_HOOK_CODE, hook)
    u.reg_write(UC_ARM_REG_SP, stack)
    u.reg_write(UC_ARM_REG_R3, mode)
    entry = 0xA0394734 if branch == 'nonzero' else 0xA0394958
    u.emu_start(entry, 0xA0394B98, count=10000)
    assert u.reg_read(UC_ARM_REG_PC) == 0xA0394B98
    stage_names = [e['stage'] for e in events if 'selector' in e]
    stage_returns = {e['stage_return']: e['return'] for e in events if 'stage_return' in e}
    state_after = bytes(u.mem_read(staged, 0x22))
    ready_after = u.mem_read(0xA170AFB8, 1)[0]
    if generator_return != 0:
        assert stage_names == [] and state_after == before_staged and ready_after == 0
    elif branch == 'nonzero':
        # The original debug table is zero: GetWarp is optional on this branch.
        assert stage_names == ['set'] and state_after == before_staged and ready_after == 0
        assert stage_returns == {'set': hex(0xFFFFFFFF if fault == 'set-lookup' else 0)}
    else:
        assert stage_names == ['set', 'get']
        assert stage_returns == {'set': hex(0xFFFFFFFF if fault == 'set-lookup' else 0),
                                 'get': hex(0xFFFFFFFF if fault == 'get-lookup' else 0)}
        assert get(staged) == enabled and ready_after == bool(enabled)
        expect_x, expect_y = (new_x, new_y) if fault == 'none' else (old_x, old_y)
        assert (get(staged + 8), get(staged + 12)) == (expect_x, expect_y)
    if generator_return == 0 and fault != 'set-lookup':
        assert bytes(u.mem_read(new_x, 0x1800)) + bytes(u.mem_read(new_y, 0x1800)) == payload
    return {
        'branch_a17045da': branch, 'generator_return': hex(generator_return),
        'fault_injected': fault, 'descriptor_enabled': enabled,
        'events': events, 'staged_state_changed': state_after != before_staged,
        'ready_byte_after': ready_after,
        'staged_x': hex(get(staged + 8)), 'staged_y': hex(get(staged + 12)),
        'old_descriptor_addresses': [hex(old_x), hex(old_y)],
        'new_bank_addresses': [hex(new_x), hex(new_y)],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-directory', type=Path, default=ROOT / 'artifacts/device/2026-11-11-eis-stage-failure-contract')
    args = parser.parse_args()
    image = IMAGE.read_bytes()
    assert sha(image) == SHA256
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for address, expected in CHECKS.items():
        ins = next(md.disasm(image[address - BASE:address - BASE + 4], address))
        text = f'{ins.mnemonic} {ins.op_str}'
        assert text == expected, (hex(address), text, expected)
        checks.append({'address': hex(address), 'instruction': text})
    cases = [scenario(image, branch, gen, fault, enabled)
             for branch in ('nonzero', 'zero')
             for gen in (0, 1, 0xFFFFFFFF)
             for fault in ('none', 'set-lookup', 'get-lookup')
             for enabled in (0, 1)]
    args.output_directory.mkdir(parents=True, exist_ok=True)
    windows = []
    for name, (start, end) in WINDOWS.items():
        body = image[start - BASE:end - BASE]
        path = args.output_directory / (name + '.asm')
        path.write_text('\n'.join(f'{i.address:08x}: {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(body, start)) + '\n')
        windows.append({'name': name, 'start': hex(start), 'end_exclusive': hex(end), 'sha256': sha(body)})
    report = {
        'evidence_kind': 'pinned original coordinator tails and Set/GetWarp instructions in synthetic RAM',
        'cpu_image_sha256': sha(image), 'script_sha256': sha(Path(__file__).read_bytes()),
        'instruction_checks': checks, 'instruction_windows': windows,
        'scenario_count': len(cases), 'scenarios': cases,
        'findings': [
            'Both coordinator branches gate SetWarp on generator return exactly zero.',
            'Both branches ignore the SetWarp return; the zero branch also ignores GetWarp return.',
            'With synthetic SetWarp lookup failure the zero branch stages the prior descriptor and may set A170AFB8=1.',
            'With synthetic GetWarp lookup failure the zero branch stages the prior global result and may set A170AFB8=1.',
            'Generation success or the ready byte alone cannot validate this invocation\'s table preparation.',
        ],
        'declared_substitutes': [
            'A02DA164 generator returns a selected status; no generator math executed here',
            'mutex/context lookup return synthetic owned addresses or declared lookup error',
            'lock/unlock log only; no concurrency or real synchronization model',
            'memcpy performs synthetic logical copy; cache-clean only logged',
            'A0308B8C returns zero; no alternate descriptor clean path',
            'address conversion is identity; logs suppressed',
        ],
        'limits': [
            'Starts at two explicit tails after upstream mode/geometry computation; not full EIS task execution.',
            'Original SetWarp and GetWarp execute; no DSP, MMIO, real cache, SD, firmware mutation or device connection.',
            'Injected lookup failures demonstrate control-flow reachability, not observed live faults or fault rates.',
            'No complete state publication or encoded-frame association is executed or proved.',
        ],
        'device_access': False, 'custom_eis_replacement_ready': False,
    }
    (args.output_directory / 'audit.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'scenarios': len(cases), 'instruction_checks': len(checks), 'output': str(args.output_directory), 'device_access': False}))


if __name__ == '__main__':
    main()
