#!/usr/bin/env python3
"""Offline original ARM FIFO lifecycle with explicitly modeled external services."""
import hashlib
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import UC_HOOK_CODE
from unicorn.arm_const import *
import audit_prerecord_video_pts as arm

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-fifo-lifecycle-audit.json'
BASE_FIFO, VIRTUAL, QUEUE=0x10003000,0x10004000,0x10008000
CONFIG, OUTPUT, CALLBACK=0x10001000,0x10001100,0x10011000
REGISTRY, GLOBAL=0xA196608C,0xA196618C
STREAM=0x1234


def signed(v): return v-(1<<32) if v>>31 else v
def sha(data): return hashlib.sha256(data).hexdigest()


class Machine:
    """OS locks, message queue, allocator and diagnostics are test doubles.

    FIFO functions, memset, 32/64-bit division remain original image instructions.
    No scheduler, real mutex or actual allocation/concurrency is executed.
    """
    def __init__(self,image):
        self.uc=arm.machine(image);self.uc.mem_map(0xA1966000,0x2000)
        self.events=[];self.locks={};self.callbacks=[]
        self.allocate_status=0;self.free_status=0;self.message_status=0
        self.lock_failure=None
        self.uc.hook_add(UC_HOOK_CODE,self.hook)
        self.put(GLOBAL+4,BASE_FIFO);self.put(GLOBAL+8,VIRTUAL)
        self.put(GLOBAL+0x50,1);self.put(GLOBAL+0x54,1)
        self.put(BASE_FIFO+4,BASE_FIFO);self.put(BASE_FIFO+8,STREAM)
        self.put(BASE_FIFO+12,1);self.put(BASE_FIFO+0x88,8)
        self.put(BASE_FIFO+0x90,5,8);self.put(BASE_FIFO+0x98,9,8)
        self.put(VIRTUAL+4,VIRTUAL)

    def put(self,address,value,size=4): arm.put(self.uc,address,value,size)
    def get(self,address,size=4): return arm.get(self.uc,address,size)
    def hook(self,uc,address,size,user):
        args=[uc.reg_read(r) for r in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)]
        result=None
        if address==0xA03BC46C:
            result=7 if self.lock_failure==args[0] else 0
            if not result:self.locks[args[0]]=self.locks.get(args[0],0)+1
            self.events.append(dict(kind='lock_model',address=hex(args[0]),timeout=hex(args[1]),result=result))
        elif address==0xA03BC498:
            self.locks[args[0]]=self.locks.get(args[0],0)-1;result=0
            self.events.append(dict(kind='unlock_model',address=hex(args[0])))
        elif address==0xA029A7D8:
            result=self.allocate_status
            if result==0:
                self.put(args[1],QUEUE);self.put(args[2],0x7788)
            self.events.append(dict(kind='allocator_model',requested_bytes=args[3],alignment=self.get(uc.reg_read(UC_ARM_REG_SP)),result=result))
        elif address==0xA03BC714:
            result=self.free_status
            self.events.append(dict(kind='pool_free_model',resource=hex(args[0]),result=result))
        elif address==0xA03BC598:
            result=self.message_status
            self.events.append(dict(kind='send_message_model',message_words=[self.get(args[1]+i*4) for i in range(3)],result=result))
        elif address in (0xA02A70EC,0xA044E734):
            result=0
        elif address==CALLBACK:
            self.callbacks.append(dict(handle=hex(args[0]),event=hex(args[1]),
               argument_word=self.get(args[2]) if args[2] else None,
               locks_held=[hex(a) for a,n in self.locks.items() if n>0],
               return_address=hex(uc.reg_read(UC_ARM_REG_LR))))
            result=0
        if result is not None:
            uc.reg_write(UC_ARM_REG_R0,result&0xffffffff)
            uc.reg_write(UC_ARM_REG_PC,uc.reg_read(UC_ARM_REG_LR))

    def run(self,address,*args):
        self.uc.reg_write(UC_ARM_REG_CPSR,0x13)
        self.uc.reg_write(UC_ARM_REG_SP,arm.STACK)
        self.uc.reg_write(UC_ARM_REG_LR,arm.RETURN)
        for r,v in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),args):self.uc.reg_write(r,v)
        arm.run(self.uc,address,arm.RETURN)
        assert self.uc.reg_read(UC_ARM_REG_SP)==arm.STACK
        return signed(self.uc.reg_read(UC_ARM_REG_R0))

    def config(self,capacity=8):
        assert self.run(0xA04509B0,CONFIG)==0
        assert bytes(self.uc.mem_read(CONFIG,0x58))==struct.pack('<III',0,128,1)+bytes(0x4c)
        self.put(CONFIG,STREAM);self.put(CONFIG+4,capacity);self.put(CONFIG+12,CALLBACK)
        self.put(OUTPUT,0xdeadbeef)

    def existing(self,read=5,write=9,capacity=8):
        self.put(VIRTUAL,0);self.put(VIRTUAL+4,VIRTUAL);self.put(VIRTUAL+8,STREAM)
        self.put(VIRTUAL+12,1);self.put(VIRTUAL+16,BASE_FIFO)
        self.put(VIRTUAL+0x80,QUEUE);self.put(VIRTUAL+0x84,capacity*32)
        self.put(VIRTUAL+0x88,capacity);self.put(VIRTUAL+0x90,read,8)
        self.put(VIRTUAL+0x98,write,8);self.put(VIRTUAL+0xA0,0x7788)
        self.put(REGISTRY,VIRTUAL)
        for index in range(capacity):self.uc.mem_write(QUEUE+index*32,bytes([index+1])*32)


def main():
    image=arm.IMAGE.read_bytes();assert sha(image)==arm.DIGEST
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    expected={
      0xA02335AC:('mov','r2, #0x2000'),
      0xA04509E4:('ldr','r3, [r0, #0xc]'),
      0xA0450BD4:('ldrb','r3, [r7, #0x1c]'),0xA0450BDC:('ldr','r3, [r7, #0x20]'),
      0xA0450BE4:('ldr','r3, [r7, #0x24]'),0xA0450BEC:('ldr','r3, [r7, #0x10]'),
      0xA0450BF4:('ldr','r3, [r7, #0x14]'),0xA0450C04:('ldr','r3, [r7, #0x28]'),
      0xA0450C70:('ldrb','r3, [r7, #0x30]'),0xA0450F24:('ldrb','r3, [r7, #0x40]'),
      0xA0450F2C:('ldrb','r3, [r7, #0x31]'),
      0xA0451050:('str','r2, [r4, #0xc]'),0xA0450BBC:('str','r4, [r1, r3, lsl #2]'),
      0xA0451284:('str','r3, [r2]'),0xA0451288:('bl','#0xa03bc498'),
      0xA0451E28:('strd','sl, fp, [r4, #0x90]'),0xA0451E78:('bl','#0xa03bc598'),
      0xA044F0BC:('bl','#0xa03bc56c'),0xA044F5B4:('bl','#0xa044e8d4'),
      0xA0452464:('bl','#0xa044e8d4'),0xA045246C:('bl','#0xa03bc498'),
      0xA044EEA0:('blx','r3'),0xA044EF1C:('blx','r3'),0xA044F024:('blx','r3'),
    }
    checks=[]
    for a,pair in expected.items():
        ins=next(md.disasm(image[a-arm.BASE:a-arm.BASE+4],a))
        assert (ins.mnemonic,ins.op_str)==pair,(hex(a),ins.mnemonic,ins.op_str,pair)
        checks.append(dict(address=hex(a),bytes=ins.bytes.hex(),instruction=ins.mnemonic+' '+ins.op_str))
    cases=[]
    def record(name,m,status,**extra):
        cases.append(dict(name=name,status=status,slot_in_use=m.get(VIRTUAL+12),registry0=hex(m.get(REGISTRY)),
             output=hex(m.get(OUTPUT)),locks={hex(a):n for a,n in m.locks.items() if n},events=m.events,
             callbacks=m.callbacks,**extra))
    # Execute the actual UVCd config-building prefix. Its earlier query/global
    # setup is excluded; r1=0, output register r5 and primary stream are supplied.
    m=Machine(image);m.uc.mem_map(0xA13C8000,0x1000)
    m.put(0xA13C82D8,STREAM)
    m.uc.reg_write(UC_ARM_REG_R1,0);m.uc.reg_write(UC_ARM_REG_R5,OUTPUT)
    arm.run(m.uc,0xA0233570,0xA02335C4)
    config=bytes(m.uc.mem_read(arm.STACK,0x58))
    assert config==struct.pack('<IIII',STREAM,8192,1,0xA0233434)+bytes(0x48)
    record('uvcd_original_config_prefix',m,0,config_hex=config.hex(),
           stopped_before_create=True,constructed_register_preconditions=True)
    for mode in ('normal','inherit_capacity','no_virtual_slots','no_base','allocator_failure','registry_full','callback_null'):
        m=Machine(image);m.config(0 if mode=='inherit_capacity' else 8)
        if mode=='no_virtual_slots':m.put(GLOBAL+0x50,0)
        if mode=='no_base':m.put(BASE_FIFO+8,STREAM+1)
        if mode=='allocator_failure':m.allocate_status=123
        if mode=='registry_full':
            for i in range(64):m.put(REGISTRY+i*4,0x55550000+i*4)
        if mode=='callback_null':m.put(CONFIG+12,0)
        status=m.run(0xA04509DC,CONFIG,OUTPUT)
        if mode in ('normal','inherit_capacity'):
            assert status==0 and m.get(OUTPUT)==VIRTUAL and m.get(VIRTUAL+16)==BASE_FIFO
            assert m.get(VIRTUAL+0x90,8)==9 and m.get(VIRTUAL+0x98,8)==9
            assert m.get(VIRTUAL+0xC0)==255 and not any(m.locks.values())
        else:
            assert status==-1
            if mode in ('no_virtual_slots','allocator_failure'):assert m.get(OUTPUT)==0
            else:assert m.get(OUTPUT)==0xdeadbeef
            if mode in ('no_base','allocator_failure','registry_full'):assert m.get(VIRTUAL+12)==1
            if mode=='allocator_failure':assert m.get(REGISTRY)==VIRTUAL
        record('create_'+mode,m,status)
    m=Machine(image);m.config()
    for off,value in ((0x10,0x1010),(0x14,3),(0x18,0x1818),(0x1c,1),
                      (0x20,0x20000000),(0x24,0x2000003f),(0x28,90000)):
        m.put(CONFIG+off,value)
    status=m.run(0xA04509DC,CONFIG,OUTPUT)
    fields={0xA8:0x1010,0xAC:3,0xB0:1,0xB8:0x20000000,0xBC:0x2000003f,0xC8:90000}
    assert status==0 and all(m.get(VIRTUAL+off,1 if off==0xB0 else 4)==v for off,v in fields.items())
    record('create_additional_fields_copied_without_history',m,status,
           copied_handler_fields={hex(k):hex(v) for k,v in fields.items()})
    m=Machine(image);m.config();m.put(BASE_FIFO+12,0)
    status=m.run(0xA04509DC,CONFIG,OUTPUT)
    assert status==0 and m.get(OUTPUT)==VIRTUAL and m.get(VIRTUAL+16)==BASE_FIFO
    record('create_matches_stream_even_if_base_flag_inactive',m,status,
           matched_base_in_use=m.get(BASE_FIFO+12),requires_external_active_base_precondition=True)
    for name,read,write,index,expected_status in (
      ('ordinary',5,9,0,0),('wrapped_slot',7,10,2,0),('empty',9,9,0,-8),
      ('no_indexed_entry',5,6,1,-8),('overlap',0,9,0,-9),('index_at_capacity',5,9,8,0)):
        m=Machine(image);m.existing(read,write);m.put(OUTPUT,0xdeadbeef)
        status=m.run(0xA0451960,VIRTUAL,OUTPUT,index)
        expected_pointer=QUEUE+((read+index)%8)*32 if status==0 and index<8 else 0
        assert status==expected_status and m.get(OUTPUT)==expected_pointer,(name,status,hex(m.get(OUTPUT)))
        assert not any(m.locks.values())
        record('peek_'+name,m,status,descriptor_pointer=hex(m.get(OUTPUT)))
    m=Machine(image);m.existing();m.put(VIRTUAL+12,0);m.put(OUTPUT,0xdeadbeef)
    status=m.run(0xA0451960,VIRTUAL,OUTPUT,0)
    assert status==-1 and m.get(OUTPUT)==0xdeadbeef
    record('peek_invalid_handle',m,status)
    for name,read,write,count,base_remove,message,expected_status in (
      ('ordinary',5,9,1,0,0,0),('two_span',7,10,2,0,0,0),
      ('too_many_clamped',5,7,9,0,0,0),('empty_clamped',9,9,1,0,0,0),
      ('send_failed_after_advance',5,9,1,0,71,71),('base_remove_on_write',5,9,1,1,0,0)):
        m=Machine(image);m.existing(read,write);m.put(BASE_FIFO+0xB0,base_remove,1);m.message_status=message
        before=bytes(m.uc.mem_read(QUEUE,256));status=m.run(0xA0451C94,VIRTUAL,count)
        removed=min(count,write-read)
        assert status==expected_status and m.get(VIRTUAL+0x90,8)==read+removed
        expected_queue=bytearray(before)
        for i in range(removed):expected_queue[((read+i)%8)*32:((read+i)%8+1)*32]=bytes(32)
        assert bytes(m.uc.mem_read(QUEUE,256))==expected_queue and not any(m.locks.values())
        record('remove_'+name,m,status,removed=removed,read_after=m.get(VIRTUAL+0x90,8))
    m=Machine(image);m.existing();m.put(VIRTUAL+12,0)
    status=m.run(0xA0451C94,VIRTUAL,1)
    assert status==-1 and m.get(VIRTUAL+0x90,8)==5 and not m.locks
    record('remove_invalid_handle_before_mutation',m,status)
    for name,free_status,registry,in_use in (('normal',0,True,True),('pool_free_failure',55,True,True),
                                          ('already_unregistered',0,False,True),('invalid_flag',0,True,False)):
        m=Machine(image);m.existing();m.free_status=free_status
        if not registry:m.put(REGISTRY,0)
        if not in_use:m.put(VIRTUAL+12,0)
        status=m.run(0xA04514E4,VIRTUAL)
        assert status==(-1 if free_status else 0)
        if name=='normal':assert m.get(VIRTUAL+12)==0 and m.get(REGISTRY)==0 and not any(m.locks.values())
        if free_status:assert m.get(VIRTUAL+12)==1 and m.get(REGISTRY)==VIRTUAL and not any(m.locks.values())
        if name in ('already_unregistered','invalid_flag'):assert m.locks[VIRTUAL+0x14]==1 and m.locks[VIRTUAL+0x48]==1
        record('delete_'+name,m,status)
    for name,kind,length,event in (('data',1,128,0x4000002),('eos_length',1,0xffffff,0x4000001),
                                  ('eos_type',255,128,0x4000001)):
        m=Machine(image);m.existing(9,9);m.put(VIRTUAL+0xA4,CALLBACK);m.put(VIRTUAL+0xC0,255)
        m.put(CONFIG+16,kind,1);m.put(CONFIG+24,length)
        status=m.run(0xA044E8D4,BASE_FIFO,CONFIG)
        assert len(m.callbacks)==1 and int(m.callbacks[0]['event'],16)==event
        assert m.callbacks[0]['locks_held']==[] and m.get(VIRTUAL+0x98,8)==10
        record('sync_callback_'+name,m,status)
    m=Machine(image);m.existing(2,9);m.put(VIRTUAL+0xA4,CALLBACK);m.put(VIRTUAL+0xC0,255)
    m.put(CONFIG+16,1,1);m.put(CONFIG+24,128)
    status=m.run(0xA044E8D4,BASE_FIFO,CONFIG)
    assert [int(row['event'],16) for row in m.callbacks]==[0x4000002,0x4000005]
    record('sync_data_then_full_notification',m,status)
    # Deliberate sequential interleaving, not a scheduler/concurrency test:
    # pause SyncWritten just after virtual unlock, execute normal Delete on an
    # independent synthetic stack, then resume the original saved CPU context.
    m=Machine(image);m.existing(9,9);m.put(VIRTUAL+0xA4,CALLBACK);m.put(VIRTUAL+0xC0,255)
    m.put(CONFIG+16,1,1);m.put(CONFIG+24,128)
    m.uc.reg_write(UC_ARM_REG_R0,BASE_FIFO);m.uc.reg_write(UC_ARM_REG_R1,CONFIG)
    arm.run(m.uc,0xA044E8D4,0xA044EE58)
    assert not any(m.locks.values()) and not m.callbacks
    context=m.uc.context_save()
    m.uc.reg_write(UC_ARM_REG_SP,arm.STACK-0x2000)
    m.uc.reg_write(UC_ARM_REG_LR,arm.RETURN);m.uc.reg_write(UC_ARM_REG_R0,VIRTUAL)
    arm.run(m.uc,0xA04514E4,arm.RETURN)
    assert m.uc.reg_read(UC_ARM_REG_R0)==0 and m.get(VIRTUAL+12)==0 and m.get(REGISTRY)==0
    m.uc.context_restore(context)
    arm.run(m.uc,0xA044EE58,arm.RETURN)
    assert len(m.callbacks)==1 and m.get(VIRTUAL+12)==0
    record('delete_does_not_barrier_already_released_sync_callback',m,0,
           explicit_sequential_interleaving=True,callback_happened_after_successful_delete=True)
    windows=[(0xA0233434,0xA02335F8),(0xA04509B0,0xA04514DC),(0xA04514E4,0xA045177C),
             (0xA0451960,0xA0451B04),(0xA0451C94,0xA0452028),(0xA044E8D4,0xA044F05C),
             (0xA044F05C,0xA044F0D0),(0xA044F5AC,0xA044F5BC),(0xA0452448,0xA0452470),
             (0xA01F845C,0xA01F8E68),(0xA01F8E68,0xA01F8E80),(0xA01F8F08,0xA01F91C0)]
    regions=[dict(begin=hex(lo),end_exclusive=hex(hi),sha256=sha(image[lo-arm.BASE:hi-arm.BASE]),
             instructions=[dict(address=hex(i.address),bytes=i.bytes.hex(),instruction=i.mnemonic+' '+i.op_str)
               for i in md.disasm(image[lo-arm.BASE:hi-arm.BASE],lo)]) for lo,hi in windows]
    output=dict(image_sha256=arm.DIGEST,evidence_type='Original ARM FIFO APIs executed with constructed RAM and explicit OS/allocator/diagnostic test doubles',
      assertions=checks,assertion_count=len(checks),cases=cases,execution_case_count=len(cases),regions=regions,
      external_models=['mutex take/unlock: bookkeeping only, no scheduler or mutual exclusion',
        'descriptor allocator/free: fixed synthetic address and selected failure status',
        'RTOS message send: captured message and selected status, no worker execution',
        'printf and FIFO trace: ignored', 'notification callback: records event, argument word and modeled held locks, returns synchronously'],
      original_helpers_executed=['memset A04F8DEC','32-bit division A0506674','64-bit division A0506F38'],
      limitations=['No actual scheduling, lock safety, concurrent producer/delete, DMA, payload ownership or camera execution was tested.',
        'Callback lock observations cover the base-to-virtual SyncWritten path with one constructed virtual FIFO; another direct path is statically identified but not executed.',
        'History config modes are statically observed only; the minimal UVCd-compatible zero-history mode alone is executed.',
        'Create failure state and Delete early-return locks are original-instruction observations under selected external return values; no device repair is attempted.',
        'SyncWritten is void; recorded r0 return values are not an API status.'],device_access=False)
    OUT.write_text(json.dumps(output,indent=2)+'\n')
    OUT.with_suffix('.asm').write_text('\n'.join(
        row['address']+' '+row['bytes']+' '+row['instruction']
        for region in regions for row in region['instructions'])+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),assertions=len(checks),original_arm_cases=len(cases))))


if __name__=='__main__':main()
