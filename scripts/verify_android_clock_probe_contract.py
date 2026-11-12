#!/usr/bin/env python3
"""Audit the explicit Android camera-clock probe contract without device access.

This intentionally reads source files only. It proves the live probe is opt-in
and records request/readback fields; it does not prove a camera was synchronized.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / "android/app/build.gradle"
PROBE = ROOT / "android/app/src/test/java/dev/yi4k/control/CameraLiveProbe.java"
TEST = ROOT / "android/app/src/test/java/dev/yi4k/control/CameraConfigurationTest.java"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(text: str, needle: str, label: str) -> None:
    if needle not in text:
        raise AssertionError(f"missing {label}: {needle}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise SystemExit(f"refusing to overwrite {args.output}")

    build, probe, test = BUILD.read_text(), PROBE.read_text(), TEST.read_text()
    require(build, "providers.gradleProperty('syncClock').getOrElse('false')", "default-off Gradle property")
    require(build, "providers.gradleProperty('changeSetting').getOrElse('false'),\n            providers.gradleProperty('syncClock')", "explicit probe argument")
    require(probe, 'boolean syncClock = false;', "default-off probe flag")
    require(probe, 'put("sync_clock_requested", syncClock)', "request evidence")
    require(probe, 'CameraConfiguration.syncClock(camera)', "camera-clock write/readback path")
    require(probe, 'put("requested_at", requestedAt)', "requested time evidence")
    require(probe, 'put("readback", readback)', "readback evidence")
    require(probe, 'put("readback_verified", true)', "verification evidence")
    require(test, "syncClockWritesAndroidTimeAndVerifiesCameraReadback", "loopback protocol test")

    files = {str(path.relative_to(ROOT)): sha256(path) for path in (BUILD, PROBE, TEST)}
    report = {
        "schema": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "status": "pass_host_contract_only",
        "device_access": False,
        "camera_write_performed": False,
        "sync_clock_default": False,
        "explicit_property": "syncClock=true",
        "evidence_fields": [
            "sync_clock_requested",
            "clock_sync.requested_at",
            "clock_sync.readback",
            "clock_sync.readback_verified",
        ],
        "source_sha256": files,
        "limitations": [
            "No physical phone or camera connection",
            "No camera setting write or RTC readback",
            "Host contract does not establish timezone or camera clock accuracy",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps(report, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
