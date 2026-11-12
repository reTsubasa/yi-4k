from pathlib import Path
import json,hashlib
from capstone import Cs,CS_ARCH_ARM,CS_MODE_ARM,CS_MODE_LITTLE_ENDIAN
root=Path('artifacts/device/2026-11-09-rtos-logging');manifest=json.loads((root/'kernel-window-capture.json').read_text())
windows=[]
for row in manifest['windows']:
 b=(root/row['file']).read_bytes();assert hashlib.sha256(b).hexdigest()==row['sha256'];windows.append((int(row['va'],16),b))
selected=[('head',0x40008000,0x220),('pfn_valid',0x40016494,0x80),('devmem_range_checks',0x40017d14,0x100),('read_mem',0x40265578,0x3c8),('mmap_mem',0x40265940,0x3b0),('amba_dspmem_mmap',0x4027f694,0x110)]
md=Cs(CS_ARCH_ARM,CS_MODE_ARM|CS_MODE_LITTLE_ENDIAN);out=[]
for name,va,size in selected:
 for start,b in windows:
  off=va-start
  if 0<=off and off+size<=len(b):break
 else:raise ValueError(hex(va))
 out.append('\nFUNCTION_WINDOW '+name+' '+hex(va)+'\n')
 for ins in md.disasm(b[off:off+size],va):out.append('%08x %-8s %s\n'%(ins.address,ins.mnemonic,ins.op_str))
(root/'kernel-selected.asm').write_text(''.join(out))
