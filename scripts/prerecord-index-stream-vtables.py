#!/usr/bin/env python3
"""Offline conditional vtable expansion; never connects to the camera.

Targets apply to the stock App MP4/file creation path and the union of its three
index backends. Unknown external leaves remain; this is not runtime ownership.
"""
import hashlib
import importlib.util
import json
import struct
from collections import deque
from pathlib import Path
import capstone
from capstone import CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB, CS_GRP_CALL, CS_GRP_JUMP

ROOT=Path(__file__).resolve().parents[1]
SPEC=importlib.util.spec_from_file_location('native', ROOT/'scripts/prerecord-sync-boundary.py')
native=importlib.util.module_from_spec(SPEC);SPEC.loader.exec_module(native)
TABLES={
 'mem_index':(0xA078A458,[0xA04032FC,0xA0402ED8,0xA0402884,0xA0402750,0xA0402600,0xA0402D34,0xA0402608]),
 'raw_index':(0xA078A474,[0xA04053B8,0xA04055EC,0xA04040B4,0xA0403F18,0xA04039B8,0xA040506C,0xA0404F70]),
 'temp_index':(0xA078A490,[0xA0406F64,0xA04068AC,0xA0406384,0xA040614C,0xA0405FC8,0xA0406628,0xA0405E58]),
 'file':(0xA078A4AC,[0xA0444ECC,0xA0445234,0xA0444D34,0xA0444B78,0xA0445314,0xA0443FA8,0xA0444A0C,0xA04455D0,0xA0445438]),
}
FIFO={0xA04509DC:'Create',0xA04514E4:'Delete',0xA0451960:'PeekEntry',0xA0451AFC:'RevPeekEntry',
      0xA0451C94:'RemoveEntry',0xA045202C:'PrepareEntry',0xA0452254:'WriteEntry',0xA0452B68:'EraseAll',0xA0452E9C:'Resume'}
RESOLUTIONS={}
def resolve(sites,kind,offset=None,target=None):
 for site in sites:
  targets=([target] if isinstance(target,int) else target if target is not None else [TABLES['file'][1][offset//4]] if kind=='file'
           else [TABLES[k][1][offset//4] for k in ('mem_index','raw_index','temp_index')])
  RESOLUTIONS[site]=dict(kind=kind,slot=offset,targets=targets)

resolve([0xA03E2640,0xA03E2718], 'file',0xC)
resolve([0xA0401298], 'index',8)
resolve([0xA04012C0], 'file',0x10)
resolve([0xA04012E8], 'file',8)
resolve([0xA0401454], 'index',0xC)
resolve([0xA040C090,0xA040C250,0xA040D134,0xA040F37C,0xA040F4E4], 'index',0x14)
resolve([0xA040C12C,0xA040C1A8,0xA040C484], 'index',8)
resolve([0xA040C284,0xA040CBD8,0xA040CD90,0xA040D158], 'index',0xC)
resolve([0xA040C29C], 'index',0x10)
resolve([0xA0433E6C,0xA0433F34,0xA0434C50], 'file',0x14)
resolve([0xA0433F58,0xA0433FC4,0xA0434D80,0xA0435070], 'file',0x18)
resolve([0xA0433FF4,0xA0434058,0xA04340BC,0xA0434194,0xA043420C,
         0xA0434AD8,0xA0434D04,0xA0434DC0,0xA043509C], 'file',0x10)
resolve([0xA0435AF8], 'file',0x20)
resolve([0xA0435B98], 'index',0)
resolve([0xA0435EA0,0xA04360D0], 'index',4)
resolve([0xA0435BE0,0xA0434B74,0xA0434C04], 'stock_ftyp_callback',target=0xA0435630)
resolve([0xA0433F1C,0xA0434C34], 'stock_moov_writer_callback',target=0xA0433AF0)
resolve([0xA0434A00], 'stock_moov_size_callback',target=0xA0433C1C)
resolve([0xA03E22C8,0xA03E2590,0xA04263A4,0xA03E2418,0xA03E24F0,
         0xA03E2368,0xA03E27D4,0xA03E2868,0xA042A784,0xA042EED8,
         0xA042DD04,0xA040218C,0xA04023D4,0xA040D4E8], 'file',0xC)
resolve([0xA04020B4,0xA04022F8,0xA0402540], 'index',8)
# RawIdx_Access has caller-supplied callbacks. The union includes both read
# and write callers. Writes use an old export's unindexed DAT_A0404208 body.
resolve([0xA0403B5C,0xA0403C14], 'raw_partial_callback',target=[0xA040447C,0xA0404208])
resolve([0xA0403BD4], 'raw_block_callback',target=[0xA0404684,0xA0483B28])

def main():
 b=(ROOT/native.IMAGE).read_bytes();assert hashlib.sha256(b).hexdigest()==native.EXPECTED
 fs={int(f['entry'],16):f for f in json.loads((ROOT/native.EXPORT/'functions.json').read_text())}
 # These four tiny returns and one raw partial-write helper are absent from
 # the old export. Bound them by raw return instructions / next actual entry.
 for lo,hi in [(0xA0402600,0xA0402607),(0xA0402608,0xA040260F),
               (0xA04039B8,0xA04039BF),(0xA0405E58,0xA0405E5F),
               (0xA0404208,0xA040447B)]:
  fs[lo]=dict(entry=hex(lo),thumb_context='0',body_ranges=[f'{lo:x}-{hi:x}'])
 tables=[]
 for name,(addr,expected) in TABLES.items():
  values=list(struct.unpack('<'+'I'*len(expected),b[addr-native.BASE:addr-native.BASE+4*len(expected)]))
  assert values==expected
  tables.append(dict(name=name,address=hex(addr),entries=[hex(v) for v in values],sha256=hashlib.sha256(b[addr-native.BASE:addr-native.BASE+4*len(expected)]).hexdigest()))
 c=capstone.Cs(CS_ARCH_ARM,CS_MODE_ARM);c.detail=True
 checks=[]
 for addr,mnemonic,operands in [
   (0xA04026A0,'movw','r3, #0xa458'),(0xA04026A8,'movt','r3, #0xa078'),(0xA04026B4,'str','r3, [r5]'),
   (0xA0403A54,'movw','r3, #0xa474'),(0xA0403A5C,'movt','r3, #0xa078'),(0xA0403A68,'str','r3, [r5]'),
   (0xA04066E8,'movw','r3, #0xa490'),(0xA04066F0,'movt','r3, #0xa078'),(0xA04066F4,'str','r3, [r5]'),
   (0xA0443D40,'movw','r3, #0xa4ac'),(0xA0443D48,'movt','r3, #0xa078'),(0xA0443D50,'str','r3, [r4]')]:
  i=next(c.disasm(b[addr-native.BASE:addr-native.BASE+4],addr))
  assert (i.mnemonic,i.op_str)==(mnemonic,operands)
  checks.append(dict(address=hex(addr),mnemonic=mnemonic,operands=operands))
 # Execute the real default-config routine, including its real memset, and
 # the four unindexed constant returns. No IO/kernel callbacks are replaced.
 m=native.machine(b);cfg=0x10000000
 native.reg(m,native.UC_ARM_REG_R0,cfg);native.run(m,0xA03FECCC)
 assert native.get(m,cfg+0x10)==0xA0433AF0 and native.get(m,cfg+0x14)==0xA0433C1C
 cases=[dict(operation='stock_default_config_complete',moov_writer='0xa0433af0',moov_size='0xa0433c1c',passed=True)]
 for addr in (0xA0402600,0xA0402608,0xA04039B8,0xA0405E58):
  m=native.machine(b);native.reg(m,native.UC_ARM_REG_R0,0xDEADBEEF);native.run(m,addr)
  assert m.reg_read(native.UC_ARM_REG_R0)==0
  cases.append(dict(operation='constant_return_complete',address=hex(addr),result=0,passed=True))
 windows=[]
 for site,resolution in sorted(RESOLUTIONS.items()):
  ins=list(c.disasm(b[site-native.BASE-32:site-native.BASE+4],site-32))
  assert ins[-1].address==site and ins[-1].group(CS_GRP_CALL) and not ins[-1].op_str.startswith('#')
  windows.append(dict(site=hex(site),**{k:([hex(v) for v in x] if k=='targets' else x) for k,x in resolution.items()},
      instructions=[f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in ins],
      bytes_sha256=hashlib.sha256(b[site-native.BASE-32:site-native.BASE+4]).hexdigest()))
 decoded={};sources=set()
 def edges(addr):
  f=fs[addr];md=capstone.Cs(CS_ARCH_ARM,CS_MODE_THUMB if f['thumb_context']=='1' else CS_MODE_ARM);md.detail=True
  direct=[];unresolved=[];resolved=[]
  ranges=[tuple(int(a,16) for a in r.split('-')) for r in f['body_ranges']]
  for lo,hi in ranges:
   for i in md.disasm(b[lo-native.BASE:hi-native.BASE+1],lo):
    if i.group(CS_GRP_CALL):
     if i.op_str.startswith('#'):direct.append((int(i.op_str[1:],16)&~1,i.address,'direct'))
     elif i.address in RESOLUTIONS:
      for target in RESOLUTIONS[i.address]['targets']:direct.append((target,i.address,RESOLUTIONS[i.address]['kind']))
      resolved.append(hex(i.address))
     else:unresolved.append(dict(site=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str))
    elif i.group(CS_GRP_JUMP) and i.op_str.startswith('#'):
     target=int(i.op_str[1:],16)&~1
     if target in fs and target!=addr and not any(x<=target<=y for x,y in ranges):direct.append((target,i.address,'tail'))
    elif i.group(CS_GRP_JUMP) and i.op_str!='lr':unresolved.append(dict(site=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str))
  return direct,resolved,unresolved
 graphs=[]
 for root in (0xA03FE300,0xA03FE468):
  queue=deque([(root,[])]);seen=set();nodes=[];leaves=[]
  while queue:
   addr,path=queue.popleft()
   if addr in seen:continue
   seen.add(addr)
   if addr not in fs or not 0xA03E0000<=addr<0xA0446000:
    leaves.append(dict(address=hex(addr),path=path,reason='missing_export' if addr not in fs else 'outside_declared_scope',fifo_api=FIFO.get(addr)));continue
   sources.add(addr);direct,resolved,unresolved=edges(addr)
   nodes.append(dict(address=hex(addr),resolved_sites=resolved,unresolved=unresolved,
      edges=[dict(target=hex(t),site=hex(s),kind=k) for t,s,k in direct]))
   for target,site,kind in direct:queue.append((target,path+[dict(site=hex(site),kind=kind)]))
  graphs.append(dict(root=hex(root),expanded_nodes=nodes,external_leaves=leaves,
    unresolved_sites=sum(len(n['unresolved']) for n in nodes),resolved_sites=sum(len(n['resolved_sites']) for n in nodes),
    fifo_apis=[x for x in leaves if x['fifo_api']]))
 provenance=[0xA02042A8,0xA0402610,0xA04039C0,0xA040669C,0xA0443CF0,0xA03FECCC,0xA03FDEC4,0xA01F3338,0xA04014E4,0xA040EE8C]
 sources.update(provenance)
 fingerprints=[]
 for a in sorted(sources):
  f=fs[a];payload=b''.join(b[int(r.split('-')[0],16)-native.BASE:int(r.split('-')[1],16)-native.BASE+1] for r in f['body_ranges'])
  row=dict(entry=hex(a),ranges=f['body_ranges'],sha256=hashlib.sha256(payload).hexdigest())
  if 'decompiled_file' in f:row.update(pseudocode=f['decompiled_file'],pseudocode_sha256=hashlib.sha256((ROOT/native.EXPORT/f['decompiled_file']).read_bytes()).hexdigest())
  fingerprints.append(row)
 result=dict(image=str(native.IMAGE),image_sha256=native.EXPECTED,evidence_type='conditional static target recovery and bounded graph expansion; no camera, FIFO or file execution',
  assumption='Stock App MP4/file constructors and default MP4 callbacks; runtime pointer identities unobserved. Index backend is a union, not a selected runtime value.',
  scope='Expand indexed entries in [A03E0000,A0446000); leave CFS, kernel, math, memory and all other external targets explicit.',
  tables=tables,resolutions=windows,constructor_assertions=checks,execution_cases=cases,graphs=graphs,sources=fingerprints,
  limitations=['Original unknown-site classification is reviewed from raw load windows and Ghidra argument flow, not inferred only from matching offsets.',
   'Recovered callback targets are defaults whose actual runtime object values were not captured.',
   'Newly reached calls, external leaves and unresolved indirect sites are not a complete no-mutation proof.',
   'No next FIFO peek, payload lifetime, SPS/PPS repeat, playable split or prerecord behavior was executed.'])
 out=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-index-stream-vtables-audit.json'
 out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
 print(json.dumps(dict(output=str(out.relative_to(ROOT)),recovered_sites=len(windows),source_functions=len(fingerprints),graphs=[dict(root=g['root'],nodes=len(g['expanded_nodes']),leaves=len(g['external_leaves']),resolved=g['resolved_sites'],unresolved=g['unresolved_sites'],fifo=g['fifo_apis']) for g in graphs])))
 if any(g['fifo_apis'] for g in graphs):raise AssertionError('FIFO API reached; inspect before interpreting')

if __name__=='__main__':main()
