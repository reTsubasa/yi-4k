#!/usr/bin/env python3
"""Bounded static direct-call audit and actual metadata-reset instruction checks.

No camera connection. Unknown indirect/kernel/CFS edges remain explicit frontiers.
This cannot prove a complete runtime FIFO ownership or playable-split contract.
"""
import hashlib
import importlib.util
import json
import struct
from collections import deque
from pathlib import Path
import capstone
from capstone import CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB, CS_GRP_CALL, CS_GRP_JUMP

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('sync_boundary', ROOT/'scripts/prerecord-sync-boundary.py')
native = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(native)
BASE = native.BASE
EXPORT = ROOT/native.EXPORT
OUT = ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-fifo-rollover-ownership-audit.json'
FIFO = {0xA04509DC:'Create',0xA04514E4:'Delete',0xA0451960:'PeekEntry',
        0xA0451AFC:'RevPeekEntry',0xA0451C94:'RemoveEntry',0xA045202C:'PrepareEntry',
        0xA0452254:'WriteEntry',0xA0452B68:'EraseAll',0xA0452E9C:'Resume'}
APP_HELPERS = {0xA01F3124,0xA01F705C,0xA01F69B0,0xA01F6BE8,0xA01F721C,
               0xA01F68B8,0xA01F538C,0xA0119670,0xA011A208}


def sha(b): return hashlib.sha256(b).hexdigest()


def main():
    b = (ROOT/native.IMAGE).read_bytes()
    assert sha(b) == native.EXPECTED
    fs = {int(x['entry'],16):x for x in json.loads((EXPORT/'functions.json').read_text())}
    # This callback is not a function entry in the old export. The next actual
    # function starts at A01F5FF0; do not include registration/close code after it.
    fs[0xA01F569C] = dict(entry='0xa01f569c',name='unindexed_stock_mux_callback',
        thumb_context='0',body_ranges=['a01f569c-a01f5fef'])
    decoded={}
    def instructions(addr):
        if addr not in decoded:
            f=fs[addr]
            c=capstone.Cs(CS_ARCH_ARM,CS_MODE_THUMB if f['thumb_context']=='1' else CS_MODE_ARM)
            c.detail=True
            ins=[]
            for interval in f['body_ranges']:
                lo,hi=[int(x,16) for x in interval.split('-')]
                ins.extend(c.disasm(b[lo-BASE:hi-BASE+1],lo))
            decoded[addr]=ins
        return decoded[addr]
    def contains(addr,target):
        return any(int(r.split('-')[0],16)<=target<=int(r.split('-')[1],16)
                   for r in fs[addr]['body_ranges'])
    def edges(addr):
        direct=[];indirect=[]
        for i in instructions(addr):
            if i.group(CS_GRP_CALL):
                if i.op_str.startswith('#'):
                    direct.append(dict(site=hex(i.address),target=hex(int(i.op_str[1:],16)&~1),kind='call'))
                else: indirect.append(dict(site=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str))
            elif i.group(CS_GRP_JUMP) and i.op_str.startswith('#'):
                target=int(i.op_str[1:],16)&~1
                if target in fs and target!=addr and not contains(addr,target):
                    direct.append(dict(site=hex(i.address),target=hex(target),kind='cross_function_branch'))
            elif i.group(CS_GRP_JUMP) and i.op_str not in ('lr',):
                indirect.append(dict(site=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str))
        return direct,indirect
    def eligible(addr):
        return 0xA03E0000<=addr<0xA0446000 or addr in APP_HELPERS
    graphs=[]
    for root in (0xA03FE300,0xA03FE468,0xA0444ECC,0xA0445234,0xA01F3124):
        queue=deque([(root,[])]);seen=set();nodes=[];frontiers=[]
        while queue:
            addr,path=queue.popleft()
            if addr in seen: continue
            seen.add(addr)
            if addr not in fs or (addr!=root and not eligible(addr)):
                frontiers.append(dict(address=hex(addr),reason='missing_export' if addr not in fs
                    else 'outside_declared_codec_index_file_metadata_scope',path=path,
                    fifo_api=FIFO.get(addr)))
                continue
            direct,indirect=edges(addr)
            nodes.append(dict(address=hex(addr),direct=direct,indirect=indirect))
            for e in direct: queue.append((int(e['target'],16),path+[e['site']]))
        graphs.append(dict(root=hex(root),expanded_nodes=nodes,frontiers=frontiers,
            fifo_apis_reached=[dict(address=x['address'],name=x['fifo_api'],path=x['path'])
                               for x in frontiers if x['fifo_api']],
            unresolved_indirect_sites=sum(len(x['indirect']) for x in nodes)))
    # Search only the audited bodies. This is not a global absence assertion.
    mutations=set(FIFO)-{0xA0451960,0xA0451AFC}
    for graph in graphs:
        assert not any(int(x['address'],16) in mutations for x in graph['fifo_apis_reached'])

    # Real metadata instructions preserve the two representative track FIFO
    # handles. Canary bytes stand in for opaque objects, not a simulated FIFO.
    cases=[]
    for operation in ('restore_dts','reset_counts','reset_video_pts','iso_open_prefix'):
        m=native.machine(b);movie,fmt=0x10000000,0x10001000
        native.put(m,movie,1,1);native.put(m,movie+0x6f4,2,1)
        handles=[0x10003000,0x10003100]
        canary=bytes(range(128))
        for i,handle in enumerate(handles):
            t=movie+0x78+i*0x90
            native.track(m,t,90000,12345,90000+i*3000)
            native.put(m,t+0x89,i+1,1);native.put(m,t+0x30,handle)
            native.put(m,t+0x28,91000+i*3000,8)
            native.put(m,t+0xc,1001);native.put(m,t+0x78,1,2)
            m.mem_write(handle,canary)
        native.reg(m,native.UC_ARM_REG_R0,movie)
        if operation=='restore_dts': native.run(m,0xA04404D8)
        elif operation=='reset_counts': native.run(m,0xA01F68B8)
        elif operation=='reset_video_pts':
            native.reg(m,native.UC_ARM_REG_R0,movie+0x78);native.run(m,0xA01F721C)
        else:
            native.put(m,fmt+4,movie)
            for r,v in [(native.UC_ARM_REG_R0,fmt),(native.UC_ARM_REG_R1,0x10004000),
                        (native.UC_ARM_REG_R2,0x10005000),(native.UC_ARM_REG_R3,0)]:native.reg(m,r,v)
            native.run(m,0xA0435A18,0xA0435AA4)
        assert [native.get(m,movie+0x78+i*0x90+0x30) for i in range(2)] == handles
        assert all(bytes(m.mem_read(h,len(canary)))==canary for h in handles)
        cases.append(dict(case=operation,constructed_track_count=2,
            fifo_handle_words_preserved=True,opaque_object_canaries_preserved=True,passed=True))

    # The connected-camera split notification with param=3 has a distinct path
    # from loop's param=2 deletion path. For normal mode stop before logger;
    # for mode=6 the entire real function returns without any helper call.
    for camera_mode in (2,6):
        m=native.machine(b);m.mem_map(0xA1055000,0x1000)
        native.put(m,0xA1055CFA,camera_mode,1)
        native.reg(m,native.UC_ARM_REG_R0,3)
        stop=0xA011A2BC if camera_mode!=6 else native.END
        native.run(m,0xA011A208,stop)
        cases.append(dict(case='split_notification_parameter3',camera_mode=camera_mode,
            stop=hex(stop),executed_loop_deletion=False,passed=True,
            limitation='normal-mode execution stops before original logger'))

    # Exact linkage assertions, including static copy range and file vtable.
    c=capstone.Cs(CS_ARCH_ARM,CS_MODE_ARM)
    checks=[]
    for addr,mnem,operands in [(0xA03E41D8,'add','r1, r5, #0x50'),
        (0xA03E41E0,'movw','r2, #0x6b8'),(0xA03E41E8,'add','r0, r4, #0x50'),
        (0xA03E4200,'bl','#0xa029c680'),(0xA01F59CC,'str','r1, [fp]'),
        (0xA01F59D0,'str','r1, [r0, #4]'),(0xA01F5E2C,'bl','#0xa01e659c'),
        (0xA011A290,'bl','#0xa01f51d0')]:
        i=next(c.disasm(b[addr-BASE:addr-BASE+4],addr))
        assert (i.mnemonic,i.op_str)==(mnem,operands)
        checks.append(dict(address=hex(addr),mnemonic=mnem,operands=operands,passed=True))
    file_table=struct.unpack('<2I',b[0xA078A4AC-BASE:0xA078A4B4-BASE])
    assert file_table==(0xA0444ECC,0xA0445234)
    direct_callback,indirect_callback=edges(0xA01F569C)
    assert not any(int(x['target'],16) in mutations|{0xA01F6088,0xA01F6340}
                   for x in direct_callback)
    # Ordinary full close is positively identified, unlike callback rollover.
    full_close_direct,_=edges(0xA01F6088)
    deletes=[x for x in full_close_direct if int(x['target'],16)==0xA04514E4]
    assert len(deletes)==6
    sources=[]
    selected=set(a for g in graphs for a in (int(n['address'],16) for n in g['expanded_nodes']))
    selected.update((0xA01F569C,0xA01F6088,0xA01F6340,0xA03E41A0,0xA03E40C8,
        0xA03E29DC,0xA01F68B8,0xA01F4BC8,0xA0124470,0xA01F47CC,0xA0113594,
        0xA0113808,0xA01282E0,0xA011A208,0xA0119670,0xA0443CF0,0xA0445AB4,
        0xA043D1C0,0xA0443900,0xA0443720,0xA0442674,0xA04404D8))
    for a in sorted(selected):
        f=fs[a];payload=b''
        for r in f['body_ranges']:
            lo,hi=[int(x,16) for x in r.split('-')];payload+=b[lo-BASE:hi-BASE+1]
        row=dict(entry=hex(a),body_ranges=f['body_ranges'],bytes_sha256=sha(payload))
        if 'decompiled_file' in f:
            p=EXPORT/f['decompiled_file'];row.update(pseudocode=str(p.relative_to(ROOT)),
                pseudocode_sha256=sha(p.read_bytes()))
        sources.append(row)
    resolutions=[
        dict(site='0xa01f58ac',role='main_format_close',target='0xa03fe300',basis='MP4 vtable A078A404 +4'),
        dict(site='0xa01f58cc',role='main_file_close',target='0xa0445234',basis='Create A0445AB4 -> A0443CF0 -> file vtable A078A4AC +4'),
        dict(site='0xa01f5944',role='main_name_callback',target='0xa01f2be4',basis='A01F4BC8 sets A13C1774; default setup provenance, not captured runtime pointer'),
        dict(site='0xa01f5a18',role='main_file_open',target='0xa0444ecc',basis='file vtable A078A4AC +0'),
        dict(site='0xa01f5a2c',role='main_format_open',target='0xa03fe468',basis='MP4 vtable A078A404 +0'),
        dict(site='0xa01f5a64',role='split_counter_notification',target='0xa0119670',basis='A0124470 -> A01F47CC sets A13C2A5C; static setup provenance'),
        dict(site='0xa01f5e2c',role='ordinary_split_message',target='0xa01e659c',basis='0x48010003,param1=3 -> A0113808 action1C -> A01282E0 -> A011A208'),
    ]
    result=dict(evidence_type='offline bounded static direct-call graph and original metadata instructions; no actual FIFO or file IO',
        image=str(native.IMAGE),image_sha256=native.EXPECTED,
        dependency_script='scripts/prerecord-sync-boundary.py',
        dependency_sha256=sha((ROOT/'scripts/prerecord-sync-boundary.py').read_bytes()),
        graph_scope=dict(expand_range=['0xa03e0000','0xa0446000'],
            extra_app_helpers=[hex(x) for x in sorted(APP_HELPERS)],
            follows='immediate call targets and cross-function immediate branches to indexed entries',
            does_not_follow='indirect branches/calls; kernel/CFS/allocator/logger/memory/math leaves outside range'),
        graphs=graphs,callback_direct_edges=direct_callback,callback_indirect_sites=indirect_callback,
        callback_range=['0xa01f569c','0xa01f5ff0'],normal_full_close_delete_sites=deletes,
        linkage_assertions=checks,file_stream_vtable=dict(address='0xa078a4ac',open=hex(file_table[0]),close=hex(file_table[1])),
        static_resolutions=resolutions,cases=cases,passed_cases=len(cases),sources=sources,
        conclusion='No direct FIFO mutation API is reached inside the declared expanded graph; only PeekEntry is reached via ResetMovie/AdjustDTS. This is bounded evidence and not a complete ownership proof.',
        outstanding=[
            'No runtime pointer identities, FIFO cursor or pending descriptor/payload were captured.',
            'Graph records unresolved indirect index/stream calls and excluded external leaves; a complete no-mutation transitive closure is not established.',
            'Name generation can enter database/preferences; only default static setup provenance is recorded.',
            'Metadata handle preservation does not prove pointed-to FIFO state or encoder payload-ring lifetime.',
            'Substream callback ordering, error/assert paths and producer backpressure during close/open remain unverified.',
            'No playable native split, cross-file A/V continuity or 60-second prerecord was executed.'])
    OUT.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),passed_cases=len(cases),
        linkage_assertions=len(checks),source_functions=len(sources),graphs=[dict(root=g['root'],
        expanded_nodes=len(g['expanded_nodes']),frontiers=len(g['frontiers']),
        indirect_sites=g['unresolved_indirect_sites'],fifo_apis=g['fifo_apis_reached']) for g in graphs])))

if __name__=='__main__':main()
