#!/usr/bin/env python3
"""Offline compact nonzero window: correct SPS geometry, stock ARM edits, explicit consumer results.

FFmpeg8 acceptance never erases ffprobe6.1 or AVFoundation compatibility controls.
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
                t=p['output_'+field];base.require(t['valid'] and t['numeric'] and t['timescale']>0,'consumer timing unavailable')
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

def probe8(path,tool):
    argv=[str(tool),'-v','error']
    result=json.loads(g.run(argv+['-show_streams','-show_data','-of','json',path]))
    result['packets']=json.loads(g.run(argv+['-show_packets','-of','json',path]))['packets']
    return result

def frames8(path,tool,limit=None):
    argv=[str(tool),'-v','error','-xerror','-i',str(path),'-map','0:v:0']
    if limit is not None:argv+=['-frames:v',str(limit)]
    result=g.run(argv+['-f','framemd5','pipe:1']).decode()
    return [line.split(',')[-1].strip() for line in result.splitlines() if not line.startswith('#')]

def pcm8(path,tool,raw_aac=False):
    argv=[str(tool),'-v','error','-xerror','-i',str(path)]+([] if raw_aac else ['-map','0:a:0'])
    return g.run(argv+['-f','s16le','pipe:1'])

def geometry_readback(raw):
    def child(box,kind):return next(b for b in g.box_children(raw,box['offset']+8,box['offset']+box['size']) if b['kind']==kind)
    moov=next(b for b in g.box_children(raw,0,len(raw)) if b['kind']=='moov')
    trak=next(b for b in g.box_children(raw,moov['offset']+8,moov['offset']+moov['size']) if b['kind']=='trak')
    tkhd=child(trak,'tkhd')['payload']
    stsd=child(child(child(child(trak,'mdia'),'minf'),'stbl'),'stsd')['payload']
    base.require(stsd[12:16]==b'avc1','unexpected first sample description')
    return dict(avc1_width=int.from_bytes(stsd[40:42],'big'),avc1_height=int.from_bytes(stsd[42:44],'big'),
        tkhd_width=Fraction(int.from_bytes(tkhd[-8:-4],'big'),65536),tkhd_height=Fraction(int.from_bytes(tkhd[-4:],'big'),65536))

def validate(pending,selected,origin,out,report,binary,probe_tool,decode_tool):
    raw=pending.read_bytes();legacy_probe=g.probe(pending);legacy=g.packets(legacy_probe,raw)
    legacy_gate=r.comparison(legacy,selected,legacy_probe['streams'],origin)
    report['ordinary_ffprobe61_gate']=legacy_gate
    report['ffprobe61_rejection_retained']=legacy_gate['status']=='reject'
    report['container']=g.container_timeline(raw)
    geometry=geometry_readback(raw);width=report['geometry']['width'];height=report['geometry']['height']
    base.require(geometry==dict(avc1_width=width,avc1_height=height,tkhd_width=width,tkhd_height=height),'SPS and serialized track geometry disagree')
    report['geometry']['serialized_readback']={k:int(v) for k,v in geometry.items()}
    observed=probe8(pending,probe_tool);actual=g.packets(observed,raw)
    report['ordinary_ffmpeg8_gate']=r.comparison(actual,selected,observed['streams'],origin)
    base.require(report['ordinary_ffmpeg8_gate']['status']=='pass','FFmpeg8 exact retained-packet gate rejected')
    # Independent oracle opens after original native mux candidate exists.
    source=r.minute.SOURCE;source_raw=source.read_bytes();base.require(n.sha(source_raw)==r.minute.SOURCE_SHA,'oracle identity changed')
    wanted={(p['stream'],p['index']) for p in selected}
    oracle=[p for p in g.packets(g.probe(source),source_raw) if (p['stream'],p['index']) in wanted]
    report['source_used_as_mux_input']=False
    report['strict_original_source_gate']=g.exact_gate(actual,oracle,observed['streams'],origin)
    base.require(report['strict_original_source_gate']['status']=='pass','source-oracle exact gate rejected')
    first=next(p['index'] for p in selected if p['stream']==0);count=sum(p['stream']==0 for p in selected)
    reference=out/'expected-retained.aac';reference.write_bytes(b''.join(g.adts(p['data']) for p in selected if p['stream']==1))
    pcm=pcm8(pending,decode_tool);expected_pcm=pcm8(reference,decode_tool,True)
    frames=frames8(pending,decode_tool)
    base.require(frames==frames8(source,decode_tool,first+count)[first:first+count] and pcm==expected_pcm,'FFmpeg8 complete retained decode mismatch')
    report['decode']=dict(ffmpeg8_video_frames=len(frames),ffmpeg8_video_matches_source=True,ffmpeg8_audio_matches_whole_aac=True,
        ffmpeg8_pcm_sha256=n.sha(pcm),ffmpeg8_pcm_bytes=len(pcm))
    # AVFoundation exposes media and presentation times separately. Its output
    # timing and complete decode stay explicit compatibility controls, never an
    # independently rebased source timeline or a replacement for exact gates.
    readback=reader(binary,pending,out/'avfoundation-packets.json')
    avf=avf_packets(readback);streams=[dict(time_base='1/'+str(rate)) for rate in window.RATES]
    report['ordinary_avfoundation_output_gate']=r.comparison(avf,selected,streams,origin)
    decoded=reader(binary,pending,out/'avfoundation-decode.json',True)
    expected_audio_frames=sum(p['duration'] for p in selected if p['stream']==1)
    avf_audio=decoded['tracks'][1]
    report['avfoundation_decode_control']=dict(video_image_buffers=len(decoded['tracks'][0]['packets']),expected_video_packets=count,
        audio_frames=avf_audio['decodedAudioFrames'],expected_whole_aac_frames=expected_audio_frames,
        audio_frame_difference=avf_audio['decodedAudioFrames']-expected_audio_frames,pcm_bytes=avf_audio['pcmBytes'],
        packet_gate=report['ordinary_avfoundation_output_gate']['status'],
        source_segment_mappings=[t['segments'] for t in readback['tracks']])
    report['presentation']=dict(common_source_offset=g.rational(origin),leading_empty_duration=g.rational(Fraction()),
        first_pts=[g.rational(Fraction(next(p['pts'] for p in actual if p['stream']==st),window.RATES[st])) for st in (0,1)],
        phase=g.rational(Fraction(next(p['pts'] for p in actual if p['stream']==0),30000)-Fraction(next(p['pts'] for p in actual if p['stream']==1),48000)))
    report['output_sha256']=n.sha(raw);report['output_bytes']=len(raw)
    report['consumer']=dict(accepted='FFmpeg/ffprobe8.0 ordinary edit-aware defaults',probe_sha256=base.digest(probe_tool),ffmpeg_sha256=base.digest(decode_tool),
        avfoundation_name=readback['consumer'],os=readback['os'],reader_source_sha256=base.digest(SWIFT),reader_binary_sha256=base.digest(binary),legacy_ffprobe_sha256=base.digest(s.FFPROBE))

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--input',type=Path,default=base.DEFAULT_INPUT);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--start',type=Fraction,default=Fraction(63));p.add_argument('--stop',type=Fraction,default=Fraction(64))
    p.add_argument('--ffprobe8',type=Path,default=ROOT/'.tools/ffmpeg8-host/ffprobe');p.add_argument('--ffmpeg8',type=Path,default=ROOT/'.tools/ffmpeg8-host/ffmpeg')
    p.add_argument('--pretrigger',type=Fraction,default=Fraction(60));p.add_argument('--reader',type=Path,required=True)
    p.add_argument('--drop-boundary-aac',action='store_true');p.add_argument('--invalid-sps',action='store_true');p.add_argument('--fail-close',action='store_true')
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    report=dict(schema=1,status='running',offline_only=True,device_access=False,script_sha256=base.digest(__file__),
        dependencies={str(Path(x).relative_to(ROOT)):base.digest(x) for x in (window.__file__,base.__file__,sps_parser.__file__,SWIFT)},
        firmware_sha256=s.life.arm.DIGEST,consumer_policy='FFmpeg8 exact gate and complete decode; preserve ffprobe6.1 and AVFoundation results independently',
        injection=dict(drop_boundary_aac=a.drop_boundary_aac,invalid_sps=a.invalid_sps,fail_close=a.fail_close),
        limitations=['Consumer-specific FFmpeg8 host candidate; AVFoundation AAC priming and Android/player behavior are separate compatibility results.',
            'No metadata-origin adapter, leading presentation padding, media byte rewrite or fabricated sample.',
            'Geometry configuration is supplied from sealed SPS; previous zero-dimension receipts are unchanged.',
            'Fixed ffprobe6.1 compact-window duration and AVFoundation AAC priming limitations remain explicit controls.',
            'Archived progressive I/P H.264 and 48kHz AAC only; no encoder/DMA/concurrency/SD or device writes.'])
    try:
        packets,configuration=base.load_segments(a.input,report,a.drop_boundary_aac)
        selected,origin=window.select_window(packets,a.start,a.stop,a.pretrigger,report)
        geometry=native_geometry(configuration,selected,report,a.invalid_sps)
        export(selected,configuration,origin,geometry,a.output,report,a.fail_close)
        validate(a.output/'session.pending.mp4',selected,origin,a.output,report,a.reader.resolve(),a.ffprobe8.resolve(),a.ffmpeg8.resolve())
        (a.output/'session.pending.mp4').rename(a.output/'compact.ffmpeg8-reviewed.mp4')
        report.update(status='pass_compact_native_window_ffmpeg8_other_consumer_controls_retained',published=True)
    except Exception as error:report.update(status='rejected_inputs_or_consumer_pending_retained',published=False,error=str(error),traceback=traceback.format_exc())
    finally:
        report['input_hashes_unchanged']=all(base.digest(x['path'])==x['sha256'] for x in report.get('inputs',[]))
        (a.output/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:report.get(k) for k in ('status','error','published','input_hashes_unchanged')}),flush=True)
    return 0 if report['published'] else 2
if __name__=='__main__':raise SystemExit(main())
