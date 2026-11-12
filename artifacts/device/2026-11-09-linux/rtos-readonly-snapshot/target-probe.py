import os, binascii, json, signal
signal.alarm(8)
fd = os.open('/dev/mem', os.O_RDONLY)
def read_va(va, count):
    os.lseek(fd, va - 0xa0000000, os.SEEK_SET)
    data = os.read(fd, count)
    assert len(data) == count
    return data
try:
    for va, expected in [(2685403388, 'b01f10ee031001e200000fe1000051e31f00c0e3d10080e300f021e118219f0518219f1500d092e51f00c0e3d20080e300f021e108219f0508219f1500d092e5'), (2688097520, '04e02de56cd04de204008de5403604e370314ae30c3093e540308de5403604e370314ae3103093e53c308de5c83a07e375304ae30030d3e5010053e32800008a')]:
        assert binascii.hexlify(read_va(va, len(expected)//2)) == expected, 'Live text fingerprint mismatch; no state read'
    print('YI_RTOS_TEXT_MATCHED')
    for va, count in [(2692053568, 272), (2708483136, 192), (2708488272, 640), (2708489632, 96), (2705603864, 64), (2711836068, 4)]:
        print('YI_RTOS_MEMORY ' + json.dumps({'va': hex(va).rstrip('L'), 'pa': hex(va-0xa0000000).rstrip('L'), 'hex': binascii.hexlify(read_va(va, count))}))
finally:
    os.close(fd)
    signal.alarm(0)
