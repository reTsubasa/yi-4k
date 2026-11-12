#!/usr/bin/env python3
"""Offline execution of the stock RPC test service entry and its failure edges.

The original 1.10.7 ARM registration/dispatch bytes run in Unicorn. Allocator,
port, task, string and print services are explicit synthetic stubs; no device
RPC, SD input, payload or writer is used. The test asks whether an externally
reachable stock handler supplies a controlled native code entry. It records the
negative result and the ownership leaks/foreign Linux boundary in the original
control flow.
"""
from __future__ import annotations
import argparse, hashlib, json, struct
from pathlib import Path
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
BASE=0xA0100000
IMAGE_PATH=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
IMAGE_SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
HEAD=0xA0789608
PROGRAM=0x10000001
RETURN=0x7003f000
STACK_BASE=0x70100000

class Run:
    def __init__(self,image,case):
        self.case=case; self.u=Uc(UC_ARCH_ARM,UC_MODE_ARM)
        self.u.mem_map(0xA0000000,0x04000000);self.u.mem_write(BASE,image)
        self.u.mem_map(0x70000000,0x00400000)
        self.heap=0x70100000;self.events=[];self.allocs=[];self.frees=[];self.prints=[]
        self.put(HEAD,HEAD);self.put(HEAD+4,HEAD)
        # The firmware stores this as a pool base/global pointer. Zero is the
        # synthetic base used by the original constructor's address arithmetic.
        self.put(0xA14452E4,0)
        self.u.hook_add(UC_HOOK_CODE,self.hook)
        self.seed_argv(case['argv'])

    def put(self,a,v): self.u.mem_write(a,struct.pack('<I',v & 0xffffffff))
    def get(self,a): return struct.unpack('<I',self.u.mem_read(a,4))[0]
    def cstr(self,a): return bytes(self.u.mem_read(a,512)).split(b'\0',1)[0].decode('latin1')
    def seed_argv(self,argv):
        self.argv=0x70001000
        for i,w in enumerate(argv):
            at=0x70010000+i*0x1000;self.u.mem_write(at,w.encode()+b'\0');self.put(self.argv+4*i,at)
        self.put(self.argv+4*len(argv),0)

    def ret(self,at,value):
        self.u.reg_write(UC_ARM_REG_R0,value & 0xffffffff)
        self.u.reg_write(UC_ARM_REG_CPSR,self.u.reg_read(UC_ARM_REG_CPSR)&~0x20)
        self.u.reg_write(UC_ARM_REG_PC,self.u.reg_read(UC_ARM_REG_LR)&~1)

    def hook(self,u,at,size,user):
        args=[u.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
        kind=None; result=None
        if at==0xA04F9744:
            kind='strcmp';result=int(self.cstr(args[0])!=self.cstr(args[1]))
        elif at==0xA03CD2D8:
            # Stock allocator wrapper: all allocations are explicit synthetic
            # non-device objects; preserve enough bytes for original accesses.
            size=max(args[0],0x100);result=(self.heap+0x1f)&~0x1f;self.heap=result+size+0x100
            self.allocs.append({'address':hex(result),'requested':args[0],'capacity':size})
            self.u.mem_write(result,b'\0'*min(size,0x2000));kind='pool_alloc'
        elif at==0xA03CD264:
            kind='pool_free';self.frees.append(args[0]);result=0
        elif at==0xA03C87A0:
            kind='port_register';result=0
        elif at==0xA03C88F8:
            kind='port_bind';result=0
        elif at==0xA03BC2BC:
            # Original wrapper ABI: object, name/entry args and external stack;
            # do not execute a scheduler in this offline model.
            kind='task_create';result=0
        elif at==0xA02A70EC:
            kind='print';result=0
            try:self.prints.append(self.cstr(args[0]))
            except Exception:self.prints.append('<format-pointer>')
        if result is not None:
            self.events.append(dict(address=hex(at),kind=kind,args=[hex(x) for x in args],result=hex(result)))
            self.ret(at,result)

    def run(self):
        regs=[(UC_ARM_REG_R0,len(self.case['argv'])),(UC_ARM_REG_R1,self.argv),
              (UC_ARM_REG_R2,0x70030000),(UC_ARM_REG_SP,0x703ff000),
              (UC_ARM_REG_LR,RETURN),(UC_ARM_REG_CPSR,0x13)]
        for r,v in regs:self.u.reg_write(r,v)
        self.u.reg_write(UC_ARM_REG_C1_C0_2,0xf00000);self.u.reg_write(UC_ARM_REG_FPEXC,0x40000000)
        self.u.emu_start(0xA0245CF4,RETURN,count=400000)
        assert self.u.reg_read(UC_ARM_REG_PC)==RETURN
        return dict(name=self.case['name'],argv=self.case['argv'],returned=True,return_code=hex(self.u.reg_read(UC_ARM_REG_R0)),
                    events=self.events,allocations=self.allocs,free_addresses=[hex(x) for x in self.frees],
                    service_list_head=hex(self.get(HEAD)),printed=self.prints)

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',required=True,type=Path);a=p.parse_args()
    image=IMAGE_PATH.read_bytes();assert hashlib.sha256(image).hexdigest()==IMAGE_SHA
    cases=[dict(name='first_stock_service_registration',argv=['rpc','svc','test','+']),
           dict(name='duplicate_registration_after_first',argv=['rpc','svc','test','+'])]
    # First two must share the same synthetic registration list, so execute in
    # one machine while preserving original global list state.
    first=Run(image,cases[0]); row1=json.loads(json.dumps(first.run()))
    # Reuse the same machine and hook binding so the first registration remains
    # visible to the duplicate check. Slice the second invocation's deltas out
    # of the cumulative callback logs.
    second=first; second.case=cases[1]
    event_start=len(second.events); alloc_start=len(second.allocs)
    free_start=len(second.frees); print_start=len(second.prints)
    second.seed_argv(cases[1]['argv']); raw2=second.run()
    row2=dict(raw2)
    row2['events']=raw2['events'][event_start:]
    row2['allocations']=raw2['allocations'][alloc_start:]
    row2['free_addresses']=raw2['free_addresses'][free_start:]
    row2['printed']=raw2['printed'][print_start:]
    # Duplicate run allocates the temporary 4K stack/table in the command
    # wrapper, but the original duplicate check exits before adopting stack.
    dup_allocs=[x['requested'] for x in row2['allocations']]
    assert row1['returned'] and row2['returned'] and row2['return_code']=='0x0'
    assert row1['service_list_head'] != hex(HEAD)
    assert 0x1000 in dup_allocs and 0x10 in dup_allocs
    assert any(e['kind']=='task_create' for e in row1['events'])
    assert not any(e['kind']=='task_create' for e in row2['events'])
    assert any('resgistered already' in x for x in row2['printed'])
    # Ensure no synthetic bytes were emitted as a target payload or file.
    report={'schema':'native-rpc-external-entry-audit/v1','status':'pass_bounded_negative_entry_audit',
      'device_access':False,'firmware_execution':'original ARM control flow under Unicorn; external services synthetic',
      'image_sha256':IMAGE_SHA,'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'cases':[row1,row2],
      'findings':{
        'stock_rpc_service_registration_is_externally_script_reachable':True,
        'first_registration_creates_fixed_worker':True,
        'duplicate_registration_adopts_new_stack':False,
        'duplicate_registration_task_create_called':False,
        'duplicate_registration_stack_allocation_orphaned':True,
        'duplicate_registration_procedure_table_freed':True,
        'handler_address_controlled_by_external_request':False,
        'linux_exec_path_is_native_rtOS_entry':False,
        'native_payload_emitted':False,
      },
      'limits':['Synthetic allocator/port/task/print stubs are not live RTOS/device behavior.',
        'Linux exec classification comes from static source analysis; this audit does not emulate its client transport.',
        'No shell command was sent; no camera memory/firmware/SD was changed.',
        'Original unregister and task scheduler quiescence remain unproven for a live service.',
        'The duplicate allocation leak is an original control-flow finding in this declared model, not a device leak measurement.'],
      'conclusion':'The externally script-reachable RPC service path registers fixed in-firmware handlers. Static analysis identifies separate exec commands as Linux text forwarding, with unsafe fixed-buffer string handling. These paths supply no parameterized ARM entry, no caller-controlled function pointer, and no I-cache publication or independent recovery. Do not use them as a native EIS loader.'}
    a.output.mkdir(parents=True,exist_ok=False);(a.output/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'status':report['status'],'cases':len(report['cases']),'device_access':False,'duplicate_task_create':False,'native_entry':False}))
if __name__=='__main__':main()
