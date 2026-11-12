#!/usr/bin/env python3
"""Reproduce focused Capstone listings for the pinned YI4K RTOS sample."""
from pathlib import Path
import hashlib
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB, CS_MODE_LITTLE_ENDIAN

BINARY=Path('artifacts/firmware/v1.10.52/_part_lrtos.a9s')
BASE=0xA0100000
SHA256='c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141'
RANGES=[
 ('shell_registration',0xA029E098,0x10C,False),
 ('loadbin',0xA02A2584,0x180,False),
 ('savebin',0xA02A3DB0,0x158,False),
 ('sleep_ps',0xA02A3824,0x2F0,False),
 ('stdio',0xA032E0C8,0x180,False),
 ('stdio_backend',0xA033A1B4,0x240,False),
 ('task_create_veneer',0xA03BC2BC,0x68,False),
 ('kal_task_and_mutex',0xA03BC30C,0x18C,False),
 ('kal_bytepool',0xA03BC6B0,0x68,False),
 ('threadx_sleep',0xA03C0B20,0xA4,False),
 ('threadx_create_check',0xA03C4240,0x24C,False),
 ('cache',0xA0498728,0x12C,False),
 ('cache_invalidate_low',0xA04A2038,0x100,False),
 ('cache_clean_low',0xA04A22CC,0xC0,False),
 ('cache_flush_low',0xA04A2568,0x90,False),
 ('strcmp',0xA04F9744,0x9A,True),
 ('strtoul',0xA04FB328,0x1C,True),
 ('aligned_alloc',0xA029A7D8,0x4C,False),
]

def main():
 data=BINARY.read_bytes()
 assert hashlib.sha256(data).hexdigest()==SHA256,'Unrecognized firmware: do not reuse these addresses.'
 out=Path('artifacts/rtos-reverse/core');out.mkdir(parents=True,exist_ok=True)
 for name,start,length,thumb in RANGES:
  md=Cs(CS_ARCH_ARM,(CS_MODE_THUMB if thumb else CS_MODE_ARM)|CS_MODE_LITTLE_ENDIAN)
  lines=[f'; SHA256 {SHA256}',f'; {name}, mode={"Thumb" if thumb else "ARM"}; selected range, not guaranteed function boundary']
  lines.extend(f'{i.address:08x}  {i.bytes.hex():<10} {i.mnemonic:<9} {i.op_str}' for i in md.disasm(data[start-BASE:start-BASE+length],start))
  (out/(name+'.asm')).write_text('\n'.join(lines)+'\n')
 print(f'Wrote {len(RANGES)} focused listings to {out}')
if __name__=='__main__':main()
