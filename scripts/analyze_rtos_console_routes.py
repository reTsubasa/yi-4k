#!/usr/bin/env python3
"""Hash-pinned static audit of stock USB routes and diagnostic file output."""
import hashlib
import json
from pathlib import Path
import shutil
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, __version__
from analyze_sharepreview_init_dependencies import SOURCE, BASE, SHA256


def main():
    # SOURCE is .../2026-11-09-linux/rtos-analysis.
    output=SOURCE.parent.parent/'2026-11-10-rtos-console-route'/'static-audit'
    output.mkdir(parents=True,exist_ok=True)
    data=(SOURCE/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(data).hexdigest()==SHA256
    rows={int(row['entry'],16):row for row in json.loads((SOURCE/'full/functions.json').read_text())}
    functions={
        0xA0192474:'USB connected/disconnected mode dispatch',
        0xA0231FC8:'USB UART initialization',0xA023166C:'CDC task startup',
        0xA0231408:'CDC bulk receive',0xA0231538:'CDC bulk send',
        0xA01B8C20:'NetCar CLI/Exec tasks creation',
        0xA01B7994:'NetCar byte-stream command accumulation',
        0xA01B8710:'NetCar packet validation',
        0xA01B83FC:'NetCar supported service dispatch',
        0xA01B8134:'VehicleID/WifiInfo JSON parsing',
        0xA0233608:'UVC video resources; shell string is not a command parser',
        0xA0233340:'UVC host encoding callback',
        0xA0197424:'console marker enables UART0 shell callbacks',
        0xA029DE40:'install general shell IO callbacks',
        0xA029CB84:'command file redirection',0xA029C974:'command table dispatch',
        0xA029D4D8:'Shell execution task and autoexec event',
        0xA0238170:'VideoAnal initialized flag and task creation',
        0xA023809C:'VideoAnal task receive-and-dispatch loop',
        0xA03C4500:'checked task information wrapper',
    }
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    evidence=[];decoded={}
    for address,role in functions.items():
        row=rows[address];raw=b'';listing=[]
        for span in row['body_ranges']:
            start,last=(int(x,16) for x in span.split('-'))
            chunk=data[start-BASE:last-BASE+1];raw+=chunk
            instructions=list(md.disasm(chunk,start))
            assert sum(i.size for i in instructions)==len(chunk)
            for i in instructions:
                decoded[i.address]=(i.mnemonic,i.op_str)
                listing.append('%08x %s %s'%(i.address,i.mnemonic,i.op_str))
        label='%08x'%address
        (output/(label+'.asm')).write_text('\n'.join(listing)+'\n')
        pseudocode=SOURCE.parent.parent/'2026-11-10-rtos-console-route/focused'/(label+'.c')
        if not pseudocode.exists():pseudocode=SOURCE/'full/decompiled'/(label+'.c')
        if pseudocode.exists():shutil.copyfile(pseudocode,output/(label+'.c'))
        evidence.append({'entry':hex(address),'role_inferred':role,'body_ranges_inclusive':row['body_ranges'],
                         'body_sha256':hashlib.sha256(raw).hexdigest()})
    # Unindexed print callback is retained as an explicit excerpt, not a full function.
    start,end=0xA029C6DC,0xA029C74C
    listing=[]
    for i in md.disasm(data[start-BASE:end-BASE],start):
        decoded[i.address]=(i.mnemonic,i.op_str)
        listing.append('%08x %s %s'%(i.address,i.mnemonic,i.op_str))
    (output/'file-print-excerpt.asm').write_text('\n'.join(listing)+'\n')
    checks={0xA0231894:('bl','#0xa01b8c20'),
            0xA01926E4:('bl','#0xa0231fc8'),
            0xA029CBE8:('bl','#0xa032e0c8'),
            0xA029C730:('bl','#0xa032e0d8'),
            0xA0238244:('add','r0, r4, #4'),
            0xA023824C:('bl','#0xa03bc2bc'),
            0xA0238278:('strb','r7, [r4]')}
    for at,expected in checks.items():assert decoded[at]==expected,(hex(at),decoded[at])
    def string(at):
        off=at-BASE
        return data[off:data.index(0,off)].decode('ascii')
    addresses=[0xA05A0104,0xA05A0134,0xA05A01E4,0xA05A0E98,
               0xA05618A4,0xA05A115C,0xA0643444,0xA05FC918,0xA0576B5C]
    states={str(i):string(struct.unpack_from('<I',data,0xA062C988-BASE+4*i)[0]) for i in range(13)}
    result={'image_sha256':SHA256,'capstone_version':__version__,
            'producer_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'functions':evidence,'instruction_checks':{hex(a):list(v) for a,v in checks.items()},
            'strings':{hex(a):string(a) for a in addresses},'task_state_names':states,
            'file_print_excerpt_end_exclusive':[hex(start),hex(end)],
            'findings':{
                'usb_uart':'USB mode 2 starts CDC transport and NetCar packet tasks; no general Shell parser call identified on this path.',
                'uvc':'USB mode 3 creates video buffers/queue/send task and encoding callbacks.',
                'console_marker':'Enables existing UART0 Shell callbacks; does not establish USB or Wi-Fi Shell.',
                'redirection':'Split on >, parse pathname, fopen in w mode, replace caller print callback with file writer, fclose and restore callback.',
                'videoanal':'Initialized byte A14307B8; task TCB A14307BC, literal name VA frame hdlr, priority 136, stack A1430A14 length 0x8000.',
            },
            'limitations':['Filesystem Ghidra/Capstone evidence; no REA session or Evidence IDs.',
                           'Static reachability findings are scoped to recovered paths; absence of a general bridge is not an exhaustive proof.',
                           'No USB mode switches, raw endpoint writes, NAND changes or memory mappings performed by this audit.']}
    (output/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'functions':len(evidence),'instruction_checks':len(checks),'output':str(output)}))


if __name__=='__main__':main()
