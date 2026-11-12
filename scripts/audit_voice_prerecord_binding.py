#!/usr/bin/env python3
"""Audit the offline seam between stock voice semantics and prerecord START.

This is a read-only evidence joiner.  It does not perform recognition, open a
camera socket, touch an SD card, or install an event hook.  The output is
deliberately explicit about which facts are static/host-only and which remain
unproved on the camera.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/verification/2026-11-12-voice-prerecord-binding/audit.json",
    )
    args = ap.parse_args()

    semantics_path = ROOT / "artifacts/device/2026-11-10-voice-semantics/audit.json"
    static_path = ROOT / "artifacts/device/2026-11-10-native-voice/static-evidence.json"
    ring_path = ROOT / "artifacts/verification/2026-11-12-prerecord-media-ring-run03/validation.json"
    python_router = ROOT / "scripts/prerecord_trigger.py"
    c_router = ROOT / "sdk/yi4k_capture_trigger.c"
    java_adapter = ROOT / "android/app/src/main/java/dev/yi4k/control/CaptureTriggerAdapter.java"
    java_router = ROOT / "android/app/src/main/java/dev/yi4k/control/CaptureTriggerRouter.java"

    for path in (semantics_path, static_path, ring_path, python_router, c_router, java_adapter, java_router):
        require(path.is_file(), f"missing evidence/source: {path}")

    semantics = json.loads(semantics_path.read_text())
    static = json.loads(static_path.read_text())
    ring = json.loads(ring_path.read_text())
    python_text = python_router.read_text()
    c_text = c_router.read_text()
    java_adapter_text = java_adapter.read_text()
    java_router_text = java_router.read_text()

    mapping = semantics["class_to_public_code"]
    require(mapping == [1002, 1001, 1004, 1003, 1005], f"unexpected stock class mapping: {mapping}")
    command_names = semantics["command_names"]
    require(command_names[2] == "Yi_action_begin_recording", "stock START semantic name missing")
    require(command_names[3] == "Yi_action_stop_recording", "stock STOP semantic name missing")
    require(semantics["device_access"] is False and semantics["device_write"] is False,
            "voice semantics evidence must remain offline")
    require(semantics["exact_acoustic_phrases_verified"] is False,
            "exact acoustic phrase must not be overstated")

    # Existing static task evidence proves a named task and compiled dispatch
    # ranges, but it intentionally does not prove a live microphone result.
    task_rows = static["existing_runtime_task_snapshots"]
    require(task_rows and all(row["name"] == "VoiceCmd_Task" for row in task_rows),
            "VoiceCmd_Task snapshots missing")
    require(static["runtime_validation"].startswith("Existing native task table snapshots"),
            "static voice scope changed unexpectedly")
    phrase_search = static["phrase_string_search"]

    # The host and Android layers consume typed events and never parse audio or
    # call CameraClient from the adapter.  This is the intended seam for a
    # future camera event transport, not a claim that transport exists.
    require('CAMERA_VOICE_PHRASES' in python_text and '"开始录像"' in python_text and '"start recording"' in python_text,
            "host phrase fixtures missing")
    require('does not perform speech recognition' in python_text, "host router scope marker missing")
    require('YI4K_CAPTURE_START' in c_text and 'YI4K_CAPTURE_STOP' in c_text,
            "C typed START/STOP boundary missing")
    require('import dev.yi4k.control.CameraClient' not in java_adapter_text and '.call(' not in java_adapter_text,
            "Android trigger adapter must not call CameraClient")
    require('START_RECORDING' in java_router_text, "Android typed START boundary missing")

    require(ring["status"] == "pass_archived_media_incremental_ring_publication_and_recovery",
            "ring evidence is not a passing host run")
    require(ring["device_access"] is False, "ring evidence must remain host-only")
    case_names = {case["name"] for case in ring["cases"]}
    require({"voice_interruption_retention_and_recovery", "changed_retained_segment_rejects_recovery",
             "shutter_live_delivery_and_publication"} <= case_names,
            f"ring cases incomplete: {case_names}")
    voice_case = next(case for case in ring["cases"] if case["name"] == "voice_interruption_retention_and_recovery")
    shutter_case = next(case for case in ring["cases"] if case["name"] == "shutter_live_delivery_and_publication")
    require(voice_case["recovery"]["full_decode_passed"] is True, "voice recovery decode gate missing")
    require(shutter_case["exact_same_clip_as_recovered_voice"] is True, "voice/shutter clip identity missing")

    checks = {
        "stock_semantic_class_3_is_start_1003": True,
        "stock_semantic_class_2_is_stop_1004": True,
        "stock_named_voice_task_present": True,
        "exact_acoustic_phrases_unverified": semantics["exact_acoustic_phrases_verified"] is False,
        "typed_host_voice_fixture_contains_both_requested_phrases": True,
        "android_adapter_does_not_call_camera_client": True,
        "host_ring_voice_recovery_decode_passed": True,
        "host_ring_shutter_matches_voice_recovery_sha": True,
    }
    report = {
        "schema": 1,
        "status": "pass_offline_voice_to_prerecord_binding_audit",
        "device_access": False,
        "device_write": False,
        "scope": "Evidence join only; no microphone recognition, camera event transport, GPIO, SD, firmware, RAM or partition operation",
        "recommendation": "Reuse the stock START semantic after camera recognition; do not replace keywords merely to add prerecord.",
        "stock_semantics": {
            "class_to_public_code": mapping,
            "start_result": 1003,
            "stop_result": 1004,
            "start_name": command_names[2],
            "stop_name": command_names[3],
            "task_snapshots": len(task_rows),
            "phrase_string_search": phrase_search,
            "exact_acoustic_phrases_verified": semantics["exact_acoustic_phrases_verified"],
        },
        "typed_event_seam": {
            "python_router": str(python_router.relative_to(ROOT)),
            "c_router": str(c_router.relative_to(ROOT)),
            "android_adapter": str(java_adapter.relative_to(ROOT)),
            "android_calls_camera_client": False,
            "production_input": "typed START_RECORDING event; phrase recognition remains camera responsibility",
        },
        "host_ring": {
            "validation": str(ring_path.relative_to(ROOT)),
            "voice_recovery_clip_sha256": voice_case["recovery"]["clip_sha256"],
            "shutter_exact_same_clip_as_voice_recovery": shutter_case["exact_same_clip_as_recovered_voice"],
            "cases": sorted(case_names),
        },
        "checks": checks,
        "evidence_hashes": {
            str(path.relative_to(ROOT)): digest(path)
            for path in (semantics_path, static_path, ring_path, python_router, c_router, java_adapter, java_router)
        },
        "limits": [
            "The static task table and compiled ARM path do not prove that a particular spoken Mandarin or English phrase is recognized by this camera.",
            "The host phrase list is a test fixture; it is not ASR and does not modify the camera model.",
            "The ring run injects typed voice/shutter events into archived H264/AAC replay; it does not prove camera event delivery, realtime encoder/FIFO, physical SD durability or original mux binding.",
            "A new keyword would require model/feature/pipeline validation and a separately approved reversible device experiment.",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"status": report["status"], "checks": len(checks), "device_access": False}))


if __name__ == "__main__":
    main()
