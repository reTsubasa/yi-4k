#!/usr/bin/env python3
"""Offline, pinned 1.10.7 API-registration and voice-preference audit.

Executes stock ARM control flow in synthetic Unicorn RAM, with explicitly
stubbed JSON, IO, allocation, getters/options/setters and app callbacks.
Does not connect to a target, write a target, or exercise recognition/audio.
"""
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
                               UC_ARM_REG_R3, UC_ARM_REG_SP, UC_ARM_REG_LR,
                               UC_ARM_REG_PC, UC_ARM_REG_CPSR)

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE, TABLE, COUNT, STRIDE = 0xA0100000, 0xA06A5FA4, 96, 100
OUT = ROOT / 'artifacts/device/2026-11-10-voice-settings-gate'
REGS = (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)


def main():
    binary = (ANALYSIS / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(binary).hexdigest() == SHA
    word = lambda address: struct.unpack_from('<I', binary, address - BASE)[0]

    def cstring(address):
        offset = address - BASE
        end = binary.index(b'\0', offset)
        return binary[offset:end].decode('ascii')

    rows = []
    for index in range(COUNT):
        address = TABLE + index * STRIDE
        rows.append(dict(index=index, address=hex(address), id=word(address),
                         key=cstring(address + 8), getter=word(address + 88),
                         options=word(address + 92), setter=word(address + 96)))
    assert len({r['key'] for r in rows}) == COUNT
    assert not any(r['key'] == 'voice_control' or r['id'] == 84 for r in rows)
    assert [(r['id'], r['key']) for r in rows[67:69]] == [
        (83, 'screen_auto_lock'), (85, 'dewarp_support_status')]
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    pins = {
        0xA016326C: ('mov', 'r0, #0x60'),
        0xA0163270: ('bx', 'lr'),
        0xA01662B0: ('bl', '#0xa016326c'),
        0xA0166364: ('ldr', 'r3, [r4, #0x50]'),
        0xA0166354: ('bl', '#0xa0192b70'),
        0xA016635C: ('add', 'r4, r4, #0x64'),
        0xA0164824: ('bl', '#0xa016326c'),
        0xA01648A8: ('add', 'r5, r5, #0x64'),
        0xA01648C8: ('ldr', 'r3, [r4, #4]'),
        0xA0164904: ('bl', '#0xa02a70ec'),
        0xA016490C: ('bl', '#0xa02471d0'),
        0xA0164914: ('bl', '#0xa03bc714'),
        0xA0164920: ('pop', '{r4, r5, r6, r7, r8, pc}'),
        0xA0148AFC: ('bl', '#0xa011f758'),
        0xA0148B08: ('bl', '#0xa011f21c'),
        0xA0148B18: ('strb', 'r6, [r3, #0x136]'),
        0xA0148B1C: ('bl', '#0xa018c6d8'),
        0xA0148B2C: ('moveq', 'r0, #0x93'),
        0xA0148B30: ('movne', 'r0, #0x94'),
        0xA012D5F0: ('bl', '#0xa016ad30'),
        0xA01391B8: ('bl', '#0xa016ad30'),
        0xA016ADA0: ('b', '#0xa014eecc'),
        0xA014EF1C: ('bl', '#0xa0148aac'),
        0xA014F0B4: ('mov', 'r0, #0x54'),
        0xA019317C: ('movw', 'r0, #0x2307'),
        0xA0193180: ('bx', 'lr'),
        0xA0129640: ('bl', '#0xa01184c8'),
        0xA012A100: ('bl', '#0xa0118564'),
    }
    instruction_evidence = []
    for address, expected in pins.items():
        instruction = next(md.disasm(binary[address-BASE:address-BASE+4], address))
        assert (instruction.mnemonic, instruction.op_str) == expected, (hex(address), instruction.mnemonic, instruction.op_str, expected)
        instruction_evidence.append(dict(address=hex(address), bytes=bytes(instruction.bytes).hex(),
                                         instruction=' '.join(expected)))
    assert word(0xA0164998) == TABLE + 8
    assert word(0xA016499C) == TABLE + 88
    assert word(0xA01664B8) == TABLE + 8
    assert word(0xA01282FC + 0x93 * 4) == 0xA0129640
    assert word(0xA01282FC + 0x94 * 4) == 0xA012A100

    shell_rows = []
    for i in range(69):
        address = 0xA056B404 + i * 8
        shell_rows.append(dict(name=cstring(word(address)), handler=word(address+4),
                               address=hex(address)))
    vc_row = next(r for r in shell_rows if r['name'] == 'vc_test')
    assert vc_row['handler'] == 0xA01ABD80
    assert word(0xA06A33FC) == 0xA012D5BC
    gui_row = 0xA06A33FC - 96
    assert cstring(gui_row) == 'MENU_SETUP_VOICE_CONTROL_SWITCHER'

    uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    uc.mem_map(0xA0000000, 0x02000000)
    uc.mem_write(BASE, binary)
    uc.mem_map(0x70000000, 0x10000)
    put = lambda at, value: uc.mem_write(at, struct.pack('<I', value & 0xFFFFFFFF))
    get = lambda at: struct.unpack('<I', uc.mem_read(at, 4))[0]
    end, callback = 0x70008000, 0x70007000
    state = {}

    def readstr(at):
        value = bytearray()
        for offset in range(256):
            byte = bytes(uc.mem_read(at + offset, 1))
            if byte == b'\0':
                return value.decode('ascii')
            value.extend(byte)
        raise AssertionError('unterminated synthetic C string')

    def return_stub(value):
        lr = uc.reg_read(UC_ARM_REG_LR)
        uc.reg_write(UC_ARM_REG_R0, value & 0xFFFFFFFF)
        cpsr = uc.reg_read(UC_ARM_REG_CPSR)
        uc.reg_write(UC_ARM_REG_CPSR, (cpsr & ~32) | ((lr & 1) << 5))
        uc.reg_write(UC_ARM_REG_PC, lr & ~1)

    getters = {r['getter'] for r in rows if r['getter']}
    option_handlers = {r['options'] for r in rows if r['options']}
    setter_handlers = {r['setter'] for r in rows if r['setter']}
    neutral = {0xA02471D0, 0xA03BC714, 0xA02A70EC, 0xA019294C,
               0xA0192A48, 0xA0192B78, 0xA0192BD0, 0xA01929E8, 0xA0192B10}

    def hook(machine, address, size, user):
        args = [machine.reg_read(reg) for reg in REGS]
        value = None
        if address == 0xA04F8DEC:
            machine.mem_write(args[0], bytes([args[1] & 255]) * args[2]); value = args[0]
        elif address == 0xA04F95D0:
            value = int(readstr(args[0]) != readstr(args[1]))
        elif address == 0xA015522C:
            value = 0  # Saved settings metadata is already initialized.
        elif address == 0xA0246FF4:
            put(args[0], 0x70005000); value = state.get('parse_error', 0)
        elif address == 0xA02470F0:
            field = readstr(args[1]); value = state.get('field_error', 0)
            text = state['key'] if field in ('type', 'param') else ''
            machine.mem_write(args[2], text.encode() + b'\0')
        elif address == 0xA023FA94:
            state['replies'].append([args[0], signed(args[1])]); value = 0
        elif address == 0xA029A7D8:
            put(args[1], 0x70002000); put(args[2], 0x70003000); value = 0
        elif address == 0xA0192B70:
            state['enumerated'].append(readstr(args[1])); value = 0
        elif address == 0xA0192780:
            state['sent_json'] += 1; value = 0
        elif address in getters:
            machine.mem_write(args[0], b'synthetic-value\0'); value = 0
        elif address in option_handlers or address in setter_handlers:
            state['handlers'].append(hex(address)); value = 0
        elif address == 0xA011F758:
            state['readiness_calls'].append('vf'); value = state.get('vf', 0)
        elif address == 0xA011F21C:
            state['readiness_calls'].append('ready'); value = state.get('ready', 1)
        elif address == 0xA018C6D8:
            state['persists'] += 1; value = 0
        elif address == callback:
            state['operations'].append(args[:3]); value = -123  # Deliberately fails.
        elif address == 0xA04FB1C4:
            value = int(readstr(args[0]))
        elif address in neutral:
            value = 0
        if value is not None:
            return_stub(value)
        else:
            low, high = state['range']
            assert low <= address < high or 0xA016326C <= address < 0xA0163274, hex(address)

    uc.hook_add(UC_HOOK_CODE, hook)

    def run(start, stop, arguments=(), **settings):
        state.clear()
        state.update(replies=[], enumerated=[], handlers=[], sent_json=0,
                     readiness_calls=[], persists=0, operations=[], range=(start, stop), **settings)
        for reg, value in zip(REGS, list(arguments) + [0] * (4-len(arguments))):
            uc.reg_write(reg, value)
        uc.reg_write(UC_ARM_REG_CPSR, 0x10)
        uc.reg_write(UC_ARM_REG_SP, 0x7000F000)
        uc.reg_write(UC_ARM_REG_LR, end)
        uc.emu_start(start, end, count=50000)
        assert uc.reg_read(UC_ARM_REG_PC) == end
        assert uc.reg_read(UC_ARM_REG_SP) == 0x7000F000
        result = dict(state)
        result['return'] = signed(uc.reg_read(UC_ARM_REG_R0))
        result.pop('range')
        return result

    api_cases = []
    for key in ('voice_control', 'not_a_setting', 'video_quality'):
        result = run(0xA01647FC, 0xA0164998, (0x70000100, 0x70000200), key=key)
        if key == 'video_quality':
            assert result['return'] == 0 and result['handlers'] == ['0xa015b08c']
        else:
            assert result['return'] == -1 and not result['handlers'] and not result['replies']
        api_cases.append(dict(message=9, **result))
    for field, value in (('parse_error', -1), ('field_error', -1)):
        result = run(0xA01647FC, 0xA0164998, (0x70000100, 0x70000200),
                     key='voice_control', **{field: value})
        assert result['replies'] == [[9, -7]]
        api_cases.append(dict(message=9, **result))
    for message, start, stop, error in ((2, 0xA01649A0, 0xA0164BB0, -1),
                                        (1, 0xA0164BB0, 0xA0164E10, -13)):
        result = run(start, stop, (0x70000100, 0x70000200), key='voice_control')
        assert result['replies'] == [[message, error]] and not result['handlers']
        api_cases.append(dict(message=message, **result))
    enumeration = run(0xA0166274, 0xA01664B8)
    assert enumeration['enumerated'] == [r['key'] for r in rows]
    assert enumeration['sent_json'] == 1 and enumeration['return'] == 0

    pref, argument, same, argv = 0x70004000, 0x70000100, 0x70000300, 0x70000400
    put(0xA1055CD4, pref); put(0xA0FB3364, callback); put(argv, argument)
    leaf_cases = []
    for enabled in (0, 1):
        for requested in (0, 1):
            for vf, ready in ((0, 1), (1, 1), (0, 0)):
                uc.mem_write(pref+0x136, bytes([enabled]))
                uc.mem_write(argument, (b'on' if requested else b'off') + b'\0')
                put(same, 0xDEADBEEF)
                result = run(0xA0148AAC, 0xA0148BA4, (argument, same), vf=vf, ready=ready)
                unchanged = enabled == requested
                expected = 0 if unchanged or (not vf and ready) else (-36 if vf else -21)
                assert result['return'] == expected
                assert get(same) == int(unchanged)
                changed = not unchanged and expected == 0
                assert result['persists'] == int(changed)
                assert result['operations'] == ([[0x93 if requested else 0x94, 0, 0]] if changed else [])
                assert bytes(uc.mem_read(pref+0x136, 1))[0] == (requested if changed else enabled)
                leaf_cases.append(dict(enabled=enabled, requested=requested, **result))
    debug_cases = []
    for number in (1, 0, 2):
        uc.mem_write(argument, str(number).encode() + b'\0')
        result = run(0xA01ABD80, 0xA01ABE20, (1, argv), vf=1, ready=0)
        assert result['return'] == 0 and result['persists'] == 1
        assert not result['readiness_calls']
        assert result['operations'] == [[0x93 if number == 1 else 0x94, 0, 0]]
        debug_cases.append(dict(input=number, **result))

    functions = json.loads((ANALYSIS / 'full/functions.json').read_text())
    selected = [0xA016326C, 0xA0163294, 0xA0166274, 0xA01647FC,
                0xA01649A0, 0xA0164BB0, 0xA01549FC, 0xA0148AAC,
                0xA014EECC, 0xA01ABD80, 0xA012D5BC, 0xA016AD30,
                0xA01321C0, 0xA0138F84, 0xA011F084, 0xA011F0C8,
                0xA019317C, 0xA01184C8, 0xA0118564, 0xA01282E0]
    fingerprints = []
    assembly = []
    for address in selected:
        function = next(f for f in functions if int(f['entry'], 16) == address)
        chunks = []
        assembly.append('\nFUNCTION ' + hex(address))
        for span in function['body_ranges']:
            low, high = [int(v, 16) for v in span.split('-')]
            chunk = binary[low-BASE:high-BASE+1]; chunks.append(chunk)
            for ins in md.disasm(chunk, low):
                assembly.append(f'{ins.address:08x} {bytes(ins.bytes).hex()} {ins.mnemonic} {ins.op_str}')
        source = ANALYSIS / 'full' / function['decompiled_file']
        fingerprints.append(dict(entry=hex(address), spans=function['body_ranges'],
                                 code_sha256=hashlib.sha256(b''.join(chunks)).hexdigest(),
                                 pseudocode_sha256=hashlib.sha256(source.read_bytes()).hexdigest()))

    evidence = ROOT / 'artifacts/device/2026-11-10-feature-api'
    saved = json.loads((evidence / 'readonly.json').read_text())
    assert 'voice_control' not in saved['settings']
    events = json.loads((evidence / 'events.json').read_text())
    query = next(i for i, e in enumerate(events) if e['direction'] == 'send' and
                 e['message'] == {'msg_id': 9, 'param': 'voice_control'})
    assert not any(e['direction'] == 'receive' and e['message'].get('msg_id') == 9
                   for e in events[query+1:])
    report = dict(image_sha256=SHA, table=dict(base=hex(TABLE), count=COUNT,
                  stride=STRIDE, sha256=hashlib.sha256(binary[TABLE-BASE:TABLE-BASE+COUNT*STRIDE]).hexdigest(),
                  rows=rows, voice_key_registered=False, internal_id84_registered=False),
                  instruction_checks=instruction_evidence, function_fingerprints=fingerprints,
                  api_synthetic_cases=api_cases, msg3_synthetic_enumeration=enumeration,
                  native_leaf_synthetic_cases=leaf_cases, debug_synthetic_cases=debug_cases,
                  vc_test_registration=vc_row, gui_menu_row=dict(address=hex(gui_row),
                      name=cstring(gui_row), handler=hex(word(0xA06A33FC))),
                  saved_api_evidence=dict(readonly_sha256=hashlib.sha256((evidence/'readonly.json').read_bytes()).hexdigest(),
                      events_sha256=hashlib.sha256((evidence/'events.json').read_bytes()).hexdigest(),
                      query_event_index=query, query=events[query], subsequent_events=events[query+1:]),
                  boundaries=dict(device_access=False, target_write=False, recognition_verified=False,
                      exact_chinese_phrase_verified=False, exact_english_phrase_verified=False,
                      compile_policy_or_model_reason_recovered=False),
                  stubs='JSON/parsing, allocation, IO/logging, generic getters/options/setters, readiness, preference save, failing app callback; stock API loops/count/native leaf/debug control flow executes in synthetic RAM')
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / 'audit.json').write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
    (OUT / 'audit.asm').write_text('\n'.join(assembly) + '\n')
    print(f'PASS: {COUNT} rows; {len(pins)} instruction pins; {len(api_cases)} API cases; '
          f'{len(enumeration["enumerated"])} msg3 keys; {len(leaf_cases)} native leaf cases; '
          f'{len(debug_cases)} debug bypass cases; no target access')


def signed(value):
    return value if value < 0x80000000 else value - 0x100000000


if __name__ == '__main__':
    main()
