"""Offline selected ARM ELF evidence. Never executes target files.
Needs pyelftools and Capstone. Some functions contain trailing literal pools.
PLT names resolved by decoding each ARM stub's GOT address, allowing Thumb veneers.
"""
from pathlib import Path
import argparse,re,struct
from elftools.elf.elffile import ELFFile
from capstone import Cs,CS_ARCH_ARM,CS_MODE_ARM,CS_MODE_THUMB
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--root',type=Path,default=Path('artifacts/linux-analysis/rootfs'))
parser.add_argument('--out',type=Path,default=Path('artifacts/linux-analysis/ipc-evidence'))
parser.add_argument('--names',nargs='+',help='Paths relative to root, overriding the standard set')
parser.add_argument('--function-filter',default='AmbaRpcProg_Util_Exec|AmbaMem_|AmbaEventNotify|ambaipc_clnt_create|ambaipc_clnt_call|nl_send_pkt|nl_recv_pkt|nl_open_socket')
args=parser.parse_args()
root=args.root;out=args.out
out.mkdir(parents=True,exist_ok=True)
names=['usr/bin/util_svc','usr/bin/SendToRTOS','usr/bin/RecvFromRTOS','usr/bin/example_sharepreview','usr/bin/remoteapi_cmd_daemon','usr/bin/remoteapi_data_daemon','usr/bin/ipcbind','usr/lib/libambamem.so.1','usr/lib/libambaipc.so','usr/lib/libambaeventnotifier.so.1']
if args.names:names=args.names
def imm(w):
 v=w&255;r=((w>>8)&15)*2
 return ((v>>r)|(v<<(32-r)))&0xffffffff if r else v
for name in names:
 with (root/name).open('rb') as f:
  e=ELFFile(f);sec=e.get_section_by_name('.text');sy=e.get_section_by_name('.dynsym');pl=e.get_section_by_name('.plt');rel=e.get_section_by_name('.rel.plt');labels={}
  if pl and rel:
   got={r['r_offset']:sy.get_symbol(r['r_info_sym']).name for r in rel.iter_relocations()}
   data=pl.data()
   for o in range(0,len(data)-11,4):
    a,b,c=struct.unpack_from('<III',data,o)
    if a&0xfffff000==0xe28fc000 and b&0xfffff000==0xe28cc000 and c&0xfffff000==0xe5bcf000:
     addr=pl['sh_addr']+o;g=(addr+8+imm(a)+imm(b)+(c&4095))&0xffffffff
     if g in got:labels[addr]=got[g]
  def listing(data,addr,mode):
   lines=[]
   md=Cs(CS_ARCH_ARM,mode);md.skipdata=True
   for ins in md.disasm(data,addr):
    annotation=''
    if ins.mnemonic in ('bl','blx','b.w','b') and ins.op_str.startswith('#'):
     v=int(ins.op_str[1:],0)
     if v in labels:annotation=' ; '+labels[v]
    lines.append(f'{ins.address:08x} {ins.mnemonic:8} {ins.op_str}{annotation}')
   return lines
  lines=[]
  for s in sy.iter_symbols():
   if s['st_info']['type']!='STT_FUNC' or s['st_shndx']=='SHN_UNDEF' or not s['st_size']:continue
   if not re.search(args.function_filter,s.name):continue
   addr=s['st_value']&~1;off=addr-sec['sh_addr']
   lines.append('\nFUNCTION '+s.name+' '+hex(s['st_value']))
   lines.extend(listing(sec.data()[off:off+s['st_size']],addr,CS_MODE_THUMB if s['st_value']&1 else CS_MODE_ARM))
  (out/(Path(name).name+'.selected.asm')).write_text('\n'.join(lines)+'\n')
  if '/bin/' in name:
   (out/(Path(name).name+'.text.asm')).write_text('\n'.join(listing(sec.data(),sec['sh_addr'],CS_MODE_ARM))+'\n')
  (out/(Path(name).name+'.plt.json')).write_text(__import__('json').dumps({hex(k):v for k,v in labels.items()},indent=2))
