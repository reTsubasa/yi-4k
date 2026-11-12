#!/usr/bin/env python3
"""Offline DSP bits_info -> ARM FrameDesc contract. No device or ORC execution."""
import hashlib
import importlib.util
import json
import re
import struct
from pathlib import Path
import capstone
from unicorn.arm_const import UC_ARM_REG_R4, UC_ARM_REG_R5
from audit_eis_orc_core import DSP, REF, DSP_SHA, REF_SHA, CoreDecoder
from audit_eis_dsp_reference import inventory
import audit_prerecord_video_pts as arm

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-dsp-framedesc-contract-audit.json'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def core_slice(ins, begin, stops, registers, memory, delayed=False):
    """Bounded host interpretation only. Call/extension encodings rejected."""
    regs = [0]*32
    for r,v in registers.items(): regs[r]=v
    flag,pc=False,begin
    path=[]
    def ordinary(text):
        nonlocal flag
        if m:=re.fullmatch(r'l.(lwz|lbz) r(\d+),(-?\d+)\(r(\d+)\)',text):
            op,rd,off,ra=m.groups();regs[int(rd)]=memory[regs[int(ra)]+int(off)]&(255 if op=='lbz' else 0xffffffff)
        elif m:=re.fullmatch(r'l.(sw|sb) (-?\d+)\(r(\d+)\),r(\d+)',text):
            op,off,ra,rb=m.groups();memory[regs[int(ra)]+int(off)]=regs[int(rb)]&(255 if op=='sb' else 0xffffffff)
        elif m:=re.fullmatch(r'l.(andi|ori|addi|srli|slli) r(\d+),r(\d+),(-?\d+|0x[0-9a-f]+)',text):
            op,rd,ra,value=m.groups();a=regs[int(ra)];v=int(value,0)
            regs[int(rd)]={'andi':lambda:a&v,'ori':lambda:a|v,'addi':lambda:a+v,
                           'srli':lambda:a>>v,'slli':lambda:a<<v}[op]()&0xffffffff
        elif m:=re.fullmatch(r'l.(add|sub|and|or) r(\d+),r(\d+),r(\d+)',text):
            op,rd,ra,rb=m.groups();a,b=regs[int(ra)],regs[int(rb)]
            regs[int(rd)]={'add':lambda:a+b,'sub':lambda:a-b,'and':lambda:a&b,'or':lambda:a|b}[op]()&0xffffffff
        elif m:=re.fullmatch(r'l.sf(eq|ne)i r(\d+),(\d+)',text):
            op,ra,v=m.groups();flag=(regs[int(ra)]==int(v))==(op=='eq')
        else:raise AssertionError(('unsupported bounded slice',text))
    for _ in range(100):
        if pc in stops:return regs,memory,path
        text=ins(pc);path.append(hex(pc))
        branch=re.fullmatch(r'l.b(f|nf) (0x[0-9a-f]+)',text)
        jump=re.fullmatch(r'l.j (0x[0-9a-f]+)',text)
        if branch or jump:
            if branch:
                kind,target=branch.groups();taken=flag if kind=='f' else not flag
            else:target,taken=jump.group(1),True
            if delayed:ordinary(ins(pc+4));path.append(hex(pc+4))
            pc=int(target,16) if taken else pc+(8 if delayed else 4)
        else:ordinary(text);pc+=4
    raise AssertionError('bounded slice did not stop')


def main():
    dsp,reference=DSP.read_bytes(),REF.read_bytes()
    assert sha(dsp)==DSP_SHA and sha(reference)==REF_SHA
    member=inventory(dsp)[0];start=int(member['offset'],16);binary=dsp[start:start+member['bytes']]
    decoder=CoreDecoder(reference.decode())
    def word(a):return struct.unpack_from('<I',binary,a)[0]
    def ins(a):return decoder.decode(word(a),a)
    expected={
      0x163D70:'l.lwz r4,32(r14)',0x163D7C:'l.andi r27,r29,0x3',
      0x163D80:'l.sfnei r27,2',0x163D84:'l.bf 0x163db0',
      0x163D88:'l.lwz r5,16(r14)',0x163D94:'l.sfnei r31,1',
      0x163D9C:'l.srli r8,r4,7',0x163DA0:'l.andi r6,r8,0x1',
      0x163DA8:'l.bf 0x163db0',0x163DAC:'l.addi r10,r0,1',
      0x163DB4:'l.addi r24,r2,-64',0x163DC4:'l.addi r5,r0,64',
      0x163DC8:'l.jal 0x98c10',0x163DF8:'l.sfnei r10,0',
      0x163DFC:'l.bf 0x164424',0x163E00:'l.lwz r8,32(r14)',
      0x163E10:'l.bf 0x16441c',0x163E1C:'l.addi r4,r0,3',
      0x163E20:'l.lwz r17,-44(r2)',0x163E24:'l.addi r19,r0,-8',
      0x163E28:'l.and r3,r17,r19',0x163E30:'l.or r5,r3,r4',
      0x163E38:'l.sw -44(r2),r5',
      0x164414:'l.addi r4,r0,4',0x16441C:'l.addi r4,r0,2',
      0x164424:'l.lwz r8,32(r14)',0x164428:'l.addi r4,r0,1',
      0x16442C:'l.j 0x163e20',
      0x163CEC:'l.lwz r13,244(r3)',0x163CF8:'l.lwz r11,76(r4)',
      0x163CFC:'l.addi r12,r13,7',0x163D04:'l.lwz r9,20(r11)',
      0x163D08:'l.srli r22,r12,3',0x163D10:'l.lwz r10,12(r11)',
      0x163D1C:'l.add r12,r10,r9',0x163D20:'l.jal 0x1636ac',
      0x163F18:'l.srli r4,r8,26',0x163F1C:'l.andi r8,r4,0x3',
      0x163F20:'l.sfeqi r8,1',0x163F24:'l.bf 0x164394',
      0x163F28:'l.sw -48(r2),r12',0x163F2C:'l.sw -40(r2),r22',
      0x164394:'l.lwz r9,88(r14)',0x164398:'l.movhi r17,0xff',
      0x16439C:'l.ori r17,r17,0xffff',0x1643A0:'l.lwz r19,84(r14)',
      0x1643A4:'l.and r12,r9,r17',0x1643A8:'l.sw -48(r2),r19',
      0x1643AC:'l.sw -40(r2),r12',
      0x163F94:'l.lwz r31,76(r16)',0x163F98:'l.ori r4,r24,0x0',
      0x163F9C:'l.addi r5,r0,64',0x163FA0:'l.lwz r24,36(r31)',
      0x163FA4:'l.lwz r27,32(r31)',0x163FA8:'l.ori r3,r24,0x0',
      0x163FAC:'l.lwz r29,24(r31)',0x163FB0:'l.add r12,r29,r27',
      0x163FB4:'l.jal 0x1a14d8',0x163FB8:'l.ori r4,r24,0x0',
      0x163FBC:'l.ori r3,r12,0x0',0x163FC0:'l.addi r5,r0,64',
      0x163FC4:'l.jal 0x1a4a04',
      0x164454:'l.addi r24,r2,-64',0x164458:'l.addi r4,r0,-1',
      0x164460:'l.addi r5,r0,64',0x164464:'l.jal 0x98c10',
      0x1644A8:'l.ori r4,r13,0x1',0x1644AC:'l.sw -44(r2),r4',
      0x1640A4:'l.lwz r7,20(r4)',0x1640A8:'l.lwz r31,16(r4)',
      0x1640AC:'l.add r27,r7,r15',0x1640B0:'l.divu r29,r27,r31',
      0x1640B8:'l.sub r30,r27,r12',0x1640BC:'l.sw 20(r4),r30',
      0x179184:'l.jal 0x1636ac',0x17918C:'l.sw 244(r16),r11',
      0x163724:'l.jal 0x1a1830',0x163728:'l.ori r10,r11,0x0',
      0x1A4B80:'l.movhi r3,0x8c',0x1A4B84:'l.ori r3,r3,0x2579',
      0x163798:'l.movhi r8,0x8200',0x16379C:'l.ori r8,r8,0x1',
      0x1637A4:'l.sw 0(r12),r8',0x1637B8:'l.sw 4(r12),r7',
      0x1637C4:'l.sw 12(r12),r6',0x1637D0:'l.sw 16(r12),r4',
    }
    checks=[]
    for a,text in expected.items():
        assert ins(a)==text,(hex(a),ins(a),text)
        checks.append(dict(offset=hex(a),word=hex(word(a)),instruction=text))
    diag=binary[0x2C2579:binary.index(0,0x2C2579)].decode()
    assert diag=='smem_2_dram(), size is not multiple of 4 (%d)\n'
    classes=[]
    for raw in range(256):
        d=int(raw&0xB0==0xA0);mem={0x1020:raw,0x2000-44:0xa5a5a5a5}
        regs,out,path=core_slice(ins,0x163DF8,{0x163E3C},{10:d,14:0x1000,2:0x2000},mem)
        typ=out[0x2000-44]&7;c=raw>>4&3
        expected_type=1 if d else (2 if c==2 else 3 if c==0 else 4)
        assert typ==expected_type and (typ==1)==bool(d)
        # IDR assignment is also invariant under a conventional one-slot model.
        if d:
            _,delayed,_=core_slice(ins,0x163DF8,{0x163E3C},
                                   {10:d,14:0x1000,2:0x2000},dict(mem),True)
            assert delayed[0x2000-44]&7==1
        classes.append(dict(constructed_picture_0x20_low_byte=raw,idr_predicate=bool(d),
                            raw_bits_info_type=typ,non_delayed_core_interpretation=True,
                            idr_assignment_agrees_with_one_slot_model=bool(d)))
    arithmetic=[]
    for bit_count,offset in ((1,0),(8,64),(511,0xff80),(512,0xffc0),(513,0xffc0),(12345,0x1234)):
        mem={0x1000+244:bit_count,0x3000+76:0x4000,0x4000+20:offset,0x4000+12:0x20000000}
        regs,_,_=core_slice(ins,0x163CEC,{0x163D20},{3:0x1000,4:0x3000,5:1,6:0},mem)
        assert regs[22]==(bit_count+7)//8 and regs[12]==0x20000000+offset
        arithmetic.append(dict(constructed_bit_count=bit_count,constructed_bits_offset=offset,
                               reported_start=hex(regs[12]),reported_length=regs[22]))

    image=arm.IMAGE.read_bytes();assert sha(image)==arm.DIGEST
    md=capstone.Cs(capstone.CS_ARCH_ARM,capstone.CS_MODE_ARM)
    arm_expected={0xA02CA9B0:('ldr','r0, [fp, #0x10]'),0xA02CA9B4:('bl','#0xa04a3bd4'),
      0xA02CA9B8:('ldrb','r3, [fp, #0x14]'),0xA02CA9D0:('and','r3, r3, #7'),
      0xA02CA9D4:('str','r3, [sp, #0x3c]'),0xA02CA9E4:('str','r2, [sp, #0x44]'),
      0xA046CB2C:('ldr','r2, [r4, #0x1c]'),0xA046CB38:('strb','r2, [sp, #0x20]'),
      0xA046CB68:('ldr','r2, [r4, #0x18]'),0xA046CB78:('str','r2, [sp, #0x24]'),
      0xA046CB7C:('bl','#0xa0452254'),
      0xA04607A4:('ldr','r3, [r5, #0x24]'),0xA04607A8:('cmn','r3, #1'),
      0xA04607C0:('mvn','r3, #0xff000000'),0xA04607C4:('str','r3, [r5, #0x24]')}
    arm_checks=[]
    for a,pair in arm_expected.items():
        i=next(md.disasm(image[a-arm.BASE:a-arm.BASE+4],a));assert (i.mnemonic,i.op_str)==pair
        arm_checks.append(dict(address=hex(a),mnemonic=i.mnemonic,operands=i.op_str))
    arm_cases=[]
    for kind,flag,size,index in ((1,0,4096,0),(1,1,9000,1023),(2,1,64,1),(3,0,1,2),(4,1,65537,3),
                                  (1,1,0xffffffff,4)):
        m=arm.machine(image);ring,cursor=0xA06890E0,0xA1458568;record=ring+index*64
        arm.put(m,cursor,index);arm.put(m,arm.STATE+0xc,0xffff0000)
        arm.put(m,record,1,1);arm.put(m,record+1,0x11,1);arm.put(m,record+4,123)
        arm.put(m,record+8,1001,8);arm.put(m,record+0x10,0x20000100)
        arm.put(m,record+0x14,kind|(flag<<7));arm.put(m,record+0x18,size)
        m.reg_write(arm.UC_ARM_REG_R7,ring);m.reg_write(arm.UC_ARM_REG_SB,cursor);m.reg_write(arm.UC_ARM_REG_R8,arm.STATE)
        arm.run(m,0xA02CA950,0xA02CA9F8);event=m.reg_read(arm.UC_ARM_REG_R1)
        assert arm.get(m,event+0x1c)==kind and arm.get(m,event+0x20)==flag
        address=arm.get(m,event+0x18);assert arm.get(m,event+0x24)==size
        desc=None
        if size!=0xffffffff:
            m.mem_write(arm.EVENT,bytes(m.mem_read(event,48)));m.reg_write(arm.UC_ARM_REG_SP,arm.STACK)
            m.reg_write(arm.UC_ARM_REG_R0,0);m.reg_write(arm.UC_ARM_REG_R1,0x1f);m.reg_write(arm.UC_ARM_REG_R2,arm.EVENT)
            arm.run(m,0xA046CA94,0xA046CB7C);desc=m.reg_read(arm.UC_ARM_REG_R1)
            assert arm.get(m,desc+0x10,1)==kind and arm.get(m,desc+0x11,1)==1
            assert arm.get(m,desc+0x14)==address and arm.get(m,desc+0x18)==size
        arm_cases.append(dict(raw_type=kind,raw_flag_bit7=flag,raw_payload_length=size,
                              ring_index=index,next_index=arm.get(m,cursor),event_type=kind,
                              translated_address=hex(address),frame_desc_callback_executed=desc is not None,
                              stopped_before_event_dispatch_and_fifo_write=True))
    m=arm.machine(image);arm.put(m,arm.EVENT+0x24,0xffffffff)
    m.reg_write(UC_ARM_REG_R5,arm.EVENT);m.reg_write(UC_ARM_REG_R4,0)
    arm.run(m,0xA04607A4,0xA04607C8)
    assert arm.get(m,arm.EVENT+0x24)==0x00ffffff
    arm_cases.append(dict(operation='original_bitsmgr_eos_normalization_slice',
                          input_length='0xffffffff',output_length='0x00ffffff',
                          skipped_mutex_and_stopped_before_copy_callback=True))
    windows=[(0x163CEC,0x163DF8),(0x163DF8,0x163E3C),(0x163F18,0x163FD0),
             (0x164394,0x1643B4),(0x164404,0x164454),(0x164454,0x1644B4),
             (0x16409C,0x1640DC),(0x17917C,0x179190),(0x1636AC,0x163748),
             (0x1A4B74,0x1A4B90)]
    regions=[]
    for lo,hi in windows:
        rows=[dict(offset=hex(a),word=hex(word(a)),instruction=ins(a)) for a in range(lo,hi,4)]
        regions.append(dict(begin=hex(lo),end_exclusive=hex(hi),sha256=sha(binary[lo:hi]),instructions=rows))
    counter_unknown=[]
    for address,value in ((0x1A1830,0xF160240C),(0x1A1834,0xF0000089)):
        assert word(address)==value and ins(address) is None
        counter_unknown.append(dict(offset=hex(address),raw_word=hex(value)))
    result=dict(evidence_type='Pinned static DSP producer fields and bounded host interpretations plus original ARM slices with constructed RAM',
      dsp_sha256=DSP_SHA,orccode_sha256=sha(binary),reference_sha256=REF_SHA,arm_image_sha256=arm.DIGEST,
      orc_assertions=checks,orc_assertion_count=len(checks),arm_assertions=arm_checks,
      classification_interpretations=classes,classification_interpretation_count=len(classes),
      ordinary_payload_accounting=arithmetic,arm_execution_cases=arm_cases,arm_execution_case_count=len(arm_cases),
      regions=regions,smem_to_dram_diagnostic=diag,unsupported_counter_getter_words=counter_unknown,
      conclusions=['Normal-state H264 bits_info type1 is selected by exactly the C2/R1 predicate that selects slice NAL5 and the SPS/PPS production path.',
                   'ARM masks bits_info+0x14 low3 and forwards it unchanged to FrameDesc+0x10; ordinary payload start/length also forward after stock address translation.',
                   'The stock non-normal-state sentinel path also emits type1 with lengthFFFFFFFF; high-level BitsMgr normalizes its length to00FFFFFF.',
                   'Ordinary bits_info start is configured bits base+current write offset; length is ceil(picture+F4 bits/8). A separate property mode overrides them from picture+54/+58 low24.',
                   'The64-byte descriptor is staged then submitted to the original smem_2_dram helper and ring-info offset advances64 modulo configured info-ring bytes.'],
      limitations=['Type truth table uses explicit non-delayed host interpretation. Only the IDR assignment subset also checked under one-slot branches; full ORC execution model is unresolved.',
                   'No actual queue, DMA, hardware bitcounter, proprietary output opcode or DSP runtime execution occurred.',
                   'The length is a reported counter snapshot; reset/baseline and inclusion of SPS/PPS and slice within a single ring range are not yet proven.',
                   'Property-mode override producer semantics and multi-slice aggregation remain unresolved.',
                   'ARM callbacks stop before FIFO write; full BitsMgr and EOS callback are not executed. Only its original normalization slice is executed separately.',
                   'No safe third-party virtual consumer, payload ownership/release contract or native device execution is established.'],
      device_access=False)
    OUT.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),orc_assertions=len(checks),arm_assertions=len(arm_checks),
                          classification_cases=len(classes),payload_arithmetic_cases=len(arithmetic),arm_execution_cases=len(arm_cases))))


if __name__=='__main__':main()
