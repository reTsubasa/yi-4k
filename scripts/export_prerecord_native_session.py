#!/usr/bin/env python3
"""Export sealed event3 segments through unmodified original ARM MP4 mux.

The recording limit remains 60000 ms. This is a separate offline final-export
session whose requested output limit is the exact selected 64064 ms window.
No FFmpeg mux, host ISO writer, firmware patch, camera, or device IO is used.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import time
import traceback
import audit_prerecord_minute_aac_schedule as schedule

r, g, n, s = schedule.r, schedule.g, schedule.n, schedule.s
ROOT = r.ROOT
DEFAULT_INPUT = ROOT/'artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01'
END = Fraction(1920*1001, 30000)
RATES = (30000, 48000)
DELTAS = (1001, 1024)


def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def fraction(value): return Fraction(value['numerator'], value['denominator'])
def require(condition, message):
    if not condition: raise RuntimeError(message)


def load_segments(folder, report, drop_boundary=False):
    """Native bytes + native tables + caller's sealed source epochs only.

    The original intact recording is deliberately not read by this function.
    Per-track chronology is checked before any native Open or publication.
    """
    record_path = folder/'audit.json'
    record = json.loads(record_path.read_text())
    require(record['status']=='offline_end_assigned_event3_executed', 'native event3 input incomplete')
    require(record['legal_close_mode']==0 and not record['unknown_close1_used'], 'input Close contract changed')
    report['inputs'] = [dict(path=str(record_path),sha256=digest(record_path))]
    report['segments'] = []
    result=[];counts=[0,0];configuration=None
    for segment_index, segment in enumerate(record['segments']):
        entry=segment['native'];path=folder/entry['file'];raw=path.read_bytes()
        require(n.sha(raw)==entry['sha256'], 'native input bytes do not match sealed receipt')
        report['inputs'].append(dict(path=str(path),sha256=n.sha(raw)))
        probe=g.probe(path,True)  # Decode native STTS; preserve edit delay explicitly below.
        require([st['time_base'] for st in probe['streams']]==['1/30000','1/48000'],'input clocks changed')
        current=tuple(g.extradata(st['extradata']) for st in probe['streams'])
        require(configuration is None or current==configuration,'codec epoch changed')
        configuration=current
        boxed=g.container_timeline(raw);epoch=fraction(entry['source_epoch'])
        packets=g.packets(probe,raw);rows=[]
        for st,rate in enumerate(RATES):
            track=boxed['tracks'][st];delay=fraction(track['delay'])
            local=[p for p in packets if p['stream']==st]
            require(track['media_clock']==rate,'native media clock changed')
            require(track['stts_durations']==[DELTAS[st]]*len(local),'unexpected native STTS')
            for p in local:
                position=epoch+delay+Fraction(p['pts'],rate)
                require(p['pts']==p['dts'] and p['duration']==DELTAS[st],'unexpected reordered/variable input')
                require(position==Fraction(counts[st]*DELTAS[st],rate),'native segment source chronology discontinuity')
                global_ticks=position*rate;require(global_ticks.denominator==1,'nonintegral source tick')
                q=dict(p,index=counts[st],pts=int(global_ticks),dts=int(global_ticks),
                       native_segment=segment_index+1,native_index=p['index'],native_pts=p['pts'],
                       native_duration=p['duration'],source_epoch=g.rational(epoch),edit_delay=g.rational(delay))
                rows.append(q);counts[st]+=1
        # Record what the ordinary fixed consumer actually reports for this
        # native segment, without replacing the existing comparison gate.
        expected=[dict(p,pts=p['pts'],dts=p['dts']) for p in rows]
        normal=g.probe(path);ordinary=g.packets(normal,raw)
        baseline=r.comparison(ordinary,expected,normal['streams'],epoch)
        failures=[x for x in baseline['compared_packets'] if not x['same_payload'] or any(
            x[k]['numerator'] for k in ('pts_error','dts_error','duration_error'))]
        report['segments'].append(dict(file=str(path),sha256=n.sha(raw),source_epoch=g.rational(epoch),
            native_consumer_gate=baseline['status'],native_consumer_failures=failures,
            common_epoch_preserved=True,track_counts=dict(Counter(p['stream'] for p in rows))))
        result.extend(rows)
    require(counts==[1920,3003], 'expected complete native session counts')
    result.sort(key=lambda p:(Fraction(p['dts'],RATES[p['stream']]),p['stream']))
    if drop_boundary:
        removed=[p for p in result if p['stream']==1 and p['index']==2815]
        require(len(removed)==1,'boundary AAC injection missing')
        report['injected_missing_packet']=g.public_packet(removed[0])
        result=[p for p in result if p not in removed]
    report['reconstructed_input_packets']=[g.public_packet(p) for p in result]
    # Packet counts, continuity and endpoint are publication prerequisites,
    # never a reason to synthesize one AAC packet or shift later packets.
    for st,rate in enumerate(RATES):
        ps=[p for p in result if p['stream']==st]
        require(all(p['index']==i and p['pts']==i*DELTAS[st] for i,p in enumerate(ps)),
                f'publication preflight rejects missing/discontinuous track {st}')
        require(Fraction(ps[-1]['pts']+ps[-1]['duration'],rate)==END,'unaligned final endpoint')
    return result, configuration


def native_export(packets, configuration, output, report, fail_close=False):
    image=s.life.arm.IMAGE.read_bytes();require(n.sha(image)==s.life.arm.DIGEST,'firmware identity changed')
    require(n.sha(Path(r.__file__).read_bytes())==schedule.ROLLOVER_SHA,'frozen rollover harness changed')
    for name,sha in r.FROZEN.items(): require(digest(ROOT/'scripts'/name)==sha,'frozen dependency changed: '+name)
    # The separate export is bounded by the selected final window. The original
    # event3 recording process and its 60000ms boundary are not changed/replayed.
    export_ms=END*1000;require(export_ms.denominator==1,'nonintegral export bound')
    export_ms=int(export_ms)
    m,track,mux=r.init(image)
    m.put(mux+0x10,export_ms)
    report['native_execution']=dict(recording_limit_ms=60000,final_export_limit_ms=export_ms,
        original_arm_unchanged=True,host_iso_rebuilder_used=False,ffmpeg_mux_used=False,
        model='RAM file, RTOS OS/notification models, one caller-owned synthetic FIFO')
    report['submissions']=[]
    sps,pps=g.avcc(configuration[0]);started=time.monotonic()
    try:
        for ordinal,p in enumerate(packets):
            r.event.load_packet(m,p,sps,pps);m.phase='final_export_samples'
            if p['stream']==0:
                status=m.call(0xa042d0f8,s.MOVIE,track,s.MOVIE+0x350,mux+0x58,s.STREAM,
                              export_ms,0xffffffff,0xffffffff)
            else:
                status=m.call(0xa043173c,s.MOVIE,track+0x90,mux+0x58,s.STREAM,
                              0,export_ms,0xffffffff,0xffffffff)
            report['submissions'].append(dict(stream=p['stream'],source_index=p['index'],status=status))
            require(status==0,f'original final export rejected stream{p["stream"]} index{p["index"]}: {status}')
            if (ordinal+1)%500==0:
                print(json.dumps(dict(phase='original_ARM_final_export',packets=ordinal+1,total=len(packets),
                                     seconds=round(time.monotonic()-started,2))),flush=True)
        require([m.get(track+0x10),m.get(track+0xa0)]==[1920,3003],'native counters differ from complete session')
        m.phase='final_export_Close0'
        if fail_close: m.short_write_at=len(m.writes)
        status=m.call(0xa03fe300,mux,0)
        report['native_execution']['close_status']=status
        require(status==0,'native final Close0 failed')
        require(not m.index_events,'mock index operation used')
        return bytes(m.output)
    finally:
        # A native close/write assertion leaves the bytes pending and all
        # original sealed segments untouched. Publication happens later.
        (output/'session.pending.mp4').write_bytes(m.output)
        report['native_execution'].update(original_calls=m.transitions,native_calls=dict(Counter(
            c['entry'] for c in m.native_calls)),diagnostics=m.logs,external_events=m.external,
            index_mock_events=m.index_events,file_writes=len(m.writes),elapsed_seconds=time.monotonic()-started)


def validate_candidate(pending, expected, report, output):
    raw=pending.read_bytes();probe=g.probe(pending);actual=g.packets(probe,raw)
    # Unmodified existing gate, ordinary edit-list-aware consumer. No tolerance,
    # guessed duration, ignore_editlist, packet filtering or source substitution.
    retained=r.comparison(actual,expected,probe['streams'],Fraction())
    report['strict_native_input_packet_time_gate']=retained
    require(retained['status']=='pass','ordinary consumer rejects ARM final output')
    # Open intact source only after native mux output is fully written.
    source=r.minute.SOURCE;source_raw=source.read_bytes()
    require(n.sha(source_raw)==r.minute.SOURCE_SHA,'independent oracle identity changed')
    oracle=g.select_window(g.packets(g.probe(source),source_raw),Fraction(),END)
    report['source_used_as_mux_input']=False
    report['strict_original_source_gate']=g.exact_gate(actual,oracle,probe['streams'],Fraction())
    require(report['strict_original_source_gate']['status']=='pass','source oracle strict gate rejected')
    boxed=g.container_timeline(raw);report['output_container']=boxed
    require([t['edit_list'] for t in boxed['tracks']]==[
        [dict(duration=1921920,media_time=0,media_rate=65536)],
        [dict(duration=1921920,media_time=0,media_rate=65536)]], 'unexpected nonzero native edit origin')
    frames=g.frame_hashes(pending);reference=output/'expected-retained.aac'
    reference.write_bytes(b''.join(g.adts(p['data']) for p in expected if p['stream']==1))
    pcm=g.pcm(pending);expected_pcm=g.pcm(reference,True)
    report['decode']=dict(video_frames=len(frames),video_matches_source=frames==g.frame_hashes(source,1920),
        audio_pcm_bytes=len(pcm),audio_pcm_sha256=n.sha(pcm),audio_matches_all_retained_packets=pcm==expected_pcm)
    require(report['decode']['video_matches_source'] and pcm==expected_pcm,'strict decode comparison failed')
    report['output_packets']=[dict(g.public_packet(p),source_index=old['index'],
        original_segment=old['native_segment'],original_native_index=old['native_index'])
        for st in (0,1) for p,old in zip([x for x in actual if x['stream']==st],[x for x in expected if x['stream']==st])]
    report['output_sha256']=n.sha(raw)
    report['output_bytes']=len(raw)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,default=DEFAULT_INPUT)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--drop-boundary-aac',action='store_true')
    parser.add_argument('--fail-close',action='store_true')
    args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    report=dict(schema=1,status='running',offline_only=True,device_access=False,
        script_sha256=digest(__file__),firmware_sha256=s.life.arm.DIGEST,
        selection=dict(start=g.rational(Fraction()),end=g.rational(END)),
        injection=dict(drop_boundary_aac=args.drop_boundary_aac,fail_close=args.fail_close),
        limitations=['Original 60000ms independent event3 second segment consumer gate remains rejected.',
            'This is a separate original-ARM final export after sealed segment closure, not a live camera recording.',
            'Epochs are caller receipts; MP4 alone does not authenticate the source epoch.',
            'Only archived zero-origin 1080p29.97 I/P and 48kHz stereo AAC exact common endpoint supported.',
            'No encoder/DMA/callback installation/real concurrent queue/SD throughput or physical durability proof.'])
    try:
        packets,configuration=load_segments(args.input,report,args.drop_boundary_aac)
        native_export(packets,configuration,args.output,report,args.fail_close)
        validate_candidate(args.output/'session.pending.mp4',packets,report,args.output)
        (args.output/'session.pending.mp4').rename(args.output/'session.mp4')
        report['status']='pass_original_arm_final_export_from_native_event3_segments'
    except Exception as error:
        report.update(status='rejected_inputs_and_pending_retained',error=str(error),traceback=traceback.format_exc())
        report['published']=False
    else: report['published']=True
    finally:
        report['input_hashes_unchanged']=all(digest(x['path'])==x['sha256'] for x in report.get('inputs',[]))
        (args.output/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:report.get(k) for k in ('status','error','published','input_hashes_unchanged')}),flush=True)
    return 0 if report['published'] else 2

if __name__=='__main__': raise SystemExit(main())
