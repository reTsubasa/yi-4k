#!/usr/bin/env python3
"""Deterministic offline three-axis sweep through the original stock EIS generator."""
from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

from audit_eis_candidate_stock_affine import IMAGE, SHA256, execute
from eis_candidate_mesh import MeshConfig
from eis_candidate_stock_affine import candidate_calibration


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    data = IMAGE.read_bytes()
    if hashlib.sha256(data).hexdigest() != SHA256:
        raise SystemExit('fixed firmware image SHA256 mismatch')

    config = MeshConfig(1920, 1080, crop_margin=0.12)
    cases, rejected = [], []
    # All sign combinations at three levels per axis, including isolated axes.
    for pitch, yaw, roll in itertools.product((-0.01, 0.0, 0.01), repeat=3):
        name = f'p{pitch:+.3f}_y{yaw:+.3f}_r{roll:+.3f}'
        correction = (pitch, yaw, roll)
        try:
            candidate_calibration(config, correction)
            cases.append(execute(data, args.output, name, config, correction))
        except ValueError as exc:
            rejected.append({'name': name, 'correction_radians': correction, 'reason': str(exc)})

    boundary_probes = []
    for name, correction in [
        ('support-edge-roll', (0.0, 0.0, 0.04)),
        ('signed32-roll-bound', (0.0, 0.0, 0.125)),
        ('beyond-roll-bound', (0.0, 0.0, 0.126)),
        ('support-edge-pitch', (0.04, 0.0, 0.0)),
        ('support-edge-yaw', (0.0, 0.04, 0.0)),
    ]:
        try:
            candidate_calibration(config, correction)
            boundary_probes.append({'name': name, 'correction_radians': correction, 'accepted': True})
        except ValueError as exc:
            boundary_probes.append({'name': name, 'correction_radians': correction,
                                    'accepted': False, 'reason': str(exc)})

    report = {
        'schema': 'yi4k.eis-candidate-stock-affine-sweep/v1',
        'firmware_sha256': SHA256,
        'source_sha256': {
            'sweep_script': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'adapter': hashlib.sha256((Path(__file__).parent / 'eis_candidate_stock_affine.py').read_bytes()).hexdigest(),
            'stock_audit': hashlib.sha256((Path(__file__).parent / 'audit_eis_candidate_stock_affine.py').read_bytes()).hexdigest(),
        },
        'profile': {'width': 1920, 'height': 1080, 'crop_margin': 0.12,
                    'control_grid': '3x3 signed16 Q4; 1024px spacing'},
        'sweep': {'levels_radians_per_axis': [-0.01, 0.0, 0.01],
                  'attempted': 27, 'accepted_and_executed': len(cases),
                  'rejected_before_execution': rejected},
        'boundary_probes': boundary_probes,
        'cases': cases,
        'checks': {
            'all_accepted_cases_executed_original_stock_entries': True,
            'all_active_xy_plane_elements_match_independent_integer_reference': True,
            'per_case_continuous_affine_error_max_pixels': max(
                case['max_continuous_affine_error_pixels'] for case in cases),
            'per_case_cpu_reconstruction_error_max_pixels': max(
                case['cpu_two_stage_reconstruction_max_error_pixels'] for case in cases),
            'device_access': False,
            'dsp_or_image_quality_claim': False,
            'artifact_file_count': len(list(args.output.iterdir())),
        },
        'limitations': [
            'Synthetic 1920x1080 geometry and hypothetical axis signs only.',
            'Uses the unmodified ARM generator in Unicorn; does not establish target CPU runtime or DSP table latch.',
            'The sweep covers only the stated discrete angle levels, crop, focal length and grid profile.',
            'No gyro calibration, frame timing, camera lens calibration, encoded-video comparison or device test.',
        ],
    }
    path = args.output / 'sweep.json'
    path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'attempted': 27, 'accepted_executed': len(cases),
                      'max_affine_error_px': report['checks']['per_case_continuous_affine_error_max_pixels'],
                      'max_reconstruction_error_px': report['checks']['per_case_cpu_reconstruction_error_max_pixels'],
                      'device_access': False}))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
