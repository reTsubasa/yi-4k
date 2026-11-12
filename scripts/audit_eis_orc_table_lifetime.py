#!/usr/bin/env python3
"""Pin ORC warp pointer retention and copy preparation; no hardware execution."""
from __future__ import annotations
import json
import struct
from audit_eis_orc_core import ROOT, DSP, REF, DSP_SHA, REF_SHA, CoreDecoder, sha
from audit_eis_dsp_reference import inventory

# Deliberately explicit expected decodings, independent of the report prose.
CHECKS = {
    0xD748C: 'l.ori r22,r3,0x0', 0xD7490: 'l.addi r29,r0,104',
    0xD7494: 'l.lbz r3,1629(r3)', 0xD7498: 'l.ori r10,r4,0x0',
    0xD74A0: 'l.mul r21,r3,r29', 0xD74B4: 'l.lwz r23,1620(r22)',
    0xD74D4: 'l.add r26,r23,r21', 0xD7690: 'l.lwz r3,36(r10)',
    0xD7694: 'l.addi r4,r0,10784', 0xD7698: 'l.addi r5,r0,128',
    0xD769C: 'l.addi r10,r2,-80', 0xD76A0: 'l.jal 0x1a4890',
    0xD76A4: 'l.addi r3,r0,10784', 0xD76A8: 'l.ori r4,r10,0x0',
    0xD76AC: 'l.addi r5,r0,80', 0xD76B8: 'l.jal 0x1a14c4',
    0xD76DC: 'l.ori r3,r28,0x0', 0xD76E0: 'l.ori r4,r10,0x0',
    0xD76E4: 'l.jal 0x17f594', 0xD76E8: 'l.lwz r3,-68(r2)',
    0xD76EC: 'l.sfeqi r3,0', 0xD76F0: 'l.bf 0xd780c',
    0xD76F4: 'l.sw 24(r26),r3', 0xD76F8: 'l.lwz r29,32(r26)',
    0xD76FC: 'l.lbz r31,-25(r2)', 0xD7700: 'l.ori r10,r29,0x800',
    0xD7704: 'l.sb 28(r26),r31', 0xD7708: 'l.lbz r28,-24(r2)',
    0xD770C: 'l.sw 32(r26),r10', 0xD7710: 'l.sb 29(r26),r28',
    0xD7934: 'l.lwz r3,-32(r2)', 0xD7940: 'l.sw -72(r2),r3',
    0xD7948: 'l.jal 0xd7454', 0xD794C: 'l.j 0xd78d8',
    0xD78F4: 'l.addi r3,r14,60', 0xD78F8: 'l.jal 0x1a4a04',
    0x17F5B8: 'l.lwz r14,8(r4)', 0x17F5BC: 'l.ori r12,r4,0x0',
    0x17F5C4: 'l.addi r4,r0,20', 0x17F5C8: 'l.jal 0x18b448',
    0x17F5D0: 'l.ori r10,r11,0x0', 0x17F6A8: 'l.sfeqi r14,0',
    0x17F6AC: 'l.bnf 0x17f7c0', 0x17F7C8: 'l.addi r4,r10,320',
    0x17F7D4: 'l.ori r3,r14,0x0', 0x17F7DC: 'l.addi r5,r0,3072',
    0x17F7E4: 'l.jal 0x18cb2c',
    0x18CB50: 'l.ori r18,r4,0x0', 0x18CB54: 'l.ori r12,r5,0x0',
    0x18CB58: 'l.ori r14,r3,0x0', 0x18CBA0: 'l.sflesi r12,544',
    0x18CBA4: 'l.addi r10,r0,544', 0x18CBAC: 'l.ori r10,r12,0x0',
    0x18CBB4: 'l.ori r3,r14,0x0', 0x18CBB8: 'l.and r10,r10,r8',
    0x18CBBC: 'l.ori r4,r16,0x0', 0x18CBC0: 'l.ori r5,r10,0x0',
    0x18CBC8: 'l.jal 0x1a46a0', 0x18CBCC: 'l.ori r3,r18,0x0',
    0x18CBD0: 'l.ori r4,r16,0x0', 0x18CBD4: 'l.ori r5,r10,0x0',
    0x18CBDC: 'l.jal 0x1a4a04',
    0xC5844: 'l.addi r8,r0,104', 0xC5848: 'l.lwz r5,1620(r12)',
    0xC584C: 'l.mul r11,r22,r8', 0xC5854: 'l.add r14,r5,r11',
    0xC5864: 'l.addi r13,r22,-1', 0xC5868: 'l.lbz r3,1637(r12)',
    0xC5870: 'l.sfltu r7,r3', 0xC5878: 'l.addi r15,r3,-1',
    0xC5880: 'l.mul r20,r7,r8', 0xC5884: 'l.ori r3,r14,0x0',
    0xC5888: 'l.add r4,r5,r20', 0xC588C: 'l.jal 0xe3d74',
    0xE3DB8: 'l.lbz r7,28(r4)', 0xE3DBC: 'l.lwz r5,24(r4)',
    0xE3DC0: 'l.lbz r6,29(r4)', 0xE3DC4: 'l.sb 28(r3),r7',
    0xE3DC8: 'l.sw 24(r3),r5', 0xE3DCC: 'l.sb 29(r3),r6',
    0xE3DD4: 'l.andi r29,r31,0x7f8',
    0xC49B4: 'l.lbz r5,1630(r14)', 0xC49B8: 'l.addi r20,r0,104',
    0xC49BC: 'l.mul r27,r20,r5', 0xC49C4: 'l.lwz r29,1620(r14)',
    0xC49D8: 'l.add r10,r29,r27', 0xC4A18: 'l.ori r3,r18,0x0',
    0xC4A1C: 'l.jal 0x1aff40', 0xC4A20: 'l.ori r3,r11,0x0',
    0xC4A24: 'l.ori r4,r10,0x0', 0xC4A28: 'l.ori r5,r20,0x0',
    0xC4A2C: 'l.jal 0x1a14d8',
    0x1A47DC: 'l.jal 0x1a6ef4', 0x1A47E0: 'l.ori r3,r20,0x0',
    0x1A47E4: 'l.ori r4,r14,0x0', 0x1A47E8: 'l.jal 0x1a156c',
}
STRINGS = {
    0x2BC474: (0x18CC2C, 0x18CC30, 'idspdrv_dram2dram src:'),
    0x2C243A: (0x1A481C, 0x1A4820, 'dram_2_smem(), size is not multiple of 4'),
}
WINDOWS = [(0xD7454,0xD7844), (0x17F594,0x17F810), (0x18CB2C,0x18CC6C),
           (0xC5838,0xC589C), (0xE3D74,0xE3E58), (0xC49B4,0xC4A30),
           (0x1A46A0,0x1A4890), (0x1A156C,0x1A15A0), (0x1A6EF4,0x1A6F34)]


def main():
    dsp, ref = DSP.read_bytes(), REF.read_bytes()
    assert sha(dsp) == DSP_SHA and sha(ref) == REF_SHA
    member = inventory(dsp)[0]
    begin = int(member['offset'], 16)
    binary = dsp[begin:begin+member['bytes']]
    dec = CoreDecoder(ref.decode())
    def word(p): return struct.unpack_from('<I', binary, p)[0]
    checks = []
    for p, expected in CHECKS.items():
        actual = dec.decode(word(p),p)
        assert actual == expected, (hex(p), actual, expected)
        checks.append({'member_offset':hex(p),'word_le':hex(word(p)),'instruction':actual})
    strings=[]
    for p,(hi,lo,required) in STRINGS.items():
        a,b=word(hi),word(lo)
        assert a&0xFC1F0000==0x18000000 and b&0xFC000000==0xA8000000
        assert a>>21&31==b>>16&31==b>>21&31==3
        address=(a&65535)<<16 | b&65535
        assert address==p+0x600000
        value=binary[p:binary.index(0,p)].decode()
        assert required in value
        strings.append({'member_offset':hex(p),'text':value,'high':hex(hi),'low':hex(lo)})
    assert -68-(-80)==12 and -25-(-80)==55 and -24-(-80)==56
    out=ROOT/'artifacts/device/2026-11-10-eis-orc-table-lifetime'
    out.mkdir(parents=True,exist_ok=True)
    windows=[]; lines=[]
    for start,end in WINDOWS:
        unknown=[]
        lines.append(f'\n; static ORC member [{start:#x},{end:#x})')
        for p in range(start,end,4):
            ins=dec.decode(word(p),p)
            if ins is None: unknown.append(hex(p))
            lines.append(f'{p:08x}: {word(p):08x}  {ins or ".word (unsupported encoding)"}')
        windows.append({'start':hex(start),'end_exclusive':hex(end),'sha256':sha(binary[start:end]),'unsupported_offsets':unknown})
    (out/'table-windows.asm').write_text('\n'.join(lines)+'\n')
    report={'evidence_type':'fixed stored ORC bytes; no execution or device access',
            'dsp_sha256':sha(dsp),'reference_sha256':sha(ref),'orccode_sha256':sha(binary),
            'instruction_check_count':len(checks),'instruction_checks':checks,'diagnostic_references':strings,
            'vertical_pointer_retention':{'frame':'lwz(context+0x654) + byte(context+0x65d)*0x68',
                'descriptor':'state+0x24 read through opaque staging; local base stack-80',
                'retained':'local command+0x0c -> frame+0x18; command+0x37/+0x38 -> frame+0x1c/+0x1d; frame+0x20 |= 0x800',
                'tag_echo_order':'pointer stores are inside 0xd7454; 0xd7844 calls it before tag submission preparation',
                'shallow_copy':'0xc588c passes two same-array frame objects to 0xe3d74, which copies +0x18 pointer and +0x1c/+0x1d metadata without table copying',
                'shallow_copy_flag_caveat':'0xe3d74 copies source flags masked 0x7f8, excluding bit11; copying pointer alone does not establish activation'},
            'horizontal_copy_preparation':{'helper':'0x17f594 takes descriptor+8; nonzero source enters idspdrv_dram2dram(source, command20+0x140, 0xc00)',
                'copy_path':'0x18cb2c chunks <=0x220 through scratch; dram_2_smem then smem_2_dram; final padded remainder path is separately visible',
                'completion':'0x1a46a0 calls opaque 0x1a6ef4 then 0x1a156c; latter has counted unknown instructions, not decoded done polling'},
            'frame_handoff_preparation':'0xc49b4 indexes same frame array with byte(context+0x65e), then passes whole 0x68 frame to opaque staging 0x1a14d8',
            'not_proven':['actual DSP execution or runtime frame sequence','hardware consumer of frame+0x18 or actual later table read','safe release point or table lifetime bound','DMA done/ordering/cache semantics of proprietary instructions','feedback-to-output PTS correspondence'],
            'windows':windows,'device_access':False}
    (out/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'instruction_checks':len(checks),'diagnostic_references':len(strings),'output':str(out),'device_access':False}))


if __name__=='__main__': main()
