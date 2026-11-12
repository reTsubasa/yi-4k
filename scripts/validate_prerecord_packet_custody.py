#!/usr/bin/env python3
"""Host + compiled ARM RAM-custody checks, including archived stock Close losses.

Never connects to a camera. Existing event3 outputs are read-only regression
inputs; this runner does not rerun native mux or prove durable SD storage.
"""
from __future__ import annotations
import argparse
import ctypes as ct
from fractions import Fraction
import hashlib
import io
import json
from pathlib import Path
import platform
import shutil
import struct
import subprocess
import tempfile
from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *
import audit_prerecord_real_gop as g

ROOT=Path(__file__).resolve().parents[1]
SOURCES=[ROOT/'sdk'/f'yi4k_1107_{n}.c' for n in ('packet_custody','early_copy','payload_copy','owned_mux')]
FIXTURE=ROOT/'sdk/offline/yi4k_packet_custody_fixture.c'
HEADERS=[ROOT/'sdk/yi4k_1107_packet_custody.h',*sorted((ROOT/'sdk').glob('yi4k_1107_*.h'))]
CAP=2048
def sha(data):return hashlib.sha256(data).hexdigest()
def run(argv):return subprocess.check_output(list(map(str,argv)),stderr=subprocess.STDOUT)

class Pair:
    def __init__(self, library, blob, symbols):
        self.lib=library;self.sym=symbols;self.u=Uc(UC_ARCH_ARM,UC_MODE_ARM)
        self.u.mem_map(0x10000000,0x100000)
        for seg in ELFFile(io.BytesIO(blob)).iter_segments():
            if seg['p_type']=='PT_LOAD' and seg['p_filesz']:self.u.mem_write(seg['p_vaddr'],seg.data())
        self.stack=0x100fe000;self.ret=0x100ff000;self.calls=0
    def call(self,name,*args):
        name='custody_fixture_'+name
        host=getattr(self.lib,name)(*args)
        regs=[UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3]
        saved=[UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11]
        for i,r in enumerate(saved):self.u.reg_write(r,0xaabb0000+i)
        self.u.reg_write(UC_ARM_REG_SP,self.stack);self.u.reg_write(UC_ARM_REG_LR,self.ret)
        for i,a in enumerate(args):
            if i<4:self.u.reg_write(regs[i],a&0xffffffff)
            else:self.u.mem_write(self.stack+4*(i-4),struct.pack('<I',a&0xffffffff))
        self.u.emu_start(self.sym[name],self.ret,count=2000000)
        assert self.u.reg_read(UC_ARM_REG_PC)==self.ret
        assert self.u.reg_read(UC_ARM_REG_SP)==self.stack
        assert [self.u.reg_read(r) for r in saved]==[0xaabb0000+i for i in range(8)]
        arm=ct.c_int32(self.u.reg_read(UC_ARM_REG_R0)).value
        assert host==arm,(name,host,arm)
        h=bytes((ct.c_uint32*12).in_dll(self.lib,'custody_fixture_report'))
        assert h==bytes(self.u.mem_read(self.sym['custody_fixture_report'],48))
        self.report=list(struct.unpack('<12I',h));self.calls+=1
        assert self.retained()==bytes(self.u.mem_read(self.sym['custody_fixture_retained'],CAP*16))
        return host
    def input(self,data):
        assert len(data)<=CAP
        ct.memmove(ct.addressof((ct.c_uint8*CAP).in_dll(self.lib,'custody_fixture_input')),data,len(data))
        self.u.mem_write(self.sym['custody_fixture_input'],data)
    def retained(self):return bytes((ct.c_uint8*(CAP*16)).in_dll(self.lib,'custody_fixture_retained'))
    def offer(self,seq,pts,data):
        self.input(data);return self.call('offer',seq,pts&0xffffffff,pts>>32,len(data))
    def check(self,seq,pts,data,id=1,alias=0):
        self.input(data);return self.call('check',seq,pts&0xffffffff,pts>>32,len(data),id,alias)

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output-dir',type=Path,required=True)
    out=ap.parse_args().output_dir.resolve();out.mkdir(parents=True,exist_ok=False)
    paths=list(dict.fromkeys([*SOURCES,FIXTURE,*HEADERS,Path(__file__).resolve()]))
    frozen={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in paths}
    clang=shutil.which('clang');candidates=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker=shutil.which('ld.lld') or str(candidates[-1]);assert clang
    common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin','-I'+str(ROOT/'sdk')]
    arm=['--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none','-ffreestanding','-fno-stack-protector','-fno-pic','-fno-unwind-tables','-fno-asynchronous-unwind-tables',*common]
    commands=[]
    def command(a):commands.append(list(map(str,a)));return run(a)
    rows=[]
    with tempfile.TemporaryDirectory(prefix='yi4k-custody-') as d:
        temp=Path(d);libpath=temp/'custody.dylib'
        command([clang,*(['-arch',platform.machine()] if platform.system()=='Darwin' else []),'-shared','-fPIC',*common,*SOURCES,FIXTURE,'-o',libpath])
        objects=[]
        for p in [*SOURCES,FIXTURE]:
            obj=temp/(p.name+'.o');command([clang,*arm,'-c',p,'-o',obj]);objects.append(obj)
        ld=temp/'custody.ld';ld.write_text((ROOT/'sdk/offline/yi4k_payload_copy_emulation.ld').read_text().replace('ENTRY(yi4k_1107_copy_payload)','ENTRY(custody_fixture_init)'))
        elfpath=out/'custody-offline.elf';command([linker,'-T',ld,*objects,'-o',elfpath])
        blob=elfpath.read_bytes();elf=ELFFile(io.BytesIO(blob));syms=list(elf.get_section_by_name('.symtab').iter_symbols())
        assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in syms)
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        sym={s.name:s['st_value'] for s in syms};lib=ct.CDLL(str(libpath));p=Pair(lib,blob,sym)
        data=bytes(range(64));second=bytes(reversed(range(64)))
        for kind in (1,2):
            for mode in ('success','full','capacity','close_failure','missing','duplicate','extra','order','changed_payload','changed_pts','wrong_segment','alias','no_complete','store_duplicate','store_pts_order','empty_close','premature_commit'):
                assert p.call('init',kind,1 if mode=='full' else 3,63 if mode=='capacity' else CAP)==0
                if mode=='empty_close':
                    assert p.call('closed',0)==-5 and p.report[:3]==[0,0,3]
                    rows.append(dict(name=('video' if kind==1 else 'audio')+'_'+mode,host_arm_equal=True,report=p.report,retained_sha256=sha(p.retained())))
                    continue
                s=p.offer(10,0x123456789,data)
                if mode=='capacity':
                    assert s==1 and p.report[0]==0 and p.report[3]==1
                    snapshot=p.retained();assert p.offer(11,0x123456b89,second)==103
                    assert p.retained()==snapshot
                else:
                    assert s==0 and p.report[3]==0 and p.retained()[:len(data)]==data
                    if mode=='full':
                        snapshot=p.retained();assert p.offer(11,0x123456b89,second)==1
                        assert p.report[0]==1 and p.report[3]==1 and p.retained()==snapshot
                        assert p.offer(12,0x123456f89,second)==103 and p.retained()==snapshot
                    elif mode in ('store_duplicate','store_pts_order'):
                        assert p.offer(10 if mode=='store_duplicate' else 11,0x123456b89 if mode=='store_duplicate' else 0x123456789,second)==-3 and p.report[3]==1 and p.report[2]==3
                    else:
                        assert p.offer(11,0x123456b89,second)==0
                        saved=p.retained()
                        if mode=='close_failure':assert p.call('closed',-12)==-4
                        else:
                            assert p.call('closed',0)==0 and p.report[0]==2
                            if mode=='premature_commit':assert p.call('commit',1,1)==-5
                            elif mode=='missing':
                                assert p.check(10,0x123456789,data)==0
                                assert p.call('commit',1,1)==-5
                            elif mode=='order':assert p.check(11,0x123456b89,second)==-3
                            elif mode=='changed_payload':assert p.check(10,0x123456789,second)==-3
                            elif mode=='changed_pts':assert p.check(10,0x12345678a,data)==-3
                            elif mode=='wrong_segment':assert p.check(10,0x123456789,data,id=2)==-3
                            elif mode=='alias':assert p.check(10,0x123456789,data,alias=1)==-3
                            else:
                                assert p.check(10,0x123456789,data)==0
                                if mode=='duplicate':assert p.check(10,0x123456789,data)==-3
                                else:
                                    assert p.check(11,0x123456b89,second)==0
                                    if mode=='extra':assert p.check(12,0x123456f89,second)==-3
                                    else:assert p.call('commit',1,0 if mode=='no_complete' else 1)==(-5 if mode=='no_complete' else 0)
                        assert p.retained()==saved
                        if mode=='success':
                            assert p.report[:3]==[0,0,0]
                            assert p.call('begin',1)==-1 and p.call('begin',2)==0
                        else:
                            assert p.report[0]==2 and p.report[2]==3
                            assert p.call('begin',2)==-2 and p.call('commit',1,1)==-2
                            assert p.retained()==saved
                rows.append(dict(name=('video' if kind==1 else 'audio')+'_'+mode,host_arm_equal=True,report=p.report,retained_sha256=sha(p.retained())))
        # Exact archived packet bytes read from MP4 file extents, not a receipt
        # copied from custody. Sequence/PTS metadata are supplied by our pinned
        # source mapping: MP4 itself has no original FIFO sequence number.
        source=g.s.SAMPLE_MP4;raw=source.read_bytes();assert sha(raw)==g.SOURCE_SHA
        source_probe=g.probe(source);source_audio=[x for x in g.packets(source_probe,raw) if x['stream']==1]
        regression=[];inputs={str(source.relative_to(ROOT)):sha(raw)}
        for segment in (1,2):
            path=ROOT/f'artifacts/device/2026-11-11-prerecord-event3-run02/event3-segment-{segment}.mp4'
            mp4=path.read_bytes();probe=g.probe(path);actual=[x for x in g.packets(probe,mp4) if x['stream']==1]
            expected=source_audio[(segment-1)*13:segment*13];assert len(expected)==13 and len(actual)==12
            inputs[str(path.relative_to(ROOT))]=sha(mp4)
            assert p.call('init',2,16,CAP)==0
            for e in expected:assert p.offer(e['index'],e['pts'],e['data'])==0
            saved=p.retained();assert p.call('closed',0)==0
            for e,a in zip(expected,actual):
                assert a['data']==e['data']
                assert p.check(e['index'],e['pts'],a['data'])==0
            assert p.call('commit',1,1)==-5 and p.report[:3]==[13,12,3]
            assert p.retained()==saved
            for i,e in enumerate(expected):assert p.retained()[i*CAP:i*CAP+len(e['data'])]==e['data']
            origin=Fraction(0) if segment==1 else Fraction(64064,240000)
            timing=[Fraction(a['pts'])*Fraction(probe['streams'][1]['time_base'])+origin-Fraction(e['pts'],48000) for e,a in zip(expected,actual)]
            missing=expected[-1];retained=out/f'event3-segment-{segment}-missing-aac-{missing["index"]}.bin';retained.write_bytes(missing['data'])
            regression.append(dict(segment=segment,submitted=13,final_mp4_packets=12,checked=12,
                missing_source_index=missing['index'],missing_pts=missing['pts'],missing_sha256=sha(missing['data']),
                retained_missing_payload=str(retained.relative_to(out)),commit_status=-5,all_source_bytes_retained=True,
                check_scope='payload + caller supplied original identity; separate exact container timing check below',
                exact_container_timing=all(x==0 for x in timing),timing_errors=[str(x) for x in timing]))
        assert all(sha((ROOT/name).read_bytes())==h for name,h in frozen.items())
        report=dict(schema=1,offline_only=True,status='pass',source_hashes=frozen,archived_input_hashes=inputs,
            compiled_arm_elf_sha256=sha(blob),host_arm_calls=p.calls,abi_preserved=True,undefined_symbols=0,relocations=0,
            cases=rows,event3_regressions=regression,commands=commands,
            limitations=['RAM retention only; no camera writes, storage flush, recovery/reassembly or 60-second throughput.',
                'Stock event3 MP4s are existing pinned artifacts, not newly executed native mux.',
                'MP4 original sequence/PTS mapping is caller-supplied; payload comparison cannot authenticate it.',
                'Container timing is checked separately and second segment remains rejected.',
                'This bounded module freezes on failure; it does not repair the stock assert or persist across power loss.'])
        (out/'validation.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(dict(output=str(out),cases=len(rows),event3_regressions=len(regression),host_arm_calls=p.calls,status='pass')))
if __name__=='__main__':main()
