"""Behavior and real media integrity checks for the host prerecord prototype."""
import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prerecord_buffer import PreRecordBuffer, Segment, State
import prerecord_replay as replay_module
from prerecord_replay import FFMPEG, FFPROBE, replay, run, sha256
from validate_prerecord_packet_fidelity import validate as validate_packet_fidelity

SECOND = 1_000_000


def segment(index):
    return Segment(f"part-{index:06d}.mp4", index * 2 * SECOND, (index + 1) * 2 * SECOND, True)


class BufferTests(unittest.TestCase):
    def test_window_ladder_covers_five_fifteen_and_sixty_seconds(self):
        """The state machine keeps the requested GOP history at each rollout size."""
        for window_seconds in (5, 15, 60):
            window_us = window_seconds * SECOND
            trigger_us = window_us * 2
            stop_us = trigger_us + 3 * SECOND
            buffer = PreRecordBuffer(window_us)
            for index in range((stop_us // (2 * SECOND)) + 2):
                start_us = index * 2 * SECOND
                end_us = start_us + 2 * SECOND
                segment_item = segment(index)
                segment_item = Segment(segment_item.name, start_us, end_us, True)
                if buffer.trigger_us is None and end_us > trigger_us:
                    accepted, _ = buffer.start(trigger_us)
                    self.assertTrue(accepted)
                if buffer.stop_us is None and buffer.state == State.RECORDING and end_us >= stop_us:
                    self.assertTrue(buffer.stop(stop_us))
                buffer.ingest(segment_item)
                if buffer.state == State.FINALIZING:
                    break
            buffer.complete()
            summary = buffer.summary()
            self.assertEqual(window_us, summary["window_us"])
            self.assertTrue(summary["full_window_available"], window_seconds)
            self.assertGreaterEqual(summary["available_pretrigger_us"], window_us)
            self.assertTrue(all(item["starts_with_keyframe"] for item in summary["segments"]))
            self.assertEqual(SECOND, summary["stop_overshoot_us"])

    def test_one_minute_window_pins_history_and_duplicate_start_never_stops(self):
        buffer = PreRecordBuffer()
        evicted = []
        for index in range(32):
            evicted.extend(buffer.ingest(segment(index)))
        accepted, removed = buffer.start(65 * SECOND)
        evicted.extend(removed)
        self.assertTrue(accepted)
        self.assertFalse(buffer.start(65 * SECOND)[0])
        self.assertEqual([item.name for item in evicted], [segment(i).name for i in range(2)])
        for index in range(32, 35):
            self.assertEqual([], buffer.ingest(segment(index)))
        self.assertTrue(buffer.stop(71 * SECOND))
        self.assertFalse(buffer.stop(71 * SECOND))
        self.assertEqual(State.STOPPING, buffer.state)
        buffer.ingest(segment(35))
        buffer.complete()
        self.assertEqual(State.COMPLETE, buffer.state)
        self.assertEqual(61 * SECOND, buffer.summary()["available_pretrigger_us"])
        self.assertEqual(SECOND, buffer.summary()["stop_overshoot_us"])
        self.assertFalse(buffer.start(73 * SECOND)[0])

    def test_early_trigger_reports_partial_window(self):
        buffer = PreRecordBuffer()
        buffer.start(SECOND)
        buffer.stop(SECOND + SECOND // 2)
        buffer.ingest(segment(0))
        buffer.complete()
        self.assertFalse(buffer.summary()["full_window_available"])
        self.assertEqual(SECOND, buffer.summary()["available_pretrigger_us"])

    def test_missing_start_coverage_is_rejected(self):
        buffer = PreRecordBuffer()
        buffer.start(65 * SECOND)
        buffer.stop(71 * SECOND)
        with self.assertRaises(ValueError):
            buffer.ingest(segment(35))
        self.assertEqual([], buffer.segments)

    def test_gaps_nonkeyframes_and_retrospective_events_fail_without_publishing(self):
        buffer = PreRecordBuffer()
        buffer.ingest(segment(0))
        for bad in (segment(2), Segment("bad", 2 * SECOND, 4 * SECOND, False)):
            with self.assertRaises(ValueError):
                buffer.ingest(bad)
        with self.assertRaises(ValueError):
            buffer.start(SECOND)
        with self.assertRaises(ValueError):
            buffer.stop(3 * SECOND)
        self.assertEqual([segment(0)], buffer.segments)
        buffer.start(2 * SECOND)
        buffer.stop(3 * SECOND)
        with self.assertRaises(ValueError):
            buffer.complete()
        buffer.ingest(segment(1))
        buffer.complete()
        with self.assertRaises(ValueError):
            buffer.ingest(segment(2))

    def test_segment_identity_cannot_escape_owning_spool(self):
        buffer = PreRecordBuffer()
        for name in ("../outside.mp4", "nested/part.mp4", "nested\\part.mp4", ".", "..", ""):
            with self.subTest(name=name), self.assertRaises(ValueError):
                buffer.ingest(Segment(name, 0, 2 * SECOND, True))
        self.assertEqual([], buffer.segments)


def packets(path, kind):
    process = subprocess.run([
        FFPROBE, "-v", "error", "-select_streams", kind, "-show_packets",
        "-show_entries", "packet=pts_time,dts_time,data_hash", "-show_data_hash", "sha256",
        "-of", "json", str(path)], text=True, capture_output=True, check=True)
    return json.loads(process.stdout)["packets"]


@unittest.skipUnless(shutil.which(FFMPEG) and shutil.which(FFPROBE), "host FFmpeg is required")
class MediaIntegrationTests(unittest.TestCase):
    def test_no_b_frames_preserve_zero_origin_aac_priming(self):
        """Keep the negative-PTS priming packet and shared timeline unchanged."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.mp4"
            run(["ffmpeg", "-v", "error", "-nostdin", "-n",
                 "-f", "lavfi", "-i", "testsrc2=size=64x48:rate=25",
                 "-f", "lavfi", "-i", "sine=frequency=997:sample_rate=48000",
                 "-t", "14", "-c:v", "libx264", "-preset", "ultrafast",
                 "-bf", "0", "-g", "25", "-c:a", "aac", "-b:a", "32k", str(source)])
            original_audio = packets(source, "a:0")
            self.assertLess(float(original_audio[0]["pts_time"]), 0)
            output = root / "zero"
            evidence = replay(source, output, 5 * SECOND, 8 * SECOND)
            self.assertTrue(evidence["publication_gate"]["passed"])
            self.assertEqual(0, evidence["selected_start_us"])
            checked = validate_packet_fidelity(output / "manifest.json", Path(FFPROBE))
            self.assertTrue(checked["passed"], checked)
            self.assertEqual(checked["tracks"]["audio"]["selected_segment_packet_count"],
                             checked["tracks"]["audio"]["clip_packet_count"])
            self.assertEqual(original_audio[0]["data_hash"], packets(output / "clip.mp4", "a:0")[0]["data_hash"])

    def test_video_only_replay_passes_publication_gate(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.mp4"
            run(["ffmpeg", "-v", "error", "-nostdin", "-n",
                 "-f", "lavfi", "-i", "testsrc2=size=64x48:rate=25",
                 "-t", "10", "-c:v", "libx264", "-preset", "ultrafast",
                 "-g", "25", "-an", str(source)])
            output = root / "replay"
            evidence = replay(source, output, 5 * SECOND, 8 * SECOND)
            self.assertTrue(evidence["publication_gate"]["passed"])
            gate = json.loads((output / "prepublish-packet-fidelity.json").read_text())
            self.assertEqual(["video"], gate["track_types"])
            self.assertFalse(gate["common_audio_video_offset_applicable"])
            self.assertTrue(gate["passed"])
            self.assertTrue(validate_packet_fidelity(output / "manifest.json", Path(FFPROBE))["passed"])

    def test_decodable_audio_shift_is_rejected_before_publication(self):
        """Real remux corruption keeps packets/decode but changes the A/V offset."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.mp4"
            run(["ffmpeg", "-v", "error", "-nostdin", "-n",
                 "-f", "lavfi", "-i", "testsrc2=size=64x48:rate=25",
                 "-f", "lavfi", "-i", "sine=frequency=997:sample_rate=48000",
                 "-t", "10", "-c:v", "libx264", "-preset", "ultrafast",
                 "-bf", "0", "-g", "25", "-c:a", "aac", "-b:a", "32k", str(source)])
            output = root / "failed-replay"
            original_run = replay_module.run
            changed = []

            def shift_remuxed_audio(args):
                result = original_run(args)
                if args[0] == "ffmpeg" and Path(args[-1]).resolve() == (output / "clip.pending.mp4").resolve():
                    pending = output / "clip.pending.mp4"
                    unshifted = output / "clip.unshifted-test-control.mp4"
                    pending.rename(unshifted)
                    original_run(["ffmpeg", "-v", "error", "-nostdin", "-n", "-copyts",
                                  "-advanced_editlist", "0", "-i", str(unshifted),
                                  "-itsoffset", "0.1", "-advanced_editlist", "0", "-i", str(unshifted),
                                  "-map", "0:v:0", "-map", "1:a:0", "-c", "copy",
                                  "-avoid_negative_ts", "disabled", "-movie_timescale", "1000000",
                                  str(pending)])
                    changed.append(True)
                return result

            with patch.object(replay_module, "run", side_effect=shift_remuxed_audio):
                with self.assertRaisesRegex(ValueError, "packet fidelity publication gate rejected"):
                    replay(source, output, 5 * SECOND, 8 * SECOND)
            self.assertEqual([True], changed)
            manifest = json.loads((output / "manifest.json").read_text())
            snapshot = json.loads((output / "prepublish-manifest.json").read_text())
            gate = json.loads((output / "prepublish-packet-fidelity.json").read_text())
            self.assertEqual("failed", manifest["state"])
            self.assertEqual("validating", snapshot["state"])
            self.assertTrue(snapshot["clip"]["full_decode_passed"])
            self.assertEqual(gate["manifest_sha256"], sha256(output / "prepublish-manifest.json"))
            self.assertFalse(gate["passed"])
            self.assertFalse(gate["checks"]["common_audio_video_timestamp_offset"])
            self.assertTrue(gate["checks"]["pts_dts_durations_preserved"])
            self.assertTrue(gate["checks"]["selected_segment_packet_order_preserved"])
            self.assertFalse((output / "clip.mp4").exists())
            self.assertTrue((output / "clip.pending.mp4").is_file())
            self.assertTrue(all((output / "segments" / row["name"]).is_file() for row in snapshot["segments"]))
            self.assertEqual(manifest["source_sha256"], sha256(source))

    def test_decode_failure_keeps_recovery_manifest_and_never_publishes_clip(self):
        """A failed final decode leaves owned segments for inspection/recovery."""
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.mp4"
            run([
                "ffmpeg", "-v", "error", "-nostdin", "-n",
                "-f", "lavfi", "-i", "testsrc2=size=64x48:rate=25",
                "-f", "lavfi", "-i", "sine=frequency=997:sample_rate=48000",
                "-t", "10", "-c:v", "libx264", "-preset", "ultrafast", "-g", "25",
                "-keyint_min", "25", "-sc_threshold", "0", "-c:a", "aac", "-b:a", "32k",
                str(source)])
            output = root / "failed-replay"
            original_run = replay_module.run

            def fail_final_decode(args):
                if any(str(item).endswith("clip.pending.mp4") for item in args) and args[-1] == "-":
                    raise RuntimeError("injected final decode failure")
                return original_run(args)

            with patch.object(replay_module, "run", side_effect=fail_final_decode):
                with self.assertRaisesRegex(RuntimeError, "injected final decode failure"):
                    replay(source, output, 5 * SECOND, 8 * SECOND)
            manifest = json.loads((output / "manifest.json").read_text())
            self.assertEqual("failed", manifest["state"])
            self.assertIn("injected final decode failure", manifest["error"])
            self.assertFalse((output / "clip.mp4").exists())
            self.assertTrue((output / "clip.pending.mp4").exists())
            self.assertTrue(any((output / "segments" / item["name"]).exists()
                                for item in manifest["buffer"]["segments"]))
            self.assertEqual(manifest["source_sha256"], sha256(source))

    def test_aac_overhang_does_not_accumulate_at_nonzero_selection_start(self):
        """64-frame GOP cuts do not align with 1024-sample AAC packets.

        The old reset/concat path decodes but drifts at every boundary. A
        nonzero selected start also catches accidental per-track rebasing.
        """
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.mp4"
            run(["ffmpeg", "-v", "error", "-nostdin", "-n",
                 "-f", "lavfi", "-i", "testsrc2=size=96x64:rate=30000/1001",
                 "-f", "lavfi", "-i", "sine=frequency=997:sample_rate=48000",
                 "-t", "14", "-c:v", "libx264", "-preset", "ultrafast",
                 "-bf", "2", "-g", "64", "-keyint_min", "64", "-sc_threshold", "0",
                 "-c:a", "aac", "-b:a", "64k", str(source)])
            output = root / "replay"
            evidence = replay(source, output, 9 * SECOND, 12 * SECOND, 5 * SECOND)
            self.assertTrue(evidence["publication_gate"]["passed"])
            self.assertGreater(evidence["selected_start_us"], 0)
            self.assertGreaterEqual(len(evidence["segments"]), 4)
            checked = validate_packet_fidelity(output / "manifest.json", Path(FFPROBE))
            self.assertTrue(checked["passed"], checked)

    def test_sixty_second_clip_preserves_source_packets_and_audio_video_timeline(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.mp4"
            run([
                "ffmpeg", "-v", "error", "-nostdin", "-n",
                "-f", "lavfi", "-i", "testsrc2=size=96x64:rate=30000/1001",
                "-f", "lavfi", "-i", "sine=frequency=997:sample_rate=48000",
                "-t", "74", "-c:v", "libx264", "-preset", "ultrafast", "-bf", "2", "-g", "60",
                "-keyint_min", "60", "-sc_threshold", "0", "-c:a", "aac", "-b:a", "64k",
                str(source)])
            output = root / "replay"
            evidence = replay(source, output, 65 * SECOND, 71 * SECOND)
            self.assertTrue(evidence["full_window_available"])
            self.assertTrue(evidence["clip"]["full_decode_passed"])
            self.assertEqual("complete", evidence["state"])
            self.assertGreaterEqual(evidence["available_pretrigger_us"], 60 * SECOND)
            self.assertLess(evidence["available_pretrigger_us"], 63 * SECOND)
            clip = output / "clip.mp4"
            offsets = []
            for kind in ("v:0", "a:0"):
                original_packets = packets(source, kind)
                original = [entry["data_hash"] for entry in original_packets]
                result = packets(clip, kind)
                actual = [entry["data_hash"] for entry in result]
                selected = [entry["data_hash"] for item in evidence["segments"]
                            for entry in packets(output / "segments" / item["name"], kind)]
                self.assertEqual(selected, actual, "remux must preserve every selected encoded packet")
                first = original.index(actual[0])
                self.assertEqual(original[first:first + len(actual)], actual,
                                 "selected video/audio must be contiguous in the original source")
                offset = float(original_packets[first]["dts_time"]) - float(result[0]["dts_time"])
                offsets.append(offset)
                for original_packet, output_packet in zip(original_packets[first:first + len(actual)], result):
                    for key in ("dts_time", "pts_time"):
                        self.assertAlmostEqual(float(original_packet[key]) - offset, float(output_packet[key]),
                                               delta=0.002, msg="no per-segment timestamp drift or gap allowed")
                dts = [float(entry["dts_time"]) for entry in result]
                self.assertTrue(all(after > before for before, after in zip(dts, dts[1:])))
            self.assertAlmostEqual(offsets[0], offsets[1], delta=0.002, msg="audio/video need the same time offset")
            streams = evidence["clip"]["probe"]["streams"]
            self.assertLess(abs(float(streams[0]["duration"]) - float(streams[1]["duration"])), 0.15)
            with self.assertRaises(FileExistsError):
                replay(source, output, 65 * SECOND, 71 * SECOND)
            self.assertEqual(evidence["source_sha256"], sha256(source))
            # STOP exactly at a delivered segment boundary must not ingest the following segment.
            boundary = evidence["segments"][-2]["end_us"]
            aligned = replay(source, root / "boundary", 65 * SECOND, boundary)
            self.assertEqual(0, aligned["stop_overshoot_us"])
            self.assertEqual("complete", aligned["state"])


if __name__ == "__main__":
    unittest.main()
