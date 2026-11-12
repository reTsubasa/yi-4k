#!/usr/bin/env python3
"""Compare public BST/BLD/FW_UP components without making a flash image.

The result separates packer metadata from linked-code observations.  It is
useful for deciding what a Linux-visible PTB does and does not expose.
"""
from __future__ import annotations
import argparse, hashlib, json, re, struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

BASES={'bst':0x00000000,'bld':0x10000000,'fw_up':0x00100000}

def header(path):
    out={}
    for line in path.read_text(errors='replace').splitlines():
        if '=' in line and not line.lstrip().startswith('#'):
            k,v=line.split('=',1); out[k.strip()]=v.strip()
    return out

def strings(data,minlen=5):
    out=[]
    for m in re.finditer(rb'[ -~]{%d,}'%minlen,data):
        out.append({'offset':m.start(),'text':m.group().decode('ascii','replace')})
    return out

def disasm(data,base,limit=0x2000):
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM); md.detail=False
    out=[]
    for ins in md.disasm(data[:limit],base):
        out.append({'address':f'0x{ins.address:08x}','bytes':ins.bytes.hex(),'mnemonic':ins.mnemonic,'operands':ins.op_str})
    return out

def common_windows(a,b,window=64,step=4,limit=40):
    # bounded exact windows: a location -> b location, enough to identify code reuse
    index={b[i:i+window]:i for i in range(0,max(0,len(b)-window+1),step)}
    hits=[]
    for i in range(0,max(0,len(a)-window+1),step):
        j=index.get(a[i:i+window])
        if j is not None: hits.append((i,j))
    # coalesce nearby windows
    runs=[]
    for i,j in hits:
        if runs and i-runs[-1][0] <= step and j-runs[-1][1] <= step:
            runs[-1]=(runs[-1][0],runs[-1][1],runs[-1][2]+step)
        else:runs.append((i,j,window))
    return [{'a_offset':hex(i),'b_offset':hex(j),'bytes':n} for i,j,n in runs[:limit]]

def longest_runs(a: bytes, b: bytes, window=256, step=4, limit=20):
    """Find bounded exact runs, extending a 256-byte hash hit byte by byte."""
    index = {b[i:i+window]: i for i in range(0, max(0, len(b)-window+1), step)}
    hits = []
    for i in range(0, max(0, len(a)-window+1), step):
        j = index.get(a[i:i+window])
        if j is None:
            continue
        n = window
        while i+n < len(a) and j+n < len(b) and a[i+n] == b[j+n]:
            n += 1
        # Exclude long all-zero/all-ff padding from the code-reuse evidence.
        body = a[i:i+n]
        if body.count(0) == n or body.count(0xff) == n:
            continue
        hits.append((n, i, j))
    out=[]
    for n,i,j in sorted(hits, reverse=True):
        if any(abs(i-x['a_offset_int']) < n and abs(j-x['b_offset_int']) < n for x in out):
            continue
        out.append({'a_offset':hex(i),'b_offset':hex(j),'bytes':n,'a_offset_int':i,'b_offset_int':j})
        if len(out) >= limit: break
    for x in out:
        x.pop('a_offset_int'); x.pop('b_offset_int')
    return out

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('root',type=Path); ap.add_argument('--output',required=True,type=Path); args=ap.parse_args()
    root=args.root
    parts={name:(root/f'_part_{name}.a9s').read_bytes() for name in BASES}
    result={'source':'public v1.10.52 components','components':{},'comparisons':{},'limitations':[]}
    needles=[b'BOOTSTRAP',b'BOOTLOADER',b'FW_UPDATER',b'SYS_SW',b'LINUX_Kernel',b'Normal updater boot',b'BootTimes is %d',b'Partition full',b'Write partition']
    for name,data in parts.items():
        hs=header(root/f'_part_{name}.a9h')
        result['components'][name]={'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'header':hs,'load_base':hex(BASES[name]),'first_words':[f'0x{x:08x}' for x in struct.unpack('<%dI'%(min(16,len(data)//4),),data[:64])],'needle_hits':[],'strings':strings(data),'disassembly_first_0x2000':disasm(data,BASES[name])}
        for needle in needles:
            for m in re.finditer(re.escape(needle),data): result['components'][name]['needle_hits'].append({'text':needle.decode(),'file_offset':hex(m.start()),'runtime_address':hex(BASES[name]+m.start())})
    result['comparisons']['bld_fw_up_common_64']=common_windows(parts['bld'],parts['fw_up'])
    result['comparisons']['bst_fw_up_common_64']=common_windows(parts['bst'],parts['fw_up'])
    result['comparisons']['bld_fw_up_longest_nonpadding']=longest_runs(parts['bld'],parts['fw_up'])
    result['comparisons']['bst_fw_up_longest_nonpadding']=longest_runs(parts['bst'],parts['fw_up'])
    result['comparisons']['bld_fw_up_exact']=parts['fw_up'].find(parts['bld'])
    result['comparisons']['bst_fw_up_exact']=parts['fw_up'].find(parts['bst'])
    result['interpretation']=[
      'BST is a 4096-byte separately packed component with mem_addr=0; its bytes are not present as a contiguous copy in FW_UP.',
      'BLD is separately packed at load address 0x10000000; the public FW_UP contains many exact 64-byte windows from BLD routines but no complete contiguous BLD copy.',
      'FW_UP header mem_addr=0x00100000 is a linked load context distinct from RTOS PPM2 0xA0100000 and Linux kernel 0x3ca08000.',
      'Shared code proves updater/bootloader implementation overlap, not that FW_UP can be loaded as a normal RTOS image or that it exposes a device recovery command over Linux.',
    ]
    result['limitations']=['Public components are v1.10.52 references; the device is 1.10.7.','No signature/OOB policy or hidden NAND offsets are inferred from byte similarity.','No device writes or updater execution were performed.']
    args.output.parent.mkdir(parents=True,exist_ok=True); args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'components':{k:len(v) for k,v in parts.items()},'common_bld_fw_up_64':len(result['comparisons']['bld_fw_up_common_64']),'exact_bld':result['comparisons']['bld_fw_up_exact']}))
if __name__=='__main__':main()
