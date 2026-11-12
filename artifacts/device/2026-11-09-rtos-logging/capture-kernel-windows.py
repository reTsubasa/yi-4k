import hashlib,json,sys,re,datetime
from pathlib import Path
sys.path.insert(0,'scripts')
from device_linux_capture import Telnet
from device_partition_capture import decode
root=Path('artifacts/device/2026-11-09-rtos-logging')
client=Telnet('192.168.42.1')
manifest=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source='/dev/mtdblock4',scope='Read-only logical flash windows; no running-memory access',windows=[])
try:
 client.login()
 mtd=client.command('cat /proc/mtd');assert re.search(r'mtd4: 00a00000 00020000 "LINUX_Kernel"',mtd)
 symbols=client.command("awk '$3 == \"stext\" || $3 == \"_text\" || $3 == \"_stext\" || $3 == \"phys_mem_access_prot\" || $3 == \"phys_mem_access_prot_allowed\" || $3 == \"pfn_valid\" || $3 == \"mmap_mem\" || $3 == \"read_mem\" || $3 == \"mem_types\" || $3 == \"valid_mmap_phys_addr_range\" || $3 == \"devmem_is_allowed\" || $3 == \"amba_heapmem_mmap\" || $3 == \"amba_dspmem_mmap\" || $3 == \"high_memory\" || $3 == \"__pv_phys_offset\"' /proc/kallsyms",timeout=12)
 (root/'kernel-focused-symbols.txt').write_text(symbols);assert re.search(r'(?m)^400081c0 [A-Za-z] _stext',symbols)
 for name,start,count in [('kernel-head.bin',0,32),('kernel-mem-drivers.bin',0x255000//4096,42)]:
  command='dd if=/dev/mtdblock4 bs=4096 skip=%d count=%d 2>/dev/null | base64'%(start,count)
  raw=client.command(command,timeout=25);data=decode(raw);assert len(data)==4096*count
  (root/name).write_bytes(data)
  manifest['windows'].append(dict(file=name,offset=start*4096,bytes=len(data),va=hex(0x40008000+start*4096),sha256=hashlib.sha256(data).hexdigest(),command=command))
 print(symbols)
finally:
 client.close();(root/'kernel-window-capture.json').write_text(json.dumps(manifest,indent=2)+'\n')
