#!/usr/bin/env python3
"""Offline original-byte EIS generator execution with synthetic owned data.

A032CF38/A032B520/A032A4B8/math/memset execute original pinned code.
No timing model, device access, firmware patch, wrapper or payload.
"""
from __future__ import annotations
import collections
import json
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *
from analyze_eis_warp_publication import ROOT,IMAGE,SHA256,BASE
from audit_eis_orc_core import sha
OUT=ROOT/'artifacts/device/2026-11-10-eis-generator-scope'
CHECKS={
0xA039C144:'movw r1, #0x20d0',0xA039C154:'movt r1, #0xa060',
0xA039C160:'bl #0xa02a70ec',0xA039C4B8:'bl #0xa03119a8',0xA039CC70:'bl #0xa03119a8',
0xA0394718:'vmov.f64 d0, d16',0xA0394730:'beq #0xa03948b8',
0xA02DA314:'add r3, ip, #0x110',0xA02DA318:'ldrd r2, r3, [r3]',0xA02DA324:'strd r2, r3, [sp, #0xc8]',
0xA03855D4:'ldr r3, [r3]',0xA03855E8:'cmp r2, r3',
0xA0394740:'bl #0xa02da164',0xA0394960:'bl #0xa02da164',
0xA0385570:'bl #0xa0392cb0',0xA0385574:'bl #0xa048e3f8',
0xA03855C4:'bl #0xa048e3f8',0xA0385614:'bl #0xa02a70ec',
0xA02D9BA4:'vmov.f64 d8, d0',0xA02D9BC0:'bl #0xa03bc46c',
0xA02D9BD0:'vstr d8, [r3, #0x110]',0xA02D9BD4:'add r2, r2, #1',
0xA02D9BD8:'str r2, [r3, #0x34]',0xA02D9BDC:'bl #0xa03bc498',
0xA032D2D8:'bl #0xa032b520',0xA032D0E4:'str r3, [r5]',
}
WINDOWS={
'ituner-entry':(0xA039C140,0xA039C184),'ituner-first-calc':(0xA039C3D0,0xA039C4C4),
'ituner-second-calc':(0xA039CC48,0xA039CC94),'theta-update':(0xA02D9B88,0xA02D9C04),
'eis-frame-deadline':(0xA0385570,0xA0385618),'eis-production-first':(0xA0394700,0xA0394768),
'eis-production-second':(0xA0394940,0xA0394988),
}
FUNCTION_ENTRIES={0xA032CF38:'core',0xA032B520:'video_generator',0xA032A4B8:'calibration_interpolate',
0xA029C680:'copy_wrapper',0xA04F8DEC:'thumb_memset',0xA0506F38:'divide64',0xA0315EFC:'phase_select',0xA0316174:'phase_update'}


def intervals(mask):
    out=[];start=None
    for n,used in enumerate(list(mask)+[False]):
        if used and start is None:start=n
        if not used and start is not None:out.append([start,n]);start=None
    return out


def machine(data):
    u=Uc(UC_ARCH_ARM,UC_MODE_ARM);u.mem_map(BASE,(len(data)+4095)&~4095);u.mem_write(BASE,data)
    u.mem_map(0xA1400000,0x200000);u.mem_map(0x30000000,0x100000);u.mem_map(0x70000000,0x10000)
    u.reg_write(UC_ARM_REG_C1_C0_2,0xf<<20);u.reg_write(UC_ARM_REG_FPEXC,0x40000000)
    return u


def generator_case(data,case):
    u=machine(data)
    P,S,D,V,MODE,RES,G,GRID=0x30000000,0x30010000,0x30030000,0x30040000,0x30041000,0x30042000,0x30043000,0x30050000
    def put(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
    width,height=case['geometry'];calib=case.get('calibration',False)
    put(0xA14C1F44,0xA029C680);put(0xA14C1F48,0xA04F8DED)
    # Logger points to a trap address; no tested case is allowed to call it.
    put(0xA14C1F60,0x70000010)
    for off,val in [(0x48,width),(0x4C,height),(0x64,width),(0x68,height),(0x6C,width),(0x70,height),
                    (0x7C,width<<16),(0x80,height<<16),(0x84,width),(0x88,height)]:put(P+off,val)
    put(P+4,case.get('control',0))
    if case.get('raw_vertical_enable'):
        put(P+0xB0,1);put(P+0x78,8<<16)
    if calib:
        for off,val in [(0,1),(8,0x20140701),(0xC,4),(0x10,4),(0x14,11),(0x18,11),
                        (0x24,width),(0x28,height),(0x2C,0x01010101),(0x3C,GRID),(0x50,0x01010101)]:put(P+off,val)
        grid=[]
        for row in range(4):
            for col in range(4):
                grid.append((16+row*7+col*3,-32+row*5-col*9) if case.get('affine_grid') else (16,-32))
        u.mem_write(GRID,b''.join(struct.pack('<hh',x,y) for x,y in grid))
    for n,val in enumerate([P,S,0,0,G]):put(V+4*n,val)
    for n,val in enumerate([0,D,0,D+0x100]):put(RES+4*n,val)
    u.mem_write(G+8,struct.pack('<H',128))
    # Dirty prior-generation padding is intentional, not silently zeroed.
    u.mem_write(S,bytes([0xA5])*0x10000)
    before_input=bytes(u.mem_read(P,0xC0));before_grid=bytes(u.mem_read(GRID,0x40))
    mask=bytearray(0x3000);outside=[];step=0;calls=collections.Counter();badwrites=[]
    def hook(machine,pc,size,user):
        nonlocal step
        step+=1
        if pc==0x70000010:raise AssertionError('unexpected diagnostic/error path')
        if pc in FUNCTION_ENTRIES:calls[FUNCTION_ENTRIES[pc]]+=1
    def write(machine,access,addr,size,value,user):
        if S<=addr<S+0x10000:
            if addr+size>S+0x3000:outside.append([addr-S,size])
            else:mask[addr-S:addr-S+size]=b'\1'*size
        elif not (D<=addr<D+0x200 or RES<=addr<RES+0x10 or G<=addr<G+0x100 or 0x70000000<=addr<0x70010000):
            badwrites.append([hex(addr),size])
    u.hook_add(UC_HOOK_CODE,hook);u.hook_add(UC_HOOK_MEM_WRITE,write)
    entry=0xA032B520 if case.get('lower_helper_only') else 0xA032CF38
    args=[(UC_ARM_REG_R0,0),(UC_ARM_REG_R1,P),(UC_ARM_REG_R2,S),(UC_ARM_REG_R3,D)] if case.get('lower_helper_only') else [(UC_ARM_REG_R0,MODE),(UC_ARM_REG_R1,V),(UC_ARM_REG_R2,RES)]
    for reg,val in args+[(UC_ARM_REG_SP,0x7000F000),(UC_ARM_REG_LR,0x70000000)]:u.reg_write(reg,val)
    u.emu_start(entry,0x70000000,count=1000000)
    assert u.reg_read(UC_ARM_REG_PC)==0x70000000 and u.reg_read(UC_ARM_REG_R0)==0
    assert not outside and not badwrites,(outside,badwrites)
    assert bytes(u.mem_read(P,0xC0))==before_input and bytes(u.mem_read(GRID,0x40))==before_grid
    output=bytes(u.mem_read(S,0x3000));desc=bytes(u.mem_read(D,0x50))
    assert bytes(u.mem_read(S+0x3000,0xD000))==bytes([0xA5])*0xD000
    for n in range(0x3000):
        if not mask[n]:assert output[n]==0xA5
    planes=[]
    for base,meta in [(0,0x30),(0x1800,0x35)]:
        cols,rows=desc[meta]+1,desc[meta+1]+1
        pitch=cols if width>0xA9C else 32
        plane_mask=mask[base:base+0x1800]
        expected=bytearray(0x1800)
        for row in range(rows):expected[row*pitch*2:row*pitch*2+cols*2]=b'\1'*(cols*2)
        active=[]
        for row in range(rows):
            for col in range(cols):active.append(struct.unpack_from('<h',output,base+(row*pitch+col)*2)[0])
        if calib and not case.get('control'):
            assert plane_mask==expected,(case,base,intervals(plane_mask),intervals(expected))
            if not case.get('affine_grid'):assert set(active)=={16 if base==0 else -32}
        planes.append({'offset':hex(base),'descriptor_bytes':list(desc[meta:meta+4]),
                       'observed_columns':cols,'observed_rows':rows,'profile_pitch_elements':pitch,
                       'active_rectangle_write_mask_verified':bool(calib and not case.get('control')), 
                       'bytes_written':sum(plane_mask),'write_intervals':intervals(plane_mask),
                       'active_value_min':min(active),'active_value_max':max(active),
                       'active_value_sha256':sha(b''.join(struct.pack('<h',x) for x in active))})
    (OUT/(case['name']+'.planes.bin')).write_bytes(output)
    (OUT/(case['name']+'.descriptor.bin')).write_bytes(desc)
    assert calls['core']==(0 if case.get('lower_helper_only') else 1) and calls['video_generator']==1
    if calib and not case.get('control'):assert calls['calibration_interpolate']==sum(p['observed_columns']*p['observed_rows'] for p in planes)
    return {'input':case,'entry':hex(entry),'return':0,'original_instruction_count':step,'original_entry_counts':dict(calls),
            'status_words':list(struct.unpack('<4I',bytes(u.mem_read(RES,16)))),
            'descriptor_hex':desc.hex(),'planes':planes,'scratch_plane_sha256':sha(output),
            'scratch_outside_planes_unchanged':True,'calc_info_unchanged':True,'grid_unchanged':True,
            'substituted_calls':[],'runtime_configuration':'synthetic function table: copy=A029C680, memset=A04F8DED; diagnostics trap unused'}


def theta_cases(data):
    results=[]
    for value,counter in [(0.,0),(0.01,7),(-0.125,0xffffffff),(1.25,20)]:
        u=machine(data);MODE,C=0x30000000,0x30010000;events=[]
        u.mem_write(MODE,struct.pack('<I',0x100));u.mem_write(C+0x34,struct.pack('<I',counter))
        bits=struct.unpack('<Q',struct.pack('<d',value))[0]
        def hook(machine,pc,size,user):
            if pc==0xA02D8248:
                p=machine.reg_read(UC_ARM_REG_R2);machine.mem_write(p,struct.pack('<I',C));ret=0;events.append('lookup_stub')
            elif pc in [0xA03BC46C,0xA03BC498]:ret=0;events.append('lock_stub' if pc==0xA03BC46C else 'unlock_stub')
            else:return
            machine.reg_write(UC_ARM_REG_R0,ret);machine.reg_write(UC_ARM_REG_PC,machine.reg_read(UC_ARM_REG_LR))
        u.hook_add(UC_HOOK_CODE,hook)
        u.reg_write(UC_ARM_REG_D0,bits);u.reg_write(UC_ARM_REG_R0,MODE)
        u.reg_write(UC_ARM_REG_SP,0x7000F000);u.reg_write(UC_ARM_REG_LR,0x70000000)
        u.emu_start(0xA02D9B88,0x70000000,count=200)
        assert bytes(u.mem_read(C+0x110,8))==struct.pack('<d',value)
        after=struct.unpack('<I',u.mem_read(C+0x34,4))[0];assert after==(counter+1)&0xffffffff
        results.append({'theta':value,'initial_parameter_counter':counter,'final_parameter_counter':after,
                        'double_bits_preserved':True,'events':events})
    return results


def main():
    data=IMAGE.read_bytes();assert sha(data)==SHA256
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM);checks=[]
    for p,expected in CHECKS.items():
        i=next(md.disasm(data[p-BASE:p-BASE+4],p));actual=f'{i.mnemonic} {i.op_str}'
        assert actual==expected,(hex(p),actual,expected);checks.append({'address':hex(p),'instruction':actual})
    OUT.mkdir(parents=True,exist_ok=True)
    for name,(s,e) in WINDOWS.items():
        (OUT/f'{name}.asm').write_text('\n'.join(f'{i.address:08x}: {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(data[s-BASE:e-BASE],s))+'\n')
    strings=[]
    for p,needle in [(0xA06020D0,'AmbaItuner_Execute'),(0xA06021C4,'[ITUNER][DEBUG]'),(0xA05FFDA4,'Eis-Warp calculation not in-time'),(0xA0601434,'EisAngleLimit')]:
        value=data[p-BASE:data.index(0,p-BASE)].decode();assert needle in value,(hex(p),value)
        strings.append({'address':hex(p),'text':value})
    cases=[{'name':'disabled-640','geometry':[640,480]}, {'name':'disabled-1080','geometry':[1920,1080]},
           *[{'name':f'constant-{w}x{h}','geometry':[w,h],'calibration':True} for w,h in [(640,480),(1280,720),(1920,1080),(3840,2160),(4096,2160)]],
           {'name':'affine-1080','geometry':[1920,1080],'calibration':True,'affine_grid':True},
           {'name':'control8-raw-y','geometry':[1920,1080],'control':8,'raw_vertical_enable':True,'lower_helper_only':True}]
    reports=[]
    for c in cases:
        reports.append(generator_case(data,c))
    for r in reports:print(json.dumps({'case':r['input']['name'],'instructions':r['original_instruction_count'],'writes':[p['bytes_written'] for p in r['planes']]}))
    report={'cpu_sha256':sha(data),'fixed_instruction_checks':checks,'diagnostic_strings':strings,
            'original_generator_cases':reports,'theta_update_cases':theta_cases(data),
            'function_fingerprints':{'A032CF38_032D8C0':sha(data[0xA032CF38-BASE:0xA032D8C0-BASE]),'A032B520_032C940':sha(data[0xA032B520-BASE:0xA032C940-BASE])},
            'proof_scope':'synthetic valid video inputs, original A032CF38 and reachable core/helper/library bytes; no generator or memset stub',
            'not_proven':['exhaustive profiles or calibration variants','theta-generated fake-grid branch with enabled rotation',
                          'physical warp units/Q interpretation','encoded frame identity','native CPU cycle cost or deadline margin','device loader, runtime cache or DSP behavior'],
            'device_access':False}
    (OUT/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'checks':len(checks),'generator_cases':len(reports),'theta_cases':len(report['theta_update_cases']),'output':str(OUT),'device_access':False}))

if __name__=='__main__':main()
