#!/usr/bin/env python3
"""Host-only pinned ARM DSP-bitstream -> video FrameDesc PTS audit.

No camera access, instruction patches, OS/helper stubs, or claim of capture sync.
"""
import argparse
import hashlib
import json
from pathlib import Path
import capstone
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
    UC_ARM_REG_R3, UC_ARM_REG_R6, UC_ARM_REG_R7, UC_ARM_REG_R8, UC_ARM_REG_SB,
    UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC)

ROOT=Path(__file__).resolve().parents[1]
IMAGE=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
EXPORT=IMAGE.parent/'full'
BASE=0xA0100000
DIGEST='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
RAM=0x10000000
STATE=RAM
RAW=RAM+0x1000
EVENT=RAM+0x2000
STACK=RAM+0x1f000
RETURN=RAM+0x10000
MASK=(1<<64)-1


def sha(data):return hashlib.sha256(data).hexdigest()
def put(m,addr,value,n=4):m.mem_write(addr,(value%(1<<(n*8))).to_bytes(n,'little'))
def get(m,addr,n=4):return int.from_bytes(m.mem_read(addr,n),'little')
def machine(image):
    m=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    m.mem_map(BASE,(len(image)+4095)&~4095);m.mem_write(BASE,image)
    m.mem_map(0xA1445000,0x1000)
    m.mem_map(RAM,0x20000);m.mem_map(0xA1458000,0x1000);m.mem_map(0xA19C9000,0x2000)
    m.reg_write(UC_ARM_REG_SP,STACK);m.reg_write(UC_ARM_REG_LR,RETURN)
    return m

def run(m,entry,stop):
    m.emu_start(entry,stop,count=100000)
    assert m.reg_read(UC_ARM_REG_PC)==stop,f'Unexpected PC {m.reg_read(UC_ARM_REG_PC):x}'

def expected(raw,prev,base,threshold,mode,kind):
    if abs(raw-prev)<=threshold:return (raw+base)&MASK,raw,base,'normal'
    if mode==1 or kind&7!=3:
        base=(base+(1<<32))&MASK
        return (raw+base)&MASK,raw,base,'c1'
    return (raw+base+(1<<32))&MASK,prev,base,'c0'


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'artifacts/device/2026-11-10-prerecord/video-producer-audit.json')
    args=parser.parse_args();image=IMAGE.read_bytes();assert sha(image)==DIGEST
    functions={f['entry']:f for f in json.loads((EXPORT/'functions.json').read_text())}
    sources=[]
    for address in [0xA02C7660,0xA02CA5A0,0xA02CB7C8,0xA0460754,0xA04A3BD4]:
        f=functions[hex(address)];body=b''
        for span in f['body_ranges']:
            a,b=[int(v,16) for v in span.split('-')];body+=image[a-BASE:b-BASE+1]
        path=EXPORT/f['decompiled_file']
        sources.append({'entry':hex(address),'body_ranges_inclusive':f['body_ranges'],
            'body_sha256':sha(body),'pseudocode':str(path.relative_to(ROOT)),'pseudocode_sha256':sha(path.read_bytes())})
    # This callback was not made a function in the retained Ghidra export.
    sources.append({'entry':'0xa046ca94','kind':'raw ARM callback window; not an indexed Ghidra function',
        'range_inclusive':'a046ca94-a046cd9f','sha256':sha(image[0xA046CA94-BASE:0xA046CDA0-BASE])})
    initialization=[]
    secondary_base=int.from_bytes(image[0xA02CB804-BASE:0xA02CB808-BASE],'little')
    for channel,stream,mode in [(0,0,0),(1,0,1),(0,1,2),(1,1,0)]:
        m=machine(image)
        m.reg_write(UC_ARM_REG_R0,channel);m.reg_write(UC_ARM_REG_R1,stream);m.reg_write(UC_ARM_REG_R2,mode)
        target=(0xA1458478 if stream==0 else secondary_base)+channel*0x78
        put(m,target+0x10,0x123456789,8);put(m,target+0x18,0xabcdef0123,8)
        run(m,0xA02CB7C8,RETURN)
        assert get(m,target+8)==mode and get(m,target+0xc)==0xffff0000
        assert get(m,target+0x10,8)==0x123456789 and get(m,target+0x18,8)==0xabcdef0123
        initialization.append({'channel':channel,'stream_argument':stream,'mode':mode,'target':hex(target),
            'threshold':get(m,target+0xc),'base_previous_retained':True,'passed':True})
    cases=[
        ('ordinary',1001,0,0,0xffff0000,0,1),
        ('backwards_within_threshold',900,1000,7000,100,0,3),
        ('threshold_equal',1100,1000,0,100,0,1),
        ('threshold_plus_one',1101,1000,0,100,0,1),
        ('u32_wrap',0x100,0xffffff00,0,0xffff0000,0,1),
        ('u32_wrap_c0',0x100,0xffffff00,0,0xffff0000,0,3),
        ('u32_wrap_mode1_overrides_c0',0x100,0xffffff00,0,0xffff0000,1,3),
        ('raw_above_u32',0x100001000,0x100000000,0x100000000,0xffff0000,0,1),
        ('base_low_carry',0xfffffff0,0,0xfffffff0,1,0,1),
        ('base_wrap_u64',0x100,0xffffff00,0xffffffff00000000,0xffff0000,0,1),
        ('c0_flags_masked',1,0xffffffff,0x12345678,0xffff0000,0,0x83),
    ]
    results=[]
    for name,raw,prev,base,threshold,mode,kind in cases:
        m=machine(image);put(m,STATE+8,mode);put(m,STATE+0xc,threshold)
        put(m,STATE+0x10,base,8);put(m,STATE+0x18,prev,8)
        put(m,RAW+8,raw,8);put(m,RAW+0x14,kind,1)
        m.reg_write(UC_ARM_REG_R0,STATE);m.reg_write(UC_ARM_REG_R1,RAW)
        output,next_prev,next_base,branch=expected(raw,prev,base,threshold,mode,kind)
        stop={'normal':RETURN,'c1':0xA02C76F0,'c0':0xA02C7764}[branch]
        run(m,0xA02C7660,stop)
        actual=(m.reg_read(UC_ARM_REG_R0)|(m.reg_read(UC_ARM_REG_R1)<<32)) if branch=='normal' else (m.reg_read(UC_ARM_REG_R6)|(m.reg_read(UC_ARM_REG_R7)<<32))
        assert actual==output,(name,hex(actual),hex(output))
        assert get(m,STATE+0x10,8)==next_base
        assert get(m,STATE+0x18,8)==(next_prev if branch=='normal' else prev)
        # c1 updates previous only after printf; do not execute or stub logging.
        if branch=='c1':
            run(m,0xA02C76F4,RETURN)
            assert get(m,STATE+0x18,8)==next_prev
            assert m.reg_read(UC_ARM_REG_R0)|(m.reg_read(UC_ARM_REG_R1)<<32)==output
        results.append({'name':name,'input':{'raw':raw,'previous':prev,'base':base,'threshold':threshold,'mode':mode,'kind':kind},
            'branch':branch,'corrected':actual,'next_base':next_base,'next_previous':next_prev,
            'execution':'full function' if branch=='normal' else 'prefix stopping before printf; c1 post-log suffix run separately; no printf stub',
            'stop':hex(stop),'passed':True})
    # c0 leaves previous/base untouched; next ordinary raw is corrected under the old base.
    m=machine(image);put(m,STATE+0xc,0xffff0000);put(m,STATE+0x18,0xfffffff0,8)
    put(m,RAW+8,0x100,8);put(m,RAW+0x14,3,1)
    m.reg_write(UC_ARM_REG_R0,STATE);m.reg_write(UC_ARM_REG_R1,RAW)
    run(m,0xA02C7660,0xA02C7764)
    transient=m.reg_read(UC_ARM_REG_R6)|(m.reg_read(UC_ARM_REG_R7)<<32)
    m.reg_write(UC_ARM_REG_SP,STACK);m.reg_write(UC_ARM_REG_LR,RETURN)
    put(m,RAW+8,0x100000020,8);put(m,RAW+0x14,1,1)
    m.reg_write(UC_ARM_REG_R0,STATE);m.reg_write(UC_ARM_REG_R1,RAW)
    run(m,0xA02C7660,RETURN)
    assert get(m,STATE+0x10,8)==0 and get(m,STATE+0x18,8)==0x100000020
    results.append({'name':'c0_followed_by_normal','first_transient':transient,'second_output':m.reg_read(UC_ARM_REG_R0)|(m.reg_read(UC_ARM_REG_R1)<<32),'base_retained':0,'passed':True})
    # Real ring adapter prefix, real address translation helper, stop before event dispatch.
    for index,size,raw,prev,base in [(0,4096,1001,0,0),(1023,9000,0x123,0x100,1<<32),(1,0xffffffff,0x100000321,0,1<<32)]:
        m=machine(image);ring=0xA06890E0;cursor=0xA1458568;record=ring+index*0x40
        put(m,cursor,index);put(m,STATE+0xc,0xffff0000);put(m,STATE+0x18,prev,8);put(m,STATE+0x10,base,8)
        put(m,record,1,1);put(m,record+1,0x11,1);put(m,record+4,0x12345678)
        put(m,record+8,raw,8);put(m,record+0x10,0x20000100)
        put(m,record+0x14,0x83,1);put(m,record+0x18,size)
        put(m,record+0x24,3840,2);put(m,record+0x26,2160,2);put(m,record+0x28,0x87654321)
        m.reg_write(UC_ARM_REG_R7,ring);m.reg_write(UC_ARM_REG_SB,cursor);m.reg_write(UC_ARM_REG_R8,STATE)
        run(m,0xA02CA950,0xA02CA9F8)
        event=m.reg_read(UC_ARM_REG_R1)
        assert event==STACK+0x20 and m.reg_read(UC_ARM_REG_R0)==4
        assert get(m,cursor)==(index+1)%1024
        assert get(m,event)==1 and get(m,event+4)==0 and get(m,event+8)==0x12345678
        converted=raw if size==0xffffffff else (raw+base)&MASK
        assert get(m,event+0x10,8)==converted and get(m,event+0x1c)==3 and get(m,event+0x20)==1
        assert get(m,event+0x24)==size
        evt=bytes(m.mem_read(event,0x30));translated=get(m,event+0x18)
        # Normal callback path forwards the converted PTS, type and payload without another clock conversion.
        if size!=0xffffffff:
            m.mem_write(EVENT,evt);m.reg_write(UC_ARM_REG_SP,STACK)
            m.reg_write(UC_ARM_REG_R0,0);m.reg_write(UC_ARM_REG_R1,0x1f);m.reg_write(UC_ARM_REG_R2,EVENT)
            run(m,0xA046CA94,0xA046CB7C)
            desc=m.reg_read(UC_ARM_REG_R1)
            assert get(m,desc)==0x12345678 and get(m,desc+8,8)==converted
            assert get(m,desc+0x10,1)==3 and get(m,desc+0x11,1)==1
            assert get(m,desc+0x14)==translated and get(m,desc+0x18)==size
        results.append({'name':f'dsp_ring_{index}_size_{size}','ring_stride':64,'next_index':get(m,cursor),
            'raw_pts':raw,'event_pts':converted,'base':base,
            'sequence':0x12345678,'type':3,'flags':1,'translated_payload_address':translated,
            'event_hex':evt.hex(),'callback_executed':size!=0xffffffff,
            'execution':'original ring-to-event prefix through real translation helper; ordinary-size event then original callback to before FIFO write',
            'passed':True})
    md=capstone.Cs(capstone.CS_ARCH_ARM,capstone.CS_MODE_ARM)
    windows=[]
    for a,b in [(0xA02C7660,0xA02C776C),(0xA02CA950,0xA02CA9FC),(0xA046CAE4,0xA046CB80)]:
        windows.append({'start':hex(a),'end_exclusive':hex(b),'sha256':sha(image[a-BASE:b-BASE]),
            'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in md.disasm(image[a-BASE:b-BASE],a)]})
    report={'scope':'offline pinned ARM execution with synthetic RAM only; no device access',
        'image':str(IMAGE.relative_to(ROOT)),'sha256':DIGEST,
        'functions_index_sha256':sha((EXPORT/'functions.json').read_bytes()),
        'harness_sha256':sha(Path(__file__).read_bytes()),
        'synthetic_extra_pages':['A1445000 translation runtime pointer state (zero)','A1458000 DSP cursor and PTS state','A19C9000 callback statistics'],
        'sources':sources,'windows':windows,
        'initialization':initialization,'cases':results,'passed':len(results)+len(initialization),'failed':0,
        'limits':['DSP firmware raw PTS generation/clock and A/V common epoch remain unknown',
            'No DSP hardware, actual FIFO/mux call, RTOS synchronization or original video payload executed',
            'c0/c1 printf is not executed or stubbed: prefixes and c1 suffix are separate instruction windows',
            'Test values including overflow are synthetic arithmetic cases, not supported camera configurations',
            '0xffffffff raw DSP payload sentinel and 0x00ffffff higher-level sentinel must not be conflated',
            'No standalone 60s prerecord, camera trigger or native execution entry implemented']}
    args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'passed':len(results)+len(initialization),'output':str(args.output)}))

if __name__=='__main__':main()
