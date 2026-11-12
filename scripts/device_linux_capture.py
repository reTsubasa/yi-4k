#!/usr/bin/env python3
"""Read Linux diagnostics over the camera's existing Telnet service.

Runs only a fixed list of inspection commands. Writes evidence on the host.
No firmware changes, device-file writes, or service startup.
"""
import argparse
import datetime
import json
from pathlib import Path
import re
import socket
import time
import uuid


class Telnet:
    def __init__(self, host):
        self.sock = socket.create_connection((host, 23), timeout=5)
        self.sock.settimeout(0.5)
        self.pending = bytearray()
        self.buffer = bytearray()

    def receive(self):
        data = self.sock.recv(65536)
        if not data:
            raise ConnectionError('Telnet connection closed')
        self.pending.extend(data)
        while self.pending:
            if self.pending[0] != 255:
                end = self.pending.find(255)
                if end < 0:
                    end = len(self.pending)
                self.buffer.extend(self.pending[:end])
                del self.pending[:end]
                continue
            if len(self.pending) < 2:
                return
            op = self.pending[1]
            if op == 255:
                self.buffer.append(255)
                del self.pending[:2]
            elif op in (251, 252, 253, 254):
                if len(self.pending) < 3:
                    return
                opt = self.pending[2]
                del self.pending[:3]
                if op == 253:
                    self.sock.sendall(bytes((255, 252, opt)))
                elif op == 251:
                    self.sock.sendall(bytes((255, 253 if opt in (1, 3) else 254, opt)))
            elif op == 250:
                end = self.pending.find(b'\xff\xf0', 2)
                if end < 0:
                    return
                del self.pending[:end + 2]
            else:
                del self.pending[:2]

    def until(self, pattern, timeout=20):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            match = re.search(pattern, self.buffer)
            if match:
                data = bytes(self.buffer[:match.end()])
                del self.buffer[:match.end()]
                return data
            try:
                self.receive()
            except socket.timeout:
                continue
        raise TimeoutError(f'Telnet read timeout: {bytes(self.buffer[-500:])!r}')

    def login(self):
        self.until(rb'login: *')
        self.sock.sendall(b'root\r\n')
        self.until(rb'(?:~|/[^\r\n]*)? # ')

    def command(self, command, timeout=25):
        marker = '__YI_CAPTURE_' + uuid.uuid4().hex + '__'
        self.sock.sendall((command + '\necho ' + marker + '\n').encode())
        raw = self.until(rb'\n' + marker.encode() + rb'\r*\n', timeout)
        text = raw.decode('utf-8', 'replace').replace('\r', '').replace('\x00', '')
        return text

    def close(self):
        try:
            self.sock.sendall(b'exit\r\n')
        finally:
            self.sock.close()


COMMANDS = [
    ('identity', 'uname -a; cat /proc/version; cat /etc/os-release; id; uptime'),
    ('boot_arguments', 'cat /proc/cmdline; cat /proc/uptime'),
    ('cpu_memory', 'cat /proc/cpuinfo; cat /proc/meminfo'),
    ('memory_map', 'cat /proc/iomem; cat /proc/partitions; cat /proc/mtd'),
    ('mounts', 'cat /proc/mounts; df -k'),
    ('processes', 'ps; ps -ef'),
    ('network', 'ifconfig; route -n; netstat -lntup'),
    ('modules', 'cat /proc/modules; ls -l /sys/class/rpmsg /sys/bus/rpmsg/devices /sys/class/remoteproc'),
    ('device_nodes', 'ls -l /dev/amba* /dev/rpmsg* /dev/video* /dev/iio* /dev/mtd* /dev/ttyGS*'),
    ('ambarella', 'ls -l /proc/ambarella; cat /proc/ambarella/board_info; cat /proc/ambarella/uport'),
    ('sd_root', 'ls -la /tmp/SD0; ls -ld /tmp/SD0 /tmp/fuse_d /pref; ls -l /tmp/yi4k_rtos_probe.ok'),
    ('startup', 'cat /etc/inittab; ls -l /etc/init.d; cat /etc/init.d/S99postboot; cat /etc/init.d/S99bootdone'),
    ('tools', 'ls -l /usr/bin/python* /usr/bin/strace /usr/bin/gdbserver /usr/bin/SendToRTOS /usr/bin/RecvFromRTOS /usr/bin/example_sharepreview /usr/bin/ipcinfo'),
    ('kernel_config', 'zcat /proc/config.gz'),
    ('kernel_log', 'dmesg'),
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='192.168.42.1')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    session = {'host': args.host, 'started_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
               'transport': 'Existing Telnet, root, empty password',
               'scope': 'Linux inspection commands; target not flashed or patched', 'commands': []}
    client = Telnet(args.host)
    try:
        client.login()
        for name, command in COMMANDS:
            started = time.monotonic()
            result = client.command(command)
            (args.output / (name + '.txt')).write_text(result)
            session['commands'].append({'name': name, 'command': command,
                                        'elapsed_seconds': round(time.monotonic() - started, 3),
                                        'output': name + '.txt'})
            (args.output / 'session.json').write_text(json.dumps(session, ensure_ascii=False, indent=2) + '\n')
            print(name, len(result), 'characters', flush=True)
    finally:
        client.close()


if __name__ == '__main__':
    main()
