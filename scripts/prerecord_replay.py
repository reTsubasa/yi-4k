#!/usr/bin/env python3
"""Replay a local MP4 through the 60-second prerecord model and remux a clip.

Uses host FFmpeg/ffprobe, without decoding/re-encoding during segmentation or
remux. Output must be a NEW directory. Never connects to or modifies a camera.
This validates file-level semantics; it is not an RTOS encoder/FIFO adapter.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import subprocess
import signal
from contextlib import contextmanager
from decimal import Decimal
from pathlib import Path

from prerecord_buffer import PreRecordBuffer, Segment, State
from validate_prerecord_packet_fidelity import validate as validate_packet_fidelity
from prerecord_media_store import ClosedMediaStore
from prerecord_trigger import CameraEvent, CameraEventType, PreRecordTriggerRouter


def _tool_default(name: str) -> str:
    """Prefer the repository-pinned host tool when it is available.

    The replay is intended to be reproducible across developer machines. A
    system FFmpeg can still be selected through the environment, while the
    bundled binary avoids unrelated Homebrew codec-library failures.
    """
    bundled = Path(__file__).resolve().parents[1] / ".tools" / "ffmpeg-host" / name
    return str(bundled) if bundled.is_file() else name


FFMPEG = os.environ.get("YI4K_FFMPEG", _tool_default("ffmpeg"))
FFPROBE = os.environ.get("YI4K_FFPROBE", _tool_default("ffprobe"))


def run(args: list[str]) -> str:
    args = [{"ffmpeg": FFMPEG, "ffprobe": FFPROBE}.get(args[0], args[0]), *args[1:]]
    process = subprocess.run(args, text=True, capture_output=True, check=False)
    if process.returncode:
        raise RuntimeError(f"{args[0]} failed: {process.stderr[-4000:]}")
    return process.stdout


def probe(path: Path) -> dict:
    return json.loads(run(["ffprobe", "-v", "error", "-show_streams", "-show_format", "-of", "json", str(path)]))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def microseconds(value: str) -> int:
    number = Decimal(value)
    if not number.is_finite():
        raise ValueError("time must be finite")
    return int(number * 1_000_000)


@contextmanager
def delivered_segments(arguments: list[str], output: Path, incremental: bool):
    """Yield only segment-list notifications emitted AFTER the mux closes a file.

    Paced local-file replay avoids preparing the entire source first. STOP the
    producer while custody/probe work runs, so it cannot grow arbitrarily ahead
    of a slow consumer. This is POSIX process scheduling, not RTOS flow control.
    """
    if not incremental:
        run(arguments)
        yield iter(csv.reader((output / 'segments/timeline.csv').read_text().splitlines()))
        return
    arguments = arguments.copy()
    arguments[arguments.index('-segment_list') + 1] = 'pipe:1'
    arguments[1:1] = ['-re']
    stderr = output / 'segment-producer.stderr'
    with stderr.open('w') as errors:
        producer = subprocess.Popen([FFMPEG, *arguments[1:]], stdout=subprocess.PIPE,
                                    stderr=errors, text=True, bufsize=1)
        paused = False
        def rows():
            nonlocal paused
            with (output / 'segments/timeline.csv').open('x') as timeline:
                assert producer.stdout is not None
                for line in producer.stdout:
                    if producer.poll() is None:
                        os.kill(producer.pid, signal.SIGSTOP); paused = True
                    timeline.write(line); timeline.flush()
                    try:
                        row = next(csv.reader([line]))
                        if len(row) != 3:
                            raise ValueError('invalid closed segment notification')
                        yield row
                    finally:
                        if paused and producer.poll() is None:
                            os.kill(producer.pid, signal.SIGCONT)
                        paused = False
                if producer.wait() != 0:
                    raise RuntimeError('incremental segment producer failed: ' + stderr.read_text()[-4000:])
        try:
            yield rows()
        finally:
            if producer.poll() is None:
                # Stop at the selected closed boundary; the unselected final
                # producer file remains recovery material, without a receipt.
                producer.terminate()
                if paused:
                    os.kill(producer.pid, signal.SIGCONT)
                try:
                    producer.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    producer.kill(); producer.wait(timeout=10)
            if producer.stdout is not None:
                producer.stdout.close()


def replay(source: Path, output: Path, trigger_us: int, stop_us: int,
           window_us: int = 60_000_000, segment_seconds: str = "2", *,
           incremental: bool = False, budget_bytes: int = 512 * 1024 * 1024,
           trigger_source: str | None = None, before_publish=None) -> dict:
    source = source.resolve(strict=True)
    output = output.resolve()
    if trigger_us < 0 or stop_us <= trigger_us or microseconds(segment_seconds) <= 0:
        raise ValueError("require 0 <= START < STOP and a positive segment duration")
    info = probe(source)
    videos = [stream for stream in info["streams"] if stream["codec_type"] == "video"]
    if len(videos) != 1 or videos[0]["codec_name"] != "h264":
        raise ValueError("prototype accepts exactly one H.264 video track")
    if stop_us >= microseconds(info["format"]["duration"]):
        raise ValueError("STOP must precede source end to close its final segment")
    buffer = PreRecordBuffer(window_us)
    output.mkdir(parents=True, exist_ok=False)
    spool = output / "segments"
    spool.mkdir()
    store = ClosedMediaStore(spool, budget_bytes) if incremental else None
    router = PreRecordTriggerRouter() if trigger_source else None
    if trigger_source not in (None, 'voice', 'shutter'):
        raise ValueError('unknown typed trigger source')
    manifest_path = output / "manifest.json"
    evidence = {
        "scope": "host-only local MP4 replay; no camera FIFO, voice recognition or firmware execution",
        "source": str(source), "source_sha256": sha256(source),
        "window_seconds": window_us / 1_000_000,
        "source_probe": info, "state": "preparing", "events": [], "evicted": [],
        "limitations": [
            "Segmentation runs before replay, so host peak disk usage includes the whole input.",
            "START is injected as a typed host event; camera firmware voice recognition and event transport remain unimplemented.",
            "STOP closes at the next segment boundary; reported overshoot is retained.",
            "MP4 segments carry their own codec configuration; this does not establish the camera FIFO ABI.",
            "Failed outputs retain segments and manifest for recovery; no automatic retry or camera deployment.",
        ],
        "ffmpeg_version": run(["ffmpeg", "-version"]).splitlines()[0],
        "timestamp_strategy": {
            "segment_reset_timestamps": False,
            "segment_movie_timescale": 1_000_000,
            "concat": "source timestamps; inpoint 0 and duration 0 prevent per-file offset accumulation",
            "output_offset_us": None,
            "concat_mp4_advanced_editlist": False,
        },
        "incremental_delivery": incremental,
    }
    if incremental:
        evidence['limitations'][0] = ('Paced local-file segment producer is paused at closed-segment delivery. '
            'Capacity is observed at checkpoints; not a physical SD quota, producer throughput or RTOS proof.')

    def checkpoint() -> None:
        if store:
            evidence['media_store'] = store.summary()
        # Atomic host manifest update; source and pre-existing outputs are untouched.
        temporary = output / "manifest.tmp"
        temporary.write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n")
        temporary.replace(manifest_path)

    def evict(entries: list[Segment]) -> None:
        for entry in entries:
            path = spool / entry.name
            evidence["evicted"].append({**vars(entry), "bytes": path.stat().st_size})
            if store:
                store.evict(entry.name)
            else:
                path.unlink()  # Only segments generated inside this new output directory.

    checkpoint()
    try:
        segment_list = spool / "timeline.csv"
        segmentation = ["ffmpeg", "-v", "error", "-nostdin", "-n", "-i", str(source),
             "-map", "0:v:0", "-map", "0:a:0?", "-c", "copy",
             "-f", "segment", "-segment_time", segment_seconds,
             "-segment_list", str(segment_list), "-segment_list_type", "csv",
             "-reset_timestamps", "0", "-avoid_negative_ts", "disabled",
             "-segment_format_options", "movie_timescale=1000000:avoid_negative_ts=disabled",
             str(spool / "part-%06d.mp4")]
        with delivered_segments(segmentation, output, incremental) as rows:
            first_us = None
            for name, start, end in rows:
              if first_us is None:
                  first_us = microseconds(start)
              name = Path(name).name
              if not name.startswith("part-") or not name.endswith(".mp4"):
                  raise ValueError("unexpected generated segment identity")
              start_us, end_us = microseconds(start) - first_us, microseconds(end) - first_us
              if buffer.trigger_us is None and trigger_us < end_us:
                  if router:
                      event = (router.on_camera_event(CameraEvent(CameraEventType.START_RECORDING, trigger_us))
                               if trigger_source == 'voice' else router.on_shutter(trigger_us))
                      if not event.accepted:
                          raise ValueError('typed trigger rejected')
                      other = (router.on_shutter(trigger_us) if trigger_source == 'voice'
                               else router.on_camera_event(CameraEvent(CameraEventType.START_RECORDING, trigger_us)))
                      evidence['typed_trigger'] = dict(source=event.source.value, decision=event.decision.value,
                                                      alternate_source_duplicate=other.decision.value)
                  accepted, removed = buffer.start(trigger_us)
                  evict(removed)
                  if store:
                      store.pin_all()
                  evidence["events"].append({"event": "START", "at_us": trigger_us, "accepted": accepted})
                  duplicate, _ = buffer.start(trigger_us)
                  evidence["events"].append({"event": "duplicate_START", "accepted": duplicate})
              if buffer.trigger_us is not None and buffer.stop_us is None and stop_us <= end_us:
                  buffer.stop(stop_us)
                  evidence["events"].append({"event": "STOP", "at_us": stop_us})
                  if buffer.state == State.FINALIZING:
                      break
              # FFmpeg packet flags supply a bounded check of the first video packet.
              packet = json.loads(run(["ffprobe", "-v", "error", "-select_streams", "v:0",
                                       "-read_intervals", "%+#1", "-show_packets", "-show_entries",
                                       "packet=flags", "-of", "json", str(spool / name)]))
              keyframe = "K" in packet["packets"][0]["flags"]
              if store:
                  store.accept(name, pin=buffer.trigger_us is not None)
              evict(buffer.ingest(Segment(name, start_us, end_us, keyframe)))
              if store:
                  checkpoint()
              if buffer.state == State.FINALIZING:
                  break
        if buffer.state != State.FINALIZING:
            raise ValueError("source did not deliver a complete segment covering STOP")
        evidence.update(buffer.summary())
        evidence["state"] = "remuxing"
        for segment in evidence["segments"]:
            path = spool / segment["name"]
            segment.update({"bytes": path.stat().st_size, "sha256": sha256(path)})
            # A keyframe flag alone does not establish a closed/independent GOP.
            run(["ffmpeg", "-v", "error", "-xerror", "-err_detect", "explode", "-nostdin",
                 "-i", str(path), "-map", "0:v:0", "-f", "null", "-"])
            segment["independent_video_decode_passed"] = True
        checkpoint()
        concat_list = output / "selected.ffconcat"
        # Segments keep a shared source timeline. The concat demuxer's default
        # rebasing adds each container's max(A/V duration), accumulating AAC
        # overhang at every cut. Explicit inpoint=0 avoids subtracting each
        # file's inferred start; duration=0 makes its cumulative offset zero.
        # MOV advanced edit-list processing marks negative-PTS AAC priming
        # packets DISCARD, so streamcopy silently omits them. Disabling only
        # advanced processing retains the edit-list timestamp offset and skip
        # samples, unlike ignore_editlist=1 which destroys the shared timeline.
        # These overrides retain all selected packets, with no outpoint,
        # trimming, replacement source input or per-track timestamp changes.
        concat_list.write_text("ffconcat version 1.0\n" + "".join(
            f"file segments/{segment.name}\ninpoint 0\nduration 0\noption advanced_editlist 0\n"
            for segment in buffer.segments))
        # Normalize once for the entire selection, never independently per
        # track or segment. Segment CSV time selects the window; packet times
        # remain untouched apart from this common constant shift.
        # Keep the source phase within its first whole second. In the retained
        # camera file, subtracting a fractional segment origin makes MOV's edit
        # list clip the final AAC sample (102 vs 1024 ticks). A shared integral
        # second shift preserves the complete terminal sample and track delay;
        # the nonzero first PTS is reported, never hidden with per-track shifts.
        offset_us = -(buffer.segments[0].start_us // 1_000_000) * 1_000_000
        evidence["timestamp_strategy"]["output_offset_us"] = offset_us
        evidence['timestamp_strategy']['normalization'] = 'common whole-second shift; source phase retained'
        temporary_clip = output / "clip.pending.mp4"
        run(["ffmpeg", "-v", "error", "-nostdin", "-n", "-copyts",
             # File options require safe=0. The list is generated here from
             # validated owned segment names, and only file I/O is allowed.
             "-f", "concat", "-safe", "0", "-protocol_whitelist", "file", "-auto_convert", "0",
             "-itsoffset", str(Decimal(offset_us) / 1_000_000),
             "-i", str(concat_list), "-map", "0", "-c", "copy",
             "-avoid_negative_ts", "disabled", "-movie_timescale", "1000000",
             "-movflags", "+faststart", str(temporary_clip)])
        # Decode the whole clip before publishing a visible success artifact.
        run(["ffmpeg", "-v", "error", "-xerror", "-err_detect", "explode", "-nostdin", "-i", str(temporary_clip),
             "-map", "0:v:0", "-map", "0:a:0?", "-f", "null", "-"])
        clip_info = probe(temporary_clip)
        evidence["state"] = "validating"
        evidence["clip"] = {"path": temporary_clip.name, "sha256": sha256(temporary_clip),
                            "probe": clip_info, "full_decode_passed": True}
        checkpoint()
        # Preserve the exact input to the publication gate. It references the
        # pending media, never pretends that an unpublished replay is complete.
        snapshot = output / "prepublish-manifest.json"
        with snapshot.open("x") as file:
            json.dump(evidence, file, ensure_ascii=False, indent=2)
            file.write("\n")
        fidelity_path = output / "prepublish-packet-fidelity.json"
        evidence["publication_gate"] = {
            "snapshot": snapshot.name, "snapshot_sha256": sha256(snapshot),
            "packet_fidelity": fidelity_path.name, "passed": False,
        }
        try:
            fidelity = validate_packet_fidelity(snapshot, Path(FFPROBE), phase="prepublish")
        except Exception as error:
            # Parsing/probing/hash failures also fail closed and retain a
            # machine-readable rejection instead of losing the gate evidence.
            fidelity = {"phase": "prepublish", "manifest": str(snapshot),
                        "manifest_sha256": sha256(snapshot), "passed": False,
                        "error_type": type(error).__name__, "error": str(error)}
        with fidelity_path.open("x") as file:
            json.dump(fidelity, file, ensure_ascii=False, indent=2)
            file.write("\n")
        evidence["publication_gate"].update({"passed": fidelity["passed"],
                                            "packet_fidelity_sha256": sha256(fidelity_path)})
        checkpoint()
        if not fidelity["passed"]:
            raise ValueError("packet fidelity publication gate rejected pending clip")
        if sha256(temporary_clip) != fidelity["clip_sha256"]:
            raise ValueError("pending clip changed after packet fidelity validation")
        if before_publish:
            before_publish(output)
        buffer.complete()
        temporary_clip.rename(output / "clip.mp4")
        evidence["state"] = buffer.state.value
        evidence["clip"] = {"path": "clip.mp4", "sha256": sha256(output / "clip.mp4"),
                            "probe": clip_info, "full_decode_passed": True}
        checkpoint()
    except Exception as error:
        evidence.update({"state": "failed", "error": str(error), "buffer": buffer.summary()})
        checkpoint()
        raise
    return evidence


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--output", type=Path, required=True, help="new host directory")
    parser.add_argument("--trigger-seconds", required=True)
    parser.add_argument("--stop-seconds", required=True)
    parser.add_argument("--window-seconds", default="60")
    parser.add_argument("--segment-seconds", default="2")
    args = parser.parse_args()
    result = replay(args.source, args.output, microseconds(args.trigger_seconds),
                    microseconds(args.stop_seconds), microseconds(args.window_seconds), args.segment_seconds)
    print(json.dumps({key: result[key] for key in (
        "state", "full_window_available", "available_pretrigger_us", "stop_overshoot_us")}, indent=2))


if __name__ == "__main__":
    main()
