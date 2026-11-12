#!/usr/bin/env python3
"""Original 1.10.7 GetPartitionInfo in synthetic RAM, never a device reader.

No callbacks or services are substituted. No NAND/updater/init function runs.
The image is pinned; data, stack, output and fault behavior are host constructs.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UcError, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
IMAGE=SOURCE/'rtos-window.bin'
SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE=0xA0100000
SYS,USER=0xA0001400,0xA0001800
OUTPUT,STACK,STOP=0x70001000,0x7000F000,0x7001FF00
ENTRIES={0xA0483C20:0x58,0xA0484F80:4,0xA0492E18:0x9C,0xA0488900:4,0xA0493058:0x9C}

def sha(data):return hashlib.sha256(data).hexdigest()
def word(data,address):return struct.unpack_from('<I',data,address-BASE)[0]
def signed(value):return value if value<0x80000000 else value-0x100000000

def execute(image,backend,system,index,destination=OUTPUT,*,entry=0xA0483C20,pointer=None,mutate=False,alias=False,table_selector=None):
    uc=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    uc.mem_map(BASE,(len(image)+4095)&~4095);uc.mem_write(BASE,image)
    uc.mem_map(0xA0001000,0x1000);uc.mem_map(0x70000000,0x20000)
    low=bytearray((i*37+11)&255 for i in range(0x1000))
    source=(SYS+0xC if system else USER+8)+(index&0xFFFFFFFF)*0x40
    source&=0xFFFFFFFF
    if mutate and SYS<=source<=USER+0x340:
        low[source-0xA0001000+32:source-0xA0001000+36]=b'\xDE\xAD\xBE\xEF'
    uc.mem_write(0xA0001000,bytes(low));uc.mem_write(OUTPUT-16,b'\xCC'*128)
    if pointer is not None:
        location=(0xA078B600 if system else 0xA078B604) if backend!=1 else (0xA078B610 if system else 0xA078B60C)
        uc.mem_write(location,struct.pack('<I',pointer))
        source=(pointer+(0xC if system else 8)+(index&0xFFFFFFFF)*0x40)&0xFFFFFFFF
    if alias:destination=source
    reads=[];writes=[];trace=[]
    def code(machine,address,size,user):trace.append(address)
    def read(machine,access,address,size,value,user):reads.append((address,size))
    def write(machine,access,address,size,value,user):writes.append((address,size))
    uc.hook_add(UC_HOOK_CODE,code);uc.hook_add(UC_HOOK_MEM_READ,read);uc.hook_add(UC_HOOK_MEM_WRITE,write)
    uc.reg_write(UC_ARM_REG_CPSR,0x13);uc.reg_write(UC_ARM_REG_SP,STACK);uc.reg_write(UC_ARM_REG_LR,STOP)
    saved={r:0x41550000+i*0x1010 for i,r in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
    for reg,value in saved.items():uc.reg_write(reg,value)
    selector=(0 if system else 1) if table_selector is None else table_selector
    args=(backend,selector,index,destination) if entry==0xA0483C20 else (selector,index,destination)
    for reg,value in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),args):uc.reg_write(reg,value&0xFFFFFFFF)
    error=None
    try:uc.emu_start(entry,STOP,count=10000)
    except UcError as exception:error=str(exception)
    returned=uc.reg_read(UC_ARM_REG_PC)==STOP
    low_reads=[(a,n) for a,n in reads if 0xA0001000<=a<0xA0002000]
    low_writes=[(a,n) for a,n in writes if 0xA0001000<=a<0xA0002000]
    out_writes=[(a,n) for a,n in writes if OUTPUT-16<=a<OUTPUT+112]
    output=bytes(uc.mem_read(OUTPUT,64));guards=bytes(uc.mem_read(OUTPUT-16,16))+bytes(uc.mem_read(OUTPUT+64,48))
    if returned:
        assert uc.reg_read(UC_ARM_REG_SP)==STACK and all(uc.reg_read(r)==v for r,v in saved.items())
    allowed=set()
    for start,length in ENTRIES.items():allowed.update(range(start,start+length,4))
    assert all(pc in allowed for pc in trace),[hex(pc) for pc in trace if pc not in allowed]
    assert all((STACK-64<=a<STACK) or (OUTPUT-16<=a<OUTPUT+112) or (alias and source<=a<source+64) for a,n in writes),writes
    return dict(backend=backend,table='SYS' if system else 'USER',table_selector=selector,index=index,entry=hex(entry),destination=hex(destination),
                computed_source=hex(source),returned=returned,status=signed(uc.reg_read(UC_ARM_REG_R0)) if returned else None,
                synthetic_fault=error,pc=hex(uc.reg_read(UC_ARM_REG_PC)),
                exact_low_reads=[[hex(a),n] for a,n in low_reads],low_page_writes=[[hex(a),n] for a,n in low_writes],
                output_writes=[[hex(a),n] for a,n in out_writes],output_hex=output.hex(),guard_unchanged=guards==b'\xCC'*64,
                output_unchanged=output==b'\xCC'*64,low_page_unchanged=bytes(uc.mem_read(0xA0001000,0x1000))==bytes(low),
                executed_entries=[hex(a) for a in ENTRIES if a in trace],instructions=len(trace),
                abi_preserved_if_returned=returned,no_substituted_services=True)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir',type=Path,default=ROOT/'artifacts/device/2026-11-11-get-partition-info-contract')
    output=parser.parse_args().output_dir.resolve();output.mkdir(parents=True,exist_ok=False)
    image=IMAGE.read_bytes();assert sha(image)==SHA
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    pins={0xA0483C3C:('ldr','lr, [lr, #0x2c]'),0xA0483C48:('cmp','r0, #2'),
          0xA0483C58:('mov','r0, r1'),0xA0483C5C:('mov','r1, r2'),0xA0483C60:('mov','r2, r3'),0xA0483C6C:('bx','r3'),
          0xA0484F80:('b','#0xa0492e18'),0xA0492E20:('cmp','r1, #0xc'),0xA0492E30:('cmp','r1, #2'),
          0xA0492E48:('add','r1, r1, #0xc'),0xA0492E4C:('cmp','r2, #0'),0xA0492E58:('add','r3, r1, #0x40'),
          0xA0492E7C:('str','r4, [r2, #-0x10]'),0xA0492EAC:('add','r1, r3, r1'),
          0xA0488900:('b','#0xa0493058'),0xA0493098:('add','r3, r1, #0x40')}
    instruction_checks=[]
    for address,expected in pins.items():
        ins=next(md.disasm(image[address-BASE:address-BASE+4],address));assert (ins.mnemonic,ins.op_str)==expected
        instruction_checks.append(dict(address=hex(address),bytes=bytes(ins.bytes).hex(),mnemonic=ins.mnemonic,operands=ins.op_str))
    pointers={hex(a):hex(word(image,a)) for a in (0xA078B600,0xA078B604,0xA078B60C,0xA078B610)}
    assert list(pointers.values())==['0xa0001400','0xa0001800','0xa0001800','0xa0001400']
    backends=[dict(index=i,slot=hex(0xA062AD54+i*0x58),target=hex(word(image,0xA062AD54+i*0x58))) for i in range(3)]
    assert [row['target'] for row in backends]==['0xa0484f80','0xa0488900','0x0']
    positives=[];failures=[];hazards=[]
    for backend in (0,1):
        for system,count in ((True,3),(False,13)):
            for index in range(count):
                row=execute(image,backend,system,index)
                start=int(row['computed_source'],16)
                expected=bytes(((start-0xA0001000+i)*37+11)&255 for i in range(64))
                assert row['returned'] and row['status']==0 and bytes.fromhex(row['output_hex'])==expected
                assert row['exact_low_reads']==[[hex(start+i*4),4] for i in range(16)]
                assert row['output_writes']==[[hex(OUTPUT+i*4),4] for i in range(16)]
                assert row['low_page_unchanged'] and row['guard_unchanged'] and not row['low_page_writes']
                positives.append(row)
            for index,destination in ((count,OUTPUT),(0xFFFFFFFF,OUTPUT),(0,0)):
                row=execute(image,backend,system,index,destination)
                assert row['returned'] and row['status']==-1 and row['output_unchanged'] and row['guard_unchanged']
                assert not row['exact_low_reads'] and not row['output_writes'] and row['low_page_unchanged']
                failures.append(row)
    for backend in (2,3,0xFFFFFFFF):
        row=execute(image,backend,True,0)
        assert row['returned'] and row['status']==-1 and row['output_unchanged'] and not row['exact_low_reads']
        failures.append(row)
    # Data validation is absent: a corrupted synthetic record copies unchanged.
    row=execute(image,0,True,0,mutate=True)
    assert row['returned'] and row['status']==0 and bytes.fromhex(row['output_hex'])[32:36]==b'\xDE\xAD\xBE\xEF'
    row['meaning']='No magic/name/CRC/record-size semantic validation; corrupted record returned success';hazards.append(row)
    # The destination has no length or ownership validation; caller alias can
    # write low PTB memory even though normal distinct-output path does not.
    row=execute(image,0,True,0,alias=True)
    assert row['returned'] and row['status']==0 and len(row['low_page_writes'])==16
    row['meaning']='Caller destination alias writes 64 bytes into source PTB range; no readonly API guarantee';hazards.append(row)
    for pointer in (0,0xA0003000):
        row=execute(image,0,True,0,pointer=pointer)
        assert not row['returned'] and row['synthetic_fault']
        row['meaning']='Missing/unmapped table pointer leads to native load fault, not -1';hazards.append(row)
    row=execute(image,0x01000000,True,0)
    assert not row['returned'] and row['synthetic_fault']
    row['meaning']='Backend lookup load precedes bounds check; grossly invalid backend faults before rejecting';hazards.append(row)
    row=execute(image,0,True,0,pointer=0xFFFFFFF4)
    assert row['returned'] and row['status']==-1 and not row['exact_low_reads']
    row['meaning']='Only computed record pointer zero is rejected; not a base-pointer validity check';hazards.append(row)
    # Direct thunk has the same copy semantics; no dispatcher service needed.
    row=execute(image,0,True,2,entry=0xA0484F80)
    assert row['returned'] and row['status']==0 and len(row['output_writes'])==16;positives.append(row)
    for selector in (2,0xFFFFFFFF):
        row=execute(image,0,False,12,table_selector=selector)
        assert row['returned'] and row['status']==0 and row['computed_source']==hex(USER+8+12*64)
        assert row['exact_low_reads']==[[hex(USER+8+12*64+i*4),4] for i in range(16)]
        assert not row['low_page_writes'] and row['guard_unchanged'];positives.append(row)
    functions={r['entry']:r for r in json.loads((SOURCE/'full/functions.json').read_text())}
    windows=[];assembly=[]
    for address,length in ENTRIES.items():
        data=image[address-BASE:address-BASE+length]
        windows.append(dict(entry=hex(address),bytes=length,sha256=sha(data),declared_body_ranges=functions[hex(address)]['body_ranges']))
        assembly.append('\n'+hex(address)+'\n'+'\n'.join(f'{i.address:08x} {bytes(i.bytes).hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(data,address)))
    targets={hex(a) for a in ENTRIES};incoming=[]
    for line in (SOURCE/'full/references.tsv').read_text().splitlines()[1:]:
        frm,to,kind=line.split('\t')
        if to in targets:incoming.append(dict(site=frm,target=to,type=kind))
    drv=[]
    def string(a):return image[a-BASE:image.index(b'\0',a-BASE)].decode('ascii')
    for i in range(21):
        name,handler,description=struct.unpack_from('<III',image,0xA0637334+i*12-BASE)
        drv.append(dict(index=i,name=string(name),handler=hex(handler)))
    assert not any(row['handler'] in targets for row in drv)
    # Store observed direct-call inventory rather than claiming all indirect
    # invocations or all shell commands have been exhaustively ruled out.
    direct_calls=[]
    for line in (SOURCE/'full/calls.tsv').read_text().splitlines()[1:]:
        caller,site,target,kind=line.split('\t')
        if target in targets:direct_calls.append(dict(caller=caller,site=site,target=target,type=kind))
    result=dict(scope='offline original fixed ARM bytes; synthetic RAM and fault mapping only; no services substituted',
        image=dict(path=str(IMAGE.relative_to(ROOT)),base=hex(BASE),sha256=SHA),
        instruction_checks=instruction_checks,pointer_words=pointers,backend_slots=backends,
        successful_copy_cases=len(positives),explicit_rejection_cases=len(failures),hazard_cases=len(hazards),
        copies=positives,rejections=failures,hazards=hazards,code_windows=windows,
        direct_call_inventory=direct_calls,incoming_reference_inventory=incoming,drv_commands=drv,
        index_provenance={name:sha((SOURCE/'full'/name).read_bytes()) for name in ('functions.json','references.tsv','calls.tsv')},
        source_pseudocode_sha256={hex(a):sha((SOURCE/'full/decompiled'/f'{a:08x}.c').read_bytes()) for a in ENTRIES},
        script_sha256=sha(Path(__file__).read_bytes()),
        conclusions=['backend0 selects original NAND PTB copy; backend1 selects alternate copy sharing initial SYS/USER pointers; backend2 has NULL getter',
            'SYS accepts index0..2 at table+0xC+64*index; USER accepts index0..12 at table+8+64*index; nonzero table selector means USER',
            'Normal separated output copies exactly64bytes, no target PTB stores, no NAND/CRC/init/updater/callback calls',
            'NULL destination, out-of-range record index and ordinary unsupported backend return-1 without output writes',
            'No source ownership/mapping/CRC validation, output size parameter, alias check, lock, cache maintenance or read-fault recovery',
            'This internal C API is not a discovered externally invokable read command or safe first-entry mechanism'],
        limits=['Current camera table pointers/content, active MMU, cache coherency, concurrent mutation and first-call safety remain unknown.',
            'Invalid-memory outcomes are synthetic Unicorn mappings; actual hardware fault/watchdog/recovery behavior is untested.',
            'Declared direct-reference index and21-row drv table coverage do not prove absence of indirect or other protocol callers.',
            'No SYS table capture, boot partition bytes, native entry, code publication or independent recovery obtained.'],
        rea_evidence_id=None,device_access=False,nand_access=False,deployable_reader_generated=False)
    (output/'audit.json').write_text(json.dumps(result,indent=2)+'\n');(output/'audit.asm').write_text('\n'.join(assembly)+'\n')
    print(json.dumps(dict(output=str(output),copy_cases=len(positives),rejections=len(failures),hazards=len(hazards),device_access=False)))

if __name__=='__main__':main()
