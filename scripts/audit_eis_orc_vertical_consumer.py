#!/usr/bin/env python3
"""Offline, fixed-byte trace of ORC vertical-warp envelope and copy preparation.

No device access, execution, proprietary ISA decoding, or completion inference.
All addresses below are stored orccode member offsets, not verified DSP PCs.
"""
from __future__ import annotations
import json
import struct
from audit_eis_orc_core import ROOT, DSP, REF, DSP_SHA, REF_SHA, CoreDecoder, sha
from audit_eis_dsp_reference import inventory

CHECKS = {
    0xC4860:'l.ori r14,r3,0x0', 0xC4868:'l.lbz r3,1684(r3)',
    0xC4874:'l.addi r12,r14,1276', 0xC4878:'l.jal 0x1ac8c4',
    0xC487C:'l.ori r18,r11,0x0', 0xC493C:'l.lbz r21,2(r12)',
    0xC4944:'l.slli r17,r21,1', 0xC4950:'l.add r22,r17,r12',
    0xC49B4:'l.lbz r5,1630(r14)', 0xC49B8:'l.addi r20,r0,104',
    0xC49C4:'l.lwz r29,1620(r14)', 0xC49D8:'l.add r10,r29,r27',
    0xC49EC:'l.lwz r11,1588(r14)', 0xC49F4:'l.sw 4(r10),r11',
    0xC4A18:'l.ori r3,r18,0x0', 0xC4A1C:'l.jal 0x1aff40',
    0xC4A20:'l.ori r3,r11,0x0', 0xC4A24:'l.ori r4,r10,0x0',
    0xC4A28:'l.ori r5,r20,0x0', 0xC4A2C:'l.jal 0x1a14d8',
    0xC4A38:'l.sh 72(r22),r18',
    0xD0FB0:'l.ori r20,r3,0x0', 0xD0FE0:'l.addi r12,r3,1276',
    0xD103C:'l.lbz r27,0(r12)', 0xD1040:'l.addi r10,r20,1620',
    0xD1044:'l.slli r18,r27,1', 0xD1048:'l.add r25,r18,r12',
    0xD104C:'l.lhz r18,72(r25)', 0xD1050:'l.ori r3,r18,0x0',
    0xD1054:'l.jal 0x1aff40', 0xD1058:'l.lbz r23,11(r10)',
    0xD105C:'l.addi r5,r0,104', 0xD1060:'l.ori r3,r11,0x0',
    0xD1064:'l.mul r17,r5,r23', 0xD1068:'l.lwz r19,4(r10)',
    0xD1074:'l.add r4,r19,r17', 0xD1078:'l.jal 0x1a14c4',
    0xD1080:'l.lbz r16,18(r10)', 0xD1094:'l.ori r3,r18,0x0',
    0xD1098:'l.jal 0x1add2c', 0xD10A0:'l.lbz r4,0(r12)',
    0xD10C0:'l.sb 0(r12),r31',
    0xB3070:'l.ori r14,r3,0x0', 0xB30F8:'l.addi r10,r14,1620',
    0xB311C:'l.lbz r29,12(r10)', 0xB3120:'l.addi r31,r0,104',
    0xB3128:'l.mul r23,r29,r31', 0xB312C:'l.lwz r25,4(r10)',
    0xB3138:'l.add r22,r25,r23', 0xB3178:'l.lwz r4,32(r22)',
    0xB31C4:'l.srli r9,r4,11', 0xB31C8:'l.andi r4,r9,0x1',
    0xB31CC:'l.sfeqi r4,0', 0xB31D0:'l.bf 0xb4888',
    0xB31D4:'l.lwz r4,24(r22)', 0xB31D8:'l.addi r3,r0,0',
    0xB31DC:'l.lbz r5,28(r22)', 0xB31E0:'l.lbz r6,29(r22)',
    0xB31E4:'l.jal 0x17f1b8', 0xB3224:'l.lwz r19,32(r22)',
    0xB3228:'l.addi r20,r0,-2049', 0xB322C:'l.and r17,r19,r20',
    0xB3230:'l.sw 32(r22),r17',
    0x17F1DC:'l.ori r16,r4,0x0', 0x17F1E0:'l.andi r12,r5,0xff',
    0x17F1E4:'l.andi r14,r6,0xff', 0x17F1E8:'l.addi r4,r0,24',
    0x17F1F4:'l.jal 0x18b448', 0x17F204:'l.ori r10,r11,0x0',
    0x17F260:'l.addi r4,r10,256', 0x17F264:'l.ori r3,r16,0x0',
    0x17F268:'l.addi r5,r0,3136', 0x17F26C:'l.sfeqi r16,0',
    0x17F270:'l.bnf 0x17f29c', 0x17F29C:'l.lhz r8,11058(r18)',
    0x17F2A0:'l.ori r7,r8,0x3', 0x17F2A4:'l.sh 11058(r18),r7',
    0x17F2A8:'l.jal 0x18cb2c',
    0x18CBA4:'l.addi r10,r0,544', 0x18CBB8:'l.and r10,r10,r8',
    0x18CBC8:'l.jal 0x1a46a0', 0x18CBDC:'l.jal 0x1a4a04',
    0x18CBE8:'l.bf 0x18cba0',
    0x1A47DC:'l.jal 0x1a6ef4', 0x1A47E8:'l.jal 0x1a156c',
    0x1A4B14:'l.jal 0x1a1528', 0x1A4B40:'l.jal 0x1a6ef4',
    0x1A4B4C:'l.jal 0x1a15d4',
    0x1ADD58:'l.andi r10,r3,0xffff', 0x1ADF5C:'l.andi r19,r21,0x3f',
    0x1ADF84:'l.addi r11,r12,-1', 0x1ADF90:'l.sw 24(r7),r6',
    0x1ADEA8:'l.andi r15,r17,0x3f', 0x1ADEAC:'l.addi r13,r15,-1',
    0x1ADEBC:'l.sw 24(r16),r8',
}
STRINGS = {
    0x280EC7:(0xC48E8,0xC48EC,'send_data_to_2nd_half:'),
    0x281014:(0xC4AC8,0xC4ACC,'cap_info_fid='),
    0x285749:(0xD13D0,0xD13D4,'from_secondhalf_q'),
    0x2856E5:(0xD13B4,0xD13B8,'vcap_idsp_update_sec3_warp_yuv_input_fbid'),
    0x2B7BA9:(0x17F280,0x17F284,'idspdrv_update_vertical_warp_field() done.'),
    0x2C5EA1:(0x1ADE30,0x1ADE34,'relFBuf'),
}
WINDOWS = {
    'send-frame':(0xC482C,0xC4B54), 'receive-frame':(0xD0F60,0xD1468),
    'vertical-consumer':(0xB3014,0xB3250), 'consumer-no-table':(0xB4878,0xB4950),
    'vertical-command':(0x17F1B8,0x17F2D4), 'command-object':(0x18B448,0x18B520),
    'dram-copy':(0x18CB2C,0x18CC6C), 'dram-to-scratch':(0x1A46A0,0x1A4890),
    'scratch-to-dram':(0x1A4A04,0x1A4BEC), 'frame-handle-release':(0x1ADD2C,0x1AE07C),
    'frame-handle-address':(0x1AFF40,0x1B004C),
    'opaque-staging':(0x1A14C4,0x1A14EC),
    'opaque-preparation':(0x1A1528,0x1A155C),
    'opaque-read-loop':(0x1A156C,0x1A15A0),
    'opaque-write-loop':(0x1A15D4,0x1A1608),
    'opaque-descriptor':(0x1A6EF4,0x1A6F34),
}
# Uninterpreted words at the smallest relevant unsupported spans.
OPAQUE = {
    0x1A14CC:0xF1E30222,0x1A14D0:0xF0000049,
    0x1A14E0:0xF1E30223,0x1A14E4:0xF0000049,
    0x1A1570:0xFC606000,0x1A1580:0xF0000049,
    0x1A1594:0xFC60001C,0x1A1598:0xF0000049,
    0x1A15D8:0xFC606001,0x1A15E8:0xF0000049,
    0x1A15FC:0xFC600008,0x1A1600:0xF0000049,
    0x1A6F08:0xFC602007,0x1A6F0C:0xFC602887,
    0x1A6F10:0xFC603107,0x1A6F14:0xFC603987,
    0x1A6F18:0xFC604207,0x1A6F1C:0xFC605A87,0x1A6F20:0xF0000049,
}


def main():
    dsp, ref = DSP.read_bytes(), REF.read_bytes()
    assert sha(dsp)==DSP_SHA and sha(ref)==REF_SHA
    member=inventory(dsp)[0]; begin=int(member['offset'],16)
    binary=dsp[begin:begin+member['bytes']]; dec=CoreDecoder(ref.decode())
    def word(p): return struct.unpack_from('<I',binary,p)[0]
    checks=[]
    for p, expected in CHECKS.items():
        actual=dec.decode(word(p),p)
        assert actual==expected,(hex(p),actual,expected)
        checks.append({'offset':hex(p),'word':f'{word(p):08x}','instruction':actual})
    strings=[]
    for p,(hi,lo,required) in STRINGS.items():
        a,b=word(hi),word(lo)
        assert a&0xFC1F0000==0x18000000 and b&0xFC000000==0xA8000000
        assert a>>21&31==b>>16&31==b>>21&31==3
        assert ((a&65535)<<16 | b&65535)==p+0x600000
        value=binary[p:binary.index(0,p)].decode()
        assert required in value
        strings.append({'offset':hex(p),'reference_pair':[hex(hi),hex(lo)],'text':value})
    for p,w in OPAQUE.items():
        assert word(p)==w and dec.decode(w,p) is None,(hex(p),hex(word(p)))
    # This is only a syntactic direct-jal inventory within a stated range.
    callers=[]
    for p in range(0,0x200000,4):
        w=word(p)
        if w>>26==1 and dec.decode(w,p)=='l.jal 0x17f1b8': callers.append(p)
    assert callers==[0xB31E4,0xF8BEC,0xF8ED4,0xF9148,0x17FC2C,0x18033C,0x185AD4]
    remaining=0xC40; pos=0; chunks=[]
    while remaining>63:
        size=min(remaining,0x220)&~31
        chunks.append({'source_add':hex(pos),'destination_add':hex(pos),'size':hex(size)})
        pos+=size;remaining-=size
    assert remaining==0 and pos==0xC40 and len(chunks)==6
    out=ROOT/'artifacts/device/2026-11-10-eis-orc-vertical-consumer'
    out.mkdir(parents=True,exist_ok=True)
    windows=[]
    for name,(start,end) in WINDOWS.items():
        lines=[]; unknown=[]
        for p in range(start,end,4):
            ins=dec.decode(word(p),p)
            if ins is None:unknown.append(hex(p))
            lines.append(f'{p:08x}: {word(p):08x}  {ins or ".word (unsupported encoding)"}')
        path=out/f'{name}.asm';path.write_text('\n'.join(lines)+'\n')
        windows.append({'name':name,'start':hex(start),'end_exclusive':hex(end),
                        'sha256':sha(binary[start:end]),'unsupported_offsets':unknown})
    result={
        'evidence_type':'fixed stored ORC bytes only; no execution or device access',
        'dsp_sha256':sha(dsp),'reference_sha256':sha(ref),'orccode_sha256':sha(binary),
        'instruction_check_count':len(checks),'instruction_checks':checks,
        'diagnostics':strings,'windows':windows,
        'sender':{'frame':'lwz(context+0x654)+byte(context+0x65e)*0x68',
                  'envelope_field_4':'context+0x634 copied into frame+4',
                  'handle_queue':'Q=context+0x4fc; half[Q+0x48+2*byte(Q+2)] = cap_info_fid',
                  'staging':'1aff40(handle), then 1a14d8(address,frame,0x68); proprietary transfer'},
        'receiver':{'entry':'0xd0f60; named by diagnostic vcap_idsp_update_sec3_warp_yuv_input_fbid',
                    'handle':'half[Q+0x48+2*byte(Q+0)]',
                    'destination':'lwz(context+0x658)+byte(context+0x65f)*0x68; capacity byte(context+0x666)',
                    'sequence':'1aff40(handle),1a14c4(address,destination,0x68),1add2c(handle),advance Q+0',
                    'release_scope':'relFBuf decrements packed framebuffer usage counters, not a proven table release'},
        'consumer':{'frame':'lwz(context+0x658)+byte(context+0x660)*0x68',
                    'guard':'frame+0x20 bit11 plus other context gates',
                    'call':'17f1b8(0,lwz(frame+0x18),byte(frame+0x1c),byte(frame+0x1d))',
                    'post_call':'after controlregs shadow preparation, visible code clears frame+0x20 bit11 at 0xb3230; +0x18 not cleared in that sequence'},
        'vertical_controlregs_shadow':{'filter_selector':24,'shadow_pointer':'18b448(0,24) result; not a proven hardware opcode',
                            'source':'frame+0x18 retained into r16',
                            'destination':'shadow_pointer+0x100','size':'0xc40',
                            'other_fields':'18bf5c calls use metadata bytes as stack arguments; no undocumented register-field names assigned',
                            'global_flag':'half[0x2b32] |= 3 before copy call; runtime address identity unproven',
                            'diagnostic_is_not_completion':'done string is ordinary log call after copy helper returns'},
        'copy_chunk_derivation':{'algorithm':'min(remaining,0x220)&~31 while remaining>63',
                                 'chunks':chunks,'final_remainder':remaining,
                                 'not_execution':'arithmetic reconstruction of visible core instructions only'},
        'opaque_words':[{'offset':hex(p),'word':f'{w:08x}'} for p,w in OPAQUE.items()],
        'direct_jal_inventory':{'range':['0x0','0x200000'],'target':'0x17f1b8',
                                'syntactic_hits':[hex(p) for p in callers],
                                'limitation':'not a complete call graph, reachability or executable-range proof'},
        'not_proven':['actual DSP PCs or runtime frame correspondence',
                      'completion or memory-ordering semantics of unsupported transfer instructions',
                      'unique/final hardware reader or table owner',
                      'warp table release bound, output PTS or feedback-tag correspondence',
                      'filter24 shadow field meanings, hardware submission or consumption timing'],
        'device_access':False}
    (out/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'instruction_checks':len(checks),'diagnostics':len(strings),
                      'opaque_word_checks':len(OPAQUE),'copy_chunks':len(chunks),'output':str(out),'device_access':False}))

if __name__=='__main__':main()
