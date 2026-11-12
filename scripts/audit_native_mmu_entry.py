#!/usr/bin/env python3
"""Offline MMU descriptor/ownership audit. No target access or payload output.

Executes the stock MMU initialization prefix through construction of all tables,
then stops before cache/TLB/TTBR activation. Unicorn mocks memset and cache
maintenance only; no hardware cache, translation or multicore claims are made.
"""
from __future__ import annotations
import hashlib
import json
import re
import struct
from collections import Counter
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R8, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT = ROOT / 'artifacts/device/2026-11-10-native-mmu-entry-audit'
BASE = 0xA0100000
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
L1 = 0xA0B9C000


def main():
    blob = (ANALYSIS / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(blob).hexdigest() == SHA
    OUT.mkdir(parents=True, exist_ok=True)
    uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    uc.mem_map(0xA0000000, 0x02000000)
    uc.mem_write(BASE, blob)
    uc.mem_map(0x70000000, 0x10000)
    word = lambda a: struct.unpack('<I', uc.mem_read(a, 4))[0]
    hook_calls = Counter()
    builders = []

    def hook(machine, at, size, _):
        if at == 0xA04A41F0:
            # Declared cold construction branch; stop before activation, so the
            # supplied SCTLR is not an observation of the device's live state.
            machine.reg_write(UC_ARM_REG_R8, 0)
            machine.reg_write(UC_ARM_REG_PC, at + 4)
        elif at == 0xA04A3FB0:
            p = machine.reg_read(UC_ARM_REG_R0)
            builders.append(dict(source=hex(p), words=[hex(word(p+i*4)) for i in range(4)]))
        elif at in (0xA04F8DEC, 0xA04A22CC, 0xA04A2568):
            hook_calls[hex(at)] += 1
            result = 0
            if at == 0xA04F8DEC:
                dest = machine.reg_read(UC_ARM_REG_R0)
                value = machine.reg_read(UC_ARM_REG_R1) & 255
                size = machine.reg_read(UC_ARM_REG_R2)
                assert size <= 0x4000
                machine.mem_write(dest, bytes([value]) * size)
                result = dest
            machine.reg_write(UC_ARM_REG_R0, result)
            machine.reg_write(UC_ARM_REG_PC, machine.reg_read(UC_ARM_REG_LR))

    uc.hook_add(UC_HOOK_CODE, hook)
    uc.reg_write(UC_ARM_REG_SP, 0x7000F000)
    uc.reg_write(UC_ARM_REG_LR, 0x70001000)
    uc.emu_start(0xA04A41E8, 0xA04A42AC, count=2_000_000)
    assert uc.reg_read(UC_ARM_REG_PC) == 0xA04A42AC
    assert len(builders) == 14
    rows = [tuple(int(w, 16) for w in b['words']) for b in builders]
    assert rows[:10] == [
        (0xA0000000,0,0x100000,0x1060F),
        (0xA0100000,0x100000,0x54F000,0x1060F),
        (0xA069B000,0x69B000,0x187000,0x1060F),
        (0xA064F000,0x64F000,0x4C000,0x11603),
        (0xA0824F68,0x824F68,0x122D098,0x1060F),
        (0xA1B00000,0x1B00000,0x600000,0x11601),
        (0xA3100000,0x3100000,0x38F00000,0x1060D),
        (0xA2100000,0x2100000,0x1000000,0x11601),
        (0xFFFF0000,0x100000,0x4000,0x1060F),
        (0xDC000000,0x3C000000,0x4000000,0x1160D)]

    def p2v(pa):
        # Match firmware inverse mapping helper's default-first search order.
        for va, phys, size, _ in rows[10:] + rows[:10]:
            if phys <= pa < phys + size:
                return pa + va - phys
        return pa

    def decode(pte, section):
        if section:
            xn, tex, ap = (pte >> 4) & 1, (pte >> 12) & 7, ((pte >> 10) & 3) | (((pte >> 15) & 1) << 2)
            s = (pte >> 16) & 1
        else:
            xn, tex, ap = pte & 1, (pte >> 6) & 7, ((pte >> 4) & 3) | (((pte >> 9) & 1) << 2)
            s = (pte >> 10) & 1
        b, c = (pte >> 2) & 1, (pte >> 3) & 1
        memory = {(0,0,0):'Strongly-ordered', (0,1,0):'Shareable Device',
                  (0,0,1):'Normal WT no WA', (0,1,1):'Normal WB no WA',
                  (1,0,0):'Normal non-cacheable', (1,1,1):'Normal WB WA'}.get((tex,b,c),'other')
        return dict(xn=xn, tex=tex, c=c, b=b, ap=ap, shareable=s, memory=memory,
                    normal_noncacheable=(tex,b,c)==(1,0,0))

    mappings = []
    coarse_tables = []
    for index in range(4096):
        pte = word(L1 + index*4)
        kind = pte & 3
        if kind == 0:
            continue
        if kind == 2:
            assert not pte & (1 << 18), 'supersection unsupported'
            mappings.append(dict(va=index<<20, pa=pte&0xFFF00000, size=0x100000,
                                 descriptor=pte, kind='section', **decode(pte,True)))
        elif kind == 1:
            table_pa = pte & 0xFFFFFC00
            table_va = p2v(table_pa)
            coarse_tables.append(dict(l1_index=index, descriptor=hex(pte), pa=hex(table_pa), va=hex(table_va)))
            for page in range(256):
                small = word(table_va + page*4)
                if not small & 3:
                    continue
                assert small & 2, 'large page unsupported'
                mappings.append(dict(va=(index<<20)+(page<<12), pa=small&0xFFFFF000,
                                     size=0x1000, descriptor=small, kind='small_page', **decode(small,False)))
        else:
            raise AssertionError(hex(pte))
    mappings.sort(key=lambda r:r['va'])
    groups = []
    for m in mappings:
        attrs = {k:v for k,v in m.items() if k not in ('va','pa','size','descriptor')}
        if groups and all(groups[-1][k]==v for k,v in attrs.items()) and groups[-1]['va_end']==m['va'] and groups[-1]['pa_end']==m['pa']:
            groups[-1]['va_end'] += m['size']; groups[-1]['pa_end'] += m['size']
        else:
            groups.append(dict(va=m['va'], va_end=m['va']+m['size'],pa=m['pa'],pa_end=m['pa']+m['size'],**attrs))
    def lookup(va):
        return next(m for m in mappings if m['va']<=va<m['va']+m['size'])
    assert lookup(0xA064E220)['descriptor'] == 0x0064E43E
    assert lookup(0xA064F000)['descriptor'] == 0x0064F472
    assert lookup(0xA2100000)['descriptor'] == 0x02111C02
    assert lookup(0xA1B00000)['descriptor'] == 0x01B11C02
    assert lookup(0xFFFF0000)['pa'] == 0x00100000
    nc = [g for g in groups if g['normal_noncacheable'] and not g['xn']]
    assert [(g['va'],g['va_end']) for g in nc] == [(0xA064F000,0xA069B000),(0xA1B00000,0xA3100000)]
    aliases = []
    for i,a in enumerate(groups):
        for b in groups[i+1:]:
            lo,hi=max(a['pa'],b['pa']),min(a['pa_end'],b['pa_end'])
            if lo<hi:
                aliases.append(dict(pa=hex(lo),pa_end=hex(hi),a_va=hex(a['va']+lo-a['pa']),
                                    b_va=hex(b['va']+lo-b['pa']),a_memory=a['memory'],b_memory=b['memory'],
                                    noncache_alias=a['normal_noncacheable'] or b['normal_noncacheable']))
    assert len(aliases)==1 and not aliases[0]['noncache_alias']

    # Count recorded data references into the image-backed NC region. These
    # demonstrate use, while absence of a reference cannot establish ownership.
    refs=[]; ref_count=0; zero_run_refs=[]; zero_ref_count=0
    with (ANALYSIS/'full/references.tsv').open() as f:
        next(f)
        for line in f:
            fields=line.rstrip().split('\t')
            try: target=int(fields[1],16)
            except ValueError: continue
            if 0xA064F000<=target<0xA069B000:
                ref_count+=1
                if len(refs)<32: refs.append(fields)
                if 0xA065206C<=target<0xA069B000:
                    zero_ref_count+=1
                    if len(zero_run_refs)<16 or target==0xA0699160:
                        zero_run_refs.append(fields)
    zero_runs=[]
    for match in re.finditer(b'\0{32,}',blob[0xA064F000-BASE:0xA069B000-BASE]):
        zero_runs.append(dict(start=hex(0xA064F000+match.start()),end=hex(0xA064F000+match.end()),bytes=match.end()-match.start()))
    zero_runs.sort(key=lambda r:r['bytes'],reverse=True)

    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    evidence=[]
    for name,lo,hi in [('layout',0xA0295CF8,0xA0295FF8),('builders',0xA04A3754,0xA04A3FFC),
                       ('primary',0xA04A41E8,0xA04A43FC),('startup_pool',0xA018756C,0xA0187740),
                       ('reserved_buffers',0xA02C6C5C,0xA02C6C94),('linux_shared',0xA0295B38,0xA0295CF8)]:
        raw=blob[lo-BASE:hi-BASE]
        path=OUT/f'{name}.asm'
        path.write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(raw,lo))+'\n')
        evidence.append(dict(path=str(path.relative_to(ROOT)),start=hex(lo),end=hex(hi),sha256=hashlib.sha256(raw).hexdigest()))
    comparisons={int(r['entry'],16):r for r in json.loads((ANALYSIS/'function-comparison.json').read_text())}
    provenance=[]
    for at in (0xA0295CF8,0xA04A3FB0,0xA04A3B24,0xA04A3BD4,0xA04A41E8,0xA018756C,0xA02C6C5C,0xA0295B38):
        record=comparisons[at]
        raw=b''.join(blob[int(lo,16)-BASE:int(hi,16)-BASE+1] for lo,hi in (s.split('-') for s in record['body_ranges']))
        assert record['same_body_bytes'] and hashlib.sha256(raw).hexdigest()==record['device_body_sha256']
        provenance.append(record)
    def format_group(g):
        return {k:(hex(v) if k in ('va','va_end','pa','pa_end') else v) for k,v in g.items()}
    result=dict(image_sha256=SHA,scope='stock construction prefix in synthetic RAM; stops before activation',
        original_prefix_entry='0xa04a41e8',stop_pc='0xa04a42ac',sctlr_input=0,
        image_sctlr=hex(struct.unpack_from('<I',blob,0xA078C0F8-BASE)[0]),
        configured_sctlr=hex(word(0xA078C0F8)),tex_remap_enabled=bool(word(0xA078C0F8)&(1<<28)),
        wxn_enabled=bool(word(0xA078C0F8)&(1<<19)),mocked_call_counts=dict(hook_calls),
        constructor_calls=builders,coarse_tables=coarse_tables,mappings=[format_group(g) for g in groups],
        representative_ptes={hex(a):dict(descriptor=hex(lookup(a)['descriptor']),**decode(lookup(a)['descriptor'],lookup(a)['kind']=='section'))
            for a in (0xA064E220,0xA064F000,0xA1B00000,0xA2100000,0xFFFF0000,0xDC000000)},
        noncache_executable=[format_group(g) for g in nc],physical_aliases=aliases,
        image_backed_nc_region=dict(range=['0xa064f000','0xa069b000'],recorded_reference_count=ref_count,
            reference_examples=refs,zero_runs_at_least_32_bytes=len(zero_runs),largest_zero_runs=zero_runs[:16],
            largest_zero_run_reference_count=zero_ref_count,largest_zero_run_reference_examples=zero_run_refs,
            ownership_proven=False),
        ownership_evidence=[
            dict(region=['0xa2100000','0xa3100000'],pool='0xa0fe7220',creation_call='0xa018766c',
                 constructor='0xa03bc6b0',status='stock secondary byte pool; no allocation obtained'),
            dict(region=['0xa1b00000','0xa2100000'],address_provider='0xa02c6c5c',
                 returned_addresses=['0xa1b00000','0xa1f80000','0xa2000000','0xa2080000'],
                 status='four fixed buffer addresses; exact sub-lifetimes not established'),
            dict(region=['0xa064f000','0xa069b000'],known_objects=['0xa064f3c0','0xa06520c0','0xa0699160'],
                 status='stock initialized/shared data; includes DSP publication word')],
        provenance=provenance,evidence=evidence,
        decision='Normal non-cacheable XN=0 RAM exists in constructor output; no owned executable allocation or safe first-entry buffer is established. No NC alias of existing cached text was found in the 14 constructed descriptors.',
        limitations=['No live TTBR/SCTLR/PTE readback; startup/hibernation or later rewrites can differ.',
            'Unicorn does not model real I/D caches, barriers, multicore propagation, DMA or ownership.',
            'XN=0 and configured WXN=0 are static prerequisites, not a guarantee of fresh first fetch or supported code publication.',
            'Zero bytes and bounded reference searches do not reserve RAM.'],target_access=False,target_memory_write=False,payload_emitted=False)
    (OUT/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(noncache_executable=result['noncache_executable'],representative_ptes=result['representative_ptes'],physical_aliases=aliases,reference_count=ref_count,largest_zero_runs=zero_runs[:4]),indent=2))


if __name__=='__main__': main()
