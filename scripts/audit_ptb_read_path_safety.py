#!/usr/bin/env python3
"""Offline fixed-image PTB read-path audit. No target access or reader generation.

Unicorn runs original ARM handlers against synthetic RAM; numeric conversion and
printing callbacks are host stubs. This is not runtime MMU/cache validation.
"""
from pathlib import Path
import hashlib
import json
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_LR, UC_ARM_REG_PC, UC_ARM_REG_SP

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xa0100000
RTOS = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
KDIR = ROOT / 'artifacts/device/2026-11-09-rtos-logging'
OUT = ROOT / 'artifacts/device/2026-11-11-ptb-read-path-safety'
PINS = {
    RTOS: 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c',
    KDIR / 'kernel-head.bin': 'd729a6faf6f274378be6ab60d6ee51d604b24e87a0b2ddcff55a13e5219be83b',
    KDIR / 'kernel-mem-drivers.bin': 'b1598f4d511f7d6323d702988fd2b1bf8917f6cf90b32a2523fd2785abd3e7ad',
}

def digest(raw):
    return hashlib.sha256(raw).hexdigest()

def cstr(cpu, address):
    result = bytearray()
    for offset in range(128):
        char = bytes(cpu.mem_read(address + offset, 1))
        if char == b'\0':
            return result.decode('ascii')
        result.extend(char)
    raise ValueError('unterminated synthetic argument')

def emulate_read(raw, entry, address, count, width):
    cpu = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    for start, size in [(BASE, (len(raw)+4095)&~4095), (0xa0001000, 4096),
                        (0xb0000000, 0x20000), (0xb1000000, 4096)]:
        cpu.mem_map(start, size)
    cpu.mem_write(BASE, raw)
    pattern = bytes((i * 37 + 11) & 255 for i in range(4096))
    cpu.mem_write(0xa0001000, pattern)
    argv = 0xb0010000
    for index, value in enumerate(('read', hex(address), str(count))):
        pointer = argv + 0x100 + index * 0x100
        cpu.mem_write(pointer, value.encode()+b'\0')
        cpu.mem_write(argv+index*4, struct.pack('<I', pointer))
    reads, writes, output = [], [], []
    stop, callback = 0xb1000000, 0xb1000004

    def instruction(uc, pc, size, _):
        if pc == 0xa04fb328:
            # Stock strtoul is outside this test's contract. All supplied values
            # are fixed valid hex/decimal, checked here as a conversion stub.
            value = cstr(uc, uc.reg_read(UC_ARM_REG_R0))
            uc.reg_write(UC_ARM_REG_R0, int(value, 16 if value.startswith('0x') else 10))
            uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))
        elif pc == callback:
            output.append(cstr(uc, uc.reg_read(UC_ARM_REG_R0)))
            uc.reg_write(UC_ARM_REG_R0, 0)
            uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))

    def access(uc, kind, addr, size, value, destination):
        destination.append((addr, size))

    cpu.hook_add(UC_HOOK_CODE, instruction)
    cpu.hook_add(UC_HOOK_MEM_READ, access, reads, 0xa0001000, 0xa0001fff)
    cpu.hook_add(UC_HOOK_MEM_WRITE, access, writes)
    cpu.reg_write(UC_ARM_REG_SP, 0xb000f000)
    cpu.reg_write(UC_ARM_REG_R0, 3)
    cpu.reg_write(UC_ARM_REG_R1, argv)
    cpu.reg_write(UC_ARM_REG_R2, callback)
    cpu.reg_write(UC_ARM_REG_LR, stop)
    cpu.emu_start(entry, stop, count=200000)
    assert cpu.reg_read(UC_ARM_REG_R0) == 0
    assert reads == [(address+i*width, width) for i in range(count)]
    assert all(0xb000e000 <= addr < 0xb000f000 for addr, _ in writes), writes
    assert bytes(cpu.mem_read(0xa0001000, 4096)) == pattern
    return dict(entry=hex(entry), va=hex(address), count=count, width=width,
                exact_target_reads=len(reads), target_writes=0,
                stack_writes=len(writes), printing_callback_calls=len(output))

def main():
    inputs = {}
    for path, expected in PINS.items():
        raw = path.read_bytes()
        assert digest(raw) == expected, str(path)
        inputs[path] = raw
    rtos, head, mem = (inputs[p] for p in PINS)
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    pins = {
        0x40017ccc: ('movw', 'r3, #0xffff'),
        0x40017cd0: ('movt', 'r3, #0x3c9f'),
        0x40017cd8: ('bhi', '#0x40017ce4'),
        0x40017cdc: ('mov', 'r0, #0'),
        0x40017d14: ('add', 'r0, r0, r1, lsr #12'),
        0xa04837ec: ('movw', 'ip, #0x7433'),
        0xa04837fc: ('movt', 'ip, #0x4262'),
        0xa0483804: ('movw', 'lr, #0x6242'),
        0xa0483808: ('movt', 'lr, #0x3274'),
        0xa0483810: ('str', 'ip, [r1, #0x1c8]'),
        0xa048381c: ('str', 'lr, [r1, #0x1c4]'),
        0xa0483604: ('ldr', 'r0, [r0, #0x1c4]'),
        0xa04836d0: ('ldr', 'r1, [r1, #0x1c8]'),
    }
    for address, expected in pins.items():
        raw, base = (head, 0x40008000) if address < BASE else (rtos, BASE)
        ins = next(md.disasm(raw[address-base:address-base+4], address))
        assert (ins.mnemonic, ins.op_str) == expected
    kernel_tests = []
    for address, size in [(0x1400, 0x1d0), (0x1800, 0x354), (0, 4), (0x3c9fffff, 1)]:
        cpu = Uc(UC_ARCH_ARM, UC_MODE_ARM)
        cpu.mem_map(0x40008000, len(head))
        cpu.mem_write(0x40008000, head)
        cpu.reg_write(UC_ARM_REG_R0, address)
        cpu.reg_write(UC_ARM_REG_R1, size)
        cpu.reg_write(UC_ARM_REG_LR, 0x40008000)
        cpu.emu_start(0x40017ccc, 0x40008000, count=100)
        assert cpu.reg_read(UC_ARM_REG_R0) == 0
        kernel_tests.append(dict(pa=hex(address), bytes=size, allowed=False))
    handler_tests = []
    for address, size in [(0xa0001400, 0x1d0), (0xa0001800, 0x354)]:
        for entry, width in [(0xa02a2e58, 1), (0xa02a3000, 4)]:
            for count in (0, 1, size//width):
                handler_tests.append(emulate_read(rtos, entry, address, count, width))
    captures = []
    capture_root = ROOT / 'artifacts/device/2026-11-09-linux'
    for directory in sorted(capture_root.glob('rtos-readonly*')):
        path = directory / 'telnet-output.txt'
        if not path.exists():
            continue
        for line in path.read_text(errors='replace').splitlines():
            if line.startswith('YI_RTOS_MEMORY '):
                row = json.loads(line.split(' ', 1)[1])
                va = int(row['va'], 16)
                size = len(bytes.fromhex(row['hex']))
                captures.append(dict(file=str(path.relative_to(ROOT)), va=hex(va), bytes=size,
                    overlaps_low_ptb_page=va < 0xa0002000 and va+size > 0xa0001000))
    assert captures and not any(row['overlaps_low_ptb_page'] for row in captures)
    asm = []
    for name, raw, base, address, size in [
        ('kernel read physical gate', head, 0x40008000, 0x40017ccc, 0x64),
        ('kernel physical translation', head, 0x40008000, 0x4001d530, 0xfc),
        ('kernel DSP region RPC getter', head, 0x40008000, 0x4002049c, 0xbc),
        ('kernel DSP mmap', mem, 0x4025d000, 0x4027f694, 0x110),
        ('read argument parser', rtos, BASE, 0xa02a2cfc, 0x6c),
        ('readb', rtos, BASE, 0xa02a2e58, 0xd4),
        ('readl', rtos, BASE, 0xa02a3000, 0xd4),
        ('BBT marker creation', rtos, BASE, 0xa048372c, 0x1c0),
        ('BBT marker consumer', rtos, BASE, 0xa0483570, 0x1bc),
    ]:
        asm.append('\n'+name+'\n')
        for ins in md.disasm(raw[address-base:address-base+size], address):
            asm.append(f'{ins.address:08x} {ins.mnemonic:8} {ins.op_str}\n')
    audit = dict(scope='offline fixed bytes and synthetic RAM only',
        inputs=[dict(file=str(p.relative_to(ROOT)), sha256=digest(b)) for p,b in inputs.items()],
        instruction_pins=len(pins), kernel_read_rejection_tests=kernel_tests,
        original_handler_synthetic_tests=handler_tests,
        stubs=['numeric conversion for fixed valid args', 'printing callback'],
        existing_snapshot_inventory=captures,
        sys_tail=dict(bbt_primary_offset='0x1c4', bbt_primary_word='0x32746242',
            bbt_mirror_offset='0x1c8', bbt_mirror_word='0x42627433',
            remaining_unclassified_interval='[0xcc,0x1c4)'),
        not_proven=['current target MMU mapping', 'cross-core cache coherency',
            'target console availability at read time', 'bootloader reservation origin',
            'hidden NAND image bytes', 'independent recovery'],
        target_access=False)
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT/'audit.json').write_text(json.dumps(audit, indent=2)+'\n')
    (OUT/'audit.asm').write_text(''.join(asm))
    print(json.dumps(dict(output=str(OUT), kernel_tests=len(kernel_tests),
        handler_tests=len(handler_tests), old_capture_ranges=len(captures), target_access=False)))

if __name__ == '__main__':
    main()
