#!/usr/bin/env python3
"""Run candidate affine calibration through original ARM stock mesh generation.

No device I/O. Geometry and calibration are synthetic owned host memory. All
stock math/interpolation/copy instructions execute unchanged; no return stubs.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
import math
from pathlib import Path
import struct

from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

from audit_eis_generator_scope import BASE, IMAGE, ROOT, SHA256, machine
from eis_candidate_mesh import MeshConfig, validate_trace
from eis_candidate_stock_affine import candidate_calibration, interpolate_q4, remapped_grid, rotated_grid, source_point, two_stage_displacement
from eis_stock_mesh_layout import layouts_from_descriptor, unpack_active

P, S, D, V, MODE, RES, G, GRID = (0x30000000, 0x30010000, 0x30030000, 0x30040000,
                                0x30041000, 0x30042000, 0x30043000, 0x30050000)
ENTRIES = {0xA032CF38: 'core', 0xA032B520: 'video_generator',
           0xA032A4B8: 'interpolator', 0xA032C940: 'vertical_remap',
           0xA0503878: 'cos', 0xA0503DC8: 'sin', 0xA029C680: 'copy_wrapper',
           0xA03BC388: 'thread_context_test', 0xA029C180: 'copy_implementation',
           0xA04F8DEC: 'memset'}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def plane_linear(values, columns, rows, x, y):
    """Declared host bilinear sampler, not a model of DSP rounding/filtering."""
    if not 0 <= x <= (columns - 1) * 64 or not 0 <= y <= (rows - 1) * 32:
        raise ValueError('two-stage reconstruction outside generated table support')
    col, row = min(int(x // 64), columns - 2), min(int(y // 32), rows - 2)
    fx, fy = (x - col * 64) / 64, (y - row * 32) / 32
    a, b = values[row * columns + col], values[row * columns + col + 1]
    c, d = values[(row + 1) * columns + col], values[(row + 1) * columns + col + 1]
    return ((a * (1-fx) + b*fx) * (1-fy) + (c*(1-fx) + d*fx) * fy) / 16


def execute(data, output, name, config, correction):
    calibration = candidate_calibration(config, correction)
    u = machine(data)
    u.mem_map(0xA1796000, 0x1000)
    def put(addr, value):
        u.mem_write(addr, struct.pack('<I', value & 0xFFFFFFFF))
    for addr, value in [(0xA14C1F44, 0xA029C680), (0xA14C1F48, 0xA04F8DED),
                        (0xA14C1F60, 0x70000010)]:
        put(addr, value)
    # Equal input/output geometry and identity remap ratios, as independently
    # recovered by audit_eis_stock_coordinate_contract.py. Grid shape differs:
    # 3x3 exp10 avoids far-node signed32 rotation wrap from 4x4 exp11.
    for off, value in [(0x48, 1920), (0x4C, 1080), (0x64, 1920), (0x68, 1080),
                       (0x6C, 1920), (0x70, 1080), (0x7C, 1920 << 16),
                       (0x80, 1080 << 16), (0x84, 1920), (0x88, 1080), (0x50, 0x01010101),
                       (0, 1), (8, 0x20140701), (0xC, calibration.columns),
                       (0x10, calibration.rows), (0x14, calibration.horizontal_exponent),
                       (0x18, calibration.vertical_exponent), (0x24, 1920), (0x28, 1080),
                       (0x2C, 0x01010101), (0x30, 1), (0x3C, GRID)]:
        put(P + off, value)
    u.mem_write(P + 0xB8, struct.pack('<d', calibration.stock_theta_radians))
    grid = calibration.grid_bytes()
    u.mem_write(GRID, grid)
    for base, values in [(V, [P, S, 0, 0, G]), (RES, [0, D, 0, D + 0x100])]:
        for index, value in enumerate(values):
            put(base + 4 * index, value)
    u.mem_write(G + 8, struct.pack('<H', 128))
    u.mem_write(S, b'\xA5' * 0x10000)
    input_before = bytes(u.mem_read(P, 0xC0))
    counts, snapshots, queries, writes = Counter(), {}, [], bytearray(0x3000)
    invalid_writes = []
    def hook(m, pc, size, _):
        if pc == 0x70000010:
            raise AssertionError('stock diagnostic error path')
        if pc in ENTRIES:
            counts[ENTRIES[pc]] += 1
        if pc == 0xA032C940:
            snapshots['rotated'] = bytes(m.mem_read(S + 0x3000, len(grid)))
        if pc == 0xA032B520:
            info = m.reg_read(UC_ARM_REG_R1)
            pointer = struct.unpack('<I', m.mem_read(info + 0x3C, 4))[0]
            snapshots['remapped'] = bytes(m.mem_read(pointer, len(grid)))
        if pc == 0xA032A4B8:
            queries.append([m.reg_read(UC_ARM_REG_R1), m.reg_read(UC_ARM_REG_R2), m.reg_read(UC_ARM_REG_R3)])
    def write(m, access, addr, size, value, _):
        if S <= addr and addr + size <= S + 0x3000:
            writes[addr - S:addr - S + size] = b'\1' * size
        elif not (S <= addr and addr + size <= S + 0x10000 or
                  D <= addr and addr + size <= D + 0x200 or
                  RES <= addr and addr + size <= RES + 0x10 or
                  G <= addr and addr + size <= G + 0x100 or
                  0x70000000 <= addr and addr + size <= 0x70010000):
            invalid_writes.append([hex(addr), size])
    u.hook_add(UC_HOOK_CODE, hook)
    u.hook_add(UC_HOOK_MEM_WRITE, write)
    for reg, value in [(UC_ARM_REG_R0, MODE), (UC_ARM_REG_R1, V), (UC_ARM_REG_R2, RES),
                       (UC_ARM_REG_SP, 0x7000F000), (UC_ARM_REG_LR, 0x70000000)]:
        u.reg_write(reg, value)
    u.emu_start(0xA032CF38, 0x70000000, count=3000000)
    assert u.reg_read(UC_ARM_REG_PC) == 0x70000000
    assert u.reg_read(UC_ARM_REG_R0) == 0
    assert not invalid_writes
    assert bytes(u.mem_read(P, 0xC0)) == input_before
    assert bytes(u.mem_read(GRID, len(grid))) == grid
    expected_rotated = b''.join(struct.pack('<hh', *value) for value in rotated_grid(calibration))
    assert snapshots['rotated'] == expected_rotated
    expected_remapped = b''.join(struct.pack('<hh', *value) for value in remapped_grid(calibration))
    assert snapshots['remapped'] == expected_remapped
    scratch, descriptor = bytes(u.mem_read(S, 0x3000)), bytes(u.mem_read(D, 0x50))
    layouts = layouts_from_descriptor(descriptor, x_pitch=32, y_pitch=32)
    assert [(p.columns, p.rows) for p in layouts] == [(31, 35), (31, 36)]
    active = unpack_active(scratch, layouts)
    errors, expected_mask, plane_reports = [], bytearray(0x3000), []
    for axis, (layout, values) in enumerate(zip(layouts, active)):
        axis_queries = [q[:2] for q in queries if q[2] == axis + 1]
        expected_queries = [[col * 64, row * 32] for row in range(layout.rows) for col in range(layout.columns)]
        assert axis_queries == expected_queries
        oracle = [interpolate_q4(calibration, x, y, axis) for x, y in axis_queries]
        assert values == oracle, [(i, a, b) for i, (a, b) in enumerate(zip(values, oracle)) if a != b][:10]
        for (x, y), value in zip(axis_queries, values):
            errors.append(abs(two_stage_displacement(config, correction, x, y, axis) - value / 16))
        for off in layout.offsets():
            expected_mask[off:off + 2] = b'\1\1'
        plane_reports.append(dict(axis=axis, columns=layout.columns, rows=layout.rows, pitch=32,
                                  min=min(values), max=max(values), active_sha256=sha(struct.pack('<' + 'h'*len(values), *values))))
    assert writes == expected_mask
    assert all(scratch[i] == 0xA5 for i, written in enumerate(writes) if not written)
    assert counts['core'] == counts['video_generator'] == counts['vertical_remap'] == 1
    assert counts['interpolator'] == 2201
    assert counts['cos'] == counts['sin'] == int(bool(correction[2]))
    assert max(errors) <= 0.25, 'continuous affine table error exceeds reviewed quarter-pixel bound'
    reconstruction_errors = []
    naive_x_errors = []
    for y in [row * 32 for row in range(34)] + [1080]:
        for x in [col * 64 for col in range(31)]:
            dy = plane_linear(active[1], 31, 36, x, y)
            dx = plane_linear(active[0], 31, 35, x, y + dy)
            ideal = source_point(config, correction, x, y)
            reconstruction_errors.append(math.hypot(x + dx - ideal[0], y + dy - ideal[1]))
            # Counterexample: treating X as an ordinary same-coordinate plane.
            naive_x_errors.append(abs(x + plane_linear(active[0], 31, 35, x, y) - ideal[0]))
    assert max(reconstruction_errors) <= 0.5
    for start, end in ((0xA032CF38, 0xA032D8C0), (0xA032B520, 0xA032C940), (0xA032A4B8, 0xA032A8F8)):
        assert bytes(u.mem_read(start, end-start)) == data[start-BASE:end-BASE]
    for suffix, blob in [('grid.bin', grid), ('rotated.bin', expected_rotated),
                         ('remapped.bin', expected_remapped), ('planes.bin', scratch), ('descriptor.bin', descriptor)]:
        (output / (name + '.' + suffix)).write_bytes(blob)
    return dict(name=name, correction_radians=correction, calibration=calibration.metadata(),
                return_u32=0, original_entries=dict(counts), substituted_calls=[],
                plane_reports=plane_reports, max_continuous_affine_error_pixels=max(errors),
                active_points_checked=len(errors), exact_integer_reference=True,
                cpu_two_stage_reconstruction_points=len(reconstruction_errors),
                cpu_two_stage_reconstruction_max_error_pixels=max(reconstruction_errors),
                naive_same_coordinate_x_max_error_pixels=max(naive_x_errors),
                padding_preserved=True, original_input_and_code_unchanged=True,
                output_sha256=sha(scratch))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    data = IMAGE.read_bytes()
    assert sha(data) == SHA256
    config = MeshConfig(1920, 1080, crop_margin=0.12)
    cases = []
    for name, correction in [('stationary', [0., 0., 0.]),
                             ('pitch-positive', [0.006, 0., 0.]),
                             ('yaw-negative', [0., -0.009, 0.]),
                             ('roll-positive', [0., 0., 0.01]),
                             ('roll-negative', [0., 0., -0.01]),
                             ('combined', [0.004, -0.007, 0.015])]:
        cases.append(execute(data, args.output, name, config, correction))
    # A complete candidate v2 gyro -> bounded posture -> actual ARM table chain.
    trace = {'schema': 'yi4k.eis-candidate-trace/v1',
             'units': {'gyro': 'degrees_per_second', 'tick': 'microseconds'},
             'config': {'width': 1920, 'height': 1080, 'crop_margin': 0.12},
             'samples': [{'sequence': i, 'tick_us': i * 10000 + 1000,
                          'gyro_dps': [2.0, -3.0, 1.0]} for i in range(7)]}
    candidate = validate_trace(trace)
    candidate_mesh_checks = 0
    for frame in candidate['frames']:
        for i, point in enumerate(frame['mesh']):
            row, col = divmod(i, config.columns)
            ideal = source_point(config, frame['correction_angle_rad'],
                                 col * config.width / (config.columns - 1),
                                 row * config.height / (config.rows - 1))
            actual = ((point['x_q16'] / 65536 + 1) * config.width / 2,
                      (point['y_q16'] / 65536 + 1) * config.height / 2)
            assert abs(actual[0] - ideal[0]) <= config.width / 262144 + 1e-9
            assert abs(actual[1] - ideal[1]) <= config.height / 262144 + 1e-9
            candidate_mesh_checks += 1
    for frame in (candidate['frames'][0], candidate['frames'][3], candidate['frames'][-1]):
        cases.append(execute(data, args.output, 'candidate-v2-' + str(frame['sequence']),
                             config, frame['correction_angle_rad']))
    rejects = []
    for name, invalid, correction in [('unsupported-4k', MeshConfig(3840,2160), [0.,0.,0.]),
                                      ('insufficient-crop-for-guard-row', MeshConfig(1920,1080,crop_margin=0.01), [0.,0.,0.]),
                                      ('nonfinite', config, [float('nan'),0.,0.]),
                                      ('excessive-correction', config, [0.,0.,0.2]),
                                      ('outside-source-support', config, [0.12,0.,0.])]:
        try:
            candidate_calibration(invalid, correction)
        except ValueError as error:
            rejects.append(dict(name=name, error=str(error)))
        else:
            raise AssertionError('negative accepted: ' + name)
    report = dict(status='pass_bounded_candidate_affine_original_arm_tables',
                  device_access=False, replacement_deployment_ready=False, stock_abi_compatible=False,
                  image_sha256=SHA256, cases=cases, rejected=rejects,
                  case_count=len(cases), active_points_checked=sum(c['active_points_checked'] for c in cases),
                  max_continuous_affine_error_pixels=max(c['max_continuous_affine_error_pixels'] for c in cases),
                  candidate_mesh_to_affine_points_checked=candidate_mesh_checks,
                  cpu_two_stage_reconstruction_points=sum(c['cpu_two_stage_reconstruction_points'] for c in cases),
                  cpu_two_stage_reconstruction_max_error_pixels=max(c['cpu_two_stage_reconstruction_max_error_pixels'] for c in cases),
                  profile='synthetic1920x1080 equal geometry,3x3 calibration exp10,two-stage vertical remap,pitch32',
                  cpu_coordinate_hypothesis='candidate output-to-source affine displacement; DSP mapping direction unproven',
                  limits=['Synthetic unit-labelled gyro only; no sensor calibration, axis or common frame clock',
                          'Two-stage reconstruction uses declared host bilinear sampling, not unknown actual DSP filtering/rounding',
                          'No actual camera calibration/lens distortion, rolling shutter or optical quality proof',
                          'CPU generator return and table bytes do not prove DSP latch, cache visibility or runtime ABI',
                          'No native deployment, device access, firmware changes or camera writes'],
                  source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in
                                 [Path(__file__), ROOT/'scripts/eis_candidate_stock_affine.py',
                                  ROOT/'scripts/eis_candidate_mesh.py', ROOT/'scripts/eis_stock_mesh_layout.py',
                                  ROOT/'scripts/audit_eis_generator_scope.py']})
    (args.output / 'trace.json').write_text(json.dumps(trace, indent=2)+'\n')
    (args.output / 'audit.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ('status','case_count','active_points_checked','max_continuous_affine_error_pixels')}))


if __name__ == '__main__':
    main()
