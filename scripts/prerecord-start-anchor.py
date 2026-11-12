#!/usr/bin/env python3
"""Offline audit of DSP event 0x13 -> audio gate linkage; no camera access."""
import hashlib
import json
from pathlib import Path

import capstone
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT=Path(__file__).resolve().parents[1]
BASE=0xA0100000
IMAGE=Path('artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin')
EXPORT=Path('artifacts/device/2026-11-09-linux/rtos-analysis/full')
EXPECTED='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
SP=0x1001F000


def sha(b):return hashlib.sha256(b).hexdigest()


def read(m,a,n=4):return int.from_bytes(m.mem_read(a,n),'little')


def write(m,a,v,n=4):m.mem_write(a,v.to_bytes(n,'little'))


def machine(b):
    m=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    m.mem_map(BASE,(len(b)+4095)&~4095)
    m.mem_write(BASE,b)
    m.mem_map(0x10000000,0x20000)
    m.mem_map(0xA1456000,0x3000)
    m.mem_map(0xA14BD000,0x1000)
    m.mem_map(0xA19C7000,0x1000)
    m.reg_write(UC_ARM_REG_SP,SP)
    return m


def run(m,start,stop):
    m.emu_start(start,stop,count=100000)
    assert m.reg_read(UC_ARM_REG_PC)==stop


def main():
    b=(ROOT/IMAGE).read_bytes();assert sha(b)==EXPECTED
    functions={f['entry']:f for f in json.loads((ROOT/EXPORT/'functions.json').read_text())}
    sources=[]
    for address in [0xA046F4A8,0xA046E6FC,0xA045FD38,0xA045D7B8,0xA045DA98,0xA045ECD0,0xA02C78D8,0xA02D296C,0xA02D3648,0xA02B38B4,0xA02C1358]:
        f=functions[hex(address)];body=b''
        for interval in f['body_ranges']:
            lo,hi=[int(x,16) for x in interval.split('-')];body+=b[lo-BASE:hi-BASE+1]
        path=EXPORT/f['decompiled_file']
        sources.append({'entry':hex(address),'body_ranges':f['body_ranges'],'body_sha256':sha(body),'pseudocode_path':str(path),'pseudocode_sha256':sha((ROOT/path).read_bytes())})
    results=[]
    # Stop before event dispatcher; test the original pending-counter decision.
    for pending,counter,mode in [(100,100,0),(100,101,0),(100,99,0),(0,101,0),(100,101,2),(103,104,0)]:
        m=machine(b)
        write(m,0xA14BDB5C,pending)
        write(m,0xA1456ABC,counter)
        write(m,0xA1458498,mode,1)
        due=pending!=0 and pending<counter
        stop=0xA02C7944 if due else 0xA02C7948
        run(m,0xA02C78D8,stop)
        assert read(m,0xA14BDB5C)==(0 if due else pending)
        event=None
        if due:
            assert m.reg_read(UC_ARM_REG_R0)==(0x20 if mode==2 else 0x13)
            event=m.reg_read(UC_ARM_REG_R1)
            assert read(m,event)==0 and read(m,event+4)==0
        results.append({'name':'pending_event_prefix','pending':pending,'current_counter':counter,'mode':mode,'stop_before':hex(stop),'event_due':due,'event_id':m.reg_read(UC_ARM_REG_R0) if due else None,'event_payload_words':[read(m,event),read(m,event+4)] if due else None,'passed':True})

    # Start after mutex release; event handler does not consume a timestamp.
    for stream,event_stream in [(0,0),(0,1),(1,0),(1,1)]:
        m=machine(b);event=0x10000000;pipeline=0x10004000
        write(m,event+4,event_stream)
        for reg,val in [(UC_ARM_REG_SB,event),(UC_ARM_REG_R5,stream),(UC_ARM_REG_R6,1),(UC_ARM_REG_R8,pipeline)]:m.reg_write(reg,val)
        matches=stream==0 and event_stream==0
        stop=0xA046E77C if matches else 0xA046E768
        run(m,0xA046E744,stop)
        if matches:assert m.reg_read(UC_ARM_REG_R0)==pipeline
        results.append({'name':'video_event_filter_suffix','video_stream':stream,'event_stream':event_stream,'calls_audio_gate_lookup':matches,'stop_before':hex(stop),'passed':True})

    # Search audio instances by the pipeline identifier, stop before gate helper.
    for matching_slot in (0,3,None):
        m=machine(b);pipeline=0x10004000
        for idx in range(8):
            ctx=0xA19C7250+idx*0xF0
            write(m,ctx+8,1,1)
            write(m,ctx+0x14,pipeline if idx==matching_slot else 0x10005000+idx*4)
        m.reg_write(UC_ARM_REG_R4,0xA19C71A8)
        m.reg_write(UC_ARM_REG_R5,pipeline)
        stop=0xA045FDB8 if matching_slot is not None else 0xA045FD9C
        run(m,0xA045FD70,stop)
        if matching_slot is not None:
            ctx=0xA19C7250+matching_slot*0xF0
            assert m.reg_read(UC_ARM_REG_R0)==ctx+10 and m.reg_read(UC_ARM_REG_R1)==ctx+12
        results.append({'name':'audio_pipeline_lookup_suffix','matching_slot':matching_slot,'stop_before':hex(stop),'calls_source_gate_helper':matching_slot is not None,'passed':True})

    # The pinned build bypasses the apparent optional wait block unconditionally.
    m=machine(b);run(m,0xA045DB78,0xA045DB98)
    assert m.reg_read(UC_ARM_REG_R3)==0
    results.append({'name':'record_optional_wait_block_bypassed','entry':'0xa045db78','stop_before':'0xa045db98','r3':0,'passed':True})

    c=capstone.Cs(capstone.CS_ARCH_ARM,capstone.CS_MODE_ARM)
    windows=[]
    for lo,hi in [(0xA046F4A8,0xA046F4D0),(0xA046E744,0xA046E780),(0xA045FD70,0xA045FDC4),(0xA045DB78,0xA045DBC0),(0xA02C790C,0xA02C7948),(0xA02D2DC8,0xA02D2DF0),(0xA045F0CC,0xA045F0E4)]:
        windows.append({'start':hex(lo),'stop_exclusive':hex(hi),'sha256':sha(b[lo-BASE:hi-BASE]),'instructions':[{'address':hex(i.address),'bytes':bytes(i.bytes).hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in c.disasm(b[lo-BASE:hi-BASE],lo)]})
    expected=[(0xA046F4C4,'mov','r0, #0x13'),(0xA046F4CC,'bl','#0xa02c11b0'),(0xA046E77C,'bl','#0xa045fd38'),(0xA045FDB8,'bl','#0xa045d7b8'),(0xA045DB78,'movw','r3, #0'),(0xA045DB7C,'movt','r3, #0'),(0xA045DB84,'beq','#0xa045db98'),(0xA045DB8C,'nop',''),(0xA045DBB8,'bl','#0xa045d7b8'),(0xA02D2DE8,'addhi','r3, r3, #3'),(0xA02D2DEC,'str','r3, [r1, r7, lsl #2]')]
    for addr,mnemonic,operands in expected:
        i=next(c.disasm(b[addr-BASE:addr-BASE+4],addr));assert(i.mnemonic,i.op_str)==(mnemonic,operands)
    report={'image':str(IMAGE),'image_sha256':EXPECTED,'scope':'Offline existing decompilation and bounded original instruction prefixes/suffixes in synthetic RAM. Stops before lock, dispatcher or gate calls; no firmware/device writes, RTOS or callbacks executed.','sources':sources,'instruction_windows':windows,'snippet_cases_passed':len(results),'instruction_assertions_passed':len(expected),'results':results,'findings':['A DSP event 0x13 callback reaches audio source-gate opening by shared pipeline identifier; this is an actual cross-module hook.','Pending events are emitted when nonzero pending counter < current command/message-service counter; event payload is two indices without a timestamp.','The pinned audio record-start bytecode unconditionally bypasses the optional block and calls source-gate open directly, so the later DSP hook cannot be assumed to define first accepted audio samples.','Current pending-event counter is not proven to be sensor frame count or hardware clock.'],'limits':['No common A/V capture timestamp, first-sample correspondence, gate/DMA boundary or physical synchronization proved.','Pending writer current/+3 branch retained as static original instructions, not whole DSP start execution.','Audio-instance lookup tests stop at the first match; the full helper can continue scanning additional matching instances.']}
    output=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-start-anchor-audit.json'
    output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'output':str(output),'snippet_cases_passed':len(results),'instruction_assertions_passed':len(expected)}))

if __name__=='__main__':main()
