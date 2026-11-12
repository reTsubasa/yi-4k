#!/usr/bin/env python3
"""Execute the public YI 1.10.52 pre-kernel serial gate, with synthetic MMIO.

No UART/USB/device access. No flash/firmware writes. This is public reference
code, NOT the hidden BLD from the 1.10.7 device.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_SP, UC_ARM_REG_LR

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-11-public-yi-bld-serial-entry'
SOURCE = ROOT / 'artifacts/firmware/v1.10.52/_part_bld.a9s'
PIN = '259ed36093252298186c7e39c5f3400ba307f44224aba467ab885da8e1e5cbd7'
BASE, ENTRY, SHELL, STOP = 0x10000000, 0x10005a64, 0x10005b28, 0x10600000
UART, TIMER, STACK = 0xe8005000, 0xe8170000, 0x10500000
THRESHOLD = 0x15f8ff


def sha(data):
    return hashlib.sha256(data).hexdigest()


def run_case(raw, label, polls, expected, arg=0):
    """polls=(counter value, received byte or None). No target service mocks."""
    u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    for address, size in [(BASE, 0x10000), (STACK, 0x10000), (STOP, 0x1000),
                          (UART, 0x1000), (TIMER, 0x1000)]:
        u.mem_map(address, size)
    u.mem_write(BASE, raw)
    u.reg_write(UC_ARM_REG_SP, STACK + 0xf000)
    u.reg_write(UC_ARM_REG_LR, STOP)
    u.reg_write(UC_ARM_REG_R0, arg)
    observed, writes, index, steps, outcome = [], [], -1, 0, None

    def read_hook(_, access, address, size, value, context):
        nonlocal index
        if address == TIMER + 0x254:
            index += 1
            tick, byte = polls[index] if index < len(polls) else (THRESHOLD + 1, None)
            observed.append(dict(counter=tick, rx=byte))
            u.mem_write(address, struct.pack('<I', tick))
        elif address == UART + 0x14:
            assert index >= 0
            u.mem_write(address, struct.pack('<I', int(observed[-1]['rx'] is not None)))
        elif address == UART:
            assert observed[-1]['rx'] is not None
            u.mem_write(address, struct.pack('<I', observed[-1]['rx']))

    def write_hook(_, access, address, size, value, context):
        if TIMER <= address < TIMER + 0x1000 or UART <= address < UART + 0x1000:
            writes.append(dict(address=hex(address), size=size, value=value))

    def code_hook(_, address, size, context):
        nonlocal steps, outcome
        steps += 1
        if address in (SHELL, STOP):
            outcome = 'shell_gate_passed' if address == SHELL else 'timeout_returned'
            u.emu_stop()

    u.hook_add(UC_HOOK_MEM_READ, read_hook)
    u.hook_add(UC_HOOK_MEM_WRITE, write_hook)
    u.hook_add(UC_HOOK_CODE, code_hook)
    u.emu_start(ENTRY, STOP + 4, count=10000)
    assert outcome == expected, (label, outcome, observed)
    if outcome == 'timeout_returned':
        assert u.reg_read(UC_ARM_REG_SP) == STACK + 0xf000
    assert all(w['address'] == hex(TIMER + 0x258) and w['size'] == 4 for w in writes)
    assert [w['value'] for w in writes] == ([] if arg else [1, 0, 1])
    return dict(label=label, argument=arg, polls=observed, outcome=outcome,
                instructions_executed=steps, modeled_mmio_writes=writes,
                actual_hardware_access=False)


def main():
    raw = SOURCE.read_bytes()
    assert sha(raw) == PIN
    assert struct.unpack_from('<I', raw, 0xb750)[0] == UART
    assert struct.unpack_from('<I', raw, 0xbab4)[0] == TIMER
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = {
        0x10006b48: ('mov', 'r0, r4'),
        0x10006b38: ('subs', 'r4, r0, #0'),
        0x10006b3c: ('bne', '#0x10006b54'),
        0x10006b4c: ('bl', '#0x10005a64'),
        0x10006b50: ('bl', '#0x10006834'),
        0x10006960: ('bl', '#0x10002358'),
        0x10006998: ('mov', 'pc, r3'),
        0x10005a64: ('cmp', 'r0, #0'),
        0x10005a70: ('bne', '#0x10005b18'),
        0x10005a80: ('movw', 'ip, #0xf8ff'),
        0x10005a98: ('movt', 'ip, #0x15'),
        0x10005aac: ('ldr', 'r5, [r3, #0x254]'),
        0x10005acc: ('bhi', '#0x10006538'),
        0x10005ad4: ('ldr', 'r5, [sl, #0x14]'),
        0x10005ad8: ('tst', 'r5, #1'),
        0x10005adc: ('beq', '#0x10006530'),
        0x10005af4: ('cmp', 'r0, #0x17'),
        0x10005b00: ('cmp', 'r0, #0x17'),
        0x10005b14: ('b', '#0x10005b28'),
        0x10006530: ('str', 'lr, [r0, #-8]'),
        0x10006544: ('pop', '{r4, r5, r6, r7, r8, sb, sl, fp, pc}'),
    }
    for address, expected in checks.items():
        ins = next(md.disasm(raw[address - BASE:address - BASE + 4], address))
        assert (ins.mnemonic, ins.op_str) == expected, hex(address)
    cases = [
        ('idle', [(0, None), (100, None)], 'timeout_returned', 0),
        ('single_ctrl_w', [(0, 0x17)], 'timeout_returned', 0),
        ('two_ctrl_w', [(0, 0x17), (100, 0x17)], 'shell_gate_passed', 0),
        ('ctrl_w_idle_ctrl_w', [(0, 0x17), (1, None), (2, 0x17)], 'shell_gate_passed', 0),
        ('ctrl_w_other_ctrl_w', [(0, 0x17), (1, 0x41), (2, 0x17)], 'timeout_returned', 0),
        ('other_ctrl_w_ctrl_w', [(0, 0x41), (1, 0x17), (2, 0x17)], 'shell_gate_passed', 0),
        ('two_ascii_w', [(0, 0x77), (1, 0x77)], 'timeout_returned', 0),
        ('two_ctrl_c', [(0, 3), (1, 3)], 'timeout_returned', 0),
        ('deadline_inclusive', [(THRESHOLD - 1, 0x17), (THRESHOLD, 0x17)], 'shell_gate_passed', 0),
        ('late_second_byte', [(THRESHOLD, 0x17), (THRESHOLD + 1, 0x17)], 'timeout_returned', 0),
        ('expired_before_rx', [(THRESHOLD + 1, 0x17)], 'timeout_returned', 0),
        ('caller_forced_shell', [], 'shell_gate_passed', 1),
    ]
    results = [run_case(raw, *c) for c in cases]
    # Audit the downloaded CLI's field assumptions; never execute its session.
    refs = ROOT / 'artifacts/public-reference/2026-11-11-usb-recovery'
    manifest = json.loads((refs / 'source-manifest.json').read_text())
    selected = {}
    for name in ('src/session.c', 'src/ambausb_proto.h', 'src/elf.c'):
        row = next(x for x in manifest['files'] if x['repository'] == 'getnexar/ambausb_cli' and x['path'] == name)
        content = (ROOT / row['local']).read_bytes()
        assert sha(content) == row['sha256']
        selected[name] = dict(sha256=sha(content), commit=row['commit'], url=row['url'])
    session = (refs / 'getnexar_ambausb_cli/src/session.c').read_text()
    proto = (refs / 'getnexar_ambausb_cli/src/ambausb_proto.h').read_text()
    assert '#define BLD_OFFSET_DRAM_REG           0x00000048u' in proto
    assert 'else if (off == BLD_OFFSET_DRAM_REG) {\n                value = dram_size_reg_value;' in session
    version_word = struct.unpack_from('<I', raw, 0x38)[0]
    stack_instruction = next(md.disasm(raw[0x48:0x4c], BASE + 0x48))
    assert version_word == 0xe38000d1 and version_word & 0xffff0000 != 0
    assert (stack_instruction.mnemonic, stack_instruction.op_str) == ('ldr', 'sp, [r2]')
    OUT.mkdir(parents=True, exist_ok=True)
    windows = {}
    for name, lo, hi in [('serial_gate', ENTRY, 0x10005b2c),
                         ('serial_gate_timeout', 0x10006530, 0x10006548),
                         ('pre_kernel_call_order', 0x10006b34, 0x10006b78),
                         ('kernel_load_jump', 0x10006918, 0x1000699c)]:
        body = raw[lo - BASE:hi - BASE]
        path = OUT / (name + '.asm')
        path.write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(body, lo)) + '\n')
        windows[name] = dict(start=hex(lo), end_exclusive=hex(hi), sha256=sha(body), path=str(path.relative_to(ROOT)))
    result = dict(scope='public YI 1.10.52 BLD gate only; synthetic UART/timer; no devices',
                  source=str(SOURCE.relative_to(ROOT)), sha256=PIN,
                  fixed_instruction_checks=len(checks), cases=results, windows=windows,
                  generic_cli_field_mismatch=dict(source=selected, public_yi_version_offset_word=hex(version_word),
                      public_yi_satisfies_cli_version_guard=False,
                      cli_dram_patch_offset='0x48', public_yi_word='0xe592d000',
                      public_yi_instruction='ldr sp, [r2]',
                      cli_dram_patch_requires_valid_version=False,
                      interpretation='Feeding this flat YI BLD into that generic patcher would replace a startup instruction, not a DRAM metadata field; no such session was run.'),
                  uart_address=hex(UART), timer_address=hex(TIMER), counter_threshold=THRESHOLD,
                  semantics='last two received bytes must both be 0x17 before counter exceeds threshold; idle polls do not count as received bytes',
                  deliberately_not_executed='after shell gate 0x10005b28, kernel handoff, target services or MMIO',
                  limitations=['Not current 1.10.7 hidden BLD identity.',
                               'No timer clock-to-seconds, physical pinout, logic voltage or reachable UART wiring proof.',
                               'No USB download, NAND/OOB backup/write or independent recovery was exercised or established.'])
    (OUT / 'audit.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(cases=len(results), instruction_checks=len(checks), output=str(OUT / 'audit.json'))))


if __name__ == '__main__':
    main()
