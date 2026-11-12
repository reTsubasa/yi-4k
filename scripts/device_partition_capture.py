#!/usr/bin/env python3
"""Read SYS_SW and the SquashFS content window through existing Telnet.

Uses dd with if= only and base64; no target file or partition writes.
These are logical MTD block reads, not NAND/OOB recovery images.
"""
import argparse
import base64
import datetime
import hashlib
import json
from pathlib import Path
import re

from device_linux_capture import Telnet


def decode(command_output):
    lines = [line for line in command_output.splitlines()
             if line and len(line) % 4 == 0 and
             re.fullmatch(r'[A-Za-z0-9+/]+={0,2}', line)]
    return base64.b64decode(''.join(lines), validate=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    c = Telnet(args.host)
    c.login()
    manifest = {'date_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
                'host': args.host, 'scope': 'Logical MTD read to host; no NAND OOB; no target writes',
                'images': []}
    try:
        mtd = c.command('cat /proc/mtd')
        assert re.search(r'mtd1: 02000000 00020000 "SYS_SW"', mtd), 'Unexpected SYS_SW layout'
        assert re.search(r'mtd5: 03c00000 00020000 "LINUX_RFS"', mtd), 'Unexpected RFS layout'
        superblock = decode(c.command('dd if=/dev/mtdblock5 bs=4096 count=1 2>/dev/null | base64'))
        assert len(superblock) == 4096 and superblock[:4] == b'hsqs'
        used = int.from_bytes(superblock[40:48], 'little')
        assert 96 < used <= 0x3c00000
        captures = [('sys_sw_partition.bin', '/dev/mtdblock1', 0x2000000),
                    ('linux_rfs_window.squashfs', '/dev/mtdblock5', ((used + 4095) // 4096) * 4096)]
        for name, device, length in captures:
            path = args.output / name
            if path.exists():
                raise FileExistsError(f'Refusing to overwrite capture: {path}')
            digest = hashlib.sha256()
            with path.open('xb') as file:
                for offset in range(0, length, 512 * 1024):
                    blocks = min(128, (length - offset) // 4096)
                    command = f'dd if={device} bs=4096 skip={offset // 4096} count={blocks} 2>/dev/null | base64'
                    data = decode(c.command(command, timeout=45))
                    assert len(data) == blocks * 4096, (name, offset, len(data), blocks * 4096)
                    file.write(data)
                    digest.update(data)
                    if (offset + len(data)) % (4 * 1024 * 1024) == 0 or offset + len(data) == length:
                        print(name, offset + len(data), '/', length, flush=True)
            hash_command = f'dd if={device} bs=4096 count={length // 4096} 2>/dev/null | sha256sum'
            remote = c.command(hash_command, timeout=45)
            (args.output / (name + '.remote-hash.txt')).write_text(remote)
            match = re.search(r'(?m)^([0-9a-f]{64})\s+-', remote)
            assert match and match[1] == digest.hexdigest(), 'Remote/host SHA-256 mismatch'
            item = {'file': name, 'source': device, 'bytes': length,
                    'sha256': digest.hexdigest(), 'remote_hash_matches': True,
                    'device_hash_command': hash_command}
            if name.endswith('.squashfs'):
                item['squashfs_bytes_used'] = used
            manifest['images'].append(item)
            (args.output / 'partition-capture.json').write_text(json.dumps(manifest, indent=2) + '\n')
            print(name, 'verified', digest.hexdigest(), flush=True)
    finally:
        c.close()


if __name__ == '__main__':
    main()
