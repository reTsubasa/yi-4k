#!/usr/bin/env python3
"""List static uses of PTB descriptor offsets in the public BLD."""
from pathlib import Path
import argparse,json,hashlib
from capstone import Cs,CS_ARCH_ARM,CS_MODE_ARM
BASE=0x10000000
SHA='259ed36093252298186c7e39c5f3400ba307f44224aba467ab885da8e1e5cbd7'
OFFSETS={0x20:'attribute',0x24:'allocated_size',0x28:'block_count',0x2c:'start_block',0x30:'load_address',0x34:'actual_size',0x38:'state_or_reserved',0x3c:'data_crc'}
def main():
 ap=argparse.ArgumentParser();ap.add_argument('input',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();d=a.input.read_bytes(); assert hashlib.sha256(d).hexdigest()==SHA
 md=Cs(CS_ARCH_ARM,CS_MODE_ARM);md.detail=True; refs=[]
 for ins in md.disasm(d,BASE):
  op=ins.op_str
  for off,name in OFFSETS.items():
   if f'#{hex(off)}' in op or f'#{off}' in op:
    refs.append({'address':hex(ins.address),'bytes':ins.bytes.hex(),'mnemonic':ins.mnemonic,'operands':op,'offset':hex(off),'field':name})
 out={'source':str(a.input),'sha256':SHA,'fields':OFFSETS,'references':refs,'counts':{name:sum(r['field']==name for r in refs) for name in OFFSETS.values()},'limitations':['A memory operand offset is only a structural reference; base register and control flow must be recovered separately.','This is public v1.10.52 BLD, not a byte identity claim for the 1.10.7 hidden BLD.']};a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n');print(json.dumps(out['counts']))
if __name__=='__main__':main()
