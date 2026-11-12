#!/usr/bin/env python3
"""Build a reproducible offline contract manifest for pre-record segments.

This script consumes the checked-in audit JSON files only.  It validates the
facts used by the segment/rollover design and records the claims that still
need runtime observations.  It never opens a camera, writes firmware/RAM, or
executes a device-side API.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
IMAGE = Path("artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin")
IMAGE_SHA256 = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
OUT_DEFAULT = ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-segment-manifest.json"

EVIDENCE = [
    Path("artifacts/device/2026-11-10-prerecord/prerecord-sync-boundary-audit.json"),
    Path("artifacts/device/2026-11-10-prerecord/prerecord-audio-config-audit.json"),
    Path("artifacts/device/2026-11-10-prerecord/audio-producer-audit.json"),
    Path("artifacts/device/2026-11-10-prerecord/prerecord-session-rollover-audit.json"),
    Path("artifacts/device/2026-11-10-prerecord/output-contract.json"),
    Path("artifacts/device/2026-11-10-prerecord/track-writers-audit.json"),
]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise AssertionError(f"{path} is not a JSON object")
    return value


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=OUT_DEFAULT)
    args = parser.parse_args()

    image_bytes = (ROOT / IMAGE).read_bytes()
    require(sha256(image_bytes) == IMAGE_SHA256, "unexpected RTOS image SHA-256")

    loaded = {path: read_json(ROOT / path) for path in EVIDENCE}
    sync = loaded[EVIDENCE[0]]
    audio = loaded[EVIDENCE[1]]
    audio_producer = loaded[EVIDENCE[2]]
    session = loaded[EVIDENCE[3]]
    output_contract = loaded[EVIDENCE[4]]
    writers = loaded[EVIDENCE[5]]

    sync_cases = sync.get("cases", [])
    require(sync.get("image_sha256") == IMAGE_SHA256, "sync audit image mismatch")
    require(sync.get("passed_cases") == 67, "sync audit case count changed")
    require(len(sync_cases) == 67 and all(c.get("passed") for c in sync_cases),
            "sync audit contains failed or missing cases")

    gate_cases = [c for c in sync_cases if c.get("case") == "video_sync_type_gate"]
    require(len(gate_cases) == 8, "unexpected sync type gate case count")
    require(sum(bool(c.get("goes_to_limit_check")) for c in gate_cases) == 1,
            "type=1 must be the only limit-gated video type")
    require(next(c for c in gate_cases if c.get("raw_type") == 1).get("goes_to_limit_check") is True,
            "type=1 limit gate missing")
    require(all(c.get("goes_to_limit_check") is False for c in gate_cases if c.get("raw_type") != 1),
            "a non-type=1 video entry reached the limit gate")

    reset_case = next((c for c in sync_cases if c.get("case") ==
                       "iso_open_actual_prefix_codec_cache_clear"), None)
    require(reset_case is not None, "codec-cache reset case missing")
    require(reset_case.get("cleared_movie_range") == ["0x338", "0x670"],
            "unexpected codec-cache clear range")
    parser_cases = [c for c in sync_cases if c.get("case") ==
                    "complete_parser_slice_without_parameter_sets"]
    require(len(parser_cases) == 4, "unexpected slice parser case count")
    require(all(c.get("result") == 10 and c.get("sps_length") == 0 and
                c.get("pps_length") == 0 for c in parser_cases),
            "slice parser counterexample changed")

    audio_rows = audio.get("audited_table_rows", [])
    require(audio.get("test_count") == 10, "audio config test count changed")
    require(len(audio_rows) == 3 and all(r.get("field_08_denominator") == 48000
                                         for r in audio_rows),
            "audio configuration denominator is no longer 48 kHz for all audited rows")
    require(all(r.get("passed") for r in audio.get("results", [])),
            "audio config audit contains failed results")
    require(audio_producer.get("test_count") == 15, "audio producer audit count changed")

    require(session.get("snippet_cases_passed") == 21, "session rollover case count changed")
    require(len(session.get("results", [])) == 21 and
            all(c.get("passed") for c in session.get("results", [])),
            "session rollover audit contains failed or missing cases")

    checks = output_contract.get("checks", {})
    required_checks = [
        "video_event_1f_goes_to_descriptor",
        "video_output_calls_fifo_write",
        "audio_output_calls_fifo_write",
        "video_consumer_peeks",
        "video_consumer_removes",
        "audio_consumer_peeks",
        "audio_consumer_removes",
        "mux_close_waits_before_delete",
        "mux_close_stops_pipe_before_fifo_delete",
    ]
    require(all(checks.get(name) is True for name in required_checks),
            "one or more output-contract checks are no longer true")

    # Hashes make the manifest reviewable and make accidental audit drift
    # visible without embedding all of the audit JSON a second time.
    evidence_files = [
        {"path": str(IMAGE), "sha256": IMAGE_SHA256, "kind": "firmware-window"},
    ]
    for path in EVIDENCE:
        evidence_files.append({
            "path": str(path),
            "sha256": sha256((ROOT / path).read_bytes()),
            "kind": "audit-json",
        })

    manifest = {
        "schema_version": 1,
        "kind": "offline pre-record segment contract manifest",
        "generator": "scripts/prerecord-segment-manifest.py",
        "image": {"path": str(IMAGE), "base": "0xA0100000", "sha256": IMAGE_SHA256},
        "evidence_files": evidence_files,
        "validated": {
            "sync_boundary_cases": sync["passed_cases"],
            "audio_config_cases": audio["test_count"],
            "audio_producer_cases": audio_producer["test_count"],
            "session_rollover_cases": session["snippet_cases_passed"],
            "output_contract_checks": len(required_checks),
        },
        "video_boundary": {
            "type1_only_limit_gate": True,
            "return_before_consume": True,
            "new_open_clears_movie_range": ["0x338", "0x670"],
            "parser_positive_without_parameter_sets": True,
            "sps_pps_rebuild_required": True,
        },
        "audio_config": {
            "audited_selectors": [0, 1, 2],
            "configured_sample_rate_hz": 48000,
            "samples_per_frame_typical": 1024,
            "eventrecord_audio_period_formula_separate": True,
            "shared_capture_epoch_proven": False,
            "aac_config_continuity_proven": False,
        },
        "tracks": {
            "primary_and_secondary_use_mux_limit_helper_static": True,
            "secondary_boundary_requires_default_ended_static": True,
            "audio_video_interleaving_traced": False,
            "producer_clock_epoch_traced": False,
            "writer_ownership_runtime_proven": False,
            "track_writer_unresolved": writers.get("unresolved", []),
        },
        "mux_reuse": {
            "ordinary_event3_close_open_candidate": True,
            "same_mux_pipe_candidate": True,
            "movie_counters_and_pts_reset_static": True,
            "producer_restart_observed": False,
            "eventrecord_standby_or_concurrent_writer_proven": False,
            "virtual_fifo_quiescence_barrier_proven": False,
        },
        "playability": {
            "sps_pps_complete": False,
            "aac_config_continuity": False,
            "av_sync_continuity": False,
            "playable_output": False,
        },
        "required_runtime_observations": [
            "descriptor type, PTS, payload address/size and FIFO cursor per consumer",
            "first new-segment sync payload bytes, including NAL7/NAL8/NAL5 ordering",
            "SPS/PPS cache lengths and bytes after each new IsoMux_Open",
            "AAC AudioSpecificConfig and sample-entry continuity in every new file",
            "audio/video first-sample timestamps and producer clock epoch",
            "close/open return values, writer ownership and payload lifetime",
            "final files opened by an independent MP4/H.264/AAC validator",
        ],
        "limitations": [
            "All evidence is offline original ARM execution or static linkage over synthetic RAM.",
            "A positive slice parser return does not establish SPS/PPS completeness or decodability.",
            "The 48 kHz/1024 audio values are configuration evidence, not a live ADC measurement.",
            "Ordinary mux event-3 close/open is a reuse candidate; producer restart and seamless A/V continuity remain unproven.",
            "No final playable output is claimed until runtime payload, metadata and file validation are captured.",
        ],
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), "validated": manifest["validated"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
