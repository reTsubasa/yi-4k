#!/usr/bin/env python3
"""Compile the payload-copy candidate for host/ARM and execute offline only."""
from __future__ import annotations
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
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-payload-copy-validation.json'
SOURCE = ROOT/'sdk/yi4k_1107_payload_copy.c'
LINK = ROOT/'sdk/offline/yi4k_payload_copy_emulation.ld'
PATTERN = bytes((i*37+11)&255 for i in range(256))
ADDRESSES = dict(ring=0x20000000, destination=0x21000000,
                 descriptor=0x22000000, view=0x22000100, result=0x22000200)
STACK, RETURN = 0x23008000, 0x1004ff00


def sha(data):
    return hashlib.sha256(data).hexdigest()


class Frame(ct.Structure):
    _fields_ = [('sequence', ct.c_uint32), ('reserved', ct.c_uint32),
                ('pts', ct.c_uint64), ('type', ct.c_uint8), ('flags', ct.c_uint8),
                ('reserved12', ct.c_uint16), ('address', ct.c_uint32),
                ('length', ct.c_uint32), ('opaque', ct.c_uint32)]


class View(ct.Structure):
    _fields_ = [('bytes', ct.c_void_p), ('base', ct.c_uint32), ('size', ct.c_uint32)]


def cases():
    rows = []
    def add(name, status=0, **kwargs):
        row=dict(name=name, expected_status=status, length=16, offset=8,
                 ring_size=64, cpu_base=0x20000000, kind=1, capacity=64)
        row.update(kwargs)
        rows.append(row)
    add('contiguous_idr_hint')
    add('contiguous_non_idr', kind=2)
    add('other_type_is_not_sync', kind=3)
    add('exact_end', offset=48)
    add('two_spans', offset=57)
    add('whole_ring_from_offset', length=64, offset=23)
    add('one_byte_at_end', length=1, offset=63)
    add('exact_destination_capacity', capacity=16)
    add('separate_logical_cpu_base', cpu_base=0x40000000)
    add('near_32bit_limit', cpu_base=0xffffffe0, ring_size=31, length=1, offset=30)
    add('short_capacity', 5, capacity=15)
    add('address_below_ring', 4, address=0x1fffffff)
    add('address_at_end', 4, offset=64)
    add('zero_length', 4, length=0)
    add('length_exceeds_ring', 4, length=65)
    add('empty_ring', 3, ring_size=0)
    add('zero_cpu_base', 3, cpu_base=0)
    add('cpu_bounds_overflow', 3, cpu_base=0xfffffff0)
    add('null_ring_bytes', 3, bytes_pointer='null')
    add('host_ring_bounds_overflow', 3, bytes_pointer='overflow')
    add('null_descriptor', 2, descriptor_pointer='null')
    add('descriptor_pointer_overflow', 2, descriptor_pointer='overflow')
    add('misaligned_descriptor', 2, descriptor_pointer=['descriptor', 1])
    add('null_view', 2, view_pointer='null')
    add('view_pointer_overflow', 2, view_pointer='overflow')
    add('misaligned_view', 2, view_pointer=['view', 1])
    add('null_destination', 2, destination_pointer='null')
    add('destination_pointer_overflow', 2, destination_pointer='overflow')
    add('null_result', 2, result_pointer='null')
    add('result_pointer_overflow', 2, result_pointer='overflow')
    add('misaligned_result', 2, result_pointer=['result', 1])
    add('destination_overlaps_ring', 6, destination_pointer=['ring', 1])
    add('result_overlaps_ring', 6, result_pointer=['ring', 8])
    add('result_overlaps_destination', 6, result_pointer=['destination', 4])
    add('destination_overlaps_descriptor', 6, destination_pointer=['descriptor', 0])
    add('result_overlaps_descriptor', 6, result_pointer=['descriptor', 0])
    add('destination_overlaps_view', 6, destination_pointer=['view', 0])
    add('result_overlaps_view', 6, result_pointer=['view', 0])
    for length in (0x00ffffff, 0xffffffff):
        add('eos_%08x_before_pointer_use'%length, 1, length=length, kind=1,
            view_pointer='null', destination_pointer='null', result_pointer='null')
    return rows


def build(directory):
    clang = shutil.which('clang')
    assert clang, 'existing clang is required'
    linkers = sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker = shutil.which('ld.lld') or (str(linkers[-1]) if linkers else None)
    assert linker, 'existing ld.lld is required'
    common = ['-std=c11', '-O2', '-Wall', '-Wextra', '-Werror']
    flags = ['--target=armv7-none-eabi', '-mcpu=cortex-a9', '-marm',
             '-mfloat-abi=soft', '-mfpu=none', '-ffreestanding', '-fno-builtin',
             '-fno-stack-protector', '-fno-pic', '-fno-unwind-tables',
             '-fno-asynchronous-unwind-tables', *common]
    host = directory/'copy.dylib'
    obj, arm = directory/'copy.o', directory/'copy.elf'
    commands = [[clang, '-shared', '-fPIC', *common, str(SOURCE), '-o', str(host)],
                [clang, *flags, '-c', str(SOURCE), '-o', str(obj)],
                [linker, '-T', str(LINK), str(obj), '-o', str(arm)]]
    for command in commands:
        subprocess.run(command, check=True, capture_output=True)
    blob = arm.read_bytes()
    elf = ELFFile(io.BytesIO(blob))
    symbols = list(elf.get_section_by_name('.symtab').iter_symbols())
    assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
    assert not any(s['sh_type'] in ('SHT_REL', 'SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
    entry = next(s['st_value'] for s in symbols if s.name=='yi4k_1107_copy_payload')
    library = ct.CDLL(str(host))
    function = library.yi4k_1107_copy_payload
    function.argtypes = [ct.c_void_p, ct.c_void_p, ct.c_void_p, ct.c_size_t, ct.c_void_p]
    function.restype = ct.c_int
    return function, library, blob, entry, dict(
        commands=commands, clang_version=subprocess.check_output([clang, '--version'], text=True).splitlines()[0],
        linker_version=subprocess.check_output([linker, '--version'], text=True).strip(),
        source_sha256=sha(SOURCE.read_bytes()),
        header_sha256=sha(SOURCE.with_suffix('.h').read_bytes()),
        descriptor_header_sha256=sha((ROOT/'sdk/yi4k_1107_video_descriptor.h').read_bytes()),
        linker_script_sha256=sha(LINK.read_bytes()), host_library_sha256=sha(host.read_bytes()),
        arm_elf_sha256=sha(blob), arm_function_bytes=next(s['st_size'] for s in symbols if s.name=='yi4k_1107_copy_payload'),
        arm_entry=hex(entry), undefined_symbols=0, linked_relocations=0)


def execute(case, function, blob, entry, arm):
    if arm:
        uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
        for address, size in ((0x10030000,0x20000), (0x20000000,0x10000),
                              (0x21000000,0x10000), (0x22000000,0x10000), (0x23000000,0x10000)):
            uc.mem_map(address, size)
        for section in ELFFile(io.BytesIO(blob)).iter_sections():
            if section['sh_flags']&2 and section['sh_size']:
                uc.mem_write(section['sh_addr'], section.data() if section['sh_type']!='SHT_NOBITS' else bytes(section['sh_size']))
        addresses = ADDRESSES
        maximum = 0xffffffff
        def read(address, size): return bytes(uc.mem_read(address,size))
        def write(address, value): uc.mem_write(address,value)
    else:
        allocations = {name:(ct.c_uint8*256)() for name in ADDRESSES}
        addresses = {name:ct.addressof(buf) for name,buf in allocations.items()}
        maximum = (1<<(8*ct.sizeof(ct.c_void_p)))-1
        def read(address, size): return ct.string_at(address,size)
        def write(address, value): ct.memmove(address,value,len(value))
    for address in addresses.values(): write(address, bytes([0xa5])*256)
    write(addresses['ring'],PATTERN)
    def pointer(name):
        value=case.get(name+'_pointer',name)
        if value=='null': return 0
        if value=='overflow': return maximum-(7 if name in ('descriptor','view') else 3)
        if isinstance(value,list): return addresses[value[0]]+value[1]
        return addresses[value]
    desc = Frame(123,0,1001,case['kind'],1,0,
                 case.get('address',(case['cpu_base']+case['offset'])&0xffffffff),case['length'],0)
    write(addresses['descriptor'],bytes(desc))
    if arm:
        view=struct.pack('<III',pointer('bytes') if 'bytes_pointer' in case else addresses['ring'],case['cpu_base'],case['ring_size'])
    else:
        view=bytes(View(pointer('bytes') if 'bytes_pointer' in case else addresses['ring'],case['cpu_base'],case['ring_size']))
    write(addresses['view'],view)
    args=[pointer('descriptor'),pointer('view'),pointer('destination'),case['capacity'],pointer('result')]
    before={name:read(address,256) for name,address in addresses.items()}
    payload_reads, writes = [], []
    if arm:
        def load(machine,access,address,size,value,user):
            if addresses['ring']<=address<addresses['ring']+256:
                payload_reads.extend(range(address-addresses['ring'],address-addresses['ring']+size))
        def store(machine,access,address,size,value,user):
            writes.append((address,size))
        uc.hook_add(UC_HOOK_MEM_READ,load)
        uc.hook_add(UC_HOOK_MEM_WRITE,store)
        registers=(UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,
                   UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11)
        saved={r:0x51230000+i*0x1234 for i,r in enumerate(registers)}
        uc.reg_write(UC_ARM_REG_CPSR,0x13)
        for r,v in saved.items(): uc.reg_write(r,v)
        for r,v in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),args): uc.reg_write(r,v)
        write(STACK,struct.pack('<I',args[4]))
        uc.reg_write(UC_ARM_REG_SP,STACK)
        uc.reg_write(UC_ARM_REG_LR,RETURN)
        uc.emu_start(entry,RETURN,count=100000)
        assert uc.reg_read(UC_ARM_REG_PC)==RETURN,case['name']
        assert uc.reg_read(UC_ARM_REG_SP)==STACK,case['name']
        assert all(uc.reg_read(r)==v for r,v in saved.items()),case['name']
        status=uc.reg_read(UC_ARM_REG_R0)
    else:
        status=function(*args)
    assert status==case['expected_status'],(case['name'],arm,status)
    after={name:read(address,256) for name,address in addresses.items()}
    expected_reads=[]
    if status==0:
        size,offset,length=case['ring_size'],case['offset'],case['length']
        expected_reads=[(offset+i)%size for i in range(length)]
        payload=bytes(PATTERN[i] for i in expected_reads)
        first=min(length,size-offset)
        result=struct.pack('<IIII',length,first,length-first,int(case['kind']==1))
        assert after['destination']==payload+before['destination'][length:]
        assert after['result']==result+before['result'][16:]
        for name in ('ring','descriptor','view'): assert after[name]==before[name],case['name']
    else:
        assert after==before,(case['name'],'failure changed memory')
    if arm:
        assert sorted(payload_reads)==sorted(expected_reads),(case['name'],'source read footprint',payload_reads)
        if status:
            assert all(0x23000000<=address and address+size<=0x23010000 for address,size in writes),case['name']
    return dict(name=case['name'],status=status,payload=after['destination'][:case['length']].hex() if status==0 else None,
                result=after['result'][:16].hex() if status==0 else None,
                payload_read_bytes=len(payload_reads) if arm else None,
                no_output_change_on_non_success=status!=0,
                callee_saved_and_sp_preserved=True if arm else None)


def main():
    assert ct.sizeof(Frame)==32 and Frame.address.offset==20 and Frame.length.offset==24
    with tempfile.TemporaryDirectory(prefix='yi4k-copy-') as directory:
        function,library,blob,entry,build_info=build(Path(directory))
        rows=[]
        for case in cases():
            host=execute(case,function,blob,entry,False)
            arm=execute(case,function,blob,entry,True)
            assert (host['status'],host['payload'],host['result'])==(arm['status'],arm['payload'],arm['result'])
            rows.append(dict(inputs=case,host=host,compiled_arm=arm))
    result=dict(evidence_type='Actual C compiled and executed on host and compiled ARM executed by Unicorn with constructed RAM',
                build=build_info,case_count=len(rows),host_execution_count=len(rows),arm_execution_count=len(rows),cases=rows,
                limitations=['No firmware payload bytes or runtime descriptors were read.',
                             'No device, producer quiescence, cache coherence, DMA, mapping or FIFO API is implemented or tested.',
                             'Native ARM means compiled ARM instructions executed offline, not execution on camera hardware.',
                             'Successful copying does not prove an H264 access unit, parameter-set inclusion, sync point or playable recording.',
                             'The caller must retain its virtual cursor until copied bytes have been validated and stored.'],
                device_access=False)
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),cases=len(rows),host_executions=len(rows),arm_executions=len(rows),arm_function_bytes=build_info['arm_function_bytes'])))


if __name__=='__main__': main()
