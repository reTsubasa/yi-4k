#!/usr/bin/env python3
"""Recover a pinned, failed pair of stock event3 files from retained AAC.

Host-only byte-preserving container reconstruction. Output bytes come from failed MP4 extents and
custody bins, never from the intact source used as an independent oracle.
This is deliberately limited to the audited zero-origin 16 I/P + 26 AAC case.
No RTOS/device/SD execution or general damaged-media repair is implemented.
"""
from __future__ import annotations
import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess
import struct
import traceback

import audit_prerecord_real_gop as g

ROOT = Path(__file__).resolve().parents[1]
CUSTODY = ROOT / 'artifacts/verification/2026-11-11-prerecord-packet-custody-independent-run02'
SEGMENTS = ROOT / 'artifacts/device/2026-11-11-prerecord-event3-run02'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def rebuild_mp4(template, video, audio):
    """Rebuild only the pinned CFR/no-reorder tracks; preserve stsd and every packet.

    The failed segments do not authenticate the original capture epoch. This
    caller uses the archived, independently audited zero-origin mapping, and
    refuses reordered H.264. No timestamp is inferred by a decoder/parser.
    """
    def u32(*values): return struct.pack('>' + 'I' * len(values), *values)
    def box(kind, payload): return u32(len(payload) + 8) + kind.encode('ascii') + payload
    def full(kind, payload): return box(kind, b'\0' * 4 + payload)
    for packet in video:
        for nal in g.split_nals(packet):
            if nal[0] & 31 in (1, 5) and g.slice_type(nal)['picture_type'] not in ('I', 'P'):
                raise ValueError('Reordered H.264 is outside this recovery contract')
    top = g.box_children(template, 0, len(template))
    ftyp = next(x for x in top if x['kind'] == 'ftyp')
    ftyp_bytes = template[ftyp['offset']:ftyp['offset'] + ftyp['size']]
    first_video = len(ftyp_bytes) + 8
    first_audio = first_video + sum(map(len, video))
    movie_clock = 240000
    metadata = dict(video=(video, 30000, 1001, first_video), audio=(audio, 48000, 1024, first_audio))
    durations = {key: len(samples) * delta * movie_clock // rate
                 for key, (samples, rate, delta, _) in metadata.items()}
    def rewrite(node, track=None):
        kind, payload = node['kind'], node['payload']
        if kind == 'edts': return b''  # Failed split edit lists cannot describe the rebuilt continuous tracks.
        if kind == 'trak':
            children = g.box_children(template, node['offset'] + 8, node['offset'] + node['size'])
            mdia = next(x for x in children if x['kind'] == 'mdia')
            hdlr = next(x for x in g.box_children(template, mdia['offset'] + 8, mdia['offset'] + mdia['size']) if x['kind'] == 'hdlr')
            track = {b'vide': 'video', b'soun': 'audio'}[hdlr['payload'][8:12]]
        if kind in ('moov', 'trak', 'mdia', 'minf', 'stbl'):
            children = g.box_children(template, node['offset'] + 8, node['offset'] + node['size'])
            return box(kind, b''.join(rewrite(child, track) for child in children))
        if kind in ('mvhd', 'mdhd', 'tkhd'):
            if payload[0] != 0: raise ValueError('Only version-zero duration headers are supported')
            data = bytearray(payload)
            if kind == 'mvhd': data[12:20] = u32(movie_clock, max(durations.values()))
            elif kind == 'tkhd': data[20:24] = u32(durations[track])
            else:
                samples, rate, delta, _ = metadata[track]
                data[12:20] = u32(rate, len(samples) * delta)
            return box(kind, bytes(data))
        if track:
            samples, rate, delta, offset = metadata[track]
            if kind == 'stts': return full(kind, u32(1, len(samples), delta))
            if kind == 'stsc': return full(kind, u32(1, 1, len(samples), 1))
            if kind == 'stsz': return full(kind, u32(0, len(samples), *map(len, samples)))
            if kind == 'stco': return full(kind, u32(1, offset))
            if kind == 'stss':
                sync = [i + 1 for i, packet in enumerate(samples)
                        if any(nal[0] & 31 == 5 for nal in g.split_nals(packet))]
                return full(kind, u32(len(sync), *sync))
            if kind in ('ctts', 'co64'): raise ValueError('Unsupported timing/chunk table')
        return box(kind, payload)
    moov = next(x for x in top if x['kind'] == 'moov')
    return ftyp_bytes + box('mdat', b''.join(video + audio)) + rewrite(moov)


def recover(output: Path, *, omit_custody=False, corrupt_custody=False):
    output.mkdir(parents=True, exist_ok=False)
    report = dict(schema=1, scope=__doc__, device_access=False, status='running',
                  source_used_for_output=False, output_uses_reencode=False, script_sha256=sha(Path(__file__).read_bytes()),
                  injection=dict(omit_custody=omit_custody, corrupt_custody=corrupt_custody),
                  input_hashes={}, provenance=[], commands=[])
    def checkpoint():
        (output / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    def read(path):
        data = path.read_bytes()
        report['input_hashes'][str(path.relative_to(ROOT))] = sha(data)
        return data
    def command(argv):
        result = subprocess.run(list(map(str, argv)), capture_output=True)
        report['commands'].append(dict(argv=list(map(str, argv)), returncode=result.returncode,
                                       stderr=result.stderr.decode(errors='replace')))
        if result.returncode:
            raise ValueError(result.stderr.decode(errors='replace'))
        return result.stdout
    checkpoint()
    try:
        validation = json.loads(read(CUSTODY / 'validation.json'))
        if validation['status'] != 'pass' or not validation['offline_only']:
            raise ValueError('Custody input is not the pinned offline validation')
        regressions = validation['event3_regressions']
        audio, video, config, template = [], [], None, None
        for number in (1, 2):
            path = SEGMENTS / f'event3-segment-{number}.mp4'
            raw = read(path)
            if template is None: template = raw
            if sha(raw) != validation['archived_input_hashes'][str(path.relative_to(ROOT))]:
                raise ValueError('Stock segment identity changed')
            probe = g.probe(path)
            if [stream['codec_name'] for stream in probe['streams']] != ['h264', 'aac']:
                raise ValueError('Only pinned H.264/AAC tracks are supported')
            if [stream['time_base'] for stream in probe['streams']] != ['1/30000', '1/48000']:
                raise ValueError('Track clocks differ from archived recovery contract')
            sps, pps = g.avcc(g.extradata(probe['streams'][0]['extradata']))
            if config is not None and config != (sps, pps):
                raise ValueError('Codec epoch differs across failed segments')
            config = sps, pps
            packets = g.packets(probe, raw)
            local_video = [p for p in packets if p['stream'] == 0]
            local_audio = [p for p in packets if p['stream'] == 1]
            if len(local_video) != 8 or len(local_audio) != 12:
                raise ValueError('Unsupported missing packet pattern')
            if not local_video[0]['key']:
                raise ValueError('Segment does not begin at the audited sync frame')
            video.extend(p['data'] for p in local_video)
            audio.extend(p['data'] for p in local_audio)
            for p in packets:
                report['provenance'].append(dict(kind='closed_mp4_extent', segment=number,
                    stream=p['stream'], local_index=p['index'], offset=p['offset'], bytes=p['bytes'],
                    sha256=p['sha256']))
            missing = regressions[number - 1]
            retained = read(CUSTODY / missing['retained_missing_payload'])
            if (missing['segment'] != number or missing['missing_source_index'] != number * 13 - 1
                    or not missing['all_source_bytes_retained'] or sha(retained) != missing['missing_sha256']):
                raise ValueError('Custody provenance does not match the pinned missing AAC')
            if not omit_custody:
                if corrupt_custody and number == 1:
                    retained = bytes([retained[0] ^ 1]) + retained[1:]
                audio.append(retained)
                report['provenance'].append(dict(kind='custody_bin', segment=number, stream=1,
                    source_index=missing['missing_source_index'], bytes=len(retained), sha256=sha(retained)))
        pending = output / 'recovered.pending.mp4'
        pending.write_bytes(rebuild_mp4(template, video, audio))
        report['container_rebuild'] = dict(backend='direct ISO BMFF tables, no codec parser/re-encode',
            video_clock=30000, video_delta=1001, audio_clock=48000, audio_delta=1024,
            sample_entries_source='first failed MP4 stsd', edit_lists='removed; archived zero-origin mapping only')
        report['pending_sha256'] = sha(pending.read_bytes())
        # Oracle consulted only after output has been constructed.
        source = g.s.SAMPLE_MP4
        raw = read(source)
        if sha(raw) != g.SOURCE_SHA:
            raise ValueError('Independent oracle identity changed')
        oracle = g.packets(g.probe(source), raw)
        selected = [p for p in oracle if p['index'] < (16 if p['stream'] == 0 else 26)]
        # Gate rejects missing/changed bytes even when the output decodes.
        probe = g.probe(pending)
        actual = g.packets(probe, pending.read_bytes())
        counts = {str(track): sum(p['stream'] == track for p in actual) for track in (0, 1)}
        expected_counts = {'0': 16, '1': 26}
        report['output_counts'] = counts
        report['expected_counts'] = expected_counts
        if counts == expected_counts:
            gate = g.exact_gate(actual, selected, probe['streams'], Fraction(0))
        else:
            gate = dict(status='reject', reason='packet count mismatch')
        report['strict_packet_time_gate'] = gate
        if gate['status'] != 'pass':
            report['status'] = 'rejected_retained_for_recovery'
            checkpoint()
            return report
        frames = g.frame_hashes(pending)
        expected_frames = g.frame_hashes(source, 16)
        # Decode the same complete AAC sequence continuously. Native video tail
        # is shorter than AAC; no -shortest trimming may drop the last AAC.
        reference = output / 'oracle-reference.aac'
        reference.write_bytes(b''.join(g.adts(p['data']) for p in selected if p['stream'] == 1))
        pcm = g.pcm(pending)
        report['decode'] = dict(video_frames=len(frames), video_matches_oracle=frames == expected_frames,
                              pcm_bytes=len(pcm), pcm_sha256=sha(pcm),
                              audio_matches_continuous_oracle=pcm == g.pcm(reference, True))
        if not all((frames == expected_frames, report['decode']['audio_matches_continuous_oracle'])):
            raise ValueError('Independent decode differs')
        pending.rename(output / 'recovered.mp4')
        report['status'] = 'pass_host_recovery_only'
        report['limitations'] = [
            'Pinned zero-origin, no-B-frame 29.97fps H.264 / stereo 48kHz AAC only.',
            'Original FIFO identity is an archived caller mapping, not authenticated by MP4.',
            'Both complete tracks are rebuilt on one continuous source-rate timeline; failed per-segment timing is not trusted.',
            'Direct ISO BMFF reconstruction is host recovery only; no RTOS mux recovery, physical SD durability or device integration.',
            'The fixture covers 16 video / 26 audio packets, not a one-minute live buffer.',
        ]
        checkpoint()
        return report
    except Exception as error:
        report.update(status='error_retained_for_recovery', error=str(error), traceback=traceback.format_exc())
        checkpoint()
        raise


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--omit-custody', action='store_true')
    ap.add_argument('--corrupt-custody', action='store_true')
    args = ap.parse_args()
    result = recover(args.output, omit_custody=args.omit_custody, corrupt_custody=args.corrupt_custody)
    print(json.dumps(dict(output=str(args.output), status=result['status'])))
    raise SystemExit(0 if result['status'] == 'pass_host_recovery_only' else 2)


if __name__ == '__main__':
    main()
