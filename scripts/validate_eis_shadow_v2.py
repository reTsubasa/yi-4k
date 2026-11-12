#!/usr/bin/env python3
"""Compile and emulate the offline v2 88B EIS shadow wrapper.

This validates ABI/publication semantics against the pinned A0384710 bytes in
Unicorn. It never installs a hook, contacts a camera, or emits a device patch.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import random
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from elftools.elf.elffile import ELFFile
from unicorn import UC_HOOK_CODE
from unicorn.arm_const import *

from eis_filter_replay import (BASE, IMAGE, I32_MAX, I32_MIN, Parameters,
                               load_identity, signed32, stock_step)
from validate_eis_filter_replay import NativeFunction, PREVIOUS, RETURN, STACK

ROOT = Path(__file__).resolve().parents[1]
BUF = 0x10060000
HEADER, STRIDE, CAPACITY = 64, 88, 128
COMMIT_V1, PREVIOUS_AFTER, COMMIT_V2 = 76, 80, 84


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compile_sdk(directory: Path, linker: Path) -> tuple[bytes, dict]:
    flags = ['--target=armv7-none-eabi', '-mcpu=cortex-a9', '-marm', '-mfloat-abi=soft',
             '-mfpu=none', '-ffreestanding', '-fno-builtin', '-fno-stack-protector',
             '-fno-pic', '-fno-unwind-tables', '-fno-asynchronous-unwind-tables',
             '-O2', '-Wall', '-Wextra', '-Werror']
    objects = []
    commands = []
    for source in (ROOT / 'sdk/yi4k_1107_eis_shadow_v2.c',
                   ROOT / 'sdk/yi4k_1107_eis_shadow_v2_veneer.S'):
        target = directory / (source.name + '.o')
        command = ['clang', *flags, '-c', str(source), '-o', str(target)]
        subprocess.run(command, check=True, capture_output=True)
        commands.append(command)
        objects.append(str(target))
    script = directory / 'emulation.ld'
    script.write_text((ROOT / 'sdk/offline/yi4k_eis_shadow_v2_emulation.ld').read_text())
    elf = directory / 'shadow-v2.elf'
    command = [str(linker), '-T', str(script), *objects, '-o', str(elf)]
    subprocess.run(command, check=True, capture_output=True)
    commands.append(command)
    blob = elf.read_bytes()
    parsed = ELFFile(io.BytesIO(blob))
    if any(section['sh_type'] in ('SHT_REL', 'SHT_RELA') and section['sh_size']
           for section in parsed.iter_sections()):
        raise AssertionError('unresolved linked relocations')
    symbols = {symbol.name: symbol['st_value']
               for symbol in parsed.get_section_by_name('.symtab').iter_symbols()
               if symbol.name}
    if any(symbol['st_shndx'] == 'SHN_UNDEF' and symbol.name
           for symbol in parsed.get_section_by_name('.symtab').iter_symbols()):
        raise AssertionError('undefined linked symbol')
    return blob, {'symbols': symbols, 'elf_sha256': hashlib.sha256(blob).hexdigest(),
                  'elf_bytes': len(blob), 'compile_flags': flags, 'commands': commands}


class V2Wrapper(NativeFunction):
    def __init__(self, data: bytes, blob: bytes, symbols: dict):
        super().__init__(data)
        self.symbols = symbols
        self.uc.mem_map(0x10034000, 0x20000)
        self.uc.mem_map(BUF, 0x4000)
        self.uc.mem_map(0xA1A30000, 0x10000)
        parsed = ELFFile(io.BytesIO(blob))
        for section in parsed.iter_sections():
            if section['sh_flags'] & 2 and section['sh_size']:
                contents = section.data() if section['sh_type'] != 'SHT_NOBITS' else bytes(section['sh_size'])
                self.uc.mem_write(section['sh_addr'], contents)
        self.stock_calls = 0
        self.low_sp = STACK

        def hook(uc, address, size, user):
            self.low_sp = min(self.low_sp, uc.reg_read(UC_ARM_REG_SP))
            if address == 0xA0384710:
                if uc.reg_read(UC_ARM_REG_SP) % 8:
                    raise AssertionError('misaligned stock call')
                self.stock_calls += 1

        self.uc.hook_add(UC_HOOK_CODE, hook)
        self.initialize()

    def put32(self, address: int, value: int) -> None:
        self.uc.mem_write(address, struct.pack('<I', value & 0xffffffff))

    def word(self, address: int) -> int:
        return struct.unpack('<I', self.uc.mem_read(address, 4))[0]

    def invoke(self, address: int, args: tuple[int, ...]) -> int:
        uc = self.uc
        uc.reg_write(UC_ARM_REG_CPSR, 0x13)
        uc.reg_write(UC_ARM_REG_FPSCR, 0)
        for register, value in zip((UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3), args):
            uc.reg_write(register, value & 0xffffffff)
        saved = {}
        for index, register in enumerate((UC_ARM_REG_R4, UC_ARM_REG_R5, UC_ARM_REG_R6, UC_ARM_REG_R7,
                                          UC_ARM_REG_R8, UC_ARM_REG_R9, UC_ARM_REG_R10, UC_ARM_REG_R11)):
            saved[register] = 0x51230000 + index * 0x1234
            uc.reg_write(register, saved[register])
        for index in range(8, 16):
            register = globals()[f'UC_ARM_REG_D{index}']
            saved[register] = 0x1234500000000000 + index
            uc.reg_write(register, saved[register])
        uc.reg_write(UC_ARM_REG_SP, STACK)
        uc.reg_write(UC_ARM_REG_LR, RETURN)
        uc.emu_start(address, RETURN, count=50000)
        assert uc.reg_read(UC_ARM_REG_PC) == RETURN
        assert uc.reg_read(UC_ARM_REG_SP) == STACK
        assert all(uc.reg_read(register) == value for register, value in saved.items())
        return signed32(uc.reg_read(UC_ARM_REG_R0))

    def initialize(self) -> None:
        self.uc.mem_write(BUF, bytes(HEADER + STRIDE * CAPACITY))
        self.invoke(self.symbols['yi4k_eis_shadow_v2_initialize'], (BUF,))
        assert self.word(BUF + 4) == 2
        assert self.word(BUF + 12) == STRIDE
        assert self.word(BUF + 16) == 0 and self.word(BUF + 24) == 0
        self.put32(self.symbols['yi4k_eis_shadow_control_v2'], BUF)
        self.put32(self.symbols['yi4k_eis_shadow_control_v2'] + 4,
                   self.symbols['yi4k_eis_shadow_sources_1107_v2'])
        self.put32(BUF + 16, 1)
        self.put32(0xA1A3A528, 123456)

    def set_state(self, previous: int, params: Parameters, count: int) -> None:
        self.put32(PREVIOUS, previous)
        self.put32(0xA170AFEC, params.limit)
        self.uc.mem_write(0xA170AF88, bytes((int(params.adaptive_enabled), count)))
        self.uc.mem_write(0xA0757B54, bytes((params.gain & 255,)))
        self.put32(0xA0757AD4, params.small_motion_degrees)
        self.uc.mem_write(0xA0757AA1, bytes((params.scale_shift & 255,)))
        self.uc.mem_write(0xA0757AD8, bytes((params.small_count_limit,)))
        self.put32(0xA0757ADC, params.adaptive_feedback)

    def call(self, previous: int, current: int, params: Parameters,
             count: int, site: int) -> tuple[int, list[int] | None]:
        self.set_state(previous, params, count)
        before_committed = self.word(BUF + 24)
        output = self.invoke(self.symbols[f'yi4k_eis_shadow_v2_site{site}'],
                             (2, current, PREVIOUS))
        if signed32(self.word(PREVIOUS)) != previous:
            raise AssertionError('stock call changed previous pointer')
        after_committed = self.word(BUF + 24)
        row = None
        if after_committed == before_committed + 1:
            address = BUF + HEADER + before_committed * STRIDE
            row = list(struct.unpack('<22I', self.uc.mem_read(address, STRIDE)))
        return output, row


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--linker', type=Path)
    args = parser.parse_args()
    linkers = sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker = args.linker or (Path(shutil.which('ld.lld')) if shutil.which('ld.lld') else (linkers[-1] if linkers else None))
    if linker is None:
        parser.error('provide existing --linker path to ld.lld')
    identity, defaults = load_identity()
    data = IMAGE.read_bytes()
    disassembler = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    callsite_checks = []
    for address in (0xA03937F0, 0xA0393C00):
        instruction = next(disassembler.disasm(data[address - BASE:address - BASE + 4], address))
        if (instruction.mnemonic, instruction.op_str) != ('bl', '#0xa0384710'):
            raise AssertionError('pinned A0384710 callsite changed')
        callsite_checks.append({'address': hex(address), 'bytes': instruction.bytes.hex()})
    with tempfile.TemporaryDirectory(prefix='yi4k-shadow-v2-') as directory:
        blob, build = compile_sdk(Path(directory), linker)
        wrapper = V2Wrapper(data, blob, build['symbols'])
        rng = random.Random(1107)
        baseline = Parameters(limit=1_000_000, **defaults)
        cases = 0
        for index in range(512):
            wrapper.initialize()
            params = Parameters(**(defaults | {
                'limit': (0, 1, 100, I32_MAX)[index % 4],
                'adaptive_enabled': bool(index % 2),
                'gain': (-128, -1, 0, 100, 127)[index % 5],
            }))
            previous = rng.randrange(I32_MIN, I32_MAX + 1)
            current = rng.randrange(I32_MIN, I32_MAX + 1) if index % 3 else 0
            count = (0, 4, 5, 6, 254, 255)[index % 6]
            expected, next_count, _ = stock_step(previous, current, params, count)
            before_calls = wrapper.stock_calls
            output, row = wrapper.call(previous, current, params, count, 1 + index % 2)
            assert output == expected and wrapper.stock_calls == before_calls + 1
            assert row is not None
            assert row[0:7] == [0, 1 + index % 2, 2, current & 0xffffffff,
                                PREVIOUS, previous & 0xffffffff, expected & 0xffffffff]
            assert row[7:11] == [123456, 123456, count, next_count]
            assert row[19] == 0, 'legacy v1 commit must stay zero'
            assert signed32(row[20]) == previous, 'previous_after mismatch'
            assert row[21] == 1, 'v2 publication marker mismatch'
            cases += 1

        wrapper.initialize()
        for _ in range(CAPACITY + 7):
            output, row = wrapper.call(10, -10, baseline, 0, 1)
            assert output == stock_step(10, -10, baseline, 0)[0]
            assert row is not None or wrapper.word(BUF + 24) >= CAPACITY
        assert wrapper.word(BUF + 24) == CAPACITY
        assert wrapper.word(BUF + 28) == 7
        assert wrapper.word(BUF + HEADER + (CAPACITY - 1) * STRIDE + COMMIT_V1) == 0
        assert wrapper.word(BUF + HEADER + (CAPACITY - 1) * STRIDE + COMMIT_V2) == CAPACITY
        full_validation = {'capacity': CAPACITY, 'record_bytes': STRIDE,
                           'buffer_bytes': HEADER + STRIDE * CAPACITY,
                           'additional_calls': 7, 'dropped_full': 7,
                           'legacy_commit_zero': True, 'previous_after_checked': True}

        wrapper.initialize()
        wrapper.put32(BUF + 16, 0)
        before = wrapper.stock_calls
        output, row = wrapper.call(10, -10, baseline, 0, 1)
        assert row is None and wrapper.stock_calls == before + 1
        assert output == stock_step(10, -10, baseline, 0)[0]
        report = {
            'target': identity,
            'evidence_kind': 'offline compiled v2 C/A32 wrapper and pinned stock filter in Unicorn',
            'sdk_sources': {str(path.relative_to(ROOT)): sha(path) for path in (
                ROOT / 'sdk/yi4k_1107_eis_shadow.h', ROOT / 'sdk/yi4k_1107_eis_shadow_v2.h',
                ROOT / 'sdk/yi4k_1107_eis_shadow_v2.c', ROOT / 'sdk/yi4k_1107_eis_shadow_v2_veneer.S',
                ROOT / 'sdk/offline/yi4k_eis_shadow_v2_emulation.ld')},
            'build': build,
            'callsite_checks': callsite_checks,
            'record_layout': {'version': 2, 'record_bytes': STRIDE,
                              'legacy_commit_offset': COMMIT_V1,
                              'previous_after_offset': PREVIOUS_AFTER,
                              'commit_v2_offset': COMMIT_V2,
                              'buffer_bytes': HEADER + STRIDE * CAPACITY},
            'differential_wrapper_cases': cases,
            'mismatches': 0,
            'full_buffer_validation': full_validation,
            'disarmed_stock_bypass': True,
            'maximum_observed_stack_use_bytes': STACK - wrapper.low_sp,
            'limitations': [
                'Synthetic ELF addresses only; no loader, hook installation, or device entry exists.',
                'Unicorn does not prove SMP exclusive-monitor behavior, cache publication, timing, or rollback.',
                'The v2 object is a host-side integration candidate and is not a flashable payload.',
            ],
            'device_contacted': False,
        }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'wrapper_cases': cases, 'mismatches': 0,
                      'record_bytes': STRIDE, 'output': str(args.output),
                      'device_contacted': False}, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
