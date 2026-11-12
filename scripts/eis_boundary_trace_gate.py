#!/usr/bin/env python3
"""Validate a stock A0384710 boundary trace and report the replacement gate.

The input is a host-exported, stock-only trace.  It is deliberately separate
from raw gyro logs: ``input`` is the transformed scalar passed in r1 and
``previous`` is the value dereferenced through r2 at the call boundary.  This
tool never contacts a camera and never creates a patch or loader.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

from eis_filter_replay import IMAGE, Parameters, load_identity, stock_step, signed32

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SCALAR_VALIDATION = ROOT / "artifacts/device/2026-11-10-eis-filter-replay/validation.json"
EXPECTED_FUNCTION = "0xA0384710"
SITES = (1, 2)
I32_MIN, I32_MAX = -(1 << 31), (1 << 31) - 1

# These are deliberately conservative.  They make a real trace useful for
# caller topology and timing without pretending it proves pixel quality.
MIN_TOTAL = 2000
MIN_PER_SITE = 500
MIN_ADAPTIVE = 32
MIN_COUNT_TRANSITIONS = 8
MIN_CLAMPED = 100
MIN_UNCLAMPED = 100


def i32(value: Any, label: str) -> int:
    if type(value) is not int or not I32_MIN <= value <= I32_MAX:
        raise ValueError(f"{label} must be a signed 32-bit integer")
    return value


def u8(value: Any, label: str) -> int:
    if type(value) is not int or not 0 <= value <= 255:
        raise ValueError(f"{label} must be an unsigned byte")
    return value


def load_scalar_validation(path: Path, identity: dict[str, Any]) -> dict[str, Any]:
    try:
        report = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        return {"ok": False, "reason": f"scalar validation unavailable: {exc}"}
    target = report.get("target", {})
    cases = report.get("differential_cases", 0)
    mismatches = report.get("mismatches", 1)
    ok = (target.get("sha256") == identity["sha256"] and
          target.get("function") == EXPECTED_FUNCTION and
          type(cases) is int and cases >= 3240 and mismatches == 0)
    reason = None if ok else "scalar validation identity/case/mismatch gate failed"
    return {"ok": ok, "reason": reason, "path": str(path),
            "differential_cases": cases, "mismatches": mismatches,
            "sha256": target.get("sha256"), "function": target.get("function")}


def evaluate(payload: dict[str, Any], identity: dict[str, Any], defaults: dict[str, Any],
             scalar: dict[str, Any]) -> dict[str, Any]:
    blockers: list[str] = []
    if payload.get("schema") != "yi4k.eis-boundary-trace-gate/v1":
        blockers.append("trace schema is not yi4k.eis-boundary-trace-gate/v1")
    sample_kind = payload.get("sample_kind")
    if not isinstance(sample_kind, str) or "boundary" not in sample_kind:
        blockers.append("trace sample_kind does not identify a function-boundary capture")
    target = payload.get("target")
    if not isinstance(target, dict):
        blockers.append("missing target identity")
        target = {}
    if target.get("sha256") != identity["sha256"]:
        blockers.append("trace firmware hash does not match pinned 1.10.7 image")
    if target.get("function") != EXPECTED_FUNCTION:
        blockers.append("trace target is not A0384710")

    capture = payload.get("capture")
    if not isinstance(capture, dict):
        blockers.append("missing capture metadata")
        capture = {}
    for key, message in (
        ("stock_only", "capture was not explicitly stock-only"),
        ("committed_contiguous", "export does not prove contiguous committed records"),
        ("previous_after_available", "capture lacks the post-call previous canary"),
    ):
        if capture.get(key) is not True:
            blockers.append(message)
    if capture.get("synthetic") is True:
        blockers.append("synthetic trace cannot pass the replacement gate")
    record_bytes = capture.get("record_bytes")
    if record_bytes == 80:
        blockers.append("v1 80B shadow records have no previous_after; they cannot pass the replacement gate")
    elif record_bytes != 88:
        blockers.append("replacement gate requires v2 88B records with previous_after")
    if capture.get("dropped_records", 0) != 0:
        blockers.append("capture reports dropped records")
    if capture.get("busy_seen", False):
        blockers.append("capture saw wrapper contention; call coverage is incomplete")
    if not isinstance(capture.get("source"), str) or not capture["source"]:
        blockers.append("capture source is unspecified")

    samples = payload.get("samples")
    if not isinstance(samples, list) or not samples:
        blockers.append("samples must be a nonempty list")
        samples = []

    rows: list[dict[str, Any]] = []
    errors: list[dict[str, Any]] = []
    last_sequence = -1
    last_tick: int | None = None
    counts = {"site_1": 0, "site_2": 0, "adaptive": 0, "count_transitions": 0,
              "clamped": 0, "unclamped": 0, "ticks": 0, "previous_unchanged": 0,
              "wrapped": 0}
    required = ("sequence", "site", "mode", "input", "previous_address", "previous",
                "observed_output", "count_before", "count_after", "limit", "gain",
                "adaptive_enabled", "small_motion_degrees", "scale_shift",
                "small_count_limit", "adaptive_feedback")
    for index, sample in enumerate(samples):
        if not isinstance(sample, dict):
            errors.append({"index": index, "error": "sample is not an object"})
            continue
        missing = [key for key in required if key not in sample]
        if missing:
            errors.append({"index": index, "error": "missing fields", "fields": missing})
            continue
        try:
            sequence = sample["sequence"]
            if type(sequence) is not int or sequence <= last_sequence:
                raise ValueError("sequence must strictly increase")
            last_sequence = sequence
            site = sample["site"]
            if site not in SITES:
                raise ValueError("site must be 1 or 2")
            if sample["mode"] != 2:
                raise ValueError("mode must be the recovered callsite value 2")
            current = i32(sample["input"], "input")
            previous = i32(sample["previous"], "previous")
            observed = i32(sample["observed_output"], "observed_output")
            address = sample["previous_address"]
            if type(address) is not int or address <= 0 or address & 3:
                raise ValueError("previous_address must be a nonzero 4-byte-aligned address")
            before = u8(sample["count_before"], "count_before")
            after = u8(sample["count_after"], "count_after")
            adaptive = sample["adaptive_enabled"]
            if type(adaptive) is not bool:
                raise ValueError("adaptive_enabled must be boolean")
            params = Parameters(
                limit=i32(sample["limit"], "limit"),
                gain=i32(sample["gain"], "gain"),
                adaptive_enabled=adaptive,
                small_motion_degrees=i32(sample["small_motion_degrees"], "small_motion_degrees"),
                scale_shift=i32(sample["scale_shift"], "scale_shift"),
                small_count_limit=u8(sample["small_count_limit"], "small_count_limit"),
                adaptive_feedback=i32(sample["adaptive_feedback"], "adaptive_feedback"),
                radians_numerator=sample.get("radians_numerator", defaults["radians_numerator"]),
                radians_denominator=sample.get("radians_denominator", defaults["radians_denominator"]),
            )
            expected, expected_count, details = stock_step(previous, current, params, before)
            if observed != expected:
                raise ValueError(f"observed_output {observed} != reference {expected}")
            if after != expected_count:
                raise ValueError(f"count_after {after} != reference {expected_count}")
            if "stock_invocations" in sample and sample["stock_invocations"] != 1:
                raise ValueError("stock_invocations must be exactly one")
            if "previous_after" in sample and i32(sample["previous_after"], "previous_after") != previous:
                raise ValueError("stock call changed the previous slot")
            unchanged = sample.get("previous_unchanged")
            if unchanged is not True:
                raise ValueError("previous_unchanged must be true for replacement evidence")
            tick_before = sample.get("tick_before")
            tick_after = sample.get("tick_after")
            if tick_before is None or tick_after is None:
                raise ValueError("tick_before and tick_after are required")
            if (type(tick_before) is not int or type(tick_after) is not int or
                    tick_after < tick_before or (last_tick is not None and tick_before < last_tick)):
                raise ValueError("ticks must be nondecreasing and tick_after >= tick_before")
            last_tick = tick_after
            counts[f"site_{site}"] += 1
            counts["adaptive"] += int(adaptive)
            counts["count_transitions"] += int(after != before)
            counts["clamped"] += int(details["clamped"])
            counts["unclamped"] += int(not details["clamped"])
            counts["ticks"] += 1
            counts["previous_unchanged"] += 1
            counts["wrapped"] += int(any(details[key] for key in
                                          ("wrapped_feedback_product", "wrapped_input_product", "wrapped_addition")))
            rows.append({"sequence": sequence, "site": site, "expected_output": expected,
                         "observed_output": observed, "count_before": before,
                         "count_after": after, "clamped": details["clamped"],
                         "adaptive": adaptive})
        except (TypeError, ValueError, KeyError, OverflowError) as exc:
            errors.append({"index": index, "sequence": sample.get("sequence"), "error": str(exc)})

    if errors:
        blockers.append(f"{len(errors)} trace rows failed schema/reference validation")
    if not scalar.get("ok"):
        blockers.append(scalar.get("reason") or "scalar validation failed")
    coverage_requirements = {
        "total": (len(rows), MIN_TOTAL),
        "site_1": (counts["site_1"], MIN_PER_SITE),
        "site_2": (counts["site_2"], MIN_PER_SITE),
        "adaptive": (counts["adaptive"], MIN_ADAPTIVE),
        "count_transitions": (counts["count_transitions"], MIN_COUNT_TRANSITIONS),
        "clamped": (counts["clamped"], MIN_CLAMPED),
        "unclamped": (counts["unclamped"], MIN_UNCLAMPED),
    }
    for name, (actual, minimum) in coverage_requirements.items():
        if actual < minimum:
            blockers.append(f"coverage {name}={actual} is below required {minimum}")
    gate_passed = not blockers
    return {
        "schema": "yi4k.eis-boundary-trace-gate/v1",
        "target": identity,
        "trace_sample_count": len(samples),
        "validated_rows": len(rows),
        "row_errors": errors[:32],
        "row_error_count": len(errors),
        "coverage": counts | {"requirements": {name: minimum for name, (_, minimum) in coverage_requirements.items()}},
        "scalar_validation": scalar,
        "replacement_gate": {
            "passed": gate_passed,
            "blockers": blockers,
            "decision": "eligible for a separately reviewed stock-equivalent replacement experiment" if gate_passed
                        else "do not replace A0384710; continue stock-only capture",
        },
        "limitations": [
            "A passing gate proves scalar boundary equivalence and capture completeness only; it says nothing about image quality.",
            "The trace must be collected with the stock function still executing and with a bounded recorder.",
            "The gate does not prove executable placement, cache publication, SMP ownership, timing budget, or rollback.",
            "A replacement experiment still requires a separate native execution and recovery gate plus one-variable video acceptance.",
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("trace", type=Path)
    parser.add_argument("--image", type=Path, default=IMAGE)
    parser.add_argument("--scalar-validation", type=Path, default=DEFAULT_SCALAR_VALIDATION)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--strict", action="store_true", help="exit nonzero unless the replacement gate passes")
    args = parser.parse_args()
    identity, defaults = load_identity(args.image)
    payload = json.loads(args.trace.read_text())
    scalar = load_scalar_validation(args.scalar_validation, identity)
    result = evaluate(payload, identity, defaults, scalar)
    raw = args.trace.read_bytes()
    result["input"] = {"path": str(args.trace), "sha256": hashlib.sha256(raw).hexdigest()}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"gate_passed": result["replacement_gate"]["passed"],
                      "validated_rows": result["validated_rows"], "row_errors": result["row_error_count"],
                      "output": str(args.output), "device_contacted": False}, ensure_ascii=False))
    return 0 if result["replacement_gate"]["passed"] or not args.strict else 2


if __name__ == "__main__":
    raise SystemExit(main())
