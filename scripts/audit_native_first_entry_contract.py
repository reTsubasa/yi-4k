#!/usr/bin/env python3
"""Offline stock control-plane/SMP evidence; no writer, patch or executable output."""
import csv
import hashlib
import json
import re
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT = ROOT / 'artifacts/device/2026-11-10-native-first-entry-contract'
BASE = 0xA0100000
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'


def main():
    image = (SOURCE / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(image).hexdigest() == SHA
    OUT.mkdir(parents=True, exist_ok=True)
    arm = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []

    def check(at, mnemonic, operands):
        ins = next(arm.disasm(image[at-BASE:at-BASE+4], at))
        assert (ins.mnemonic, ins.op_str) == (mnemonic, operands), hex(at)
        checks.append(dict(site=hex(at), bytes=bytes(ins.bytes).hex(), instruction=f'{mnemonic} {operands}'))

    def export(label, lo, hi):
        raw = image[lo-BASE:hi-BASE]
        (OUT / (label+'.asm')).write_text('\n'.join(
            f'{i.address:08x} {bytes(i.bytes).hex()} {i.mnemonic} {i.op_str}'
            for i in arm.disasm(raw, lo))+'\n')
        return dict(start=hex(lo), end_exclusive=hex(hi), sha256=hashlib.sha256(raw).hexdigest())

    # Original remote callback is a tail branch through one fixed global slot.
    for args in [
        (0xA03CFBFC,'movw','r3, #0x143c'), (0xA03CFC00,'movt','r3, #0xa17e'),
        (0xA03CFC04,'ldr','r3, [r3]'), (0xA03CFC08,'bx','r3'),
        (0xA03CFBD8,'dsb','sy'), (0xA03CFBF0,'dsb','sy'), (0xA03CFBF4,'isb','sy'),
        (0xA03CFBF8,'bx','lr'),
        (0xA03D0898,'bl','#0xa03cfbd8'), (0xA03D089C,'bl','#0xa04a1f54'),
        (0xA03D08A0,'dsb','sy'), (0xA03D08C0,'bl','#0xa03bc3cc'),
        (0xA03D08C8,'movw','ip, #0xfbd8'), (0xA03D08D0,'movt','ip, #0xa03c'),
        (0xA03D08E0,'str','ip, [r3]'), (0xA03D08E4,'bl','#0xa0482f3c'),
        (0xA03D0900,'bl','#0xa03d0548'), (0xA03D0904,'mcr','p15, #0, r4, c7, c1, #0'),
        (0xA02A41C0,'blx','#0xa04f9744'), (0xA02A42A4,'bl','#0xa02a40bc'),
        (0xA02A3934,'bl','#0xa048fb7c'), (0xA02A393C,'bl','#0xa048fe2c'),
        (0xA02A3A94,'bl','#0xa048fca0'),
    ]:
        check(*args)

    refs = list(csv.DictReader((SOURCE/'full/references.tsv').open(), delimiter='\t'))
    slot_refs = [r for r in refs if r['to']=='0xa17e143c']
    writes = [r for r in slot_refs if r['type']=='WRITE']
    assert {r['from'] for r in writes} == {'0xa03cffdc','0xa03d08e0'}
    check(0xA03CFFC4,'movw','ip, #0xfbd8')
    check(0xA03CFFC8,'movt','ip, #0xa03c')
    check(0xA03CFFDC,'str','ip, [r3]')
    tlb = list(arm.disasm(image[0xA03CFBD8-BASE:0xA03CFBFC-BASE],0xA03CFBD8))
    assert [i.op_str for i in tlb if i.mnemonic=='mcr'] == [
        'p15, #0, r3, c8, c7, #0', 'p15, #0, r3, c8, c6, #0',
        'p15, #0, r3, c8, c5, #0', 'p15, #0, r3, c8, c3, #0']

    ranges = {
        'boss_remote_tlb_and_trampoline': (0xA03CFBD8,0xA03CFC0C),
        'boss_start_publication_excerpt': (0xA03CFFAC,0xA03CFFF0),
        'boss_restore_order': (0xA03D0780,0xA03D0948),
        'interrupt_send': (0xA0482F3C,0xA0482FCC),
        'ps_dispatch': (0xA02A3864,0xA02A3B14),
        'ver_dispatch': (0xA02A40BC,0xA02A42AC),
        'pool_summary': (0xA048FB7C,0xA048FCA0),
        'pool_detail': (0xA048FCA0,0xA048FE2C),
        'shell_script_reader': (0xA029D3B4,0xA029D4D8),
    }
    exported = {label:export(label,*span) for label,span in ranges.items()}

    historical_dir=ROOT/'artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-03'
    historical_mem=historical_dir/'yi4k_diag_e30da2b76aa5_mem.txt'
    historical_raw=historical_mem.read_bytes()
    historical_rows=[dict(id=int(a),available_bytes=int(b),fragments=int(c))
        for a,b,c in re.findall(r'^\s*(\d+)\s+(\d+)\s+(\d+)\s*$',
            historical_raw.decode().split('Block pool')[0],re.M)]
    assert len(historical_rows)==8 and historical_rows[0]['available_bytes']==234597172
    app_head=(historical_dir/'yi4k_diag_e30da2b76aa5_pool1.bin').read_bytes()
    assert len(app_head)==48
    assert struct.unpack_from('<I',app_head,0)[0]==0x42595445
    assert struct.unpack_from('<II',app_head,8)==(234597172,522)
    assert struct.unpack_from('<II',app_head,0x18)==(0xC1100000,451936256)

    # Real stock query dispatch only. The query bodies themselves are not run.
    # strcmp, query targets, build-info getter and print are explicit stubs.
    runs=[]
    for words,entry,expected in [
        (['ps','mem'],0xA02A3864,[0xA048FB7C,0xA048FE2C]),
        (['ps','mem','detail'],0xA02A3864,[0xA048FCA0]),
        (['ps','tsk'],0xA02A3864,[0xA048F43C]),
        (['ver','-e'],0xA02A40F8,[0xA029B79C]),
    ]:
        u=Uc(UC_ARCH_ARM,UC_MODE_ARM)
        u.mem_map(BASE,(len(image)+4095)&~4095);u.mem_write(BASE,image)
        u.mem_map(0x70000000,0x10000)
        argv,printer,stop=0x70001000,0x70003000,0x70004000
        def put(at,v):u.mem_write(at,struct.pack('<I',v))
        def cstr(at):
            raw=bytes(u.mem_read(at,256));return raw.split(b'\0',1)[0].decode()
        for n,w in enumerate(words):
            at=0x70000100+n*0x100;u.mem_write(at,w.encode()+b'\0');put(argv+4*n,at)
        calls=[];prints=[]
        def hook(m,at,size,opaque):
            ret=None
            if at==0xA04F9744:ret=int(cstr(m.reg_read(UC_ARM_REG_R0))!=cstr(m.reg_read(UC_ARM_REG_R1)))
            elif at in expected:
                calls.append(at)
                if at==0xA029B79C:
                    for n,reg in enumerate((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2)):
                        p=0x70002000+n*0x100;u.mem_write(p,b'audit-build-string\0');put(m.reg_read(reg),p)
                else:assert m.reg_read(UC_ARM_REG_R0)==printer
                ret=0
            elif at==printer:prints.append(cstr(m.reg_read(UC_ARM_REG_R0)));ret=0
            if ret is not None:
                m.reg_write(UC_ARM_REG_R0,ret)
                m.reg_write(UC_ARM_REG_CPSR,m.reg_read(UC_ARM_REG_CPSR)&~0x20)
                m.reg_write(UC_ARM_REG_PC,m.reg_read(UC_ARM_REG_LR)&~1)
        u.hook_add(UC_HOOK_CODE,hook)
        saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
        for n,r in enumerate(saved):u.reg_write(r,0xABC00000+n)
        for r,v in [(UC_ARM_REG_R0,len(words)),(UC_ARM_REG_R1,argv),(UC_ARM_REG_R2,printer),(UC_ARM_REG_SP,0x7000F000),(UC_ARM_REG_LR,stop)]:u.reg_write(r,v)
        u.emu_start(entry,stop,count=5000)
        assert calls==expected and u.reg_read(UC_ARM_REG_PC)==stop and u.reg_read(UC_ARM_REG_SP)==0x7000F000
        assert all(u.reg_read(r)==0xABC00000+n for n,r in enumerate(saved))
        runs.append(dict(command=' '.join(words),entry=hex(entry),observed_stub_targets=[hex(x) for x in calls],print_formats=prints,return_sp_callee_saved_verified=True))

    report=dict(schema='native-first-entry-contract/v2', cpu_sha256=SHA,
        script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        fixed_instruction_checks=checks,exports=exported,
        query_dispatch_runs=runs,query_scope='Original command dispatcher; strcmp/query/build-info/print stubs explicitly declared. No target access or original query body execution.',
        historical_capture=dict(path=str(historical_mem.relative_to(ROOT)),sha256=hashlib.sha256(historical_raw).hexdigest(),
            byte_pool_rows=historical_rows,total_fragments=sum(r['fragments'] for r in historical_rows),
            app_head_path=str((historical_dir/'yi4k_diag_e30da2b76aa5_pool1.bin').relative_to(ROOT)),
            app_head_sha256=hashlib.sha256(app_head).hexdigest(),
            observed_scope='Existing successful target capture, not a new observation. Pool row1 identity is not proven by summary alone.'),
        boss_slot=dict(address='0xa17e143c',references=slot_refs,observed_write_target='0xa03cfbd8',remote_handler='0xa03cfbfc',remote_helper_operations=[i.mnemonic+' '+i.op_str for i in tlb],
            interpretation='Observed remote callback is TLB maintenance, not I-cache publication; sender sets IRQ target mask and triggers interrupt, without a completion acknowledgement in this function.'),
        not_proven=['No complete external-input-to-allocated-buffer-to-code-entry route established.',
            'Fixed reference index does not include unknown indirect stores or uncaptured code.',
            'No real cache, SMP completion, live page table, allocation ownership or cold-reset behavior verified.',
            'No executable RAM candidate selected; pool free blocks are not reservations.'],
        device_access=False,target_write=False,payload_or_writer_emitted=False)
    (OUT/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(f'{len(checks)} fixed instruction checks; {len(runs)} original query-dispatch scenarios; no device access or payload')


if __name__=='__main__':main()
