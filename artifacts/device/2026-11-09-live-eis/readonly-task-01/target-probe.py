anchors = [(2685403388, 'b01f10ee031001e200000fe1000051e31f00c0e3d10080e300f021e118219f0518219f1500d092e51f00c0e3d20080e300f021e108219f0508219f1500d092e5'), (2688097520, '04e02de56cd04de204008de5403604e370314ae30c3093e540308de5403604e370314ae3103093e53c308de5c83a07e375304ae30030d3e5010053e32800008a')]
windows = [(2692053568, 272), (2708483120, 208), (2708483328, 3288), (2708515600, 256), (2708488272, 800), (2708489632, 96), (2708519552, 688), (2695671040, 1280), (2711850688, 384), (2711856384, 128)]
duration = 4.0
interval = 0.1
import os, mmap, binascii, json, signal, time
signal.alarm(int(duration) + 12)
fd = os.open('/dev/mem', os.O_RDONLY)
pages = {}
def read_va(va, count):
    pa = va - 0xa0000000
    start = pa & ~4095
    offset = pa - start
    length = (offset + count + 4095) & ~4095
    key = (start, length)
    if key not in pages:
        pages[key] = mmap.mmap(fd, length, flags=mmap.MAP_SHARED,
                              prot=mmap.PROT_READ, offset=start)
    return pages[key][offset:offset+count]
try:
    for va, expected in anchors:
        assert binascii.hexlify(read_va(va, len(expected)//2)) == expected, 'Code fingerprint mismatch'
    for va, count in windows:
        read_va(va, count)
    start = time.time()
    print('YI_LIVE_READY ' + json.dumps({'start_wall': start, 'duration': duration, 'interval': interval}))
    number = 0
    while time.time() - start < duration:
        before = time.time()
        data = [{'va': hex(va).rstrip('L'), 'hex': binascii.hexlify(read_va(va, count))}
                for va, count in windows]
        after = time.time()
        print('YI_LIVE_SAMPLE ' + json.dumps({'n': number, 't_start': before-start,
              't_end': after-start, 'windows': data}, separators=(',', ':')))
        number += 1
        remaining = start + number*interval - time.time()
        if remaining > 0:
            time.sleep(remaining)
    print('YI_LIVE_DONE ' + json.dumps({'samples': number, 'elapsed': time.time()-start}))
finally:
    for mem in pages.values():
        mem.close()
    os.close(fd)
    signal.alarm(0)
