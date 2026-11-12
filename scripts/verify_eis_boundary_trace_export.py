#!/usr/bin/env python3
"""Verify the envelope of a stock-only A0384710 trace export.

This is a host-only parser.  It validates a self-declared export contract,
then delegates scalar checks to ``eis_boundary_trace_gate.py``.  It never
contacts a camera and cannot authenticate that a file really came from one;
the report therefore distinguishes ``real-stock-only-declared`` from a
synthetic test file.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

from eis_boundary_trace_gate import (DEFAULT_SCALAR_VALIDATION, evaluate,
                                     load_scalar_validation)
from eis_filter_replay import IMAGE, load_identity

EXPORT_SCHEMA = "yi4k.eis-boundary-trace-export/v1"
GATE_SCHEMA = "yi4k.eis-boundary-trace-gate/v1"
FUNCTION = "0xA0384710"


def canonical_records(records: list[dict[str, Any]]) -> bytes:
    return json.dumps(records, ensure_ascii=False, sort_keys=True,
                      separators=(",", ":")).encode()


def verify_envelope(export: dict[str, Any], identity: dict[str, Any],
                    allow_synthetic: bool = False) -> tuple[dict[str, Any], list[str]]:
    blockers: list[str] = []
    if export.get("schema") != EXPORT_SCHEMA:
        blockers.append(f"schema must be {EXPORT_SCHEMA}")
    evidence = export.get("evidence")
    if not isinstance(evidence, dict):
        blockers.append("missing evidence metadata")
        evidence = {}
    evidence_kind = evidence.get("kind")
    synthetic = evidence.get("synthetic")
    if evidence_kind not in ("real-stock-only", "synthetic-test"):
        blockers.append("evidence.kind must be real-stock-only or synthetic-test")
    if type(synthetic) is not bool:
        blockers.append("evidence.synthetic must be boolean")
    elif (evidence_kind == "real-stock-only") != (synthetic is False):
        blockers.append("evidence.kind and evidence.synthetic disagree")
    if evidence_kind == "synthetic-test" and not allow_synthetic:
        blockers.append("synthetic export requires --allow-synthetic for schema testing")
    if not isinstance(evidence.get("collector"), str) or not evidence["collector"]:
        blockers.append("evidence.collector is missing")

    target = export.get("target")
    if not isinstance(target, dict):
        blockers.append("missing target identity")
        target = {}
    if target.get("sha256") != identity["sha256"]:
        blockers.append("target sha256 does not match pinned image")
    if target.get("function") != FUNCTION:
        blockers.append("target function is not A0384710")

    capture = export.get("capture")
    if not isinstance(capture, dict):
        blockers.append("missing capture metadata")
        capture = {}
    export_meta = export.get("export")
    if not isinstance(export_meta, dict):
        blockers.append("missing export metadata")
        export_meta = {}
    if export_meta.get("format") != "json-records-v1":
        blockers.append("export.format must be json-records-v1")
    if export_meta.get("read_mode") != "producer-quiescent":
        blockers.append("export.read_mode must prove producer-quiescent export")
    if export_meta.get("producer_quiescent") is not True:
        blockers.append("export does not assert producer_quiescent=true")
    if export_meta.get("committed_contiguous") is not True:
        blockers.append("export does not assert committed_contiguous=true")
    if export_meta.get("record_capacity") != 128:
        blockers.append("record_capacity must be 128")
    record_bytes = export_meta.get("record_bytes")
    if record_bytes != 88:
        blockers.append("v1 80B exports are not eligible; v2 export must use record_bytes=88")

    records = export.get("records")
    if not isinstance(records, list) or not records:
        blockers.append("records must be a nonempty list")
        records = []
    if export_meta.get("committed_count") != len(records):
        blockers.append("committed_count does not match records length")
    if export_meta.get("dropped_full", 0) != 0:
        blockers.append("export reports dropped_full records")
    if capture.get("dropped_records", 0) != 0:
        blockers.append("capture reports dropped records")
    if capture.get("busy_seen", False):
        blockers.append("capture reports wrapper contention")
    if not isinstance(capture.get("source"), str) or not capture["source"]:
        blockers.append("capture.source is missing")
    if capture.get("stock_only") is not True:
        blockers.append("capture.stock_only must be true")
    if capture.get("previous_after_available") is not True:
        blockers.append("capture.previous_after_available must be true")
    if capture.get("record_bytes") != record_bytes:
        blockers.append("capture.record_bytes does not match export.record_bytes")
    if capture.get("record_bytes") != 88:
        blockers.append("capture must declare v2 88B records for replacement evidence")
    if capture.get("committed_contiguous") is not True:
        blockers.append("capture.committed_contiguous must be true")
    if capture.get("synthetic") is not synthetic:
        blockers.append("capture.synthetic disagrees with evidence.synthetic")

    sequences = []
    commits = []
    for index, record in enumerate(records):
        if not isinstance(record, dict):
            blockers.append(f"record {index} is not an object")
            continue
        sequence = record.get("sequence")
        if type(sequence) is not int:
            blockers.append(f"record {index} sequence is not an integer")
        else:
            sequences.append(sequence)
            if sequence != index:
                blockers.append(f"record {index} sequence is not contiguous from zero")
        if "commit" not in record:
            blockers.append(f"record {index} has no commit publication marker")
        else:
            commit = record["commit"]
            if type(commit) is not int or commit != index + 1:
                blockers.append(f"record {index} commit is not sequence+1")
            else:
                commits.append(commit)
    if sequences and sequences != list(range(len(records))):
        blockers.append("record sequences are not contiguous")
    if records and commits != list(range(1, len(records) + 1)):
        blockers.append("record commits are not contiguous")
    expected_hash = export_meta.get("records_sha256")
    actual_hash = hashlib.sha256(canonical_records(records)).hexdigest()
    if expected_hash != actual_hash:
        blockers.append("records_sha256 does not match canonical records")

    payload = {
        "schema": GATE_SCHEMA,
        "sample_kind": "caller captured scalar function-boundary trace",
        "target": target,
        "capture": capture,
        "samples": records,
    }
    return payload, blockers


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("export", type=Path)
    parser.add_argument("--image", type=Path, default=IMAGE)
    parser.add_argument("--scalar-validation", type=Path, default=DEFAULT_SCALAR_VALIDATION)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--allow-synthetic", action="store_true",
                        help="parse synthetic files for schema tests; never enables the replacement gate")
    args = parser.parse_args()
    identity, defaults = load_identity(args.image)
    raw = args.export.read_bytes()
    export = json.loads(raw)
    payload, envelope_blockers = verify_envelope(export, identity, args.allow_synthetic)
    scalar = load_scalar_validation(args.scalar_validation, identity)
    gate = evaluate(payload, identity, defaults, scalar)
    gate["replacement_gate"]["blockers"] = envelope_blockers + gate["replacement_gate"]["blockers"]
    gate["replacement_gate"]["passed"] = not gate["replacement_gate"]["blockers"]
    gate["replacement_gate"]["decision"] = (
        "eligible for a separately reviewed stock-equivalent replacement experiment"
        if gate["replacement_gate"]["passed"] else "do not replace A0384710; continue stock-only capture")
    evidence = export.get("evidence", {})
    report = {
        "schema": "yi4k.eis-boundary-trace-export-report/v1",
        "input": {"path": str(args.export), "sha256": hashlib.sha256(raw).hexdigest()},
        "export_verification": {
            "passed": not envelope_blockers,
            "evidence_class": "real-stock-only-declared" if evidence.get("kind") == "real-stock-only"
                              else "synthetic-test",
            "authenticity": "self-declared metadata; no hardware attestation",
            "blockers": envelope_blockers,
        },
        "gate": gate,
        "device_contacted": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"export_passed": not envelope_blockers,
                      "evidence_class": report["export_verification"]["evidence_class"],
                      "gate_passed": gate["replacement_gate"]["passed"],
                      "output": str(args.output), "device_contacted": False}, ensure_ascii=False))
    return 0 if gate["replacement_gate"]["passed"] else 2


if __name__ == "__main__":
    raise SystemExit(main())
