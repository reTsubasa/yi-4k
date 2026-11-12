#!/usr/bin/env python3
"""Offline 1.10.7 PTB pointer/CRC audit. No sockets, device files or acquisition.

Optional --system-ptb/--user-ptb consume EXACT local RAM table copies, not a
complete NAND image. Their acquisition/firmware provenance is not authenticated
by this parser. This script never generates target code or a device reader.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import struct
import zlib

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_LR

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
PIN = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE, SYS, USER, STOP = 0xa0100000, 0xa0001400, 0xa0001800, 0xa0900000
SYSTEM_NAMES = ('BOOTSTRAP', 'BOOTLOADER', 'FW_UPDATER')
USER_NAMES = ('VENDOR_DATA', 'SYS_SW', 'DSP_uCode', 'SYS_DATA', 'LINUX_Kernel',
              'LINUX_RFS', 'LINUX_HIBER_IMG', 'VIDEO_REC_IDX', 'CALIB',
              'USER_SETTING', 'DRIVE_A', 'DRIVE_B', 'RESERVED')

def sha(raw): return hashlib.sha256(raw).hexdigest()
def word(raw, offset): return struct.unpack_from('<I', raw, offset)[0]

def parse(raw, system):
    length, crc_offset, start, names = (0x1d0, 0x1cc, 12, SYSTEM_NAMES) if system else (0x354, 0x350, 8, USER_NAMES)
    if len(raw) != length: raise ValueError(f'exact table length required: {length:#x}')
    if word(raw, crc_offset) != zlib.crc32(raw[:crc_offset]): raise ValueError('table CRC mismatch')
    records = []
    for index, name in enumerate(names):
        offset = start + index * 0x40
        row = raw[offset:offset + 0x40]
        actual_name = row[:32].split(b'\0', 1)[0].decode('ascii', errors='strict')
        if actual_name != name: raise ValueError(f'record {index} identity mismatch: {actual_name!r}')
        attribute, allocation, blocks, block, load, actual, status, crc = struct.unpack_from('<8I', row, 32)
        # Allocations may include bad-block spare space; do not require equality
        # between block span and allocation, or infer physical byte coverage.
        if actual > allocation or (actual and (not blocks or not allocation)):
            raise ValueError('invalid record length/allocation')
        records.append(dict(index=index, name=name, attribute=hex(attribute), allocation=allocation,
                            blocks=blocks, start_block=block, load_address=hex(load), actual_bytes=actual,
                            status_raw=hex(status), data_crc32=hex(crc),
                            has_image_fingerprint=actual>0 and status!=0xffffffff and crc!=0xffffffff))
    return dict(bytes=len(raw), sha256=sha(raw), table_crc32=hex(word(raw, crc_offset)),
                header_raw_hex=raw[:start].hex(),
                unclassified_tail_hex=raw[start+len(names)*64:crc_offset].hex(),
                records=records, hidden_partition_bytes_acquired=False, recovery_proven=False)

def synthetic(system):
    length, start, names = (0x1d0, 12, SYSTEM_NAMES) if system else (0x354, 8, USER_NAMES)
    raw = bytearray(length)
    if system: struct.pack_into('<III', raw, 0, 1, 0x20000, 4)
    for index, name in enumerate(names):
        offset = start + index * 0x40
        raw[offset:offset + len(name)] = name.encode()
        struct.pack_into('<8I', raw, offset + 32, 1, 0x40000, 2, index * 2, 0x100000, 4096, 0, index)
    struct.pack_into('<I', raw, length - 4, zlib.crc32(raw[:-4]))
    return bytes(raw)

def cpu(raw):
    emu = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    emu.mem_map(BASE, (len(raw) + 4095) & ~4095)
    emu.mem_write(BASE, raw)
    emu.mem_map(0xa0001000, 0x1000)
    emu.mem_map(STOP, 0x1000)
    return emu

def original_call(emu, address, r0, r1):
    emu.reg_write(UC_ARM_REG_R0, r0); emu.reg_write(UC_ARM_REG_R1, r1)
    emu.reg_write(UC_ARM_REG_LR, STOP)
    emu.emu_start(address, STOP, count=100000)
    return emu.reg_read(UC_ARM_REG_R0)

def audit(raw):
    if sha(raw) != PIN: raise ValueError('1.10.7 RTOS image identity mismatch')
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = {
        0xa0492dd0: ('cmp', 'r1, #0xc'), 0xa0492df4: ('cmp', 'r1, #2'),
        0xa0492e08: ('addls', 'r0, r0, #0xc'), 0xa0492de8: ('add', 'r0, r0, #8'),
        0xa0484d04: ('mov', 'r1, #0x1cc'), 0xa0484d14: ('ldr', 'r2, [r3, #0x1cc]'),
        0xa04849e8: ('mov', 'r2, #0x1d0'), 0xa0484b88: ('mov', 'r2, #0x354'),
    }
    for addr, expected in checks.items():
        insn = next(md.disasm(raw[addr-BASE:addr-BASE+4], addr))
        assert (insn.mnemonic, insn.op_str) == expected, (hex(addr), insn.mnemonic, insn.op_str)
    pointers = {0xa078b600: SYS, 0xa078b604: USER, 0xa06f27f8: SYS, 0xa06f27f4: USER}
    for addr, value in pointers.items(): assert word(raw, addr-BASE) == value
    configuration=[]
    for index,(addr,name) in enumerate(zip((0xa05aceb4,0xa05acec0,0xa05acecc),SYSTEM_NAMES)):
        assert word(raw,0xa05acdfc-BASE+index*12)==addr
        assert raw[addr-BASE:addr-BASE+len(name)+1]==name.encode()+b'\0'
        configuration.append(dict(index=index,name=name,configuration=hex(0xa05acdfc+index*12),name_pointer=hex(addr)))
    emu = cpu(raw)
    selectors = []
    for kind, indices, expected_base, record_start, maximum in (
            (0, (0, 1, 2, 3, 12, 0xffffffff), SYS, 12, 2),
            (1, (0, 1, 2, 12, 13, 0xffffffff), USER, 8, 12),
            (7, (0, 12, 13), USER, 8, 12)):
        for index in indices:
            actual = original_call(emu, 0xa0492dc8, kind, index)
            expected = expected_base + record_start + index*64 if index <= maximum else 0
            assert actual == expected
            selectors.append(dict(kind=kind, index=index, returned=hex(actual)))
    crc_cases, negative_cases = [], []
    for system in (True, False):
        data = synthetic(system); addr = SYS if system else USER
        emu.mem_write(addr, data)
        actual = original_call(emu, 0xa02a79f0, addr, len(data)-4)
        assert actual == zlib.crc32(data[:-4])
        parse(data, system)
        crc_cases.append(dict(system=system, original_function_crc=hex(actual), model='synthetic RAM bytes'))
        corrupt = bytearray(data); corrupt[40] ^= 1
        wrong_schema = bytearray(data); wrong_schema[12 if system else 8] = ord('X')
        struct.pack_into('<I', wrong_schema, len(data)-4, zlib.crc32(wrong_schema[:-4]))
        too_large = bytearray(data); record=12 if system else 8
        struct.pack_into('<I', too_large, record+0x34, 0x80000)
        struct.pack_into('<I', too_large, len(data)-4, zlib.crc32(too_large[:-4]))
        for label, bad in [('truncated', data[:-1]), ('extra_bytes', data+b'\0'), ('corrupt_crc', corrupt),
                           ('wrong_names_valid_crc', wrong_schema), ('oversized_actual_valid_crc', too_large)]:
            try: parse(bad, system)
            except (ValueError, UnicodeDecodeError) as error:
                negative_cases.append(dict(system=system, case=label, rejected=str(error)))
            else: raise AssertionError(label)
    return dict(rtos_sha256=PIN, pointer_words={hex(k):hex(v) for k,v in pointers.items()},
                system_configuration_names=configuration,
                fixed_instruction_checks=len(checks), original_selector_cases=selectors,
                original_crc_cases=crc_cases, parser_corruption_cases=negative_cases)

def read_capture(path):
    resolved=path.resolve()
    if str(resolved).startswith('/dev/') or not resolved.is_file():
        raise ValueError('local regular-file input required; no device files')
    return resolved.read_bytes()

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rtos-image', type=Path, default=IMAGE)
    parser.add_argument('--system-ptb', type=Path); parser.add_argument('--user-ptb', type=Path)
    parser.add_argument('--output', type=Path, default=ROOT/'artifacts/device/2026-11-11-hidden-ptb-ram-candidate/audit.json')
    args=parser.parse_args(); raw=read_capture(args.rtos_image); result=audit(raw)
    changed=bytearray(raw); changed[0]^=1
    try: audit(changed)
    except ValueError as error: result['firmware_identity_negative_case']=str(error)
    else: raise AssertionError('Wrong firmware image accepted')
    result.update(device_access=False, usb_access=False, target_code_executed=False,
                  nand_read=False, runtime_pointers_verified=False,
                  hidden_partition_bytes_acquired=False, independent_recovery_proven=False)
    for key, path, system in [('provided_system_ptb',args.system_ptb,True),('provided_user_ptb',args.user_ptb,False)]:
        if path:
            result[key]=parse(read_capture(path),system)
            result[key]['capture_provenance_authenticated']=False
    evidence=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis/full'
    names=['a0298c8c.c','a048498c.c','a0484b0c.c','a0484cf4.c','a0483d98.c','a0492dc8.c','a02a79f0.c']
    result['existing_pseudocode_sources']=[dict(path=str((evidence/'decompiled'/n).relative_to(ROOT)),sha256=sha((evidence/'decompiled'/n).read_bytes())) for n in names]
    control=ROOT/'artifacts/device/2026-11-09-linux/boot-metadata/vendor_data.bin'
    control_raw=read_capture(control)
    assert sha(control_raw)=='69c4fcd4c096e0b02b0c0303483c11a364cafc0c46fe5aefaf73983fff7f3844'
    # Existing NAND logical USER table is ONLY a parser control, not evidence
    # that either candidate RAM address has been captured.
    result['existing_user_nand_control']=parse(control_raw[:0x354],False)
    result['existing_user_nand_control']['source']=str(control.relative_to(ROOT))
    result['existing_user_nand_control']['new_capture']=False
    result['existing_user_nand_control']['ram_address_verified']=False
    empty=bytearray(synthetic(False)); row=8+12*64
    struct.pack_into('<8I',empty,row+32,0,0,0,0,0xffffffff,0,0xffffffff,0xffffffff)
    struct.pack_into('<I',empty,len(empty)-4,zlib.crc32(empty[:-4]))
    parsed_empty=parse(empty,False)
    assert not parsed_empty['records'][-1]['has_image_fingerprint']
    result['legal_empty_slot_positive_case']=parsed_empty['records'][-1]
    refs=[]
    for line in (evidence/'references.tsv').read_text().splitlines():
        fields=line.split('\t')
        if len(fields)==3 and fields[1] in {hex(a) for a in (0xa078b600,0xa078b604,0xa06f27f4,0xa06f27f8)}:
            refs.append(dict(source=fields[0],destination=fields[1],type=fields[2]))
    result['retained_static_pointer_references']=refs
    result['pointer_write_reference_count']=sum('WRITE' in r['type'] for r in refs)
    result['pointer_reference_limit']='Retained Ghidra direct refs only; indirect/alias/runtime writes not excluded.'
    result['scope']='Original fixed 1.10.7 selector/CRC instructions in synthetic host RAM; no NAND functions executed.'
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    assembly=[]
    for addr,size in [(0xa0492dc8,0x50),(0xa02a79f0,0x44),(0xa048498c,0x90),(0xa0484b0c,0xbc),(0xa0484cf4,0x1a8)]:
        assembly.extend(f'{i.address:08x}: {i.mnemonic} {i.op_str}' for i in md_disasm(raw,addr,size))
        assembly.append('')
    args.output.with_suffix('.asm').write_text('\n'.join(assembly))
    print(json.dumps(dict(output=str(args.output),selectors=15,crc_cases=2,negative_cases=10,device_access=False)))

def md_disasm(raw,addr,size): return Cs(CS_ARCH_ARM,CS_MODE_ARM).disasm(raw[addr-BASE:addr-BASE+size],addr)

if __name__=='__main__': main()
