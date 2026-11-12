#!/usr/bin/env python3
"""Recover a complete continuous archived session from end-assigned stock segments.

Host ISO reconstruction only. Payload/configuration are read exclusively from
native segments. The full intact source is opened only after pending output is
built, for an independent strict gate and frame/PCM comparison.
"""
import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import traceback

import recover_prerecord_custody as recovery
import audit_prerecord_minute_aac_schedule as schedule

g = recovery.g
ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / 'artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01'

def digest(data): return hashlib.sha256(data).hexdigest()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--drop-boundary-aac', action='store_true')
    args = parser.parse_args()
    output = args.output; output.mkdir(parents=True, exist_ok=False)
    report = dict(schema=1, status='running', device_access=False, source_used_for_output=False,
                  scope=__doc__, script_sha256=digest(Path(__file__).read_bytes()),
                  iso_rebuilder_sha256=digest(Path(recovery.__file__).read_bytes()), input_hashes={},
                  injection=dict(drop_boundary_aac=args.drop_boundary_aac))
    def checkpoint(): (output/'audit.json').write_text(json.dumps(report, indent=2)+'\n')
    checkpoint()
    try:
        record_bytes = (INPUT/'audit.json').read_bytes()
        record = json.loads(record_bytes)
        report['input_hashes'][str((INPUT/'audit.json').relative_to(ROOT))] = digest(record_bytes)
        assert record['offline_only'] and record['legal_close_mode']==0 and not record['unknown_close1_used']
        assert record['status']=='offline_end_assigned_event3_executed'
        template=None; config=None; video=[]; audio=[]; report['segments']=[]
        for number, segment in enumerate(record['segments']):
            native=segment['native']; path=INPUT/native['file']; raw=path.read_bytes()
            assert digest(raw)==native['sha256']
            report['input_hashes'][str(path.relative_to(ROOT))]=digest(raw)
            if template is None: template=raw
            probe=g.probe(path, True)  # Read samples without consumer edit-list clipping.
            assert [s['time_base'] for s in probe['streams']]==['1/30000','1/48000']
            current=tuple(g.extradata(s['extradata']) for s in probe['streams'])
            if config is not None: assert current==config, 'Codec epoch changed'
            config=current
            boxed=g.container_timeline(raw)
            packets=g.packets(probe,raw)
            epoch=Fraction(native['source_epoch']['numerator'],native['source_epoch']['denominator'])
            for st, target, rate, delta in [(0,video,30000,1001),(1,audio,48000,1024)]:
                track=boxed['tracks'][st]
                assert track['media_clock']==rate
                delay=track['delay'];delay=Fraction(delay['numerator'],delay['denominator'])
                local=[p for p in packets if p['stream']==st]
                assert track['stts_durations']==[delta]*len(local)
                # Global chronology comes from segment epoch + native tables,
                # independent of original file packet identities or timestamps.
                for p in local:
                    expected=Fraction(len(target)*delta,rate)
                    observed=epoch+delay+Fraction(p['pts'],rate)
                    assert observed==expected, f'Track {st} discontinuity: {observed} != {expected}'
                    assert p['pts']==p['dts'] and p['duration']==delta
                    target.append(p['data'])
            report['segments'].append(dict(file=native['file'],source_epoch=native['source_epoch'],
                                           cumulative_counts=dict(video=len(video),audio=len(audio))))
        assert len(video)==1920 and len(audio)==3003
        if args.drop_boundary_aac: del audio[2815]
        pending=output/'session.pending.mp4'
        pending.write_bytes(recovery.rebuild_mp4(template,video,audio))
        report['pending_sha256']=digest(pending.read_bytes())
        # Intact source is not read until the candidate has been fully built.
        source=schedule.r.minute.SOURCE; raw=source.read_bytes()
        assert digest(raw)==schedule.r.minute.SOURCE_SHA
        oracle=g.packets(g.probe(source),raw)
        selected=g.select_window(oracle,Fraction(0),Fraction(1920*1001,30000))
        probe=g.probe(pending); actual=g.packets(probe,pending.read_bytes())
        counts={str(st):sum(p['stream']==st for p in actual) for st in (0,1)}
        report['counts']=counts
        gate=g.exact_gate(actual,selected,probe['streams'],Fraction(0)) if counts=={'0':1920,'1':3003} else dict(status='reject',reason='packet count mismatch')
        report['strict_packet_time_gate']=gate
        if gate['status']!='pass': report['status']='rejected_retained_for_recovery';checkpoint();return 2
        reference=output/'oracle-reference.aac';reference.write_bytes(b''.join(g.adts(p['data']) for p in selected if p['stream']==1))
        frames=g.frame_hashes(pending);pcm=g.pcm(pending)
        report['decode']=dict(video_frames=len(frames),video_matches_oracle=frames==g.frame_hashes(source,1920),
                              pcm_bytes=len(pcm),pcm_sha256=digest(pcm),audio_matches_oracle=pcm==g.pcm(reference,True))
        assert report['decode']['video_matches_oracle'] and report['decode']['audio_matches_oracle']
        pending.rename(output/'session.mp4');report['status']='pass_host_minute_session_recovery_only';checkpoint();return 0
    except Exception as error:
        report.update(status='error_retained',error=str(error),traceback=traceback.format_exc());checkpoint();raise

if __name__=='__main__': raise SystemExit(main())
