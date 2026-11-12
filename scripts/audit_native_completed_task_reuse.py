#!/usr/bin/env python3
"""Original ARM natural-completion tail, last old accesses and storage reuse.

Offline only. Controlled CPU1 MPIDR and architectural exception-entry models;
no real SMP, IRQ delivery, camera binding, allocator/ownership runtime or
deployment. The same-address ABA case still executes the original TaskCreate
bytes against synthetic RAM.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
DEPENDENCY = ROOT / 'scripts/audit_native_task_stop_proof.py'
SPEC = importlib.util.spec_from_file_location('stop_proof', DEPENDENCY)
STOP = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(STOP)
TCB = STOP.TCB
LOCK = STOP.LOCK
OLD_STACK_LO, OLD_STACK_HI = 0x70018000, 0x70020000
NEXT = 0x71001000
NEXT_STACK = 0x71008000
DONE = 0x7100F000
OBSERVER_STACK = 0x70017000
MD = Cs(CS_ARCH_ARM, CS_MODE_ARM)
MD_THUMB = Cs(CS_ARCH_ARM, CS_MODE_THUMB)


def sha(blob):
    return hashlib.sha256(blob).hexdigest()


class Machine(STOP.Machine):
    def __init__(self, image):
        self.accesses = []
        self.traces = []
        self.stub_calls = []
        self.modeled_mpidr_sites = set()
        self.removed = False
        self.logging = True
        self.instructions = []
        self.phase = 'natural_completion'
        super().__init__(image, state=0)
        self.u.mem_map(0x71000000, 0x10000)
        self.u.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, self.memory)
        self.put(TCB + 0xC, 0x70010000)
        self.put(TCB + 0x10, 0x70011000)
        self.put(TCB + 0xC4, 0x70010800)
        self.put(TCB + 8, 0x70010800)
        for at in (0x70010000, 0x70011001, 0x700107FC):
            self.put(at, 0xEFEFEFEF)
        for off, value in ((0x38, 0), (0x20, TCB), (0x24, TCB),
                           (0x2C, 7), (0x3C, 7), (0xC8, STOP.CALLBACK)):
            self.put(TCB + off, value)
        self.u.reg_write(UC_ARM_REG_C1_C0_2, 0xF << 20)
        self.u.reg_write(UC_ARM_REG_FPEXC, 1 << 30)

    def observe(self, u, at, size, user):
        if self.observer_core1:
            # Detect exactly MRC p15,0,Rd,c0,c0,5. Extends the existing four
            # lock/query sites to create/new-task execution on logical CPU1.
            word = struct.unpack('<I', u.mem_read(at, 4))[0]
            if word & 0x0FFF0FFF == 0x0E100FB0:
                rd = (word >> 12) & 15
                assert rd < 13
                self.modeled_mpidr_sites.add(at)
                u.reg_write(STOP.REGS[rd], 1)
                u.reg_write(UC_ARM_REG_PC, at + 4)
                return
        if self.logging:
            self.instructions.append(at)
        if at in (0xA048EF98, 0xA049762C):
            self.stub_calls.append(dict(phase=self.phase, pc=hex(at),
                replacement='hardware clock returns zero' if at == 0xA048EF98 else 'interrupt dispatcher returns without handlers'))
            u.reg_write(UC_ARM_REG_R0, 0)
            u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR))
        if at in (0xA03C1CE0, 0xA03C1D18, 0xA03C1D3C, 0xA03C1D40,
                  0xA03C08F4, 0xA03C0938, 0xA03C0988, 0xA03C098C,
                  0xA03C09F0, 0xA03C09F4, 0xA03C09C8):
            self.traces.append(dict(phase=self.phase, pc=hex(at),
                sp=u.reg_read(UC_ARM_REG_SP), cpsr=u.reg_read(UC_ARM_REG_CPSR),
                current=self.get(0xA179630C), next=self.get(0xA1796314),
                lock=self.words(LOCK, 4)))

    def memory(self, u, access, address, size, value, user):
        kind = 'old_tcb' if TCB <= address < TCB + 0xD8 else (
            'old_stack' if OLD_STACK_LO <= address < OLD_STACK_HI else None)
        if kind and self.logging:
            assert not self.removed, (self.phase, hex(u.reg_read(UC_ARM_REG_PC)), hex(address))
            self.accesses.append(dict(phase=self.phase, pc=hex(u.reg_read(UC_ARM_REG_PC)),
                region=kind, access='write' if access == 17 else 'read',
                address=hex(address), bytes=size))

    def run_to(self, start, target, count=200000):
        def pause(u, at, size, user):
            if at == target:
                u.emu_stop()
        h = self.u.hook_add(UC_HOOK_CODE, pause)
        self.u.emu_start(start, DONE, count=count)
        self.u.hook_del(h)
        assert self.u.reg_read(UC_ARM_REG_PC) == target, (hex(self.u.reg_read(UC_ARM_REG_PC)), hex(target))

    def complete_to(self, target):
        self.u.reg_write(UC_ARM_REG_SP, STOP.STACK)
        self.u.reg_write(UC_ARM_REG_LR, DONE)
        self.run_to(0xA03C0A74, target)
        assert self.get(TCB + 0x30) == 1 and self.get(0xA179630C) == 0

    def observer_query_delete(self, should_wait=False):
        saved = {r: self.u.reg_read(r) for r in STOP.REGS}
        self.observer_core1 = True
        self.logging = False
        self.phase = 'observer_cpu1'
        if should_wait:
            self.u.reg_write(UC_ARM_REG_SP, OBSERVER_STACK)
            self.u.reg_write(UC_ARM_REG_LR, STOP.RETURN)
            self.u.reg_write(UC_ARM_REG_R0, TCB)
            self.u.reg_write(UC_ARM_REG_R1, STOP.OUT)
            self.run_to(0xA03BC324, 0xA03C13E4)
            result = dict(query_returned=False, stop='original WFE entry',
                          lock=self.words(LOCK, 4), delete_attempted=False)
        else:
            query = self.call(0xA03BC324, (TCB, STOP.OUT), OBSERVER_STACK)
            delete = self.call(0xA03BC30C, (TCB,), OBSERVER_STACK)
            assert query['status'] == delete['status'] == 0 and query['output'][0] == 1
            assert self.get(TCB) == 0 and self.get(0xA17962FC) == 0
            result = dict(query_returned=True, query_status=0, query_output=query['output'],
                          delete_status=0, magic_after_delete=0, lock=self.words(LOCK, 4))
        self.observer_core1 = False
        self.logging = True
        self.phase = 'natural_completion'
        for r, v in saved.items():
            self.u.reg_write(r, v)
        return result

    def remove_old(self):
        assert self.words(LOCK, 4) == [0, 0, 0xffffffff, 0]
        # Unmapping catches actual CPU references; reading SP as a value is not
        # itself an access. Host instrumentation also avoids the unmapped TCB.
        self.u.mem_unmap(TCB & ~0xFFF, 0x1000)
        self.u.mem_unmap(OLD_STACK_LO, OLD_STACK_HI - OLD_STACK_LO)
        self.removed = True

    def next_task(self, restore='solicited_plain'):
        self.put(NEXT, STOP.THRD)
        self.put(NEXT + 0x98, 0x8000)
        self.put(NEXT + 8, NEXT_STACK)
        self.put(NEXT + 0x18, 19)
        fp = restore.endswith('_fp')
        irq = restore.startswith('interrupt')
        self.put(NEXT + 0xA0, int(fp))
        words = [int(irq), 0x13]
        if irq:
            if fp:
                # Actual interrupt restore vpop d0-d15 (32 words), d16-d31
                # (32 words), fpscr (1 word): total 65 words.
                words = [1, 0x13] + [0] * 64 + [0]
            words += [0xBC000000 + n for n in range(13)] + [0x7100E000, DONE]
        else:
            if fp:
                words += [0] * 48 + [0]  # d8-d15 + d16-d31 + fpscr
            words += [0xBC000004 + n for n in range(8)] + [DONE]
        for n, value in enumerate(words):
            self.put(NEXT_STACK + n * 4, value)
        self.put(0xA1796314, NEXT)
        return NEXT_STACK + len(words) * 4

    def resume_next(self, start, restore='solicited_plain'):
        expected_sp = self.next_task(restore)
        self.phase = 'resume_distinct_task'
        self.u.emu_start(start, DONE, count=100000)
        assert self.u.reg_read(UC_ARM_REG_PC) == DONE
        assert self.u.reg_read(UC_ARM_REG_SP) == expected_sp
        assert self.get(0xA179630C) == NEXT and self.get(0xA1796314) == NEXT
        assert self.get(NEXT + 4) == 1
        return dict(restore=restore, next_task=hex(NEXT), final_pc=hex(DONE),
                    expected_sp=hex(expected_sp), actual_sp=hex(self.u.reg_read(UC_ARM_REG_SP)))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', required=True, type=Path)
    a = p.parse_args()
    image = (STOP.ANALYSIS / 'rtos-window.bin').read_bytes()
    assert sha(image) == STOP.SHA
    cases = []

    # Before unlock observer blocks. Immediately after unlock (even before
    # DSB/SEV), original query/delete can succeed in this sequential model.
    m = Machine(image)
    m.complete_to(0xA03C1D3C)
    blocked = m.observer_query_delete(True)
    assert blocked['lock'] == [1, 0, 0xffffffff, 0]
    m.run_to(0xA03C1D3C, 0xA03C1D40)
    available = m.observer_query_delete()
    last = {region: [e for e in m.accesses if e['region'] == region][-1]
            for region in ('old_stack', 'old_tcb')}
    assert last['old_stack']['pc'] == '0xa03c1ce0' and last['old_stack']['access'] == 'read'
    assert last['old_tcb']['pc'] == '0xa03c1d18' and last['old_tcb']['access'] == 'write'
    m.remove_old()
    # With no candidate, run to actual WFI; no old memory is mapped.
    m.phase = 'idle_after_unmap'
    m.run_to(0xA03C1D40, 0xA03C0938)
    assert OLD_STACK_LO <= m.u.reg_read(UC_ARM_REG_SP) < OLD_STACK_HI
    # A single no-interrupt WFI step in Unicorn is only emulation semantics,
    # not evidence of a physical wait. Stop there; next case handles wake path.
    cases.append(dict(name='lock_boundary_and_idle_with_unmapped_old_storage',
        before_unlock=blocked, after_unlock=available, last_old_accesses=last,
        idle_pc=hex(m.u.reg_read(UC_ARM_REG_PC)), stale_sp=hex(m.u.reg_read(UC_ARM_REG_SP)),
        old_storage_unmapped=True, traces=m.traces, old_accesses=m.accesses,
        substitutions=m.stub_calls))

    # Restore all original scheduler context variants on a distinct task.
    for restore in ('solicited_plain', 'solicited_fp', 'interrupt_plain', 'interrupt_fp'):
        m = Machine(image)
        m.complete_to(0xA03C1D40)
        observer = m.observer_query_delete()
        m.remove_old()
        result = m.resume_next(0xA03C1D40, restore)
        cases.append(dict(name='unmapped_old_storage_then_' + restore,
            observer=observer, result=result, old_storage_unmapped=True,
            traces=m.traces, substitutions=m.stub_calls))

    # Inject a hardware-exception entry at the idle scheduler boundary. The
    # CPU bank switch/SPSR/LR construction is explicit; prologue/epilogue,
    # profiling callers and banked-stack accesses execute original ARM.
    for name, mode, vector in [('irq', 0x12, 0xA03BC150), ('fiq', 0x11, 0xA03BC15C)]:
        m = Machine(image)
        m.complete_to(0xA03C1D40)
        observer = m.observer_query_delete()
        m.remove_old()
        m.phase = 'idle_before_' + name
        m.run_to(0xA03C1D40, 0xA03C0938)
        svc_sp = m.u.reg_read(UC_ARM_REG_SP)
        interrupted_cpsr = m.u.reg_read(UC_ARM_REG_CPSR)
        assert interrupted_cpsr & 0x1F == 0x13 and not interrupted_cpsr & 0x80
        m.u.reg_write(UC_ARM_REG_CPSR, (interrupted_cpsr & ~0x1F) | mode | 0xC0)
        m.u.reg_write(UC_ARM_REG_SP, 0x7100D000)
        m.u.reg_write(UC_ARM_REG_SPSR, interrupted_cpsr)
        m.u.reg_write(UC_ARM_REG_LR, 0xA03C0938 + 4)
        m.phase = name + '_banked_handler'
        m.run_to(vector, 0xA03C08F4)
        assert m.get(0xA17962E8) == 0 and m.u.reg_read(UC_ARM_REG_CPSR) & 0x1F == 0x13
        assert m.u.reg_read(UC_ARM_REG_SP) == svc_sp
        result = m.resume_next(0xA03C08F4)
        cases.append(dict(name=name + '_while_idle_old_storage_unmapped', observer=observer,
            modeled_exception=dict(mode=hex(mode), banked_stack=hex(0x7100D000),
                                   prior_cpsr=hex(interrupted_cpsr), prior_svc_sp=hex(svc_sp)),
            result=result, traces=m.traces, substitutions=m.stub_calls,
            limits='Manual architectural exception entry and empty ISR dispatcher model; not actual IRQ/FIQ delivery or handler graph coverage.'))

    # Ownership ABA: a stale completed receipt cannot distinguish a newly
    # created task at the same TCB address. Use original create(auto_start=0),
    # actual next-context restore and natural return on modeled CPU1; only
    # initial ready/current publication is a synthetic dispatcher fixture.
    m = Machine(image)
    m.complete_to(0xA03C1D40)
    old_cpu0 = {r: m.u.reg_read(r) for r in STOP.REGS}
    m.logging = False
    m.observer_core1 = True
    m.phase = 'stale_owner_and_new_generation'
    stale = m.call(0xA03BC324, (TCB, STOP.OUT), OBSERVER_STACK)
    assert stale['status'] == 0 and stale['output'][0] == 1
    deleted_old = m.call(0xA03BC30C, (TCB,), OBSERVER_STACK)
    assert deleted_old['status'] == 0
    created = m.call(0xA03BC2BC, (TCB, 0x71000200, 12, STOP.ENTRY),
        OBSERVER_STACK, stack_args=(0x4567, 0x71004000, 0x2000, 0))
    assert created['status'] == 0 and m.get(TCB + 0x30) == 3
    rejects_new_suspended = m.call(0xA03BC30C, (TCB,), OBSERVER_STACK)
    assert rejects_new_suspended['status'] == 0x11 and m.get(TCB) == STOP.THRD
    # Publish one running-ready synthetic dispatcher assignment for CPU1.
    # TaskCreate initialization/frame remain the real bytes; no state1 store.
    m.put(TCB + 0x30, 0)
    m.put(TCB + 0x38, 0)
    m.put(TCB + 0x94, 1)
    m.put(TCB + 0x20, TCB)
    m.put(TCB + 0x24, TCB)
    m.put(0xA1796318, TCB)
    m.u.reg_write(UC_ARM_REG_SP, OBSERVER_STACK)
    m.run_to(0xA03C08F4, 0xA03C0938)
    assert m.get(TCB + 0x30) == 1 and m.get(0xA1796310) == 0
    new_query = m.call(0xA03BC324, (TCB, STOP.OUT), OBSERVER_STACK)
    assert new_query['status'] == 0 and new_query['output'] == [1, 12, 0x71000200]
    stale_delete_new = m.call(0xA03BC30C, (TCB,), OBSERVER_STACK)
    assert stale_delete_new['status'] == 0 and m.get(TCB) == 0
    # Old CPU0 is still paused just after unlock; it must not need either old
    # storage even though the same-address new generation was created/completed.
    m.observer_core1 = False
    for r, value in old_cpu0.items():
        m.u.reg_write(r, value)
    m.logging = True
    m.remove_old()
    m.phase = 'cpu0_tail_after_same_address_reincarnation'
    result = m.resume_next(0xA03C1D40)
    cases.append(dict(name='stale_state1_receipt_deletes_new_completed_generation',
        stale_query_output=stale['output'], old_delete_status=deleted_old['status'],
        original_create_status=created['status'], newly_suspended_delete_status=rejects_new_suspended['status'],
        new_completed_query_output=new_query['output'], stale_delete_new_status=stale_delete_new['status'],
        same_tcb_address=hex(TCB), new_task_stack=hex(0x71004000),
        cpu0_tail_after_reincarnation=result, substitutions=m.stub_calls,
        modeled_mpidr_sites=[hex(x) for x in sorted(m.modeled_mpidr_sites)],
        limits='Synthetic ready/current dispatch assignment for new CPU1 task; original create and saved-frame restore/entry return/query/delete execute. Demonstrates API generation gap if exclusive ownership is violated, not a permitted reuse protocol.'))

    a.output.mkdir(parents=True, exist_ok=False)
    exports = {}
    # Explicit instruction ranges, including scheduler assembly Ghidra assigned
    # to noncontiguous functions, raw IRQ/FIQ entry and return glue.
    export_specs = [
        (0xA03C1C8C, 0xA03C1D4C, MD), (0xA03C08F4, 0xA03C09F8, MD),
        (0xA03BFA60, 0xA03BFBCC, MD), (0xA03BFBE8, 0xA03BFC88, MD),
        (0xA03BFF24, 0xA03C00BC, MD), (0xA03C00D8, 0xA03C0164, MD),
        (0xA03BC150, 0xA03BC168, MD), (0xA03BC2BC, 0xA03BC30C, MD),
        (0xA03C158C, 0xA03C1620, MD),
        # Original TaskCreate checked/body paths used by the same-address
        # generation case; the memset helper is Thumb.
        (0xA03C4240, 0xA03C448C, MD), (0xA03BFC90, 0xA03BFE70, MD),
        (0xA04F8DEC, 0xA04F8E8E, MD_THUMB),
    ]
    for lo, hi, disassembler in export_specs:
        raw = image[lo - STOP.BASE:hi - STOP.BASE]
        filename = f'{lo:08x}-{hi:08x}.asm'
        (a.output / filename).write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
            for i in disassembler.disasm(raw, lo)) + '\n')
        exports[filename] = dict(start=hex(lo), end_exclusive=hex(hi),
                                 mode='thumb' if disassembler is MD_THUMB else 'arm',
                                 sha256=sha(raw))
    report = dict(schema=1, status='pass', device_access=False, case_count=len(cases), cases=cases,
        image_sha256=STOP.SHA, script_sha256=sha(Path(__file__).read_bytes()),
        dependency=dict(path=str(DEPENDENCY.relative_to(ROOT)), sha256=sha(DEPENDENCY.read_bytes())),
        original_instruction_evidence=exports,
        conclusion='In executed natural completion, old-stack last read A03C1CE0 and old-TCB last write A03C1D18 precede unlock A03C1D3C. Query/delete after unlock and scheduler/idle exception paths tolerate unmapped old storage. A separate original-create same-address reincarnation shows stale state1 receipt plus pointer can delete a newly completed task: exclusive lifecycle/generation ownership is still required.',
        models=['Synthetic ready-list/current/next/TCB/RAM and next saved contexts; original scheduler removal, context save/restore, task query/delete and SMP lock bytes. The natural-return entry and exit notifier callbacks are synthetic BX LR bytes.',
            'Only exact MPIDR MRC instructions during logical observer/new-task CPU1 execution, hardware clock reader A048EF98 and empty ISR dispatcher A049762C are substituted. Original Thumb memset executes for new TaskCreate.',
            'IRQ/FIQ banked CPSR/SPSR/SP/LR entry is constructed by harness; no physical exception delivery or full device ISR runs.'],
        limitations=['Sequential instruction interleavings do not test cache/coherence visibility or a full multicore scheduler.',
            'The same-address TaskCreate path executes the original checked/body initialization and Thumb memset, but does not model allocator ownership, reset/rebind, or a runtime stack reuse contract; unmapping is an adversarial lifetime check.',
            'Unexamined ISR handlers, callbacks, exceptions, scheduler states and stale external pointers can still access memory. Permanent gateway/code lifetime remains separate.',
            'Natural completed state1 under exclusive lifetime is a candidate; P10 and independent recovery remain incomplete; no deployment authorization.'])
    (a.output / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(status='pass', cases=len(cases), device_access=False)))


if __name__ == '__main__':
    main()
