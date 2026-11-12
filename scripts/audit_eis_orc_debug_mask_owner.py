#!/usr/bin/env python3
"""Audit stock ORC debug-level writers behind the vertical-warp log gate.

Static fixed-byte checks only. No ORC execution, emulation, device access,
hardware address interpretation, or debug-command dispatch.
"""
from __future__ import annotations
import json
import struct
from pathlib import Path
from audit_eis_orc_core import DSP, DSP_SHA, REF, REF_SHA, CoreDecoder, sha
from audit_eis_dsp_reference import inventory

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-11-eis-orc-debug-mask-owner'
CHECKS = {
    0x17F1EC:'l.movhi r18,0x0', 0x17F1F0:'l.ori r18,r18,0x0',
    0x17F27C:'l.lwz r6,120(r18)', 0x17F288:'l.andi r5,r6,0x3',
    0x17F290:'l.bf 0x17f2b0', 0x17F294:'l.jal 0x19fe44',
    0x18CB5C:'l.movhi r16,0x0', 0x18CB60:'l.ori r16,r16,0x0',
    0x18CB68:'l.lwz r5,120(r16)', 0x18CB70:'l.andi r4,r5,0x1',
    0x18CB78:'l.bnf 0x18cc2c', 0x18CC40:'l.jal 0x19fe44',
    0x18CC44:'l.j 0x18cb7c',
    0x1A0B14:'l.ori r10,r3,0x0', 0x1A0B18:'l.ori r12,r4,0x0',
    0x1A0B28:'l.sflesi r10,7', 0x1A0B48:'l.jal 0x19fe44',
    0x1A0B4C:'l.slli r6,r10,2', 0x1A0B50:'l.movhi r3,0x0',
    0x1A0B54:'l.ori r3,r3,0x64', 0x1A0B58:'l.add r5,r6,r3',
    0x1A0B5C:'l.sw 0(r5),r12',
    0x1A0B90:'l.ori r10,r3,0x0', 0x1A0B94:'l.ori r12,r4,0x0',
    0x1A0BB4:'l.slli r8,r10,2', 0x1A0BC0:'l.movhi r10,0x0',
    0x1A0BC4:'l.ori r10,r10,0x64', 0x1A0BD0:'l.add r9,r8,r10',
    0x1A0BD4:'l.lwz r7,0(r9)', 0x1A0BD8:'l.or r6,r7,r12',
    0x1A0BDC:'l.sw 0(r9),r6',
    0x1A856C:'l.lbz r3,4(r10)', 0x1A857C:'l.lbz r15,5(r10)',
    0x1A85CC:'l.lwz r4,8(r10)', 0x1A85D4:'l.jal 0x1a0b78',
    0x1A85F4:'l.lwz r4,8(r10)', 0x1A85FC:'l.jal 0x1a0afc',
    0x1A860C:'l.lbz r17,5(r10)', 0x1A8618:'l.lwz r4,8(r10)',
    0x1A8620:'l.jal 0x1a0b78', 0x1A8628:'l.lwz r4,8(r10)',
    0x1A8630:'l.jal 0x1a0afc',
    0xD360:'l.movhi r5,0x0', 0xD364:'l.ori r5,r5,0x0',
    0xD368:'l.addi r3,r0,0', 0xD36C:'l.sw 120(r5),r3',
    0x98E08:'l.addi r3,r0,0', 0x98E24:'l.sw 120(r4),r3',
    0x98E60:'l.movhi r4,0x0', 0x98E64:'l.ori r4,r4,0x0',
    0x98E90:'l.addi r7,r0,7', 0x98EAC:'l.sw 120(r4),r7',
    0x1A0384:'l.movhi r12,0x0', 0x1A0388:'l.ori r12,r12,0x0',
    0x1A0390:'l.addi r5,r0,7', 0x1A03B0:'l.sw 120(r12),r5',
    0x1FC1F0:'l.movhi r16,0x0', 0x1FC1F4:'l.ori r16,r16,0x0',
    0x1FC1F8:'l.addi r14,r0,7', 0x1FC208:'l.sw 120(r16),r14',
}
STRINGS = {
    0x2C027E:(0x1A0B38,0x1A0B3C,'DSP:: setDebugLevel module=%d, dbg_lvl=%d'),
    0x2C02A9:(0x1A0BC8,0x1A0BCC,'DSP:: addDebugLevel module=%d, dbg_lvl=%d, after=%d'),
    0x2C354B:(0x1A85B0,0x1A85B4,'CMD_DSP_SET_DEBUG_LEVEL'),
}
WINDOWS = {
    'debug-set':(0x1A0AFC,0x1A0B78), 'debug-or':(0x1A0B78,0x1A0BFC),
    'command-dispatch':(0x1A855C,0x1A8638),
    'vertical-reader':(0x17F1B8,0x17F2D4), 'copy-reader':(0x18CB2C,0x18CC6C),
    'explicit-zero-writer':(0xD354,0xD37C),
    'mode-writers':(0x98DDC,0x98EC8),
    'init-seven-writer':(0x1A0384,0x1A03D4),
    'other-seven-writer':(0x1FC1D0,0x1FC21C),
}

def main():
    dsp,ref=DSP.read_bytes(),REF.read_bytes()
    assert sha(dsp)==DSP_SHA and sha(ref)==REF_SHA
    m=inventory(dsp)[0]; start=int(m['offset'],16); binary=dsp[start:start+m['bytes']]
    assert sha(binary)=='9b005a4fabfad2ddfeac71eca88d7968f7d2ddcc3f385d970cdbb7be12f2f1f6'
    dec=CoreDecoder(ref.decode())
    def word(p):return struct.unpack_from('<I',binary,p)[0]
    checks=[]
    for p,expected in CHECKS.items():
        actual=dec.decode(word(p),p); assert actual==expected,(hex(p),actual,expected)
        checks.append({'offset':hex(p),'word_le':hex(word(p)),'instruction':actual})
    strings=[]
    for p,(hi,lo,needle) in STRINGS.items():
        target=p+0x600000
        assert word(hi)==(0x18600000|(target>>16))
        assert word(lo)==(0xA8630000|(target&65535))
        text=binary[p:binary.index(0,p)].decode(); assert needle in text
        strings.append({'offset':hex(p),'references':[hex(hi),hex(lo)],'text':text})
    assert 0x64+5*4==0x78
    OUT.mkdir(parents=True,exist_ok=True)
    windows=[]
    for name,(lo,hi) in WINDOWS.items():
        rows=[]
        for p in range(lo,hi,4):rows.append(f'{p:08x}: {word(p):08x}  {dec.decode(word(p),p) or ".word (unsupported)"}')
        (OUT/(name+'.asm')).write_text('\n'.join(rows)+'\n')
        windows.append({'name':name,'range':[hex(lo),hex(hi)],'sha256':sha(binary[lo:hi])})
    result={
        'evidence_type':'fixed stored ORC bytes and stock diagnostic references; offline only',
        'dsp_sha256':sha(dsp),'orccode_sha256':sha(binary),'reference_sha256':sha(ref),
        'instruction_checks':checks,'instruction_check_count':len(checks),
        'diagnostics':strings,'windows':windows,
        'debug_array':{'base_expression':'zero-base-relative +0x64, not an asserted physical address',
            'element_bytes':4,'module5_offset':'0x78',
            'set_helper':'0x1a0afc: array[module] = level',
            'add_helper':'0x1a0b78: array[module] |= level',
            'command_fields':'module=byte(command+4), add=byte(command+5), mask=word(command+8)',
            'command_reachability':'static dispatcher only; no API exposure/runtime reachability or command execution asserted'},
        'bounded_findings':[
            'The +0x78 field matches index 5 of the +0x64 u32 debug-level array; setDebugLevel and addDebugLevel are anchored by two matched stock diagnostic references and actual indexed stores.',
            'The debug command dispatch loads module/add/mask from +4/+5/+8 and calls set or OR helpers, providing an explicit software writer to the same array element.',
            'Several independent fixed windows write 0 or 7 to zero-base-relative +0x78; no DMA-done value is required to explain the observed low bits.',
            'The vertical-warp logger checks module5 bits 0..1, while idspdrv_dram2dram checks module5 bit0 before printing its src/dst/size diagnostic; these reader/writer facts identify a diagnostic mask, not a transfer completion field.'
        ],
        'not_proven':[
            'DSP physical DMEM/SMEM base, actual runtime mapping and register state',
            'Exhaustive writer inventory, unknown indirect aliases or proprietary effects',
            'Runtime debug level or externally reachable debug command path',
            'Dedicated hardware completion/cache/latch semantics of proprietary transfers',
            'Transfer-source final-reader time or safe table/slot reuse'
        ],
        'next_gap':'Completion must be recovered from the proprietary transfer/consumer hardware contract; +0x78 is a diagnostic configuration element and cannot provide that contract.',
        'device_access':False,'orc_executed':False,'rtos_executed':False,'writes_to_device':False,
    }
    (OUT/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'output':str(OUT),'instruction_checks':len(checks),'diagnostics':len(strings),'windows':len(windows),'device_access':False}))

if __name__=='__main__':main()
