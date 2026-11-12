#!/usr/bin/env python3
"""Offline original ARM event3 at the unmodified 60000 ms limit.

Archived 65s camera recording, modeled RAM files/OS/naming only. No device,
callback installation, live ring, physical SD writes or deployable prerecord.
"""
from __future__ import annotations
import argparse
import ast
from collections import Counter
from fractions import Fraction
import json
from pathlib import Path
import time
import traceback
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn.arm_const import UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3, UC_ARM_REG_SP, UC_ARM_REG_PC, UC_ARM_REG_LR
import audit_prerecord_minute_native as minute
import audit_prerecord_event3_rollover as event

n, f, s, g = minute.n, minute.f, minute.s, minute.g
ROOT = minute.ROOT
LIMIT_MS = 60000
BOUNDARY_FRAME = 1800
END_FRAME = 1920
FROZEN = {**minute.FROZEN,
    'audit_prerecord_minute_native.py': 'e2660f136fa1e9eccb9c2e866c5bb480a96dd4b3b3635c84c8abd01c910fbe87',
    'audit_prerecord_event3_rollover.py': '9679be4f7017200c1247b5a8913ff267cebc33a1b20b006c0722195e9530b570'}
RAM_FILE_CAPACITY = minute.SOURCE.stat().st_size + 1024 * 1024
_event_tree = ast.parse(Path(event.__file__).read_text())
HOOKS = minute.HOOKS | event.WATCH | frozenset(node.value for node in ast.walk(_event_tree)
    if isinstance(node, ast.Constant) and isinstance(node.value, int) and 0x10000000 <= node.value <= 0xffffffff)


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


class Machine(event.EventMachine):
    def __init__(self, image, filtered=True):
        self.filtered = filtered
        super().__init__(image)

    def hook(self, uc, address, size, user):
        if self.filtered and address not in HOOKS and not 0x11000000 <= address < 0x14000000:
            return
        if address == n.SEEK:
            # The frozen small-fixture RAM model caps seeks at 256 MiB, below
            # this archive's first segment. Keep its AAPCS offset, failure
            # injection and logging semantics; enlarge only host file capacity.
            args = [uc.reg_read(r) for r in (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2, UC_ARM_REG_R3)]
            require(args[0] == s.STREAM, 'seek stream mismatch')
            origin = self.get(uc.reg_read(UC_ARM_REG_SP))
            offset = (args[3] << 32) | args[2]
            if offset & (1 << 63):
                offset -= 1 << 64
            require(origin in (0, 1, 2), 'seek origin invalid')
            base = 0 if origin == 0 else self.position if origin == 1 else len(self.output)
            target = base + offset
            require(0 <= target < RAM_FILE_CAPACITY, f'RAM seek capacity exceeded: {target}')
            status = -12 if self.seek_count == self.seek_fail_at else 0
            self.seek_count += 1
            self.stream_events.append(dict(kind='seek', old_position=self.position,
                offset=offset, origin=origin, target=target, status=status))
            if status == 0:
                self.position = target
            uc.reg_write(UC_ARM_REG_R0, status & 0xffffffff)
            uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))
            return
        super().hook(uc, address, size, user)


def init(image, filtered=True):
    m = Machine(image, filtered)
    track, mem = m.setup_index()
    for i, value in enumerate([2, 0, 0, s.MOVIE, 2 * 0x709, 2]):
        m.put(f.CFG + i * 4, value)
    m.uc.mem_write(f.NAME, b'minute-first.mp4\0' + bytes(48))
    require(m.call(0xa03e3c48, f.CFG) == 0, 'factory init failed')
    require(m.call(0xa03e3f00, f.NAME, s.RESULT) == 0 and m.get(s.RESULT) == s.MOVIE, 'movie allocation failed')
    require(m.call(0xa0440cd4, s.MOVIE, s.CONFIG) == 0, 'movie config failed')
    require(m.call(0xa03feccc, f.MUXCFG) == 0, 'mux config failed')
    for off, value in [(0, s.STREAM), (4, mem), (8, 2)]:
        m.put(f.MUXCFG + off, value)
    require(m.call(0xa03fed44, f.MUXCFG, s.RESULT) == 0, 'mux allocation failed')
    mux = m.get(s.RESULT)
    m.put(mux + 4, s.MOVIE)
    m.put(mux + 0x10, LIMIT_MS)
    m.phase = 'first_segment'
    require(m.call(0xa03fe468, mux) == 0, 'first Open failed')
    return m, track, mux


def process(m, movie, mux, packet):
    track = movie + 0x78
    if packet['stream'] == 0:
        return m.call(0xa042d0f8, movie, track, movie + 0x350, mux + 0x58,
                      s.STREAM, LIMIT_MS, 0xffffffff, 0xffffffff)
    return m.call(0xa043173c, movie, track + 0x90, mux + 0x58, s.STREAM,
                  0, LIMIT_MS, 0xffffffff, 0xffffffff)


def feed(m, movie, mux, packets, sps, pps, report, progress=True):
    statuses = []
    report.setdefault('submissions', []).append(statuses)
    started = time.monotonic()
    for ordinal, p in enumerate(packets):
        event.load_packet(m, p, sps, pps)
        status = process(m, movie, mux, p)
        statuses.append(dict(stream=p['stream'],source_index=p['index'],status=status))
        require(status == 0, f"unexpected process status {status}: stream={p['stream']}, index={p['index']}")
        if progress and (ordinal + 1) % 250 == 0:
            print(json.dumps(dict(phase=m.phase, packets_processed=ordinal+1, total=len(packets),
                                 seconds=round(time.monotonic()-started, 2), media_bytes=len(m.output))), flush=True)


def fifo(m, track):
    return dict(cursor=m.get(s.life.VIRTUAL+0x90,8),
                fifo=bytes(m.uc.mem_read(s.life.VIRTUAL,0xd0)).hex(),
                descriptor=bytes(m.uc.mem_read(s.life.QUEUE,32)).hex(),
                dts=[m.get(track+off,8) for off in (0x20,0xb0)])


def configure_event(m,mux):
    for address,value in [(0xa13c2a44,mux),(0xa13c1768,s.MOVIE),(0xa13c2a54,s.STREAM),
            (0xa13c29f4,1),(0xa13c1774,event.NAME_CALLBACK),(0xa13c2a50,0),
            (0xa13c2a40,2),(0xa13c2a5c,0),(0xa06d42c8,LIMIT_MS)]:
        m.put(address,value)
    m.put(0xa06d42c0,0,8)
    m.put(event.PIPE,mux)
    m.put(event.PIPE+0x10,1,1)
    m.put(event.PIPE+0x14,0xa01f569c)
    m.put(event.PIPE+0x60,LIMIT_MS)
    m.put(event.PIPE+0x68,0xffffffffffffffff,8)
    m.put(event.PIPE+0x72,2,1)


def comparison(actual, expected, streams, origin):
    # Preserve every submitted packet; no dropping crossing/trailing AAC to make
    # this gate pass. Match identity by per-stream source order and SHA.
    rows=[]; missing=[]; unexpected=[]
    for st in (0,1):
        old=[p for p in expected if p['stream']==st]
        new=[p for p in actual if p['stream']==st]
        rate=30000 if st==0 else 48000
        tb=Fraction(streams[st]['time_base'])
        for a,b in zip(old,new):
            rows.append(dict(stream=st,source_index=a['index'],source_sha256=a['sha256'],
                output_sha256=b['sha256'],same_payload=a['sha256']==b['sha256'],
                pts_error=g.rational(b['pts']*tb-(Fraction(a['pts'],rate)-origin)),
                dts_error=g.rational(b['dts']*tb-(Fraction(a['dts'],rate)-origin)),
                duration_error=g.rational(b['duration']*tb-Fraction(a['duration'],rate))))
        missing += [g.public_packet(p) for p in old[len(new):]]
        unexpected += [g.public_packet(p) for p in new[len(old):]]
    payload=all(r['same_payload'] for r in rows)
    timing=all(r[k]['numerator']==0 for r in rows for k in ('pts_error','dts_error','duration_error'))
    return dict(status='pass' if payload and timing and not missing and not unexpected else 'reject',
        same_retained_payload=payload, exact_retained_timing=timing,
        missing_submitted_packets=missing, unexpected_output_packets=unexpected, compared_packets=rows)


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output',type=Path,required=True)
    args=ap.parse_args()
    out=args.output
    out.mkdir(parents=True,exist_ok=False)
    started=time.monotonic()
    report=dict(schema=1,status='running',offline_only=True,limit_ms=LIMIT_MS,
        ram_file_model=dict(capacity_bytes=RAM_FILE_CAPACITY,
            previous_capacity_bytes=0x10000000,
            change='Host RAM file seek capacity only; original ARM instructions unchanged'),
        source=dict(path=str(minute.SOURCE.relative_to(ROOT)),sha256=minute.SOURCE_SHA),
        script_sha256=n.sha(Path(__file__).read_bytes()), frozen_harness_sha256=FROZEN,
        scope='Original ARM Close/New/Copy/Rel/Reset/Open at 60000ms; archived packets with RAM file/name/OS models',
        limitations=['No live camera/encoder/DMA/callback installation/SD writes or real-time scheduler.',
            'No one-minute live ring/spool or voice/shutter integration.',
            'Single constructed FIFO reused by caller, not simultaneous producer queues.',
            'Only archived 1080p29.97 I/P video and 48kHz stereo AAC from one recording.'])
    m=None
    try:
        for name,digest in FROZEN.items():
            require(n.sha((ROOT/'scripts'/name).read_bytes())==digest,f'harness changed: {name}')
        image=s.life.arm.IMAGE.read_bytes()
        require(n.sha(image)==s.life.arm.DIGEST,'firmware hash mismatch')
        report['firmware_sha256']=s.life.arm.DIGEST
        raw=minute.SOURCE.read_bytes()
        require(n.sha(raw)==minute.SOURCE_SHA,'archive hash mismatch')
        source=g.probe(minute.SOURCE)
        packets=g.packets(source,raw)
        sps,pps=g.avcc(g.extradata(source['streams'][0]['extradata']))
        require([st['time_base'] for st in source['streams']]==['1/30000','1/48000'],'source clocks changed')
        # Differential check the complete EventMachine ancestry before scaling;
        # original ARM instructions execute in both modes.
        calibration=g.select_window(packets,Fraction(0),Fraction(8008,30000))
        summaries=[]
        for filtered in (False,True):
            test,_,test_mux=init(image,filtered)
            feed(test,s.MOVIE,test_mux,calibration,sps,pps,{},False)
            require(test.call(0xa03fe300,test_mux,0)==0,'calibration Close failed')
            summaries.append(dict(**minute.summarize(test),transitions=test.transitions,
                                  external=test.external,closed_files=[n.sha(v) for v in test.closed_files]))
        require(summaries[0]==summaries[1],'filtered hook differential mismatch')
        report['hook_differential']=dict(video_frames=8,packets=len(calibration),
            same_output_and_all_inherited_events=True,output_sha256=summaries[0]['output_sha256'],
            filtered_hook_addresses=[hex(x) for x in sorted(HOOKS)])
        print(json.dumps(dict(phase='hook_differential',status='pass')),flush=True)
        boundary=next(p for p in packets if p['stream']==0 and p['index']==BOUNDARY_FRAME)
        origin=Fraction(boundary['pts'],30000)
        end=Fraction(END_FRAME*1001,30000)
        require(boundary['key'] and origin==Fraction(3003,50),'expected 60.06s key boundary missing')
        selected=g.select_window(packets,Fraction(0),end)
        require(all(Fraction(p['pts'],30000 if p['stream']==0 else 48000)<end
            for p in selected),'selected packet exceeds endpoint')
        omitted=[g.public_packet(p) for p in packets
            if Fraction(p['pts'],30000 if p['stream']==0 else 48000)<end
            and (p['stream'],p['index']) not in {(x['stream'],x['index']) for x in selected}]
        require(not omitted,'64.064s endpoint excludes crossing packet')
        first=[p for p in selected if Fraction(p['pts'],30000 if p['stream']==0 else 48000)<origin]
        second=[p for p in selected if Fraction(p['pts'],30000 if p['stream']==0 else 48000)>=origin]
        report.update(boundary_source=g.public_packet(boundary),boundary_seconds=g.rational(origin),
                      stop_seconds=g.rational(end),submitted_counts=[dict(Counter(p['stream'] for p in ps)) for ps in (first,second)],
                      omitted_crossing_packets=omitted)
        m,track,mux=init(image)
        feed(m,s.MOVIE,mux,first,sps,pps,report)
        event.load_packet(m,boundary,sps,pps)
        report['before']=fifo(m,track)
        m.phase='boundary_limit'
        status=process(m,s.MOVIE,mux,boundary)
        report['boundary_status']=status
        require(status==3,f'boundary returned {status}, expected 3')
        report['at_limit']=fifo(m,track)
        require(report['at_limit']['cursor']==report['before']['cursor'],'limit consumed boundary')
        configure_event(m,mux)
        m.phase='original_event3'
        report['event_status']=m.call(0xa0443720,event.PIPE,mux,3)
        require(report['event_status']==0,'original event3 failed')
        new_movie=m.get(mux+4)
        report['after']=fifo(m,new_movie+0x78)
        report['after'].update(movie=hex(new_movie),split_counter=m.get(0xa13c29f4),
            pipe_state=m.get(event.PIPE+0x72,1),format_open=m.get(mux+0xf80,1))
        require(new_movie==s.MOVIE+0x708,'factory did not rotate to second movie')
        require(all(report['before'][key]==report['after'][key] for key in ('cursor','fifo','descriptor')),
            'event3 changed retained descriptor/FIFO/cursor')
        require(report['after']['split_counter']==2 and report['after']['format_open']==1,'reset/open state wrong')
        m.phase='retained_first_sample'
        report['retained_boundary_status']=process(m,new_movie,mux,boundary)
        require(report['retained_boundary_status']==0,'retained key rejected')
        report['retained_boundary_cursor']=m.get(s.life.VIRTUAL+0x90,8)
        require(report['retained_boundary_cursor']==report['before']['cursor']+1,'retained frame not consumed once')
        m.phase='second_segment'
        feed(m,new_movie,mux,[p for p in second if not (p['stream']==0 and p['index']==BOUNDARY_FRAME)],sps,pps,report)
        m.phase='final_close'
        report['final_close_status']=m.call(0xa03fe300,mux,0)
        require(report['final_close_status']==0 and len(m.closed_files)==1,'final Close failed')
        report['segments']=[]
        source_video=g.frame_hashes(minute.SOURCE,END_FRAME)
        for number,(data,submitted,segment_origin) in enumerate(zip(
                [m.closed_files[0],bytes(m.output)],[first,second],[Fraction(0),origin]),1):
            path=out/f'minute-segment-{number}.mp4'
            path.write_bytes(data)
            probe=g.probe(path)
            actual=g.packets(probe,data)
            strict=comparison(actual,submitted,probe['streams'],segment_origin)
            decoded=g.frame_hashes(path)
            expected=source_video[:BOUNDARY_FRAME] if number==1 else source_video[BOUNDARY_FRAME:END_FRAME]
            decoded_audio=g.pcm(path)
            audio=[p for p in submitted if p['stream']==1]
            reference=out/f'segment-{number}-submitted-audio.aac'
            reference.write_bytes(b''.join(g.adts(p['data']) for p in audio))
            expected_audio=g.pcm(reference,True)
            report['segments'].append(dict(file=path.name,bytes=len(data),sha256=n.sha(data),
                packets=[g.public_packet(p) for p in actual],packet_counts=dict(Counter(p['stream'] for p in actual)),
                container=g.container_timeline(data),strict_packet_time_gate=strict,
                video_frames=len(decoded),video_frame_md5=decoded,video_matches_archived_window=decoded==expected,
                audio_pcm_bytes=len(decoded_audio),audio_pcm_sha256=n.sha(decoded_audio),
                submitted_audio_pcm_bytes=len(expected_audio),submitted_audio_pcm_sha256=n.sha(expected_audio),
                audio_matches_all_submitted_packets=decoded_audio==expected_audio))
            require(decoded==expected,f'segment {number} video decode mismatch')
        cs=Cs(CS_ARCH_ARM,CS_MODE_ARM)
        convention={0xa043d320:('mov','sl, r0'),0xa043d32c:('mov','r1, r4'),
            0xa043d330:('mov','r2, sl'),0xa043d334:('mov','r0, r6'),0xa043d338:('bl','#0xa0443720')}
        report['original_event_calling_convention']=[]
        for address,expected in convention.items():
            ins=next(cs.disasm(image[address-0xa0100000:address-0xa0100000+4],address))
            require((ins.mnemonic,ins.op_str)==expected,'event3 calling convention changed')
            report['original_event_calling_convention'].append(dict(site=hex(address),instruction=ins.mnemonic+' '+ins.op_str,bytes=ins.bytes.hex()))
        report['status']='offline_minute_event3_executed'
        report['publication_gate']='pass' if all(r['strict_packet_time_gate']['status']=='pass'
            and r['audio_matches_all_submitted_packets'] for r in report['segments']) else 'reject'
    except Exception as error:
        report['status']='execution_failed'
        report['publication_gate']='reject'
        report['error']=str(error)
        report['traceback']=traceback.format_exc()
        if m is not None:
            for number,data in enumerate(m.closed_files+[bytes(m.output)],1):
                (out/f'partial-segment-{number}.mp4').write_bytes(data)
    finally:
        if m is not None:
            report.update(original_calls=m.transitions,modeled_external_events=m.external,
                diagnostics=m.logs,actual_native_calls=dict(Counter(c['entry'] for c in m.native_calls)),
                modeled_file_writes=len(m.writes),mock_index_events=m.index_events)
        report['elapsed_seconds']=time.monotonic()-started
        (out/'audit.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(dict(output=str(out),status=report['status'],publication_gate=report['publication_gate'],
            error=report.get('error'),elapsed_seconds=report['elapsed_seconds'])),flush=True)
    return 1 if report['status']=='execution_failed' else 0

if __name__=='__main__':
    raise SystemExit(main())
