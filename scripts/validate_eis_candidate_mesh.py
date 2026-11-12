#!/usr/bin/env python3
"""Deterministic host validation for the offline EIS mesh candidate."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
from typing import Any

from eis_candidate_mesh import Q, Q_MAX, Q_MIN, validate_trace


def base_trace() -> dict[str, Any]:
    return {
        "schema": "yi4k.eis-candidate-trace/v1",
        "units": {"gyro": "degrees_per_second", "tick": "microseconds"},
        "config": {"width": 1920, "height": 1080, "columns": 9, "rows": 7,
                   "focal_length_px": 800.0, "crop_margin": 0.2,
                   "smoothing_alpha": 0.25, "max_rate_dps": 720.0},
        "samples": [
            {"sequence": 0, "tick_us": 1000, "gyro_dps": [0.0, 0.0, 0.0]},
            {"sequence": 1, "tick_us": 11000, "gyro_dps": [0.0, 0.0, 0.0]},
            {"sequence": 2, "tick_us": 21000, "gyro_dps": [2.0, -1.5, 0.5]},
            {"sequence": 3, "tick_us": 31000, "gyro_dps": [2.0, -1.5, 0.5]},
        ],
    }


def expect_reject(payload: dict[str, Any], phrase: str) -> str:
    try:
        validate_trace(payload)
    except ValueError as exc:
        if phrase not in str(exc):
            raise AssertionError(f"wrong rejection: {exc!r} (wanted {phrase!r})") from exc
        return str(exc)
    raise AssertionError(f"invalid trace unexpectedly accepted: {phrase}")


def run() -> dict[str, Any]:
    payload = base_trace()
    first = validate_trace(payload)
    second = validate_trace(payload)
    assert first == second, "same input must produce byte-stable semantic output"
    assert first["frame_count"] == len(payload["samples"])
    assert first["gate"]["host_candidate_ready"] is True
    assert first["gate"]["stock_abi_compatible"] is False
    assert first["gate"]["replacement_deployment_ready"] is False
    assert all(frame["mesh_format"] == "normalized_q16.16" for frame in first["frames"])
    for frame in first["frames"]:
        mesh = frame["mesh"]
        assert len(mesh) == 9 * 7
        assert all(Q_MIN <= p[axis] <= Q_MAX for p in mesh for axis in ("x_q16", "y_q16"))
        assert all(-Q <= p[axis] <= Q for p in mesh for axis in ("x_q16", "y_q16"))
        assert frame["max_displacement"] <= math.sqrt(2) * 0.8
    # A nonzero rotation must alter the mesh while preserving output bounds.
    assert first["frames"][0]["mesh"] != first["frames"][3]["mesh"]

    rejected = []
    bad = base_trace(); bad["units"]["gyro"] = "raw_counts"
    rejected.append(expect_reject(bad, "units must declare"))
    bad = base_trace(); bad["samples"][2]["tick_us"] = bad["samples"][1]["tick_us"]
    rejected.append(expect_reject(bad, "tick_us must strictly increase"))
    bad = base_trace(); bad["samples"][2]["tick_us"] = bad["samples"][1]["tick_us"] + 100001
    rejected.append(expect_reject(bad, "sample gap exceeds"))
    bad = base_trace(); bad["samples"][2]["gyro_dps"] = [721.0, 0.0, 0.0]
    rejected.append(expect_reject(bad, "gyro rate exceeds"))
    bad = base_trace(); bad["samples"][2]["gyro_dps"] = [float("nan"), 0.0, 0.0]
    rejected.append(expect_reject(bad, "must be finite"))
    bad = base_trace(); bad["samples"][2]["sequence"] = 1
    rejected.append(expect_reject(bad, "sequence must strictly increase"))
    # Strong sustained angular input exceeds crop and must stop closed.
    bad = base_trace()
    bad["config"]["crop_margin"] = 0.01
    bad["samples"] = [{"sequence": i, "tick_us": i * 10000 + 1000,
                       "gyro_dps": [0.0, 40.0, 0.0]} for i in range(40)]
    rejected.append(expect_reject(bad, "exceeds crop margin"))
    return {
        "schema": "yi4k.eis-candidate-mesh-validation/v1",
        "algorithm": first["algorithm"],
        "status": "passed_host_candidate_and_rejection_checks",
        "positive_trace_frames": first["frame_count"],
        "deterministic_output": True,
        "nonzero_motion_changes_mesh": True,
        "q16_16_and_crop_bounds_checked": True,
        "rejection_checks": len(rejected),
        "rejection_messages": rejected,
        "stock_abi_compatible": False,
        "replacement_deployment_ready": False,
        "device_access": False,
        "sources": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in
                    (Path(__file__), Path(__file__).with_name("eis_candidate_mesh.py"))},
        "limitations": [
            "Synthetic trace only; not captured camera gyro, exposure or frame data.",
            "Normalized Q16.16 mesh is a candidate adapter format, not the stock 1.10.7 warp table ABI.",
            "No encoded image comparison, rolling-shutter quality, real-time budget, DSP latch, RTOS execution or device write is tested.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    report = run()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"status": report["status"], "positive_trace_frames": report["positive_trace_frames"],
                      "rejection_checks": report["rejection_checks"], "device_access": False}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
