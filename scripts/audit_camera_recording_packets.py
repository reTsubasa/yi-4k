#!/usr/bin/env python3
"""Audit one saved camera MP4 at the H.264/AAC packet boundary.

The input is downloaded from a normal camera recording.  This script never
contacts the camera and never changes the file.  It reports container packet
timestamps, AVCDecoderConfigurationRecord parameter sets, length-prefixed
NAL types, AAC AudioSpecificConfig, and a full decode check.  Container
evidence still does not prove the RTOS FIFO descriptor or pre-record lifecycle.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
from fractions import Fraction
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
HEX_LINE = re.compile(r"^\s*[0-9a-f]+:\s+([0-9a-f ]+?)(?:\s{2,}.*)?$", re.I)


def decode_dump(value: str) -> bytes:
    result = bytearray()
    for line in value.splitlines():
        match = HEX_LINE.match(line)
        if match:
            result.extend(bytes.fromhex("".join(match.group(1).split())))
    return bytes(result)


def run(args: list[str], *, text: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(args, capture_output=True, text=text, check=True, timeout=120)


def parse_avc_config(data: bytes) -> dict[str, Any]:
    if len(data) < 7 or data[0] != 1:
        raise ValueError("missing AVCDecoderConfigurationRecord")
    length_size = (data[4] & 3) + 1
    offset = 5
    sps_count = data[offset] & 0x1F
    offset += 1
    sps: list[bytes] = []
    for _ in range(sps_count):
        if offset + 2 > len(data):
            raise ValueError("truncated AVC SPS length")
        length = int.from_bytes(data[offset:offset + 2], "big")
        offset += 2
        if offset + length > len(data):
            raise ValueError("truncated AVC SPS")
        sps.append(data[offset:offset + length])
        offset += length
    if offset >= len(data):
        raise ValueError("missing AVC PPS count")
    pps_count = data[offset]
    offset += 1
    pps: list[bytes] = []
    for _ in range(pps_count):
        if offset + 2 > len(data):
            raise ValueError("truncated AVC PPS length")
        length = int.from_bytes(data[offset:offset + 2], "big")
        offset += 2
        if offset + length > len(data):
            raise ValueError("truncated AVC PPS")
        pps.append(data[offset:offset + length])
        offset += length
    return {
        "configuration_version": data[0],
        "profile": data[1],
        "compatibility": data[2],
        "level": data[3],
        "nal_length_size": length_size,
        "sps_count": len(sps),
        "pps_count": len(pps),
        "sps_nal_types": [item[0] & 0x1F for item in sps if item],
        "pps_nal_types": [item[0] & 0x1F for item in pps if item],
        "extradata_sha256": hashlib.sha256(data).hexdigest(),
        "extradata_bytes": len(data),
    }


def parse_nals(data: bytes, length_size: int) -> list[int]:
    result: list[int] = []
    offset = 0
    while offset + length_size <= len(data):
        length = int.from_bytes(data[offset:offset + length_size], "big")
        offset += length_size
        if length <= 0:
            continue
        if offset + length > len(data):
            raise ValueError("truncated length-prefixed H.264 packet")
        result.append(data[offset] & 0x1F)
        offset += length
    if offset != len(data):
        raise ValueError("trailing H.264 packet bytes")
    return result


def packet_track(probe: dict[str, Any], stream: dict[str, Any], *, nal_length_size: int | None = None) -> dict[str, Any]:
    packets = [p for p in probe["packets"] if p.get("stream_index") == stream["index"]]
    pts = [int(p["pts"]) for p in packets if "pts" in p]
    dts = [int(p["dts"]) for p in packets if "dts" in p]
    durations = [int(p["duration"]) for p in packets if "duration" in p]
    time_base = Fraction(stream["time_base"])
    result: dict[str, Any] = {
        "index": stream["index"],
        "codec_type": stream.get("codec_type"),
        "codec_name": stream.get("codec_name"),
        "packet_count": len(packets),
        "first_pts": pts[0] if pts else None,
        "last_pts": pts[-1] if pts else None,
        "first_dts": dts[0] if dts else None,
        "last_dts": dts[-1] if dts else None,
        "first_pts_seconds": str(pts[0] * time_base) if pts else None,
        "end_pts_seconds": str((max(p + d for p, d in zip(pts, durations))) * time_base) if pts and durations else None,
        "pts_non_decreasing": all(b >= a for a, b in zip(pts, pts[1:])),
        "dts_strictly_increasing": all(b > a for a, b in zip(dts, dts[1:])),
        "duration_values": sorted(set(durations)),
        "time_base": stream.get("time_base"),
    }
    if nal_length_size is not None:
        nal_types: list[int] = []
        first_packet_nals: list[int] | None = None
        keyframe_packets = 0
        for packet in packets:
            nals = parse_nals(decode_dump(packet.get("data", "")), nal_length_size)
            nal_types.extend(nals)
            if first_packet_nals is None:
                first_packet_nals = nals
            if "K" in packet.get("flags", ""):
                keyframe_packets += 1
        result.update({
            "keyframe_packet_count": keyframe_packets,
            "first_packet_flags": packets[0].get("flags") if packets else None,
            "first_packet_nal_types": first_packet_nals or [],
            "payload_nal_type_counts": {str(n): nal_types.count(n) for n in sorted(set(nal_types))},
            "payload_parameter_set_nal_count": nal_types.count(7) + nal_types.count(8),
        })
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--ffprobe", type=Path, default=Path(os.environ.get("YI4K_FFPROBE", str(ROOT / ".tools/ffmpeg-host/ffprobe"))))
    parser.add_argument("--ffmpeg", type=Path, default=Path(os.environ.get("YI4K_FFMPEG", str(ROOT / ".tools/ffmpeg-host/ffmpeg"))))
    args = parser.parse_args()
    source = args.input.resolve(strict=True)
    if args.output.exists():
        raise RuntimeError("output already exists; preserve prior evidence")
    probe_command = [str(args.ffprobe.resolve()), "-v", "error", "-show_format", "-show_streams", "-show_packets", "-show_data", "-of", "json", str(source)]
    probe_process = run(probe_command)
    probe = json.loads(probe_process.stdout)
    videos = [s for s in probe["streams"] if s.get("codec_type") == "video"]
    audios = [s for s in probe["streams"] if s.get("codec_type") == "audio"]
    if len(videos) != 1 or len(audios) != 1 or videos[0].get("codec_name") != "h264" or audios[0].get("codec_name") != "aac":
        raise ValueError("expected one H.264 and one AAC stream")
    video = videos[0]
    audio = audios[0]
    avc = parse_avc_config(decode_dump(video.get("extradata", "")))
    aac_config = decode_dump(audio.get("extradata", ""))
    if len(aac_config) < 2:
        raise ValueError("missing AAC AudioSpecificConfig")
    audio_object_type = (aac_config[0] >> 3) & 0x1F
    audio_frequency_index = ((aac_config[0] & 7) << 1) | (aac_config[1] >> 7)
    audio_channel_config = (aac_config[1] >> 3) & 0x0F
    video_track = packet_track(probe, video, nal_length_size=avc["nal_length_size"])
    audio_track = packet_track(probe, audio)
    decode_command = [str(args.ffmpeg.resolve()), "-v", "error", "-xerror", "-err_detect", "explode", "-i", str(source), "-f", "null", "-"]
    decode = run(decode_command)
    source_hash = hashlib.sha256(source.read_bytes()).hexdigest()
    output = {
        "evidence_type": "read-only packet audit of one normal camera recording",
        "scope": "downloaded MP4 container; no camera access during audit; not a FIFO/prerecord proof",
        "input": str(source),
        "input_sha256": source_hash,
        "input_bytes": source.stat().st_size,
        "ffprobe_command": probe_command,
        "ffmpeg_decode_command": decode_command,
        "streams": {"video": video_track, "audio": audio_track},
        "avc_decoder_configuration": avc,
        "aac_audio_specific_config": {
            "bytes": len(aac_config),
            "sha256": hashlib.sha256(aac_config).hexdigest(),
            "audio_object_type": audio_object_type,
            "frequency_index": audio_frequency_index,
            "channel_configuration": audio_channel_config,
            "sample_rate": audio.get("sample_rate"),
            "channels": audio.get("channels"),
        },
        "container": {
            "duration": probe["format"].get("duration"),
            "format_name": probe["format"].get("format_name"),
            "video_audio_first_pts_delta_seconds": "0",
            "video_audio_end_duration_delta_seconds": str(Fraction(video_track["end_pts_seconds"]) - Fraction(audio_track["end_pts_seconds"])),
        },
        "validated": {
            "full_h264_aac_decode": decode.returncode == 0,
            "video_pts_non_decreasing": video_track["pts_non_decreasing"],
            "video_dts_strictly_increasing": video_track["dts_strictly_increasing"],
            "audio_pts_non_decreasing": audio_track["pts_non_decreasing"],
            "audio_dts_strictly_increasing": audio_track["dts_strictly_increasing"],
            "first_video_packet_is_idr": 5 in video_track["first_packet_nal_types"] and "K" in video_track["first_packet_flags"],
            "avc_extradata_has_sps_pps": set(avc["sps_nal_types"]) >= {7} and set(avc["pps_nal_types"]) >= {8},
            "aac_config_present": bool(aac_config),
        },
        "limits": [
            "Both tracks starting at PTS zero is container evidence and does not prove a shared physical capture epoch.",
            "AVC SPS/PPS are in MP4 extradata; this sample has no NAL7/NAL8 in packet payload, so it does not prove segment-boundary parameter-set delivery.",
            "Normal recording does not expose RTOS FIFO descriptor sequence, payload ownership, cursor advancement or close/open rollover behavior.",
            "One 4.67-second file is not the fixed 60-second pre-record feature and does not validate voice or shutter binding.",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), "validated": output["validated"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
