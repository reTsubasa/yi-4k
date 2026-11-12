#!/usr/bin/env python3
"""Fixed 1.10.7 stock-watchdog recovery suitability, entirely offline.

Runs original handler, application init and feed thunk on synthetic host RAM.
String conversion, UART, WDT wrapper, timer registration and prints are mocks.
No camera access, actual timer, reset, writer or executable probe is emitted.
"""
import hashlib
import json
from pathlib import Path
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
OUT = ROOT / 'artifacts/verification/2026-11-12-native-watchdog-recovery-boundary-run01'
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE, STACK, STOP, ARGV, TEXT, PRINT = 0xa0100000, 0x20010000, 0x20020000, 0x20000000, 0x20000100, 0x20030000
REGS = (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)


def sha(raw): return hashlib.sha256(raw).hexdigest()


def machine(image):
    u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    u.mem_map(0xa0000000, 0x2000000); u.mem_write(BASE, image)
    u.mem_map(0x20000000, 0x40000)
    u.reg_write(UC_ARM_REG_SP, STACK); u.reg_write(UC_ARM_REG_LR, STOP)
    return u


def ret(u, value=0):
    u.reg_write(UC_ARM_REG_R0, value & 0xffffffff)
    u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR))


def string(u, at): return bytes(u.mem_read(at, 512)).split(b'\0', 1)[0].decode('ascii')


def command_case(image, name, start_result, read_result=None, stop_result=0, seconds=10):
    u = machine(image)
    u.mem_write(ARGV, struct.pack('<2I', TEXT, TEXT + 16))
    u.mem_write(TEXT, b'wdt\0'); u.mem_write(TEXT + 16, str(seconds).encode() + b'\0')
    u.reg_write(UC_ARM_REG_R0, 2); u.reg_write(UC_ARM_REG_R1, ARGV); u.reg_write(UC_ARM_REG_R2, PRINT)
    events, returned, blocked = [], False, False

    def hook(_, address, size, context):
        nonlocal returned, blocked
        a = [u.reg_read(r) for r in REGS]
        if address == STOP:
            returned = True; u.emu_stop()
        elif address == 0xa04f9744:
            ret(u, int(string(u, a[0]) != string(u, a[1])))
        elif address == 0xa04fb328:
            ret(u, int(string(u, a[0]), 0))
        elif address == PRINT:
            events.append(dict(call='print', format=string(u, a[0]))); ret(u)
        elif address == 0xa048ec20:
            raw = bytes(u.mem_read(a[0], 12))
            events.append(dict(call='start_wrapper_mock', config_hex=raw.hex(),
                               mode=raw[0], pulse=raw[1], duration_ms=struct.unpack_from('<I', raw, 4)[0],
                               extra_word=struct.unpack_from('<I', raw, 8)[0], result=start_result))
            ret(u, start_result)
        elif address == 0xa048eab8:
            events.append(dict(call='uart_read_mock', channel=a[0], bytes=a[1], timeout=hex(a[3]), result=read_result))
            if read_result is None:
                blocked = True; u.emu_stop()
            else: ret(u, read_result)
        elif address == 0xa048ec7c:
            events.append(dict(call='stop_wrapper_mock', result=stop_result)); ret(u, stop_result)

    u.hook_add(UC_HOOK_CODE, hook)
    u.emu_start(0xa04af634, STOP + 4, count=10000)
    assert returned or blocked
    if returned:
        assert u.reg_read(UC_ARM_REG_SP) == STACK and u.reg_read(UC_ARM_REG_R0) == 0
    return dict(name=name, requested_seconds=seconds, start_result=start_result, read_result=read_result,
                stop_result=stop_result, returned=returned, stopped_at_uart_wait=blocked,
                result=u.reg_read(UC_ARM_REG_R0) if returned else None, events=events)


def app_case(image, enabled, start_result=0):
    u = machine(image)
    # Original predicate A0195388 reads this fixed context pointer and +8 byte.
    u.mem_write(0xa1a39c88, bytes([enabled]))
    events, returned = [], False

    def hook(_, address, size, context):
        nonlocal returned
        a = [u.reg_read(r) for r in REGS]
        if address == STOP:
            returned = True; u.emu_stop()
        elif address == 0xa048ec14:
            events.append(dict(call='wdt_initialization_mock')); ret(u)
        elif address == 0xa048ec20:
            events.append(dict(call='start_wrapper_mock', config_hex=bytes(u.mem_read(a[0], 12)).hex(), result=start_result)); ret(u, start_result)
        elif address == 0xa01e6acc:
            events.append(dict(call='timer_registration_mock', timer_id=a[0], callback=hex(a[1]))); ret(u)
        elif address == 0xa02a70ec:
            events.append(dict(call='print_mock')); ret(u)

    u.hook_add(UC_HOOK_CODE, hook)
    u.emu_start(0xa019d198, STOP + 4, count=10000)
    assert returned and u.reg_read(UC_ARM_REG_SP) == STACK
    return dict(enabled_byte=enabled, start_result=start_result,
                result=u.reg_read(UC_ARM_REG_R0), events=events)


def feed_case(image, callback_argument):
    u = machine(image)
    # The fixed pointer resolves to E800C000. This is only a synthetic register
    # page, not a hardware MMIO transaction or reset/timer model.
    u.mem_map(0xe800c000, 0x1000)
    u.reg_write(UC_ARM_REG_R0, callback_argument)
    writes, returned = [], False

    def hook(_, address, size, context):
        nonlocal returned
        if address == STOP:
            returned = True; u.emu_stop()

    def write(_, access, address, size, value, context):
        writes.append(dict(address=hex(address), bytes=size, value=hex(value)))

    u.hook_add(UC_HOOK_CODE, hook); u.hook_add(UC_HOOK_MEM_WRITE, write)
    u.emu_start(0xa019c3bc, STOP + 4, count=1000)
    assert returned
    return dict(callback_argument=callback_argument, synthetic_register_writes=writes)


def setup_case(image, mode, existing_control):
    u = machine(image); u.mem_map(0xe800c000, 0x1000)
    u.mem_write(0xe800c00c, struct.pack('<I', existing_control))
    u.mem_write(TEXT, struct.pack('<BBHII', mode, 10, 0, 10000, 0))
    u.reg_write(UC_ARM_REG_R0, TEXT)
    writes, services, returned = [], [], False

    def hook(_, address, size, context):
        nonlocal returned
        if address == STOP:
            returned = True; u.emu_stop()
        elif address == 0xa04a4b68:
            services.append('clock_frequency_mock_24000000'); ret(u, 24000000)
        elif address == 0xa049758c:
            services.append('irq_disable_mock'); ret(u)
        elif address == 0xa0481c8c:
            services.append('reset_route_mock_mode_' + str(u.reg_read(UC_ARM_REG_R0))); ret(u)

    def write(_, access, address, size, value, context):
        if 0xe800c000 <= address < 0xe800d000:
            writes.append(dict(address=hex(address), bytes=size, value=hex(value)))

    u.hook_add(UC_HOOK_CODE, hook); u.hook_add(UC_HOOK_MEM_WRITE, write)
    u.emu_start(0xa0497818, STOP + 4, count=1000)
    assert returned
    return dict(mode=mode, initial_control=hex(existing_control),
                returned=u.reg_read(UC_ARM_REG_R0), synthetic_register_writes=writes,
                modeled_services=services,
                control_after=hex(struct.unpack('<I', bytes(u.mem_read(0xe800c00c, 4)))[0]))


def main():
    image = IMAGE.read_bytes(); assert sha(image) == SHA
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = {
        0xa04af6d8: ('bl', '#0xa048ec20'), 0xa04af6dc: ('mov', 'r1, r5'),
        0xa04af6e4: ('mvn', 'r3, #0'), 0xa04af6ec: ('bl', '#0xa048eab8'),
        0xa04af6f0: ('bl', '#0xa048ec7c'), 0xa04af700: ('mov', 'r0, r4'),
        0xa019d9c8: ('bl', '#0xa019d198'), 0xa019d1ac: ('bl', '#0xa019d13c'),
        0xa019d1bc: ('bl', '#0xa01e6acc'), 0xa019c3bc: ('cmp', 'r0, #3'),
        0xa019c3c4: ('b', '#0xa048ec78'), 0xa048ec78: ('b', '#0xa0497910'),
        0xa0497920: ('str', 'r2, [r3, #8]'), 0xa049783c: ('str', 'r3, [r4, #0xc]'),
        0xa0497938: ('str', 'r2, [r3, #0xc]'),
    }
    for at, expected in checks.items():
        ins = next(md.disasm(image[at - BASE:at - BASE + 4], at))
        assert (ins.mnemonic, ins.op_str) == expected, hex(at)
    commands = [command_case(image, 'armed_but_same_shell_waits', 0),
                command_case(image, 'start_failed_still_waits', -1),
                command_case(image, 'key_return_then_stop', 0, 0),
                command_case(image, 'start_read_stop_all_failed_still_success', -1, -1, -1),
                command_case(image, 'milliseconds_multiply_wraps', 0, seconds=4294968)]
    assert all(row['stopped_at_uart_wait'] for row in commands[:2])
    assert all(not any(e['call'] == 'stop_wrapper_mock' for e in row['events']) for row in commands[:2])
    assert all(row['returned'] and row['result'] == 0 for row in commands[2:4])
    assert next(e for e in commands[4]['events'] if e['call']=='start_wrapper_mock')['duration_ms']==704
    apps = [app_case(image, 0), app_case(image, 1), app_case(image, 1, -1)]
    assert apps[0]['events'] == [] and apps[0]['result'] == 0
    for row in apps[1:]:
        assert row['events'][1]['config_hex'] == '010a00003075000000000000'
        assert row['events'][2] == dict(call='timer_registration_mock', timer_id=7, callback='0xa019c3bc')
        assert row['result'] == 1
    feeds = [feed_case(image, 0), feed_case(image, 3)]
    assert feeds[0]['synthetic_register_writes'] == [dict(address='0xe800c008', bytes=4, value='0x4755')]
    assert feeds[1]['synthetic_register_writes'] == []
    setups = [setup_case(image, 0, 3), setup_case(image, 1, 3)]
    assert setups[0]['synthetic_register_writes'] == [dict(address='0xe800c00c', bytes=4, value='0x2')]
    assert setups[1]['synthetic_register_writes'][0] == dict(address='0xe800c00c', bytes=4, value='0x2')
    assert [r['address'] for r in setups[1]['synthetic_register_writes']] == ['0xe800c00c', '0xe800c004', '0xe800c008', '0xe800c018']
    OUT.mkdir(parents=True, exist_ok=True)
    windows = [(0xa0195388, 0xa01953a4), (0xa019c3bc, 0xa019c3c8),
               (0xa019d13c, 0xa019d1e0), (0xa04af634, 0xa04af784),
               (0xa048ec20, 0xa048ecb8), (0xa0497818, 0xa0497940)]
    for lo, hi in windows:
        (OUT / f'{lo:08x}.asm').write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(image[lo - BASE:hi - BASE], lo)) + '\n')
    report = dict(schema='native-watchdog-recovery-boundary/v1', image_sha256=SHA,
                  script_sha256=sha(Path(__file__).read_bytes()), instruction_checks=len(checks),
                  command_cases=commands, application_init_cases=apps, feed_cases=feeds, hardware_setup_cases=setups,
                  device_access=False, target_write=False, reset_executed=False, payload_emitted=False,
                  findings={'shell_command_background_arm': False,
                            'shell_command_checks_start_read_stop_errors': False,
                            'app_enable_predicate': '*(uint8_t *)(*(uint32_t *)A078B608 + 8) != 0',
                            'app_predicate_context_address_from_image': '0xa1a39c80',
                            'stock_duration_ms': 30000, 'stock_feed_timer_id': 7,
                            'shared_hardware_pointer': '0xa062ace4 -> 0xe800c000',
                            'independent_recovery_proven': False},
                  limits=['Synthetic host RAM and register page; no ticking watchdog, reset, clocks or physical MMIO.',
                          'UART/WDT wrappers, string helpers, timer registration and prints are explicit host services.',
                          'App enabled-byte input is synthetic; fixed bytes do not reveal its live value.',
                          'Timer callback registration does not prove actual period or runtime scheduling.',
                          'Feed can keep WDT alive while one Shell task is stuck if its timer continues; no actual lockup was run.',
                          'No P1 arbitrary entry, P5 publication, reset-domain proof, pre-RTOS recovery or rollback established.'])
    (OUT / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(instruction_checks=len(checks), command_cases=len(commands), application_cases=len(apps), feed_cases=len(feeds), setup_cases=len(setups), report=str(OUT / 'audit.json'))))


if __name__ == '__main__': main()
