#!/usr/bin/env python3
"""Offline H264 start/header configuration audit, not a bitstream guarantee."""
import hashlib
import importlib.util
import itertools
import json
import struct
from pathlib import Path
import capstone
from unicorn import UC_HOOK_MEM_WRITE
from audit_eis_orc_core import DSP,REF,DSP_SHA,REF_SHA,CoreDecoder
from audit_eis_dsp_reference import inventory

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('native',ROOT/'scripts/prerecord-sync-boundary.py')
n=importlib.util.module_from_spec(spec);spec.loader.exec_module(n)
OUT=ROOT/'artifacts/device/2026-11-10-prerecord/prerecord-h264-header-contract-audit.json'

def sha(data):return hashlib.sha256(data).hexdigest()

def main():
 b=(ROOT/n.IMAGE).read_bytes();assert sha(b)==n.EXPECTED
 cases=[]
 # Start after stream selection, before the original real memset. The block
 # constructs a command until the actual H264ENC_START submit call, then stops.
 # No helper stubs, actual enqueue, DSP execution, FIFO or file IO.
 for mode,(fps,au),stream,count in itertools.product((0,5,6),((30,0),(120,1),(300,255)),(0,1),(1,2)):
  m=n.machine(b)
  for addr,size in ((0xA1456000,0x3000),(0xA14BD000,0x2000)):m.mem_map(addr,size)
  cfg,ctx,syscfg=0x10001000,0x10002000,0x10004000
  n.put(m,0xA06F3380,syscfg);n.put(m,0xA1457FE0,fps)
  n.put(m,0xA14BDB58,count);n.put(m,0xA06F3428,2 if fps==120 else 0,1)
  n.put(m,0xA14BDB70,5);n.put(m,0xA14BDAD8,1 if fps==300 else 0)
  for off,val,size in ((0x10,3840,2),(0x12,2160,2),(0x40,30,2),(0x44,1920,2),(0x54,mode,1)):
   n.put(m,syscfg+off,val,size)
  n.put(m,ctx+2,stream,1);n.put(m,ctx+0x1C,1,1);n.put(m,ctx+0x30,46000000)
  n.put(m,cfg+6,au,1);n.put(m,cfg+2,1,1)
  n.put(m,cfg+0x3E,16,2);n.put(m,cfg+0x40,16,2)
  n.put(m,n.SP+0x14,0xA06F3380);n.put(m,n.SP+4,count)
  m.mem_write(n.SP+0x28,b'\xff'*0x60)
  for reg,value in ((n.UC_ARM_REG_R4,cfg),(n.UC_ARM_REG_R5,ctx),(n.UC_ARM_REG_R7,stream),
                    (n.UC_ARM_REG_R11,0),(n.UC_ARM_REG_R10,cfg+1)):
   n.reg(m,reg,value)
  writes=[]
  def write_hook(machine,access,address,size,value,user):
   if address<=n.SP+0x62<address+size:
    writes.append(dict(pc=hex(machine.reg_read(n.UC_ARM_REG_PC)),address=hex(address),size=size,value=hex(value)))
  m.hook_add(UC_HOOK_MEM_WRITE,write_hook)
  n.run(m,0xA02D2ACC,0xA02D2DA4)
  cmd=m.reg_read(n.UC_ARM_REG_R1)
  assert cmd==n.SP+0x28 and m.reg_read(n.UC_ARM_REG_R0)==1
  flags=n.get(m,cmd+0x3A,2);actual_au=n.get(m,cmd+0x39,1)
  assert flags&0x20==0 and actual_au==au
  cases.append(dict(operation='real_start_command_build_prefix',constructed_system_mode=mode,fps=fps,
    stream=stream,pipeline_count=count,au_input=au,au_output=actual_au,
    header_halfword=hex(flags),sps_pps_header_mode=0,writes_overlapping_header_byte=writes,
    stop_before_submit='0xa02d2da4',passed=True))
 # Diagnostic code itself extracts bit5 and associates its concrete name.
 diagnostic=b[0xA05BA3B8-n.BASE:b.index(0,0xA05BA3B8-n.BASE)].decode()
 assert 'sps_pps_header_mode' in diagnostic
 m=n.machine(b);cmd=0x10001000;n.reg(m,n.UC_ARM_REG_R0,1);n.reg(m,n.UC_ARM_REG_R1,cmd)
 n.run(m,0xA02B7914,0xA02B7930);assert n.get(m,cmd)==0x02000002
 cases.append(dict(operation='real_start_command_code_prefix',result='0x02000002',stop_before_address_translation='0xa02b7930',passed=True))
 for byte in (0,0x1F,0x20,0x3F,0x40,0x60,0x80,0xFF):
  m=n.machine(b);cmd=0x10001000;n.put(m,cmd+0x3A,byte,1)
  n.reg(m,n.UC_ARM_REG_R4,cmd);n.run(m,0xA02B7BDC,0xA02B7BEC)
  assert m.reg_read(n.UC_ARM_REG_R1)==(byte>>5&1)
  pointer=m.reg_read(n.UC_ARM_REG_R0);assert pointer==0xA05BA3B8
  cases.append(dict(operation='original_header_mode_diagnostic_extract',byte=byte,result=byte>>5&1,passed=True))
 # Bounded two-instruction provenance: video ctx+97 -> start-config+6.
 for au in (0,1,255):
  m=n.machine(b);ctx,cfg=0x10001000,0x10002000
  n.put(m,ctx+0x97,au,1);n.reg(m,n.UC_ARM_REG_R4,ctx);n.reg(m,n.UC_ARM_REG_R5,cfg)
  n.run(m,0xA046C6C4,0xA046C6CC);assert n.get(m,cfg+6,1)==au
  cases.append(dict(operation='au_context_forwarding_slice',input=au,output=au,passed=True))
 c=capstone.Cs(capstone.CS_ARCH_ARM,capstone.CS_MODE_ARM)
 checks=[]
 expected={0xA02D2ACC:('add','ip, sp, #0x28'),0xA02D2AD0:('mov','r2, #0x60'),
  0xA02D2ADC:('blx','#0xa04f8dec'),0xA02D2C00:('bfi','r3, sb, #7, #3'),
  0xA02D2C04:('strh','r3, [sp, #0x62]'),0xA02D2DA4:('bl','#0xa02b7914'),
  0xA02B7BDC:('ldrb','r1, [r4, #0x3a]'),0xA02B7BE8:('ubfx','r1, r1, #5, #1'),
  0xA02D3080:('bfi','r3, r1, #1, #4'),0xA02D3084:('strb','r3, [sp, #0x62]'),
  0xA02B7918:('mov','r3, #2'),0xA02B791C:('movt','r3, #0x200'),0xA02B7928:('str','r3, [r1]'),
  0xA046C6C4:('ldrb','r3, [r4, #0x97]'),0xA046C6C8:('strb','r3, [r5, #6]')}
 for addr,pair in expected.items():
  i=next(c.disasm(b[addr-n.BASE:addr-n.BASE+4],addr));assert(i.mnemonic,i.op_str)==pair
  checks.append(dict(address=hex(addr),mnemonic=i.mnemonic,operands=i.op_str))
 # DSP reference is tied to stored identity by the existing inventory audit.
 # Decode supported core instructions only; never infer meanings for unknowns.
 dsp,ref=DSP.read_bytes(),REF.read_bytes();assert sha(dsp)==DSP_SHA and sha(ref)==REF_SHA
 member=inventory(dsp)[0];start=int(member['offset'],16);orc=dsp[start:start+member['bytes']]
 dec=CoreDecoder(ref.decode());orc_checks=[]
 expected_orc={0x9E3A4:'l.movhi r25,0x200',0x9E3A8:'l.ori r25,r25,0x2',
  0x9E3B0:'l.sfne r4,r25',0x9E3BC:'l.movhi r27,0x400',0x9E3C0:'l.ori r27,r27,0x2',
  0x9EDCC:'l.movhi r3,0x86',0x9EDD0:'l.ori r3,r3,0x6b8b',
  0x9E67C:'l.lwz r7,56(r12)',0x9E684:'l.srli r5,r7,13',0x9E68C:'l.andi r13,r5,0xf0',
  0x9E694:'l.sw 1292(r31),r9',0x9E6F4:'l.lhz r10,58(r12)',0x9E6FC:'l.andi r29,r10,0x1',
  0x9E704:'l.slli r27,r29,28',0x9E710:'l.sw 16(r14),r23',
  0x9E7F4:'l.lwz r29,1292(r6)',0x9E7F8:'l.movhi r3,0xffdf',0x9E7FC:'l.ori r3,r3,0xffff',
  0x9E80C:'l.and r27,r29,r3',0x9E818:'l.sw 1292(r6),r27',
  0x9E848:'l.lwz r21,56(r12)',0x9E850:'l.srli r7,r21,4',0x9E858:'l.and r17,r7,r5',
  0x9E860:'l.sw 1292(r13),r15',0x9FEF8:'l.lwz r21,1292(r5)',
  0x9FEFC:'l.srli r19,r21,21',0x9FF00:'l.andi r5,r19,0x1'}
 for addr,instruction in expected_orc.items():
  w=struct.unpack_from('<I',orc,addr)[0];assert dec.decode(w,addr)==instruction
  orc_checks.append(dict(offset=hex(addr),word=hex(w),instruction=instruction))
 regions=[]
 for lo,hi in ((0x9E3A4,0x9E3E0),(0x9E678,0x9E714),(0x9E7F4,0x9E88C),(0x9EDC8,0x9EDF8),(0x9FEF8,0x9FF24)):
  rows=[]
  for addr in range(lo,hi,4):
   w=struct.unpack_from('<I',orc,addr)[0];rows.append(dict(offset=hex(addr),word=hex(w),instruction=dec.decode(w,addr)))
  regions.append(dict(begin=hex(lo),end_exclusive=hex(hi),sha256=sha(orc[lo:hi]),instructions=rows))
 string=orc[0x266B8B:orc.index(0,0x266B8B)].decode();assert string.startswith('HENC:CMD: [ENC_START]')
 fs={int(f['entry'],16):f for f in json.loads((ROOT/n.EXPORT/'functions.json').read_text())}
 sources=[]
 for addr in (0xA02B7454,0xA02B7914,0xA02D296C,0xA046C454,0xA046E788,0xA0458914,0xA02CB728):
  f=fs[addr];data=b''.join(b[int(r.split('-')[0],16)-n.BASE:int(r.split('-')[1],16)-n.BASE+1] for r in f['body_ranges'])
  sources.append(dict(entry=hex(addr),ranges=f['body_ranges'],sha256=sha(data),pseudocode=f['decompiled_file'],pseudocode_sha256=sha((ROOT/n.EXPORT/f['decompiled_file']).read_bytes())))
 result=dict(image=str(n.IMAGE),image_sha256=n.EXPECTED,dsp_sha256=DSP_SHA,orc_sha256=sha(orc),decoder_reference_sha256=REF_SHA,
  evidence_type='Offline original ARM instruction slices/prefixes with constructed RAM; static ORC core decoding; no enqueue or bitstream capture',
  cpu_field=dict(command='H264ENC_START 0x02000002',offset='0x3a',bit=5,diagnostic_name='sps_pps_header_mode',diagnostic_string_address='0xa05ba3b8',diagnostic_string=diagnostic,observed_build_value=0,au_type_offset='0x39'),
  instruction_assertions=checks,execution_cases=cases,passed_cases=len(cases),sources=sources,
  orc_assertions=orc_checks,orc_regions=regions,orc_start_reference=dict(string_offset='0x266b8b',reference_pair=['0x9edcc','0x9edd0'],alias_delta='0x600000',text=string),
  conclusions=['The identified CPU H264 start builder initializes its command with actual memset and leaves named header_mode bit5 zero in 36 constructed mode/fps/stream/pipeline cases.',
    'au_type has separate provenance video context+97 -> start config+6 -> command+39; it is not header_mode.',
    'The ORC handler identifies 0x02000002/0x04000002 ENC_START, maps several neighboring fields, and explicitly clears state+0x50c bit21 in the audited path.',
    'No semantic mapping from header_mode value0/1 to every-IDR SPS/PPS insertion is established. The ORC state bit21 is not proven equivalent to the CPU command bit21.',
    'CPU configuration alone cannot prove that every mux type1 descriptor payload includes NAL7/NAL8.'],
  limitations=['Execution begins after stream selection and stops before DSP submit; complete start/task/device behavior not executed.',
   'Inputs and global state are constructed, not current camera settings; no exhaustive mode/configuration guarantee.',
   'No actual ORC execution or complete header-generation consumer/producer closure was established.',
   'No type1/IDR equivalence, NAL boundary/ring sample, playable split, or minute prerecord implementation was validated.'])
 OUT.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
 print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),execution_cases=len(cases),arm_assertions=len(checks),orc_assertions=len(orc_checks),source_functions=len(sources),header_mode=0)))

if __name__=='__main__':main()
