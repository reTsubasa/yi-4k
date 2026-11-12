#!/usr/bin/env python3
"""Bounded stock coordinate evidence, running pinned original ARM/Thumb bytes.

Synthetic video calibration only. No device, payload, deployment, DSP or timing
claim. In particular a calibration displacement is not a normalized sample map.
"""
from __future__ import annotations

import collections
import hashlib
import json
import math
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

from audit_eis_generator_scope import BASE, IMAGE, ROOT, SHA256, machine

OUT = ROOT / 'artifacts/verification/2026-11-12-eis-stock-coordinate-contract'
P, S, D, V, MODE, RES, G, GRID = (
    0x30000000, 0x30010000, 0x30030000, 0x30040000,
    0x30041000, 0x30042000, 0x30043000, 0x30050000,
)
CHECKS = {
    0xA032D51C: 'vldr d9, [pc, #0x394]',
    0xA032D528: 'blx #0xa0503878',
    0xA032D534: 'vcvt.s32.f64 s15, d16',
    0xA032D53C: 'blx #0xa0503dc8',
    0xA032D564: 'vcvt.s32.f64 s15, d0',
    0xA032D5D8: 'lsl r7, r0, #4',
    0xA032D630: 'lsl r3, r0, #4',
    0xA032D68C: 'sxtah r3, r3, lr',
    0xA032D690: 'sxtah r0, sl, ip',
    0xA032D6A4: 'rsb r1, r3, r1, asr #16',
    0xA032D6A8: 'rsb r2, r0, r2, asr #16',
    0xA032D6B0: 'strh r1, [r4, #-4]',
    0xA032D6B8: 'strh r3, [r4, #-2]',
    0xA032D6FC: 'vldr d8, [r3, #0xb8]',
    0xA032D700: 'vneg.f64 d8, d8',
}
ENTRIES = {
    0xA032CF38: 'core', 0xA032B520: 'video_generator',
    0xA032A4B8: 'interpolator', 0xA032C940: 'vertical_remap',
    0xA0503878: 'cos', 0xA0503DC8: 'sin',
    0xA029C680: 'copy_wrapper', 0xA03BC388: 'thread_context_test',
    0xA029C180: 'copy_implementation', 0xA04F8DEC: 'memset',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def signed(value, bits):
    return ((value + (1 << (bits - 1))) % (1 << bits)) - (1 << (bits - 1))


def rotate_reference(grid, cols, exponent, center, cosine, sine):
    """Exact integer loop, including 32-bit products and signed ASR rounding."""
    out = []
    for index, (dx, dy) in enumerate(grid):
        row, col = divmod(index, cols)
        x = (col << (exponent[0] + 4)) - center[0] + dx
        y = (row << (exponent[1] + 4)) - center[1] + dy
        rx = signed(x * cosine - y * sine, 32) >> 16
        ry = signed(y * cosine + x * sine, 32) >> 16
        out.append((signed(rx - x + dx, 16), signed(ry - y + dy, 16)))
    return out


def pairs(data):
    return list(struct.iter_unpack('<hh', data))


def execute(data, name, theta=0., translation=(0, 0), affine=False,
            raw_offset_q16=None):
    u = machine(data)
    # Original memcpy's context check reads these original per-core words.
    # Zero means no current RTOS thread; no function is replaced.
    u.mem_map(0xA1796000, 0x1000)

    def put(addr, value):
        u.mem_write(addr, struct.pack('<I', value & 0xFFFFFFFF))

    for addr, value in [(0xA14C1F44, 0xA029C680),
                        (0xA14C1F48, 0xA04F8DED),
                        (0xA14C1F60, 0x70000010)]:
        put(addr, value)
    for off, value in [(0x48, 1920), (0x4C, 1080), (0x64, 1920),
                       (0x68, 1080), (0x6C, 1920), (0x70, 1080),
                       (0x7C, 1920 << 16), (0x80, 1080 << 16),
                       (0x84, 1920), (0x88, 1080), (0x50, 0x01010101)]:
        put(P + off, value)
    if raw_offset_q16 is None:
        for off, value in [(0, 1), (8, 0x20140701), (0xC, 4), (0x10, 4),
                           (0x14, 11), (0x18, 11), (0x24, 1920),
                           (0x28, 1080), (0x2C, 0x01010101), (0x30, 1),
                           (0x3C, GRID)]:
            put(P + off, value)
    else:
        put(P + 4, 8)
        put(P + 0xB0, 1)
        put(P + 0x78, raw_offset_q16)
    u.mem_write(P + 0xB8, struct.pack('<d', theta))
    grid = [(translation[0] + (row * 7 + col * 3 if affine else 0),
             translation[1] + (row * 5 - col * 9 if affine else 0))
            for row in range(4) for col in range(4)]
    grid_bytes = b''.join(struct.pack('<hh', *point) for point in grid)
    u.mem_write(GRID, grid_bytes)
    for base, values in [(V, [P, S, 0, 0, G]), (RES, [0, D, 0, D + 0x100])]:
        for index, value in enumerate(values):
            put(base + 4 * index, value)
    u.mem_write(G + 8, struct.pack('<H', 128))
    u.mem_write(S, b'\xA5' * 0x10000)
    input_before = bytes(u.mem_read(P, 0xC0))
    counts = collections.Counter()
    snapshots, queries, invalid_writes = {}, [], []
    mask = bytearray(0x3000)
    instructions = 0

    def hook(m, pc, size, _):
        nonlocal instructions
        instructions += 1
        if pc == 0x70000010:
            raise AssertionError('original diagnostic/error path reached')
        if pc in ENTRIES:
            counts[ENTRIES[pc]] += 1
        if pc == 0xA032D63C:
            sp = m.reg_read(UC_ARM_REG_SP)
            snapshots['rotation'] = {
                'cosine_q16': signed(m.reg_read(UC_ARM_REG_R6), 32),
                'sine_q16': signed(m.reg_read(UC_ARM_REG_R5), 32),
                'center_q4': [m.reg_read(UC_ARM_REG_R7),
                              struct.unpack('<I', m.mem_read(sp + 0x40, 4))[0]],
            }
        if pc == 0xA032C940:
            snapshots['rotated'] = bytes(m.mem_read(S + 0x3000, len(grid_bytes)))
        if pc == 0xA032B520 and raw_offset_q16 is None:
            info = m.reg_read(UC_ARM_REG_R1)
            ptr = struct.unpack('<I', m.mem_read(info + 0x3C, 4))[0]
            snapshots['remapped'] = bytes(m.mem_read(ptr, len(grid_bytes)))
        if pc == 0xA032A4B8:
            queries.append([signed(m.reg_read(UC_ARM_REG_R1), 32),
                            signed(m.reg_read(UC_ARM_REG_R2), 32),
                            m.reg_read(UC_ARM_REG_R3)])

    def write(m, access, addr, size, value, _):
        if S <= addr and addr + size <= S + 0x3000:
            mask[addr - S:addr - S + size] = b'\1' * size
        elif not (S <= addr and addr + size <= S + 0x10000 or
                  D <= addr and addr + size <= D + 0x200 or
                  RES <= addr and addr + size <= RES + 0x10 or
                  G <= addr and addr + size <= G + 0x100 or
                  0x70000000 <= addr and addr + size <= 0x70010000):
            invalid_writes.append([hex(addr), size])

    u.hook_add(UC_HOOK_CODE, hook)
    u.hook_add(UC_HOOK_MEM_WRITE, write)
    args = [(UC_ARM_REG_R0, MODE), (UC_ARM_REG_R1, V), (UC_ARM_REG_R2, RES)]
    entry = 0xA032CF38
    if raw_offset_q16 is not None:
        entry = 0xA032B520
        args = [(UC_ARM_REG_R0, 0), (UC_ARM_REG_R1, P),
                (UC_ARM_REG_R2, S), (UC_ARM_REG_R3, D)]
    for reg, value in args + [(UC_ARM_REG_SP, 0x7000F000),
                              (UC_ARM_REG_LR, 0x70000000)]:
        u.reg_write(reg, value)
    u.emu_start(entry, 0x70000000, count=3000000)
    assert u.reg_read(UC_ARM_REG_PC) == 0x70000000
    assert u.reg_read(UC_ARM_REG_R0) == 0
    assert not invalid_writes, invalid_writes
    assert bytes(u.mem_read(P, 0xC0)) == input_before
    assert bytes(u.mem_read(GRID, len(grid_bytes))) == grid_bytes
    output, desc = bytes(u.mem_read(S, 0x3000)), bytes(u.mem_read(D, 0x50))
    plane_report = []
    for base, meta, component in [(0, 0x30, 1), (0x1800, 0x35, 2)]:
        cols, rows = desc[meta] + 1, desc[meta + 1] + 1
        values = [struct.unpack_from('<h', output, base + 2 * (row * 32 + col))[0]
                  for row in range(rows) for col in range(cols)]
        plane_queries = [point[:2] for point in queries if point[2] == component]
        if raw_offset_q16 is None:
            assert plane_queries == [[col * 64, row * 32]
                                     for row in range(rows) for col in range(cols)]
            expected_mask = bytearray(0x1800)
            for row in range(rows):
                expected_mask[row * 64:row * 64 + cols * 2] = b'\1' * (cols * 2)
            assert mask[base:base + 0x1800] == expected_mask
            if theta == 0 and not affine:
                assert set(values) == {translation[component - 1]}
        else:
            assert set(values) == ({0} if component == 1 else {raw_offset_q16 >> 12})
        plane_report.append({'columns': cols, 'rows': rows, 'pitch_elements': 32,
                             'spacing_descriptor': list(desc[meta + 2:meta + 4]),
                             'min': min(values), 'max': max(values),
                             'query_first_last': [plane_queries[0], plane_queries[-1]]
                             if plane_queries else None,
                             'active_sha256': sha(struct.pack('<' + 'h' * len(values), *values))})
    for i, used in enumerate(mask):
        if not used:
            assert output[i] == 0xA5
    if raw_offset_q16 is None:
        assert counts['core'] == counts['video_generator'] == counts['vertical_remap'] == 1
        assert counts['interpolator'] == 2201
        assert counts['copy_wrapper'] == counts['thread_context_test'] == counts['copy_implementation'] == 4
        assert counts['cos'] == counts['sin'] == int(bool(theta))
        if theta:
            rot = snapshots['rotation']
            assert rot['cosine_q16'] == math.trunc(math.cos(-theta) * 65536)
            assert rot['sine_q16'] == math.trunc(math.sin(-theta) * 65536)
            assert rot['center_q4'] == [960 * 16, 540 * 16]
            expected = rotate_reference(grid, 4, [11, 11], rot['center_q4'],
                                        rot['cosine_q16'], rot['sine_q16'])
            assert pairs(snapshots['rotated']) == expected
        else:
            assert pairs(snapshots['rotated']) == grid
    OUT.mkdir(parents=True, exist_ok=True)
    for suffix, blob in [('planes.bin', output), ('descriptor.bin', desc),
                         *[(key + '.bin', snapshots[key])
                           for key in ['rotated', 'remapped'] if key in snapshots]]:
        (OUT / f'{name}.{suffix}').write_bytes(blob)
    return {'name': name, 'theta_radians': theta, 'translation_q4': translation,
            'affine': affine, 'raw_offset_q16': raw_offset_q16,
            'entry': hex(entry), 'return': 0, 'original_instruction_count': instructions,
            'original_entries': dict(counts), 'planes': plane_report,
            'rotation': snapshots.get('rotation'),
            'rotation_grid_exact_integer_reference': bool(theta),
            'source_input_and_grid_unchanged': True, 'padding_preserved': True,
            'substituted_calls': [], 'planes_sha256': sha(output)}


def main():
    data = IMAGE.read_bytes()
    assert sha(data) == SHA256
    decoder = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checks = []
    for addr, expected in CHECKS.items():
        ins = next(decoder.disasm(data[addr - BASE:addr - BASE + 4], addr))
        actual = f'{ins.mnemonic} {ins.op_str}'
        assert actual == expected, (hex(addr), actual, expected)
        checks.append({'address': hex(addr), 'instruction': actual})
    assert struct.unpack_from('<d', data, 0xA032D8B8 - BASE)[0] == 65536.
    cases = [execute(data, 'constant-zero'),
             execute(data, 'constant-positive', translation=(16, 32)),
             execute(data, 'constant-negative', translation=(-16, -32)),
             execute(data, 'constant-subpixel', translation=(1, -1)),
             execute(data, 'affine', translation=(16, -32), affine=True)]
    for theta in [0.0001, -0.0001, 0.01, -0.01, 0.125, -0.125]:
        cases.append(execute(data, f'rotation-{theta:+g}', theta=theta,
                             translation=(16, -32)))
    for offset in [0, 4095, 4096, 65535, 65536, 8 << 16]:
        cases.append(execute(data, f'raw-y-q16-{offset}', raw_offset_q16=offset))
    report = {
        'status': 'pass_bounded_original_coordinate_evidence',
        'device_access': False, 'stock_abi_compatible': False,
        'replacement_deployment_ready': False,
        'image_sha256': SHA256,
        'script_sha256': sha(Path(__file__).read_bytes()),
        'dependency_sha256': {
            str(path.relative_to(ROOT)): sha(path.read_bytes())
            for path in [ROOT / 'scripts/audit_eis_generator_scope.py',
                         ROOT / 'scripts/analyze_eis_warp_publication.py',
                         ROOT / 'scripts/audit_eis_orc_core.py']
        },
        'original_function_sha256': {
            'A032CF38_A032D8C0': sha(data[0xA032CF38 - BASE:0xA032D8C0 - BASE]),
            'A032B520_A032C940': sha(data[0xA032B520 - BASE:0xA032C940 - BASE]),
            'A032C940_A032CF38': sha(data[0xA032C940 - BASE:0xA032CF38 - BASE]),
        },
        'fixed_instruction_checks': checks, 'cases': cases,
        'observed_contract': {
            'profile': 'synthetic 1920x1080 video, equal geometry, control=0; calibration 4x4 exp11, ratios 1:1, remap enabled',
            'input_grid': 'signed16 displacement pairs; coordinate arithmetic uses 16 units per calibration coordinate',
            'rotation': 'theta negated, cos/sin*65536 truncated toward zero; 32-bit products then signed ASR16; final signed16 storage',
            'rotation_origin_in_profile': [960, 540],
            'constant_input_to_planes_in_profile': 'same signed displacement, including +/-1 subpixel unit',
            'interpolation_queries_in_profile': 'x=64*column, y=32*row; X31x35, Y31x36; physical plane pitch32',
            'raw_y_profile': 'control8, raw enabled: nonnegative P+78 Q16 offset >>12 becomes Y signed16; X cleared',
            'ownership': 'all inputs/outputs synthetic owned host memory; original context/ring publication not executed',
        },
        'not_proven': [
            'general geometry, crop, subsampling, mirror or control100 conversion',
            'DSP interpretation: destination-to-source vs source-to-destination and visible image motion sign',
            'candidate normalized sample coordinates to physical calibration coordinates',
            'real gyro units/axes/exposure/row timing, runtime calibration origin',
            'bank lifetime/cache/barriers, execution loader/recovery, hardware frame identity or deadline',
        ],
    }
    (OUT / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'status': report['status'], 'cases': len(cases),
                      'rotation_grid_points_checked': 6 * 16,
                      'output': str(OUT / 'audit.json'), 'device_access': False}))


if __name__ == '__main__':
    main()
