#!/usr/bin/env python3
"""Read MP4 timing boxes directly; no modification or dependency on ffprobe."""
import argparse
import hashlib
import json
from pathlib import Path
import struct


def boxes(data, start=0, end=None):
    end = len(data) if end is None else end
    while start < end:
        if end - start < 8:
            raise ValueError('short box header')
        size, kind = struct.unpack_from('>I4s', data, start)
        header = 8
        if size == 1:
            size = struct.unpack_from('>Q', data, start + 8)[0]
            header = 16
        elif size == 0:
            size = end - start
        if size < header or start + size > end:
            raise ValueError('invalid box extent')
        yield kind.decode('ascii'), start + header, start + size
        start += size


def child(data, parent, kind):
    matches = [row for row in boxes(data, parent[1], parent[2]) if row[0] == kind]
    if len(matches) != 1:
        raise ValueError(f'expected exactly one {kind}')
    return matches[0]


def inspect(path):
    data = path.read_bytes()
    moov = child(data, ('root', 0, len(data)), 'moov')
    result = {'path': str(path.resolve()), 'sha256': hashlib.sha256(data).hexdigest(), 'tracks': {}}
    for track in (b for b in boxes(data, moov[1], moov[2]) if b[0] == 'trak'):
        mdia = child(data, track, 'mdia')
        hdlr = child(data, mdia, 'hdlr')
        kind = data[hdlr[1] + 8:hdlr[1] + 12].decode('ascii')
        mdhd = child(data, mdia, 'mdhd')
        pos = mdhd[1]
        version = data[pos]
        if version == 0:
            timescale, duration = struct.unpack_from('>II', data, pos + 12)
        elif version == 1:
            timescale, duration = struct.unpack_from('>IQ', data, pos + 20)
        else:
            raise ValueError('unsupported mdhd version')
        minf = child(data, mdia, 'minf')
        stbl = child(data, minf, 'stbl')
        stts = child(data, stbl, 'stts')
        pos = stts[1]
        count = struct.unpack_from('>I', data, pos + 4)[0]
        if stts[2] - pos != 8 + count * 8:
            raise ValueError('invalid STTS length')
        entries = [struct.unpack_from('>II', data, pos + 8 + i * 8) for i in range(count)]
        durations = [duration for samples, duration in entries for _ in range(samples)]
        result['tracks'][kind] = {'timescale': timescale, 'mdhd_duration': duration,
                                  'sample_count': len(durations), 'stts_entries': entries,
                                  'expanded_sample_durations': durations}
    return result


def main():
    root = Path(__file__).resolve().parent
    files = [root / 'source.mp4', *sorted((root / 'nonzero/segments').glob('part-00000[2-5].mp4')),
             root / 'nonzero/clip.pending.mp4']
    rows = [inspect(path) for path in files]
    audio = [row['tracks']['soun']['expanded_sample_durations'] for row in rows]
    selected = [duration for part in audio[1:-1] for duration in part]
    source_start_packet = 189  # independently identified by packet SHA256 in preserved fidelity JSON
    checks = {'output_stts_equals_selected_stts': audio[-1] == selected,
              'output_stts_equals_contiguous_source_stts': audio[-1] == audio[0][source_start_packet:source_start_packet + len(audio[-1])],
              'output_last_aac_stts_duration_1024': audio[-1][-1] == 1024}
    for row in rows:
        for track in row['tracks'].values():
            del track['expanded_sample_durations']
    result = {'scope': 'direct MP4 STTS/MDHD parsing; no device contact or media mutation',
              'source_start_packet_from_sha256': source_start_packet, 'checks': checks,
              'passed': all(checks.values()), 'files': rows,
              'ffprobe_observation': {'source_last_selected_duration': 1024,
                                      'output_last_duration': 512,
                                      'source_and_output_audio_time_base': '1/48000'},
              'interpretation': 'Actual source/selected/output STTS durations match. FFmpeg 6.1 MOV packet duration inference misreports final duration for this positive-start case; unchanged strict gate rejects.'}
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=root / 'timing-table-proof.json')
    destination = parser.parse_args().output
    with destination.open('x') as file:
        json.dump(result, file, indent=2)
        file.write('\n')
    print(json.dumps({'passed': result['passed'], 'checks': checks}))


if __name__ == '__main__':
    main()
