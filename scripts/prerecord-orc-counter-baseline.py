#!/usr/bin/env python3
"""Pin counter callers and baselines; never infer proprietary opcode semantics."""
import hashlib
import json
import re
import struct
from pathlib import Path
from audit_eis_orc_core import DSP, REF, DSP_SHA, REF_SHA, CoreDecoder
from audit_eis_dsp_reference import inventory

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-orc-counter-baseline-audit.json'


def sha(data): return hashlib.sha256(data).hexdigest()


def main():
    package,reference=DSP.read_bytes(),REF.read_bytes()
    assert sha(package)==DSP_SHA and sha(reference)==REF_SHA
    member=inventory(package)[0];start=int(member['offset'],16)
    binary=package[start:start+member['bytes']]
    decoder=CoreDecoder(reference.decode())
    def word(a): return struct.unpack_from('<I',binary,a)[0]
    def ins(a): return decoder.decode(word(a),a)
    expected={
      0x163270:'l.ori r3,r12,0x0',0x163278:'l.jal 0x177004',
      0x163308:'l.ori r3,r12,0x0',0x163310:'l.jal 0x177004',
      0x163320:'l.srli r22,r4,28',0x163324:'l.andi r18,r22,0x3',
      0x163328:'l.sfnei r18,1',0x16332C:'l.bf 0x163344',
      0x163344:'l.srli r15,r4,28',0x163348:'l.andi r5,r15,0x3',
      0x16334C:'l.sfnei r5,1',0x163350:'l.bnf 0x16338c',
      0x16339C:'l.lhz r17,266(r12)',0x1633A0:'l.sfnei r17,0',
      0x1633A4:'l.bnf 0x16343c',0x1633A8:'l.addi r5,r20,8',
      0x1633B4:'l.jal 0x177364',0x163400:'l.jal 0x172d24',
      0x163408:'l.ori r3,r12,0x0',0x16340C:'l.jal 0x177004',
      0x16343C:'l.ori r3,r12,0x0',0x163440:'l.addi r4,r0,1',
      0x163444:'l.jal 0x1636ac',0x163448:'l.sw 252(r12),r11',
      0x16344C:'l.j 0x1633a8',
      0x1636C0:'l.lwz r4,16(r3)',0x1636C8:'l.srli r5,r4,28',
      0x1636CC:'l.andi r4,r5,0x3',0x1636D0:'l.sfnei r4,1',
      0x1636D4:'l.bnf 0x163724',0x163724:'l.jal 0x1a1830',
      0x163728:'l.ori r10,r11,0x0',0x163730:'l.ori r11,r10,0x0',
      0x163C60:'l.addi r4,r0,0',0x163C64:'l.jal 0x1636ac',
      0x163C68:'l.srli r3,r11,9',0x163C6C:'l.slli r11,r3,6',
      0x163C7C:'l.addi r11,r11,-64',
      0x164D70:'l.ori r3,r10,0x0',0x164D74:'l.jal 0x164ca0',
      0x164ED0:'l.jal 0x1630b8',0x164F0C:'l.addi r3,r0,0',
      0x164F20:'l.sw 244(r10),r3',0x164F78:'l.sfeqi r18,0',
      0x164F7C:'l.bf 0x164fd8',0x164F88:'l.lwz r7,244(r10)',
      0x164F8C:'l.srli r4,r7,9',0x164F90:'l.slli r3,r4,6',
      0x164FA0:'l.addi r11,r3,-64',0x164FA8:'l.slli r9,r11,3',
      0x164FB4:'l.sw 244(r10),r9',0x164FBC:'l.jal 0x163cb0',
      0x164FCC:'l.jal 0x163748',0x164FDC:'l.jal 0x1630b8',
      0x164FE4:'l.jal 0x163530',0x1650B4:'l.ori r3,r10,0x0',
      0x1650B8:'l.addi r4,r0,0',0x1650BC:'l.addi r5,r0,0',
      0x1650C0:'l.addi r6,r0,0',0x1650C4:'l.jal 0x178388',
      0x1650C8:'l.j 0x164d70',
      0x1783B8:'l.ori r14,r3,0x0',0x1783E8:'l.lwz r13,32(r14)',
      0x1783F0:'l.andi r9,r13,0x1',0x178400:'l.lwz r4,76(r16)',
      0x17840C:'l.bf 0x1786f8',0x178410:'l.lwz r5,0(r4)',
      0x178414:'l.srli r19,r5,5',0x178418:'l.andi r17,r19,0x1',
      0x17841C:'l.sfnei r17,0',0x178420:'l.bf 0x1786f8',
      0x178424:'l.ori r21,r5,0x20',0x17842C:'l.sw 0(r4),r21',
      0x178510:'l.lwz r6,20(r5)',0x178514:'l.slli r7,r6,1',
      0x178518:'l.andi r31,r6,0x3fff',0x17851C:'l.and r29,r7,r3',
      0x178520:'l.or r27,r29,r31',0x178524:'l.sw -8(r2),r27',
      0x178658:'l.addi r3,r0,0',0x17865C:'l.jal 0x1a1850',
      0x178660:'l.addi r3,r0,0',0x178664:'l.jal 0x1a1814',
      0x17868C:'l.andi r3,r10,0xff',0x178690:'l.addi r4,r0,0',
      0x178694:'l.addi r18,r10,12',0x178698:'l.jal 0x1a1868',
      0x17869C:'l.addi r4,r0,0',0x1786A0:'l.andi r3,r18,0xff',
      0x1786A4:'l.addi r10,r10,1',0x1786A8:'l.jal 0x1a1868',
      0x1786AC:'l.sfleui r10,3',0x1786B0:'l.bf 0x17868c',
      0x1786F8:'l.jal 0x1a185c',0x178704:'l.sw -4(r2),r11',
      0x178728:'l.movhi r10,0x1',0x17872C:'l.ori r10,r10,0x3010',
      0x17873C:'l.ori r3,r10,0x0',0x178740:'l.addi r4,r2,-4',
      0x178744:'l.addi r5,r0,4',0x178748:'l.jal 0x1a14c4',
      0x17874C:'l.lwz r10,-4(r2)',0x178758:'l.addi r9,r10,7',
      0x17875C:'l.srli r8,r9,3',0x178768:'l.j 0x178430',
      0x164140:'l.jal 0x1a185c',0x164148:'l.movhi r22,0x1',
      0x16414C:'l.ori r22,r22,0x3010',0x16415C:'l.sw -80(r2),r11',
      0x164174:'l.ori r3,r22,0x0',0x164178:'l.addi r4,r2,-80',
      0x16417C:'l.addi r5,r0,4',0x164180:'l.jal 0x1a14d8',
      0x178B54:'l.jal 0x1a1830',0x178B58:'l.lwz r3,76(r12)',
      0x178B5C:'l.addi r4,r11,7',0x178B60:'l.lwz r10,20(r3)',
      0x178B64:'l.srai r14,r4,3',0x178B68:'l.lwz r12,12(r3)',
      0x178B6C:'l.add r7,r10,r14',0x178B74:'l.add r5,r12,r10',
      0x178B90:'l.jal 0x1a14d8',0x178EE4:'l.jal 0x1a185c',
      0x178F7C:'l.addi r10,r0,0',0x178F80:'l.jal 0x1a1830',
      0x178F84:'l.ori r20,r11,0x0',0x178F88:'l.ori r14,r11,0x0',
      0x178FA0:'l.ori r3,r10,0x0',0x178FA4:'l.jal 0x1a187c',
      0x178FC4:'l.addi r10,r10,1',0x178FD0:'l.sub r14,r14,r11',
      0x178FF8:'l.sfleui r10,3',0x178FFC:'l.bf 0x178fa0',
      0x179020:'l.jal 0x1a1824',0x179024:'l.ori r10,r11,0x0',
      0x179028:'l.lwz r4,252(r16)',0x179038:'l.sub r5,r20,r4',
      0x179040:'l.addi r22,r5,-40',0x1790D8:'l.jal 0x1a183c',
      0x179180:'l.ori r3,r16,0x0',0x179184:'l.jal 0x1636ac',
      0x17918C:'l.sw 244(r16),r11',
    }
    checks=[]
    for a,text in expected.items():
        assert ins(a)==text,(hex(a),ins(a),text)
        checks.append(dict(offset=hex(a),word=hex(word(a)),instruction=text))
    callers={
        0x1A1830:[0x163724,0x178B54,0x178F80],
        0x1636AC:[0x163444,0x163C64,0x163D20,0x179184],
        0x178388:[0x1650C4],0x1A1814:[0x178664],0x1A1850:[0x17865C],
        0x1A185C:[0x164140,0x1786F8,0x178EE4],
        0x1A1868:[0x178698,0x1786A8],0x1A187C:[0x1649FC,0x164A08,0x178FA4]}
    actual={target:[] for target in callers}
    for a in range(0,len(binary)-3,4):
        if word(a)>>26!=1: continue
        text=ins(a)
        if text and text.startswith('l.jal '):
            target=int(text.split()[-1],16)
            if target in actual: actual[target].append(a)
    assert actual==callers,actual
    field_stores=[]
    for a in range(0x162000,0x17A000,4):
        text=ins(a)
        if text and re.fullmatch(r'l.sw (244|252)\(r\d+\),r\d+',text):
            field_stores.append(dict(offset=hex(a),instruction=text))
    assert [int(r['offset'],16) for r in field_stores]==[0x163448,0x164F20,0x164FB4,0x17918C]
    opaque={
      0x1A1814:0xF0030C0B,0x1A1818:0xF003240B,0x1A181C:0xF0000089,
      0x1A1824:0xF1600C0C,0x1A1828:0xF0000089,
      0x1A1830:0xF160240C,0x1A1834:0xF0000089,
      0x1A1844:0xF0045812,0x1A1848:0xF0000089,
      0x1A1850:0xF003200B,0x1A1854:0xF0000089,
      0x1A185C:0xF160200C,0x1A1860:0xF0000089,
      0x1A1868:0xF003180B,0x1A186C:0xF0000089,0x1A1870:0xF0041C0B,0x1A1874:0xF0000089,
      0x1A187C:0xF003180B,0x1A1880:0xF0000089,0x1A1884:0xF1601C0C,0x1A1888:0xF0000089,
      0x178460:0xF000200D,0x178464:0xF0000089,
      0x178528:0xFD80D887,0x17852C:0xF0000049,
      0x163C80:0xF3C80008,0x163C84:0xF0000049,
      0x164F80:0xF3C80008,0x164F84:0xF0000049}
    for a,w in opaque.items(): assert word(a)==w and ins(a) is None,(hex(a),hex(word(a)))
    diagnostics=[]
    for off,xref,text in (
      (0x2B5EE0,0x178784,'ENG0: eng0_init_h264()\n'),
      (0x2B5EA4,0x178770,'cin_bitcnt load from smem to cmem: strmtp=%d, sbase=0x%.8x\n'),
      (0x2B5FBF,0x178BB4,'ENG0: === eng0_h264enc_lowdelay_ex_code_send2dram(): (bs_base+bs_offset)=0x%08x bs_size=%d value_write_to_dram=0x%08x dram_address=0x%08x\n'),
      (0x2B27B2,0x164150,'ENG0: cin_bitcnt backup from cmem to smem: strmtp=%d, sbase=0x%.8x\n'),
      (0x2B27F6,0x164168,'ENG0: cin_bitcnt(backup)=%d\n'),
      (0x2B604A,0x178FBC,'ENG0: CABAC_DATA_ID %d \n'),
      (0x2B6063,0x178FE0,'ENG0: CABAC_BITS    %d \n')):
        assert binary[off:binary.index(0,off)].decode()==text
        assert ins(xref)=='l.movhi r3,0x8b'
        assert ins(xref+4)==f'l.ori r3,r3,{hex(off&0xffff)}'
        diagnostics.append(dict(offset=hex(off),xref=hex(xref),text=text))
    bounds=[(0x16325C,0x163280),(0x1632F4,0x163450),(0x1636AC,0x163748),
            (0x163C50,0x163C98),(0x164128,0x164188),(0x164EC8,0x165004),
            (0x1650B4,0x1650CC),(0x178388,0x17843C),(0x17845C,0x178654),
            (0x178648,0x1787B4),(0x178B2C,0x178BE0),(0x178ED8,0x178F24),
            (0x178F64,0x1790E4),(0x17917C,0x179198),(0x1A1814,0x1A1890)]
    windows=[dict(begin=hex(lo),end_exclusive=hex(hi),sha256=sha(binary[lo:hi]),
                  instructions=[dict(offset=hex(a),word=hex(word(a)),core=ins(a)) for a in range(lo,hi,4)])
             for lo,hi in bounds]
    result=dict(evidence_type='Pinned original core instructions, literal diagnostics and aligned direct-call encodings; no ORC execution or opcode inference',
      dsp_sha256=DSP_SHA,reference_sha256=REF_SHA,orc_member_sha256=sha(binary),orc_member_bytes=len(binary),
      core_assertion_count=len(checks),core_assertions=checks,
      direct_call_inventory={hex(k):[hex(a) for a in v] for k,v in actual.items()},
      inventory_scope='Every 4-byte-aligned word in the entire member, including data; not a reachability/indirect-call proof',
      field_store_inventory=field_stores,field_store_inventory_scope='core-decodable immediate SW +F4/+FC in [162000,17A000); base-object identity separately constrained at pinned sites',
      opaque_words=[dict(offset=hex(a),word=hex(w)) for a,w in opaque.items()],
      opaque_word_count=len(opaque),diagnostics=diagnostics,windows=windows,
      conclusions=[
        'H264 generic getter forwards 1A1830 return unchanged; all three direct getter call encodings are inventoried.',
        'The first-slice header snapshot at picture+FC follows SPS/PPS output calls and precedes slice-header output; the same picture is passed at each common output call.',
        'FinalBS snapshots the getter, subtracts four indexed opaque-helper values, and separately computes snapshot-picture+FC-40 for later padding logic.',
        'Final picture+F4 is assigned another generic getter result, without a visible immediate subtraction at that store.',
        'Zero-input opaque wrappers occur in one conditional initialization branch; the alternate path loads a saved cin_bitcnt value via 13010.',
        'Configured write offset is packed before inline opaque instructions, while reported descriptor start later uses bits base plus write offset. Hardware destination semantics are unresolved.'
      ],limitations=[
        '1A1830 F160240C/F0000089 is deliberately uninterpreted; no absolute/per-picture counter semantics or hardware reset is proved.',
        'Zero arguments do not prove a reset; the first-initialization branch does not establish a reset before every frame or slice.',
        'Common output helper and source-level ordering do not establish common hardware base/offset, cache completion or contiguous NAL7/8/5 bytes.',
        'Multi-slice code also contains unknown inline instructions and rewrites picture+F4; no aggregation claim is made.',
        'No producer runtime identity, queue, payload, hardware instruction, device access or ORC execution was tested.'
      ],device_access=False)
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),core_assertions=len(checks),opaque_words=len(opaque),
                          direct_targets=len(actual),direct_calls=sum(map(len,actual.values())),diagnostics=len(diagnostics),windows=len(windows))))


if __name__=='__main__': main()
