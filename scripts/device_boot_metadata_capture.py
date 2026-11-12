#!/usr/bin/env python3
"""Bounded read-only capture of MTD metadata for boot-chain analysis.

Reads only logical MTD block devices through the existing Telnet shell. It does
not access /dev/mem, raw NAND/OOB, or write any target file/configuration.
"""
from __future__ import annotations
import argparse, base64, datetime, hashlib, json, re
from pathlib import Path
from device_linux_capture import Telnet

CAPTURES = [
    ('vendor_data.bin', '/dev/mtdblock0', 0x20000),
    ('dsp_prefix.bin', '/dev/mtdblock2', 0x10000),
    ('sys_data_prefix.bin', '/dev/mtdblock3', 0x10000),
    ('reserved_prefix.bin', '/dev/mtdblock12', 0x10000),
]

def decode(s):
    lines=[]
    for line in s.splitlines():
        line=line.strip()
        if line and len(line)%4==0 and re.fullmatch(r'[A-Za-z0-9+/]+={0,2}',line): lines.append(line)
    return base64.b64decode(''.join(lines),validate=True)

def main():
    p=argparse.ArgumentParser();p.add_argument('--host',default='192.168.42.1');p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    a.output.mkdir(parents=True,exist_ok=True)
    c=Telnet(a.host); c.login(); manifest={'date_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'host':a.host,'scope':'bounded logical MTD reads only; no writes, no raw NAND/OOB, no /dev/mem','captures':[]}
    try:
        mtd=c.command('cat /proc/mtd; for x in /sys/class/mtd/mtd*/name /sys/class/mtd/mtd*/size /sys/class/mtd/mtd*/offset /sys/class/mtd/mtd*/ro; do echo ===$x; cat $x 2>/dev/null; done; ls -l /dev/mtd* /dev/mtdblock*')
        (a.output/'metadata.txt').write_text(mtd)
        for name,dev,n in CAPTURES:
            path=a.output/name
            if path.exists(): raise FileExistsError(path)
            raw=c.command(f'dd if={dev} bs=4096 count={n//4096} 2>/dev/null | base64',timeout=30)
            data=decode(raw); assert len(data)==n,(name,len(data),n)
            path.write_bytes(data)
            remote=c.command(f'dd if={dev} bs=4096 count={n//4096} 2>/dev/null | sha256sum',timeout=30)
            (a.output/(name+'.remote-hash.txt')).write_text(remote)
            m=re.search(r'(?m)^([0-9a-f]{64})\s+-',remote); digest=hashlib.sha256(data).hexdigest(); assert m and m[1]==digest,(name,remote,digest)
            manifest['captures'].append({'file':name,'source':dev,'bytes':n,'sha256':digest,'remote_hash_matches':True})
        (a.output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
        print(json.dumps({'captures':len(CAPTURES),'verified':True,'device_modified':False}))
    finally:c.close()
if __name__=='__main__':main()
