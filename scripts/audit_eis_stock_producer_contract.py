#!/usr/bin/env python3
"""Pin stock producer boundaries; execute real CPU envelopes with declared stubs.

Does not execute warp arithmetic, caches, locks, address translation, DSP or MMIO.
No device access, binary patch, deployable wrapper, or writer.
"""
from __future__ import annotations
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *
from analyze_eis_warp_publication import ROOT, IMAGE, SHA256, BASE
from audit_eis_orc_core import DSP, REF, DSP_SHA, REF_SHA, CoreDecoder, sha
from audit_eis_dsp_reference import inventory

OUT=ROOT/'artifacts/device/2026-11-10-eis-stock-producer-contract'
CHECKS={
0xA0311CE4:'bl #0xa0308880',0xA0311CF8:'bl #0xa03bc46c',
0xA03120C8:'add r0, r0, #0x600',0xA03120D8:'str r0, [sp, #0x68]',
0xA03120E4:'str ip, [sp, #0x58]',0xA03120EC:'str r2, [sp, #0x60]',
0xA0311D80:'mov r0, r5',0xA0311D84:'add r1, sp, #0x64',
0xA0311D88:'add r2, sp, #0x54',0xA0311D8C:'bl #0xa032cf38',
0xA0311D90:'subs r7, r0, #0',0xA0311D94:'beq #0xa03122d8',
0xA0311D9C:'bl #0xa03bc498',0xA03122E0:'mov r2, #0xc0',
0xA03122E4:'bl #0xa029c680',0xA03122EC:'str r3, [sb]',0xA03122F4:'str r3, [sl]',
0xA0312300:'cmp r3, #1',0xA0312304:'moveq r0, #2',
0xA0312310:'moveq r0, #3',0xA031236C:'bl #0xa02cece4',
0xA03124BC:'bl #0xa03bc46c',
0xA0312790:'ldrb r2, [r2, #0x88a]',0xA0312794:'ldrb r1, [fp, #0x392]',
0xA0312798:'ldr r0, [r3, #0x38]',0xA03127A0:'uxtbhi r0, r0',
0xA03127A4:'addhi r1, r1, r0',0xA03127A8:'rsb r1, r2, r1',
0xA03127C0:'ldr r6, [r2, #4]',0xA03127CC:'add r7, r7, #0x60',
0xA03127D0:'add r6, r6, #0x60',0xA03126E8:'mov r2, #0x1800',
0xA03126F4:'bl #0xa029c680',0xA0312704:'bl #0xa029c680',
0xA0312708:'str r7, [r8, #8]',0xA031270C:'str r6, [r8, #0xc]',
0xA03127F8:'bl #0xa04a22cc',0xA0312804:'bl #0xa04a22cc',
0xA0309118:'movls r7, #6',0xA0309164:'str r7, [r3, #0x38]',
0xA03092C8:'movw r0, #0x2d20',0xA03092D0:'movt r0, #1',
0xA03092E0:'bl #0xa03086b4',
0xA032D0E4:'str r3, [r5]',0xA032D134:'bl #0xa0316174',
0xA032D2D8:'bl #0xa032b520',0xA032D0C8:'bl #0xa032a6c4',
0xA02DA3FC:'bl #0xa03119a8',
}
CPU_WINDOWS={
'producer-envelope':(0xA0311CCC,0xA0311DA4),'video-vector':(0xA03120A0,0xA03120F8),
'status-commit':(0xA03122D8,0xA0312378),'ring-selection':(0xA0312788,0xA03127D8),
'setwarp-copy':(0xA0312658,0xA0312778),'setwarp-clean':(0xA03127F0,0xA031282C),
'bank-init':(0xA0309110,0xA030916C),'bank-allocation':(0xA03092B0,0xA0309300),
'core-output-status':(0xA032D0C8,0xA032D140),'core-video-call':(0xA032D2C8,0xA032D2E4),
}
ORC_CHECKS={0x18A454:'l.sfnei r3,24',0x18A45C:'l.addi r11,r0,2',
0x18A51C:'l.lwz r12,10784(r14)',0x18A528:'l.addi r12,r12,1920',
0x18A538:'l.ori r4,r4,0x1280',0x18A53C:'l.add r12,r12,r4',
0x18A63C:'l.lwz r4,0(r5)',0x18A640:'l.add r11,r11,r4',
0x187A40:'l.ori r3,r3,0xa3c9',0x18B790:'l.ori r3,r3,0xbf33'}


def emulate(data):
    u=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    u.mem_map(BASE,(len(data)+4095)&~4095);u.mem_write(BASE,data)
    u.mem_map(0xA1400000,0x200000)
    u.mem_map(0x30000000,0x400000);u.mem_map(0x70000000,0x10000)
    C,P,MODE,M,W=0x30000000,0x30380000,0x30380100,0x30390000,0x303A0000
    regs=[UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3]
    def put(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
    def get(a):return struct.unpack('<I',u.mem_read(a,4))[0]
    state={};events=[];captures=[]
    def hook(machine,a,size,user):
        r=[machine.reg_read(z) for z in regs]
        ret=None
        if a==0xA0308880:put(r[1],M);ret=0;events.append({'kind':'mutex_lookup'})
        elif a==0xA0308754:put(r[1],C);ret=0;events.append({'kind':'context_lookup'})
        elif a==0xA03BC46C:ret=0;events.append({'kind':'lock','object':hex(r[0])});state['locked']=True
        elif a==0xA03BC498:ret=0;events.append({'kind':'unlock','object':hex(r[0])});state['locked']=False
        elif a in [0xA02CECE4,0xA02CED58]:ret=W;events.append({'kind':'still_work_lookup','helper':hex(a),'mode':r[0]})
        elif a==0xA032CF38:
            assert state['locked']
            vin=[get(r[1]+x) for x in range(0,20,4)];vout=[get(r[2]+x) for x in range(0,16,4)]
            pipe=state['pipe'];scratch=C+(0x47600 if pipe==0 else 0x68560)
            assert vin[0]==P and vin[1+pipe]==scratch and vin[2-pipe]==0
            assert vin[4]==C+(0x2F04 if pipe==0 else 0x52A7C)
            assert vout[1]==C+(0x41104 if pipe==0 else 0x60884)
            assert vout[3]==C+(0x41154 if pipe==0 else 0x608D4)
            assert vin[3]==(0 if pipe==0 else W)
            u.mem_write(scratch,state['pattern']);put(r[2],1);put(r[2]+8,7)
            captures.append({'pipe':pipe,'input_vector':[hex(x) for x in vin],
                             'status_vector_before':[hex(x) for x in vout],
                             'theta_bytes':bytes(u.mem_read(P+0xB8,8)).hex(),
                             'mutex_held':True})
            ret=state['core_return'];events.append({'kind':'stub_core','return':hex(ret)})
        elif a==0xA029C680:
            events.append({'kind':'copy','destination':hex(r[0]),'source':hex(r[1]),'bytes':r[2]})
            u.mem_write(r[0],bytes(u.mem_read(r[1],r[2])));ret=r[0]
        elif a==0xA04A22CC:events.append({'kind':'clean','address':hex(r[0]),'bytes':r[1]});ret=0
        elif a==0xA0308B8C:ret=0
        elif a==0xA02A70EC:events.append({'kind':'log_stub'});ret=0
        elif a in [0xA02BD9F0,0xA02BC3F8]:raise AssertionError('selector F reached independent command')
        if ret is not None:
            machine.reg_write(UC_ARM_REG_R0,ret&0xffffffff)
            machine.reg_write(UC_ARM_REG_PC,machine.reg_read(UC_ARM_REG_LR))
    u.hook_add(UC_HOOK_CODE,hook)
    u.reg_write(UC_ARM_REG_C1_C0_2,0xf<<20);u.reg_write(UC_ARM_REG_FPEXC,0x40000000)
    def run(entry):
        u.reg_write(UC_ARM_REG_SP,0x7000F000);u.reg_write(UC_ARM_REG_LR,0x70000000)
        u.reg_write(UC_ARM_REG_R0,MODE);u.reg_write(UC_ARM_REG_R1,P)
        u.emu_start(entry,0x70000000,count=20000)
        assert u.reg_read(UC_ARM_REG_PC)==0x70000000 and not state['locked']
        return u.reg_read(UC_ARM_REG_R0)
    producer_cases=[]
    for pipe,algo,func,theta,ret in [(0,0,0,0.,0),(0,0,0,1.25,0),(0,0,0,0.,0xffffffff),
                                     (0,0,0,0.,1),(1,1,0,0.,0),(1,2,2,0.,0)]:
        u.mem_write(C,bytes(0xD7668));u.mem_write(P,bytes(0x200))
        u.mem_write(MODE,bytes([pipe,algo,func,0])+bytes(12))
        for off,val in [(0x48,1920),(0x4C,1080),(0x6C,1920),(0x70,1080),(0x84,1920),(0x88,1080)]:put(P+off,val)
        u.mem_write(P+0xB8,struct.pack('<d',theta))
        statusbase=C+(0x56378 if pipe==0 else 0x772D8)
        put(statusbase,0xA5A5A5A5);put(statusbase+4,0xB6B6B6B6)
        events.clear();state.update(pipe=pipe,core_return=ret,pattern=bytes((n*17+pipe)&255 for n in range(0x3000)),locked=False)
        actual=run(0xA03119A8);assert actual==ret
        copies=[e for e in events if e['kind']=='copy']
        if ret==0:
            assert len(copies)==1 and copies[0]['bytes']==0xC0
            assert (get(statusbase),get(statusbase+4))==(1,7)
            assert events[-1]['kind']=='unlock'
        else:
            assert not copies and (get(statusbase),get(statusbase+4))==(0xA5A5A5A5,0xB6B6B6B6)
        producer_cases.append({'pipe':pipe,'algo':algo,'func':func,'theta':theta,'core_return':hex(ret),
                               'actual_return':hex(actual),'events':list(events)})
    ring_cases=[]
    for current in range(6):
        for lag in range(6):
            state.update(pipe=0,locked=False)
            u.mem_write(MODE,bytes(16));put(MODE+4,15);put(C+0x38,6)
            u.mem_write(C+0x56392,bytes([current]));u.mem_write(C+0x4088A,bytes([lag]))
            for slot in range(6):put(C+0xD764C+slot*4,C+0x100000+slot*0x14000)
            pattern=bytes((n*29+current*7+lag)&255 for n in range(0x3000));u.mem_write(C+0x47600,pattern)
            events.clear();assert run(0xA0312460)==0
            slot=(current-lag)%6;bank=C+0x100000+slot*0x14000
            x,y=bank+0xD060,bank+0xE860
            assert bytes(u.mem_read(x,0x1800))+bytes(u.mem_read(y,0x1800))==pattern
            assert (get(C+0x4110C),get(C+0x41110))==(x,y)
            ops=[e for e in events if e['kind'] in ['copy','clean']]
            assert [e['kind'] for e in ops]==['copy','copy','clean','clean']
            assert [e.get('bytes') for e in ops]==[0x1800]*4
            assert [e['address'] for e in ops[2:]]==[hex(x),hex(y)]
            ring_cases.append({'current':current,'lag':lag,'count':6,'slot':slot,'x':hex(x),'y':hex(y),'ops':ops})
    return {'producer_cases':producer_cases,'producer_vectors':captures,'ring_cases':ring_cases,
            'declared_stubs':['context and mutex lookup return synthetic owned memory','mutex calls logged; no synchronization model',
                              'A032CF38 replaced by deterministic two-plane writer/status result; warp arithmetic NOT executed',
                              'memcpy performs logical synthetic copy; original helper NOT executed',
                              'cache clean logged only','still work buffer lookup synthetic','diagnostics suppressed',
                              'A0308B8C fixed zero; alternate descriptor-clean branch static only'],
            'proof_scope':'real original A03119A8/A0312460 envelopes, branches and arguments with the declared substitutes only'}


def main():
    data=IMAGE.read_bytes();assert sha(data)==SHA256
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    checks=[]
    for p,expected in CHECKS.items():
        ins=next(md.disasm(data[p-BASE:p-BASE+4],p));actual=f'{ins.mnemonic} {ins.op_str}'
        assert actual==expected,(hex(p),actual,expected)
        checks.append({'address':hex(p),'instruction':actual})
    edges=[]
    calls=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis/full/calls.tsv'
    for line in calls.read_text().splitlines():
        cols=line.split('\t')
        if len(cols)==4 and cols[2] in ['0xa032cf38','0xa03119a8'] and cols[3]=='UNCONDITIONAL_CALL':
            owner,site,target=map(lambda x:int(x,16),cols[:3])
            ins=next(md.disasm(data[site-BASE:site-BASE+4],site))
            assert ins.mnemonic=='bl' and ins.op_str==f'#{target:#x}'
            edges.append({'owner':hex(owner),'site':hex(site),'target':hex(target)})
    assert len([e for e in edges if e['target']=='0xa032cf38'])==1
    assert len([e for e in edges if e['target']=='0xa03119a8'])==8
    OUT.mkdir(parents=True,exist_ok=True)
    for name,(s,e) in CPU_WINDOWS.items():
        (OUT/f'{name}.asm').write_text('\n'.join(f'{i.address:08x}: {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(data[s-BASE:e-BASE],s))+'\n')
    dsp,ref=DSP.read_bytes(),REF.read_bytes();assert sha(dsp)==DSP_SHA and sha(ref)==REF_SHA
    m=inventory(dsp)[0];begin=int(m['offset'],16);orc=dsp[begin:begin+m['bytes']];dec=CoreDecoder(ref.decode())
    def w(p):return struct.unpack_from('<I',orc,p)[0]
    for p,expected in ORC_CHECKS.items():assert dec.decode(w(p),p)==expected,(hex(p),dec.decode(w(p),p))
    strings=[]
    for off,hi,lo,expected in [(0x2BA3C9,0x187A3C,0x187A40,'copied controlregs image'),(0x2BBF33,0x18B78C,0x18B790,'debug_dump_shadow')]:
        assert ((w(hi)&65535)<<16 | w(lo)&65535)==off+0x600000
        value=orc[off:orc.index(0,off)].decode();assert expected in value
        strings.append({'offset':hex(off),'text':value})
    for name,s,e in [('shadow-class',0x18A428,0x18A608),('shadow-address',0x18A608,0x18A658),('shadow-copy-config',0x187A34,0x187A6C)]:
        (OUT/f'{name}.asm').write_text('\n'.join(f'{p:08x}: {w(p):08x} {dec.decode(w(p),p) or ".word (unsupported encoding)"}' for p in range(s,e,4))+'\n')
    emu=emulate(data)
    result={'cpu_sha256':sha(data),'dsp_sha256':sha(dsp),'reference_sha256':sha(ref),
            'cpu_instruction_checks':checks,'orc_instruction_checks':len(ORC_CHECKS),'diagnostics':strings,
            'retained_call_graph_edges':edges,'calls_tsv_sha256':sha(calls.read_bytes()),
            'execution':emu,
            'candidate_boundary':{'site':'A0311D8C call, returning at A0311D90 while stock context mutex remains held',
                'inputs':'r0 mode object; r1 five-word vector; r2 four-word status/descriptor vector',
                'video_scratch':'context+47600, plane stride1800, following SetWarp copies3000 total',
                'preserve':['same original scratch address','original mode, geometry and descriptor layout','original status/index/return','stock SetWarp ring selection, copies, cleans and status publication'],
                'mutation_candidates':['one scalar in invocation-local calc info with stock core still called','one bounded plane after stock core returns successfully, before original caller unlocks'],
                'not_deployment_authorization':'no wrapper or patch generated; format, runtime budgets, loader and recovery remain separate'},
            'shadow_selector_correction':'18B448(0,24) selects filter24/controlregs shadow; not established as command opcode24 or actual hardware submit',
            'not_proven':['full generator write bounds for every profile','DSP final read or DMA completion','runtime lock contention/realtime budget','MP4 frame identity','unknown A039C140 callers profiles','exclusive runtime EIS context identity'],
            'device_access':False}
    (OUT/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'cpu_checks':len(checks),'orc_checks':len(ORC_CHECKS),'producer_cases':len(emu['producer_cases']),
                      'ring_cases':len(emu['ring_cases']),'calls':len(edges),'output':str(OUT),'device_access':False}))

if __name__=='__main__':main()
