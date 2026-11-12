#!/usr/bin/env python3
"""Bounded, read-only RTOS DRAM snapshot through existing Linux /dev/mem.

The captured image's identical MMU initializer a0295cf8 maps the selected RTOS
VA ranges to VA-0xa0000000. Before reading any state, two live text windows must
match that same captured image. No mmap write, ioctl, cache operation, or hook.
Cross-core reads are not a coherent snapshot and may see stale cache contents.
Device use is suspended after a confirmed camera hang during the investigation;
see docs/device-live-eis-observation.md section 6. Read-only is not zero impact.
"""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import struct

from device_linux_capture import Telnet

ROOT = Path(__file__).resolve().parents[1]
PARTITION = ROOT / 'artifacts/device/2026-11-09-linux/sys_sw_partition.bin'
EXPECTED = 'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6'
ANCHORS = [(0xA01000FC, 64), (0xA0391CF0, 64)]
WINDOWS = [(0xA0757A40, 0x110), (0xA1702C30, 0xD0),
           (0xA1702D00, 0xCD8), (0xA170AB10, 0x100),
           (0xA1704050, 0x320), (0xA17045A0, 0x60),
           (0xA1443D18, 0x40), (0xA1A355A4, 4)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    image = PARTITION.read_bytes()
    assert hashlib.sha256(image).hexdigest() == EXPECTED
    args.output.mkdir(parents=True, exist_ok=False)
    anchors = [(a, image[a-0xA0100000:a-0xA0100000+n].hex()) for a, n in ANCHORS]
    target = '''import os, mmap, binascii, json, signal
signal.alarm(8)
fd = os.open('/dev/mem', os.O_RDONLY)
def read_va(va, count):
    pa = va - 0xa0000000
    offset = pa & 4095
    mem = mmap.mmap(fd, offset + count, flags=mmap.MAP_SHARED,
                   prot=mmap.PROT_READ, offset=pa & ~4095)
    try:
        return mem[offset:offset + count]
    finally:
        mem.close()
try:
    for va, expected in ANCHORS:
        assert binascii.hexlify(read_va(va, len(expected)//2)) == expected, 'Live text fingerprint mismatch; no state read'
    print('YI_RTOS_TEXT_MATCHED')
    for va, count in WINDOWS:
        print('YI_RTOS_MEMORY ' + json.dumps({'va': hex(va).rstrip('L'), 'pa': hex(va-0xa0000000).rstrip('L'), 'hex': binascii.hexlify(read_va(va, count))}))
finally:
    os.close(fd)
    signal.alarm(0)
'''.replace('ANCHORS', repr(anchors)).replace('WINDOWS', repr(WINDOWS))
    command = "python -B -u <<'YI_MEM_PY'\n" + target + '\nYI_MEM_PY'
    (args.output / 'target-probe.py').write_text(target)
    session = dict(host=args.host, started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                   image_sha256=EXPECTED, command=command,
                   limitations=['Not atomic or cache coherent with RTOS; values may be stale.',
                                'No high-frequency gyro stream or performance measurement.'])
    client = Telnet(args.host)
    try:
        client.login()
        output = client.command(command, timeout=15)
        (args.output / 'telnet-output.txt').write_text(output)
        rows = [json.loads(line.split(' ', 1)[1]) for line in output.splitlines()
                if line.startswith('YI_RTOS_MEMORY ')]
        session['text_fingerprints_matched'] = '\nYI_RTOS_TEXT_MATCHED\n' in output
        session['memory'] = rows
        if not session['text_fingerprints_matched'] or len(rows) != len(WINDOWS):
            raise RuntimeError('Snapshot incomplete; inspect retained output')
        def get(va, fmt):
            n = struct.calcsize(fmt)
            for r in rows:
                start = int(r['va'], 16)
                data = bytes.fromhex(r['hex'])
                if start <= va and va+n <= start+len(data):
                    return struct.unpack_from(fmt, data, va-start)[0]
            raise ValueError(hex(va))
        session['decoded_candidates'] = {
            'rsc_enable_u8': get(0xA0757A68, '<B'),
            'extra_gyro_phase_delay_s8': get(0xA0757AB0, '<b'),
            'ucode_gyro_delay_u8': get(0xA0757AB1, '<B'),
            'rsc_scale_u32': get(0xA0757AC4, '<I'),
            'timeshift_s32': get(0xA0757B44, '<i'),
            'extra_rsc_phase_delay_s8': get(0xA17045E8, '<b'),
            'frame_rate_u32': get(0xA17040B4, '<I'),
            'frame_length_lines_u32': get(0xA1704134, '<I'),
            'row_time_float_candidate': get(0xA1704140, '<f'),
            'sample_processing_gate_u8': get(0xA1702CBC, '<B'),
            'sample_tick_counter_u32': get(0xA1702C40, '<I'),
            'ring_length_u32': get(0xA1702F10, '<I'),
            'ring_next_write_u32': get(0xA1702F14, '<I'),
            'ring_current_index_u32': get(0xA170AB38, '<I'),
            'driver_output_xyz_u16': [get(0xA1702C30 + 2*i, '<H') for i in range(3)],
            'sharepreview_status_u8': get(0xA1443D18, '<B'),
            'gyro_ops_pointer_u32': hex(get(0xA1A355A4, '<I')),
        }
        print(json.dumps(session['decoded_candidates'], indent=2))
    finally:
        client.close()
        (args.output / 'session.json').write_text(json.dumps(session, indent=2) + '\n')


if __name__ == '__main__':
    main()
