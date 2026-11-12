#!/usr/bin/env python3
"""Pinned offline GUI reachability and voice model container evidence.

Runs stock GUI control flow and resource transform in synthetic RAM. All GUI
rendering, timing/readiness, allocator/parser and setter edges are declared
stubs. Never accesses a camera or executes a real voice setting/recognizer.
"""
import hashlib
import json
import math
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
    UC_ARM_REG_R3, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR)

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT = ROOT/'artifacts/device/2026-11-10-voice-gui-resources'
BASE = 0xA0100000
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
SEED = 0x3FBB720F
REGS = (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)


def transform(source):
    seed = SEED
    output = bytearray()
    for offset in range(0, len(source), 4):
        piece = source[offset:offset+4]
        decoded = int.from_bytes(piece, 'little') ^ seed
        seed = (decoded-seed) & 0xFFFFFFFF
        output.extend(decoded.to_bytes(4, 'little')[:len(piece)])
    return bytes(output), seed


def tensors(data):
    count = struct.unpack_from('<I', data)[0]
    cursor, result = 4, []
    for index in range(count):
        name_end = data.index(b':', data.index(b':', cursor)+1)+1
        name = data[cursor:name_end].decode('ascii')
        cursor = name_end
        rank = struct.unpack_from('<I', data, cursor)[0]; cursor += 4
        assert 0 < rank <= 4, (name, rank)
        shape = struct.unpack_from('<'+'I'*rank, data, cursor); cursor += rank*4
        length = math.prod(shape)*4
        assert cursor+length <= len(data)
        result.append(dict(name=name, shape=shape, offset=cursor, bytes=length,
                           sha256=hashlib.sha256(data[cursor:cursor+length]).hexdigest()))
        cursor += length
    assert data[cursor:cursor+8] == b'version:'
    version_length = struct.unpack_from('<I', data, cursor+8)[0]
    version = data[cursor+12:]
    assert len(version) == version_length
    return dict(tensors=result,version=version.decode('ascii'))


def main():
    binary = (ANALYSIS/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(binary).hexdigest() == SHA
    word = lambda address: struct.unpack_from('<I', binary, address-BASE)[0]
    descriptor_table = 0xA06C5470
    voice_descriptor = word(descriptor_table+0x15E*4)
    assert voice_descriptor == 0xA06BD194
    raw = binary[voice_descriptor-BASE:voice_descriptor-BASE+100]
    descriptor = dict(pointer=hex(voice_descriptor), sha256=hashlib.sha256(raw).hexdigest(),
                      group=word(voice_descriptor+0x1C), type=raw[0x21],
                      initial_visible=raw[0x20], x=word(voice_descriptor+0x24),
                      y=word(voice_descriptor+0x28), resource_id=word(voice_descriptor+0x2C),
                      bitmap=word(voice_descriptor+0x30), raw_hex=raw.hex())
    assert (descriptor['group'], descriptor['type'], descriptor['x'], descriptor['y'],
            descriptor['bitmap']) == (26, 4, 133, 110, 0x209)
    members = list(struct.unpack_from('<100H', binary, 0xA06B06D0+26*200-BASE))[2:]
    members = members[:members.index(0)]
    assert members == list(range(0x15C, 0x163))
    uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    uc.mem_map(0xA0000000, 0x02000000); uc.mem_write(BASE, binary)
    uc.mem_map(0x70000000, 0x400000)
    put = lambda at, value: uc.mem_write(at, struct.pack('<I', value & 0xFFFFFFFF))
    get = lambda at: struct.unpack('<I', uc.mem_read(at, 4))[0]
    byte = lambda at, value: uc.mem_write(at, bytes([value]))
    state = {}
    end, callback = 0x70008000, 0x70007000
    functions = json.loads((ANALYSIS/'full/functions.json').read_text())
    lookup = {int(f['entry'],16): f for f in functions}
    ranges = {entry:[tuple(int(x,16) for x in span.split('-'))
                     for span in function['body_ranges']]
              for entry,function in lookup.items()}

    def ret(value):
        lr = uc.reg_read(UC_ARM_REG_LR)
        uc.reg_write(UC_ARM_REG_R0, value & 0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_CPSR, (uc.reg_read(UC_ARM_REG_CPSR)&~32)|((lr&1)<<5))
        uc.reg_write(UC_ARM_REG_PC, lr&~1)

    neutral = {0xA02A70EC, 0xA01FFC74, 0xA0130EC8, 0xA02027B0, 0xA0131504,
               0xA0134EA4, 0xA03BC714, 0xA02A819C}
    def hook(machine, address, size, user):
        args = [machine.reg_read(reg) for reg in REGS]
        value = None
        if address == 0xA01881F4:
            put(args[0], 0x70000200); put(0x70000200, 0); value = 0
        elif address == 0xA016ACB8:
            value = state.get('enabled', 0)
        elif address == 0xA011F084:
            value = state.get('recording', 0)
        elif address == 0xA011F0C8:
            value = state.get('capturing', 0)
        elif address == 0xA0121B80:
            value = 0
        elif address == 0xA0201DC8:
            state['bitmap_updates'].append(args[:3]); value = 0
        elif address in (0xA02022C8, 0xA02025C4) and not state.get('real_draw', False):
            state['visibility'].append(dict(show=address == 0xA02022C8, object=args[1])); value = 0
        elif address == 0xA01321C0 and state.get('stub_group', False):
            state['groups'].append(args[:3]); value = 0
        elif address == 0xA012FB64:
            value = state.get('touch_too_fast', 0)
        elif address == 0xA0199954:
            value = state.get('slide_block', 0)
        elif address == 0xA011FC54:
            value = state.get('touch_block', 0)
        elif address == 0xA016AD30:
            state['setter_arguments'].append(args[0]); value = state.get('setter_return', 0)
        elif address == callback:
            state['render_callbacks'].append(args[:3]); value = 0
        elif address == 0xA04F8DEC:
            machine.mem_write(args[0], bytes([args[1]&255])*args[2]); value = args[0]
        elif address == 0xA029C680:
            machine.mem_write(args[0], bytes(machine.mem_read(args[1],args[2]))); value = args[0]
        elif address == 0xA04EC7D8:
            # std::vector<uint8_t> first growth, preallocate whole fixture.
            assert get(args[0]) == 0
            begin = 0x70100000
            machine.mem_write(begin, bytes(machine.mem_read(args[1],1)))
            put(args[0], begin); put(args[0]+4, begin+1); put(args[0]+8, begin+0x40000)
            value = 0
        elif address == 0xA04ECD1C:
            state['decoded'] = bytes(machine.mem_read(args[1],args[2])); value = 0
        elif address == 0xA02A8104:
            assert args[0] == 0x6DC4
            value = 0x70200000
        elif address == 0xA04CAA78:
            sp = machine.reg_read(UC_ARM_REG_SP)
            state['constructor_arguments'] = args+[get(sp+i*4) for i in range(16)]
            value = 0
        elif address in neutral:
            value = 0
        if value is not None:
            ret(value)
        else:
            assert any(low <= address <= high for low,high in state['real_ranges']), hex(address)
    uc.hook_add(UC_HOOK_CODE, hook)

    def run(entry, args, real=(), stack_args=(), **options):
        state.clear(); state.update(real={entry,*real}, bitmap_updates=[], visibility=[], groups=[],
            setter_arguments=[], render_callbacks=[], **options)
        state['real_ranges'] = [span for f in state['real'] for span in ranges[f]]
        for reg,value in zip(REGS,list(args)+[0]*(4-len(args))): uc.reg_write(reg,value)
        uc.reg_write(UC_ARM_REG_CPSR, 0x10)
        uc.reg_write(UC_ARM_REG_SP,0x703FF000); uc.reg_write(UC_ARM_REG_LR,end)
        for index,value in enumerate(stack_args): put(0x703FF000+index*4,value)
        uc.emu_start(entry,end,count=6000000)
        assert uc.reg_read(UC_ARM_REG_PC)==end
        assert uc.reg_read(UC_ARM_REG_SP)==0x703FF000
        result = {key:value for key,value in state.items()
                  if key not in ('real','real_ranges','decoded')}
        result['return'] = uc.reg_read(UC_ARM_REG_R0)
        return result

    # Ordinary group drawing, with renderer IO/readiness/getter dependencies stubbed.
    group_cases = []
    put(0xA1055CD4,0x70001000)
    for enabled in (0,1):
        for recording,capturing in ((0,0),(1,0),(0,1)):
            put(0xA06D44D4,0x1B); byte(0xA1055D82,1)
            result=run(0xA01321C0,(26,0,0),enabled=enabled,recording=recording,capturing=capturing)
            updates=[u for u in result['bitmap_updates'] if u[1]==0x15E]
            expected=0x208 if recording or capturing else 0x20A if enabled else 0x209
            assert updates==[[2,0x15E,expected]]
            assert any(v['show'] and v['object']==0x15E for v in result['visibility'])
            group_cases.append(result)

    # Ordinary swipe: current group6 / 0x1B, gesture4, last coordinate <180.
    gesture_cases=[]
    byte(0xA1055D06,1); byte(0xA1055D84,0)
    for group,popup,y,blocked in ((6,0,100,0),(27,0,100,0),(6,12,100,0),
                                (6,0,180,0),(6,0,100,1)):
        put(0xA06D44D4,group); put(0xA1055D14,popup)
        result=run(0xA013D7D0,(group,0,4,100),stack_args=(y,),stub_group=True,slide_block=blocked)
        expected=group in (6,27) and popup!=12 and y<180 and not blocked
        assert bool(result['groups'])==expected
        if expected: assert result['groups']==[[26,0,0]]
        gesture_cases.append(dict(group=group,popup=popup,y=y,blocked=blocked,**result))

    # Click reaches normal setter stub; never execute persistent setter or bypass.
    click_cases=[]
    for enabled in (0,1):
        for recording,capturing,too_fast in ((0,0,0),(1,0,0),(0,1,0),(0,0,1)):
            byte(0xA0FBC191,enabled); put(0xA1055D14,0)
            result=run(0xA0138F84,(26,0x15E,0,0),stack_args=(1,),stub_group=True,
                       recording=recording,capturing=capturing,touch_too_fast=too_fast)
            expected=[] if recording or capturing or too_fast else [1-enabled]
            assert result['setter_arguments']==expected
            click_cases.append(dict(enabled=enabled,**result))

    # Real generic object creation/show, with synthetic valid bitmap metadata.
    context,canvas,resource=0xA06D42E4,0x70010000,0x70003000
    put(context+8,descriptor_table);put(context+0xD8,canvas);put(context+0xE0,resource)
    byte(context,1);put(context+0xB4,callback);put(context+0xBC,callback)
    put(resource+0x40,0);put(resource+0x44,0x400);put(resource+0x48,resource+0x4C)
    real_draw=(0xA0200350,0xA01FFB20,0xA01F9FB8)
    creation=run(0xA02022C8,(2,0x15E),real=real_draw,real_draw=True)
    assert creation['return']==0 and len(creation['render_callbacks'])==2
    assert bytes(uc.mem_read(canvas+0x15E*0xA8+0x5C,1))==b'\1'
    assert get(canvas+0x15E*0xA8+0x98)==voice_descriptor+0x24

    # Decode both embedded model stages. Container boundaries come from linked
    # size words/GOT arguments, never guessed from arbitrary printable output.
    resources=[('en','stage1_graph',0xA0790C60,0xA0791EC4),
       ('en','stage1_weights',0xA0791EC8,0xA079DDE8),
       ('en','stage2_graph',0xA079DDF0,0xA079DDEC),
       ('en','stage2_weights',0xA079F1B4,0xA079F1B0),
       ('zh','stage1_graph',0xA07BA43C,0xA07BB6A0),
       ('zh','stage1_weights',0xA07BB6A8,0xA07BB6A4),
       ('zh','stage2_graph',0xA07C75C8,0xA07C75C4),
       ('zh','stage2_weights',0xA07C8988,0xA07E3C10)]
    # Execute the stock language branch and argument marshaling with allocator
    # and recognizer constructor stubbed before they can run any recognizer.
    got=(word(0xA04CAE80)+0xA04CACE8)&0xFFFFFFFF
    language_flag=word(got+word(0xA04CAE84))
    constructor_cases=[]
    for language,flag in (('en',0),('zh',1)):
        put(language_flag,flag)
        result=run(0xA04CACD0,())
        a=result['constructor_arguments']
        expected=[r for r in resources if r[0]==language]
        pairs=[(a[1],a[2]),(a[3],a[4]),(a[10],a[11]),(a[12],a[13])]
        assert pairs==[(r[2],word(r[3])) for r in expected], (language,pairs)
        constructor_cases.append(dict(language=language,flag=flag,arguments=a))
    model_report=[];decoded_files={}
    for language,kind,address,size_address in resources:
        size=word(size_address);encoded=binary[address-BASE:address-BASE+size]
        decoded,final_seed=transform(encoded)
        ctx=0x70200000;put(ctx+0x3694,SEED)
        run(0xA04F0048,(ctx,address,size))
        assert state['decoded']==decoded, (language,kind,len(state['decoded']),size,
            next(((i,a,b) for i,(a,b) in enumerate(zip(state['decoded'],decoded)) if a!=b),None))
        # The stock partial-word memcpy leaves unused high stack bytes intact.
        # Only the emitted byte lanes and corresponding seed bits are defined.
        seed_mask = (1 << ((size%4 or 4)*8))-1
        assert get(ctx+0x3694)&seed_mask == final_seed&seed_mask
        suffix='txt' if kind.endswith('graph') else 'bin'
        name=f'{language}-{kind}.{suffix}';decoded_files[name]=decoded
        item=dict(language=language,kind=kind,address=hex(address),size_address=hex(size_address),
                  bytes=size,encoded_sha256=hashlib.sha256(encoded).hexdigest(),
                  decoded_sha256=hashlib.sha256(decoded).hexdigest(),file=name,
                  real_arm_transform_equal=True,final_seed_defined_mask=hex(seed_mask),
                  final_seed_defined_bits=hex(final_seed&seed_mask))
        if kind.endswith('graph'):
            text=decoded.decode('ascii')
            lines=[line for line in text.splitlines() if line.strip() and not line.startswith('#')]
            item['graph_lines']=lines
            assert lines[0] == ('AudioNIN,100,1,13' if kind=='stage1_graph' else 'AudioNIN,198,1,13')
        else:
            item.update(tensors(decoded))
        item['phrase_search']={phrase:{encoding:decoded.find(phrase.encode(encoding))
                            for encoding in ('utf-8','utf-16le')} for phrase in
                            ('开始录像','开始录影','小蚁开始录像','start recording',
                             'begin recording','Yi action begin recording')}
        model_report.append(item)

    # Code fingerprints and focused known-instruction ranges avoid treating
    # embedded ARM jump tables as executable instructions.
    selected=[0xA0181ED0,0xA01816C4,0xA0201748,0xA02022C8,0xA02025C4,
              0xA0200350,0xA01FFB20,0xA01F9FB8,0xA01321C0,0xA013D7D0,
              0xA0138F84,0xA012FB64,0xA01C682C,0xA01C7844,0xA04F48D4,
              0xA04F0048,0xA04E839C,0xA04E81A4,0xA04CACD0]
    fingerprints=[]
    for entry in selected:
        function=lookup[entry];parts=[]
        for span in function['body_ranges']:
            low,high=[int(x,16) for x in span.split('-')];parts.append(binary[low-BASE:high-BASE+1])
        fingerprints.append(dict(entry=hex(entry),spans=function['body_ranges'],
                            sha256=hashlib.sha256(b''.join(parts)).hexdigest()))
    pins={0xA04F4A5C:'0f1207e3',0xA04F4A68:'bb1f43e3',0xA04F4A88:'941684e5'}
    for address,expected in pins.items():
        assert binary[address-BASE:address-BASE+4].hex()==expected
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    windows={}
    for label,low,high in [('bitmap_create',0xA0200350,0xA0200508),
            ('resource_transform',0xA04F0048,0xA04F0158),
            ('voice_click',0xA01391A4,0xA01391D8)]:
        windows[label]=[dict(address=hex(i.address),bytes=bytes(i.bytes).hex(),
                       instruction=i.mnemonic+' '+i.op_str)
                       for i in md.disasm(binary[low-BASE:high-BASE],low)]
    report=dict(image_sha256=SHA,group_table_address=hex(0xA06B06D0+26*200),
                group_members=[hex(m) for m in members],descriptor=descriptor,
                synthetic_group_cases=group_cases,synthetic_gesture_cases=gesture_cases,
                synthetic_click_cases=click_cases,synthetic_bitmap_creation=creation,
                models=model_report,synthetic_language_constructor=constructor_cases,
                seed_instruction_pins={hex(a):b for a,b in pins.items()},
                function_fingerprints=fingerprints,instruction_windows=windows,
                limitations=['No target access or write; normal setting edges are stubbed before persistence.',
                 'Synthetic bitmap metadata replaces uncaptured device bitmap cache/ROMFS; no display pixels or physical touch hitbox proven.',
                 'Model transform verified against stock ARM with vector allocation/parser stubbed; no classifier execution or inferred exact spoken phrase.',
                 'Two decoded neural topology files per language and float tensors contain no readable target command dictionary.'],
                device_access=False,device_write=False,exact_phrases_verified=False)
    OUT.mkdir(parents=True,exist_ok=True)
    for name,contents in decoded_files.items():(OUT/name).write_bytes(contents)
    (OUT/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(f'PASS: descriptor+7 group members; {len(group_cases)} group, {len(gesture_cases)} swipe, '
          f'{len(click_cases)} click, real creation; {len(model_report)} real-ARM model transforms; no target access')


if __name__=='__main__':main()
