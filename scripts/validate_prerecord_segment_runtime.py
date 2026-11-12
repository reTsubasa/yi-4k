#!/usr/bin/env python3
"""Validate host replay segments at the MP4/H.264/AAC boundary.

This checker strengthens the host-only pre-record evidence by inspecting every
selected segment in a replay manifest.  It verifies that each segment has
independent H.264 output (an IDR in its first packet plus SPS/PPS in AVC
extradata), that AAC configuration is present and stable, and that the
published clip decodes.  It never connects to a camera and never treats an
MP4 container observation as proof of the RTOS FIFO/descriptor contract.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
from pathlib import Path
from typing import Any


FFPROBE = os.environ.get("YI4K_FFPROBE", "ffprobe")
FFMPEG = os.environ.get("YI4K_FFMPEG", "ffmpeg")
HEX_LINE = re.compile(r"^\s*[0-9a-f]+:\s+([0-9a-f ]+?)(?:\s{2,}.*)?$", re.I)


def run(command: list[str]) -> str:
    process = subprocess.run(command, text=True, capture_output=True, check=False)
    if process.returncode:
        raise RuntimeError(f"{command[0]} failed: {process.stderr[-4000:]}")
    return process.stdout


def probe_streams(path: Path) -> list[dict[str, Any]]:
    return json.loads(run([
        FFPROBE, "-v", "error", "-show_streams", "-show_data", "-of", "json", str(path)
    ]))["streams"]


def probe_first_video_packet(path: Path) -> dict[str, Any]:
    packets = json.loads(run([
        FFPROBE, "-v", "error", "-select_streams", "v:0", "-read_intervals", "%+#1",
        "-show_packets", "-show_data",
        "-show_entries", "packet=pts,dts,flags,size,data", "-of", "json", str(path)
    ]))["packets"]
    if not packets:
        raise ValueError(f"segment has no video packet: {path}")
    return packets[0]


def decode_dump(value: str) -> bytes:
    result = bytearray()
    for line in value.splitlines():
        match = HEX_LINE.match(line)
        if match:
            result.extend(bytes.fromhex("".join(match.group(1).split())))
    return bytes(result)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def extradata_bytes(stream: dict[str, Any]) -> bytes:
    value = stream.get("extradata")
    if not isinstance(value, str):
        return b""
    return decode_dump(value)


def avc_nal_types(packet_data: bytes, length_size: int) -> list[int]:
    if length_size not in (1, 2, 4):
        raise ValueError(f"unsupported AVC NAL length size: {length_size}")
    result: list[int] = []
    offset = 0
    while offset + length_size <= len(packet_data):
        length = int.from_bytes(packet_data[offset:offset + length_size], "big")
        offset += length_size
        if length == 0:
            continue
        if offset + length > len(packet_data):
            raise ValueError("length-prefixed H.264 packet is truncated")
        result.append(packet_data[offset] & 0x1F)
        offset += length
    if offset != len(packet_data):
        raise ValueError("length-prefixed H.264 packet has trailing bytes")
    return result


def avc_parameter_set_types(data: bytes) -> set[int]:
    """Read SPS/PPS types from an AVCDecoderConfigurationRecord."""
    if len(data) < 7 or data[0] != 1:
        return set()
    offset = 5
    result: set[int] = set()
    sps_count = data[offset] & 0x1F
    offset += 1
    for _ in range(sps_count):
        if offset + 2 > len(data):
            return result
        length = int.from_bytes(data[offset:offset + 2], "big")
        offset += 2
        if offset + length > len(data):
            return result
        if length:
            result.add(data[offset] & 0x1F)
        offset += length
    if offset >= len(data):
        return result
    pps_count = data[offset]
    offset += 1
    for _ in range(pps_count):
        if offset + 2 > len(data):
            return result
        length = int.from_bytes(data[offset:offset + 2], "big")
        offset += 2
        if offset + length > len(data):
            return result
        if length:
            result.add(data[offset] & 0x1F)
        offset += length
    return result


def validate(manifest_path: Path) -> dict[str, Any]:
    manifest_path = manifest_path.resolve(strict=True)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    root = manifest_path.parent
    selected = manifest.get("segments")
    if not isinstance(selected, list) or not selected:
        raise ValueError("manifest has no selected segments")

    segment_rows: list[dict[str, Any]] = []
    audio_configs: list[str] = []
    for entry in selected:
        name = entry.get("name")
        if not isinstance(name, str) or Path(name).name != name:
            raise ValueError("manifest contains an unsafe segment name")
        path = root / "segments" / name
        if not path.is_file():
            raise FileNotFoundError(path)
        digest = sha256(path)
        if entry.get("sha256") and entry["sha256"] != digest:
            raise ValueError(f"segment hash mismatch: {name}")
        streams = probe_streams(path)
        videos = [stream for stream in streams if stream.get("codec_type") == "video"]
        audios = [stream for stream in streams if stream.get("codec_type") == "audio"]
        if len(videos) != 1 or videos[0].get("codec_name") != "h264":
            raise ValueError(f"segment does not contain exactly one H.264 track: {name}")
        video = videos[0]
        parameter_types = avc_parameter_set_types(extradata_bytes(video))
        packet = probe_first_video_packet(path)
        packet_data = decode_dump(packet.get("data", ""))
        packet_size = int(packet.get("size", len(packet_data)))
        nal_types = avc_nal_types(packet_data, int(video.get("nal_length_size", 4)))
        if packet_size != len(packet_data):
            raise ValueError(f"first packet byte count mismatch: {name}")
        if "K" not in packet.get("flags", "") or 5 not in nal_types:
            raise ValueError(f"segment does not begin with an IDR packet: {name}")
        audio = audios[0] if audios else None
        audio_config = extradata_bytes(audio) if audio else b""
        if audio is not None:
            if audio.get("codec_name") != "aac" or int(audio.get("sample_rate", 0)) != 48000:
                raise ValueError(f"unexpected AAC configuration: {name}")
            if not audio_config:
                raise ValueError(f"AAC AudioSpecificConfig missing: {name}")
            audio_configs.append(hashlib.sha256(audio_config).hexdigest())
        segment_rows.append({
            "name": name,
            "sha256": digest,
            "source_start_us": entry.get("start_us"),
            "source_end_us": entry.get("end_us"),
            "video_time_base": video.get("time_base"),
            "video_duration": video.get("duration"),
            "audio_duration": audio.get("duration") if audio else None,
            "audio_sample_rate": audio.get("sample_rate") if audio else None,
            "avc_extradata_size": video.get("extradata_size"),
            "avc_parameter_set_types": sorted(parameter_types),
            "first_video_packet_flags": packet.get("flags"),
            "first_video_packet_nal_types": nal_types,
            "first_video_packet_pts": packet.get("pts"),
            "first_video_packet_dts": packet.get("dts"),
            "first_video_packet_size": packet_size,
            "aac_config_sha256": audio_configs[-1] if audio else None,
        })

    clip_relative = manifest.get("clip", {}).get("path", "clip.mp4")
    clip = (root / clip_relative).resolve(strict=True)
    if root not in clip.parents:
        raise ValueError("clip escapes replay directory")
    clip_streams = probe_streams(clip)
    clip_videos = [stream for stream in clip_streams if stream.get("codec_type") == "video"]
    clip_audios = [stream for stream in clip_streams if stream.get("codec_type") == "audio"]
    if len(clip_videos) != 1 or clip_videos[0].get("codec_name") != "h264":
        raise ValueError("published clip is missing its H.264 track")
    run([FFMPEG, "-v", "error", "-xerror", "-err_detect", "explode", "-nostdin",
         "-i", str(clip), "-map", "0:v:0", "-map", "0:a:0?", "-f", "null", "-"])

    all_parameter_sets = all(set(row["avc_parameter_set_types"]) >= {7, 8} for row in segment_rows)
    all_idr = all(5 in row["first_video_packet_nal_types"] for row in segment_rows)
    audio_continuity = bool(audio_configs) and len(set(audio_configs)) == 1
    return {
        "schema_version": 1,
        "kind": "host pre-record segment runtime contract",
        "scope": "host MP4 replay only; no camera FIFO or RTOS execution",
        "manifest": str(manifest_path),
        "segment_count": len(segment_rows),
        "segments": segment_rows,
        "clip": {
            "path": str(clip),
            "sha256": sha256(clip),
            "video_streams": len(clip_videos),
            "audio_streams": len(clip_audios),
            "full_decode_passed": True,
        },
        "validated": {
            "segment_hashes": True,
            "all_segments_have_sps_pps_in_mp4_extradata": all_parameter_sets,
            "all_segments_start_with_idr": all_idr,
            "aac_audio_specific_config_present": bool(audio_configs),
            "aac_config_continuity": audio_continuity,
            "published_clip_decodes": True,
        },
        "runtime_gaps": [
            "MP4 AVC extradata does not prove that camera FIFO payloads contain NAL7/NAL8 before NAL5.",
            "Host segment timestamps are reset by the MP4 segmenter and do not prove a camera A/V capture epoch.",
            "Descriptor sequence, payload address lifetime, FIFO cursor and close/open ownership remain unobserved.",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = validate(args.manifest)
    output = args.output or args.manifest.with_name("segment-runtime-contract.json")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(output), "validated": result["validated"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
