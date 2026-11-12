#!/usr/bin/env python3
"""Verify compressed packet identity and timing of a local prerecord replay.

Reads MP4 files through ffprobe; never connects to a camera. Packet hashes avoid
loading a hex dump of the entire compressed video into Python memory. This is
file-level evidence, not a FIFO, hardware epoch or camera prerecord validator.
"""
from __future__ import annotations

import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def probe(path, ffprobe):
    command = [str(ffprobe), '-v', 'error', '-show_streams', '-show_packets',
               '-show_data_hash', 'sha256', '-show_entries',
               'stream=index,codec_type,codec_name,time_base:packet=stream_index,pts,dts,duration,size,flags,data_hash',
               '-of', 'json', str(path)]
    result = subprocess.run(command, capture_output=True, check=True, timeout=180)
    data = json.loads(result.stdout)
    tracks = {}
    for stream in data['streams']:
        kind = stream['codec_type']
        if kind not in ('video', 'audio'):
            continue
        if kind in tracks:
            raise ValueError('expected one track per audio/video type')
        packets = [p for p in data['packets'] if p['stream_index'] == stream['index']]
        if not packets or any(not p.get('data_hash', '').startswith('SHA256:') for p in packets):
            raise ValueError('missing compressed packet hashes')
        if any('pts' not in p or 'dts' not in p or 'duration' not in p for p in packets):
            raise ValueError('all packets require PTS, DTS and duration')
        tracks[kind] = dict(stream=stream, packets=packets)
    if 'video' not in tracks:
        raise ValueError('expected one video track with optional audio')
    return tracks


def signatures(packets):
    return [(p['data_hash'], int(p['size'])) for p in packets]


def compare_track(source, clip, segments, tolerance):
    originals, saved = source['packets'], clip['packets']
    expected, actual = signatures(originals), signatures(saved)
    flattened = [p for track in segments for p in track['packets']]
    source_tb = Fraction(source['stream']['time_base'])
    clip_tb = Fraction(clip['stream']['time_base'])
    # Compressed packets can be identical (e.g. silence); record all matching
    # offsets rather than claiming that a hash proves a unique source identity.
    matches = [i for i in range(len(expected) - len(actual) + 1)
               if expected[i:i + len(actual)] == actual]
    timing_matches = []
    diagnostics = []
    for start in matches:
        offsets = [int(b[field]) * clip_tb - int(a[field]) * source_tb
                   for a, b in zip(originals[start:start + len(saved)], saved)
                   for field in ('pts', 'dts')]
        duration_errors = [abs(int(b['duration']) * clip_tb - int(a['duration']) * source_tb)
                           for a, b in zip(originals[start:start + len(saved)], saved)]
        low, high = min(offsets), max(offsets)
        row = dict(source_first_packet=start, offset_min_seconds=str(low),
                   offset_max_seconds=str(high), offset_spread_seconds=str(high - low),
                   max_duration_error_seconds=str(max(duration_errors)),
                   constant_pts_dts_offset=high - low <= tolerance,
                   durations_preserved=max(duration_errors) <= tolerance)
        diagnostics.append(row)
        if row['constant_pts_dts_offset'] and row['durations_preserved']:
            timing_matches.append(row)
    return dict(codec=clip['stream']['codec_name'], source_packet_count=len(originals),
                clip_packet_count=len(saved), selected_segment_packet_count=len(flattened),
                selected_segments_equal_clip_packets=signatures(flattened) == actual,
                source_contiguous_hash_match_count=len(matches),
                source_identity_unique=len(matches) == 1,
                source_matching_timing_candidates=diagnostics,
                faithful_timing_candidates=timing_matches,
                dts_strictly_increasing=all(int(b['dts']) > int(a['dts'])
                                          for a, b in zip(saved, saved[1:])))


def validate(manifest_path, ffprobe, *, phase='published'):
    manifest_path = manifest_path.resolve(strict=True)
    manifest = json.loads(manifest_path.read_text())
    required_state = {'published': 'complete', 'prepublish': 'validating'}.get(phase)
    if required_state is None or manifest.get('state') != required_state:
        raise ValueError('manifest state does not match validation phase')
    root = manifest_path.parent
    source = Path(manifest['source']).resolve(strict=True)
    clip = (root / manifest['clip']['path']).resolve(strict=True)
    if root not in clip.parents:
        raise ValueError('clip escapes replay directory')
    if digest(source) != manifest['source_sha256'] or digest(clip) != manifest['clip']['sha256']:
        raise ValueError('source/clip hash differs from replay manifest')
    selected = []
    for row in manifest['segments']:
        name = row['name']
        if Path(name).name != name:
            raise ValueError('unsafe segment name')
        path = (root / 'segments' / name).resolve(strict=True)
        if root not in path.parents or digest(path) != row['sha256']:
            raise ValueError('segment escapes replay directory or hash differs')
        selected.append(probe(path, ffprobe))
    if not selected:
        raise ValueError('no selected segments')
    original_tracks, clip_tracks = probe(source, ffprobe), probe(clip, ffprobe)
    kinds = tuple(k for k in ('video', 'audio') if k in original_tracks)
    if set(clip_tracks) != set(kinds) or any(set(s) != set(kinds) for s in selected):
        raise ValueError('source, selected segments and clip must have the same tracks')
    tolerance = Fraction(2, 1000)
    tracks = {kind: compare_track(original_tracks[kind], clip_tracks[kind],
                                 [s[kind] for s in selected], tolerance)
              for kind in kinds}
    # A shared fixed offset must explain BOTH tracks. Independent per-track
    # offsets would hide an audio/video shift introduced during concatenation.
    common = []
    for v in tracks['video']['faithful_timing_candidates']:
        # Video-only sources still require a faithful fixed offset. When an
        # audio track exists the original shared-offset test stays mandatory.
        audio_candidates = tracks['audio']['faithful_timing_candidates'] if 'audio' in tracks else [None]
        for a in audio_candidates:
            if a is None:
                common.append(dict(video_source_packet=v['source_first_packet'],
                                   offset_min_seconds=v['offset_min_seconds'],
                                   offset_max_seconds=v['offset_max_seconds']))
                continue
            lo = min(Fraction(v['offset_min_seconds']), Fraction(a['offset_min_seconds']))
            hi = max(Fraction(v['offset_max_seconds']), Fraction(a['offset_max_seconds']))
            if hi - lo <= tolerance:
                common.append(dict(video_source_packet=v['source_first_packet'],
                                   audio_source_packet=a['source_first_packet'],
                                   offset_min_seconds=str(lo), offset_max_seconds=str(hi)))
    checks = dict(source_and_output_hashes_match_manifest=True,
                  selected_segment_packet_order_preserved=all(t['selected_segments_equal_clip_packets'] for t in tracks.values()),
                  compressed_packets_are_contiguous_source_subsequences=all(t['source_contiguous_hash_match_count'] > 0 for t in tracks.values()),
                  pts_dts_durations_preserved=all(t['faithful_timing_candidates'] for t in tracks.values()),
                  strictly_increasing_dts=all(t['dts_strictly_increasing'] for t in tracks.values()),
                  common_audio_video_timestamp_offset=bool(common))
    return dict(scope='host MP4 compressed packet/timestamp comparison; no device contact or FIFO proof',
                phase=phase, track_types=list(kinds),
                common_audio_video_offset_applicable='audio' in tracks,
                manifest=str(manifest_path), manifest_sha256=digest(manifest_path),
                source_sha256=digest(source), clip_sha256=digest(clip),
                timestamp_tolerance_seconds=str(tolerance), selected_segments=len(selected),
                tracks=tracks, common_timestamp_offset_candidates=common,
                checks=checks, passed=all(checks.values()),
                limits=['Container timestamps do not prove a common hardware capture epoch.',
                        'No RTOS payload ownership, callback installation, SD spool or real trigger is exercised.',
                        'Repeated identical compressed packets can make source position ambiguous; all candidates are retained.'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--ffprobe', type=Path, default=ROOT / '.tools/ffmpeg-host/ffprobe')
    parser.add_argument('--phase', choices=('published', 'prepublish'), default='published')
    args = parser.parse_args()
    if args.output.exists():
        raise ValueError('output exists; preserve previous evidence')
    result = validate(args.manifest, args.ffprobe.resolve(strict=True), phase=args.phase)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x') as output:
        json.dump(result, output, ensure_ascii=False, indent=2)
        output.write('\n')
    print(json.dumps(dict(output=str(args.output), checks=result['checks'], passed=result['passed'])))
    raise SystemExit(0 if result['passed'] else 1)


if __name__ == '__main__':
    main()
