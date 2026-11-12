#!/usr/bin/env python3
"""Pin 1.10.7 mode handlers and execute stock leaf setters in synthetic RAM.

Never contacts a camera. GUI dispatch, preference services and readiness tests
are declared stubs; dispatch is observed, not actual sensor-mode completion.
"""
import hashlib
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE = 0xA0100000
EXPECTED_SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
OUT = ROOT / 'artifacts/device/2026-11-10-camera-mode-apply'


def main():
    data = (ANALYSIS / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(data).hexdigest() == EXPECTED_SHA
    u32 = lambda address: struct.unpack_from('<I', data, address - BASE)[0]
    rows = {}
    for name, address, handler in [('capture_mode', 0xA06A6268, 0xA0157204),
                                   ('system_mode', 0xA06A7078, 0xA0158844),
                                   ('rec_mode', 0xA06A726C, 0xA0158AA8)]:
        # Table key is at record+8; msg2 handler is record+0x60.
        assert data[address-BASE:address-BASE+len(name)+1] == name.encode()+b'\0'
        assert u32(address+0x58) == handler
        rows[name] = {'key_address': hex(address), 'msg2_handler': hex(handler)}

    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    functions = {int(row['entry'], 16): row for row in json.loads((ANALYSIS / 'full/functions.json').read_text())}
    selected = [0xA01649A0, 0xA0158844, 0xA01555C8, 0xA01554BC, 0xA015663C,
                0xA0157204, 0xA014BDD0, 0xA0145E10,
                0xA0158AA8, 0xA014BF24, 0xA0146228]
    sources = []
    assembly = []
    for entry in selected:
        f = functions[entry]
        pieces = []
        for span in f['body_ranges']:
            a, b = [int(value, 16) for value in span.split('-')]
            code = data[a-BASE:b-BASE+1]
            pieces.append(code)
            assembly.extend(f'{i.address:08x}  {i.mnemonic} {i.op_str}' for i in md.disasm(code, a))
        c = ANALYSIS / 'full/decompiled' / f'{entry:08x}.c'
        sources.append({'entry':hex(entry), 'body_ranges':f['body_ranges'],
                        'bytes_sha256':hashlib.sha256(b''.join(pieces)).hexdigest(),
                        'pseudocode_sha256':hashlib.sha256(c.read_bytes()).hexdigest()})
    expected = {0xA0157244:'bl #0xa014bdd0', 0xA0158AD8:'bl #0xa014bf24',
                0xA0145F24:'movt r0, #0xd809', 0xA0145F30:'blx r3',
                0xA01462B4:'movt r0, #0xd809', 0xA01462C0:'blx r3'}
    for address, wanted in expected.items():
        i = next(md.disasm(data[address-BASE:address-BASE+4], address))
        assert f'{i.mnemonic} {i.op_str}' == wanted

    machine = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    machine.mem_map(BASE, (len(data)+4095)&~4095)
    machine.mem_write(BASE, data)
    machine.mem_map(0xA1055000, 0x2000)
    machine.mem_map(0x70000000, 0x4000)
    arg, result, prefs, gui, callback, end = [0x70000000+n for n in (0,0x100,0x200,0x400,0x800,0x900)]
    put = lambda a,v: machine.mem_write(a,struct.pack('<I',v))
    get = lambda a: struct.unpack('<I',machine.mem_read(a,4))[0]
    put(0xA1055CD4,prefs)
    put(gui+0x28,callback)
    dispatches = []
    state = {'busy':False}
    stubs = {0xA011F0C8,0xA011EFc4,0xA011F084,0xA0213B5C,0xA0213C0C,
             0xA0213C80,0xA0213C90,0xA017888C,0xA0213AF8,0xA0178868,
             0xA02A70EC,0xA018C6D8}

    def cstring(address):
        text = bytearray()
        for n in range(256):
            value = bytes(machine.mem_read(address+n,1))
            if value == b'\0': return bytes(text)
            text.extend(value)
        raise AssertionError('Unterminated synthetic string')

    def hook(uc,address,size,user):
        returns = None
        if address == 0xA04F95D0:
            a,b = cstring(uc.reg_read(UC_ARM_REG_R0)),cstring(uc.reg_read(UC_ARM_REG_R1))
            returns = 0 if a == b else 1
        elif address == 0xA01881F4:
            put(uc.reg_read(UC_ARM_REG_R0),gui)
            returns = 0
        elif address == callback:
            dispatches.append([uc.reg_read(reg) for reg in (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2)])
            returns = 0
        elif address in stubs:
            returns = int(state['busy']) if address in (0xA011F0C8,0xA011F084) else 0
        if returns is not None:
            uc.reg_write(UC_ARM_REG_R0,returns)
            lr = uc.reg_read(UC_ARM_REG_LR)
            uc.reg_write(UC_ARM_REG_CPSR,uc.reg_read(UC_ARM_REG_CPSR)&~0x20)
            uc.reg_write(UC_ARM_REG_PC,lr&~1)

    machine.hook_add(UC_HOOK_CODE,hook)
    modes = [('precise quality',0,0xA0145E10),('precise self quality',1,0xA0145E10),
             ('burst quality',2,0xA0145E10),('precise quality cont.',3,0xA0145E10),
             ('record',4,0xA0146228),('record_timelapse',5,0xA0146228),
             ('record_loop',6,0xA0146228),('record_photo',7,0xA0146228),
             ('record_slow_motion',8,0xA0146228)]
    cases = []
    for name, target, entry in modes:
        for same,busy in [(False,False),(True,False),(False,True)]:
            dispatches.clear();state['busy']=busy
            current = target if same else (4 if target<4 else 0)
            machine.mem_write(0xA1055CFA,bytes([current]))
            machine.mem_write(arg,name.encode()+b'\0');put(result,0xDEADBEEF)
            for reg,value in [(UC_ARM_REG_R0,arg),(UC_ARM_REG_R1,0),(UC_ARM_REG_R2,result),
                              (UC_ARM_REG_SP,0x70003F00),(UC_ARM_REG_LR,end)]:machine.reg_write(reg,value)
            machine.reg_write(UC_ARM_REG_CPSR,machine.reg_read(UC_ARM_REG_CPSR)&~0x20)
            machine.emu_start(entry,end,count=2000)
            assert machine.reg_read(UC_ARM_REG_PC)==end
            status=machine.reg_read(UC_ARM_REG_R0)
            assert status == (0xFFFFFFEB if busy else 0)
            wanted=[] if (same or busy) else ([[0xF0010309,0,0]] if target<4 else [])+[[0xD8090004,target,0]]
            assert dispatches==wanted,(name,same,busy,dispatches,wanted)
            if not busy:assert get(result)==int(same)
            cases.append({'requested':name,'current_native_mode':current,'target':target,
                          'busy':busy,'same':same,'return':hex(status),
                          'gui_dispatches':[[hex(a),b,c] for a,b,c in dispatches]})
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'audit.asm').write_text('\n'.join(assembly)+'\n')
    runtime_path=ROOT/'artifacts/android/0.3.2-mode-switch-probe-run03.json'
    runtime=json.loads(runtime_path.read_text())
    assert runtime['capture_readbacks'][-1]['mode']=='capture'
    assert runtime['restored_readbacks'][-1]['mode']=='record'
    assert runtime['after_mode']=='record' and runtime['after_status']=='idle'
    report={'image_sha256':EXPECTED_SHA,'table_rows':rows,'sources':sources,
            'parent_saved_runtime_probe':{'path':str(runtime_path.relative_to(ROOT)),
                                          'sha256':hashlib.sha256(runtime_path.read_bytes()).hexdigest(),
                                          'capture_mode_observed':'capture',
                                          'restored_system_mode':'record','restored_status':'idle',
                                          'provenance':'Parent ordinary API run; this audit only reads saved JSON'},
            'instruction_assertions':len(expected),'synthetic_setter_cases':cases,
            'scope':'Pinned stock mode leaf setters with declared readiness/preference/GUI stubs; no camera connection or real mode completion',
            'limitation':'No GUI event consumer, encoder, sensor or storage is emulated; parent runtime probe must prove system_mode readback.'}
    (OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(f'Pinned 3 handlers, {len(expected)} instruction checks, {len(cases)} synthetic leaf-setter cases')


if __name__=='__main__':main()
