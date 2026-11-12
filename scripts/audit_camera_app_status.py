#!/usr/bin/env python3
"""Execute 1.10.7 app_status getter with synthetic state; never contacts a device."""
import hashlib
import json
import struct
from pathlib import Path
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR

ROOT=Path(__file__).resolve().parents[1]
ANALYSIS=ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE=0xA0100000
SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'


def main():
    data=(ANALYSIS/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(data).hexdigest()==SHA
    uc=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    uc.mem_map(BASE,(len(data)+4095)&~4095);uc.mem_write(BASE,data)
    for address in (0xA0FB3000,0xA1055000,0x70000000):uc.mem_map(address,0x2000)
    def text(address):
        result=bytearray()
        for i in range(128):
            b=bytes(uc.mem_read(address+i,1))
            if b==b'\0':return result.decode()
            result.extend(b)
        raise AssertionError('No C-string end')
    def hook(machine,address,size,user):
        if address==0xA04F93C4:
            assert text(machine.reg_read(UC_ARM_REG_R2))=='%s'
            result=text(machine.reg_read(UC_ARM_REG_R3))
            machine.mem_write(machine.reg_read(UC_ARM_REG_R0),result.encode()+b'\0')
            value=len(result)
        elif address==0xA02A70EC:value=0 # Diagnostic output only.
        else:return
        machine.reg_write(UC_ARM_REG_R0,value)
        lr=machine.reg_read(UC_ARM_REG_LR)
        machine.reg_write(UC_ARM_REG_CPSR,machine.reg_read(UC_ARM_REG_CPSR)&~0x20)
        machine.reg_write(UC_ARM_REG_PC,lr&~1)
    uc.hook_add(UC_HOOK_CODE,hook)
    put=lambda a,v:uc.mem_write(a,struct.pack('<I',v))
    cases=[('idle',0,4,0,0,0,0),('vf',5,4,0,0,0,0),
           ('record',1,4,0,0,0,0),('record',0,4,0x200,0,0,0),
           ('capture',4,0,0,0,0,0),('capture',0,0,2,0,0,0),
           ('capture',5,0,2,0,0,0),('Unknown',2,4,0,0,0,0),
           ('Unknown',6,4,0,0,0,0),('Unknown',255,4,0,0,0,0),
           ('Unknown',0,4,4,0,0,0),('Unknown',0,4,0,0,0,4)]
    results=[]
    for wanted,app,mode,flags,cflags,gflags,d08 in cases:
        uc.mem_write(0xA0FB334C,bytes([app]));uc.mem_write(0xA1055CFA,bytes([mode]));uc.mem_write(0xA1055D08,bytes([d08]))
        for address,value in [(0xA069B3C8,flags),(0xA069B3CC,cflags),(0xA069B3C4,gflags)]:put(address,value)
        uc.mem_write(0x70000000,b'\0'*128)
        for reg,value in [(UC_ARM_REG_R0,0x70000000),(UC_ARM_REG_R1,128),(UC_ARM_REG_SP,0x70001F00),(UC_ARM_REG_LR,0x70001000)]:uc.reg_write(reg,value)
        uc.reg_write(UC_ARM_REG_CPSR,uc.reg_read(UC_ARM_REG_CPSR)&~0x20)
        uc.emu_start(0xA0155D9C,0x70001000,count=2000)
        assert uc.reg_read(UC_ARM_REG_PC)==0x70001000
        actual=text(0x70000000);assert actual==wanted,(actual,wanted)
        results.append({'synthetic_app_state':app,'native_mode':mode,'flags':hex(flags),'cflags':hex(cflags),'gflags':hex(gflags),'d08':d08,'app_status':actual})
    sources=[]
    for entry in [0xA0155D9C,0xA011F21C,0xA011EFC4,0xA011F084,0xA011F0C8,0xA011F758,0xA0165B98]:
        path=ANALYSIS/'full/decompiled'/f'{entry:08x}.c'
        sources.append({'entry':hex(entry),'pseudocode_sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    out=ROOT/'artifacts/device/2026-11-10-camera-app-status';out.mkdir(parents=True,exist_ok=True)
    (out/'audit.json').write_text(json.dumps({'image_sha256':SHA,'sources':sources,'synthetic_cases':results,
        'scope':'Real stock getter/readiness helpers in synthetic RAM; snprintf/diagnostic print stubbed. No camera connection or observed transition.',
        'limits':'Unknown examples prove classification, not that those states occurred during the failing Android run.'},indent=2)+'\n')
    print(f'{len(results)} real-getter synthetic cases passed; output includes exact Unknown capitalization')


if __name__=='__main__':main()
