#!/usr/bin/env python3
"""Verify that the prerecord backend contract is still honest about its gates.

This is a read-only integrity audit.  It does not connect to a camera, execute
RTOS code, or write firmware/RAM/partitions.  The contract is deliberately
allowed to pass only when its evidence hashes still match and every runtime
gate that requires camera evidence remains explicitly open.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONTRACT = ROOT / "artifacts/device/2026-11-11-prerecord-backend-contract/contract.json"
OUT_DIR = ROOT / "artifacts/device/2026-11-11-prerecord-backend-gate-audit"
OUT = OUT_DIR / "audit.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def check(name: str, condition: bool, detail: str) -> dict:
    return {"name": name, "status": "passed" if condition else "failed", "detail": detail}


def main() -> None:
    contract = json.loads(CONTRACT.read_text())
    checks: list[dict] = []

    checks.append(check(
        "contract scope remains offline",
        contract.get("candidate_status") == "offline_contract_only_not_device_ready"
        and contract.get("generated_scope", "").startswith("offline"),
        "candidate is still explicitly marked as an offline contract",
    ))

    safety = contract.get("safety", {})
    unsafe_flags = {key: value for key, value in safety.items() if value is not False}
    checks.append(check(
        "safety flags are all false",
        not unsafe_flags,
        "camera, firmware, RAM/partition, hidden setter, and RTOS execution flags are false",
    ))

    gates = contract.get("runtime_gates", [])
    gate_names = {gate.get("gate") for gate in gates}
    required_gates = {
        "virtual FIFO create/base validity",
        "descriptor/payload stable lease",
        "callback quiescence before Delete",
        "segment first access unit",
        "A/V capture epoch",
        "continuous producer across rollover",
        "storage/power recovery",
        "camera voice/shutter delivery",
    }
    checks.append(check(
        "all required runtime gates are represented",
        required_gates <= gate_names,
        f"represented {len(required_gates & gate_names)}/{len(required_gates)} required camera gates",
    ))
    closed = [gate.get("gate") for gate in gates if gate.get("status") in {"passed", "verified", "closed"}]
    checks.append(check(
        "no camera gate is falsely closed",
        not closed,
        "all runtime gates remain missing or explicitly unproven",
    ))

    evidence_results = []
    for name, entry in contract.get("evidence", {}).items():
        path = ROOT / entry["path"]
        exists = path.is_file()
        actual = sha256(path) if exists else None
        matches = exists and actual == entry.get("sha256")
        evidence_results.append({
            "name": name,
            "path": entry["path"],
            "exists": exists,
            "expected_sha256": entry.get("sha256"),
            "actual_sha256": actual,
            "matches": matches,
        })
    checks.append(check(
        "contract evidence hashes still match",
        all(item["matches"] for item in evidence_results),
        f"verified {sum(item['matches'] for item in evidence_results)}/{len(evidence_results)} evidence files",
    ))

    # A runtime-ready claim must have a positive device-access marker.  The
    # current contract intentionally has none; this check prevents a future
    # edit from silently turning host/ARM evidence into a deployment claim.
    checks.append(check(
        "offline evidence is not promoted to runtime proof",
        all(item.get("device_access") is not True for item in contract.get("evidence", {}).values()),
        "contract evidence entries contain no device_access=true assertion",
    ))

    passed = all(item["status"] == "passed" for item in checks)
    result = {
        "schema": "yi4k.prerecord-backend-gate-audit/v1",
        "contract": str(CONTRACT.relative_to(ROOT)),
        "status": "passed" if passed else "failed",
        "device_access": False,
        "firmware_written": False,
        "ram_or_partition_written": False,
        "rtos_executed": False,
        "checks": checks,
        "evidence": evidence_results,
        "open_gates": [gate for gate in gates if gate.get("status") not in {"passed", "verified", "closed"}],
        "next_safe_action": "Run only the bounded real-camera read-only gates after explicit device-test authorization; do not install a callback or submit a custom EIS/prerecord payload from this audit.",
    }
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps({"output": str(OUT), "checks": len(checks), "status": result["status"]}, ensure_ascii=False))
    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
