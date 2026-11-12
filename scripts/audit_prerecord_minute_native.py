#!/usr/bin/env python3
"""Offline >=60s archived A/V prefix through original ARM MP4 factory/index/writers.

This is an archived-packet replay with modeled RAM file/OS services, not a live
camera, callback, one-minute ring buffer or deployable firmware component.
"""
from __future__ import annotations
import argparse
import ast
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import time
import audit_prerecord_real_gop as g

n=g.native; f=g.factory; s=g.s; ROOT=g.ROOT
SOURCE=ROOT/'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'
SOURCE_SHA='7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c'
FROZEN={
 'audit_prerecord_real_gop.py':'a2b0835d771a1775bf8a60f8ee96c2d110fe7c16e899a855f793f7939ae7f12f',
 **g.FROZEN,
}

# Avoid reading four ARM registers in every inherited hook for instructions
# which none of those hooks observes. This does NOT replace ARM instructions.
# All literal addresses and integer module globals in the entire hook ancestry
# form a conservative superset. A differential small replay checks this filter.
def hook_addresses():
    modules=(g,f,n,s,s.life,s.life.arm)
    addresses=set()
    for module in modules:
        tree=ast.parse(Path(module.__file__).read_text())
        addresses.update(node.value for node in ast.walk(tree)
            if isinstance(node,ast.Constant) and isinstance(node.value,int) and 0x10000000<=node.value<=0xffffffff)
        for value in vars(module).values():
            if isinstance(value,int) and 0x10000000<=value<=0xffffffff:addresses.add(value)
            if isinstance(value,(set,tuple,list)):
                addresses.update(x for x in value if isinstance(x,int) and 0x10000000<=x<=0xffffffff)
    return frozenset(addresses)
HOOKS=hook_addresses()

class MinuteMachine(g.GopMachine):
    def __init__(self,image,filtered=True):
        self.filtered=filtered
        super().__init__(image)
    def hook(self,uc,address,size,user):
        if self.filtered and address not in HOOKS and not 0x11000000<=address<0x14000000:return
        super().hook(uc,address,size,user)

def init_machine(image,sps,pps,filtered):
    m=MinuteMachine(image,filtered);track,mem=m.setup_index()
    for i,value in enumerate([1,0,0,s.MOVIE,0x709,2]):m.put(f.CFG+i*4,value)
    m.uc.mem_write(f.NAME,b'offline.mp4\0'+bytes(52));assert m.call(0xA03E3C48,f.CFG)==0
    assert m.call(0xA03E3F00,f.NAME,s.RESULT)==0
    m.put(s.CONFIG+0xC,0);m.put(s.CONFIG+0x34+0xC,0)
    assert m.call(0xA0440CD4,s.MOVIE,s.CONFIG)==0
    assert m.get(track+4)==m.get(track+0x94)==240000
    assert [m.get(track+0x20,8),m.get(track+0xB0,8)]==[0,0]
    assert m.call(0xA03FECCC,f.MUXCFG)==0
    for off,value in [(0,s.STREAM),(4,mem),(8,2)]:m.put(f.MUXCFG+off,value)
    assert m.call(0xA03FED44,f.MUXCFG,s.RESULT)==0;mux=m.get(s.RESULT)
    m.put(mux+4,s.MOVIE);m.put(mux+0x10,60000)
    index=mux+0x58;m.output=bytearray();m.position=0;m.writes=[]
    assert m.call(0xA03FE468,mux)==0
    return m,track,mux,index

def replay(image,selected,sps,pps,filtered=True,progress=False):
    m,track,mux,index=init_machine(image,sps,pps,filtered)
    started=time.monotonic();recorded=[];maximum=0
    for ordinal,packet in enumerate(selected):
        data=packet['data'];video=packet['stream']==0
        if video:
            data=b''.join(b'\0\0\0\1'+nal for nal in g.split_nals(data))
            if packet['key']:data=b'\0\0\0\1'+sps+b'\0\0\0\1'+pps+data
        maximum=max(maximum,len(data))
        m.descriptor(data,m.payload(data,32),1 if video and packet['key'] else 3 if video else 8,packet['pts'])
        status=m.call(0xA042D0F8,s.MOVIE,track,s.PARAMS,index,s.STREAM,60000,0xffffffff,0xffffffff) if video else m.call(
            0xA043173C,s.MOVIE,track+0x90,index,s.STREAM,0,60000,0xffffffff,0xffffffff)
        assert status==0,(ordinal,g.public_packet(packet),status,m.logs[-3:])
        recorded.append((packet['stream'],packet['index'],status))
        if progress and (ordinal+1)%250==0:
            print(json.dumps({'packets_processed':ordinal+1,'total':len(selected),'seconds':round(time.monotonic()-started,2),'media_bytes':len(m.output)}),flush=True)
    counts=[m.get(track+0x10),m.get(track+0xA0)]
    assert counts==[sum(p['stream']==st for p in selected) for st in (0,1)]
    assert m.call(0xA03FE300,mux,0)==0
    assert not m.index_events and m.get(mux+0xF80,1)==0 and m.get(n.MEMOBJ+0x38)==0
    return m,dict(submitted_counts=counts,closed=f.state(m,track,mux),elapsed_seconds=time.monotonic()-started,
        max_adapted_payload_bytes=maximum,descriptor_count=len(recorded),actual_native_calls=dict(Counter(c['entry'] for c in m.native_calls)),
        modeled_os_events=len(m.os_events),modeled_file_writes=len(m.writes),mock_index_events=len(m.index_events))

def summarize(m):
    return dict(output_sha256=n.sha(m.output),bytes=len(m.output),added=m.added,index_reads=m.index_reads,index_writes=m.index_writes,
        native_calls=m.native_calls,diagnostics=m.logs,stream_events=m.stream_events,allocations=m.allocations,frees=m.frees)

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output','--output-dir',required=True,type=Path)
    ap.add_argument('--video-frames',type=int,default=1920,choices=(8,1920),help='8 is a calibration only; 1920 is 64.064s')
    args=ap.parse_args();out=args.output;out.mkdir(parents=True,exist_ok=False)
    for name,digest in FROZEN.items():assert n.sha((ROOT/'scripts'/name).read_bytes())==digest
    image=s.life.arm.IMAGE.read_bytes();assert n.sha(image)==s.life.arm.DIGEST
    raw=SOURCE.read_bytes();assert n.sha(raw)==SOURCE_SHA
    source=g.probe(SOURCE);all_packets=g.packets(source,raw)
    assert [x['time_base'] for x in source['streams']]==['1/30000','1/48000']
    assert g.extradata(source['streams'][1]['extradata'])==bytes.fromhex('1190000000')
    sps,pps=g.avcc(g.extradata(source['streams'][0]['extradata']))
    classifications=[]
    for p in all_packets:
        if p['stream']==0:
            kinds=[g.slice_type(nal)['picture_type'] for nal in g.split_nals(p['data']) if nal[0]&31 in (1,5)]
            assert len(kinds)==1;classifications+=kinds
    assert set(classifications)<={'I','P'}
    calibration=g.select_window(all_packets,Fraction(0),Fraction(8008,30000))
    slow,_=replay(image,calibration,sps,pps,False)
    fast,_=replay(image,calibration,sps,pps,True)
    assert summarize(slow)==summarize(fast)
    differential=dict(video_frames=8,packet_count=len(calibration),same_firmware_output_and_all_inherited_events=True,
        output_sha256=n.sha(fast.output),filtered_hook_address_count=len(HOOKS),filter_addresses=[hex(v) for v in sorted(HOOKS)])
    del slow,fast
    end=Fraction(args.video_frames*1001,30000)
    selected=g.select_window(all_packets,Fraction(0),end)
    selected_indices={st:{p['index'] for p in selected if p['stream']==st} for st in (0,1)}
    omitted=[g.public_packet(p) for p in all_packets if Fraction(p['pts'],30000 if p['stream']==0 else 48000)<end and p['index'] not in selected_indices[p['stream']]]
    if args.video_frames==1920:assert not omitted
    m,execution=replay(image,selected,sps,pps,True,True)
    path=out/'native-prefix.mp4';path.write_bytes(m.output)
    output=g.probe(path);actual=g.packets(output,bytes(m.output))
    gate=g.exact_gate(actual,selected,output['streams'],Fraction(0));assert gate['status']=='pass'
    boxed=g.container_timeline(bytes(m.output))
    assert boxed['movie_clock']==30000
    for stream,rate in [(0,30000),(1,48000)]:
        timing=boxed['tracks'][stream]
        expected=[p for p in selected if p['stream']==stream]
        assert [Fraction(t,timing['media_clock']) for t in timing['stts_durations']]==[Fraction(p['duration'],rate) for p in expected]
    expected_video=g.frame_hashes(SOURCE,args.video_frames);observed_video=g.frame_hashes(path)
    assert observed_video==expected_video
    # Compare a continuous decoder sequence against the identical raw AAC
    # packets, not independent per-GOP decoders or repeated first-frame fixtures.
    audio=[p for p in selected if p['stream']==1]
    adts_path=out/'reference-audio.aac';adts_path.write_bytes(b''.join(g.adts(p['data']) for p in audio))
    expected_pcm=g.pcm(adts_path,True);observed_pcm=g.pcm(path)
    assert observed_pcm==expected_pcm
    assert len(observed_pcm)==len(audio)*1024*2*2
    assert execution['submitted_counts']==[len(expected_video),len(audio)]
    report=dict(scope='original ARM factory/index/Open/ProcessVideo/ProcessAudio/Close0; RAM file/OS models; archived normal camera recording, not on-camera prerecord',
        source=dict(path=str(SOURCE.relative_to(ROOT)),sha256=SOURCE_SHA,video_picture_types=dict(Counter(classifications))),
        firmware_sha256=s.life.arm.DIGEST,harness_sha256=FROZEN,script_sha256=n.sha(Path(__file__).read_bytes()),
        mode='minute_prefix' if args.video_frames==1920 else 'calibration_only',
        simulated_trigger_seconds=60 if args.video_frames==1920 else None,stop_time=g.rational(end),
        history_at_simulated_trigger_seconds=60 if args.video_frames==1920 else None,
        common_endpoint=not omitted,omitted_crossing_packets=omitted,hook_differential=differential,
        execution=execution,output=dict(file=path.name,bytes=path.stat().st_size,sha256=n.sha(m.output),
        counts={str(st):sum(p['stream']==st for p in actual) for st in (0,1)},container=boxed,strict_packet_and_time_gate=gate),
        decode=dict(ffmpeg_xerror=True,video_frames=len(observed_video),video_frame_md5=observed_video,video_matches_archived_prefix=True,
        audio_pcm_bytes=len(observed_pcm),audio_pcm_sha256=n.sha(observed_pcm),audio_matches_continuous_selected_aac_decoder=True),
        limitations=['Only 1080p29.97 I/P and 48kHz stereo AAC from one archived recording.',
        'The zero-origin 64.064s endpoint is an exact video/AAC common endpoint; arbitrary trigger/cut boundaries remain unproved.',
        'This does not install a callback, preserve a live one-minute history, prove owned queue/SD throughput or bind voice/shutter.',
        'RAM stream and OS models do not establish physical SD persistence, power-loss recovery or real-time performance.',
        'Continuous ADTS reference proves selected compressed sequence decoding, not original hardware AAC capture epoch.'])
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(output=str(out),counts=report['output']['counts'],strict_gate=gate['status'],duration_seconds=float(end),elapsed_seconds=execution['elapsed_seconds'])),flush=True)
if __name__=='__main__':main()
