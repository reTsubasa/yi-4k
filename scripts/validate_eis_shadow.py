#!/usr/bin/env python3
"""Compile and emulate the EIS shadow wrapper; never patch/contact a camera."""
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
from elftools.elf.elffile import ELFFile
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import UC_HOOK_CODE
from unicorn.arm_const import *
from eis_filter_replay import BASE, IMAGE, I32_MIN, I32_MAX, Parameters, load_identity, signed32, stock_step
from validate_eis_filter_replay import NativeFunction, STACK, PREVIOUS, RETURN

ROOT = Path(__file__).resolve().parents[1]
BUF = 0x10060000
HEADER, STRIDE, CAPACITY = 64, 80, 128

# Test-only stub deliberately calls the wrapper recursively once before the
# outer stock call. This object is absent from the normal integration build.
NESTED_ASM = '''
.syntax unified
.arch armv7-a
.arm
.text
.global yi4k_eis_shadow_nested_stock
yi4k_eis_shadow_nested_stock:
  push {r4-r8, lr}
  mov r4, r0
  mov r5, r1
  mov r6, r2
  mov r7, #0
  ldr r8, =nested_guard
  ldr r3, [r8]
  cmp r3, #0
  bne 1f
  mov r7, #1
  str r7, [r8]
  bl yi4k_eis_shadow_site2
1:
  mov r0, r4
  mov r1, r5
  mov r2, r6
  movw ip, #0x4710
  movt ip, #0xa038
  blx ip
  cmp r7, #0
  movne r3, #0
  strne r3, [r8]
  pop {r4-r8, pc}
.bss
.align 2
nested_guard: .space 4
'''


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compile_sdk(directory: Path, linker: Path, nested: bool = False) -> tuple[bytes, dict]:
    c = ROOT/'sdk/yi4k_1107_eis_shadow.c'
    asm = ROOT/'sdk/yi4k_1107_eis_shadow_veneer.S'
    flags = ['--target=armv7-none-eabi', '-mcpu=cortex-a9', '-marm', '-mfloat-abi=soft', '-mfpu=none',
             '-ffreestanding', '-fno-builtin', '-fno-stack-protector', '-fno-pic',
             '-fno-unwind-tables', '-fno-asynchronous-unwind-tables', '-O2', '-Wall', '-Wextra', '-Werror']
    commands = []
    objects = []
    for source in (c, asm):
        target = directory/(source.name+'.o')
        command = ['clang', *flags, '-c', str(source), '-o', str(target)]
        subprocess.run(command, check=True, capture_output=True)
        commands.append(command)
        objects.append(str(target))
    script = (ROOT/'sdk/offline/yi4k_eis_shadow_emulation.ld').read_text()
    if nested:
        source = directory/'nested.S'
        source.write_text(NESTED_ASM)
        obj = directory/'nested.o'
        command = ['clang', *flags, '-c', str(source), '-o', str(obj)]
        subprocess.run(command, check=True, capture_output=True)
        commands.append(command)
        objects.append(str(obj))
        script = script.replace('yi4k_eis_stock_filter = 0xA0384710;',
                                'yi4k_eis_stock_filter = yi4k_eis_shadow_nested_stock;')
    ld = directory/'emulation.ld'
    ld.write_text(script)
    elfpath = directory/'shadow.elf'
    command = [str(linker), '-T', str(ld), *objects, '-o', str(elfpath)]
    subprocess.run(command, check=True, capture_output=True)
    commands.append(command)
    blob = elfpath.read_bytes()
    elf = ELFFile(io.BytesIO(blob))
    if any(section['sh_type'] in ('SHT_REL', 'SHT_RELA') and section['sh_size'] for section in elf.iter_sections()):
        raise AssertionError('unresolved linked relocations')
    symbols = {s.name: s['st_value'] for s in elf.get_section_by_name('.symtab').iter_symbols() if s.name}
    if any(s['st_shndx']=='SHN_UNDEF' and s.name for s in elf.get_section_by_name('.symtab').iter_symbols()):
        raise AssertionError('undefined linked symbol')
    return blob, {'symbols': symbols, 'elf_sha256': hashlib.sha256(blob).hexdigest(),
                  'elf_bytes': len(blob), 'compile_flags': flags, 'commands': commands,
                  'test_only_nested_stub': nested}


class Wrapper(NativeFunction):
    def __init__(self, data: bytes, blob: bytes, symbols: dict):
        super().__init__(data)
        uc = self.uc
        self.symbols = symbols
        uc.mem_map(0x10030000, 0x20000)
        uc.mem_map(BUF, 0x4000)
        uc.mem_map(0xA1A30000, 0x10000)
        elf = ELFFile(io.BytesIO(blob))
        for section in elf.iter_sections():
            if section['sh_flags'] & 2 and section['sh_size']:
                content = section.data() if section['sh_type'] != 'SHT_NOBITS' else bytes(section['sh_size'])
                uc.mem_write(section['sh_addr'], content)
        self.stock_calls = 0
        self.instructions = 0
        self.low_sp = STACK
        def hook(uc, address, size, user):
            self.instructions += 1
            self.low_sp = min(self.low_sp, uc.reg_read(UC_ARM_REG_SP))
            if address == 0xA0384710:
                assert uc.reg_read(UC_ARM_REG_SP) % 8 == 0, 'misaligned stock call'
                self.stock_calls += 1
        self.hook = uc.hook_add(UC_HOOK_CODE, hook)
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
            saved[register] = 0x51230000 + index*0x1234
            uc.reg_write(register, saved[register])
        for index in range(8, 16):
            register = globals()[f'UC_ARM_REG_D{index}']
            saved[register] = 0x1234500000000000 + index
            uc.reg_write(register, saved[register])
        uc.reg_write(UC_ARM_REG_SP, STACK)
        uc.reg_write(UC_ARM_REG_LR, RETURN)
        uc.emu_start(address, RETURN, count=50000)
        assert uc.reg_read(UC_ARM_REG_PC) == RETURN, 'instruction bound expired'
        assert uc.reg_read(UC_ARM_REG_SP) == STACK, 'stack not restored'
        assert all(uc.reg_read(register) == value for register, value in saved.items()), 'callee-saved register changed'
        return signed32(uc.reg_read(UC_ARM_REG_R0))

    def initialize(self) -> None:
        self.uc.mem_write(BUF, bytes(HEADER+STRIDE*CAPACITY))
        self.invoke(self.symbols['yi4k_eis_shadow_initialize'], (BUF,))
        assert self.word(BUF+16) == 0 and self.word(BUF+24) == 0
        self.put32(self.symbols['yi4k_eis_shadow_control'], BUF)
        self.put32(self.symbols['yi4k_eis_shadow_control']+4, self.symbols['yi4k_eis_shadow_sources_1107'])
        self.put32(BUF+16, 1)
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

    def call(self, previous: int, current: int, params: Parameters, count: int, site: int = 1) -> tuple[int, list[int] | None]:
        self.set_state(previous, params, count)
        before_count = self.word(BUF+24)
        output = self.invoke(self.symbols[f'yi4k_eis_shadow_site{site}'], (2, current, PREVIOUS))
        assert signed32(self.word(PREVIOUS)) == previous
        after_count = self.word(BUF+24)
        row = None
        if after_count == before_count + 1:
            row = list(struct.unpack('<20I', self.uc.mem_read(BUF+HEADER+before_count*STRIDE, STRIDE)))
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
    checks = []
    for address in (0xA03937F0, 0xA0393C00):
        ins = next(disassembler.disasm(data[address-BASE:address-BASE+4], address))
        assert (ins.mnemonic, ins.op_str) == ('bl', '#0xa0384710')
        checks.append({'address': hex(address), 'bytes': ins.bytes.hex(), 'instruction': ins.mnemonic+' '+ins.op_str,
                       'return_address': hex(address+4)})
    with tempfile.TemporaryDirectory(prefix='yi4k-shadow-') as tmp:
        normal_dir, nested_dir = Path(tmp)/'normal', Path(tmp)/'nested'
        normal_dir.mkdir(); nested_dir.mkdir()
        blob, build = compile_sdk(normal_dir, linker)
        nested_blob, nested_build = compile_sdk(nested_dir, linker, nested=True)
        wrapper = Wrapper(data, blob, build['symbols'])
        params = Parameters(limit=1000000, **defaults)
        rng = random.Random(1107)
        cases = 0
        for index in range(512):
            wrapper.initialize()
            adaptive = bool(index%2)
            p = Parameters(**(defaults | {'limit': [0, 1, 100, I32_MAX][index%4],
                                         'adaptive_enabled': adaptive, 'gain': [-128,-1,0,100,127][index%5]}))
            previous = rng.randrange(I32_MIN,I32_MAX+1)
            current = rng.randrange(I32_MIN,I32_MAX+1) if index%3 else 0
            count = [0,4,5,6,254,255][index%6]
            expected, next_count, _ = stock_step(previous, current, p, count)
            before_calls = wrapper.stock_calls
            site = 1+index%2
            output, row = wrapper.call(previous, current, p, count, site)
            assert output == expected and wrapper.stock_calls == before_calls+1
            assert row is not None
            assert row[0:7] == [0,site,2,current&0xffffffff,PREVIOUS,previous&0xffffffff,expected&0xffffffff]
            assert row[7:11] == [123456,123456,count,next_count]
            assert row[11:18] == [p.limit, p.gain&0xffffffff, int(p.adaptive_enabled), p.small_motion_degrees&0xffffffff,
                                   p.scale_shift&0xffffffff,p.small_count_limit,p.adaptive_feedback&0xffffffff]
            assert row[18:20] == [1,1] and wrapper.word(BUF+20)==0
            cases += 1
        wrapper.initialize()
        for index in range(CAPACITY+7):
            output,row=wrapper.call(10,-10,params,0,1+index%2)
            assert output==stock_step(10,-10,params,0)[0]
            assert (row is not None)==(index<CAPACITY)
        assert wrapper.word(BUF+24)==CAPACITY and wrapper.word(BUF+28)==7
        assert wrapper.word(BUF+HEADER+(CAPACITY-1)*STRIDE+76)==CAPACITY
        wrapper.put32(BUF+28,0xffffffff)
        wrapper.call(10,-10,params,0)
        assert wrapper.word(BUF+28)==0xffffffff and wrapper.word(BUF+32)==1
        full_validation={'capacity':CAPACITY,'record_bytes':STRIDE,'buffer_bytes':HEADER+CAPACITY*STRIDE,
                         'additional_calls':7,'dropped_full':7,'saturating_counter_checked':True}
        wrapper.initialize(); wrapper.put32(BUF+20,1)
        output,row=wrapper.call(10,-10,params,0)
        assert row is None and wrapper.word(BUF+36)==1 and wrapper.word(BUF+24)==0 and wrapper.word(BUF+20)==1
        assert output==stock_step(10,-10,params,0)[0]
        bypasses=[]
        for label,address,value in [('disarmed',BUF+16,0),('null_buffer',build['symbols']['yi4k_eis_shadow_control'],0),
                                    ('null_sources',build['symbols']['yi4k_eis_shadow_control']+4,0),('bad_magic',BUF,0)]:
            wrapper.initialize(); wrapper.put32(address,value)
            before=wrapper.stock_calls
            output,row=wrapper.call(10,-10,params,0)
            assert row is None and wrapper.stock_calls==before+1 and output==stock_step(10,-10,params,0)[0]
            bypasses.append(label)
        # A real nested wrapper invocation: record lock is held while the
        # test-only stock stub recursively enters site2, then executes stock.
        nested=Wrapper(data,nested_blob,nested_build['symbols'])
        p=Parameters(**(defaults|{'limit':1000000,'adaptive_enabled':True}))
        expected1,count1,_=stock_step(100,0,p,5)
        expected2,count2,_=stock_step(100,0,p,count1)
        output,row=nested.call(100,0,p,5,1)
        assert output==expected2 and nested.stock_calls==2 and nested.word(BUF+24)==1
        assert row is not None and row[9:11]==[5,count2] and row[18]==3
        assert nested.word(BUF+36)==1 and nested.word(BUF+20)==0
        nested_validation={'true_recursive_call':True,'stock_invocations':2,'records':1,'busy_seen':1,
                           'outer_output':output,'expected_outer_output':expected2,
                           'contention_record_flag':True,'sp_and_callee_saved_preserved':True,
                           'limitation':'Snapshots span nested calls; contention flag marks potential mismatch with one isolated filter invocation.'}
        # Keep only reviewable assembly and JSON. Temp objects/ELFs disappear.
        snippets=[]
        for name in ('yi4k_eis_shadow_site1','yi4k_eis_shadow_site2','yi4k_eis_shadow_dispatch'):
            elf=ELFFile(io.BytesIO(blob)); section=elf.get_section_by_name('.text')
            lo=build['symbols'][name]; sym=next(s for s in elf.get_section_by_name('.symtab').iter_symbols() if s.name==name)
            raw=section.data()[lo-section['sh_addr']:lo-section['sh_addr']+sym['st_size']]
            snippets.append({'symbol':name,'address':hex(lo),'bytes':len(raw),
                             'instructions':[f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in disassembler.disasm(raw,lo)]})
        report={'target':identity,'evidence_kind':'offline compiled C/A32 wrapper and original pinned filter executed in Unicorn',
                'sdk_sources':{str(p.relative_to(ROOT)):sha(p) for p in [ROOT/'sdk/yi4k_1107_eis_shadow.h',ROOT/'sdk/yi4k_1107_eis_shadow.c',
                    ROOT/'sdk/yi4k_1107_eis_shadow_veneer.S',ROOT/'sdk/offline/yi4k_eis_shadow_emulation.ld']},
                'callsite_checks':checks,'build':build,'nested_test_build':nested_build,
                'differential_wrapper_cases':cases,'mismatches':0,'full_buffer_validation':full_validation,
                'preclaimed_lock_bypass':True,'bypasses':bypasses,'nested_validation':nested_validation,
                'callee_saved_core_and_vfp_checked':True,'maximum_observed_stack_use_bytes':STACK-min(wrapper.low_sp,nested.low_sp),
                'snippets':snippets,'device_contacted':False,
                'limitations':['No firmware patch or deployment artifact produced; temporary synthetic-address ELF removed.',
                               'Unicorn does not prove SMP exclusive monitor interference, real task timing, code/cache publication or device execution.',
                               'No live buffer reader, buffer ownership, executable placement, hook installation or removal protocol established.',
                               'busy_seen is a sticky lower-information contention latch, not an exact dropped-call counter.',
                               'A 1ms tick may not resolve wrapper execution time; no real-time budget established.']}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'wrapper_cases':cases,'mismatches':0,'nested_test':True,'full_buffer_test':True,
                      'max_observed_stack_bytes':report['maximum_observed_stack_use_bytes'],'output':str(args.output),'device_contacted':False}))
    return 0

if __name__=='__main__':
    raise SystemExit(main())
