#!/usr/bin/env python3
"""Audit real archived EIS input eligibility and original-generator ABI views.

No new camera operation, firmware execution, optical-quality claim or deployment.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import subprocess
from collections import Counter
from pathlib import Path

from analyze_native_eis_trace import analyze
from analyze_eis_recording_window import analyze as phase_analyze
from eis_stock_mesh_layout import layouts_from_descriptor, unpack_active, repack_active_host

ROOT = Path(__file__).resolve().parents[1]
STOCK = ROOT / "artifacts/device/2026-11-10-eis-generator-scope"
CAPTURE = ROOT / "artifacts/device/2026-11-09-eis-recording"
PINNED_STOCK_REPORT = "c41fcfd21e83115e9bd463eeda08070182c08f70ec36edf2d3b07cb825a4c87a"
PINNED_LOG = "5529f3828fa987a5e3fefc0955b55a23a92fa3c1d2a7ed333fc386744136083c"
PINNED_VIDEO = "1dc7d72892e54dcacaf4c6b032e3ec017237a44dad66d24edb4ba305f98970ee"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def identity(path):
    data = path.read_bytes()
    try:
        name = str(path.relative_to(ROOT))
    except ValueError:
        name = str(path.resolve())
    return {"path": name, "bytes": len(data), "sha256": sha(data)}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def stock_views():
    report = json.loads((STOCK / "audit.json").read_text())
    require(sha((STOCK / "audit.json").read_bytes()) == PINNED_STOCK_REPORT, "stock report identity mismatch")
    results = []
    for case in report["original_generator_cases"]:
        name = case["input"]["name"]
        scratch = (STOCK / f"{name}.planes.bin").read_bytes()
        descriptor = (STOCK / f"{name}.descriptor.bin").read_bytes()
        require(sha(scratch) == case["scratch_plane_sha256"], f"{name}: scratch mismatch")
        require(descriptor.hex() == case["descriptor_hex"], f"{name}: descriptor mismatch")
        x, y = case["planes"]
        layouts = layouts_from_descriptor(descriptor, x_pitch=x["profile_pitch_elements"],
                                          y_pitch=y["profile_pitch_elements"])
        planes = unpack_active(scratch, layouts)
        require(repack_active_host(scratch, layouts, planes) == scratch, f"{name}: round trip mismatch")
        summaries = []
        for layout, plane, expected in zip(layouts, planes, case["planes"]):
            raw = b"".join(struct.pack("<h", value) for value in plane)
            require(sha(raw) == expected["active_value_sha256"], f"{name}: active-value mismatch")
            require(min(plane) == expected["active_value_min"] and max(plane) == expected["active_value_max"],
                    f"{name}: active extrema mismatch")
            active_bytes = {off + byte for off in layout.offsets() for byte in (0, 1)}
            padding = bytes(scratch[i] for i in range(layout.scratch_offset, layout.scratch_offset + 0x1800)
                            if i not in active_bytes)
            if expected["active_rectangle_write_mask_verified"]:
                require(all(b == 0xA5 for b in padding), f"{name}: dirty padding mismatch")
            summaries.append({"columns": layout.columns, "rows": layout.rows,
                              "pitch_elements": layout.pitch_elements,
                              "active_values": len(plane), "active_value_sha256": sha(raw),
                              "min_signed16": min(plane), "max_signed16": max(plane),
                              "inactive_bytes": len(padding), "inactive_sha256": sha(padding)})
        results.append({"name": name, "input_geometry": case["input"]["geometry"],
                        "source_kind": "original_arm_output_with_synthetic_input",
                        "round_trip_identical_including_padding": True, "planes": summaries,
                        "source_files": [identity(STOCK / f"{name}.planes.bin"),
                                         identity(STOCK / f"{name}.descriptor.bin")]})
    require(len(results) == 9, "expected nine retained profiles")
    ordinary = next(c for c in results if c["name"] == "constant-1920x1080")
    wide = next(c for c in results if c["name"] == "constant-3840x2160")
    require([p["pitch_elements"] for p in ordinary["planes"]] == [32, 32], "1080 pitch mismatch")
    require([p["pitch_elements"] for p in wide["planes"]] == [31, 31], "wide pitch mismatch")
    require([p["rows"] for p in ordinary["planes"]] == [35, 36], "distinct X/Y row count mismatch")
    return {"report": identity(STOCK / "audit.json"), "cases": results,
            "case_count": len(results), "plane_count": 2 * len(results),
            "stock_physical_units_known": False, "normalized_candidate_convertible": False}


def real_input_eligibility(ffprobe, ffmpeg):
    log = CAPTURE / "native-log-02/RtosActive.log"
    parsed = analyze(log)
    require(parsed["sha256"] == PINNED_LOG, "real log identity mismatch")
    saved = json.loads((CAPTURE / "native-log-02/gyro-events.json").read_text())
    require(parsed["events"] == saved["events"], "real event reparse mismatch")
    phases = phase_analyze(log)["phases"]
    phase = phases[1]
    events = [e for e in parsed["events"] if phase["first_source_line"] <= e["line"] <= phase["last_source_line"]]
    gyros = [e for e in events if e["kind"] == "gyro"]
    exposures = [e for e in events if e["kind"] == "exposure"]
    feedback = [e for e in events if e["kind"] == "frame_update"]
    require((len(gyros), len(exposures), len(feedback)) == (48, 67, 66), "recording phase count mismatch")
    deltas = Counter(b["log_tick"] - a["log_tick"] for a, b in zip(gyros, gyros[1:]))
    require(deltas == Counter({50: 47}), "gyro log cadence changed")
    video = CAPTURE / "video/YDXJ0139.MP4"
    require(sha(video.read_bytes()) == PINNED_VIDEO, "real video identity mismatch")
    probe_command = [str(ffprobe.resolve()), "-v", "error", "-select_streams", "v:0", "-count_frames",
                     "-show_entries", "stream=width,height,nb_read_frames,r_frame_rate,time_base", "-of", "json", str(video)]
    probe = json.loads(subprocess.run(probe_command, capture_output=True, text=True, check=True, timeout=60).stdout)
    require(int(probe["streams"][0]["nb_read_frames"]) == 48, "video frame count mismatch")
    decode_command = [str(ffmpeg.resolve()), "-v", "error", "-nostdin", "-i", str(video),
                      "-map", "0:v:0", "-f", "null", "-"]
    decode = subprocess.run(decode_command, capture_output=True, text=True, check=True, timeout=60)
    require(not decode.stderr.strip(), "video decode emitted errors")
    blockers = [
        "Gyro values are level-shifted raw counts; calibrated axis mapping, bias and dps scale are unavailable at the captured sample boundary.",
        "50-ms modulo-decimated log ticks are not per-IMU-sample acquisition timestamps or a lossless sample stream.",
        "ExposureTime is a truncated printed raw integer; precise exposure start/center and readout association are unavailable.",
        "Feedback tags 0x105/0x106 repeat; no joint gyro/warp-generation/encoded-PTS identity was captured.",
        "Warp outputs in the separate ABI fixtures were generated offline from synthetic inputs; they are not tables captured from this recording.",
    ]
    return {"kind": "retained_real_camera_recording_and_logs", "new_camera_access": False,
            "sources": [identity(log), identity(video), identity(CAPTURE / "native-log-02/gyro-events.json")],
            "recording_phase_counts": dict(Counter(e["kind"] for e in events)),
            "gyro_tick_delta_histogram": dict(deltas), "log_tick_design_unit": "milliseconds; not hardware sample timestamps",
            "gyro_axis_raw_ranges": [[min(e[f"axis_{i}_raw"] for e in gyros), max(e[f"axis_{i}_raw"] for e in gyros)] for i in range(3)],
            "exposure_printed_values": sorted({e["exposure_time_raw"] for e in exposures}),
            "feedback_tags": sorted({hex(e["arm_sys_time_raw"]) for e in feedback}),
            "video_probe": probe, "video_decode_passed_now": True,
            "probe_command": probe_command, "decode_command": decode_command,
            "ffprobe": identity(ffprobe), "ffmpeg": identity(ffmpeg),
            "candidate_replay_eligible": False, "optical_quality_comparison_eligible": False,
            "candidate_trajectory_generated_from_real_log": False, "blockers": blockers}


def run(ffprobe, ffmpeg):
    return {"schema": "yi4k.eis-candidate-archive-audit/v1",
            "status": "passed_archive_layout_and_real_input_eligibility_checks",
            "stock_layout": stock_views(), "real_input": real_input_eligibility(ffprobe, ffmpeg),
            "device_access": False, "target_write": False,
            "replacement_deployment_ready": False,
            "source_files": [identity(Path(__file__)), identity(ROOT / "scripts/eis_stock_mesh_layout.py")],
            "limitations": ["Original-generator outputs establish a bounded storage layout, not physical Q or optical displacement direction.",
                            "Archived camera video is re-decoded; no candidate warp is applied or compared for image quality.",
                            "No RTOS first entry, timing, cache, DSP latch or rollback evidence is added."]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--ffprobe", type=Path, default=ROOT / ".tools/ffmpeg-host/ffprobe")
    parser.add_argument("--ffmpeg", type=Path, default=ROOT / ".tools/ffmpeg-host/ffmpeg")
    args = parser.parse_args()
    report = run(args.ffprobe, args.ffmpeg)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"status": report["status"], "stock_cases": report["stock_layout"]["case_count"],
                      "real_candidate_replay_eligible": False, "device_access": False}))


if __name__ == "__main__":
    main()
