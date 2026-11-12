#!/usr/bin/env python3
"""Pinned original ARM task query/delete/terminate and early-stopped snapshots.

Runs original SMP lock code on synthetic uncontended CPU-0 RAM. No camera.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UcError, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE = 0xA0100000
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
TCB = 0x70001000
OUT = 0x70002000
RETURN = 0x7001ff00
STACK = 0x7001f000
LOCK = 0xA1796764
THRD = 0x54485244
CALLBACK = 0x70003000
ENTRY = 0x70003004
REGS = [UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3,
        UC_ARM_REG_R4, UC_ARM_REG_R5, UC_ARM_REG_R6, UC_ARM_REG_R7,
        UC_ARM_REG_R8, UC_ARM_REG_R9, UC_ARM_REG_R10, UC_ARM_REG_R11,
        UC_ARM_REG_R12, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR]


class Machine:
    def __init__(self, image, state=3, magic=THRD, context=0):
        self.u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
        self.u.mem_map(BASE, (len(image) + 4095) & ~4095)
        self.u.mem_write(BASE, image)
        self.u.mem_map(0xA1790000, 0x10000)
        self.u.mem_map(0x70000000, 0x20000)
        self.u.mem_write(0x70018000, b'\xa5' * 0x8000)
        self.u.mem_write(CALLBACK, bytes.fromhex('1eff2fe11eff2fe1'))
        for off, value in ((0, magic), (4, 0x101), (0x18, 0x202),
                           (0x28, 0x70000100), (0x30, state),
                           (0x44, ENTRY), (0x48, 0x1234),
                           (0x74, 0x303), (0x8c, TCB), (0x90, TCB),
                           (0xb0, 12), (0xb4, 9)):
            self.put(TCB + off, value)
        self.put(LOCK + 8, 0xffffffff)
        self.put(0xA17962E8, context)
        self.put(0xA17962FC, 1)
        self.put(0xA1796304, TCB)
        self.put(0xA179630C, TCB)
        self.put(0xA1796314, TCB)
        self.u.reg_write(UC_ARM_REG_CPSR, 0x13)
        self.events = []
        self.observer_core1 = False
        self.u.hook_add(UC_HOOK_CODE, self.observe)

    def put(self, address, value):
        self.u.mem_write(address, struct.pack('<I', value & 0xffffffff))

    def get(self, address):
        return struct.unpack('<I', self.u.mem_read(address, 4))[0]

    def words(self, address, n):
        return list(struct.unpack('<' + 'I' * n, self.u.mem_read(address, 4 * n)))

    def observe(self, u, at, size, user):
        # Unicorn's MPIDR is read-only CPU0. For controlled external-observer
        # interleavings only, substitute four MPIDR reads with logical CPU1.
        # All lock decisions, exclusive atomics, counters and barriers stay real.
        if self.observer_core1:
            core_register = {0xA03C13BC: UC_ARM_REG_R2,
                             0xA03C1404: UC_ARM_REG_R2,
                             0xA03C1438: UC_ARM_REG_R3,
                             0xA03C0D14: UC_ARM_REG_R2}.get(at)
            if core_register is not None:
                u.reg_write(core_register, 1)
                u.reg_write(UC_ARM_REG_PC, at + 4)
        if at in (0xA03C13B0, 0xA03C1428, 0xA03C0D08, CALLBACK,
                  0xA03C1D5C, 0xA03C16E4):
            self.events.append(dict(pc=hex(at), state=self.get(TCB + 0x30),
                completion_field=self.get(TCB + 0x38), magic=self.get(TCB),
                lock_words=self.words(LOCK, 4)))

    def call(self, entry, args=(), stack=STACK, stack_args=()):
        saved = {r: 0xabc00000 + n for n, r in enumerate(REGS[4:12])}
        for r, v in saved.items():
            self.u.reg_write(r, v)
        for r, v in zip(REGS[:4], args):
            self.u.reg_write(r, v)
        for n, v in enumerate(stack_args):
            self.put(stack + n * 4, v)
        self.u.reg_write(UC_ARM_REG_SP, stack)
        self.u.reg_write(UC_ARM_REG_LR, RETURN)
        self.u.emu_start(entry, RETURN, count=100000)
        assert self.u.reg_read(UC_ARM_REG_PC) == RETURN
        assert self.u.reg_read(UC_ARM_REG_SP) == stack
        assert all(self.u.reg_read(r) == v for r, v in saved.items())
        assert self.words(LOCK, 4) == [0, 0, 0xffffffff, 0]
        return dict(status=self.u.reg_read(UC_ARM_REG_R0),
            output=self.words(OUT, 3), task=self.words(TCB, 0xD8 // 4),
            callee_saved_sp_preserved=True, lock_released=True)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', required=True, type=Path)
    a = p.parse_args()
    image = (ANALYSIS / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(image).hexdigest() == SHA
    rows = []

    # State/priority/name layout and original return status through wrapper.
    for state in (0, 1, 2, 3, 4, 5, 6, 0xffffffff):
        m = Machine(image, state)
        before = bytes(m.u.mem_read(TCB, 0xD8))
        result = m.call(0xA03BC324, (TCB, OUT))
        assert result['status'] == 0 and result['output'] == [state, 12, 0x70000100]
        assert bytes(m.u.mem_read(TCB, 0xD8)) == before
        rows.append(dict(name='query_state_' + str(state), result=result, events=m.events))
    for bad, handle in [('null', 0), ('mapped_bad_magic', TCB)]:
        m = Machine(image, magic=0)
        m.u.mem_write(OUT, b'\x11' * 12)
        result = m.call(0xA03BC324, (handle, OUT))
        assert result['status'] == 0xE and result['output'] == [0xa5a5a5a5] * 3
        assert not m.events
        rows.append(dict(name='query_' + bad + '_copies_stack_poison', result=result))
    m = Machine(image)
    result = m.call(0xA03C4500, (TCB, OUT, OUT + 4, OUT + 8),
                    stack_args=(OUT + 12, OUT + 16, OUT + 20, OUT + 24, OUT + 28))
    assert result['status'] == 0
    assert m.words(OUT, 8) == [0x70000100, 3, 0x101, 12, 9, 0x202, TCB, 0x303]
    rows.append(dict(name='direct_info_eight_optional_outputs', result=result,
                     all_outputs=m.words(OUT, 8), events=m.events))
    m = Machine(image)
    result = m.call(0xA03C4500, (TCB, 0, 0, 0), stack_args=(0, 0, 0, 0, 0))
    assert result['status'] == 0
    rows.append(dict(name='direct_info_null_optional_outputs', result=result, events=m.events))
    for entry, args in [(0xA03BC324, (0x60000000, OUT)), (0xA03BC324, (TCB, 0))]:
        m = Machine(image)
        try:
            m.call(entry, args)
            raise AssertionError('unmapped access unexpectedly returned')
        except UcError as error:
            rows.append(dict(name='unmapped_handle_or_output_is_memory_fault', args=list(args),
                             unicorn_error=str(error), pc=hex(m.u.reg_read(UC_ARM_REG_PC))))

    for state in (0, 1, 2, 3, 4, 5, 6):
        m = Machine(image, state)
        before = bytes(m.u.mem_read(TCB, 0xD8))
        result = m.call(0xA03BC30C, (TCB,))
        assert result['status'] == (0 if state in (1, 2) else 0x11)
        if state in (1, 2):
            assert m.get(TCB) == 0 and m.get(0xA17962FC) == 0 and m.get(0xA1796304) == 0
            again = m.call(0xA03BC30C, (TCB,))
            assert again['status'] == 0xE
        else:
            assert bytes(m.u.mem_read(TCB, 0xD8)) == before
            assert m.get(0xA17962FC) == 1 and m.get(0xA1796304) == TCB
            again = None
        rows.append(dict(name='delete_state_' + str(state), result=result,
                         repeated_delete=again, events=m.events))
    for name, magic, handle, context, expected in [
            ('null', THRD, 0, 0, 0xE), ('bad_magic', 0, TCB, 0, 0xE),
            ('illegal_context_leaves_live', THRD, TCB, 1, 0x13),
            ('context_error_precedes_bad_magic', 0, TCB, 1, 0x13)]:
        m = Machine(image, magic=magic, context=context)
        before = bytes(m.u.mem_read(TCB, 0xD8))
        result = m.call(0xA03BC30C, (handle,))
        assert result['status'] == expected and bytes(m.u.mem_read(TCB, 0xD8)) == before
        rows.append(dict(name='delete_' + name, result=result, events=m.events))
    for name, magic, handle, context, expected in [
            ('null', THRD, 0, 0, 0xE), ('bad_magic', 0, TCB, 0, 0xE),
            ('illegal_context_leaves_live', THRD, TCB, 1, 0x13)]:
        m = Machine(image, magic=magic, context=context)
        before = bytes(m.u.mem_read(TCB, 0xD8))
        result = m.call(0xA03BC310, (handle,))
        assert result['status'] == expected and bytes(m.u.mem_read(TCB, 0xD8)) == before
        rows.append(dict(name='terminate_' + name, result=result, events=m.events))
    for state in (1, 2, 3):
        m = Machine(image, state)
        result = m.call(0xA03BC310, (TCB,))
        assert result['status'] == 0 and m.get(TCB) == THRD
        assert m.get(TCB + 0x30) == (state if state in (1, 2) else 2)
        rows.append(dict(name='terminate_state_' + str(state) + '_no_callbacks', result=result, events=m.events))

    # Stop just before exit callback and inspect actual lock retention. A
    # completed/ready task's global preemption count keeps the SMP lock held;
    # suspended termination has no such retention. Never forge an unlock.
    races = []
    for name, entry, state, stop_kind in [
            ('entry_return_state1_before_exit_callback', 0xA03C0A74, 0, 0xA03C1D5C),
            ('terminate_ready_state2_before_exit_callback', 0xA03BC310, 0, 0xA03C1D5C),
            ('terminate_suspended_state2_flag0_before_exit_callback', 0xA03BC310, 3, 0xA03C16E4)]:
        m = Machine(image, state)
        m.put(TCB + 0xC8, CALLBACK)
        m.u.reg_write(UC_ARM_REG_SP, STACK)
        m.u.reg_write(UC_ARM_REG_LR, RETURN)
        m.u.reg_write(UC_ARM_REG_R0, TCB)
        seen = []

        def pause(u, at, size, user):
            if at == CALLBACK and u.reg_read(UC_ARM_REG_R1) == 1:
                u.emu_stop()

        hook = m.u.hook_add(UC_HOOK_CODE, pause)
        m.u.emu_start(entry, RETURN, count=100000)
        assert m.u.reg_read(UC_ARM_REG_PC) == CALLBACK
        m.u.hook_del(hook)
        saved = {r: m.u.reg_read(r) for r in REGS}
        snapshot = dict(state=m.get(TCB + 0x30), completion_field=m.get(TCB + 0x38),
                        lock=m.words(LOCK, 4), target_magic=m.get(TCB),
                        global_preemption_count=m.get(0xA1796780))
        assert snapshot['state'] in (1, 2)
        m.observer_core1 = True
        blocked = []
        if state == 0:
            assert snapshot['lock'] == [1, 0, 0, 0] and snapshot['global_preemption_count'] == 1

            def stop_wait(u, at, size, user):
                if at == 0xA03C13E4:
                    blocked.append(dict(pc=hex(at), lock=m.words(LOCK, 4)))
                    u.emu_stop()

            wait_hook = m.u.hook_add(UC_HOOK_CODE, stop_wait)
            m.u.reg_write(UC_ARM_REG_SP, 0x70017000)
            m.u.reg_write(UC_ARM_REG_LR, RETURN)
            m.u.reg_write(UC_ARM_REG_R0, TCB)
            m.u.reg_write(UC_ARM_REG_R1, OUT)
            m.u.emu_start(0xA03BC324, RETURN, count=100000)
            m.u.hook_del(wait_hook)
            assert blocked and m.u.reg_read(UC_ARM_REG_PC) == 0xA03C13E4
            queried = dict(returned=False, stopped_at='original WFE wait entry',
                           observer_cpu_id_model=1, lock_held_by=0)
            deleted = dict(attempted=False)
        else:
            assert snapshot['lock'] == [0, 0, 0xffffffff, 0] and snapshot['global_preemption_count'] == 0
            queried = m.call(0xA03BC324, (TCB, OUT), stack=0x70017000)
            assert queried['status'] == 0 and queried['output'][0] == snapshot['state']
            deleted = m.call(0xA03BC30C, (TCB,), stack=0x70017000)
            assert deleted['status'] == 0 and m.get(TCB) == 0
        m.observer_core1 = False
        for r, v in saved.items():
            m.u.reg_write(r, v)

        def stop_scheduler(u, at, size, user):
            if at == stop_kind:
                seen.append(dict(pc=hex(at), target_magic=m.get(TCB),
                                 argument=u.reg_read(UC_ARM_REG_R0)))
                u.emu_stop()

        m.u.hook_add(UC_HOOK_CODE, stop_scheduler)
        m.u.emu_start(CALLBACK, RETURN, count=100000)
        assert seen and seen[0]['target_magic'] == (THRD if state == 0 else 0)
        races.append(dict(name=name, before_callback=snapshot,
            observer_query=queried, observer_delete=deleted, blocked=blocked,
            resumed_wrapper_reaches=seen, events=m.events,
            scope='Controlled original-ARM instruction interleaving with logical observer CPU1 MPIDR read model; no RTOS scheduling or physical SMP race executed.'))

    # Readiness of state receipts also depends on ownership, not only THRD.
    m = Machine(image, 1)
    m.put(0xA17962FC, 0)
    m.put(0xA1796304, 0)
    result = m.call(0xA03BC324, (TCB, OUT))
    assert result['status'] == 0 and result['output'][0] == 1
    rows.append(dict(name='unregistered_synthetic_thrd_is_accepted_by_query', result=result))

    # Follow one ordinary completed-current-task removal through actual scheduler
    # cleanup and context-save. Stub only the hardware clock reader (not lock,
    # scheduler or task APIs). Stop before selecting a new task.
    m = Machine(image, 1)
    m.put(TCB + 0xC, 0x70010000)
    m.put(TCB + 0x10, 0x70011000)
    m.put(TCB + 0xC4, 0x70010800)
    m.put(TCB + 8, 0x70010800)
    for address in (0x70010000, 0x70011001, 0x700107FC):
        m.put(address, 0xEFEFEFEF)
    for off, value in ((0x38, 1), (0x20, TCB), (0x24, TCB),
                       (0x2C, 7), (0x3C, 7), (0xA0, 1)):
        m.put(TCB + off, value)
    m.put(0xA1796780, 1)
    m.put(LOCK, 1)
    m.put(LOCK + 8, 0)
    m.put(LOCK + 12, 0)
    m.u.reg_write(UC_ARM_REG_C1_C0_2, 0xF << 20)
    m.u.reg_write(UC_ARM_REG_FPEXC, 1 << 30)
    scheduler_trace = []

    def context_save(u, at, size, user):
        if at == 0xA048EF98:
            scheduler_trace.append(dict(pc=hex(at), substitution='hardware clock returns 0'))
            u.reg_write(UC_ARM_REG_R0, 0)
            u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR))
        elif at in (0xA03C1C8C, 0xA03C1D08, 0xA03C1D38, 0xA03C1D40, 0xA03C08F4):
            scheduler_trace.append(dict(pc=hex(at), current=m.get(0xA179630C),
                next=m.get(0xA1796314), preemption=m.get(0xA1796780),
                lock=m.words(LOCK, 4), saved_sp=m.get(TCB + 8), sp=u.reg_read(UC_ARM_REG_SP)))
            if at == 0xA03C08F4:
                u.emu_stop()

    m.u.hook_add(UC_HOOK_CODE, context_save)
    m.u.reg_write(UC_ARM_REG_SP, STACK)
    m.u.reg_write(UC_ARM_REG_LR, RETURN)
    m.u.reg_write(UC_ARM_REG_R0, TCB)
    m.u.emu_start(0xA03C1D5C, RETURN, count=100000)
    assert m.u.reg_read(UC_ARM_REG_PC) == 0xA03C08F4
    assert m.get(0xA179630C) == 0 and m.get(0xA1796314) == 0
    assert m.words(LOCK, 4) == [0, 0, 0xffffffff, 0] and m.get(0xA1796780) == 0
    assert m.get(TCB + 0x38) == 0 and m.get(TCB + 0x30) == 1
    scheduler_snapshot = dict(state=1, completion_field=0,
        current=m.get(0xA179630C), next=m.get(0xA1796314), lock=m.words(LOCK, 4),
        trace=scheduler_trace, scope='One synthetic ready-list/task/global configuration, including original VFP save; no full scheduler state-space proof.')

    a.output.mkdir(parents=True, exist_ok=False)
    functions = {int(r['entry'], 16): r for r in json.loads((ANALYSIS / 'full/functions.json').read_text())}
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    exports = {}
    for address in (0xA03BC324, 0xA03C4500, 0xA03C448C, 0xA03C4694,
                    0xA03C0A74, 0xA03C13B0, 0xA03C1428, 0xA03C0D08,
                    0xA03C0D4C, 0xA03C09F8, 0xA03C2F00,
                    0xA03C1D5C, 0xA03C1C8C, 0xA03BDC48):
        raw = b''
        lines = []
        for span in functions[address]['body_ranges']:
            lo, hi = [int(v, 16) for v in span.split('-')]
            chunk = image[lo - BASE:hi - BASE + 1]
            raw += chunk
            lines.extend(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
                         for i in md.disasm(chunk, lo))
        (a.output / f'{address:08x}.asm').write_text('\n'.join(lines) + '\n')
        exports[hex(address)] = dict(body_ranges=functions[address]['body_ranges'],
                                    sha256=hashlib.sha256(raw).hexdigest())
    callsites = []
    for line in (ANALYSIS / 'full/calls.tsv').read_text().splitlines():
        fields = line.split('\t')
        if len(fields) == 4 and fields[2].lower() == '0xa03bc324':
            callsites.append(dict(owner=fields[0], site=fields[1], target=fields[2], kind=fields[3]))
    assert len(callsites) == 6
    report = dict(schema=1, status='pass', case_count=len(rows), cases=rows,
        controlled_interleavings=races, interleaving_count=len(races),
        completed_scheduler_removal=scheduler_snapshot,
        query_callsites=callsites, original_function_evidence=exports,
        image_sha256=SHA, script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        device_access=False,
        substituted_services=['Two synthetic BX LR callbacks (entry and exit notifier). No task query/delete/terminate/lock service substitutions.',
            'Four CP15 MPIDR read sites are modeled as logical CPU1 only while running controlled observer interleavings; all other runs execute Unicorn CPU0 MPIDR.',
            'Only completed_scheduler_removal stubs hardware clock reader A048EF98 to zero; original accounting caller, scheduler removal, context-save, VFP-save and lock release execute.'],
        execution_environment=['Original SMP critical enter/exit, context getter, task info/get wrapper, delete and tested terminate paths execute unchanged bytes.',
            'Synthetic CPU-0 global lock, TCB/list/current-task RAM. No IRQ delivery, scheduler run or physical SMP concurrency.',
            'Interleavings retain actual lock state; completion/ready termination keep it held and block external query; suspended termination unlocks it. Scheduler bodies stop at original entry, not fake a completed stop.'],
        conclusion='TaskQuery status must precede output use. Ordinary completion state1 is protected by retained SMP lock until current-task removal in the inspected completed-task path; this is a stronger candidate receipt under exclusive ownership. Suspended termination exposes state2/flag0 and permits delete=0 before exit notifier/reconsideration returns; accepting both states generically is insufficient as the owned retirement external stopped proof.',
        limitations=['Original snapshot functions authenticate magic only, not allocation ownership or generation.',
            'Mapped invalid objects can return status; arbitrary/unmapped pointers can fault. No pointer validator.',
            'Controlled interleavings prove original instruction ordering and missing checks, not actual camera scheduling reachability or observed use-after-free.',
            'No bounded external full-task/stack/code quiescence proof or safe camera lifecycle binding established.'])
    (a.output / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', cases=len(rows), interleavings=len(races),
                         original_lock_executed=True, device_access=False)))


if __name__ == '__main__':
    main()
