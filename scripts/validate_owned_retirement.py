#!/usr/bin/env python3
"""Host/ARM owned lifecycle failures, ARM instruction interleavings, host threads."""
import argparse
import ctypes as ct
import hashlib
import io
import json
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [ROOT / 'sdk/yi4k_1107_owned_retirement.c',
           ROOT / 'sdk/offline/yi4k_owned_retirement_test.c']
THREADS = ROOT / 'sdk/offline/yi4k_owned_retirement_threads.c'
CASES = ['normal_order_and_once_only_release', 'revoke_failure_retains',
         'request_failure_retains', 'stop_proof_failure_retains',
         'task_delete_failure_retains', 'inflight_delays_proof_and_release',
         'limit_and_two_inflight_drain', 'reentrant_controller_rejected',
         'drain_alone_does_not_prove_stop', 'invalid_services_rejected']
REGS = [UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3,
        UC_ARM_REG_R4, UC_ARM_REG_R5, UC_ARM_REG_R6, UC_ARM_REG_R7,
        UC_ARM_REG_R8, UC_ARM_REG_R9, UC_ARM_REG_R10, UC_ARM_REG_R11,
        UC_ARM_REG_R12, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR]


def sha(blob):
    return hashlib.sha256(blob).hexdigest()


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', required=True, type=Path)
    a = p.parse_args()
    clang = shutil.which('clang')
    linkers = sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker = shutil.which('ld.lld') or (str(linkers[-1]) if linkers else None)
    assert clang and linker
    common = ['-std=c11', '-O2', '-Wall', '-Wextra', '-Werror', '-fno-builtin']
    flags = ['--target=armv7-none-eabi', '-mcpu=cortex-a9', '-marm', '-mfloat-abi=soft',
             '-mfpu=none', '-ffreestanding', '-fno-stack-protector', '-fno-pic',
             '-fno-unwind-tables', '-fno-asynchronous-unwind-tables', *common]
    commands = []

    def build(command):
        result = subprocess.run(command, capture_output=True, text=True)
        assert result.returncode == 0, result.stderr
        commands.append(command)

    with tempfile.TemporaryDirectory(prefix='yi4k-retirement-') as temp:
        directory = Path(temp)
        host = directory / 'retirement.dylib'
        build([clang, '-shared', '-fPIC', '-pthread', *common,
               *map(str, SOURCES), str(THREADS), '-o', str(host)])
        objects = []
        for source in SOURCES:
            obj = directory / (source.name + '.o')
            build([clang, *flags, '-c', str(source), '-o', str(obj)])
            objects.append(str(obj))
        ld = directory / 'retirement.ld'
        ld.write_text((ROOT / 'sdk/offline/yi4k_payload_copy_emulation.ld').read_text().replace(
            'ENTRY(yi4k_1107_copy_payload)', 'ENTRY(yi4k_owned_retirement_test)'))
        target = directory / 'retirement.elf'
        build([linker, '-T', str(ld), *objects, '-o', str(target)])
        blob = target.read_bytes()
        elf = ELFFile(io.BytesIO(blob))
        symbols = list(elf.get_section_by_name('.symtab').iter_symbols())
        assert not any(s.name and s['st_shndx'] == 'SHN_UNDEF' for s in symbols)
        assert not any(s['sh_type'] in ('SHT_REL', 'SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        functions = {s.name: dict(address=s['st_value'], bytes=s['st_size'])
                     for s in symbols if s['st_info']['type'] == 'STT_FUNC'}
        report_at = next(s['st_value'] for s in symbols if s.name == 'yi4k_retirement_test_report')

        def machine():
            m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
            m.mem_map(0x10030000, 0x20000)
            m.mem_map(0x23000000, 0x10000)
            for section in elf.iter_sections():
                if section['sh_flags'] & 2 and section['sh_size']:
                    m.mem_write(section['sh_addr'], section.data() if section['sh_type'] != 'SHT_NOBITS' else bytes(section['sh_size']))
            m.reg_write(UC_ARM_REG_CPSR, 0x13)
            return m

        def call(m, name, argument=0):
            saved = {r: 0x51230000 + n * 0x1234 for n, r in enumerate(REGS[4:12])}
            for r, v in saved.items():
                m.reg_write(r, v)
            m.reg_write(UC_ARM_REG_R0, argument)
            m.reg_write(UC_ARM_REG_SP, 0x23008000)
            m.reg_write(UC_ARM_REG_LR, 0x1004ff00)
            m.emu_start(functions[name]['address'], 0x1004ff00, count=1000000)
            assert m.reg_read(UC_ARM_REG_PC) == 0x1004ff00
            assert m.reg_read(UC_ARM_REG_SP) == 0x23008000
            assert all(m.reg_read(r) == v for r, v in saved.items())
            return m.reg_read(UC_ARM_REG_R0)

        library = ct.CDLL(str(host))
        test = library.yi4k_owned_retirement_test
        test.argtypes = [ct.c_uint32]
        test.restype = ct.c_int
        host_report = (ct.c_uint32 * 16).in_dll(library, 'yi4k_retirement_test_report')
        rows = []
        for n, name in enumerate(CASES):
            status = test(n)
            assert status == 0, (name, 'host', status)
            host_words = list(host_report)
            m = machine()
            status = call(m, 'yi4k_owned_retirement_test', n)
            assert status == 0, (name, 'ARM', status)
            arm_words = list(struct.unpack('<16I', m.mem_read(report_at, 64)))
            assert arm_words == host_words
            rows.append(dict(name=name, host_status=0, arm_status=0,
                             report=arm_words, matching_reports=True,
                             callee_saved_and_sp_preserved=True))

        # Explicit instruction interleavings on compiled ARM. Stop just BEFORE
        # LDREX, or just AFTER successful STREX, and execute the real close/
        # finish functions on a separate stack. No C source or instruction patch.
        m = machine()
        entry = functions['yi4k_1107_retirement_enter']
        instructions = list(Cs(CS_ARCH_ARM, CS_MODE_ARM).disasm(
            bytes(m.mem_read(entry['address'], entry['bytes'])), entry['address']))
        exclusive = [i for i in instructions if i.mnemonic == 'ldrex']
        stores = [i for i in instructions if i.mnemonic == 'strex']
        assert len(exclusive) == len(stores) == 1
        interleavings = []
        for name, stop_at in [('close_before_admission_cas', exclusive[0].address),
                              ('close_after_admission_cas', stores[0].address + stores[0].size)]:
            m = machine()
            assert call(m, 'yi4k_retirement_race_setup') == 0

            def hook(u, at, size, user):
                if at == stop_at:
                    u.emu_stop()

            handle = m.hook_add(UC_HOOK_CODE, hook)
            m.reg_write(UC_ARM_REG_SP, 0x23008000)
            m.reg_write(UC_ARM_REG_LR, 0x1004ff00)
            m.emu_start(functions['yi4k_retirement_race_enter']['address'], 0x1004ff00, count=10000)
            assert m.reg_read(UC_ARM_REG_PC) == stop_at
            m.hook_del(handle)
            saved = {r: m.reg_read(r) for r in REGS}
            # Only architectural registers are saved. Interleaving occurs
            # outside the exclusive interval, so no monitor state is restored.
            m.reg_write(UC_ARM_REG_SP, 0x2300d000)
            m.reg_write(UC_ARM_REG_LR, 0x1004ff00)
            m.emu_start(functions['yi4k_retirement_race_close_finish']['address'], 0x1004ff00, count=100000)
            closed_result = m.reg_read(UC_ARM_REG_R0)
            assert m.reg_read(UC_ARM_REG_PC) == 0x1004ff00
            for r, v in saved.items():
                m.reg_write(r, v)
            m.emu_start(stop_at, 0x1004ff00, count=100000)
            entered_result = m.reg_read(UC_ARM_REG_R0)
            assert m.reg_read(UC_ARM_REG_PC) == 0x1004ff00
            if name == 'close_before_admission_cas':
                assert closed_result == 8 and entered_result == 2
            else:
                assert closed_result == 4 and entered_result == 0
                assert call(m, 'yi4k_retirement_race_leave_finish') == 0
            interleavings.append(dict(name=name, stop_at=hex(stop_at),
                finish_result=closed_result, enter_result=entered_result, passed=True))

        stress = library.yi4k_owned_retirement_thread_test
        stress.restype = ct.c_int
        for _ in range(20):
            assert stress() == 0
        thread_report = list((ct.c_uint32 * 8).in_dll(library, 'yi4k_retirement_thread_report'))
        report = dict(status='pass', device_access=False, cases=rows,
            host_and_arm_cases=len(rows), arm_instruction_interleavings=interleavings,
            host_concurrency=dict(runs=20, admitted_per_run=6,
                rejected_after_close_per_run=12000, final_report=thread_report,
                controlled_controller_overlap=True, external_stop_proof='pthread_join completion'),
            build=dict(commands=commands, arm_elf_sha256=sha(blob),
                host_library_sha256=sha(host.read_bytes()), undefined_symbols=0,
                linked_relocations=0, functions=functions),
            source_sha256={str(x.relative_to(ROOT)): sha(x.read_bytes()) for x in [*SOURCES,
                THREADS, ROOT/'sdk/yi4k_1107_owned_retirement.h', Path(__file__)]},
            limitations=['External revoke/stop/verify/delete/release services are fixtures, not camera bindings.',
                'Caller must keep guard/code/context alive across every late entrant; no guard self-reclamation.',
                'No firmware destructor, scheduler, code publication, hardware cache, or camera operation.',
                'No device deployment is authorized; actual ingress revocation and scheduler stopped proof remain unimplemented.'])
        a.output.mkdir(parents=True, exist_ok=False)
        (a.output/'validation.json').write_text(json.dumps(report, indent=2)+'\n')
        (a.output/'retirement-enter.asm').write_text('\n'.join(
            f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in instructions)+'\n')
    print(json.dumps(dict(status='pass', host_arm_cases=len(rows), arm_interleavings=2,
                         host_thread_runs=20, device_access=False)))


if __name__ == '__main__':
    main()
