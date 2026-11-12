#!/usr/bin/env python3
"""Offline one-byte false/MVN visibility candidate. No device tool or binary output.

Unicorn verifies logical ARM/parser/write extents only, not hardware instruction
publication, cache, concurrency, file service integrity or recovery.
"""
import csv
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT=ROOT/'artifacts/device/2026-11-10-false-instruction-visibility'
BASE=0xA0100000
SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
FALSE=0xA02A0AA8
CHANGED=FALSE+2


def main():
    image=(SRC/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(image).hexdigest()==SHA
    assert image[FALSE-BASE:FALSE-BASE+8].hex()=='0000e0e31eff2fe1'
    OUT.mkdir(parents=True,exist_ok=True)
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    refs=list(csv.DictReader((SRC/'full/references.tsv').open(),delimiter='\t'))
    calls=list(csv.DictReader((SRC/'full/calls.tsv').open(),delimiter='\t'))
    def cs(data,at):return data[at-BASE:data.index(b'\0',at-BASE)].decode()
    def new():
        u=Uc(UC_ARCH_ARM,UC_MODE_ARM)
        u.mem_map(BASE,(len(image)+4095)&~4095);u.mem_write(BASE,image)
        u.mem_map(0xA1400000,0x1000000);u.mem_map(0x70000000,0x10000)
        return u
    def put(u,a,v):u.mem_write(a,struct.pack('<I',v))
    def string(u,a):return bytes(u.mem_read(a,256)).split(b'\0',1)[0].decode()
    def run(u,entry,args):
        saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
        for n,r in enumerate(saved):u.reg_write(r,0xABCD0000+n)
        for r,v in zip([UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3],args):u.reg_write(r,v)
        u.reg_write(UC_ARM_REG_SP,0x7000F000);u.reg_write(UC_ARM_REG_LR,0x70004000)
        u.emu_start(entry,0x70004000,count=150000)
        assert u.reg_read(UC_ARM_REG_PC)==0x70004000 and u.reg_read(UC_ARM_REG_SP)==0x7000F000
        assert all(u.reg_read(r)==0xABCD0000+n for n,r in enumerate(saved))
        return u.reg_read(UC_ARM_REG_R0)

    # Byte-oriented raw pointers, aligned A32 direct branches, and bounded
    # MOVW/MOVT constant construction supplement incomplete function indexes.
    pointer_hits=[]
    for target in (FALSE,FALSE|1):
        needle=struct.pack('<I',target);start=0
        while True:
            pos=image.find(needle,start)
            if pos<0:break
            pointer_hits.append(dict(site=hex(BASE+pos),value=hex(target),aligned=pos%4==0));start=pos+1
    assert pointer_hits==[dict(site='0xa06f2f10',value=hex(FALSE),aligned=True)]
    direct=[];constants=[]
    words=[x[0] for x in struct.iter_unpack('<I',image)]
    for n,w in enumerate(words):
        at=BASE+4*n
        if w>>28!=15 and (w&0x0E000000)==0x0A000000:
            delta=(w&0xFFFFFF)<<2
            if delta&(1<<25):delta-=1<<26
            target=(at+8+delta)&0xFFFFFFFF
            if FALSE<=target<FALSE+8:direct.append(dict(site=hex(at),target=hex(target)))
        if (w&0x0FF00000)!=0x03000000:continue
        low=((w>>16)&15)*4096+(w&4095);rd=(w>>12)&15
        for k in range(1,6):
            if n+k>=len(words):break
            q=words[n+k]
            if (q&0x0FF00000)==0x03400000 and (q>>12)&15==rd:
                target=low+((((q>>16)&15)*4096+(q&4095))<<16)
                if FALSE<=target<FALSE+8:constants.append(dict(movw=hex(at),movt=hex(at+4*k),value=hex(target)))
    assert not direct and not constants
    name,handler,_=struct.unpack_from('<III',image,0xA06F2F0C-BASE)
    assert cs(image,name)=='false' and handler==FALSE
    intervals=[]
    for r in refs:
        try:to=int(r['to'],16)
        except ValueError:continue
        if FALSE<=to<FALSE+8:intervals.append(dict(site=r['from'],target=r['to'],type=r['type']))
    assert not intervals
    exports={}
    for label,lo,hi in [('false_32byte_line',0xA02A0AA0,0xA02A0AC0),('false_neighbor_64bytes',0xA02A0A80,0xA02A0AC0),
                        ('ordinary_dispatch_call',0xA029CAF8,0xA029CB30),('loadbin',0xA02A2584,0xA02A26F4),
                        ('partial_sector_reader',0xA03534D8,0xA03535A8),('byte_copy',0xA033A6C4,0xA033A740)]:
        raw=image[lo-BASE:hi-BASE]
        (OUT/(label+'.asm')).write_text('\n'.join(f'{i.address:08x} {bytes(i.bytes).hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(raw,lo))+'\n')
        exports[label]=dict(start=hex(lo),end_exclusive=hex(hi),sha256=hashlib.sha256(raw).hexdigest())

    # Execute the real conditional parser, string library, ordinary dispatcher,
    # false leaf and echo handler. Only printing is a stub. Fresh Uc instances
    # intentionally remove emulator translation-cache history from each case.
    visibility=[]
    for label,value,want,branch in [('original',0xE0,0xFFFFFFFF,'ELSE_HIT'),('changed',0xA0,0,'THEN_HIT'),('restored_data',0xE0,0xFFFFFFFF,'ELSE_HIT')]:
        u=new();u.mem_write(CHANGED,bytes([value]));put(u,0xA06F3068,0x70003000)
        for a in range(0xA06F2EA0,0xA06F305C,12):put(u,a+8,a+12)
        put(u,0xA06F3064,0)
        printed=[];fetched=[]
        def printer(m,a,size,data):
            if a==FALSE:fetched.append(bytes(m.mem_read(FALSE,8)).hex())
            if a==0x70003000:
                printed.append(string(m,m.reg_read(UC_ARM_REG_R0)))
                m.reg_write(UC_ARM_REG_R0,0);m.reg_write(UC_ARM_REG_PC,m.reg_read(UC_ARM_REG_LR)&~1)
        u.hook_add(UC_HOOK_CODE,printer)
        u.mem_write(0x70000100,b'false\0')
        ret=run(u,0xA029CCB8,[0x70000100]);assert ret==want
        assert struct.unpack('<I',u.mem_read(0xA14466A8,4))[0]==want
        u.mem_write(0x70000100,b'if $?; then echo THEN_HIT; else echo ELSE_HIT; fi\0')
        run(u,0xA029CCB8,[0x70000100])
        assert printed==[branch,'\n'] and len(fetched)==1
        visibility.append(dict(case=label,changed_byte=hex(value),handler_return=hex(ret),conditional_print=printed,original_handler_instruction_bytes=fetched[0],sp_callee_saved_verified=True))

    # Check loadbin's exact fread request with declared file metadata/API stubs.
    # This does not itself validate the file service or single-byte store.
    loads=[]
    for count,stat_ok in [(1,True),(2,True),(1,False)]:
        u=new();events=[]
        for n,s in enumerate(['loadbin','c:\\synthetic.bin','0xA02A0AAA']):
            p=0x70000100+n*0x100;u.mem_write(p,s.encode()+b'\0');put(u,0x70001000+4*n,p)
        def fs(m,a,size,data):
            ret=None
            if a==0xA032E194:
                # stat fills 64-bit length at stat+8; failure leaves declared
                # poison from stack preparation to reveal fall-through.
                if stat_ok:u.mem_write(m.reg_read(UC_ARM_REG_R1)+8,struct.pack('<II',count,0))
                ret=0 if stat_ok else 0xFFFFFFFF;events.append(dict(api='stat',success=stat_ok))
            elif a==0xA032E0C8:ret=0x70002000
            elif a==0xA032E0D4:
                events.append(dict(api='fread',destination=hex(m.reg_read(UC_ARM_REG_R0)),size=m.reg_read(UC_ARM_REG_R1),count=m.reg_read(UC_ARM_REG_R2)))
                ret=m.reg_read(UC_ARM_REG_R2)
            elif a==0xA032E0D0:ret=0
            elif a==0xA032E114:ret=7
            elif a==0x70003000:ret=0
            if ret is not None:
                m.reg_write(UC_ARM_REG_R0,ret);m.reg_write(UC_ARM_REG_PC,m.reg_read(UC_ARM_REG_LR)&~1)
        u.hook_add(UC_HOOK_CODE,fs)
        # loadbin sp_after_push_sub + 10 = caller_sp - 28; poison low size.
        u.mem_write(0x7000F000-0x28,struct.pack('<II',0x1234,0))
        result=run(u,0xA02A2584,[3,0x70001000,0x70003000])
        request=next(x for x in events if x['api']=='fread')
        assert request['destination']==hex(CHANGED) and request['size']==1
        assert request['count']==(count if stat_ok else 0x1234)
        loads.append(dict(stat_size=count,stat_success=stat_ok,events=events,return_value=hex(result)))

    # Real partial-sector helper + real byte-copy. Sector cache lookup and
    # mounted-media checks are declared stubs; no disk/DMA operation is run.
    partial=[]
    for offset in (0,17,511):
        u=new();sector,cache,descriptor,out=0x70005000,0x70006000,0x70007000,0x70008000
        u.mem_write(sector,struct.pack('<H',512));u.mem_write(sector+0x75C8,struct.pack('<H',1))
        # Object extends beyond the small test stack mapping above.
        put(u,descriptor+8,cache);u.mem_write(cache,b'\xA0'*512)
        before=bytes(u.mem_read(FALSE,8));writes=[]
        def helper(m,a,size,data):
            ret=None
            if a==0xA033B410:ret=1
            elif a==0xA033E73C:put(m,m.reg_read(UC_ARM_REG_R2),descriptor);ret=0
            if ret is not None:m.reg_write(UC_ARM_REG_R0,ret);m.reg_write(UC_ARM_REG_PC,m.reg_read(UC_ARM_REG_LR)&~1)
        def store(m,access,a,size,value,data):
            if FALSE<=a<FALSE+8:writes.append(dict(address=hex(a),size=size,value=value))
        u.hook_add(UC_HOOK_CODE,helper);u.hook_add(UC_HOOK_MEM_WRITE,store)
        # 5th..7th arguments at caller SP.
        put(u,0x7000F000,1);put(u,0x7000F004,out);put(u,0x7000F008,1)
        ret=run(u,0xA03534D8,[sector,CHANGED,3,offset])
        after=bytes(u.mem_read(FALSE,8))
        assert ret==0 and after==before[:2]+b'\xA0'+before[3:]
        assert writes==[dict(address=hex(CHANGED),size=1,value=0xA0)]
        assert struct.unpack('<I',u.mem_read(out,4))[0]==1
        partial.append(dict(sector_offset=offset,writes=writes,reported_bytes=1))

    report=dict(cpu_sha256=SHA,range=dict(start=hex(FALSE),end_exclusive=hex(FALSE+8),original_hex=image[FALSE-BASE:FALSE-BASE+8].hex(),
        proposed_change=dict(address=hex(CHANGED),original_byte='e0',changed_byte='a0',old_instruction='mvn r0, #0',new_instruction='mov r0, #0',unchanged_return='bx lr')),
        references=dict(raw_pointer_hits=pointer_hits,retained_incoming_interval_refs=intervals,aligned_a32_branch_candidates=direct,movw_movt_within_five_instructions=constants,
            limits='Byte-pattern and bounded A32 scans are not a proof against computed pointers, arithmetic, Thumb callers, copied tables, runtime scripts or uncaptured code.'),
        interpreter_alias_callers=[r for r in calls if r['target']=='0xa029de98'],
        known_alias_arguments=['A019E160: dmesg dsp -4096 > c:\\dsp.log','A01AC580: five t audio-enc init/create/encstart/stop/delete commands'],
        visibility_parser_cases=visibility,loadbin_request_cases=loads,partial_sector_cases=partial,exports=exports,
        limitations=['No actual file service, SD read/DMA or device memory write is proven by declared file stubs.',
            'Fresh emulator instances do not model I/D-cache, fetch visibility, concurrency or restoration of live instruction state.',
            'This is a one-byte instruction visibility candidate, not arbitrary payload execution or a general code publication mechanism.'],
        target_access=False,target_write=False,binary_or_deployer_emitted=False)
    (OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print('3 real parser/handler cases; 3 loadbin request cases; 3 original partial-sector byte-store cases; no device access or binary')


if __name__=='__main__':main()
