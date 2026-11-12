#!/usr/bin/env python3
"""Offline first-entry evidence only; emits no device writer or executable payload.

The dispatch test substitutes a synthetic existing-table handler and declared
strcmp/print/handler stubs. It does not validate instruction-cache publication.
"""
import hashlib
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR

ROOT=Path(__file__).resolve().parents[1]
ANALYSIS=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE=0xA0100000
SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
PAD=(0xA064E214,0xA064F000)


def main():
    data=(ANALYSIS/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(data).hexdigest()==SHA
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    functions=json.loads((ANALYSIS/'full/functions.json').read_text())
    def owners(address):
        return [f['entry'] for f in functions for span in f['body_ranges']
                if int(span.split('-')[0],16)<=address<=int(span.split('-')[1],16)]
    thumb=Cs(CS_ARCH_ARM,CS_MODE_THUMB)
    candidates=[]
    for offset in range(0,len(data)-3,2):
        # T32 MCR/MRC first halfword. Full decode identifies operation below.
        if (data[offset+1]&0xef)!=0xee:continue
        ins=next(thumb.disasm(data[offset:offset+4],BASE+offset),None)
        if not(ins and ins.size==4 and ins.mnemonic=='mcr' and 'p15' in ins.op_str):continue
        if not any(part in ins.op_str for part in ('c7, c1,','c7, c5,')):continue
        candidates.append({'address':hex(ins.address),'bytes':bytes(ins.bytes).hex(),
                           'instruction':ins.mnemonic+' '+ins.op_str,
                           'a32_owners':owners(ins.address),'valid_icache_op':ins.op_str.endswith((', c1, #0',', c5, #0',', c5, #1',', c5, #4')),
                           'uses_pc_as_rt':', pc,' in ins.op_str})
    assert len(candidates)==7
    useful=[c for c in candidates if c['valid_icache_op'] and not c['uses_pc_as_rt']]
    assert [int(c['address'],16) for c in useful]==[0xA04A42D6,0xA04A43CE,0xA04A442E,0xA04A4492]
    # These T32 decodes straddle the second half of one actual A32 MCR and
    # first half of a following A32 TLB instruction. Not independent Thumb code.
    for c in useful:
        at=int(c['address'],16)
        ins=list(md.disasm(data[at-2-BASE:at+6-BASE],at-2))
        assert len(ins)==2 and ins[0].mnemonic==ins[1].mnemonic=='mcr'
        assert 'c7, c5, #0' in ins[0].op_str and 'c8, c5, #0' in ins[1].op_str
        c['a32_overlap']=[f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in ins]
        c['classification']='cross-boundary reinterpretation inside known A32 MMU initializer'
    for c in candidates:
        if c not in useful:c['classification']='unsupported c7 operation and Rt=pc; no demonstrated callable cache helper'

    uc=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    uc.mem_map(BASE,(len(data)+4095)&~4095);uc.mem_write(BASE,data)
    uc.mem_map(0x70000000,0x10000)
    put=lambda at,value:uc.mem_write(at,struct.pack('<I',value))
    get=lambda at:struct.unpack('<I',uc.mem_read(at,4))[0]
    def string(at):
        out=bytearray()
        for n in range(256):
            byte=bytes(uc.mem_read(at+n,1))
            if byte==b'\0':return out.decode()
            out.extend(byte)
        raise AssertionError('No C-string end')
    table=0xA056B404
    rows=[]
    for index in range(69):
        name,handler=struct.unpack_from('<II',data,table+index*8-BASE)
        rows.append({'index':index,'name':string(name),'name_pointer':hex(name),'handler':hex(handler)})
    # Choose an arbitrary table row in synthetic RAM. No command is recommended
    # for target replacement; all real handlers stay unexecuted here.
    row=rows[0];slot=table+4;original=get(slot)
    argv=0x70001000;callback=0x70002000;stub=0x70003000;end=0x70004000
    args=['ants',row['name'],'audit-argument']
    for i,arg in enumerate(args):
        at=0x70000100+i*0x100;uc.mem_write(at,arg.encode()+b'\0');put(argv+i*4,at)
    calls=[];printing=[]
    def hook(machine,address,size,user):
        ret=None
        if address==0xA04F9744:
            ret=int(string(machine.reg_read(UC_ARM_REG_R0))!=string(machine.reg_read(UC_ARM_REG_R1)))
        elif address==stub:
            calls.append({'argc':machine.reg_read(UC_ARM_REG_R0),'argv':hex(machine.reg_read(UC_ARM_REG_R1)),
                          'first_argument':string(get(machine.reg_read(UC_ARM_REG_R1))),
                          'print_pointer':hex(machine.reg_read(UC_ARM_REG_R2))})
            ret=0x12345678
        elif address==callback:
            printing.append(string(machine.reg_read(UC_ARM_REG_R0)));ret=0
        if ret is not None:
            machine.reg_write(UC_ARM_REG_R0,ret)
            lr=machine.reg_read(UC_ARM_REG_LR)
            machine.reg_write(UC_ARM_REG_CPSR,machine.reg_read(UC_ARM_REG_CPSR)&~0x20)
            machine.reg_write(UC_ARM_REG_PC,lr&~1)
    uc.hook_add(UC_HOOK_CODE,hook)
    put(slot,stub)
    from unicorn.arm_const import UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11
    saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
    for n,reg in enumerate(saved):uc.reg_write(reg,0xABC00000+n)
    sp=0x7000F000
    for reg,value in [(UC_ARM_REG_R0,3),(UC_ARM_REG_R1,argv),(UC_ARM_REG_R2,callback),(UC_ARM_REG_SP,sp),(UC_ARM_REG_LR,end)]:uc.reg_write(reg,value)
    uc.emu_start(0xA01AB8BC,end,count=3000)
    assert uc.reg_read(UC_ARM_REG_PC)==end and uc.reg_read(UC_ARM_REG_R0)==0x12345678
    assert uc.reg_read(UC_ARM_REG_SP)==sp
    assert all(uc.reg_read(reg)==0xABC00000+n for n,reg in enumerate(saved))
    assert calls==[{'argc':1,'argv':hex(argv+8),'first_argument':'audit-argument','print_pointer':hex(callback)}]
    put(slot,original);assert get(slot)==original
    pad=data[PAD[0]-BASE:PAD[1]-BASE];assert not any(pad)
    out=ROOT/'artifacts/device/2026-11-10-native-ram-entry-audit';out.mkdir(parents=True,exist_ok=True)
    result={'image_sha256':SHA,'thumb_scan':{'stride_bytes':2,'range':[hex(BASE),hex(BASE+len(data))],
                'matches':candidates,'new_usable_thumb_icache_helpers':0,
                'limitations':'Opcode candidates only; not exhaustive CFG or dynamically loaded/uncaptured code.'},
            'ants_table':rows,'dispatch':{'entry':'0xa01ab8bc','synthetic_handler_calls':calls,
                'synthetic_original_pointer_restored':True,'callee_saved_sp_return_verified':True,
                'scope':'Real stock dispatcher in synthetic RAM, declared strcmp/print/new-handler stubs; no real handler invocation or target mutation'},
            'padding':{'range':[hex(PAD[0]),hex(PAD[1])],'all_zero_in_storage':True,
                'live_ownership_verified':False,'code_publication_verified':False},
            'decision':'No runnable RAM probe emitted. First fetch/coherency, padding ownership, single-owner pointer lifetime and failure recovery remain unverified.',
            'target_access':False,'target_memory_write':False,'payload_emitted':False}
    (out/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(f'{len(candidates)} T32 candidates classified; real dispatcher synthetic ABI verified; no payload or device writer emitted')


if __name__=='__main__':main()
