#!/usr/bin/env python3
"""Offline causal EIS mesh candidate.

This module integrates an explicitly unit-labelled gyro trace and produces a
bounded normalized warp mesh.  It is an algorithm/adapter candidate only: the
output uses Q16.16 normalized coordinates and is deliberately not accepted as
the stock 1.10.7 warp table ABI.  No camera, firmware image or device API is
accessed.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

Q = 1 << 16
Q_MIN, Q_MAX = -(1 << 31), (1 << 31) - 1


def _finite(value: Any, name: str) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(float(value)):
        raise ValueError(f"{name} must be finite")
    return float(value)


def _q16(value: float) -> int:
    scaled = round(value * Q)
    if not Q_MIN <= scaled <= Q_MAX:
        raise ValueError("mesh coordinate exceeds signed Q16.16 range")
    return int(scaled)


@dataclass(frozen=True)
class MeshConfig:
    width: int
    height: int
    columns: int = 31
    rows: int = 36
    focal_length_px: float = 960.0
    crop_margin: float = 0.08
    smoothing_alpha: float = 0.18
    smoothing_reference_interval_us: int = 10_000
    max_rate_dps: float = 720.0

    def __post_init__(self) -> None:
        if type(self.width) is not int or type(self.height) is not int:
            raise ValueError("width and height must be integers")
        if self.width < 2 or self.height < 2:
            raise ValueError("width and height must be at least 2")
        if type(self.columns) is not int or type(self.rows) is not int:
            raise ValueError("mesh dimensions must be integers")
        if not 2 <= self.columns <= 129 or not 2 <= self.rows <= 129:
            raise ValueError("mesh dimensions must be in [2,129]")
        if not math.isfinite(self.focal_length_px) or self.focal_length_px <= 0:
            raise ValueError("focal_length_px must be positive")
        if not 0 <= self.crop_margin < 0.5:
            raise ValueError("crop_margin must be in [0,0.5)")
        if not 0 < self.smoothing_alpha <= 1:
            raise ValueError("smoothing_alpha must be in (0,1]")
        if type(self.smoothing_reference_interval_us) is not int or not 1 <= self.smoothing_reference_interval_us <= 100_000:
            raise ValueError("smoothing_reference_interval_us must be an integer in [1,100000]")
        if not 0 < self.max_rate_dps <= 2000:
            raise ValueError("max_rate_dps is outside the supported safety range")


def _mesh(config: MeshConfig, correction: tuple[float, float, float]) -> tuple[list[dict[str, int]], float]:
    """Return a roll/pitch/yaw corrected mesh and its max displacement."""
    pitch, yaw, roll = correction
    # Small-angle perspective correction.  The focal length is explicit so the
    # adapter can later replace this with the recovered stock projection.
    # Normalized coordinates span [-1,1], hence two normalized units per
    # image dimension. This host convention is not a stock warp-unit mapping.
    tx = -2.0 * yaw * config.focal_length_px / config.width
    ty = 2.0 * pitch * config.focal_length_px / config.height
    cr, sr = math.cos(roll), math.sin(roll)
    margin = config.crop_margin
    points: list[dict[str, int]] = []
    max_displacement = 0.0
    for row in range(config.rows):
        v = (1.0 - margin) * (-1.0 + 2.0 * row / (config.rows - 1))
        for col in range(config.columns):
            u = (1.0 - margin) * (-1.0 + 2.0 * col / (config.columns - 1))
            # Rotate in pixel space so a non-square image preserves angles.
            x = cr * u - sr * v * config.height / config.width + tx
            y = sr * u * config.width / config.height + cr * v + ty
            # The baseline rectangle reserves actual image-space crop room.
            # All affine cell interiors are convex combinations of corners;
            # checking every vertex also bounds interiors to sensor support.
            if abs(x) > 1.0 or abs(y) > 1.0:
                raise ValueError("candidate correction exceeds crop margin")
            max_displacement = max(max_displacement, math.hypot(x - u, y - v))
            points.append({"x_q16": _q16(x), "y_q16": _q16(y)})
    return points, max_displacement


def validate_trace(payload: dict[str, Any]) -> dict[str, Any]:
    if payload.get("schema") != "yi4k.eis-candidate-trace/v1":
        raise ValueError("schema must be yi4k.eis-candidate-trace/v1")
    units = payload.get("units")
    if units != {"gyro": "degrees_per_second", "tick": "microseconds"}:
        raise ValueError("units must declare gyro=dps and tick=microseconds")
    c = payload.get("config")
    if not isinstance(c, dict):
        raise ValueError("config is required")
    config = MeshConfig(**c)
    samples = payload.get("samples")
    if not isinstance(samples, list) or not samples:
        raise ValueError("samples must be a non-empty list")
    previous_tick: int | None = None
    previous_sequence = -1
    angle = [0.0, 0.0, 0.0]
    smoothed = [0.0, 0.0, 0.0]
    frames: list[dict[str, Any]] = []
    rejected = 0
    for sample in samples:
        if not isinstance(sample, dict):
            raise ValueError("each sample must be an object")
        sequence = sample.get("sequence")
        if type(sequence) is not int or sequence <= previous_sequence:
            raise ValueError("sequence must strictly increase")
        tick = sample.get("tick_us")
        if type(tick) is not int or tick < 0 or (previous_tick is not None and tick <= previous_tick):
            raise ValueError("tick_us must strictly increase")
        rates = sample.get("gyro_dps")
        if not isinstance(rates, list) or len(rates) != 3:
            raise ValueError("gyro_dps must contain [pitch,yaw,roll]")
        values = [_finite(v, "gyro_dps") for v in rates]
        if any(abs(v) > config.max_rate_dps for v in values):
            raise ValueError("gyro rate exceeds configured safety limit")
        dt = 0 if previous_tick is None else tick - previous_tick
        if dt > 100_000:
            raise ValueError("sample gap exceeds 100ms")
        for i, value in enumerate(values):
            rate_rad = math.radians(value)
            old_angle = angle[i]
            angle[i] += rate_rad * dt / 1_000_000.0
            if config.smoothing_alpha == 1:
                smoothed[i] = angle[i]
            elif dt:
                # Exact first-order response to the linear angle trajectory
                # implied by this sample's zero-order-held angular rate.
                # Alpha refers to a declared interval, rather than one record,
                # so splitting the same rate interval leaves the state equal.
                tau = -(config.smoothing_reference_interval_us / 1_000_000.0) / math.log1p(-config.smoothing_alpha)
                decay = math.exp(-(dt / 1_000_000.0) / tau)
                smoothed[i] = angle[i] - rate_rad * tau + (smoothed[i] - old_angle + rate_rad * tau) * decay
        correction = tuple(smoothed[i] - angle[i] for i in range(3))
        try:
            points, displacement = _mesh(config, correction)
        except ValueError:
            rejected += 1
            raise
        frames.append({"sequence": sequence, "tick_us": tick, "dt_us": dt,
                       "integrated_angle_rad": list(angle),
                       "smoothed_angle_rad": list(smoothed),
                       "correction_angle_rad": list(correction),
                       "max_displacement": displacement,
                       "mesh_format": "normalized_q16.16",
                       "mesh": points})
        previous_tick, previous_sequence = tick, sequence
    return {
        "schema": "yi4k.eis-candidate-mesh/v1",
        "algorithm": "causal_gyro_residual_affine/v2",
        "mesh_semantics": "output-to-source normalized coordinates; cropped baseline; hypothetical host axis convention",
        "config": asdict(config),
        "source_trace_sha256": hashlib.sha256(json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()).hexdigest(),
        "frame_count": len(frames), "rejected_frames": rejected,
        "frames": frames,
        "gate": {"host_candidate_ready": True, "stock_abi_compatible": False,
                 "device_access": False, "replacement_deployment_ready": False},
        "limitations": [
            "The trace uses explicit dps and microsecond units; no camera gyro calibration or exposure timing is supplied.",
            "The projection is a conservative host candidate, not the recovered A032CF38 table format or stock Q interpretation.",
            "No image quality, rolling-shutter, DSP latch, deadline, cache, RTOS entry or encoded-frame result is proved.",
            "A crop-margin rejection is fail-closed; it never emits a folded or black-border mesh.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = validate_trace(json.loads(args.input.read_text()))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"frames": result["frame_count"], "host_candidate_ready": True,
                      "stock_abi_compatible": False, "device_access": False}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
