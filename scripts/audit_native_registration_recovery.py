#!/usr/bin/env python3
"""Original ARM registry failure/duplicate/unlocked-dispatch counterexamples.

All services and RAM are explicit host models; no device or patch is emitted.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
BASE=0xA0100000
SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
REGISTRY=0xA06F3070
MUTEX=0xA1446708
class Machine:
    def __init__(self,image,fail=0):
        self.u=Uc(UC_ARCH_ARM,UC_MODE_ARM)
        self.u.mem_map(BASE,(len(image)+4095)&~4095);self.u.mem_write(BASE,image)
        self.u.mem_map(0x70000000,0x10000);self.u.mem_map(0xA1400000,0x50000)
        self.events=[];self.fail=fail;self.allocs=0;self.owner=None;self.depth=0;self.actor=1
        self.next_alloc=0x70004000;self.handlers=[]
        self.put(REGISTRY,0x70000100);self.u.mem_write(0x70000100,b'stock-root\0')
        self.put(REGISTRY+4,0x70002000);self.put(REGISTRY+8,0)
        self.u.hook_add(UC_HOOK_CODE,self.hook)
    def put(self,at,v):self.u.mem_write(at,struct.pack('<I',v & 0xffffffff))
    def get(self,at):return struct.unpack('<I',self.u.mem_read(at,4))[0]
    def string(self,at):return bytes(self.u.mem_read(at,128)).split(b'\0',1)[0].decode()
    def hook(self,u,at,size,user):
        args=[u.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
        ret=None;kind=None
        if at==0xA04F99F0:ret=len(self.string(args[0]));kind='strlen'
        elif at==0xA04F9B38:u.mem_write(args[0],bytes(u.mem_read(args[1],args[2])));ret=args[0];kind='memcpy'
        elif at==0xA04F9744:ret=int(self.string(args[0])!=self.string(args[1]));kind='strcmp'
        elif at==0xA03BC46C:
            assert args[:2]==[MUTEX,0xffffffff];kind='mutex_take'
            if self.owner not in (None,self.actor):
                # Stop rather than invent a return from a real infinite-wait
                # mutex call. The OS scheduling/deadlock behavior is unmodeled.
                self.events.append(dict(kind='other_owner_infinite_wait_requested',actor=self.actor,args=args))
                u.emu_stop();return
            self.owner=self.actor;self.depth+=1;ret=0
        elif at==0xA03BC498:
            assert self.owner==self.actor and args[0]==MUTEX;self.depth-=1
            if not self.depth:self.owner=None
            ret=0;kind='mutex_give'
        elif at==0xA03BC6DC:
            assert args[0]==0xA144A73C and args[3]==0;self.allocs+=1;kind='pool_allocate'
            if self.allocs==self.fail:ret=1
            else:self.put(args[1],self.next_alloc);self.next_alloc+=(args[2]+7)&~7;ret=0
        elif at==0xA03BC714:ret=0;kind='pool_free'
        elif at in (0x70002000,0x70002004,0x70002008):
            self.handlers.append(at);ret=0x12340000+(at-0x70002000);kind='handler'
        elif at==0x70003000:ret=0;kind='print'
        if kind:
            self.events.append(dict(kind=kind,actor=self.actor,args=args,return_value=ret))
            u.reg_write(UC_ARM_REG_R0,ret);u.reg_write(UC_ARM_REG_PC,u.reg_read(UC_ARM_REG_LR)&~1)
            u.reg_write(UC_ARM_REG_CPSR,u.reg_read(UC_ARM_REG_CPSR)&~0x20)
    def call(self,entry,args):
        saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
        for n,r in enumerate(saved):self.u.reg_write(r,0xABC00000+n)
        for r,v in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2),args):self.u.reg_write(r,v)
        self.u.reg_write(UC_ARM_REG_SP,0x7000F000);self.u.reg_write(UC_ARM_REG_LR,0x7000F800)
        self.u.emu_start(entry,0x7000F800,count=10000)
        returned=self.u.reg_read(UC_ARM_REG_PC)==0x7000F800
        if returned:
            assert self.u.reg_read(UC_ARM_REG_SP)==0x7000F000
            assert all(self.u.reg_read(r)==0xABC00000+n for n,r in enumerate(saved))
        return dict(returned=returned,r0=self.u.reg_read(UC_ARM_REG_R0),mutex_owner=self.owner,mutex_depth=self.depth)
    def register(self,name='probe',handler=0x70002004):
        self.u.mem_write(0x70001000,name.encode()+b'\0')
        return self.call(0xA029E098,[0x70001000,handler,0])
    def dispatch(self):
        for n,value in enumerate(('t','probe','arg')):
            at=0x70001100+n*0x80;self.u.mem_write(at,value.encode()+b'\0');self.put(0x70001400+n*4,at)
        return self.call(0xA029E1A4,[3,0x70001400,0x70003000])

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',required=True,type=Path);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    image=(ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin').read_bytes();assert hashlib.sha256(image).hexdigest()==SHA
    rows=[]
    for fail in (0,1,2):
        m=Machine(image,fail);receipt=m.register()
        assert receipt['returned'] and receipt['r0']==(0 if not fail else 0xffffffff)
        assert m.depth==(1 if fail else 0)
        if fail:
            assert not any(e['kind']=='mutex_give' for e in m.events)
            assert sum(e['kind']=='pool_free' for e in m.events)==int(fail==2)
            m.actor=2;blocked=m.register();assert not blocked['returned']
        else:blocked=None
        rows.append(dict(name=f'allocation_failure_{fail}',receipt=receipt,other_owner=blocked,events=m.events))
    m=Machine(image);first=m.register();node1=m.get(REGISTRY+8)
    second=m.register(handler=0x70002008);node2=m.get(node1+8)
    assert node1 and node2 and m.get(node1+4)==0x70002004 and m.get(node2+4)==0x70002008 and m.get(node2+8)==0
    before=len(m.events);dispatched=m.dispatch()
    assert dispatched['r0']==0x12340004 and m.handlers==[0x70002004]
    assert not any(e['kind'].startswith('mutex') for e in m.events[before:])
    rows.append(dict(name='same_name_append_does_not_replace',registrations=[first,second],nodes=[hex(node1),hex(node2)],dispatch=dispatched,events=m.events))
    # A held registry mutex is not a quiescence gate: the real dispatcher
    # still reaches the earlier handler without calling any mutex service.
    m.owner=1;m.depth=1;m.actor=2;before=len(m.events);dispatched=m.dispatch()
    assert dispatched['returned'] and m.handlers==[0x70002004,0x70002004]
    assert not any(e['kind'].startswith('mutex') for e in m.events[before:])
    rows.append(dict(name='registry_mutex_does_not_quiesce_dispatch',dispatch=dispatched,events=m.events[before:]))
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM);raw=image[0xA029E098-BASE:0xA029E260-BASE]
    (a.output/'registry-dispatch.asm').write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(raw,0xA029E098))+'\n')
    report=dict(schema=1,status='pass',image_sha256=SHA,script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),cases=rows,case_count=len(rows),device_access=False,
                conclusion='Original registration failure paths retain the acquired mutex; same-name registration appends and does not replace; holding that mutex does not stop the unlocked dispatcher from tail-calling the earlier handler.',
                models=['strlen/strcmp/memcpy; pool allocation/free; recursive owner-counted mutex; handler and print callbacks; synthetic registry root and RAM.'],
                limits=['Real ThreadX scheduler/mutex bodies are not executed; a different-owner infinite-wait request stops emulation at the service boundary instead of fabricating timeout/deadlock behavior.',
                        'No unregister, code publication, external first-entry, active caller quiescence or device recovery is established.'])
    (a.output/'audit.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(status='pass',cases=len(rows),device_access=False)))
if __name__=='__main__':main()
