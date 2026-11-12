#!/usr/bin/env python3
"""Offline bounded AAC owner tests on host and compiled ARM in synthetic RAM.

No camera, original firmware calls, writer, codecs or SD persistence. Exact
rational oracle tests include uint64/uint32 cross products beyond 64 bits.
"""
from __future__ import annotations
import argparse,ctypes as ct,hashlib,io,json,platform,random,shutil,struct,subprocess,tempfile
from fractions import Fraction
from pathlib import Path
from elftools.elf.elffile import ELFFile
from unicorn import Uc,UC_ARCH_ARM,UC_MODE_ARM
from unicorn.arm_const import UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3,UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11,UC_ARM_REG_SP,UC_ARM_REG_LR,UC_ARM_REG_PC,UC_ARM_REG_CPSR
ROOT=Path(__file__).resolve().parents[1]
SOURCES=[ROOT/'sdk/yi4k_1107_aac_boundary.c',ROOT/'sdk/offline/yi4k_aac_boundary_test.c']
CASES=['exact_end_current','one_tick_crossing_held','real_fractional_crossing_preserves_source','busy_no_overwrite',
'safe_failure_retry_same_ticket','ambiguous_handoff_freezes','wrong_ticket_retains','duplicate_packet_rejected','sequence_gap_rejected',
'pts_gap_rejected','reorder_rejected','identity_change_rejected','config_change_rejected','epoch_change_rejected','timescale_change_rejected',
'duration_change_rejected','packet_end_overflow','uint64_exact_end','96bit_comparison','capacity_retry','ticket_overflow','sequence_wrap_rejected',
'advance_transactional_bounds','packet_before_source_origin','payload_alias_rejected','eos_rejected','video_rejected','descriptor_pts_mismatch',
'missing_binding_rejected','invalid_split','live_reinit_rejected','3003_packets_two_segments_once_only']
def sha(b):return hashlib.sha256(b).hexdigest()
def run(a):
 p=subprocess.run(list(map(str,a)),capture_output=True)
 if p.returncode:raise RuntimeError(p.stderr.decode()+p.stdout.decode())
 return p.stdout
class Arm:
 def __init__(self,blob,symbols):
  self.symbols=symbols;self.u=Uc(UC_ARCH_ARM,UC_MODE_ARM);self.u.mem_map(0x10000000,0x100000)
  for seg in ELFFile(io.BytesIO(blob)).iter_segments():
   if seg['p_type']=='PT_LOAD' and seg['p_filesz']:self.u.mem_write(seg['p_vaddr'],seg.data())
  self.stack=0x100fe000;self.ret=0x100ff000;self.u.reg_write(UC_ARM_REG_CPSR,0x13)
 def call(self,name,args):
  regs=[UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3]
  saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
  for i,r in enumerate(saved):self.u.reg_write(r,0xaabb0000+i)
  self.u.reg_write(UC_ARM_REG_SP,self.stack);self.u.reg_write(UC_ARM_REG_LR,self.ret)
  for i,a in enumerate(args):
   if i<4:self.u.reg_write(regs[i],a)
   else:self.u.mem_write(self.stack+4*(i-4),struct.pack('<I',a))
  self.u.emu_start(self.symbols[name],self.ret,count=50000000)
  assert self.u.reg_read(UC_ARM_REG_PC)==self.ret,'instruction budget exhausted'
  assert self.u.reg_read(UC_ARM_REG_SP)==self.stack
  assert [self.u.reg_read(r) for r in saved]==[0xaabb0000+i for i in range(8)]
  return ct.c_int32(self.u.reg_read(UC_ARM_REG_R0)).value
 def report(self):return list(struct.unpack('<12I',self.u.mem_read(self.symbols['yi4k_aac_boundary_report'],48)))
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output-dir',type=Path,required=True)
 out=ap.parse_args().output_dir.resolve();out.mkdir(parents=True,exist_ok=False)
 clang=shutil.which('clang');paths=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
 linker=shutil.which('ld.lld') or str(paths[-1]);assert clang and linker
 common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin','-I'+str(ROOT/'sdk')]
 flags=['--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none','-ffreestanding','-fno-stack-protector','-fno-pic','-fno-unwind-tables','-fno-asynchronous-unwind-tables',*common]
 commands=[];rows=[];random_rows=[]
 def command(a):commands.append(list(map(str,a)));return run(a)
 with tempfile.TemporaryDirectory(prefix='yi4k-aac-boundary-') as temp_dir:
  temp=Path(temp_dir);libpath=temp/'owner.dylib'
  command([clang,*(['-arch',platform.machine()] if platform.system()=='Darwin' else []),'-shared','-fPIC',*common,*SOURCES,'-o',libpath])
  objects=[]
  for source in SOURCES:
   obj=temp/(source.name+'.o');command([clang,*flags,'-c',source,'-o',obj]);objects.append(obj)
  ld=temp/'owner.ld';ld.write_text('ENTRY(yi4k_aac_boundary_test)\nSECTIONS { . = 0x10030000; .text : { *(.text*) } .rodata : { *(.rodata*) } .data : { *(.data*) } .bss (NOLOAD) : { *(.bss*) *(COMMON) } /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) *(.comment) } }\n')
  elfpath=out/'aac-boundary-offline.elf';command([linker,'-T',ld,*objects,'-o',elfpath])
  blob=elfpath.read_bytes();elf=ELFFile(io.BytesIO(blob));symbols=list(elf.get_section_by_name('.symtab').iter_symbols())
  assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
  assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
  sym={s.name:s['st_value'] for s in symbols};arm=Arm(blob,sym);library=ct.CDLL(str(libpath))
  test=library.yi4k_aac_boundary_test;test.argtypes=[ct.c_uint32];test.restype=ct.c_int32
  report=(ct.c_uint32*12).in_dll(library,'yi4k_aac_boundary_report')
  for i,name in enumerate(CASES):
   host=test(i);assert host==0,(name,'host failure line',host)
   arm_result=arm.call('yi4k_aac_boundary_test',[i]);assert arm_result==0,(name,'ARM failure line',arm_result)
   assert arm.report()==list(report),(name,'host/ARM reports differ')
   rows.append(dict(name=name,host_passed=True,compiled_arm_passed=True,abi_preserved=True,report=list(report)))
  classify=library.yi4k_aac_boundary_classify;classify.argtypes=[ct.c_uint32]*6;classify.restype=ct.c_int32
  rng=random.Random(0x41414342)
  numbers=[(1024,48000,1024,48000),(1024,48000,1023,48000),((1<<64)-1,0xffffffff,(1<<64)-1,0xffffffff),
   ((1<<64)-1,48000,(1<<64)-1,1),((1<<64)-1,1,(1<<64)-1,0xffffffff)]
  for _ in range(512):numbers.append((rng.randrange(1024,1<<64),rng.randrange(1,1<<32),rng.randrange(1,1<<64),rng.randrange(1,1<<32)))
  for end,scale,split,split_scale in numbers:
   expected=1 if Fraction(end,scale)<=Fraction(split,split_scale) else 2
   args=[end&0xffffffff,end>>32,scale,split&0xffffffff,split>>32,split_scale]
   assert classify(*args)==expected,(args,'host',expected)
   assert arm.call('yi4k_aac_boundary_classify',args)==expected,(args,'ARM',expected)
   random_rows.append(dict(packet_end=end,scale=scale,split=split,split_scale=split_scale,expected=expected))
 paths=[*SOURCES,ROOT/'sdk/yi4k_1107_aac_boundary.h',*sorted((ROOT/'sdk').glob('yi4k_1107_*.h')),Path(__file__).resolve()]
 result=dict(schema=1,status='pass',offline_only=True,cases=len(rows),rational_oracle_cases=len(random_rows),results=rows,
  rational_oracle=random_rows,commands=commands,compiled_arm_elf_sha256=sha(blob),
  source_hashes={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in dict.fromkeys(paths)},
  limitations=['Synthetic payloads and caller-supplied codec/source-time identities only; no live AAC or common hardware epoch validation.',
   'Custody receipt is caller attestation; ProcessAudio/Close success alone is insufficient and actual independent closed-file verification is external.',
   'One-slot ownership and exact split classification only, not live minute backend, producer scheduling, native mux, SD durability or deployment.'])
 (out/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
 print(json.dumps({k:result[k] for k in ['status','cases','rational_oracle_cases','compiled_arm_elf_sha256']},indent=2))
if __name__=='__main__':main()
