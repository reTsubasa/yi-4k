#!/usr/bin/env python3
"""Offline compact nonzero window: correct SPS geometry, stock ARM edits, explicit consumer results.

AVFoundation acceptance never erases the unchanged ffprobe6.1 rejection.
No device access, instruction patch, fabricated packet, media-byte rewrite or
per-track timestamp normalization occurs.
"""
import argparse
from fractions import Fraction
import json
from pathlib import Path
import subprocess
import traceback
import export_prerecord_native_window as window
import prerecord_native_window_sps as sps_parser
base,r,g,n,s=window.base,window.r,window.g,window.n,window.s
ROOT=base.ROOT
SWIFT=ROOT/'scripts/audit_prerecord_native_window_avfoundation.swift'

def reader(binary,path,output,decode=False):
    argv=[str(binary),str(path),str(output)]+(['decode'] if decode else [])
    run=subprocess.run(argv,capture_output=True,text=True)
    if run.returncode:raise RuntimeError('AVFoundation reader failed: '+run.stdout+run.stderr)
    return json.loads(output.read_text())

def avf_packets(report):
    actual=[]
    for st,track in enumerate(report['tracks']):
        base.require(track['type']==('vide','soun')[st],'AVFoundation track order changed')
        rate=window.RATES[st]
        for p in track['packets']:
            q=dict(stream=st,index=p['index'],bytes=p['bytes'],sha256=p['sha256'])
            for field in ('pts','dts','duration'):
                t=p[field];base.require(t['valid'] and t['numeric'] and t['timescale']>0,'consumer timing unavailable')
                value=Fraction(t['value'],t['timescale'])*rate
                base.require(value.denominator==1,'consumer timing not integral in native clock')
                q[field]=int(value)
            actual.append(q)
    return actual

def native_geometry(configuration,packets,report,invalid=False):
    sps,pps=g.avcc(configuration[0])
    parsed=sps_parser.geometry(sps[:5] if invalid else sps)
    for p in packets:
        if p['stream']==0 and p['key']:
            for nal in g.split_nals(p['data']):
                if nal[0]&31==7:base.require(nal==sps,'in-band SPS epoch changed')
                if nal[0]&31==8:base.require(nal==pps,'in-band PPS epoch changed')
    report['geometry']=dict(parsed,sps_sha256=n.sha(sps),source='SPS from hash-verified sealed native AVCDecoderConfigurationRecord',
        native_fields=dict(width='video_track+0x74 (u16)',height='video_track+0x76 (u16)'),
        instruction_consumers=['0xa0432230 MINF/AVC1 initializer','0xa04331f4 MOOV/TKHD initializer'])
    return parsed

def export(selected,configuration,origin,geometry,out,report,fail_close):
    original_init=r.init
    def configured_init(image,*args,**kwargs):
        m,track,mux=original_init(image,*args,**kwargs)
        before=[m.get(track+0x74,2),m.get(track+0x76,2)]
        m.put(track+0x74,geometry['width'],2);m.put(track+0x76,geometry['height'],2)
        report['geometry']['native_configuration']=dict(before=before,after=[m.get(track+0x74,2),m.get(track+0x76,2)],
            moment='after original Open, before samples and original final metadata construction')
        return m,track,mux
    r.init=configured_init
    try:window.native_export(selected,configuration,origin,out,report,adapt=False,fail_close=fail_close)
    finally:r.init=original_init
    base.require(not report['native_execution']['caller_metadata_adapter'],'compact output unexpectedly used origin adapter')

def validate(pending,selected,origin,out,report,binary):
    raw=pending.read_bytes();legacy_probe=g.probe(pending);legacy=g.packets(legacy_probe,raw)
    legacy_gate=r.comparison(legacy,selected,legacy_probe['streams'],origin)
    report['ordinary_ffprobe61_gate']=legacy_gate
    report['ffprobe61_rejection_retained']=legacy_gate['status']=='reject'
    report['container']=g.container_timeline(raw)
    readback=reader(binary,pending,out/'avfoundation-packets.json')
    actual=avf_packets(readback);streams=[dict(time_base='1/'+str(rate)) for rate in window.RATES]
    gate=r.comparison(actual,selected,streams,origin);report['ordinary_avfoundation_gate']=gate
    base.require(gate['status']=='pass','AVFoundation strict retained-packet gate rejected')
    # Archive opens as independent oracle only after ARM writes candidate.
    source=r.minute.SOURCE;source_raw=source.read_bytes();base.require(n.sha(source_raw)==r.minute.SOURCE_SHA,'oracle identity changed')
    wanted={(p['stream'],p['index']) for p in selected}
    oracle=[p for p in g.packets(g.probe(source),source_raw) if (p['stream'],p['index']) in wanted]
    report['source_used_as_mux_input']=False
    report['strict_original_source_gate']=g.exact_gate(actual,oracle,streams,origin)
    base.require(report['strict_original_source_gate']['status']=='pass','AVFoundation source-oracle gate rejected')
    first=next(p['index'] for p in selected if p['stream']==0);count=sum(p['stream']==0 for p in selected)
    # Two decoder implementations must consume the full compact movie.
    decoded=reader(binary,pending,out/'avfoundation-decode.json',True)
    decoded_source=reader(binary,source,out/'source-avfoundation-decode.json',True)
    target_video=[p['sha256'] for p in decoded['tracks'][0]['packets']]
    source_video=[p['sha256'] for p in decoded_source['tracks'][0]['packets']][first:first+count]
    expected_audio_frames=sum(p['duration'] for p in selected if p['stream']==1)
    avf_audio=decoded['tracks'][1]
    base.require(target_video==source_video and len(target_video)==count,'AVFoundation full decoded video differs')
    base.require(avf_audio['decodedAudioFrames']==expected_audio_frames and avf_audio['pcmBytes']==expected_audio_frames*4,
        'AVFoundation full audio decode lost frames')
    reference=out/'expected-retained.aac';reference.write_bytes(b''.join(g.adts(p['data']) for p in selected if p['stream']==1))
    pcm=g.pcm(pending);expected_pcm=g.pcm(reference,True)
    frames=g.frame_hashes(pending)
    base.require(frames==g.frame_hashes(source,first+count)[first:first+count] and pcm==expected_pcm,'FFmpeg full retained decode mismatch')
    report['decode']=dict(avfoundation_video_frames=len(target_video),avfoundation_video_matches_source=True,
        avfoundation_audio_frames=avf_audio['decodedAudioFrames'],avfoundation_audio_pcm_bytes=avf_audio['pcmBytes'],
        ffmpeg_video_frames=len(frames),ffmpeg_video_matches_source=True,ffmpeg_audio_matches_whole_aac=True,
        ffmpeg_pcm_sha256=n.sha(pcm),ffmpeg_pcm_bytes=len(pcm))
    report['presentation']=dict(common_source_offset=g.rational(origin),leading_empty_duration=g.rational(Fraction()),
        first_pts=[g.rational(Fraction(next(p['pts'] for p in actual if p['stream']==st),window.RATES[st])) for st in (0,1)],
        phase=g.rational(Fraction(next(p['pts'] for p in actual if p['stream']==0),30000)-Fraction(next(p['pts'] for p in actual if p['stream']==1),48000)))
    report['output_sha256']=n.sha(raw);report['output_bytes']=len(raw)
    report['consumer']=dict(name=readback['consumer'],os=readback['os'],reader_source_sha256=base.digest(SWIFT),
        reader_binary_sha256=base.digest(binary),legacy_ffprobe_sha256=base.digest(s.FFPROBE))

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--input',type=Path,default=base.DEFAULT_INPUT);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--start',type=Fraction,default=Fraction(63));p.add_argument('--stop',type=Fraction,default=Fraction(64))
    p.add_argument('--pretrigger',type=Fraction,default=Fraction(60));p.add_argument('--reader',type=Path,required=True)
    p.add_argument('--drop-boundary-aac',action='store_true');p.add_argument('--invalid-sps',action='store_true');p.add_argument('--fail-close',action='store_true')
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    report=dict(schema=1,status='running',offline_only=True,device_access=False,script_sha256=base.digest(__file__),
        dependencies={str(Path(x).relative_to(ROOT)):base.digest(x) for x in (window.__file__,base.__file__,sps_parser.__file__,SWIFT)},
        firmware_sha256=s.life.arm.DIGEST,consumer_policy='AVFoundation exact gate and complete decode; preserve ffprobe6.1 result independently',
        injection=dict(drop_boundary_aac=a.drop_boundary_aac,invalid_sps=a.invalid_sps,fail_close=a.fail_close),
        limitations=['Consumer-specific host candidate, not universal player/Android or real-time camera acceptance.',
            'No metadata-origin adapter, leading presentation padding, media byte rewrite or fabricated sample.',
            'Geometry configuration is supplied from sealed SPS; previous zero-dimension receipts are unchanged.',
            'Fixed ffprobe6.1 compact-window duration rejection remains an explicit compatibility limitation.',
            'Archived progressive I/P H.264 and48kHz AAC only; no encoder/DMA/concurrency/SD or device writes.'])
    try:
        packets,configuration=base.load_segments(a.input,report,a.drop_boundary_aac)
        selected,origin=window.select_window(packets,a.start,a.stop,a.pretrigger,report)
        geometry=native_geometry(configuration,selected,report,a.invalid_sps)
        export(selected,configuration,origin,geometry,a.output,report,a.fail_close)
        validate(a.output/'session.pending.mp4',selected,origin,a.output,report,a.reader.resolve())
        (a.output/'session.pending.mp4').rename(a.output/'compact.avfoundation-reviewed.mp4')
        report.update(status='pass_compact_native_window_avfoundation_legacy_consumer_reported',published=True)
    except Exception as error:report.update(status='rejected_inputs_or_consumer_pending_retained',published=False,error=str(error),traceback=traceback.format_exc())
    finally:
        report['input_hashes_unchanged']=all(base.digest(x['path'])==x['sha256'] for x in report.get('inputs',[]))
        (a.output/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:report.get(k) for k in ('status','error','published','input_hashes_unchanged')}),flush=True)
    return 0 if report['published'] else 2
if __name__=='__main__':raise SystemExit(main())
