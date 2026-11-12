#!/usr/bin/env python3
"""Independent packet coverage and ISO-vs-demuxer timing review; no device IO."""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path
import audit_prerecord_minute_aac_schedule as audit

g,n,r=audit.g,audit.n,audit.r
s=r.s


def compact(gate):
    failures=[p for p in gate['compared_packets'] if not p['same_payload'] or any(
        p[k]['numerator'] for k in ('pts_error','dts_error','duration_error'))]
    return dict(status=gate['status'],same_retained_payload=gate['same_retained_payload'],
        exact_retained_timing=gate['exact_retained_timing'],missing=gate['missing_submitted_packets'],
        unexpected=gate['unexpected_output_packets'],failures=failures)


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--input',type=Path,required=True)
    folder=ap.parse_args().input
    record=json.loads((folder/'audit.json').read_text())
    r.require(record['status']=='offline_end_assigned_event3_executed','audit did not finish')
    source=g.probe(r.minute.SOURCE);source_packets=g.packets(source,r.minute.SOURCE.read_bytes())
    selected=g.select_window(source_packets,Fraction(),Fraction(1920*1001,30000))
    split=Fraction(1800*1001,30000)
    first=[p for p in selected if (p['stream']==0 and Fraction(p['pts'],30000)<split)
        or (p['stream']==1 and Fraction(p['pts']+p['duration'],48000)<=split)]
    keys={(p['stream'],p['index']) for p in first}
    second=[p for p in selected if (p['stream'],p['index']) not in keys]
    emitted={0:[],1:[]};segments=[]
    for number,(seg,expected) in enumerate(zip(record['segments'],[first,second]),1):
        entry=seg['native'];path=folder/entry['file'];raw=path.read_bytes()
        r.require(n.sha(raw)==entry['sha256'],'native output hash mismatch')
        epoch=Fraction(entry['source_epoch']['numerator'],entry['source_epoch']['denominator'])
        ordinary=g.probe(path);normal=g.packets(ordinary,raw)
        ignored=g.probe(path,True);bare=g.packets(ignored,raw)
        native=r.comparison(normal,expected,ordinary['streams'],epoch)
        # Independent standards-level projection from STTS and the empty edit.
        # This is an additional diagnostic, not a replacement consumer gate.
        boxed=g.container_timeline(raw);projected=[];tracks=[]
        for st in (0,1):
            track=boxed['tracks'][st];tb=Fraction(ignored['streams'][st]['time_base'])
            d=track['delay'];delay=Fraction(d['numerator'],d['denominator'])
            offset=delay/tb;r.require(offset.denominator==1,'edit delay does not map exactly to track ticks')
            bare_stream=[p for p in bare if p['stream']==st]
            r.require([Fraction(p['duration'])*tb for p in bare_stream]==[
                Fraction(v,track['media_clock']) for v in track['stts_durations']], 'ignored durations disagree with STTS')
            for p in bare_stream:
                q=dict(p);q['pts']+=int(offset);q['dts']+=int(offset);projected.append(q)
            emitted[st].extend(p['sha256'] for p in bare_stream)
            tracks.append(dict(stream=st,media_clock=track['media_clock'],media_duration=track['media_duration'],
                empty_edit=track['delay'],stts_duration_set=sorted(set(track['stts_durations'])),
                first_ignored_pts=bare_stream[0]['pts'],last_ignored_duration=bare_stream[-1]['duration']))
        iso=r.comparison(projected,expected,ignored['streams'],epoch)
        r.require(iso['status']=='pass','ISO/STTS projection does not preserve exact source timeline')
        segments.append(dict(file=path.name,sha256=n.sha(raw),consumer_gate=compact(native),
            iso_stts_plus_empty_edit_projection_gate=compact(iso),source_epoch=entry['source_epoch'],tracks=tracks,
            video_decode_matches_source=entry['video_matches_source'],all_submitted_aac_pcm_matches=entry['all_submitted_audio_matches_pcm'],
            iso_duration_variant_changes=seg['iso_changes']))
    coverage={}
    for st in (0,1):
        expected=[p['sha256'] for p in selected if p['stream']==st]
        r.require(emitted[st]==expected,'global sample identity/order mismatch')
        coverage[str(st)]=dict(source_packets=len(expected),exported_packets=len(emitted[st]),
            source_order_payload_identity=True,missing=0,duplicates=0)
    result=dict(schema=1,offline_only=True,status='expected_native_consumer_rejection_preserved',
        ffprobe=dict(version=g.run([s.FFPROBE,'-version']).decode().splitlines()[0],
            sha256=n.sha(Path(s.FFPROBE).read_bytes())),
        ffmpeg_sha256=n.sha(Path(s.FFMPEG).read_bytes()),
        audit_sha256=n.sha((folder/'audit.json').read_bytes()),review_script_sha256=n.sha(Path(__file__).read_bytes()),
        executed_audit_script_digest_matches=n.sha(Path(audit.__file__).read_bytes())==record['script_sha256'],
        source_packet_coverage=coverage,segments=segments,
        strict_native_consumer_gate='reject',iso_projection_is_not_publication_gate=True,
        conclusion='End-assignment fixes native Close0 AAC coverage. Native ISO sample tables and delays describe every exact source interval. This ffprobe applies video delay and reports a shorter last packet, consistent with clipping against the unshifted duration; consumer internals were not audited. No gate was weakened.',
        limitations=['Standards-level timestamp reconstruction is not a proven consumer implementation or deployment fix.',
            'No live producer queues, lookahead ownership, SD persistence or device integration were tested.'])
    (folder/'timing-review.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__':main()
