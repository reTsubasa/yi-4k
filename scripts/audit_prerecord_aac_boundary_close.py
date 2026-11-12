#!/usr/bin/env python3
"""Offline start-assigned AAC boundary packets versus original Close/Trim."""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path
import audit_prerecord_real_gop as gop

n=gop.native
f=gop.factory
s=gop.s
ROOT=gop.ROOT
OUT=ROOT/'artifacts/device/2026-11-11-prerecord-aac-boundary-close'
GOP_SHA='a2b0835d771a1775bf8a60f8ee96c2d110fe7c16e899a855f793f7939ae7f12f'
TRIM=0xA0435F64
CALLERS={0xA0442880:0,0xA044195C:0x40,0xA0442674:0x40,0xA0442BAC:0x40,0xA0441550:0x80}

class BoundaryMachine(gop.GopMachine):
    def __init__(self,image):
        super().__init__(image)
        self.trim_calls=[]
    def hook(self,uc,address,size,user):
        if address==TRIM:self.trim_calls.append(dict(phase=self.phase,entry=hex(address)))
        super().hook(uc,address,size,user)

def pins(image):
    result=[];wanted=set(CALLERS)|{TRIM,0xA03FE300,0xA0436004}
    for fn in json.loads((s.SRC.parent/'functions.json').read_text()):
        if int(fn['entry'],16) not in wanted:continue
        body=b''
        for span in fn['body_ranges']:
            lo,hi=[int(v,16) for v in span.split('-')]
            body+=image[lo-0xA0100000:hi-0xA0100000+1]
        source=s.SRC.parent/fn['decompiled_file']
        result.append(dict(entry=fn['entry'],ranges=fn['body_ranges'],arm_sha256=n.sha(body),
            source=str(source.relative_to(ROOT)),source_sha256=n.sha(source.read_bytes())))
    assert len(result)==len(wanted)
    return result

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output','--output-dir',type=Path,default=OUT)
    out=parser.parse_args().output;out.mkdir(parents=True,exist_ok=True)
    assert n.sha(Path(gop.__file__).read_bytes())==GOP_SHA
    for name,digest in gop.FROZEN.items():assert n.sha((ROOT/'scripts'/name).read_bytes())==digest
    image=s.life.arm.IMAGE.read_bytes();assert n.sha(image)==s.life.arm.DIGEST
    raw=s.SAMPLE_MP4.read_bytes();assert n.sha(raw)==gop.SOURCE_SHA
    source_probe=gop.probe(s.SAMPLE_MP4);packets=gop.packets(source_probe,raw)
    sps,pps=gop.avcc(gop.extradata(source_probe['streams'][0]['extradata']))
    windows=[(Fraction(0),Fraction(8008,30000)),(Fraction(8008,30000),Fraction(16016,30000))]
    selections=[]
    for start,end in windows:
        chosen=[p for p in packets if start<=Fraction(p['pts'],30000 if p['stream']==0 else 48000)<end]
        assert [sum(p['stream']==st for p in chosen) for st in (0,1)]==[8,13]
        selections.append(chosen)
    reference_video=gop.frame_hashes(s.SAMPLE_MP4,16)
    cases=[]
    for mode in (0,1):
        m=BoundaryMachine(image);track,mem=m.setup_index()
        for i,value in enumerate([1,0,0,s.MOVIE,0x709,2]):m.put(f.CFG+i*4,value)
        m.uc.mem_write(f.NAME,b'offline.mp4\0'+bytes(52));assert m.call(0xA03E3C48,f.CFG)==0
        mux=None;segments=[];emitted_audio=[];emitted_video=[]
        for number,((start,end),chosen) in enumerate(zip(windows,selections),1):
            m.phase=f'close_{mode}_segment_{number}'
            if number==2:assert m.call(0xA03E40C8,s.MOVIE,1)==0
            assert m.call(0xA03E3F00,f.NAME,s.RESULT)==0
            videos=[p for p in chosen if p['stream']==0];audios=[p for p in chosen if p['stream']==1]
            video_ms=round(Fraction(videos[0]['pts']*1000,30000));audio_ms=round(Fraction(audios[0]['pts']*1000,48000))
            m.put(s.CONFIG+0xC,video_ms);m.put(s.CONFIG+0x34+0xC,audio_ms)
            assert m.call(0xA0440CD4,s.MOVIE,s.CONFIG)==0
            before=[m.get(track+0x20,8),m.get(track+0xB0,8)]
            assert before==[videos[0]['pts']*8,audios[0]['pts']*5]
            m.put(track+0x58,videos[0]['pts'],8)
            m.descriptor(videos[0]['data'],m.payload(videos[0]['data'],32),1,videos[0]['pts'])
            assert m.call(0xA01F3124,s.MOVIE)==0
            after=[m.get(track+0x20,8),m.get(track+0xB0,8)]
            assert after==([0,0] if number==1 else [0,2496])
            if mux is None:
                assert m.call(0xA03FECCC,f.MUXCFG)==0
                for off,value in [(0,s.STREAM),(4,mem),(8,2)]:m.put(f.MUXCFG+off,value)
                assert m.call(0xA03FED44,f.MUXCFG,s.RESULT)==0;mux=m.get(s.RESULT)
                m.put(mux+4,s.MOVIE);m.put(mux+0x10,60000)
            index=mux+0x58;m.output=bytearray();m.position=0;m.writes=[]
            assert m.call(0xA03FE468,mux)==0
            add_start=len(m.added)
            for packet in chosen:
                data=packet['data'];is_video=packet['stream']==0
                if is_video:
                    data=b''.join(b'\0\0\0\1'+nal for nal in gop.split_nals(data))
                    if packet['key']:data=b'\0\0\0\1'+sps+b'\0\0\0\1'+pps+data
                kind=1 if is_video and packet['key'] else 3 if is_video else 8
                m.descriptor(data,m.payload(data,32),kind,packet['pts'])
                status=m.call(0xA042D0F8,s.MOVIE,track,s.PARAMS,index,s.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF) if is_video else m.call(
                    0xA043173C,s.MOVIE,track+0x90,index,s.STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)
                assert status==0
            submitted=[m.get(track+0x10),m.get(track+0xA0)];assert submitted==[8,13]
            # The original Add records identify even a tail packet subsequently
            # removed from the MP4 tables by Trim.
            audio_offsets=[int(e['data_hex'],16) for e in m.added[add_start:] if e['track']==1 and e['kind']==9]
            assert len(audio_offsets)==13
            tail_before=bytes(m.output[audio_offsets[-1]:audio_offsets[-1]+audios[-1]['bytes']])
            assert tail_before==audios[-1]['data']
            trim_before=len(m.trim_calls)
            assert m.call(0xA03FE300,mux,mode)==0
            trim_count=len(m.trim_calls)-trim_before
            assert trim_count==(1 if mode==0 else 0)
            assert not m.index_events
            path=out/f'assign-start-close{mode}-{number}.mp4';path.write_bytes(m.output)
            probe=gop.probe(path);actual=gop.packets(probe,bytes(m.output))
            actual_video=[p for p in actual if p['stream']==0];actual_audio=[p for p in actual if p['stream']==1]
            expected_audio=audios[:12] if mode==0 else audios
            assert len(actual_audio)==len(expected_audio)
            assert [p['sha256'] for p in actual_video]==[p['sha256'] for p in videos]
            assert [p['sha256'] for p in actual_audio]==[p['sha256'] for p in expected_audio]
            emitted_audio.extend(p['index'] for p in expected_audio);emitted_video.extend(p['index'] for p in videos)
            removed=audios[len(expected_audio):]
            unindexed=[]
            for packet in removed:
                offset=audio_offsets[audios.index(packet)]
                after_bytes=bytes(m.output[offset:offset+packet['bytes']])
                unindexed.append(dict(source_index=packet['index'],file_offset=offset,bytes=packet['bytes'],sha256=packet['sha256'],
                    exact_payload_present_before_close=True,exact_payload_retained_at_offset_after_close=after_bytes==packet['data'],
                    bytes_after_close_prefix_hex=after_bytes[:16].hex()))
            # Strict ffprobe timeline comparison remains unchanged. Mode0's
            # coverage failure is additional to the old second-segment timing rejection.
            selected_emitted=[p for p in chosen if p['stream']==0 or p in expected_audio]
            gate=gop.exact_gate(actual,selected_emitted,probe['streams'],start)
            assert gate['status']==('pass' if number==1 else 'reject')
            boxed=gop.container_timeline(bytes(m.output))
            assert boxed['movie_clock']==30000
            assert boxed['tracks'][1]['stts_durations']==[1024]*len(expected_audio)
            delay=boxed['tracks'][1]['delay'];assert Fraction(delay['numerator'],delay['denominator'])==Fraction(audios[0]['pts'],48000)-start
            decoded_video=gop.frame_hashes(path);assert decoded_video==reference_video[(number-1)*8:number*8]
            adts_path=out/f'expected-close{mode}-{number}.aac'
            adts_path.write_bytes(b''.join(gop.adts(p['data']) for p in expected_audio))
            baseline_pcm=gop.pcm(adts_path,True);decoded_pcm=gop.pcm(path)
            assert decoded_pcm==baseline_pcm and len(decoded_pcm)==len(expected_audio)*4096
            segments.append(dict(segment=number,file=path.name,bytes=len(m.output),sha256=n.sha(m.output),
                initial_dts=before,reset_dts=after,submitted_counts=submitted,output_counts=[len(actual_video),len(actual_audio)],
                source_indices_submitted={str(st):[p['index'] for p in chosen if p['stream']==st] for st in (0,1)},
                source_audio_indices_emitted=[p['index'] for p in expected_audio],
                trim_calls=trim_count,removed_samples=unindexed,
                container=boxed,strict_consumer_timeline_gate=gate,video_md5=decoded_video,
                video_matches_source=True,audio_pcm_bytes=len(decoded_pcm),audio_pcm_sha256=n.sha(decoded_pcm),
                audio_matches_independent_selected_sequence=True,
                closed=f.state(m,track,mux)))
        expected_indices=[p['index'] for window in selections for p in window if p['stream']==1]
        counts=Counter(emitted_audio)
        missing=[i for i in expected_indices if counts[i]==0];duplicates=[i for i,n_ in counts.items() if n_!=1]
        assert emitted_video==list(range(16)) and expected_indices==list(range(26))
        assert missing==([12,25] if mode==0 else []) and not duplicates
        cases.append(dict(close_mode=mode,mode_provenance='observed normal end caller uses0' if mode==0 else 'unknown nonzero value; offline branch experiment only',
            original_trim_called=mode==0,segments=segments,combined_video_indices=emitted_video,
            combined_audio_indices=emitted_audio,missing_audio_indices=missing,duplicated_audio_indices=duplicates,
            submitted_audio_index_hash_integrity='pass',exported_audio_coverage_gate='reject' if missing or duplicates else 'pass',
            strict_consumer_timeline_gate='reject',camera_integration_gate='reject',
            concatenation_warning='no naive append timing proof; retaining cross-boundary AAC extends first movie beyond its video GOP end'))
    caller_evidence=[]
    for address,value in CALLERS.items():
        path=s.SRC/f'{address:08x}.c'
        lines=[dict(line=i,text=line.strip()) for i,line in enumerate(path.read_text().splitlines(),1)
            if '(code **)' in line and '+ 4)' in line and ('0x'+format(value,'x') if value else ',0)') in line]
        assert lines
        caller_evidence.append(dict(entry=hex(address),observed_mode=value,source=str(path.relative_to(ROOT)),lines=lines))
    report=dict(schema=1,status='pass_expected_rejections_preserved',offline_only=True,
        source=dict(path=str(s.SAMPLE_MP4.relative_to(ROOT)),sha256=gop.SOURCE_SHA),
        frozen_gop_script_sha256=GOP_SHA,frozen_harness_hashes=gop.FROZEN,
        cases=cases,caller_evidence=caller_evidence,function_pins=pins(image),
        caller_search_scope='bounded existing mux pipe sources A0441550/A044195C/A0442674/A0442880/A0442BAC; no claim of all indirect callers',
        nonzero_mode1_official_caller_found=False,
        conclusions=['normal original Close0 trims AAC12 and AAC25 from indexed output despite successful writes; coverage remains rejected',
            'unknown Close1 follows non-Trim branch and keeps26 AAC packets exactly once, but not demonstrated as official camera API',
            'both retain common original reset [0,2496] for second segment and exact312/30000s ELST; strict ffprobe timing rejection unchanged',
            'all emitted packet payloads and complete decoded video/AAC selected-sequence outputs match independent baselines'],
        limits=['no physical device or configuration writes; no real encoder binding, continuous decoder overlap or naive concatenation proof',
            'Close1 experiment is unsupported value observation only, never a deployment or real-device recommendation'])
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status=report['status'],close0_coverage='reject',unknown_close1_coverage='pass_offline_only',
        consumer_timeline='reject',camera_integration='reject',output=str(out))))

if __name__=='__main__':main()
