#!/usr/bin/env python3
"""Read-only boot-chain and recovery inventory over existing Telnet.

This intentionally does not open /dev/mem, does not write any device node,
and does not read beyond bounded metadata. It records Linux-visible evidence
that may identify the hidden boot/recovery interfaces.
"""
from __future__ import annotations
import argparse, datetime, json, re, time
from pathlib import Path
from device_linux_capture import Telnet

COMMANDS = [
 ('identity', 'uname -a; cat /proc/cmdline; cat /proc/version'),
 ('mtd_and_devices', 'cat /proc/mtd; ls -l /dev/mtd* /dev/mtdblock*; for x in /sys/class/mtd/mtd*/name /sys/class/mtd/mtd*/size /sys/class/mtd/mtd*/ro; do echo ===$x; cat $x 2>/dev/null; done'),
 ('boot_files', 'find / -xdev -type f \( -iname "*boot*" -o -iname "*ptb*" -o -iname "*firmware*" -o -iname "*recovery*" -o -iname "*upgrade*" \) -print 2>/dev/null | head -300'),
 ('proc_sys', 'find /proc -maxdepth 2 -type f -print 2>/dev/null | sort; find /sys -maxdepth 4 -type f -print 2>/dev/null | grep -Ei "boot|nand|mtd|firm|recovery|remoteproc|rpmsg|ambarella" | head -300'),
 ('ambarella', 'ls -la /proc/ambarella 2>/dev/null; for f in /proc/ambarella/*; do echo ===$f; cat "$f" 2>/dev/null; done'),
 ('logs', 'dmesg | grep -Ei "boot|nand|mtd|firm|recovery|upgrade|rpmsg|remoteproc|hiber|amba" | tail -300'),
 ('startup_services', 'cat /etc/inittab 2>/dev/null; for f in /etc/init.d/* /etc/rcS.d/* /etc/rc*.d/*; do [ -f "$f" ] && echo ===$f && sed -n "1,220p" "$f"; done 2>/dev/null | grep -Ei -C 4 "firm|upgrade|boot|recovery|mtd|nand|rtos|rpmsg" | head -500'),
 ('usb_serial', 'lsusb 2>/dev/null; ls -l /dev/tty* /dev/usb* /sys/bus/usb/devices/* 2>/dev/null | head -300'),
]

def main():
 p=argparse.ArgumentParser();p.add_argument('--host',default='192.168.42.1');p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
 t=Telnet(a.host);t.login(); manifest={'date_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'host':a.host,'scope':'bounded read-only Linux inventory; no writes, no /dev/mem, no raw NAND/OOB','commands':[]}
 try:
  for name,cmd in COMMANDS:
   st=time.monotonic(); out=t.command(cmd,timeout=40); (a.output/(name+'.txt')).write_text(out); manifest['commands'].append({'name':name,'elapsed_seconds':round(time.monotonic()-st,3),'output':name+'.txt','command':cmd}); print(name,len(out),flush=True)
 finally:t.close()
 (a.output/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__':main()
