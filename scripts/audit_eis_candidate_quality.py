#!/usr/bin/env python3
"""Host angle-domain behavior checks, explicitly not encoded-image quality."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path

from eis_candidate_mesh import Q, validate_trace


def trace(step_us, seconds, rate):
    return {"schema": "yi4k.eis-candidate-trace/v1",
            "units": {"gyro": "degrees_per_second", "tick": "microseconds"},
            "config": {"width": 1920, "height": 1080, "columns": 3, "rows": 3,
                       "focal_length_px": 800.0, "crop_margin": 0.1,
                       "smoothing_alpha": 0.25, "smoothing_reference_interval_us": 10_000},
            "samples": [{"sequence": n, "tick_us": n * step_us,
                         "gyro_dps": [0.0, rate(n * step_us / 1e6), 0.0]}
                        for n in range(round(seconds * 1e6 / step_us) + 1)]}


def require(ok, message):
    if not ok:
        raise ValueError(message)


def run():
    # A sustained pan should follow the intended path instead of cancelling an
    # ever-growing absolute angle until the crop is exhausted.
    pan = validate_trace(trace(10_000, 20, lambda t: 10.0))
    end = pan["frames"][-1]
    tau = -0.01 / math.log1p(-0.25)
    residual = abs(end["correction_angle_rad"][1])
    require(math.isclose(end["integrated_angle_rad"][1], math.radians(200), abs_tol=1e-10), "pan integral mismatch")
    require(math.isclose(residual, math.radians(10) * tau, abs_tol=1e-10), "pan residual is not bounded at steady state")
    # Splitting identical constant-rate intervals must preserve the same virtual
    # camera path. A per-record alpha would change the effective time constant.
    dense = validate_trace(trace(5_000, 20, lambda t: 10.0))
    dense_end = dense["frames"][-1]
    error = max(abs(a - b) for a, b in zip(end["smoothed_angle_rad"], dense_end["smoothed_angle_rad"]))
    require(error < 1e-10, "equivalent rate partition changed smoothing")
    require(end["mesh"] == dense_end["mesh"], "equivalent rate partition changed quantized mesh")
    # When panning stops, the residual must settle back to zero.
    stopped = validate_trace(trace(10_000, 2, lambda t: 10.0 if t <= 1 else 0.0))
    stop_before = abs(stopped["frames"][100]["correction_angle_rad"][1])
    stop_after = abs(stopped["frames"][-1]["correction_angle_rad"][1])
    require(stop_after < stop_before * 1e-8, "stationary camera failed to settle")
    # This validates smoothing in angle space against a known 5-Hz yaw path.
    # It neither models optical distortion nor uses an invented camera trace.
    dt = 0.005
    theta = lambda t: math.radians(1) * math.sin(2 * math.pi * 5 * t)
    rate = lambda t: math.degrees((theta(t) - theta(max(0, t - dt))) / dt) if t else 0.0
    vibration = validate_trace(trace(5_000, 2, rate))
    steady = vibration["frames"][200:]
    rms = lambda vals: math.sqrt(sum(v * v for v in vals) / len(vals))
    input_rms = rms([f["integrated_angle_rad"][1] for f in steady])
    virtual_rms = rms([f["smoothed_angle_rad"][1] for f in steady])
    attenuation = virtual_rms / input_rms
    require(attenuation < 0.75, "5Hz virtual path was not smoothed")
    all_frames = pan["frames"] + dense["frames"] + stopped["frames"] + vibration["frames"]
    require(all(-Q <= p[a] <= Q for f in all_frames for p in f["mesh"] for a in ("x_q16", "y_q16")),
            "mesh sample left normalized sensor support")
    return {"schema": "yi4k.eis-candidate-behavior/v1", "algorithm": pan["algorithm"],
            "status": "passed_host_angle_and_sampling_support_checks",
            "sustained_pan": {"seconds": 20, "rate_dps": 10, "integrated_degrees": math.degrees(end["integrated_angle_rad"][1]),
                              "steady_residual_rad": residual, "expected_rate_times_tau_rad": math.radians(10) * tau},
            "cadence_invariance": {"step_us": [10_000, 5_000], "max_angle_error_rad": error,
                                   "quantized_mesh_equal": True},
            "stop_settling": {"residual_before_rad": stop_before, "residual_after_rad": stop_after},
            "five_hz_virtual_path": {"input_rms_rad": input_rms, "smoothed_rms_rad": virtual_rms,
                                     "rms_ratio": attenuation},
            "mesh_frames_checked_inside_sensor": len(all_frames),
            "real_gyro_used": False, "encoded_image_quality_tested": False,
            "stock_abi_compatible": False, "replacement_deployment_ready": False, "device_access": False,
            "limitations": ["Analytic trajectory behavior only; no optical/rolling-shutter/camera video improvement is inferred.",
                            "Host axis/projection convention is hypothetical; real gyro calibration and exposure alignment remain missing.",
                            "Small-angle pitch/yaw with affine roll is not a calibrated full-3D lens model."],
            "sources": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in
                        (Path(__file__), Path(__file__).with_name("eis_candidate_mesh.py"))}}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = run()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"status": result["status"], "mesh_frames_checked": result["mesh_frames_checked_inside_sensor"],
                      "optical_quality_tested": False, "device_access": False}))


if __name__ == "__main__":
    main()
