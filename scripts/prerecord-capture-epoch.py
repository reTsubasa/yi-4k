#!/usr/bin/env python3
"""Bounded host-only audio capture/DMA/gate audit; never contacts a camera."""
import hashlib
import json
from pathlib import Path

import capstone
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE = Path('artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin')
EXPORT = Path('artifacts/device/2026-11-09-linux/rtos-analysis/full')
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'


def sha(b):
    return hashlib.sha256(b).hexdigest()


def read(m,a,n=4):
    return int.from_bytes(m.mem_read(a,n),'little')


def write(m,a,v,n=4):
    m.mem_write(a,v.to_bytes(n,'little'))


def machine(b):
    m=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    m.mem_map(BASE,(len(b)+4095)&~4095)
    m.mem_write(BASE,b)
    m.mem_map(0x10000000,0x20000)
    m.reg_write(UC_ARM_REG_SP,0x1001f000)
    m.reg_write(UC_ARM_REG_LR,0x10010000)
    return m


def run(m,start,stop):
    m.emu_start(start,stop,count=100000)
    assert m.reg_read(UC_ARM_REG_PC)==stop


def main():
    b=(ROOT/IMAGE).read_bytes()
    assert sha(b)==EXPECTED
    catalog=json.loads((ROOT/EXPORT/'functions.json').read_text())
    functions={f['entry']:f for f in catalog}
    entries=[0xA045D264,0xA0291C5C,0xA0291430,0xA0291498,0xA02914B4,0xA02915F4,0xA0291758,0xA029262C,0xA0292304,0xA02921C8,0xA02941F4,0xA02943C0,0xA0294078,0xA029351C,0xA0293440,0xA0293204,0xA0293FB0,0xA02902B4]
    sources=[]
    for addr in entries:
        f=functions[hex(addr)]
        body=b''
        for s in f['body_ranges']:
            lo,hi=[int(x,16) for x in s.split('-')]
            body+=b[lo-BASE:hi-BASE+1]
        path=EXPORT/f['decompiled_file']
        sources.append({'entry':hex(addr),'body_ranges':f['body_ranges'],'body_sha256':sha(body),'pseudocode_path':str(path),'pseudocode_sha256':sha((ROOT/path).read_bytes())})

    results=[]
    # Start after semaphore wait/status active check; stop before return epilogue.
    for name,statuses in [('not_completed',[0,0,0]),('one_completed',[0x08000000,0,0]),('two_completed',[0x08000000,0x08000000,0]),('one_terminal',[0x18000000,0,0])]:
        m=machine(b)
        ctrl,cfg,status,out=0x10000000,0x10001000,0x10002000,0x10003000
        for off,val in [(4,3),(8,0),(12,1)]:write(m,ctrl+off,val)
        write(m,cfg+0x14,status)
        for idx,val in enumerate(statuses):write(m,status+4*idx,val)
        for reg,val in [(UC_ARM_REG_R4,ctrl),(UC_ARM_REG_R7,cfg),(UC_ARM_REG_R8,out),(UC_ARM_REG_R5,0)]:m.reg_write(reg,val)
        stop = 0xA0291544 if name=='not_completed' else 0xA02914EC
        run(m,0xA02914F4,stop)
        expected=sum(bool(x&0x08000000) for x in statuses)
        assert m.reg_read(UC_ARM_REG_R5)==expected
        assert read(m,ctrl+8)==expected
        assert read(m,out)==int(name=='one_terminal')
        for idx in range(expected):assert read(m,status+idx*4)==0
        results.append({'name':name,'entry':'0xa02914f4','stop_before':hex(stop),'status_words_before':statuses,'completed_count':expected,'ring_index_after':read(m,ctrl+8),'terminal':read(m,out),'passed':True})

    # Entry after successful mutex release; tests the real source-open branch only.
    for flag,stop in [(0,0xA029424C),(1,0xA0294250),(2,0xA029424C)]:
        m=machine(b)
        m.reg_write(UC_ARM_REG_R0,0)
        m.reg_write(UC_ARM_REG_R4,flag)
        run(m,0xA0294230,stop)
        if flag!=1:assert m.reg_read(UC_ARM_REG_R0)==0
        results.append({'name':'source_gate_suffix','entry':'0xa0294230','stop_before':hex(stop),'source_open_flag':flag,'accepts_payload_path':flag==1,'passed':True})

    # Stop/rearm marker is a DMA descriptor control flag, not a capture timestamp.
    for index in (0,3):
        for direction in (0,1):
            m=machine(b)
            cfg,desc=0x10000000,0x10002000
            write(m,cfg+0x18,desc)
            m.reg_write(UC_ARM_REG_R0,cfg)
            m.reg_write(UC_ARM_REG_R1,index)
            m.reg_write(UC_ARM_REG_R2,direction)
            run(m,0xA0291758,0x10010000)
            value=read(m,desc+24*index+20)
            assert value==(0x01B20007 if direction==0 else 0x01720007)
            results.append({'name':'dma_control_marker','entry':'0xa0291758','index':index,'direction':direction,'descriptor_stride':24,'control_word':hex(value),'passed':True})

    c=capstone.Cs(capstone.CS_ARCH_ARM,capstone.CS_MODE_ARM)
    expected=[(0xA0291504,'ands','r1, r3, #0x8000000'),(0xA02915AC,'tst','r3, #0x10000000'),(0xA029423C,'cmp','r4, #1'),(0xA0294240,'beq','#0xa0294250'),(0xA02924D4,'add','r3, r3, #1'),(0xA02924E8,'bl','#0xa02941f4'),(0xA0292560,'str','r3, [r2, #8]'),(0xA0293560,'strb','r3, [r5, #4]')]
    checks=[]
    for addr,mnemonic,operands in expected:
        i=next(c.disasm(b[addr-BASE:addr-BASE+4],addr))
        assert(i.mnemonic,i.op_str)==(mnemonic,operands)
        checks.append({'address':hex(addr),'bytes':bytes(i.bytes).hex(),'mnemonic':mnemonic,'operands':operands})
    windows=[]
    for lo,hi in [(0xA02914F4,0xA02915DC),(0xA0294230,0xA0294254),(0xA02924C8,0xA0292514),(0xA0292538,0xA029257C),(0xA0293558,0xA0293568),(0xA0291CA0,0xA0291D24)]:
        windows.append({'start':hex(lo),'stop_exclusive':hex(hi),'sha256':sha(b[lo-BASE:hi-BASE]),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str,'bytes':bytes(i.bytes).hex()} for i in c.disasm(b[lo-BASE:hi-BASE],lo)]})
    report={'image':str(IMAGE),'image_sha256':EXPECTED,'scope':'Existing exports plus bounded instruction snippets in synthetic RAM, no hardware, no RTOS/helper stubs or instruction patches.','sources':sources,'results':results,'snippet_cases_passed':len(results),'instruction_assertions':checks,'instruction_windows':windows,'findings':['Input DMA completion uses status bit 0x08000000 and terminal bit 0x10000000, advances a ring index. No capture timestamp in the audited completion/status path.','A02941F4 returns success without copying when source IoNode+4 is not 1. InputDataProc counts a capacity-qualified destination before calling this writer, then can advance the DMA consume index even though the source gate is closed.','InputDataProc MakeUp and overwrite-warning branches compare ring indices; no video DSP clock is referenced in those branches.','The stop/rearm marker stores a control word into DMA descriptor+0x14, not a timestamp.','Buffer-to-encoder payload descriptors have 12-byte entries with pointer/size/terminal flag; no timestamp field was found in this bounded path.'],'limitations':['Closed source plus available capacity is sufficient for discard/progress; no assertion that every closed or backpressured state discards.','Input/encoder effect callbacks can be custom and are not fully analyzed here.','MMIO startup, DMA scheduling and hardware clock correlation are not executed.','A bounded absence of timestamps does not prove all firmware synchronization paths absent.','No shared capture epoch, lip sync, one-minute prerecord or device behavior verified.']}
    out=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-capture-epoch-audit.json'
    out.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'output':str(out),'snippet_cases_passed':len(results),'instruction_assertions_passed':len(checks)}))

if __name__=='__main__':main()
