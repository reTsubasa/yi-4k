#!/usr/bin/env python3
"""Build a conservative, hash-checked EIS replacement readiness ledger.

This is an offline evidence gate.  It reads prior static/host audit JSON files,
verifies that their referenced source artifacts still have the recorded hashes,
and reports which parts of the replacement contract are demonstrated versus
which runtime gates remain open.  It never connects to a camera, executes ORC
or RTOS code, and never writes firmware/RAM/partitions.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "artifacts/device/2026-11-11-eis-replacement-readiness/audit.json"

EVIDENCE = {
    "filter_replay": ROOT / "artifacts/device/2026-11-11-eis-filter-replay/validation-next.json",
    "shadow_v2": ROOT / "artifacts/device/2026-11-11-eis-shadow-v2-rerun/validation.json",
    "publication_owner": ROOT / "artifacts/device/2026-11-11-eis-vcap-update-addr/audit.json",
    "orc_call_sites": ROOT / "artifacts/device/2026-11-11-eis-orc-feedback-call-sites-rerun/audit.json",
    "orc_transfer": ROOT / "artifacts/device/2026-11-11-eis-orc-transfer-dependencies/audit.json",
    "vertical_gate": ROOT / "artifacts/device/2026-11-11-eis-vertical-done-log-gate/audit.json",
    "feedback_closure": ROOT / "artifacts/device/2026-11-10-eis-feedback-table-closure/audit.json",
}

PINNED_SOURCES = {
    "rtos_window": (ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin",
                    "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"),
    "dsp_container": (ROOT / "artifacts/firmware/v1.10.52/_part_dsp.a9s",
                      "9b56d1d2cf3bfddc3da06d4d0b7e26543f23708369e1bd13c1afac30c8edea73"),
    "or1k_reference": (ROOT / "artifacts/device/2026-11-10-eis-orc-core/reference/or1k-opc.c",
                       "4383b2c2ddceafec258d3907dee382d76389ca3604c0cad867fc58d15a30039c"),
    "ghidra_calls": (ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/calls.tsv",
                     "2e75c7ed3d04d6c21ea6357fee3117e99aa5430b61110aedbb0ec002c509f039"),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"{path} is not a JSON object")
    return value


def flag_false(doc: dict[str, Any], *keys: str) -> bool:
    """Return true only when every named safety flag is explicitly false."""
    return all(doc.get(key) is False for key in keys)


def nonempty_list(doc: dict[str, Any], key: str) -> bool:
    value = doc.get(key)
    return isinstance(value, list) and bool(value)


def input_hashes(doc: dict[str, Any]) -> dict[str, str]:
    """Collect hash fields from the common audit layouts for the ledger."""
    result: dict[str, str] = {}
    for key in ("dsp_sha256", "orccode_sha256", "reference_sha256"):
        if isinstance(doc.get(key), str):
            result[key] = doc[key]
    inputs = doc.get("inputs")
    if isinstance(inputs, dict):
        for key, value in inputs.items():
            if key.endswith("sha256") and isinstance(value, str):
                result[key] = value
    target = doc.get("target")
    if isinstance(target, dict) and isinstance(target.get("sha256"), str):
        result["target_sha256"] = target["sha256"]
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()

    docs: dict[str, dict[str, Any]] = {}
    file_records: dict[str, dict[str, Any]] = {}
    errors: list[str] = []
    pinned_source_records: dict[str, dict[str, Any]] = {}
    for name, (path, expected) in PINNED_SOURCES.items():
        try:
            actual = sha256(path)
            pinned_source_records[name] = {
                "path": str(path.relative_to(ROOT)),
                "expected_sha256": expected,
                "actual_sha256": actual,
                "matches": actual == expected,
                "bytes": path.stat().st_size,
            }
        except Exception as error:
            pinned_source_records[name] = {
                "path": str(path.relative_to(ROOT)),
                "expected_sha256": expected,
                "actual_sha256": None,
                "matches": False,
                "error": str(error),
            }
    for name, path in EVIDENCE.items():
        try:
            doc = load(path)
            docs[name] = doc
            file_records[name] = {
                "path": str(path.relative_to(ROOT)),
                "sha256": sha256(path),
                "bytes": path.stat().st_size,
                "input_hashes": input_hashes(doc),
            }
        except Exception as error:  # pragma: no cover - deliberately surfaced in JSON
            errors.append(f"{name}: {error}")

    checks = {
        "stock_filter_replay_matches_zero": (
            docs.get("filter_replay", {}).get("mismatches") == 0,
            "Pinned A32 stock filter and host arithmetic replay have zero mismatches.",
        ),
        "offline_shadow_v2_matches_zero": (
            docs.get("shadow_v2", {}).get("mismatches") == 0
            and docs.get("shadow_v2", {}).get("device_contacted") is False,
            "The v2 shadow wrapper is differentially validated offline with no device contact.",
        ),
        "publication_owner_is_bounded": (
            bool(docs.get("publication_owner", {}).get("call_sites"))
            and nonempty_list(docs.get("publication_owner", {}), "not_proven")
            and flag_false(docs.get("publication_owner", {}), "device_access", "firmware_executed", "writes_to_device"),
            "CPU publication ownership is statically bounded and its runtime gaps remain explicit.",
        ),
        "orc_call_inventory_is_bounded": (
            docs.get("orc_call_sites", {}).get("candidate_count") == 1647
            and flag_false(docs.get("orc_call_sites", {}), "device_access"),
            "The fixed ORC member inventory is complete for the selected image and remains offline.",
        ),
        "orc_transfer_completion_is_unproven": (
            nonempty_list(docs.get("orc_transfer", {}), "not_proven")
            and flag_false(docs.get("orc_transfer", {}), "device_access", "firmware_executed", "writes_to_device"),
            "Transfer dependencies have explicit unresolved completion/latch gaps.",
        ),
        "vertical_done_log_is_not_hardware_ack": (
            nonempty_list(docs.get("vertical_gate", {}), "not_proven")
            and flag_false(docs.get("vertical_gate", {}), "device_access", "firmware_executed", "writes_to_device"),
            "The vertical done-log branch is recorded as software control flow only.",
        ),
        "feedback_closure_keeps_runtime_gaps": (
            nonempty_list(docs.get("feedback_closure", {}), "unknowns")
            and docs.get("feedback_closure", {}).get("device_access") is False
            and docs.get("feedback_closure", {}).get("consistency_checks", {}).get("horizontal_copy_completion_unproven") is True,
            "The cross-audit retains missing runtime writer, atomicity and DSP identity evidence.",
        ),
        "pinned_static_inputs_match": (
            bool(pinned_source_records) and all(item.get("matches") is True for item in pinned_source_records.values()),
            "The fixed RTOS window, DSP container, OR1K decoder reference and Ghidra call inventory still match their recorded hashes.",
        ),
    }

    readiness = {
        "offline_filter_semantics": checks["stock_filter_replay_matches_zero"][0],
        "offline_wrapper_contract": checks["offline_shadow_v2_matches_zero"][0],
        "cpu_publication_address_bounded": checks["publication_owner_is_bounded"][0],
        "orc_transfer_runtime_contract": False,
        "dsp_runtime_identity_and_latch": False,
        "safe_old_slot_reuse": False,
        "custom_eis_replacement_ready": False,
    }
    result = {
        "evidence_type": "offline hash-checked EIS replacement readiness ledger",
        "scope": "Reads prior static/host JSON only; no device, ORC, RTOS, RAM, firmware or partition execution/writes.",
        "firmware_identity": docs.get("filter_replay", {}).get("target", {}).get("firmware"),
        "checks": {name: {"passed": passed, "meaning": meaning} for name, (passed, meaning) in checks.items()},
        "pinned_source_integrity": pinned_source_records,
        "readiness": readiness,
        "source_files": file_records,
        "errors": errors,
        "next_safe_action": (
            "Prepare a user-approved, read-only real-camera gate for runtime DSP identity, one-frame publication/feedback correlation, "
            "and old-slot reuse. Do not load or submit custom EIS code from this ledger."
        ),
        "device_access": False,
        "orc_executed": False,
        "rtos_executed": False,
        "writes_to_device": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if errors or not all(item[0] for item in checks.values()):
        return 1
    print(json.dumps({"output": str(args.output), "checks": len(checks), "custom_eis_replacement_ready": False}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
