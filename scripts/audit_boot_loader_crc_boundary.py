#!/usr/bin/env python3
"""Offline public-BLD loader execution and captured-device CRC scope audit.

Never opens a device/network or emits a modified partition/PTB/firmware image.
Unicorn executes the stock loader only; NAND, arithmetic, memcpy and logging
are explicit host services. Public 1.10.52 code is NOT the device's 1.10.7 BLD.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct
import zlib

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import UC_ARM_REG_PC, UC_ARM_REG_LR, UC_ARM_REG_SP
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-11-boot-loader-crc-boundary'
BASE, DEST, TABLE, GEOM, STOP = 0x10000000, 0x20000000, 0x10500000, 0x10501000, 0x10600000
PAGE, PAGES_PER_BLOCK = 2048, 64
BLOCK = PAGE * PAGES_PER_BLOCK
PINS = {
    'artifacts/firmware/v1.10.52/_part_bld.a9s': '259ed36093252298186c7e39c5f3400ba307f44224aba467ab885da8e1e5cbd7',
    'artifacts/device/2026-11-09-linux/boot-metadata/vendor_data.bin': '69c4fcd4c096e0b02b0c0303483c11a364cafc0c46fe5aefaf73983fff7f3844',
    'artifacts/device/2026-11-09-linux/sys_sw_partition.bin': 'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6',
    'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin': 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def crc(data):
    return zlib.crc32(data) & 0xffffffff


def loader_case(bld, source, block_count, skip_first=False):
    n = len(source)
    u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    for address, size in [(BASE, 0x50000), (0x10440000, 0x10000),
                          (TABLE, 0x20000), (STOP, 0x1000),
                          (DEST, ((n + 0x1ffff) // 0x1000) * 0x1000)]:
        u.mem_map(address, size)
    u.mem_write(BASE, bld)
    u.mem_write(DEST, b'\xcc' * (n + 64))
    u.mem_write(0x10441610, struct.pack('<I', GEOM))
    u.mem_write(0x1000cdd8, struct.pack('<I', TABLE))
    u.mem_write(GEOM + 6, struct.pack('<H', PAGE))
    u.mem_write(GEOM + 9, bytes([PAGES_PER_BLOCK]))
    record = TABLE + 8 + 0x40  # SYS_SW, user table index 1
    start_block = 0xc
    u.mem_write(record + 0x28, struct.pack('<4I', block_count, start_block, 0x100000, n))
    u.reg_write(UC_ARM_REG_R0, 1)
    u.reg_write(UC_ARM_REG_R1, 1)
    u.reg_write(UC_ARM_REG_R2, DEST)
    u.reg_write(UC_ARM_REG_SP, TABLE + 0x1f000)
    u.reg_write(UC_ARM_REG_LR, STOP)
    calls, reads, copied = {}, [], []
    returned = False

    def ret():
        u.reg_write(UC_ARM_REG_PC, u.reg_read(UC_ARM_REG_LR))

    def hook(_, address, size, context):
        nonlocal returned
        if address == STOP:
            returned = True
            u.emu_stop()
            return
        if address not in (0x1000ada8, 0x1000b004, 0x100034d4, 0x10001ac0, 0x100019f0, 0x10006c7c):
            return
        calls[hex(address)] = calls.get(hex(address), 0) + 1
        a, b, c, d = [u.reg_read(r) for r in (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)]
        if address in (0x1000ada8, 0x1000b004):
            assert b != 0
            u.reg_write(UC_ARM_REG_R0, a // b)
            u.reg_write(UC_ARM_REG_R1, a % b)
        elif address == 0x10001ac0:
            u.reg_write(UC_ARM_REG_R0, 0 if skip_first and a == start_block else 3)
        elif address == 0x100019f0:
            assert b > 0 and d == 0
            physical_first = (start_block + int(skip_first)) * PAGES_PER_BLOCK
            offset = (a - physical_first) * PAGE
            assert offset >= 0
            raw = source[offset:offset + b * PAGE]
            raw += b'\xa7' * (b * PAGE - len(raw))
            assert (DEST <= c and c + len(raw) <= DEST + n) or (c == 0x10032000 and b == 1)
            u.mem_write(c, raw)
            reads.append(dict(first_page=a, pages=b, destination=hex(c)))
            u.reg_write(UC_ARM_REG_R0, 0)
        elif address == 0x10006c7c:
            assert 0 < c < PAGE
            assert DEST <= a < a + c <= DEST + n and b == 0x10032000
            u.mem_write(a, bytes(u.mem_read(b, c)))
            copied.append(dict(destination=hex(a), source=hex(b), bytes=c))
            u.reg_write(UC_ARM_REG_R0, a)
        # Logging return is unspecified/caller-saved; zero is enough here.
        elif address == 0x100034d4:
            u.reg_write(UC_ARM_REG_R0, 0)
        ret()

    u.hook_add(UC_HOOK_CODE, hook)
    u.emu_start(0x10002358, STOP + 4, count=100000)
    assert returned
    result = u.reg_read(UC_ARM_REG_R0)
    loaded = min(n, block_count * BLOCK)
    assert bytes(u.mem_read(DEST, loaded)) == source[:loaded]
    assert bytes(u.mem_read(DEST + loaded, n + 64 - loaded)) == b'\xcc' * (n + 64 - loaded)
    assert result == 0
    assert sum(r['pages'] for r in reads) == (loaded + PAGE - 1) // PAGE
    return dict(actual_bytes=n, allocated_blocks=block_count, skip_first_block=skip_first,
                returned=result, destination_bytes_verified=loaded,
                full_actual_size_loaded=loaded == n, suffix_canary_preserved=True,
                nand_pages_read=sum(r['pages'] for r in reads),
                nand_bytes_read=sum(r['pages'] for r in reads) * PAGE,
                partial_page_copy=copied, mocked_service_calls=calls)


def main():
    data = {name: (ROOT / name).read_bytes() for name in PINS}
    for name, expected in PINS.items():
        assert sha(data[name]) == expected, name
    bld, ptb, partition, window = [data[name] for name in PINS]
    assert struct.unpack_from('<I', ptb, 0x350)[0] == crc(ptb[:0x350])
    rec = 0x48
    assert ptb[rec:rec + 7] == b'SYS_SW\0'
    allocated, blocks, start, load, actual, state, stored_crc = struct.unpack_from('<7I', ptb, rec + 0x24)
    assert (allocated, blocks, start, load, actual, stored_crc) == (0x2000000, 0x100, 0xc, 0x100000, 0x724f68, 0xb3cb97f7)
    assert crc(partition[:actual]) == stored_crc
    assert partition[:len(window)] == window and len(window) == (actual + PAGE - 1) // PAGE * PAGE
    assessment = json.loads((ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/boot-patch-assessment/assessment.json').read_text())
    spans = assessment['prototype']['patch_spans']
    assert [(int(s['file_offset'], 16), s['bytes']) for s in spans] == [(0x87bf4, 4), (0x54e220, 96)]
    assert spans[0]['after_hex'] == '891913eb'
    assert sha(bytes.fromhex(spans[1]['after_hex'])) == '96d06a9f22a5637067a1fb103f17873d1953b4c7ca0f356cdd0549f7b77aa097'
    effects = []
    for mask in (1, 2, 3):
        changed = bytearray(partition)
        names = []
        for i, span in enumerate(spans):
            offset = int(span['file_offset'], 16)
            before, after = bytes.fromhex(span['before_hex']), bytes.fromhex(span['after_hex'])
            assert changed[offset:offset + len(before)] == before
            assert len(before) == len(after) == span['bytes'] and offset + len(after) <= actual
            if mask & (1 << i):
                changed[offset:offset + len(after)] = after
                names.append(span['label'])
        new_data_crc = crc(changed[:actual])
        assert new_data_crc != stored_crc
        metadata = bytearray(ptb)
        struct.pack_into('<I', metadata, rec + 0x3c, new_data_crc)
        new_ptb_crc = crc(metadata[:0x350])
        assert new_ptb_crc != crc(ptb[:0x350])
        effects.append(dict(spans=names, data_crc_after=f'0x{new_data_crc:08x}',
                            data_crc_field_offset=hex(rec + 0x3c),
                            old_ptb_crc_would_mismatch=True,
                            recalculated_ptb_crc=f'0x{new_ptb_crc:08x}',
                            modified_data_sha256=sha(changed), modified_image_written=False))
    assert effects[-1]['modified_data_sha256'] == assessment['prototype']['mutated_partition_sha256']
    cases = []
    def sample_bytes(n):
        # Distinct pages catch wrong source cursors; a byte counter repeats each
        # 256 bytes and would not detect a page/block offset error.
        return b''.join(hashlib.shake_256(struct.pack('<I', i)).digest(min(PAGE, n - i * PAGE))
                        for i in range((n + PAGE - 1) // PAGE))
    for n in (1, PAGE - 1, PAGE, PAGE + 1, BLOCK - 1, BLOCK, BLOCK + 1):
        sample = sample_bytes(n)
        for skip in (False, True):
            cases.append(loader_case(bld, sample, (n + BLOCK - 1) // BLOCK, skip))
    cases.append(loader_case(bld, partition[:actual], blocks))
    shortage = loader_case(bld, sample_bytes(BLOCK + 1), 1)
    assert shortage['returned'] == 0 and not shortage['full_actual_size_loaded']
    # Pin exact loader instructions for the relevant dataflow, not inferred names.
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = {0x100023e4: ('ldr', 'r4, [r6, #0x34]'),
              0x10002408: ('cmp', 'r0, r3'),
              0x10002414: ('movhs', 'sb, r3'),
              0x100024fc: ('mov', 'r0, #0'),
              0x100025ac: ('mov', 'r2, r4'),
              0x100025bc: ('blx', '#0x10006c7c')}
    for address, expected in checks.items():
        ins = next(md.disasm(bld[address - BASE:address - BASE + 4], address))
        assert (ins.mnemonic, ins.op_str) == expected
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / 'public_partition_loader.asm').write_text('\n'.join(
        f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
        for i in md.disasm(bld[0x2358:0x25e0], 0x10002358)) + '\n')
    result = dict(scope='offline static CRC and public loader emulation; no device or flashable image',
                  sources=PINS, actual_size=actual, data_crc=f'0x{stored_crc:08x}',
                  ptb_crc=f'0x{crc(ptb[:0x350]):08x}', crc_effects=effects,
                  rounded_capture_tail=dict(window_bytes=len(window), actual_end_virtual=hex(0xa0100000 + actual),
                                            bytes=len(window) - actual, sha256=sha(window[actual:]),
                                            all_ff=all(b == 255 for b in window[actual:]),
                                            within_actual_size_or_crc=False),
                  actual_length_all_patch_spans_covered=True,
                  public_loader_instruction_checks=len(checks), public_loader_cases=cases,
                  insufficient_allocation_case=shortage,
                  caveats=['BLD is public 1.10.52, not the captured 1.10.7 hidden BLD.',
                           'NAND/geometry, division, logging and memcpy are modeled services; loader instructions execute in Unicorn.',
                           'Data CRC is observed metadata; this does not prove hidden BLD enforcement, signature policy or write ordering.',
                           'No independent recovery, physical NAND/OOB ownership, runtime padding ownership or cold/resume behavior is proved.'])
    (OUT / 'audit.json').write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n')
    print(json.dumps(dict(cases=len(cases) + 1, instruction_checks=len(checks),
                          crc_effects=effects, report=str(OUT / 'audit.json'))))


if __name__ == '__main__':
    main()
