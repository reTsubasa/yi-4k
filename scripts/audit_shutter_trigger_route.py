#!/usr/bin/env python3
"""Offline stock ARM physical-key / recorder / queue contract audit.

Only the saved image executes, in synthetic RAM. GPIO, timers, scheduler,
logging, UI and recorder operations are substituted; no device IO or patch.
Unknown executed code fails closed. This is not a physical debounce test.
"""
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT = ROOT / 'artifacts/device/2026-11-10-shutter-route'
BASE = 0xA0100000
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
ARGS = (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)
SAVED = (UC_ARM_REG_R4, UC_ARM_REG_R5, UC_ARM_REG_R6, UC_ARM_REG_R7,
         UC_ARM_REG_R8, UC_ARM_REG_R9, UC_ARM_REG_R10, UC_ARM_REG_R11)
SHORT, LONG = 0xE001001E, 0xF0010332
QUEUE, BUFFER = 0xA13A2200, 0x70010000
APP_DISPATCH, REC_OP = 0x70009000, 0x70009010


def main():
    raw = (SOURCE / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(raw).hexdigest() == EXPECTED
    word = lambda a: struct.unpack_from('<I', raw, a - BASE)[0]
    functions = {int(f['entry'], 16): f for f in json.loads(
        (SOURCE / 'full/functions.json').read_text())}
    ranges = {a: [tuple(int(x, 16) for x in s.split('-'))
                  for s in f['body_ranges']] for a, f in functions.items()}
    # These LAB entrypoints have no independent exported function metadata.
    # Their exact bounded instruction intervals are also fingerprinted below.
    ranges.update({0xA0296A10: [(0xA0296A10, 0xA0296AC7)],
                   0xA019CF48: [(0xA019CF48, 0xA019CF5B)],
                   0xA019D10C: [(0xA019D10C, 0xA019D123)],
                   # Only the nonblocking send branches; waiting-sender paths
                   # at/after 0xa03bf554 are intentionally not admitted.
                   0xA03BF3D4: [(0xA03BF3D4, 0xA03BF553)]})
    uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    uc.mem_map(0xA0000000, 0x02000000)
    uc.mem_write(BASE, raw)
    uc.mem_map(0x70000000, 0x800000)
    put = lambda a, v: uc.mem_write(a, struct.pack('<I', v & 0xFFFFFFFF))
    get = lambda a: struct.unpack('<I', uc.mem_read(a, 4))[0]
    byte = lambda a, v: uc.mem_write(a, bytes([v]))
    state = {}
    counters = dict(instructions=0, invocations=0, aligned_calls=0)
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)

    def ret(v=0):
        lr = uc.reg_read(UC_ARM_REG_LR)
        uc.reg_write(UC_ARM_REG_R0, v & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_PC, lr & ~1)

    def hook(machine, address, size, _):
        a = [machine.reg_read(r) for r in ARGS]
        counters['instructions'] += 1
        if address == 0xA0482820:
            assert a[0] == 13
            machine.mem_write(a[1], bytes([0, state['level'], 0, 0, 0]))
            state['gpio_reads'] += 1
            ret()
        elif address in (0xA03BC648, 0xA03BC64C):
            state['timer_calls'].append(dict(entry=hex(address), args=a))
            ret()
        elif address == 0xA01E659C and not state.get('real_queue'):
            state['messages'].append(a[:3])
            ret()
        elif address in (0xA03C13B0, 0xA03C1428):
            state['critical_calls'].append(hex(address))
            ret()
        elif address in (0xA03BC41C, 0xA03C17C4):
            state['scheduler_calls'].append([hex(address), a[0]])
            ret()
        elif address == 0xA019CB58:
            state['queue_failure_dumps'] += 1
            ret()
        elif address == 0xA02A70EC:
            state['log_calls'] += 1
            ret()
        elif address == APP_DISPATCH:
            state['app_dispatch'].append(a[:3])
            ret()
        elif address == REC_OP:
            state['operations'].append(a[:3])
            ret(state.get('prerequisite', 0) if a[0] == 0x3A else 0)
        elif address == 0xA012C220 and state.get('stub_buttons'):
            state['button_record_calls'] += 1
            ret()
        elif address == 0xA012BA98 and state.get('stub_buttons'):
            state['button_photo_calls'] += 1
            ret()
        elif address == 0xA0113664:
            state['readiness_calls'].append(a[0])
            ret(state.get('readiness', 0))
        elif address in (0xA012F8FC, 0xA012F950, 0xA012FD20, 0xA0138CB8):
            state['special_ui_calls'].append([hex(address), a[0]])
            ret()
        elif address in (0xA01345A8, 0xA017697C, 0xA0197848, 0xA012011C):
            state['recorder_side_calls'].append([hex(address), a[0]])
            ret()
        elif address == 0xA0197944:
            ret(1)
        elif address == 0xA02D2868:
            ret(state.get('vf_ready', 1))
        else:
            assert any(lo <= address <= hi for lo, hi in state['real_ranges']), hex(address)
            insn = next(md.disasm(bytes(machine.mem_read(address, size)), address))
            if insn.mnemonic in ('bl', 'blx'):
                assert machine.reg_read(UC_ARM_REG_SP) % 8 == 0
                counters['aligned_calls'] += 1

    uc.hook_add(UC_HOOK_CODE, hook)

    def run(entry, args=(), real=(), **opts):
        state.clear()
        state.update(messages=[], timer_calls=[], gpio_reads=0, critical_calls=[],
                     scheduler_calls=[], queue_failure_dumps=0, log_calls=0,
                     app_dispatch=[], operations=[], button_record_calls=0,
                     button_photo_calls=0, readiness_calls=[], special_ui_calls=[],
                     recorder_side_calls=[])
        state.update(opts)
        state['real_ranges'] = [s for f in (entry, *real) for s in ranges[f]]
        for reg, value in zip(ARGS, list(args) + [0] * (4 - len(args))):
            uc.reg_write(reg, value)
        expected_saved = [0x11441100 + i for i in range(len(SAVED))]
        for reg, value in zip(SAVED, expected_saved):
            uc.reg_write(reg, value)
        uc.reg_write(UC_ARM_REG_CPSR, 0x10)
        uc.reg_write(UC_ARM_REG_SP, 0x707FF000)
        uc.reg_write(UC_ARM_REG_LR, 0x70008000)
        uc.emu_start(entry, 0x70008000, count=100000)
        assert uc.reg_read(UC_ARM_REG_PC) == 0x70008000
        assert uc.reg_read(UC_ARM_REG_SP) == 0x707FF000
        assert [uc.reg_read(r) for r in SAVED] == expected_saved
        counters['invocations'] += 1
        result = uc.reg_read(UC_ARM_REG_R0)
        return dict(result=result if result < 0x80000000 else result - 0x100000000,
                    **{k: v for k, v in state.items() if k != 'real_ranges'})

    # Execute the actual registration stores, then the exact BSP callback path.
    registration = [run(0xA0296B7C, (0xA019D10C,)),
                    run(0xA0296B8C, (0xA019CF48,))]
    assert get(0xA1445470) == 0xA019D10C
    assert get(0xA14454A4) == 0xA019CF48
    physical_cases = []
    for label, sequence, expected in [
        ('release_without_press', [0, 0], []),
        ('normal_short_repeat_low', [1, 0, 0], [SHORT]),
        ('repeated_high_before_short', [1, 1, 0, 0], [SHORT]),
        ('two_complete_short_cycles', [1, 0, 1, 0], [SHORT, SHORT]),
        ('long_then_one_release', [1, 'timer', 0], [LONG]),
        # This is a deliberately adverse synthetic input, not a claim that the
        # captured hardware really produces duplicate low IRQs after a long.
        ('long_then_duplicate_low_boundary', [1, 'timer', 0, 0], [LONG, SHORT]),
        ('raw_bounce_is_two_cycles', [1, 0, 1, 0], [SHORT, SHORT]),
    ]:
        put(0xA06F23A0, 0)
        put(0xA144546C, 0)
        steps, events = [], []
        for step in sequence:
            if step == 'timer':
                r = run(0xA02969D8, real=(0xA019D10C,))
            else:
                r = run(0xA0296A10, (13,), real=(0xA019CF48,), level=step)
            steps.append(dict(step=step, press_latch=get(0xA06F23A0),
                              long_suppression=get(0xA144546C), **r))
            events += r['messages']
        assert [e[0] for e in events] == expected
        assert all(e[1:] == [0, 0] for e in events)
        physical_cases.append(dict(label=label, events=events, steps=steps))
    wrong_pin = run(0xA0296A10, (12,), level=1)
    assert wrong_pin['gpio_reads'] == 0 and not wrong_pin['messages']
    physical_cases.append(dict(label='other_gpio_ignored', **wrong_pin))
    for r in physical_cases:
        for step in r.get('steps', []):
            for call in step['timer_calls']:
                if call['entry'] == '0xa03bc64c':
                    assert call['args'] == [0xA1445474, 1500, 0, 1]

    # Full real zero-wait queue copy: real wrapper, timestamp, validation and
    # underlying send body. Kernel critical sections / scheduler are stubs.
    queue_cases = []
    assert word(0xA01E5E1C) + 0x40 == QUEUE
    assert word(0xA01E624C) == QUEUE
    assert word(0xA01E64E0) == QUEUE
    queue_real = (0xA01E659C, 0xA01E656C, 0xA01E5DA4, 0xA03BC6A0,
                  0xA03BC598, 0xA03C3F68, 0xA03BF3D4)
    for label, entry, args, slots, waiting in [
        ('short_queue_copy', 0xA019CF48, (0, 0), 1, False),
        ('short_wrapper_payload_duplication', 0xA019CF48, (7, 9), 1, False),
        ('long_queue_copy', 0xA019D10C, (7, 9), 1, False),
        ('direct_waiting_receiver_copy', 0xA019CF48, (0, 0), 1, True),
        ('queue_full_drops_without_retry', 0xA019CF48, (0, 0), 0, False),
    ]:
        uc.mem_write(QUEUE, bytes(0x3C))
        for off, value in [(0, 0x51554555), (8, 4), (0x14, slots),
                           (0x18, BUFFER), (0x1C, BUFFER + 16), (0x24, BUFFER)]:
            put(QUEUE + off, value)
        uc.mem_write(BUFFER, bytes([0xAA]) * 16)
        receiver, destination = 0x70020000, 0x70021000
        if waiting:
            uc.mem_write(receiver, bytes(0x100))
            put(QUEUE + 0x28, receiver)
            put(QUEUE + 0x2C, 1)
            put(receiver + 0x80, destination)
            uc.mem_write(destination, bytes([0xAA]) * 16)
        put(0xA1796810, 123456)
        put(0xA13A21C0 + 0x1CC, 0)
        put(0xA13A21C0 + 0x1D0, 0)
        r = run(entry, args, real=queue_real, real_queue=True)
        dest = destination if waiting else BUFFER
        copied = [get(dest + i * 4) for i in range(4)]
        message = [SHORT, args[0], args[0], 123456] if entry == 0xA019CF48 else [LONG, *args, 123456]
        assert copied == (message if slots else [0xAAAAAAAA] * 4)
        assert r['result'] == (0 if slots else 11)
        assert r['queue_failure_dumps'] == int(not slots)
        assert get(0xA13A21C0 + 0x1CC) == int(bool(slots))
        assert get(0xA13A21C0 + 0x1D0) == int(not slots)
        queue_cases.append(dict(label=label, copied_words=copied, **r))

    # Real recorder app routing, with synthetic callback destinations. The
    # table's video-button slot is pinned; the misleading 'shutter' symbol is
    # the photo slot, and must not be used as the video toggle entrypoint.
    assert word(0xA069CBD8) == 0xA012C220
    assert word(0xA069CBD8 + 12) == 0xA012BA98
    app_cases = []
    for mode, ready, ui1, ui2, rtmp in [(m, 0, 0, 0, 0) for m in range(9)] + [
        (4, 1, 0, 0, 0), (4, 0, 1, 0, 0), (4, 0, 0, 1, 0), (4, 0, 0, 0, 1)]:
        put(0xA069B3C4, 4)
        put(0xA0FB336C, 0xA069CBD8)
        put(0xA069B3D8, APP_DISPATCH)
        byte(0xA1055CFA, mode)
        byte(0xA1055D7E, ui1)
        byte(0xA1055D7F, ui2)
        byte(0xA1055D84, rtmp)
        byte(0xA1055D87, 0)
        r = run(0xA0113808, (SHORT, 17, 29), stub_buttons=True, readiness=ready)
        expected = [] if ready or ui1 or ui2 or rtmp else [[0xE001000E if mode < 4 else 0xE001000C, 17, 29]]
        assert r['app_dispatch'] == expected
        app_cases.append(dict(mode=mode, ui1=ui1, ui2=ui2, rtmp=rtmp, **r))
    for initialized in (0, 4):
        put(0xA069B3C4, initialized)
        r = run(0xA0113808, (0xE001000C, 17, 29), stub_buttons=True)
        assert r['button_record_calls'] == bool(initialized)
        assert r['button_photo_calls'] == 0
        app_cases.append(dict(label='record_event_table_slot', initialized=initialized, **r))

    toggle_cases = []
    pref = 0x70030000
    for label, status, flags1, flags2, mode, pref77, formatting, prereq, expected in [
        ('idle_start', 0, 0, 0, 4, 0, 0, 0, [0x3A, 0x12]),
        ('starting_not_actually_started_no_stop', 1, 0, 0, 4, 0, 0, 0, []),
        ('confirmed_recording_stop', 1, 4, 0x80, 4, 0, 0, 0, [0x13]),
        ('only_first_start_flag_no_stop', 1, 4, 0, 4, 0, 0, 0, []),
        ('mode5_alternative_stop_gate', 1, 0x80000000, 0, 5, 0, 0, 0, [0x13]),
        ('preference_alternative_stop_gate', 1, 0, 0, 4, 3, 0, 0, [0x13]),
        ('vf_to_record', 5, 0, 0, 4, 0, 0, 0, [0x3A, 0x58]),
        ('formatting_blocks', 0, 0, 0, 4, 0, 1, 0, []),
        ('start_prerequisite_failure', 0, 0, 0, 4, 0, 0, 7, [0x3A]),
        ('record_busy_blocks', 0, 0x400000, 0, 4, 0, 0, 0, []),
    ]:
        byte(0xA0FB334C, status)
        put(0xA069B3C8, flags1)
        put(0xA069B3CC, flags2)
        put(0xA0FB3370, 0)
        put(0xA1055CD4, pref)
        byte(pref + 0x77, pref77)
        byte(0xA1055CFA, mode)
        byte(0xA1055CD8, 0)
        byte(0xA1055E79, formatting)
        put(0xA0FB3364, REC_OP)
        r = run(0xA012C220, prerequisite=prereq)
        assert [op[0] for op in r['operations']] == expected, (label, r)
        assert all(op[1:] == [0, 0] for op in r['operations'])
        toggle_cases.append(dict(label=label, status=status, flags1=hex(flags1),
                                 flags2=hex(flags2), mode=mode, pref77=pref77, **r))

    # Bounded static instruction assertions for the serialized event owner and
    # early voice commands. No startup, UI, or shutdown body executes here.
    static_assertions = {
        0xA019DA28: 'bl #0xa01881f4',
        0xA019DA34: 'bl #0xa01e5f08',
        0xA019DA54: 'bl #0xa019ca44',
        0xA019DA5C: 'bl #0xa0199a14',
        0xA019DA64: 'blt #0xa019dd84',
        0xA019E390: 'beq #0xa019f4e0',
        0xA019E8F0: 'beq #0xa019efd4',
        0xA019EF90: 'bl #0xa01b22e0',
        0xA019E60C: 'bl #0xa01b25e4',
        0xA01A0F80: 'ldr r3, [r3, #0x28]',
        0xA01A0F84: 'blx r3',
        0xA01A0988: 'blx r3',
        0xA0187BAC: 'bl #0xa0296b7c',
        0xA0187BB8: 'bl #0xa0296b8c',
        0xA0187BBC: 'bl #0xa0296b9c',
        0xA01E62A4: 'mov r2, #0x10',
        0xA01E62A8: 'mov r3, #0x80',
        0xA01E62B0: 'bl #0xa03bc534',
        0xA03BC548: 'lsr r2, r2, #2',
    }
    static_evidence = []
    for address, expected in static_assertions.items():
        insn = next(md.disasm(raw[address - BASE:address - BASE + 4], address))
        decoded = f'{insn.mnemonic} {insn.op_str}'
        assert decoded == expected, (hex(address), decoded)
        static_evidence.append(dict(address=hex(address), instruction=decoded))
    fingerprint_ranges = [(0xA02969D8, 0xA0296AC8), (0xA019CF48, 0xA019CF5C),
        (0xA019D10C, 0xA019D124), (0xA0296B08, 0xA0296BCC),
        (0xA01E656C, 0xA01E65A0), (0xA01E5DA4, 0xA01E5E20),
        (0xA03C3F68, 0xA03C3FF0), (0xA03BF3D4, 0xA03BF554),
        (0xA0113808, 0xA01172A8), (0xA012C220, 0xA012C6B8),
        (0xA019DA24, 0xA019DA68), (0xA019F4E0, 0xA019F564),
        (0xA019EFD4, 0xA019F05C), (0xA01A0F70, 0xA01A0F8C),
        (0xA01E627C, 0xA01E64D8), (0xA04918A0, 0xA04919CC),
        (0xA03BC534, 0xA03BC564)]
    fingerprints = [dict(start=hex(lo), end_exclusive=hex(hi),
        sha256=hashlib.sha256(raw[lo - BASE:hi - BASE]).hexdigest()) for lo, hi in fingerprint_ranges]
    OUT.mkdir(parents=True, exist_ok=True)
    result = dict(status='PASS', source_sha256=EXPECTED, counters=counters,
        physical_cases=physical_cases, registration=registration, queue_cases=queue_cases,
        app_cases=app_cases, toggle_cases=toggle_cases, static_evidence=static_evidence,
        fingerprints=fingerprints,
        limits=['Synthetic GPIO sequences do not prove hardware debounce or IRQ/timer ordering.',
                'Long-release duplicate-low boundary demonstrably can emit a short in this model.',
                'Zero-wait queue can drop events; no delivery guarantee is established.',
                'No camera calls, settings writes, encoder, filesystem or patch executed.',
                'Backend commit/stop confirmation and provenance adapter remain unimplemented.'])
    (OUT / 'audit.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status='PASS', physical_cases=len(physical_cases),
        queue_cases=len(queue_cases), app_cases=len(app_cases), toggle_cases=len(toggle_cases),
        fingerprints=len(fingerprints), **counters)))


if __name__ == '__main__':
    main()
