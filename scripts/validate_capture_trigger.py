#!/usr/bin/env python3
"""Compile pure C capture router for host/ARM; execute same tests in Unicorn.

No firmware image, device connection, patch address, loader or writer is used.
"""
import hashlib
import io
import json
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path

from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'artifacts/offline/2026-11-10-capture-trigger'
CODE=0x10000000
STACK=0x2001F000
RETURN=0x100FF000


def main():
    candidates=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker=shutil.which('ld.lld') or (str(candidates[-1]) if candidates else None)
    if not linker:raise SystemExit('An existing ld.lld is required for offline ARM linking')
    clang=shutil.which('clang')
    sources=[ROOT/'sdk/yi4k_capture_trigger.c',ROOT/'sdk/offline/yi4k_capture_trigger_test.c']
    inputs=[*sources,ROOT/'sdk/yi4k_capture_trigger.h']
    commands=[]
    def command(args):
        commands.append([str(x) for x in args])
        completed=subprocess.run(args,check=True,capture_output=True,text=True)
        return completed.stdout
    with tempfile.TemporaryDirectory(prefix='yi4k-capture-trigger-') as temp:
        build=Path(temp)
        native=build/'capture-host'
        host=command([clang,'-std=c11','-O2','-Wall','-Wextra','-Werror','-DYI4K_HOST_TEST',
                      *map(str,sources),'-o',str(native)])
        host=command([str(native)])
        flags=['--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft',
            '-mfpu=none','-std=c11','-O2','-ffreestanding','-fno-builtin','-fno-stack-protector',
            '-fno-pic','-fno-unwind-tables','-fno-asynchronous-unwind-tables',
            '-Wall','-Wextra','-Werror']
        objects=[]
        for source in sources:
            obj=build/(source.name+'.o');objects.append(str(obj))
            command([clang,*flags,'-c',str(source),'-o',str(obj)])
        ld=build/'offline.ld'
        ld.write_text('ENTRY(yi4k_capture_router_selftest)\nSECTIONS {\n'
            ' . = 0x10000000; .text : { *(.text*) }\n'
            ' .rodata : { *(.rodata*) } .ARM.exidx : { *(.ARM.exidx*) }\n'
            ' .data : { *(.data*) } .bss : { *(.bss*) *(COMMON) }\n}\n')
        target=build/'capture-trigger-offline.elf'
        command([linker,'-T',str(ld),*objects,'-o',str(target)])
        blob=target.read_bytes()
    elf=ELFFile(io.BytesIO(blob))
    syms={s.name:s['st_value'] for s in elf.get_section_by_name('.symtab').iter_symbols() if s.name}
    assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in elf.get_section_by_name('.symtab').iter_symbols())
    assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
    uc=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    uc.mem_map(CODE,0x100000);uc.mem_map(0x20000000,0x20000)
    for section in elf.iter_sections():
        if section['sh_flags']&2 and section['sh_size']:
            assert CODE <= section['sh_addr'] < RETURN
            uc.mem_write(section['sh_addr'],bytes(section['sh_size']) if section['sh_type']=='SHT_NOBITS' else section.data())
    saved={}
    for i,reg in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,
                           UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11)):
        saved[reg]=0x51230000+i*0x1234
    for i in range(8,16):saved[globals()[f'UC_ARM_REG_D{i}']]=0x1234500000000000+i
    for reg,value in saved.items():uc.reg_write(reg,value)
    uc.reg_write(UC_ARM_REG_CPSR,0x13)
    uc.reg_write(UC_ARM_REG_SP,STACK);uc.reg_write(UC_ARM_REG_LR,RETURN)
    stats=dict(instructions=0,lowest_sp=STACK,aligned_calls=0)
    def hook(machine,address,size,user):
        stats['instructions']+=1
        stats['lowest_sp']=min(stats['lowest_sp'],machine.reg_read(UC_ARM_REG_SP))
        opcode=struct.unpack('<I',machine.mem_read(address,4))[0]
        if opcode&0x0F000000==0x0B000000 or opcode&0xFE000000==0xFA000000:
            assert machine.reg_read(UC_ARM_REG_SP)%8==0,'misaligned ARM call boundary'
            stats['aligned_calls']+=1
    uc.hook_add(UC_HOOK_CODE,hook)
    uc.emu_start(syms['yi4k_capture_router_selftest'],RETURN,count=10000000)
    assert uc.reg_read(UC_ARM_REG_PC)==RETURN,'ARM instruction budget exhausted'
    assert uc.reg_read(UC_ARM_REG_R0)==0,f"ARM selftest failed at C line {uc.reg_read(UC_ARM_REG_R0)}"
    assert uc.reg_read(UC_ARM_REG_SP)==STACK
    assert all(uc.reg_read(reg)==value for reg,value in saved.items()),'callee-saved ABI corruption'
    checks=struct.unpack('<I',uc.mem_read(syms['yi4k_capture_test_checks'],4))[0]
    assert host.strip()==f'PASS: {checks} capture-router checks'
    # AAPCS exported entries and each direct BL use eight-byte aligned stacks.
    # The selftest itself enforces the exact host/ARM structure layout via the
    # public header's static assertions; no addresses from camera firmware exist.
    report=dict(host=host.strip(),arm_checks=checks,arm_selftest_return=0,
        callee_saved_r4_r11=True,callee_saved_d8_d15=True,stack_restored=True,
        stack_bytes_used=STACK-stats['lowest_sp'],instructions=stats['instructions'],
        aligned_call_boundaries=stats['aligned_calls'],
        elf_sha256=hashlib.sha256(blob).hexdigest(),elf_bytes=len(blob),symbols=syms,
        input_sha256={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs},
        commands=commands,arm_flags=flags,device_access=False,device_write=False,
        prerecord_backend_implemented=False,
        synchronization='All operations and async completions serialized on one owner thread or one external lock.',
        limitations=['Backend is absent; intents and synthetic completion events only.',
          'Host/ARM same deterministic suite, not actual camera/audio/file/encoder testing.',
          'Short/long classification and debounce belong to the hardware adapter.',
          'No trampoline, address patch, runtime loader, stock call or persistent setting write.'])
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    (OUT/'capture-trigger-offline.elf').write_bytes(blob)
    print(f'PASS: host + ARM {checks} semantic checks; R4-R11/D8-D15/SP preserved; stack {report["stack_bytes_used"]} bytes; no device access')


if __name__=='__main__':main()
