#!/usr/bin/env python3
"""Offline integration of typed camera triggers with the 60-second buffer.

The input events are already classified camera events. This script does not
access a microphone, GPIO, camera, firmware or storage; it checks the seam
between the trigger router and the host buffer state machine.
"""
from __future__ import annotations

import json
from pathlib import Path

from prerecord_buffer import PreRecordBuffer, Segment, State
from prerecord_trigger import (
    CameraEvent,
    CameraEventType,
    Decision,
    PreRecordTriggerRouter,
)

SECOND = 1_000_000
OUT = Path(__file__).resolve().parents[1] / "artifacts/host-prerecord/trigger-buffer-integration.json"


def run_case(name: str, start_kind: str) -> dict:
    router = PreRecordTriggerRouter()
    buffer = PreRecordBuffer()
    delivered = []
    # One-second independently decodable segments provide exactly 60 seconds
    # before START at 65 seconds and let STOP land on a segment boundary.
    for index in range(65):
        delivered.append(buffer.ingest(Segment(
            f"part-{index:04d}.mp4", index * SECOND, (index + 1) * SECOND, True)))
    if start_kind == "voice":
        accepted = router.on_camera_event(CameraEvent(CameraEventType.START_RECORDING, 65 * SECOND))
    elif start_kind == "shutter":
        accepted = router.on_shutter(65 * SECOND)
    else:
        raise ValueError(start_kind)
    assert accepted.decision is Decision.ACCEPTED
    started, evicted = buffer.start(accepted.at_us)
    assert started
    delivered.append(evicted)
    duplicate = router.on_shutter(66 * SECOND)
    assert duplicate.decision is Decision.DUPLICATE
    assert buffer.stop(71 * SECOND)
    for index in range(65, 71):
        delivered.append(buffer.ingest(Segment(
            f"part-{index:04d}.mp4", index * SECOND, (index + 1) * SECOND, True)))
    assert buffer.state is State.FINALIZING
    buffer.complete()
    summary = buffer.summary()
    assert summary["full_window_available"]
    assert summary["available_pretrigger_us"] == 60 * SECOND
    assert summary["stop_overshoot_us"] == 0
    return {
        "name": name,
        "start_source": accepted.source.value,
        "accepted_at_us": accepted.at_us,
        "duplicate_after_start": duplicate.decision.value,
        "evicted_segments": sum(len(item) for item in delivered),
        "summary": summary,
    }


def main() -> None:
    cases = [run_case("voice_start_then_shutter_duplicate", "voice"),
             run_case("shutter_start_then_voice_duplicate", "shutter")]
    result = {
        "scope": "offline typed camera-event to host buffer seam; no camera, microphone, GPIO, firmware or storage",
        "window_us": 60 * SECOND,
        "cases": cases,
        "assertions": 2 * 7,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"output": str(OUT), "cases": len(cases), "assertions": result["assertions"]}))


if __name__ == "__main__":
    main()
