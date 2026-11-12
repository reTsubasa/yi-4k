#!/usr/bin/env python3
"""Read the fixed 1.10.7 DSP logical image without writing camera files.

Only /dev/mtdblock2 is read, in bounded 128 KiB pieces. No RTOS commands,
raw NAND/OOB, memory mapping, settings changes, or partition writes are used.
The captured image is a stored partition, not proof of the running DSP image.
"""
from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import re
import struct
import time
import zlib
from pathlib import Path

from device_boot_metadata_capture import decode
from device_linux_capture import Telnet
from device_readiness_baseline import api_snapshot

ROOT = Path(__file__).resolve().parents[1]
PTB = ROOT / 'artifacts/device/2026-11-09-linux/boot-metadata/vendor_data.bin'
REFERENCE = ROOT / 'artifacts/firmware/v1.10.52/_part_dsp.a9s'
EXPECTED_PTB_SHA = '69c4fcd4c096e0b02b0c0303483c11a364cafc0c46fe5aefaf73983fff7f3844'
DEVICE = '/dev/mtdblock2'
PAGE = 4096
PAGES_PER_READ = 32


def utc():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def expected_image():
    ptb = PTB.read_bytes()
    if hashlib.sha256(ptb).hexdigest() != EXPECTED_PTB_SHA:
        raise ValueError('Pinned device PTB identity changed')
    if zlib.crc32(ptb[:0x350]) & 0xffffffff != struct.unpack_from('<I', ptb, 0x350)[0]:
        raise ValueError('Device PTB CRC mismatch')
    position = 8 + 2 * 0x40
    if ptb[position:position + 0x20].split(b'\0', 1)[0] != b'DSP_uCode':
        raise ValueError('Unexpected DSP PTB record')
    size, crc = struct.unpack_from('<I', ptb, position + 0x34)[0], struct.unpack_from('<I', ptb, position + 0x3c)[0]
    if size != 4038656 or size % PAGE or size > 8 * 1024 * 1024:
        raise ValueError('Unexpected DSP length; refusing unbounded capture')
    return size, crc


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    size, crc = expected_image()
    reference = REFERENCE.read_bytes()
    args.output.mkdir(parents=True, exist_ok=False)
    events = []
    report = {'started_utc': utc(), 'host': args.host, 'source': DEVICE,
              'expected_bytes': size, 'expected_crc32': hex(crc),
              'scope': 'bounded logical DSP partition reads; no target files written',
              'target_files_written': False, 'rtos_shell_invoked': False,
              'memory_mapping_run': False, 'reboot_requested': False,
              'recording_requested': False, 'settings_changed': False,
              'api_events': events, 'reads': [],
              'running_dsp_identity_proven': False}
    client = None
    try:
        report['before'] = api_snapshot(args.host, events)
        if report['before']['status'].get('param') != 'idle':
            raise RuntimeError('Camera must be idle before a partition capture')
        client = Telnet(args.host)
        client.login()
        metadata = client.command('cat /sys/class/mtd/mtd2/name; cat /sys/class/mtd/mtd2/size; cat /proc/sys/kernel/random/boot_id', timeout=8)
        (args.output / 'metadata-before.txt').write_text(metadata)
        if not re.search(r'(?m)^DSP_uCode\s*$', metadata):
            raise RuntimeError('Logical MTD identity is not DSP_uCode')
        boot_ids = re.findall(r'\b[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}\b', metadata)
        if len(boot_ids) != 1:
            raise RuntimeError('Cannot establish the initial boot identity')
        part = args.output / 'dsp-partition-image.part'
        with part.open('xb') as output:
            for skip in range(0, size // PAGE, PAGES_PER_READ):
                count = min(PAGES_PER_READ, size // PAGE - skip)
                command = f'dd if={DEVICE} bs={PAGE} skip={skip} count={count} 2>/dev/null | base64'
                started = time.monotonic()
                raw = client.command(command, timeout=20)
                chunk = decode(raw)
                if len(chunk) != count * PAGE:
                    raise RuntimeError(f'Short/invalid DSP chunk at {skip * PAGE}: {len(chunk)}')
                output.write(chunk)
                report['reads'].append({'offset': skip * PAGE, 'bytes': len(chunk),
                                        'sha256': hashlib.sha256(chunk).hexdigest(),
                                        'seconds': round(time.monotonic() - started, 3),
                                        'command': command})
                print(f'DSP {min((skip + count) * PAGE, size)}/{size}', flush=True)
        data = part.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        if len(data) != size or zlib.crc32(data) & 0xffffffff != crc:
            raise RuntimeError('Captured DSP length/CRC disagrees with device PTB')
        command = f'dd if={DEVICE} bs={PAGE} count={size // PAGE} 2>/dev/null | sha256sum'
        remote = client.command(command, timeout=30)
        (args.output / 'remote-sha256.txt').write_text(remote)
        hashes = re.findall(r'(?m)^([0-9a-f]{64})\s+-\s*$', remote)
        if hashes != [digest]:
            raise RuntimeError('Independent device SHA-256 disagrees with captured bytes')
        after_boot = client.command('cat /proc/sys/kernel/random/boot_id', timeout=8)
        (args.output / 'metadata-after.txt').write_text(after_boot)
        if boot_ids[0] not in after_boot:
            raise RuntimeError('Camera boot identity changed during capture')
        client.close()
        client = None
        report['after'] = api_snapshot(args.host, events)
        report['camera_state_equal'] = report['before'] == report['after']
        if not report['camera_state_equal']:
            raise RuntimeError('Camera state changed during read-only capture; inspect evidence')
        final = args.output / 'dsp-partition-image.bin'
        part.rename(final)
        report.update({'file': final.name, 'bytes': len(data), 'sha256': digest,
                       'crc32': hex(zlib.crc32(data) & 0xffffffff),
                       'remote_sha256_equal': True, 'boot_id_unchanged': True,
                       'reference_sha256': hashlib.sha256(reference).hexdigest(),
                       'reference_byte_equal': data == reference,
                       'stored_partition_identity_proven': True})
        print(json.dumps({k: report[k] for k in ('bytes', 'sha256', 'reference_byte_equal', 'camera_state_equal')}))
    except BaseException as error:
        report['error'] = repr(error)
        raise
    finally:
        try:
            if client is not None:
                client.close()
        finally:
            report['finished_utc'] = utc()
            (args.output / 'capture.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    main()
