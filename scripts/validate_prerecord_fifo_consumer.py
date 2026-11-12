#!/usr/bin/env python3
"""Compile/execute the native consumer on host and offline ARM with injected ops."""
import ctypes as ct
import hashlib
import io
import json
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path
from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-fifo-consumer-validation.json'
SOURCES=[ROOT/'sdk/yi4k_1107_fifo_consumer.c', ROOT/'sdk/yi4k_1107_payload_copy.c',
         ROOT/'sdk/offline/yi4k_fifo_consumer_test.c']
CASES=['normal_order_and_two_span_copy','create_failure_with_handle','create_failure_without_handle',
       'create_zero_status_null_handle','read_guard_failure','peek_empty','peek_overlap',
       'peek_zero_status_null_pointer','persist_failure_then_retry','copy_capacity_short',
       'copy_invalid_payload','remove_failure_after_cursor_advance','high_level_eos','raw_eos',
       'quiesce_failure_then_retry','delete_failure_handle_retained','peek_invalid_handle',
       'synchronous_reentry_rejected','bad_start_arguments','missing_quiesce_rejected']


def sha(data):return hashlib.sha256(data).hexdigest()


def main():
    clang=shutil.which('clang');assert clang
    linkers=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker=shutil.which('ld.lld') or (str(linkers[-1]) if linkers else None);assert linker
    common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin']
    flags=['--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none',
           '-ffreestanding','-fno-stack-protector','-fno-pic','-fno-unwind-tables',
           '-fno-asynchronous-unwind-tables',*common]
    with tempfile.TemporaryDirectory(prefix='yi4k-consumer-') as temp:
        directory=Path(temp);commands=[]
        library_path=directory/'consumer.dylib'
        command=[clang,'-shared','-fPIC',*common,*map(str,SOURCES),'-o',str(library_path)]
        subprocess.run(command,check=True,capture_output=True);commands.append(command)
        objects=[]
        for source in SOURCES:
            obj=directory/(source.name+'.o');objects.append(str(obj))
            command=[clang,*flags,'-c',str(source),'-o',str(obj)]
            subprocess.run(command,check=True,capture_output=True);commands.append(command)
        script=directory/'consumer.ld'
        script.write_text((ROOT/'sdk/offline/yi4k_payload_copy_emulation.ld').read_text().replace(
            'ENTRY(yi4k_1107_copy_payload)','ENTRY(yi4k_fifo_consumer_test)'))
        target=directory/'consumer.elf'
        command=[linker,'-T',str(script),*objects,'-o',str(target)]
        subprocess.run(command,check=True,capture_output=True);commands.append(command)
        blob=target.read_bytes();elf=ELFFile(io.BytesIO(blob))
        symbols=list(elf.get_section_by_name('.symtab').iter_symbols())
        assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        functions={s.name:dict(address=s['st_value'],bytes=s['st_size']) for s in symbols if s['st_info']['type']=='STT_FUNC'}
        report_address=next(s['st_value'] for s in symbols if s.name=='yi4k_fifo_test_report')
        library=ct.CDLL(str(library_path));function=library.yi4k_fifo_consumer_test
        function.argtypes=[ct.c_uint32];function.restype=ct.c_int
        host_report=(ct.c_uint32*16).in_dll(library,'yi4k_fifo_test_report')
        rows=[]
        for index,name in enumerate(CASES):
            host_status=function(index);assert host_status==0,(name,'host',host_status)
            host_words=list(host_report)
            m=Uc(UC_ARCH_ARM,UC_MODE_ARM)
            m.mem_map(0x10030000,0x20000);m.mem_map(0x23000000,0x10000)
            for section in elf.iter_sections():
                if section['sh_flags']&2 and section['sh_size']:
                    m.mem_write(section['sh_addr'],section.data() if section['sh_type']!='SHT_NOBITS' else bytes(section['sh_size']))
            m.reg_write(UC_ARM_REG_CPSR,0x13)
            saved={r:0x51230000+i*0x1234 for i,r in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,
                UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
            for r,v in saved.items():m.reg_write(r,v)
            m.reg_write(UC_ARM_REG_R0,index);m.reg_write(UC_ARM_REG_SP,0x23008000)
            m.reg_write(UC_ARM_REG_LR,0x1004ff00)
            m.emu_start(functions['yi4k_fifo_consumer_test']['address'],0x1004ff00,count=1000000)
            assert m.reg_read(UC_ARM_REG_PC)==0x1004ff00 and m.reg_read(UC_ARM_REG_SP)==0x23008000
            assert all(m.reg_read(r)==v for r,v in saved.items())
            status=m.reg_read(UC_ARM_REG_R0);assert status==0,(name,'ARM',status)
            arm_words=list(struct.unpack('<16I',m.mem_read(report_address,64)))
            assert arm_words==host_words,(name,arm_words,host_words)
            rows.append(dict(name=name,host_status=host_status,compiled_arm_status=status,report=arm_words,
                             host_and_arm_match=True,callee_saved_and_sp_preserved=True))
        data=dict(evidence_type='Actual consumer C and payload-copy C compiled and executed on host and offline ARM, using test-only injected services',
            case_count=len(rows),host_execution_count=len(rows),arm_execution_count=len(rows),cases=rows,
            report_fields=['final_state','last_backend_status','frames_persisted','create_calls','begin_calls',
                'peek_calls','persist_calls','remove_calls','end_calls','quiesce_calls','delete_calls',
                'modeled_cursor_advances','busy_reentry_rejections','handle_is_null','last_copy_status','reserved'],
            build=dict(commands=commands,clang_version=subprocess.check_output([clang,'--version'],text=True).splitlines()[0],
                linker_version=subprocess.check_output([linker,'--version'],text=True).strip(),arm_elf_sha256=sha(blob),
                host_library_sha256=sha(library_path.read_bytes()),undefined_symbols=0,linked_relocations=0,
                functions=functions,source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in SOURCES},
                headers_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in (
                  ROOT/'sdk/yi4k_1107_fifo_consumer.h',ROOT/'sdk/yi4k_1107_payload_copy.h',ROOT/'sdk/yi4k_1107_video_descriptor.h')}),
            limitations=['Injected read guard/quiesce/persist/stock API services are deterministic test fixtures, not camera backend implementations.',
               'No runtime stock API addresses are bound, and no callback bridge, RTOS worker, real registry verifier or global lifecycle lock is implemented.',
               'The state machine is for one serialized owner; busy detects synchronous reentry only, not concurrent threads.',
               'Actual payload mapping, stable producer retention, DMA/cache coherence and delete quiescence remain required integration evidence.',
               'No actual FIFO, file, encoder, MP4 mux or camera was operated.'],device_access=False)
    OUT.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),cases=len(rows),host_executions=len(rows),arm_executions=len(rows))))


if __name__=='__main__':main()
