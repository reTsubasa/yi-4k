#!/usr/bin/env python3
"""Offline fixed-1.10.7 autoexec storage-event gate and text reader execution.

Unmodified ARM windows execute in Unicorn. Event/filesystem/services are explicit
host mocks. Does not acquire from the camera, emit a script, or invoke a writer.
"""
from __future__ import annotations
import hashlib
import json
from pathlib import Path
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
OUT = ROOT / 'artifacts/verification/2026-11-12-autoexec-storage-gate-run01'
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE, STACK, STOP = 0xa0100000, 0x20010000, 0x20020000
EVENT, APP, CALLBACK = 0xa1446558, 0xa1055cd8, 0x20030000
REGS = (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def machine(image):
    u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    u.mem_map(0xa0000000, 0x2000000)
    u.mem_map(0x20000000, 0x40000)
    u.mem_write(BASE, image)
    u.reg_write(UC_ARM_REG_SP, STACK)
    u.reg_write(UC_ARM_REG_LR, STOP)
    return u


def cstr(u, address):
    return bytes(u.mem_read(address, 1024)).split(b'\0', 1)[0].decode('ascii')


def ret(u, result=0):
    u.reg_write(UC_ARM_REG_R0, result & 0xffffffff)
    u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR))


def storage_case(image, name, completion, ready, drive, busy, primary, high=-1):
    """Start at HMSG_STORAGE_IDLE body; app/service state is caller-supplied.

    AppHandler's preceding message ID dispatch is instruction-pinned below.
    r5/r8 carry the queued message's second/third words at A019DA50.
    """
    u = machine(image)
    u.reg_write(UC_ARM_REG_R4, APP)
    u.reg_write(UC_ARM_REG_R5, drive)
    u.reg_write(UC_ARM_REG_R8, completion)
    u.reg_write(UC_ARM_REG_R10, 0x38010002)
    u.mem_write(APP + 0x18, bytes([busy]))
    u.mem_write(APP + 0x1a1, b'\x01')
    u.mem_write(STACK + 0x54, struct.pack('<I', CALLBACK))
    u.mem_write(CALLBACK, struct.pack('<I', 0))
    u.mem_write(CALLBACK + 0x28, struct.pack('<I', CALLBACK + 0x100))
    events, visited, calls, requeued = [], [], [], []
    terminal = []
    # All app-level services in this bounded path are mocked; event thunk itself
    # executes original instructions, and its event-set callee is a host service.
    generic = {0xa02a70ec, 0xa02231b8, 0xa0223744, 0xa0197cf4,
               0xa01b0ab0, 0xa01b0f6c, 0xa019ce8c, 0xa01972cc,
               0xa019b1f4, 0xa0193280, 0xa0223854, CALLBACK + 0x100}

    def hook(_, address, size, context):
        if address == 0xa019db34:
            terminal.append(hex(address)); u.emu_stop(); return
        if address in (0xa019e818, 0xa019e828, 0xa019e874, 0xa01a0c2c, 0xa01a0c94):
            visited.append(hex(address))
        if address == 0xa02231e0:
            calls.append(hex(address)); ret(u, ready)
        elif address == 0xa0222de8:
            calls.append(hex(address)); ret(u, drive - (0x41 if drive < 0x5b else 0x61))
        elif address == 0xa02237cc:
            calls.append(hex(address)); ret(u, high)
        elif address == 0xa0223274:
            calls.append(hex(address)); ret(u, 2)
        elif address == 0xa022328c:
            calls.append(hex(address)); ret(u, primary)
        elif address == 0xa03bc4e8:
            args = [u.reg_read(r) for r in REGS]
            events.append({'group': hex(args[0]), 'flags': args[1]}); ret(u)
        elif address == 0xa01e659c:
            requeued.append([u.reg_read(r) for r in REGS[:3]]); ret(u)
        elif address in generic:
            calls.append(hex(address)); ret(u)

    u.hook_add(UC_HOOK_CODE, hook)
    u.emu_start(0xa019e7f8, STOP, count=10000)
    assert terminal
    return dict(name=name, completion=completion, card_ready_result=ready,
                drive=chr(drive), busy_slot=busy, primary_slot=primary,
                higher_priority_slot=high, events=events, visited=visited,
                terminal=terminal[0], mocked_calls=calls, requeued_messages=requeued)


def exec_case(image, flags, reader_result):
    u = machine(image)
    waits, readers, clears, sets = [], [], [], []
    u.mem_write(0xa1446624, b'help\0')

    def hook(_, address, size, context):
        args = [u.reg_read(r) for r in REGS]
        if address == 0xa03bc4ac:
            if waits:
                u.emu_stop(); return
            waits.append(dict(group=hex(args[0]), mask=args[1], option=args[2]))
            u.mem_write(args[3], struct.pack('<I', flags)); ret(u)
        elif address == 0xa029d3b4:
            readers.append(cstr(u, args[0])); ret(u, reader_result)
        elif address == 0xa029ccb8:
            ret(u)
        elif address == 0xa04f99f0:
            ret(u, len(cstr(u, args[0])))
        elif address == 0xa04f9744:
            ret(u, 1)
        elif address == 0xa03bc4f0:
            clears.append(args[1]); ret(u)
        elif address == 0xa03bc4e8:
            sets.append(args[1]); ret(u)
        elif address == 0xa02a70ec:
            ret(u)

    u.hook_add(UC_HOOK_CODE, hook)
    u.emu_start(0xa029d4d8, STOP, count=1000)
    return dict(flags=flags, reader_result=reader_result, wait=waits,
                script_reads=readers, flags_cleared=clears, flags_set=sets,
                stopped_at_next_wait=True)


def reader_case(image, name, text, exists=True):
    u = machine(image)
    u.reg_write(UC_ARM_REG_R0, 0xa05ae4a8)
    opened, commands, closed = [], [], []
    cursor, returned = 0, False

    def hook(_, address, size, context):
        nonlocal cursor, returned
        args = [u.reg_read(r) for r in REGS]
        if address == STOP:
            returned = True; u.emu_stop()
        elif address == 0xa032e0c8:
            opened.append({'path': cstr(u, args[0]), 'mode': cstr(u, args[1])}); ret(u, 1 if exists else 0)
        elif address == 0xa032e0d4:
            assert args[1:] == [1, 1, 1]
            if cursor < len(text):
                u.mem_write(args[0], text[cursor:cursor + 1]); cursor += 1; ret(u, 1)
            else:
                ret(u)
        elif address == 0xa04f8dec:
            u.mem_write(args[0], bytes([args[1]]) * args[2]); ret(u, args[0])
        elif address == 0xa029ccb8:
            commands.append(cstr(u, args[0])); ret(u)
        elif address == 0xa032e0d0:
            closed.append(args[0]); ret(u)

    u.hook_add(UC_HOOK_CODE, hook)
    u.emu_start(0xa029d3b4, STOP + 4, count=100000)
    assert returned
    return dict(name=name, source_hex=text.hex(), exists=exists, opened=opened,
                command_strings=commands, closed=closed, result=u.reg_read(UC_ARM_REG_R0))


def main():
    image = IMAGE.read_bytes()
    assert sha(image) == SHA
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = {
        0xa019e7e8: ('mov', 'r3, #2'), 0xa019e7ec: ('movt', 'r3, #0x3801'),
        0xa019e818: ('cmp', 'r8, #1'), 0xa019e828: ('str', 'r3, [sp, #0x48]'),
        0xa019e874: ('cmp', 'sb, ip'), 0xa019e878: ('beq', '#0xa01a0bcc'),
        0xa01a0c2c: ('cmp', 'sb, r0'), 0xa01a0c30: ('bne', '#0xa019db34'),
        0xa01a0c94: ('bl', '#0xa029de88'), 0xa029de8c: ('mov', 'r1, #2'),
        0xa029de90: ('b', '#0xa03bc4e8'),
        0xa029d508: ('tst', 'r1, #2'), 0xa029d570: ('bl', '#0xa029d3b4'),
        0xa029d574: ('mov', 'r1, #2'), 0xa029d57c: ('bl', '#0xa03bc4f0'),
        0xa029d404: ('bl', '#0xa032e0d4'), 0xa029d46c: ('bl', '#0xa029ccb8'),
        0xa029d490: ('bl', '#0xa032e0d0'),
    }
    for address, expected in checks.items():
        ins = next(md.disasm(image[address - BASE:address - BASE + 4], address))
        assert (ins.mnemonic, ins.op_str) == expected, (hex(address), ins.mnemonic, ins.op_str)
    storage = [
        storage_case(image, 'completion_equals_1_early_branch', 1, 0, ord('c'), 2, 2),
        storage_case(image, 'card_ready_nonzero_early_branch', 0, -1, ord('c'), 2, 2),
        storage_case(image, 'busy_slot_mismatch', 0, 0, ord('c'), 1, 2),
        storage_case(image, 'primary_slot_mismatch', 0, 0, ord('c'), 2, 1),
        storage_case(image, 'matching_primary_c_slot', 0, 0, ord('c'), 2, 2),
        storage_case(image, 'matching_primary_a_slot_still_uses_fixed_script_path', 0, 0, ord('a'), 0, 0),
        storage_case(image, 'higher_priority_slot_diverts', 0, 0, ord('c'), 2, 2, 1),
    ]
    assert all(not row['events'] for row in storage[:4])
    assert storage[1]['requeued_messages'] == [[0x38010002, ord('c'), 0]]
    assert storage[4]['events'] == storage[5]['events'] == [{'group': hex(EVENT), 'flags': 2}]
    assert not storage[6]['events']
    execution = [exec_case(image, flags, result) for flags, result in [(1, 0), (2, 0), (2, -1), (3, -1)]]
    assert execution[0]['script_reads'] == [] and execution[0]['flags_cleared'] == [1]
    for row in execution[1:]:
        assert row['script_reads'] == ['c:\\autoexec.ash'] and row['flags_cleared'] == [2]
    reader = [reader_case(image, 'missing_file', b'', False),
              reader_case(image, 'two_newline_terminated_lines', b'help\nps tsk\n'),
              reader_case(image, 'unterminated_final_line_dropped', b'help\nps tsk'),
              reader_case(image, 'crlf_dispatches_empty_lines', b'help\r\n'),
              reader_case(image, 'tab_does_not_advance_cursor', b'ps\ttsk\n')]
    assert reader[0]['result'] == 0xffffffff and reader[0]['command_strings'] == []
    assert reader[1]['command_strings'] == ['help', 'ps tsk']
    assert reader[2]['command_strings'] == ['help']
    assert reader[3]['command_strings'] == ['help', '']
    assert reader[4]['command_strings'] == ['pstsk']
    staged_path = ROOT / 'artifacts/device/2026-11-12-native-eis-trace-stage-01/autoexec.ash'
    staged = staged_path.read_bytes()
    assert sha(staged) == '6ceda2695f5e56ba5bb1b246c3bd1ccc78389413bdd469dede25f4effc0cc06e'
    assert staged.endswith(b'\n') and b'\t' not in staged and max(map(len, staged.split(b'\n'))) < 256
    archived = reader_case(image, 'archived_run01_all_lines_reach_parser_mock', staged)
    assert archived['command_strings'] == [line.decode('ascii') for line in staged.split(b'\n')[:-1]]
    reader.append(archived)
    OUT.mkdir(parents=True, exist_ok=True)
    excerpts = [(0xa019e7e8, 0xa019e89c), (0xa01a0bcc, 0xa01a0ca0),
                (0xa01a04c4, 0xa01a04f0), (0xa01a054c, 0xa01a0580),
                (0xa01a10e0, 0xa01a10ec), (0xa0224318, 0xa02243a8),
                (0xa029d3b4, 0xa029d5ac), (0xa029de88, 0xa029de94)]
    for start, end in excerpts:
        (OUT / f'{start:08x}.asm').write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(image[start - BASE:end - BASE], start)) + '\n')
    report = dict(schema='autoexec-storage-gate/v1', image_sha256=SHA,
                  script_sha256=sha(Path(__file__).read_bytes()), instruction_checks=len(checks),
                  archived_script={'path': str(staged_path.relative_to(ROOT)), 'sha256': sha(staged),
                                   'trailing_lf': True, 'has_tabs': False,
                                   'max_line_bytes': max(map(len, staged.split(b'\n')))},
                  storage_cases=storage, shell_event_cases=execution, script_reader_cases=reader,
                  device_access=False, target_write=False, payload_emitted=False,
                  mechanism={'message': 'HMSG_STORAGE_IDLE', 'message_id': '0x38010002',
                             'set_call_site': '0xa01a0c94', 'event_group': hex(EVENT),
                             'event_mask': 2, 'exec_task': '0xa029d4d8',
                             'reader': '0xa029d3b4', 'path': 'c:\\autoexec.ash'},
                  limits=['Original fixed ARM control flow executes only in synthetic host RAM; no device state is observed.',
                          'Filesystem, card state, application services, command parser and event services are host mocks.',
                          'Storage message branch labels come from fixed firmware strings; application callbacks are mocked.',
                          'No file watcher or retry occurs in the audited Shell event loop after reader returns; a future event can trigger a new read.',
                          'No arbitrary native entry, code publication, SMP completion, cold boot or rollback is established.'])
    (OUT / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(instruction_checks=len(checks), storage_cases=len(storage),
                          shell_cases=len(execution), reader_cases=len(reader), report=str(OUT / 'audit.json'))))


if __name__ == '__main__':
    main()
