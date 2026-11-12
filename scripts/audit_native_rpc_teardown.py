#!/usr/bin/env python3
"""Execute original RPC unregister ARM with explicit teardown service outcomes.

Offline fault injection only; does not run a scheduler or contact a camera.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
HEAD = 0xA0789608
SERVICE = 0x70001000
TABLE = 0x70002000
PROGRAM = 0x10000001


class Machine:
    def __init__(self, image, case):
        self.u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
        self.u.mem_map(BASE, (len(image) + 4095) & ~4095)
        self.u.mem_write(BASE, image)
        self.u.mem_map(0x70000000, 0x10000)
        self.case = case
        self.events = []
        self.worker_alive = case['state'] not in (1, 2)
        self.task_deleted = False
        self.put(HEAD, SERVICE + 0x78)
        self.put(HEAD + 4, SERVICE + 0x78)
        for off, value in ((0, PROGRAM), (4, 1), (0x78, HEAD),
                           (0x7c, HEAD), (0x344, 1), (0x34c, TABLE)):
            self.put(SERVICE + off, value)
        self.u.hook_add(UC_HOOK_CODE, self.hook)

    def put(self, at, value):
        self.u.mem_write(at, struct.pack('<I', value & 0xffffffff))

    def get(self, at):
        return struct.unpack('<I', self.u.mem_read(at, 4))[0]

    def hook(self, u, at, size, user):
        args = [u.reg_read(r) for r in (UC_ARM_REG_R0, UC_ARM_REG_R1,
                                       UC_ARM_REG_R2, UC_ARM_REG_R3)]
        kind = None
        result = 0
        if at == 0xA03BC4E8:
            kind = 'event_set'
            assert args[:2] == [SERVICE + 0x44, 4]
            result = self.case.get('event_set_status', 0)
        elif at == 0xA03BC4AC:
            kind = 'event_get'
            assert args[:3] == [SERVICE + 0x44, 8, 3]
            assert self.get(u.reg_read(UC_ARM_REG_SP)) == 0xffffffff
            result = self.case.get('event_get_status', 0)
            if result == 0:
                self.put(args[3], 8)
        elif at == 0xA03BC324:
            kind = 'task_info'
            assert args[0] == SERVICE + 0x84
            result = self.case.get('task_info_status', 0)
            if result == 0:
                self.put(args[1], self.case['state'])
        elif at == 0xA03BC310:
            kind = 'task_terminate'
            assert args[0] == SERVICE + 0x84
            result = self.case.get('terminate_status', 0)
            if result == 0:
                self.worker_alive = False
        elif at == 0xA03BC30C:
            kind = 'task_delete'
            assert args[0] == SERVICE + 0x84
            result = self.case.get('delete_status', 0)
            if result == 0:
                self.task_deleted = True
        elif at == 0xA02A70EC:
            kind = 'log'
        elif at == 0xA03C88A0:
            kind = 'port_remove'
            assert args[0] == SERVICE + 8
        elif at == 0xA03CD264:
            kind = 'free'
            assert args[0] in (SERVICE, TABLE)
        if kind:
            self.events.append(dict(kind=kind, args=args, status=result,
                                    worker_alive_model=self.worker_alive,
                                    task_deleted_model=self.task_deleted))
            u.reg_write(UC_ARM_REG_R0, result)
            u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR))

    def run(self):
        saved = [UC_ARM_REG_R4, UC_ARM_REG_R5, UC_ARM_REG_R6,
                 UC_ARM_REG_R7, UC_ARM_REG_R8, UC_ARM_REG_R9,
                 UC_ARM_REG_R10, UC_ARM_REG_R11]
        for n, r in enumerate(saved):
            self.u.reg_write(r, 0xabc00000 + n)
        self.u.reg_write(UC_ARM_REG_SP, 0x7000f000)
        self.u.reg_write(UC_ARM_REG_LR, 0x7000f800)
        self.u.reg_write(UC_ARM_REG_R0, PROGRAM)
        self.u.reg_write(UC_ARM_REG_R1, 1)
        self.u.emu_start(0xA03CAC1C, 0x7000f800, count=10000)
        assert self.u.reg_read(UC_ARM_REG_PC) == 0x7000f800
        assert self.u.reg_read(UC_ARM_REG_R0) == 0
        assert self.u.reg_read(UC_ARM_REG_SP) == 0x7000f000
        assert all(self.u.reg_read(r) == 0xabc00000 + n
                   for n, r in enumerate(saved))
        assert self.get(HEAD) == HEAD and self.get(HEAD + 4) == HEAD
        frees = [e for e in self.events if e['kind'] == 'free']
        assert [e['args'][0] for e in frees] == [TABLE, SERVICE]
        return dict(case=self.case, returned=True, r0=0,
                    callee_saved_and_sp_preserved=True, service_unlinked=True,
                    worker_alive_model=self.worker_alive,
                    task_deleted_model=self.task_deleted, events=self.events)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    image = (ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin').read_bytes()
    assert hashlib.sha256(image).hexdigest() == SHA
    cases = [dict(name='completed_delete_success', state=1),
             dict(name='terminated_delete_success', state=2),
             dict(name='running_terminate_delete_success', state=3),
             dict(name='running_terminate_and_delete_fail', state=3,
                  terminate_status=1, delete_status=1),
             dict(name='completed_delete_fail', state=1, delete_status=1),
             dict(name='event_wait_fails', state=3, event_get_status=1,
                  terminate_status=1, delete_status=1),
             dict(name='event_set_fails', state=1, event_set_status=1),
             dict(name='task_info_fails', state=3, task_info_status=1,
                  terminate_status=1, delete_status=1)]
    rows = [Machine(image, c).run() for c in cases]
    for row in rows:
        kinds = [e['kind'] for e in row['events']]
        expected_terminate = row['case']['state'] not in (1, 2)
        assert ('task_terminate' in kinds) == expected_terminate
        assert kinds.index('task_delete') < kinds.index('port_remove') < kinds.index('free')
        if row['case'].get('terminate_status') == 1:
            assert row['worker_alive_model'] and not row['task_deleted_model']
    a.output.mkdir(parents=True, exist_ok=False)
    raw = image[0xA03CAC1C - BASE:0xA03CADCC - BASE]
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    (a.output / 'unregister.asm').write_text('\n'.join(
        f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
        for i in md.disasm(raw, 0xA03CAC1C)) + '\n')
    report = dict(schema=1, status='pass', case_count=len(rows), cases=rows,
                  image_sha256=SHA, unregister_body_sha256=hashlib.sha256(raw).hexdigest(),
                  script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  device_access=False,
                  conclusion='Original unregister returns zero and unlinks/frees copied table and service object even after modeled event, task-info, terminate or delete failures.',
                  models=['Synthetic service and doubly linked list; explicit event/task/log/port/free service stubs.',
                          'worker_alive and task_deleted are dependency-state models, not an executed scheduler.'],
                  limits=['No real scheduler, active worker, allocator, RPC transport or device execution.',
                          'Does not prove failures occur on camera or demonstrate an actual use-after-free.',
                          'A return-zero receipt alone does not prove quiescence or safe code/table/stack reclamation.'])
    (a.output / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', cases=len(rows), device_access=False)))


if __name__ == '__main__':
    main()
