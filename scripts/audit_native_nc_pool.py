#!/usr/bin/env python3
"""Synthetic stock byte-pool ABI audit; no device access or executable output.

Runs stock create, checked allocation, alignment and free on a NEW synthetic
pool, with stock locks/core queries and Thumb memset/division. This does not
observe capacity or allocate from the camera's real secondary pool.
"""
import hashlib
import json
import struct
from collections import Counter
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_R4, UC_ARM_REG_R5, UC_ARM_REG_R6, UC_ARM_REG_R7, UC_ARM_REG_R8, UC_ARM_REG_R9, UC_ARM_REG_R10, UC_ARM_REG_R11, UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_CPSR

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT = ROOT/'artifacts/device/2026-11-10-native-nc-pool-audit'
BASE=0xA0100000
SHA='eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'


def main():
    raw=(SRC/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(raw).hexdigest()==SHA
    uc=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    uc.mem_map(0xA0000000,0x04000000);uc.mem_write(BASE,raw)
    uc.mem_map(0x70000000,0x10000)
    put=lambda a,v:uc.mem_write(a,struct.pack('<I',v))
    get=lambda a:struct.unpack('<I',uc.mem_read(a,4))[0]
    # A fresh declared RTOS model, not copied device BSS: no created pools,
    # core 0, valid current-thread placeholder, no interrupt/system state.
    thread=0x70002000;pool=0x70003000;region=0xA2100000;size=0x4000
    put(0xA179630C,thread);put(0xA1796314,thread);put(0xA179676C,0xFFFFFFFF)
    calls=Counter();events=[];visited={}
    blocked=(0xA03C1D5C,0xA02A7524,0xA03C1C8C)
    def hook(machine,at,n,_):
        visited[at]=bool(machine.reg_read(UC_ARM_REG_CPSR)&0x20)
        assert not region<=at<region+size, 'Pool bytes must never be executed'
        if at in blocked:raise AssertionError(f'Unexpected suspend/assert/switch {at:x}')
        if at in (0xA03C3448,0xA03C3524,0xA03C3700,0xA03BD130,0xA03C13B0,0xA03C1428,0xA03C0D08,0xA03C0D4C,0xA04F8DEC,0xA0506674):calls[hex(at)]+=1
    uc.hook_add(UC_HOOK_CODE,hook)
    saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
    def call(at,args,expected=None,label=''):
        sp=0x7000F000;end=0x70001000
        uc.reg_write(UC_ARM_REG_CPSR,0x13)
        for i,r in enumerate(saved):uc.reg_write(r,0xABC00000+i)
        for i,r in enumerate((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)):uc.reg_write(r,args[i] if i<len(args) else 0)
        for i,v in enumerate(args[4:]):put(sp+i*4,v)
        uc.reg_write(UC_ARM_REG_SP,sp);uc.reg_write(UC_ARM_REG_LR,end)
        uc.emu_start(at,end,count=1_000_000)
        assert uc.reg_read(UC_ARM_REG_PC)==end,hex(uc.reg_read(UC_ARM_REG_PC))
        assert uc.reg_read(UC_ARM_REG_SP)==sp
        assert all(uc.reg_read(r)==0xABC00000+i for i,r in enumerate(saved))
        rc=uc.reg_read(UC_ARM_REG_R0)
        if expected is not None:assert rc==expected,(label,hex(rc),hex(expected))
        events.append(dict(label=label,entry=hex(at),arguments=[hex(a) for a in args],rc=hex(rc),available=get(pool+8)))
        return rc
    call(0xA03BC6B0,[pool,region,size],0,'create fresh synthetic NC-address pool')
    assert get(pool)==0x42595445 and get(pool+0x18)==region and get(pool+0x1C)==size
    out=0x70004000;aligned_out=0x70004010;orig_out=0x70004020
    initial=get(pool+8)
    for label,args,rc in [('null pool',[0,out,32,0],2),('bad magic',[0x70005000,out,32,0],2),
                          ('null output',[pool,0,32,0],3),('zero size',[pool,out,0,0],5),
                          ('above pool size',[pool,out,size+1,0],5)]:
        put(out,0x11223344);call(0xA03BC6DC,args,rc,label);assert get(out)==0x11223344
    call(0xA03BC6DC,[pool,out,37,0],0,'no-wait odd-size allocate')
    p=get(out);assert region<=p<region+size and p%4==0 and get(p-4)==pool
    assert get(pool+8)==initial-48
    call(0xA03BC714,[p],0,'release original pointer')
    assert get(pool+8)==initial and get(p-4)==0xFFFFEEEE
    call(0xA03BC714,[p],3,'reject double release')
    call(0xA03BC714,[0],3,'reject null release')
    call(0xA03BC6DC,[pool,out,64,0],0,'allocate simultaneous owner A')
    owner_a=get(out)
    call(0xA03BC6DC,[pool,orig_out,96,0],0,'allocate simultaneous owner B')
    owner_b=get(orig_out)
    assert owner_a+64<=owner_b or owner_b+96<=owner_a
    uc.mem_write(owner_b,b'B'*96)
    call(0xA03BC714,[owner_a],0,'release A while B remains allocated')
    assert bytes(uc.mem_read(owner_b,96))==b'B'*96 and get(owner_b-4)==pool
    call(0xA03BC6DC,[pool,out,32,0],0,'allocate owner C while B remains allocated')
    owner_c=get(out)
    assert owner_c+32<=owner_b or owner_b+96<=owner_c
    assert bytes(uc.mem_read(owner_b,96))==b'B'*96
    call(0xA03BC714,[owner_b],0,'release B')
    call(0xA03BC714,[owner_c],0,'release C')
    assert get(pool+8)==initial
    # ThreadX rounds to 4 bytes; allocate virtually all free payload, then
    # verify a second no-wait allocation fails and leaves the output alone.
    call(0xA03BC6DC,[pool,out,initial-16,0],0,'nearly exhaust synthetic pool')
    exhausted_p=get(out);put(orig_out,0x55667788)
    call(0xA03BC6DC,[pool,orig_out,64,0],0x10,'no memory returns without suspend')
    assert get(orig_out)==0x55667788
    call(0xA03BC714,[exhausted_p],0,'release nearly full block')
    assert get(pool+8)==initial
    put(aligned_out,0x11223344);put(orig_out,0x55667788)
    call(0xA029A7D8,[0,aligned_out,orig_out,96,64],2,'aligned wrapper preserves outputs on rejected pool')
    assert get(aligned_out)==0x11223344 and get(orig_out)==0x55667788
    align_cases=[]
    for requested in (0,1,4,16,32,64,128):
        call(0xA029A7D8,[pool,aligned_out,orig_out,96,requested],0,f'aligned wrapper alignment {requested}')
        original,aligned=get(orig_out),get(aligned_out)
        effective=max(32,requested)
        assert aligned==(original&~(effective-1))+effective
        assert aligned%effective==0 and aligned+96<=original+96+2*effective
        align_cases.append(dict(requested=requested,effective=effective,original=hex(original),aligned=hex(aligned)))
        call(0xA03BC714,[original],0,'release original after aligned allocation')
        assert get(pool+8)==initial
    # General nonblocking aligned wrapper returns original in pair[0] and
    # aligned in pair[1], and paired release consumes pair[0].
    pair=0x70004030
    call(0xA03BC77C,[pool,pair,97,64],0,'no-wait paired alignment wrapper')
    pair_original,pair_aligned=get(pair),get(pair+4)
    assert pair_aligned%64==0 and pair_original<=pair_aligned<pair_original+64
    call(0xA03BC7D0,[pair],0,'paired release reads original pointer')
    assert get(pool+8)==initial
    # Context checks are stock; the declared system-state values determine
    # whether waiting or any allocation is legal, rather than the API fixing it.
    put(0xA17962E8,1)
    call(0xA03BC6DC,[pool,out,32,1],4,'waiting rejected in nonzero system state')
    call(0xA03BC6DC,[pool,out,32,0],0x13,'non-wait rejected in disallowed caller state')
    put(0xA17962E8,0)
    put(0xA179630C,0xA1796C34)
    call(0xA03BC6DC,[pool,out,32,0],0x13,'timer-thread context rejected')
    put(0xA179630C,thread)

    OUT.mkdir(parents=True,exist_ok=True)
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    functions={int(f['entry'],16):f for f in json.loads((SRC/'full/functions.json').read_text())}
    evidence=[]
    addrs=(0xA018756C,0xA01E66F4,0xA029A7D8,0xA03BC6B0,0xA03BC6DC,0xA03BC714,0xA03BC77C,0xA03BC7D0,
           0xA03C3448,0xA03C3524,0xA03C3700,0xA03BD130,0xA03C13B0,0xA03C1428,0xA01A8998,
           0xA01CBBBC,0xA020CF14,0xA0210894,0xA021064C,0xA022F07C,0xA04B2EE0,0xA04B2F08,0xA04B1C64,0xA04B1D18,
           0xA02A80F4,0xA02A8104,0xA0186F3C,0xA0189A28,0xA018AE80,0xA01E0AB8,0xA01E0C10)
    for a in addrs:
        f=functions.get(a)
        if not f:continue
        listing=[];chunks=[]
        for span in f['body_ranges']:
            lo,hi=[int(v,16) for v in span.split('-')];b=raw[lo-BASE:hi-BASE+1];chunks.append(b)
            listing.extend(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in md.disasm(b,lo))
        path=OUT/f'{a:08x}.asm';path.write_text('\n'.join(listing)+'\n')
        evidence.append(dict(entry=hex(a),ranges=f['body_ranges'],sha256=hashlib.sha256(b''.join(chunks)).hexdigest(),path=str(path.relative_to(ROOT))))
    refs=[]
    with (SRC/'full/references.tsv').open() as f:
        next(f)
        for line in f:
            fields=line.rstrip().split('\t')
            if fields[1] in ('0xa0fe7220','0xa13a23f0'):refs.append(fields)
    # Retain graph search boundary; indirect function-table edges are absent.
    graph={}
    with (SRC/'full/calls.tsv').open() as f:
        next(f)
        for line in f:
            a,site,b,kind=line.rstrip().split('\t')
            if kind.endswith('CALL'):graph.setdefault(int(a,16),[]).append((int(site,16),int(b,16)))
    command=json.loads((ROOT/'artifacts/device/2026-11-10-native-ram-entry-audit/audit.json').read_text())['ants_table']
    thumb=next(r for r in command if r['name']=='thumb');assert thumb['handler']=='0xa01a8998'
    slot=0xA056B404+68*8
    assert struct.unpack_from('<II',raw,slot-BASE)==(int(thumb['name_pointer'],16),int(thumb['handler'],16))
    entry_owners={}
    for ref in refs:
        at=int(ref[0],16)
        owners=[f['entry'] for f in functions.values() if any(int(s.split('-')[0],16)<=at<=int(s.split('-')[1],16) for s in f['body_ranges'])]
        entry_owners.setdefault(ref[1],[]).append(dict(reference=ref,owners=owners))
    # Bounded reachability from the known t ants table to direct NC users.
    targets={0xA0186F3C,0xA0189A28,0xA01E0AB8,0xA01E0C10,0xA01CBBBC,0xA020CF14,0xA0210894,0xA022F07C}
    paths=[]
    for cmd in command:
        todo=[(int(cmd['handler'],16),[])];seen=set()
        while todo:
            node,path=todo.pop(0)
            if node in seen:continue
            seen.add(node)
            if node in targets:paths.append(dict(command=cmd['name'],handler=cmd['handler'],target=hex(node),path=path))
            if len(path)<6:
                todo.extend((dest,path+[dict(caller=hex(node),site=hex(site),target=hex(dest))]) for site,dest in graph.get(node,[]))
    synchronization=[]
    tmd=Cs(CS_ARCH_ARM,CS_MODE_THUMB)
    for at in sorted(visited):
        if BASE<=at<BASE+len(raw):
            ins=next((tmd if visited[at] else md).disasm(raw[at-BASE:at-BASE+4],at),None)
            if ins and ins.mnemonic in ('dmb','dsb','isb','mcr','mrc'):
                synchronization.append(dict(address=hex(at),instruction=ins.mnemonic+' '+ins.op_str))
    assert any(s['instruction'].startswith('dmb') for s in synchronization)
    assert any(s['instruction'].startswith('dsb') for s in synchronization)
    assert not any(s['instruction'].startswith(('isb','mcr')) for s in synchronization)
    comparisons={int(r['entry'],16):r for r in json.loads((SRC/'function-comparison.json').read_text())}
    provenance=[]
    for e in evidence:
        a=int(e['entry'],16)
        if a in comparisons:
            r=comparisons[a];assert r['same_body_bytes'] and e['sha256']==r['device_body_sha256']
            provenance.append(dict(entry=e['entry'],same_old_body=True,sha256=e['sha256']))
    result=dict(image_sha256=SHA,scope='real stock pool routines in wholly synthetic memory and declared no-contention core-0 RTOS state',
        events=events,stock_call_counts=dict(calls),aligned_cases=align_cases,
        original_pool_magic=hex(get(pool)),final_available=get(pool+8),initial_available=initial,
        original_allocation_pointer=hex(p),paired_original=hex(pair_original),paired_aligned=hex(pair_aligned),
        simultaneous_allocations_nonoverlap=True,live_block_preserved_when_other_freed=True,
        secondary_pool_reference_inventory=entry_owners,thumb_command=thumb,evidence=evidence,provenance=provenance,
        bounded_ants_nc_user_paths=dict(max_direct_call_depth=6,paths=paths,indirect_edges_included=False),
        executed_synchronization=synchronization,pool_bytes_executed=False,
        api=dict(raw_allocate=dict(entry='0xa03bc6dc',args=['pool','output','bytes','timeout'],no_wait=0),
                 free=dict(entry='0xa03bc714',args=['original_ptr']),
                 paired_aligned_no_wait=dict(entry='0xa03bc77c',args=['pool','pair_out','bytes','alignment'],release='0xa03bc7d0(pair_out)'),
                 fixed_wait_aligned=dict(entry='0xa029a7d8',args=['pool','aligned_out','original_out','bytes','alignment'],wait=500,
                     minimum_alignment=32,rounding='(original & ~(effective_alignment-1)) + effective_alignment',
                     requires_power_of_two_alignment=True,power_of_two_checked_by_stock=False)),
        decision='A known NC pool and complete allocate/free contracts exist; no observed public command grants an owned NC allocation and publishes/enters it. The first transfer and cache/ISB/multicore contract remain open.',
        limitations=['No real secondary-pool capacity, fragmentation, allocation or hardware mapping observation.',
            'Synthetic current-thread and core-0 state; no contention, suspended threads, device DMA or caches simulated.',
            'Shell candidate is thumb malloc: random-sized cached application pool stress test with fatal assertion path, not a controlled NC allocator.',
            'Alignment wrappers have no overflow/power-of-two validation; callers must check size and alignment bounds.',
            'Release verifies a header near its input; arbitrary or interior pointers can fault or corrupt and must not be tested on hardware.'],
        target_access=False,target_memory_write=False,payload_emitted=False)
    (OUT/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(cases=len(events),aligned_cases=len(align_cases),final_available=get(pool+8),initial_available=initial,stock_call_counts=dict(calls)),indent=2))


if __name__=='__main__':main()
