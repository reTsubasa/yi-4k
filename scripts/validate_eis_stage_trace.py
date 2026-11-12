#!/usr/bin/env python3
"""Host C + compiled ARM same-invocation EIS receipt checks. No device access."""
from __future__ import annotations
import argparse
import ctypes as C
import hashlib
import io
import json
import shutil
import struct
import subprocess
import zlib
from pathlib import Path
from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *
import eis_stage_failure_contract as stock

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'sdk/yi4k_1107_eis_stage_trace.c'
HEADER=SOURCE.with_suffix('.h')
CODE, DATA, STACK, RETURN=0x10000000,0x20000000,0x3000f000,0x40000000

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
class Table(C.Structure): _fields_=[(k,C.c_uint32) for k in ('bank','x','y','digest_x','digest_y')]
class Receipt(C.Structure): _fields_=[('token',C.c_uint32),('context',C.c_uint32),('stage',C.c_uint32),('status',C.c_int32),('table_token',C.c_uint32),('table',Table),('observations',C.c_uint32)]
class Slot(C.Structure): _fields_=[(k,C.c_uint32) for k in ('token','context','stage','finished','verdict')]+[('generated',Table),('prepared',Table)]
class Trace(C.Structure): _fields_=[('next_token',C.c_uint32),('slots',Slot*4)]

class Host:
    def __init__(self,lib): self.lib=lib; self.t=Trace()
    def init(self): self.lib.yi4k_eis_stage_trace_init(C.byref(self.t))
    def begin(self,c): return self.lib.yi4k_eis_stage_trace_begin(C.byref(self.t),c)
    def apply(self,r): return self.lib.yi4k_eis_stage_trace_apply(C.byref(self.t),C.byref(r))
    def finish(self,t): return self.lib.yi4k_eis_stage_trace_finish(C.byref(self.t),t)
    def state(self): return bytes(self.t)
    def next(self,n): self.t.next_token=n
    def dirty(self): C.memset(C.byref(self.t),0xa5,C.sizeof(self.t))

class Arm:
    def __init__(self,blob):
        self.uc=Uc(UC_ARCH_ARM,UC_MODE_ARM); self.uc.mem_map(CODE,0x10000)
        self.uc.mem_map(DATA,0x10000); self.uc.mem_map(STACK&~0xffff,0x10000)
        self.uc.mem_map(RETURN,0x1000)
        elf=ELFFile(io.BytesIO(blob)); self.symbols={s.name:s['st_value'] for s in elf.get_section_by_name('.symtab').iter_symbols() if s.name}
        assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in elf.get_section_by_name('.symtab').iter_symbols())
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        for s in elf.iter_sections():
            if s['sh_flags']&2 and s['sh_size']: self.uc.mem_write(s['sh_addr'],s.data() if s['sh_type']!='SHT_NOBITS' else bytes(s['sh_size']))
    def call(self,name,*args):
        u=self.uc; u.reg_write(UC_ARM_REG_CPSR,0x13)
        for r,v in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),args): u.reg_write(r,v)
        saved={r:0xabcd0000+i for i,r in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
        for r,v in saved.items(): u.reg_write(r,v)
        u.reg_write(UC_ARM_REG_SP,STACK); u.reg_write(UC_ARM_REG_LR,RETURN)
        u.emu_start(self.symbols['yi4k_eis_stage_trace_'+name],RETURN,count=10000)
        assert u.reg_read(UC_ARM_REG_PC)==RETURN and u.reg_read(UC_ARM_REG_SP)==STACK
        assert all(u.reg_read(r)==v for r,v in saved.items())
        return u.reg_read(UC_ARM_REG_R0)
    def init(self): self.call('init',DATA)
    def begin(self,c): return self.call('begin',DATA,c)
    def apply(self,r): self.uc.mem_write(DATA+0x1000,bytes(r)); return self.call('apply',DATA,DATA+0x1000)
    def finish(self,t): return self.call('finish',DATA,t)
    def state(self): return bytes(self.uc.mem_read(DATA,C.sizeof(Trace)))
    def next(self,n): self.uc.mem_write(DATA,struct.pack('<I',n))
    def dirty(self): self.uc.mem_write(DATA,b'\xa5'*C.sizeof(Trace))

def receipt(token,stage,status=0,table=None,obs=0,context=0x30000000,table_token=None):
    return Receipt(token,context,stage,C.c_int32(status).value,token if table_token is None else table_token,Table(*(table or [0,0,0,0,0])),obs)

def exercise(engine,inputs):
    # Initialize dirty storage, not merely a loader's zero-filled BSS.
    engine.dirty(); engine.init(); out=[]
    initialized=Trace.from_buffer_copy(engine.state())
    assert initialized.next_token==1
    for slot in initialized.slots:
        assert slot.finished==1
        assert not any(bytes(slot.generated)) and not any(bytes(slot.prepared))
    for c in inputs:
        operation,*args=c
        if operation=='begin': value=engine.begin(*args)
        elif operation=='apply': value=engine.apply(*args)
        elif operation=='finish': value=engine.finish(*args)
        elif operation=='next': engine.next(*args); value=None
        else: raise AssertionError(operation)
        out.append(value)
    return out,engine.state()

def main():
    p=argparse.ArgumentParser(description=__doc__); p.add_argument('--output',type=Path,required=True); a=p.parse_args()
    a.output.mkdir(parents=True,exist_ok=False)
    linker=shutil.which('ld.lld') or str(sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))[-1])
    commands=[]
    def run(cmd): subprocess.run(cmd,check=True,capture_output=True); commands.append(cmd)
    library=a.output/'stage-trace.dylib'; obj=a.output/'stage-trace.o'; elf=a.output/'stage-trace.elf'; ld=a.output/'emulation.ld'
    common=['-O2','-Wall','-Wextra','-Werror','-fno-builtin','-fno-stack-protector']
    run(['clang',*common,'-dynamiclib',str(SOURCE),'-o',str(library)])
    run(['clang',*common,'--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-ffreestanding','-fno-unwind-tables','-fno-asynchronous-unwind-tables','-c',str(SOURCE),'-o',str(obj)])
    ld.write_text('ENTRY(yi4k_eis_stage_trace_init)\nSECTIONS { . = 0x10000000; .text : { *(.text*) } .rodata : { *(.rodata*) } .data : { *(.data*) } .bss : { *(.bss*) } }\n')
    run([linker,'-T',str(ld),str(obj),'-o',str(elf)])
    lib=C.CDLL(str(library.resolve()))
    for name in ('begin','apply','finish'): getattr(lib,'yi4k_eis_stage_trace_'+name).restype=C.c_uint32
    image=stock.IMAGE.read_bytes(); assert hashlib.sha256(image).hexdigest()==stock.SHA256
    cases=[]; checks=[]
    def case(name,inputs,expected,raw=None):
        h=Host(lib); arm=Arm(elf.read_bytes()); hresult,hstate=exercise(h,inputs); aresult,astate=exercise(arm,inputs)
        assert hresult==aresult==expected,(name,hresult,aresult,expected)
        assert hstate==astate,(name,'state differs')
        encoded=[]
        for operation,*values in inputs:
            if operation=='apply':
                r=values[0]
                encoded.append({'operation':operation,**{key:getattr(r,key) for key in ('token','context','stage','status','table_token','observations')},'table':list(struct.unpack('<5I',bytes(r.table)))})
            else: encoded.append({'operation':operation,'arguments':values})
        cases.append({'name':name,'operations':encoded,'returns':hresult,'state_sha256':hashlib.sha256(hstate).hexdigest(),'stock_scenario':raw})
    payload=bytes((n*17+3)&255 for n in range(0x3000)); digests=[zlib.crc32(payload[:0x1800]),zlib.crc32(payload[0x1800:])]
    for gen in (0,1,0xffffffff):
        for fault in ('none','set-lookup','get-lookup'):
            for enabled in (0,1):
                raw=stock.scenario(image,'zero',gen,fault,enabled)
                new=[0x30100000,*[int(x,16) for x in raw['new_bank_addresses']],*digests]
                old=[0x30000000,*[int(x,16) for x in raw['old_descriptor_addresses']],0x11111111,0x22222222]
                events=[('begin',0x30000000),('apply',receipt(1,1,gen,new))]; expected=[1,2 if gen else 0]
                verdict=2 if gen else 0
                if not gen:
                    returns={x['stage_return']:int(x['return'],16) for x in raw['events'] if 'stage_return' in x}
                    copy=sum(x.get('bytes',0) for x in raw['events'] if x.get('dependency')=='copy')
                    clean=sum(x.get('bytes',0) for x in raw['events'] if x.get('dependency')=='clean')
                    observations=15 if copy==0x3000 and clean==0x3000 else 0
                    events += [('apply',receipt(1,2,returns['set'],new if fault!='set-lookup' else old,observations))]
                    verdict=3 if returns['set'] else 0; expected.append(verdict)
                    staged=new if fault=='none' else old
                    events += [('apply',receipt(1,3,returns['get'],staged)),('apply',receipt(1,4,0,staged,raw['ready_byte_after']))]
                    verdict=verdict or (4 if returns['get'] else 0); expected.append(verdict)
                    verdict=verdict or 1; expected.append(verdict)
                events.append(('finish',1)); expected.append(verdict)
                case(f'original-{gen:x}-{fault}-enable{enabled}',events,expected,raw)
    table=[0x30100000,0x3010d060,0x3010e860,*digests]
    good=[('apply',receipt(1,1,table=table)),('apply',receipt(1,2,table=table,obs=15)),('apply',receipt(1,3,table=table)),('apply',receipt(1,4,table=table))]
    case('missing-get-ready-is-not-enough',[('begin',0x30000000),*good[:2],good[3],('finish',1)],[1,0,0,6,6])
    case('missing-tail-is-incomplete',[('begin',0x30000000),*good[:3],('finish',1)],[1,0,0,0,0])
    case('duplicate-calc',[('begin',0x30000000),good[0],good[0],('finish',1)],[1,0,6,6])
    case('duplicate-after-prepared',[('begin',0x30000000),*good,good[3],('finish',1)],[1,0,0,0,1,6,6])
    case('candidate-nonzero-status',[('begin',0x30000000),*good[:3],('apply',receipt(1,4,status=1,table=table)),('finish',1)],[1,0,0,0,6,6])
    case('candidate-nonzero-status-old-table-token',[('begin',0x30000000),*good[:3],('apply',receipt(1,4,status=1,table=table,table_token=2)),('finish',1)],[1,0,0,0,6,6])
    case('old-token-after-slot-reuse',[('begin',0x30000000),('finish',1),('begin',0x30000000),good[0],('finish',2)],[1,0,2,7,0])
    case('wrong-context',[('begin',0x30000000),('apply',receipt(1,1,table=table,context=0x30000001)),('finish',1)],[1,6,6])
    mixed=[('begin',0x30000000),('finish',1),('begin',0x30000000)]
    mixed.extend(('apply',receipt(2,stage,table=table,obs=15 if stage==2 else 0,table_token=1 if stage==3 else 2)) for stage in (1,2,3,4))
    case('same-bank-cross-invocation-getter',mixed+[('finish',2)],[1,0,2,0,0,5,5,5])
    case('missing-clean-receipt',[('begin',0x30000000),good[0],('apply',receipt(1,2,table=table,obs=3)),('finish',1)],[1,0,5,5])
    stale=table.copy(); stale[3]^=1
    case('same-address-stale-content',[('begin',0x30000000),*good[:2],('apply',receipt(1,3,table=stale)),('finish',1)],[1,0,0,5,5])
    stale=table.copy(); stale[1]+=0x1000
    case('wrong-bank-address',[('begin',0x30000000),*good[:2],('apply',receipt(1,3,table=stale)),('finish',1)],[1,0,0,5,5])
    case('bounded-full',[('begin',1),('begin',2),('begin',3),('begin',4),('begin',5),('finish',2),('begin',5)],[1,2,3,4,0,0,5])
    inter=[('begin',0x30000000),('begin',0x30000001)]; expected=[1,2]
    for stage in range(1,5):
        for token in (1,2):
            inter.append(('apply',receipt(token,stage,table=table,obs=15 if stage==2 else 0,context=0x30000000+token-1)))
            expected.append(1 if stage==4 else 0)
    case('two-interleaved-invocations',inter+[('finish',1),('finish',2)],expected+[1,1])
    case('token-exhaustion-no-reuse',[('next',0xffffffff),('begin',1),('finish',0xffffffff),('begin',1)],[None,0xffffffff,0,0])
    report={'evidence_kind':'Host compiled C and ARM compiled C in Unicorn, plus original zero-branch ARM stage-failure scenarios','case_count':len(cases),'cases':cases,'commands':commands,'cpu_image_sha256':stock.SHA256,'source_hashes':{str(p.relative_to(ROOT)):sha(p) for p in (SOURCE,HEADER,Path(__file__),Path(stock.__file__))},'abi':{'trace_bytes':C.sizeof(Trace),'receipt_bytes':C.sizeof(Receipt),'arm_callee_saved_and_sp_checked':True},'device_access':False,'replacement_ready':False,'limits':['Not an installed recorder; token/context receipts are caller-provided, not authenticated hardware observations.','Original harness models generation status, context/mutex lookup, logical copy, cache-clean call logging and address conversion.','CRC32 fixture identifies synthetic plane contents; collisions or dishonest receipts are not detected.','Only mandatory-Get zero branch is supported; debug-gated nonzero branch cannot be relabeled PREPARED.','No runtime allocation/entry/unregister, SMP synchronization, cache completion, DSP latch or encoded-frame association is proved.']}
    (a.output/'validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'case_count':len(cases),'output':str(a.output),'device_access':False}))
if __name__=='__main__': main()
