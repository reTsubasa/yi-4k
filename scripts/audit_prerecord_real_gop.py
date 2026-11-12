#!/usr/bin/env python3
"""Offline real archived I/P+AAC GOPs through original factory/mux; exact-time gate."""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path
import subprocess
import audit_prerecord_native_mp4 as native
import audit_prerecord_movie_factory as factory

s=native.stock
ROOT=native.ROOT
OUT=ROOT/'artifacts/device/2026-11-11-prerecord-real-gop'
FROZEN={
    'audit_prerecord_native_mp4.py':'3dc7b00032803b6440124e8e6ce7316701a595333365253da935494bf208da99',
    'audit_prerecord_movie_factory.py':'be794e9d19c10c873884d96f20825153f773be4883a181613ba2f7f294388f02',
}
GLOBAL=0xA13C1758
SOURCE_SHA='862da3a4349d9a845333ab29b6afccb5be8a8862ce62d794f3ca758d85bbf79d'
EXTRA_ROOTS={0xA01F3124,0xA01F705C,0xA01F6BE8,0xA01F69B0,0xA01F721C,0xA042CE28,0xA03E5B5C,
             0xA0425E18,0xA04331F4,0xA0433138,0xA043173C}

def run(argv):
    result=subprocess.run(list(map(str,argv)),capture_output=True)
    assert result.returncode==0,(list(map(str,argv)),result.stderr.decode(errors='replace'))
    assert not result.stderr,(list(map(str,argv)),result.stderr.decode(errors='replace'))
    return result.stdout

def rational(value):
    return dict(numerator=value.numerator,denominator=value.denominator,seconds=float(value))

def extradata(text):
    return b''.join(bytes.fromhex(line.split(':',1)[1].split('  ')[0].strip())
        for line in text.splitlines() if ':' in line)

def avcc(blob):
    assert blob[0]==1 and blob[4]&3==3 and blob[5]&31==1
    size=int.from_bytes(blob[6:8],'big');sps=blob[8:8+size];pos=8+size
    assert blob[pos]==1;pos+=1;size=int.from_bytes(blob[pos:pos+2],'big');pos+=2
    pps=blob[pos:pos+size];assert pos+size==len(blob)
    return sps,pps

def split_nals(data):
    pos=0;parts=[]
    while pos<len(data):
        assert pos+4<=len(data)
        size=int.from_bytes(data[pos:pos+4],'big');pos+=4
        assert size>0 and pos+size<=len(data)
        parts.append(data[pos:pos+size]);pos+=size
    assert parts and pos==len(data)
    return parts

def slice_type(nal):
    # Classify only first_mb_in_slice and slice_type; decoder verifies rest.
    rbsp=bytearray();i=1
    while i<len(nal):
        if nal[i:i+3]==b'\0\0\3':rbsp.extend(b'\0\0');i+=3
        else:rbsp.append(nal[i]);i+=1
    bits=''.join(f'{b:08b}' for b in rbsp);position=0
    def ue():
        nonlocal position
        zeros=0
        while bits[position]=='0':position+=1;zeros+=1;assert zeros<32
        position+=1
        value=(1<<zeros)-1+(int(bits[position:position+zeros],2) if zeros else 0)
        position+=zeros
        return value
    first=ue();kind=ue()%5
    return dict(first_mb_in_slice=first,slice_type=kind,picture_type={0:'P',1:'B',2:'I',3:'SP',4:'SI'}[kind])

def probe(path,ignore_edits=False):
    base=[s.FFPROBE,'-v','error']+(['-ignore_editlist','1'] if ignore_edits else [])
    result=json.loads(run(base+['-show_streams','-show_data','-of','json',path]))
    result['packets']=json.loads(run(base+['-show_packets','-of','json',path]))['packets']
    return result

def box_children(data,start,end):
    result=[]
    while start<end:
        assert start+8<=end
        size=int.from_bytes(data[start:start+4],'big');kind=data[start+4:start+8].decode('ascii')
        assert size>=8 and start+size<=end
        result.append(dict(kind=kind,offset=start,size=size,payload=data[start+8:start+size]))
        start+=size
    assert start==end
    return result

def container_timeline(data):
    def child(box,kind):
        return next(x for x in box_children(data,box['offset']+8,box['offset']+box['size']) if x['kind']==kind)
    moov=next(x for x in box_children(data,0,len(data)) if x['kind']=='moov')
    mvhd=child(moov,'mvhd')['payload'];assert mvhd[0]==0
    movie_clock=int.from_bytes(mvhd[12:16],'big');tracks=[]
    for trak in box_children(data,moov['offset']+8,moov['offset']+moov['size']):
        if trak['kind']!='trak':continue
        mdia=child(trak,'mdia');mdhd=child(mdia,'mdhd')['payload'];assert mdhd[0]==0
        media_clock=int.from_bytes(mdhd[12:16],'big')
        elst_box=child(child(trak,'edts'),'elst');elst=elst_box['payload'];assert elst[0]==0
        entries=[]
        for i in range(int.from_bytes(elst[4:8],'big')):
            row=elst[8+i*12:20+i*12]
            entries.append(dict(duration=int.from_bytes(row[:4],'big'),media_time=int.from_bytes(row[4:8],'big',signed=True),
                media_rate=int.from_bytes(row[8:12],'big')))
        stbl=child(child(mdia,'minf'),'stbl');stts_box=child(stbl,'stts');stts=stts_box['payload']
        timing=[]
        for i in range(int.from_bytes(stts[4:8],'big')):
            row=stts[8+i*8:16+i*8];timing.extend([int.from_bytes(row[4:8],'big')]*int.from_bytes(row[:4],'big'))
        delay=sum((Fraction(x['duration'],movie_clock) for x in entries if x['media_time']==-1),Fraction())
        assert all(x['media_time'] in (-1,0) and x['media_rate']==65536 for x in entries)
        tracks.append(dict(media_clock=media_clock,media_duration=int.from_bytes(mdhd[16:20],'big'),
            edit_list=entries,edit_list_hex=data[elst_box['offset']:elst_box['offset']+elst_box['size']].hex(),
            stts_durations=timing,stts_hex=data[stts_box['offset']:stts_box['offset']+stts_box['size']].hex(),
            delay=rational(delay)))
    return dict(movie_clock=movie_clock,tracks=tracks)

def packets(probed,raw):
    counts=Counter();result=[]
    for packet in probed['packets']:
        stream=packet['stream_index'];offset=int(packet['pos']);size=int(packet['size'])
        data=raw[offset:offset+size];assert len(data)==size
        result.append(dict(stream=stream,index=counts[stream],pts=int(packet['pts']),dts=int(packet['dts']),
            duration=int(packet['duration']),offset=offset,bytes=size,sha256=native.sha(data),
            key='K' in packet['flags'],data=data))
        counts[stream]+=1
    return result

def public_packet(packet):
    return {k:v for k,v in packet.items() if k!='data'}

def frame_hashes(path,frames=None):
    args=[s.FFMPEG,'-v','error','-xerror','-i',path,'-map','0:v:0']
    if frames is not None:args+=['-frames:v',str(frames)]
    text=run(args+['-f','framemd5','pipe:1']).decode()
    return [line.split(',')[-1].strip() for line in text.splitlines() if not line.startswith('#')]

def pcm(path,audio_only=False):
    args=[s.FFMPEG,'-v','error','-xerror','-i',path]
    if not audio_only:args+=['-map','0:a:0']
    return run(args+['-f','s16le','pipe:1'])

def adts(packet):
    length=len(packet)+7
    assert length<8192
    return bytes([0xff,0xf1,0x4c,0x80|((length>>11)&3),(length>>3)&255,((length&7)<<5)|31,0xfc])+packet

class GopMachine(factory.FactoryMachine):
    def __init__(self,image):
        super().__init__(image)
        self.uc.mem_map(0xA13C1000,0x1000)
        self.timeline_calls=[]

    def hook(self,uc,address,size,user):
        if address in EXTRA_ROOTS:
            self.timeline_calls.append(dict(entry=hex(address),phase=self.phase))
        super().hook(uc,address,size,user)

def select_window(all_packets,start,end):
    selected=[]
    for packet in all_packets:
        rate=30000 if packet['stream']==0 else 48000
        first=Fraction(packet['pts'],rate);last=Fraction(packet['pts']+packet['duration'],rate)
        if start<=first and last<=end:selected.append(packet)
    return selected

def exact_gate(output_packets,selected,streams,origin):
    rows=[]
    for stream in (0,1):
        actual=[x for x in output_packets if x['stream']==stream]
        expected=[x for x in selected if x['stream']==stream]
        assert len(actual)==len(expected)
        out_tb=Fraction(streams[stream]['time_base']);source_rate=30000 if stream==0 else 48000
        for old,new in zip(expected,actual):
            expected_pts=Fraction(old['pts'],source_rate)-origin
            expected_dts=Fraction(old['dts'],source_rate)-origin
            observed_pts=new['pts']*out_tb;observed_dts=new['dts']*out_tb
            observed_duration=new['duration']*out_tb;expected_duration=Fraction(old['duration'],source_rate)
            rows.append(dict(stream=stream,source_index=old['index'],same_payload=new['sha256']==old['sha256'],
                source_sha256=old['sha256'],output_sha256=new['sha256'],expected_pts=rational(expected_pts),
                observed_pts=rational(observed_pts),pts_error=rational(observed_pts-expected_pts),
                expected_dts=rational(expected_dts),observed_dts=rational(observed_dts),
                dts_error=rational(observed_dts-expected_dts),expected_duration=rational(expected_duration),
                observed_duration=rational(observed_duration),duration_equal=observed_duration==expected_duration,
                pts_equal=observed_pts==expected_pts,dts_equal=observed_dts==expected_dts))
    payload=all(x['same_payload'] for x in rows)
    time=all(x['pts_equal'] and x['dts_equal'] and x['duration_equal'] for x in rows)
    return dict(status='pass' if payload and time else 'reject',payload_equal=payload,exact_timeline_equal=time,
        mismatches=[x for x in rows if not (x['pts_equal'] and x['dts_equal'] and x['duration_equal'])],packets=rows)

def pin_functions(image):
    roots=factory.ROOTS|EXTRA_ROOTS;result=[]
    for f in json.loads((s.SRC.parent/'functions.json').read_text()):
        if int(f['entry'],16) not in roots:continue
        body=b''
        for span in f['body_ranges']:
            low,high=[int(x,16) for x in span.split('-')]
            body+=image[low-0xA0100000:high-0xA0100000+1]
        source=s.SRC.parent/f['decompiled_file']
        result.append(dict(entry=f['entry'],body_ranges=f['body_ranges'],arm_sha256=native.sha(body),
            decompiled_file=str(source.relative_to(ROOT)),decompiled_sha256=native.sha(source.read_bytes())))
    assert len(result)==len(roots)
    return result

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output','--output-dir',type=Path,default=OUT)
    out=parser.parse_args().output;out.mkdir(parents=True,exist_ok=True)
    imported={name:native.sha((ROOT/'scripts'/name).read_bytes()) for name in FROZEN}
    assert imported==FROZEN
    timeline_path=ROOT/'scripts/audit_prerecord_session_timeline.py'
    frozen_timeline_sha=native.sha(timeline_path.read_bytes())
    image=s.life.arm.IMAGE.read_bytes();assert native.sha(image)==s.life.arm.DIGEST
    raw=s.SAMPLE_MP4.read_bytes();assert native.sha(raw)==SOURCE_SHA
    source_probe=probe(s.SAMPLE_MP4);all_packets=packets(source_probe,raw)
    video_stream,audio_stream=source_probe['streams'];assert video_stream['codec_type']=='video' and audio_stream['codec_type']=='audio'
    assert video_stream['time_base']=='1/30000' and audio_stream['time_base']=='1/48000'
    assert int(audio_stream['sample_rate'])==48000 and audio_stream['channels']==2
    sps,pps=avcc(extradata(video_stream['extradata']));asc=extradata(audio_stream['extradata'])
    assert asc==bytes.fromhex('1190000000') and len(sps)<=64 and len(pps)<=64
    windows=[(Fraction(0),Fraction(8008,30000)),(Fraction(8008,30000),Fraction(16016,30000))]
    selected_windows=[select_window(all_packets,*window) for window in windows]
    classifications=[]
    for packet in all_packets:
        if packet['stream']!=0:continue
        nals=split_nals(packet['data']);slices=[slice_type(nal) for nal in nals if nal[0]&31 in (1,5)]
        assert len(slices)==1
        classifications.append(dict(index=packet['index'],nal_types=[n[0]&31 for n in nals],**slices[0]))
    assert Counter(x['picture_type'] for x in classifications)=={'I':11,'P':70}
    source_frames=frame_hashes(s.SAMPLE_MP4,16)
    assert len(source_frames)==16 and len(set(source_frames))==16
    reference_audio=[]
    for number,selected in enumerate(selected_windows,1):
        videos=[p for p in selected if p['stream']==0];audios=[p for p in selected if p['stream']==1]
        assert len(videos)==8 and len(audios)==12 and videos[0]['key']
        assert all(not p['key'] for p in videos[1:])
        adts_path=out/f'selected-audio-{number}.aac';adts_path.write_bytes(b''.join(adts(p['data']) for p in audios))
        decoded=pcm(adts_path,True);assert len(decoded)==12*1024*2*2
        reference_audio.append(decoded)
    cases=[]
    for audio_clock in (48000,240000):
        m=GopMachine(image);track,mem=m.setup_index()
        for i,value in enumerate([1,0,0,s.MOVIE,0x709,2]):m.put(factory.CFG+i*4,value)
        m.uc.mem_write(factory.NAME,b'offline.mp4\0'+bytes(52));m.phase='format_init'
        assert m.call(0xA03E3C48,factory.CFG)==0
        mux=None
        for number,((start,end),selected) in enumerate(zip(windows,selected_windows),1):
            m.phase=f'{audio_clock}_segment_{number}'
            if number==2:assert m.call(0xA03E40C8,s.MOVIE,1)==0
            assert m.call(0xA03E3F00,factory.NAME,s.RESULT)==0 and m.get(s.RESULT)==s.MOVIE
            initial=factory.state(m,track,mux);assert initial['sample_counts']==[0,0]
            videos=[p for p in selected if p['stream']==0];audios=[p for p in selected if p['stream']==1]
            # Construct archived packet start states through original InitMovieInfo.
            # Millisecond inputs are explicitly chosen to round to these known
            # frame/audio boundaries, then checked against exact source ticks.
            video_ms=round(Fraction(videos[0]['pts']*1000,30000))
            audio_ms=round(Fraction(audios[0]['pts']*1000,48000))
            for off,value in [(0xC,video_ms),(0x34+0xC,audio_ms),(0x34+4,audio_clock),
                (0x34+8,1024*audio_clock//48000)]:m.put(s.CONFIG+off,value)
            assert m.call(0xA0440CD4,s.MOVIE,s.CONFIG)==0
            common=m.get(track+4);assert common==m.get(track+0x94)==240000
            before=[m.get(track+0x20,8),m.get(track+0xB0,8)]
            assert before==[videos[0]['pts']*8,audios[0]['pts']*5]
            # A constructed stream-origin binding permits original AdjustDTS
            # to observe the retained first descriptor without changing rate.
            m.put(track+0x58,videos[0]['pts'],8)
            m.descriptor(videos[0]['data'],m.payload(videos[0]['data'],32),1,videos[0]['pts'])
            fifo_before=bytes(m.uc.mem_read(s.life.VIRTUAL,0xD0));queue_before=bytes(m.uc.mem_read(s.life.QUEUE,32))
            assert m.call(0xA01F3124,s.MOVIE)==0
            assert bytes(m.uc.mem_read(s.life.VIRTUAL,0xD0))==fifo_before
            assert bytes(m.uc.mem_read(s.life.QUEUE,32))==queue_before
            after=[m.get(track+0x20,8),m.get(track+0xB0,8)]
            expected=[value-min(before) for value in before];assert after==expected
            assert after[1]-after[0]==before[1]-before[0]
            assert after==([0,0] if number==1 else [0,2496])
            if mux is None:
                assert m.call(0xA03FECCC,factory.MUXCFG)==0
                for off,value in [(0,s.STREAM),(4,mem),(8,2)]:m.put(factory.MUXCFG+off,value)
                assert m.call(0xA03FED44,factory.MUXCFG,s.RESULT)==0;mux=m.get(s.RESULT)
                m.put(mux+4,s.MOVIE);m.put(mux+0x10,60000)
            index=mux+0x58;m.output=bytearray();m.position=0;m.writes=[]
            assert m.call(0xA03FE468,mux)==0
            add_start=len(m.added);recorded=[]
            for packet in selected:
                data=packet['data'];is_video=packet['stream']==0
                if is_video:
                    nals=split_nals(data)
                    adapted=b''.join(b'\0\0\0\1'+nal for nal in nals)
                    if packet['key']:adapted=b'\0\0\0\1'+sps+b'\0\0\0\1'+pps+adapted
                    data=adapted
                # type3 is an explicit caller P mapping for these M=1 packets;
                # the archived MP4 does not carry a camera FrameDesc capture.
                kind=1 if is_video and packet['key'] else 3 if is_video else 8
                m.descriptor(data,m.payload(data,32),kind,packet['pts'])
                status=m.call(0xA042D0F8,s.MOVIE,track,s.PARAMS,index,s.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF) if is_video else m.call(
                    0xA043173C,s.MOVIE,track+0x90,index,s.STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)
                assert status==0,(audio_clock,number,public_packet(packet),status,m.logs[-3:])
                recorded.append(dict(source_stream=packet['stream'],source_index=packet['index'],
                    descriptor_kind=kind,descriptor_pts=packet['pts'],adapted_input_sha256=native.sha(data),status=status))
            for t in (0,1):assert m.call(0xA0411048,index,t)==0
            readback=factory.read_back(m,index,add_start)
            assert m.call(0xA03FE300,mux,0)==0
            assert not m.index_events and m.get(mux+0xF80,1)==0 and m.get(native.MEMOBJ+0x38)==0
            path=out/f'real-gop-{audio_clock}-{number}.mp4';path.write_bytes(m.output)
            output_probe=probe(path);output_packets=packets(output_probe,bytes(m.output))
            gate=exact_gate(output_packets,selected,output_probe['streams'],start)
            assert gate['payload_equal']
            expected_pass=number==1
            assert (gate['status']=='pass')==expected_pass
            if not expected_pass:
                errors={Fraction(row['pts_error']['numerator'],row['pts_error']['denominator']) for row in gate['mismatches']}
                assert errors==({Fraction(-1,240000)} if audio_clock==48000 else {Fraction(0)})
                assert len(gate['mismatches'])==(12 if audio_clock==48000 else 1)
                assert gate['mismatches'][-1]['observed_duration']['seconds']<gate['mismatches'][-1]['expected_duration']['seconds']
            boxed=container_timeline(bytes(m.output));assert boxed['movie_clock']==30000
            for st,source_packets in enumerate((videos,audios)):
                timing=boxed['tracks'][st];clock=timing['media_clock']
                delay=Fraction(timing['delay']['numerator'],timing['delay']['denominator'])
                expected_delay=Fraction(source_packets[0]['pts'],30000 if st==0 else 48000)-start
                assert delay==expected_delay
                assert [Fraction(t,clock) for t in timing['stts_durations']]==[Fraction(p['duration'],30000 if st==0 else 48000) for p in source_packets]
            unedited=probe(path,True)
            unedited_audio=[p for p in unedited['packets'] if p['stream_index']==1]
            assert [Fraction(int(p['duration']))*Fraction(unedited['streams'][1]['time_base']) for p in unedited_audio]==[Fraction(1024,48000)]*12
            decoded_video=frame_hashes(path)
            assert decoded_video==source_frames[(number-1)*8:number*8]
            decoded_audio=pcm(path)
            assert decoded_audio==reference_audio[number-1]
            first_audio=next(p for p in output_packets if p['stream']==1)
            actual_gap=first_audio['pts']*Fraction(output_probe['streams'][1]['time_base'])
            expected_gap=Fraction(audios[0]['pts'],48000)-start
            # Full output probe is retained to audit original edit lists and
            # the exact rational timestamps without relying on rounded strings.
            (out/f'real-gop-{audio_clock}-{number}-probe.json').write_text(json.dumps(output_probe,indent=2)+'\n')
            cases.append(dict(audio_mux_clock=audio_clock,configuration='default_clock' if audio_clock==48000 else 'offline_caller_clock_experiment',
                segment=number,movie=hex(s.MOVIE),memidx=hex(mem),mux=hex(mux),window=[rational(start),rational(end)],
                configured_start_milliseconds=[video_ms,audio_ms],common_track_clock=common,
                before_original_reset_dts=before,after_original_reset_dts=after,
                common_subtrahend=min(before),fifo_unchanged_during_reset=True,global_reset_value=m.get(GLOBAL,8),
                expected_audio_gap=rational(expected_gap),actual_audio_gap=rational(actual_gap),
                file=path.name,bytes=len(m.output),sha256=native.sha(m.output),
                original_container_timeline=boxed,original_container_gap_and_stts_exact=True,
                ignore_editlist_audio_packets=unedited_audio,
                source_packet_indices={str(st):[p['index'] for p in selected if p['stream']==st] for st in (0,1)},
                descriptor_calls=recorded,index_readback=readback,strict_publication_gate=gate,
                decoder=dict(strict_ffmpeg_xerror=True,video_frames=len(decoded_video),video_frame_md5=decoded_video,
                    video_matches_source_frames=True,audio_pcm_bytes=len(decoded_audio),audio_pcm_sha256=native.sha(decoded_audio),
                    audio_matches_independently_adts_wrapped_selected_packets=True),
                native_calls=dict(Counter(c['entry'] for c in m.native_calls)),
                factory_calls=m.factory_calls,timeline_calls=m.timeline_calls,
                original_diagnostics=m.logs,closed=factory.state(m,track,mux)))
    source_window_end=windows[-1][1]
    selected_audio={p['index'] for window in selected_windows for p in window if p['stream']==1}
    omitted=[public_packet(p) for p in all_packets if p['stream']==1 and Fraction(p['pts'],48000)<source_window_end and p['index'] not in selected_audio]
    assert [p['index'] for p in omitted]==[12,25]
    internal_omitted=[p for p in omitted if Fraction(p['pts']+p['duration'],48000)<=source_window_end]
    assert [p['index'] for p in internal_omitted]==[12]
    report=dict(schema=1,status='pass_expected_rejection_preserved',offline_only=True,
        default_exact_timeline_gate='reject',offline_240000_experiment_exact_gate='reject',
        firmware_sha256=native.sha(image),frozen_import_hashes=imported,frozen_timeline_reference_sha256=frozen_timeline_sha,
        source=dict(path=str(s.SAMPLE_MP4.relative_to(ROOT)),sha256=SOURCE_SHA,origin='archived ordinary camera MP4, not encoder FIFO observation',
            video_avcc_hex=extradata(video_stream['extradata']).hex(),audio_asc_hex=asc.hex(),
            declared_has_b_frames=video_stream['has_b_frames'],actual_picture_counts=dict(Counter(x['picture_type'] for x in classifications)),
            pictures=classifications,first_16_decoded_frame_md5=source_frames),
        windows=[dict(start=rational(start),end=rational(end),selected=[public_packet(p) for p in selected])
            for (start,end),selected in zip(windows,selected_windows)],
        cases=cases,function_pins=pin_functions(image),
        audio_boundary=dict(policy='select only complete AAC packets entirely inside each GOP window',
            omitted_source_packets=omitted,internal_boundary_omission=internal_omitted,
            final_window_partial_packet=[p for p in omitted if p not in internal_omitted],continuous_audio_coverage_gate='reject',
            reason='source AAC12 straddles internal GOP boundary and AAC25 straddles final window end; both excluded; no lossless cross-file AAC split claimed',
            pcm_comparison_scope='each selected AAC sequence starts a fresh decoder; does not claim continuous source decoder overlap is preserved'),
        explicit_inputs=['frozen file/OS/FIFO RAM models and original factory execution from prior reports',
            'source avcC SPS/PPS inserted before segment IDR; raw AAC unchanged with explicit 48kHz stereo ASC',
            'known source packet clock, initial per-track starts and video origin binding constructed by caller',
            'P descriptor type3 selected by caller for M=1; not observed live camera FrameDesc',
            '240000 audio mux timebase with 5120 ticks/AAC is an offline caller configuration experiment, sample rate stays48000'],
        limits=['original movie clock is30000; elst empty312/30000s is exact, default ffprobe audio clock48000 quantizes it to499ticks, losing1/240000s',
            'ffprobe with edits applied shortens final AAC reported packet duration in both configurations; original STTS and complete PCM remain full length',
            '240000 experiment is not evidence of current camera support, generic solution, or live encoder configuration binding',
            'no B-frame source present; no B reorder, minute buffer, camera access, storage/DMA, voice/shutter or real-time execution proof',
            'strict selected-packet integrity passes; continuous audio coverage remains rejected because boundary AAC is excluded'])
    (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status=report['status'],cases=len(cases),default_exact_gate='reject',
        caller_240000_exact_gate='reject',continuous_audio_coverage='reject',output=str(out))))

if __name__=='__main__':main()
