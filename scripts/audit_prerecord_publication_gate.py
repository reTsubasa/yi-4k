#!/usr/bin/env python3
"""Preserve a host media positive control and a +100 ms audio negative control.

All media is generated locally. No camera access or firmware execution occurs.
Output must be a new directory; rejected media and recovery evidence are kept.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from unittest.mock import patch

import prerecord_replay as replay_module
from validate_prerecord_packet_fidelity import validate


def audit(output: Path) -> dict:
    output = output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    source = output / "source.mp4"
    replay_module.run([
        "ffmpeg", "-v", "error", "-nostdin", "-n",
        "-f", "lavfi", "-i", "testsrc2=size=64x48:rate=25",
        "-f", "lavfi", "-i", "sine=frequency=997:sample_rate=48000",
        "-t", "10", "-c:v", "libx264", "-preset", "ultrafast", "-bf", "0",
        "-g", "25", "-c:a", "aac", "-b:a", "32k", str(source)])
    source_hash = replay_module.sha256(source)
    positive = output / "positive"
    replay_module.replay(source, positive, 5_000_000, 8_000_000)
    published = validate(positive / "manifest.json", Path(replay_module.FFPROBE))
    (positive / "published-packet-fidelity.json").write_text(json.dumps(published, indent=2) + "\n")

    negative = output / "audio-shift-negative"
    original_run = replay_module.run
    injection_commands = []

    def inject_audio_shift(args):
        result = original_run(args)
        pending = negative / "clip.pending.mp4"
        if args[0] == "ffmpeg" and Path(args[-1]).resolve() == pending:
            unshifted = negative / "clip.unshifted-negative-control.mp4"
            pending.rename(unshifted)
            command = ["ffmpeg", "-v", "error", "-nostdin", "-n", "-copyts",
                       "-advanced_editlist", "0", "-i", str(unshifted),
                       "-itsoffset", "0.1", "-advanced_editlist", "0", "-i", str(unshifted),
                       "-map", "0:v:0", "-map", "1:a:0", "-c", "copy",
                       "-avoid_negative_ts", "disabled", "-movie_timescale", "1000000", str(pending)]
            original_run(command)
            injection_commands.append(command)
        return result

    rejected = False
    with patch.object(replay_module, "run", side_effect=inject_audio_shift):
        try:
            replay_module.replay(source, negative, 5_000_000, 8_000_000)
        except ValueError as error:
            if "packet fidelity publication gate rejected" not in str(error):
                raise
            rejected = True
    manifest = json.loads((negative / "manifest.json").read_text())
    snapshot = json.loads((negative / "prepublish-manifest.json").read_text())
    gate = json.loads((negative / "prepublish-packet-fidelity.json").read_text())
    checks = {
        "positive_published_and_passed": published["passed"] and (positive / "clip.mp4").is_file(),
        "exactly_one_real_remux_injected": len(injection_commands) == 1,
        "negative_full_decode_passed": snapshot["clip"]["full_decode_passed"],
        "negative_gate_rejected": rejected and not gate["passed"],
        "negative_failed_manifest": manifest["state"] == "failed",
        "negative_never_published": not (negative / "clip.mp4").exists(),
        "negative_pending_retained": (negative / "clip.pending.mp4").is_file(),
        "negative_segments_retained": all((negative / "segments" / s["name"]).is_file() for s in snapshot["segments"]),
        "negative_snapshot_hash_matches": gate["manifest_sha256"] == replay_module.sha256(negative / "prepublish-manifest.json"),
        "negative_only_av_offset_failed": all(value == (name != "common_audio_video_timestamp_offset")
                                               for name, value in gate["checks"].items()),
        "source_unchanged": source_hash == replay_module.sha256(source),
    }
    result = {"scope": "local host-generated media; no camera contact", "checks": checks,
              "passed": all(checks.values()), "injection_commands": injection_commands,
              "positive_clip_sha256": published["clip_sha256"],
              "negative_clip_sha256": gate["clip_sha256"],
              "negative_snapshot_sha256": gate["manifest_sha256"],
              "code_sha256": {name: replay_module.sha256(Path(__file__).parent / name) for name in
                              ("prerecord_replay.py", "validate_prerecord_packet_fidelity.py", Path(__file__).name)}}
    (output / "audit.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    result = audit(parser.parse_args().output)
    print(json.dumps(result, indent=2))
    raise SystemExit(0 if result["passed"] else 1)
