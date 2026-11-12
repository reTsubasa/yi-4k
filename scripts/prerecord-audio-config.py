#!/usr/bin/env python3
"""Audit audio configuration provenance and start ordering, host only.

.venv-reverse/bin/python scripts/prerecord-audio-config.py
Original instructions execute only within declared prefixes against synthetic RAM.
No camera access, RTOS calls, firmware patches, or repeated PTS arithmetic tests.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

import capstone
from unicorn import UC_ARCH_ARM, UC_MODE_ARM, Uc
from unicorn.arm_const import (
    UC_ARM_REG_PC, UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
    UC_ARM_REG_R4, UC_ARM_REG_R7, UC_ARM_REG_SP,
)

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE = Path('artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin')
EXPORT = Path('artifacts/device/2026-11-09-linux/rtos-analysis/full')
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
SP = 0x1001F000


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(m, addr, n=4):
    return int.from_bytes(m.mem_read(addr, n), 'little')


def write(m, addr, value, n=4):
    m.mem_write(addr, value.to_bytes(n, 'little'))


def new_machine(image):
    m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    m.mem_map(BASE, (len(image)+4095) & ~4095)
    m.mem_write(BASE, image)
    m.mem_map(0x10000000, 0x20000)
    m.mem_map(0xA19C7000, 0x1000)
    m.reg_write(UC_ARM_REG_SP, SP)
    return m


def run(m, entry, stop):
    m.emu_start(entry, stop, count=100000)
    assert m.reg_read(UC_ARM_REG_PC) == stop


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', type=Path, default=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-audio-config-audit.json')
    args = p.parse_args()
    image = (ROOT/IMAGE).read_bytes()
    assert sha(image) == EXPECTED, 'Wrong image'
    catalog = json.loads((ROOT/EXPORT/'functions.json').read_text())
    functions = {f['entry']:f for f in catalog}
    sources = []
    for entry in [0xA0210894,0xA0189A28,0xA046012C,0xA045F204,0xA021D274,0xA021E464,0xA021E7F8,0xA045BE3C,0xA045C6E8,0xA045DA98,0xA045D390,0xA045DD8C,0xA045D264]:
        f = functions[hex(entry)]
        body = b''
        for interval in f['body_ranges']:
            lo,hi = [int(x,16) for x in interval.split('-')]
            body += image[lo-BASE:hi-BASE+1]
        source = EXPORT/f['decompiled_file']
        sources.append({'entry':hex(entry),'body_ranges_inclusive':f['body_ranges'],'body_sha256':sha(body),'pseudocode_path':str(source),'pseudocode_sha256':sha((ROOT/source).read_bytes())})

    # Retain only the three independently identified selectors; not a guessed table extent.
    rows = []
    for selector in range(3):
        addr = 0xA06D4508+selector*28
        raw = image[addr-BASE:addr-BASE+28]
        fmt,field04,field08,h0c,h0e,x10,x14,x18 = struct.unpack('<IIIHHIII',raw)
        assert field08 == 48000
        rows.append({'selector':selector,'address':hex(addr),'bytes':raw.hex(),'format_word':fmt,'field_04':field04,'field_08_denominator':field08,'halfword_0c':h0c,'halfword_0e':h0e,'codec_words_10_14_18':[x10,x14,x18]})
    results = []
    for selector in range(3):
        for track,entry,stop,setup in [
            ('primary',0xA0210B40,0xA0210B80,SP+0x58),
            ('secondary',0xA021094C,0xA02109D4,SP+0xB4),
        ]:
            m = new_machine(image)
            m.reg_write(UC_ARM_REG_R7, selector)
            m.reg_write(UC_ARM_REG_R4, 0)
            run(m,entry,stop)
            assert read(m,setup+0x10) == rows[selector]['field_04']
            assert read(m,setup+0x14) == rows[selector]['field_08_denominator']
            assert read(m,setup+0x18,2) == rows[selector]['halfword_0c']
            assert read(m,setup+0x1A,2) == rows[selector]['halfword_0e']
            results.append({'name':'table_to_create_config_prefix','track':track,'selector':selector,'entry':hex(entry),'stop_before':hex(stop),'create_config_14':read(m,setup+0x14),'passed':True})

    m = new_machine(image)
    run(m,0xA0210F88,0xA0210FD0)
    assert read(m,SP+0x58+0x14) == 48000
    results.append({'name':'primary_equal_selector_fallback_prefix','entry':'0xa0210f88','stop_before':'0xa0210fd0','table_row':1,'create_config_14':48000,'passed':True})

    m = new_machine(image)
    m.reg_write(UC_ARM_REG_R4, 0)
    m.reg_write(UC_ARM_REG_R7, 0)
    # This alternative app creates config at sp+0xb8; prefix stops before codec branch.
    run(m,0xA0189AE0,0xA0189B14)
    assert read(m,SP+0xB8+0x14) == 48000
    results.append({'name':'alternative_caller_literal_48000_prefix','entry':'0xa0189ae0','stop_before':'0xa0189b14','create_config_14':48000,'passed':True})

    for free_slot in (0,3):
        m = new_machine(image)
        config = 0x10000000
        write(m,config+0x3C,0x10002000)
        write(m,config+0x40,0x10000)
        write(m,config+0x44,0x10003000)
        write(m,config+0x48,0x1000)
        for slot in range(free_slot):
            write(m,0xA19C71A8+slot*0xF0+0xB0,1,1)
        m.reg_write(UC_ARM_REG_R0,config)
        m.reg_write(UC_ARM_REG_R1,0x10004000)
        run(m,0xA045F204,0xA045F328)
        context = 0xA19C7250+free_slot*0xF0
        destination = m.reg_read(UC_ARM_REG_R0)
        assert destination == context+0x4C
        assert m.reg_read(UC_ARM_REG_R1) == config
        assert m.reg_read(UC_ARM_REG_R2) == 0x5C
        assert read(m,context+4) == 0xA078A7BC
        results.append({'name':'create_copy_arguments_prefix','free_slot':free_slot,'entry':'0xa045f204','stop_before':'0xa045f328','context':hex(context),'copy_destination':hex(destination),'copy_size':0x5C,'copy_executed':False,'passed':True})

    expected_instructions = [
        (0xA045C778,'ldr','r0, [r7, #4]!'),
        (0xA045C784,'ldr','r2, [r0, #4]'),
        (0xA045C788,'ldr','r2, [r2, #0x10]'),
        (0xA045C794,'blx','r2'),
        (0xA045C7A0,'blo','#0xa045c778'),
        (0xA045DB5C,'bl','#0xa0290b60'),
        (0xA045DB6C,'bl','#0xa045d390'),
        (0xA045D4D0,'bl','#0xa0290f14'),
        (0xA045D4DC,'ldrb','r2, [r5, #0xa4]'),
        (0xA045D4F8,'bl','#0xa045d264'),
    ]
    c = capstone.Cs(capstone.CS_ARCH_ARM,capstone.CS_MODE_ARM)
    checked = []
    for addr,mnemonic,operands in expected_instructions:
        i = next(c.disasm(image[addr-BASE:addr-BASE+4],addr))
        assert (i.mnemonic,i.op_str) == (mnemonic,operands)
        checked.append({'address':hex(addr),'bytes':bytes(i.bytes).hex(),'mnemonic':mnemonic,'operands':operands})
    vtable = struct.unpack_from('<7I',image,0xA078A7BC-BASE)
    assert vtable[2] == 0xA045DD8C and vtable[4] == 0xA045DA98
    windows = []
    for lo,hi in [(0xA0210B40,0xA0210B80),(0xA021094C,0xA02109D4),(0xA0210F88,0xA0210FD4),(0xA045F2D8,0xA045F32C),(0xA045C768,0xA045C7A4),(0xA045D4C4,0xA045D500)]:
        windows.append({'start':hex(lo),'stop_exclusive':hex(hi),'sha256':sha(image[lo-BASE:hi-BASE]),'instructions':[{'address':hex(i.address),'bytes':bytes(i.bytes).hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in c.disasm(image[lo-BASE:hi-BASE],lo)]})
    report = {'image_path':str(IMAGE),'image_sha256':EXPECTED,'functions_index_sha256':sha((ROOT/EXPORT/'functions.json').read_bytes()),'scope':'Offline synthetic RAM, bounded prefixes only; no RTOS calls, actual memcpy, codec, camera, or A/V capture execution.','sources':sources,'audited_table_rows':rows,'table_stride':28,'audio_vtable':{'address':'0xa078a7bc','words':[hex(x) for x in vtable],'start_liveview_offset_08':hex(vtable[2]),'start_record_offset_10':hex(vtable[4])},'checked_instructions':checked,'instruction_windows':windows,'test_count':len(results),'results':results,'conclusions':['Audited AppLib table selectors 0,1,2 each supply 48000 to create config+0x14 on primary and secondary paths.','Create copies 0x5c bytes to context+0x4c, mapping config+0x14 to context+0x60, and config+0x58 to context+0xa4. Copy call arguments verified; memcpy not executed.','AmpEnc_StartRecord walks pipeline handles in array order, dispatching vtable+0x10. Audio table slot resolves to A045DA98.','Audio record start calls setup, then encoder-task start; starts audio input there only when context+0xa4==0. With nonzero flag, input may already have started during liveview.'],'limitations':['Only identified table selectors 0..2 audited; no assertion of complete enum or table extent.','Static configured 48000 is not live ADC clock measurement.','Pipeline callback call order is not physical capture alignment.','InputTaskStartInLiveView can change whether ADC input precedes record; live flag value unobserved.','No shared audio/video capture epoch proved; no one-minute prerecord implementation or device validation.']}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'output':str(args.output),'prefix_cases_passed':len(results),'instruction_assertions_passed':len(checked),'camera_access':False}))

if __name__ == '__main__':
    main()
